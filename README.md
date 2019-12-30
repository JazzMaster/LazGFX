
Lazarus Graphics
-----------------

This is the (NEW?) Graphics Core API for FPC/Lazarus.<br>
We are using SDL (and OpenGL) here.

Please try it- especially if you are coming from DOS-era libGraph(C) or Graph.pas(BP/TP) units.<br>
This is a modern-day version of "that".

#### Dont start the presses yet...

Printing is one unit we lack.<br> 
You need to convert the data into "postscript format"- and kick the data(output,file) into some sort of printer buffer
or printer engine, or "print server" - to print anything.

#### The BLEEPING COMPUTER
 
It should be beeping...(why its not is another matter)<br>
I picked up where fpc team left off. Debian isnt beeping, Ubuntu is.<br>
(lack of a PC speaker on my notebook?)<br>

So yes, that is back(ON LINUX), Grand Piano-ish...if you want to write older sound routines..<br>
I have docs on this , and its "sort of implemented" in my sub-units.

(See Late 1980s and early 1990s BASIC refernces on this- yeah, its that old of a routine.)


### License

Lazarus Graphics units are Mozilla/Apache licensed(you can "free more" but you cant UN-FREE).<br>

Various other misc units are licenced under GPL, LGPL and other Open Source parameters.<br>
You remain free to FREE them further - however, GPL and LGPL forbid "restrictive licence changes".

This is not PUBLIC DOMAIN CODE. 

PUBLIC DOMAIN is ABANDONWARE- "do whatever licences" (MIT or similar).<br>
Sometime licenses have other restrictive clauses- payment limits, etc.<br>
Those routines, if ever used- have been removed.<br>
They cannot be used(legal reasons), so dont add them.

Microsoft, Apple, and GL (as well as MESA and X) Consortium(s) maintain the copywrights and licensure on 
GUI APIs- but allow hooking them. That is all Ive done. I do not claim to have wrote that code, and I make no claim to.

#### WARRANTY

This unit uses (and links to) code from various people. 
THIS SOFTWARE COMES WITH ABSOLUTELY NO WARRANTY- 

		Including the merchantibility for ANY particular purpose.(It may not suit your needs)

The code is "mostly sane", but do use caution.<br>
This is WIP, but the most complete attempt that I have (built) found so far.

Timer Callbacks are not fully implemented yet, use caution. Code will not be optimal, yet.

---

Ports status:

Win32 and Linux64(at least) are FULLY OPERATIONAL, as the code is written(console app).<br>
FPIDE seems to be missing from Win32 fpc port for some reason(bad idea).

Lazarus)itself) seems to kill off SDL Renderer for some reason, possibly due to broken code in setGraphMode...<br>
(Using BGITest.pas as a "Program")

GL seems to work either called thru the console, or as a Lazarus app.


2D Graphics(BGI) Status:

**SDL1 is an early alpha break/fix mode- not guaranteed to compile yet**<br>
**SDL2 is working in break/fix mode as features are tweaked and added**

InitGraph: Working<br>
CloseGraph:  Working <br>
GraphDetect: 

	SDLv1:  Working
	SDLv2:  In Progress 

(Draw)Line:  Working <br>
(Draw)Rect:  Working <br>
PlotPixelWithNeighbors:  Working<br> 
PutPixel:  Working <br>
GetPixel:  Working <br>
Clearscreen/ClearDevice:  Working<br> 
SetBGcolor(multiple declarations):  Working<br> 
SetFGColor(multiple declarations):  Working <br>
Tris: somewhat implemented<br>
Circle(Bresnans): Should work, untested<br>
Ellipses, Polys,Fills: Unimplemented<br>
Line: MISSING! (fpc team..)<br>
Logging: FULLY OPERATIONAL



3D OpenGL Status(very basic):

InitGraph:  Working <br>
CloseGraph:  Working <br>
Core GL ops:  Working, Linking OK from C <br>
GL "DirectRendering" (Drawing on the fly ops):  Working <br>

Textures(and QUADS): UNTESTED, doesnt need "shaders" with "basic objects".<br>
Games create objects(possibly thru shaders), then add Textures to them, like "slapping wallpaper on everything".<br>
(You can texturize both 2d and 3d objects.)

---

Castle Engine may provide these:

GL Shaders(GLSL): MOSTLY BROKEN, possible to use<br>

RENDERING ISSUES, INEFFICENT on larger scale

	requires wonky C-like shader code(vertex/fragment) and "programs" to be compiled

3D spirtes(OGRE/AssImp):  UNIMPLEMENTED<br>
SceneGraph(WorldGen,SpeedTree,etc): UNIMPLEMENTED<br>
Collision(Bullet) Physics: UNIMPLEMENTED<br>
Compressed and Advanced Texture Loading: UNIMPLEMENTED<br>

---

### Depends HELL!

These units have many many depends.<br>
I have tried to source as many as possible for you, without requiring you to rebuild each and every one.

**There is no way to avoid this unless you want to reprogram everything  
for 50+ years and have a team of programmers to do it.**

JPEG support alone- in Pascal is an ancient mess, most will not know decades later how to implement it.<br>
-You have to co-ordinate!

OpenGL would not be possible to use in Lazarus if not for FContext and DelphiGL teams
(YW for the double threat).


Anyone scared of this- wanting static, self-made SINGLE DEPENDS libraries ...run into the worgen woods now.<br>
I cannot- and WILL NOT- help you. <br>

You can help me by coding for DX, X11, or Quartz2D, QuickDraw- as punishment.

#### Just Draw

I operate on the "just draw" concept. 

You shouldnt have to worry about the sublayered APIs.<br>
You want to draw, so lets make it easier!

