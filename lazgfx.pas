Unit LazGFX; 

{
A "fully creative rewrite" of the "Borland Graphic Interface" in SDL(and maybe libSVGA) (c) 2017-18 (and beyond) Richard Jasmin
-with the assistance of others.

LPGL v2 ONLY. 
You may NOT use a higher version.

Commercial software is allowed- provided I get the backported changes and modifications.
I dont care what you use the source code for- just give me credit.

You must cite original authors and sub authors, as appropriate(standard attribution rules).
DO NOT CLAIM THIS CODE AS YOUR OWN and you MAY NOT remove this notice.

GetText .po can handle translations- if you know how to use it. 
I dont. YET.
Thats the joke at the end of the README.

Although designed "for games programming"..the integration involved by the USE, ABUSE, and REUSE-
of SDL and X1Core/WinAPI highlights so many OS internals its not even funny.

Anyone serious enough to work with SDL on an ongoing basis- is doing some SERIOUS development,
moreso if they are "expanding the reach" of SDL using a language "without much love" such as FreePascal/Lazarus.
}

interface
{
-DONT RUN A LIBRARY..link to it.
-Anonymous C kernel dev (that runs a library)

This is not -and never will be- your program. Sorry, Jim.
RELEASES are stable builds and nothing else is guaranteed. See the DEMOs for details.

The quote that never was- 

"Linus: Dont tell me what to do.
I write CODE for a living. 
Everything is mutable."


FIXME: Logging and dialogs are more for testing SDL than for when you want things to just work.
So expect me to rem the code out- use these "if shit is inconsistently fucked and you dont know why".
We will however, log anyways (where appropriate-at least)

This become one of those- "Do I want to see the output window or not" things.


Some notes before we begin:

There are two ways to invoke this-
1- with GUI and Lazarus

Project-> Application (kiss writeln() and readln() goodbye)
You can only log output.

2- without GUI/Lazarus as a Console Application
Project-> Console App or
Project-> Program

Set Run Parameters:
"Use Launcher" -to enable runwait.sh and console output (otherwise you might not see it)

-This was the old school "compiler output window" in DOS Days.
-Yes, Im that old.



-One uses Classes and CThreads, the other doesnt.(This unit will suck in CThreads.)
This method offers a Console output and Readln() writeln().
What you wont get is the LCL and components and nice UI- but we are using SDL for that.
:-P


While Id reccommend the 2nd method- Lord knows what you are using this for.
Most Games (and Game consoles dont have a debugging output window)

-THIS CODE WILL CHECK WHICH IS USED and log accordingly.

---

we need to switch to Texture ops (where possible), not Surface ones and take full use of the GPU.
The conversion is underway from SDL1.2 to 2.0

TODO:

(createTextureFromSurface must use surface^.format -of chosen bpp- or it could be off)
(The bpp limitation is intentional with this unit due to backward compatibility)

Should leave just: 

window
renderer

layers active- 
freeing a lot of ram if surface ops arent needed, and limiting to one texture- if needed

We will have some limits:

        Namely VRAM
        Because if its not onscreen, its in RAM or funneled thru the CPU somewhere...
        You might have 12Gb fre of RAM, but not 256mb of VRAM. 

        Older systems could have as less as 16MB VRAM, most notebooks within 5-10 years should have 256.
        The only way to work with these systems is to clear EVERYTHING REPEATEDLY or use CPU and RAM to your advantage.
        (There is a way..)

This code was a mess because of SDL1.2 implementation all over the place.
Many dont understand its use- then get thrown and force fed SDL2.x and GPU_ opcodes.
I am working on cleaning this up. Lord knows I was confused.

How to write good games:

SDL1.2 (learn to page flip)
SDL2.0 (renderer and "render to textures as surfaces")
SDL_GPU
OGL_SDL (assisted)
OGL (straight)
O-AL (audio)

You need to know:

        event-driven input and rendering loops (forget the console and ReadKEY)

---

There is a lot of plugins for SDL/SDLv2 and that initially confused the heck out of me.
Most of those were ported to FPC by JEDI team. I have cleaned that mess up, except for depends.

        SDL Extensions:

                SDL(2)_Image
                SDL(2)_gfx
                SDL(2)_net
                SDL(2)_rtf
                SDL(2)_TTF

mercurial repo(in case you cant find it):

        http://hg.libsdl.org/


SDL_Image is JPEG, TIF, PNG support (BMP is in SDL(core) v1.2)
SDL_GFX is supposed to utilize mmx and better use the GPU. 
The rest of the routines ARE USED.

If you are using non-unices you will need to install these packages or build the sources to get the compiled units.
Im looking for the latter but sometimes I get the sources instead. Sorry.
However, THE MAIN THING is that we can use them as soon as the "INTERFACE" code is written(HERE).


Nexiuz and Postal2 use SDL.
Hedgewars uses SDL v1.2, iirc...

The difference between an ellipse and a circle is that "an ellipse is corrected for the aspect ratio".


TODO: 

    split this unit out- everything is "here" and should be seperate units.
    get tris and circles and elippses working
    aspect stretching??? (SDL can handle some of this internally)

FONTS:

    I have some base fonts- most likely your OS has some - but not standardized ones.
    We do NOT use bitmapped fonts- we use TTF.
    In many ways this is better.
    SDL_gfx has a 8x8 font embedded into the code headers. I will tap it for the missing pattern data.


This code is Useful when you need VESA modes but cant have them because X11, etc. is running.
This code **should** port or crossplatform build, but no guarantees.

SEMI-"Borland compatible" w modifications.

Lazarus graphics unit is severely lacking...use this instead.
Most of these functions(Text, polygons) are actually implemented in FPC (LCL) TCanvas 

The FPC devs assume you can understand OpenGL right away...
I dont agree w "basic drawing primitives" being an objectified mess.


SDL and JEDI have been poorly documented.

1- FPC code seems doggishly slow to update when bugs are discovered. Meanwhile SDL chugs along in C.
(Then we have to BACKPORT the changes again.)

2- I have no way to know if threads requirement is met(seems so) that SDL v1.2 libGraph units in C are encountering.

3- The "pascal/lazarus graphics unit" changes as per the HOST OS. 
Usually not a problem unless doing kernel development -but its an objective Pascal nightmare.
(too many functions are wrapped). 

SDL fixes this for us. 


SDL support adds "wave, mp3, etc" sounds instead of PC speaker beeping
(see the 'beep' command and enable the module -its blacklisted-on Linux) 
and adds mouse and joystick, even haptic/VR feedback support.

However, "licensing issues" (Fraunhoffer/MP3 is a cash cow) -as with qb64 which also uses SDL- wreak havoc on us. 
Yes- I Have a merge tree of qb64 that builds, just ask...

The workaround is to use VLC/FFMpeg or other libraries. 
I may in fact choose this over SDL Audio functions.


Linear Framebuffer is virtually required(OS Drivers) and bank switching has had some isues in DOS.
A lot of code back in the day(20 years ago) was written to use "banks" due to color or VRAM limitations.
The dos mouse was broken due to bank switching (at some point). 

The way around it was to not need bank switching-by using a LFB. 


CGA as implemented here is actually mCGA(pre-VGA 16 color mode).
True CGA is 4plane-4color mode (and its butt ugly).
 
It was designed for early GREEN and ORANGE monitors and 4 color monitors that had some limits.
As such-also due to "ROM bugs", some "yellows" were actually "oranges".

Full compatibilty CGA will require a lot of aspirin and "funky math" as well as code rewrites Im not ready for.
The idea is that the code otherwise works.

THIS CODE is written for 32 AND 64 bit systems.
TP code has a 32bit Overlay-> VM patching unit. 
(I suggest you use it. )

16 Bit systems will have to use code hacks and function relocation definitions as like the original hackish Borland unit used. 
Memory addressing MMU/PMU, etc. allows such things that Borland Pascal does not anymore.

Apparently the SDL/JEDI never got the 64-bit bugfix(GitHub, people...).
(A longword is not a longword when its a QWord...)

USERFIXME: Error 216 usually indicates BOUNDS errors(memory alloc and not FREE--a "memory leak")

----

Colors are bit banged to hell and back.

SDL_Color=record (internal definition)

	r:byte; //UInt8 in C
	g:byte;
	b:byte;
	a:byte; 

end;

^SDL_Color/PSDL_Color = PUInt8 or ^UInt8; (BytePtr)


2 byte take up a WORD(unused)
4 byte take up a longword/DWord(full rgb tuple plus a or i)
8 bytes take up a QuadWord

24 bit and awkward modes:
Tuples (just RGB values) dont exist in Pascal(or C).Its a Python Thing.
The closest we have is a "record and a pointer to one", or an "array of one".


---
4bit(16)->8bit(256):

just use the first 16 colors of the palette and add more colors to it
its easier to not do 4bit conversion, but use 8bit color and convert that.

- is it possible the original 16 colors can point elsewhere- yes, 
but that would de-standardize "upscaling the colors"

Downsizing bits:

-you cant put whats not there- you can only "dither down" or "fake it" by using "odd patterns".
what this is -is tricking your eyes with "almost similar pixel data".


32bit to 16bit RGB 565:
//drop the LSB

NewR: = R shr 3;
NewG: = G shr 2;
NewB: = B shr 3;
NewA:=$ff;

16bit can also be 15bit color:

(in mode 5551- we throw the A bit away. 
shr 3 on all bits- "a one-bit alpha layer" is hard to write code for.)


RGB16->32:

NewR: =shl 3
NewG: =shl 2
NewB: =shl 3 
NewA:=A;

color math:

        We are using SDL to do this hacking for us.

//to get the longword
myColor := (R or G or B or A);

//to break down into components using RGBA mask(ARGB is backwards mask)

Red := (myColor    and 0xFF000000);
Green := ((myColor and 0x00FF0000) shr 8);
Blue := ((myColor  and 0x0000FF00) shr 16);
Alpha := ((myColor and 0x000000FF) shr 24);


(try not to confuse BIT with BYTE here)

8bit is paletted RGB 
(for our use- so is anything less-we ignore alpha-bits here to ease programming hell)
(AN odd mobile color map is 332 (8-bit) RGB)

15 bit is "a 16bit hack" or "ignorance of the alpha-bit" (in 5551 mode)
16 bit color mode is one of: 5551 or more commonly 565 "unpaletted" RGB (data needs to converted to/from this mode)
24bit color data is often stored (when lesser or higher modes are desired).

The only "TRUE COLOR mode" is 32bpp. 
While 24bit is "effectual" and beyond most eyes to discern, its not TRUE Color mode. Its missing bits.


What this means is that for non-equal modes that are not "byte aligned" or "full bytes" (above 256 colors) 
you have to do color conversion or the colors will be "off".

which means get and put pixel ops, file load and save ops have to take this into account.
Its another necessary nightmare if not using 32bit or paletted 256 modes.

Post 1990s/2000s movies are shot with YUV (COMPOSITE RED,green,blue cable) and converted on the fly.
HDMI standard is "modified encrypted ethernet"(HDCP) with this YUV data.
(Something about yielding better chroma/luminance of colors, etc etc...)

YUV data has to be converted on-the-fly to be useful.

---


Note the HALF-LIFE/POSTAL implementation of SDL(steam):

    start with a window
    set window to FS (hide the window)
    draw to sdl buffer offscreen and/or blit(invisible rendering)
    renderPresent  (making content visible)

this IS the proper workflow.

Something to be aware of:

Most Games use transparency(PNG) for "invisible background" effects.
-While this is true, however, BMPs can also be used w "colorkey values".


-for example:

SDL_BlitSurface (srcSurface,srcrect,dstSurface,dstrect);
SDL_SetColorKey(Mainsurface,SDL_TRUE,DWord);


PNG can be quantized-
Quantization is not compression- its downgrading the color sheme used in storing the color
and then compensating for it by dithering.(Some 3D math algorithms are used.)
(Beyond the scope of this code)

PNG itself may or may not work as intended with a black color as a "hole".This is a known SDL issue.
PNG-Lite may come to the rescue- but I need the Pascal headers, not the C ones.


Not all games use a full 256-color (64x64) palette
This is even noted in SkyLander games lately with Activision.
"Bright happy cheery" Games use colors that are often "limited palettes" in use.

Most older games clear either VRAM or RAM while running (cheat) to accomplish most effects.
        RenderClear() -does this

Most FADE TO BLACK arent just visuals, they clear VRAM in the process.

Fading is easy- taking away and adding color---not so much.
However- its not impossible.

    you need two palettes for each color  :-)  and you need to step the colors used between the two values
    switching all colors (or each individual color) straight to grey wont work- the entire image would go grey.
    you want gracefully delayed steps(and block user input while doing it) over the course of nano-seconds.



Color Modes:

BPP 	 COLORS
4		(16)
8		(256)

15		(32768) "thousands" - no alpha
16		(65536) "thousands" -w or wo alpha 

24		(16,777,216) -TRUE COLOR mode "millions" - no alpha
32		(4,294,967,296) --(TRUE COLOR(24) plus full alpha-bit)

Not yet supported:

