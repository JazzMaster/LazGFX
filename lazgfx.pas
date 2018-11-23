Unit LazGFX; 

{
A "fully creative rewrite" of the "Borland Graphic Interface" in SDL (c) 2017-18 Richard Jasmin
with the assistance of others.

LPGL v2 ONLY. 
You may NOT use a higher version.

Commercial software is allowed- provided I get the backported changes and modifications.
I dont care what use the source code for- just give me credit.

You must cite original authors and sub authors, as appropriate(standard attribution rules).
DO NOT CLAIM THIS CODE AS YOUR OWN and you MAY NOT remove this notice.

GetText .po can handle translations- if you know how to use it. 
I dont.
Thats the joke at the end of the README.

}

interface
{
-DONT RUN A LIBRARY..link to it.
-Anonymous C kernel dev (that runs a library)

This is not -and never will be- your program. Sorry, Jim.
RELEASES are stable builds and nothing else is guaranteed.



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


While Id reccommend the 2nd- Lord knows what you are using this for.
Most Game finished products (and Game consoles dont have a debugging output window)

-THIS CODE WILL CHECK WHICH IS USED and log accordingly.

---
mem optim:

destroySurface(mainsurface); needs to be used.

we need to switch to Texture ops, not Surface ones and take full use of the GPU.
I have not done this yet as there are a shitton of surface ops (or WERE) here.

to work around a SDL flaw w textures not matching surface bpp(required here) we must "create textures"
this is optimized by the fact that we can render to them (and treat them) like a surface(with renderer functions).

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
        You might have 12Gb fre of RAM, but not 12Gb of VRAM. I said might- as in SHOULD.

        Older systems could have as less as 16MB VRAM, most notebooks within 5-10 years should have 256.
        The only way to work with these systems is to clear EVERYTHING REPEATEDLY or use CPU and RAM to your advantage.

This code was a mess because of SDL1.2 implementation all over the place.
Many dont understand its use- then get thrown and force fed SDL2.x and GPU_ opcodes.
I am working on cleaning this up.

How to write good games:

SDL1.2
SDL2.0 (renderer and render to textures as surfaces)
SDL_GPU
OGL_SDL (assisted)
OGL (straight)

You need to know:

        event-driven input and rendering loops

---

There is a lot of plugins for SDL/SDLv2 and that initially confused the heck out of me.
Most of those were ported to FPC by JEDI team. I have cleaned that mess up, except for depends.

        SDL_gfx and SDL_Image are some of those extensions.

SDL_Image is JPEG, TIF, PNG support (BMP is in SDL(core) v1.2)
SDL_GFX is supposed to utilize mmx and better use the GPU. These are not SDL(core) routines nor core rendering procedures.


If you are using non-unices you will need to install these packages or build the sources to get the compiled units.
Im looking for the latter but sometimes I get the sources instead. Sorry.
However, THE MAIN THING is that we can use them as soon as the BGI code is written(HERE).

SDL 1.2 (v.14) and SDL v2 may in the future be backported to OS9 but theses sytems are "very very tiny".


Nexiuz and Postal2 use SDL.
Hedgewars uses SDL v1.2, iirc...

The difference between an ellipse and a circle is that "an ellipse is corrected for the aspect ratio".


TODO: 

    split this unit out- everything is "here" and should be seperate units.
    get tris and circles and elippses working
    aspect stretching???

FONTS:

    I have some base fonts- most likely your OS has some - but not standardized ones.
    We do NOT use bitmapped fonts- we use TTF.
    In many ways this is better.
    SDL_gfx has a 8x8 font embedded into the code headers.


This code is Useful when you need VESA modes but cant have them because X11, etc. is running.
This code **should** port or crossplatform build, but no guarantees.
SEMI-"Borland compatible" w modifications.
Lazarus graphics unit is severely lacking...use this instead.
Most of these functions(Text, polygons) are actually implemented in FPC (LCL) TCanvas 
Its also OLD, DATED, and needs an update.
The FPC devs assume you can understand OpenGL right away...
I dont agree w "basic drawing primitives" being an objectified mess.
FPC dev team doesnt make use of a renderer. 

Also: 

	HW accelleration is inhibited by direct screen put-and-get pixel routines..batches are faster.


SDL and JEDI have been poorly documented.

1- FPC code seems doggishly slow to update when bugs are discovered. Meanwhile SDL chugs along in C.
(Then we have to BACKPORT the changes again.)

2- I have no way to know if threads requirement is met(seems so) that SDL v1.2 libGraph units in C are encountering.

3- The "pascal/lazarus graphics unit" changes as per the HOST OS. 
Usually not a problem unless doing kernel development -but its an objective Pascal nightmare.
(too many functions are wrapped). 
SDL fixes this for us. 


SDL support adds "wave, mp3, etc" sounds instead of PC speaker beeping
(see the 'beep' command and enable the module on Linux) 
and adds mouse and joystick, even haptic/VR feedback support.

However, "licensing issues" (Fraunhoffer/MP3 is a cash cow) -as with qb64 which also uses SDL- wreak havoc on us. 
Yes- I Have a merge tree of qb64 that builds, just ask...

The workaround is to use VLC/FFMpeg or other libraries. 
I may in fact choose this over SDL Audio functions.


Linear Framebuffer is virtually required(OS Drivers) and bank switching has had some isues in DOS.
A lot of code back in the day(20 years ago) was written to use "banks" due to color or VRAM limitations.
The dos mouse was broken due to bank switching (at some point). The way around it was to not need bank switching-
by using a LFB. First 4GB limit, then with 64 bit chips--well, we havent hit the limit yet.


CGA as implemented here is actually MCGA(pre-VGA 16 color mode).
True CGA is 4plane-4color mode (and its butt ugly). 
It was designed for early GREEN and ORANGE monitors and 4 color monitors that had some limits.
As such-also due to "ROM bugs", some "yellows" were actually "oranges".
Full compatibilty CGA will require a lot of aspirin and funcky math as well as code rewrites Im not ready for.

THIS CODE is written for 32 AND 64 bit systems.
TP code has a 32bit Overlay-> VM unit. I suggest you use it. 

16 Bit systems will have to use code hacks and function relocation definitions as like the original hackish Borland unit used. 
Memory addressing MMU/PMU, etc. allows such things that Borland Pascal does not anymore.

Apparently the SDL/JEDI never got the 64-bit bugfix(GitHub, people...).
(A longword is not a longword when its a QWord...)

Error 216 usually indicates BOUNDS errors(memory alloc and not FREE)

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


Not all games use a full 256-color (8x8 bit) palette
This is even noted in SkyLander games lately with Activision.
"Bright happy cheery" colors are often "limited palettes" in use.

Most older games clear either VRAM or RAM while running (cheat) to accomplish most effects.
Most FADE TO BLACK arent just visuals, they clear VRAM in the process.

Fading is easy- taking away and adding color---not so much.
However- its not impossible.
    you need two palettes for each color  :-)  and you need to step the colors used between the two values
    switching all colors or each individual color straight to grey wont work- the entire image would go grey.
    you want gracefully delayed steps(and block user input while doing it)



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
Our ops are restricted, even yet to "pixels" and not groups of them.
TandL is a pixel-based operation.

There may be bugs in my math. I havent checked yet.
(I cant be as bad as -"multiplying (safely) your tokens on ETH/EXP by zero", though.)


MessageBox:

With Working messageBox(es) we dont need the console.

InGame_MsgBox() routines (like what Skyrim uses) still needs to be implemented.
FurtherMore, they need to match your given palette scheme.

I will provide the extended asciii-ish character set to work with(those box characters).

GVision, routines can now be used where they could not before.
GVision requires Graphics modes(provided here) and TVision routines be present(or similar ones written).
FPC team is refusing to fix TVision bugs. This is wrong.

debugging(captains log):
        
        Logging was fixed, but its not "perfect".
        All SDL functions should be logged. None in fact are. OOPS.

Some idiot wrote the code wrong and it needs to be updated for FILE STREAM IO.
Logging will be forced in the folowing conditions:

    under windows LCL is checked for- this is a known Lazarus issue.
    under linux with LCL compiled in


Original code derived from the following:

	original *VERY FLAWED* port (in C) coutesy: Faraz Shahbazker <faraz_ms@rediffmail.com>
	unfinished port (from go32v2 in FPC) courtesy: Evgeniy Ivanov <lolkaantimat@gmail.com> 
	some early and or unfinished FPK (FPC) and LCL graphics unit sources 
	SDLUtils(drawing primitives) [SDL v1.2+ -in Pascal]
    JEDI SDl headers(unfinished) and in some places- not needed.

manuals:
    SDL1.2 pdf
    Borland BGI documentation by QUE Publishing    
    TCanvas LCL Documentation (different implementation of a 'SDL_screen') 
    Lazarus Programming (a very rare book) by Blaise Pascal Magazine
    JEDI chm file
	TurboVision(TVision) references (where I can find them and understand them.)


