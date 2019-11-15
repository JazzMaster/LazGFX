Unit LazGFX; 
{$mode objfpc}

//Range and overflow checks =ON
{$Q+}
{$R+}

{$IFDEF debug}
//memory tracing, along with heap.
	{$S+}
{$ENDIF}


{
A "fully creative rewrite" of the "Borland Graphic Interface" in SDLv1 (c) 2017-18 (and beyond) Richard Jasmin
-with the assistance of others.

SDL unifies and simplifies programming for DirectX(D2D), Quartz2D, and X11.
Therefore- it become easier to write code for these platforms.
However- the syntax is unfamiliar to most to be of use. Hence the "BGI port".

The only SDL unit needed is SDL Pascal unit I have provided-
smaller platforms wil need to 'break out the headers'. (FPC on modern systems is not affected by this.)

(I am writing this on AMD64 Quad and OCTO core system >2.5Ghz with gigabytes of RAM and VRAM at my disposal)


GDI/GDI+ and core X11 Primitive ops(prior to XOrg merge) are excrutiatingly slow.
(Please write code for DX7+ or a newer X11).

Byte/SmallInt are 8bit references
Word/Integer are 16bit references
Longword are 32bit references
QuadWords are 64bit references

**Code Intentionally uses forced 32bit references.**

Too many shortcuts are taken with most BGI graphics units.
This is the 'most complete' version that I have found. As far as compatibility- I am porting some C here- to fix this.
A lot was added.

--Jazz


Apache/Mozilla licensed(FREED).

Sections from FPC unit are from Jonas Maebe-and other where noted.

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

--

This unit is for compatiblility -FPC can pull in this unit - if done correctly- bypassing 
FPCs ANCIENT libSVGA unit version of libGraph and "compensating for using X11" these days.

That old FPC libSVGA unit "may be useful" once we get Framebuffer or KMS functional-
either as a fallback- or for RasPi.


Commercial software is allowed- I would like the backported changes and modifications.
I dont care what you use the source code for- just give me credit.

You must cite original authors and sub authors, as appropriate(standard attribution rules).
DO NOT CLAIM THIS CODE AS YOUR OWN and you MAY NOT remove this notice.

Although designed "for games programming"..the integration involved by the USE, ABUSE, and REUSE-
of SDL and X11Core/WinAPI highlights so many OS internals its not even funny.

Anyone serious enough to work with SDL on an ongoing basis- is doing some SERIOUS development,
moreso if they are "expanding the reach" of SDL using a language "without much love" such as FreePascal.

LCL/Lazarus references will be removed- Lazarus is NOT compatible with the Window/Graphical Context hooks provided here.
IT IS COMPATIBLE with 3D OpenGL ones. Until Windows/MacOSX/X11 hooks can be pulled thru correctly- this cannot be fixed.
SDL provides no way of doing this correctly in a 'sensible PASCAL manner'.

-If you figure out how to do this on modern hardware, with recent code- Im all ears.


Its easier to fix my code than patch the SDL headers, which appear flawed at the moment. Im working on fixing this.
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


without GUI/Lazarus as a Console Application
(when running you may get crash help-full debugging support)

Project-> Console App or
Project-> Program

Set Run Parameters:
"Use Launcher" -to enable runwait.sh and console output (otherwise you might not see it)

--

fp:

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
(shoot self in foot twice, Laz DEVS!!)

---

We will have some limits:

        Namely VRAM
        Because if its not onscreen, its in RAM or funneled thru the CPU somewhere...
        You might have 12Gb fre of RAM, but not 256mb of VRAM. 

        Older systems could have as less as 16MB VRAM, most notebooks within 5-10 years should have 256.
        The only way to work with these systems is to clear EVERYTHING REPEATEDLY or use CPU and RAM to your advantage.
        (There is a way..)

Many dont understand SDLv1 use- then get thrown and force fed SDL2.x and GPU_ opcodes.

How to write good games:
        -learn to thread and use callback interrupts-

SDL1.2 (learn to page flip)
SDL2.0 (renderer and "render to textures as surfaces")

OGL (straight--has rendering issues)

uOS (sound)
Synapse/Synaser (net)

You need to know:

        event-driven input and rendering loops (forget the console and ReadKEY)
         

---

There is a lot of plugins for SDL/SDLv2 and that initially confused the heck out of me.
Most of those were ported to FPC by JEDI team. I have cleaned that mess up, except for depends.


SDL_Image is JPEG, TIF, PNG support (BMP is in SDL(core))
However, THE MAIN THING is that we can use them as soon as the "INTERFACE" code is written(HERE).

Nexiuz and Postal use SDL.
Postal2 uses unreal engine.
Hedgewars uses SDL v1.2, iirc...


Circle/ellippse:
The difference between an ellipse and a circle is that "an ellipse is corrected for the aspect ratio".


    get tris and circles and elippses working
    aspect stretching??? (SDL can handle some of this internally)

FONTS:

    I have some base fonts- most likely your OS has some - but not standardized ones.

    We do NOT use bitmapped fonts- we use TTF.
    In many ways this is better.


Lazarus TCanvas unit(s) (graph, graphics) are severely lacking. Most DO NOT utilize openGl.
They utilize X11CorePrimitives instead. 


So you might as well be using THIS unit--since we already use:

D2D(directX)
Quartz2D
and X11Coreprimitives

The FPC devs assume you can understand OpenGL right away...thats bad.
I dont agree w "basic drawing primitives" being an "objectified mess".


HELP:

SDL and JEDI have been poorly documented.

1- FPC code seems doggishly slow to update when bugs are discovered. Meanwhile SDL chugs along in C.
(Then we have to BACKPORT the changes again.)

2- The "pascal/lazarus graphics unit" changes as per the HOST OS. 
Usually not a problem unless doing kernel development -but its an objective Pascal nightmare.
(too many functions are wrapped). 

-SDL fixes this for us. 


uOS support adds "wave, mp3, etc" sounds instead of PC speaker beeping
(see the 'beep' command and enable the module -its blacklisted-on Linux) 
and adds mouse and joystick, even haptic/VR feedback support.

SDL_Audio "licensing issues" (Fraunhoffer/MP3 is a cash cow) -as with qb64, which also uses SDL- wreak havoc on us. 
(Yes- I Have a merge tree of qb64 that builds, just ask...)

The workaround is to use VLC/FFMpeg or other libraries. 

Linear Framebuffer is virtually required(OS Drivers) and bank switching has had some isues in DOS.
A lot of code back in the day(20 years ago) was written to use "banks" due to color or VRAM limitations.
The dos mouse was broken due to bank switching (at some point). 

The way around it was to not need bank switching-by using a LFB. 


CGA and EGA have been properly "emulated" by palettes.
Your standard "Text mode hack" (16 colors) is EGA palette emulation.
This was only possible on CGA screen sby hacking the text mode ASCII character set.(CP850)


**THIS CODE is written for 32 AND 64 bit systems.**

Apparently the SDL/JEDI never got the 64-bit bugfix(GitHub, people...).
(A longword is not a longword- when its a QWord...)

USER FIXME: Error 216 usually indicates BOUNDS errors(memory alloc and not FREE--a "memory leak")
USER FIXME: SDL and OpenGL can fire errors with no debugging info and leave you clueless as 
    to where to start debugging.(c units have not been compiled w debug support)

----

Colors are bit banged to hell and back.
32bit RGBA is assumed -and faked- in modes less than 15bits.
15 and 16bit color uses word storage(16bit aligned for speed)

24 bit is an RGB tuple -padded to RGBA. A-bit is ignored, as with 15bit color(555).
32 bit is the only true true color mode and true rgba mode.

USER FIXME: SDL is limited to 32bits. Opengl is NOT. "Mind your bytes"

RGB/RGBA Color data is as accurate as possible using data from the net.


Downsizing bits:

-you cant put whats not there- you can only "dither down" or "fake it" by using "odd patterns".
what this is -is tricking your eyes with "almost similar pixel data".

most use down conversion routines to guess at lower depth approx colors.


What this means is that for non-equal modes that are not "byte aligned" or "full bytes" (above 256 colors) 
you have to do color conversion or the colors will be "off".

Futher- forcing the video driver to accept non-aligned data slows things down-
        in case of opengl- it CAN crash things.

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



I havent added in Android or MacOS modes yet.
You cant support "portable Apple devices". Apple forbids it w FPC.

---

**CORE EFFICIENCY FAILURE**:

Pixel rendering (the old school methods)

We have to "lock pixels" to work with them, then "unlock pixels" and "pageFlip". 

Our ops are restricted, even yet to "pixels" and not groups of them.
TandL is a "pixel-based operation".

**There may be bugs in my math. I havent checked yet.**


MessageBox:

With Working messageBox(es) we dont need the console.

InGame_MsgBox() routines (OVERLAYS like what Skyrim uses) still needs to be implemented.
FurtherMore, they need to match your given palette scheme. (I can only do so much)

GVision, routines can now be used where they could not before.
GVision requires Graphics modes(provided here) and TVision routines be present(or similar ones written).

FPC team is refusing to fix TVision bugs. 

        This is wrong.

That is like sayingFPC DEVS dont support Win16(FPC DOES NOW) apps and programming.


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


to animate- screen savers, etc...you need to (page)flip/rendercopy and slow down rendering timers.
(trust me, this works-Ive written some soon-to-be-here demos)


bounds:
   cap pixels at viewport
   off screen..gets ignored but should throw an error- we should know screen bounds.
   (zoom in or out of a bitmap- but dont exceed bounds.) 


on 2d games...you are effectively preloading the fore and aft areas on the 'level' like mario.
there are ways to reduce flickering -control renderClear and Flip. 

the damn thing should be loaded in memory anyhoo..
what.. 64K for a level? cmon....ITS ZOOMED IN....

  Move (texture,memory,sizeof(texture));

or Better yet:

  Move (texture,memory,sizeof(GraphicsBuffer));


NOTE:

SDL bug:
    "You must render in the same (mainloop) that handles input." (NOPE)
EXPORT THE GRAPHICS CONTEXT and youll be FINER than A STEEL STRING GUITAR.


SDL routines require more than just dropping a routine in here- 
    you have to know how the original routine wants the data-
        get it in the right format
        call the routine
        and if needed-catch errors.

The biggest problem with SDL is "the bloody syntax".

SDL is not SIMPLE. 
The BGI was SIMPLE.

"SemiDirect MultiMedia OverLayer" - should be the unit name.

 --Jazz (comments -and code- by me unless otherwise noted)

}


{$IFDEF DARWIN} //OSX
    {$modeswitch objectivec1} //version 2 is above OSX 10.5- use with SDL2. This excludes PPC arch.
    {$linklib gcc}
    {$linklib SDLmain}
{$ENDIF}

uses

//Threads requires baseunix unit
//cthreads has to be the first unit in this case-it so happens to support the C version.

{$IFDEF UNIX} //if coming from dos- sysutils is the equivalent unit.
      cthreads,cmem,sysUtils,baseunix,
    
{$ENDIF}

    ctypes,classes,

//ctypes: cint,uint,PTRUint,PTR-USINT,sint...etc.

// A hackish trick...test if LCL unit(s) are loaded or linked in, then adjust "console" logging...

{$IFDEF MSWINDOWS} //as if theres a non-MS WINDOWS?
    Windows,MMsystem, //audio subsystem

{$ENDIF}

{$IFDEF LCL}
	{$IFDEF LCLGTK2}
		gtk2,
	{$ENDIF}

	{$IFDEF LCLQT}
		qtwidgets,
	{$ENDIF}

	  //works on Linux+Qt but not windows??? I have WINE and a VM- lets figure it out.
      LazUtils,  Interfaces, Dialogs, LCLType,Forms,Controls, 
    {$IFDEF MSWINDOWS}
       //we will check if this is set later.
      {$DEFINE NOCONSOLE }
    {$ENDIF}

{$ENDIF}


//its possible to have a Windows "console app" thru FPC,
//just not thru Lazarus. Debugging thru console environment, however, IS supported on windows.

{$IFNDEF NOCONSOLE}
    crt,crtstuff,
{$ENDIF}

//if you build with the LCL --you get rid of the ugly ass SDL dialogs

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


//FPC generic units(OS independent)
  SDL,strings,typinfo,logger

//uos

//Logger was the unit "throwing -EIO- errors" all over...FNF- I reset instead of reWrote...


//stipple is what dashes lines are called


//lets be fair to the compiler..
{$IFDEF debug} ,heaptrc {$ENDIF} 

//Carbon is OS 8 and 9 to OSX API
{$IFDEF macos} 
  ,MacOSAll
{$ENDIF}

{$IFDEF Darwin}
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