30		(1,073,741,824) --DEEP color "billions"
36		(68,719,476,736) --DEEP color
48		(281,474,976,710,656) --VERY DEEP color "trillions" 

64      ????

Common Resolutions:

RES							BPP Supported
320x200 					4/8bpp
320x240 					4/8bpp

640x480 					4/8/16bpp
800x600 					4/8/16bpp

1024x768 					8/16/24bpp
FlatPanels(1366x768)		8/16/24bpp

720p(1280x720)				8/16/24bpp
1366x768  					8/16/24bpp
1280x1024 					8/16/24bpp
1080p(1920x1080) 			8/16/24bpp

These are weird: (its 4K but not 4K...)
2k (3840x2160)  			8/16/24bpp


Not Supported(SDL Limit):
4k (7680x4320) 				8/16/24/30/36bpp
8k (?? x ??)                8/16/24/30/36/48


I havent added in Android or MacOS modes yet.
You cant support portable Apple devices. Apple forbids it w FPC.

---

**CORE EFFICIENCY FAILURE**:

Pixel rendering (the old school methods)

We have to "lock pixels" to work with them, then "unlock pixels" and "pageFlip". 
Texture rendering(SDL2) uses the VRAM for ops -whereby SDL1 uses RAM and CPU(Surfaces).

rendering is a one-way street, however.

Our ops are restricted, even yet to "pixels" and not groups of them.
TandL is a "pixel-based operation".

There may be bugs in my math. I havent checked yet.
(I cant be as bad as -"multiplying (safely) your tokens on ETH/EXP by zero", though.)


MessageBox:

With Working messageBox(es) we dont need the console.

InGame_MsgBox() routines (OVERLAYS like what Skyrim uses) still needs to be implemented.
FurtherMore, they need to match your given palette scheme.

I will provide the extended asciii-ish character set to work with.

GVision, routines can now be used where they could not before.
GVision requires Graphics modes(provided here) and TVision routines be present(or similar ones written).
FPC team is refusing to fix TVision bugs. 

        This is wrong.

debugging(captains log):
        
        All SDL functions should be logged. 

Some idiot wrote the logging  code wrong and it needs to be updated for FILE STREAM IO.
Logging will be forced in the folowing conditions:

    under windows LCL is checked for- this is a known Lazarus issue.
    under linux with LCL compiled in-caller isnt a console or VT or Xerm (usually)


Code upgraded from the following:

	original *VERY FLAWED* port (in C) coutesy: Faraz Shahbazker <faraz_ms@rediffmail.com>
	unfinished port (from go32v2 in FPC) courtesy: Evgeniy Ivanov <lolkaantimat@gmail.com> 
	some early and or unfinished FPK (FPC) and LCL graphics unit sources 
	SDLUtils(Get nad PutPixel) SDL v1.2+ -in Pascal
    JEDI SDL headers(unfinished) and in some places- not needed.
    libSVGA Lazarus wiki found here: http://wiki.lazarus.freepascal.org/svgalib
    libSVGA in C: http://www.svgalib.org/jay/beginners_guide/beginners_guide.html
    StackExchange in C/CPP (the where is documented)

manuals:
    SDL1.2 pdf
    Borland BGI documentation by QUE Publishing ISBN 0880224290
    TCanvas LCL Documentation (different implementation of a 'SDL_screen') 
    Lazarus Programming by Blaise Pascal Magazine ISBN 9789490968021 
    Getting started w Lazarus and FP ISBN 9781507632529
    JEDI chm file
	TurboVision(TVision) references (where I can find them and understand them.)


NOTE: All visual rendering routines are 'far calls' if you insist building for DOS.
(I really cant help you if you do, but dont drop 32+ cpu support. I will merge the code if you fpfork it, however.)



to animate- screen savers, etc...you need to (page)flip/rendercopy and slow down rendering timers.
(trust me, this works-Ive written some soon-to-be-here demos)


bounds:
   cap pixels at viewport
   off screen..gets ignored but should throw an error- we should know screen bounds.
   (zoom in or out of a bitmap- but dont exceed bounds.) 


on 2d games...you are effectively preloading the fore and aft areas on the 'level' like mario.
there are ways to reduce flickering -control renderClear and RenderPresent. 

the damn thing should be loaded in memory anyhoo..
what.. 64K for a level? cmon....ITS ZOOMED IN....

  Move (texture,memory,sizeof(texture));


Palettes:

   These are mostly standardized now.
   Max colors in a palette are always 256, unless in modified CGA modes- then 16. 
   Specify each value or leave it as a zero
  
  See the included file from Super Mario in TP7.
  It very similar method.

  Note "the holes" can be used for overlay areas onscreen when stacking layers.
  The holes are standardized to xterm specs. I think theres like 5.


I wonder if DirectX .DDS files are SDL Surfaces in disguise??? HMMMM....
(There is a C library to load ANY texture into RAM and work with all types of them.)
Im betting they are "not off by much".
Im seeing a Ton of correlation between OGL/SDL and DirectX (and people think there isnt any).


NOTE:

OpenGL bug:
"Rendering onto more than one windows renderer can cause issues"

SDL bug:
"You must render in the same routine that handles input(only in the main program-this is a library)"

SDL routines require more than just dropping a routine in here- 
    you have to know how the original routine wants the data-
        get it in the right format
        call the routine
        and if needed-catch errors.

The biggest problem with SDL is "the bloody syntax".
This is why the code is taking so long.


SDL is not SIMPLE. 
The BGI was SIMPLE.

SemiDirect MultiMedia OverLayer - should be the unit name.

 --Jazz (comments -and code- by me unless otherwise noted)

}


uses

//there are parts of SDL that we can get rid of. 
//They are hard to read, seem to be wrapped "do nothing routines", etc.

//aka Threads and EventCallback hooks-Pascal(C too as it were..) has its own faster itnernals.
//we link into a lot of C- but still...

//Threads and fpfork(forking), requires baseunix unit
//cthreads has to be the first unit in this case-it so happens to support the C version.

//if we need to use one or the other- 
//  we will use CThreads. Currently the syntax is for "Pascal Threads".


    cthreads,cmem,ctypes,sysUtils,{$ifdef unix}baseunix,{$endif}

//cint,uint,PTRUint,PTR-USINT,sint...etc.

	
// A hackish trick...test if LCL unit(s) are loaded or linked in, then adjust "console" logging...

{$IFDEF MSWINDOWS} //as if theres a non-MS WINDOWS?
      MMsystem, //audio subsystem
{$ENDIF}


  {$IFDEF LCL}
    {$IFDEF MSWINDOWS}
      {$DEFINE NOCONSOLE }
    {$ENDIF}
    //LCL is linked in but we are not in windows. Not critical. If you want output, set it up.
      LazUtils,  
  {$ENDIF}

//cant use crtstuff if theres no crt units available.

//its possible to have a Windows "console app" thru FPC,
//just not thru Lazarus(I wish Linux was the same way, its not).
//This may have to do with how the window rendering code(WinAPI) is initd.

{$IFNDEF NOCONSOLE}
    crt,crtstuff,
{$ENDIF}

//if you build with the LCL (you get rid of the ugly ass SDL dialogs):

//Linux NOTE:
//  Lazarus Menu:  "View" menu, under "Debug Windows" there is an entry for a "console output" 

//however, if you are in a input loop or waiting for keypress- 
// you will not get output until your program is complete (and has stopped execution)


// In this case- Lazarus Menu:   Run -> Run Parameters, then check the box for "Use launching application".
// (You may have to 'chmod +x' that script.)

// you will have to setup and manage "windows" yourself, and handle dialogs accordingly.
//HINT: (its the window with the dots on it inside Lazarus)

//the backend is straight pascal w hooks for "Lazarus windowed objects".
//(QtCreator(QT) uses similar for C/C++.)



//to build without the LCL:

// Just make a normal "most basic" program and call me or SDL directly in your "uses clause".

// You will find that the LCL may be a burden or get in your way- 
//we dont really use the fundamentals of OBJFPC, OBJPAS, or Lazarus beyond basic functions.



//FPC generic units(OS independent)
  SDL2,SDL2_Image,SDL2_TTF,SDL2_mixer,strings,typinfo,math,logger

//GL, GLU - not used yet, but works.

//SDL2_gfx is untested as of yet. functions start with GPU_ not SDL_. 
//The entire SDL is NOT duplicated there. gfx is "specific optimized routines"

{$ifdef debug} ,heaptrc {$endif} 

//sdl2_net 

//UDP or TCP?? and port number??
//there is a process to using net- check that unit.


//Carbon is OS 8 and 9 to OSX API
{$ifdef mac} 
  ,MacOSAll
{$endif}

//Cocoa (OBJ-C) is the new API
//OSX 10.5+
{$ifdef darwin}
	{$linkframework Cocoa}
    {$linklib SDLimg}
    {$linklib SDLttf}
    {$linklib SDLnet}
	{$linklib SDLmain}
	{$linklib gcc}

//also requires:
//mode objpas
//modeswitch objectivec2

//-This code is not objectified in these units- that is an internal fpfork that hasnt happened yet.


//iFruits, iTVs, etc:
// {linkframework CocoaTouch} -- but go kick apple in the ass for not letting us link to it.
// not legally, anyway....

{$endif}


//Altogether- we are talking PCs running OSX, Windows(down to XP), and most unices.
//OS 8 and 9 were kicked with sdl1.2 v14 and sdl 2.0

//and Some android (as a unice sub-derivative)

;

{
NOTES on units used:

crt is a failsafe "ncurses-ish"....output...
crtstuff is MY enhanced dialog unit 
    I will be porting this and maybe more to the graphics routines in this unit.


mac- is a hairy mess but "try to do something".
most may support the following up and coming xlib fpfork.

droid isnt here(yet)
sin has been done -(but no reason we CANT redo it)


FPC Devs: "It might be wise to include cmem for speedups"
"The uses clause definition of cthreads, enables theaded applications"

There is a way to use SDL timers, signals and threads,however, "Compiler reserved words" forbid us using these.
(screw you too,C devs....)


mutex(es):

The idea is to talk when you have the rubber chicken or to request it or wait until others are done.
Ideally you would mutex events and process them like cpu interrupts- one at a time.

-Moreso for the event handler-
(creating a window apparently trips like 5 events??)


sephamores are like using a loo in a castle- 
only so many can do it at once, first come- first served
- but theres more than one toilet

}


type  


//direct center of screen modded by half length of the line in each direction.
//verticle line: use y, not x
//centered: (((x mod 2),(y mod 2)) - ((x1-x2) mod 2))

//this is per Pixel line ops.
//line types:  line_styles=( SOLID_LINE, DOTTED_LINE, CENTER_LINE, DASHED_LINE, USERBIT_LINE );


//drawing width of lines in pixels
//due to changes in pixel sizes- I let them get very FAT.

//how BIG is a pixel? its smaller than you think. 
//You are probly used to "MotionJPEG Quantization error BLOCKS" on your TV- those are not pixels. 
//Those are compression artifacts after loss of signal (or in weak signal areas). 
//That started after the DVD MPEG2 standard and digital TV signals came to be.


//right idea, wrong implementation of this
  linestyles=( NormalWidth  = 1,
  WideWidth = 3,
  ThickWidth =5,
  VeryThickWidth =7,
  VeryVeryThickWidth=9);

//C style syntax-used to be a function, isnt anymore.
  grErrorType=(OK,NoGrMem,NoFontMem,FontNotFound,InvalidMode,GenError,IoError,InvalidFontType);

//Pascal defines:
//memAllocError =
//FNF=error 2
//IoERROR=

  TArcCoordsType = record
      x,y : word;
      xstart,ystart : word;
      xend,yend : word;
  end;

//for MoveRel(MoveRelative)
  Twhere=record
     x,y:word;
  end;


//graphdriver is not really used half the time anyways..most people probe.
//these are range checked numbers internally.

	graphics_driver=(DETECT, CGA, VGA,VESA); //cga,vga,vesa,hdmi,hdmi1.2


//This is a 8x8 (or 8x12) Font pattern (in HEX) according to the BGI sources
//(A BLITTER BITMAP in SDL)

   FillSettingsType = (clear,lines,slashes,THslashes,THBackSlashes,BackSlashes,SMBoxes,rhombus,wall,widePTs,DensePTS);
//Borland VGA256 sources (expansion pack) has the deatils-which are temporarily outside of this repo ATM

{

Modes and "the list":

byte because we cant have "the negativity"..
could be 5000 modes...we dont care...
the number is tricky..since we cant setup a variable here...its a "sequential byte".

yes we could do it another way...but then we have to pre-call the setup routine and do some other whacky crap.


Y not 4K modes?
1080p is reasonable stopping point until consumers buy better hardware...which takes years...
most computers support up to 1080p output..it will take some more lotta years for that to change.


}


{$INCLUDE palettesh.inc}
{$INCLUDE modelisth.inc}

//color conversion procs etc...taking up waay too much room in here...
{$INCLUDE colormodsh.inc}


//This is for updating sections or "viewports".

var

