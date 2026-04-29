---
weight: 12
title: "Step 2: Programming"
---

# Step 2: Programming

Programming the NeoInfinity badge is rather straight forward for anyone familiar with the Arduino. In short, it involves opening the Arduino project, installing [
Spence Kondes megaTinyCore](https://github.com/SpenceKonde/megaTinyCore) core, configuring the board settings, connecting and then flashing the board.

## Requirements
- A computer with a USB port, and the Arduino IDE Installed. Any operating system supporting the IDE should work (Windows, Mac, Linux).
- A UPDI programmer board.
## Sub-Steps
### Installing software prerequisites
To flash the badge with its software, you need to have the [Arduino IDE](https://www.arduino.cc/en/software) installed.
The IDE needs to have the megaTinyCore core for tinyAVR MCUs installed ([Installation guide](https://github.com/SpenceKonde/megaTinyCore/blob/master/Installation.md)). 
The [NeoInfinity repository](https://github.com/SarahAlroe/NeoInfinity) should be downloaded. 

### Flashing the badge software
To flash the code, you should
1. Open the NeoInfinity project in the Arduino IDE.
2. Select Tools -> Board: -> megaTinyCore -> ATtiny412/402/212/202
3. Set all the options in the bottom half of the Tools menu to the following: ![Board: "ATtiny412/402/212/202". attachinterrupt Mode: "On all pins, with new implementation." BOD Mode when Active/Sleeping (burn bootloader req'd): "Disabled/Disabled". BOD Voltage Level (burn bootloader req'd): "1.8V (5 MHz or less)". Chip: "ATtiny412". Clock: "20 MHz internal". Save EEPROM (burn bootloader req'd): "EEPROM retained" millis)/micros). Timer: "Disabled (saves flash)". printf(): "Minimal, 1.1k flash used". Programmer: "SerialUPD| - 230400 baud"](Software-BoardOptions.png)
   The important settings to get right here are Chip type, millis())/micros()) Timer, printf(), and the appropriate programmer, as setting these wrong will likely make the software fail to compile burn.
1. Connect the badge to the computer using a UPDI programmer, and select it in the IDE. 
	- Remember to select the appropriate programmer for your UPDI board.
2. Click the upload button (in the top left corner), to start compiling and then uploading the software to the device.