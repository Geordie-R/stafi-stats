#!/bin/bash

create_dir="$HOME/stafi-stats"
config_file="$create_dir/config.ini"
mem_alert=false
cpu_alert=false
disk_alert=false
peer_alert=false
block_diff_alert=false
version_alert=false
stafi_rpc_address="https://rpc.stafi.io"

#----------------------------------------------------------------------------------------------------#
# NOTE: PARAMETERS ARE CONTAINED IN CONFIG.INI                                                       #
#----------------------------------------------------------------------------------------------------#

#----------------------------------------------------------------------------------------------------#
# GLOBAL VALUE IS USED AS A GLOBAL VARIABLE TO RETURN THE RESULT                                     #
#----------------------------------------------------------------------------------------------------#

function get_config_value(){
  global_value=$(grep -v '^#' "$config_file" | grep "^$1=" | awk -F '=' '{print $2}')
  if [ -z "$global_value" ]
  then
    return 1
  else
    return 0
  fi
}

function ParseVersionNumber(){
  vers=$(echo $1 | sed -n 1'p' | tr '-' '\n' | head -n 1)
  echo  "$vers"
}

function IsFirstGreaterThanSecond(){
if awk 'BEGIN{exit ARGV[2]>ARGV[1]}' "$1" "$2"
then
  echo "true"
else
  echo "false"
fi


}


#----------------------------------------------------------------------------------------------------#
# FILL PARAMETERS BELOW RETRIEVED FROM CONFIG.INI                                                    #
#----------------------------------------------------------------------------------------------------#


if get_config_value node_name
then
  node_name="$global_value"
fi

if get_config_value disk_max_percent
then
  disk_max_percent="$global_value"
fi

if get_config_value block_diff_threshold
then
  block_diff_threshold="$global_value"
fi

if get_config_value low_no_of_peers
then
  low_no_of_peers="$global_value"
fi

if get_config_value cpu_max_percent
then
  cpu_max_percent="$global_value"
fi

if get_config_value memory_max_percent
then
  memory_max_percent="$global_value"
fi

if get_config_value telegram_bot_token
then
  telegram_bot_token="$global_value"
fi

if get_config_value telegram_chat_id
then
  telegram_chat_id="$global_value"
fi

#----------------------------------------------------------------------------------------------------#
# CHECK RAM                                                                                          #
#----------------------------------------------------------------------------------------------------#

memory_used_percent="$(free | grep Mem | awk '{print $3/$2 * 100.0}' | awk -F '.' '{print $1}')"
memory_max_percent="$(echo $memory_max_percent | tr -d '%' )"


 if (( memory_used_percent >= memory_max_percent ))
  then
    mem_msg="❌ Memory is at $memory_used_percent percent used"
    mem_alert=true
else
mem_msg="Memory is fine at $memory_used_percent percent used percent used"
  fi

#----------------------------------------------------------------------------------------------------#
# CHECK DISK SPACE                                                                                   #
#----------------------------------------------------------------------------------------------------#
disk_used_percent="$(df -h | grep -w '/' | awk '{print $5}' | tr -d '%')"
disk_max_percent="$(echo $disk_max_percent | tr -d '%' )"

 if (( disk_used_percent >= disk_max_percent ))
  then
    disk_msg="❌ Disk space is at $disk_used_percent percent used"
    disk_alert=true
else
disk_msg="Disk space is at $disk_used_percent percent used which is OK"
  fi

echo "$disk_msg"


#----------------------------------------------------------------------------------------------------#
# CHECK CPU                                                                                          #
#----------------------------------------------------------------------------------------------------#

cpu_utilization=$((100 - $(vmstat 2 2 | tail -1 | awk '{print $15}' | sed 's/%//')))

if [[ $cpu_utilization -gt $cpu_max_percent ]]; then
cpu_msg="❌ CPU is at $cpu_utilization percent used"
echo "$cpu_msg"
cpu_alert=true
else
cpu_msg="CPU is $cpu_utilization which is ok"
fi

echo "$cpu_msg"

#----------------------------------------------------------------------------------------------------#
# PEER COUNT / INFO                                                                                  #
#----------------------------------------------------------------------------------------------------#