type

	graphics_modes=(

mCGA, 
VGAMed,vgaMedx256,
vgaHi,VGAHix256,VGAHix32k,VGAHix64k,
m800x600x16,m800x600x256,m800x600x32k,m800x800x64k,
m1024x768x256,m1024x768x32k,m1024x768x64k,m1024x768xMil,
m1280x720x256,m1280x720x32k,m1280x720x64k,m1280x720xMil,
m1280x1024x256,m1280x1024x32k,m1280x1024x64k,m1280x1024xMil,
m1366x768x256,m1366x768x32k,m1366x768x64k,m1366x768xMil,
m1920x1080x256,m1920x1080x32k,m1920x1080x64k,m1920x1080xMil);

//data is in the main unit Init routines.

Tmode=record
//non-negative and some values are yuuge
	ModeNumber:byte;
  	ModeName:string;
 	MaxColors:DWord; //LongWord??
    bpp:byte;
  	MaxX:Word;
    MaxY:Word;
	XAspect:byte;
	YAspect:byte;
	AspectRatio:real; //things are computed from this somehow...
end; //record




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


//when drawing a line- this is supposed to dictate if the line is dashed or not
//AND how thick it is.

  LineStyle=(solid,dotted,center,dashed);
  Thickness=(normalwidth=1,thickwidth=3,superthickwidth=5,ultimateThickwidth=7);

//C style syntax-used to be a function, isnt anymore.
  grErrorType=(OK,NoGrMem,NoFontMem,FontNotFound,InvalidMode,GenError,IoError,InvalidFontType);


{
This is a "buffer copy" of all written string to the screen.
As long as we have this- we can print, and we can copy screen contents.

Another "hackish trick":


(allow for space between 'font chars' )
-Now take one char off both axis.

MaxFontChars:=(Screen/viewportwidth / FontWidth *1.5)  - FontWidth;
MaxFontLines:=(Screen/viewportHeight / FontHeight *1.5) - FontHeight;

ScreenTextBuffer: array [0..MaxFontChars,0..MaxFontLines]of char;
ScreenLineBuffer: array [0..MaxFontChars]of char;

MOD:
-OutText writes one char here until full- goes onto next line.
-OutTextLine just writes the whole array

-array is copied into the buffer- adjusted if scrolling is enabled- otherwise reset -when end of screen reached.
If we didnt reset- our charPtr would be off of the screen- with no way to see anything else written.

(This was the old DOS way)

-All of this- of Course- is also maintained with the "TextSurface".
GL just has no clue how to "draw the fonts". 


Think of Text like a "Transparent Label" or "clear sticker".

}



  TArcCoordsType = record
      x,y : word;
      xstart,ystart : word;
      xend,yend : word;
  end;

//for MoveRel(MoveRelative)
  Twhere=record
     x,y:word;
  end;

 //   PTTF_Font=^TTF_Font;
    //TTF_Font

//A Ton of code enforces a viewport mandate- that even sans viewports- the screen is one.
//This is better used with screen shrinking effects such as status bars, etc.


//graphdriver is not really used half the time anyways..most people probe.
//these are range checked numbers internally.

	graphics_driver=(DETECT, CGA, VGA,VESA); //cga,vga,vesa,hdmi,hdmi1.2


//This is a 8x8 (or 8x12) Font pattern (in HEX) according to the BGI sources
//(A BLITTER BITMAP in SDL)

//X11- at least has this already implemented, SDL2_BGI mimicks those routines.

   FillSettingsType = (clear,lines,slashes,THslashes,THBackSlashes,BackSlashes,SMBoxes,rhombus,wall,widePTs,DensePTS);

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


var
  thick:thickness;
  bpp:integer; //byte
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

I think Im going to leave this as an excercise to the user rather than dictate archane methods.

SDL Events fire after EVENT variable is assigned a pointer and either polling or event checking is enabled.
NOT UTIL- so we should be "safe" to not check input until the user program calling us needs it.

SDL will close the app and at the window managers request(I hope) without direct code intervention.
But- its unsafe to assume things.

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
}

const
   {$IFDEF mswindows} //I have my Own implementaion of this- works for win32 apps.
        IsConsole:boolean;
   {$ENDIF}
   //Analog joystick dead zone 
   JOYSTICK_DEAD_ZONE = 8000;
   //joysticks seem to be slow to respond in some games....

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
    X,Y:integer;
    _grResult:grErrortype;
    
    gGameController:PSDL_Joystick;

    MainSurface,FontSurface : PSDL_Surface; //TnL mostly at this point, and for hacks

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

}

    font_size:integer; 
    style:byte; //BOLD,ITALIC,etc.
    outline:longint;
    grErrorStrings: array [0 .. 7] of string; //or typinfo value thereof..
    AspectRatio:real; //computed from (AspectX mod AspectY)

{
older modes are not used, so y keep them in the list??
 (M)CGA because well..I think you KNOW WHY Im being called here....

 mode13h(320x200x16 or x256) : EXTREMELY COMMON GAME PROGRAMMING
 (we use the more square pixel mode)

Atari modes, etc. were removed. (double the res and pixelSize and we will talk)

}

  MaxColors:LongWord; //positive only!!
  ClipPixels: Boolean=true; //always clip, never an option "not to".

  WantsJoyPad:boolean;
  screenshots:longint;

//CDROM access is very limited.

//Used mostly for Audio CDs and RedBook Audio Games.
//This said- I have some emulators(in C) that access the Linux CDROM device....
//the code is old (Red Hat v7? vs RHEL v7) but builds "with a few hacks".

//such games have "CDROM Modeswitch delays" in accessing data while playing audio tracks(game skippage).

//Descent II(PC) and SonicCD(PC and SEGA CD Emu) come to mind.
//you would want ogg or mp3 or wav files these days- on some sort of storage medium.

  NonPalette, TrueColor,WantsAudioToo,WantsCDROM:boolean;	
  Blink:boolean;
  CenterText:boolean=false; //see crtstuff unit for the trick
  
  MaxX,MaxY:word;

  _fgcolor, _bgcolor:DWord;	//this is modified due to hi and true color support.
  //do not use old school index numbers. FETCH the index based DWord instead.  
  
  flip_timer_ms:Longint; //Time in MS between Render calls. (longint orlongword) -in C.

  //ideally ignore this and use GetTicks estimates with "Deltas"
  //this is bare minimum support.

  EventThread:Longint; //fpc uses Longint
  EventThreadReturnValue:LongInt; //Threads are supposed to return a error code
	
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

  r,g,b,a:PUInt8; //^Byte

  //TextureFormat
  format:LongInt;

//this pre-definition shit is a ~PITA~

//our data may differ from SDLs.
type 
//the lists..

//wants graphics_modes??

  Pmodelist=^TmodeList;
  TmodeList=array [0 .. 31] of TMode;

//single mode
  Pmode=^TMode;

var

//modelist hacking

//pointers
//single modes

     modePointer:Pmode;

//list
    modeListpointer:PmodeList;

//arrays
	ModeArray:TmodeList;

//forward declared defines

function FetchModeList:Tmodelist;

procedure RoughSteinbergDither(filename,filename2:string);


//surfaceOps
procedure lock;
procedure unlock;


//videoCallback


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

//SDL Internal: Update_Rect()

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
{
procedure LoadImage(filename:PChar; Rect:PSDL_Rect);
procedure LoadImageStretched(filename:PChar);
}

procedure PlotPixelWithNeighbors(thick:thickness; x,y:integer);

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

(technically they are rgb(a) colors and have no index anymore)
(so we are in true colors and straight rgb/rgba after this.....)

You need (full) DWords or RGB data for TRUE color modes.
 
'A' bit affects transparency and completes the 'DWord'.
The default setting is to ignore it(FF).
This is what is set.

Most bitmap or blitter or renderer or opengl based code uses some sort of shader(or composite image).
This isnt covered here.

This is for drawing "primitives" on the "surface".....
"advanced primitives" require alpha bit hacking or TRUE COLOR MODE.

-One step at a time.

each 256 SDL_color= r,g,b,a whereas in range of 0-255(FF FF) per color.
for 16 color modes we use 0-16(FF)
 
16 color mode is technically a wonky spec:
	officially this is composed of:  RGB plus I(light/dark) modes.
	in relaity thi is: RGB+CMY whereas W+K are seperate colors- its not quite CMYK nor RGB with two intensities(7 or F)

CMYK isnt really a video color standard normally because pixels are RGB. 
CMYK is for printing. The reason has to do with color gamut and other huffy-puff.
(Learn photography if you want the color headache)
 
CGA modes threw us this curveball:
	4 color , 4 palette hi bit resolution modes that are half ass documented. 
	Theres no need for those modes anymore.(think t shirt half-tones for screen printing)

this is the best I can implement this data given that specs are all over the place- 
	and I want this standardized as much as pssible given that we have very high color setings available
	
VGA/SVGA (Video gate array / super video gate array) and VESA (video electronic standards association) modes are available now.

-of course SDL just simulates all of this (inside a window)

}


//we can use SetColor(SkyBlue3); in 256 modes with this- since we know which color index it is.

//this is only for the default palette of course- if you muck with it.....
// and only up to 256 colors....sorry.

// you have no idea how hard to find and hard to put into code this shit is.


//blink is a "text attribute" ..a feature...
//write..wait.erase..wait..rewrite..just like the blinking cursor..

{

colors: 

	MUST be hard defined to set the pallete prior to drawing.
	No 16 color bitshifting hacks allowed. They dont work anymore.
	    However: you can-
	         adjust the colors by some math
	         render something
	         and restore the colors before rendering again
			 then render something else
}
type


//There IS a way to ge the Names listed here- the magic type info library
//this cuts down on spurious string data and standardizes the palette names a bit also


//iirc - its ...RED,BLUE,GREEN... on the ol 8088s...
// K-R-B-G-C-M-Br Gy-Gyd R-B-G-C-M-Y-W (CGA)
// vs K-B-G-C-R-M-Br Gy-Gyd- B-G-C-R-M-Y-W (wikipedia) 
//the xterm 256 spec reflects this- oddly.


//these names CANNOT overlap. If you want to change them, be my guest.

//you cant fuck up the first 16- Borland INC (RIP) made that "the standard"
TPalette16Names=(BLACK,RED,BLUE,GREEN,CYAN,MAGENTA,BROWN,LTGRAY,GRAY,LTRED,LTBLUE,LTGREEN,LTCYAN,LTMAGENTA,YELLOW,WHITE);
TPalette16NamesGrey=(gBLACK,g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14,gWHITE);

//tfs=two fifty six
//original xterm must have these stored somewhere as string data because parts of "unused holes" and "duplicate data" exist

// I can guarantee you a shade of slateBlue etc.. but not the exact shade.
//(thank you very much whichever programmer fucked this up for us)


