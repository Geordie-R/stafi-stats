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

In order to message you on telegram, we will create a telegram bot which you control the bot token for.

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

Visit my dedicated telegram bot here [**@StafiChatIDBot**](https://t.me/StafiChatIDBot) for collecting your Chat ID that you will be asked for when you run installstats.sh in Step 3 that follows.

## Step 3: Download & Setup The Scripts Required For Stafi Stats

<br>

```
cd ~
mkdir stafi-stats
cd stafi-stats
wget https://raw.githubusercontent.com/Geordie-R/stafi-stats/master/installstats.sh
sudo chmod +x installstats.sh
./installstats.sh

```

Now run this

```
wget https://raw.githubusercontent.com/Geordie-R/stafi-stats/master/stats.sh
sudo chmod +x stats.sh
chown $USER:$USER stats.sh
```
<br>

## Step 4: Test Telegram

Test that your telegram bot is setup correctly by running the following

```
wget https://raw.githubusercontent.com/Geordie-R/stafi-stats/master/telegramtest.sh
sudo chmod +x telegramtest.sh
sudo ./telegramtest.sh
```

## Step 5: Test Alerts

To test the alerts system why not modify the config and set the alerts metrics to say 5 for the disk or cpu to almost guarantee it will alert you.  To do so

```
sudo nano ~/stafi-stats/config.ini
```

Once you have made the changes press Ctrl + X and then press Y to save.

Now just wait for the next 5 minute cycle.  You should be alerted.

Thats it! Now amend the config back to reasonable values and you're good to go.
