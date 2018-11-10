## Laz GrFX- 
An Extended SDL replacement of the "Borland Graphics Interface" (BGI)
For Lazarus/FPC 

(SEMI-PURE Pascal is used here)

A VB(visual Basic or VB.NET) - or even python- could fork from this, if needed.
-Who nose, I might even just fork it myself!


state:  **COMPILING**  -up until line 2774 in main unit.

Multiple safety and paranoia checks will still have to be done to ensure accuracy-
Those checks are not here yet- be aware of this.


This unit uses **modified** JEDI headers.

While the C Syntax is correct when utilizing SDL, the PASCAL needed some adjustment.
It makes more sense to use similar syntax, if possible.
Why this wasnt corrected and the patches released is beyond me- quite frankly thats BULLSHIT!

        "If its half-assed, its as good as NEVER DONE."
    
-A US Navy Chief


### What is it, what does it do?

Its a GRAPHICS MODE "Canvas", not unlike TCanvas. You draw with it.
There is a reason Im redoing this. 

Windows uses its own internal Canvas Routines (not the whole BGI) for those hdd pie charts, for example...

We could extend TCanvas- 

        but I dont think it will happen the way it needs to.

Also:

        Lazarus OGL demos are busted- where the Pascal SDL ones work.

I included the Pascal OGL "chapter demo" as an example to prove my point.


### Why does it exist?

Some outdated BGI code needed to be brought up to speed.

You will need **this Library** if you write strictly for graphics modes or wish to.

I intend to utilize an "everything bagel" here. 

        You may not need (or want) everything on your bagel- but Im making them that way anyways.


**This code and demos are in a very early state.**
I will try to provide further demos where possible.


So what is the BGI? and why is SDL important?


#### BGI 

(Borland Graphics Interface) According to Wikipedia-

		"BGI(Borland Graphics Interface) was accessible in C/C++ with "graphics.lib" 
		and "graphics.h", and in Pascal via the "graph" unit.

		BGI is less powerful(thier opinion) than modern graphics libraries such as SDL or OpenGL, 
		since it was designed for "presentation graphics" instead of "event-based 3D applications". 


-What is not written, however, is that the codebase was abandoned because of UI environments.

When X11 and Sin came about...there was no way to use graphics mode because it was in use.
As a result you could not write an old-school graphics mode application.


Along came SDL, DirectX, and OGL....but nobody bothered to backport the BGI.
You can learn OGL from SDL but usually the reverse is difficult.

OGL/DX9+ was OS limited. So what is SDL?



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
		However, the library is suited to building games directly or is usable indirectly by engines built on top of it.


I have noticed numberous fail points to which SDL is NOT "simple" nor "easy" and the BGI wins
in these regards. I do not write OOP level garbage, I find object code and repeated instantiation is a mess.

I have my own "methods" if I need object-related routines. They work.


#### OpenGL(3D)

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


DX9 programming experience is not necessary- 
When you see the OGL or "SDL assisted OGL" demos you will begin to understand.

I will hold your hand until we get to OpenGL.

You may also follow along here (not overly difficult once you understand SDL):

		http://wiki.lazarus.freepascal.org/OpenGL_Tutorial

#### So what about Raster(non-resizeable) graphics?

Size and speed are the reasons why you use Vector(CGI-such as here- graphics).
They also scale very well.

Raster graphics on the OTOH are much heaver(bigger), extremely more detailed, and do not scale well(pixelate).

Each has its own use. Raster are smoother, as they are composed of geometric shapes, not actual per-pixel data.
So far, SDLv1 and v2 and the BGI focus on this.

So to answer you- we are working on RASTER, then working on VECTOR later(or a combination of the two).



### Pardon the mess

Everything is in one folder for a reason.
(Dont confuse *me* -or the compiler)

The .ppu and .o are output files from the compiler. 
**You can delete these**

The .inc are mostly for SDL2.
**You will need these, "DO NOT DELETE"**

You should be able to compile this once you GIT (or Download) to your computer, so long as FPC and/or
Lazarus is installed.

This code doesnt call the LCL- but yours might. LCL errors are up to you to fix.

SDL "Pointer issues" and mem-alloc/free issue, however, need to be worked out by you.
(If the problem doesnt come from this main unit- YOU FIX IT)

I know JEDI is broken in places and I appreciate the help in fixing it.
-DO send me those changes.