TPalette256Names=(

tfsBLACK,
maroon,
tfsGREEN,
olive,
navy,
purple,
teal,
silver,
grey,
tfsRED,
lime,
tfsYELLOW,
tfsBLUE,
fuchsia,
aqua,
tfsWHITE,

Grey0,
NavyBlue,
DarkBlue,
Blue3,
Blue4,
Blue1,

DarkGreen,
DeepSkyBlue4,
DeepSkyBlue6,
DeepSkyBlue7,
DeepSkyBlue3,

DodgerBlue3,
DodgerBlue2,

Green4,
SpringGreen4,


Turquoise4,
DeepSkyBlue5,
DeepSkyBlue2,
DodgerBlue1,
Green3,

SpringGreen3,
DarkCyan,
LightSeaGreen,

DeepSkyBlue1,
DeepSkyBlue8,
Green5,

SpringGreen5,
SpringGreen1,
Cyan3,

DarkTurquoise,
Turquoise2,

Green1,

SpringGreen2,
SpringGreen,
MediumSpringGreen,
Cyan2,
Cyan1,

DarkRed,
DeepPink4,
Purple4,
Purple5,
Purple3,

BlueViolet,
Orange4,
Grey37,
MediumPurple4,
SlateBlue3,
SlateBlue2,
RoyalBlue1,

UnUsedHole5,
DarkSeaGreen5,

PaleTurquoise4,
SteelBlue,
SteelBlue3,

CornflowerBlue,
UnUsedHole3,

DarkSeaGreen4,
CadetBlue,
CadetBlue1,

SkyBlue2,
SteelBlue1,

UnUsedHole4,
PaleGreen3,
SeaGreen3,

Aquamarine3,
MediumTurquoise,

SteelBlue2,
UnUsedHole1,

SeaGreen2,
SeaGreen,
SeaGreen1,

Aquamarine1,
DarkSlateGray2,
DarkRed2,
DeepPink5,

DarkMagenta,
DarkMagenta1,

DarkViolet,
Purple1,
Orange5,
LightPink4,
Plum4,
MediumPurple3,
MediumPurple5,
SlateBlue1,
Yellow4,


Wheat4,
Grey53,
LightSlateGrey,
MediumPurple,
LightSlateBlue,
Yellow5,

DarkOliveGreen3,
DarkSeaGreen,
LightSkyBlue1,
LightSkyBlue2,
SkyBlue3,

UnUsedHole2,

DarkOliveGreen4,
PaleGreen4,
DarkSeaGreen3,
DarkSlateGray3,

SkyBlue1,
UnUsedHole,

LightGreen,
LightGreen1,

PaleGreen1,
Aquamarine2,
DarkSlateGray1,

Red3,
DeepPink6,
MediumVioletRed,
Magenta3,
DarkViolet2, 
Purple2,
DarkOrange1,
IndianRed,

HotPink3,
MediumOrchid3,
MediumOrchid,
MediumPurple2,
DarkGoldenrod,

LightSalmon3,
RosyBrown,
Grey63,
MediumPurple6,
MediumPurple1,
Gold3,
DarkKhaki,
NavajoWhite3,
Grey69,
LightSteelBlue3,
LightSteelBlue,

Yellow3,
DarkOliveGreen5,
DarkSeaGreen6,
DarkSeaGreen2,

LightCyan3,
LightSkyBlue3,
GreenYellow,

DarkOliveGreen2,
PaleGreen2,
DarkSeaGreen7,
DarkSeaGreen1,

PaleTurquoise1,
Red4,
DeepPink3,
DeepPink7,
Magenta5,
Magenta6,
Magenta2,
DarkOrange2,
IndianRed1,
HotPink4,
HotPink2,
Orchid,
MediumOrchid1,
Orange1,
LightSalmon2,
LightPink1,
Pink1,

Plum2,
Violet,
Gold2,
LightGoldenrod4,
Tan,
MistyRose3,
Thistle3,

Plum3,
Yellow7,
Khaki3,
LightGoldenrod2,
LightYellow3,
Grey84,
LightSteelBlue1,
Yellow2,

DarkOliveGreen,
DarkOliveGreen1,
DarkSeaGreen8,
Honeydew2,
LightCyan1,
Red1,
DeepPink2,
DeepPink,
DeepPink1,
Magenta4,
Magenta1,
OrangeRed,
IndianRed2,
IndianRed3,
HotPink,
HotPink1,
MediumOrchid2,
DarkOrange,
Salmon1,

LightCoral,
PaleVioletRed,

Orchid2,
Orchid1,
Orange,
SandyBrown,
LightSalmon,
LightPink,

Pink,
Plum,
Gold,
LightGoldenrod5,
LightGoldenrod3,
NavajoWhite1,
MistyRose1,
Thistle1,
Yellow1,
LightGoldenrod1,
Khaki1,
Wheat1,
Cornsilk,

Grey100,
Grey3,
Grey7,
Grey11,
Grey15,
Grey19,
Grey23,
Grey27,
Grey30,
Grey35,

Grey39,
Grey42,
Grey46,
Grey50,
Grey54,
Grey58,
Grey62,
Grey66,
Grey70,
Grey74,

Grey78,
Grey82,
Grey85,
Grey89,
Grey93);


//this one is HELL!
TPalette256NamesGrey=(

tfsGBlack,
tfsG1,
tfsG2,
tfsG3,
tfsG4,
tfsG5,
tfsG6,
tfsG7,
tfsG8,
tfsG9,
tfsG10,

tfsG11,
tfsG12,
tfsG13,
tfsG14,
tfsG15,

tfsG16,
tfsG17,
tfsG18,
tfsG19,
tfsG20,

tfsG21,
tfsG22,
tfsG23,
tfsG24,
tfsG25,
tfsG26,
tfsG27,
tfsG28,
tfsG29,
tfsG30,

tfsG31,
tfsG32,
tfsG33,
tfsG34,
tfsG35,
tfsG36,
tfsG37,
tfsG38,
tfsG39,
tfsG40,

tfsG41,
tfsG42,
tfsG43,
tfsG44,
tfsG45,
tfsG46,
tfsG47,
tfsG48,
tfsG49,
tfsG50,

tfsG51,
tfsG52,
tfsG53,
tfsG54,
tfsG55,

tfsG56,
tfsG57,
tfsG58,
tfsG59,
tfsG60,
tfsG61,
tfsG62,
tfsG63,
tfsG64,
tfsG65,

tfsG66,
tfsG67,
tfsG68,
tfsG69,
tfsG70,
tfsG71,
tfsG72,
tfsG73,
tfsG74,
tfsG75, 

tfsG76,
tfsG77,
tfsG78, 

tfsG79,
tfsG80,
tfsG81,
tfsG82,
tfsG83,
tfsG84,
tfsG85,
tfsG86,
tfsG87,
tfsG88, 

tfsG89,
tfsG90,
tfsG91,
tfsG92,
tfsG93,
tfsG94,
tfsG95,
tfsG96,
tfsG97,
tfsG98, 

tfsG99,
tfsG100,
tfsG101,
tfsG102,
tfsG103,
tfsG104,
tfsG105,
tfsG106,
tfsG107,
tfsG108, 

tfsG109,
tfsG110,
tfsG111,
tfsG112,
tfsG113,
tfsG114,
tfsG115,
tfsG116,
tfsG117,
tfsG118, 

tfsG119,
tfsG120,
tfsG121,
tfsG122,
tfsG123,
tfsG124,
tfsG125,
tfsG126,
tfsG127,
tfsG128, 

tfsG129,
tfsG130,
tfsG131,
tfsG132,
tfsG133,
tfsG134,
tfsG135,
tfsG136,
tfsG137,
tfsG138, 

tfsG139,
tfsG140,
tfsG141,
tfsG142,
tfsG143,
tfsG144,
tfsG145,
tfsG146,
tfsG147,
tfsG148, 

tfsG149,
tfsG150,
tfsG151,
tfsG152,
tfsG153,
tfsG154,
tfsG155, 
tfsG156,
tfsG157,
tfsG158, 

tfsG159,
tfsG160,
tfsG161,
tfsG162,
tfsG163,
tfsG164,
tfsG165,
tfsG166,
tfsG167,
tfsG168, 

tfsG169,
tfsG170,
tfsG171,
tfsG172,
tfsG173,
tfsG174,
tfsG175,
tfsG176,
tfsG177,
tfsG178, 

tfsG179,
tfsG180,
tfsG181,
tfsG182,
tfsG183,
tfsG184,
tfsG185,
tfsG186,
tfsG187,
tfsG188, 

tfsG189,
tfsG190,
tfsG191,
tfsG192,
tfsG193,
tfsG194,
tfsG195,
tfsG196,
tfsG197,
tfsG198, 

tfsG199,
tfsG200,
tfsG201,
tfsG202,
tfsG203,
tfsG204,
tfsG205,
tfsG206,
tfsG207,
tfsG208,

tfsG209,
tfsG210,
tfsG211,
tfsG212,
tfsG213,
tfsG214,
tfsG215,
tfsG216,
tfsG217,
tfsG218,

tfsG219,
tfsG220,
tfsG221,
tfsG222,
tfsG223,
tfsG224,
tfsG225,
tfsG226,
tfsG227,
tfsG228,
tfsG229,

tfsG230,
tfsG231,
tfsG232,
tfsG233,
tfsG234,
tfsG235,
tfsG236,
tfsG237,
tfsG238,
tfsG239,
tfsG240,

tfsG241,
tfsG242,
tfsG243,
tfsG244,
tfsG245,
tfsG246,
tfsG247,
tfsG248,
tfsG249,
tfsG250,

tfsG251,
tfsG252,
tfsG253,
tfsG254,
tfsGWhite

);

TRec16=record
  
	colors:PSDL_COLOR; 

{SDL defines this is as:

SDL_Color=record
	r,g,b,a:byte;
	...some other stuff we dont need to use.
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


var
//this one is unorthodox due to the totally destructive downsizing and image degredation needed
//and its "best guess"
  GreyList16:array [0..48] of byte;

  valuelist16: array [0..48] of byte;
  valuelist256: array [0..767] of byte;

  TPalette16: array [0..15] of TRec16;
  TPalette16Grey:array [0..15] of TRec16;

  TPalette256:array [0..255] of TRec256;
  TPalette256Grey:array [0..255] of TRec256;


function GetRGBfromIndex(index:byte):PSDL_Color; 
function GetDWordfromIndex(index:byte):DWord; 
function GetRGBFromHex(input:DWord):PSDL_Color;
function GetRGBAFromHex(input:DWord):PSDL_Color;
function GetIndexFromHex(input:DWord):byte;
function GetColorNameFromHex(input:dword):string;
function GetFgRGB:PSDL_Color;
function GetFgRGBA:PSDL_Color;
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
function GetFgDWordRGBA:DWord;
function GetBgDWordRGB(r,g,b:byte):DWord;
function GetBgDWordRGBA(r,g,b,a:byte):DWord;
procedure invertColors;
function DWordToRGBA(someword:DWord):PSDL_Color;
function RGBAToDWord(somecolor:PSDL_Color):DWord;


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
(SDL_Map and SDL_Get RGB/RGBA are here for this purpose bu tour version is faster-
and doesnt need to use bitdepth checks)

}

//standalone routines. get/putPixel takes care of the conversion for you.
//I like my implementation better.

//16bit from 24bit
function Word16_from_RGB(red,green, blue:byte):Word; //Word=GLShort
//565 16bit color

var
    alpha:byte;
begin
  red:= red shr 3;
  green:= green shr 2;
  blue:=  blue shr 3;
  alpha:=$ff; //ignored
  Word16_from_RGB:= (red shl 11) or (green shl 5) or blue;
end;

//15bit from 24bit
function Word15_from_RGB(red,green, blue:byte):Word; //Word=GLShort
//555[1] 16bit color

var
    alpha:byte;

begin
  red:= red shr 3;
  green:= green shr 3;
  blue:=  blue shr 3;
  alpha:=$ff; //dropped and ignored
  Word15_from_RGB:= (red shl 10) or (green shl 4) or blue;
end;



//SDLv1 code- JEDI team doesnt do it right, and only in SDL2_GFX unit.

//Normally you lock and Unlock Surfaces for batch ops.
//RLE Surfaces (accelerated) MUST be locked prior to pixel ops- and are the only ones-where locking is required.
//REPEATED calls to lock/unlock slow things down



//PtrUInt is a hack- specify length of data to fetch.

//bpp is a global- half this unit is.
function SDL_GetPixel( SrcSurface : PSDL_Surface; x : integer; y : integer ) : PtrUInt; export;

var

i:integer;
index:LongWord;

{$IFDEF Borland } 
//probly needs more borland tweaks to compile- this is a start
    Location:Byte; 
{$ENDIF}

{$IFDEF FPC } 
    Location:^Longword; //location in 1D array
{$ENDIF}

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
            {$IFDEF Borland }
                if (SDL_MUSTLOCK(SrcSurface)) then
                    SDL_UnLockSurface(SrcSurface);

                Result:=Byte(Location);
                exit;
            {$ENDIF}  
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
        24: begin //tuple to longword- leave some bits as ??
//            Location[3]:=$ff;

            if (SDL_BYTEORDER = SDL_BIG_ENDIAN) then
                Result:= (Longword (location[2] shl 24 or location[1] shl 16 or location[0] shl 8 shr 8))
             else           
                Result:=(Longword(location[0] shl 24 or location[1] shl 16 or location[2] shl 8 shr 8));
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
{$IFDEF Borland } 
    Location:Byte; 
{$ENDIF}

{$IFDEF FPC } 
    Location:^LongWord;
{$ENDIF}

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
              {$IFDEF Borland } 
                   Location:=indexcolor; 
              {$ENDIF}
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



//rect size could be 1px for all we know- or the entire rendering surface...
//note this function is "slow ASS"

