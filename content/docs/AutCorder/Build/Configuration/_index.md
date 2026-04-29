---
weight: 15
title: "Step 5: Configuration"
---

# Step 5: Configuring the device

After a while, a new USB storage device should appear on the computer, bearing the same label as the formatted SD card (if not, make sure you have a usb data cable, replug the device, and try pressing the shutter button to manually wake it up). On it you will find two empty folders `/new` and `/old` and a file, `config.json` The config file contains everything for setting up the device. To ease trawling the configuration file, you can open the `AutCorder-Arduino/extras/jsonEditor/index.html` file in a browser. This page allows for (optionally) opening an existing `config.json` file, changing its settings, and saving it back to the downloads folder.

After finishing configuration, click the save button to download the `config.json` file. From the downloads folder, copy it over to the AutCorder storage device, overwriting the original file. Make sure the file has the exact name `config.json`. After this the device can be ejected (which might take a few seconds), and the AutCorder is ready for use.

Here follows an explanation of each of the configuration options:
## Device connectivity
The AutCorder can function in a few distinct ways with regards to wireless connectivity: 

`offline` - The AutCorder is configured as a completely offline device, functioning just as a simple digital camera, from which files can be pulled using the USB connection. While this mode may be rather impractical, it makes for a very long battery life (maybe upwards of two months), and requires no additional setup.

`standalone` - The AutCorder is configured as a standalone wireless device. Using its configuration (see below), it will connect to WiFi, transcribe any recordings and upload new pictures and recordings to a Telegram chat or a Discord channel. Using this setup is somewhat involved, but enables integrating the AutCorder with existing daily (online) practices. Battery life is reduced to a few weeks.

