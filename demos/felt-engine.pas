Unit FeltEngine;

{

A "FELT-like experience" for programming 2D scenes or games or animations

-Requires some sort of BGI(or BGI-ish interface)- 
-preferrably mine (Jazz)

---

-The reason why is that we are using GL 2/3D functions
We are not pushing background perspective- but we need 3D Depth for the "felt" to work.

-FELT is about a MM thick-
Anything applied - or removed- affects the whole layer of felt.

YES- you can pre-cut the FELT as it were. In reality- a "cricut machine" would do this for you.
Shapes added to the screen get "felted".

We can accellerate by using bitmaps of the pre-compiled felt IFFF we can chroma key it.
Id prefer to compute the felt noise.

-or-

Use "precompiled felt" Textures from disk. (There will be loads of felt needed)

This will require a lot of CPU or a GPU to work right.

Animations are pretty basic. This is intentional.
Animations, weather, etc are always the top layer of felt. 
This layer is always a TnL shader(or transparent effect).

Take BG or FG color and apply noise to it- to give a felt-like look.
Then render layers of felt on each other to make a scene.

Look at it top-down (photoshop/gimp) or straight on (look at TV)

render some FX on top like snow, rain,etc.
add animation

-This is my SPIN on SEGAs "Painted Canvas" idea.

}

//we can have lots of layers but lets not make this too complex.

//Get Active ScreenResolution, first.

var
    ScreenResolution: LongWord;
    FeltLayers: array [0..32] of ScreenResolution;

//lets get fuzzy. Take a Vynil looking layer. Returns FELT.
function FeltLayer(Texture:GLTexture):GLTexture;
begin
    //with TExture do begin
        //add noise
        //add 1MM worth of depth to z-buffer
    //end;
end;

begin

end.


