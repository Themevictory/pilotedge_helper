# pilotedge_helper
X-Plane 10 LUA script with some handy functions for online flying on Pilotedge, Vatsim, etc. Requires [FlyWithLUA plugin](http://forums.x-plane.org/index.php?app=downloads&showfile=17468) installed

## Features

### Mini transponder gauge

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

Moving your mouse outside of the gauge are hides the gauge, so you can enjoy an uncluttered screen without breaking your immersion.

*NOTE: The gauge is fully compatible with plane models that already have built-in transponders: in these cases it can be treated just as an alternate method of manipulating the transponder values, or can be completely ignored (or disabled: see below)*

### FPS counter

On the bottom left of your screen you'll see several indicators, the first of which is a FPS counter:

![FPS](http://i.imgur.com/AsanbRW.jpg)

True, you can opt to visualize your FPS by displaying the relevant X-Plane dataref in the uper left conrner, but it's a big ugly box that holds a ton of additional information that you probably don't need unless you're troubleshooting something.
This here is a simple **color coded** FPS counter: with frames at 30 or above it's green, the range 20 to 30 is yellow and at 19 or bellow it goes red.

*NOTE: The 19 FPS threshold is an important one when flying online: when you drop below it X-Plane will start transparently decreasing your simulation rate, so that your system is able to cope with the rendering strain. The net result is that you will be moving around more slowly than you think you are (and than your gauges are telling you). For the controllers watching you on their scopes and for other pilots in the air your ground speed would be slower than displayed: e.g. you might be at 120kt indicated / 140 ground speed according to your speedometer, but due to the sim-rate decrease you might be effectively at let's say 100 ground speed and this is how it would appear to the other guys on the network, be it ATC or other pilots. You can ocassionally hear controllers on Pilotedge commenting on this on the frequency and mentioning "the FPS issue"*

### Selected COM radio (and frequency)

The second indicator shows you the currently selected COM radio **for transmitting** (along with its currently dialed frequency):

![COM](http://i.imgur.com/h4x9VTj.jpg)

When flying online and having to deal with multiple frequency changes it's convenient to use both COM radios (when your plane has them). Unfortunately many models / addons fall short when it comes to selecting the radio for trasnmitting: some addons just don't have working buttons for that in their 3D cockpits, some tie it to the listening radio selections, some use custom code, etc. It's inconsistent and I've heard pilots on Pilotedge many times unintentionally transmit on the wrong COM radio (and I've done it myself).
So it's very handy to be able to *determine at a glance* which COM radio is selected for transmission and what frequency is dialed in it. This is what this indicator does and it's also *color coded*: it's white when COM1 is selected, yellow when COM2 is selected and red while you're transmitting (the "Contact ATC" button pressed):

![COM2](http://i.imgur.com/P6kgzyN.jpg)
![COM TRANSMIT](http://i.imgur.com/zuRuYsT.jpg)

Apart from being an indicator, this area is also an actuator, i.e. it not only shows you the information, but allows you to **change it (COM1 <-> COM2)**: clicking anywhere on the COM area will toggle the transmitting radio from COM1 to COM2 or vice versa. You can use that if your plane/hardware does not have a convenient way of switching between the radios.

### Transponder mode indicator

The last indicator displays the current transponder mode, which is also handy to have at a glance at all times: you ought to have your transponder on when airborne at sometimes also on the ground when the airport uses Ground Surveilance Radar. The indicator is *color coded* and displays a red [-] symbol when transponder is off, yellow [S] when transponder is on standby and green [C] when transponder is on (mode C):

![SQ MODE](http://i.imgur.com/b6POU0U.jpg)