I am not replacing every SDL function here- but I am rewriting "the Borland equivalent".<br>
You can use any "drawing method you like", once the context is operational.<br>
Same with OpenGL.

ONLY accelerated underlying APIs will be used. <br>
        
        X11(post XFree fork)
        QDraw/QDraw GX/GameSprockets 
        DirectDraw/D2D

        8088-> Pentium1 (DOS) can use "accellerated Assembler (int 10 calls)" thru "Watcom" linker 
        
The latter is a "port thru Linux/Windows x64" hack -there is no native fpc compiler -yet- on this platform.<br>
(It assumes FreeDOS, not M$ft DOS.)

**OPENGL is reserved for 3D and 2D/3D combinations ONLY.**

Theres one possible glitch:

		2d SDL ops may be using "forced software surfaces" 
			-if not using fullscreen rendering/drawing
			-if using SDL1 vs SDL2 on newer hardware

Of course, hardware rendering is faster(if you can use it).<br>
DO NOT PRESUME that Accelerated drawing ops REQUIRE openGL. They DONT.


#### Portables??

You need to support an API that allows for "accellerated drawing".<br>

iOS devices have licencing issues that forbid developing for them in FPC/Lazarus.<br>
Android (from FPC) needs some help- or we need to find another way to accomplish this task.

The RasPi is showing Promise, for VTerm access(libsvga or directfb).


### The teardown

This "UNIT" should compose of two major elements:

        2d- BGI
        3d- OpenGL

OpenGL is EXTREMELY ADVANCED 2D/3D engine- that leaves most of the work, math, (and how-to) UP TO YOU.<br>
IT DOES NOT ASSUME ANYTHING.

If you need to mix 2D and 3D ops (at the same time) -use OpenGL.<br>
I will tell you why:

	OpenGL doesnt care what view you use, if you draw in 3d onto the side of a cube, etc.
	You can mix co ordinate systems 50x time a second- and it will keep up.

GL co-ordinate system is what confuses people.<br>
Further, you need at least a basic understanding of College level "intermediate algebra" to understand the 
co-ordinate system(x,y,z RightHand, LeftHand,etc) and how it works.

Now, you can add a 2D HUD on top of all of that- AND work in 3D (at the same time), using a different
co-ordinate calculation(without dropping a single voxel- or slowing down).

(Change your "perspective" matrix, reset it, change it again...)<br>
(or as I like to call it- "the push it, pop it, tweak it-bop it", method)

"Drawing primitives" is left to the core APIs that can better accomplish the task.(2D)<br>
Trying to rewrite these in a 3D API is proving to be hell (and hair) raising and too much headache.<br>
So- Im just not going to do it.(Its overkill trying)


### 2D

2D will consist of a "mimicked", Pseudo-BGI API based on what we already know about it,<br>
Ported multi-platform (and multi-arch) thru SDL(for now).


#### Mac OS

MAC OS9 is SDL1.2 limited!

OS9 doesnt support above OpenGL 1.2.1- SDL requires OpenGL version 2 or above, so as of SDL 1.2.13, OS9 was dropped.<br>
OS9 has 16bit memory limts due to max memory hardware limits(32bit PowerPC cpu).<br>
(This may be due to 080 compatibility layer provided thru OS9. Yes, you can run 68K apps!)

There is a hack for Borland BP/TP7 that switches out the segmented memory model with a VM(x86) on-demand paging one.<br>
-You have to replace a Compiler file, somewhere- as memory serves.

Since OS9 is Object-Pascal, there may be a way to hack the core kernel into using a VM instead of segmented memory model.
-however, this may break compatibility.

Compatibility is actually a HUGE DEAL with MacOS.<br>
(Snow Leopard still supports PowerPC applications- half of which are still supplied, as of SL-"PPC only" by apple)

The question is how much of the OS depends this compatibility? 

		The system Folder?
		All Apps?
		Extensions?

I find that OS9 was ignored, and abandoned (often abused) when the latter moments 
of developing on the platform actually made OS9 (and the Mac) a solid product. <br>

It was too perfect.<br>
(Much like Sony NetMD.)

#### OSX (10.4+)

OSX is really the way to go-

        However, I will do my best to support OS9 or "classic" or "sheep-shaved" installs

If I can support the 2D API thru OSX Quartz2d- I will look into it.<br>
(Quartz is where OSX is at these days.)


### 3D

3d will be a mix of:

        OpenGL+FContext+DelphiGL(portable)+Lazarus units

where applicable and 

        OpenGL+CodeWarrior or Lazarus/FPC/XCode

where it isnt.

(Notice that I make no attempt to rewrite this in C)


#### DelphiGL Caveat

DGL doesnt allow lower than 24bpp, nor palettes.<br>
Implementing them requires heavy understanding of Fragment Shaders and Textures(think unreal tournament).

If you just want "modern-day graphics", then focus on 3D API- <br>
and look at Game engines like "Castle". (OpenMorrowWind uses assImp/OGRE.)


#### Cheating

Valve and Unity and Unreal devs "cheat compatibility"- <br>
by using WineAPIs (instead of porting the D3D code to OpenGL).

The other WineAPIs allow them to "not know" Linux-es, "to CHEAT again" by running a windows application.<br>
There is no actual "Native Code" running- and these devs DO NOT CARE.<br>


## Build Targets

	OS9/OSX AQUA Interface and MacShell(OS9) (Intel and PowerPC macintosh)
	Win32/64 SDL via "Command Prompt" and OpenGL via Lazarus
	Lin32/64 X11/VTerm (currently missing a Pascal-based "Graphics API" and "working OpenGL routines")
	RasPi (FullScreen only) VTerm(mailroom based GPU accleration)
	Android (needs a ton of testing- and time I dont have)

-Enjoy,


-Jazz