{
function GEtPixels(Rect:PSDL_Rect):pointer;
var

  pitch:integer;
  AttemptRead:longint;
  pixels:pointer;

begin
   pixels:=Nil;
   pitch:=0;

//case format of...

//format and rect we already can derive
//pixels and pitch will be returned for the given rect in SDL_Color format given by our set definition
//rect is Nil to copy the entire rendering target

//   Getpixels:= SDL_RenderReadPixels( renderer, rect, format, pixels, pitch);

   if AttemptRead=Nil then
     exit;

end;
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


TPalette16GRey.DWords[0]:=$000000ff;
TPalette16GRey.DWords[1]:=$111111ff;
TPalette16GRey.DWords[2]:=$222222ff;
TPalette16GRey.DWords[3]:=$333333ff;
TPalette16GRey.DWords[4]:=$444444ff;
TPalette16GRey.DWords[5]:=$555555ff;
TPalette16GRey.DWords[6]:=$666666ff;
TPalette16GRey.DWords[7]:=$777777ff;
TPalette16GRey.DWords[8]:=$888888ff;
TPalette16GRey.DWords[9]:=$999999ff;
TPalette16GRey.DWords[10]:=$aaaaaaff;
TPalette16GRey.DWords[11]:=$bbbbbbff;
TPalette16GRey.DWords[12]:=$ccccccff;
TPalette16GRey.DWords[13]:=$ddddddff;
TPalette16GRey.DWords[14]:=$eeeeeeff;
TPalette16GRey.DWords[15]:=$ffffffff; 

end;


procedure initPaletteGrey256;

//easy peasy to setup.

var
    i,num:integer;


begin  

//(we dont setup valuelist by hand this time)

   i:=0;
  repeat 
      Tpalette256Grey.colors[num]^.r:=Byte(longint(i));
      Tpalette256Grey.colors[num]^.g:=Byte(longint(i));
      Tpalette256Grey.colors[num]^.b:=Byte(longint(i));
      Tpalette256Grey.colors[num]^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i); //notice the difference <-HERE ..where RGB are the same values
  until i=255;

	
//00-FF as shown above with all value the same in the DWord except the Alpha/transparency Bit, which stays at FF
//FIXME: these need to be corrected 


Tpalette256Grey.DWords[0]:=$000000ff;
//the only gauranteed correct values are 0 and 255 right now.
//this will have to be manually set according to the above math.

Tpalette256Grey.DWords[1]:=$010101ff;
Tpalette256Grey.DWords[2]:=$020202ff;
Tpalette256Grey.DWords[3]:=$030303ff;
Tpalette256Grey.DWords[4]:=$040404ff;
Tpalette256Grey.DWords[5]:=$050505ff;
Tpalette256Grey.DWords[6]:=$060606ff;
Tpalette256Grey.DWords[7]:=$070707ff;
Tpalette256Grey.DWords[8]:=$080808ff;
Tpalette256Grey.DWords[9]:=$090909ff;
Tpalette256Grey.DWords[10]:=$0a0a0aff;
Tpalette256Grey.DWords[11]:=$0b0b0bff;
Tpalette256Grey.DWords[12]:=$0c0c0cff;
Tpalette256Grey.DWords[13]:=$0d0d0dff;
Tpalette256Grey.DWords[14]:=$0e0e0eff;
Tpalette256Grey.DWords[15]:=$0f0f0fff; 

Tpalette256Grey.DWords[16]:=$101010ff;
Tpalette256Grey.DWords[17]:=$111111ff;
Tpalette256Grey.DWords[18]:=$121212ff;
Tpalette256Grey.DWords[19]:=$131313ff;
Tpalette256Grey.DWords[20]:=$141414ff;
Tpalette256Grey.DWords[21]:=$151515ff;
Tpalette256Grey.DWords[22]:=$161616ff;
Tpalette256Grey.DWords[23]:=$171717ff;
Tpalette256Grey.DWords[24]:=$181818ff;
Tpalette256Grey.DWords[25]:=$191919ff;
Tpalette256Grey.DWords[26]:=$1a1a1aff;
Tpalette256Grey.DWords[27]:=$1b1b1bff;
Tpalette256Grey.DWords[28]:=$1c1c1cff;
Tpalette256Grey.DWords[29]:=$1d1d1dff;
Tpalette256Grey.DWords[30]:=$1e1e1eff;
Tpalette256Grey.DWords[31]:=$1f1f1fff;

Tpalette256Grey.DWords[32]:=$202020ff;
Tpalette256Grey.DWords[33]:=$212121ff;
Tpalette256Grey.DWords[34]:=$222222ff;
Tpalette256Grey.DWords[35]:=$232323ff;
Tpalette256Grey.DWords[36]:=$242424ff;
Tpalette256Grey.DWords[37]:=$252525ff;
Tpalette256Grey.DWords[38]:=$262626ff;
Tpalette256Grey.DWords[39]:=$272727ff;
Tpalette256Grey.DWords[40]:=$282828ff;
Tpalette256Grey.DWords[41]:=$292929ff;
Tpalette256Grey.DWords[42]:=$2a2a2aff;
Tpalette256Grey.DWords[43]:=$2b2b2bff;
Tpalette256Grey.DWords[44]:=$2c2c2cff;
Tpalette256Grey.DWords[45]:=$2d2d2dff;
Tpalette256Grey.DWords[46]:=$2e2e2eff;
Tpalette256Grey.DWords[47]:=$2f2f2fff;

Tpalette256Grey.DWords[48]:=$303030ff;
Tpalette256Grey.DWords[49]:=$313131ff;
Tpalette256Grey.DWords[50]:=$323232ff;
Tpalette256Grey.DWords[51]:=$333333ff;
Tpalette256Grey.DWords[52]:=$343434ff;
Tpalette256Grey.DWords[53]:=$353535ff;
Tpalette256Grey.DWords[54]:=$363636ff;
Tpalette256Grey.DWords[55]:=$373737ff;
Tpalette256Grey.DWords[56]:=$383838ff;
Tpalette256Grey.DWords[57]:=$393939ff;
Tpalette256Grey.DWords[58]:=$3a3a3aff;
Tpalette256Grey.DWords[59]:=$3b3b3bff;
Tpalette256Grey.DWords[60]:=$3c3c3cff;
Tpalette256Grey.DWords[61]:=$3d3d3dff;
Tpalette256Grey.DWords[62]:=$3e3e3eff;
Tpalette256Grey.DWords[63]:=$3f3f3fff;

Tpalette256Grey.DWords[64]:=$404040ff;
Tpalette256Grey.DWords[65]:=$414141ff;
Tpalette256Grey.DWords[66]:=$424242ff;
Tpalette256Grey.DWords[67]:=$434343ff;
Tpalette256Grey.DWords[68]:=$444444ff;
Tpalette256Grey.DWords[69]:=$454545ff;
Tpalette256Grey.DWords[70]:=$464646ff;
Tpalette256Grey.DWords[71]:=$474747ff;
Tpalette256Grey.DWords[72]:=$484848ff;
Tpalette256Grey.DWords[73]:=$494949ff;
Tpalette256Grey.DWords[74]:=$4a4a4aff;
Tpalette256Grey.DWords[75]:=$4b4b4bff;
Tpalette256Grey.DWords[76]:=$4c4c4cff;
Tpalette256Grey.DWords[77]:=$4d4d4dff;
Tpalette256Grey.DWords[78]:=$4e4e4eff;
Tpalette256Grey.DWords[79]:=$4f4f4fff;

Tpalette256Grey.DWords[80]:=$505050ff;
Tpalette256Grey.DWords[81]:=$515151ff;
Tpalette256Grey.DWords[82]:=$525252ff;
Tpalette256Grey.DWords[83]:=$535353ff;
Tpalette256Grey.DWords[84]:=$545454ff;
Tpalette256Grey.DWords[85]:=$555555ff;
Tpalette256Grey.DWords[86]:=$565656ff;
Tpalette256Grey.DWords[87]:=$575757ff;
Tpalette256Grey.DWords[88]:=$585858ff;
Tpalette256Grey.DWords[89]:=$595959ff;
Tpalette256Grey.DWords[90]:=$5a5a5aff;
Tpalette256Grey.DWords[91]:=$5b5b5bff;
Tpalette256Grey.DWords[92]:=$5c5c5cff;
Tpalette256Grey.DWords[93]:=$5d5d5dff;
Tpalette256Grey.DWords[94]:=$5e5e5eff;
Tpalette256Grey.DWords[95]:=$5f5f5fff;

Tpalette256Grey.DWords[96]:=$606060ff;
Tpalette256Grey.DWords[97]:=$616161ff;
Tpalette256Grey.DWords[98]:=$626262ff;
Tpalette256Grey.DWords[99]:=$636363ff;
Tpalette256Grey.DWords[100]:=$646464ff;
Tpalette256Grey.DWords[101]:=$656565ff;
Tpalette256Grey.DWords[102]:=$666666ff;
Tpalette256Grey.DWords[103]:=$676767ff;
Tpalette256Grey.DWords[104]:=$686868ff;
Tpalette256Grey.DWords[105]:=$696969ff;
Tpalette256Grey.DWords[106]:=$6a6a6aff;
Tpalette256Grey.DWords[107]:=$6b6b6bff;
Tpalette256Grey.DWords[108]:=$6c6c6cff;
Tpalette256Grey.DWords[109]:=$6d6d6dff;
Tpalette256Grey.DWords[110]:=$6e6e6eff;
Tpalette256Grey.DWords[111]:=$6f6f6fff;

Tpalette256Grey.DWords[112]:=$707070ff;
Tpalette256Grey.DWords[113]:=$717171ff;
Tpalette256Grey.DWords[114]:=$727272ff;
Tpalette256Grey.DWords[115]:=$737373ff;
Tpalette256Grey.DWords[116]:=$747474ff;
Tpalette256Grey.DWords[117]:=$757575ff;
Tpalette256Grey.DWords[118]:=$767676ff;
Tpalette256Grey.DWords[119]:=$777777ff;
Tpalette256Grey.DWords[120]:=$787878ff;
Tpalette256Grey.DWords[121]:=$797979ff;
Tpalette256Grey.DWords[122]:=$7a7a7aff;
Tpalette256Grey.DWords[123]:=$7b7b7bff;
Tpalette256Grey.DWords[124]:=$7c7c7cff;
Tpalette256Grey.DWords[125]:=$7d7d7dff;
Tpalette256Grey.DWords[126]:=$7e7e7eff;
Tpalette256Grey.DWords[127]:=$7f7f7fff;

Tpalette256Grey.DWords[128]:=$808080ff;
Tpalette256Grey.DWords[129]:=$818181ff;
Tpalette256Grey.DWords[130]:=$828282ff;
Tpalette256Grey.DWords[131]:=$838383ff;
Tpalette256Grey.DWords[132]:=$848484ff;
Tpalette256Grey.DWords[133]:=$858585ff;
Tpalette256Grey.DWords[134]:=$868686ff;
Tpalette256Grey.DWords[135]:=$878787ff;
Tpalette256Grey.DWords[136]:=$888888ff;
Tpalette256Grey.DWords[137]:=$898989ff;
Tpalette256Grey.DWords[138]:=$8a8a8aff;
Tpalette256Grey.DWords[139]:=$8b8b8bff;
Tpalette256Grey.DWords[140]:=$8c8c8cff;
Tpalette256Grey.DWords[141]:=$8d8d8dff;
Tpalette256Grey.DWords[142]:=$8e8e8eff;
Tpalette256Grey.DWords[143]:=$8f8f8fff;

Tpalette256Grey.DWords[144]:=$909090ff;
Tpalette256Grey.DWords[145]:=$919191ff;
Tpalette256Grey.DWords[146]:=$929292ff;
Tpalette256Grey.DWords[147]:=$939393ff;
Tpalette256Grey.DWords[148]:=$949494ff;
Tpalette256Grey.DWords[149]:=$959595ff;
Tpalette256Grey.DWords[150]:=$969696ff;
Tpalette256Grey.DWords[151]:=$979797ff;
Tpalette256Grey.DWords[152]:=$989898ff;
Tpalette256Grey.DWords[153]:=$999999ff;
Tpalette256Grey.DWords[154]:=$9a9a9aff;
Tpalette256Grey.DWords[155]:=$9b9b9bff;
Tpalette256Grey.DWords[156]:=$9c9c9cff;
Tpalette256Grey.DWords[157]:=$9d9d9dff;
Tpalette256Grey.DWords[158]:=$9e9e9eff;
TPalette256GRey.DWords[159]:=$9f9f9fff; 

Tpalette256Grey.DWords[160]:=$a0a0a0ff;
Tpalette256Grey.DWords[161]:=$a1a1a1ff;
Tpalette256Grey.DWords[162]:=$a2a2a2ff;
Tpalette256Grey.DWords[163]:=$a3a3a3ff;
Tpalette256Grey.DWords[164]:=$a4a4a4ff;
Tpalette256Grey.DWords[165]:=$a5a5a5ff;
Tpalette256Grey.DWords[166]:=$a6a6a6ff;
Tpalette256Grey.DWords[167]:=$a7a7a7ff;
Tpalette256Grey.DWords[168]:=$a8a8a8ff;
Tpalette256Grey.DWords[169]:=$a9a9a9ff;
Tpalette256Grey.DWords[170]:=$aaaaaaff;
Tpalette256Grey.DWords[171]:=$abababff;
Tpalette256Grey.DWords[172]:=$acacacff;
Tpalette256Grey.DWords[173]:=$adadadff;
Tpalette256Grey.DWords[174]:=$aeaeaeff;
Tpalette256Grey.DWords[175]:=$afafafff;