NOTE: All visual rendering routines are 'far calls' if you insist building for DOS.
(I really cant help you if you do, but dont drop 32+ cpu support. I will merge the code if you fork it, however.)


plotting pixels and lines is notoriously slow. dont make it worse. 
lock and unlock only where necessary.


to animate- screen savers, etc...you need to (page)flip/rendercopy and slow down rendering timers.
(trust me, this works-Ive written some soon-to-be-here demos)


bounds:
   cap pixels at viewport
   off screen..gets ignored but should throw an error- we should know screen bounds.
   (zoom in or out of a bitmap- but dont exceed bounds.) 


on 2d games...you are effectively preloading the fore and aft areas on the 'level' like mario.
there are ways to reduce flickering but ive not gotten there yet. the damn thing should be loaded in memory anyhoo..
what.. 64K for a level? cmon....

  Move (texture,memory,sizeof(texture));


Palettes:

   These are mostly standardized now.
   Max colors in a palette are always 256, unless in modified CGA modes- then 16. 
   Specify each value or leave it as a zero
  
  See the included file from Super Mario in TP7.
  It very similar method.

  Note "the holes" can be used for overlay areas onscreen when stacking layers.
  The holes are standardized to xterm specs. I think theres like 5.


I wonder if DirectX .DDS files are SDL Surfaces??? HMMMM....
(There is a C library to load ANY texture into RAM and work with all types of them.)

Im seeing a Ton of correlation between OGL/SDL and DirectX (and people think there isnt any).


NOTE:

SDL is screwed up somewhere-
"You should not expect to be able to render, or receive events on any thread other than the main one. "
"You must render in the same routine that handles input"


Tris (triangles, trigons), polys are not ported from SDL yet. This requires much more than 
just dropping a routine in here- you have to know how the original routine wants the data-
get it in the right format, call the routine, and if needed-catch errors.

This is why the code is taking so long.


SDL is not SIMPLE. 
The BGI was SIMPLE.
SemiDirect MultiMedia OverLayer - should be the unit name.

 --Jazz (comments by me unless otherwise noted)

}


uses

// A hackish trick...test if LCL unit(s) are loaded or linked in, then adjust "console" logging...

  {$IFDEF LCL}
    {$IFDEF MSWINDOWS}
      {$DEFINE NOCONSOLE }
    {$ENDIF}
    //LCL is linked in but we are not in windows. Not critical. If you want output, set it up.
      crt,   
  {$ENDIF}

//cant use crtstuff if theres no crt units available..

{$IFNDEF NOCONSOLE}
    crtstuff,
{$ENDIF}

//if you build with the LCL (you get rid of the ugly ass SDL dialogs):

//  Lazarus Menu:  "View" menu, under "Debug Windows" there is an entry for a "console output" 
//however, if you are not in a input loop or waiting for keypress- 
// you will not get output until your program is complete (and has stopped execution)

// In this case- Lazarus Menu:   Run -> Run Parameters, then check the box for "Use launching application".
// (You may have to 'chmod +x' that script.)

// you will have to setup and manage "windows" yourself, and handle dialogs accordingly.
//HINT: (its the window with the dots on it)



//to build without the LCL:

// Just make a normal "most basic" program and call me or SDL directly in your "uses clause"
// You will find that the LCL may be a burden or get in your way- we only need it to setup "the window"- 
//     but..SDL can do that for us- (so its a great help).


//there are parts of SDL that we can get rid of. They are hard to read, seem to be wrapped "do nothing routines", etc.


{$ifdef unix} cthreads,ctypes,cmem,sysUtils,crt,{$endif}

//FPC generic units(OS independent)
  SDL2,SDL2_Image,SDL2_TTF,strings,typinfo

//GL, GLU
//math

//SDL2_gfx is untested as of yet. functions start with GPU_ not SDL_

{$ifdef debug} ,heaptrc {$endif} //logger


//sdl_net (-YAASSS!! networking!!!)

//Carbon is OS 8 and 9 to OSX API
{$ifdef mac} 
  ,MacOSAll
{$endif}

//Cocoa (OBJ-C) is the new API
//OSX 10.5+
{$ifdef darwin}
	{$linkframework Cocoa}
	{$linklib SDLmain}
	{$linklib gcc}

//also requires:
//mode objpas
//modeswitch objectivec2

//-This code is not objectified in these units- the required "objpas mode" may fail.
// (you would have to rewrite units as objects to do this)

//iFruits, iTVs, etc:
// {linkframework CocoaTouch} -- but go kick apple in the ass for not letting us link to it.

{$endif}


//Altogether- we are talking PCs running OSX, OS9, OS8 (heaven forbid), Windows(sin-down to XP), and most unices.
//Some android (as a unice sub-derivative)

;

{
NOTES on units used:

crt is a failsafe "ncurses"....output...
crtstuff is MY enhanced dialog unit for crt "ncurses" output on the console.
    I will be porting these and maybe more to the graphics routines in this unit.


mac- is a hairy mess but "try to do something"
droid isnt here(yet)
sin has been done -(but no reason we CANT redo it)

FPC Devs: "It might be wise to include cmem for speedups"
"The uses clause definition of cthreads, enables theaded applications"

There is a way to use SDL timers, signals and threads instead of Pascal or C ones.
"Compiler reserved words" forbid us using these.

mutex(es):

The idea is to talk when you have the rubber chicken or to request it or wait until others are done.
Ideally you would mutex events and process them like cpu interrupts- one at a time.

(creating a window apparently trips like 5 events??)


sephamores are like using a loo in a castle- 
only so many can do it at once, first come- first served

- but theres more than one toilet

}


type  

//FIXME:
//typedefines need to be prefaced with a T as in: "TSomething=something else"

//becuse otherwise we confuse the compiler etc.
//adjust the variables accordingly. This is mostly for records and objects.


//drawing width of lines in pixels

  linestyles=( NormWidth  = 1,
  WideWidth = 3,
  ThickWidth =5,
  VeryThickWidth =7,
  VeryVeryThickWidth=9);

//should we need to abort...
  grErrorType=(OK,NoGrMem,NoFontMem,FontNotFound,InvalidMode,GenError,IoError,InvalidFontType);


  TArcCoordsType = record
      x,y : word;
      xstart,ystart : word;
      xend,yend : word;
  end;

//for GotoXY()
  Twhere=record
     x,y:word;
  end;

//tris,polys,etc.
  TPoint=record 
//this is correct and there is (NOW) a way to dyn load records and arrays of records w FPC,
//this DOES NOT APPLY to TP/BP and derivatives.

    x,y:word;
  end;


//graphdriver is not really used half the time anyways..most people probe.
//these are range checked numbers internally.

	graphics_driver=(DETECT, CGA, VGA,VESA); //cg,vga,vesa,hdmi,hdmi1.2


//thick graphic images, not text ascii chars...

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


DriverNumber note: 

	this might fuck w the system unit FPG BUG: 0029147
	if 'i' exceeds bound defs of graphics_modes we have typedef problems...and only IF.

solution:
    for i in graphics_modes do
        if (not modelist.modename[i]='VGALo') then
           inc(i)
        else .....
        if i> ord(high(graphics_modes)-1) then break;
}


{$INCLUDE palettesh.inc}
{$INCLUDE modelisth.inc}

//This is for updating sections or "viewports".

var

  texBounds: array [0..32] of PSDL_Rect;
  textures: array [0..32] of PSDL_Texture;
//you only scroll,etc within a viewport- you cant escape from it without help.


