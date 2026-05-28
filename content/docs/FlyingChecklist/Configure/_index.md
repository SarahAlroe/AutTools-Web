---
weight: 2
title: Configuring your checklist
---
# Configuring your checklist
The checklist is configured entirely through `.json` files on the internal storage of the device. Before the device can be used, it must be configured for either transcribing through wifi or the AutTools Connector App. Besides this, the checklist is fully operational using the default configuration. For a quick-start, simply follow the sections on [connecting the checklist to a computer](#connecting-the-checklist-to-a-computer), [what to expect on the file system](#overview-of-the-device-file-system) and setting up transcription through [wifi](#getting-started-transcribing-over-wifi) or the [app](/#getting-started-transcribing-using-the-auttools-connector-app). If you want to further costummize your device, check the rest of this page.

{{% hint info %}}
Note: Transcription has currently only been tested with a self-hosted instance of [Speaches](https://speaches.ai/). With Speaches being OpenAI api compatible, it should however just be a question of changing the option strings to match.
{{% /hint %}}

## Connecting the checklist to a computer

When a sleeping checklist is connected to a computer, it will automatically enter usb transfer mode. Simply wait for the display to show a moon icon (![Sleeping](../Use/MOON.png)), and then plug in the device using a USB-C (data) cable. The device should now display a large USB icon, and the internal storage appear as a removable storage device. Depending on the operating system of the computer, some extra work may be needed.
### Linux
On a linux-based system with automatic device mounting, the checklist should just appear in your file manager. If you're used to manually mounting devices, this should also work as normal.

### Mac

Depending on the version of MacOS, the checklist may or may not automatically mount. If the storage device does not appear in finder within half a minute, you'll need to mount it manually:

In a terminal window,
1. Figure out the device identifier using `diskutil list`. You should find a disk matching the following size and layout:
    ```
    /dev/disk4 (external, physical):
        #:                       TYPE NAME                    SIZE       IDENTIFIER
        0:                            NO NAME                *12.5 MB    disk4
    ```
    Make a note of the disk identifier, i.e. `disk4`
2. Create a new empty directory of your choosing, e.g. `mkdir mntchecklist`
3. Mount the disk at the directory, explicitly as fatfs:  
    `sudo mount -t msdos /dev/disk4 ./mntchecklist`  
    (replacing `disk4` with the appropriate identifier).

The disk should now appear in finder.

### Windows
{{% hint warning %}}
Note: Accessing the internal file system of the checklist using a Windows computer is currently inconsistent at best. In most cases the disk will show up in disk management, but refuse to be assigned a drive letter.
{{% /hint %}}

### A note on FS corruption. 
{{% hint info %}}
Due to the way that FATFS on the esp32 handles wear levelling, editing files on-device may sometimes result in partial writes, or corruption of other files or the FS itself. This is not fatal, but can be frustrating. If you want to ensure file consistency when editing files, copy the entirety of files off the device, edit the configuration files locally, and delete everything on-device before replacing it with the local copy.
{{% /hint %}}

## Overview of the device file system

On a checklist, you may find the following files and directories. If a file is marked as 'Default', it is automatically created by the system. non-Default files have to be created / transferred manually.

|Path|Description|Default|
|:--|:--|:--|
|/config.json|The json file containing most configuration options.|Yes|
|/cron/|A directory containing cron .json files. All files found in the directory are automatically processed. See the [Cron](./Cron/) page for more info.|Yes|
|/notes/|A directory containing each of the checklist pages and their contents. Each page has its own .json file. These files can but should not be edited.|Yes|
|/rec/|A directory containing audio recordings awaiting transcription.|Yes|
|/update.pem|The SSL certificate used when pulling an update bin from the URL specified in config.json. Only neccesary if updating via WiFi.|No|
|/whisper.pem|The SSL certificate used when accessing the transciption service over WiFi. Not required if using the app.|No|

## Getting started transcribing over WiFi

To get transcribing over WiFi, the config.json file needs to be edited, and an ssl certificate for the transcription server uploaded to the device. The config.json should be edited as follows:

1. Set `"has_wifi":true` and `"has_ble":false`
2. For the `"wifi"` object, add up to five distinct wifi networks by their SSID and password in the format: `{"ssid":"NetworkSSID","pass":"NetworkPassword"}`
3. For the `stt` object,
   1. Set the `"domain"` property to the plain domain name (or ip) of the transcription without protocol or path, e.g. `"example.com"`
   2. Set the `"path"` property to the path of the API endpoint on the domain, e.g. `"/v1/audio/transcriptions"`
   3. Set the `"model"` property to the specific transcription model you want to use, e.g. `"deepdml/faster-whisper-large-v3-turbo-ct2"`
   4. If you will be dictating mono-lingually, set the `"lang"` property to increase transcription speed and accuracy, e.g. `"en"`
   5. Set the `"token"` property to your provided token, e.g.`"cXXXXXXXXXXXXXXXXXXXXXc="`
   6. Set the `"auth"` server authentication mode. This will either be `"Basic"` or `"Bearer"`.

Download the root certificate of the API endpoint. This can either be accomplished through a browser or through terminal. Rename the certificate to whisper.pem, and put it in the root directory of the device.

Having saved, ejected and unplugged the checklist, you should now be able to start transcribing.
Try recording a message, and then look out for the wifi (![Connected](../Use/WIFI.png)) and processing (![Processing](../Use/PROCESSING.png)) icons. Within a minute, a transcription of your recording should slide onto the checklist page.


## Getting started transcribing using the AutTools Connector App

{{% hint info %}}
Note: The AutTools Connector app is currently only available for Android devices. 
{{% /hint %}}

To get transcribing over BLE using the AutTools Connector App, the config.json file needs to be edited, and the app configuration needs to be edited. The config.json should be edited as follows:
1. Set `"has_wifi":false` and `"has_ble":true`
That's it. You can now save, eject and unplug the device.

Install the AutTools Connector app and open it. In the Settings menu, input the transcription service options as provided. If you plan to only record notes in a single language, you can input e.g. `en` in the Model language field. Enable the `Background sync` and `Automatic transcription` toggle options.

In the 'Silent' tab of your notifications drawer, you should now see the AutTools Connector app. Note: This notification should not be dismissed, as it enables background connectivity with the device.

The checklist should now be able to transcribe files while your phone is nearby. Try recording a message, and then look out for the Bluetooth (![BLE](../Use/BLE.png)) and processing (![](../Use/PROCESSING.png)) icons. Within a few minutes, a transcription of your recording should slide onto the checklist page. Note that to save power, the checklist may go to sleep ![](../Use/MOON.png) after transferring the recording to the phone, while waiting for the transcription to complete. Next time the checklist wakes, it will try to connect again to fetch the transcription. You can follow the progress of transcriptions in the Recordings tab of the app.

## Overview of configuration options

| key        | Description                                                                                                                                                                                                                                                              |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `lists`    | Pages of the checklist and their individual configuration. See [Checklist Page configurations](#checklist-page-configurations)                                                                                                                                                                                                      |
| `wifi`     | WiFi networks to connect to for transcription or updating. See [WiFi configuration](#wifi-configuration)                                                                                                                                                                                                      |
| `stt`      | Speech-to-text configuration for WiFi based transcription. See [WiFi transcription configuration](#wifi-transcription-configuration)                                                                                                                                                                                                      |
| `has_wifi` | Boolean: Should the checklist connect to WiFi for doing transcriptions?                                                                                                                                                                                                  |
| `has_ble`  | Boolean: Should the checklist connect to the app over BLE?                                                                                                                                                                                                               |
| `ui`       | Various user interface configuration options. See [UI Configuration](#ui-configuration)                                                                                                                                                                                                                   |
| `tz`       | Posix TZ string for the device timezone e.g. `CET-1CEST,M3.5.0,M10.5.0/3` See https://github.com/nayarsystems/posix_tz_db/blob/master/zones.csv                                                                                                                          |
| `update`   | Settings for the OTA update system. Currently only a single option - "url" which is the url used when attempting to pull a .bin for updating the device firmware. By default https://github.com/SarahAlroe/FlyingChecklist/releases/latest/download/FlyingChecklist.bin" |

### Checklist Page configurations

`lists` is an array of objects, each representing a page on the device. Each object has the following properties:

| key         | Description                                                                                                                                                                                                                                                                                                                                                                                                           |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`      | Name of the checklist page. What is shown at the top of the screen.                                                                                                                                                                                                                                                                                                                                                   |
| `sort`      | When items on the list are checked off, should they be sorted towards the beginning of the list? This gives a better overview of the remaining unchecked items.                                                                                                                                                                                                                                                       |
| `ins_strat` | New note Insertion strategy - where in a list new notes should appear. (Dependent on sorting being enabled)<br>0: End - New notes are inserted at the end of the list. <br>1: Middle - New notes are inserted at the middle of the list, at the end of the checked items, beginning of unchecked items.<br>Effectively this changes whether older items will be towards or away from the collection of checked items. |
| `order_inv` | List order inversed? false: new notes are inserted at the bottom of the page. true: New notes are inserted at the top of the page.                                                                                                                                                                                                                                                                                    |
| `flw_new`   | Follow new notes? If true, the list will automatically scroll to show a new item being added to the page.                                                                                                                                                                                                                                                                                                             |
| `flw_chck`  | Follow checked notes? If true, the list will automatically scroll to show where newly checked items are moved to.                                                                                                                                                                                                                                                                                                     |
| `del_mins`  | Deletion minutes - How many minutes should (at a minimum) pass before a checked item is permanently deleted from the list. If 0, checked items will be deleted immediately. If -1, checked items will never be deleted.                                                                                                                                                                                               |
### WiFi configuration

`wifi` is an array of objects, each representing a wireless network which the device will try to connect to when doing wifi transcription or updating. The array should maximally have 5 networks. Each object has the following properties:


| key    | Description                                                                     |
| ------ | ------------------------------------------------------------------------------- |
| `ssid` | The SSID of the network, the name which is shown in the network selection menu. |
| `pass` | The password for the network, written in plaintext.                             |

### WiFi Transcription configuration

`stt` is an object containing properties relevant to transcription using WiFi:

| key      | Description                                                                                                                                                |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `domain` | Domain name of the transcription API, e.g. `"example.com"`                                                                                                 |
| `path`   | Path for the API endpoint. E.g. `"/v1/audio/transcriptions"`                                                                                               |
| `model`  | Name of the transcription model to be used. e.g. `"deepdml/faster-whisper-large-v3-turbo-ct2"`                                                             |
| `lang`   | Two letter short code for a specific language to transcribe by. e.g. `"en"` If left blank, the transcription will attempt to guess the language by itself. |
| `token`  | The bearer token or encoded basic auth key used for authenticating with the API                                                                            |
| `auth`   | Authentication mode for the API. `"Basic"` or `"Bearer"`                                                                                                   |

### UI Configuration

| key         | Description                                                                                                                                                    |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `clk`       | Show the clock widget in the status bar                                                                                                                        |
| `clk_upd`   | How often (in minutes) should the clock be updated? Note that shorter update times will increase battery consumption dramatically.                             |
| `done`      | Show a widget that counts the number of items and completed items on the current page.                                                                         |
| `mac`       | Show a widget that displays the last four digits of the device MAC adress.                                                                                     |
| `fb_vib`    | If a notification is to be triggered, should the vibration motor buzz for it?                                                                                  |
| `fb_led`    | If a notification is to be triggered, should the front-facing LED start blinking to indicate news?                                                             |
| `pos_vib`   | Use the inbuilt vibration motor to indicate                                                                                                                    |
| `txt_min`   | Minimum text size multiplier, integer. 1 is smallest possible value. 2 is double the size. Larger text is easier to read, but less text will fit on each note. |
| `txt_const` | Constant text size. If true, all checklist notes will use the txt_min text size. If false, a given note may have a larger text size if all text can fit.       |
| `fullscr`   | Enable fullscreening of notes? If true, a short click on a note will scale it up to fill the entire screen. Click any button to exit the fullscreen.           |
| `fb_disp`   | If a notification is to be triggered, should an icon be left in the status bar until the device is interacted with again?                                      |
