---
weight: 3
bookFlatSection: true
title: "Customizing the AutCorder"
---

# Customizing the hardware

The AutCorders have been designed to be modified in both form and function. Here's a bit of guidance on getting started:
### Custom shells
If designing an producing your own AutCorder shell, a few things should be kept in mind:
- The dimensions of the AutCorder PCB.
- The locations and necessary space for the USB socket (and connected cable) and camera. Note that the camera is an Ø8mm x 4mm cylinder sitting on top of an 8.5 x8.5 x 2.5 mm box, protruding from the PCB (and also that the micro SD card sticks out at a 2.7mm height). Getting these dimensions right may require a few iterations or manual adjustment.
- The necessary space for the chosen battery (important to not risk damaging the cell) and any additional wires and peripherals.

The existing AutCorder shells are available as FreeCAD files for inspiration, sizing or remixing, although I would recommend starting from scratch for any significantly different designs. If you are doing CAD, the easiest way to check dimensions for a new design is to import the [KiCad produced .step file](https://github.com/SarahAlroe/AutCorder-Hardware/blob/main/AutCorder-Hardware.step) to measure against.
### Toggle input
One ready-to-implement modification of the AutCorder is a toggle input for prepending pictures and recordings with either of two text strings. To do this, simply solder the pole of a SPDT switch to the middle `UTIL` pin, and the two throws to the first and third pin. Then enable and configure it as detailed in the section above. An example shell with inbuilt space and slot for a selector switch can be found in the [KittyCam shell design](https://github.com/SarahAlroe/AutCorder-Shells/tree/main/KittyCam).
### Extending behavior
Beyond existing functionality, the AutCorder hardware has a few extra features that can be utilized for further customization:
- As mentioned above, the board has three `UTIL` pins, which in sequence are a ground, a `GPIO`, and a `3.3V` source (connected to the switched rail, meaning it is turned off during sleep). Although functionally limited to being a binary input at the moment, the `GPIO` pin is internally connected to `GPIO8`, which can function as both a touch sensor, analog input, or RTC GPIO for interactivity during sleep. With a bit of modification and code the `UTIL` pins could function as a potentiometer input, a touch sensor, a secondary shutter, a status indicator, or additional feedback output. Sky's the limit (as long as a single GPIO is enough...).
- The board has a pair of `LED` pins, which are connected in parallel with the on-board camera flash (but through a separate current limiting resistor). These pins can be used to add a secondary (or replacement) flash LED of higher power or different color. By default both LED resistors are `1KΩ`. On the schematic, the resistor for the inbuilt LED is `R19` wile `R23` is for the external LED.
- Behind the USB socket is a pair of `PWR` pins, which are connected in parallel with the USB power input. These can be used for adding a separate power input (like wireless or pogo pin charging), or for enabling shell designs where the board USB port is not easily accessible.