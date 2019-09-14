# Laz GFX- 

A "UNIVERSAL replacement" of the "Borland Graphics Interface" (BGI) For Lazarus/FPC/GNU? Pascal<br>
Copywright (c) 2018-2019 Richard Jasmin et al



Ports are available HERE (or soon will be) for GAMBAS[Basic/VB/VB.NET]/Python/Fortran/Ada

Its a GRAPHICS MODE "Canvas", like TCanvas- only better.<br>
-You draw with it. <br>

You will need **this Library** if you write strictly for graphics modes or wish to.<br>
I will try to provide further demos where possible.

2D and 3D modes are supported.<br>
AUDIO and Networking are also supported.

3D "Scene Rendering" is limited. <br>
Try "Castle Engine" -for something more complete.

Modified "JEDI Headers" are used here. They appear to also be abandoned.

Lazarus programmers can open the lpr (DEMO) file and "get to work" now. <br>
(MANY THANK YOUs to GLContext programmer Sebastian Hütter for fixing a "major Lazarus PITA")

REMEMBER:

        This is EVENT DRIVEN INPUT, NO MATTER THE RENDER TYPE USED (MAKE NO ATTEMPT to use ReadKey/ReadLn, etc.)
        RENDERING IN A LOOP will hang input - use a Timer callback to render

### LEGAL-ese

Since I am starting to see changes in NASA/JPL and other demos out in the wild-<br>
**LEGAL DEFINITIONS and MUMBO-JUMBO MUST BE ADHERED TO**.

Licensed under Apache License, Version 2.0.<br>
(compatible with Mozilla)<br>

This statement applies to ALL CODE enclosed herein:<br>

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

The code herein is NOT LGPL LICENSED.<br>
YOU MAY NOT ATTEMPT to bypass GitHUB versioning -to circumvent this license change.

This is an original (in some places composite) BLACK-BOX work.<br>
Code was reverse engineered- solely from existing documentation.

No original Borland (or other companies code) was used during this units "manufacture".<br>
Some parts are based upon "public C sources" or "Distributed Materials" with books purchased.<br>
Said books are listed in the bibliography of "the documentation of sources".

Plagarism cannot be claimed:

        Over 90% of the written code is Original based upon "source code function-header documentation".

Reasons for License Changes:

        1- Source code redistribution of derivative works is no longer forced (GPL/LGPL licenses force it)
            You are required,however, to notify others of where to find THIS "ORIGINAL" SOURCE.

            While **extremely encouraged**, code merging(post forking) is NOT required. 
            I can be CCed changes (centralization) without other forks of this work being CCed, as well.
                    -This I prefer.

        2- I have the right to reject "Forked Code" for any reason.
        3- YOU can still (otherwise) use the code as you please. 

Examples:

        for-profit use
        business use
        proprietary use
        embedded use

Use of this source code assumes you accept the terms of this License agreement.

**This code is Copywrighted**. 

Removing ANY Copywright notices constitutes THEFT( of Intellectual Property).<br>
Code Authors reserve the right to sue under Intellectual Property laws -if Copywright notices are removed.

(Standard Attribution rules apply)

While you may not remove such notices- you may edit them to better serve a purpose:

        Shortening changelogs
        Beautifying code

YOU **MAY** use this code to serve any need- given the above named restrictions.<br>
A copy of The Apache v2 license is hereby attached and legally binding.


This unit (LazGraphics) SHOULD be ported to the same Languages that OpenGl supports, listed here:

(OpenGL Languages)[https://www.khronos.org/opengl/wiki/Language_bindings#Delphi.2FFree_Pascal_.28Object_Pascal.29]
		
		
-DONT ASK about assembler. The compiler does this for you.<br>
Assembler -in flight- does not guarantee optimized code.


So if performance is lacking(usually in math areas)- 
		
		First- 
				Use better compile time optimizations
		Second-
				Use more efficient Logic methods
                Like turning off "state tracking" until absolutely required to turn it on
		
		Third-
				Try another method of implementation like OGL/DirectX vs WinAPI/Xlib

		Fourth-
				Your computer is tto slow. Try a faster one.

Ive tried to do the second for you- as best possible.<br>
Math is not my strong-suit.(GL is riddled w 3D Matrice Math).

Try to keep the ports HERE- DO NOT FORK unnecessarily.<br>
I will be happy to import code.

---

# Ports 

More will be added as time goes on.<br>
For older PCs consider hardware hacks like USB-Floppy interfaces and CF-HDD interfaces.

Mostly these are "language ports". 

## i8086 Port (Core Reto-Tastic Original PC)

Target is 8088 to 386 based computers<br>
(This is being EMULATED for newer Computers)

**THIS REQUIRES A VERY RECENT CROSS COMPILER FROM FPC TEAM**

Graphics API from FPC team will need tweaking:

You can throw away VESA modes (int 10, 4F02) they werent supported yet.

CGA only supports 4-color, 4-plane palettes(max) and 320x200 max resolution.<br>
While we **might** be able to squeeze SDLv1 in there- (input will have to be raw), timings are critical.

TExtMode Pixel hacking - for 16 color graphics -may need to be added.<br>
The Graphics routines work(written in x86 asm from borland) and dont need to be rewritten.

FPC does NOT suffer from the "CRT.Delay() bug" that BP7 and TP7 encounter.<br>
You do NOT need to patch sources.

Minix OS is suggested (vs DOS)- I will have to PC EM Emulate an equivalent to test(threw mine away in the late 90s).

Networking (10BaseT) at 10Mips can be accomplished- dont expect much.<br>
Sound can use PC speaker- normally, or "speed hacked" -soundcards didnt exist yet.

WAV output can be forced thru the PC speaker with "Phone-like" reduction of the audio samples.<br>
Usually Audio is CPU intensive and hard to sync with video on these old systems.

(Ducktales seems unaffected)

FreeDos is being ported, but limited in use.


## GO32(v2) port 

(Target is 486+ computers)

I would say 
        use DPMI and context switch VESA LFB(if avail) when using it
        use VESA modes
        use VGA(mode13, 256 colors)
        use OPL3(if available)
        use 10BaseT Net(if available)

Consider BusyBox or minimal Linux(vs DOS)- we have FrameBuffer Graphics on these older systems.<br>
FreeDos is guaranteed to work also.<br>
DosBox -may or may not- work.

### Render-Targets

2D can use either GL or SDL.<br>
3D MUST use OpenGL/GL ES

MAY also use as a Software fallback(slow):

(Errors or very old hardware ONLY should trip this.)


### EXTERNAL LIBS warning:

This UNIT API uses several external libs-

		THIS IS HOW LINUX IS DESIGNED
		
The location of which on Windows is completely unknown.
(they could be anywhere-even missing-)

Please- lets standardize this.

OpenGL sources are being pushed thru the "DelphiGL(DGL) port machine".<br>
FreeGLUT and older XGL methods are not being used.<br>
This will require a rewrite of code(back to standards) the change was needed due to 
"timer callbacks on rendering".


### Port status

WIN32:

		Win32/64 (crossed from Linux x64) will port thru DelphiGL(DGL) - I have a book on DGL.
        SDL Port is forthcoming- shouldnt present too much difficulty(on ubuntu atm).
        Testing CAN be done thru (I prefer VFIO due to speed) WINDOWS 2K-10 under QEMU/VirtualBox

MAC:
        OSX:
            Seting up XCode is proving to be a R-PITA. The cc tools are out of date.
            Lazarus is now available (it wasnt before) for Tiger+ versions of OSX
            64/32 and Intel/PPC (quad binary) can be produced if compiled correctly (on SNOW LEOPARD)
		
		OS9:
			GL support is very limited.
			SDL1 is available, SDL2 was abandoned.
            Rendering Context can be as small as 16MB		
            MPW or CodeWeavers HAS TO BE USED to comple this(Borland era tools)			
        
Ubuntu:

**serious FPC/Lazarus distribution flaw.**

SVN (sourceforge) packages -3- can be installed or you can pull from svn trunk(preferred)

        You need Watcom(see reddit post) to cross to i8086(linker is needed)
        You need cross environment(can be difficult) setup to cross elsewhere
        Crossing to Windows or i386-linux is moderately difficult to setup
        SDL Port works(needs a rewrite), OpenGL port works(will be rewritten), OGL demos work.

Lazarus OGL Demo is the basis of the OpenGL rewrite thru DGL libs(universal port).


Mobile, etc:

        Little work has been done here, yet.

---

### Build status:

INITAL SDL1 RELEASE FREEZE some time in the past.<br>
RELEASE freeze at v.83 (BUILD SUCCESS- SDL subsystem)<br>
RELEASE freeze at v2.0 May 27th 2019 (OpenGL subsystem-core API only).

master branch: code may or may not build **UNSTABLE** (wait for release)

There are some routines not yet ported, and some completely untested.<br>
libSOIL routines are disabled at this time(image support). I will fix this.

FULL CGA, EGA, and VGA palletted modes WILL work properly(2.5 milestone?). 

**Less than bpp 24 modes Currently FAIL under OpenGL**<br>
**TEXT is being worked on for OpenGL**

Checks for windows(but not PowerPC arch) have been added.<br>

FrameBuffer support (no X11/tty) code needs some help and more thourough testing.<br>
It does NOT work with newer kernels or X11 past .13 (post the XFREE merge).<br>
It WILL WORK (accellerated) under RasPi.

---


### Technobabble


#### BGI 

(Borland Graphics Interface) 
"The Original Graphics library"

According to Wikipedia-

		"BGI(Borland Graphics Interface) was accessible in C/C++ with "graphics.lib" 
		and "graphics.h", and in Pascal via the "graph" unit.

		BGI is less powerful(thier opinion) than modern graphics libraries such as SDL or OpenGL, 
		since it was designed for "presentation graphics" instead of "event-based 3D applications". 


-What is not written, however, is that the codebase was abandoned because of UI environments.
When X11 and Sin came about...there was no way to use graphics mode because it was in use.
As a result you could not write an old-school graphics mode application.

Along came SDL, DirectX, and OGL....but nobody bothered to backport the BGI. 
Programming became difficult.

You can learn GL "basics" from SDL.


#### SDL 

(Simple Directmedia Layer) according to Wikipedia-
(This is mostly 2D with 3D hooks to OpenGL C routines)

		Simple DirectMedia Layer (SDL) is a cross-platform software development library 
		designed to provide a hardware abstraction layer for computer multimedia hardware components. 

		Software developers can use it to write high-performance computer games 
		and other multimedia applications that can run on many operating systems 
		such as Android, iOS, Linux, Mac OS X and Windows.

		SDL manages video, audio, input devices, CD-ROM, threads, shared object loading, networking and timers.
		For 3D graphics it can handle an OpenGL or Direct3D context.

		...

		SDL is extensively used in the industry in both large and small projects. 
		Over 700 games, 180 applications, and 120 demos have also been posted on the library website.

		A common misconception is that SDL is a game engine, but this is not true. 
		However, the library is suited to building games directly- 
            or is usable indirectly by engines built on top of it.


I have noticed numberous fail points to which SDL is NOT "simple" nor "easy" and the BGI wins in these regards. 
I do not write OOP level garbage, I find object code and repeated instantiation is a mess.


SDL 1 and 2  "unified sources" included- for your pleasure programming.<br>
(SDL is mostly for 2d rendering- version 2 uses the GPU vs the CPU)

SDL2_AUDIO is encountering a random Pointer bug after failing somewhere .<br>
(Im assuming it cant find the soundcard device. PortAudio/uos doesnt seem to have that problem.)

I have found that SDL is scattered to the winds, and that developing for it -is hard- because of that.<br>
But its good code to get started with.<Br>
It will give you a basic idea what - and how- things work.

OpenGL and SDL (in 3d) dont mix very well(and you lose text output), so I rewrote the entire API in GL.<br>
This has proven a pain with 2d because the methods used are old- or depreciated with GL.


#### DirectX

Your driver (hardware) should support OpenGL v2- at minimal.<br> 
If NOT- use SDL **and forgo 3D**.

DirectX programing is not necessary.<br>
If you know how- great- help port the WinAPI sources to use it.<br>
(But I dont care at this point if this is done or not.)


#### OpenGL

Again, according to Wikipedia-

"Open Graphics Library (OpenGL) is a cross-language, cross-platform, application programming interface (API) 
for rendering 2D and 3D vector graphics. 

The API is typically used to interact with a graphics processing unit (GPU), to achieve hardware-accelerated rendering.

[It] is used extensively in the fields of:

        computer-aided design (CAD)
        virtual reality
        scientific visualization
        information visualization (Presentation Graphics)
        flight simulation
        -and video games

"

QUADS refers to "2D opengl". Squares have four points.<br>
The co ordinate system- by default is FUBAR, IMHO. Ive patched it "back to sanity".

Refernece Materiels:
    
        OGL Red book
        OGL Blue book
        OGL Green book
        OGL Orange book


### So what about Raster graphics?

Size and speed are the reasons why you use Vector graphics.
They also scale very well.

Each has its own use.
Raster are smoother, as they are composed of geometric shapes, not actual per-pixel data.

Both are being worked on.

### Pardon the mess

Everything is in one folder for a reason.
(Dont confuse *me* -or the compiler)
Im working on cleaning this up. (-Fu option - no thats the compiler option, not a joke.)

You should be able to compile this once you GIT (or Download) sources to your computer, so long as FPC and/or Lazarus is installed.

This code doesnt call the LCL- but yours might. 
LCL errors are **up to you to fix**.

OGL/SDL "Pointer issues" and mem-alloc/free issues- need to be worked out by you.
Im having a hard time debugging them myself- and SDL doesnt want to co operate.


### Dependencies (INSTALL ME FIRST!!):

NO-

		Im not going to make a slimmed down API.
		If you want to- thats on you. Linux is not designed this way.

		1- im not that much of a genious
		2- linux programming has 50 ways of doing things -and none- are correct
		3- I dont know that many Linux internals(but I know enough)
		4- I would be 350 years old before finishing(even core routines)

You need development packages installed as well as the libraries themselves

libUOS is on GitHub- look for it. WE WILL BE USING IT.

**You dont need SDL nor its sources if you dont plan on using it.**

Unices:

		libudev (USB device support)
		mesa (OpenGL base)
		libSOIL (DirectDrawSurface texture loading,etc)
		xserver-xorg (X11 itself)
		xserver-xorg-drivers-VENDOR (your vendors X11 dirver)
		SDL2-x.x.x 		   			-- (SDL)
		SDL2_image-x.x.x 			-- (SDL image support)

		libPortAudio	(required backend)
		libsndfile (audio conversion)
		libMpg123  (audio conversion -mp3)
		libMp4  (audio conversion - mp4a)
		libFaad  (audio conversion -faad)
        libOpen_vr (VR helmet support)
        Synapse and/or Indy libs(Net support)
        FTGL (font support)

OSX:

Install XCode
You need X11 from here

			https://www.xquartz.org/


For SDL in C, Try the directions here: 
			
			http://lazyfoo.net/tutorials/SDL/01_hello_SDL/mac/index.php
			(You will need XCode 6.1, "Yo-sem-i-te" is assumed.)

We need to setup FPC and the LCL now. This is a process.


Sin(windows):

        Install Freepascal/Lazarus 


#### Can I have a IDE??

IDE wich understand Pascal syntax:

Lazarus(DUH)<br>
FPC "FP" application(just type 'fp' on the command line)

M$FT Visual Studio "Code"

		https://code.visualstudio.com/docs/setup/


Text Editors:

		Delphi IDE
		Geany
		XCode (once fpc is installed into it)

#### Crossing the line (cross-build):

Building for Windows from Linux:

This can be done with minimal fuss from the Makefile(if it exists)
(Test with WINE API or a VM)

Buildig on windows:

    Lazarus has a Project file now and DGL is used. It works on Windows.


	There is also a WinAPI SDL (version): http://math.ubbcluj.ro/~sberinde/wingraph/main.html	

	WARNING: 

        The colors DO NOT conform to XTerm standards, nor CGA standards-mine DO)
        WinDos, WinMouse, and WinCrt units were re-written by this guy, it seems.
        It sucks- its ancient, 3D is dodgy- but it builds.


