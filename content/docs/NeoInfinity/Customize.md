---
weight: 5
bookFlatSection: true
title: "Customizing the badge"
---

# Customizing the badge

While the NeoInfinity badge is intentionally limited in capabilities, it can be costumized in various ways by modifying its source code. Examples of a few easy modifications are provided below.

{{% hint info %}}
Note that the ATtiny412 has both very limited flash and RAM. To make any additions would likely require taking out existing functionality to make space. 
{{% /hint %}}

## Provided config options

A few simple configuration options are provided at the top of the Arduino code, which function as follows:
- `LIGHT_ATTENUATION_LEVEL` At their maximum, the LEDs on the board can be unpleasantly bright. This option limits the maximum brightness to a more sensible level. This option can be set between 0 and 8, where 0 is brightest and 8 is dullest. By default, the limit is set to 3.
- `DO_ERROR_DIFFUSION` To smooth out the animations of the LEDs, which at low brightness can appear rather 'stepped', the software uses temporal error diffusion dithering (Described in a blog post [here](https://sarah.alroe.dk/2025/NeoInf/)). This option, set to either `true` or `false`, enables or disables this feature. There are few reasons other than aesthetics to disable it.
- `GAMMA_CORRECTION_COMPLEXITY` While most display devices work in linear space, the eye does not perceive brightness linearly. To manage this, [gamma correction](https://en.wikipedia.org/wiki/Gamma_correction) is utilized. Due to the limitations of the ATtiny, the badge uses one of three approximations of a proper gamma function: `0` is the fastest, while `2` is the most accurate. `1` is a reasonable compromise. If you need faster rendering speeds (i.e. less flicker), change this to `0`.
- `SINGLE_COLOR_SINGLE_SPEED` In its default configuration the badge cycles through five different color sets: Pastel rainbow, red, yellow, green, HSV rainbow. By enabling this option, only one animation speed is available for the red, yellow and green options, as they have little aesthetic difference. This reduces the number of combinations to cycle through from 45 to 27.

## Changing the speed of animations

By default, each animation can progress at three distinct speeds, set by the `ANIM_SPEED_0`, `ANIM_SPEED_1` and `ANIM_SPEED_2` constants, ranging from 0-255. 
By increasing their value, animations will be sped up. Similarly, reducing the value will slow down the animation. A speed of 0 means the animation will be stopped.
To e.g. have the option of having an entirely still badge (and otherwise a slow and slower option), the constants might be reconfigured as:

```C
#define ANIM_SPEED_0 0
#define ANIM_SPEED_1 8 * 20000000 / F_CPU
#define ANIM_SPEED_2 30 * 20000000 / F_CPU
```

The number of available animation speeds can be changed by changing the SPEED_COUNT constant and editing the MOVING_SPEEDS array to add or remove elements.

## Adding new color schemes

Except for the HSV rainbow option, color sets are defined as a set of four 8 bit RGB values, defined in the `quadGradientColors` constant. 
Without having to change other parts of the code, these four colors can be modified as desired. To ease the process of selecting colors, a [gradient visualiser](https://cssgradient.io/) can be used with the four colors positioned at (0%, 100%), 25%, 50% and 75%. 

The number of available colors can be changed by changing the GRADIENT_COUNT constant and editing the quadGradientColors array to add or remove elements. 
Keep an eye on the compiled flash size, as it may be difficult to fit many more colors into the limited ROM. Note that the HSV rainbow colors are generated in a different way.

## Adding an animation pattern

Animation patterns, or *directions* as they're called in code, are stored in a slightly peculiar way: 
Since all animations are cyclical, a pattern consists of the relative offset in the animation of each individual RGB LED pixel, stored in the sequence they are electrically wired.
Animations complete an entire cycle by cycling through the entirety of an unsigned 16 bit integer space, from 0 to 65535, then overflowing back to 0.
By offsetting each pixel along this ring, their color can be temporally staggered.

By default, the three available patterns available are flowing along the infinity symbol, moving horizontally across the badge, and randomly distributed fading.

Again the number of available patterns can be changed by modifying the `DIRECTION_COUNT` constant and modifying the `PIXEL_POSITIONS` array. 
Even more than with colors and speeds, additional patterns will take up significant space. 
