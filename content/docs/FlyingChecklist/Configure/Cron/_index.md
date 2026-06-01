---
weight: 3
title: Configuring cron
---
# Configuring cron

The checklist has support for recurring notes that (re)appear on a fixed schedule.
This can be used to keeping track of regular tasks, like taking your meds or vacuuming.
Recurring notes are configured through .json files in the cron subdirectory on the device.

{{% hint info %}}
This feature is named cron after the [unix job scheduler](https://en.wikipedia.org/wiki/Cron), as it makes use of the cron time-interval syntax. Do note that no other functionality is shared beyond this (e.g. actual crontab files will not work here.)
{{% /hint %}}

The cron .json files must contain arrays of objects, each denoting a recurring note. Note objects can have the following properties:

| key      | Description                                                                                                                                                                                                                                                                                                                                                            |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `time`   | String. The time interval in cron syntax (with seconds) for when this note should be added.                                                                                                                                                                                                                                                                            |
| `page`   | String. Which of the checklist pages the note should be inserted into. Use the same text string as used for the `name`property in the main config.json file.                                                                                                                                                                                                           |
| `one`    | Boolean. Should there only be one instance of this note on the list? If true, the checklist will check if a note with the same text already exists and uncross it (if crossed), instead of just adding another note.                                                                                                                                                   |
| `aggro`  | Boolean. If the checklist has lost track of tasks due to being reset or loosing power, should the note be added regardless of this uncertainty? This may lead to the note being added more than intended, but will guarantee the note *will* appear at all intended times. If the checklist is not actively being worked on and is kept charged, this will not matter. |
| `follow` | Boolean. When this note is added, should the checklist page and position change to stay where the note was added? This can bring additional attention to the added note, but may be mildly confusing as the device then changes position on its own.                                                                                                                   |
| `notify` | Boolean. When the note is added, should the checklist notify of this? Whether to notify by LED blink, vibration or status icon is configured in the [main config file](../#ui-configuration).                                                                                                                                                                                                  |
| `txt`    | String. The text contents of the note to be added.                                                                                                                                                                                                                                                                                                                     |

{{% hint info %}}
The cron syntax can be confusing to understand. Many online interactive tools (e.g. [crontabkit](https://crontabkit.com/crontab-expression-generator)) can be used to generate a desired cron string.
{{% /hint %}}

Cron .json files are enabled simply by placing them in the /cron/ subdirectory.

## Example cron .json file


If the following .json file is put into the /cron/ directory, the following notes reappear:

- Every Friday at 16:00, a new note with the text "Start the weekend!" will appear on the page titled Work. The checklist will change to (and stay at) the Work page, and then notify of the new note.
- Every day at 06:30, the note "Take your meds!" is added or un-crossed on the page titled Home. This os done quietly without disturbing the checklist otherwise.

```json
[
    {"time":"0 0 16 * * FRI","page":"Work","one":false,"aggro":false,"follow":true,"notify":true,"txt":"Start the weekend!"},
    {"time":"0 30 7 * * *","page":"Home","one":true,"aggro":false,"follow":false,"notify":false,"txt":"Take your meds!"},
]
```
