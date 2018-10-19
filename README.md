## Laz GrFX- 
An Extended SDL replacement of the "Borland Graphics Interface" (BGI)

(For Lazarus/FPC) Written in SEMI-PURE Pascal


state: <font color='green'> COMPILING </font> (somewhat)

### What is it, what does it do?

First lets define BGI, then SDL, then the need for this code.



BGI (Borland Graphics Interface) According to Wikipedia-

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



SDL (Simple Directmedia Layer) according to Wikipedia-

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


**Expect "pure pascal functions" where possible.**


You will need this Library if you write strictly for graphics modes or wish to.

I intend to utilize an "everything bagel" here. 

You may not need or want everything on your bagel- but Im making them that way anyways.


This code and demos are in a very early state. 

I will try to provide further demos where possible.



### Pardon the mess

The .ppu and .o are output files from the compiler. 

The .inc are mostly for SDL2.

**Do not remove them.**

I have a few myself that I need.

You should be able to compile this once you GIT or DL it to your computer, so long as FPC and/or
Lazarus is installed.


This code doesnt call the LCL- but yours might. LCL errors are up to you to fix.


### 3D programming?

DX9 programming experience is not necessary- I will hold your hand until we get to OpenGL.

Lazarus supports it. SDL supports it.

For OpenGL follow along here (not overly difficult once you understand SDL):

		http://wiki.lazarus.freepascal.org/OpenGL_Tutorial

These are LCL demos but you need to build the LCL(as a whole or it cant be used).

The fastest way to do this was to build FPC from full sources, including unit folders.

Im also noticing as of late that you need to re-build Lazarus in place(YMMV w options here).

I do it within Lazarus itself and it takes minutes.

Do note the call to Vampyre libs (above OGL demos) for imagery, SDL doesnt use this method.

You will have to build these yourself and/or put them in place when units can find them.

Most prefer the FP application(console FPC UI) or Lazarus to do this for you. 

I agree. I hate "digging for units".



The OpenGL demo is busted. Maybe an FPC issue.




Allegro is now on a similar path to SDL but not-so-much better maintained.

		
Remember to remove debugging code and strip binaries when writing for real gaming hardware. 

(FPC Options: -g -Xs)




Focus:

		Unices and MacOS(graphics libraries for DOS have been written by Borland, INC.)


I use SDL v2 C and Pascal headers (JEDI) and sections included from version 1.2 in pascal.    

There are some ports to Sin (windows) already. 

Borland took up and turned to Delphi in this regards.





To use this you will need(depends on):

UNIX/Lin-ux:

(preferably SDL2-)

			SDL-x.x.x.rpm 		   	-- the main SDL library
			SDL-devel-x.x.x.rpm 		-- the developer package
			SDL_image-x.x.x.rpm 		-- image library for fonts
			SDL_image-devel-x.x.x.rpm 	-- image library developer 
	
etc. There are lots of these units.

Debians and ubunt-nuts need to find the .deb(s). They use similar names.

SuSe and Fedora wearers(its a hat) can find similar.

These libaries are a standard part of most current distributions. 

The libaries will *probably already*(cross fingers) be installed. 

You may have to install the developer packages. 




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



Come Set Sail!

(-And yes, I will add Alpha masked layers to my next iteration of this.)


![Lazarus Boat](./boatdemo/boat.png)


The makefile should work now.



Note that Windows SDL is much slower than someone elses WinAPI implementation.

(referred to below)



By default compiles for :

		Win32/64
		linux 32/64 
		

OSX/XCode may or may not build. UNTESTED as of right now.

Android I need help with anyways.



### DEMOS!!! LOADS OF DEMOS!!!


Demos at first will focus on BGI graphics "quality" and "basic logic".

(The othello code Ive written in the past has an excessive recursion problem)


Planned demos:


FLAT-

Board Games:

	Othello, 2d chess, sorry, pente...

Card Games:

	Basic Solitare, Poker, etc.
	
	
	
SIDESCROLLER(collision based) 2d/3d games:
    
    OpenSonic/Mayro remake etc. etc. etc.


        