//I doubt we need much more than 4 viewports. Dialogs are handled seperately(and then removed)

  texBounds: array [0..4] of PSDL_Rect;
  textures: array [0..4] of PSDL_Texture;

  somelineType:linestyles;
//you only scroll,etc within a viewport- you cant escape from it without help.
//you can flip between them, however.

//think minimaps in games like Warcraft and Skyrim


{ I think Im going to leave this as an excercise to the user rather than dictate archane methods.

SDL Events fire after EVENT variable is assigned a pointer and either polling or event checking is enabled.
NOT UTIL- so we should be "safe" to not check input until the user program calling us needs it.

THAT SAID:

    initgraph enables the event handler.

So you need some sort of input (and window event) detection in your code SETUP --BEFORE calling initgraph.
SDL will work-you just wont be able to process input correctly, or do anything.

SDL will close the app and at the window managers request(I hope) without direct code intervention.
But- its unsafe to assume things.

This is like "interrupt based kernel programming"- DO NOT code as if "waiting on input"- 
    pray it happens, continue on- if it doesnt.

(events may still yet fire)

	KeyDownEventDefault:KeyDownEvent; //dont process here
	PauseRoutineDefault:PauseRoutine;  
	ResumeRoutineDefault:ResumeRoutine; 
	escapeRoutineDefault:escapeRoutine;  // a 'pause' button

	KeyUpEventDefault:KeyUpEvent; //should be processing here
	MouseMovedEventDefault:MouseMovedEvent;
	MouseDownEventDefault:MouseDownEvent;
	MouseUpEventDefault:MouseUpEvent;
	MouseWheelEventDefault:MouseWheelEvent;
	MinimizedDefault:Minimized; //pause
	MaximizedDefault:Maximized; //resume
	FocusedDefault:Focused; //resume
	Lost_FocusDefault:Lost_Focus; //pause
}

const
   //Analog joystick dead zone 
   JOYSTICK_DEAD_ZONE = 8000;
   //joysticks seem to be slow to respond in some games....

var

    chunk: PMix_Chunk; 
    music: PMix_Music;

    eventLock: PSDL_Mutex;
    eventWait: PSDL_Cond;
    video_timer_id: PSDL_TimerID;

    palette:PSDL_Palette;
    where:Twhere;
	quit,minimized,paused,wantsFullIMGSupport,nojoy,exitloop,LoadlibSVGA:boolean;
    nogoautorefresh:boolean;
    X,Y:integer;
    _grResult:grErrortype;
    
    //SDL2 broken game controller support nono-suid and root-only.
    //again, this is wrong.

    //you want event driven, not input driven-the code seems to be here.
    gGameController:PSDL_Joystick;

    Renderer:PSDL_Renderer;
    MainSurface,FontSurface : PSDL_Surface; //TnL mostly at this point, and for hacks
    window:PSDL_Window; //A window... heh..."windows" he he...

    // no such thing as a MainTexture. Texture, period.
    //its "on a path to the renderer" or "its made new"

    srcR,destR,TextRect:PSDL_Rect;
    //rmask,gmask,bmask,amask:longword;

    ttfFont : PTTF_Font; //^TTF_Font
    TextFore,TextBack : PSDL_Color; //font fg and bg...

    filename:String;
    fontpath,iconpath:PChar; // look in: "C:\windows\fonts\" or "/usr/share/fonts/"

{

Fonts:
Most OSes have a default of:

    Serif
    Sans(Serif)
    Gothic
    Terminal(Code)
    Tri-Plex

and as a result, some basic fonts are also included. (Royalty FREE-in case youre wondering)

}

    font_size:integer; 
    style:byte; //BOLD,ITALIC,etc.
    outline:longint;
    grErrorStrings: array [low(grerrorType) .. high(grErrorType)] of string; //or typinfo value thereof..
    AspectRatio:real; //computed from (AspectX mod AspectY)

{
older modes are not used, so y keep them in the list??
 (M)CGA because well..I think you KNOW WHY Im being called here....

 mode13h(320x200x16 or x256) : EXTREMELY COMMON GAME PROGRAMMING
 (we use the more square pixel mode)

Atari modes, etc. were removed. (double the res and we will talk)

}

  MaxColors:LongWord; //positive only!!
  ClipPixels: Boolean=true; //always clip, never an option "not to".

  WantsJoyPad:boolean;
  screenshots:longint;

//CDROM access is very limited and ancient. (Removed after SDLv1.2.)

//Used mostly for Audio CDs and RedBook Audio Games.
//This said- I have some emulators(in C) that access the Linux CDROM device....
//the code is old (Red Hat v7? vs RHEL v7) but builds "with a few hacks".

//such games have CDROM Modeswitch delays in accessing data while playing audio tracks(game skippage).

//Descent II(PC) and SonicCD(PC and SEGA CD Emu) come to mind.
//you would want ogg or mp3 or wav files these days- on some sort of storage medium.

  NonPalette, TrueColor,WantsAudioToo,WantsCDROM:boolean;	
  Blink:boolean;
  CenterText:boolean=false; //see crtstuff unit for the trick
  
  MaxX,MaxY:word;
  bpp:byte;

  _fgcolor, _bgcolor:DWord;	//this is modified due to hi and true color support.
  //do not use old school index numbers. FETCH the index based DWord instead.  
  
  flip_timer_ms:Longint; //Time in MS between Render calls. (longint orlongword) -in C.

  //ideally ignore this and use GetTicks estimates with "Deltas"
  //this is bare minimum support.

//ideally we could mutex the renderer - but thats in a program, not this unit.

 
  EventThread:Longint; //fpc uses Longint
  EventThreadReturnValue:LongInt; //forked processes are supposed to return a error code
	
  Rect : PSDL_Rect;

  LIBGRAPHICS_ACTIVE:boolean;
  LIBGRAPHICS_INIT:boolean;
  RenderingDone:boolean; //did you want to pageflip now(or wait)?

  IsConsoleInvoked,CantDoAudio:boolean; //will audio init? and the other is tripped NOT if in X11.
  //can we modeset in a framebuffer graphics mode? YES. 


//This should help converting some of the SDL C:
//^SDL_Surface (PSDL_Surface) => ^TSDL_Surface

  Event:PSDL_Event; //^SDL_Event
   
  himode,lomode:integer;

  CurrentMode:PSDL_DisplayMode; //^SDL_DisplayMode
  r,g,b,a:PUInt8; //^Byte

  //TextureFormat
  format:LongInt;

//variable sized array- assigned at runtime.
    modeList:array of TSDL_DisplayMode;

//modelist hacking
    mode:TSDL_DisplayMode;
    modeP:PSDL_DisplayMode;


//forward declared defines

function FetchModeList:modelist;

procedure RoughSteinbergDither(filename,filename2:string);

{
locking and unlocking Texture may prove futile -but changing contexts is not
query pixelFormat (of the Texture) is required for any color conversion to take place.

no fetching (peeking) is done on the Texture without the "queried pixelFormat data"
this is normally already set for surface ops when we made the surface(and kept until surface is freed)

destroying MainSurface(especially in software) is disasterous. 
(clone MainSurface -or blit- and destroy the clone.)

The reason is thus:

   As with ( bpp<24)- these modes are not normally unsupported
   Which means more work(werk werk werk)

In many ways SDL2 builds on SDLv1.2 Surface routines, anyway...and cant function without it.

Pushing to the renderer is ok- but if we can outright avoid working with surfaces in general- its better.
Sometimes, however, surface ops make more logical sense.

}


//surfaceOps
procedure lock;
procedure unlock;

//works around SDL OpenGL bug where Windows got optimzed, but Unices didnt--WRONG BTW! (WRITE UNIVERSAL CODE)
procedure Texlock(Tex:PSDL_Texture);
procedure TexlockwRect(Tex:PSDL_Texture; Rect:PSDL_Rect);
function lockNewTexture:Maintexture;
procedure TexUnlock(Tex:PSDL_Texture);


//videoCallback


procedure clearscreen; 
procedure clearscreen(index:byte); overload;
procedure clearscreen(color:Dword); overload;
procedure clearscreen(r,g,b:byte); overload;
procedure clearscreen(r,g,b,a:byte); overload;

procedure clearviewport(windownumber:smallint);
procedure initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean);
procedure closegraph;

function GetX:word;
function GetY:word;
function GetXY:Twhere; 

//this is like Update_Rect() in SDL v1.
procedure renderTexture( tex:PSDL_Texture;  ren:PSDL_Renderer;  x,y:integer;  clip:PSDL_Rect);
//(use SDL_RenderCopy otherwise)

procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 
function getgraphmode:string; 
procedure restorecrtmode;

function getmaxX:word;
function getmaxY:word;

function GetPixel(x,y:integer):DWord;
Procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word);

function getdrivername:string;
Function detectGraph:integer;
function getmaxmode:string;
procedure getmoderange(graphdriver:integer);

procedure installUserFont(fontpath:string; font_size:integer; style:byte; outline:boolean);

procedure SetViewPort(X1, Y1, X2, Y2: Word);
function RemoveViewPort(windowcount:byte):PSDL_Rect;

procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
procedure RegisterBGIDriver(driver: pointer);

function GetMaxColor: word;

procedure LoadImage(filename:string; Rect:PSDL_Rect);
procedure LoadImageStretched(filename:string);

procedure PlotPixelWNeighbors(x,y:integer);

procedure SaveBMPImage(filename:string);

//pull a Rect (off the renderer-back to a surface-then kick out a 1D array of SDL_Colors from inside the Rect)
function GetPixels(Rect:PSDL_Rect):pointer;

procedure GRblink(Text:string);
procedure GRSTOPBlink;


procedure IntHandler; //we should have fpforked and kick started....

{ programmer needs to provide these.

procedure KeyDownEvent;
procedure PauseRoutine;  
procedure ResumeRoutine; 
procedure escapeRoutine;  // a 'pause' button
procedure KeyUpEvent; //should be processing here
procedure MouseMovedEvent;
procedure MouseDownEvent;
procedure MouseUpEvent;
procedure MouseWheelEvent;
procedure Minimized; //pause
procedure Maximized; //resume
procedure Focused; //resume
procedure Lost_Focus; //pause


ok..I think Ive figured out the whole GEtXY shit...SDL should track but doesnt.
BGI needs these "features"

so heres what we do:

on each putpixel call-update WHERE.
on each rect call-update WHERE with WxH location
on each tri call(unless spun) set WHERE to the bottommost right corner
...
etc
etc

If we track where were at based upon where we want to go be should be ok but...by default
we have no data.(SDL has no clue- and doesnt care either)


}

const
//I dont care how many you have, but "minus one" is the MAXIMUM ALLOWED.
   maxMode=Ord(High(Graphics_Modes))-1;


implementation

{$INCLUDE palettes.inc}
{$INCLUDE modelist.inc}
{$INCLUDE colormods.inc}

{

DO NOT BLINDLY ALLOW any function to be called arbitrarily.(this was done in C- I removed the checks for a short while)

two exceptions:

making a 16 or 256 palette and/or modelist file

}

//this was ported from (SDL) C- 
//https://stackoverflow.com/questions/37978149/sdl1-sdl2-resolution-list-building-with-a-custom-screen-mode-class

function FetchModeList:modelist;
var
    mode_index,modes_count ,display_index,display_count:integer;
    i:integer;

begin
   display_count := SDL_GetNumVideoDisplays; //1->display0
   LogLn('Number of displays: ', display_count);
   display_index := 0;

//for each monitor do..
while  (display_index <= display_count) do begin
    LogLn('Display: ', display_index);

    modes_count := SDL_GetNumDisplayModes(display_index); //max number of supported modes
    setLength(modeList, modes_count);
    mode_index: = 0;
    i:=0;

    //do for each mode in the number of possible modes
    while ( mode_index <= modes_count ) do begin

        mode^.format:= SDL_PIXELFORMAT_UNKNOWN;
        mode^.w:= 0;
        mode^.h:= 0;
        mode^.refresh_rate:= 0;
        mode^.driverdata:= Nil;

        modeP:^mode;

        if (SDL_GetDisplayMode(display_index, mode_index, modeP) = 0) then begin //mode supported

            //Log: pixelFormat(bpp)MaxX,MaXy,refrsh_rate            
            LogLn(IntToStr(SDL_BITSPERPIXEL(mode^.format)),' bpp', IntToStr(mode^.w), ' x ',IntToStr(mode^.h), '@ ',IntToStr(mode^.refresh_rate),' Hz ');

            //store data in a modeList array
                modeList[i]^.format:=SDL_BITSPERPIXEL(mode.format;            
                modeList[i]^.w:=mode.w;                
                modeList[i]^.h:=mode.h;                
                modeList[i]^.refresh_rate:=mode.refresh_rate;                
                modeList[i]^.driverdata:=mode.driverdata;

        end;
        inc(i);
        inc(mode_index);
    end;
    inc(display_index);
    
end;


{

Graphics detection is a wonky process.
1- find whats supported
2- find highest supported mode(backwards) in that list
3- use it, or try to.

repeat num 2 and 3 if you fail- until no modes work

blindly setting says:

I was THIS mode, and none other- it had better be supported (but is it?)
(try or fail)

Although generally in SDL(and on hardware) smaller windows and color depths are supported(emulation),
SDL -by itself- might not support that mode.

VGA supports mCGA -(but HDMI might not support either)

Do we care- as mostly we are setting windows sizes? Not usually.
WE could care less if the data is scaled on fullsceen-since we arent responsible for the scaling

(whether things look good- is another matter)

A TON of old code was written when pixels were actually visible. NOT THE CASE, anymore.

DetectGraph is here more for compatibility than anything else.
It seems to be used as often as DEFINED modes.

-Custom modes are usually hackish anyways.

}

procedure IntHandler;
//This is a dummy routine.
//This variable must mach-and doesnt on purpose- closegraph "fpfork killer" exit status.

//I want you- Users/programmers to override this routine and DO THINGS RIGHT.

var
   MoonOrange:boolean;

begin
  EventThread:=fpfork; 
  
  if (EventThread=0) then begin //we didnt fpfork....
     if IsConsoleInvoked then begin
        writeln('EPIC FAILURE: SDL requires multiprocessing. I cant seem to fpfork. ');
        LogLn('EPIC FAILURE: SDL requires multiprocessing. I cant seem to fpfork.');
        closegraph;
     end;
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'EPIC FAILURE: Cant fpfork. I need to. CRITICAL ERROR.','BYE..',NIL);
      closegraph;
  end;

    MoonOrange:=false;
    repeat
      delay(1000);