### Why SDL and not...

Allegro is now on a similar path to SDL but not-so-much better maintained.
(Its also not on GH)
		
-SO NOW YOU KNOW.


#### Focus:

		Unices (red hat, fedora, Suse, ubuntu,debian,etc.)
        MacOSX
        Android(eventually)

(graphics libraries for DOS have been written by Borland, INC.)
There are some ports to Sin (windows) already using WinAPI (or Delphi). 

I use SDL v2 C and Pascal headers (JEDI) and sections included from version 1.2 in pascal.    

While we could reasonably use X11 CoreLibs, **its NOT PORTABLE** !




### Dependencies (INSTALL ME FIRST!!):

NOTE:
    
        CMake
        libudev-dev

are reccommended as some other libs depend on these. (udev is for USB devices support)

        libOpenMPT (Tracker/mikmod format "game" audio support)
        libOpen_vr (VR helmet support)

are being considered (need pascal headers)- SDL looks like it supports the IO methods.


UNIX/Lin-ux:

(preferably SDL2-)

			SDL-x.x.x.rpm 		   	-- the main SDL library
			SDL-devel-x.x.x.rpm 		-- the developer package
			SDL_image-x.x.x.rpm 		-- image library for fonts
			SDL_image-devel-x.x.x.rpm 	-- image library developer 
	
etc. There are lots of these units.

Debians and ubunt-nuts need to find the .deb(s). They use similar names.


These libaries are a standard part of most current distributions. 
The libaries will *probably already* (cross fingers) be installed. 

You may have to install the developer packages,however. 
Ive noticed also that "preinstalled" might point to version 1, not version 2.
Double check version 2 is installed.

M$FT Visual Studio "Code" can be found here:

        https://code.visualstudio.com/docs/setup/linux



Cross building to Sin(windows):

		MinGW (MINimum GNU for Windows) is probly a best bet. Go install it.
        "sudo apt-get install build essential fpc" inside bash if you are running Centennial edition or higher Win10.

        Compressed sub-units are HERE, go install SDL (and the source code headers)
            from the main site and make SURE its "version 2".

        go fetch and install both FreePascal (fpc) and Lazarus also.

        Visual Studio Installer is enclosed, but its a "rolling release" sort of application.

        Microsoft Visual Studio is over 15GB installed (YIKES!!) and unknown compatibility or syntax.


	For SIN there is a WinAPI port: http://math.ubbcluj.ro/~sberinde/wingraph/main.html
	- or you can browse the files here, which is the same thing.

	The guy seems to have a better WinAPI direct access than the FPC team, therefore his unit 
	(as per 2010) AFAIK is far superior. I doubt much has changed in FPC, all of the docs still point to JEDI
	residing on sourceforge (via PGD website). It isnt there. Its on Github (and dodgy at best.)

	This above uses WinAPI, not SDL for BGI support. So dont come beggin me for help.
	It is the windows equivalent of using X11 core libs. 

	WinDos, WinMouse, and WinCrt units I believe were rewritten in Delphi by Borland.
    The FPC equivalents should work ok.


Mac:
		
		Mac should import the necessary units via IFDEFS. Let me know if Im off.
		(Build for Linux x64 on Ubuntu at the moment.)


	OS9 was removed support years ago...not sure if it has a FPC use these days
	FPK and others had some ability to program but dont ask me where to find abandoned alpha level code.



	Otherwise you need XCode installed
		
	Setup SDL First, then FPC. 

	For SDL in C, Try the directions here: 
			
			http://lazyfoo.net/tutorials/SDL/01_hello_SDL/mac/index.php
			(You will need XCode 6.1, "Yo-sem-i-te" is assumed.)

	The IFDEFS in the Pascal code 'should' pull in everything SDL.
	There is no "Lazarus" in MacOSX, you use XCode and link in the LCL routines instead.

	I have a Mac available but Im working from a Linux box.

        Compressed sub-units are HERE, go install SDL (and the source code headers)
            from the main site and make SURE its "version 2".

        Visual Studio Installer is enclosed, but its a "rolling release" sort of application.


NOTE:

        "Lazarus on Mac" doesnt really exist, the LCL and XCode, however, DOES.
        This unit WILL NOT WORK/BUILD without XCODE, FPC and SDL installed and operating under OSX.
        

