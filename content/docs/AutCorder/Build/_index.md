---
weight: 1
bookFlatSection: false
title: "How to produce an AutCorder"
---

# How to produce an AutCorder

AutCorders consist of these parts: 
1. The base AutCorder PCB.
2. A few external components attached by connector or soldering:
	- a camera module.
	- a battery.
	- a shutter button.
	- a micro-SD card.
	- and optionally a piezo buzzer or vibration motor.
3. The previous contained in a 3D printed shell.

Once assembled, the AutCorder can be flashed using the Arduino IDE, and configured using a browser based tool.

The following is a guide from beginning to end of how to build an AutCorder. If you have parts that are already prepared, you may wish to skip certain chapters of the guide. Also note that this guide suggests a certain workflow. If in doubt, it should be possible to follow this with minimal trouble. If you already have a different workflow, adjust as necessary.

Time estimate of active work: 2 - 3 hours.  
Time estimate including waiting for parts: A couple of weeks.  
Breakdown:
- PCB production and component ordering (waiting): 1-3 weeks.
- 3D Printing (waiting): 4-12 hours.
- PCB assembly: 1 - 2 hours.
- 3D Print processing: 10 minutes.
- Attaching external components and final assembly: 15-40 minutes.
- Programming and configuration: 10 minutes.

Note that this is just a documentation repository. The AutCorder sources are spread across three git repos:
- [AutCorder-Hardware](https://github.com/SarahAlroe/AutCorder-Hardware) - KiCad and production files for the AutCorder base PCB
- [AutCorder-Arduino](https://github.com/SarahAlroe/AutCorder-Arduino) - Arduino software for flashing the AutCorder board and configuration tools.
- [AutCorder-Shells](https://github.com/SarahAlroe/AutCorder-Shells)- FreeCAD and exported STL files for the different 3D printed shells available for the AutCorder