3D-        
   
    Yet to be determined (OpenFreeSpace??)
	OpenSkyRim?? 
        
        It may seem that some "surface" routines are missing. They are not.
        SURFACE rendering is bad- you should be using the render-er.

        "Rendered Drawing" is better but as long as "Surfaces are Rendered" it is sort of a moot point. 
        This is complicated further by lack of PASCAL stable non-assembler routines otherwise available.
        I have attempted to migrate "surface code" to utilize the renderer.
        You shouldnt have to worry too much about this. This is internal SDL methodology.
        In case of overlap I will use the fastest methods. Note that Pixel ops are always slow.
        And "SLOW" is relative term. Sorry. Thats how it is.
		
The meat of the crux is this:

	Render "frames" and use "collsion sweeping"- logic enhancements. (Batch writes.)
	Do Not RenderPresent() every object(do you want a screensaver??).
  
  
  
This code is a "black boxed" FPC derivative work.


Borland, INC. has been bought out and seems to "be no more".

Unlike Microsoft, I respect thier codebase and right to copyright.

Original code for DOS (c) Borland, INC. and reported (from C) via FreePascal (FPK) dev team, myself and a few others.

I have left reference where its due in the code. I only accept credit where its due me.




I suppose if you want to- you can update TCanvas from this. 


		TCanvas is an ugly inherited mess.


The alternative is to hook into X11 primitives code in C. (which makes inverse proprietary unices only code) 

I do not know X11 accelleration(2D) hooks- dont ask.
        

		X11 is not cross-platform. OpenGL(3D) IS.


This will be ported- if need be- to windows. I can do that.

I will aim to force "console compatibility" with winDos and keyboard units support- 
        
        DO NOT LEAN ON THEM for INPUT.

        You cannot use ReadLn/ReadKey, it creates issues with EVENT-DRIVEN SDL input.
        

Write/WriteLn is ok(logging), IFF theres a Terminal to write to, and IF NOT used in a GUI application.

Thats an FPC limitation with Windows and "Lazarus mode".
	


Cross building to Sin:

		There are ways to crossbuild on one system for others. TO SIN is easier than FROM it.
		MinGW is probly a best bet. Im not working on this right now.

Mac:
		
		Mac should import the necessary units via IFDEFS. Let me know if Im off.
		(Build for Linux x64 on Ubuntu at the moment.)


MODELIST:

        This is a royal pain in the ass to maintain.
        Android, iOS, macintosh are all non-standard PC sizes.


MOBILE:

        ModeList support is experimental (or non-existant) right now.
	(without this nothing works)

	SDL says it supports mobile devices. 
	Droids and iFruits will have to be tested seperately. 
		
	Once you get this down and have all your secret keys-- you should have a fine day. Eventually.

	iFruit (iPhone/iPad)  may never be supported due to  SDK limitations "forbiding linked source code". 
	SORRY.
		

SIN(windows):

For now-

	For SIN there is a WinAPI port: http://math.ubbcluj.ro/~sberinde/wingraph/main.html
	(yes, I have the files)

	The guy seems to have a better WinAPI direct access than the FPC team, therefore his unit 
	(as per 2010) AFAIK is far superior. I doubt much has changed in FPC, all of the docs still point to JEDI
	residing on sourceforge (via PGD website). It isnt there. Its on Github (and dodgy at best.)

	^^ The above uses WinAPI, not SDL for BGI support. So dont come beggin me for help.
	It is the windows equivalent of using X11 core libs I believe. They are fast, indeed.
		
		
	I use SDL for the BGI interface port here. HUGE difference.
	(But- the C may be slow in places, where WinAPI AKA assembler isnt.)

	WinDos, WinMouse, and WinCrt units I believe were rewritten in Delphi by Borland.
	Im not writing on this platform curently so I cant test against them. They should work.


ALL ELSE FAILS: 
		
	Revert to SDL and its manuals.
	The SDL 2.0 wiki is a wiked mess if you try to DL it and there is no PDF -- the devs dont care.
		
		

Macintosh:

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

Incomplete or untested:

		Input from keyboard
		Polygons
		Circles/Ellipses
		Fills(incomplete as of yet)
		More Advanced functions
		3D OGL routines(OGL surface is enabled-code isnt there yet)


---		
	
## Basic Q and A:

Q: I just dont get it....


A: Scan thru the headers or a PASCAL REFERENCE manual to further inderstand invocation.
These are slim for FPC/LAZARUS but plenty available for PASCAL.