{ I think Im going to leave this as an excercise to the user rather than dictate archane methods.

SDL Events fire after EVENT variable is assigned a pointer and either polling or event checking is enabled.
NOT UTIL- so we should be "safe" to not check input until the user program calling us needs it.


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
   //joysticks seem to be slow to respond in some games, I wonder why....

var
    where:Twhere;
	quit,minimized,paused,wantsFullIMGSupport,nojoy,exitloop:boolean;
    X,Y,_grResult:integer;
    gGameController:PSDL_Joystick;
    Renderer:PSDL_Renderer;
    Surface,FontSurface : PSDL_Surface; //main drawing screen
    window:PSDL_Window; //A window... heh..."windows" he he...
    MainTexture,Texture:PSDL_Texture;
    Rect1,srcR,destR,TextRect:PSDL_Rect;
    rmask,gmask,bmask,amask:longword;

    ttfFont : PTTF_Font;
    TextFore,TextBack : PSDL_Color; //font fg and bg...

    filename:String;
    fontpath,iconpath:PChar; // "C:\windows\fonts\*.ttf" (one at a time) or "/usr/share/fonts/*.ttf"
    font_size:integer; 
    style:byte; 
    outline:longint;
    grErrorStrings: array [low(grerrorType)..high(grErrorType)] of string; //or typinfo value thereof..
    AspectRatio:real; //computed from (AspectX mod AspectY)

{
older modes are not used, so y keep them in the list??
 (M)CGA because well..I think you KNOW WHY Im being called here....

 mode13h : "SEY-GAH"...would just not be the same wo 320x200x256...

Atari modes, etc. were removed. (double the res and we will talk)

}

  debuglog: text;
  MaxColors:LongWord; //positive only!!
  ClipPixels: Boolean=true; //always clip, never an option "not to".

  WantsJoyPad:boolean;
  screenshots:longint=000000;

  NonPalette, TrueColor,WantsAudioToo,WantsCDROM:boolean;	
  Blink:boolean=false;
  CenterText:boolean=false; //see crtstuff unit for the trick
  
  MaxX,MaxY:word;
  bpp:byte;

  _fgcolor, _bgcolor:DWord;	//this is modified due to hi and true color support.
  //do not use old school index numbers. FETCH the index based DWord instead.  
  
  flip_timer_ms:integer; //Time in MS between Render calls.
  //ideally ignore this and use GetTicks estimates with "Deltas"
  //this is bare minimum support.

  thread:PSDL_Thread;
  threadID:^TSDL_threadID;
  threadReturnValue:integer;
	
  Rect : PSDL_Rect;

  LIBGRAPHICS_ACTIVE:boolean;
  LIBGRAPHICS_INIT:boolean;
  RenderingDone:boolean; //did you want to pageflip now(or wait)?
  IsConsoleInvoked,CantDoAudio:boolean; //will audio init? and the other is tripped if in X11.
  //can we modeset in a framebuffer graphics mode? YES. but it may be brutally slow and hackish. Please use X11.

  //can we check if LCL is compiled in?

//This should help converting some of the SDL C:
//^SDL_Surface (PSDL_Surface definition) => ^TSDL_Surface

  Event:PSDL_Event; //^SDL_Event
   
  himode,lomode:integer;

  CurrentMode:PSDL_DisplayMode; //^SDL_DisplayMode
  r,g,b,a:PUInt8; //^Byte

  //this might be an internal reserved word- if so, change it.(TextureFormat)
  format:Longword;
  MainTexture:PSDL_Texture;

//ideally we could fork for rendering and then wait for renderer to exit(or fail)...



{ this is an example- programmer needs to provide these.
procedure IntHandler; //we should have forked and kick started....

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

on each putpixel call-update the CurrentPointer(CP).
on each rect call-update cp with WxH location
on each tri call(unless spun) its the bottommost right corner

etc
etc

If we track where were at based upon where we want to go be should be ok but...by default
we have no data.

I use:

currX, currY --which should sync to: 
where.X and where.Y
}

const
//I dont care how many you have, but "minus one" is the MAXIMUM ALLOWED.
   maxMode:=(hi(GraphicsModes)-1);


implementation

{$INCLUDE palettes.inc}
{$INCLUDE modelist.inc}

{

DO NOT BLINDLY ALLOW any function to be called arbitrarily.(this was done in C- I removed the checks)
If SDL engine isnt active- BAIL.

two exceptions:

making a 16 or 256 palette and/or modelist file

}



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

}

//Im going to force use of these routines as a "safety net".
//You should only have one "rendering context" when using pixel ops anyhoo-

//which surface do we lock/unlock??
//solve for X -by providing it.

procedure lock;


begin
  if (LIBGRAPHICS_ACTIVE=false) then
    //throw error
    exit;    
  end;
  Maintexture:=Nil; //if we dont clear it before calling, results are unpredictable.
  Maintexture := SDL_CreateTexture(renderer, format, SDL_TEXTUREACCESS_TARGET, MaxX, MaxY);
  if (Tex = Nil) then begin
     //error
     exit;
  end;

  SDL_SetRenderTarget(renderer, texture);

end;

//call when done drawing pixels
procedure unlock;

begin

  if (LIBGRAPHICS_ACTIVE=false) then
    //throw error
    exit;    
  end;

//we are done playing with pixels so....

//get stuff ready for the renderer and render.
  SDL_SetRenderTarget(renderer, NULL);
  SDL_RenderCopy(renderer, MainTexture, NULL, NULL);
  SDL_FreeTexture(MainTexure); 

end;



procedure timer_flip(flip_timer_ms:longint); //triggered by SDL timer according to screen refresh rate
//16.7 (or 17) is 60Hz refresh

begin
   if (not Paused) then begin //if paused then ignore screen updates
      if (TimerTicks mod flip_timer_ms) then 
         SDL_RenderPresent(Renderer);  
   end else exit;
   //else: do other stuff instead of updating the screen.
end;

//semi-generic color functions


function GetRGBfromIndex(index:byte):PSDL_Color; 
//if its indexed- we have the rgb definition already!!

var
   somecolor:PSDL_Color;
//   someRGB:PSDL_Color;
   
begin
  if bpp=8 then begin

    if MaxColors =16 then
	      somecolor:=Tpalette16.colors[index] //literally get the SDL_color from the index
    else if MaxColors=256 then
	      somecolor:=Tpalette256.colors[index]; 
    GetRGBFromIndex:=someRGB;
  end else begin
    //error:not indexed
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
    GetRGBFromIndex:=somecolor;
  end else begin
   //error: not indexed
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
	   while (i<256) do begin
		    if (Tpalette256.dwords[i] = input) then begin //did we find a match?
	    	   SDL_GetRGB(Tpalette256.DWords[i],MainSurface^.format,r,g,b);
               somedata^.r:=byte(^r);
               somedata^.g:=byte(^g);
               somedata^.b:=byte(^b);
               somedata^.a:= $ff;
 			   GetRGBFromHex:=somedata;
               exit;
           
           end else
				inc(i);  //no
       end;
	  //error:no match found
      exit;

   end else if (MaxColors=16) then begin
	    i:=0;
	    while (i<16) do begin

		    if (Tpalette16.dwords[i] = input) then begin//did we find a match?
	    	   SDL_GetRGB(Tpalette16.DWords[i],MainSurface^.format,r,g,b);
			   somedata^.r:=byte(^r);
               somedata^.g:=byte(^g);
               somedata^.b:=byte(^b);
               somedata^.a:= $ff;
               GetRGBFromHex:=somedata;
               exit;
            end else
				inc(i);  //no
       end;
	  //error:no match found
      exit;

   end;


   //True color modes
	   SDL_GetRGB(input,MainSurface^.format,r,g,b);
       somedata^.r:=byte(^r);
       somedata^.g:=byte(^g);
       somedata^.b:=byte(^b);
       somedata^.a:= $ff;
   	   GetRGBFromHex:=somedata;
end;

function GetRGBAFromHex(input:DWord):PSDL_Color;
var
	i:integer;
    somecolor:PSDL_Color; 
    r,g,b,a:PUInt8;

begin
   if (bpp <=8) then begin
      //error: not RGBA
      exit;
   end;

//RGBA doesnt support paletted modes(True color modes)
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
    //error: index not available
    exit; 
  end;

    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
   end;

  SDL_GetRGB(input,format,r,g,b); //Get the RGB color from the DWord given
     color^.r:=byte(^r);
     color^.g:=byte(^g);
     color^.b:=byte(^b);

	if MaxColors=256 then begin
        i:=0;
		repeat
			if ((color^.r=Tpalette256.colors[i]^.r) and (color^.g=Tpalette256.colors[i]^.g) and (color^.b=Tpalette256.colors[i]^.b)) then begin
				ColorNumFromHex:=i;
				exit;
			end;
		    inc(i);
		until i=256;
   //error:no match found
   //exit

	end else if MaxColors=16 then begin
        i:=0;
		
        repeat
  			if ((color^.r=Tpalette16.colors[i]^.r) and (color^.g=Tpalette16.colors[i]^.g) and (color^.b=Tpalette16.colors[i]^.b)) then begin
				ColorNumFromHex:=i;
				exit;
  			end;
  			inc(i);
		until i=16;
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
        //error: not indexed
        exit; //I dunno what the name is...
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
	until i=256;
  //no match found
  //exit


  end else if MaxColors=16 then begin
	repeat
  		if ((color^.r=Tpalette256.colors[i]^.r) and (color^.g=Tpalette256.colors[i]^.g) and (color^.b=Tpalette256.colors[i]^.b)) then begin
			GetColorNameFromHex:=GEtEnumName(typeinfo(TPalette16Names),ord(i));
			exit;
  		end;
  		inc(i);
	until i=16;
  end;
  //no match found
  //exit

end;




//get the last color set

function GetFgRGB:PSDL_Color;
var
  color:PSDL_Color;
  r,g,b,a:PUInt8;


begin
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    color^.r:=byte(^r);
    color^.g:=byte(^g);
    color^.b:=byte(^b);
    color^.a:= $ff;
    GetFgRGB:=color; 