Tpalette256Grey.DWords[176]:=$b0b0b0ff;
Tpalette256Grey.DWords[177]:=$b1b1b1ff;
Tpalette256Grey.DWords[178]:=$b2b2b2ff;
Tpalette256Grey.DWords[179]:=$b3b3b3ff;
Tpalette256Grey.DWords[180]:=$b4b4b4ff;
Tpalette256Grey.DWords[181]:=$b5b5b5ff;
Tpalette256Grey.DWords[182]:=$b6b6b6ff;
Tpalette256Grey.DWords[183]:=$b7b7b7ff;
Tpalette256Grey.DWords[184]:=$b8b8b8ff;
Tpalette256Grey.DWords[185]:=$b9b9b9ff;
Tpalette256Grey.DWords[186]:=$bababaff;
Tpalette256Grey.DWords[187]:=$bbbbbbff;
Tpalette256Grey.DWords[188]:=$bcbcbcff;
Tpalette256Grey.DWords[189]:=$bdbdbdff;
Tpalette256Grey.DWords[190]:=$bebebeff;
Tpalette256Grey.DWords[191]:=$bfbfbfff;

Tpalette256Grey.DWords[192]:=$c0c0c0ff;
Tpalette256Grey.DWords[193]:=$c1c1c1ff;
Tpalette256Grey.DWords[194]:=$c2c2c2ff;
Tpalette256Grey.DWords[195]:=$c3c3c3ff;
Tpalette256Grey.DWords[196]:=$c4c4c4ff;
Tpalette256Grey.DWords[197]:=$c5c5c5ff;
Tpalette256Grey.DWords[198]:=$c6c6c6ff;
Tpalette256Grey.DWords[199]:=$c7c7c7ff;
Tpalette256Grey.DWords[200]:=$c8c8c8ff;
Tpalette256Grey.DWords[201]:=$c9c9c9ff;
Tpalette256Grey.DWords[202]:=$cacacaff;
Tpalette256Grey.DWords[203]:=$cbcbcbff;
Tpalette256Grey.DWords[204]:=$ccccccff;
Tpalette256Grey.DWords[205]:=$cdcdcdff;
Tpalette256Grey.DWords[206]:=$cececeff;
Tpalette256Grey.DWords[207]:=$cfcfcfff;

Tpalette256Grey.DWords[208]:=$d0d0d0ff;
Tpalette256Grey.DWords[209]:=$d1d1d1ff;
Tpalette256Grey.DWords[210]:=$d2d2d2ff;
Tpalette256Grey.DWords[211]:=$d3d3d3ff;
Tpalette256Grey.DWords[212]:=$d4d4d4ff;
Tpalette256Grey.DWords[213]:=$d5d5d5ff;
Tpalette256Grey.DWords[214]:=$d6d6d6ff;
Tpalette256Grey.DWords[215]:=$d7d7d7ff;
Tpalette256Grey.DWords[216]:=$d8d8d8ff;
Tpalette256Grey.DWords[217]:=$d9d9d9ff;
Tpalette256Grey.DWords[218]:=$dadadaff;
Tpalette256Grey.DWords[219]:=$dbdbdbff;
Tpalette256Grey.DWords[220]:=$dcdcdcff;
Tpalette256Grey.DWords[221]:=$ddddddff;
Tpalette256Grey.DWords[222]:=$dededeff;
Tpalette256Grey.DWords[223]:=$dfdfdfff;

Tpalette256Grey.DWords[224]:=$e0e0e0ff;
Tpalette256Grey.DWords[225]:=$e1e1e1ff;
Tpalette256Grey.DWords[226]:=$e2e2e2ff;
Tpalette256Grey.DWords[227]:=$e3e3e3ff;
Tpalette256Grey.DWords[228]:=$e4e4e4ff;
Tpalette256Grey.DWords[229]:=$e5e5e5ff;
Tpalette256Grey.DWords[230]:=$e6e6e6ff;
Tpalette256Grey.DWords[231]:=$e7e7e7ff;
Tpalette256Grey.DWords[232]:=$e8e8e8ff;
Tpalette256Grey.DWords[233]:=$e9e9e9ff;
Tpalette256Grey.DWords[234]:=$eaeaeaff;
Tpalette256Grey.DWords[235]:=$ebebebff;
Tpalette256Grey.DWords[236]:=$ecececff;
Tpalette256Grey.DWords[237]:=$edededff;
Tpalette256Grey.DWords[238]:=$eeeeeeff;
Tpalette256Grey.DWords[239]:=$efefefff;

Tpalette256Grey.DWords[240]:=$f0f0f0ff;
Tpalette256Grey.DWords[241]:=$f1f1f1ff;
Tpalette256Grey.DWords[242]:=$f2f2f2ff;
Tpalette256Grey.DWords[243]:=$f3f3f3ff;
Tpalette256Grey.DWords[244]:=$f4f4f4ff;
Tpalette256Grey.DWords[245]:=$f5f5f5ff;
Tpalette256Grey.DWords[246]:=$f6f6f6ff;
Tpalette256Grey.DWords[247]:=$f7f7f7ff;
Tpalette256Grey.DWords[248]:=$f8f8f8ff;
Tpalette256Grey.DWords[249]:=$f9f9f9ff;
Tpalette256Grey.DWords[250]:=$fafafaff;
Tpalette256Grey.DWords[251]:=$fbfbfbff;
Tpalette256Grey.DWords[252]:=$fcfcfcff;
Tpalette256Grey.DWords[253]:=$fdfdfdff;
Tpalette256Grey.DWords[254]:=$fefefeff;
Tpalette256Grey.DWords[255]:=$ffffffff;

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
      Tpalette16.colors[num]^.r:=valuelist16[i];
      Tpalette16.colors[num]^.g:=valuelist16[i+1];
      Tpalette16.colors[num]^.b:=valuelist16[i+2];
      Tpalette16.colors[num]^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      //see the remmed out notes below
      inc(i,3);
      inc(num); 
  until num=14;;

//This is the proper way to do it but we have transparencys, not just intensities now.
//mucking w the alpha bit changes opacity levels- we dont want that.
//so we assume we are not going to "muck with it". 
//YOU can if you want.

{
//yes this is hackish- as were the days of (m)CGA...

   i:=0;
   num:=0; 
   for num:=0 to 7 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  end;


  num:=8;//force it
  i:=24;
   for num:=8 to 14 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#7f; 
      inc(i,3);
      inc(num); 
  end;

  Tpalette16.colors[15].r:=valuelist16[45];
  Tpalette16.colors[15].g:=valuelist16[46];
  Tpalette16.colors[15].b:=valuelist16[47];
  Tpalette16.colors[15].a:=#ff; 

Color Sequence:

K HiR HiG HiB HiC HiM HiY HiGR LoGr LoR LoG LoB LoC LoM LoY W
}


TPalette16.DWords[0]:=$000000ff;

TPalette16.DWords[1]:=$ff0000ff;
TPalette16.DWords[2]:=$00ff00ff;
TPalette16.DWords[3]:=$ffff00ff;

TPalette16.DWords[4]:=$0000ffff;
TPalette16.DWords[5]:=$ff00ffff;
TPalette16.DWords[6]:=$ffff55ff;


TPalette16.DWords[7]:=$c0c0c0ff;
TPalette16.DWords[8]:=$7f7f7fff;

TPalette16.DWords[9]:=$7f0000ff;
TPalette16.DWords[10]:=$007f00ff;
TPalette16.DWords[11]:=$7f7f00ff;

TPalette16.DWords[12]:=$00007fff;
TPalette16.DWords[13]:=$7f007fff;
TPalette16.DWords[14]:=$007f7fff;

TPalette16.DWords[15]:=$ffffffff;

end;


procedure Save16Palette(filename:string);

var
	palette16File : File of TRec16;
	i,num            : integer;

Begin
	initPalette16;
	Assign(palette16File, filename);
	ReWrite(palette16File);

	Write(palette16File, TPalette16); //dump everything out
	Close(palette16File);
	
End;

//we should ask if we want to read a color or BW file, else we duplicate code for one line of changes.
//there is a way to check- but we would have to peek inside the file or just display it and assume things.
//this could shove a BW file in the color section or a color file in the BW section...
//anyway, theres two sets of arrays and you can reset to defaults if you need to.

procedure Read16Palette(filename:string; ReadColorFile:boolean);

Var
	palette16File  : File of TRec16;
	i,num            : integer;
    palette:PSDL_Palette;

Begin
	Assign(palette16File, filename);
	ReSet(palette16File);
    Seek(palette16File, 0); //find first record
    if ReadColorFile =true then
		Read(palette16File, TPalette16) //read everything in
	else
		Read(palette16File, TPalette16GRey); 
	    
	Close(palette16File);
	
     SDL_AllocPalette(16);    
    if ReadColorFile =true then
          
          SDL_SetPaletteColors(palette,Tpalette16.colors,0,16)
    else
          SDL_SetPaletteColors(palette,Tpalette16GRey.colors,0,16);

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

//zero increments are always one short

   i:=0;
   num:=0; 
   repeat
      Tpalette256.colors[num]^.r:=valuelist256[i];
      Tpalette256.colors[num]^.g:=valuelist256[i+1];
      Tpalette256.colors[num]^.b:=valuelist256[i+2];
      Tpalette256.colors[num]^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  until num=767;

	
//256 color VGA palette based on XTerm colors(Unix)
//first 16 colors now should be more accurate!

TPalette256.DWords[0]:=$000000ff;
TPalette256.DWords[1]:=$ff0000ff;
TPalette256.DWords[2]:=$00ff00ff;
TPalette256.DWords[3]:=$ffff00ff;
TPalette256.DWords[4]:=$0000ffff;
TPalette256.DWords[5]:=$ff00ffff;
TPalette256.DWords[6]:=$ffff55ff;
TPalette256.DWords[7]:=$c0c0c0ff;
TPalette256.DWords[8]:=$7f7f7fff;
TPalette256.DWords[9]:=$7f0000ff;
TPalette256.DWords[10]:=$007f00ff;
TPalette256.DWords[11]:=$7f7f00ff;
TPalette256.DWords[12]:=$00007fff;
TPalette256.DWords[13]:=$7f007fff;
TPalette256.DWords[14]:=$007f7fff;
TPalette256.DWords[15]:=$ffffffff;

TPalette256.DWords[16]:=$000000ff;
TPalette256.DWords[17]:=$00005fff;
TPalette256.DWords[18]:=$000087ff;
TPalette256.DWords[19]:=$0000afff;
TPalette256.DWords[20]:=$0000d7ff;
TPalette256.DWords[21]:=$0000ffff;
TPalette256.DWords[22]:=$005f00ff;
TPalette256.DWords[23]:=$005f5fff;
TPalette256.DWords[24]:=$005f87ff;
TPalette256.DWords[25]:=$005fafff;
TPalette256.DWords[26]:=$005fd7ff;
TPalette256.DWords[27]:=$005fffff;
TPalette256.DWords[28]:=$008700ff;
TPalette256.DWords[29]:=$00875fff;
TPalette256.DWords[30]:=$008787ff;

TPalette256.DWords[31]:=$0087afff;
TPalette256.DWords[32]:=$0087d7ff;
TPalette256.DWords[33]:=$0087ffff;
TPalette256.DWords[34]:=$00af00ff;
TPalette256.DWords[35]:=$00af5fff;
TPalette256.DWords[36]:=$00af87ff;
TPalette256.DWords[37]:=$00afafff;
TPalette256.DWords[38]:=$00afd7ff;
TPalette256.DWords[39]:=$00afffff;
TPalette256.DWords[40]:=$00d700ff;
TPalette256.DWords[41]:=$00d75fff;
TPalette256.DWords[42]:=$00d787ff;
TPalette256.DWords[43]:=$00d7afff;
TPalette256.DWords[44]:=$00d7d7ff;
TPalette256.DWords[45]:=$00d7ffff;

TPalette256.DWords[46]:=$00ff00ff;
TPalette256.DWords[47]:=$00ff5fff;
TPalette256.DWords[48]:=$00ff87ff;
TPalette256.DWords[49]:=$00ffafff;
TPalette256.DWords[50]:=$00ffd7ff;
TPalette256.DWords[51]:=$00ffffff;
TPalette256.DWords[52]:=$5f0000ff;
TPalette256.DWords[53]:=$5f005fff;
TPalette256.DWords[54]:=$5f0087ff;
TPalette256.DWords[55]:=$5f00afff;
TPalette256.DWords[56]:=$5f00d7ff;
TPalette256.DWords[57]:=$5f00ffff;
TPalette256.DWords[58]:=$5f5f00ff;
TPalette256.DWords[59]:=$5f5f5fff;
TPalette256.DWords[60]:=$5f5f87ff;