{ 
this is how to do it- 
is there a faster way once the input handler is reassigned?
we shall see..

var
      kbhit,GetString,quit,echo:boolean;
      GetChar,c:char;
      event:SDL_Event;
	  somestring:string;
      i:integer;

//Readkey,KeyPressedm and ReadString combo with one handler.

	if ((SDL_PollEvent( event ) <> Nil) and (event^.type = SDL_KEYDOWN))) then begin
        SDL_PushEvent(event);
	    kbhit:=true;

	  case( event.type ) of
	  SDL_KEYDOWN:
	    c=event.key.keysym.sym;
	    if (isprint(c)) then begin  
	      i:=0;
          if GetString=true then begin
              repeat 
                somestring[i]:=c;
                inc(i);
              until (c=SDLK_RETURN) or (i=len(somestring));
          end else begin
             GetChar:=c;    
          end;
        end; //Is printable char
            
	    exit;
      end;
	  SDL_ACTIVEEVENT:
	//    if ((event.active.state = SDL_APPINPUTFOCUS) and event.active.gain) then
	      //resume
	    break;
	  SDL_QUIT:
	    MoonOrange := true;
	    exit;
	  else:
	    //SDL_PushEvent(event); or
		//SDL_WaitEVent(0);
	    exit;
	  end else begin
	    SDL_WaitEvent(0);
	  end;
    end;

}

    until MoonOrange=true;
    //exit gracefully.
end;

// from wikipedia(untested)
procedure RoughSteinbergDither(filename,filename2:string);

var
	pixel:array[0..1280,0..1024] of DWord;
	oldpixel,newpixel,quant_error:DWord;
	file1,file2:file;
    Buf : Array[1..4096] of byte;
    

begin
    assign(file1,filename); 
    assign(file2,filename2); 
  
    blockread(file1,buf,sizeof(file));

  while Y<MaxY do begin
	 while x<MaxX do begin

      oldpixel  := pixel[x,y];
      newpixel  := round(oldpixel mod 256);
      pixel[x,y]  := newpixel;
      quant_error  := oldpixel - newpixel;

      pixel[x + 1,y]:= longword(pixel[x + 1,y] + quant_error * 7 mod 16);
      pixel[x - 1,y + 1] := longword(pixel[x - 1,y + 1] + quant_error * 3 mod 16);
      pixel[x,y + 1] := longword(pixel[x,y + 1] + quant_error * 5 mod 16);
      pixel[x + 1,y + 1] := longword(pixel[x + 1,y + 1] + quant_error * 1 mod 16);

    end;
   end;
     blockwrite(file2,buf,sizeof(file));

     close(file1);
	 close(file2);
end;


{

Got weird fucked up c boolean evals? (JEEZ theyre a BITCH to understand....)
  wonky "what ? (eh vs uh) : something" ===>if (evaluation) then (= to this) else (equal to that)
(usually a boolean eval with a byte input- an overflow disaster waiting to happen)

such oddly is the case with xlib for X11. The boolean gives a negative false, not zero and one.
(Thats a disaster waiting to happen)
}


{
Create a new texture for most ops-or DO NOT call RenderCopy(or unlock),meaning that rendering is NOT done yet.

RenderPresent is being called automatically at minimum (screen_refresh) as an interval.
Refresh is fine if data is in the backbuffer. Until its copied into the main buffer- its never displayed.

DO NOT call these functions/procs if using Render based ops- they may do this automagically.
(Texture is only a context if using "surface opertions on a Texture" such as GET/setRGB and sdl v1 surface ops such as:
line,rect
...etc)


which surface/texture do we lock/unlock??
solve for X -by providing it. dont beat your own brains out nuking the problem.

unfortunately- a texture -based SDL2 only solution "nukes the problem".
-especially with color conversion.

Therefore surface ops-need to be added back in(or still used)

(Main/surface^.format can only be probed in renderer if SDL_QueryTexture is used)

Sorry.

}

//FIXME:
//All SDL calls are unpredictable unless vars are Nil before checks are made.
//(This is secure code way of doing things)

procedure lock;
begin
    if SDL_MustLock(MainSurface)=true then
        SDL_LockSurface(Mainsurface);
    //else exit: no locking needed
end;


procedure unlock;
begin
    if SDL_MustLock(MainSurface)=true then
           SDL_UnlockSurface(Mainsurface);
    //else exit: no UNlocking needed
end;

//depending on how you call or if "MainSurface" isnt what you want.
procedure lock(someSurface:PSDL_Surface); overload;
begin
    if SDL_MustLock(someSurface)=true then
        SDL_LockSurface(someSurface);
    //else exit: no locking needed
end;


procedure unlock(someSurface:PSDL_Surface);; overload;
begin
    if SDL_MustLock(someSurface)=true then
           SDL_UnlockSurface(someSurface);
    //else exit: no UNlocking needed
end;


procedure Texlock(Tex:PSDL_Texture);

var
  w,h,pitch:integer;
  pixels:^longword;

