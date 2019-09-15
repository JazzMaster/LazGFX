
Lazarus Graphics
-----------------

The Lazarus Graphics API is now targeting for release version 3.<br>
Previous attempts are abandoned.

Release version 3 will come together much faster than previous releases-<br>
Most of the core API is already written, just NOT like you are used to using.

I will fix this for you.

I am not doing this to hook old code-<br>
I am doing this to ease the headache in recreating the wheel(when it works).

ONLY accelerated APIs will be used. <br>

        Windows GDI is OUT
        
        X11(post XFree fork) is IN
        GameSprockets/QDraw/QDraw GX is IN
        DirectDraw/D2D is IN

        8088-> Pentium1 can use accellerated Assembler (int 10 calls) thru "Watcom" linker (considered)
        
The latter is a "port thru Linux x86_64(or windows 32bit)" -there is no native fpc compiler -yet- on this platform.<br>
(It assumes FreeDOS, not M$ft DOS.)

DirectDraw and GameSprockets I will need some help/books on (and resources that APPLE and others were hiding).<br>
In the end it will pay out.

**WE WANT THIS FAST**


#### Portables??

You need to support an API that allows for "accellerated drawing".<br>
Do you have accellerated Framebuffer or hardware support? (RasPi does)

iOS devices have licencing issues that forbid developing for them in FPC/Lazarus.<br>
Android (from FPC) needs some help- or we need to find another way to accomplish this task.

**Coding for Other "Portables" may be possible.**

GL ES (mostly) is what is holding us back. <br>

SDLv1 may port to these devices.<br> 
It drops off at 1.2.12 for OS9-ignores GameSprockets API.

Ive already switched the code to version 2- if I can backport the code to v1, I will.<br>
Otherwise the SDLv2 code is going away. (GameSprockets API is better)

## What happened?

I took a look at some X11 code and decided that we are approaching the matter wrong(again).

This should compose of two major elements:

        2dBGI
        3dOpenGL

Can you combine the two into one API? YES. <br>
Can you extend this and add assIMP, etc etc....YES!!!! <br>

Lets get everything in working order first.<br>

If you need to mix 2D and 3D ops (at the same time) use OpenGL.<br>
I will tell you why:

        OpenGL doesnt care what view you use, if you draw in 3d onto the side of a cube, etc.
        You can mix co ordinate systems 50x time a second- and it will keep up.
        
"Drawing primitives" is left to the core APIs that can better accomplish the task.(2D)<br>
Trying to rewrite these in a 3D API is proving to be hell (and hair) raising and too much headache.<br>
So- Im just not going to do it.


SDL is an overachiever. PERIOD.<br>
This is why OS9 was dropped. 

OS9 doesnt support above OpenGL 1.2.1- SDL requires OpenGL version 2 or above.


Blame APPLE for jumping the bandwagon but OSX does provide memory segmentation and protections.<br>
While OS9 tries- it can still "BOMB OUT"- it can still crash..sometimes without a solution, otherwise randomly.

OSX is really the way to go-

        However, I will do my best to support OS9 or "classic" or "sheep-shaved" installs

I find that OS9 was ignored, and abandoned (often abused) when the latter moments of developing on the platform
actually made OS9 and the Mac a solid product. <br>
It was too perfect.<br>
(Much like Sony NetMD.)

If I can support the 2D API thru OSX Quartz2d- I will look into it.<br>
(Quartz is where OSX is at these days.)

Unfortunately, there is no universal anything. VESA tried and failed at this.<br>
Nobody else has stepped up (I will look at SDLBGI -mac code- in C sources) for multiplatform, multiarch.

When they did(Borland) - the API changed too much for anyone to keep up.

3d will be a mix of:

        OpenGL+FContext+DelphiGL(portable)+Lazarus 

where applicable and 

        OpenGL+CodeWarrior+FPC/XCode

where it isnt.

(Notice that I make no attempt to rewrite this in C)


These libs work. They test ok. <br>


DGL doesnt allow (GL issue) lower than 24bpp, nor palettes.<br>
This is a HUGE CHUNK of the API thats being written, Im not going to remove it.

Lets code around the problem, instead, by limiting these routines to "a viable 2d API".<br>
(You can limit colors used, but some routines are impossible to implement in 3d)

"IfRender3D" is the Boolean Flag Im using.

If you just want modern-day graphics, then focus on 3D API here- <br>
and look at Game engines like "Castle". (OpenMorrowWind uses assImp/OGRE.)

Keep in mind you are looking for "Linux based" or "Multi-platform Engines".<br>
I am not finding that many. <br>

Valve and Unity and Unreal devs "cheat compatibility"- <br>
by using WineAPIs instead of porting the D3D code(windows) to OpenGL(universal standard).

The other WineAPIs allow them to "not know" Linux-es, "to CHEAT again" by running a windows application.<br>
There is no actual "Native Code" running- and these devs DO NOT CARE.<br>
If the WinAPI is broken for some reason(Blizzard) - you get screwed.

I actually code for Linux. I like the challenge. I will "port" or IFDEF the rest.

## Enough said

Lazarus projects all around.<br>
Where there isnt one- compile the main library (LazGfx.pas), and "put it in your uses clause".

Im making a LIBRARY, remember? <br>
The app code is for DEMOS "of this library".

## Primary Build Targets

I will start with X11 and D2D (win7 plus, youre probably running this) -and perhaps Quartz2D(OSX).<br>
I will add other targets as time goes on-

I have 

        source code
        compilers 

-and plenty of books.

The old code will stay until I get something stable here. I just moved it.

-Jazz