TPalette256.DWords[61]:=$5f5fafff;
TPalette256.DWords[62]:=$5f5fd7ff;
TPalette256.DWords[63]:=$5f5fffff;
TPalette256.DWords[64]:=$5f8700ff;
TPalette256.DWords[65]:=$5f875fff;
TPalette256.DWords[66]:=$5f8787ff;
TPalette256.DWords[67]:=$5f87afff;
TPalette256.DWords[68]:=$5f87d7ff;
TPalette256.DWords[69]:=$5f87ffff;
TPalette256.DWords[70]:=$5faf00ff;
TPalette256.DWords[71]:=$5faf5fff;
TPalette256.DWords[72]:=$5faf87ff;
TPalette256.DWords[73]:=$5fafafff;
TPalette256.DWords[74]:=$5fafd7ff;
TPalette256.DWords[75]:=$5fafffff;

TPalette256.DWords[76]:=$5fd700ff;
TPalette256.DWords[77]:=$5fd75fff;
TPalette256.DWords[78]:=$5fd787ff;
TPalette256.DWords[79]:=$5fd7afff;
TPalette256.DWords[80]:=$5fd7d7ff;
TPalette256.DWords[81]:=$5fd7ffff;
TPalette256.DWords[82]:=$5fff00ff;
TPalette256.DWords[83]:=$5fff5fff;
TPalette256.DWords[84]:=$5fff87ff;
TPalette256.DWords[85]:=$5fffafff;
TPalette256.DWords[86]:=$5fffd7ff;
TPalette256.DWords[87]:=$5fffffff;
TPalette256.DWords[88]:=$870000ff;
TPalette256.DWords[89]:=$87005fff;
TPalette256.DWords[90]:=$870087ff;

TPalette256.DWords[91]:=$8700afff;
TPalette256.DWords[92]:=$8700d7ff;
TPalette256.DWords[93]:=$8700ffff;
TPalette256.DWords[94]:=$875f00ff;
TPalette256.DWords[95]:=$875f5fff;
TPalette256.DWords[96]:=$875f87ff;
TPalette256.DWords[97]:=$875fafff;
TPalette256.DWords[98]:=$875fd7ff;
TPalette256.DWords[99]:=$875fffff;
TPalette256.DWords[100]:=$878700ff;
TPalette256.DWords[101]:=$87875fff;
TPalette256.DWords[102]:=$878787ff;
TPalette256.DWords[103]:=$8787afff;
TPalette256.DWords[104]:=$8787d7ff;
TPalette256.DWords[105]:=$8787ffff;

TPalette256.DWords[106]:=$87af00ff;
TPalette256.DWords[107]:=$87af5fff;
TPalette256.DWords[108]:=$87af87ff;
TPalette256.DWords[109]:=$87afafff;


TPalette256.DWords[110]:=$87afd7ff;
TPalette256.DWords[111]:=$87afffff;
TPalette256.DWords[112]:=$87d700ff;
TPalette256.DWords[113]:=$87d75fff;
TPalette256.DWords[114]:=$87d787ff;
TPalette256.DWords[115]:=$87d7afff;
TPalette256.DWords[116]:=$87d7d7ff;
TPalette256.DWords[117]:=$87d7ffff;
TPalette256.DWords[118]:=$87ff00ff;
TPalette256.DWords[119]:=$87ff5fff;
TPalette256.DWords[120]:=$87ff87ff;

TPalette256.DWords[121]:=$87ffafff;
TPalette256.DWords[122]:=$87ffd7ff;
TPalette256.DWords[123]:=$87ffffff;
TPalette256.DWords[124]:=$af0000ff;
TPalette256.DWords[125]:=$af005fff;
TPalette256.DWords[126]:=$af0087ff;
TPalette256.DWords[127]:=$af00afff;
TPalette256.DWords[128]:=$af00d7ff;
TPalette256.DWords[129]:=$af00ffff;
TPalette256.DWords[130]:=$af5f00ff;
TPalette256.DWords[131]:=$af5f5fff;
TPalette256.DWords[132]:=$af5f87ff;
TPalette256.DWords[133]:=$af5fafff;
TPalette256.DWords[134]:=$af5fd7ff;
TPalette256.DWords[135]:=$af5fffff;

TPalette256.DWords[136]:=$af8700ff;
TPalette256.DWords[137]:=$af875fff;
TPalette256.DWords[138]:=$af8787ff;
TPalette256.DWords[139]:=$af87afff;
TPalette256.DWords[140]:=$af87d7ff;
TPalette256.DWords[141]:=$af87ffff;
TPalette256.DWords[142]:=$afaf00ff;
TPalette256.DWords[143]:=$afaf5fff;
TPalette256.DWords[144]:=$afaf87ff;
TPalette256.DWords[145]:=$afafafff;
TPalette256.DWords[146]:=$afafd7ff;
TPalette256.DWords[147]:=$afafffff;
TPalette256.DWords[148]:=$afd700ff;
TPalette256.DWords[149]:=$afd75fff;
TPalette256.DWords[150]:=$afd787ff;

TPalette256.DWords[151]:=$afd7afff;
TPalette256.DWords[152]:=$afd7d7ff;
TPalette256.DWords[153]:=$afd7ffff;
TPalette256.DWords[154]:=$afff00ff;
TPalette256.DWords[155]:=$afff5fff;
TPalette256.DWords[156]:=$afff87ff;
TPalette256.DWords[157]:=$afffafff;
TPalette256.DWords[158]:=$afffd7ff;
TPalette256.DWords[159]:=$afffffff;
TPalette256.DWords[160]:=$d70000ff;
TPalette256.DWords[161]:=$d7005fff;
TPalette256.DWords[162]:=$d70087ff;
TPalette256.DWords[163]:=$d700afff;
TPalette256.DWords[164]:=$d700d7ff;
TPalette256.DWords[165]:=$d700ffff;

TPalette256.DWords[166]:=$d75f00ff;
TPalette256.DWords[167]:=$d75f5fff;
TPalette256.DWords[168]:=$d75f87ff;
TPalette256.DWords[169]:=$d75fafff;
TPalette256.DWords[170]:=$d75fd7ff;
TPalette256.DWords[171]:=$d75fffff;
TPalette256.DWords[172]:=$d78700ff;
TPalette256.DWords[173]:=$d7875fff;
TPalette256.DWords[174]:=$d78787ff;
TPalette256.DWords[175]:=$d787afff;
TPalette256.DWords[176]:=$d787d7ff;
TPalette256.DWords[177]:=$d787ffff;
TPalette256.DWords[178]:=$d7af00ff;
TPalette256.DWords[179]:=$d7af5fff;
TPalette256.DWords[180]:=$d7af87ff;

TPalette256.DWords[181]:=$d7afafff;
TPalette256.DWords[182]:=$d7afd7ff;
TPalette256.DWords[183]:=$d7afffff;
TPalette256.DWords[184]:=$d7d700ff;
TPalette256.DWords[185]:=$d7d75fff;
TPalette256.DWords[186]:=$d7d787ff;
TPalette256.DWords[187]:=$d7d7afff;
TPalette256.DWords[188]:=$d7d7d7ff;
TPalette256.DWords[189]:=$d7d7ffff;
TPalette256.DWords[190]:=$d7ff00ff;
TPalette256.DWords[191]:=$d7ff5fff;
TPalette256.DWords[192]:=$d7ff87ff;
TPalette256.DWords[193]:=$d7ffafff;
TPalette256.DWords[194]:=$d7ffd7ff;
TPalette256.DWords[195]:=$d7ffffff;

TPalette256.DWords[196]:=$ff0000ff;
TPalette256.DWords[197]:=$ff005fff;
TPalette256.DWords[198]:=$ff0087ff;
TPalette256.DWords[199]:=$ff00afff;
TPalette256.DWords[200]:=$ff00d7ff;
TPalette256.DWords[201]:=$ff00ffff;
TPalette256.DWords[202]:=$ff5f00ff;
TPalette256.DWords[203]:=$ff5f5fff;
TPalette256.DWords[204]:=$ff5f87ff;
TPalette256.DWords[205]:=$ff5fafff;
TPalette256.DWords[206]:=$ff5fd7ff;
TPalette256.DWords[207]:=$ff5fffff;
TPalette256.DWords[208]:=$ff8700ff;
TPalette256.DWords[209]:=$ff875fff;
TPalette256.DWords[210]:=$ff8787ff;

TPalette256.DWords[211]:=$ff87afff;
TPalette256.DWords[212]:=$ff87d7ff;
TPalette256.DWords[213]:=$ff87ffff;
TPalette256.DWords[214]:=$ffaf00ff;
TPalette256.DWords[215]:=$ffaf5fff;
TPalette256.DWords[216]:=$ffaf87ff;
TPalette256.DWords[217]:=$ffafafff;
TPalette256.DWords[218]:=$ffafd7ff;
TPalette256.DWords[219]:=$ffafffff;
TPalette256.DWords[220]:=$ffd700ff;

TPalette256.DWords[221]:=$ffd75fff;
TPalette256.DWords[222]:=$ffd787ff;
TPalette256.DWords[223]:=$ffd7afff;
TPalette256.DWords[224]:=$ffd7d7ff;

TPalette256.DWords[225]:=$ffd7ffff;
TPalette256.DWords[226]:=$ffff00ff;
TPalette256.DWords[227]:=$ffff5fff;
TPalette256.DWords[228]:=$ffff87ff;
TPalette256.DWords[229]:=$ffffafff;
TPalette256.DWords[230]:=$ffffd7ff;


TPalette256.DWords[231]:=$ffffffff;
TPalette256.DWords[232]:=$080808ff;
TPalette256.DWords[233]:=$121212ff;
TPalette256.DWords[234]:=$1c1c1cff;
TPalette256.DWords[235]:=$262626ff;
TPalette256.DWords[236]:=$303030ff;
TPalette256.DWords[237]:=$3a3a3aff;
TPalette256.DWords[238]:=$444444ff;
TPalette256.DWords[239]:=$4e4e4eff;
TPalette256.DWords[240]:=$585858ff;
TPalette256.DWords[241]:=$626262ff;
TPalette256.DWords[242]:=$6c6c6cff;
TPalette256.DWords[243]:=$767676ff;
TPalette256.DWords[244]:=$808080ff;
TPalette256.DWords[245]:=$8a8a8aff;
TPalette256.DWords[246]:=$949494ff;
TPalette256.DWords[247]:=$9e9e9eff;
TPalette256.DWords[248]:=$a8a8a8ff;
TPalette256.DWords[249]:=$b2b2b2ff;
TPalette256.DWords[250]:=$bcbcbcff;
TPalette256.DWords[251]:=$c6c6c6ff;
TPalette256.DWords[252]:=$d0d0d0ff;
TPalette256.DWords[253]:=$dadadaff;
TPalette256.DWords[254]:=$e4e4e4ff;
TPalette256.DWords[255]:=$eeeeeeff;

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

	Write(palette256File, TPalette256); 
	Close(palette256File);
	
End;


procedure Read256Palette(filename:string; ReadColorFile:boolean);

Var
	palette256File  : File of TRec256;
	i,num            : integer;
    palette: PSDL_Palette;

Begin
	Assign(palette256File, filename);
	ReSet(palette256File);
    Seek(palette256File, 0); //find first record

	Read(palette256File, TPalette256); 
	Close(palette256File);	
    SDL_AllocPalette(256);    
    if ReadColorFile =true then
          SDL_SetPaletteColors(palette,Tpalette256.colors,0,256)
    else
          SDL_SetPaletteColors(palette,Tpalette256GRey.colors,0,256);

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
		writeln('Attempt to fetch RGB from non-Indexed color.Wrong routine called.');
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
	    	writeln('Attempt to fetch indexed DWord from non-indexed color');
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
             writeln('Wrong routine called. Try: TrueColorGetRGBfromHex');
             writeln('Wrong routine called. Try: TrueColorGetRGBfromHex');
       end;
       SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Wrong routine called. Try: TrueColorGetRGBfromHex','OK',NIL); 
 end;
end;


//its either we hack this to hell- or reimplement MainSurface- the easier option.
//MainSurface^.PixelFormat is unknown-but assignable.
//for a texture-WHICH? there is no MAIN-TEXTURE.

function TrueColorGetRGBfromHex(somedata:DWord; Texture:PSDL_Texture):PSDL_Color;
//I need to know from which Texture- (pre RenderCopy) that you want to get the data from.
//the reason why is that we DONT HAVE the RGB values- in paletted mode- WE DO.
//(we need to query a Texture to do this.)
//but WHICH ONE?

var
	pitch,format,i:integer;
    someColor:PSDL_Color;
    r,g,b:PUINT8;
    pixelFormat:PSDL_PixelFormat;

begin

//always wise to lock-and unlock but w textures(I was trying to avoid a bug) theres more to it.
lock;