system_health=$(curl -sS -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_health", "params":[]}' http://localhost:9933)
peers=$(echo $system_health | jq -r '.result.peers')
isSyncing=$(echo $system_health | jq -r '.result.isSyncing')

if [[ $peers -lt $low_no_of_peers ]]; then
peer_msg="❌ LOW NUMBER OF PEERS: $peers - BUSY SYNCING: $isSyncing"
peer_alert=true
else
peer_msg="Peers is ok: $peers - Busy syncing: $isSyncing"
fi
echo "$peer_msg"

#----------------------------------------------------------------------------------------------------#
# STAFI BLOCK HEIGHT VS YOUR BLOCK HEIGHT                                                            #
#----------------------------------------------------------------------------------------------------#

block_height=$(curl -s 127.0.0.1:9615/metrics | grep "substrate_block_height{status=\"best\"" | awk '{print $2}')
stafi_block_height_hex=$(curl -sH "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "chain_getHeader", "params":[]}' http://localhost:9933 | jq -r '.result.number')
#echo "Stafi Block Height Hex:$stafi_block_height_hex"
stafi_block_height=$(($stafi_block_height_hex))
echo "Stafi Block Height: $stafi_block_height - Your Block Height: $block_height"


block_diff=$(($stafi_block_height - $block_height))

if [[ $block_diff -gt $block_diff_threshold ]]; then
block_diff_msg="❌ Block difference of $block_diff as STAFI: $stafi_block_height AND YOURS IS: $block_height
"
block_diff_alert=true
else
block_diff_msg="Block Difference is within chosen limits"
fi
echo "$block_diff_msg"

#----------------------------------------------------------------------------------------------------#
# STAFI SYSTEM VERSION VS YOUR SYSTEM VERSION                                                        #
#----------------------------------------------------------------------------------------------------#

system_version=$(curl -sH "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_version", "params":[]}' http://localhost:9933 | jq -r '.result')
stafi_system_version=$(curl -sH "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_version", "params":[]}' $stafi_rpc_address | jq -r '.result')
stafi_system_vers_numberonly=$(ParseVersionNumber "$stafi_system_version")
system_version_numberonly=$(ParseVersionNumber "$system_version")

echo "Stafi Version: $stafi_system_version -  Your System Version:$system_version"
alert=false

version_greater=$(IsFirstGreaterThanSecond "$stafi_system_vers_numberonly" "$system_version_numberonly")


if [[ "$system_version" == "$stafi_system_version" ]]; then
  version_msg="Same Version"

elif [[ "$stafi_system_version" == "" ]]; then
version_msg="Stafi version unknown"

elif [[ "$version_greater" == "true" ]]; then
version_msg="❌ Wrong Version: stafi is $stafi_system_version and yours is $system_version"
version_alert=true

fi

msg=""
if $mem_alert || $cpu_alert || $block_diff_alert || $disk_alert || $peer_alert || $version_alert
then
  alert=true
  if $mem_alert
  then
  msg="$msg
  $mem_msg"
  fi

  if $cpu_alert
  then
  msg="$msg
  $cpu_msg"
  fi

  if $disk_alert
  then
  msg="$msg
   $disk_msg"
  fi

  if $peer_alert
  then
  msg="$msg
  $peer_msg"
  fi

 if $block_diff_alert
  then
  msg="$msg
  $block_diff_msg"
  fi

  if $version_alert
  then
  msg="$msg
  $version_msg"
  fi

fi

msg="ALERTS FOUND ON $node_name ($HOSTNAME)!
$msg"

#----------------------------------------------------------------------------------------------------#
# SEND ALERT NOTIFICATIONS TO TELEGRAM BOT (IF THERE'S SOMETHING TO SEND)                            #
#----------------------------------------------------------------------------------------------------#

  if $alert
  then

echo "Sending Telegram: $msg"

    curl -s -X POST https://api.telegram.org/bot$telegram_bot_token/sendMessage -d chat_id=$telegram_chat_id -d text="$msg" &>/dev/null
else
echo "No alerts needed"
  fi