end;

function GetFgRGBA:PSDL_Color;

var
  color:PSDL_Color;
  r,g,b,a:PUInt8;


begin
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    color^.r:=byte(^r);
    color^.g:=byte(^g);
    color^.b:=byte(^b);
    color^.a:= $ff;
    GetFgRGBA:=color; 

end;

//give me the name(string) of the current fg or bg color (paletted modes only) from the screen

function GetFGName:string;

var
   i:integer;
   somecolor:^SDL_Color;
   someDWord:DWord;

begin
   i:=0;
   i:=GetFGColorIndex;
   if ((i> 256) or (i<0)) then begin

      If IsConsoleInvoked then
			Writeln('Cant Get color name from an RGB mode colors.');
	  //messagebox('Cant Get index from an RGB mode colors.');
	  exit;
   end;
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
   i:integer;
   somecolor:^SDL_Color;
   someDWord:DWord;

begin
   i:=0;
   i:=GetBGColorIndex;
   if ((i> 256) or (i<0)) then begin

      If IsConsoleInvoked then
			Writeln('Cant Get color name from an RGB mode colors.');
	  //messagebox('Cant Get index from an RGB mode colors.');
	  exit;
   end;
   if MaxColors=256 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
		  exit;
   end else if MaxColors=16 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette16Names),ord(i));
		  exit;
   end;	

end;


//returns the current color
//BG is the tricky part- we need to have set something previously.

function GetBGColorIndex:byte;

var
   i:integer;

begin
     
     if MaxColors=16 then begin
     i:=0;
        repeat
	        if TPalette16.dwords[i]= _bgcolor then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;
    end;
     
     if MaxColors=256 then begin
       i:=0; 
       repeat
	        if TPalette256.dwords[i]= _bgcolor then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 end else begin
		If IsConsoleInvoked then
			Writeln('Cant Get index from an RGB mode colors.');
		//else
			//messagebox('Cant Get index from an RGB mode colors.');
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
		//else
			//messagebox('Cant Get index from an RGB mode colors.');
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
   end
   else begin
      //error:not indexed
      exit;
   end;
end;


//sets pen color to given dword.
procedure setFGColor(someDword:dword); overload;
var
    r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin

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
   end
   else begin
    //error: Not indexed
    exit;
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
//    somecolor^.a:= $ff;

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
    if MaxColors<255 then exit; //use the other function for this

    //try to match rgb  in TPaletteXX.colors 
    //if a match- then use index to fetch the DWord. 
    //this is done already 

    GetBgDWordRGB:=SDL_MapRGB(MainSurface^.format,ord(r),ord(g),ord(b)); //returns SDL RGB Tuple     
end;

function GetBgDWordRGBA(r,g,b,a:byte):DWord;
begin
    GetBgDWordRGBA:=SDL_MapRGBA(MainSurface^.format,ord(r),ord(g),ord(b),ord(a)); //gimmie the DWord instead
end;


//end color ops

procedure clearscreen; 

begin
	SDL_RenderClear(renderer);
end;

procedure clearscreen(index:byte); overload;

var
	r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin
    if MaxColors>256 then begin
        //ERROR: i cant do that. not indexed.
        exit; //not indexed
    end;
    if MaxColors=16 then
       somecolor:=Tpalette16.colors[index];
    
    if MaxColors=256 then
       somecolor:=Tpalette256.colors[index];


    SetPenColor(Renderer,ord(somecolor^.r),ord(somecolor^.g),ord(somecolor^.b),255);
	SDL_RenderClear(renderer);
end;


procedure clearscreen(color:Dword); overload;

var
    somecolor:PSDL_Color;
    someDword:DWord;
begin
    SDL_GetRGB(color,MainSurface^.format,r,g,b);
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);

    SetPenColor(Renderer,ord(somecolor^.r),ord(somecolor^.g),ord(somecolor^.b),255);
	SDL_RenderClear(renderer);
end;

//these two dont need conversion of the data
procedure clearscreen(r,g,b:byte); overload;


begin
	SetPenColor(Renderer,ord(r),ord(g),ord(b),255);
	SDL_RenderClear(renderer);
end;


procedure clearscreen(r,g,b,a:byte); overload;

begin
	SetPenColor(Renderer,ord(r),ord(g),ord(b),ord(a));
	SDL_RenderClear(renderer);
end;


//Im not sure if sprites (Bitmaps/Blits) can be removed this way or not.
// I know that making multiple surfaces can run out of vRAM quickly...


//this is for added-on "windows" without handles...not the whole screen.
procedure clearviewport(windownumber:smallint);
//clears it, doesnt remove or add a "layered window".
//usually the last viewport set..not necessary the whole "screen"
var
  r,g,b,a:PUInt8;
  viewport:PSDL_Rect;
  destcolor:longword;
  Tex:PSDL_Texture;
  somecolor:PSDL_Color;

begin
   viewport^.X:=TextRect[windownumber].x;
   viewport^.Y:=TextRect[windownumber].y;
   viewport^.W:=TextRect[windownumber].w;
   viewport^.H:=TextRect[windownumber].h;
   
  //rended_fillRect??
  SDL_FillRect(MainSurface, viewport,_fgcolor);
  Tex:=SDL_createTextureFromSurface(Renderer,Mainsurface);
  SDL_RenderCopy(Renderer,Tex,viewport,viewport); 
  SDL_RenderPresent(Renderer);
end;


//do you want fullscreen or not? pathToDriver is obsolete..
procedure initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean);

var
	bpp,i,numdisplaymodes:integer;
	_initflag,_imgflags,my_timer_id:longword; //^SDL_Flags?? no such beast 
    iconpath:string;
    imagesON,RamSize:integer;
	mode:PSDL_DisplayMode;

begin
  pathToDriver:='';  //unused- code compatibility
  iconpath:='./sdlbgi.bmp';


   //"usermode" must match available resolutions etc etc etc
   //this is why I removed all of that code..."define what exactly"??

  //until we get here, SDL isnt (or cant be) used.
  //attempt to trigger SDL...on most sytems this takes a split second.

  if WantsAudioToo then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER; 
  if WantsJoyPad then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_JOYSTICK;
  if WantsCDROM then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_CDROM;

  if ( SDL_Init(_initflag) < 0 ) then begin
       if not IsConsoleInvoked then begin //windows,etc
          //we cant speak- write something down.
      //    SDL_LogCritical(SDL_LOG_CATEGORY_ERROR,SDL_GetError);
          exit;
       end;
        writeln('EPIC FAILURE: Unable to init SDL: ', SDL_GetError);
        //general gfx failure
        exit; //nothing setup...so dont un-set anything. exit to caller
  //if we cant init- dont bother with dialogs.
  end;
 //usually we can get at least -here-

  if wantsFullIMGSupport then begin

    _imgflags:= IMG_INIT_JPG or IMG_INIT_PNG or IMG_INIT_TIF;
    //test support  	
    imagesON:=IMG_Init(_imgflags);

    //not critical, as we have bmp support but lacking very very bad...
    if((imagesON and _imgflags) <> _imgflags) then begin
       writeln('IMG_Init: Failed to init required JPG, PNG, and TIFF support!');
       writeln('IMG_Init: %s ', IMG_GetError);
    end;
  end;

// im going to skip the RAM requirements code and instead haarp on proper rendering requirements.
// note that a 12 yr old notebook-try as it may- might not have enough vRAM to pull things off.
// can you squeeze the code to fit into a 486??---you are pushing it.

  if (graphdriver = DETECT) then begin
	DetectGraph; //probe for it, dumbass...NEVER ASSUME.
    graphmode := MaxModes.num; //pick the highest supported by default(1080p x millions)
  end;

  if bpp=4 then initPalette16 else if bpp=8 then initpalette256; //ignor high color bpp, its not paletted.
  //setup the palette(s) (but only in modes 256 colors or less).

  LIBGRAPHICS_INIT:=true; 
  LIBGRAPHICS_ACTVE:=false; 

  SetGraphMode(graphdriver,Graphmode,wantFullScreen);

//no atexit handler needed, just call CloseGraph
//that was a nasty SDL surprise...


//If we got here- YAY!


//not tested and a lot depends on this working
   
  mythread:= SDL_CreateThread(IntHandler, 'SDL_INP_Handler', Nil); //fork(IntHandler);
 
  if not (mythread) then begin; //we didnt fork....
     if IsConsoleInvoked then begin
        writeln('EPIC FAILURE: SDL requires multiprocessing. I cant seem to fork. ');
        closegraph;
     end;
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'EPIC FAILURE: Cant init multiprocess. Its required.','BYE..',NIL);
      closegraph;
  end;
  mythreadID := SDL_GetThreadID(mythread); //we will kil you eventually Mr.Bond....
   

//lets get the current refresh rate and set a screen timer to it.
// we cant fetch this from X11? sure we can.