// Now you want to format the color to a correct format that SDL can use.
// Basically we convert our RGB color to a hex-like BGR color.
  SDL_GetRGB(somedata,MainSurface^.Format, R, G, B);

       somecolor^.r:=byte(^r);
       somecolor^.g:=byte(^g);
       somecolor^.b:=byte(^b);

// Also don't forget to unlock your texture once you're done.
UnLock;

   	   TrueColorGetRGBfromHex:=somecolor;
end;

function GetRGBAFromHex(input:DWord):PSDL_Color;
var
	i:integer;
    somecolor:PSDL_Color; 
    r,g,b,a:PUInt8;

begin
   if (bpp <=8) then begin
         if IsConsoleInvoked then
			writeln('Cant Get RGBA data from indexed colors.');
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
			writeln('Cant Get color name from an RGB mode colors.');
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
			writeln('Cant Get color name from an RGB mode colors.');
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
  		if ((color^.r=Tpalette256.colors[i]^.r) and (color^.g=Tpalette256.colors[i]^.g) and (color^.b=Tpalette256.colors[i]^.b)) then begin
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
			Writeln('Cant Get color name from an RGB mode colors.');
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
			Writeln('Cant Get color name from an RGB mode colors.');
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
			Writeln('Cant Get index from an RGB mode (or non-palette) colors.');
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
			Writeln('Cant Get index from an RGB mode colors.');

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


//HACKME:
//sets pen color given an indexed input
procedure setFGColor(color:byte);
var
	colorToSet:PSDL_Color;
    r,g,b:PUInt8;
begin

   if MaxColors=256 then begin
        colorToSet:=Tpalette256.colors[color];
        SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
   end else if MaxColors=16 then begin
		colorToSet:=Tpalette16.colors[color];
        SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
   end;
end;


//sets pen color to given dword.
procedure setFGColor(someDword:dword); overload;
var
    r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin

//again- as with below-
//check bpp <=8 to see if we have the data already.


   SDL_GetRGB(someDword,MainSurface^.format,r,g,b); //now gimmie the RGB pair of that color
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);

   SDL_SetRenderDrawColor( Renderer, ord(somecolor^.r), ord(somecolor^.g), ord(somecolor^.b), 255 ); 
   
end;

//"words" are not Pointers to "Unsigned 8-bit ints".. some type conversion is needed here
procedure setFGColor(r,g,b:word); overload;

begin
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
end;

procedure setFGColor(r,g,b,a:word); overload;

begin
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), ord(a)); 
end;



//sets background color based on index
procedure setBGColor(index:byte);
var
	colorToSet:PSDL_Color;
//if we dont store the value- we cant fetch it later on when we need it.
begin

    if MaxColors=256 then begin
        colorToSet:=Tpalette256.colors[index];
        _bgcolor:=Tpalette256.dwords[index]; //set here- fetch later
	    SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
	    SDL_RenderClear(Renderer);
   end else if MaxColors=16 then begin 
		colorToSet:=Tpalette16.colors[index];
        _bgcolor:=Tpalette256.dwords[index]; //set here- fetch later
   	    SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
   	    SDL_RenderClear(Renderer);
   end;
end;

procedure setBGColor(someDword:DWord); overload;
var
    r,g,b:PUInt8;
	somecolor:PSDL_Color;

begin

    SDL_GetRGB(someDword,MainSurface^.format,r,g,b); //now gimmie the RGB pair of that color
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);

   _bgcolor:=someDword; //store the value
   SDL_SetRenderDrawColor( Renderer, ord(somecolor^.r), ord(somecolor^.g), ord(somecolor^.b), 255 ); 
   SDL_RenderClear(renderer);
end;

procedure setBGColor(r,g,b:word); overload;

//bgcolor here and rgba *MAY* not match our palette..be advised.

var
 color:PSDL_Color;

begin
   _bgcolor:=SDL_MapRGB(MainSurface^.format,color^.r,color^.g,color^.b);
   SDL_SetRenderDrawColor( Renderer, ord(color^.r), ord(color^.g), ord(color^.b), 255 ); 
   SDL_RenderClear(renderer);
end;

procedure setBGColor(r,g,b,a:word); overload;

var
  color:PSDL_Color;

begin
   _bgcolor:=SDL_MapRGBA(MainSurface^.format,color^.r,color^.g,color^.b,color^.a);
   SDL_SetRenderDrawColor( Renderer, ord(color^.r), ord(color^.g), ord(color^.b), ord(color^.a)); 
   SDL_RenderClear(renderer);
end;


// ColorNameToNum(ColorName : string) : integer;
//isnt needed anymore because enums carry a number for the defined "NAME".


//remember: _fgcolor and _bgcolor are DWord(s).

function GetFgDWordRGBA:DWord;

var
  somecolor:PSDL_Color;
  r,g,b,a:PUint8;

begin
    if (bpp < 8) then begin
        //error: not indexed color
        exit; //rgba not supported
    end;
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);
    somecolor^.a:=byte(^a);

    GetFgDWordRGBA:=SDL_MapRGBA(MainSurface^.format,somecolor^.r,somecolor^.g,somecolor^.b,somecolor^.a); //gimmie the DWord instead
end;

//doesnt make sence w using _bgcolor as a DWord
//only makes sense if you are using RGB or RGBA "tuples" instead of a Dword but wanted a DWord.
//has a use but its limited.

function GetBgDWordRGB(r,g,b:byte):DWord;

begin
//really rare case
    if (MaxColors<=255) then exit; //use the other function for this
       if IsConsoleInvoked then begin
          writeln('Trying to fetch background color -when we have it- in Paletted mode.');
          writeln('We have the background color in paletted modes!');
          exit;
       end;
       SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'We already have the Background Color in Paletted mode.','OK',NIL);

    GetBgDWordRGB:=SDL_MapRGB(MainSurface^.format,ord(r),ord(g),ord(b));    
end;

function GetBgDWordRGBA(r,g,b,a:byte):DWord;
begin
    GetBgDWordRGBA:=SDL_MapRGBA(MainSurface^.format,ord(r),ord(g),ord(b),ord(a)); //gimmie the DWord instead
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

//use XRandr...or...
//SetVideoMode will not work anymore. Dont try it- it wil crash your app.

var
    mode_index,modes_count ,display_index,display_count:integer;
    i:integer;


begin
   display_count := SDL_GetNumVideoDisplays; //1->display0
   writeln('Number of displays: '+ intTOstr(display_count));
   display_index := 0;

//for each monitor do..
while  (display_index <= display_count) do begin
    writeln('Display: '+intTOstr(display_index));

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
            writeln(IntToStr(SDL_BITSPERPIXEL(SDLmodePointer^.format))+' bpp'+ IntToStr(SDLmodePointer^.w)+ ' x '+IntToStr(SDLmodePointer^.h)+ '@ '+IntToStr(SDLmodePointer^.refresh_rate)+' Hz ');

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
    
end;

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

-Custom modes are usually hackish and were removed.

Interrupt handling:

The reason this is remmed out is bc I want YOu to do this.
The code is however-reasonable- but untested.


}


procedure IntHandler;
//This is a dummy routine.

//I want you- Users/programmers to override this routine and DO THINGS RIGHT.

begin

  while true do begin //mainloop -should never exit

  if (SDL_PollEvent(event) = 1) then begin
      
      case event^.type_ of
 
               //keyboard events
        SDL_KEYDOWN: begin
        end;

	    SDL_MOUSEBUTTONDOWN: begin
	    end;
        
        SDL_WINDOWEVENT: begin
                           
                           case event^.window.event of
                             SDL_WINDOWEVENT_MINIMIZED: minimized:=true; //pause
                             SDL_WINDOWEVENT_MAXIMIZED: minimized:=false; //resume
                             SDL_WINDOWEVENT_ENTER: begin
                                    continue;
                             end; 
                             SDL_WINDOWEVENT_LEAVE: begin
                                   continue;
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
function RGBAToDWord(somecolor:PSDL_Color):DWord;
var
    someDword:DWord;

begin
    someDWord := (somecolor^.R or somecolor^.G or somecolor^.B or somecolor^.A);
    RGBAToDWord:=someDWord;
end;

//to break down into components using RGBA mask(ARGB is backwards mask)
function DWordToRGBA(someword:DWord):PSDL_Color;

var
    somecolor: PSDL_Color;
begin
    //if not mswindows (this is rgba), if so - flip to ARGB instead

    somecolor^.R := (someword and $FF000000);
    somecolor^.G := ((someword and $00FF0000) shr 8);
    somecolor^.B := ((someword  and $0000FF00) shr 16);
    somecolor^.A := ((someword and $000000FF) shr 24);
    DWordToRGBA:=somecolor;
end;


{
Create a new texture for most ops-

PageFlip is being called automatically at minimum (screen_refresh) as an interval.
        If not ready(deltas..use deltas...) then set RenderingDone to false.

This is the preferred "faster" method.

Refreshing the screen is fine- if data is in the backbuffer. 
Until its copied into the main buffer- its never displayed.

HOWEVER--
        DO NOT OVER RENDER. It will crash the best of systems.
    

which surface do we lock/unlock??
solve for X -by providing it. 
-dont beat your own brains out nuking the problem.

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

//HACKME:
//BGI spec
procedure clearDevice;

begin
    SDL_RenderClear(renderer);
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
	r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin
    if MaxColors>256 then begin
        if IsConsoleInvoked then
           writeln('ERROR: i cant do that. not indexed.');
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempting to clearscreen(index) with non-indexed data.','OK',NIL);   
        writeln('Attempting to clearscreen(index) with non-indexed data.');           
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


//this is for dividing up the screen or dialogs (in game or in app)

//spec says clear the last one assigned
procedure clearviewport;

//clears it, doesnt remove or add a "layered window".
//usually the last viewport set..not necessary the whole "screen"
var
  viewport:PSDL_Rect;

begin
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
function initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean):PSDL_renderer;

{

we are halfway there according to some Wolf3D and POSTAL devs:
FS sets logical size but we want the window- a forced "physical" to be that size too.
Logic size allows upscaling of smaller resolutions on our behalf.

}
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
        writeln('Graphics already active.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Initgraph: Graphics already active.','OK',NIL);	
    exit;
  end;
  pathToDriver:='';  //unused- code compatibility
  iconpath:='./sdlbgi.bmp'; //sdl2.0 doesnt use this.

  case(graphmode) of

//lower resolutions than this are tiny on newer hardware, only effective on older 8088.
//removed for now.
 
	     mCGA:begin 
{
         we have full frame LFB now- planar storage doesnt make sense, is very bit-wise...
         -and very hard to do animations with.

         bitshifting is significantly faster than math operations, however. Not everyone took this into account.

         SDL becomes slow on put/getpixel ops due to repeated "one shot" operations instead of batches(buffered ops/surfaces)
         each get/putPixel operation *may* have to shift colors- AND was slowed down further by a (now removed) Pixel Mask(BGI).

         SDL_RenderDrawPoint() IMHO should not exist. 
         You should batch the call thru a surface- you dont know how youre being called. 

         Hardware surfaces add wait times during copy operations between graphics hardware and memory.
         Despite the GPU being several orders (10x?) of magnitude faster than the CPU. GPU ops must also be "byte aligned".
         -In this case, 32 bits.

         How 24bit is natively supported, nobody will ever know. Probably like I do 15bit modes.

         Despite rumors- 
                CGA is 4COLOR, 4Mode Graphics. 
                EGA is 16 color.

        You probably remember some text mode hack- or use of text mode symbols, like MegaZuex (openmzx) uses.

}
			MaxX:=320;
			MaxY:=240;
			bpp:=8; //yes, 8bpp- its hackish.... SDL BUG.
			MaxColors:=4;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

	     EGA:begin 
			MaxX:=320;
			MaxY:=240;
			bpp:=8; 
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
			bpp:=8; 
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

		m1280x1024xMil2:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=32; 
		   MaxColors:=4294967296;
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

		m1366x768xMil2:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=32; 
		   MaxColors:=4294967296;
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
	    
  end;{case}

//once is enough with this list...its more of a nightmare than you know.
//(its assigned before entries are checked)


   //"usermode" must match available resolutions etc etc etc
   //this is why I removed all of that code..."define what exactly"??

  //attempt to trigger SDL...on most sytems this takes a split second- and succeeds.
  _initflag:= SDL_INIT_VIDEO or SDL_INIT_TIMER;

  if WantsAudioToo then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER; 
  if WantsJoyPad then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_JOYSTICK;