You should only need headers to understand Pascal syntax. 
The rest is minor details unless you want to sweat those.
Same for SDL in C. (C is backwards with variables, mind you)

Q: It seems incomplete...


A: Not quite. 
Most basic functions should work- for example: initgraph.
Keep in mind the original code was very primitive.

Im not "emulating" every function. Im rewriting the "most useable".
Due to SDL quirks, some functions arent (and will never be) rewritten.


I will get to the more advanced functions as time allows. 
Just follow along with the SDL/OGL or Lazarus examples so far. 
You will know where Im heading.

Yes, SDL seems incomplete. 
They dont seem to care. 
I dont think thats right of them.

I havent really looked at the castle engine yet but one can assume that since it uses FPC,
that its otherwise "feature incomplete" and they are using straight OGL.

SDL provides a bridge (to get to) OGL.

Why do it directly(PITA) when you can use easier to use routines?


Q: I think I found a buggie!


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

is better.

Q: can you port for OS (xyz, game platform abc...)


A: Not unless its supported by BOTH FPC and SDL.

Thats up to you. Grab a FPC RTL and get hoppin.

I cant help you here, I didnt have much luck with kernel development beyond certain points.
This was mostly where the issue came from. 
I know how to do it, getting it to work is another matter.

You should have an "engine already made" to use if you want to go this route...
HAVOK, etc. etc. 

Q: Will you port to DirectX? 


A: Hell no. And WinAPI is provided thanks to someone else. USE IT. Maybe fork from there?

WHY?
Thats Proprietary. 
Its also not OPEN SOURCE.

This is an OPEN SOURCE UNIT(s).


What Id advise is to use a "OGL to DX API". I dont have one available.
OGL should be supported on Sin nowadays.

Mebbe try Vulkan or the GL headers. 
They are around somewhere.


Q: But this isnt useful...


A: No warrantees of...... yada yada yada...you didnt read the Licence.
Ive your not going to read, then you probably shouldnt be writing code.



IF YOU FORK- GIVE ME YOUR CHANGES!
Sometimes people find vast improvements and they should be shared.




Q: Is this all this can accomplish?


A: Hell No.

These are baseline examples of what the BGI does and SDL certainly is far more advanced.
Ive previously written more advanced examples, potential screensavers in 256+ color modes..
etc etc.

I have to redo the BGI to get the extended support I need- to run that code.

(The FPC code hasnt been ported in over 10 years...)

You need the baseline to establish "graphics mode" before you can add more functionality.
Mostly backwards compatible but Im not Borland and Im doing it my way.

You will probably be using alpha blending,blittering and rendering or mixed of those
and Anti-Aliased stuff I havent written for yet. 

Not a problem but Im not there yet. 
SDL supports it.

You will see comparitive code in the Lazarus OGL demo in case you get confused about rendering.

We will start with 2d games and logic before moving onto 3d.


Q: Whut? 3D? Physics? huh? The files says 'physics'...


A: Unlike the BGI, SDL uses both 2d AND 3D/OpenGL functions. 
So YES, we can and we WILL extend our code.

POSTAL2 uses SDL. I like POSTAL2.

There are two types of physics:

		Render Target (SDL engine and sprite collision)
		Physics (Math based w 3d objects)

Render Target comes first(2d). 
For the latter "think nVidia".

If you can get *HERE*  advanced game design should be a cakewalk for you.
And THAT is the point.

You like Jazz? Call it the "SAX [physics] Engine"...he he he...


Q: Runtime errors..I get these STUPID ERRORS!


A: 

This is WIP- expect the occasional build bug. I might be break-fixing something.
(Thats life.)


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


Code is universal language of itself. 
If I can understand German or russian programmers, you can understand my english.



## Final NOTE:

		There REALLY REALLY isnt much to the basics, It was one file in the original TPU from Borland.
		I have extended it very much and tried to clarify very bad code and manuals and C.

		Learning SDL is not necessary. 
		This is a BGI interface port. 

		Write for the BGI, and the code should 'just work'. (for the most part)


Seriously...the SDL syntax isnt that hard to master. 
(I can piss better C and PYTHON in my sleep-- and I refuse to write C.)