begin
  pixels:=Nil;
  pitch:=0;
  if (LIBGRAPHICS_ACTIVE=false) then begin
    writeln('I cant lock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
  if (Tex = Nil) then begin
     if IsConsoleInvoked then
		writeln('Cannot Lock unassigned Texture.');
        LogLn('Cant Lock unassigned Texture');
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cannot Lock an unassigned Texture.','OK',NIL);
     exit;
  end;
  SDL_QueryTexture(tex, format, Nil, w, h);
  SDL_SetRenderTarget(renderer, tex);
{$ifdef windows}
  SDL_LockTexture(tex,Nil,pixels,pitch);
{$ifdef}
end;

procedure TexlockwRect(Tex:PSDL_Texture; Rect:PSDL_Rect);

var
  w,h,pitch:integer;
  pixels:^longword;

begin
  if (LIBGRAPHICS_ACTIVE=false) then begin
    writeln('I cant lock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
  if (Tex = Nil) then begin
     if IsConsoleInvoked then
		writeln('Cannot Lock unassigned Texture.');
        LogLn('Cant Lock unassigned Texture');
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cannot Lock an unassigned Texture.','OK',NIL);
     exit;
  end;
  SDL_QueryTexture(tex, format, rect, w, h);
  SDL_SetRenderTarget(renderer, tex);
{$ifdef windows}
  SDL_LockTexture(tex,Nil,pixels,pitch);
{$endif}
end;

function lockNewTexture:Maintexture;

var
  tex:PSDL_Texture;

begin
  if (LIBGRAPHICS_ACTIVE=false) then begin
    writeln('I cant lock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
//case bpp of... sets PixelFormat(forcibly)

  tex:=Nil; //if we dont clear it before calling, results are unpredictable.
  tex:= SDL_CreateTexture(renderer, format, SDL_TEXTUREACCESS_TARGET, MaxX, MaxY);
  if (tex = Nil) then begin
     if IsConsoleInvoked then
		writeln('Cannot Alloc Texture.');
        LogLn('Cant Alloc Texture');
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cannot Alloc Texture.','OK',NIL);
     exit;
  end;
  SDL_QueryTexture(tex, format, Nil, w, h);
  SDL_SetRenderTarget(renderer, tex);
{$ifdef windows}
  SDL_LockTexture(tex,Nil,pixels,pitch);
{$endif}
  lockNewTexture:=Tex; //kick it back
end;

//call when done drawing pixels
procedure TexUnlock(Tex:PSDL_Texture);

begin

  if (LIBGRAPHICS_ACTIVE=false) then begin
    writeln('I cant unlock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
{$ifdef windows}
    //we are done playing with pixels so....
    SDL_UnLockTexture(tex);
{$endif}

//get stuff ready for the renderer and render.
  SDL_SetRenderTarget(renderer, NiL);
  SDL_RenderCopy(renderer, tex, NiL, NiL);
  SDL_DestroyTexture(tex); 

end;


procedure clearscreen; 
//this is an alias routine

begin
    if LIBGRAPHICS_ACTIVE=true then
        clearDevice;
    else //use crt unit
        clrscr;
end;

//BGI spec
procedure clearDevice;

begin
    SDL_RenderClear(renderer);
end;

//all of these need to be rewritten-syn tax has been paid- calling convention is incorrect.
procedure clearscreen(index:byte); overload;

var
	r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin
    if MaxColors>256 then begin
        if IsConsoleInvoked then
           writeln('ERROR: i cant do that. not indexed.');
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempting to clearscreen(index) with non-indexed data.','OK',NIL);   
        LogLn('Attempting to clearscreen(index) with non-indexed data.');           
        exit; 
    end;
    if MaxColors=16 then
       somecolor:=Tpalette16.colors[index];
    
    if MaxColors=256 then
       somecolor:=Tpalette256.colors[index];


    SDL_SetRenderDrawColor(Renderer,ord(somecolor^.r),ord(somecolor^.g),ord(somecolor^.b),255);
	SDL_RenderClear(renderer);
end;


procedure clearscreen(color:Dword); overload;

var
    somecolor:PSDL_Color;
    someDword:DWord;
    r,g,b:PUInt8;
    i:integer;

begin

//the only easy way is thru paletted mode due "to the renderer"
//we might just need the pixel format type....

	if bpp =4 then begin
	    //get index from DWord- if it matches
        i:=0;
        repeat
            if color=Tpalette16.DWords[i] then begin;
                somecolor:=Tpalette16.colors[i];
                exit; 
            end;
            inc(i);
        until i=15;		
	end else
	if bpp =8 then begin
	    //get index from DWord- if it matches
        i:=0;
        repeat
            if color=Tpalette256.DWords[i] then begin;
                somecolor:=Tpalette256.colors[i];
                exit; 
            end;
            inc(i);
        until i=255;		
	end;
	
	case bpp of
        15,16,24,32: begin
	    	SDL_GetRGB(color,MainSurface^.format,r,g,b);
	    	somecolor^.r:=byte(^r);
	    	somecolor^.g:=byte(^g);
		    somecolor^.b:=byte(^b);	
	    end;
    end;
    SDL_SetRenderDrawColor(Renderer,ord(somecolor^.r),ord(somecolor^.g),ord(somecolor^.b),255);
	SDL_RenderClear(renderer);
end;

//these two dont need conversion of the data
procedure clearscreen(r,g,b:byte); overload;


begin
	SDL_SetRenderDrawColor(Renderer,ord(r),ord(g),ord(b),255);
	SDL_RenderClear(renderer);
end;


procedure clearscreen(r,g,b,a:byte); overload;

begin
	SDL_SetRenderDrawColor(Renderer,ord(r),ord(g),ord(b),ord(a));
	SDL_RenderClear(renderer);
end;

//end hack

//this is for dividing up the screen or dialogs (in game or in app)

//spec says clear the last one assigned
procedure clearviewport;

//clears it, doesnt remove or add a "layered window".
//usually the last viewport set..not necessary the whole "screen"
var
  viewport:PSDL_Rect;

begin
//if windownumber isnt set- this cant work. 
   viewport^.X:= texBounds[windownumber]^.x;
   viewport^.Y:= texBounds[windownumber]^.y;
   viewport^.W:= texBounds[windownumber]^.w;
   viewport^.H:= texBounds[windownumber]^.h;
   SDL_RenderFillRect(Renderer, viewport);
end;


function videoCallback(interval: Uint32; param: pointer): Uint32; cdecl; 
//this is a funky interrupt-ish callback in C. Its very specific code.
//that said, IO is pushed, then popped -from CPU registers in weird ways- why this is so specific.

//we dont always need the input params, nor the interval- its already assigned before we are called.
//(but it has to be given to us)

begin
   param:=Nil; //not used

   if (not Paused) then begin //if paused then ignore screen updates

//      if (TimerTicks mod interval) then 
           SDL_RenderPresent;
   end;
   SDL_CondBroadcast(eventWait);
   videoCallback := 0; //we have to return something-the what, WE should be defining.
end;

//NEW: do you want fullscreen or not?
procedure initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean);

var
	bpp,i:integer;
	_initflag,_imgflags:longword; //PSDL_Flags?? no such beast 
    iconpath:string;
    imagesON,FetchGraphMode:integer;
	mode:PSDL_DisplayMode;

begin

  if LIBGRAPHICS_ACTIVE then begin
    if ISConsoleInvoked then begin
        LogLn('Graphics already active.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Initgraph: Graphics already active.','OK',NIL);	
    exit;
  end;
  pathToDriver:='';  //unused- code compatibility
  iconpath:='./sdlbgi.bmp'; //sdl2.0 doesnt use this.

//this has to be done inline to the running code, unfortunately
  case(graphmode) of 
	     mCGA:begin
			MaxX:=320;
			MaxY:=240;
			bpp:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

        //color tv mode
		VGAMed:begin
            MaxX:=320;
			MaxY:=240;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		//spec breaks here for Borlands VGA support(not much of a specification thx to SDL...)
		//this is the "default VGA minimum".....since your not running below it, dont ask to set FS in it...
        // if you did that you would have to scale the output...
		//(more werk???)

		VGAHi:begin
            MaxX:=640;
			MaxY:=480;
			bpp:=4; 
			MaxColors:=16;
            NonPalette:=false;
    		TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		VGAHix256:begin
            MaxX:=640;
			MaxY:=480;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=False;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		VGAHix32k:begin //im not used to these ones (15bits)
           MaxX:=640;
		   MaxY:=480;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
           TrueColor:=false;
           XAspect:=4;
           YAspect:=3; 

		end;

		VGAHix64k:begin
           MaxX:=640;
		   MaxY:=480;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		//standardize these as much as possible....

		m800x600x16:begin
            MaxX:=800;
			MaxY:=600;
			bpp:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		m800x600x256:begin
            MaxX:=800;
			MaxY:=600;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;


		m800x600x32k:begin
           MaxX:=800;
		   MaxY:=600;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;


		m1024x768x256:begin
            MaxX:=1024;
			MaxY:=768;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		m1024x768x32k:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1024x768x64k:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;


		m1280x720x256:begin
            MaxX:=1280;
			MaxY:=720;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=9; 

		end;

		m1280x720x32k:begin
          MaxX:=1280;
		   MaxY:=720;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1280x720x64k:begin
           MaxX:=1280;
		   MaxY:=720;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1280x720xMil:begin
		   MaxX:=1280;
		   MaxY:=720;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1280x1024x256:begin
            MaxX:=1280;
			MaxY:=1024;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		m1280x1024x32k:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1280x1024x64k:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1280x1024xMil:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=4;
           YAspect:=3; 

		end;

{		m1280x1024xMil2:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=4;
           YAspect:=3; 

		end;
}
		m1366x768x256:begin
            MaxX:=1366;
			MaxY:=768;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=9; 

		end;

		m1366x768x32k:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1366x768x64k:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1366x768xMil:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;

{		m1366x768xMil2:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;
}

		m1920x1080x256:begin
            MaxX:=1920;
			MaxY:=1080;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=9; 

		end;

		m1920x1080x32k:begin
		   MaxX:=1920;
		   MaxY:=1080;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1920x1080x64k:begin
		   MaxX:=1920;
		   MaxY:=1080;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1920x1080xMil:begin  
 	       MaxX:=1920;
		   MaxY:=1080;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;

{
		m1920x1080xMil2: begin
 	       MaxX:=1920;
		   MaxY:=1080;
		   bpp:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;
}	    
  end;{case}

//once is enough with this list...its more of a nightmare than you know.
//(its assigned before entries are checked)


   //"usermode" must match available resolutions etc etc etc
   //this is why I removed all of that code..."define what exactly"??

  //attempt to trigger SDL...on most sytems this takes a split second- and succeeds.
  _initflag:= SDL_INIT_VIDEO or SDL_INIT_TIMER;

  if WantsAudioToo then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER; 
  if WantsJoyPad then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_JOYSTICK;
//if WantInet then SDLNet_Init;

  if ( SDL_Init(_initflag) < 0 ) then begin
     //we cant speak- write something down.

     if ISConsoleInvoked then begin
        Logln('Critical ERROR: Cant Init SDL for some reason.');
        Logln(SDL_GetError);
     end;
     //if we cant init- dont bother with dialogs.

     _grResult:=GenError; //gen error
     halt(0); //the other routines are now useless- since we didnt init- dont just exit the routine, DIE instead.

  end;
 

  if wantsFullIMGSupport then begin

    _imgflags:= IMG_INIT_JPG or IMG_INIT_PNG or IMG_INIT_TIF;
    imagesON:=IMG_Init(_imgflags);

    //not critical, as we have bmp support but now are limping very very bad...
    if((imagesON and _imgflags) <> _imgflags) then begin
       if IsConsoleInvoked then begin
		 Logln('IMG_Init: Failed to init required JPG, PNG, and TIFF support!');
		 LogLn(IMG_GetError);
	   end;
	   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'IMG_Init: Failed to init required JPG, PNG, and TIFF support','OK',NIL);	
    end;
  end;

{
 im going to skip the RAM requirements code and instead haarp on proper rendering requirements.
 note that a 12 yr old notebook-try as it may- might not have enough vRAM to pull things off.
 can you squeeze the code to fit into a 486??---you are pushing it.
(You are better off using SDLv1 instead)

now- how do we check if sdl2 is supported- and fall back, given uses clauses can only launch one or the other?
}

  if (graphdriver = DETECT) then begin
	//probe for it, dumbass...NEVER ASSUME.

//temporarily not available
	   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Graphics detrection not available at this time.','Sorry',NIL);	

//    Fetchgraphmode := DetectGraph; //need to kick back the higest supported mode...
  end;

  NoGoAutoRefresh:=false;
  LIBGRAPHICS_INIT:=true; 
  LIBGRAPHICS_ACTIVE:=false; 

//we do it this way because we might already be active- why duplicate code?

//sets up mode- then clears it in standard "BGI" fashion.
  SetGraphMode(Graphmode,wantFullScreen);

//no atexit handler needed, just call CloseGraph
//that was a nasty SDL surprise...


//If we got here- YAY!

//fpfork the event handler
  IntHandler;

//if we fpforked- we should come right back. 

//events and callbacks seem to flow from interrupt code in C..
//a BIG PITA- and VERY SPECIFIC CODE.

//this data seems to hidden in all the lines of C and barely made reference to.
//also needs to be checked for SDLv2 compliance.

   eventLock:= nil;
   eventWait:= nil;

  eventLock := SDL_CreateMutex;
   if eventLock = nil then
   begin
      if IsConsoleInvoked then
          Logln('Error: cant create a mutex');
          SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'cant create a mutex','OK',NIL);
      closegraph;
   end;

   eventWait := SDL_CreateCond;
   if eventWait = nil then
   begin
      if IsConsoleInvoked then
          Logln('Error: cant create a condition variable.');
          SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'cant create a condition variable.','OK',NIL);
      closegraph;
   end;


//lets get the current refresh rate and set a screen timer to it.
// we cant fetch this from X11? sure we can.

  
  mode^.format := SDL_PIXELFORMAT_UNKNOWN;
  mode^.w:=0;
  mode^.h:=0;
  mode^.refresh_rate:=0;
  mode^.driverdata:=Nil;
  //for physical screen 0 do..
  
  //The SDl equivalent error of: attempting to probe VideoModeInfo block when (VESA) isnt initd results in issues....
  
  if(SDL_GetCurrentDisplayMode(0, mode) <> 0) then begin
    if IsConsoleInvoked then
			Logln('Cant get current video mode info. Non-critical error.');
//    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SDL cant get the data for the current mode.','OK',NIL);
  end;

  //dont refresh faster than the screen.
  if (mode^.refresh_rate > 0)  then 
     //either force a longINT- or convert from REAL. Otherwise you have to pass it as a interrupt proc param--it hairy mess.
     flip_timer_ms := longint(mode^.refresh_rate);
  else
     flip_timer_ms := 17; 

  video_timer_id := SDL_AddTimer(flip_timer_ms, videoCallback, nil);
  if video_timer_id=Nil then begin
    if IsConsoleInvoked then begin
		Logln('WARNING: cannot set drawing to video refresh rate. Non-critical error.');
		Logln('you will have to manually update surfaces and the renderer.');
    end;
//    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SDL cant set video callback timer.Manually update surface.','OK',NIL);
    NoGoAutoRefresh:=true; //Now we can call Initgraph and check, even if quietly(game) If we need to issue RenderPresent calls.
  end;

  
  CantDoAudio:=false;
    //prepare mixer
  if WantsAudioToo then begin
    audioFlags:=(MIX_INIT_FLAC or MIX_INIT_MP3 or MIX_INIT_OGG); //unless you need mikmod support, then or it in here.
    Mix_Init(AudioFlags);
    AudioSystemCheck:=Mix_OpenAudio(44100,MIX_DEFAULT_FORMAT,2, 200); //cd audio quality
    //(slower systems use smaller chunks and degraded quality.)
    if AudioSystemCheck =Nil then begin
        if IsConsoleInvoked then
                LogLn('There is no audio. Mixer did not init.');
        else  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'There is no audio. Mixer did not init.','OK',NIL);
    end;

  end;
//set some sane default variables
  _fgcolor := $FFFFFFFF;	//Default drawing color = white (15)
  _bgcolor := $000000FF;	//default background = black(0)
  someLineType:= NormalWidth; 


  new(Event);

  LIBGRAPHICS_ACTIVE:=true;  //We are fully operational now.
  paused:=false;

  _grResult:=OK; //we can just check the dialogs (or text output) now.

  where.X:=0;
  where.Y:=0;

  //Hide, mouse.
//  SDL_ShowCursor(SDL_DISABLE);

//set some sensible input specs
  //SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);


  //Check for joysticks 
  if WantsJoyPad then begin
 
    if( SDL_NumJoysticks < 1 ) then begin
        if IsConsoleInvoked then
			Logln( 'Warning: No joysticks connected!' ); 
        
  		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Warning: No joysticks connected!','OK',NIL);
        
    end else begin //Load joystick 
	    gGameController := SDL_JoystickOpen( 0 ); 
    
        if( gGameController = NiL ) then begin  
	        if IsConsoleInvoked then begin
		    	Logln( 'Warning: Unable to open game controller! SDL Error: ', SDL_GetError); 
                LogLn(SDL_GetError);
            end;
            SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Warning: Unable to open game controller!','OK',NIL);
            noJoy:=true;
        end;
        noJoy:=false;
    end; 
  end; //Joypad 
end; //initgraph


{ 

//these two are completely untested and syntax unchecked.
//they are not, by themselves "feature coplete dialogs", nor do they check input.
//mimcs crt level windows in vga text modes

//I said Id get to the line characters..here we go.
procedure DrawSingleLinedWindowDialog(Rect:PSDL_Rect; colorToSet:DWord);

var
    UL,UR,LL,LR:Points; //see header file(polypts is ok here)
    ShrunkenRect,NewRect:PSDL_Rect;

begin
    Tex:=NewTexture;
    SDL_SetViewPort(Rect);

    //corect me if Im off- this is guesstimate math here, not actual.
    //the corner co ords
    UL.x:=x+2;
    UL.y:=y+2;
    LL.x:=h-2;
    LL.y:=x+2;
    UR.x:=w-2;
    UR.y:=y+2;
    LR.x:=w-2;
    LR.y:=h-2;
    
    NewRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetPenColor(_fgcolor);
    SDL_RenderDrawRect(NewRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)

//shink available space

    //do this again- further in
    UL.x:=x+6;
    UL.y:=y+6;
    LL.x:=h-6;
    LL.y:=x+6;
    UR.x:=w-6;
    UR.y:=y+6;
    LR.x:=w-6;
    LR.y:=h-6;

    ShrunkenRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetViewPort(ShrunkenRect);

end;

procedure DrawDoubleLinedWindowDialog(Rect:PSDL_Rect);

var
    UL,UR,LL,LR:Points; //see header file(polypts is ok here)
    ShrunkenRect,NewRect:PSDL_Rect;

begin
    Tex:=NewTexture;
    SDL_SetViewPort(Rect);

    //corect me if Im off- this is guesstimate math here, not actual.
    //the corner co ords
    UL.x:=x+2;
    UL.y:=y+2;
    LL.x:=h-2;
    LL.y:=x+2;
    UR.x:=w-2;
    UR.y:=y+2;
    LR.x:=w-2;
    LR.y:=h-2;
    NewRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetPenColor(ColorToSet);
    SDL_RenderDrawRect(NewRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)
    
    //do this again- further in
    UL.x:=x+4;
    UL.y:=y+4;
    LL.x:=h-4;
    LL.y:=x+4;
    UR.x:=w-4;
    UR.y:=y+4;
    LR.x:=w-4;
    LR.y:=h-4;
    NewRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetPenColor(ColorToSet);
    SDL_RenderDrawRect(NewRect); 

//shink available space

    //do this again- further in
    UL.x:=x+6;
    UL.y:=y+6;
    LL.x:=h-6;
    LL.y:=x+6;
    UR.x:=w-6;
    UR.y:=y+6;
    LR.x:=w-6;
    LR.y:=h-6;

    ShrunkenRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetViewPort(ShrunkenRect);

end;
}

