# stafi-stats beta
Stafi Stats is a script to produce node stats for the Stafi protocol. Every 5 minutes your node will run stats.sh script which will collect metrics and message you when there is something that needs attention.
## Features
* Memory Used Percentage
* Disk Space Used Percentage
* CPU Utilization Percentage
* Node Peer Count and isSyncing Check
* Stafi Block Height VS Your Block Height
* Stafi System Version VS Your System Version

## Step 1: Create Telegram Bot Using Botfather

#### The following steps describe how to create a new bot:

* Contact [**@BotFather**](https://telegram.me/BotFather) in your Telegram messenger.
* To get a bot token, send BotFather a message that says **`/newbot`**.
* When asked for a name for your new bot choose something that ends with the word bot, so for example YOUR_NODE_NAMEbot.
* If your chosen name is available, BotFather will then send you a token.
* Save this token as you will be asked for it once you execute the installstats.sh script.

Once your bot is created, you can set a custom name, profile photo and description for it. The description is basically a message that explains what the bot can do.

#### To set the Bot name in BotFather do the following:

* Send **`/setname`** to BotFather.
* Select the bot which you want to change.
* Send the new name to BotFather.

#### To set a Profile photo for your bot in BotFather do the following:

* Send **`/setuserpic`** to BotFather.
* Select the bot that you want the profile photo changed on.
* Send the photo to BotFather.

#### To set Description for your bot in BotFather do the following:

* Send **`/setdescription`** to BotFather.
* Select the bot for which you are writing a description.
* Change the description and send it to BotFather.

For a full list of command type /help

## Step 2: Obtain Your Chat Identification Number

Visit my dedicated telegram bot here [**@StafiChatIDBot**](https://t.me/StafiChatIDBot) for collecting your Chat ID that you will be asked for when you run installstats.sh in Step X.

## Step 3: Download & Setup The Scripts Required For Stafi Stats

<br>

```
cd ~
mkdir stafi-stats
cd stafi-stats
sudo wget https://raw.githubusercontent.com/Geordie-R/stafi-stats/master/installstats.sh
sudo chmod +x installstats.sh
sudo ./installstats.sh

```
```
sudo wget https://raw.githubusercontent.com/Geordie-R/stafi-stats/master/stats.sh
sudo chmod +x stats.sh
```
<br>