//this is important later on..you will see w game development and physics(Y do you think yer using SDL?).


//(try to) get some non critical but important video timing info
  
  mode^.format := SDL_PIXELFORMAT_UNKNOWN;
  mode^.w:=0;
  mode^.h:=0;
  mode^.refresh_rate:=0;
  mode^.driverdata:=Nil;
  //for physical screen 0 do..
  
  //attempting to probe VideoModeInfo block when (VESA) isnt initd results in issues....
  
  if(SDL_GetCurrentDisplayMode(0, mode) <> 0) then begin
    if IsConsoleInvoked then begin
			writeln('Cant get current video mode info. Non-critical error.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cant get the data for the current mode.','OK',NIL);
  end;

  //dont refresh faster than the screen.
  if (mode^.refresh_rate > 0)  then 
     flip_timer_ms := mode^.refresh_rate 
  else //can we assume 60hz? (hertz to ms=16.66 ad nauseum)
     flip_timer_ms := 17;

  { my_timer_id := SDL_AddTimer((33/10)*10, Timer_FLip, Nil);
	 
  if not my_timer_id then begin
    if IsConsoleInvoked then begin
			writeln('WARNING: cannot set drawing to video refresh rate. Non-critical error.');
			writeln('you will have to manually update surfaces and the renderer.');
    end;

    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'WARNING: SDL cant set video callback timer.Manually update surface.','OK',NIL);
  end;
}

  CantDoAudio:=false;
    //prepare mixer
  if WantsAudioToo then begin
  	if Mix_OpenAudio( MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 4096 ) < 0 then begin
 		if IsConsoleInvoked then begin
			writeln('OH-NO! The mixer cant be setup. All is silent...');
    	end;
		  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SDL Audio init error. Audio functions disabled.','OK',NIL);
		  CantDoAudio:=true;
  	end;
  end;

  
//set some sane default variables
  if (bpp <=8) then begin 
  //dont set the wrong palette....
     if bpp=4 then begin
		_fgcolor:=Tpalette16.DWords[15];
		_bgcolor:=Tpalette16.DWords[0];
     end;
     if bpp=8 then begin
		_fgcolor:=Tpalette256.DWords[15];
		_bgcolor:=Tpalette256.DWords[0];
     end;

  end;
  if MaxColors >256 then begin
	  _fgcolor := $FFFFFFFF;	//Default drawing color = white (15 or 255)
  	  _bgcolor := $000000FF;	//default background = black
  end;
//  linestyle:= Normal; 

  new(Event);

  LIBGRAPHICS_ACTIVE:=true;  //We are fully operational now.
  paused:=false;

  _grResult:=0; //we can just check the dialogs (or text output) now.

  where.X:=0;
  where.Y:=0;

  //Hide, mouse.
  SDL_ShowCursor(SDL_DISABLE);

  //you know if you can see a black screen...we are good..but I could remove this code.
  // default snaity sez white text on a black screen is golden.
  SDL_SetRenderDrawColor(renderer, $00, $00, $00, $FF); 
  SDL_RenderClear(Renderer);

//set some sensible input specs
  SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);


  //Check for joysticks 
  if WantsJoyPad then begin
 
    if( SDL_NumJoysticks < 1 ) then
	    writeln( 'Warning: No joysticks connected!' ) 
      else  //Load joystick 
      gGameController := SDL_JoystickOpen( 0 ); 
      if( gGameController = NiL ) then begin  
        writeln( 'Warning: Unable to open game controller! SDL Error: ', SDL_GetError); 
        noJoy:=true;
      end;
      noJoy:=false;
   end;

end; //initgraph
                    




procedure closegraph;
var
	status:PInt;
    waittimer:integer;

//dont want to alloc and then not free...ghosts are not nice...
begin

  if wantsJoyPad then
    SDL_JoystickClose( gGameController ); 
  gGameController := Nil;


  if WantsAudioToo then begin
     Mix_FreeMusic( music );
     Mix_FreeChunk( fx );
     Mix_CloseAudio;
  end;
  

  free(TextFore);
  free(TextBack);
  TTF_CloseFont(ttfFont);
  TTF_Quit;
  //its possible that extended images are used also for font datas...
  if wantsFullIMGSupport then 
     IMG_Quit;

 
   flip_timer_ms:=0; //going down!
 
  //Kill child if it is alive. we know the pid since we assigned it(the OS really knows it better than us)

  //we dont want to wait because were stuck in a loop
  //we can however, trip the loop to exit...

  exitloop:=true;
  SDL_WaitThread(thread,status);

  waittimer :=3;
  repeat
     SDL_Delay(1000);  
     dec(waittimer);
  until waittimer=0; //should be more than enough time to exit..
  SDL_KillThread(thread);

  dispose( Event );

  //free viewports

  x:=32;
  repeat
	if (Textures[x]<>Nil) then
		SDL_DestroyTexture(Textures[x]);
    dec(x);
  until x=0;
  


//Dont free whats not allocated in initgraph.
//routines should free what they allocate on exit.

//  SDL_DestroyTexture( Texture );
  SDL_FreeSurface( MainSurface );
  SDL_DestroyRenderer( Renderer );
  SDL_DestroyWindow ( Window );

  SDL_Quit; 
  LIBGRAPHICS_ACTIVE:=false;  //Unset the variable (and disable all of our other functions in the process)

  if IsConsoleInvoked then begin
     textcolor(7); //..reset standards...
     clrscr; //text clearscreen
     writeln;
  end;
  //unless you want to mimic the last doom screen here...usually were done....
  halt(0); //nothing special, just bail gracefully.
end;            	 

function GetX:word;
begin
  x:=Twhere.X;
end;

function GetY:word;
begin
  y:=Twhere.Y;
end;

function GetXY:Twhere;
begin
   X:=Twhere.X;
   Y:=Twhere.Y;
end;


procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 
//initgraph should call us to prevent code duplication
   
var
	flags:longint;
    IsThere,RendedWindow:integer;

begin

//fill the modelist!
//I have more data to add here.

  case(graphmode) of //we can do fullscreen, but dont force it...
	     mCGA:begin
			MaxX:=320;
			MaxY:=240;
			bpp:=4; 
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:=false;	
		end;

        //color tv mode
		VGAMed:begin
            MaxX:=320;
			MaxY:=240;
			bpp:=8; 
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:=false;	
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
		end;

		VGAHix256:begin
            MaxX:=640;
			MaxY:=480;
			bpp:=8; 
			MaxColors:=256;
           NonPalette:=False;
		   TrueColor:=false;	
		end;

		VGAHix32k:begin //im not used to these ones (15bits)
           MaxX:=640;
		   MaxY:=480;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
           TrueColor:=false;
		end;

		VGAHix64k:begin
           MaxX:=640;
		   MaxY:=480;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		//standardize these as much as possible....

		m800x600x16:begin
            MaxX:=800;
			MaxY:=600;
			bpp:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
		end;

		m800x600x256:begin
            MaxX:=800;
			MaxY:=600;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
		end;


		m800x600x32k:begin
           MaxX:=800;
		   MaxY:=600;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
		end;


		m1024x768x256:begin
            MaxX:=1024;
			MaxY:=768;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
		end;

		m1024x768x32k:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		m1024x768x64k:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
		end;


		m1280x720x256:begin
            MaxX:=1280;
			MaxY:=720;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
		end;

		m1280x720x32k:begin
          MaxX:=1280;
		   MaxY:=720;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		m1280x720x64k:begin
           MaxX:=1280;
		   MaxY:=720;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		m1280x720xMil:begin
		   MaxX:=1280;
		   MaxY:=720;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
		end;

		m1280x1024x256:begin
            MaxX:=1280;
			MaxY:=1024;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
		end;

		m1280x1024x32k:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		m1280x1024x64k:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		m1280x1024xMil:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
		end;

{		m1280x1024xMil2:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:=true;	
		end;
}
		m1366x768x256:begin
            MaxX:=1366;
			MaxY:=768;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
		end;

		m1366x768x32k:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		m1366x768x64k:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		m1366x768xMil:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
		end;

{		m1366x768xMil2:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:=true;	
		end;
}

		m1920x1080x256:begin
            MaxX:=1920;
			MaxY:=1080;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
		end;

		m1920x1080x32k:begin
		   MaxX:=1920;
		   MaxY:=1080;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		m1920x1080x64k:begin
		   MaxX:=1920;
		   MaxY:=1080;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
		end;

		m1920x1080xMil:begin  
 	       MaxX:=1920;
		   MaxY:=1080;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
		end;

{
		m1920x1080xMil2: begin
 	       MaxX:=1920;
		   MaxY:=1080;
		   bpp:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:=true;	
		end;
}	    
  end;{case}

//once is enough with this list...



//if not active:

//are we coming up?

//no? EXIT



if (LIBGRAPHICS_INIT=false) then 