Mac:
		
		Mac should import the necessary units via IFDEFS. Let me know if Im off.
		(Im Building for Linux x64 on Ubuntu at the moment.)

        You may need XCode for scenarios where Lazarus cannot be ran.

(Lettuce assume for now that you can run Lazarus on OSX)


MOBILE:

    (This is cross-built from Ubuntu/Debian)

    ModeList support is experimental (or non-existant) right now.
	(without this nothing works)

	Color depth is faked- its not what you think it is- on your phone.
		
    Android (Java/ "Pascal to Java Porting") I need help with. I have Android Studio installed.


    iDevices are impossible due to Apple OBJ-C proprietary licensure 
		
		(unless you want to rewrite this unit back to OBJ-C)
	
	Once you get this down and have all your secret keys-- you should have a fine day. 
	Eventually.
	ALL MOBILE CODE IS SIGNED.

ALL ELSE FAILS: 
		
	Revert to  manuals, both off and online.
    DO NOT attempt to rewrite this main unit core routines UNLESS YOU KNOW WHAT YOU ARE DOING.
    I am aware of the "Surface is really a Texture" code tweaks that have not been fully implemented yet.


### The objective of this package

        1) to enable people to run programs written using BGI or "libGraph" functions 
        directly in "Linux"(Linus Torvaldis Unix). 
        
        a)	To simplify GAME DEVELOPMENT and OS MULTIMEDIA programming
         
        2) To take old code, help you execute it, learn form it, and move forward.

        3) To teach you - 
		so that you can code with or in competition to- ME.

        4) Try to fix flaws in the old BGI (FPC team is tackling this) and add new features.


