Unit LazGFX; 

//this is an FPC unit, not a Delphi or Borland one. Compile accordingly.
//Borland version?? EH? You must be dreaming... 
//I could cripple this unit and still use fpc, but I have to compile a few bins first(i8086).

{$IFNDEF fpc}
 {$Fatal FPC Compiler not used, extended Pascal syntax (OBJ-P) is required.} 
{$ENDIF}

{$mode objfpc}

//Range and overflow checks =ON
{$Q+}
{$R+}

//TypeInfo(required)
{$M+}

{$IFDEF debug}
//memory tracing, along with heap.
	{$S+}
{$ENDIF}


{
A "fully creative rewrite" of the "Borland Graphic Interface" in SDLv1 (c) 2017-18 (and beyond) Richard Jasmin
-with the assistance of others.

** DONT OVERTHINK THIS UNIT**

There are easy solutions to these problems imposed upon us by SDL/ lack of a BGI.
(The BGI doesnt need AA lines...)

SDL unifies and simplifies programming for DirectX(D2D), Quartz2D, and X11(A REAL PAIN)- but it doesnt go far enough.
However- the syntax is unfamiliar to most to be of use. Hence the "BGI port".

The only SDL unit needed is SDL Pascal unit I have provided-
smaller platforms wil need to 'break out the headers'. (FPC on modern systems is not affected by this.)

(I am writing this on AMD64 Quad and OCTO core system >2.5Ghz with gigabytes of RAM -and VRAM- at my disposal)

GDI/GDI+ and core X11 Primitive ops(prior to XOrg merge) are excrutiatingly slow.
Please build on a newer X11. SDL1 cannot reliably use X11 acceleration (or 2d acceleration) using the older X11 (vs XOrg) system.


Byte/SmallInt are 8bit references
Word/Integer are 16bit references
Longword are 32bit references
QuadWords are 64bit references

**Code Intentionally uses forced 32bit references.**

Too many shortcuts are taken with most BGI graphics units.

This is the 'most complete' version that I have found. 
As far as compatibility- I am porting some C here- to fix this.
A lot was added. SOME WAS CHANGED.

--Jazz


Apache/Mozilla licensed(FREED). I dont want to hear bitching about the changes in license.


Sections from FPC unit are from Jonas Maebe-and other where noted.

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
*including commercial applications and resale*, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software *must not be misrepresented*; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
   
3. This notice may not be removed or altered from any source distribution.

--

This unit is for compatiblility (FPC can pull in this unit - if done correctly) bypassing 
FPCs ANCIENT libSVGA unit version of libGraph and "compensating for using X11" these days.

That old FPC libSVGA unit "may be useful" once we get Framebuffer or KMS functional-
either as a fallback- or for RasPi. Within X11, the code is useless (and an archaic dinosaur).

Although designed "for games programming"..the integration involved by the USE, ABUSE, and REUSE-
of SDL and X11Core/WinAPI highlights so many OS internals its not even funny.

Anyone serious enough to work with SDL on an ongoing basis- is doing some SERIOUS development,
moreso if they are "expanding the reach" of SDL using a language "without much love" such as FreePascal.

True event driven applications and games REQUIRE OS (win/mac and linux internals) programming skills(min 4yr college equiv).
Just dont think you can fake your way thru college- you code will speak to your shortcuts. 

Its easier to fix my code than patch the SDL headers, which appear flawed at the moment. 
YAAY FOR FLAWED CODE!
 
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


---
Some notes before we begin:

In LAzarus but writing without GUI/Lazarus (as a Console Application)
(some of you prefer this environment)

Project-> Console App or
Project-> Program

Set Run Parameters:
"Use Launcher" -to enable runwait.sh and console output (otherwise you might not see it)

For fp(TUI IDE) binary(windows/dos this ends in .exe):

set paths as folows:

unices:

    /usr/lib/fpc/<version>/units/$fpctarget
    /usr/lib/fpc/<version>/units/$fpctarget/*
    /usr/lib/fpc/<version>/units/$fpctarget/rtl
<point to sdl file Ive included- or -put it here:  /usr/lib/fpc/<version>/units/SDL>

windows:

    C:\fpc\<version>\units\$fpctarget
    C:\fpc\<version>\units\$fpctarget\*
    C:\fpc\<version>\units\$fpctarget\rtl
<point to sdl file Ive included- or -put it here:  C:\fpc\<version>\units\SDL>

---
Most Games (and Game consoles dont have a debugging output window)

-This code can check for the LCL- but you wont be able to use it WITH the LCL.
(shoot self in foot twice, Laz DEVS...hand over the window handlde and context, please....)

---

We will have some limits:

        Namely VRAM
        Because if its not onscreen, its in RAM or funneled thru the CPU somewhere...
        You might have 12Gb fre of RAM, but not 256mb of VRAM. 

        Older systems could have as less as 16MB VRAM, most notebooks within 5-10 years should have 256.
        The only way to work with these systems is to clear EVERYTHING REPEATEDLY or use CPU and RAM to your advantage.
        (There is a way..)

Many dont understand SDLv1 use- then get thrown and force fed SDL2.x and GPU_ functions.



How to write good games:
        -learn to thread and use callback interrupts-

SDL1.2 (learn to page flip)
SDL2.0 (renderer and "render to textures as surfaces")

OGL (straight)

aux libs:

	uOS (sound)
	Synapse/Synaser (net, pascal compatible)

You need to know:

        event-driven input and rendering loops (forget the console and ReadKEY)

I dont know how many times that Ive seen readkey used....IN "EVENT DRIVEN" APPLICATIONS and LIBRARIES.         
DO NOT IGNORE A VERY IMPORTANT INTERRUPT-BASED PART OF YOUR OPERATING SYSTEM!!
         
---

There is a lot of plugins for SDL/SDLv2 and that initially confused the heck out of me.
Most of those were ported to FPC by JEDI team. I have cleaned that mess up, except for depends.
JEDI is more like "JOKER PASCAL DEV-TEAM". A bunch of nobodys, no contact info, no nothing...and sloppy work at best.
The code is now vaporware- as is thier website and linked data.


SDL_Image is JPEG, TIF, PNG support (BMP is in SDL(core))
(you will likely want this unit)


Circle/ellipse:
The difference between an ellipse and a circle is that "an ellipse is corrected for the aspect ratio".
(ellipses are flattened on two sides)

FONTS:

    I have some base fonts- most likely your OS has some - but not standardized ones.

    **We do NOT use bitmapped fonts- we use TTF**.
    In many ways this is better. BitMapped fonts are being removed in "new code".


Lazarus TCanvas unit(s) (graph, graphics) are severely lacking. 
There is another project being brought alongsie this one to fix TCanvas.


The FPC devs assume you can understand OpenGL right away...thats bad. GL LAz demos are also broken.
I dont agree w "basic drawing primitives" being an "objectified mess".

OpenGL is NOT DESIGNED FOR 2D OPERATIONS. NOT REALLY.


HELP:

SDL and JEDI have been poorly documented.

1- FPC code seems doggishly slow to update when bugs are discovered. Meanwhile SDL chugs along in C.
(Then we have to BACKPORT the changes again.)

2- The "pascal/lazarus graphics unit" changes as per the HOST OS. 
Usually not a problem unless doing kernel development -but its an objective Pascal nightmare.


uOS support adds "wave, mp3, etc" sounds instead of PC speaker beeping
(see the 'beep' command and enable the module -its blacklisted-on Linux) 

SDL_Audio "licensing issues" (Fraunhoffer/MP3 is a cash cow) -as with qb64, which also uses SDL- wreak havoc on us. 
(Yes- I Have a merge tree of qb64 that builds, just ask...)

The workaround is to use VLC/FFMpeg or other libraries. 

Linear Framebuffer is virtually required(OS Drivers) and bank switching has had some isues in DOS.
A lot of code back in the day(20 years ago) was written to use "banks"(MMU) due to color or VRAM limitations.
The dos mouse was broken due to bank switching (at some point). 

The way around it was to not need bank switching-by using a LFB. 


CGA and EGA have been properly "emulated" by palettes.
Your standard "Text mode hack" (16 colors) is "EGA palette emulation".
This was only possible on CGA screens by hacking the text mode ASCII character set.(CP850)
(This is why linux-es dont have those characters)


**THIS CODE is written for 32 AND 64 bit systems.**

Apparently the SDL/JEDI never got the 64-bit bugfix(GitHub, people...).
(A longword is not a longword- when its a QWord- or a pointer to one...)

USER FIXME: Error 216 usually indicates SDL BOUNDS errors(memory alloc and not FREE--a "memory leak")
SDL and OpenGL can fire errors with no debugging info and leave you clueless as to where to start debugging.
(SDL c units have not been compiled w debug support- if theres a download option-grab - or install the debugging units)

Get the release units, but while testing your code- use the debug version instead. Its a HUGE help.

----

Colors are bit banged to hell and back.

24 bits seems to be the SDL1 limit here, according to what Im reading.

Below 15bpp is an LUT emulated 24 bit array
15 and 16bit color uses word storage(16bit aligned for speed)
24 bit is an RGB tuple -padded to RGBA. A-bit is ignored, as with 15bit color(555).

USER FIXME: 
 
 		SDL is limited to 24bits. Opengl is NOT. "Mind your bytes"

Color data is as accurate as possible using data from the net.


Downsizing color bits:

-you cant put whats not there- you can only "dither down" or "fake it" by using "odd patterns".
what this is -is tricking your eyes with "almost similar pixel data".

most people use down conversion routines to guess at lower depth approx colors.

What this means is that for non-equal modes that are not "byte aligned" or "full bytes" (above 256 colors) 
you have to do color conversion or the colors will be "off".

Futher- forcing the video driver to accept non-aligned data slows things down-
        in case of opengl- it WILL crash things.

---

Note the HALF-LIFE/POSTAL implementation of SDL(steam):

    start with a window
    set window to FS (hide the window)
    draw to sdl buffer offscreen and/or blit(invisible rendering)
    PageFlip  (making content visible)

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

PNG/PNM itself may or may not work as intended with a black color as a "hole color".This is a known SDL issue.
PNG-Lite may come to the rescue- but I need the Pascal headers, not the C ones.


Not all games use a full 256-color (64x64) palette
This is even noted in SkyLander games lately with Activision.
"Bright happy cheery" Games use colors that are often "limited palettes" in use.

Fading is easy- taking away and adding color---not so much.
However- its not impossible.

TO FADE:

    you need two palettes for each color  :-)  and you need to step the colors used between the two values
    switching all colors (or each individual color) straight to grey wont work- the entire image would go grey.
    you want gracefully delayed steps(and block user input while doing it) over the course of nano-seconds.


I havent added in Android or MacOS modes yet.
You cant support "portable Apple devices". Apple forbids it w FPC.

---

**CORE EFFICIENCY FAILURE**:

Pixel rendering (the old school methods)

Our ops are restricted, even yet to "pixels" and not groups of them.
BLIT LIKE HELL!

TandL is a "pixel-based operation". If you use heavy TnL, expect slowdowns.


MessageBox:

With Working messageBox(es) we dont need the console.

InGame_MsgBox() routines (OVERLAYS like what Skyrim uses) still needs to be implemented.
FurtherMore, they need to match your given palette scheme. (I can only do so much, I can match the default bpp...)

GVision, routines can now be used where they could not before.
GVision requires Graphics modes(provided here) and TVision routines be present(or similar ones written).

FPC team is refusing to fix TVision bugs. 

        This is wrong.

That is like saying: 
	FPC DEVS dont support Win16 apps and programming(they do now).


Logging will be forced in the folowing conditions:

    under windows with LCL(no terminal)
    under linux with LCL compiled in
	Terminal(tty) ox XTerm calls us(background process under linux, not available with windows LCL-just dont use the LCL)

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


to animate- screen savers, etc...you need to (page)flip/rendercopy and use DELAYED rendering timers.


bounds:
   cap pixels at viewport
   off screen..gets ignored.
   zooms need to handle the extended size to accomadate "for the zoom"


on 2d games...you are effectively preloading the fore and aft areas on the 'level' like mario.
there are ways to reduce flickering -control renderClear/Flip. 

the damn thing should be loaded in memory anyhoo..
what.. 64K for a level? cmon....ITS ZOOMED IN....

  Move (texture,memory,sizeof(texture));

or Better yet:

  Move (texture,memory,sizeof(GraphicsBuffer));


NOTE:

Some SDL BUGS are - because of stupidity and BS programmers not understanding the material.
"EVERYTHING IS MUTABLE"

SDL TEAM:
    "You must render in the same (mainloop) that handles input." (NOPE)
EXPORT THE GRAPHICS CONTEXT and youll be FINER than A STEEL STRING GUITAR.
Now- export the input handler routine, or map a new one.
*PROBLEM SOLVED* 


SDL routines require more than just dropping a routine in here- 
    you have to know how the original routine wants the data-
        get it in the right format
        call the routine
        and if needed-catch errors, otherwise drop the routine's output.

The biggest problem with SDL is "the bloody syntax".

SDL is not SIMPLE. 
The BGI was SIMPLE.

"SemiDirect MultiMedia OverLayer" - should be the unit name.

SDL should be replaced with language specific routines(pull them out of SDL) instead- to optimise the code. 
(This will remove the need to export the GC, possibly input routines)

As far as LCL GOES- normally LCL adds an input layer (and window layer) to the mix if using SDL. 
(should it? perhaps we can pull the applications input routine and mod it?)

--Jazz (comments -and code- by me unless otherwise noted)

}

{$IFDEF DARWIN} //OSX
//Hackish...Determine whether we are on a PPC by the CPU endian-ness since we know
//that support stopped at 10.5 for PPC arch- and switched to Intel.
    {$IFDEF ENDIAN_BIG}
        {$modeswitch objectivec1}
    {$ELSE}
        //version 2 is => OSX 10.5(Leopard). This excludes PPC arch. Likely INTEL CPU model.
        {$modeswitch objectivec2} 
    {$ENDIF}
//same with carbon?
	{$linkframework Cocoa}

//not sure if need to add a few units here?
    {$linklib SDLimg}
    {$linklib SDLttf}
    {$linklib SDLnet}
	{$linklib SDLmain}
	{$linklib gcc}

{$ENDIF}

uses

//Threads requires baseunix unit
//cthreads has to be the first unit in this case-fpc so happens to support the C version.
//we are linking with C, not writing an independent unit.


{$IFDEF UNIX} //if coming from dos- use sysutils instead of the dos unit.
      cthreads,cmem,sysUtils,baseunix,    
{$ENDIF}

    ctypes,classes,

//ctypes: cint,uint,PTRUint,PTR-USINT,sint...etc.
//classes: needs mode fpcobj  -ensure the object-mode define(not oop code) attaches error handlers(and so we can also use them)


{$IFDEF MSWINDOWS} //as if theres a non-MS WINDOWS?
    Windows,MMsystem, //audio subsystem, use if DX audio fails. ONLY THEN. WAV support only.
      {$DEFINE NOCONSOLE }
{$ENDIF}

{$IFNDEF NOCONSOLE}
    crt,crtstuff,
{$ENDIF}

//FPC generic units(OS independent)
  SDL,strings,typinfo,logger,math

//Pulse and Sox can give us a beep(via commandline intervention)- but dont expect much in the way of a over-driven speaker.
//Its a one-shot deal with enough delay to make you BEEP , yourself!
//Its "good enough" for our needs.

//uos,FreeImage(instead of sdl_image)


//stipple is what "dashed lines" are called. Like the "stipple on your face".


//lets be fair to the compiler..
{$IFDEF debug} ,heaptrc {$ENDIF} 

//Carbon is OS 8 and 9 to OSX API
{$IFDEF macos} 
  ,MacOSAll
{$ENDIF}

{$IFDEF Darwin}
   {$Warning Why are you using SDL1 on OSX?}   
  ,CocoaAll, Files
{$ENDIF}
;

{
NOTES on units used:

crt is a failsafe "ncurses-ish"....output...
crtstuff is MY enhanced dialog unit 
    I will be porting this and maybe more to the graphics routines in this unit.


FPC Devs: "It might be wise to include cmem for speedups"
"The uses clause definition of cthreads, enables theaded applications"

(internal to SDL right now)
mutex(es):

The idea is to talk when you have the rubber chicken or to request it or wait until others are done.
Ideally you would mutex events and process them like cpu interrupts- one at a time.

You will see the use in a moment.
This is like  "critical code sections".

sephamores:
these are like using a loo in a castle- 
only so many can do it at once, first come- first served
- but theres more than one toilet

}

{

Modes and "the list":

byte because we cant have "the negativity"..
could be 5000 modes...we dont care...
the number is tricky..since we cant setup a variable here...its a "sequential byte".

yes we could do it another way...but then we have to pre-call the setup routine and do some other whacky crap.

"ins and outs" (and hacks) are replaced by a better equivalent.

Y not 4K modes?
1080p is reasonable stopping point until consumers buy better hardware...which takes years...
most computers support up to 1080p output..it will take some more lotta years for that to change.

primary reason: SDL stops at 32bit longwords. It was never designed for 64bits.
Reason being: systems didnt exist yet.

}

//scale output(via SDL) if resolution is lower then the window canvas size-or fullscreen.
//typically, interlacing is used - "to cheat"

//wherein 320xMil0 can be blown up to 640x480 (as 480i)
//if you dont want to upscale(fuzzy)- set "fat pixel mode" at intended resolution (and draw with neighbors).

//Droids and Pis can probably use "up to VGA modes" resolutions natively. Smaller screens= lower resolution needed.
//after 1024, modern hardware drops support for lower resolutions (and palettes), GL doesnt support less than 24bpp.
//I could force the issue(palettes), but why? Im using 24bpp inside the LUT.

//below 320 will probably be stretched anyways, the canvas is too small on modern screens.(Let me get to this)

//MAC: 640x480,800x600,1024x768 up to 24bpp is supported
//droids and pis will have to have weird half-resolutions and bpps added in later on.

//TrueColors modes (>24bpp) produce one problem: We can no longer track the maximum colors(exceeds bounds).
{
BitDepth	Colors 

1bit B/W = 2
2bit CGA = 4
4bit EGA = 16
8bit VGA = 256
15bit = 32k
16bit = 64k
24bit = 16M (max addressable colors with 32bit systems is: 4Million -2)
32bit (sadly,only supported in SDL2) = 4.2B -or (16M+blends) 
 
}
type
//this is as compatible as I can make it, we dont care which standard has the mode, just that it exists and works.
	graphics_modes=(

m160x100x16,
m320x200x4,m320x200x16,m320x200x256,
m640x200x2,m640x200x16,
m640x480x16, m640x480x256, m640x480x32k, m640x480x64k,m640x480xMil,
m800x600x16,m800x600x256,m800x600x32k,m800x800x64k,m800x600xMil,
m1024x768x16,m1024x768x256,m1024x768x32k,m1024x768x64k,m1024x768xMil,
m1280x720x256,m1280x720x32k,m1280x720x64k,m1280x720xMil,
m1280x1024x16,m1280x1024x256,m1280x1024x32k,m1280x1024x64k,m1280x1024xMil,
m1366x768x256,m1366x768x32k,m1366x768x64k,m1366x768xMil,
m1920x1080x256,m1920x1080x32k,m1920x1080x64k,m1920x1080xMil);

//data is in the main unit InitGraph routine.

Tmode=record
//non-negative and some values are yuuge
	ModeNumber:byte;
  	ModeName:string;
 	MaxColors:DWord; //LongWord or QWord?
    bpp:byte;
  	MaxX:Word;
    MaxY:Word;
	XAspect:byte;
	YAspect:byte;
	AspectRatio:real; //things are computed from this somehow...
end; //record


type  

//direct center of screen modded by half length of the line in each direction.
//For verticle line: use y, not x
//centeredHLine: (((x mod 2),(y mod 2)) - ((x1-x2) mod 2))

//how BIG is a pixel? its smaller than you think. 

//You are probly used to "MotionJPEG Quantization error BLOCKS" on your TV- those are not pixels. 
//Those are compression artifacts after loss of signal (or in weak signal areas). 
//That started after the DVD MPEG2 standard and digital TV signals came to be.


//when drawing a line- this is supposed to dictate if the line is dashed or not
//AND how thick it is. Centered is not what you think it means.

  LineStyle=(solid,dotted,center,dashed);
  Thickness=(normalwidth=1,thickwidth=3,superthickwidth=5,ultimateThickwidth=7);

//LineStyle and ThickNess are usually used together along with PutPixelHow (andPut, NotPut,etc) methods.
//It is extremely inefficient(unwise) to manipulate pixels in such a way otherwise.
//This is a very confusing chunk of borland API that was never intended to be "a public method".

//C style syntax-used to be a function, isnt anymore.
  grErrorType=(OK,NoGrMem,NoFontMem,FontNotFound,InvalidMode,GenError,IoError,InvalidFontType);


{
SURFACE: 

This is a "buffer copy" of all written string to the screen.
As long as we have this- we can print, and we can copy screen contents.

There is a difference betweek MainSurface(screen) and a back-buffer. 
Clearing the backbuffer(double buffering) does NOT clear the screen, it prepares the window for the next surface update.
(I got confused by this at first) 
 
You are used to single buffered (or directRendering function calls) with DOS-ish programming methods.

-OutText writes one char here until full- goes onto next line.
-OutTextLine just writes the whole array

Think of Text like a "Transparent Label" or "blitted clear sticker".

}

//PolyPoints, basically
  Points=record
	x,y:word;
  end;

  TArcCoordsType = record
      x,y : word;
      xstart,ystart : word;
      xend,yend : word;
  end;

  Twhere=record
     x,y:word;
  end;

//CHECKME:

 //   PTTF_Font=^TTF_Font;
    //TTF_Font

//A Ton of code enforces a viewport mandate- that even sans viewports- the screen is one.
//This is better used with screen shrinking effects such as status bars, etc.


//graphdriver is not really used half the time anyways..most people probe.
//these are range checked numbers internally.

	graphics_driver=(DETECT, CGA, VGA,VESA); //cga,vga,vesa,hdmi,hdmi1.2

//HATCHes(not hashes):

//This is a 8x8 (or 8x12) Font pattern (in HEX) according to the BGI sources(A BLITTER BITMAP in SDL)
//X11- at least, has this already implemented

//This was only meant for HiREs 1bit B/W CGA modes. It was not meant for color modes.
//You could hack this using blit patterns, like Paint apps do with the "rubber stamp".

   FillSettingsType = (clear,lines,slashes,THslashes,THBackSlashes,BackSlashes,SMBoxes,rhombus,wall,widePTs,DensePTS);

//For color modes use Blends, or "blit pixels interweaved with the background every so many pixels"




var

  thick:thickness;
  bpp:byte; 
//  mode:PSDL_DisplayMode;


//This is for updating sections or "viewports".
//I doubt we need much more than 4 viewports. Dialogs are handled seperately(and then removed)
  texBounds: array [0..4] of PSDL_Rect;
 
  windownumber:byte;
  somelineType:thickness;

//you only scroll,etc within a viewport- you cant escape from it without help.
//you can flip between them, however.

//think minimaps in games like Warcraft and Skyrim


{ 

INPUT:

This is like "interrupt based kernel programming"- DO NOT code as if "waiting on input"- 
    pray it happens, continue on- if it doesnt.

These are the types of events.

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

The newer SDL2 BGI rewrite (from the professor) seems to tackle this in a weird, but efficient way.
I will try to mimic (and test) his code.

}

const
   {$IFDEF mswindows} //I have my Own implementaion of this- works for win32 apps.
        IsConsole:boolean;
   {$ENDIF}
   //Analog joystick dead zone -joysticks seem to be slow to respond in some games....
   JOYSTICK_DEAD_ZONE = 8000;

var
    _graphresult:integer;
    Xaspect,YAspect:byte;

    eventLock: PSDL_Mutex;
    eventWait: PSDL_Cond;
    video_timer_id: TSDL_TimerID;

    palette:PSDL_Palette;
    where:Twhere;
	quit,minimized,paused,wantsFullIMGSupport,nojoy,exitloop,NeedFrameBuffer:boolean;
    nogoautorefresh:boolean;
    x,y:word;
    _grResult:grErrortype;
    
    gGameController:PSDL_Joystick;

    MainSurface,FontSurface : PSDL_Surface; //Fonts and TnL mostly at this point

    srcR,destR,TextRect:PSDL_Rect;
    //rmask,gmask,bmask,amask:longword;
 
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

These were originally compiled in fonts, like object code.

}

    font_size:integer; 
    style:byte; //BOLD,ITALIC,etc.
    outline:longint;
    grErrorStrings: array [0 .. 7] of string; //or typinfo value thereof..

{
older modes are not used, so y keep them in the list??
 (M)CGA because well..I think you KNOW WHY Im being called here....

 mode13h(320x200x16 or x256) : EXTREMELY COMMON GAME PROGRAMMING
 (we use the more square pixel mode)

Atari modes, etc. were removed. (double the res and pixelSize and we will talk)

}

  ClipPixels: Boolean=true; //always clip, never an option "not to".
  MaxColors:byte; //paletted code checks ONLY! 24bpp exceeds word boundary, CODE MUST BE 32bit compliant.
  //(SDL 1.2 limitation-older 32bit hardware)
  
  WantsJoyPad:boolean;
  screenshots:longint;

//CDROM access is very limited. LibUos tries to fix this.

//Used mostly for Audio CDs and RedBook Audio Games.
//such games have "CDROM Modeswitch delays" in accessing data while playing audio tracks(game skippage).

//Descent II(PC) and SonicCD(PC and SEGA CD Emu) come to mind.
//you would want ogg or mp3 or wav files these days- on some sort of storage medium.

  NonPalette, TrueColor,WantsAudioToo,WantsCDROM:boolean;	
  Blink:boolean;
  CenterText:boolean=false; //see crtstuff unit for the trick
  
  MaxX,MaxY:word;

  _fgcolor, _bgcolor:DWord;	//this is modified due to hi and true color support.
  //do not use old school index numbers. FETCH the "index based DWord" instead.  
  IndexedColor:Byte;  

  flip_timer_ms:Longint; //Time in MS between Render calls. (longint orlongword) -in C.

  //ideally ignore this and use GetTicks estimates with "Deltas"
  //this is bare minimum support.

  EventThread:Longint; //fpc uses Longint
  EventThreadReturnValue:LongInt; //Threads are supposed to return a error code
	
  Rect : PSDL_Rect;
  TriPoints: array[0..2] of Points;
  LIBGRAPHICS_ACTIVE:boolean;
  LIBGRAPHICS_INIT:boolean;
  RenderingDone:boolean; //did you want to pageflip now(or wait)?
  ForceSWSurface:boolean;
  IsConsoleInvoked,CantDoAudio:boolean; //will audio init? and the other is tripped NOT if in X11.
  //can we modeset in a framebuffer graphics mode? YES. 

  Event:PSDL_Event; //^SDL_Event
   
  himode,lomode:integer;

  r,g,b:PUInt8; //^Byte

  //TextureFormat
  format:LongInt;

//this pre-definition shit is a ~PITA~
//our data may differ from SDLs.

{
 
I dont know on this section,yet:
 

//the lists..
  Pmodelist=^TmodeList;

//wants graphics_modes??
  TmodeList=array [0 .. 40] of TMode;

  PSDLmodeList=^TSDLmodeList;
  TSDLmodeList=array [0 .. 40] of TSDL_DisplayMode;

//single mode
  Pmode=^TMode;
  PSDLmode=^TSDL_DisplayMode;

var

//modelist hacking

//pointers
//single modes

    SDLmodePointer:PSDLMode;
    modePointer:Pmode;

//list
    SDLmodeList:PSDLmodeList;
    modeListpointer:PmodeList;

//arrays
	ModeArray:TmodeList;
	SDLModeArray:TSDLmodeList;
}

//procedure defines
//function FetchModeList:Tmodelist;

procedure RoughSteinbergDither(filename,filename2:string);


//surfaceOps
procedure lock;
procedure unlock;

procedure clearscreen; 
procedure clearscreen(index:byte); overload;
procedure clearscreen(color:Dword); overload;
procedure clearscreen(r,g,b:byte); overload;
procedure clearscreen(r,g,b,a:byte); overload;

procedure clearviewport;
procedure closegraph;

function GetX:word;
function GetY:word;
function GetXY:longint; 

function initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean):PSDL_Surface;
procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 

function getgraphmode:string; 
procedure restorecrtmode;

function getmaxX:word;
function getmaxY:word;

function getdrivername:string;
Function detectGraph:byte;
function getmaxmode:string;
procedure getmoderange(graphdriver:integer);

procedure SetViewPort(Rect:PSDL_Rect);
procedure RemoveViewPort(windownumber:byte);

procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
procedure RegisterBGIDriver(driver: pointer);

function GetMaxColor: word;

procedure LoadImage(filename:PChar; Rect:PSDL_Rect);
procedure LoadImageStretched(filename:PChar);

procedure PlotPixelWithNeighbors(thick:thickness; x,y:word);

procedure SaveBMPImage(filename:string);

//pull a Rect off the surface-then kick out a pointer (to) a 1D array of SDL_Colors from inside the Rect
function GetPixels(Rect:PSDL_Rect):pointer;

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
   maxMode=Ord(High(Graphics_Modes));


{

256 and below "color" paletted modes-
this gets harder as we go along but this is the "last indexed mode". 

colors (indexes) above 255 should throw an error(undefined --and out of bounds). 

technically they are rgb(a) colors and have no index anymore
so we are in true colors and straight rgb/rgba after this.....

You need (full) DWords or RGB data for TRUE color modes.
 
'A' bit affects transparency and completes the 'DWord'.
The default setting is to ignore it(FF). This is what is set.

You only change this for 32bit blends.

Most bitmap or blitter or renderer or opengl based code uses some sort of shader(or composite image).
This isnt covered here.


-One step at a time.

each 256 SDL_color= r,g,b,a whereas in range of 0-255(FF FF) per color.
for 16 color modes we use 0-16(FF) normally. I dont. I use a LUT instead.
 
16 color mode is technically a wonky spec:
	officially this is composed of:  RGB plus I(light/dark) modes.
	in relaity this is: RGB+CMY colors whereas W+K colors are seperate- its not quite CMYK nor RGB with two intensities(7 or F)

CMYK isnt really a video color standard normally because pixels are RGB. 
CMYK is for printing. The reason has to do with color gamut and other huffy-puff.
(Learn photography if you want the color headache)
 
CGA modes threw us this curveball:
	4 color , 4 palette hi bit resolution modes that are half ass documented. 
	(think t shirt half-tones for screen printing)

VGA/SVGA (Video gate array / super video gate array) and VESA (video electronic standards association) modes are available now.

-of course SDL just simulates all of this (inside a window)


we can use SetColor(SkyBlue3); in 256 modes with this- since we know which color index it is.

this is only for the default palette of course- if you muck with it.....
 and only up to 256 colors....sorry.


blink is a "text attribute" ..a feature...
(write..wait.erase..wait..rewrite..)just like the blinking cursor..


colors: 

	MUST be hard defined to set the pallete prior to drawing.
	No 16 color bitshifting hacks allowed. They dont work anymore.
	    However: you can-
	         adjust the colors by some math
	         render something
	         and restore the colors before rendering again
			 then render something else
}

//"color names" are Tied to Static Consts up to 256 Colors.
// with 256Greys, its a "moot point".
//The Palette[MaxColors].DWords holds the values, so this can be any var we want, just be consistent.

//with consts, we can specify an index color as a name and we will get the index, as it were.
//(its also easier to copy palette colors with)

	BLACK=0;
	RED=1;
	BLUE=2;
	GREEN=3;
	CYAN=4;
	MAGENTA=5;
	BROWN=6;
	LTGRAY=7;
	GRAY=8;
	LTRED=9;
	LTBLUE=10;
	LTGREEN=11;
	LTCYAN=12;
	LTMAGENTA=13;
	YELLOW=14;
	WHITE=15;

//Greyscale colors dont have names.
//original xterm must have these stored somewhere as string data because parts of "unused holes" and "duplicate data" exist

// I can guarantee you a shade of slateBlue etc.. but not the exact shade.
//(thank you very much whichever programmer fucked this up for us)

Grey0=16;
NavyBlue=17;
DarkBlue=18;
Blue3=19;
Blue4=20;
Blue1=21;
DarkGreen=22;
DeepSkyBlue4=23;
DeepSkyBlue6=24;
DeepSkyBlue7=25;
DeepSkyBlue3=26;
DodgerBlue3=27;
DodgerBlue2=28;
Green4=29;
SpringGreen4=30;
Turquoise4=31;
DeepSkyBlue5=32;
DeepSkyBlue2=33;
DodgerBlue1=34;
Green3=35;
SpringGreen3=36;
DarkCyan=37;
LightSeaGreen=38;
DeepSkyBlue1=39;
DeepSkyBlue8=40;
Green5=41;
SpringGreen5=42;
SpringGreen1=43;
Cyan3=44;
DarkTurquoise=45;
Turquoise2=46;
Green1=47;
SpringGreen2=48;
SpringGreen=49;
MediumSpringGreen=50;
Cyan2=51;
Cyan1=52;
DarkRed=53;
DeepPink4=54;
Purple4=55;
Purple5=56;
Purple3=57;
BlueViolet=58;
Orange4=59;
Grey37=60;
MediumPurple4=61;
SlateBlue3=62;
SlateBlue2=63;
RoyalBlue1=64;
UnUsedHole5=65;
DarkSeaGreen5=66;
PaleTurquoise4=67;
SteelBlue=68;
SteelBlue3=69;
CornflowerBlue=70;
UnUsedHole3=71;
DarkSeaGreen4=72;
CadetBlue=73;
CadetBlue1=74;
SkyBlue2=75;
SteelBlue1=76;
UnUsedHole4=77;
PaleGreen3=78;
SeaGreen3=79;
Aquamarine3=80;
MediumTurquoise=81;
SteelBlue2=82;
UnUsedHole1=83;
SeaGreen2=84;
SeaGreen=85;
SeaGreen1=86;
Aquamarine1=87;
DarkSlateGray2=88;
DarkRed2=89;
DeepPink5=90;
DarkMagenta=91;
DarkMagenta1=92;
DarkViolet=93;
Purple1=94;
Orange5=95;
LightPink4=96;
Plum4=97;
MediumPurple3=98;
MediumPurple5=99;
SlateBlue1=100;
Yellow4=101;
Wheat4=102;
Grey53=103;
LightSlateGrey=104;
MediumPurple=105;
LightSlateBlue=106;
Yellow5=107;
DarkOliveGreen3=108;
DarkSeaGreen=109;
LightSkyBlue1=110;
LightSkyBlue2=111;
SkyBlue3=112;
UnUsedHole2=113;
DarkOliveGreen4=114;
PaleGreen4=115;
DarkSeaGreen3=116;
DarkSlateGray3=117;
SkyBlue1=118;
UnUsedHole=119;
LightGreen=120;
LightGreen1=121;
PaleGreen1=122;
Aquamarine2=123;
DarkSlateGray1=124;
Red3=125;
DeepPink6=126;
MediumVioletRed=127;
Magenta3=128;
DarkViolet2=129;
Purple2=130;
DarkOrange1=131;
IndianRed=132;
HotPink3=133;
MediumOrchid3=134;
MediumOrchid=135;
MediumPurple2=136;
DarkGoldenrod=137;
LightSalmon3=138;
RosyBrown=139;
Grey63=140;
MediumPurple6=141;
MediumPurple1=142;
Gold3=143;
DarkKhaki=144;
NavajoWhite3=145;
Grey69=146;
LightSteelBlue3=147;
LightSteelBlue=148;
Yellow3=149;
DarkOliveGreen5=150;
DarkSeaGreen6=151;
DarkSeaGreen2=152;
LightCyan3=153;
LightSkyBlue3=154;
GreenYellow=155;
DarkOliveGreen2=156;
PaleGreen2=157;
DarkSeaGreen7=158;
DarkSeaGreen1=159;
PaleTurquoise1=160;
Red4=161;
DeepPink3=162;
DeepPink7=163;
Magenta5=164;
Magenta6=165;
Magenta2=166;
DarkOrange2=167;
IndianRed1=168;
HotPink4=169;
HotPink2=170;
Orchid=171;
MediumOrchid1=172;
Orange1=173;
LightSalmon2=174;
LightPink1=175;
Pink1=176;
Plum2=177;
Violet=178;
Gold2=179;
LightGoldenrod4=180;
Tan=181;
MistyRose3=182;
Thistle3=183;
Plum3=184;
Yellow7=185;
Khaki3=186;
LightGoldenrod2=187;
LightYellow3=188;
Grey84=189;
LightSteelBlue1=190;
Yellow2=191;
DarkOliveGreen=192;
DarkOliveGreen1=193;
DarkSeaGreen8=194;
Honeydew2=195;
LightCyan1=196;
Red1=197;
DeepPink2=198;
DeepPink=199;
DeepPink1=200;
Magenta4=201;
Magenta1=202;
OrangeRed=203;
IndianRed2=204;
IndianRed3=205;
HotPink=206;
HotPink1=207;
MediumOrchid2=208;
DarkOrange=209;
Salmon1=210;
LightCoral=211;
PaleVioletRed=212;
Orchid2=213;
Orchid1=214;
Orange=215;
SandyBrown=216;
LightSalmon=217;
LightPink=218;
Pink=219;
Plum=220;
Gold=221;
LightGoldenrod5=222;
LightGoldenrod3=223;
NavajoWhite1=224;
MistyRose1=225;
Thistle1=226;
Yellow1=227;
LightGoldenrod1=228;
Khaki1=229;
Wheat1=230;
Cornsilk=231;
Grey100=232;
Grey3=233;
Grey7=234;
Grey11=235;
Grey15=236;
Grey19=237;
Grey23=238;
Grey27=239;
Grey30=240;
Grey35=241;
Grey39=242;
Grey42=243;
Grey46=244;
Grey50=245;
Grey54=246;
Grey58=247;
Grey62=248;
Grey66=249;
Grey70=250;
Grey74=251;
Grey78=252;
Grey82=253;
Grey85=254;
Grey93=255;

type
//TODO:
// for some reason CGA palette data is missing...and needs to be reimplemented.
//fix the types here..then assign colors as with EGA/VGA data(palette code)..and we should be ok.
//keep in mind that most of this CAN be altered, and we need to "abstract for -all of -that" as well.
// -Jazz


{
To get the red value of color 5:
Palette16[5].colors^.r;

TO get its DWord:

Palette16[5].DWords;

}


TRec4=record
   	colors:PSDL_COLOR; 
	DWords:DWord;
end;

TRec16=record
  
	colors:PSDL_COLOR; 

{SDL defines this is as:

SDL_Color=record
	r,g,b,a:byte;
end;

}

	DWords:DWord;

end;


//this is the XTerm 256 definition...

//palette tricks would then need to use : colors[1].a hacks.

//just so you can see the amount of datas were dealing with here.
//really shouldnt go there..and waay too many palettes out there.
//this really should be read in from a file.

//anyways- as "standard" as I can get.Most UNICES use this.


TRec256=record

  colors:TSDL_COLOR; //this is setup later on. 
  DWords:array [0..255] of DWord;

end;

//these get assigned bytes, each

var
  CgaListA:array [0..15] of byte;
  CgaListB:array [0..15] of byte;
  CgaListC:array [0..15] of byte;
  CgaListD:array [0..15] of byte;

//this one is unorthodox due to the totally destructive downsizing and image degredation needed
//and its "best guess"
  GreyList16:array [0..48] of byte;
  //GreyList256 is auto defined...

  valuelist16: array [0..48] of byte;
  valuelist256: array [0..767] of byte;
  
//this is the palette index (a record) 

  //3 color modes, one hi-res B/W(Faked CGA)
  Tpalette4a: array [0..3] of TRec4;
  Tpalette4b:array [0..3] of TRec4;
  Tpalette4c:array [0..3] of TRec4;
  Tpalette4d:array [0..3] of TRec4;


  TPalette16: array [0..15] of TRec16;
  TPalette16Grey:array [0..15] of TRec16;

  TPalette256:array [0..255] of TRec256;
  TPalette256Grey:array [0..255] of TRec256;


function GetRGBfromIndex(index:byte):PSDL_Color; 
function GetDWordfromIndex(index:byte):DWord; 
function GetRGBFromHex(input:DWord):PSDL_Color;
function GetIndexFromHex(input:DWord):byte;
function GetColorNameFromHex(input:dword):string;
function GetFgRGB:PSDL_Color;
function GetFGName:string;
function GetBGName:string;
function GetBGColorIndex:byte;
function GetFGColorIndex:byte;
procedure setFGColor(color:byte);
procedure setFGColor(someDword:dword); overload;
procedure setFGColor(r,g,b:word); overload;
procedure setFGColor(r,g,b,a:word); overload;
procedure setBGColor(index:byte);
procedure setBGColor(someDword:DWord); overload;
procedure setBGColor(r,g,b:word); overload;
procedure setBGColor(r,g,b,a:word); overload;
function GetBgDWordRGB(r,g,b:byte):DWord;
procedure invertColors;

implementation

{

There is one hardspec'd hack going on:

        Get/PutPixel.

SDL routines require SDL_Get/PutPixel, however- as written- it is co-dependendent on a lot of code here.
This is unavaoidable.

There is one way-and only one way to fix this. Make the units co-dependant at build time.
The linker will merge the code for us- just make sure that use of SDL/SDL2 has this unit present--or using it will fail.

The alternative is to remm out the routines in the SDL units- and require the code here. That would break SDL.
Many internal routines- such as Line, Circle, Rect, etc. require Get- or-Put Pixel ops.

I would rather keep SDL sane. Its half-assed enough- as it is.


greyscale palettes are required for either loading or displaying in BW, or some subset thereof.
this isnt "exactly" duplicated code

hardspec it first, then allow user defined- or "pre-saved" files
that not to say you cant init, save, then load thru the main code instead of useing the hard spec.

the hardspec is here as a default setting, much like most 8x8 font sometimes are included
by default in graphics modes source code.

these are zero based colors. for 16 color modes- 88 or even 80 is not correct, 70 or 77 is.
the 256 hex color data was pulled from xterm (and CGA) specs.


the only guaranteed perfect palette code is (m)CGA -tweaked by me, and Greyscale 256.

(greyscale mCGA is a hackish guess based on rough math, given 14 colors, and also black and white)
256 should mimic xterm colors IF the endianess is correct and I dont need DWord hex math ops

the question becomes- do we really need to set the DWords by hand.. (such a PITA)
while I did this thinking YES, possibly no. 
We DO NEED the SDL subcomponents, however.

AYE AYE AYE!

SDL performs the bit-flapping for us. so- if we set the Grey256 color value as a RGBA record/struct(c) entry 
then we should be able to pull it back as a unknown DWord(in theory).
(SDL_Map and SDL_Get RGB/RGBA are here for this purpose but our version is faster-
and doesnt need to use bitdepth checks)

}

//standalone routines. get/putPixel takes care of the conversion for you.
//I like my implementation better.

//16bit from 24bit
function Word16_from_RGB(red,green, blue:byte):Word; //Word=GLShort
//565 16bit color

begin
  red:= red shr 3;
  green:= green shr 2;
  blue:=  blue shr 3;
  Word16_from_RGB:= (red shl 11) or (green shl 5) or blue;
end;

//15bit from 24bit
function Word15_from_RGB(red,green, blue:byte):Word; //Word=GLShort
//555[1] 16bit color

begin
  red:= red shr 3;
  green:= green shr 3;
  blue:=  blue shr 3;
  Word15_from_RGB:= (red shl 10) or (green shl 4) or blue;
end;



//SDLv1 code- JEDI team doesnt do it right, and only in SDL2_GFX unit.

//Normally you lock and Unlock Surfaces for batch ops.
//RLE Surfaces (accelerated) MUST be locked prior to pixel ops- and are the only ones-where locking is required.
//REPEATED calls to lock/unlock slow things down



//PtrUInt is a C hack- specify length of data to fetch.
function SDL_GetPixel( SrcSurface : PSDL_Surface; x : integer; y : integer ) : PtrUInt; export;

var

i:integer;
index:LongWord;

    Location:^Longword; //location in 1D array
    temp15,tempPixel:Longword; //byte[0,1,2,3]
    pixel:longword;
    fetched:^longword;

begin
    if (SDL_MUSTLOCK(SrcSurface)) then
        SDL_LockSurface(SrcSurface);

    bpp:=SrcSurface^.format^.BytesPerPixel;

//location is a confusing misnomer- it should contain a value(DWord), based on screen co-ordinates in 1d
//-we interpret said value.
    Location:=(SrcSurface^.pixels+(y*SrcSurface^.pitch+x) * bpp );
    

//CGA: To fetch the data- we need to know - from which (mode and palette). 
// This is More complex than it initially presents(like college algebra).

//if using BP/TP7- this is less of a concern.

    case bpp of
//<8bpp arent supported, emulate

        //Paletted. Determine Mode and use Mode to leverage which Palette to use.
        //cannot return a longword(yet)- as we dont know from which palette.        

       8:begin //max assigned 256 color palette
        //now take the longword output 

          //4bpp
          if MaxColors=4 then begin //CGA

            //check mode to find the correct palette
            
      	     i:=0;
             index:=0;
	         while (i<3) do begin
//dont assume 4a, check mode...
		        if (Tpalette4a.dwords[i] = location) then //did we find a match?
 			        index:=Tpalette4a.colors[i];
				inc(i);  //no
             end;
	         //error:no match found
             if index=0  then exit;
             if (SDL_MUSTLOCK(SrcSurface)) then
                    SDL_UnLockSurface(SrcSurface);

             Result:=longword(Tpalette4a.Dwords[index]);

          end;

          if MaxColors=16 then begin  //EGA
             //compare byte index array (modded, not fixed) to pixel data- bail if doesnt match.

      	     i:=0;
             index:=0;
	         while (i<15) do begin
		        if (Tpalette16[i].dwords = location^) then //did we find a match?
 			        index:=Tpalette16[i].DWords;
				inc(i);  //no
             end;
	         //error:no match found
             if index=0  then exit;
             if (SDL_MUSTLOCK(SrcSurface)) then
                    SDL_UnLockSurface(SrcSurface);

             Result:=longword(Tpalette16.Dwords[index]);
          end;

          //ok safely in 256 colors mode
          if MaxColors=256 then begin

      	     i:=0;
             index:=0;
	         while (i<255) do begin
		        if (Tpalette256.dwords[i] = location^) then //did we find a match?
 			        index:=Tpalette256.Dwords[i];
				inc(i);  //no
             end;
	         //error:no match found
             if index=0  then exit;
             if (SDL_MUSTLOCK(SrcSurface)) then
                    SDL_UnLockSurface(SrcSurface);

             Result:=longword(Tpalette256.Dwords[index]);
          end;
          
       end;

        //special case
        15: begin 
            //extremely undocumented info
            //either we bump up to 32 from 16, then back down to 15..or we hack our way thru things.

            //red and green need to shift.

            temp15:=LongWord(location); //pull 32bit data (hackish, should pull 16)

                //courtesy microsoft
                //mask it off

            //(x86, talos is little endian, powerpc is big endian)
            if (SDL_BYTEORDER = SDL_LIL_ENDIAN) then begin

                Fetched[0]:=(temp15 and $7c00) shr 10;
                Fetched[1]:=(temp15 and $3E0) shr 5;
                Fetched[2]:=(temp15 and $1f);

                if (SDL_MUSTLOCK(SrcSurface)) then
                    SDL_UnLockSurface(SrcSurface);
          
                //repack it (m$ft!! touche! a bug...10 and 4..)
                Result:=(Word(Fetched[0] shl 10 or Fetched[1] shl 4 or Fetched[2]));
            
            end else begin

                //mask it off
                Fetched[0]:=(temp15 and $1f);
                Fetched[1]:=(temp15 and $3E0) shr 5;
                Fetched[2]:=(temp15 and $7c00) shr 10;

                if (SDL_MUSTLOCK(SrcSurface)) then
                    SDL_UnLockSurface(SrcSurface);

                Result:=(Word(Fetched[2] shl 10 or Fetched[1] shl 4 or Fetched[0]));
            end;

        end;

        16:begin //if we hacked 15bpp, why not hack 16?
            temp15:=LongWord(Location); //hackish

            if (SDL_BYTEORDER = SDL_LIL_ENDIAN) then begin

                Fetched[0]:=(temp15 and $f800) shr 10;
                Fetched[1]:=(temp15 and $7E0) shr 5;
                Fetched[2]:=(temp15 and $1f);

                if (SDL_MUSTLOCK(SrcSurface)) then
                    SDL_UnLockSurface(SrcSurface);

                Result:=Word((Fetched[0] shl 11) or (Fetched[1] shl 5) or Fetched[2]);
            
            end else begin

                //mask it off
                Fetched[0]:=(temp15 and $1f);
                Fetched[1]:=(temp15 and $3E0) shr 5;
                Fetched[2]:=(temp15 and $7c00) shr 10;

                if (SDL_MUSTLOCK(SrcSurface)) then
                    SDL_UnLockSurface(SrcSurface);

                Result:=Word( (Fetched[2] shl 11) or (Fetched[1] shl 5) or Fetched[0]);

            end;

        end;
        24: begin //tuple to longword- leave some bits as FF

            if (SDL_BYTEORDER = SDL_BIG_ENDIAN) then
                Result:= ((Longword (location[2] shl 24 or location[1] shl 16 or location[0] shl 8) shr 8))
             else           
                Result:=(Longword((location[0] shl 24 or location[1] shl 16 or location[2] shl 8) shr 8));
        end;
        32: begin
            if (SDL_MUSTLOCK(SrcSurface)) then
                    SDL_UnLockSurface(SrcSurface);
            
            Result:= Longword(Location);
        end else
            LogLn('Invalid bit Depth to get Pixel from.');
    end; //case    
end;


//PtrUInt is a hack- specify length of data provided. Works, but dodgy code.
procedure SDL_PutPixel( DstSurface : PSDL_Surface; x : integer; y : integer; pixel : PtrUInt ); export;
var

    Location:^LongWord;
    tempPixel:^Longword; //byte[0,1,2,3]
    indexcolor:byte;

begin
//dont worry about returning anything, go set the surface pixel at location to value provided

    bpp:=DstSurface^.format^.BytesPerPixel;
    Location:=(DstSurface^.pixels+(y*DstSurface^.pitch+x) * bpp );
    case bpp of
    //A-bit is ignored up to 32bpp, as it should be.(used for blending)

   //4 and 8 bpp are Paletted. Determine Mode and use Mode to leverage which Palette to use.
   //cannot return a longword(yet)- as we dont know from which palette. 
   //Palette intentionally contains longwords. Color (Bytes) is an index to said, not a fixed color.

//FIXME: this code will be tweaked when properly incorporated into the lazgfx unit.
 
       
        8: begin //256 palette actions done different ways.
            indexColor:=Byte(Pixel);
            if MaxColors=4 then begin
              //check mode set...
              Location^:=Tpalette4a.dwords[indexColor];
            end;
            if MaxColors=16 then begin
 			        Location^:=Tpalette16.dwords[indexColor];
            end;
            if MaxColors=256 then begin
 			        Location^:=Tpalette256.dwords[indexColor];
            end;

        end; 

        //15 ,16, and 24 bpp must output shifted words, derived from longwords
        //you have to break the pixel apart(RGBA), then reassemble it - it get it to fit
        

        15: begin //555

            if (SDL_BYTEORDER= SDL_BIG_ENDIAN) then begin                

                tempPixel[0]:= (pixel shr 3) and $ff;
                tempPixel[1]:= (pixel shr 3) and $ff;
                tempPixel[2]:= (pixel  shr 3) and $ff;
                tempPixel[3]:= $ff;                    
                Location^:= (tempPixel[0] shl 10 or tempPixel[1] shl 4 or tempPixel[2]);                
                
                end else begin
                tempPixel[0]:= $ff;
                tempPixel[1]:= (pixel shr 3) and $ff;
                tempPixel[2]:= (pixel  shr 3) and $ff;
                tempPixel[3]:= (pixel shr 3) and $ff;                    
                Location^:=(tempPixel[0] shl 10 or tempPixel[1] shl 4 or tempPixel[2]);
           end;
        end;
        16: begin //565
              if (SDL_BYTEORDER= SDL_BIG_ENDIAN) then begin
                tempPixel[0]:= (pixel shr 3) and $ff;
                tempPixel[1]:= (pixel shr 2) and $ff;
                tempPixel[2]:= (pixel  shr 3) and $ff;
                tempPixel[3]:= $ff;                    
                Location^:=(tempPixel[0] shl 11 or tempPixel[1] shl 5 or tempPixel[2]); //should be packed properly now.
              end else begin
                tempPixel[0]:= $ff;
                tempPixel[1]:= (pixel shr 3) and $ff;
                tempPixel[2]:= (pixel  shr 2) and $ff;
                tempPixel[3]:= (pixel shr 3) and $ff;                    
                Location^:=longword(tempPixel[3] shl 11 or tempPixel[2] shl 5 or tempPixel[1] ); //should be packed properly now.
           end;

        end;
        24: begin //tuple to longword

                //the C "is fucked here" - this should read location:=pixel[0,1,2] (ignore A bit)
                //instead of locaion[0,1,2]- impossible as location is a longword.               
                if (SDL_BYTEORDER= SDL_BIG_ENDIAN) then begin                
                    tempPixel[0]:= (pixel shr 16) and $ff;
                    tempPixel[1]:= (pixel shr 8) and $ff;
                    tempPixel[2]:= pixel and $ff;
                    tempPixel[3]:= $ff;                    
                    location^:=longword(tempPixel[0] or tempPixel[1] or tempPixel[2]); //already a longword, but set size anyways
                end else begin
                    tempPixel[0]:= $ff;
                    tempPixel[1]:= pixel and $ff;
                    tempPixel[2]:= (pixel shr 8) and $ff;
                    tempPixel[3]:= (pixel shr 16) and $ff;                    
                    location^:=longword(tempPixel[3] or tempPixel[2] or tempPixel[1]); //already a longword, but set size anyways
                end;

                location^:=longword(tempPixel[0] or tempPixel[1] or tempPixel[2]); //already a longword, but set size anyways

        end;
        32: Location^:=Longword(Pixel);
        else
            LogLn('Invalid bit Depth to gset Pixel to.');
    end; //case    
end;

{
rect size could be 1px for all we know- or the entire rendering surface...
note this function is "slow ASS"

see also saveBMP(for the entire surface(is this what we want?)


function GetPixels(Rect:PSDL_Rect):pointer;
var
	pixelpointer: array of SDL_Color; //unspecified amount of pixels

begin

//j,k are the 2d array coords- dont confuse me, always inc the "pixel number"
//how many pixels are here? do we care?

//if needed fetch sizeof((rect.x to rect.w) * (rect.y to rect.h))

	j:=0
	with Rect do begin

	repeat
		repeat
			pixeldata^[num]:=readpixels(x,y);
			inc(num);
			inc(j);
		until x = w;
	    inc(k);
		j:=0;
	until k=h;
	end;
    GetPixels:=PixelData;
end;

PutPixels(a blit w updateRect/flip) is the opposite of this- either read the file into a 2d buffer- or copy it (from another surface).

}


procedure initPaletteGrey16;

var
   i,num:integer;


begin  

valuelist16[0]:=$00;
valuelist16[1]:=$00;
valuelist16[2]:=$00;
valuelist16[3]:=$11;
valuelist16[4]:=$11;
valuelist16[5]:=$11;
valuelist16[6]:=$22;
valuelist16[7]:=$22;
valuelist16[8]:=$22;
valuelist16[9]:=$33;
valuelist16[10]:=$33;
valuelist16[11]:=$33;
valuelist16[12]:=$44;
valuelist16[13]:=$44;
valuelist16[14]:=$44;
valuelist16[15]:=$55;
valuelist16[16]:=$55;
valuelist16[17]:=$55;
valuelist16[18]:=$66;
valuelist16[19]:=$66;
valuelist16[20]:=$66;
valuelist16[21]:=$77;
valuelist16[22]:=$77;
valuelist16[23]:=$77;
valuelist16[24]:=$88;
valuelist16[25]:=$88;
valuelist16[26]:=$88;
valuelist16[27]:=$99;
valuelist16[28]:=$99;
valuelist16[29]:=$99;
valuelist16[30]:=$aa;
valuelist16[31]:=$aa;
valuelist16[32]:=$aa;
valuelist16[33]:=$bb;
valuelist16[34]:=$bb;
valuelist16[35]:=$bb;
valuelist16[36]:=$cc;
valuelist16[37]:=$cc;
valuelist16[38]:=$cc;
valuelist16[39]:=$dd;
valuelist16[40]:=$dd;
valuelist16[41]:=$dd;
valuelist16[42]:=$ee;
valuelist16[43]:=$ee;
valuelist16[44]:=$ee;
valuelist16[45]:=$ff;
valuelist16[46]:=$ff;
valuelist16[47]:=$ff;

   i:=0;
   num:=0; 
   repeat 
      Tpalette16[num].colors^.r:=valuelist16[i];
      Tpalette16[num].colors^.g:=valuelist16[i+1];
      Tpalette16[num].colors^.b:=valuelist16[i+2];
      Tpalette16[num].colors^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  until num=15;


TPalette16GRey[0].DWords:=$000000ff;
TPalette16GRey[1].DWords:=$111111ff;
TPalette16GRey[2].DWords:=$222222ff;
TPalette16GRey[3].DWords:=$333333ff;
TPalette16GRey[4].DWords:=$444444ff;
TPalette16GRey[5].DWords:=$555555ff;
TPalette16GRey[6].DWords:=$666666ff;
TPalette16GRey[7].DWords:=$777777ff;
TPalette16GRey[8].DWords:=$888888ff;
TPalette16GRey[9].DWords:=$999999ff;
TPalette16GRey[10].DWords:=$aaaaaaff;
TPalette16GRey[11].DWords:=$bbbbbbff;
TPalette16GRey[12].DWords:=$ccccccff;
TPalette16GRey[13].DWords:=$ddddddff;
TPalette16GRey[14].DWords:=$eeeeeeff;
TPalette16GRey[15].DWords:=$ffffffff; 


end;


procedure initPaletteGrey256;

//easy peasy to setup.

var
    i,num:integer;


begin  

//(we dont setup valuelist by hand this time)

   i:=0;
   i:=0;
  repeat 
      Tpalette256Grey[i].colors^.r:=ord(i);
      Tpalette256Grey[i].colors^.g:=ord(i);
      Tpalette256Grey[i].colors^.b:=ord(i);
      Tpalette256Grey[i].colors^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i); //notice the difference <-HERE ..where RGB are the same values      
  until i=255;

Tpalette256Grey[0].DWords:=$000000ff;
//the only gauranteed correct values are 0 and 255 right now.
//this will have to be manually set according to the above math.

Tpalette256Grey[1].DWords:=$010101ff;
Tpalette256Grey[2].DWords:=$020202ff;
Tpalette256Grey[3].DWords:=$030303ff;
Tpalette256Grey[4].DWords:=$040404ff;
Tpalette256Grey[5].DWords:=$050505ff;
Tpalette256Grey[6].DWords:=$060606ff;
Tpalette256Grey[7].DWords:=$070707ff;
Tpalette256Grey[8].DWords:=$080808ff;
Tpalette256Grey[9].DWords:=$090909ff;
Tpalette256Grey[10].DWords:=$0a0a0aff;
Tpalette256Grey[11].DWords:=$0b0b0bff;
Tpalette256Grey[12].DWords:=$0c0c0cff;
Tpalette256Grey[13].DWords:=$0d0d0dff;
Tpalette256Grey[14].DWords:=$0e0e0eff;
Tpalette256Grey[15].DWords:=$0f0f0fff; 

Tpalette256Grey[16].DWords:=$101010ff;
Tpalette256Grey[17].DWords:=$111111ff;
Tpalette256Grey[18].DWords:=$121212ff;
Tpalette256Grey[19].DWords:=$131313ff;
Tpalette256Grey[20].DWords:=$141414ff;
Tpalette256Grey[21].DWords:=$151515ff;
Tpalette256Grey[22].DWords:=$161616ff;
Tpalette256Grey[23].DWords:=$171717ff;
Tpalette256Grey[24].DWords:=$181818ff;
Tpalette256Grey[25].DWords:=$191919ff;
Tpalette256Grey[26].DWords:=$1a1a1aff;
Tpalette256Grey[27].DWords:=$1b1b1bff;
Tpalette256Grey[28].DWords:=$1c1c1cff;
Tpalette256Grey[29].DWords:=$1d1d1dff;
Tpalette256Grey[30].DWords:=$1e1e1eff;
Tpalette256Grey[31].DWords:=$1f1f1fff;

Tpalette256Grey[32].DWords:=$202020ff;
Tpalette256Grey[33].DWords:=$212121ff;
Tpalette256Grey[34].DWords:=$222222ff;
Tpalette256Grey[35].DWords:=$232323ff;
Tpalette256Grey[36].DWords:=$242424ff;
Tpalette256Grey[37].DWords:=$252525ff;
Tpalette256Grey[38].DWords:=$262626ff;
Tpalette256Grey[39].DWords:=$272727ff;
Tpalette256Grey[40].DWords:=$282828ff;
Tpalette256Grey[41].DWords:=$292929ff;
Tpalette256Grey[42].DWords:=$2a2a2aff;
Tpalette256Grey[43].DWords:=$2b2b2bff;
Tpalette256Grey[44].DWords:=$2c2c2cff;
Tpalette256Grey[45].DWords:=$2d2d2dff;
Tpalette256Grey[46].DWords:=$2e2e2eff;
Tpalette256Grey[47].DWords:=$2f2f2fff;

Tpalette256Grey[48].DWords:=$303030ff;
Tpalette256Grey[49].DWords:=$313131ff;
Tpalette256Grey[50].DWords:=$323232ff;
Tpalette256Grey[51].DWords:=$333333ff;
Tpalette256Grey[52].DWords:=$343434ff;
Tpalette256Grey[53].DWords:=$353535ff;
Tpalette256Grey[54].DWords:=$363636ff;
Tpalette256Grey[55].DWords:=$373737ff;
Tpalette256Grey[56].DWords:=$383838ff;
Tpalette256Grey[57].DWords:=$393939ff;
Tpalette256Grey[58].DWords:=$3a3a3aff;
Tpalette256Grey[59].DWords:=$3b3b3bff;
Tpalette256Grey[60].DWords:=$3c3c3cff;
Tpalette256Grey[61].DWords:=$3d3d3dff;
Tpalette256Grey[62].DWords:=$3e3e3eff;
Tpalette256Grey[63].DWords:=$3f3f3fff;

Tpalette256Grey[64].DWords:=$404040ff;
Tpalette256Grey[65].DWords:=$414141ff;
Tpalette256Grey[66].DWords:=$424242ff;
Tpalette256Grey[67].DWords:=$434343ff;
Tpalette256Grey[68].DWords:=$444444ff;
Tpalette256Grey[69].DWords:=$454545ff;
Tpalette256Grey[70].DWords:=$464646ff;
Tpalette256Grey[71].DWords:=$474747ff;
Tpalette256Grey[72].DWords:=$484848ff;
Tpalette256Grey[73].DWords:=$494949ff;
Tpalette256Grey[74].DWords:=$4a4a4aff;
Tpalette256Grey[75].DWords:=$4b4b4bff;
Tpalette256Grey[76].DWords:=$4c4c4cff;
Tpalette256Grey[77].DWords:=$4d4d4dff;
Tpalette256Grey[78].DWords:=$4e4e4eff;
Tpalette256Grey[79].DWords:=$4f4f4fff;

Tpalette256Grey[80].DWords:=$505050ff;
Tpalette256Grey[81].DWords:=$515151ff;
Tpalette256Grey[82].DWords:=$525252ff;
Tpalette256Grey[83].DWords:=$535353ff;
Tpalette256Grey[84].DWords:=$545454ff;
Tpalette256Grey[85].DWords:=$555555ff;
Tpalette256Grey[86].DWords:=$565656ff;
Tpalette256Grey[87].DWords:=$575757ff;
Tpalette256Grey[88].DWords:=$585858ff;
Tpalette256Grey[89].DWords:=$595959ff;
Tpalette256Grey[90].DWords:=$5a5a5aff;
Tpalette256Grey[91].DWords:=$5b5b5bff;
Tpalette256Grey[92].DWords:=$5c5c5cff;
Tpalette256Grey[93].DWords:=$5d5d5dff;
Tpalette256Grey[94].DWords:=$5e5e5eff;
Tpalette256Grey[95].DWords:=$5f5f5fff;

Tpalette256Grey[96].DWords:=$606060ff;
Tpalette256Grey[97].DWords:=$616161ff;
Tpalette256Grey[98].DWords:=$626262ff;
Tpalette256Grey[99].DWords:=$636363ff;
Tpalette256Grey[100].DWords:=$646464ff;
Tpalette256Grey[101].DWords:=$656565ff;
Tpalette256Grey[102].DWords:=$666666ff;
Tpalette256Grey[103].DWords:=$676767ff;
Tpalette256Grey[104].DWords:=$686868ff;
Tpalette256Grey[105].DWords:=$696969ff;
Tpalette256Grey[106].DWords:=$6a6a6aff;
Tpalette256Grey[107].DWords:=$6b6b6bff;
Tpalette256Grey[108].DWords:=$6c6c6cff;
Tpalette256Grey[109].DWords:=$6d6d6dff;
Tpalette256Grey[110].DWords:=$6e6e6eff;
Tpalette256Grey[111].DWords:=$6f6f6fff;

Tpalette256Grey[112].DWords:=$707070ff;
Tpalette256Grey[113].DWords:=$717171ff;
Tpalette256Grey[114].DWords:=$727272ff;
Tpalette256Grey[115].DWords:=$737373ff;
Tpalette256Grey[116].DWords:=$747474ff;
Tpalette256Grey[117].DWords:=$757575ff;
Tpalette256Grey[118].DWords:=$767676ff;
Tpalette256Grey[119].DWords:=$777777ff;
Tpalette256Grey[120].DWords:=$787878ff;
Tpalette256Grey[121].DWords:=$797979ff;
Tpalette256Grey[122].DWords:=$7a7a7aff;
Tpalette256Grey[123].DWords:=$7b7b7bff;
Tpalette256Grey[124].DWords:=$7c7c7cff;
Tpalette256Grey[125].DWords:=$7d7d7dff;
Tpalette256Grey[126].DWords:=$7e7e7eff;
Tpalette256Grey[127].DWords:=$7f7f7fff;

Tpalette256Grey[128].DWords:=$808080ff;
Tpalette256Grey[129].DWords:=$818181ff;
Tpalette256Grey[130].DWords:=$828282ff;
Tpalette256Grey[131].DWords:=$838383ff;
Tpalette256Grey[132].DWords:=$848484ff;
Tpalette256Grey[133].DWords:=$858585ff;
Tpalette256Grey[134].DWords:=$868686ff;
Tpalette256Grey[135].DWords:=$878787ff;
Tpalette256Grey[136].DWords:=$888888ff;
Tpalette256Grey[137].DWords:=$898989ff;
Tpalette256Grey[138].DWords:=$8a8a8aff;
Tpalette256Grey[139].DWords:=$8b8b8bff;
Tpalette256Grey[140].DWords:=$8c8c8cff;
Tpalette256Grey[141].DWords:=$8d8d8dff;
Tpalette256Grey[142].DWords:=$8e8e8eff;
Tpalette256Grey[143].DWords:=$8f8f8fff;

Tpalette256Grey[144].DWords:=$909090ff;
Tpalette256Grey[145].DWords:=$919191ff;
Tpalette256Grey[146].DWords:=$929292ff;
Tpalette256Grey[147].DWords:=$939393ff;
Tpalette256Grey[148].DWords:=$949494ff;
Tpalette256Grey[149].DWords:=$959595ff;
Tpalette256Grey[150].DWords:=$969696ff;
Tpalette256Grey[151].DWords:=$979797ff;
Tpalette256Grey[152].DWords:=$989898ff;
Tpalette256Grey[153].DWords:=$999999ff;
Tpalette256Grey[154].DWords:=$9a9a9aff;
Tpalette256Grey[155].DWords:=$9b9b9bff;
Tpalette256Grey[156].DWords:=$9c9c9cff;
Tpalette256Grey[157].DWords:=$9d9d9dff;
Tpalette256Grey[158].DWords:=$9e9e9eff;
TPalette256GRey[159].DWords:=$9f9f9fff; 

Tpalette256Grey[160].DWords:=$a0a0a0ff;
Tpalette256Grey[161].DWords:=$a1a1a1ff;
Tpalette256Grey[162].DWords:=$a2a2a2ff;
Tpalette256Grey[163].DWords:=$a3a3a3ff;
Tpalette256Grey[164].DWords:=$a4a4a4ff;
Tpalette256Grey[165].DWords:=$a5a5a5ff;
Tpalette256Grey[166].DWords:=$a6a6a6ff;
Tpalette256Grey[167].DWords:=$a7a7a7ff;
Tpalette256Grey[168].DWords:=$a8a8a8ff;
Tpalette256Grey[169].DWords:=$a9a9a9ff;
Tpalette256Grey[170].DWords:=$aaaaaaff;
Tpalette256Grey[171].DWords:=$abababff;
Tpalette256Grey[172].DWords:=$acacacff;
Tpalette256Grey[173].DWords:=$adadadff;
Tpalette256Grey[174].DWords:=$aeaeaeff;
Tpalette256Grey[175].DWords:=$afafafff;

Tpalette256Grey[176].DWords:=$b0b0b0ff;
Tpalette256Grey[177].DWords:=$b1b1b1ff;
Tpalette256Grey[178].DWords:=$b2b2b2ff;
Tpalette256Grey[179].DWords:=$b3b3b3ff;
Tpalette256Grey[180].DWords:=$b4b4b4ff;
Tpalette256Grey[181].DWords:=$b5b5b5ff;
Tpalette256Grey[182].DWords:=$b6b6b6ff;
Tpalette256Grey[183].DWords:=$b7b7b7ff;
Tpalette256Grey[184].DWords:=$b8b8b8ff;
Tpalette256Grey[185].DWords:=$b9b9b9ff;
Tpalette256Grey[186].DWords:=$bababaff;
Tpalette256Grey[187].DWords:=$bbbbbbff;
Tpalette256Grey[188].DWords:=$bcbcbcff;
Tpalette256Grey[189].DWords:=$bdbdbdff;
Tpalette256Grey[190].DWords:=$bebebeff;
Tpalette256Grey[191].DWords:=$bfbfbfff;

Tpalette256Grey[192].DWords:=$c0c0c0ff;
Tpalette256Grey[193].DWords:=$c1c1c1ff;
Tpalette256Grey[194].DWords:=$c2c2c2ff;
Tpalette256Grey[195].DWords:=$c3c3c3ff;
Tpalette256Grey[196].DWords:=$c4c4c4ff;
Tpalette256Grey[197].DWords:=$c5c5c5ff;
Tpalette256Grey[198].DWords:=$c6c6c6ff;
Tpalette256Grey[199].DWords:=$c7c7c7ff;
Tpalette256Grey[200].DWords:=$c8c8c8ff;
Tpalette256Grey[201].DWords:=$c9c9c9ff;
Tpalette256Grey[202].DWords:=$cacacaff;
Tpalette256Grey[203].DWords:=$cbcbcbff;
Tpalette256Grey[204].DWords:=$ccccccff;
Tpalette256Grey[205].DWords:=$cdcdcdff;
Tpalette256Grey[206].DWords:=$cececeff;
Tpalette256Grey[207].DWords:=$cfcfcfff;

Tpalette256Grey[208].DWords:=$d0d0d0ff;
Tpalette256Grey[209].DWords:=$d1d1d1ff;
Tpalette256Grey[210].DWords:=$d2d2d2ff;
Tpalette256Grey[211].DWords:=$d3d3d3ff;
Tpalette256Grey[212].DWords:=$d4d4d4ff;
Tpalette256Grey[213].DWords:=$d5d5d5ff;
Tpalette256Grey[214].DWords:=$d6d6d6ff;
Tpalette256Grey[215].DWords:=$d7d7d7ff;
Tpalette256Grey[216].DWords:=$d8d8d8ff;
Tpalette256Grey[217].DWords:=$d9d9d9ff;
Tpalette256Grey[218].DWords:=$dadadaff;
Tpalette256Grey[219].DWords:=$dbdbdbff;
Tpalette256Grey[220].DWords:=$dcdcdcff;
Tpalette256Grey[221].DWords:=$ddddddff;
Tpalette256Grey[222].DWords:=$dededeff;
Tpalette256Grey[223].DWords:=$dfdfdfff;

Tpalette256Grey[224].DWords:=$e0e0e0ff;
Tpalette256Grey[225].DWords:=$e1e1e1ff;
Tpalette256Grey[226].DWords:=$e2e2e2ff;
Tpalette256Grey[227].DWords:=$e3e3e3ff;
Tpalette256Grey[228].DWords:=$e4e4e4ff;
Tpalette256Grey[229].DWords:=$e5e5e5ff;
Tpalette256Grey[230].DWords:=$e6e6e6ff;
Tpalette256Grey[231].DWords:=$e7e7e7ff;
Tpalette256Grey[232].DWords:=$e8e8e8ff;
Tpalette256Grey[233].DWords:=$e9e9e9ff;
Tpalette256Grey[234].DWords:=$eaeaeaff;
Tpalette256Grey[235].DWords:=$ebebebff;
Tpalette256Grey[236].DWords:=$ecececff;
Tpalette256Grey[237].DWords:=$edededff;
Tpalette256Grey[238].DWords:=$eeeeeeff;
Tpalette256Grey[239].DWords:=$efefefff;

Tpalette256Grey[240].DWords:=$f0f0f0ff;
Tpalette256Grey[241].DWords:=$f1f1f1ff;
Tpalette256Grey[242].DWords:=$f2f2f2ff;
Tpalette256Grey[243].DWords:=$f3f3f3ff;
Tpalette256Grey[244].DWords:=$f4f4f4ff;
Tpalette256Grey[245].DWords:=$f5f5f5ff;
Tpalette256Grey[246].DWords:=$f6f6f6ff;
Tpalette256Grey[247].DWords:=$f7f7f7ff;
Tpalette256Grey[248].DWords:=$f8f8f8ff;
Tpalette256Grey[249].DWords:=$f9f9f9ff;
Tpalette256Grey[250].DWords:=$fafafaff;
Tpalette256Grey[251].DWords:=$fbfbfbff;
Tpalette256Grey[252].DWords:=$fcfcfcff;
Tpalette256Grey[253].DWords:=$fdfdfdff;
Tpalette256Grey[254].DWords:=$fefefeff;
Tpalette256Grey[255].DWords:=$ffffffff;

end;

//FIXED- for good this time. (Oct-19-18)
procedure initPalette16;

var
   num,i:integer;
//80 in hex is beyond the halfway point at 128. 127 (7f) is more correct.

begin  
//Color Sequence:
//K HiR HiG HiB HiC HiM HiY HiGR LoGr LoR LoG LoB LoC LoM LoY W

valuelist16[0]:=$00;
valuelist16[1]:=$00;
valuelist16[2]:=$00;

valuelist16[3]:=$ff;
valuelist16[4]:=$00;
valuelist16[5]:=$00;

valuelist16[6]:=$00;
valuelist16[7]:=$ff;
valuelist16[8]:=$00;

valuelist16[9]:=$ff;
valuelist16[10]:=$ff;
valuelist16[11]:=$00;

valuelist16[12]:=$00;
valuelist16[13]:=$00;
valuelist16[14]:=$ff;

valuelist16[15]:=$ff;
valuelist16[16]:=$00;
valuelist16[17]:=$ff;

valuelist16[18]:=$ff;
valuelist16[19]:=$ff;
valuelist16[20]:=$00;


valuelist16[21]:=$c0;
valuelist16[22]:=$c0;
valuelist16[23]:=$c0;

valuelist16[24]:=$7f;
valuelist16[25]:=$7f;
valuelist16[26]:=$7f;


valuelist16[27]:=$7f;
valuelist16[28]:=$00;
valuelist16[29]:=$00;

valuelist16[30]:=$00;
valuelist16[31]:=$7f;
valuelist16[32]:=$00;

valuelist16[33]:=$7f;
valuelist16[34]:=$7f;
valuelist16[35]:=$00;

valuelist16[36]:=$00;
valuelist16[37]:=$00;
valuelist16[38]:=$7f;

valuelist16[39]:=$7f;
valuelist16[40]:=$00;
valuelist16[41]:=$7f;

valuelist16[42]:=$00;
valuelist16[43]:=$7f;
valuelist16[44]:=$7f;

valuelist16[45]:=$ff;
valuelist16[46]:=$ff;
valuelist16[47]:=$ff;

  i:=0;
   num:=0; 
   repeat 
      Tpalette16[num].colors^.r:=valuelist16[i];
      Tpalette16[num].colors^.g:=valuelist16[i+1];
      Tpalette16[num].colors^.b:=valuelist16[i+2];
      Tpalette16[num].colors^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      //see the remmed out notes below
      inc(i,3);
      inc(num); 
  until num=14;


TPalette16[0].DWords:=$000000ff;

TPalette16[1].DWords:=$ff0000ff;
TPalette16[2].DWords:=$00ff00ff;
TPalette16[3].DWords:=$ffff00ff;

TPalette16[4].DWords:=$0000ffff;
TPalette16[5].DWords:=$ff00ffff;
TPalette16[6].DWords:=$ffff55ff;

TPalette16[7].DWords:=$c0c0c0ff;
TPalette16[8].DWords:=$7f7f7fff;

TPalette16[9].DWords:=$7f0000ff;
TPalette16[10].DWords:=$007f00ff;
TPalette16[11].DWords:=$7f7f00ff;

TPalette16[12].DWords:=$00007fff;
TPalette16[13].DWords:=$7f007fff;
TPalette16[14].DWords:=$007f7fff;

TPalette16[15].DWords:=$ffffffff;
end;


procedure Save16Palette(filename:string);

var
	palette16File : File of TRec16;
	i,num            : integer;

Begin
	initPalette16;
	Assign(palette16File, filename);
	ReWrite(palette16File);
    i:=0;
    repeat
		Write(palette16File, TPalette16[i]); //dump everything out
        inc(i);
	until i=15;	
	Close(palette16File);
	
End;

//we should ask if we want to read a color or BW file, else we duplicate code for one line of changes.
//there is a way to check- but we would have to peek inside the file or just display it and assume things.
//this could shove a BW file in the color section or a color file in the BW section...
//anyway, theres two sets of arrays and you can reset to defaults if you need to.

procedure Read16Palette(filename:string; ReadColor:boolean);

Var
	palette16File  : File of TRec16;
	j,i,num            : integer;
    palette:PSDL_Palette;
	MY_Palette:TSDL_Colors;
	TMYPalette16: array [0..255] of SDL_Color;


Begin
	Assign(palette16File, filename);
	ReSet(palette16File);
    Seek(palette16File, 0); //find first record
	i:=0;
    if ReadColor=true then begin
        repeat
			Read(palette16File, TPalette16[i]); //read everything in
			inc(i);
		until i=15;
    end	else begin
        repeat
			Read(palette16File, TPalette16GRey[i]); 
			inc(i);
		until i=15;		
	end;    
	Close(palette16File);
	
    SDL_AllocPalette(16);    
    if ReadColor=true then begin
		x:=0;
		repeat
	        TMY_Palette16[x]:=Tpalette16[x].colors;
			inc(x);
		until x=15;

          SDL_SetPalette(surface, SDL_LOGPAL, TMYPalette16, 0, 15);

    end else begin
		x:=0;
		repeat
	        TMY_Palette16[x]:=Tpalette16Grey[x].colors;
			inc(x);
		until x=15;
          SDL_SetPalette(surface, SDL_LOGPAL, TMYPalette16, 0, 15);
   end;
end;

procedure initPalette256;

//256 color VGA palette based on XTerm colors(Unix)
// however the first 16 are off according to mCGA specs and have been corrected.
//xterms dont use "bold text by deault" an maybe this is where the confusion is.

//furthermore there are other 256rgb palettes.


var
    num,i:integer;


begin  

valuelist256[0]:=$00;
valuelist256[1]:=$00;
valuelist256[2]:=$00;
valuelist256[3]:=$ff;
valuelist256[4]:=$00;
valuelist256[5]:=$00;
valuelist256[6]:=$00;
valuelist256[7]:=$ff;
valuelist256[8]:=$00;
valuelist256[9]:=$ff;
valuelist256[10]:=$ff;
valuelist256[11]:=$00;
valuelist256[12]:=$00;
valuelist256[13]:=$00;
valuelist256[14]:=$ff;
valuelist256[15]:=$ff;
valuelist256[16]:=$00;
valuelist256[17]:=$ff;
valuelist256[18]:=$ff;
valuelist256[19]:=$ff;
valuelist256[20]:=$00;
valuelist256[21]:=$c0;
valuelist256[22]:=$c0;
valuelist256[23]:=$c0;
valuelist256[24]:=$7f;
valuelist256[25]:=$7f;
valuelist256[26]:=$7f;
valuelist256[27]:=$7f;
valuelist256[28]:=$00;
valuelist256[29]:=$00;
valuelist256[30]:=$00;
valuelist256[31]:=$7f;
valuelist256[32]:=$00;
valuelist256[33]:=$7f;
valuelist256[34]:=$7f;
valuelist256[35]:=$00;
valuelist256[36]:=$00;
valuelist256[37]:=$00;
valuelist256[38]:=$7f;
valuelist256[39]:=$7f;
valuelist256[40]:=$00;
valuelist256[41]:=$7f;
valuelist256[42]:=$00;
valuelist256[43]:=$7f;
valuelist256[44]:=$7f;
valuelist256[45]:=$ff;
valuelist256[46]:=$ff;
valuelist256[47]:=$ff;
valuelist256[48]:=$00;
valuelist256[49]:=$00;
valuelist256[50]:=$00;

valuelist256[51]:=$00;
valuelist256[52]:=$00;
valuelist256[53]:=$5f;
valuelist256[54]:=$00;
valuelist256[55]:=$00;
valuelist256[56]:=$87;
valuelist256[57]:=$00;
valuelist256[58]:=$00;
valuelist256[59]:=$af;
valuelist256[60]:=$00;
valuelist256[61]:=$00;
valuelist256[62]:=$d7;
valuelist256[63]:=$00;
valuelist256[64]:=$00;
valuelist256[65]:=$ff;
valuelist256[66]:=$00;
valuelist256[67]:=$5f;
valuelist256[68]:=$00;
valuelist256[69]:=$00;
valuelist256[70]:=$5f;
valuelist256[71]:=$5f;
valuelist256[72]:=$00;
valuelist256[73]:=$5f;
valuelist256[74]:=$87;
valuelist256[75]:=$00;
valuelist256[76]:=$5f;
valuelist256[77]:=$af;
valuelist256[78]:=$00;
valuelist256[79]:=$5f;
valuelist256[80]:=$d7;
valuelist256[81]:=$00;
valuelist256[82]:=$5f;
valuelist256[83]:=$ff;
valuelist256[84]:=$00;
valuelist256[85]:=$87;
valuelist256[86]:=$00;
valuelist256[87]:=$00;
valuelist256[88]:=$87;
valuelist256[89]:=$5f;
valuelist256[90]:=$00;
valuelist256[91]:=$87;
valuelist256[92]:=$87;
valuelist256[93]:=$00;
valuelist256[94]:=$87;
valuelist256[95]:=$af;
valuelist256[96]:=$00;
valuelist256[97]:=$87;
valuelist256[98]:=$d7;
valuelist256[99]:=$00;
valuelist256[100]:=$87;

valuelist256[101]:=$ff;
valuelist256[102]:=$00;
valuelist256[103]:=$af;
valuelist256[104]:=$00;
valuelist256[105]:=$00;
valuelist256[106]:=$af;
valuelist256[107]:=$5f;
valuelist256[108]:=$00;
valuelist256[109]:=$af;
valuelist256[110]:=$87;
valuelist256[111]:=$00;
valuelist256[112]:=$af;
valuelist256[113]:=$af;
valuelist256[114]:=$00;
valuelist256[115]:=$af;
valuelist256[116]:=$d7;
valuelist256[117]:=$00;
valuelist256[118]:=$af;
valuelist256[119]:=$ff;
valuelist256[120]:=$00;
valuelist256[121]:=$d7;
valuelist256[122]:=$00;
valuelist256[123]:=$00;
valuelist256[124]:=$d7;
valuelist256[125]:=$5f;
valuelist256[126]:=$00;
valuelist256[127]:=$d7;
valuelist256[128]:=$87;
valuelist256[129]:=$00;
valuelist256[130]:=$d7;
valuelist256[131]:=$af;
valuelist256[132]:=$00;
valuelist256[133]:=$d7;
valuelist256[134]:=$d7;
valuelist256[135]:=$00;
valuelist256[136]:=$d7;
valuelist256[137]:=$ff;
valuelist256[138]:=$00;
valuelist256[139]:=$ff;
valuelist256[140]:=$00;
valuelist256[141]:=$00;
valuelist256[142]:=$ff;
valuelist256[143]:=$5f;
valuelist256[144]:=$00;
valuelist256[145]:=$ff;
valuelist256[146]:=$87;
valuelist256[147]:=$00;
valuelist256[148]:=$ff;
valuelist256[149]:=$af;
valuelist256[150]:=$00;

valuelist256[151]:=$ff;
valuelist256[152]:=$d7;
valuelist256[153]:=$00;
valuelist256[154]:=$ff;
valuelist256[155]:=$ff;
valuelist256[156]:=$5f;
valuelist256[157]:=$00;
valuelist256[158]:=$00;
valuelist256[159]:=$5f;
valuelist256[160]:=$00;
valuelist256[161]:=$5f;
valuelist256[162]:=$5f;
valuelist256[163]:=$00;
valuelist256[164]:=$87;
valuelist256[165]:=$5f;
valuelist256[166]:=$00;
valuelist256[167]:=$af;
valuelist256[168]:=$5f;
valuelist256[169]:=$00;
valuelist256[170]:=$d7;
valuelist256[171]:=$5f;
valuelist256[172]:=$00;
valuelist256[173]:=$ff;
valuelist256[174]:=$5f;
valuelist256[175]:=$5f;
valuelist256[176]:=$00;
valuelist256[177]:=$5f;
valuelist256[178]:=$5f;
valuelist256[179]:=$5f;
valuelist256[180]:=$5f;
valuelist256[181]:=$5f;
valuelist256[182]:=$87;
valuelist256[183]:=$5f;
valuelist256[184]:=$5f;
valuelist256[185]:=$af;
valuelist256[186]:=$5f;
valuelist256[187]:=$5f;
valuelist256[188]:=$d7;
valuelist256[189]:=$5f;
valuelist256[190]:=$5f;
valuelist256[191]:=$ff;
valuelist256[192]:=$5f;
valuelist256[193]:=$87;
valuelist256[194]:=$00;
valuelist256[195]:=$5f;
valuelist256[196]:=$87;
valuelist256[197]:=$5f;
valuelist256[198]:=$5f;
valuelist256[199]:=$87;
valuelist256[200]:=$87;

valuelist256[201]:=$5f;
valuelist256[202]:=$87;
valuelist256[203]:=$af;
valuelist256[204]:=$5f;
valuelist256[205]:=$87;
valuelist256[206]:=$d7;
valuelist256[207]:=$5f;
valuelist256[208]:=$87;
valuelist256[209]:=$ff;
valuelist256[210]:=$5f;
valuelist256[211]:=$af;
valuelist256[212]:=$00;
valuelist256[213]:=$5f;
valuelist256[214]:=$af;
valuelist256[215]:=$5f;
valuelist256[216]:=$5f;
valuelist256[217]:=$af;
valuelist256[218]:=$87;
valuelist256[219]:=$5f;
valuelist256[220]:=$af;
valuelist256[221]:=$af;
valuelist256[222]:=$5f;
valuelist256[223]:=$af;
valuelist256[224]:=$d7;
valuelist256[225]:=$5f;
valuelist256[226]:=$af;
valuelist256[227]:=$ff;
valuelist256[228]:=$5f;
valuelist256[229]:=$d7;
valuelist256[230]:=$00;
valuelist256[231]:=$5f;
valuelist256[232]:=$d7;
valuelist256[233]:=$5f;
valuelist256[234]:=$5f;
valuelist256[235]:=$d7;
valuelist256[236]:=$87;
valuelist256[237]:=$5f;
valuelist256[238]:=$d7;
valuelist256[239]:=$af;
valuelist256[240]:=$5f;
valuelist256[241]:=$d7;
valuelist256[242]:=$d7;
valuelist256[243]:=$5f;
valuelist256[244]:=$d7;
valuelist256[245]:=$ff;
valuelist256[246]:=$5f;
valuelist256[247]:=$ff;
valuelist256[248]:=$00;
valuelist256[249]:=$5f;
valuelist256[250]:=$ff;
valuelist256[251]:=$5f;
valuelist256[252]:=$5f;
valuelist256[253]:=$ff;
valuelist256[254]:=$87;
valuelist256[255]:=$5f;
valuelist256[256]:=$ff;
valuelist256[257]:=$af;
valuelist256[258]:=$5f;
valuelist256[259]:=$ff;
valuelist256[260]:=$d7;

valuelist256[261]:=$5f;
valuelist256[262]:=$ff;
valuelist256[263]:=$ff;
valuelist256[264]:=$87;
valuelist256[265]:=$00;
valuelist256[266]:=$00;
valuelist256[267]:=$87;
valuelist256[268]:=$00;
valuelist256[269]:=$5f;
valuelist256[270]:=$87;
valuelist256[271]:=$00;
valuelist256[272]:=$87;
valuelist256[273]:=$87;
valuelist256[274]:=$00;
valuelist256[275]:=$af;
valuelist256[276]:=$87;
valuelist256[277]:=$00;
valuelist256[278]:=$d7;
valuelist256[279]:=$87;
valuelist256[280]:=$00;
valuelist256[281]:=$ff;
valuelist256[282]:=$87;
valuelist256[283]:=$5f;
valuelist256[284]:=$00;
valuelist256[285]:=$87;
valuelist256[286]:=$5f;
valuelist256[287]:=$5f;
valuelist256[288]:=$87;
valuelist256[289]:=$5f;
valuelist256[290]:=$87;
valuelist256[291]:=$87;
valuelist256[292]:=$5f;
valuelist256[293]:=$af;
valuelist256[294]:=$87;
valuelist256[295]:=$5f;
valuelist256[296]:=$d7;
valuelist256[297]:=$87;
valuelist256[298]:=$5f;
valuelist256[299]:=$ff;
valuelist256[300]:=$87;

valuelist256[301]:=$87;
valuelist256[302]:=$00;
valuelist256[303]:=$87;
valuelist256[304]:=$87;
valuelist256[305]:=$5f;
valuelist256[306]:=$87;
valuelist256[307]:=$87;
valuelist256[308]:=$87;
valuelist256[309]:=$87;
valuelist256[310]:=$87;
valuelist256[311]:=$af;
valuelist256[312]:=$87;
valuelist256[313]:=$87;
valuelist256[314]:=$d7;
valuelist256[315]:=$87;
valuelist256[316]:=$87;
valuelist256[317]:=$ff;
valuelist256[318]:=$87;
valuelist256[319]:=$af;
valuelist256[320]:=$00;
valuelist256[321]:=$87;
valuelist256[322]:=$af;
valuelist256[323]:=$5f;
valuelist256[324]:=$87;
valuelist256[325]:=$af;
valuelist256[326]:=$87;
valuelist256[327]:=$87;
valuelist256[328]:=$af;
valuelist256[329]:=$af;
valuelist256[330]:=$87;
valuelist256[331]:=$af;
valuelist256[332]:=$d7;
valuelist256[333]:=$87;
valuelist256[334]:=$af;
valuelist256[335]:=$ff;
valuelist256[336]:=$87;
valuelist256[337]:=$d7;
valuelist256[338]:=$00;
valuelist256[339]:=$87;
valuelist256[340]:=$d7;
valuelist256[341]:=$5f;
valuelist256[342]:=$87;
valuelist256[343]:=$d7;
valuelist256[344]:=$87;
valuelist256[345]:=$87;
valuelist256[346]:=$d7;
valuelist256[347]:=$af;
valuelist256[348]:=$87;
valuelist256[349]:=$d7;
valuelist256[350]:=$d7;
valuelist256[351]:=$87;
valuelist256[352]:=$d7;
valuelist256[353]:=$ff;
valuelist256[354]:=$87;
valuelist256[355]:=$ff;
valuelist256[356]:=$00;
valuelist256[357]:=$87;
valuelist256[358]:=$ff;
valuelist256[359]:=$5f;
valuelist256[360]:=$87;
valuelist256[361]:=$ff;
valuelist256[362]:=$87;
valuelist256[363]:=$87;
valuelist256[364]:=$ff;
valuelist256[365]:=$af;
valuelist256[366]:=$87;
valuelist256[367]:=$ff;
valuelist256[368]:=$d7;
valuelist256[369]:=$87;
valuelist256[370]:=$ff;
valuelist256[371]:=$ff;
valuelist256[372]:=$af;
valuelist256[373]:=$00;
valuelist256[374]:=$00;
valuelist256[375]:=$af;
valuelist256[376]:=$00;
valuelist256[377]:=$5f;
valuelist256[378]:=$af;
valuelist256[379]:=$00;
valuelist256[380]:=$87;
valuelist256[381]:=$af;
valuelist256[382]:=$00;
valuelist256[383]:=$af;
valuelist256[384]:=$af;
valuelist256[385]:=$00;
valuelist256[386]:=$d7;
valuelist256[387]:=$af;
valuelist256[388]:=$00;
valuelist256[389]:=$af;
valuelist256[390]:=$af;
valuelist256[391]:=$5f;
valuelist256[392]:=$00;
valuelist256[393]:=$af;
valuelist256[394]:=$5f;
valuelist256[395]:=$5f;
valuelist256[396]:=$af;
valuelist256[397]:=$5f;
valuelist256[398]:=$87;
valuelist256[399]:=$af;
valuelist256[400]:=$5f;

valuelist256[401]:=$af;
valuelist256[402]:=$af;
valuelist256[403]:=$5f;
valuelist256[404]:=$d7;
valuelist256[405]:=$af;
valuelist256[406]:=$5f;
valuelist256[407]:=$ff;
valuelist256[408]:=$af;
valuelist256[409]:=$87;
valuelist256[410]:=$00;
valuelist256[411]:=$af;
valuelist256[412]:=$87;
valuelist256[413]:=$5f;
valuelist256[414]:=$af;
valuelist256[415]:=$87;
valuelist256[416]:=$87;
valuelist256[417]:=$af;
valuelist256[418]:=$87;
valuelist256[419]:=$af;
valuelist256[420]:=$af;
valuelist256[421]:=$87;
valuelist256[422]:=$d7;
valuelist256[423]:=$af;
valuelist256[424]:=$87;
valuelist256[425]:=$ff;
valuelist256[426]:=$af;
valuelist256[427]:=$af;
valuelist256[428]:=$00;
valuelist256[429]:=$af;
valuelist256[430]:=$af;
valuelist256[431]:=$5f;
valuelist256[432]:=$af;
valuelist256[433]:=$af;
valuelist256[434]:=$87;
valuelist256[435]:=$af;
valuelist256[436]:=$af;
valuelist256[437]:=$af;
valuelist256[438]:=$af;
valuelist256[439]:=$af;
valuelist256[440]:=$d7;


valuelist256[441]:=$af;
valuelist256[442]:=$af;
valuelist256[443]:=$ff;
valuelist256[444]:=$af;
valuelist256[445]:=$d7;
valuelist256[446]:=$00;
valuelist256[447]:=$af;
valuelist256[448]:=$d7;
valuelist256[449]:=$5f;

valuelist256[450]:=$af;
valuelist256[451]:=$d7;
valuelist256[452]:=$87;
valuelist256[453]:=$af;
valuelist256[454]:=$d7;
valuelist256[455]:=$af;
valuelist256[456]:=$af;
valuelist256[457]:=$d7;
valuelist256[458]:=$d7;
valuelist256[459]:=$af;

valuelist256[460]:=$d7;
valuelist256[461]:=$ff;
valuelist256[462]:=$af;
valuelist256[463]:=$ff;
valuelist256[464]:=$00;
valuelist256[465]:=$af;
valuelist256[466]:=$ff;
valuelist256[467]:=$5f;
valuelist256[468]:=$af;
valuelist256[469]:=$ff;

valuelist256[470]:=$87;
valuelist256[471]:=$af;
valuelist256[472]:=$ff;
valuelist256[473]:=$af;
valuelist256[474]:=$af;
valuelist256[475]:=$ff;
valuelist256[476]:=$d7;
valuelist256[477]:=$af;
valuelist256[478]:=$ff;
valuelist256[479]:=$ff;

valuelist256[480]:=$d7;
valuelist256[481]:=$00;
valuelist256[482]:=$00;
valuelist256[483]:=$d7;
valuelist256[484]:=$00;
valuelist256[485]:=$5f;
valuelist256[486]:=$d7;
valuelist256[487]:=$00;
valuelist256[488]:=$87;
valuelist256[489]:=$d7;
valuelist256[490]:=$00;

valuelist256[491]:=$af;
valuelist256[492]:=$d7;
valuelist256[493]:=$00;
valuelist256[494]:=$d7;
valuelist256[495]:=$d7;
valuelist256[496]:=$00;
valuelist256[497]:=$ff;
valuelist256[498]:=$d7;
valuelist256[499]:=$5f;

valuelist256[500]:=$00;
valuelist256[501]:=$d7;
valuelist256[502]:=$5f;
valuelist256[503]:=$5f;
valuelist256[504]:=$d7;
valuelist256[505]:=$5f;
valuelist256[506]:=$87;
valuelist256[507]:=$d7;
valuelist256[508]:=$5f;
valuelist256[509]:=$af;
valuelist256[510]:=$d7;
valuelist256[511]:=$5f;
valuelist256[512]:=$d7;
valuelist256[513]:=$d7;
valuelist256[514]:=$5f;
valuelist256[515]:=$ff;
valuelist256[516]:=$d7;
valuelist256[517]:=$87;
valuelist256[518]:=$00;
valuelist256[519]:=$d7;
valuelist256[520]:=$87;
valuelist256[521]:=$5f;
valuelist256[522]:=$d7;
valuelist256[523]:=$87;
valuelist256[524]:=$87;
valuelist256[525]:=$d7;
valuelist256[526]:=$87;
valuelist256[527]:=$af;
valuelist256[528]:=$d7;
valuelist256[529]:=$87;

valuelist256[530]:=$d7;
valuelist256[531]:=$d7;
valuelist256[532]:=$87;
valuelist256[533]:=$ff;
valuelist256[534]:=$d7;
valuelist256[535]:=$af;
valuelist256[536]:=$00;
valuelist256[537]:=$d7;
valuelist256[538]:=$af;
valuelist256[539]:=$5f;

valuelist256[540]:=$d7;
valuelist256[541]:=$af;
valuelist256[542]:=$87;
valuelist256[543]:=$d7;
valuelist256[544]:=$af;
valuelist256[545]:=$af;
valuelist256[546]:=$d7;
valuelist256[547]:=$af;
valuelist256[548]:=$d7;
valuelist256[549]:=$d7;
valuelist256[550]:=$af;
valuelist256[551]:=$ff;
valuelist256[552]:=$d7;
valuelist256[553]:=$d7;
valuelist256[554]:=$00;
valuelist256[555]:=$d7;
valuelist256[556]:=$d7;
valuelist256[557]:=$5f;
valuelist256[558]:=$d7;
valuelist256[559]:=$d7;
valuelist256[560]:=$87;

valuelist256[561]:=$d7;
valuelist256[562]:=$d7;
valuelist256[563]:=$af;
valuelist256[564]:=$d7;
valuelist256[565]:=$d7;
valuelist256[566]:=$d7;
valuelist256[567]:=$d7;
valuelist256[568]:=$d7;
valuelist256[569]:=$ff;

valuelist256[570]:=$d7;
valuelist256[571]:=$ff;
valuelist256[572]:=$00;
valuelist256[573]:=$d7;
valuelist256[574]:=$ff;
valuelist256[575]:=$5f;
valuelist256[576]:=$d7;
valuelist256[577]:=$ff;
valuelist256[578]:=$87;
valuelist256[579]:=$d7;

valuelist256[580]:=$ff;
valuelist256[581]:=$af;
valuelist256[582]:=$d7;
valuelist256[583]:=$ff;
valuelist256[584]:=$d7;
valuelist256[585]:=$d7;
valuelist256[586]:=$ff;
valuelist256[587]:=$ff;
valuelist256[588]:=$ff;
valuelist256[589]:=$00;

valuelist256[590]:=$00;
valuelist256[591]:=$ff;
valuelist256[592]:=$00;
valuelist256[593]:=$5f;
valuelist256[594]:=$ff;
valuelist256[595]:=$00;
valuelist256[596]:=$87;
valuelist256[597]:=$ff;
valuelist256[598]:=$00;
valuelist256[599]:=$af;

valuelist256[600]:=$ff;
valuelist256[601]:=$00;
valuelist256[602]:=$d7;
valuelist256[603]:=$ff;
valuelist256[604]:=$00;
valuelist256[605]:=$ff;
valuelist256[606]:=$ff;
valuelist256[607]:=$5f;
valuelist256[608]:=$00;
valuelist256[609]:=$ff;

valuelist256[610]:=$5f;
valuelist256[611]:=$5f;
valuelist256[612]:=$ff;
valuelist256[613]:=$5f;
valuelist256[614]:=$87;
valuelist256[615]:=$ff;
valuelist256[616]:=$5f;
valuelist256[617]:=$af;
valuelist256[618]:=$ff;
valuelist256[619]:=$5f;

valuelist256[620]:=$d7;
valuelist256[621]:=$ff;
valuelist256[622]:=$5f;
valuelist256[623]:=$ff;
valuelist256[624]:=$ff;
valuelist256[625]:=$87;
valuelist256[626]:=$00;
valuelist256[627]:=$ff;
valuelist256[628]:=$87;
valuelist256[629]:=$5f;

valuelist256[630]:=$ff;
valuelist256[631]:=$87;
valuelist256[632]:=$87;
valuelist256[633]:=$ff;
valuelist256[634]:=$87;
valuelist256[635]:=$af;
valuelist256[636]:=$ff;
valuelist256[637]:=$87;
valuelist256[638]:=$d7;
valuelist256[639]:=$ff;

valuelist256[640]:=$87;
valuelist256[641]:=$ff;
valuelist256[642]:=$ff;
valuelist256[643]:=$af;
valuelist256[644]:=$00;
valuelist256[645]:=$ff;
valuelist256[646]:=$af;
valuelist256[647]:=$5f;
valuelist256[648]:=$ff;
valuelist256[649]:=$af;

valuelist256[650]:=$87;
valuelist256[651]:=$ff;
valuelist256[652]:=$af;
valuelist256[653]:=$af;
valuelist256[654]:=$ff;
valuelist256[655]:=$af;
valuelist256[656]:=$d7;
valuelist256[657]:=$ff;
valuelist256[658]:=$af;
valuelist256[659]:=$ff;

valuelist256[660]:=$ff;
valuelist256[661]:=$d7;
valuelist256[662]:=$00;
valuelist256[663]:=$ff;
valuelist256[664]:=$d7;
valuelist256[665]:=$5f;
valuelist256[666]:=$ff;
valuelist256[667]:=$d7;
valuelist256[668]:=$87;
valuelist256[669]:=$ff;

valuelist256[670]:=$d7;
valuelist256[671]:=$af;
valuelist256[672]:=$ff;
valuelist256[673]:=$d7;
valuelist256[674]:=$d7;
valuelist256[675]:=$ff;
valuelist256[676]:=$d7;
valuelist256[677]:=$ff;
valuelist256[678]:=$ff;
valuelist256[679]:=$ff;

valuelist256[680]:=$00;
valuelist256[681]:=$ff;
valuelist256[682]:=$ff;
valuelist256[683]:=$5f;
valuelist256[684]:=$ff;
valuelist256[685]:=$ff;
valuelist256[686]:=$87;
valuelist256[687]:=$ff;
valuelist256[688]:=$ff;
valuelist256[689]:=$af;

valuelist256[690]:=$ff;
valuelist256[691]:=$ff;
valuelist256[692]:=$d7;
valuelist256[693]:=$ff;
valuelist256[694]:=$ff;
valuelist256[695]:=$ff;
valuelist256[696]:=$08;
valuelist256[697]:=$08;
valuelist256[698]:=$08;
valuelist256[699]:=$12;

valuelist256[700]:=$12;
valuelist256[701]:=$12;
valuelist256[702]:=$1c;
valuelist256[703]:=$1c;
valuelist256[704]:=$1c;
valuelist256[705]:=$26;
valuelist256[706]:=$26;
valuelist256[707]:=$26;
valuelist256[708]:=$30;
valuelist256[709]:=$30;

valuelist256[710]:=$30;
valuelist256[711]:=$3a;
valuelist256[712]:=$3a;
valuelist256[713]:=$3a;
valuelist256[714]:=$44;
valuelist256[715]:=$44;
valuelist256[716]:=$44;
valuelist256[717]:=$4e;
valuelist256[718]:=$4e;
valuelist256[719]:=$4e;

valuelist256[720]:=$58;
valuelist256[721]:=$58;
valuelist256[722]:=$58;
valuelist256[723]:=$62;
valuelist256[724]:=$62;
valuelist256[725]:=$62;
valuelist256[726]:=$6c;
valuelist256[727]:=$6c;
valuelist256[728]:=$6c;
valuelist256[729]:=$76;

valuelist256[730]:=$76;
valuelist256[731]:=$76;
valuelist256[732]:=$80;
valuelist256[733]:=$80;
valuelist256[734]:=$80;
valuelist256[735]:=$8a;
valuelist256[736]:=$8a;
valuelist256[737]:=$8a;
valuelist256[738]:=$94;
valuelist256[739]:=$94;

valuelist256[740]:=$94;
valuelist256[741]:=$9e;
valuelist256[742]:=$9e;
valuelist256[743]:=$9e;
valuelist256[744]:=$a8;
valuelist256[745]:=$a8;
valuelist256[746]:=$a8;
valuelist256[747]:=$b2;
valuelist256[748]:=$b2;
valuelist256[749]:=$b2;

valuelist256[750]:=$bc;
valuelist256[751]:=$bc;
valuelist256[752]:=$bc;
valuelist256[753]:=$c6;
valuelist256[754]:=$c6;
valuelist256[755]:=$c6;
valuelist256[756]:=$d0;
valuelist256[757]:=$d0;
valuelist256[758]:=$d0;
valuelist256[759]:=$da;

valuelist256[760]:=$da;
valuelist256[761]:=$da;
valuelist256[762]:=$e4;
valuelist256[763]:=$e4;
valuelist256[764]:=$e4;
valuelist256[765]:=$ee;
valuelist256[766]:=$ee;
valuelist256[767]:=$ee;
  i:=0;
   num:=0; 
   repeat
      Tpalette256[num].colors^.r:=valuelist256[i];
      Tpalette256[num].colors^.g:=valuelist256[i+1];
      Tpalette256[num].colors^.b:=valuelist256[i+2];
      Tpalette256[num].colors^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  until num=767;

	
//256 color VGA palette based on XTerm colors(Unix)
//first 16 colors now should be more accurate!

TPalette256[0].DWords:=$000000ff;
TPalette256[1].DWords:=$ff0000ff;
TPalette256[2].DWords:=$00ff00ff;
TPalette256[3].DWords:=$ffff00ff;
TPalette256[4].DWords:=$0000ffff;
TPalette256[5].DWords:=$ff00ffff;
TPalette256[6].DWords:=$ffff55ff;
TPalette256[7].DWords:=$c0c0c0ff;
TPalette256[8].DWords:=$7f7f7fff;
TPalette256[9].DWords:=$7f0000ff;
TPalette256[10].DWords:=$007f00ff;
TPalette256[11].DWords:=$7f7f00ff;
TPalette256[12].DWords:=$00007fff;
TPalette256[13].DWords:=$7f007fff;
TPalette256[14].DWords:=$007f7fff;
TPalette256[15].DWords:=$ffffffff;

TPalette256[16].DWords:=$000000ff;
TPalette256[17].DWords:=$00005fff;
TPalette256[18].DWords:=$000087ff;
TPalette256[19].DWords:=$0000afff;
TPalette256[20].DWords:=$0000d7ff;
TPalette256[21].DWords:=$0000ffff;
TPalette256[22].DWords:=$005f00ff;
TPalette256[23].DWords:=$005f5fff;
TPalette256[24].DWords:=$005f87ff;
TPalette256[25].DWords:=$005fafff;
TPalette256[26].DWords:=$005fd7ff;
TPalette256[27].DWords:=$005fffff;
TPalette256[28].DWords:=$008700ff;
TPalette256[29].DWords:=$00875fff;
TPalette256[30].DWords:=$008787ff;

TPalette256[31].DWords:=$0087afff;
TPalette256[32].DWords:=$0087d7ff;
TPalette256[33].DWords:=$0087ffff;
TPalette256[34].DWords:=$00af00ff;
TPalette256[35].DWords:=$00af5fff;
TPalette256[36].DWords:=$00af87ff;
TPalette256[37].DWords:=$00afafff;
TPalette256[38].DWords:=$00afd7ff;
TPalette256[39].DWords:=$00afffff;
TPalette256[40].DWords:=$00d700ff;
TPalette256[41].DWords:=$00d75fff;
TPalette256[42].DWords:=$00d787ff;
TPalette256[43].DWords:=$00d7afff;
TPalette256[44].DWords:=$00d7d7ff;
TPalette256[45].DWords:=$00d7ffff;

TPalette256[46].DWords:=$00ff00ff;
TPalette256[47].DWords:=$00ff5fff;
TPalette256[48].DWords:=$00ff87ff;
TPalette256[49].DWords:=$00ffafff;
TPalette256[50].DWords:=$00ffd7ff;
TPalette256[51].DWords:=$00ffffff;
TPalette256[52].DWords:=$5f0000ff;
TPalette256[53].DWords:=$5f005fff;
TPalette256[54].DWords:=$5f0087ff;
TPalette256[55].DWords:=$5f00afff;
TPalette256[56].DWords:=$5f00d7ff;
TPalette256[57].DWords:=$5f00ffff;
TPalette256[58].DWords:=$5f5f00ff;
TPalette256[59].DWords:=$5f5f5fff;
TPalette256[60].DWords:=$5f5f87ff;

TPalette256[61].DWords:=$5f5fafff;
TPalette256[62].DWords:=$5f5fd7ff;
TPalette256[63].DWords:=$5f5fffff;
TPalette256[64].DWords:=$5f8700ff;
TPalette256[65].DWords:=$5f875fff;
TPalette256[66].DWords:=$5f8787ff;
TPalette256[67].DWords:=$5f87afff;
TPalette256[68].DWords:=$5f87d7ff;
TPalette256[69].DWords:=$5f87ffff;
TPalette256[70].DWords:=$5faf00ff;
TPalette256[71].DWords:=$5faf5fff;
TPalette256[72].DWords:=$5faf87ff;
TPalette256[73].DWords:=$5fafafff;
TPalette256[74].DWords:=$5fafd7ff;
TPalette256[75].DWords:=$5fafffff;

TPalette256[76].DWords:=$5fd700ff;
TPalette256[77].DWords:=$5fd75fff;
TPalette256[78].DWords:=$5fd787ff;
TPalette256[79].DWords:=$5fd7afff;
TPalette256[80].DWords:=$5fd7d7ff;
TPalette256[81].DWords:=$5fd7ffff;
TPalette256[82].DWords:=$5fff00ff;
TPalette256[83].DWords:=$5fff5fff;
TPalette256[84].DWords:=$5fff87ff;
TPalette256[85].DWords:=$5fffafff;
TPalette256[86].DWords:=$5fffd7ff;
TPalette256[87].DWords:=$5fffffff;
TPalette256[88].DWords:=$870000ff;
TPalette256[89].DWords:=$87005fff;
TPalette256[90].DWords:=$870087ff;

TPalette256[91].DWords:=$8700afff;
TPalette256[92].DWords:=$8700d7ff;
TPalette256[93].DWords:=$8700ffff;
TPalette256[94].DWords:=$875f00ff;
TPalette256[95].DWords:=$875f5fff;
TPalette256[96].DWords:=$875f87ff;
TPalette256[97].DWords:=$875fafff;
TPalette256[98].DWords:=$875fd7ff;
TPalette256[99].DWords:=$875fffff;
TPalette256[100].DWords:=$878700ff;
TPalette256[101].DWords:=$87875fff;
TPalette256[102].DWords:=$878787ff;
TPalette256[103].DWords:=$8787afff;
TPalette256[104].DWords:=$8787d7ff;
TPalette256[105].DWords:=$8787ffff;

TPalette256[106].DWords:=$87af00ff;
TPalette256[107].DWords:=$87af5fff;
TPalette256[108].DWords:=$87af87ff;
TPalette256[109].DWords:=$87afafff;


TPalette256[110].DWords:=$87afd7ff;
TPalette256[111].DWords:=$87afffff;
TPalette256[112].DWords:=$87d700ff;
TPalette256[113].DWords:=$87d75fff;
TPalette256[114].DWords:=$87d787ff;
TPalette256[115].DWords:=$87d7afff;
TPalette256[116].DWords:=$87d7d7ff;
TPalette256[117].DWords:=$87d7ffff;
TPalette256[118].DWords:=$87ff00ff;
TPalette256[119].DWords:=$87ff5fff;
TPalette256[120].DWords:=$87ff87ff;

TPalette256[121].DWords:=$87ffafff;
TPalette256[122].DWords:=$87ffd7ff;
TPalette256[123].DWords:=$87ffffff;
TPalette256[124].DWords:=$af0000ff;
TPalette256[125].DWords:=$af005fff;
TPalette256[126].DWords:=$af0087ff;
TPalette256[127].DWords:=$af00afff;
TPalette256[128].DWords:=$af00d7ff;
TPalette256[129].DWords:=$af00ffff;
TPalette256[130].DWords:=$af5f00ff;
TPalette256[131].DWords:=$af5f5fff;
TPalette256[132].DWords:=$af5f87ff;
TPalette256[133].DWords:=$af5fafff;
TPalette256[134].DWords:=$af5fd7ff;
TPalette256[135].DWords:=$af5fffff;

TPalette256[136].DWords:=$af8700ff;
TPalette256[137].DWords:=$af875fff;
TPalette256[138].DWords:=$af8787ff;
TPalette256[139].DWords:=$af87afff;
TPalette256[140].DWords:=$af87d7ff;
TPalette256[141].DWords:=$af87ffff;
TPalette256[142].DWords:=$afaf00ff;
TPalette256[143].DWords:=$afaf5fff;
TPalette256[144].DWords:=$afaf87ff;
TPalette256[145].DWords:=$afafafff;
TPalette256[146].DWords:=$afafd7ff;
TPalette256[147].DWords:=$afafffff;
TPalette256[148].DWords:=$afd700ff;
TPalette256[149].DWords:=$afd75fff;
TPalette256[150].DWords:=$afd787ff;

TPalette256[151].DWords:=$afd7afff;
TPalette256[152].DWords:=$afd7d7ff;
TPalette256[153].DWords:=$afd7ffff;
TPalette256[154].DWords:=$afff00ff;
TPalette256[155].DWords:=$afff5fff;
TPalette256[156].DWords:=$afff87ff;
TPalette256[157].DWords:=$afffafff;
TPalette256[158].DWords:=$afffd7ff;
TPalette256[159].DWords:=$afffffff;
TPalette256[160].DWords:=$d70000ff;
TPalette256[161].DWords:=$d7005fff;
TPalette256[162].DWords:=$d70087ff;
TPalette256[163].DWords:=$d700afff;
TPalette256[164].DWords:=$d700d7ff;
TPalette256[165].DWords:=$d700ffff;

TPalette256[166].DWords:=$d75f00ff;
TPalette256[167].DWords:=$d75f5fff;
TPalette256[168].DWords:=$d75f87ff;
TPalette256[169].DWords:=$d75fafff;
TPalette256[170].DWords:=$d75fd7ff;
TPalette256[171].DWords:=$d75fffff;
TPalette256[172].DWords:=$d78700ff;
TPalette256[173].DWords:=$d7875fff;
TPalette256[174].DWords:=$d78787ff;
TPalette256[175].DWords:=$d787afff;
TPalette256[176].DWords:=$d787d7ff;
TPalette256[177].DWords:=$d787ffff;
TPalette256[178].DWords:=$d7af00ff;
TPalette256[179].DWords:=$d7af5fff;
TPalette256[180].DWords:=$d7af87ff;

TPalette256[181].DWords:=$d7afafff;
TPalette256[182].DWords:=$d7afd7ff;
TPalette256[183].DWords:=$d7afffff;
TPalette256[184].DWords:=$d7d700ff;
TPalette256[185].DWords:=$d7d75fff;
TPalette256[186].DWords:=$d7d787ff;
TPalette256[187].DWords:=$d7d7afff;
TPalette256[188].DWords:=$d7d7d7ff;
TPalette256[189].DWords:=$d7d7ffff;
TPalette256[190].DWords:=$d7ff00ff;
TPalette256[191].DWords:=$d7ff5fff;
TPalette256[192].DWords:=$d7ff87ff;
TPalette256[193].DWords:=$d7ffafff;
TPalette256[194].DWords:=$d7ffd7ff;
TPalette256[195].DWords:=$d7ffffff;

TPalette256[196].DWords:=$ff0000ff;
TPalette256[197].DWords:=$ff005fff;
TPalette256[198].DWords:=$ff0087ff;
TPalette256[199].DWords:=$ff00afff;
TPalette256[200].DWords:=$ff00d7ff;
TPalette256[201].DWords:=$ff00ffff;
TPalette256[202].DWords:=$ff5f00ff;
TPalette256[203].DWords:=$ff5f5fff;
TPalette256[204].DWords:=$ff5f87ff;
TPalette256[205].DWords:=$ff5fafff;
TPalette256[206].DWords:=$ff5fd7ff;
TPalette256[207].DWords:=$ff5fffff;
TPalette256[208].DWords:=$ff8700ff;
TPalette256[209].DWords:=$ff875fff;
TPalette256[210].DWords:=$ff8787ff;

TPalette256[211].DWords:=$ff87afff;
TPalette256[212].DWords:=$ff87d7ff;
TPalette256[213].DWords:=$ff87ffff;
TPalette256[214].DWords:=$ffaf00ff;
TPalette256[215].DWords:=$ffaf5fff;
TPalette256[216].DWords:=$ffaf87ff;
TPalette256[217].DWords:=$ffafafff;
TPalette256[218].DWords:=$ffafd7ff;
TPalette256[219].DWords:=$ffafffff;
TPalette256[220].DWords:=$ffd700ff;

TPalette256[221].DWords:=$ffd75fff;
TPalette256[222].DWords:=$ffd787ff;
TPalette256[223].DWords:=$ffd7afff;
TPalette256[224].DWords:=$ffd7d7ff;

TPalette256[225].DWords:=$ffd7ffff;
TPalette256[226].DWords:=$ffff00ff;
TPalette256[227].DWords:=$ffff5fff;
TPalette256[228].DWords:=$ffff87ff;
TPalette256[229].DWords:=$ffffafff;
TPalette256[230].DWords:=$ffffd7ff;


TPalette256[231].DWords:=$ffffffff;
TPalette256[232].DWords:=$080808ff;
TPalette256[233].DWords:=$121212ff;
TPalette256[234].DWords:=$1c1c1cff;
TPalette256[235].DWords:=$262626ff;
TPalette256[236].DWords:=$303030ff;
TPalette256[237].DWords:=$3a3a3aff;
TPalette256[238].DWords:=$444444ff;
TPalette256[239].DWords:=$4e4e4eff;
TPalette256[240].DWords:=$585858ff;
TPalette256[241].DWords:=$626262ff;
TPalette256[242].DWords:=$6c6c6cff;
TPalette256[243].DWords:=$767676ff;
TPalette256[244].DWords:=$808080ff;
TPalette256[245].DWords:=$8a8a8aff;
TPalette256[246].DWords:=$949494ff;
TPalette256[247].DWords:=$9e9e9eff;
TPalette256[248].DWords:=$a8a8a8ff;
TPalette256[249].DWords:=$b2b2b2ff;
TPalette256[250].DWords:=$bcbcbcff;
TPalette256[251].DWords:=$c6c6c6ff;
TPalette256[252].DWords:=$d0d0d0ff;
TPalette256[253].DWords:=$dadadaff;
TPalette256[254].DWords:=$e4e4e4ff;
TPalette256[255].DWords:=$eeeeeeff;

end;


//supply a filename like:
// yes, you should be using long file names
// PAL256C.dat or PAL256BW.dat

//(dont make me duplicate code to change two lines)

procedure Save256Palette(filename:string);

Var
	palette256File  : File of TRec256;
	i,num            : integer;

Begin

    //save us a lot of code and work
    initPalette256;
	Assign(palette256File, filename);
	ReWrite(palette256File);

  i:=0;
    repeat
 		Write(palette256File, TPalette256[i]); 
        inc(i);
	until i=15;	
	Close(palette256File);
	
End;


procedure Read256Palette(filename:string; ReadColor:boolean);

Var
	palette256File  : File of TRec256;
	i,num            : integer;
    palette: PSDL_Palette;
    TMY_Palette256:TSDL_Colors;

Begin
	Assign(palette256File, filename);
	ReSet(palette256File);
    Seek(palette256File, 0); //find first record


   if ReadColor=true then begin
        repeat
			Read(palette256File, TPalette256[i]); //read everything in
			inc(i);
		until i=255;
    end	else begin
        repeat
			Read(palette256File, TPalette256GRey[i]); 
			inc(i);
		until i=255;		
	end;    
	Close(palette256File);
	SDL_AllocPalette(256);    
	 
    if ReadColor=true then begin
		x:=0;
		repeat
	        TMY_Palette256[x]:=Tpalette256[x].colors;
			inc(x);
		until x=255;

          SDL_SetPalette(surface, SDL_LOGPAL, TMYPalette256, 0, 255);

    end else begin
		x:=0;
		repeat
	        TMY_Palette256[x]:=Tpalette256Grey[x].colors;
			inc(x);
		until x=255;
          SDL_SetPalette(surface, SDL_LOGPAL, TMYPalette16, 0, 255);
	end;
end;

//semi-generic color functions


function GetRGBfromIndex(index:byte):PSDL_Color; 
//if its indexed- we have the rgb definition already!!

var
   somecolor:PSDL_Color;
   
begin
  if bpp=8 then begin

    if MaxColors =16 then
	      somecolor:=Tpalette16.colors[index] //literally get the SDL_color from the index
    else if MaxColors=256 then
	      somecolor:=Tpalette256.colors[index]; 
    GetRGBFromIndex:=somecolor;
  end else begin
    if IsConsoleInvoked then
		LogLn('Attempt to fetch RGB from non-Indexed color.Wrong routine called.');
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to fetch RGB from non-Indexed color.Wrong routine called.','OK',NIL); 
   
    exit;
  end;
end;

function GetDWordfromIndex(index:byte):DWord; 
//if its indexed- we have the rgb definition already!!

var
   somecolor:DWord;
   
begin
  if bpp=8 then begin
    if MaxColors =16 then
	      somecolor:=Tpalette16.DWords[index] //literally get the DWord from the index
    else if MaxColors=256 then
	      somecolor:=Tpalette256.DWords[index]; 
    
   GetDWordFromIndex:=somecolor;
  end else begin
      if IsConsoleInvoked then
	    	LogLn('Attempt to fetch indexed DWord from non-indexed color');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to fetch indexed DWord from non-indexed color','OK',NIL); 
      exit;

  end;
end;



function GetRGBFromHex(input:DWord):PSDL_Color;
var
	i:integer;
    somedata:PSDL_Color; 
    r,g,b:PUInt8;

begin

  if bpp=8 then begin
   if (MaxColors=256) then begin
	   i:=0;
	   while (i<255) do begin
		    if (Tpalette256.dwords[i] = input) then begin //did we find a match?
 			   GetRGBFromHex:=Tpalette256.colors[i];
               exit;
           
           end else
				inc(i);  //no
       end;
	  //error:no match found
      exit;

   end else if (MaxColors=16) then begin
	    i:=0;
	    while (i<15) do begin

		    if (Tpalette16.dwords[i] = input) then begin//did we find a match?
               GetRGBFromHex:=Tpalette16.colors[i];
               exit;
            end else
				inc(i);  //no
       end;
	  //error:no match found
      exit;

   end;
  end else if (bpp >8) then begin
  
       if IsConsoleInvoked then begin
             LogLn('Wrong routine called. Try: TrueColorGetRGBfromHex');
             LogLn('Wrong routine called. Try: TrueColorGetRGBfromHex');
       end;
       SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Wrong routine called. Try: TrueColorGetRGBfromHex','OK',NIL); 
 end;
end;


//its either we hack this to hell- or reimplement MainSurface- the easier option.
//MainSurface^.PixelFormat is unknown-but assignable.

function GetRGBfromHex(somedata:DWord):PSDL_Color;

var
	pitch,format,i:integer;
    someColor:PSDL_Color;
    r,g,b:PUINT8;
    pixelFormat:PSDL_PixelFormat;

begin

lock;

// Now you want to format the color to a correct format that SDL can use.
// Basically we convert our RGB color to a hex-like BGR color.
  SDL_GetRGB(somedata,MainSurface^.Format, R, G, B);

       somecolor^.r:=byte(^r);
       somecolor^.g:=byte(^g);
       somecolor^.b:=byte(^b);

UnLock;

   	   GetRGBfromHex:=somecolor;
end;

function GetRGBAFromHex(input:DWord):PSDL_Color;
var
	i:integer;
    somecolor:PSDL_Color; 
    r,g,b,a:PUInt8;

begin
   if (bpp <=8) then begin
         if IsConsoleInvoked then
			LogLn('Cant Get RGBA data from indexed colors.');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get RGBA data from indexed colors.','OK',NIL);
      exit; 
   end;

	   SDL_GetRGBA(input,MainSurface^.format,r,g,b,a);
       somecolor^.r:=byte(^r);
       somecolor^.g:=byte(^g);
       somecolor^.b:=byte(^b);
       somecolor^.a:=byte(^a);
   	   GetRGBAFromHex:=somecolor;
end;


//DWord in - Index out
function GetIndexFromHex(input:DWord):byte;

var
	r,g,b:PUInt8;
    color:PSDL_Color;
    i:integer;

begin
  if (MaxColors >256) then begin
       if IsConsoleInvoked then
			LogLn('Cant Get color name from an RGB mode colors.');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
      exit; 
  end;

    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
   end;

  SDL_GetRGB(input,MainSurface^.format,r,g,b); //Get the RGB color from the DWord given
     color^.r:=byte(^r);
     color^.g:=byte(^g);
     color^.b:=byte(^b);

	if MaxColors=256 then begin
        i:=0;
		repeat
			if ((color^.r=Tpalette256.colors[i]^.r) and (color^.g=Tpalette256.colors[i]^.g) and (color^.b=Tpalette256.colors[i]^.b)) then begin
				GetIndexFromHex:=i;
				exit;
			end;
		    inc(i);
		until i=255;
   //error:no match found
   //exit

	end else if MaxColors=16 then begin
        i:=0;
		
        repeat
  			if ((color^.r=Tpalette16.colors[i]^.r) and (color^.g=Tpalette16.colors[i]^.g) and (color^.b=Tpalette16.colors[i]^.b)) then begin
				GetIndexFromHex:=i;
				exit;
  			end;
  			inc(i);
		until i=15;
	end;
  //error:no match found
  //exit

end;

//DWord in - string out
function GetColorNameFromHex(input:dword):string;

var
	r,g,b:PUInt8;
    color:PSDL_Color;
     
    i:integer;

begin
  if (MaxColors >256) then begin
      if IsConsoleInvoked then
			LogLn('Cant Get color name from an RGB mode colors.');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
      exit; 
  end;
  i:=0;

  SDL_GetRGB(input,Mainsurface^.format,r,g,b); //Get the RGB color from the DWord given

  if MaxColors=256 then begin
	repeat
  		if ((color^.r=Tpalette256.colors[i]^.r) and (color^.g=Tpalette256.colors[i]^.g) and (color^.b=Tpalette256.colors[i]^.b)) then begin
			GetColorNameFromHex:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
			exit;
  		end;
  		inc(i);
	until i=255;
  //no match found
  //exit


  end else if MaxColors=16 then begin
	repeat
  		if ((color^.r=Tpalette16.colors[i]^.r) and (color^.g=Tpalette16.colors[i]^.g) and (color^.b=Tpalette16.colors[i]^.b)) then begin
			GetColorNameFromHex:=GEtEnumName(typeinfo(TPalette16Names),ord(i));
			exit;
  		end;
  		inc(i);
	until i=15;
  end;
  //no match found
  //exit

end;




//get the last color set:
//__bgcolor and __fgcolor hold this information. No need to go anywhere.

function GetFgRGB:PSDL_Color;

begin    
    GetFgRGB:=__Fgcolor; 
end;

function GetFgRGBA:PSDL_Color;

begin
    GetFgRGBA:=__Fgcolor; 
end;

//give me the name(string) of the current fg or bg color (paletted modes only) from the screen

function GetFGName:string;

var
   i:byte;
   somecolor:PSDL_Color;
   someDWord:DWord;

begin
   if (MaxColors> 256) then begin

      If IsConsoleInvoked then
			LogLn('Cant Get color name from an RGB mode colors.');
	  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
	  exit;
   end;
   i:=0;
   i:=GetFGColorIndex;

   if MaxColors=256 then begin
	      GetFGName:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
		  exit;
   end else if MaxColors=16 then begin
	      GetFGName:=GEtEnumName(typeinfo(TPalette16Names),ord(i));
		  exit;
   end;	

end;


function GetBGName:string;

var
   i:byte;
   somecolor:PSDL_Color;
   someDWord:DWord;

begin
   if (MaxColors> 256) then begin

      If IsConsoleInvoked then
			LogLn('Cant Get color name from an RGB mode colors.');
	  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
	  exit;
   end;
   i:=0;
   i:=GetBGColorIndex;

   if MaxColors=256 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
		  exit;
   end else if MaxColors=16 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette16Names),ord(i));
		  exit;
   end;	

end;


//returns the current color index
//BG is the tricky part- we need to have set something previously.

function GetBGColorIndex:byte;

var
   i:integer;

begin
     
     if MaxColors=16 then begin
     i:=0;
        repeat
	        if TPalette16.dwords[i]= _bgcolor then begin
		        GetBGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;
    end;
     
     if MaxColors=256 then begin
       i:=0; 
       repeat
	        if TPalette256.dwords[i]= _bgcolor then begin
		        GetBGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 end else begin
		If IsConsoleInvoked then
			LogLn('Cant Get index from an RGB mode (or non-palette) colors.');
	    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get index from an RGB mode (or non-palette) colors.','OK',NIL);
		exit;
	 end;
end;


function GetFGColorIndex:byte;

var
   i:integer;
   someColor:PSDL_Color;
   r,g,b,a:PUInt8;

begin
    SDL_GetRenderDrawColor(renderer,r,g,b,a); //returns SDL color but we want a DWord of it
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);
    somecolor^.a:= $ff;
     
     if MaxColors=16 then begin
       i:=0;  
       repeat
	        if ((TPalette16.colors[i]^.r=somecolor^.r) and (TPalette16.colors[i]^.g=somecolor^.g) and (TPalette16.colors[i]^.b=somecolor^.b))  then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;
     end;
     
     if MaxColors=256 then begin
       i:=0; 
       repeat
	        if ((TPalette256.colors[i]^.r=somecolor^.r) and (TPalette256.colors[i]^.g=somecolor^.g) and (TPalette256.colors[i]^.b=somecolor^.b))  then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 end else begin
		If IsConsoleInvoked then
			LogLn('Cant Get index from an RGB mode colors.');

		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get index from an RGB mode colors.','OK',NIL);
		exit;
	 end;
end;


{
How to implement "turtle graphics":

on start( the end of initgraph): 

show a turtle in center of the screen as a "mouse cursor"
and give user option of "mouse"(pen) or keyboard for input(or assume it)


PenUp -(GotoXY and wait for PenDown to be called)
PenDown -(Line x,y from relx,rely and wait for penUp to be called)


are the only routines we need.

to exit:

InTurtleGraphics:=false;
SDL_RenderClear;

closeGraph when done.

However- this was before the era of the mouse and we can do better in SDL.

Create a "clickable canvas".

PenDown is DownMouseButton[x]
PenUp is UpMouseButton[x]

- (you are drawing with the mouse, not the keyboard.)
- this demo has been done.

(easily catchable in the event handler)

}


//"overloading" make things so much easier for us....


//sets "pen color" given an indexed input
procedure setFGColor(color:byte);
begin

   if MaxColors=256 then begin
        colorToSet:=Tpalette256.DWords[color];
        __fgcolor:= colorToSet;
   end else if MaxColors=16 then begin
		colorToSet:=Tpalette16.DWords[color];
        __fgcolor:= colorToSet;
   end;
end;


//sets pen color to given dword.
procedure setFGColor(someDword:dword); overload;
begin
        __fgcolor:= someDword;
end;

{
//required for normal USE: FIXME

procedure setFGColor(r,g,b:word); overload;
var
	someColor:PSDL_Color;

begin
    someColor^.r:=r;
    someColor^.g:=g;
    someColor^.b:=b;
    someColor^.a:=$ff;
//convert tuple into DWord
//SDL_GetRGB
	
    __fgcolor:= colorToSet;

end;

procedure setFGColor(r,g,b,a:word); overload;
var
	someColor:PSDL_Color;

begin

    someColor^.r:=r;
    someColor^.g:=g;
    someColor^.b:=b;
    someColor^.a:=a;
//convert quad into DWord
SDL_GetRGBA
        __fgcolor:= colorToSet;

end;
}


//sets background color based on index
//which surface?? The main one, or a sub-one?
procedure setBGColor(index:byte; Surface:PSDL_Surface);

begin

    if MaxColors=256 then begin        
        _bgcolor:=Tpalette256[index].dwords; //set here- fetch later

   if MaxColors=16 then begin 
        _bgcolor:=Tpalette256.dwords[index]; //set here- fetch later

end;

procedure setBGColor(someDword:DWord; Surface:PSDL_Surface); overload; 
begin
       _bgcolor:=SomeDword; //set here- fetch later
end;

procedure setBGColor(r,g,b:byte;Surface:PSDL_Surface); overload;

//bgcolor here and rgba *MAY* not match our palette..be advised.

begin
       _bgcolor:=SDL_MapRGB(MainSurface^.format,r,g,b);
end;

procedure setBGColor(r,g,b,a:byte; Surface:PSDL_Surface); overload;

//bgcolor here and rgba *MAY* not match our palette..be advised.


begin
       _bgcolor:=SDL_MapRGBA(MainSurface^.format,r,g,b,a);
end;

// ColorNameToNum(ColorName : string) : integer;
//isnt needed anymore because enums carry a number for the defined "NAME".

//remember: _fgcolor and _bgcolor are DWord(s). They are not, and nevermore will be -index numbers.

function GetFgDWordRGBA:DWord;

var
  somecolor:PSDL_Color;
  r,g,b,a:PUint8;

begin
    if (MaxColors<=255) then begin
       if IsConsoleInvoked then begin
          LogLn('Trying to fetch foreground color -when we have it- in Paletted mode.');
          LogLn('We already have it.');
          exit;
       end;
       SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'We already have the Foreground Color in Paletted mode.','OK',NIL);
        exit; //rgba not supported in indexed mode
    end;

    GetFgDWordRGBA:=__fgcolor;
end;


function GetBgDWordRGB:DWord;
var
	someColor:PSDL_Color;
    someDWord:Dword;
begin

    if (MaxColors<=255) then exit; 
       if IsConsoleInvoked then begin
          LogLn('Trying to fetch background color -when we have it- in Paletted mode.');
          LogLn('We have the background color in paletted modes!');
          exit;
       end;
       SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'We already have the Background Color in Paletted mode.','OK',NIL);
    //force RGB color to be returned (from maybe a RGBA) surface?
    //FIXME: convert __bgcolor to a SDL_Color quad
    //then re-assemble the DWord
    GetBgDWordRGB:=someDWord;    
end;

function GetBgDWordRGBA:DWord;
begin
    GetBgDWordRGBA:=__bgcolor;
end;

procedure invertColors;

//so you see how to do manual shifting etc.. 
var
   r, g, b, a:PUInt8;
   somecolor:PSDL_Color;
begin

	SDL_GetRenderDrawColor(renderer, r, g, b, a);

    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);
    somecolor^.a:=byte(^a);

	SDL_SetRenderDrawColor(renderer, 255 - somecolor^.r, 255 - somecolor^.g, 255 - somecolor^.b, somecolor^.a); 

end;


{

DO NOT BLINDLY ALLOW any function to be called arbitrarily.(this was done in C- I removed the checks for a short while)

two exceptions:

making a 16 or 256 palette and/or modelist file

NET:

	init and teardown need to be added here- I havent gotten to that.

}

//this was ported from (SDL) C- 
//https://stackoverflow.com/questions/37978149/sdl1-sdl2-resolution-list-building-with-a-custom-screen-mode-class

//(its a VESA/VGA equivalent for SDL)
//checking supported is in another routine(DetectGraph)

function FetchModeList:Tmodelist;

//use XRandr...or...SetVideoMode 
{
var
    mode_index,modes_count ,display_index,display_count:integer;
    i:integer;


begin
   display_count := SDL_GetNumVideoDisplays; //1->display0
   LogLn('Number of displays: '+ intTOstr(display_count));
   display_index := 0;

//for each monitor do..
while  (display_index <= display_count) do begin
    LogLn('Display: '+intTOstr(display_index));

    modes_count := SDL_GetNumDisplayModes(display_index); //max number of supported modes
    mode_index:= 0;
    i:=0;

    //do for each mode in the number of possible modes
    while ( mode_index <= modes_count ) do begin

        SDLmodePointer^.format:= SDL_PIXELFORMAT_UNKNOWN;
        SDLmodePointer^.w:= 0;
        SDLmodePointer^.h:= 0;
        SDLmodePointer^.refresh_rate:= 0;
        SDLmodePointer^.driverdata:= Nil;


        if (SDL_GetDisplayMode(display_index, mode_index, SDLmodePointer) = 0) then begin //mode supported

            //Log: pixelFormat(bpp)MaxX,MaXy,refrsh_rate            
            LogLn(IntToStr(SDL_BITSPERPIXEL(SDLmodePointer^.format))+' bpp'+ IntToStr(SDLmodePointer^.w)+ ' x '+IntToStr(SDLmodePointer^.h)+ '@ '+IntToStr(SDLmodePointer^.refresh_rate)+' Hz ');

            //store data in a modeList array

                SDLmodeArray[i].format:=SDL_BITSPERPIXEL(SDLmodePointer^.format);            
                SDLmodeArray[i].w:=SDLmodePointer^.w;                
                SDLmodeArray[i].h:=SDLmodePointer^.h;                
                SDLmodeArray[i].refresh_rate:=SDLmodePointer^.refresh_rate;                
                SDLmodeArray[i].driverdata:=SDLmodePointer^.driverdata;

        end;
        inc(i);
        inc(mode_index);
    end;
    inc(display_index);
}    
end;


{

Graphics detection is a wonky process.
1- fetch (or find) whats supported
2- find highest mode in that list
3- use it, or try to.

repeat num 2 and 3 if you fail- until no modes work


I was THIS mode, and none other- it had better be supported (but is it?)
(try or fail)


Although generally in SDL(and on hardware) smaller windows and color depths are supported(emulation),
SDL -by itself- might not support that mode.


Do we care- as mostly we are setting windows sizes? Not usually.
WE could care less if the data is scaled on fullsceen-since we arent responsible for the scaling

(whether things look good- is another matter)

A TON of old code was written when pixels were actually visible. NOT THE CASE, anymore.


DetectGraph is here more for compatibility than anything else.
It seems to be used as often as DEFINED modes.


Interrupt handling:

The reason this is remmed out is bc I want YOu to do this.
The code is however-reasonable- but untested.


}

procedure IntHandler;
//This is a dummy routine. Im only giving you the basics. SOMETHING HAS TO BE HERE.
//I want you- Users/programmers to override this routine and DO THINGS RIGHT.
// EXPORT the EVENT, then you can do that.

begin

  while true do begin //mainloop -should never exit

  if (SDL_PollEvent(event) = 1) then begin
      
      case event^.type_ of
 
               //keyboard events
        SDL_KEYDOWN: begin
			case event^.key.keysym.sym of
				//ESC always exits				
				SDLK_ESCAPE:begin
					quit:=true;                                
                    break;
				end;
			end;	
        end;

	    SDL_MOUSEBUTTONDOWN: begin
	    end;
        
        SDL_WINDOWEVENT: begin
                           
                           case event^.window.event of
                             SDL_WINDOWEVENT_MINIMIZED: minimized:=true; //pause
                             SDL_WINDOWEVENT_MAXIMIZED: minimized:=false; //resume
                             SDL_WINDOWEVENT_ENTER: begin
                                   //hidemouse
                             end; 
                             SDL_WINDOWEVENT_LEAVE: begin
                                   //showmouse
                             end;

                             SDL_WINDOWEVENT_SHOWN: begin
								//redraw window
								SDL_RenderPresent(renderer);
                             end;
                             
							//we got overlapped by something, redraw the window(PageFlip again).
                             SDL_WINDOWEVENT_EXPOSED: begin
								//redraw window
								SDL_RenderPresent(renderer);
								
                             end;
                             
                             SDL_WINDOWEVENT_CLOSE: begin
                                quit:=true;                                
                                break;
                             end;
                           end; //case
        end; //subcase
                    
      end;  //case

   end; //input loop
   // writeln('event handled: ',event^.type_);
  end; //mainloop
  closegraph;
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

//basic Dword <-> SDL_Color conversion

//to get the longword

function RGBToDWord(somecolor:PSDL_Color):DWord;
var
    someDword:DWord;

begin
    someDWord := (somecolor^.R or somecolor^.G or somecolor^.B or $ff);
    RGBAToDWord:=someDWord;
end;
function RGBAToDWord(somecolor:PSDL_Color):DWord;
var
    someDword:DWord;

begin
    someDWord := (somecolor^.R or somecolor^.G or somecolor^.B or somecolor^.A);
    RGBAToDWord:=someDWord;
end;

//to break down into components using RGB mask(BGR is backwards mask)
function DWordToRGB(someword:DWord):PSDL_Color;

var
    somecolor: PSDL_Color;
begin
    somecolor^.R := (someword and $FF000000);
    somecolor^.G := ((someword and $00FF0000) shr 8);
    somecolor^.B := ((someword  and $0000FF00) shr 16);
    somecolor^.A := $ff;
    DWordToRGBA:=somecolor;
end;

function DWordToRGBA(someword:DWord):PSDL_Color;

var
    somecolor: PSDL_Color;
begin
    somecolor^.R := (someword and $FF000000);
    somecolor^.G := ((someword and $00FF0000) shr 8);
    somecolor^.B := ((someword  and $0000FF00) shr 16);
    somecolor^.A := ((someword and $000000FF) shr 24);
    DWordToRGBA:=somecolor;
end;


{

PageFlip is being called automatically at minimum (screen_refresh) as an interval.
        If not ready(deltas..use deltas...) then set RenderingDone to false.

This is the preferred "faster" method.

Refreshing the screen is fine- if data is in the backbuffer. 
Until its copied into the main buffer- its never displayed.

HOWEVER--
        DO NOT OVER RENDER. It will crash the best of systems.
    
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


procedure unlock(someSurface:PSDL_Surface); overload;
begin
    if SDL_MustLock(someSurface)=true then
           SDL_UnlockSurface(someSurface);
    //else exit: no UNlocking needed
end;

//BGI spec
procedure clearDevice;

begin
//dont re-create the wheel, here
    SetBGColor(MainSurface,__fgcolor,true); 
    //since we didnt specify which color, use the current one.
    //assume we want to obliterate the entire screen.
//   SDL_FillRect(0,0,MaxX,MaxY);
end;

procedure clearscreen; 
//this is an alias routine

begin
    if LIBGRAPHICS_ACTIVE=true then
        clearDevice
    else //use crt unit
        clrscr;
end;



//all of these need to be rewritten-syn tax has been paid- calling convention is incorrect.
procedure clearscreen(index:byte); overload;

var
    somecolor:PSDL_Color;
begin
    if MaxColors>256 then begin
        if IsConsoleInvoked then
           LogLn('ERROR: i cant do that. not indexed.');
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempting to clearscreen(index) with non-indexed data.','OK',NIL);   
        LogLn('Attempting to clearscreen(index) with non-indexed data.');           
        exit; 
    end;
    if MaxColors=16 then
       somecolor:=Tpalette16[index].dwords;    
    if MaxColors=256 then
       somecolor:=Tpalette[index]256.dwords;
    SetBGColor(MainSurface,somecolor,true); 
end;


procedure clearscreen(color:Dword); overload;

begin
     SetBGColor(MainSurface,color,true); 
end;

//these two dont need conversion of the data
procedure clearscreen(r,g,b:byte); overload;
var
	someDWord:Dword;
    someColor:SDL_Color;
//convert SDL_Color to DWord first, set A bit to FF
begin
     someColor^.r:=r;
     someColor^.g:=g;
     someColor^.b:=b;
     someColor^.a:=$ff;

     someDWord:=RGBToDWord(someColor);
     SetBGColor(MainSurface,someDword,true); 
end;


procedure clearscreen(r,g,b,a:byte); overload;
//convert SDL_COlor to DWord first
	
var
	someDWord:Dword;
    someColor:SDL_Color;
//convert SDL_Color to DWord first, set A bit to FF
begin
     someColor^.r:=r;
     someColor^.g:=g;
     someColor^.b:=b;
     someColor^.a:=a;

     someDWord:=RGBAToDWord(someColor);
     SetBGColor(MainSurface,someDword,true); 
end;


//spec says clear the last one assigned
procedure clearviewport;

//clears it, doesnt remove or add a "layered window".
//usually the last viewport set..not necessary the whole "screen"


begin
   viewport^.X:= texBounds[windownumber]^.x;
   viewport^.Y:= texBounds[windownumber]^.y;
   viewport^.W:= texBounds[windownumber]^.w;
   viewport^.H:= texBounds[windownumber]^.h;
   //with BGColor...
   SDL_FillRect(viewport^.X,viewport^.Y,viewport^.W,viewport^.H);
end;


function videoCallback(interval: Uint32; param: pointer): Uint32; cdecl; 
//this is a funky interrupt-ish callback in C. Its very specific code.
//that said, IO is pushed, then popped -from CPU registers in weird ways- why this is so specific.

//we dont always need the input params, nor the interval- its already assigned before we are called.
//(but it has to be given to us)

var
    TimerTicks:Longword;

begin
   param:=Nil; //not used
   
   if (not Paused) then begin //if paused then ignore screen updates
           SDL_Flip(Renderer);
   end;
  
   videoCallback := interval; //we have to return something-the what, WE should be defining.
end;


//NEW: do you want fullscreen or not?

function initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean):PSDL_Surface;
//This code only works a certain way- thats why languages "lacking globals" cannot compile this code.

//you would only kick-back a renderer or mainSurface, the GC. 
//YOU **SHOULD** BE EXPORTING THE GC pointer by default. 
//This eliminates problems later on when using units instead of "raw code" in applications.

//If surface is Nil, we FAILED. ABORT!

var
	i:integer;
	_initflag,_imgflags:longword; //PSDL_Flags?? no such beast 
    iconpath:string;
    imagesON,FetchGraphMode:integer;
	mode:PSDL_DisplayMode;
  //  AudioSystemCheck:integer;

begin

  if LIBGRAPHICS_ACTIVE then begin
    if ISConsoleInvoked then begin
        LogLn('Initgraph: Graphics already active. Exiting.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Initgraph: Graphics already active.','OK',NIL);	
    exit;
  end;
  pathToDriver:='';  //unused- code compatibility
  iconpath:='./sdlbgi.bmp'; //sdl2.0 doesnt use this.

  case(graphmode) of

{
         we have full frame LFB now- planar storage doesnt make sense, is very bit-wise...
         -and very hard to do animations with.

         bitshifting is significantly faster than math operations, however. Not everyone took this into account.

         SDL becomes slow on put/getpixel ops due to repeated "one shot" operations instead of batches(buffered ops/surfaces)
         each get/putPixel operation *may* have to shift colors- AND was slowed down further by a (now removed) Pixel Mask(BGI).
		 (this was supposed to be only for lines and pen strokes)

         Hardware surfaces add wait times during copy operations between graphics hardware and CPU memory.
         ** SDL1 MAY NOT SUPPORT HW Surfaces on newer hardware**
         
         Despite the GPU being several orders (10x?) of magnitude faster than the CPU,GPU ops must also be "byte aligned".
         -In this case, 32 bits.

         How 24bit is natively supported, nobody will ever know. Probably like I do 15bit modes.

         Despite rumors- 
                CGA is 4COLOR, 4Mode Graphics. 16 color mode is "extremely low resolution" on CGA systems.
                EGA and VGA use 16 color modes.

        You probably remember some text mode hack- or use of text mode symbols, like MegaZuex (openmzx) uses.

		bpp is always set to 8 on lower bitdepths, MaxColors variable checks the actual depth(SDL bug workaround).
		SDL supports these "LSB modes" but wont allow get/putpixel ops in these modes(why?).
}

		//standardize these as much as possible....

		//lo-res modes-try using SDL_SOFTSTRETCH()
		
		//CGALo
		m160x100x16:begin
            MaxX:=160;
			MaxY:=100;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;
		    //some of these its weird, 4x3 unless otherwise specified	
            XAspect:=4;
            YAspect:=3; 		
		end;
		
		//CGAMed - there are 4 viable palettes in this mode
		m320x200x4:begin
		    MaxX:=320;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=4;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;	
			
		//CGAHi
		m640x200x2:begin
		    MaxX:=640;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=2;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		//EGA
		m320x200x16:begin
		    MaxX:=320;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 		
		end;		
		
		//VGALo
		m320x200x256:begin
			MaxX:=320;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;
		
		//EGAHi (or VGAMed)
		m640x200x16:begin
			MaxX:=640;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 		
		end;		

		//end lo-res modes
		
		//VGAHi
		m640x480x16:begin
			MaxX:=640;
			MaxY:=480;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m640x480x256:begin
		    MaxX:=800;
			MaxY:=600;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m640x480x32k:begin
		    MaxX:=640;
			MaxY:=480;
			bpp:=15; 
			MaxColors:=32768;
            NonPalette:=True;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m640x480x64k:begin
		    MaxX:=640;
			MaxY:=480;
			bpp:=16; 
			MaxColors:=65535;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m640x480xMil:begin
		    MaxX:=640;
			MaxY:=480;
			bpp:=24; 
			MaxColors:=0; //no op
            NonPalette:=True;
		    TrueColor:=True;	
            XAspect:=4;
            YAspect:=3; 
		end;

		//SVGA (and VESA modes)
		m800x600x16:begin
            MaxX:=800;
			MaxY:=600;
			bpp:=8; 
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
		m800x600xMil:begin
           MaxX:=800;
		   MaxY:=600;
		   bpp:=24; 
		   MaxColors:=0;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=4;
           YAspect:=3; 		
		end;

		m1024x768x16:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=8; 
		   MaxColors:=16;
           NonPalette:=false;
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

		m1024x768xMil:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=24; 
		   MaxColors:=0;
           NonPalette:=true;
		   TrueColor:=true;	
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

		m1280x1024x16:begin
			MaxX:=1280;
			MaxY:=1024;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
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
	    
  end;{case}

//once is enough with this list...its more of a nightmare than you know.

{
There are claims that DX and HW Surfaces arent worth the headache- I say:
		Stop being a lazy fuck- and optimise your code. At the very least, use SDL2.

Lets use WHAT WE WANT, DAMNIT. (I will purge the flawed SDL C later.)
}

{$IFDEF mswindows}
	SDL_putenv('SDL_VIDEODRIVER=directx'); //Use DirectX, dont use GDI
	SDL_putenv('SDL_AUDIODRIVER=dsound'); //Fuck it, use direct sound, too.
    //unless below XP:
    ForceSWSurface:=False;
{$ENDIF}

{$IFDEF mac}
	SDL_putenv('SDL_VIDEODRIVER=DSp'); //DrawSprockets- I chose this on purpose. Dig for the OS9 Extensions.
	SDL_putenv('SDL_AUDIODRIVER=sndmgr'); //The OLD Mac Audio SubSystem
    //force software surfaces on older hardware(faster)
    ForceSWSurface:=True;
{$ENDIF}

{$IFDEF darwin}
	SDL_putenv('SDL_VIDEODRIVER=quartz'); //Quartz2D
	SDL_putenv('SDL_AUDIODRIVER=coreaudio'); //The new OSX Audio Subsystem
    ForceSWSurface:=False;
{$ENDIF}

{$IFDEF unix}
    {$IFNDEF console}
	   //Pretty deFacto Standard stuff
	   //X11 might not have HW acceleration, except with older hardware and X11 (vs newer XOrg)
	   SDL_putenv('SDL_VIDEODRIVER=x11'); //no OGL option (thats how OLD SDL1 is).
	   SDL_putenv('SDL_AUDIODRIVER=pulse');
       ForceSWSurface:=False; 
    {$ENDIF}
       //Were in a TTY, NO x11...we may have fb acceleration (possibly running on a RasPi)
	   SDL_putenv('SDL_VIDEODRIVER=svgalib'); //svgalib on FB (FPC has working-albeit tiny- Graphics unit for this.)
	   SDL_putenv('SDL_AUDIODRIVER=alsa'); //Guessing here- should be available(has been for awhile).
       ForceSWSurface:=True;        
{$ENDIF}

   //"usermode" must match available resolutions etc etc etc
   //this is why I removed all of that code..."define what exactly"??

  //attempt to trigger SDL...on most sytems this takes a split second- and succeeds.
  //at minimum setup a timer (TTimer?) and Video callback
  _initflag:= SDL_INIT_VIDEO or SDL_INIT_TIMER;

  //keyb and mouse are handled by default, joystick interface changes in version 2- 
  // as does physical connection(joyport or parrallel -to USB).
  if WantsJoyPad then _initflag:= SDL_INIT_VIDEO or SDL_INIT_TIMER or SDL_INIT_JOYSTICK;

  //audio on SDL1 isnt too bad, but use libuos instead
//  if WantsAudioToo then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER; 
//  if WantsJoyPad and WantsAudioToo then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_JOYSTICK;

//if WantInet then SDL_Init_Net; 

//turn off the parachute!!(SDL2-like)
  _initflag:= _initflag or SDL_INIT_NOPARACHUTE;

  if ( SDL_Init(_initflag) < 0 ) then begin
     //we cant speak- write something down.

     if ISConsoleInvoked then begin
        LogLn('InitGraph Failed to Launch SDL. **GENERAL ERROR**');
        LogLn(SDL_GetError);
     end;
     //if we cant init- dont bother with dialogs.
     LIBGRAPHICS_ACTIVE:=false; 
     halt(162); //the other routines are now useless- since we didnt init- dont just exit the routine, DIE instead.

  end;
 
  if wantsFullIMGSupport then begin

    _imgflags:= IMG_INIT_JPG or IMG_INIT_PNG or IMG_INIT_TIF;
    imagesON:=IMG_Init(_imgflags);

    //not critical, as we have bmp support but now are limping very very bad...
    if((imagesON and _imgflags) <> _imgflags) then begin
       if IsConsoleInvoked then begin
		 LogLn('IMG_Init: Failed to init required JPG, PNG, and TIFF support!');
		 LogLn(IMG_GetError);
	   end;
	   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'IMG_Init: Failed to init required JPG, PNG, and TIFF support','OK',NIL);	
    end;
  end;

{
 im going to skip the RAM requirements code and instead haarp on proper rendering requirements.
 note that a 12 yr old notebook-try as it may- might not have enough vRAM to pull things off.
 can you squeeze the code to fit into a 486??---you are pushing it.

}

  NoGoAutoRefresh:=false;
  LIBGRAPHICS_INIT:=true; 
  LIBGRAPHICS_ACTIVE:=false; 

//we do it this way because we might already be active- why duplicate code?

//sets up mode- then clears it in standard "BGI" fashion.
  SetGraphMode(Graphmode,wantFullScreen);
 
  
//no atexit handler needed, just call CloseGraph
//that was a nasty SDL surprise...

{ here is how to set one up:
basically it prevents random exits- all exits must call whatever is in the routine,
in this case closegraph BEFORE leaving.

(You are a hung process if you dont leave at all)
This ports -via the compiler- to some whacky assembler far calls.(hence the F)

 OldExitProc := ExitProc;                - save previous exit proc -cpu: push exit()
  ExitProc := @MyExitProc;               - insert our exit proc in chain 

$F+
procedure MyExitProc;
begin
  ExitProc := OldExitProc;  Restore exit procedure address -cpu: pop exit()
  CloseGraph;               Shut down the graphics system 
end; 
$F-

}

  
//lets get the current refresh rate and set a screen timer to it.
// we cant fetch this from X11? sure we can.
{

  mode^.format := SDL_PIXELFORMAT_UNKNOWN;
  mode^.w:=0;
  mode^.h:=0;
  mode^.refresh_rate:=0;
  mode^.driverdata:=Nil;
  //for physical screen 0 do..
  
  //The SDl equivalent error of: attempting to probe VideoModeInfo block when (VESA) isnt initd results in issues....

  if(SDL_GetDisplayMode(0,0, mode) <> 0) then begin
    if IsConsoleInvoked then
			LogLn('Cant get current video mode info. Non-critical error.');
//    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SDL cant get the data for the current mode.','OK',NIL);
  end;


  //dont refresh faster than the screen.
  if (mode^.refresh_rate > 0)  then 
     //either force a longINT- or convert from REAL. Otherwise you have to pass it as a interrupt proc param--it hairy mess.
     flip_timer_ms := longint(mode^.refresh_rate)
  else
     flip_timer_ms := 17; 


  video_timer_id := SDL_AddTimer(flip_timer_ms, @videoCallback, nil);
  if video_timer_id=0 then begin
    if IsConsoleInvoked then begin
		LogLn('WARNING: cannot set drawing to video refresh rate. Non-critical error.');
		LogLn('you will have to manually update surfaces and the renderer.');
    end;
//    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SDL cant set video callback timer.Manually update surface.','OK',NIL);
    NoGoAutoRefresh:=true; //Now we can call Initgraph and check, even if quietly(game) If we need to issue Flip calls.
  end;
}
  
  CantDoAudio:=false;
    //prepare mixer
{
  if WantsAudioToo then begin

     //use uos

  end;

}

  //initialization of TrueType font engine
  if TTF_Init = -1 then begin
    
    if IsConsoleInvoked then begin
        LogLn('I cant engage the font engine, sirs.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: I cant engage the font engine, sirs. ','OK',NIL);
		
    _graphResult:=-3; //the most likely cause, not enuf ram.
    closegraph;
  end;

//set some sane default variables
  _fgcolor := $FFFFFFFF;	//Default drawing color = white (15)
  _bgcolor := $000000FF;	//default background = black(0)
  someLineType:= NormalWidth; 


  LIBGRAPHICS_ACTIVE:=true;  //We are fully operational now.
  paused:=false;

  _grResult:=OK; //we can just check the dialogs (or text output) now.

  where.X:=0;
  where.Y:=0;


//set some sensible input specs
  //SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);


  //Check for joysticks 
  if WantsJoyPad then begin
 
    if( SDL_NumJoysticks < 1 ) then begin
        if IsConsoleInvoked then
			LogLn( 'Warning: No joysticks connected!' ); 
        
  		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Warning: No joysticks connected!','OK',NIL);
        
    end else begin //Load joystick 
	    gGameController := SDL_JoystickOpen( 0 ); 
    
        if( gGameController = NiL ) then begin  
	        if IsConsoleInvoked then begin
		    	LogLn( 'Warning: Unable to open game controller! SDL Error: '+ SDL_GetError); 
                LogLn(SDL_GetError);
            end;
            SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Warning: Unable to open game controller!','OK',NIL);
            noJoy:=true;
        end;
        noJoy:=false;
    end; 
  end; //Joypad 

 //DEBUG The GC:
 // LogLn(longword(@MainSurface));
 //if at any time this is Nil-> exit.

end; //initgraph


//obviously RENDERER ops dont work here...
procedure DrawDoubleLinedWindowDialog(Rect:PSDL_Rect);

var
    UL,UR,LL,LR:Points; //PolyPts
    ShrunkenRect,ShurunkenRect2,NewRect:PSDL_Rect;

begin
//    Tex:=NewTexture;
    SDL_SetViewPort(Rect);

    //this is guesstimate math here, not actual.
    //the corner co ords
    
    //come in by 2px, drawRect, come in by 2px, drawrect, come in by 2px- setViewport (I trapped you twice in a box..)
    UL.x:=x+2;
    UL.y:=y+2;
    UR.x:=w-2;
    LR.y:=h-2;    
    NewRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    //SDL_SetRenderDrawColor(_fgcolor);
    SDL_RenderDrawRect(NewRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)

    //shink available space and...
    //do this again- further in
    UL.x:=x+4;
    UL.y:=y+4;
    UR.x:=w-4;
    LR.y:=h-4;

    ShrunkenRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    //SDL_SetRenderDrawColor(_fgcolor);
    SDL_RenderDrawRect(ShrunkenRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)

    UL.x:=x+6;
    UL.y:=y+6;
    UR.x:=w-6;
    LR.y:=h-6;
    ShrunkenRect2:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetViewPort(ShrunkenRect2);

end;

procedure DrawSingleLinedWindowDialog(Rect:PSDL_Rect);

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
    UR.x:=w-2;
    LR.y:=h-2;
    NewRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
     //SDL_SetRenderDrawColor(_fgcolor);
   SDL_RenderDrawRect(NewRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)
    
    //do this again- further in
    UL.x:=x+4;
    UL.y:=y+4;
    UR.x:=w-4;
    LR.y:=h-4;
    ShrunkenRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format 
    SDL_SetViewPort(ShrunkenRect);

end;

//I cant believe these primitives are missing!!! OH MAE GAWD.

{

So far Ive had to implement:

	PutPixel/GetPixel (intentionally missing from SDL)
	Line/HLine/VLine (ok, sort of FPC team, too)
	Triangle
	PixelTriangle (minimum TRI support needed)
	Circle/Filled Circle and Ellipse/Filled Ellipse (bresnans or fpc team or similar)
	Fat/ Nearest Neighbor Pixels(blocks)

-On top of "getting these units SANE"....
	
Now I know why people keep this shit proprietary(and hide it in secret)...DAMN...theyre doing all the work for nothing.
Everyone has everything else- it was given to them...they dont want to work for it.
 
}

procedure Rectangle(Rect:SDL_Rect); //if you want one, give me four points
var
	x,y,x1,y1,x2,y2,x3,y3:word;
begin

//join four lines points- to each other.
		Line(x,y,x1,y1);
		Line(x1,y1,y2,x2);
		Line(x2,y2,x3,y3);
		Line(x3,x3,x,y);		//The forth line returns to sender
		SDL_Flip;
end;

//everything is made of these, yet still...no primitive in SDL?

//Incomplete SDL2 code- the drawing sequence is correct. 

{ 
PixelTris are a smidge different. 
PixelTris are caddy-corner Pixels(up or down diagonal depending on the direction of the tri.)
Instead of Line, use PutPixel here.
PixelTris are for "more precise rendering".

Plop-drop em randomly for a neat effect...
}
 
procedure UDPixelTriangle(x,y:word; PointsUp:boolean); //if you want one, give me three points
begin
		PutPixel(x,y);
		if PointsUp then begin
			PutPixel(x-1,y+1);
			PutPixel(x+1,y+1);
		end else begin
		    PutPixel(x-1,y-1);
			PutPixel(x+1,y-1);
		end;
		//are we done?
end;

procedure LRPixelTriangle(x,y:word; PointsLeft:boolean); //if you want one, give me three points
begin
		PutPixel(x,y);
		if PointsLeft then begin
			PutPixel(x+1,y+1);
			PutPixel(x+1,y-1);
		end else begin
		    PutPixel(x-1,y+1);
			PutPixel(x-1,y-1);
		end;
		//are we done?
end;


procedure Triangle(Tri:TriPoints); //if you want one, give me three points
begin

//use the above, but "bend the lines together", return to sender with 3, not 4 points instead.

		Line(x,y,x1,y1);
		Line(x1,y1,y2,x2);
		Line(x2,y2,x,y);
		//are we done?
end;


var
    FontPointer:PTTF_Font;


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
{
  if WantsAudioToo then begin
    Mix_CloseAudio; //close- even if playing

    if chunk<>Nil then
        Mix_FreeChunk(chunk); 
    if music<> Nil then 
        Mix_FreeMusic(music);

    Mix_Quit;
  end;
}
   SDL_RemoveTimer(video_timer_id);
   video_timer_id := 0;


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
  TTF_CloseFont(FontPointer);
  TTF_Quit;
  //its possible that extended images are used also for font datas...
  if wantsFullIMGSupport then 
     IMG_Quit;

  die:=9; //signal number 9=kill
  //Kill child if it is alive. we know the pid since we assigned it(the OS really knows it better than us)

  //we are stuck in a loop
  //we can however, trip the loop to exit...

  exitloop:=true;
  Killstatus:=FpKill(EventThread,Die); //send signal (DIE) to thread

  EventThread:=0;

  dispose( Event );
  //free viewports

{//subSURFACE??
  x:=8;
  repeat
	if (Textures[x]<>Nil) then
		SDL_DestroyTexture(Textures[x]);
	Textures[x]:=Nil;
    dec(x);
  until x=0;
}  

//Dont free whats not allocated in initgraph(do not double free)
//routines should free what they allocate on exit.

  if (MainSurface<> Nil) then begin
	SDL_FreeSurface( MainSurface );
	MainSurface:= Nil;
  end;	

  if (Window<> Nil) then begin
	Window:= Nil;
  	SDL_DestroyWindow ( Window );
  end;	

  if IsConsoleInvoked then begin
     
         textcolor(7); //..reset standards...
         clrscr; //text clearscreen
         writeln;
  end;
  //unless you want to mimic the last doom screen here...usually were done....  
  //Yes you can override this function- if you need a shareware screen on exit..Hackish, but it works.
  //"@ExitProc rerouting routines" (and checks) go here

  SDL_Quit; 
 
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


procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 
//initgraph should call us to prevent code duplication
//exporting a record is safer..but may change "a chunk of code" in places.   
var
	flags:longint;
    success,IsThere:integer;
    surface1:PSDL_Surface;
    FSNotPossible:boolean;
    thismode:string;
  
begin
//we can do fullscreen, but dont force it...
//"upscale the small resolutions" is done with fullscreen.
//(so dont worry if the video hardware doesnt support it)


//if not active:
//are we coming up?
//no? EXIT

//Notice that DetectGraph should be working now.

if (LIBGRAPHICS_INIT=false) then 

begin
		
		if IsConsoleInvoked then LogLn('Call initgraph before calling setGraphMode.') 
		else SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'setGraphMode called too early. Call InitGraph first.','OK',NIL);
	    exit;
end
else if (LIBGRAPHICS_INIT=true) and (LIBGRAPHICS_ACTIVE=false) then begin //initgraph called us
    writeln('MaxX: ',MaxX);
    writeln('MaxY: ',MaxY);
    writeln('bpp: ',bpp);
    if wantfullscreen = true then
        wantsFS='True';
    else
		wantsFS:='False';
    writeln('Full screen requested: ',wantsFS);
                   
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

    end;

    if mode=Detect then begin
       DetectGraph;
       exit;
    end;

    if ForceSWSurface=true then begin
		if wantsFullsCreen=true then
		    sdlflags:= (SDL_SWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF or SDL_FULLSCREEN);
		else
			sdlflags:= (SDL_SWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF);   
    end;
    if ForceSWSurface=false begin
		if wantsFullsCreen=true then
		    sdlflags:= (SDL_HWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF or SDL_FULLSCREEN);
		else
			sdlflags:= (SDL_HWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF);   
    end;

		test:=SDL_SetVideoMode(MaxX, MaxY, bpp, sdlflags);
		if test=Nil then begin //we tried an appropriate combo, it didnt work.
			if ForceSWSurface=false then begin
				//The only chance we have left- we tried HW Surface and failed, SW should be available. If that doesnt work, leave.
				Logln('You idiot. Hardware Surface not allowed. Forcing Software Surface Mode.');
				if wantsFullsCreen=true then
					sdlflags:= (SDL_SWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF or SDL_FULLSCREEN);
				else
					sdlflags:= (SDL_SWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF);   
				test:=Nil;
				test:=SDL_SetVideoMode(MaxX, MaxY, bpp, sdlflags); //if it comes back Nil- we are in trouble.
			end;
 	    end;

        if test=Nil then begin //we tried an appropriate combo, it didnt work.
			//error out
			if IsConsoleInvoked then
	             LogLn('InitGraph: Error setting mode: ', SDL_GetError);
			else SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SetGraph(SDL): Couldnt Set VideoMode','OK',NIL);	   
			halt(1); //set this higher
	    end;

    //Hide, mouse.
    SDL_ShowCursor(SDL_DISABLE);

    //reset palette data
    if bpp=4 then
      InitPalette16;
    if bpp=8 then 
      InitPalette256; 
    //then set it back up

{
This should be done in the init source code, not here

    if (bpp<=8) then begin
      if MaxColors=16 then
            SDL_SetPalette(Mainsurface, SDL_LOGPAL, TMYPalette16, 0, 15);
	  else if MaxColors=256 then
            SDL_SetPalette(Mainsurface, SDL_LOGPAL, TMYPalette256, 0, 255);
    end;
} 
     LIBGRAPHICS_ACTIVE:=true;
     exit; //back to initgraph we go.

  end else if (LIBGRAPHICS_ACTIVE=true) then begin //good to go

                   
    case bpp of
		8: begin
			    if maxColors<=256 then format:=SDL_PIXELFORMAT_INDEX8;
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

        //we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;

    end;

		writeln('Resolution Re-Size requested.');
        writeln('New MaxX: ',MaxX);
		writeln('New MaxY: ',MaxY);
		writeln('New bpp: ',bpp);
		if wantfullscreen = true then
			wantsFS='True';
		else
			wantsFS:='False';
		writeln('Full screen requested: ',wantsFS);


    if mode=Detect then begin
       DetectGraph;
       exit;
    end;

    //not a problem, just reset the current mode to another one.
    if ForceSWSurface=false then begin
		if wantsFullsCreen=true then
		    sdlflags:= (SDL_SWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF or SDL_FULLSCREEN);
		else
			sdlflasgs:= (SDL_SWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF);   
    end;
    if ForceSWSurface=true begin
		if wantsFullsCreen=true then
		    sdlflags:= (SDL_HWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF or SDL_FULLSCREEN);
		else
			sdlflasgs:= (SDL_HWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF);   
    end;

		test:=SDL_SetVideoMode(MaxX, MaxY, bpp, sdlflags);
        if test=Nil then begin //we tried an appropriate combo, it didnt work.
			//error out
			if IsConsoleInvoked then
	             LogLn('Error: ', SDL_GetError);
			else SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SetGraph(SDL): Couldnt Set VideoMode','OK',NIL);	   
			closegraph;
	   end;

    //Hide, mouse.
    SDL_ShowCursor(SDL_DISABLE);


  //reset palette data
    if bpp=4 then
      InitPalette16;
    if bpp=8 then 
      InitPalette256; 
{      
  //then set it back up

    if (bpp<=8) then begin
      if MaxColors=16 then
            SDL_SetPalette(Mainsurface, SDL_LOGPAL, TMYPalette16, 0, 15);
	  else if MaxColors=256 then
            SDL_SetPalette(surface, SDL_LOGPAL, TMYPalette256, 0, 255);
    end;
}

  end; 
end; //setGraphMode


function getgraphmode:string; 
//determine what mode we are in based on bpp, MaxX and MaxY.
var
    bppstring:string;
    format:PSDL_PixelFormat;
    MaxMode:integer;
    tempMaxX,tempMaxY:word;
    findbpp:byte;
    thismode:PSDL_DisplayMode;

begin


   if LIBGRAPHICS_ACTIVE then begin 
		x:=0;

        SDL_GetCurrentDisplayMode(0, thismode); //go get w,h,format and refresh rate..
{        case (format) of //inversely get the bpp


        end;}
        tempMaxX:=MainSurface^.w;
		tempMaxY:=MainSurface^.h;

        //now we should have the bpp, MAxX and MaxY values

            //peruse th emodeList for the mode we are looking for- either you found a match or you didnt.
			while (ModeList[x]< (Ord(High(Graphics_Modes))-1)) do begin
			
				if (tempMaxX=MaxX) and (tempMaxY=MaxY)  then begin		
                	    if (MainSurface^.format^.BitsPerPixel<>bpp) then break;			       	
                	    //typinfo shit:                      	
			    	    getgraphmode:=GetEnumName(TypeInfo(Graphics_modes), Ord(x));
						exit;
				end;                
				inc(x);
			
        end;
        if IsConsoleInvoked then begin
            LogLn('Cant find current mode in modelist.');
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

This code is REQUIRED for proper GAMES Programming, Im not there yet.
A lot of variables have to be end user supplied -and checked.

(Yes, There are some parts of SDL hat you need to know, but the BGI Interface API greatly shortens the learning curve,
especially if you can see what Im doing here...)


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
        reset the palette and Flip

        //xorBlit
        //andBlit
        //orBlit
        //notBlit(inverted colors)

SDL_ScrollX(Surface,DifX);
SDL_ScrollY(Surface,DifY);


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
    //like: (polyPts,num)
    SDL_RenderDrawLines(renderer,LineData,numLines);

}


function getdrivername:string;
begin
//not really used anymore-this isnt dos

   getdrivername:='Internal.SDL'; //be a smartASS
end;

//yes, hackish but it works
Procedure DetectGraph(WantsFullScreen:boolean);
//likely you want FS...
begin

    if ForceSWSurface=false then begin
		if wantsFullsCreen=true then
		    sdlflags:= (SDL_SWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF or SDL_FULLSCREEN);
		else
			sdlflasgs:= (SDL_SWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF);   
    end;
    if ForceSWSurface=true begin
		if wantsFullsCreen=true then
		    sdlflags:= (SDL_HWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF or SDL_FULLSCREEN);
		else
			sdlflasgs:= (SDL_HWSURFACE or SDLHWPALETTE or SDL_DOUBLEBUF);   
    end;
    //sdl1 hack: use 0,0 to use the current mode size. Try to use bpp appropriate for user request. fake it otherwise.

		test:=SDL_SetVideoMode(0, 0, bpp, sdlflags);
        if test=Nil then begin //we tried an appropriate combo, it didnt work.
			//error out
			if IsConsoleInvoked then
	             LogLn('Error: ', SDL_GetError);
			else SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SetGraph(SDL): Couldnt Set VideoMode','OK',NIL);	   
			closegraph;
	   end;
end; //detectGraph


function getmaxmode:string;
var
   maxmodetest:byte;
begin
  if LIBGRAPHICS_ACTIVE then begin
      maxmodetest:=detectgraph;
      getmaxmode:=GetEnumName(TypeInfo(graphics_modes), Ord(maxmodetest)); //use the number and get the name of it.
  end;
end;


//the only real use for the "driver" setting...
procedure getmoderange(graphdriver:integer);

begin

	if not graphdriver = ord(detect) then begin
  		if (graphdriver = ord(VGA)) then begin
    		  lomode := ord(VGAMed);
    		  himode := ord(m1024x768xMil);
  		end else

  		if (graphdriver= ord(VESA)) then begin
    		 lomode := ord(mCGA);
    		 himode := ord(m1920x1080xMil);
  		end else

		if (graphdriver = ord(mCGA)) then begin
    	  lomode := ord(mCGA);
    	  himode := ord(mCGA);
  		end;

	end else begin
        if (graphdriver=ord(DETECT)) then begin
            himode:=GetgraphMode; //what did we set?? 	   	
	    	lomode:= ord(mCGA); //no less than this.
		end else begin
			if IsConsoleInvoked then
				LogLn('Unknown graphdriver setting.');
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

---this is untested and unverified logic as of Nov 2019---

procedure SetViewPort(Rect:PSDL_Rect);

var
    LastRect:PSDL_Rect;
    ScreenData:Pointer;
    infosurface,savesurface:PSDL_Surface;

begin
//freeze movement
   if windownumber=8 then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to create too many viewports.','OK',NIL);
      if IsConsoleInvoked then
        LogLn('Attempt to create too many viewports.');
      exit;
   end;
   //get viewport size and put into LastRect
   
   LastRect^.x:= textrec[windownumber]^.x;  
   LastRect^.y:= textrec[windownumber]^.y;  
   LastRect^.w:= textrec[windownumber]^.w;  
   LastRect^.h:= textrec[windownumber]^.h;  

   
  //pixels and info abt the pixels. from the renderer-to a surface, then throw it back into a texture
//  ScreenData:=GetPixels(LastRect);
   ViewPorts[windownumber-1]:= := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface^.w * infoSurface^.format^.BytesPerPixel),longword( infoSurface^.format));

  if (saveSurface = NiL) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt create SDL_Surface from renderer pixel data','OK',NIL);
      LogLn('Couldnt create SDL_Surface from renderer pixel data. ');
      LogLn(SDL_GetError);
      exit;
                    
  end;

   //current co ords = last, add one.
   inc(windownumber);

   CurrentViewport:=Rect;
   //if: clearviewport(_fgcolor);
  
   //"Clipping" is a joke- we always clip.
   //The trick is: do we zoom out? In Most cases- NO. We zoom IN.

end;


procedure RemoveViewPort(windownumber:byte);
//the opposite of above...
//set the last window coords..(we might be trying to write to them)
//and redraw the prior window as if the new one was not there(not an easy task).
var
  ThisRect,LastRect:PSDL_Rect;

begin

   if windownumber=0 then begin
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to remove non-existant viewport.','UH oh.',NIL);
  
    if IsConsoleInvoked then
        LogLn('Attempt to remove non-existant viewport.');
    exit; 
   end;
   if windownumber > 1 then begin
  		ThisRect^.X:=TexBounds[windownumber]^.X;
		ThisRect^.Y:=TexBounds[windownumber]^.Y;
	    ThisRect^.W:=TexBounds[windownumber]^.W;
	    ThisRect^.H:=TexBounds[windownumber]^.H;

        //get co ords of the previous

        LastRect^.X:=TexBounds[windownumber-1]^.X;
 	    LastRect^.Y:=TexBounds[windownumber-1]^.Y;
 	    LastRect^.W:=TexBounds[windownumber-1]^.W;
	    LastRect^.H:=TexBounds[windownumber-1]^.H;
   
       //remove the viewport by removing the texture and redrawing the screen.
       //the problem with textures is that they are part of a one-way road. ARG!

        Surfaces[windownumber]:=nil; //Destroy the current Texture

        //blit the old data back
        SDL_Blit(MainSurface,Surfaces[windownumber-1],Nil,LastRect);
        SDL_Flip;

		ThisRect:=LastRect;
        dec(windownumber);
//unfreeze movement
        exit;
   end; 
   //else: last window remaining
   Surfaces[1]:=nil;
   ThisRect:=LastRect;

  
   SDL_Blit(MainSurface,Surfacess[0],nil,LastRect);
   SDL_Flip; //and update back to the old screen before the viewports came here.

   LastRect^.X:=0;
   LastRect^.Y:=0;
   LastRect^.W:=MaxX;
   LastRect^.H:=MaxY;
   
   dec(windownumber);

   //unfreeze movement
end;
}

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

{
procedure LoadImage(filename:PChar; Rect:PSDL_Rect);
//Rect: I need to know what size you want the imported image, and where you want it.

var
  tex:PSDL_Texture;

begin

    tex:= NiL;
    Tex:=IMG_LoadTexture(renderer,filename);
    SDL_RenderCopy(renderer, tex, Nil, rect); //PutImage at x,y but only for size of WxH
end;

procedure LoadImageStretched(filename:PChar);

var
  tex:PSDL_Texture;

begin

    tex:= NiL;
    Tex:=IMG_LoadTexture(renderer,filename); 
    SDL_RenderCopy(renderer, tex, Nil, Nil); //scales image to output window size(size of undefined Rect)
end;
}

//linestyle is: (patten,thickness) "passed together" (QUE)
//this uses thickness variable only

//These need Blit code written. Im no expert, but "Roto and zoom code" has been written already.
//Sprite blittering and rotation speeds things up even more.

//procedure SpinningDiamonds(Thick:thickness; x,y:word; speed:integer);
//procedure SpinningPixelTris(Thick:thickness; x,y:word; speed:integer);
//procedure SpinningTris(Thick:thickness; x,y:word; speed:integer);
//procedure SpinningRects(Thick:thickness; x,y:word; speed:integer);


procedure Diamonds(Thick:thickness; x,y:word;);
//everyone loves diamonds.... :-P
// Trapeziods, in other words.

begin                

   New(Rect);
   Rect^.x:=x;
   Rect^.y:=y;
   case (Thick) of
       NormalWidth: begin
             Rect^.w:=2;
			 Rect^.h:=2;   
       end;
       ThickWidth: begin  
             Rect^.w:=4;
			 Rect^.h:=4;   
       end;
       SuperThickWidth: begin
             Rect^.w:=6;
			 Rect^.h:=6;   
       end;
       UltimateThickWidth: begin  
             Rect^.w:=8;
			 Rect^.h:=8;   
       end;
   end;
   SDL_FillRect(MainSurface, rect,__fgcolor);

   Dispose(Rect);
   //now restore x and y
   case Thick of
		NormalWidth:begin
			x:=x+2;
			y:=y+2;   		
		end;
		ThickWidth:begin
			x:=x+4;
			y:=y+4;  
		end;
		SuperThickWidth: begin
            x:=x+6;
			y:=y+6;  
       end;
       UltimateThickWidth: begin  
            x:=x+8;
			y:=y+8;  
       end;
   end;
end;


procedure PlotPixelWithNeighbors(Thick:thickness; x,y:word;);
//this makes the bigger Pixels
 
// (in other words "blocky bullet holes"...)  
// EXPERT topic: smoothing reduces jagged edges

begin                
   //more efficient to render a Rect.

   New(Rect);
   Rect^.x:=x;
   Rect^.y:=y;
   case (Thick) of
       NormalWidth: begin
             Rect^.w:=2;
			 Rect^.h:=2;   
       end;
       ThickWidth: begin  
             Rect^.w:=4;
			 Rect^.h:=4;   
       end;
       SuperThickWidth: begin
             Rect^.w:=6;
			 Rect^.h:=6;   
       end;
       UltimateThickWidth: begin  
             Rect^.w:=8;
			 Rect^.h:=8;   
       end;
   end;
   SDL_FillRect(MainSurface, rect,__fgcolor);

   Dispose(Rect);
   //now restore x and y
   case Thick of
		NormalWidth:begin
			x:=x+2;
			y:=y+2;   		
		end;
		ThickWidth:begin
			x:=x+4;
			y:=y+4;  
		end;
		SuperThickWidth: begin
            x:=x+6;
			y:=y+6;  
       end;
       UltimateThickWidth: begin  
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

  filename:='screenshot'+intTostr(screenshots)+'.bmp';
  //screenshotXXXXX.BMP

  SDL_SaveBMP(MainSurface, filename);
  SDL_FreeSurface(saveSurface);
  saveSurface := NiL;
  inc(Screenshots);
end;


//note this function is "slow ASS". It uses recursive looped reads.


function GetPixels(Rect:PSDL_Rect):pointer;
//this does NOT return a single pixel by default and is written intentionally that way.

var
  v,k,j:byte;
  pitch:integer;
  pixels:array of PSDL_Color;
  AttemptRead:integer;

begin
   if ((Rect^.w=1) or (Rect^.h=1)) then begin    
     if IsConsoleInvoked then begin       
        LogLn('USE GetPixel. This routine FETCHES MORE THAN ONE');
     end;  
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'USE GetPixel. This routine FETCHES MORE THAN ONE','OK',NIL);
     exit;
   end;

    // The GetPixel loop- take into account viewport coords, do not assume fullscreen Mainsurface ops.
    j:=0;
	k:=0;
    v:=0;
	repeat
	    repeat
            Pixels[v]:=GetPixel(Viewport[currentviewport]^.x,Viewport[currentviewport]^.y);
            inc(v);
	    until j= Viewport[currentviewport]^.x;
	 	j:=0;
	    inc(k);
	until k=Viewport[currentviewport]^.y;
   
   GetPixels:=pixels;
end;



begin  //PascalMain()

StartLogging;

//On unices we dont care if LCL is used or not- were still a "console app", even if not in a VTerm.
//UI apps just dont have a "console output window". LOG ANYWAY.

{$IFDEF unix}
  //GetEnv ..an egg by another name...
  if (GetEnvironmentVariable('DISPLAY') = '') then begin //X11 is not active
	NeedFrameBuffer:=true;
    IsVTerm:=true; //This is the proper way to check, dont assume based on "flawed Unix logic".
  end;
{$ENDIF}

  
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
			-DirectFB is.
  
  This is the case of "Nuking it" or "not thinking at all" when writing code- instead of planning for "as many
  as possible" scenarios.
  
}

{$IFDEF LCL}
        {$ifndef debug} //Lazarus default is to debug while running
			{$IFDEF mswindows}
				IsVTerm:=false; //ui app- NO CONSOLE AVAILABLE
			{$ENDIF}        
        {$endif}
{$ENDIF}

   screenshots:=00000000;
   windownumber:=0;

end.



