# pilotedge_helper
X-Plane 10 LUA script with some handy functions for online flying on Pilotedge, Vatsim, etc. Requires [FlyWithLUA plugin](http://forums.x-plane.org/index.php?app=downloads&showfile=17468) installed

## Features

### Mini Transponder gauge

An unobtrusive mouse-driven transponder gauge, giving you the ability to always have a "mode C" capable transponder with IDENT functionality on any airplane/model that you use.

The gauge is hidden by default and activated by moving your mouse to the **bottom right corner** of your monitor: the gauge then appears and you can **change your squawk code** by mousing over the individual digits and rotating the mouse wheel up or down.

![Gauge](http://i.imgur.com/vK4mN2R.jpg)

The colored vertical bar on the right represents the **mode of the transponder**:

* red = transponder off
* yellow = transponder standby
* green = transponder on/alt (mode "C")

![SQ SBY](http://i.imgur.com/fPh3kBh.jpg)
![SQ C](http://i.imgur.com/MfWogE7.jpg)

The **modes can be cycled** by left-clicking anywhere within the main transponder window: click once to go from OFF to SBY, then one more time to go from SBY to ON/ALT the once more to go from ON to OFF, etc.

*NOTE: Please note that neither X-Plane nor the network pilot clients distinguish between the modes ON and ALT. Some airplane models do have transponders that visually represent these different modes, but that's purely cosmetical and uses the same internal X-Palne dataref: as far as X-Plane and the pilot clients are concerned there are three transponder states only (+ a test state which is interpreted as ON by the clients as well) and when the controller tells you to "squawk C" or "squawk altitude" if you're green, you're good*

The upper part of the gauge represents the **IDENT button**: clicking anywhere in that upper area will send the ident signal and this is what you press when a controller asks you to ident. While identing, the upper area will blink very fast in green color, to give you a visual cue that you're identing.

![SQ IDENT](http://i.imgur.com/RZ1Lc8x.jpg)