begin
		
		if IsConsoleInvoked then writeln('Call initgraph before calling setGraphMode.') 
		else SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Called setGraphMode too early. Call InitGraph first.','OK',NIL);
	    exit;
end
else if (LIBGRAPHICS_INIT=true) and (LIBGRAPHICS_ACTIVE=false) then begin //setup- initgraph called us


	RendedWindow := SDL_CreateWindowAndRenderer(MaxX, MaxY,SDL_WINDOW_OPENGL, @window,@renderer);

	if ( RendedWindow <>0 ) then begin
        //try software first...

         //posX,PosY,sizeX,sizeY,flags
         window:= SDL_CreateWindow(PChar('Lazarus Graphics Application'), SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, MaxX, MaxY, 0);
    	 if (window = Nil) then begin
 			if IsConsoleInvoked then begin
	    	   	writeln('Something Fishy. No hardware render support and cant create a window.');
	    	   	writeln('SDL reports: ',' ', SDL_GetError);      
	    	end;
	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy. No hardware render support and cant create a window.','BYE..',NIL);
			
			_grResult:=-1;
	    	closegraph;
        end;

        //we have a window but are forced into SW rendering(why?)
    	renderer := SDL_CreateSoftwareRenderer(Mainsurface);
		if (renderer = Nil ) then begin
 			if IsConsoleInvoked then begin
	    	   	writeln('Something Fishy. No hardware render support and cant setup a software one.');
	    	   	writeln('SDL reports: ',' ', SDL_GetError);      
	    	end;
	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy. No hardware render support and cant setup a software one.','BYE..',NIL);
	    	_grResult:=-1;
	    	closegraph;
		end;

   end; 
   //we have arenderer and HW window, but no surface yet
    SDL_WM_SetIcon (SDL_LoadBMP(iconpath), Nil);
 


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

  	   if ( IsThere < 0 ) then begin
    	      if IsConsoleInvoked then begin
    	         writeln('Unable to set FS: ', getmodename(graphmode));
    	         writeln('SDL reports: ',' ', SDL_GetError);      
     	      end;
//throwning an error here might fuck with a game or something. Note the error and carry on.
//    	      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set FS.','OK',NIL);
              FSNotPossible:=true;      
       
       //if we failed then just gimmie a yuge window..      
       SDL_SetWindowSize(window, MaxX, MaxY);
       end;

    end; 

    //we can create a surface down to 1bpp, but we CANNOT SetVideoMode <8 bpp
    //I think this is a HW limitation in X11,etc.

    //syntax: flags, w,h,bpp,rmask,gmask,bmask,amask

    Mainsurface := SDL_CreateRGBSurface(0, MaxX, MaxY, bpp, 0, 0, 0, 0);
    if (Mainsurface = NiL) then begin //cant create a surface
        SDL_Log('SDL_CreateRGBSurface failed: %s', SDL_GetError);
        _grresult:=-1; //probly out of vram
        //we can exit w failure codes, if we check for them
        closegraph;
    end;


  if (bpp<=8) then begin
      if MaxColors=16 then
			SDL_SetPalette( screen, (SDL_LOGPAL or SDL_PHYSPAL), TPalette16^.colors, 0, 16 );
	  else if MaxColors=256 then
			SDL_SetPalette( screen, (SDL_LOGPAL or SDL_PHYSPAL), TPalette256^.colors, 0, 256 );
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
			//cant do it, sorry.

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

  	   if ( IsThere < 0 ) then begin
    	      if IsConsoleInvoked then begin
    	         writeln('Unable to set FS: ', getmodename(graphmode));
    	         writeln('SDL reports: ',' ', SDL_GetError);      
     	      end;
//throwning an error here might fuck with a game or something. Note the error and carry on.
//    	      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set FS.','OK',NIL);
              FSNotPossible:=true;      
       
       //if we failed then just gimmie a yuge window..      
       SDL_SetWindowSize(window, MaxX, MaxY);
       end;

    end;

  //reset palette data
  if bpp=4 then
    InitPalette16;
  if bpp=8 then 
    InitPalette256; 
  //then set it back up
{
  if (bpp<=8) then begin
      if MaxColors=16 then
			SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, TPalette16.colors, 0, 16 );
	  else if MaxColors=256 then
			SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, TPalette256.colors, 0, 256 );
  end;
}
     clearviewscreen;
end;

end;

function getgraphmode:string; 

var
	thisMode:PSDL_DisplayMode;
    bppstring:string;
    format:PSDL_PixelFormat;
    MaxMode:integer;
    findX,findY:word;
    findbpp:byte;

begin
   if LIBGRAPHICS_ACTIVE then begin 
        format:=MainSurface^.format; 
		findbpp:=format^.BitsPerPixel; //4,8,15,16,24,32
        SDL_GetCurrentDisplayMode(0, thismode); //go get w,h,format and refresh rate..
		
//format should give you a clue as to what bpp you are in.

        findX:=thismode^.w;
		findY:=thismode^.h;
		x:=0;
        //we need to find X,Y,BPP in the modelist somehow...
		repeat //repeat until we run out of modes. we should hit something..
			if (findX=MaxX) and (findY=MaxY) and (findbpp=bpp) then begin		
			//typinfo(modelist(ord(x));		getgraphmode:=Modelist^.modename[x];
					exit;
			end;
            findbpp:=findbpp * findbpp; //findbpp^2
			inc(x);
		until x=32; //hi(ModeList);

   end;   
end;    

procedure restorecrtmode; //wrapped closegraph function
begin
  if (not LIBGRAPHICS_ACTIVE) then begin //if not in use, then dont call me...

	if IsConsoleEnabled then 
        writeln('you didnt call initGraph yet...try again?') 
    else
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Restore WHAT exactly?','Clarify the Stupid',NIL);
		  
  end;
  closegraph;
end;

function getmaxX:word;
begin
   if LIBGRAPHICS_ACTIVE then
     getMaxX:=(MainSurface^.w - 1); 
end;

function getmaxY:word;
begin
   if LIBGRAPHICS_ACTIVE then
     GetMaxY:=(MainSurface^.h - 1); 
end;

{ 

Blitter, Blittering, Blits, BitBlit
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

//NewLayer is a loaded (BMP) pointer (filled rect?)
//Surface is defined already

// SDL_BlitSurface(NewLayer, nil,MainSurface,nil);


//procedure HowBlit(currentwriteMode);
//this can do some whacky tricks...we are applying a color shift mask to the incoming blit or mini surface...


//GetSurface from Renderer (or Create SurfaceFromRenderer) first
SDL_ScrollX(Surface,DifX);
SDL_ScrollY(Surface,DifY);
//Then render it back as a "texture"


var 
  PolyArray=array[1..points] of SDL_Point;

begin
  polyarray[1].x:=5
  polyarray[1].y:=3

  polyarray[2].x:=7
  polyarray[2].y:=7


  SDL_RenderDrawPoints( renderer,polyarray,points);  
end;

    SDL_RenderDrawLines
    SDL_RenderDrawRects
    SDL_RenderFillRects

all work similarly.

}

function GetPixel(x,y:integer):DWord;

//this function is "inconsistently fucked" from C...so lets standardize it...
//this works, its hackish -but it works..SDL_GetPixel is for Surfaces/screens, nor renderers.
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
            //this is set, but anyways...
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
      //this is set, but anyways...
            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );;
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
       
    end; //case

    SDL_FreeSurface(Tempsurface);
    
end;


Procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word);

begin
//set renderDrawPoint (putPixel) uses fgcolor set with SDL_SEtPenColor or similar

  if (bpp<4) or (bpp >32) then
 
  begin
    		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Put Pixel values...','OK',NIL);
			exit;
  end;
  SDL_RenderDrawPoint( Renderer, X, Y );
end;


procedure Line(renderer1:PSDL_Renderer; X1, Y1, X2, Y2: word; LineStyle:Linestyles);

var
   x:integer;
   HexColor:Dword;
   rgbColor:PSDL_Color;
   r,g,b,a:byte;
   returnvalue:longword;

begin

  if LineStyle=NormWidth then begin //this is the skinny line...
    
    	    SDL_RenderDrawLine(renderer,x1, y1, x2, y2);   
  		    exit;

  end 
  else begin

    //basically draw the line, then fatten it

    //the original line, untouched.  
	SDL_RenderDrawLine(renderer,x1, y1, x2, y2); 
    x:=1;

    repeat
    if odd(x) then begin
  
		//draw one side
        SDL_RenderDrawLine(renderer,x1, y1-x, x2, y2-x); 	
 
		//the other side of the thick line
		SDL_RenderDrawLine(renderer,x1, y1+x, x2, y2+x); 
     	inc(x);
	end;
    inc(x);

  	until x=ord(Linestyle);
  SDL_RenderPresent(renderer);
  end;
end;