MOBILE:

     ModeList support is experimental (or non-existant) right now.
	(without this nothing works)


    Android (Java and Pascal to Java Porting) I need help with anyways.
    iDevices are impossible due to Apple OBJ-C proprietary licensure (unless you want to rewrite this unit back to OBJ-C)
	
	Once you get this down and have all your secret keys-- you should have a fine day. Eventually.
		

ALL ELSE FAILS: 
		
	Revert to SDL and its manuals, both off and online.
    DO NOT attempt to rewrite this main unit core routines, they are modelled after SDLv2.
    I am aware of the "Surface is really a Texture" code tweaks that have not been fully implemented yet.

    If you want v1 instead, then FORK ME- and get to work!! (maybe we can merge it back later as an IFDDEF)
    -I hear HedgeWars uses v1 if you are code inclined to wade thru the sources.
		
    Surface routines and PageFlipping are SDLv1, not v2. 
    My focus is version 2.


Current critical BUGS:

BUG1:

        The Modelist is incomplete. Without it- NOTHING works.
        While it CAN function, use is severly crippled right now if we tried. Better to wait.

BUG2:
    
        Some missing vars(oversight or undefined due to edits) prevent building past  90% mark
        Too many "formward declaration doesnt match...." errors otherwise- I moved code around.

BUG3:

        Palette Grey 256 is out of spec(AYE AYE AYE)....but this should be the next to last edit 
            for the "palette include" files.

        (Learn to count in HEX....)


## Why Pascal and why now and why THIS WAY?

		-Full 16, 256, RGB, and RGBA support (24BIT) up to 1080p.
		-(Free)Pascal is missing a "graphics engine". C has one.
		-TCanvas for Laz doesnt quite do the job.
		-Linux has never had a graphics engine or BGI. EVER. Only TCanvas has come close(incomplete).
		-GVision for Linux (Pascal version of Win311) never took off. Thats Obj-C, Qt or GTK youre looking at.
		-JEDI doesnt stand for what you think it does- its incomplete, missing, and now depreciated.
		-Castle engine is good, potentially missing in places things we should have and requires OpenGL knowhow.
		-X11 "core primitives" are non-portable. Mac uses Quartz and Sin uses DirectX and WinAPI.
		-If you have a better way-show me the PASCAL code, but it must get the job done (and compile).
		-Open Source is a "vague comment". It doesnt guarantee the code works, nor for you.
		-This isnt a "class project", its my passion.


#### Project Attempts to use or uses

	Simple DirectMedia Layer (www.libsdl.org).
	X11 "Core Drawing primitives" (www.x.org) [as otherwise provided by Borland, INC. for DOS]
	WinAPI (where available and documented)

	"BGI" references within "Turbo Pascal Quick Reference Book" by Que Publishing
	SDL Online reference (in C) and JEDI-SDL offline Pascal CHM reference(missing stuff) 
		
	Modified Unit hacks provided by me

#### This project cannot use:

	VESA(its already in use)
	SVGALib(its already in use)
	Framebuffer access(in use by video driver)
	Direct Video Driver access

	DOS or DPMI code(Already in 32 and 64 bit modes by kernel)

	Assembler hacks(prior Pascal code using VESA or SVGALib or direct FB access)
	INT10 or 21 code (MS DOS specific)

	Other libraries like allegro.


### The objective of this package

	 1) to enable people to run programs written using BGI or "libGraph" (C) functions 
         directly in "Linux"(Linus Torvaldis Unix). 
         
	 2) To take old code, help you execute it, learn form it, and move forward.

	 3) To teach you use of SDL- so that you can code with or in competition to it.
	 Some parts are impossible to work around(input/threads) and you need the SDL code. 
	 -So you need to know how it works.
		 

"It does not aim to be a complete graphics solution."

It DOES AIM, however to extend the existing (old-as-FUDGE) existing code to UNICES and 
make attempts and reworking and updating the code to something more recent.

I hope it is useful..yada yada yada....YMMV. 
**Read the Licence agreement.**


**This is a UNIT, not a program. See the demos provided.**



Be mindful of the initgraph (and other) header change.
Even "nil pointing" "PathToDriver" still leaves us in a window.
(If you want fullscreen--I have to ask.)

