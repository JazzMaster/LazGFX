
Lazarus Graphics
-----------------

2D Completion Status:


Function/Procedure:

	InitGraph: Working<br>
	CloseGraph:  Working <br>
	GraphDetect: SDLv1:  Working  SDLv2:  In Progress<br> 
    (Draw)Line:  Working <br>
	(Draw)Rect:  Working <br>
	PlotPixelWithNeighbors:  Working<br> 
	PutPixel:  Working <br>
	GetPixel:  Working <br>
	Clearscreen/ClearDevice:  Working<br> 
	SetBGcolor(multiple declarations):  Working<br> 
	SetFGColor(multiple declarations):  Working <br>


3D Completion Status:

	InitGraph:  Working <br>
	CloseGraph:  Working <br>
	Core GL  ops:  Working, Linking OK from C <br>
	GL DirectRendering (Drawing on the fly ops):  Working <br>
	GL Shaders(GLSL and 3D spirtes):  MOSTLY BROKEN, requires C-like shader code(vertex/fragment) <br>


---

I am not replacing every SDL function here- but I am rewriting "the Borland equivalent".<br>
(SEE the C version of SDLBGI if want to know more.)

ONLY accelerated APIs will be used. <br>
        
        X11(post XFree fork)
        QDraw/QDraw GX(GameSprockets API and documentation cant be found)
        DirectDraw/D2D

        8088-> Pentium1 can use accellerated Assembler (int 10 calls) thru "Watcom" linker 
        
The latter is a "port thru Linux/Windows x64" hack -there is no native fpc compiler -yet- on this platform.<br>
(It assumes FreeDOS, not M$ft DOS.)

**WE WANT THIS FAST**

Theres one possible glitch:

		2d ops may be using "forced software surfaces" if not using fullscreen rendering/drawing

This is a Hardware limitation, not so much SDL. Of course, hardware rendering is faster(if you can use it).<br>
It also imposes its own sets of challenges.


#### Portables??

You need to support an API that allows for "accellerated drawing".<br>

iOS devices have licencing issues that forbid developing for them in FPC/Lazarus.<br>
Android (from FPC) needs some help- or we need to find another way to accomplish this task.

**Coding for Other "Portables" may be possible.**

GL ES (mostly) is what is holding us back. <br>
SDL may port to these devices.<br> 

## What happened?

I took a look at some X11 code and decided that we are approaching the matter wrong.<br>
CodeWarrior would like us to use QuickDraw(thats ok).<br>
DirectDraw or D2D (DirectX) is faster than Windows GDI.

### The teardown

This "UNIT" should compose of two major elements:

        2dBGI
        3dOpenGL

Can you combine the two into one API? YES. <br>
Can you extend this and add assIMP, etc etc....YES!!!! <br>

Lets get everything in working order first.<br>

If you need to mix 2D and 3D ops (at the same time) use OpenGL.<br>
I will tell you why:

        OpenGL doesnt care what view you use, if you draw in 3d onto the side of a cube, etc.
        You can mix co ordinate systems 50x time a second- and it will keep up.

GL co-ordinate system is what confuses people. (Change your perspective matrix, reset it, change it again...)<br>
(or as I like to call it- "the push it, pop it, tweak it-bop it", method)


"Drawing primitives" is left to the core APIs that can better accomplish the task.(2D)<br>
Trying to rewrite these in a 3D API is proving to be hell (and hair) raising and too much headache.<br>
So- Im just not going to do it.


#### Mac OS

OS9 doesnt support above OpenGL 1.2.1- SDL requires OpenGL version 2 or above, so as of SDL 1.2.13, OS9 was dropped.<br>
OS9 has 16bit memory limts(2GB addressable space) due to max memory hardware limits(32bit PowerPC cpu).<br>
(This may be due to 080 compatibility layer provided thru OS9. Yes, you can run 68K apps!)

Since OS9 is Object-Pascal, there may be a way to hack the core kernel into using a VM instead of segmented memory model, however, this may break compatibility.<br>
There is a hack for Borland BP/TP7 that switches out the segmented memory model with a VM(x86) on-demand paging one.<br>
You have to replace a Compiler file, somewhere- as memory serves.


The question is how much of the OS depends on it? 

		The system Folder?
		All Apps?
		Extensions?


OSX is really the way to go-

        However, I will do my best to support OS9 or "classic" or "sheep-shaved" installs

I find that OS9 was ignored, and abandoned (often abused) when the latter moments of developing on the platform actually made OS9 (and the Mac) a solid product. <br>

It was too perfect.<br>
(Much like Sony NetMD.)

If I can support the 2D API thru OSX Quartz2d- I will look into it.<br>
(Quartz is where OSX is at these days.)

Unfortunately, there is no universal anything. VESA tried and failed at this.<br>
Nobody else has stepped up (I will look at SDLBGI -mac code- in C sources) for multiplatform, multiarch.

When they did(Borland) - the API changed too much for anyone to keep up.

#### 3D

3d will be a mix of:

        OpenGL+FContext+DelphiGL(portable)+Lazarus units

where applicable and 

        OpenGL+CodeWarrior or Lazarus/FPC/XCode

where it isnt.

(Notice that I make no attempt to rewrite this in C)


#### DelphiGL Caveat

DGL doesnt allow (GL issue) lower than 24bpp, nor palettes.<br>


If you just want modern-day graphics, then focus on 3D API here- <br>
and look at Game engines like "Castle". (OpenMorrowWind uses assImp/OGRE.)

Keep in mind you are looking for "Linux based" or "Multi-platform Engines".<br>
**I am not finding that many.** <br>

Valve and Unity and Unreal devs "cheat compatibility"- <br>
by using WineAPIs instead of porting the D3D code(windows) to OpenGL(universal standard).

The other WineAPIs allow them to "not know" Linux-es, "to CHEAT again" by running a windows application.<br>
There is no actual "Native Code" running- and these devs DO NOT CARE.<br>

I code for Linux. I like the challenge. I will "port" or IFDEF the rest.


## Primary Build Targets

		OS9/OSX (macintosh PowerPC- Intel thru OSX 10.9 coming soon)
		Win32/64
		Lin32/64 (missing a Pascal-based Graphics API and working OpenGL routines)
		RasPi(mailroom based GPU accleration inside the framebuffer)




-Jazz