procedure Rectangle(x,y,w,h:integer);
//fill rectagle starting at x,y to w,h


begin
// if w=h then IsSquare:=true;

    new(Rect);
	rect.x:=x;
    rect.y:=y;
    rect.w:=w;
    rect.h:=h;
	SDL_RenderDrawRect(renderer, rect);
  //  SDL_RenderPresent(renderer);
    free(Rect);
end;


procedure FilledRectangle(x,y,w,h,:integer);

begin
	New(Rect);
	rect.x:=x;
    rect.y:=y;
    rect.w:=w;
    rect.h:=h;
	SDL_RenderFillRect(renderer, rect);
    SDL_RenderPresent(renderer);
    free(Rect);
end;


function getdrivername:string;
begin
//not really used anymore-this isnt dos


   getdrivername:='X11Unix.bgi'; //be a smartASS
end;



Function detectGraph:boolean; //should return max mode supported(enum)

//we detected a mode or we didnt. If we failed, exit. (we should have at least one graphics mode)
//if we succeeeded- get the highest mode and return the modelist.

var

    testbpp:integer;

begin
//ignore the returned data..this should be boolean not return (0 or some number)...thats BAD C.
//and can someone shove a hole in there? USUAlly.

// this is the "shove a byte where a boolean goes bug" in C...(boolean words etc..)
//if its zero then its not ok. we dont want any other mode or similar mode...

//the trick is to prevent SDL from setting "whatever is closest"..we want this mode and only this...
//most people dont usually care but with the BGI -WE DO.


	i:=31; //might be off again...
	for (i downto 1) do begin

   		testbpp:=SDL_VideoModeOK(modelist.width[i], modelist.height[i], modelist.bpp[i], _initflag); //flags from initgraph
   		if(testbpp=0) then begin //mode not available
      		if i>1 then dec(i);
			DetectGraph:=false; 
        end else if (testbpp=1) then begin 
            
            MaxModeSupported.num:=i; //the mode number
            //initGraph just wants the number of the enum value, which we check for
            DetectGraph:=true; //we passed
            exit;
    	end;

	end; //for loop
    //there is still one mode remaining.
	testbpp:=SDL_VideoModeOK(modelist.width[i], modelist.height[i], modelist.bpp[i], _initflag);		         
	if (testbpp=0) then begin //did we run out of modes?
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'There are no graphics modes available to set. Bailing..','OK',NIL);
		CloseGraph; 
	end;
	MaxModeSupported.num:=i; //integer
	DetectGraph:=true;

	//usermode should be within these parameters, however, since that cant be checked for...
	//why not just remove it(usermode)? [enforce sanity]
    //otherwise we need to see if its valid data too....or skew up SDL window output and rendering.....
    //-which is wrong.

end; //detectGraph


function getmaxmode:string;
var
   maxmodetest:MaxModeSupported;
begin
  if LIBGRAPHICS_ACTIVE then begin
      maxmodetest:=detectgraph;
      getmaxmode:=modeList.Modename[maxmodetest];
  end;
end;


//the only real use for the "driver" setting...
procedure getmoderange(graphdriver:integer);
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
	    	himode:=MaxModeSupported.num;
	    	lomode:= mCGA; //no less than this.
		end else begin
			if IsConsoleEnabled then
				writeln('I cant get a valid GraphicsMode to report a range.');
			SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant get a valid mode list.','ok',NIL);
		end;
	end;
end; //getModeRange


procedure installUserFont(fontpath:string; font_size:integer; style:fontflags; outline:boolean);

//MOD: SDL, not BGI .CHR files which is where most code comes from.

//font_size: some number in px =12,18, etc
//path: (varies by OS) to font we want....
//style: TTF_STYLE_UNDERLINE or TTF_STYLE_ITALIC --see SDL_TTF unit
//outline: make it an outline (hackish- the font isnt stroke filled like normal)

begin
  
  //initialization of TrueType font engine and loading of a font
  if TTF_Init = -1 then begin
    
    if IsConsoleInvoked then begin
        writeln('I cant engage the font engine, sirs.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: I cant engage the font engine, sirs. ','OK',NIL);
		
    _graphResult:=-3; //the most likely cause, not enuf ram.
    closegraph;
 
  end;

  ttfFont := TTF_OpenFont( fontpath, font_size ); //should import and make a surface, like bmp loading
  //fg and bg color should be set for us(or changed by the user in some other procedure)
  new(TextFore);
  new(TextBack);
  TextFore:=_fgcolor;
  TextBack:=_bgcolor;

  TTF_SetFontStyle( ttfFont, style ); 
  TTF_SetFontOutline( ttfFont, outline );
  TTF_SetFontHinting( ttfFont, TTF_HINTING_NORMAL );
  SetTextColor(TextFore,TextBack);

  //dont render yet...just set it up.

end;



function cloneSurface(surface1:PSDL_Surface):PSDL_Surface;
//i'll take the surface to the copy machine...
var
   surface2:^SDL_Surface;

begin
    Surface2 := SDL_ConvertSurface(Surface1, Surface1^.format, Surface1^.flags);

end;


{
procedure bar3d ( left, top, right, bottom:integer topflag:boolean);

var
   y,x:integer;
begin

//GetSurfaceFromRenderer

  DrawFilledRectangle(left, top, right, bottom); //draw a bar then round it.

  GotoXY(right, bottom);

//get x,y and draw from here, do not call gotoXY
  linerel(depth*cos(PI/6), -depth*sin(PI/6));
  linerel(0, top-bottom);

  if (topflag) then begin
    
      linerel(left-right, 0);
      linerel(left, top);
      GotoXY(right, top);
      linerel(depth*cos(PI/6), -depth*sin(PI/6));
  end;	

//surfaceToTex
//renderTex
//renderPresent

end;
}
	

//these are BGI implementation, which is why its weird.

procedure SetViewPort(X1, Y1, X2, Y2: Word);

var
    ThisRect,LastRect:^SDL_Rect;
begin
   if WindowCount=0 then begin 
      LastRect.X:=0;
      LastRect.Y:=0;
      LastRect.W:=MaxX;
      LastRect.H:=MaxY;
   end
   else begin
      SDL_RenderGetViewport(renderer,Lastrect);
   end;
   inc(windowcount);
   ThisRect.X:=X1;
   ThisRect.Y:=Y1;
   ThisRect.W:=X2;
   ThisRect.H:=Y2;

   //we want to manually set the tex size yet go grab the screen and copy whats there..
   //the reason why is so we can 'undo it'
  
   Texture[windowcount]:=CreateTextureFromSurface(screen);
   //might be clipped
   Texture[windowCount].X:=ThisRect.X;
   Texture[windowCount].Y:=ThisRect.Y;
   Texture[windowCount].W:=ThisRect.W;
   Texture[windowCount].H:=ThisRect.H;

   SDL_RenderSetViewport( Renderer, ThisRect );  
   RenderCopy(Renderer,Texture[windowcount]);
   RenderPresent(renderer);
   
   //further calls are trapped inside...
   ClipPixels:=true;

end;


function RemoveViewPort(windowcount:byte):SDL_Rect;
//the opposite of above...
//return with the last window coords..(we might be trying to write to them)
//and redraw the prior window as if the new one was not there(not an easy task).
var
  ThisRect,LastRect:^SDL_Rect;

begin

   if windowCount=0 then exit else //you must be crazy...closegraph.
   if windowcount > 1 then begin
  		ThisRect.X:=Texture[windowCount].X;
		ThisRect.Y:=Texture[windowCount].Y;
	    ThisRect.W:=Texture[windowCount].W;
	    ThisRect.H:=Texture[windowCount].H;

  		dec(windowCount);

        LastRect.X:=Texture[windowCount].X;
 	    LastRect.Y:=Texture[windowCount].Y;
 	    LastRect.W:=Texture[windowCount].W;
	    LastRect.H:=Texture[windowCount].H;
   
       //remove the viewport by removing the texture and redrawing the screen.
        SDL_DestroyTexture(Texture[windowcount+1]);
        RenderCopy(Texture[windowcount]);
        RenderPresent(renderer);
		SDL_RenderSetViewport( Renderer, LastRect ); 
        RemoveViewPort:=LastRect;      
   end; 
   //else: last window remaining
   SDL_DestroyTexture(Texture[1]);
   SDL_RenderSetViewport( Renderer,nil);  //reset to full size "screen"
   RenderCopy(Renderer,Texture[0]);
   RenderPresent; //and update back to the old screen before the viewports came here.
   LastRect:=(0,0,MaxX,MaxY);
   RemoveViewPort:=LastRect;;
end;