Provides(these parts should be working):

		Initgraph
		CloseGraph
		Logging(in some form)
		Put/GetPixel ops
		Get/set Color ops on pixels or "screen as a whole"
		Get/Set image file to "screen"
		Alert Boxes(butt ugly SDL, not Lazarus ones which Id prefer)
		Text functions
		Lines
		Rectagles/Squares
        Straight OGL Pyramid (tetrahedron) spinning demo

To exit the OGL demo:

        click on the terminal that called it and press a key.

Although it calls SDL, it DOES NOT invoke event handling(which is wrong) so the output window wont accept input.
(Improper use of ReadKey() and why you shouldnt use it)


Incomplete or untested:

		Input from keyboard
		Polygons
		Circles/Ellipses
		Fills(incomplete as of yet)

		More Advanced functions
		3D OGL routines(QUADS, etc)


This is from the TCanvas Demo
(patched from "Getting Started with Lazarus and Freepascal"):


Come Set Sail!
(-And yes, I will add Alpha masked layers to my next iteration of this.)


![Lazarus Boat](./boatdemo/boat.png)



### Lets run "make"....

By default the makefile compiles for :

		Win32/64
		linux 32/64 

All in one go.
If you have issues, ensure you are building from a LINUX host.
The makefile is not designed for MAC, MOBILE, nor Windows.

Although you CAN build from inside windows thru MinGW or similar TO Linux--its far easier to go the other way.

MinGW is the (assumed target) if you build this way.
I just run FPC over the main unit file right now. Nothing fancy.

I dont know how to link this thru M$FT VS without using it- it uses project files like Lazarus and Delphi.
-I havent gotten that far yet.


### DEMOS!!! LOADS OF DEMOS!!!

Demos at first will focus on BGI graphics "quality" and "basic logic".

(The othello code Ive written in the past has an excessive recursion problem)


Planned demos:


Board Games/Card Games:

	Othello, 2d chess, sorry, pente...
	Solitare, Poker, etc.
	
	
SIDESCROLLER(collision based) 2d/3d games:
    
    OpenSonic (allegro sources in C) /Mayro (SMC) remake ...
    "Super Nintendo" or "SEGA MegaDrive/Genesis" level or slightly above it. 
        
        RedBook CDROM/CDDA support is untested.

        
3D-        
   
    OpenFreeSpace??
    OpenMorrowwind/Elsewyre??
	OpenSkyRim?? 
    Open (world of) WarCraft??
    OpenStarFlight?? (Original by E-Arts was for the BGI but tweaked in assembler to use elliptic curves on an 8088.)


#### COPYLEFT
  
  
This code is a "black boxed spinoff" work written solely for FPC in Pascal.

Borland, INC. has been bought out and seems to "be no more".
Unlike Microsoft, I respect thier codebase and right to copyright.

Original code for DOS (c) Borland, INC. and reported (from C) via FreePascal (FPK) dev team, myself and a few others.
I have left reference where its due in the code. I only accept credit where its due me.



## Final NOTE:

Code is universal language of itself. 
If I can understand German or russian programmers, you can understand my english.


There REALLY REALLY isnt much to the basics, It was one file in the original TPU from Borland.
I have extended it very much and tried to clarify very bad code and manuals and C.

Learning SDL is not necessary. 
This is a BGI interface port. 

        Write for the BGI, and the code should 'just work'. (for the most part)

Seriously...the SDL syntax (in C) isnt that hard to master. 
(I can piss better C and PYTHON in my sleep-- and I refuse to write C.)


#### Have a "Final Product"??

Remember to remove debugging code and strip binaries when writing for real gaming hardware.
(Or if you are distributing your application) 

FPC Option:
 
        -Xs

option "-g" is used for debugging 

---		
	
## Basic Q and A:

Q: I just dont get it....

A: Scan thru the headers or a PASCAL REFERENCE manual for "UNIT HEADER INVOCATION".

You should only need headers to understand Pascal syntax. 
The rest is minor details unless you want to sweat those.
Same for SDL in C. (C is backwards with variables, mind you)


Q: It seems incomplete...


A: Not quite. 
Most basic functions should work- for example: initgraph.
Keep in mind the original code was very primitive.

Im not "emulating" every function. Im rewriting the "most useable".
Due to SDL quirks, some functions arent (and will never be) rewritten.
Other take some "off the shelf thinking" to implement.

I will get to the more advanced functions as time allows. 