`companion` - The companion connectivity mode is still in development, and not currently usable. In the future, this mode will allow the AutCorder to connect to a smartphone periodically via Bluetooth Low Energy, to offload pictures and recordings. This will allow recordings to be collected on a device where they can be viewed and annotated on an ongoing basis, without any file-management kerfuffle. This too is going to reduce battery life.
## Wifi networks
If in standalone mode, the AutCorder will periodically attempt to connect to WiFi to transcribe recordings and send pictures and recordings to Telegram chats or Discord channels as configured below. Up to 5 different WiFi networks can be specified for the AutCorder to attempt to connect to using the networks SSID and Password. Note that only regular personal wifi networks (using PSK) are supported.
## Wifi Connection Timeout
When attempting to connect to a WiFi network, it may take a little while to discover the network, if it is weak or in a congested area. This option sets how many seconds the AutCorder will try to connect to wifi before giving up. 
While larger waiting times may result in better connectivity, it will also result in higher average power consumption when located somewhere without access to a configured wifi network.
## Connect telegram over WiFi
If enabled, the AutCorder will connect to the Telegram bot api to upload pictures and recordings in one or more personal or group chats. To use this feature you will need access to a Telegram bot token, and the IDs of the chats you want to send pictures and recordings to. Follow [this guide](https://core.telegram.org/bots#how-do-i-create-a-bot ) to set up a Telegram bot and obtain a bot token. Once created, you will first need to message the bot or manually add it to a group chat to allow it to send you messages. To obtain the ID of a personal or group chat, use the IDBot bot [@myidbot](https://t.me/myidbot). 
With this, set the options:
- `Enabled` - whether to enable uploading to Telegram or not.
- `Chat IDs` - A list of chat IDs pictures should be sent to. If more than one ID is provided, the AutCorder will send each picture or recording to each chat sequentially.
- `Token` - The secret bot token you have obtained. 
## Connect to a discord server over WiFi
If enabled, the AutCorder will connect to Discord using a webhook token to upload pictures and recordings in a specified server channel. To use this feature with a server, you need to have administrator access to create webhooks on a given channel. Follow [this guide]( https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) to set up a webhook.
On creating the webhook you'll get a URL in the following format
`https://discord.com/api/webhooks/[id]/[token]` with `[id]` and `[token]` replaced by a random sequence of numbers and alphanumeric characters respectively. The `[id]` and `[token]` values are used for the options below:
- `Enabled`  - whether uploading to Discord is enabled
- `ID` - where you will fill in the `[id]` part of the webhook url.
- `Token` - where you will fill in the `[token]` part of the webhook url.
- `Name` is whatever name the webhook bot will be posting as.

## Transcribe audio recordings
If connected to WiFi, the AutCorder supports connecting to a Whisper (or whisper-like) api, to upload audio recordings for transcription, which will then be attached alongside the recording when uploading to Telegram or Discord. Either the official openai whisper API or a self-hosted [Speaches instance](https://speaches.ai/) can be used.

- `Enabled` - Whether this service is enabled or disabled.
- `Server name` - The domain name (without protocol) for the API,  e.g. `api.openai.com`
- `Server path` - whatever comes after the domain name for pointing at the transcription api, e.g `/v1/audio/transcriptions`
- `Language` - If you know what language will be (exclusively) spoken, you can increase the speed of transcription by selecting it in the Language dropdown. If unsure, leave it blank.
- `Token` - The API Key to be used for HTTP bearer authentication.

## Recording upload rules
The Recording upload rules determine, if Telegram or Discord connectivity is enabled, when and how often the device should try to connect to WiFi and upload pictures and recordings if any are waiting to be uploaded. 

The `Immediate delay` sets how long the device should wait in minutes to try to upload just after a recording has been made or picture taken. With the default value of 1 minute, the device will wait a minute after a picture or recording has finished saving to start attempting an upload. If any new recordings are made in the mean time, this timer is reset.

The `Retry delay` sets the interval between reattempting an upload. With the default value of 30 minutes, if no wifi is available or the upload fails, the device will sleep for half an hour before waking up to try again. Taking a picture or recording in the mean time will re-enable the immediate delay.

`Allow uploading from` and `Allow uploading until` sets a window throughout the day which upload attempts should be restricted to. If you don't want to be disturbed during your morning or working day, the window can e.g. be set from `hour` 16, `minute` 30 until `hour` 20 `minute` 30. Valid input hours range 0-23 and valid input minutes range 0-59. Having the window span across midnight is supported.

The option `Keep recordings after upload` sets whether pictures and recordings are deleted or kept on the device after successfully being uploaded. If the option is set to false, recordings are deleted immediately after (do note that these files may be recoverable with data recovery tools.). If the option is set to true, the files are instead moved from the /new folder to the /old folder.
## Battery
This options sets, if Telegram or Discord connectivity is enabled, when and how often the AutCorder should send out a warning if the device is running low on battery.

The `Battery Low Warning Delay` sets the minimum amount of time waited between sending warnings (this may be significantly longer). The `Battery Low at Percentage` sets how low the battery capacity should be before warnings start being sent out.
## Picture orientation
The AutCorder board does not know by itself which direction is up (and it's usually not the same direction the camera sensor thinks it is by default). So that pictures are viewed in the correct orientation more often than not, a custom Exif orientation flag is added to the image header when it's saved. This option is the value of the flag set. Usually the default value of 3 should work for most PebbleCam and SquareCam and camera sensor combinations. If this is not correct, you can set the value to 1, take a picture and follow the illustration [here]( https://jdhao.github.io/2019/07/31/image_rotation_exif_info/#exif-orientation-flag) to chose the correct value.
## Audio limiter factor
This option enables an experimental audio limiter, some simple audio processing to make the recordings easier to listen to. In practice this may have varying usefulness. Reasonable limiter values range from 0 to 1.5. To disable it (if e.g. you experience an odd scratchiness of the audio), set the value to 0.
## Feedback
The `Feedback` options enables customization of what feedback is provided on certain events using the vibration motor or piezo buzzer connected to the FB pins. 
The feedback type options sets whether this AutCorder has a vibration motor (for `vibration` feedback) or a piezo buzzer (for `melody` feedback) connected.

All the following options set the path for vibration or melody files to play, once a given event occurs. E.g. to play the vibration file `"photo.vib"` (placed in the root of the device storage), Feedback type should be set to vibration and Photo Taken should be set to `/photo.vib`  
Custom vibration and melody files can be edited using the `melodyComposer` and `vibrationComposer` html tools included in the AutCorder-Arduino repository.

Event descriptions:
- `Photo Taken` plays just after a photo has been taken, while it is being saved to disk.
- `Audio recorded` plays after an audio recording has completed and is being saved to disk.
- `Upload done` If Telegram or Discord uploading has been enabled for the device, this plays when a picture or recording has been successfully been uploaded to the service.
- `General activity` This plays in situations where the AutCorder has been awake for a while, like if connected via USB as a storage device.

## LED feedback
The `LED Feedback` options are for setting if and how the camera flash should blink on certain events. These options mirror the other Feedback options exactly and use the same vibration file format. No matter how these settings are configured, the flash LED will always light up while taking a picture or while recording audio.
## Utility function
The AutCorder PCB has an extra set of pins (marked as `UTIL`) for custom functionality. At the moment this functionality is limited to functioning as a binary input (as e.g. provided by a slide switch between the thee pins) which prepends text to the file names of pictures and recordings, depending on whether the input is held high or low (connected to power or ground).
## Delay before engaging secondary function
By default the AutCorder takes a picture on a short press of the shutter button, and starts recording audio when the button is held down. Whether a press is short or held is determined by whether it has been held for longer than this value in milliseconds. If you accidentally make audio recordings when meaning to take pictures, this value can be incremented. 
## Collect statistics
This option sets whether the AutCorder should store how many pictures have been taken and how many audio recordings have been made (and for how long). The data is stored in the `stats.bin` file on the device.