procedure closegraph;
var
	Killstatus,Die:cint;
    waittimer:integer;

//free only what is allocated, nothing more- then make sure pointers are empty.
begin

  LIBGRAPHICS_ACTIVE:=false;  //Unset the variable (and disable all of our other functions in the process)
  

  //if wantsInet then
//  SDLNet_Quit;

  if wantsJoyPad then
    SDL_JoystickClose( gGameController ); 
  gGameController := Nil;

  if WantsAudioToo then begin
    Mix_CloseAudio; //close- even if playing

    if chunk<>Nil then
        Mix_FreeChunk(chunk); 
    if music<> Nil then 
        Mix_FreeMusic(music);

    Mix_Quit;
  end;

   SDL_RemoveTimer(video_timer_id);
   video_timer_id := nil;


   SDL_DestroyMutex(eventLock);
   eventLock := nil;

   SDL_DestroyCond(eventWait);
   eventWait := nil;

  
  if (TextFore <> Nil) then begin
	TextFore:=Nil;
	free(TextFore);
  end;
  if (TextBack <> Nil) then begin
	TextBack:=Nil;
	free(TextBack);
  end;
  TTF_CloseFont(ttfFont);
  TTF_Quit;
  //its possible that extended images are used also for font datas...
  if wantsFullIMGSupport then 
     IMG_Quit;


  die:=9; //signal number 9=kill
  //Kill child if it is alive. we know the pid since we assigned it(the OS really knows it better than us)

  //were stuck in a loop
  //we can however, trip the loop to exit...

  exitloop:=true;
  Killstatus:=FpKill(EventThread,Die); //send signal (DIE) to thread

  EventThread:=0;

  dispose( Event );
  //free viewports

  x:=8;
  repeat
	if (Textures[x]<>Nil) then
		SDL_DestroyTexture(Textures[x]);
		Textures[x]:=Nil;
    dec(x);
  until x=0;
  

//Dont free whats not allocated in initgraph(do not double free)
//routines should free what they allocate on exit.

  if (MainSurface<> Nil) then begin
	SDL_FreeSurface( MainSurface );
	MainSurface:= Nil;
  end;	

  if (Renderer<> Nil) then begin
    Renderer:= Nil;
	SDL_DestroyRenderer( Renderer );
  end;	

  if (Window<> Nil) then begin
	Window:= Nil;
  	SDL_DestroyWindow ( Window );
  end;	

  SDL_Quit; 


  if IsConsoleInvoked then begin
     
         textcolor(7); //..reset standards...
         clrscr; //text clearscreen
         writeln;
  end;
  //unless you want to mimic the last doom screen here...usually were done....  
  //Yes you can override this function- if you need a shareware screen on exit..Hackish, but it works.
  //"@ExitProc rerouting routines" (and checks) go here
  
  halt(0); //nothing special, just bail gracefully.
end;            	 

function GetX:word;
begin
  x:=where.X;
end;

function GetY:word;
begin
  y:=where.Y;
end;

function GetXY:longint; 
//This is the 1D location in the 2D graphics area(yes, its weird)

begin
  x:=where.X;
  y:=where.Y;
  GetXY := (y * (MainSurface^.pitch mod (sizeof(byte)) ) + x); //byte or word-(lousy USint definition)
end;

{
 Draw an Texture to an Renderer at x, y. 
 preserve the texture's width and height- also taking a clip of the texture if desired

- we can use just RenderCopy, but it doesnt take stretching or clipping into account.(its sloppy)

I didnt write this (from stackExchange in C) but it makes sense and SDL is at least "GPL", so we are "safe in licensing".

}

procedure renderTexture( tex:PSDL_Texture;  ren:PSDL_Renderer;  x,y:integer;  clip:PSDL_Rect);

var
  dst:PSDL_Rect;

begin
	
	dst^.x := x;
	dst^.y := y;
	if (clip <> Nil)then begin
		dst^.w := clip^.w;
		dst^.h := clip^.h;
	end
	else begin
		SDL_QueryTexture(tex, NiL, NiL, @dst^.w, @dst^.h);
	end;
	SDL_RenderCopy(ren, tex, clip, dst); //clip is either Nil(whole surface) or assigned

end;


procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 
//initgraph should call us to prevent code duplication
//exporting a record is safer..but may change "a chunk of code" in places.   
var
	flags:longint;
    success,IsThere,RendedWindow:integer;
    surface1:PSDL_Surface;
    FSNotPossible:boolean;
    thismode:string;
    mode:PSDL_DisplayMode;

begin
//we can do fullscreen, but dont force it...
//"upscale the small resolutions" is done with fullscreen.
//(so dont worry if the video hardware doesnt support it)



//if not active:
//are we coming up?
//no? EXIT

if (LIBGRAPHICS_INIT=false) then 

begin
		
		if IsConsoleInvoked then Logln('Call initgraph before calling setGraphMode.') 
		else SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'setGraphMode called too early. Call InitGraph first.','OK',NIL);
	    exit;
end
else if (LIBGRAPHICS_INIT=true) and (LIBGRAPHICS_ACTIVE=false) then begin //initgraph called us

    window:= SDL_CreateWindow(PChar('Lazarus Graphics Application'), SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, MaxX, MaxY, 0);
    renderer := SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);

	RendedWindow := SDL_CreateWindowAndRenderer(MaxX, MaxY,0, @window,@renderer);

	if ( RendedWindow <>0 ) then begin
    //No hardware renderer....
    
         //posX,PosY,sizeX,sizeY,flags
         window:= SDL_CreateWindow(PChar('Lazarus Graphics Application'), SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, MaxX, MaxY, 0);
    	 if (window = Nil) then begin
 			if IsConsoleInvoked then begin
	    	   	Logln('Something Fishy. No hardware render support and cant create a window.');
	    	   	Logln('SDL reports: ',' ', SDL_GetError);      
	    	end;
	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy. No hardware render support and cant create a window.','BYE..',NIL);
			
			_grResult:=GenError;
	    	closegraph;
        end;

        //we have a window but are forced into SW rendering(why?)
    	renderer := SDL_CreateSoftwareRenderer(Mainsurface);
		if (renderer = Nil ) then begin
 			if IsConsoleInvoked then begin
	    	   	Logln('Something Fishy. No hardware render support and cant setup a software one.');
	    	   	Logln('SDL reports: ',' ', SDL_GetError);      
	    	end;
	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy. No hardware render support and cant setup a software one.','BYE..',NIL);
	    	_grResult:=GEnError;
	    	closegraph;
		end;

   end; 

   surface1:=SDL_LoadBMP(iconpath);

   // The icon is attached to the window pointer
   SDL_SetWindowIcon(window, surface1);

   // ...and the surface containing the icon pixel data is no longer required.
   SDL_FreeSurface(surface1);


   if wantFullscreen then begin
       //I dont know about double buffers yet but this looks yuumy..
       //SDL_SetVideoMode(MaxX, MaxY, bpp, SDL_DOUBLEBUF|SDL_FULLSCREEN);

       flags:=(SDL_GetWindowFlags(window));
       flags:=flags or SDL_WINDOW_FULLSCREEN_DESKTOP; //fake it till u make it..
       //we dont want to change HW videomodes because 4bpp isnt supported.
       
       //autoscale us to the monitors actual resolution
       SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'linear');
       SDL_RenderSetLogicalSize(renderer, MaxX, MaxY);

	   IsThere:=SDL_SetWindowFullscreen(window, flags);
       thisMode:=getgraphmode;
  	   if ( IsThere < 0 ) then begin
    	      if IsConsoleInvoked then begin
    	         Logln('Unable to set FS: ', thismode);
    	         Logln('SDL reports: ',' ', SDL_GetError);      
     	      end;

              FSNotPossible:=true;      
       
         //if we failed then just gimmie a yuge window..      
         SDL_SetWindowSize(window, MaxX, MaxY);
         SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set FS.','OK',NIL);
         if IsconsoleInvoked then begin
            LogLn('ERROR: SDL cannot set FS.');
            LogLn(SDL_GetError);
         end;
       end;

    end; 


    //we can create a surface down to 1bpp, but we CANNOT SetVideoMode <8 bpp
    //I think this is a HW limitation in X11,etc.

    //Renderer says nothing about DEPTH, plenty about SIZE of output...

    //syntax: flags, w,h,bpp,rmask,gmask,bmask,amask

   
    Mainsurface := SDL_CreateRGBSurface(0, MaxX, MaxY, bpp, 0, 0, 0, 0);
    if (Mainsurface = NiL) then begin //cant create a surface
        LogLn('SDL_CreateRGBSurface failed');
        LogLn(SDL_GetError);
        _grresult:=GenError; //probly out of vram
        //we can exit w failure codes, if we check for them
        closegraph;
    end;


  if (bpp<=8) then begin
      if MaxColors=16 then
            SDL_SetPaletteColors(palette,TPalette16.colors,0,16)
	  else if MaxColors=256 then
            SDL_SetPaletteColors(palette,TPalette256.colors,0,256);
  end;

  SDL_SetRenderDrawColor(renderer, $00, $00, $00, $FF); 
  SDL_RenderClear(Renderer);

   LIBGRAPHICS_ACTIVE:=true;
   exit; //back to initgraph we go.

end else if (LIBGRAPHICS_ACTIVE=true) then begin //good to go

                   
    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

//we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;

        mode^.w:=MaxX;
		mode^.h:=MaxY;
		mode^.refresh_rate:=60; //assumed
		mode^.driverdata:=Nil;

		success:=SDL_SetWindowDisplayMode(window,mode);
        if (success <> 0) then begin 
			SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set DisplayMode.','OK',NIL);
	        if IsConsoleInvoked then begin
                LogLn('ERROR: SDL cannot set DisplayMode.');		
                LogLn(SDL_GetError);
            end;
			exit;
        end;
    //either way we should have a window and renderer by now...   
   if wantFullscreen then begin
       //I dont know about double buffers yet but this looks yuumy..
       //SDL_SetVideoMode(MaxX, MaxY, bpp, SDL_DOUBLEBUF|SDL_FULLSCREEN);

       flags:=(SDL_GetWindowFlags(window));
       flags:=flags or SDL_WINDOW_FULLSCREEN_DESKTOP; //fake it till u make it..
       //we dont want to change HW videomodes because 4bpp isnt supported.
       
       
       if ((flags and SDL_WINDOW_FULLSCREEN_DESKTOP) <> 0) then begin
            SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'linear');
            SDL_RenderSetLogicalSize(renderer, MaxX, MaxY);
       end;

	   IsThere:=SDL_SetWindowFullscreen(window, flags);

  	   thisMode:=getgraphmode;
  	   if ( IsThere < 0 ) then begin
    	      if IsConsoleInvoked then begin
    	         LogLn('Unable to set FS: ', thismode);
    	         LogLn('SDL reports: ',' ', SDL_GetError);      
     	      end;
              FSNotPossible:=true;      
       
          //if we failed then just gimmie a yuge window..      
          SDL_SetWindowSize(window, MaxX, MaxY);
          SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set FS.','OK',NIL);
          if IsConsoleInvoked then begin            
            LogLn('ERROR: SDL cannot set FS.');
            LogLn(SDL_GetError);
          end;
          exit;
       end;

    end;

  //reset palette data
  if bpp=4 then
    InitPalette16;
  if bpp=8 then 
    InitPalette256; 
  //then set it back up

  if (bpp<=8) then begin
      if MaxColors=16 then
            SDL_SetPaletteColors(palette,TPalette16.colors,0,16)
	  else if MaxColors=256 then
            SDL_SetPaletteColors(palette,TPalette256.colors,0,256);
  end;
  SDL_SetRenderDrawColor(renderer, $00, $00, $00, $FF); 
  SDL_RenderClear(Renderer);

end;

end;

function getgraphmode:string; 
//it could also be that the monitor output is not in the modelist
var
    bppstring:string;
    format:PSDL_PixelFormat;
    MaxMode:integer;
    findX,findY:word;
    findbpp:byte;
    thismode:PSDL_DisplayMode;

begin
   if LIBGRAPHICS_ACTIVE then begin 
        SDL_GetCurrentDisplayMode(0, thismode); //go get w,h,format and refresh rate..
        findX:=MainSurface^.w;
		findY:=MainSurface^.h;
		x:=0;
        //we need to find X,Y,BPP in the modelist somehow...
		while (x< (Ord(High(Graphics_Modes))-1)) do begin
			if (findX=MaxX) and (findY=MaxY)  then begin		
                    if (MainSurface^.format^.BitsPerPixel<>bpp) then break;			       	
                    //typinfo shit:                      	
			        getgraphmode:=GetEnumName(TypeInfo(Graphics_modes), Ord(x));
					exit;
			end;
            
            bpp:=bpp * bpp; //bpp^2 - if x and y match, save time
			inc(x);
		end;
        if IsConsoleInvoked then begin
            LogLN('Cant find current mode in modelist.');
        end;
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: Cant find current mode in modelist.','OK',NIL);        
   end;   