{
//return values can be ignored(unless there are problems) these are proceedures.

SDL_GradientFillRect( Surface,Rect, RGBStartColor, RGBEndColor, GradientStyle);


// Rounded-Corner Rectangle (3DBAR)

roundedRectangleColor(renderer, x1, y1, x2, y2, rad, colour); 
roundedRectangleRGBA(renderer, x1, y1, x2, y2, rad, r, g, b, a); 

// Rounded-Corner Filled rectangle (Box or button) 

roundedBoxColor(renderer,x1, y1, x2, y2, rad,colour); 
roundedBoxRGBA(renderer, x1, y1, x2, y2, rad,r, g, b, a); 

// Circle 

circleColor(renderer,x, y, rad,colour); 
circleRGBA(renderer,x, y, rad, r, g, b, a); 

// Arc 

arcColor(renderer, x, y, rad, start, finish,colour); 
arcRGBA(renderer,x, y, rad, start, finish, r, g, b, a); 

//Filled Circle

filledCircleColor(renderer,x, y, rad,colour); 
filledCircleRGBA(renderer,x, y, rad,r, g, b, a); 

// Ellipse (lopsided circle)

ellipseColor(renderer,x, y, rx, ry,colour); 
ellipseRGBA(renderer,x, y, rx, ry, r, g, b, a); 

// Filled Ellipse 

filledEllipseColor(renderer, x, y, rx, ry,colour); 
filledEllipseRGBA(renderer,x, y, rx, ry, r, g, b, a); 

// Pie 

pieColor(renderer,x, y, rad, start, finish, colour); 
pieRGBA(renderer,x, y, rad, start, finish, r, g, b, a); 

// Filled Pie 

filledPieColor(renderer,x, y, rad, start, finish, colour); 
filledPieRGBA(renderer, x, y, rad, start, finish, r, g, b, a); 

// Trigon /Triangle 

trigonColor(renderer, x1, y1, x2, y2, x3, y3,colour); 
trigonRGBA(renderer, x1, y1, x2, y2, x3, y3,r, g, b, a); 

// Filled Trigon 

filledTrigonColor(renderer, x1, y1, x2, y2, x3, y3, colour); 
filledTrigonRGBA(renderer, x1, y1, x2, y2, x3, y3,r, g, b, a); 

//these are confusing...you need to pass in multiple point(s)...
SDL_RenderDrawPoints(points,num)


// Filled Polys 

filledPolygonColor(renderer, vx, vy,num, colour); 
filledPolygonRGBA(renderer, vx, vy,num, r, g, b, a); 

}


//compatibility
procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
begin
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Function No longer supported: InstallUserDriver','OK',NIL);
end;

procedure RegisterBGIDriver(driver: pointer);

begin
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Function No longer supported: RegisterBGIDriver','OK',NIL);
end;


function GetMaxColor: word;
  
begin
      GetMaxColor:=MaxColors+1; // based on an index of zero so add one 255=>256
end;


//alloc a new surface and flap data onto screen -or- scrape data off of surface into a file.


//yes we can do other than BMP.
//routines are "hacked together" but "seem to be working ok".

procedure LoadExtendedImage(filename:string; Rect:PSDL_Rect);
//Rect: I need to know what size you want the imported image, and where you want it.

var
  Newsurface:PSDL_surface;
  tex:PSDL_Texture;

begin

    Newsurface:= NiL;
    Newsurface := IMG_Load(filename); //Works with PNG images and more...
 
    //Filling texture with the image using a surface
    tex := SDL_CreateTextureFromSurface(renderer, NewSurface); 
    SDL_FreeSurface(surface);
    SDL_RenderCopy(renderer, tex, Nil, rect);
    SDL_FreeTexture(tex);
end;


procedure LoadBMPImage(filename:string; Rect:PSDL_Rect);

var
  Newsurface:PSDL_surface;
  NewTex:PSDL_Texture;

begin
// if IsGameEngine then  paused:=true;
   NewSurface:=SDL_LoadBMP(filename);
   NewTex:=SDL_CreateTextureFromSurface(renderer,NewSurface);
   SDL_FreeSurface(surface);
   SDL_RenderCopy(renderer, texture, Nil, rect); //for maps, give me a rect instead of "using nil here"
   SDL_FreeTexture(NewTex);
end;

//saving PNG is weird, requires extra headers for 8bit images.


procedure PlotPixelWNeighbors(x,y:integer);
//this makes the bigger dots 
// (in other words "blocky bullet holes"...)  
begin                
   //more efficient to render a 3x3 Rect.

   New(Rect);
   Rect.x:=x;
   Rect.y:=y;
   Rect.w:=3;
   Rect.h:=3;
   SDL_RenderFillRect(renderer, rect);
// limit calls to "render present"
//   SDL_RenderPresent(renderer);
   Free(Rect);
   //now restore x and y
   x:=x+2;
   y:=y+2;   
end;


procedure SaveBMPImage(filename:string);

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
  saveSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface.w * infoSurface.format.BytesPerPixel), infoSurface^.format);

  if (saveSurface = NiL) then begin
      //ERROR: ("Couldn't create SDL_Surface from renderer pixel data", SDL_GetError);
      exit;
                    
  end;
  SDL_SaveBMP(saveSurface, filename);
  SDL_FreeSurface(saveSurface);
  saveSurface = NiL;
  infosurface:=Nil;
  ScreenData:=Nil;
  inc(Screenshots);
end;

//rect size could be 1px for all we know- or the entire rendering surface...
//note this function is "slow ASS"

//Rect: X,Y,W,H
function GetPixels(Rect:PSDL_Rect):pointer;
var

  pitch:integer;
  pixels:pointer; //array [0..x*y] of SDL_Color
  AttemptRead:integer;

begin
   pixels:=Nil;
   pitch:=0;

//case format of...

//format and rect we already can derive
//pixels and pitch will be returned for the given rect in SDL_Color format given by our set definition
//rect is Nil to copy the entire rendering target

   AttemptRead:= SDL_RenderReadPixels( renderer, rect, format, pixels, pitch)
   if (AttemptRead<0) then begin
     //error: cant read pixels
     exit;
   end;
   GetPixels:=pixels;
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


//if you want to blink circles etc...I wil leave this to the reader.
//it can be done- but its very unused code. Ususally reserved for text warnings,notices, etc.
//so anyway- heres how to do it.

// blink used to be set at value 128;

// Color:=color+Blink; -is the old way.
// Blink('string'); -is the new way.

//update your code. 
//CANTFIX: and WONTFIX: this. 
//(This was a hardwired spec in the past and is not anymore.)


procedure blinkText(Text:string);

//SDL can only SLOWLY redraw over something to "erase"
//write..erase(redraw)..write..erase..
//yes this is how my kernel console code works -just implemented differently.
begin
    
    BlinkPID:=fork; //fork(): this has to occur wo stopping while other ops are going on usually
	blink:=true; //this wont kill itself, naturally. 
    //I AM INVINCIBLE!! (only external forces can kill me now.)

        Curr^.X:=x;
        Curr^.Y:=y;  
		OutText(text);
		invertcolors;
		delay(500);
        x:=Curr^.X;
        y:=Curr^.Y;
		GotoXY(x,y);
    repeat		
		OutText(text);
		invertcolors;
		delay(500);
		GotoXY(x,y);
	until blink:=false;
end;

procedure STOPBlinkText;
//often the simplest solution is the easiest and most sane.
//we walk up to the blinking text, nudge it- and say STOP.
   
begin
            blink:=false; //kill the loop
			delay(1000); //wait for routine to safely exit.
			killPID(BlinkPID);
			BlinkPID:=Nil;
end;


begin  //main()


{$ifdef unix}
IsConsoleApp:=true; //All Linux apps are console apps-SMH.

  if (GetEnvironmentVariable('DISPLAY') = Nil) then begin
  //NO X11 was loaded
    
    writeln('Incorrectly called. SDL NEEDS X11 but X11 was never started.');
    writeln('Further: OpenGL isnt available until X11 Core loads.');
    writeln('Either that or you forgot to set the DISPLAY variable.');
    PressAnyKey; //crtstuff routine
    halt(0);
  end;

//while I dont like the assumption that all linux apps are console apps- technically its true.

//I dont see the need for the LCL with SDL/OGL but anyways...
  {$IFDEF LCL}
        QuietlyLog:=true;
        IsConsoleInvoked:=false; //ui app
  {$endif}

{$ENDIF}

{$IFDEF NOCONSOLE}
    IsConsoleEnabled:=false; //GUI APP
    QuietlyLog:=true;
{$ENDIF}

//with initgraph as a function it returns one of these codes
//these are the strings of the error codes

   screenshots:=00000000;
   grError[0]:='No Error';
   grError[1]:='Not enough memory for graphics';
   grError[2]:='Not enough memory to load font';
   grError[3]:='Font file not found';
   grError[4]:='Invalid graphics mode';
   grError[5]:='General unspecified Graphics error';
   grError[6]:='Graphics I/O error';
   grError[7]:='Invalid font';

//graphmode data is not here- its in the "init routine".

end.