Yes, "SDL seems incomplete". 
They dont seem to care. 
I dont think thats right of them.

I havent really looked at the castle engine yet but one can assume that since it uses FPC,
but its otherwise "feature incomplete" and they are using straight OGL.

SDL provides a bridge (to get to) OGL.
Why do it directly(PITA) when you can use "easier to use" routines?


Q: I think I found a bug!


A: Report it to me.

DO NOT SPAM. 
Ive probly discovered the issue already but havent gotten to it.
I dont want your C.

"As in foo points to variable A" is NOT pseudo-logic. Thats "C in plain english".

"foo is equal to A" 

and 

"if THIS then GO THERE"
"do while x is false"

"case X of"
"repeat ....until"

-is better.


Q: can you port for OS (xyz, game platform abc...)


A: Not unless its supported by BOTH FPC and SDL.

Languages are one thing, but dont expect me to rework this into some form of C (-which I rescued it from).
As I said: 

        BASIC
        VB
        Python 

are potential ports. (You can help me here).


OR GO Grab a FPC RTL and get hoppin.

I cant help you here, I didnt have much luck with kernel development beyond certain points.
This was mostly where the issue came from. 


I know how to do it, getting it to work is another matter.

You should have an "engine already made" to use if you want to go this route...
HAVOK, etc. etc. 


Q: Will you port to DirectX? 

A: 

Hell no. 
And WinAPI is provided thanks to someone else. USE IT. 

Maybe fork from there?

WHY would you ask me to write PROPRIETARY CODE?
SHAME ON YOU!!


What Id advise is to use a "OGL to DX API". I dont have one available.
OGL should be supported on Sin nowadays.

Mebbe try Vulkan or the GL headers. 
They are around somewhere.


Q: But this isnt useful...


A: No warrantees of...... yada yada yada...you didnt read the Licence.
Ive your not going to read, then you probably shouldnt be writing code.
Im not going to beat it into you- I have better things to do.



Q: Is this all this can accomplish?


A: Hell No.

These are baseline examples of what the BGI does and SDL certainly is far more advanced.
Ive previously written more advanced examples, potential screensavers in 256+ color modes..
etc etc.

I have to redo the BGI to get the extended support that I need- to run that code.

(The FPC code hasnt been ported in over 10 years...)
Those programs and routines were patching the BGI- as it was- already existing- for DOS.
I didnt write assembler, so the code *is* portable.


You need the baseline to establish "graphics mode" before you can add more functionality.
This is Mostly "backwards compatible" but Im not Borland and Im doing it my way.

You will probably be using alpha blending,blittering and rendering or mixed of those
and Anti-Aliased stuff I havent written for yet. 

Not a problem -but Im not there yet. 



Q: Whut? 3D? Physics? huh? The files says 'physics'...


A: Unlike the BGI, SDL uses both 2d AND 3D/OpenGL functions. 
So YES, we can and we WILL extend our code.

POSTAL2 uses SDL. I like POSTAL2.

There are two types of physics:

		Render Target (SDL engine and sprite collision)
		Physics (Math based w 3d objects)

Render Target comes first(2d). 
For the latter "think nVidia".

If you can get **HERE**  advanced game design should be a cakewalk for you.
And **THAT** is the point.



Q: Runtime errors..I get these STUPID ERRORS!


A: 

This is WIP- expect the occasional build bug. I might be break-fixing something.
(Thats life.)

Furthermore- 

        Check for a RELEASED UNIT. This indicates I tested something.

Check SDL depends for multimedia. 
(I cant control those..SDL links into them as seperate projects.)


Error 216 is usually an "out of bounds" caused by "Alloc and not Free" errors

AKA:

		You are doing something in a loop that continuously allocates (surface) ram but doesnt free it.
		-or some pointer was dereferenced (emptied) twice.


Could be also that you need to recompile Lazarus(point variance I call it-version mismatch) or build some
or all of the LCL subcomponents. THAT- I CANT help you with.


LibVLC expansion is planned but I will have to check the sources for viability.
LibFFmpeg is also available.



Q: No comprende? 


A: Libtool. (Problema.)	

There exist a way with Qt apps to do MOC (.po) or something. 
FPC has the "feature" but I dont know how to use it.

It has to do with aclocal and locales.

(They NEED A DEVELOPER.)