//if WantInet then SDL_Init_Net;

  if ( SDL_Init(_initflag) < 0 ) then begin
     //we cant speak- write something down.

     if ISConsoleInvoked then begin
        writeln('Critical ERROR: Cant Init SDL for some reason.');
        writeln(SDL_GetError);
     end;
     //if we cant init- dont bother with dialogs.

     _grResult:=GenError; //gen error
     halt(0); //the other routines are now useless- since we didnt init- dont just exit the routine, DIE instead.

  end;
 
{
  if wantsFullIMGSupport then begin

    _imgflags:= IMG_INIT_JPG or IMG_INIT_PNG or IMG_INIT_TIF;
    imagesON:=IMG_Init(_imgflags);

    //not critical, as we have bmp support but now are limping very very bad...
    if((imagesON and _imgflags) <> _imgflags) then begin
       if IsConsoleInvoked then begin
		 writeln('IMG_Init: Failed to init required JPG, PNG, and TIFF support!');
		 writeln(IMG_GetError);
	   end;
	   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'IMG_Init: Failed to init required JPG, PNG, and TIFF support','OK',NIL);	
    end;
  end;
}

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
			writeln('Cant get current video mode info. Non-critical error.');
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
		writeln('WARNING: cannot set drawing to video refresh rate. Non-critical error.');
		writeln('you will have to manually update surfaces and the renderer.');
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
{  if TTF_Init = -1 then begin
    
    if IsConsoleInvoked then begin
        writeln('I cant engage the font engine, sirs.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: I cant engage the font engine, sirs. ','OK',NIL);
		
    _graphResult:=-3; //the most likely cause, not enuf ram.
    closegraph;
  end;
}
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
			writeln( 'Warning: No joysticks connected!' ); 
        
  		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Warning: No joysticks connected!','OK',NIL);
        
    end else begin //Load joystick 
	    gGameController := SDL_JoystickOpen( 0 ); 
    
        if( gGameController = NiL ) then begin  
	        if IsConsoleInvoked then begin
		    	writeln( 'Warning: Unable to open game controller! SDL Error: '+ SDL_GetError); 
                writeln(SDL_GetError);
            end;
            SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Warning: Unable to open game controller!','OK',NIL);
            noJoy:=true;
        end;
        noJoy:=false;
    end; 
  end; //Joypad 

 //The GC:
 // writeln(longword(@MainSurface));

  InitGraph:=renderer;
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


var
    FontPointer:PTTF_Font;
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
//  if wantsFullIMGSupport then 
  //   IMG_Quit;


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
    success,IsThere,RendedWindow:integer;
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

if (LIBGRAPHICS_INIT=false) then 

begin
		
		if IsConsoleInvoked then writeln('Call initgraph before calling setGraphMode.') 
		else SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'setGraphMode called too early. Call InitGraph first.','OK',NIL);
	    exit;
end
else if (LIBGRAPHICS_INIT=true) and (LIBGRAPHICS_ACTIVE=false) then begin //initgraph called us
    writeln('MaxX: ',MaxX);
    writeln('MaxY: ',MaxY);
    writeln('bpp: ',bpp);
//    writeln('Full screen requested: ',wantfullscreen);


//FIXME: Lazarus and SDL2, not 1.
   
         //posX,PosY,sizeX,sizeY,flags
         {$IFNDEF LCL}
         window:= SDL_CreateWindow(PChar('Lazarus Graphics Application'), SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, MaxX, MaxY, 0);
    	 if (window = Nil) then begin
 			if IsConsoleInvoked then begin
	    	   	writeln('Something Fishy. No hardware render support and cant create a window.');
	    	   	writeln('SDL reports: '+' '+ SDL_GetError);      
	    	end;
         {$ENDIF}

//Handle -> Application.MainForm.Handle as per the forums

         {$IFDEF LCL}
            {$IFDEF mswindows}
                window:=SDL_CreateWindowFrom(Pointer(Application.MainForm.Handle));
            {$ENDIF}
            {$IFDEF unix} 
                {$IFDEF LCLGTK} //GTK- never assume                
                    window:=SDL_CreateWindowFrom(Pointer(GDK_WINDOW_XWINDOW(PGTKWidget(PtrUInt(Application.MainForm.Handle))^.window)));
                {$ENDIF}

//untested- similar to OSX
            //    {$IFDEF LCLQt} //QT- never assume                
            //        window:=SDL_CreateWindowFrom(Pointer(PQtWidget(PtrUInt(Application.MainForm.Handle))^.widget));
            //    {$ENDIF}

                //ELSE:  X11Core
                GetXHandle(Application.MainForm.Handle);
            {$ENDIF}
            //MacOSX
            {$IFDEF Darwin}
                    window:=SDL_CreateWindowFrom(Pointer(TCarbonWidget(PtrUInt(Application.MainForm.Handle))^.widget));  
            {$ENDIF}

         {$ENDIF}

	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy','I cant make a window. BYE..',NIL);
			
			_grResult:=GenError;
	    	closegraph;
         end;

        writeln('initgraph: Window is online.');

       //Hide, mouse.
       SDL_ShowCursor(SDL_DISABLE);

    end; 


    //4 and 8 bits get an empty palette where >8 need mask set.
 

    if (bpp<=8) then begin
   
   if MaxColors=16 then
            SDL_SetPaletteColors(palette,TPalette16.colors,0,16)
	  else if MaxColors=256 then
            SDL_SetPaletteColors(palette,TPalette256.colors,0,256);
    end;


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
                writeln('ERROR: SDL cannot set DisplayMode.');		
                writeln(SDL_GetError);
            end;
			exit;
        end;

//if want full screen , then....
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

  end; 

end; //setGraphMode

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
            writeln('Cant find current mode in modelist.');
        end;
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: Cant find current mode in modelist.','OK',NIL);        
   end;   
end;    

procedure restorecrtmode; //wrapped closegraph function
begin
  if (not LIBGRAPHICS_ACTIVE) then begin //if not in use, then dont call me...

	if IsConsoleInvoked then 
        writeln('you didnt call initGraph yet...try again?') 
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
        reset the palette and Flip

        //xorBlit
        //andBlit
        //orBlit
        //notBlit(inverted colors)

//GetSurface from Renderer (or Create SurfaceFromRenderer) 
SDL_ScrollX(Surface,DifX);
SDL_ScrollY(Surface,DifY);
//Then renderCopy it back as a "texture"


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
            //writeln('We ran out of modes to check.');
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
            himode:=detectgraph;	 //unfortunate probe here...   	
// FIXME: return value: (byte to enum value conversion?? - or use a bunch of consts)
// default enum type reads: longword

	    	lomode:= ord(mCGA); //no less than this.
		end else begin
			if IsConsoleInvoked then
				writeln('Unknown graphdriver setting.');
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
   if windownumber=8 then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to create too many viewports.','OK',NIL);
      if IsConsoleInvoked then
        writeln('Attempt to create too many viewports.');
      exit;
   end;
   //get viewport size and put into LastRect
   SDL_RenderGetViewport(renderer,Lastrect); 
   //current co ords = last, then add one.
   inc(windownumber);

   //LINUX claims of xor,xnor "not being supported"- so let "work around it".
   
  //store the current viewport data
  saveSurface := NiL;
  infosurface:=Nil;
  ScreenData:=Nil;

  //pixels and info abt the pixels. from the renderer-to a surface, then throw it back into a texture
  ScreenData:=GetPixels(LastRect);
  infoSurface := SDL_GetWindowSurface(Window);

  saveSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface^.w * infoSurface^.format^.BytesPerPixel),longword( infoSurface^.format));

  if (saveSurface = NiL) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt create SDL_Surface from renderer pixel data','OK',NIL);
      writeln('Couldnt create SDL_Surface from renderer pixel data. ');
      writeln(SDL_GetError);
      exit;
                    
  end;
   
   Textures[windownumber]:=SDL_CreateTextureFromSurface(renderer,saveSurface);

   //free data
   SDL_FreeSurface(saveSurface);

   saveSurface := NiL;
   infosurface:=Nil;
   ScreenData:=Nil;
  

   SDL_RenderSetViewport( Renderer, Rect );  
   //clearviewport(_fgcoor);
  
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
        writeln('Attempt to remove non-existant viewport.');
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

        Textures[windownumber]:=nil; //Destroy the current Texture

        SDL_RenderCopy(renderer,Textures[windownumber-1],Nil,LastRect);
        SDL_Flip(renderer);

		SDL_RenderSetViewport( Renderer, LastRect ); 
        dec(windownumber);
//unfreeze movement
        exit;
   end; 
   //else: last window remaining
   Textures[1]:=nil;
   SDL_RenderSetViewport( Renderer,nil);  //reset to full size "screen"

   //this only works if we freeze input and dont update the screen- otherwise, we jitter
   // and update with old data on the "overlayed area".

   SDL_RenderCopy(Renderer,Textures[0],nil,LastRect);
   SDL_Flip(renderer); //and update back to the old screen before the viewports came here.

   LastRect^.X:=0;
   LastRect^.Y:=0;
   LastRect^.W:=MaxX;
   LastRect^.H:=MaxY;
   
   dec(windownumber);

   //unfreeze movement
end;



//compatibility
//these were hooks to load or unload "driver support code modules" (mostly for DOS)
procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
begin
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Function No longer supported: InstallUserDriver','OK',NIL);
   writeln('Function No longer supported: InstallUserDriver');
end;

procedure RegisterBGIDriver(driver: pointer);

begin
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Function No longer supported: RegisterBGIDriver','OK',NIL);
   writeln('Function No longer supported: RegisterBGIDriver');
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

procedure PlotPixelWithNeighbors(Thick:thickness; x,y:integer);
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
   SDL_FillRect(renderer, rect);

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
  saveSurface := NiL;
  infosurface:=Nil;
  ScreenData:=Nil;
  ScreenData:=GetPixels(Nil); 
  
  infoSurface := SDL_GetWindowSurface(Window);
  saveSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface^.w * infoSurface^.format^.BytesPerPixel), longword(infoSurface^.format));

  if (saveSurface = NiL) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt create SDL_Surface from renderer pixel data','OK',NIL);
      if IsConsoleInvoked then begin
          writeln('Couldnt create SDL_Surface from renderer pixel data');      
          writeln(SDL_GetError);
      end;
      exit;
                    
  end;
  SDL_SaveBMP(saveSurface, filename);
  SDL_FreeSurface(saveSurface);
  saveSurface := NiL;
  infosurface:=Nil;
  ScreenData:=Nil;
  inc(Screenshots);
end;


//note this function is "slow ASS"

{
function GetPixels(Rect:PSDL_Rect):pointer;
//this does NOT return a single pixel by default and is written intentionally that way.
//GetPixel checks also the output pointer length and fudges it into a single "SDL_Color".

//this routine expects YOU to handle the array of data
//SDL_Color SDL_Color SDL_Color .....

var

  pitch:integer;
  pixels:pointer; //^array [0..x*y] of SDL_Color

//
  the array size is dependant on current screen resoluton- I can only give MAXIMUM defaults if I set this value.
  This is an SDL_Color limitation. If it were me, Id just copy the array in 2D, not 1D.
  Yes, technically, even kernel write to screen are stored in VRAM(or buffers) as:
		[X,Y,RGBColor] however...SDL treats it as a 1D array.

  I didnt design SDL, sorry. Maybe thats why its SLOW???
  src: VGA graphics 101 - address A000, 386+ VRAM (and LFB) access.
  NOTE: 
     You probly CANNOT directly write here.. (blame X11 or Windows or Apple)
     (Because youre staring at the array right now, reading this.)
//

  AttemptRead:integer;

begin
   if ((Rect^.w=1) or (Rect^.h=1)) then begin    
     if IsConsoleInvoked then begin       
        writeln('USE GetPixel. This routine FETCHES MORE THAN ONE');
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
          writeln('Attempt to read pixel data failed.');
          writeln(SDL_GetError);
      end;
     exit;
   end;
   GetPixels:=pixels;
end;
}



begin  //main()


{$IFDEF unix}
IsConsoleInvoked:=true; //All Linux apps are console apps-SMH.

  if (GetEnvironmentVariable('DISPLAY') = '') then NeedFrameBuffer:=true; //we have no X11 loaded.

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
        {$IFDEF mswindows}
			IsConsoleInvoked:=false; //ui app- NO CONSOLE AVAILABLE
        {$ENDIF}
{$ENDIF}


//with initgraph (as a function) it returns one of these codes
//these are the strings of the error codes

   screenshots:=00000000;

   windownumber:=0;
   grErrorStrings[0]:='No Error';
   grErrorStrings[1]:='Not enough memory for graphics';
   grErrorStrings[2]:='Not enough memory to load font';
   grErrorStrings[3]:='Font file not found';
   grErrorStrings[4]:='Invalid graphics mode';
   grErrorStrings[5]:='General Graphics error';
   grErrorStrings[6]:='Graphics I/O error';
   grErrorStrings[7]:='Invalid font';

end.