end;    

procedure restorecrtmode; //wrapped closegraph function
begin
  if (not LIBGRAPHICS_ACTIVE) then begin //if not in use, then dont call me...

	if IsConsoleInvoked then 
        LogLn('you didnt call initGraph yet...try again?') 
    else
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Restore WHAT exactly?','Clarify the Stupid',NIL);
  end;
  closegraph;
end;

function getmaxX:word;
var
	w,h:word;
	
begin
   if LIBGRAPHICS_ACTIVE then
   //pulling from ModeList data is much faster than querying the renderer or unfetching rendered surface data
   //if graphics is active- assume we have the data set.
     getMaxX:=(MaxX - 1); 
end;

function getmaxY:word;
begin
   if LIBGRAPHICS_ACTIVE then
     GetMaxY:=(MaxY - 1); 
end;

{ 

Blitter, Blittering, Blits, BitBlit (or RenderCopy- with a maybe on freeSurface..)

Wikipedia-

A blitter is a circuit, sometimes as a coprocessor or a logic block on a microprocessor, 
dedicated to the rapid movement and modification of data within a computer's memory.

A blitter can copy large quantities of data from one memory area to another relatively quickly, 
and in parallel with the CPU, while freeing up the CPU's more complex capabilities for other operations. 

A typical use for a blitter is the movement of a bitmap, such as windows and fonts in a graphical user interface 
or images and backgrounds in a 2D computer game. 

The name comes from the bit blit operation of the 1973 Xerox Alto, which stands for bit-block transfer.

A "blit operation" is more than a memory copy, because it can involve data that's not byte aligned 
(hence the bit in bit blit), handling transparent pixels (pixels which should not overwrite the destination data), 
and various ways of combining the source and destination data.

//NewLayer is a loaded (BMP) pointer (filled rect)

// SDL_BlitSurface(NewLayer, nil,MainSurface,nil);


//procedure HowBlit(currentwriteMode);
    //perpixel anything is horrendously slow. use the "blitting cpu functions" to our advantage instead.

--shift the palette,stupid
    --apply the shifted palette to the blit
        BLIT
        RenderCopy 
        reset the palette and renderPresent

        //xorBlit
        //andBlit
        //orBlit
        //notBlit(inverted colors)

//GetSurface from Renderer (or Create SurfaceFromRenderer) 
SDL_ScrollX(Surface,DifX);
SDL_ScrollY(Surface,DifY);
//Then renderCopy it back as a "texture"


if youre looking for batched ops:

procedure BatchRenderPixels;
var 
  PolyArray=array[1..points] of SDL_Point;

begin
  polyarray[1].x:=5
  polyarray[1].y:=3

  polyarray[2].x:=7
  polyarray[2].y:=7

  SDL_RenderDrawPoints( renderer,polyarray,points);  
end;


Polygons:
    SDL_RenderDrawLines(renderer,LineData,numLines);

}

function GetPixel(x,y:integer):DWord;

// this function is "inconsistently fucked" from C...so lets standardize it...
// this works, its hackish -but it works..SDL_GetPixel is for Surfaces/screens, not renderers.
var
  format:longword;
  TempSurface:PSDL_Surface;
  bpp:byte;
  p:pointer; //the pixel data we want 
  GotColor:PSDL_Color;
  pewpew:longword; //DWord....
  pointpew:PtrUInt;
  r,g,b,a:PUInt8;
  index:byte;
  someDWord:DWord;


begin
	rect^.x:=x;
    rect^.y:=y;
	rect^.h:=1;
	rect^.w:=1;
    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

//we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;


    //(we do this backwards....rendered to surface of the size of 1 pixel)
    if ((MaxColors=256) or (MaxColors=16)) then TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 8, format) 
    //its weird...get 4bit indexed colors list in longword format but force me into 256 color mode???

    else if (MaxColors>256) then begin
        case (bpp) of
		    15: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 15, format); 
			16: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 16, format); 
			24: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 24, format); 
			32: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 32, format); 
			else begin
				SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Wrong bpp given to get a pixel. I dont how you did this.','OK',NIL);
				 if IsConsoleInvoked then
                LogLn('Wrong bpp given to get a pixel. I dont how you did this.');
			end;

		end;
     end;

    //read a 1x1 rectangle....
    SDL_RenderReadPixels(renderer, rect, format, TempSurface^.pixels, TempSurface^.pitch);


    p:=TempSurface^.pixels;  
    bpp := TempSurface^.format^.BytesPerPixel; 
    //The C is flawed! 15bpp not taken into account.
    //ignorance is stupidity and laziness!

    // Here TempSurface^.pixels is the address to the pixel data (1px) we want to retrieve
    

{

"nuking the problem" (unnessessary overcomplication)
 the problem - not well documented for surfaces in C-

is thusly:

  P can be of any size up to 32bit values (because sdl doesnt support 64bit modes)

  is P a byte? (16/256 colors)
  is P a Word? NO. NEVER.Not enough BPP data returned.
  is P a partial DWord? (15/16bit/24bit colors) - spew SDL_Color data (for each byte inside P), 
      then fetch an appropriate DWord from that
      (this is a bitwise operation, so we need the DWord inside the pointer to work with the data)

  is P a DWord? (32bit colors)

no type conversion is needed as pointers are flexible
however endianness, although it should be checked for (ALWALYS) plays no role in how P is interpreted.

-and people wonder why thier data coming back from P is flawed?? mhm...

-you nuked it!

}
    case (bpp) of 
       8:begin //256 colors
        //now take the longword output 

          //check for the hidden 4bpp modes we made available
          if MaxColors=16 then begin
             index:=ord(Byte(^p));
             GetPixel:=Tpalette16.Dwords[index];
          end;

          //ok safely in 256 colors mode
          if MaxColors=256 then begin
             index:=ord(Byte(^p));
             GetPixel:=Tpalette256.Dwords[index];
          end;
          exit;
      end;

//these three need some work
//not its not a trick, we need the alpha-bit set to FF on non 32bit colors.
//its ignored but its also "padded data"

      15: begin //15bit
            //to do this one- we split out the RGB pairs, shift them,then recombine them.
            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );;
	         gotcolor^.b:=(byte(^b) );

            //shift adjust me
			gotcolor^.r:= (gotcolor^.r shr 3);
			gotcolor^.g:= (gotcolor^.g shr 3);
			gotcolor^.b:= (gotcolor^.b shr 3) ;

            //repack
            someDWord:= SDL_MapRGB(TempSurface^.format,gotcolor^.r,gotcolor^.g,gotcolor^.b);
            GetPixel:=someDWord;
            exit;
      end;
      16: begin //16bit-565
        //    if (TempSurface^.format=SDL_PIXELFORMAT_RGB565) then begin

            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );;
	         gotcolor^.b:=(byte(^b) );

            //shift adjust me
			gotcolor^.r:= (gotcolor^.r shr 3);
			gotcolor^.g:= (gotcolor^.g shr 2);
			gotcolor^.b:= (gotcolor^.b shr 3) ;

           //repack
            someDWord:= SDL_MapRGB(TempSurface^.format,gotcolor^.r,gotcolor^.g,gotcolor^.b);
            GetPixel:=someDWord;
      		exit;
      end;


      24: begin //24bit
            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );
	         gotcolor^.b:=(byte(^b) );
           //repack
            someDWord:= SDL_MapRGB(TempSurface^.format,gotcolor^.r,gotcolor^.g,gotcolor^.b);
            GetPixel:=someDWord;
			exit;
      end;
      32: //32bit

	        GetPixel:=DWord(p);
   
      else
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get Pixel values...','OK',NIL);
         if IsConsoleInvoked then
                LogLn('Cant Put Pixel values...');
    end; //case

    SDL_FreeSurface(Tempsurface);
    
end;


Procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word);

begin
//SDL_renderDrawPoint uses _fgcolor set with SDL_SetRenderDrawColor

  if (bpp<4) or (bpp >32) then
 
  begin
    		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Put Pixel values...','OK',NIL);
            if IsConsoleInvoked then
                LogLn('Cant Put Pixel values...');
			exit;
  end;
  SDL_RenderDrawPoint( Renderer, X, Y );
  
end;


function getdrivername:string;
begin
//not really used anymore-this isnt dos

   getdrivername:='Internal.SDL'; //be a smartASS
end;


//FIXME:dont use Graphics_mode=detect for the moment.
//(reqd fix for version 1.0)

//we should limit detectGraph calls also and allow quick checks if libGfx is already active.

Function detectGraph:byte; //should return max mode supported(enum value) -but cant be negative
//called *once* per "graphics init"-which is only called if not active.

//we detected a mode or we didnt. If we failed, exit. (we should have at least one graphics mode)
//if we succeeeded- get the highest mode.

//we only need the entire list (enum) while probing. The DATA is in the initgraph subroutine.

var

    i,testbpp:integer;

begin

//if InitGraph then...
//(AND ONLY WHILE INITing....initgraph needs to call us)

{
BAD C detected!

this is the "shove a byte where a boolean goes bug" in C...(boolean words etc..)
if its zero then its not ok. we dont want any other mode or similar mode...
in this case-
    if its 1, we found the mode.

the trick is to prevent SDL from setting "whatever is closest"..we want this mode and only this...
most people dont usually care but with the BGI -WE DO.

SDL_VideoModeOK:
    this is SDLv1.2 code
    IT also assumes that you want to switch physical screen modes(we dont) 
        (like telling X11 to drop to 320x240x256-we dont want this)
        -we will stretch for higher resolutions, or use a window for lower resolutions

SDL2:

    How do we scan the unknown? 
    1- ask SDL for supported list of Modes supported (solve X by providing it)
    2- we have to compare it to something. This is the puzzle-to what? 
        we are set higher than the mode we want. (We WANT the unsupported modes and depths)

so- we get the current screen resolution and check if requested mode is smaller-if so, GOOD.
(if its bigger, then we have a problem. DROP one mode with same color depth.)


}

{    i:=(Ord(High(Graphics_Modes))-1)

    //CurrentMode:=SDL_GetCurrentMode	 
	repeat

   		testbpp:=SDL_VideoModeOK(modelist.width[i], modelist.height[i], modelist.bpp[i], _initflag); //flags from initgraph

        //if Currentmode=ModeRequested (testbpp=1) then...
	 
        if (testbpp=1) then begin 
            
            //initGraph just wants the number of the enum value, which we check for
            DetectGraph:=byte(i); 
            exit;
    	end;
		dec(i);
	until i:=1;
    //there is still one mode remaining.
	testbpp:=SDL_VideoModeOK(modelist.width[i], modelist.height[i], modelist.bpp[i], _initflag);		         
	if (testbpp=0) then begin //did we run out of modes?
        if IsConsoleInvoked then
            writeln('We ran out of modes to check.');
            //LogLn('We ran out of modes to check.');
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'There are no graphics modes available to set. Bailing..','OK',NIL);
		CloseGraph; 
	end;
	DetectGraph:=byte(i);

	//usermode should be within these parameters, however, since that cant be checked for...
	//why not just remove it(usermode)? [enforce sanity]
    //otherwise we need to see if its valid data too....or skew up SDL window output and rendering.....
    //-which is wrong.
}

end; //detectGraph


function getmaxmode:string;
var
   maxmodetest:byte;
