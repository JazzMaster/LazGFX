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

//Get Active ScreenResolution, first, from xrandr

var
//as with ViewPorts- we need Quads AND a datstore

    pFeltLayer:^FeltLayer;
    FeltLayer= record
        pixels:array [0..MaX,0..MaxY] of SDL_Color;
    end;
    pTextures:^Textures;
    pAllFelt:^AllFelt;
    Textures,AllFelt: array [0..33] of FeltLayer;
    x,y,z:Single;

//lets get fuzzy. Takes a "Vynil looking layer". Returns FELT.
//What color Should I Make?

function FeltMakeMachine(Texture:GLTexture; r,g,b:byte; Layer:Byte):GLTexture;

begin
    if Layer:=0 then
        Layer:=1;
    else

    glClear;
    //rePaint all Layers- and push everything back 1mm

    //reUse textures in use- if any    
    i:=0;
    repeat
        AllFelt[i]:=Texture[i];
        glVertex3f(1.0,1.0,(0.04/ i)); //push back
        inc(i);
    until (i= Layer);
    inc(Layer);
   
  //1.0f is the full viewing area. DO NOT BACK UP.
  //put this one ON TOP.

  //add 1MM worth of depth to z-buffer (approx + or - 0.04 PER LAYER of FELT)
  //ONE ASSUMPTION: 1:1 mapping and 1 "cubic space" = ~3feet or 1 Meter(1M3)

  glVertex3f(1.0,1.0,(0.04*Layer));
            
  glColor3b(r,g,b,$ff);
  //fuzz it
  with AllFelt[i+1] do begin

//      pixels[x,y]:=(0.0,0.0,0.0,1.0);

  end;

  //save Texture - for next run
  Texture[i+1]:=AllFelt[i+1];
  
  FeltMakeMachine:=Texture[i+1];
end;

begin
  //Top Down view  
  glOrtho();

end.