#### Where is the application?

**THERE WILL NEVER BE ONE**
**This is a UNIT, not a program. See the demos provided.**


Be mindful of the initgraph (and other) header change.
Even "nil pointing" "PathToDriver" still leaves us in a window.
(If you want fullscreen--I have to ask.)
	


#### DEMO output

![Lazarus Boat](./boat.png)

![MouseTest](./mousetest.png)

![NASA Rendered Orbits](./nasa-orbits-of-comets.png)

![Polygons](./polys.png)

![3D pyramid(Tris) ](./pyramid.png)


### DEMOS!!! LOADS OF DEMOS!!!

Demos at first will focus on BGI graphics "quality" and "basic logic".

(The othello code Ive written in the past has an excessive recursion problem)

Planned demos:

Board Games/Card Games:

	Othello, 2d chess, sorry, pente...
	Solitare, Poker, etc.

SideScrollers could be done-

        You can have fun. A few have been done (Maryo World/HedgeWars) in SDL.
	
Due to sceneGraph and complexity of OpenGL code- I am stopping here.


The main reason is this-

        Shaders!!

You stop editing output on-the-fly and start buffering pre-canned shaders! (by the millions)


3D titles like Morrowind+ (OGRE/assimp) need extreme set of OGL/OCL skills.<br>
(I am not prepared to go there at this time.)

The C is incredibly complex and difficult to read- let alone port.


## Final NOTE:

Code is universal language of itself. <br>
If I can understand German or russian programmers, you can understand my english.

There REALLY REALLY isnt much to the basics, It was one file in the original TPU from Borland.<br>
I have extended it very much and tried to clarify very bad code and manuals and BAD C.

        including several "BS-level students HOMEWORK" 

This is a BGI interface port. 

        Write for the BGI, and the code should 'just work'. (for the most part)

Seriously...the SDL (and sometime openGL) syntax (in C) isnt that hard to master. <br>
(I can piss better C and PYTHON in my sleep-- and I refuse to write C.)


#### Have a "Final Product"??

Remember to "remove debugging code -optimize- and strip binaries".