begin
  if LIBGRAPHICS_ACTIVE then begin
      maxmodetest:=detectgraph;
      getmaxmode:=GetEnumName(TypeInfo(graphics_modes, Ord(maxmodetest); //use the number and get the name of it.
  end;
end;


//the only real use for the "driver" setting...
procedure getmoderange(graphdriver:integer);
var
     maxmodetest:MaxModeSupported;
begin

	if not graphdriver = detect then begin
  		if (graphdriver = VGA) then begin
    		  lomode := VGALO;
    		  himode := VGA1024;
  		end else

  		if (graphdriver= VESA) then begin
    		 lomode := mCGA;
    		 himode := m1920x1080xMil;
  		end else

		if (graphdriver = mCGA) then begin
    	  lomode := mCGA;
    	  himode := mCGA;
  		end;

	end else begin
        if (graphdriver=DETECT) then begin
            himode:=detectgraph;	 //unfortunate probe here...   	
// FIXME: return value: (byte to enum value conversion?? - or use a bunch of consts)
// default enum type reads: longword

	    	lomode:= mCGA; //no less than this.
		end else begin
			if IsConsoleEnabled then
				Logln('Unknown graphdriver setting.');
			SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Unknown graphdriver setting.','ok',NIL);
		end;
	end;
end; //getModeRange



//(Its an odd rare case,such as TnL --not discussed here)

function cloneSurface(surface1:PSDL_Surface):PSDL_Surface;
//Lets take the surface to the copy machine...

begin
    cloneSurface := SDL_ConvertSurface(Surface1, Surface1^.format, Surface1^.flags);
end;

{viewports-
    the trick is that we are technically always in one(FPC).
    the joke is:
         what are the co ords?

this might not be BGI spec- but it makes sense.

}

procedure SetViewPort(Rect:PSDL_Rect);

var
    LastRect:PSDL_Rect;
    ScreenData:Pointer;
    infosurface,savesurface:PSDL_Surface;

begin
//freeze movement
   if windowcount=8 then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to create too many viewports.','OK',NIL);
      if IsConsoleInvoked then
        LogLn('Attempt to create too many viewports.');
      exit;
   end;
   //get viewport size and put into LastRect
   SDL_RenderGetViewport(renderer,Lastrect); 
   //current co ords = last, then add one.
   inc(windowcount);

   //LINUX claims of xor,xnor "not being supported"- so let "work around it".
   
  //store the current viewport data
  saveSurface = NiL;
  infosurface:=Nil;
  ScreenData:=Nil;

  //pixels and info abt the pixels. from the renderer-to a surface, then throw it back into a texture
  ScreenData:=GetPixels(LastRect);
  infoSurface := SDL_GetWindowSurface(SDLWindow);

  saveSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface^.w * infoSurface^.format^.BytesPerPixel), infoSurface^.format);

  if (saveSurface = NiL) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt create SDL_Surface from renderer pixel data','OK',NIL);
      LogLn('Couldnt create SDL_Surface from renderer pixel data. ');
      LogLn(SDL_GetError);
      exit;
                    
  end;
   
   Texture[windowcount]:=CreateTextureFromSurface(saveSurface);

   //free data
   SDL_FreeSurface(saveSurface);

   saveSurface = NiL;
   infosurface:=Nil;
   ScreenData:=Nil;
  

   SDL_RenderSetViewport( Renderer, Rect );  
   //clearviewport(_fgcoor);
  
   //"Clipping" is a joke- we always clip.
   //The trick is: do we zoom out? In Most cases- NO. We zoom IN.

end;


procedure RemoveViewPort(windowcount:byte);
//the opposite of above...
//set the last window coords..(we might be trying to write to them)
//and redraw the prior window as if the new one was not there(not an easy task).
var
  ThisRect,LastRect:PSDL_Rect;

begin

   if windowCount=0 then begin
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to remove non-existant viewport.','UH oh.',NIL);
  
    if IsConsoleInvoked then
        LogLn('Attempt to remove non-existant viewport.');
    exit; 
   end;
   if windowcount > 1 then begin
  		ThisRect^.X:=Textures[windowCount]^.X;
		ThisRect^.Y:=Textures[windowCount]^.Y;
	    ThisRect^.W:=Textures[windowCount]^.W;
	    ThisRect^.H:=Textures[windowCount]^.H;

        //get co ords of the previous

        LastRect^.X:=Textures[windowCount-1]^.X;
 	    LastRect^.Y:=Textures[windowCount-1]^.Y;
 	    LastRect^.W:=Textures[windowCount-1]^.W;
	    LastRect^.H:=Textures[windowCount-1]^.H;
   
       //remove the viewport by removing the texture and redrawing the screen.
       //the problem with textures is that they are part of a one-way road. ARG!

        Textures[windowcount]:=nil; //Destroy the current Texture
        RenderCopy(Textures[windowcount-1]);
        RenderPresent(renderer);

		SDL_RenderSetViewport( Renderer, LastRect ); 
        dec(windowcount);
//unfreeze movement
        exit;
   end; 
   //else: last window remaining
   Textures[1]:=nil;
   SDL_RenderSetViewport( Renderer,nil);  //reset to full size "screen"

   //this only works if we freeze input and dont update the screen- otherwise, we jitter
   // and update with old data on the "overlayed area".

   RenderCopy(Renderer,Textures[0]);
   RenderPresent(renderer); //and update back to the old screen before the viewports came here.

   LastRect:=(0,0,MaxX,MaxY);
   dec(windowscount);
   //unfreeze movement
end;



//compatibility
//these were hooks to load or unload "driver support code modules" (mostly for DOS)
procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
begin
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Function No longer supported: InstallUserDriver','OK',NIL);
   LogLn('Function No longer supported: InstallUserDriver');
end;

procedure RegisterBGIDriver(driver: pointer);

begin
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Function No longer supported: RegisterBGIDriver','OK',NIL);
   LogLn('Function No longer supported: RegisterBGIDriver');
end;


function GetMaxColor: word;
//Use "MaxColors" if looking to use Random(Color).
//This gives you the HUMAN READABLE MAX amount of colors available.
  
begin
      GetMaxColor:=MaxColors+1; // based on an index of zero so add one 255=>256
end;



//alloc a new texture and flap data onto screen (or scrape data off of it) into a file.


//yes we can do other than BMP.

procedure LoadImage(filename:string; Rect:PSDL_Rect);
//Rect: I need to know what size you want the imported image, and where you want it.

var
  tex:PSDL_Texture;

begin

    tex:= NiL;
    Tex:=IMG_LoadTexture(renderer,filename);
    SDL_RenderCopy(renderer, tex, Nil, rect); //PutImage at x,y but only for size of WxH
end;

procedure LoadImageStretched(filename:string);

var
  tex:PSDL_Texture;

begin

    tex:= NiL;
    Tex:=IMG_LoadTexture(renderer,filename); 
    SDL_RenderCopy(renderer, tex, Nil, Nil); //scales image to output window size(size of undefined Rect)
end;

//linestyle is: (patten,thickness) "passed together" (QUE)
//this uses thickness variable only

procedure PlotPixelWNeighbors(x,y:integer);
//this makes the bigger Pixels
 
// (in other words "blocky bullet holes"...)  
// EXPERT topic: smoothing reduces jagged edges

begin                
   //more efficient to render a Rect.

   New(Rect);
   Rect.x:=x;
   Rect.y:=y;
   case (LineStyle.thickness) of
       NormalWidth: begin
             Rect.w:=2;
			 Rect.h:=2;   
       end;
       ThickWidth: begin  
             Rect.w:=4;
			 Rect.h:=4;   
       end;
       VeryThickWidth: begin
             Rect.w:=6;
			 Rect.h:=6;   
       end;
       VeryVeryThickWidth: begin  
             Rect.w:=8;
			 Rect.h:=8;   
       end;
   end;
   SDL_RenderFillRect(renderer, rect);
// limit calls to "render present"
//   SDL_RenderPresent(renderer);
   Free(Rect);
   //now restore x and y
   case LineStyle of
		NormalWidth:begin
			x:=x+2;
			y:=y+2;   		
		end;
		ThickWidth:begin
			x:=x+4;
			y:=y+4;  
		end;
		VeryThickWidth: begin
            x:=x+6;
			y:=y+6;  
       end;
       VeryVeryThickWidth: begin  
            x:=x+8;
			y:=y+8;  
       end;
   end;
end;


procedure SaveBMPImage(filename:string);
//hmmm stuck with this for time being
var
  ScreenData:Pointer;
  infosurface,savesurface:PSDL_Surface;

begin
//the downside is that upon ea sdl init for our app/game..this resets.

  filename:='screenshot'+int2str(screenshots)+'.bmp';
  //screenshotXXXXX.BMP
  saveSurface = NiL;
  infosurface:=Nil;
  ScreenData:=Nil;
  ScreenData:=GetPixels(Nil); 
  
  infoSurface := SDL_GetWindowSurface(SDLWindow);
  saveSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface^.w * infoSurface^.format^.BytesPerPixel), infoSurface^.format);

  if (saveSurface = NiL) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt create SDL_Surface from renderer pixel data','OK',NIL);
      if IsConsoleInvoked then begin
          LogLn('Couldnt create SDL_Surface from renderer pixel data');      
          LogLn(SDL_GetError);
      end;
      exit;
                    
  end;
  SDL_SaveBMP(saveSurface, filename);
  SDL_FreeSurface(saveSurface);
  saveSurface = NiL;
  infosurface:=Nil;
  ScreenData:=Nil;
  inc(Screenshots);
end;


//note this function is "slow ASS"


function GetPixels(Rect:PSDL_Rect):pointer;
//this does NOT return a single pixel by default and is written intentionally that way.
//GetPixel checks also the output pointer length and fudges it into a single "SDL_Color".

//this routine expects YOU to handle the array of data
//SDL_Color SDL_Color SDL_Color .....

var

  pitch:integer;
  pixels:pointer; //^array [0..x*y] of SDL_Color

{
  the array size is dependant on current screen resoluton- I can only give MAXIMUM defaults if I set this value.
  This is an SDL_Color limitation. If it were me, Id just copy the array in 2D, not 1D.
  Yes, technically, even kernel write to screen are stored in VRAM(or buffers) as:
		[X,Y,RGBColor] however...SDL treats it as a 1D array.

  I didnt design SDL, sorry. Maybe thats why its SLOW???
  src: VGA graphics 101 - address A000, 386+ VRAM (and LFB) access.
  NOTE: 
     You probly CANNOT directly write here.. (blame X11 or Windows or Apple)
     (Because youre staring at the array right now, reading this.)
}

  AttemptRead:integer;

begin
   if ((Rect^.w=1) or (Rect^.h=1)) then begin    
     if IsConsoleInvoked then begin       
        LogLn('USE GetPixel. This routine FETCHES MORE THAN ONE');
     end;  
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'USE GetPixel. This routine FETCHES MORE THAN ONE','OK',NIL);
     exit;
   end;

   pixels:=Nil;
   pitch:=0;

                 
    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

//we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;
//format and rect we already can derive
//pixels and pitch will be returned for the given rect in SDL_Color format given by our set definition
//rect is Nil to copy the entire rendering target

   AttemptRead:= SDL_RenderReadPixels( renderer, rect, format, pixels, pitch);
   
   //pitch at this point could be 2,3,4,etc.. and must otherwise be taken into account.
   if (AttemptRead<0) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to read pixel data failed.','OK',NIL);
      if IsConsoleInvoked then begin
          LogLn('Attempt to read pixel data failed.');
          LogLn(SDL_GetError);
      end;
     exit;
   end;
   GetPixels:=pixels;
end;




begin  //main()


{$ifdef unix}
IsConsoleApp:=true; //All Linux apps are console apps-SMH.

  if (GetEnvironmentVariable('DISPLAY') = Nil) then LoadlibSVGA:=true;

{
  libSVGA note:
		NO- Im not rewriting THAT TOO!

  -Although maybe we could "hook the C"-inadvertently enabling FreeDOS support for "SDL and associates"
   Graphics modes. There is some BASIC support with HXDPMI and its associate Win32 loaders....
   (I have personally not had a practical use for it yet.) 
   
  PCs boot in x86 mode-(or emu86 mode) in 8bit-jump to 16/32/64 bits unless EFI loaded (into 64). 
  FREEDOS takes advantage of emu86 mode-(so does DosBox--or is it DosEmu)??
  Anyway- DPMI kicks us back into 16 and 32 bit operating modes.
  
  in all practicallity- libSVGA libs may set the screen up--
  but everyone depends on libX11, libCocoa(OSX),libCarbon(OSX),or WinAPI these days...
  you are going to be limited to the LFB--which is very slow compared to NATIVE DRIVERS.
  
  There's no reason we shouldnt utilize libSVGA if its our only option, however.
  This may require - as a result SDLv1, not SDLv2- due to video ram constraints.
  
  (There has to be some reason you arent running X11....)
  
  if X11 EVER gets loaded- then libSVGA is out-of-the-question.
  libSVGA is extremely unpractical on most modern day "workstations" and "common PCs".
  (This is why it has no future support in FreePascal)
  
  But let's say you are running a specific setup (NASA? BOEING? FLight controls, etc.) and dont want X11:
  -what then?
       
       You can load the driver module and associated LFB- but is it "accelerated" without X11? 
  
  This is the case of "Nuking it" or "not thinking at all" when writing code- instead of planning for "as many
  as possible" scenarios.
  
  A more NATIVE OPTION- would be to do Fullscreen "initgraph" within X11/Windows/OSX.
  This unit DOES accomplish this.
}
{$ENDIF}

//while I dont like the assumption that all linux apps are console apps- technically its true.

//I dont see the need for the LCL with SDL/OGL but anyways...
{$IFDEF LCL}
        Log:=true;
        {$IFDEF windows}
			IsConsoleInvoked:=false; //ui app- NO CONSOLE AVAILABLE
        {$ENDIF}
{$ENDIF}


//with initgraph (as a function) it returns one of these codes
//these are the strings of the error codes

   screenshots:=00000000;

   windownumber:=0;
   grError[0]:='No Error';
   grError[1]:='Not enough memory for graphics';
   grError[2]:='Not enough memory to load font';
   grError[3]:='Font file not found';
   grError[4]:='Invalid graphics mode';
   grError[5]:='General Graphics error';
   grError[6]:='Graphics I/O error';
   grError[7]:='Invalid font';

end.
