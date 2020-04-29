# Vertical Tracker
A database to track my progress to jump good like my hero, Samurai Jack:
![Samurai Jack](misc/samuraijack_fly.gif)

## Summary
Starting on April 6, 2020 I have been tracking the highest point I can reach.

## TODO
### Per day improvement
Compute change in vertical from previous day, instead of simply tracking actual
vertical. This would give me a better sense of environmental conditions for
improvement magnitude (e.g. "A 0.2 kg increase in weight at 11 degrees Celcius
led to a 12% improvement - or 1.2 cm increase - to my vertical").

I can also take the derivative of the slope of the tracking values

### Add humidity variable
Temperature is a good measurement, but humidity might also hold important
information that may corellate with jumping ability.

## Current Progress
Here is a visualization of my current progress
![Current Progress](figures/current.png)

## Navigating Data
DoltHub uses a SQL interface to manipulate data. There is currently only one
table named **data**. This table currently has **10 fields**, but that may
change as I try to slim it down later on.

### Table Fields
**Measurement:** chronilogical index of when the measurement was taken <br />
**Date:** date of **Measurement** in *dd.mm.yyyy* format <br />
**Time:** time of **Measurement** in 24-hour format<br />
**Day:** day of week <br />
**Weather:** outside weather at time of **Measurement** <br />
**Temperature_C:** temperature of **Measurement** in *Celcius* <br />
**Height_cm:** my height at time of **Measurement** (constant because I'm old) <br />
**Stretch_cm:** my maximum outstretched height from feet to tip of fingers <br />
**Weight_kg:** my morning weight, tracked by my smart scale and *Feelfit* app <br />
**Reach_cm:** total height reached by the **Measurement** <br />

I am calculating the total vertical jump as <br />
**Vertical_cm** = (**Stretch_cm** - **Reach_cm**).

## Tracking Data
I am taking advantage of my apartment's high ceiling and measuring my jumps by
placing a Post-It note as high as I can on my loft. The Post-It note has
various information to ensure I can properly keep track of when I jumped, the
height I reached, etc.

### Setup
Here is an example of what the setup looks like:
![Setup](pics/setup.jpg)

### Example Jump
And here is a clip of one of my jumps: <br />
![Side](gifs/side.gif)
![Back](gifs/back.gif)
