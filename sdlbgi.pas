Unit SDLBGI; 

interface

//Library -DONT RUN A LIBRARY..link to it.
//-Anonymous C dev

//This is not -and never will be- your program. Sorry, Jim.



{FIXME: 

mustfix to compile:
SYNTAX SYNTAX SYNTAX
Pointer checks with SDL_Color...

index4_MSB - L is for little endians (significant bit??)

needs "if LIBGRAPHICS_ACTIVE then begin" checks

format-> MainSurface.format in places


TODO: split this unit out- everything is "here" and should be seperate units.
sub units should pull us- (and sdl1 and 2) in.

get tris and circles and elippses working

aspect stretching???

}


//I have some base fonts- most likely your OS has some - but not standardized ones.
//We do NOT use bitmapped fonts- we use TTF.
//In many ways this is better.
//SDL_gfx has a 8x8 font embedded into the code headers.

{
Description:

In simplest terms, a FreePascal "graph" unit. 
A BGI ->SDL (event-driven) API.

Useful when you need VESA modes but cant have them because X11, etc. is running.
This code **should** port or crossplatform build, but no guarantees.

SEMI-"Borland compatible" w modifications.

Lazarus graphics unit is severely lacking...use this instead.

Most of these functions(Text, polygons) are actually implemented in FPC (LCL) TCanvas 
However, the LCL code is a objectified mess. 

Its also OLD, DATED, and needs an update.
The FPC devs assume you can understand OpenGL right away...

I dont agree w "basic drawing primitives" being an objectified mess.

FPC dev team doesnt make use of a renderer. 
To do so is ungodly slow.

Also: 

	HW accelleration is inhibited by direct screen /put and get pixel routines..batches are faster.

SDL and JEDI have been poorly documented.

1- FPC code seems doggishly slow to update when bugs are discovered. Meanwhile SDL chugs along in C.
(Then we have to BACKPORT the changes again.)

2- I have no way to know if threads requirement is met(seems so) that SDL v1.2 libGraph units in C are encountering.
Hence theneed for an updated unit for SDL v2(ish).

3- The graphics unit changes as per the HOST OS. Usually not a problem unless doing kernel development but its
an objective Pascal nightmare.(too many functions are wrapped). SDL fixes this for us. 


This unit "simplifies" image loading (bmp,jpeg,etc.) and uses *some* animations and effects..
SDL support adds "wave, mp3, etc" sounds instead of PC speaker beeping(see the 'beep' command and enable the module on Linux) 
and adds mouse and joystick, even haptic feedback support also.

However, licensing issues (as with qb64 which also uses SDL) wreak havoc on us. 
The workaround is to use VLC/FFMpeg or other libraries. I may in fact choose this over SDL Audio functions.


Linear Framebuffer is virtually required(OS Drivers) and bank switching has had some isues in DOS.
A lot of code back in the day(20 years ago) was written to use "banks" due to color or VRAM limitations.
The dos mouse was broken due to bank switching.

-We dont have said limitations now-
CGA as implemented here is actually MCGA(pre VGA 16 color mode).
True CGA is 4plane-4color mode (and its butt ugly). It was designed for early GREEN and ORANGE monitors
and 4 color monitors that had some limits.

As such also due to ROM bugs, some "yellows" were actually "oranges".


Code is written for 32 AND 64 bit systems.
Some JEDI bugs were squashed in the process.
 
16 Bit systems will have to use code hacks and function relocation definitions as like the original hackish Borland unit used. 
Memory addressing MMU/PMU, etc. allows such things that Borland Pascal does not anymore. (who uses a system that old anyway?)

Note some 64-bit SDL code upgrades due to FPC compiler hacks on 64 bit systems(when is a LongWord not a LongWord?).
Apparently the SDL/JEDI never got the bugfix(GitHub, people...).

Has this been done before? YES. Twice. 
(Once for C- with SDL Video thread issues [version 1.2 instead of 2.0??],and once for SIN.

I know of other partial ports, but none this complete.
Most code I find is abandoned work or half-assed.

Mine is WIP. I at least attempt the impossible.

*Most* 1.2 routines can be upgraded or used with 2.0.
Error 216 indicated BOUNDS errors(alloc and not FREE)


I need "pascal Pointer schooling".

RGB:

r,g,b,a:byte;

2 byte take up a WORD(unused)
4 byte take up a longword/DWord(full rgb tuple plus a)


"THIS CODE (WAS) is an ANCIENT mess.."

16 color **WAS** assumed.  
256 is the defacto VGA standard. some newer cards refuse anything less.
32-bit is supported by SDL and I am still tweaking this code for compliance.
48-bit color is theoretical -most HDTV still arent there yet.

Note the POSTAL implementation of SDL(steam):

    start with a window
    set window to FS (hide the window)
    draw to sdl buffer offscreen and/or blit(invisible rendering)
    renderPresent  (making content visible)

this is the proper workflow. especially for "these old modes"..
Otherwise you are hardware flipping and using a slow screen surface..not wise.



Most Games use transparency for "invisible background" effects.
Doing this with PNG may not work as intended-
   and quite frankly using compressed textures (JPEG) results in artifacting at hi resolutions 
   or when thigns are streetched too much.
PNG-Lite may come to the rescue- but I need the Pascal headers, not the C ones for that.

Not all games use a full 256-color (8x8 bit) palette
This is even noted in SkyLander games lately with Activision.


Older school games would have to overwrite "layers" onscreen.
Most in fact do so and clear either VRAM or RAM while running (cheat) to accomplish most effects.
Most FADE TO BLACK arent just visuals, they clear VRAM in the process.

Read "Racing the beam"...and see Super Mario TP7 source code for more details.

The code- (as a DWord) should support 32bpp- not sure that SDL does in practice.

Color Modes:

BPP 	 COLORS
4		(16)
8		(256)

15		(32768) "thousands" - usually no alpha
16		(65536) "thousands" -w alpha 

24		(16,777,216) -TRUE COLOR mode "millions"

Not yet supported:

30		(1,073,741,824) --DEEP color "billions"
32		(4,294,967,296) --TRUE COLOR(24) plus full byte of transparency

up and coming bpp(not supported):

36		(68,719,476,736) --DEEP color
48		(281,474,976,710,656) --VERY DEEP color "trillions" 

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


I havent added in Native iOS, Android or MacOS modes yet.


**CORE EFFICIENCY FAILURE**:

Pixel rendering (the old school methods)

We have to "lock pixels" to work with them, then "unlock pixels" and pageFlip. 
Our ops are restricted, even yet to "pixels" and not groups of them.


Blittering (image loading) helps. So does letting the graphics chip render.
Rendering (in most cases) is significantly faster.

Use CreateTexureFromSurface() and then TextureCopy(Texture, renderer)  instead.
USE RenderPresent() to PageFlip.


There may be bugs in my math. I havent checked yet.
I cant be as bad as multiplying "safely" your tokens on ETH/EXP by zero, though.



MessageBox:

With Working messageBox(es) we dont need the console.

InGame_MsgBox() routines (like what Skyrim uses) still needs to be implemented.

I would suggest theme them according to your game.
I will provide the extended asciii-ish character set to work with(those box characters).

Set foreground and background and box(rect) size and you should be good to go.

GVision, routines can now be used where they could not before.
GVision requires Graphics modes(provided here) and TVision routines be present(or similar ones written).


debugging(captains log):
Logging is also an option(to file). 

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


units should be mostly complete.



NOTE: All visual rendering routines are 'far calls' if you insist building for DOS.
(I really cant help you if you do, but dont drop 32+ cpu support. I will merge the code if you fork it, however.)

(ifdefine things...)


floodFill needs 9-way not 4-way fills to nearest neighbor...Use SDL routines, not FPC.


plotting pixels and lines is notoriously slow. dont make it worse. 
lock and unlock only where necessary, IFFFFF you need surface rendering at all.


to animate- screen savers, etc...you need to (page)flip/rendercopy and slow down rendering timers.
(trust me, this works-Ive written some soon to be here demos)

bounds:
   cap pixels at viewport
   ok if off screen..we ignore it. Games use a second hidden surface (and zoom in a blit)

(therefore when you change views (L+R) its just tris updating.)


on 2d games...you are effectively preloading the fore and aft areas on the 'level' like mario.
there are ways to reduce flickering but ive not gotten there yet. the damn thing should be loaded in memory anyhoo..
what.. 64K for a level? cmon....

  Move (texture,memory,sizeof(texture));

Palettes:
   This code will be in a seperate include file. It is taking up half of this unit.
   I can (and should get to) reading/writing this with a file.

   I will leave to you the palette hacking

   For each color in 256(RGB,RGBA): 

		R G B (A=FF) is a byte per value. 
		When combined they make a DWord.

   I make this sequence easier to deal with but there is a math routine to do it.
   (Bit manipulation in HEX- SDL has an internal function for this with TRUE color modes)

  Its pretty basic and standardized.

  Max colors are always 256. 
  Specify each value or leave it as a zero
  
  256x3=728 bytes. 
  Nothing fancy. 
  See the included file from Super Mario in TP7.
  It very similar method.

  Note "the holes" can be used for overlay areas onscreen when stacking layers.


I wonder if DirectX .DDS files are SDL Surfaces??? HMMMM....
(textures,textures,textures.. is the name of the game...)

Im seeing a Ton of correlation between OGL/SDL and DirectX (and people think there isnt any).


NOTE:

SDL is screwed up somewhere-
"You should not expect to be able to render, or receive events on any thread other than the main one. "
"You must render in the same routine that handles input" (to poll input, maybe)

some 1.2 routines are missing 2.0 documentation as if support was dropped.
-and yet multithreaded apps and rendering is required...hmmmm..

Tris (triangles, trigons), polys are not ported from SDL yet. This requires much more than 
just dropping a routine in here- you have to know how the original routine wants the data-
  get it in the right format, call the routine, and if needed-catch errors.

Progmatic approach I like to call it.

SDL is not SIMPLE. The BGI was SIMPLE.


 --Jazz (comments by me unless otherwise noted)

}


uses


//FPC team:
//linux apps "have a console" whether "built as a console" app or not...

{$ifdef unix} cthreads,ctypes,cmem,sysUtils,crt,{$endif}

//FPC generic units(OS independent)
	SDL2,SDL2_gfx,SDL_Image,SDL2_TTF,strings,math
//gfx is untested as of yet. HELLO!

{$ifdef debug} ,heaptrc {$endif} //logger

{$IFDEF windows} 
//these are in the other package I pointed to in the readme...
//no guarantee, YMMV... this uses WinAPI, not SDL. I dont know if the two are compatible.
//it would be nice to use standardized routines but I think FPC hooks are the issue, not SDL.
   {$IFDEF CONSOLE}
	  ,wincrt, crtstuff
   {$ENDIF}   
   ,windos 
{$ENDIF}

//dont ask....need dpmi at minimal
{$IFDEF go32v2}
  ,dos,crt,crtstuff
{$ENDIF}


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

//also requires (in C, not pascal)
//mode objpas
//modeswitch objectivec2

//-This code is not objectified in these units-

//iFruits, iTVs, etc:
//CocoaTouch dylib -- but go kick apple in the ass for not letting us link to it.

{$endif}

;

//Altogether we are talking PCs running OSX, OS9, OS8 (heaven forbid), Windows(sin), and most unices.
//Some android (as a unice subderivative)

// A hackish trick...test if LCL unit(s) are loaded or linked in, then adjust "console" logging...
  {$IFDEF LCL}
    {$IFDEF MSWINDOWS}
      {$DEFINE NOCONSOLE }
    {$ENDIF}
  {$ENDIF}

//include the default data for the basic core routines.
//we need both of these.



{
NOTES on units used:

crt is a failsafe "ncurses"....output...
crtstuff is my enhanced dialog unit for crt "ncurses" output on the console.
    I will be porting these and maybe more to the graphics routines HERE.

mac is a hairy mess but try to do something
droid isnt here(yet)
sin has been done but no reason we CANT do it...(compiler flags)

FPC Devs: "It might be wise to include cmem for speedups"
"The uses clause definition of cthreads, enables theaded applications"

signals: 

We use SDL for this.
There is a way to use SDL timers, signals and threads instead.

mutex(es):

The idea is to talk when you have the rubber chicken or to request it or wait until others are done.
Ideally you would mutex events and process them like cpu interrupts- one at a time.

(creating a window apparently trips like 5 events??)


sephamores are like using a loo in a castle- 
only so many can do it at once, first come- first served

- but theres more than one toilet
}


//drawing width of lines in pixels
//otherwise, which half do we draw? top or bottom? how about both with a middle...
  NormWidth  = 1;
  WideWidth = 3;
  ThickWidth =5;
  VeryThickWidth =7;
  VeryVeryThickWidth=9; //lay it on me



type  

//FIXME:
//typedefines need to be prefaced with a T as in: "TSomething=something else"

//becuse otherwise we confuse the compiler etc.
//adjust the variables accordingly. This is mostly for records and objects.
//OK- Im lazy....or tired...

//should we need to abort...

  grErrorType=(OK,NoGrMem,NoFontMem,FontNotFound,InvalidMode,GenError,IoError,InvalidFontType);


  TArcCoordsType = record
      x,y : word;
      xstart,ystart : word;
      xend,yend : word;
  end;

  Twhere=record
     x,y:word;
  end;

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
the number is tricky..since we cant setup a variable here...its a sequential smallint.

yes we could do it another way...but then we have to pre-call the setup routine and do some other whacky crap.
...this way initgraph and similar can just use us.

Y not 4K modes?
1080p is reasonable stopping point until consumers buy better hardware...which takes years...
most computers support up to 1080p output..it will take some more lotta years for that to change.
Is this a notebook or a phone or a MAC? Those modes have to be added too (and IFDEFd)...
YEESH!


DriverNumber note: 

	this might fuck w the system unit FPG BUG: 0029147
	if 'i' exceeds bound defs of graphics_modes we have typedef problems...and only IF.

solution:
    for i in graphics_modes do
        if (not modelist.modename[i]='VGALo') then
           inc(i)
        else .....

}

type


  TMaximumModeData=record
     strings:string;
     num:smallint;
     MAxX,MAxY:word;
     bpp:byte;
  end;

{$INCLUDE palettes.inc}
{$INCLUDE modelist.inc}

//This is for updating sections or "viewports".

  texBounds: array [0..64] of SDL_Rect;
  textures: array [0..64] of SDL_Texture;
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

var
	quit,minimized:boolean;
    X,y:integer;
	e:PSDL_Event;
    gGameController:^SDL_Joystick;
    Renderer:PSDL_Renderer;
    MainSurface,FontSurface : PSDL_Surface; //main drawing screen
    window:PSDL_Window; //A window... heh..."windows" he he...
    Texture:PSDL_Texture;
    Rect1,srcR,destR:PSDL_Rect;
    rmask,gmask,bmask,amask:longword;

    ttfFont : PTTF_Font;
    TextFore,TextBack : PSDL_Color; //font fg and bg...

    filename:String;
    fontpath:PChar; 
    font_size:integer; 
    style:byte; 
    outline:longint;
    r,g,b,a:byte; //positives only!!

//main() init
  grError= array [low(grerrorType)..high(grErrorType)-1] of string;

=(
  'No Error',
  'Not enough memory for graphics',
  'Not enough memory to load font',
  'Font file not found',
  'Invalid graphics mode',
  'Graphics error',
  'Graphics I/O error',
  'Invalid font');

  AspectRatio:real; //pairs of x,y defined in a record but a "real" value

{
older modes are not used, so y keep them in the list??
 (M)CGA because well..I think you KNOW WHY Im being called here....

 mode13h : "SEY-GAH"...would just not be the same wo 320x200x256...

Atari modes, etc. were removed. 
Obsoleted by VGA and SVGA hardware.


We need to convert this to the actual DWord.
Then these can be used properly.

  SetColor(YELLOW); calls SDL_SetColor(palette16.dwords[yellow]);

  (This is BGI SYN-TAX..easier than SDL...SDL is not so "simple" anymore..is it?)
}

  debuglog: text;

  CurrX, CurrY : Word;   { viewport relative }

  ClipPixels: Boolean=true; //always clip

  _GraphResult : smallint; //compatibility
  WantsJoyPad:boolean;
  screenshots:longint=000000;


  NonPalette, TrueColor,WantsAudioToo,WantsCDROM:boolean;	
  Blink:boolean=false;
  CenterText:boolean=false; //see crtstuff unit for the trick
  fontpath:string; // "C:\windows\fonts\*.ttf" (one at a time) or "/usr/share/fonts/*.ttf"
  
  MaxModeSupported:^TMaximumModeData; //string, not an array entry??
	
  //window:PSDL_Window; //A window... heh..."windows" he he...these cant be "closed"...
  Font_surface:PSDL_Surface;	//font screen 
  ttfFont : PTTF_Font;
  TextFore,TextBack : PSDL_Color; //font fg and bg...
  Renderer : PSDL_Renderer;

  _fgcolor, _bgcolor:DWord;	//this is modified due to hi and true color support.
  //do not use old school index numbers. FETCH the index DWord instead.  
  
  //GetPixel should convert it back to an index value if possible....not leave us with hex...

  flip_timer_id:^SDL_TimerID; //needed later to remvoe it
  thread:^SDL_Thread;
  threadID:^SDL_threadID;
  threadReturnValue:integer;
	
  Rect : PSDL_Rect;

  LIBGRAPHICS_ACTIVE,LIBGRAPHICS_INIT,RenderingDone:boolean; //did you call me correctly?
  IsInvokedConsole,CantDoAudio:boolean; //will audio init? and the other is tripped if in X11.
  //can we check if LCL is compiled in?

   
  himode,lomode:integer;

  _initflag:PSDL_Flags; //^SDL_flags


//ideally we could fork for rendering and then wait for renderer to (fail) exit...
//not sure if this is required....or not...


//routines...
procedure RoughSteinbergDither(filename,filename2:string);
procedure init16Palette;
procedure init256Palette;
procedure lock;
procedure unlock;
procedure timer_flip;
function GetRGBfromHex(Hex: DWord):SDL_Color; 
function GetRGBAfromHex(Hex: DWord):SDL_Color; 
function ColorNumToHex(Color : integer) : string;
function ColorNumFromHex:integer;
function GetColorNameFromHex(color:dword):string;
function GetRGBFromHex(color:DWord):SDL_Color;
procedure setFontFore(color:integer);
procedure setFontFore(somecolor:dword); overload;
procedure setFontBack(color:integer);
procedure setFontBack(somecolor:DWord); overload;
function ColorNameToNum(ColorName : string) : integer;
function GetFGColorIndex:integer;
function GetBGColorIndex:integer;
function GetFGName:string;
function GetBGName:string;
procedure setRGBPenColor(r,g,b:byte);
procedure setColorRGB(r,g,b:byte);
procedure setRGBAPenColor(r,g,b,a:byte);
procedure setColorRGBA(r,g,b,a:byte);
procedure setColorFGByString(colorname:string);
procedure setColorBGByString(colorname:string);
procedure SetColor(color:byte);
procedure clearviewport(windownumber:smallint);
procedure initgraph(graphdriver,graphmode:integer; pathToDriver:string; wantFullScreen:boolean);
procedure RendedRectangle(x,y,w,h,:integer);
procedure closegraph;
function GetX:word;
function GetY:word;
function GetXY:where;
procedure setgraphmode(graphmode:integer,wantfullscreen:boolean); 
function getgraphmode:string; 
procedure restorecrtmode;
function getmaxX:word;
function getmaxY:word;
procedure HowPutPixel(X,Y: integer; var Writemode:currentWriteMode);

function GetPixelFromRenderer(x,y:integer):DWord;

Procedure PutPixelRGB(x,y:Word; color:SDL_Color);
Procedure PutPixelRGBA(x,y:Word; color:SDL_Color);

procedure RenderedLinePaletted(renderer1:^SDL_Renderer; X1, Y1, X2, Y2: word; LineStyle:Linestyles);
procedure RenderedLineRGB(renderer1:^SDL_Renderer; X1, Y1, X2, Y2: word; somecolor:^SDL_Color; LineStyle:LineStyles);
procedure RenderedLineRGBA(renderer1:^SDL_Renderer; X1, Y1, X2, Y2: word; somecolor:^SDL_Color; LineStyle:LineStyles);
procedure RenderedDrawRectanglePalette(x,y,w,h,:integer);
procedure RenderedDrawRectangleRGB(x,y,w,h,:integer; color:SDL_Color);
procedure RenderedDrawRectangleRGBA(x,y,w,h,:integer; color:SDL_Color);
procedure RenderedDrawFilledRectanglePalette(x,y,w,h,:integer);
procedure RenderedDrawFilledRectangleRGB(x,y,w,h,:integer;  color:SDL_Color);
procedure RenderedDrawFilledRectangleRGBA(x,y,w,h,:integer;  color:SDL_Color);
function getdrivername:string;
Function detectGraph:boolean;
function getmaxmode:string;
procedure getmoderange(graphdriver:integer);
procedure installUserFont(fontpath:string; font_size:integer; style:fontflags; outline:boolean);
function Long2String(l: longint): string;
Procedure FileLogString(s: String);
Procedure FileLogLn(s: string);
function cloneSurface(surface1:SDL_Surface):SDL_Surface;
procedure SetViewPort(X1, Y1, X2, Y2: Word);
function RemoveViewPort(windowcount:byte):SDL_Rect;
procedure Line(x1,y1,x2,y2:integer);
procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
procedure RegisterBGIDriver(driver: pointer);
function GetMaxColor: word;
procedure LoadBMPImage;

function  GetPixel( SrcSurface : PSDL_Surface; x : integer; y : integer ) : Dword;
procedure PutPixelRenderer(Renderer:SDL_Renderer; x,y:integer);
procedure PutPixel( DstSurface : PSDL_Surface; x,y : integer; _fgcolor : Dword );

procedure PlotPixelWNeighbors(x,y:integer);
procedure SaveBMPImage(filename:string);


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
}



{

ok..I think Ive figured out the whole GEtXY shit...SDL should track but doesnt.
BGI needs these "features"

so heres what we do:

on each putpixel call-update the CurrentPointer(CP).
on each rect call-update cp with wxh location
on each tri call(unless spun) its the bottommost right corner

etc
etc

If we track where were at based upon where we want to go be should be ok but...by default
we have no data.

I use:

currX
currY
where.X and where.Y
}

implementation

{

DO NOT BLINDLY ALLOW any function to be called arbitrarily.(this was done in C- I removed the checks)
If SDL engine isnt active- BAIL.

two exceptions:

making a 16 or 256 palette and/or modelist file

}


//this routine is very rough but may help
// from wikipedia
procedure RoughSteinbergDither(filename,filename2:string);
type
   imageArray =array[1..1280,1..1024] of DWord; //maximum 1080p or file x and y (image resolution) size?
//assumed here for now

var
	pixel:ImageArray;
	oldpixel,newpixel,quant_error:DWord;
	location:file;

begin
    assign(filename,location); 
  
    blockread(filename,sizeof(file));

  while Y<MaxY do begin
	 while x<MaxX do begin

      oldpixel  := pixel(x,y);
      newpixel  := round(oldpixel / 256);
      pixel(x,y)  := newpixel;
      quant_error  := oldpixel - newpixel;

      pixel(x + 1,y):= (pixel(x + 1,y) + quant_error * 7 / 16);
      pixel(x - 1,y + 1) := (pixel(x - 1,y + 1) + quant_error * 3 / 16);
      pixel(x,y + 1) := (pixel(x,y + 1) + quant_error * 5 / 16);
      pixel(x + 1,y + 1) := (pixel(x + 1,y + 1) + quant_error * 1 / 16);

    end;
   end;
     blockwrite(filename2,sizeof(file));
     close(filename);
	 close(filename2);
end;


{

Got weird fucked up c boolean evals? (JEEZ theyre a BITCH to understand....)
  wonky "what ? (eh vs uh) : something" ===>if (evaluation) then (= to this) else (equal to that)
(usually a boolean eval with a byte input- an overflow disaster waiting to happen)

}




//which surface do we lock/unlock??
//solve for X -by providing it.

procedure lock(MainSurface:^SDL_Surface);
begin
  if SDL_MUSTLOCK(MainSurface) then begin
    if SDL_LockSurface(MainSurface) < 0 then
          begin
          SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cannot lock screen surface.','BYE..',NIL);
          CloseGraph;
          end;
  end;
end;

procedure unlock(MainSurface:^SDL_Surface);

begin
  if SDL_MUSTLOCK(MainSurface) then 
    SDL_UnlockSurface(MainSurface);
  Tex:=CreateTextureFromSurface(MainSurface);
  RenderCopy(Renderer,Tex);
  SDL_FreeSurface(Tex); //alloc and not free bug if this isnt not here.
  RenderPresent;
end;

procedure timer_flip; //triggered by SDL timer according to screen refresh rate

begin
   if (not Paused) then begin //if paused then ignore screen updates
         SDL_RenderPresent(Renderer);  //SDL_Flip; ensures screen is updated if ever rendering between updates.
   end else exit;
   //else: do other stuff instead of updating the screen.
end;

//semi-generic color functions

function GetRGBfromIndex(index:byte):SDL_Color; 

var
   somecolor:SDL_Color;
   getThis:DWord;

begin
  if MaxColors =16 then
	  getThis:=palette16.DWords[index]; //literally get the dword from the index
  else if MaxColors=256 then
	  getThis:=palette256.DWords[index]; //literally get the dword from the index

  somecolor.R := getThis and $FF;
  somecolor.G := (getThis shr 8) and $FF;
  somecolor.B := (getThis shr 16) and $FF;
  somecolor.A:= $FF;
  GetRGBFromHex:=somecolor;
end;

//you already have the DWord- if you need to get it, call:
//DWord:=SDL_MapRGB(format,r, g,b);
//first

function GetRGBfromHex(Hex: DWord):SDL_Color; 

var
   somecolor:SDL_Color;

begin
  somecolor.R := Hex and $FF;
  somecolor.G := (Hex shr 8) and $FF;
  somecolor.B := (Hex shr 16) and $FF;
  somecolor.A:= $FF;
  GetRGBFromHex:=somecolor;
end;

//DWord:=SDL_MapRGBA(format,r, g,b,a);

function GetRGBAfromHex(Hex: DWord):SDL_Color; overload;

var
   somecolor:SDL_Color;

begin
  somecolor.R := Hex and $FF;
  somecolor.G := (Hex shr 8) and $FF;
  somecolor.B := (Hex shr 16) and $FF;
  somecolor.A:= (Hex shr 24) and $FF; 
  GetRGBAFromHex:=somecolor;
end;

//index to DWord

function ColorNumToHex(Color : byte) : DWord;
begin
//what number? larger modes dont have palette index numbers
   if (MaxColors >256) then exit;

   if MaxColors=256 then
	   ColorNumToHex:=palette256.dwords[color]; //its already hexed....go fetch the right one.
   else if MaxColors=16 then
	   ColorNumToHex:=palette16.dwords[color]; //its already hexed....go fetch the right one.		

end;

//DWord in - Index out
function ColorNumFromHex(input:DWord):integer;

var
	r,g,b:word;
    color:^SDL_Color;
     
    i:integer;

begin
  if (MaxColors >256) then exit; //index not available

  //FIXME: which format?? (16 colors is 4LSB iirc.)


  i:=0;
  color:=SDL_GetRGB(input,format,r,g,b); //Get the RGB color from the DWord given

	if MaxColors=256 then begin
		repeat
			if (color.r=palette256.colors[i].r) and (color.g=palette256.colors[i].g) and (color.b=palette256.colors[i].b) then begin
				ColorNumFromHex:=i;
				exit;
			end;
		    inc(i);
		until i=256;
   //no match found
   //exit

	end else if MaxColors=16 then begin
		repeat
  			if (color.r=palette16.colors[i].r) and (color.g=palette16.colors[i].g) and (color.b=palette16.colors[i].b) then begin
				ColorNumFromHex:=i;
				exit;
  			end;
  			inc(i);
		until i=16;
	end;
  //no match found
  //exit
end;

//DWord in - string out
function GetColorNameFromHex(input:dword):string;

var
	r,g,b:word;
    color:^SDL_Color;
     
    i:integer;

begin
  if (MaxColors >256) then exit; //I dunno what the name is...
  i:=0;

  color:=SDL_GetRGB(input,format,r,g,b); //Get the RGB color from the DWord given

  if MaxColors=256 then begin
	repeat
  		if (color.r=palette256.colors[i].r) and (color.g=palette256.colors[i].g) and (color.b=palette256.colors[i].b) then begin
			GetColorNameFromHex:=palette256.names[i];
			exit;
  		end;
  		inc(i);
	until i=256;
  //no match found
  //exit


  end else if MaxColors=16 then begin
	repeat
  		if (color.r=palette256.colors[i].r) and (color.g=palette256.colors[i].g) and (color.b=palette256.colors[i].b) then begin
			ColorNameFromHex:=palette16.names[i];
			exit;
  		end;
  		inc(i);
	until i=16;
  end;
  //no match found
  //exit

end;



//DWord in - SDL_Color(RGB) out

//only two of these are needed
//RGB is supported due to SDL quirks- technically.... (its funky)
//these arent just index colors- they do have RGB and RGBA data values

function GetRGBFromHex(input:DWord):SDL_Color;
var
	i:integer;
    somedata:^SDL_Color; 

begin

   if (MaxColors=256) then begin
	   i:=0;
	   while (i<256) do begin
		    if (palette256.dwords[i] = input) then //did we find a match?
	    	   GetRGBFromHex:=SDL_GetRGB(palette256.DWords[i]);
            else
				inc(i);  //no
       end;
	  //no match found
      //exit

   end else if (MaxColors=16) then begin
	    i:=0;
	    while (i<16) do begin

		    if (palette256.dwords[i] = input) then //did we find a match?
	    	   GetRGBFromHex:=SDL_GetRGB(palette16.DWords[i]);
            else
				inc(i);  //no
       end;


   end else begin //True color modes
	   SDL_GetRGB(input,MainSurface.format,somedata.r,somedata.g,somedata.b);
   	   GetRGBFromHex:=somedata;
   end;
end;

function GetRGBAFromHex(input:DWord):SDL_Color;
var
	i:integer;
    somedata:^SDL_Color; 

begin
//RGBA doesnt support paletted modes

//True color modes
	   SDL_GetRGBA(input,MainSurface.format,somedata.r,somedata.g,somedata.b,somedata.a);
   	   GetRGBFromHex:=somedata;
end;



//get the last color set

function GetFgRGB:^SDL_Color;
begin
	SDL_GetRenderDrawColor(renderer,r,g,b,255);
end;

function GetFgRGBA:^SDL_Color;
begin
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
end;

//give me the name(string) of the current fg or bg color (paletted modes only)

function GetFGName:string;

var
   i:integer;
   somecolor:^SDL_Color;
   someDWord:DWord;

begin
   i:=0;
   i:=GetFGColorIndex;
   if ((i> 256) or (i=0)) then begin

      If IsConsoleInvoked then
			Writeln('Cant Get color name from an RGB mode colors.');
	  //messagebox('Cant Get index from an RGB mode colors.');
	  exit;
   end;
   if MaxColors=256 then begin
	      GetFGName:=palette256.name[i];
		  exit;
   end else if MaxColors=16 then begin
	      GetFGName:=palette16.name[i];
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
   if ((i> 256) or (i=0)) then begin

      If IsConsoleInvoked then
			Writeln('Cant Get color name from an RGB mode colors.');
	  //messagebox('Cant Get index from an RGB mode colors.');
	  exit;
   end;
   if MaxColors=256 then begin
	      GetFGName:=palette256.name[i];
		  exit;
   end else if MaxColors=16 then begin
	      GetFGName:=palette16.name[i];
		  exit;
   end;	

end;


//returns the current color
//BG is the tricky part- we need to have set something previously.

function GetBGColorIndex:byte;

var
   i:integer;

begin
     i:=0;
     if MaxColors=16 then begin
        repeat
	        if Palette16.dwords[i]= _bgcolor then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;

     i:=0;
     if MaxColors=256 then begin
        repeat
	        if Palette256.dwords[i]= _bgcolor then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 else begin
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
   someColor:^SDL_Color; //UInt8 in C

begin
     SDL_GetRenderDrawColor(renderer,somecolor.r,somecolor.g,somecolor.b,255); //returns SDL color but we want a DWord of it

     i:=0;
     if MaxColors=16 then begin
        repeat
	        if ((Palette16.colors[i].r=somecolor.r) and (Palette16.colors[i].g=somecolor.g) and (Palette16.colors[i].b=somecolor.b))  then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;

     i:=0;
     if MaxColors=256 then begin
        repeat
	        if ((Palette256.colors[i].r=somecolor.r) and (Palette256.colors[i].g=somecolor.g) and (Palette256.colors[i].b=somecolor.b))  then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 else begin
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
	colorToSet:^SDL_Color;
    r,g,b:byte;
begin

   if MaxColors=256 then begin
        colorToSet:=GetRGBFromHex(palette256.dwords[color]);
        SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
   end else if MaxColors=16 then begin
		colorToSet:=GetRGBFromHex(palette16.dwords[color]);
        SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
   end;
   //else
   exit;
end;


//sets pen color to given dword.
procedure setFGColor(somecolor:dword); overload;
var
    r,g,b:byte;

begin

   setFontFore:=SDL_GetRGB(somecolor,MainSurface.format,r,g,b); //now gimmie the RGB pair of that color
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
   
end;

procedure setFGColor(r,g,b:word); overload;

begin
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
end;

procedure setFGColor(r,g,b,a:word); overload;

begin
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), ord(a)); 
end;



//sets background color based on index
procedure setBGColor(color:byte);
var
	colorToSet:^SDL_Color;
//if we dont store the value- we cant fetch it later on when we need it.
begin

    if MaxColors=256 then begin
        colorToSet:=GetRGBFromHex(palette256.dwords[color]);
        _bgcolor:=palette256.dwords[color]; //set here- fetch later
	    SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
	    SDL_RenderClear;
   end else if MaxColors=16 then begin 
		colorToSet:=GetRGBFromHex(palette16.dwords[color]);
        _bgcolor:=palette16.dwords[color]; //set here- fetch later
   	    SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
   	    SDL_RenderClear;
   end;
   //else
   exit;
   
end;

procedure setBGColor(somecolor:DWord); overload;
var
    r,g,b:byte;
	color:DWord;

begin
   color:=SDL_GetRGB(somecolor,MainSurface.format,r,g,b); //now gimmie the RGB pair of that color
   _bgcolor:=somecolor;
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
   SDL_RenderClear;
end;

procedure setBGColor(r,g,b:word); overload;

//bgcolor here and rgba *MAY* not match our palette..be advised.

begin
   _bgcolor:=SDL_MapRGB(format,r,g,b);
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
   SDL_RenderClear;
end;

procedure setBGColor(r,g,b,a:word); overload;

begin
   _bgcolor:=SDL_MapRGB(format,r,g,b,a);
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), ord(a)); 
   SDL_RenderClear;
end;


function ColorNameToNum(ColorName : string) : integer;
//from string to color number

var
	i:integer;

begin
  i:=0;

//gonna have to look and see if anything matches...

  if MaxColors=16 then begin
     while (i<16) do begin
        if (palette16.name[i]=ColorName) then begin
           ColorNameToNum:=i;
           exit;
        end;
        inc(i);
     end;

  end else if MaxColors=256 then begin
  while (i<256) do begin
     if (palette256.name[i]=ColorName) then begin
        ColorNameToNum:=i;
        exit;
     end;
     inc(i);
  end;

end;



//these two only:
//we locate the string and then find the value of it in the array.

procedure setColorFGByString(colorname:string); 
var
   somecolor:byte;
   somestring:string;
	i:byte;

begin

    if (MaxColors >256) then begin
		If IsConsoleInvoked then
			Writeln('Cant Set colors from an RGB mode colors.');
		//else
			//messagebox('Cant Get index from an RGB mode colors.');
       exit;
    end;
    
	if MaxColors=16 then begin
        i:=0;
		repeat
           if (palette16.names[i]=colorname) then
				   		SetFGColor(i); //set pencolor with index
		   inc(i);
				
		until i=15;
	    //else
        exit;
	end;

	else if MaxColors =256 then begin
        i:=0;
		repeat
           if (palette256.names[i]=colorname) then
				   		SetFGColor(i); //set pencolor with index
		   inc(i);
				
		until i=255;
	    //else
        exit;
	end;
   
end;	
 
procedure setColorBGByString(colorname:string); 

var
   somecolor:byte;
	i:integer;

begin

    if MaxColors >256 then begin
		If IsConsoleInvoked then
			Writeln('Cant Set colors from an RGB mode colors.');
		//else
			//messagebox('Cant Get index from an RGB mode colors.');
       exit;
    end;
    

	if MaxColors =16 then begin
        i:=0;
		repeat
           if (palette16.names[i]=colorname) then
				   		SetBGColor(i); //set pencolor with index
		   inc(i);
				
		until i=15;
	    //else
        exit;

    end	else if MaxColors =256 then
        i:=0;
		repeat
           if (palette256.names[i]=colorname) then
				   		SetBGColor(i); //set pencolor with index
		   inc(i);
				
		until i=255;
	    //else
        exit;

   end;
end;	


//gives you the DWord of the RGB Tuple last used
//does not return RGB SDL_Color Tuple

function GetFgDWordRGB:DWord;
begin
	SDL_GetRenderDrawColor(renderer,r,g,b);
    case bpp of
		4:format:=SDL_PIXELFORMAT_INDEX4LSB;
        8:format:=SDL_PIXELFORMAT_INDEX8;
        15:format:=SDL_PIXELFORMAT_RGB555;
        16:format:=SDL_PIXELFORMAT_RGBA4444;
        24:format:=SDL_PIXELFORMAT_RGB888;
   //     32:format:=SDL_PIXELFORMAT_RGBA8888;
    end;

    GetFGDWord:=MapRGBA(format,r,g,b,a); //gimmie the DWord instead
end;

function GetFgDWordRGBA:DWord;
begin
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    if (bpp < 8) then exit; //rgba not supported
    case bpp of
		4:format:=SDL_PIXELFORMAT_INDEX4LSB;
        8:format:=SDL_PIXELFORMAT_INDEX8;
        15:format:=SDL_PIXELFORMAT_RGB555;
        16:format:=SDL_PIXELFORMAT_RGBA4444;
        24:format:=SDL_PIXELFORMAT_RGB888;
   //     32:format:=SDL_PIXELFORMAT_RGBA8888;
    end;

    GetFGDWord:=MapRGBA(format,r,g,b,a); //gimmie the DWord instead
end;

//doesnt make sence w using _bgcolor as a DWord
//only makes sense if you are using RGB or RGBA "tuples" instead of a Dword but wanted a DWord.
//has a use but its limited.

function GetBgDWordRGB(r,g,b:byte):DWord;
begin
    case bpp of
		4:format:=SDL_PIXELFORMAT_INDEX4LSB;
        8:format:=SDL_PIXELFORMAT_INDEX8;
        15:format:=SDL_PIXELFORMAT_RGB555;
        16:format:=SDL_PIXELFORMAT_RGBA4444;
        24:format:=SDL_PIXELFORMAT_RGB888;
   //     32:format:=SDL_PIXELFORMAT_RGBA8888;
    end;
    
    GetBgDWordRGB:=MapRGB(format,r,g,b); //returns SDL RGB Tuple 
    
end;

function GetBgDWordRGBA(r,g,b,a:byte):DWord;
begin
    case bpp of
		4:format:=SDL_PIXELFORMAT_INDEX4LSB;
        8:format:=SDL_PIXELFORMAT_INDEX8;
        15:format:=SDL_PIXELFORMAT_RGB555;
        16:format:=SDL_PIXELFORMAT_RGBA4444;
        24:format:=SDL_PIXELFORMAT_RGB888;
   //     32:format:=SDL_PIXELFORMAT_RGBA8888;
    end;

    GetFGDWord:=MapRGBA(format,r,g,b,a); //gimmie the DWord instead
end;


//WIP
procedure Blink(Sometext:string);
//we need to be told when to stop
//and make sure our coordinates dont get overwridden

// or RenderClear sounds good( background refresh)...

//apple uses a font that blinks??? eh?
var
  HowWide:integer;

begin
  HowWide:=Length(Sometext); //so we know how much of the 'font' to erase-write-erase
  //fork() so we dont clam up the screen ops or input loop

  repeat
	  //the method- like backspace but the whole string we were given instead.
  	  //getxy()
//      OutTextXY(x,y,string);
//      delay(500);
      //clearLine
  until StopBlinking:=true; //set this and then clear the screen.
  //merge()
 
end;


//end color ops

procedure clearscreen; 

begin
	SDL_RenderClear;
end;


//this is off- wouldnt it make sense to STORE the BG color??
//UH HUH...silly me. see above for HOWTO.
procedure clearscreen(color:Dword); overload;

var
	r,g,b:byte;

begin
    SDL_GetRGB(color,format,r,g,b);
    SetPenColor(Renderer,ord(r),ord(g),ord(b),255);
	SDL_RenderClear;
end;


procedure clearscreen(r,g,b:byte); overload;


begin
	SetPenColor(Renderer,ord(r),ord(g),ord(b),255);
	SDL_RenderClear;
end;


procedure clearscreen(r,g,b,a:byte); overload;

begin
	SetPenColor(Renderer,ord(r),ord(g),ord(b),ord(a));
	SDL_RenderClear;
end;


//Im not sure if sprites (Bitmaps/Blits) can be removed this way or not.
// I know that making multiple surfaces can run out of vRAM quickly...


//this is for added-on "windows" without handles...not the whole screen.
procedure clearviewport(windownumber:smallint);
//clears it, doesnt remove or add a "layered window".
//usually the last viewport set..not necessary the whole "screen"
var
  viewport:^SDL_Rect;
  destcolor:longword;

begin
   viewpport.X:=TextRect[windownumber].x;
   viewpport.Y:=TextRect[windownumber].y;
   viewpport.W:=TextRect[windownumber].w;
   viewpport.H:=TextRect[windownumber].h;
   if MaxColors= 16 then
      destColor:=palette16.colors[_fgcolor];
   else if MaxColors=256 then
      destColor:=palette256.colors[_fgcolor];
   else if MaxColors>256 then begin
	   SDL_GetRenderDrawColor(renderer,r,g,b,a); //grab the last rgb pen color
       destcolor:=MapRGBA(format,r,g,b,a); //gimmie the DWord instead
  end;
  SDL_FillRect(MainSurface, viewport,destcolor);
  Tex2:=createTextureFromSurface(Mainsurface);
  RenderCopy(Renderer,Tex2);
  RenderPresent(Renderer);
end;



//do you want fullscreen or not? pathToDriver is obsolete..
procedure initgraph(graphdriver,graphmode:integer; pathToDriver:string; wantFullScreen:boolean);

var
	maxX,maxY,BitDepth,i,numdisplaymodes:integer;
    SDLFlags:^SDL_Surface.Flags;
	_initflag:PSDL_Flags; 
    iconpath:string;
 	flags:longword;
    imagesON,RamSize,_imgflags:integer;
	mode:^SDL_DisplayMode;
    
begin
  pathToDriver:='';  //unused- code compatibility
  iconpath:='./sdlbgi.bmp';



   //"usermode" must match available resolutions etc etc etc
   //this is why I removed all of that code..."define what exactly"??

  //until we get here, SDL isnt (or cant be) used.
  //attempt to trigger SDL...

  if WantsAudioToo then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER; 
  if WantsJoyPad then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_JOYSTICK;
  if WantsCDROM then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_CDROM;

  if ( SDL_Init(_initflag) < 0 ) then begin
     if IsConsoleInvoked then begin
        writeln('EPIC FAILURE: Unable to init SDL: ', SDL_GetError);
        Halt(0); //nothing setup...so dont un-set anything.
      end;
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt initialize SDL','BYE..',NIL);
      delay(1000); //~1sec
      halt(0);
  end;
 //usually we can get at least -here-

  if wantsFullIMGSupport then begin

    _imgflags:= IMG_INIT_JPG or IMG_INIT_PNG or IMG_INIT_TIF;
    //test support  	
    imagesON:=IMG_Init(_imgflags);

    //not critical, as we have bmp support but lacking very very bad...
    if((imagesON and _imgflags) != _imgflags) then begin
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

  if BitDepth=4 then initPalette16 else if BitDepth=8 then initpalette256; //ignor high color bpp, its not paletted.
  //setup the palette(s) (but only in modes 256 colors or less).

  LIBGRAPHICS_INIT:=true; 
  LIBGRAPHICS_ACTVE:=false; 

  SetGraphMode(graphdriver,Graphmode,wantFullScreen);

//no atexit handler needed, just call CloseGraph
//that was a nasty SDL surprise...


//If we got here- YAY!

{
not tested and a lot depends on this working
   
  thread:= SDL_CreateThread(IntHandler, "SDL_INP_Handler", NULL); //fork(IntHandler);
 
  if not (thread) then begin; //we didnt fork....
     if IsConsoleInvoked then begin
        writeln('EPIC FAILURE: SDL requires multiprocessing. I cant seem to fork. ');
        closegraph;
     end;
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'EPIC FAILURE: Cant init multiprocess. Its required.','BYE..',NIL);
      closegraph;
  end;
  threadID := SDL_GetThreadID(thread); //we will kil you eventually Mr.Bond....
   

if you can see the titlebar but crash or whatever..then we need some more checks...
SDL isnt complex to get going... most of the following is optional.
I just ran some additional checks.
}

//lets get the current refresh rate and set a screen timer to it.
// we cant fetch this from X11? sure we can.

//this is important later on..you will see w game development and physics(Y do you think yer using SDL?).


//(try to) get some non critical but important video timing info
  
  mode := ( SDL_PIXELFORMAT_UNKNOWN, 0, 0, 0, 0 );  //record
  //for physical screen 0 do..
  
  //attempting to probe VideoModeInfo block when (VESA) isnt initd results in issues....
  
  if(SDL_GetCurrentDisplayMode(0, mode) <> 0) then begin
    if IsInvokedConsole then begin
			writeln('Cant get current video mode info. Non-critical error.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cant get the data for the current mode.','OK',NIL);
  end;

  //dont refresh faster than the screen.
  if mode.refresh_rate => 0 then 
     flip_timer_id := SDL_AddTimer(displaymode.refresh_rate,^SDL_NewTimerCallback( @timer_flip ), nil ); 
  else //can we assume 60hz? (hertz to ms=16.66 ad nauseum)
     flip_timer_id := SDL_AddTimer(16.7,^SDL_NewTimerCallback( @timer_flip ), nil ); 
	 
  //sanity check 
  if not flip_timer_id then begin
    if IsInvokedConsole then begin
			writeln('WARNING: cannot set drawing to video refresh rate. Non-critical error.');
			writeln('you will have to manually update surfaces and the renderer.');
    end;

    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'WARNING: SDL cant set video callback timer.Manually update surface.','OK',NIL);
  end;


  CantDoAudio:=false;
    //prepare mixer
  if WantsAudioToo then begin
  	if Mix_OpenAudio( MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 4096 ) < 0 then begin
 		if IsInvokedConsole then begin
			writeln('OH-NO! The mixer cant be setup. All is silent...');
    	end;
		  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SDL Audio init error. Audio functions disabled.','OK',NIL);
		  CantDoAudio:=true;
  	end;
  end;

  
//set some sane default variables
  if (bpp <=8) then begin //assumes too much but the data is the same
		_fgcolor:=palette16.DWords[15];
		_bgcolor:=palette16.DWords[0];
  end;
  if MaxColors >256 then begin
	  _fgcolor := $FFFFFFFF;	//Default drawing color = white (15 or 255)
  	  _bgcolor := $000000FF;	//default background = black
  end;
//  linestyle:= Normal; 

  new(Event);
  LIBGRAPHICS_ACTIVE:=true;  //We are fully operational now.
  paused:=false;

  _graphResult:=0; //we can just check the dialogs (or text output) now.
  currX:=0;
  currY:=0;
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
  if WantsJoyToo then begin
 
    if( SDL_NumJoysticks < 1 ) then
	    writeln( 'Warning: No joysticks connected!' ); 
      else  //Load joystick 
      gGameController := SDL_JoystickOpen( 0 ); 
      if( gGameController = NiL ) then begin  
        writeln( 'Warning: Unable to open game controller! SDL Error: ', SDL_GetError); 
        noJoy:=true;
      end;
      noJoy:=false;
   end;

end; //initgraph
                    

procedure RendedRectangle(x,y,w,h,:integer);

var
	Rect1:SDL_Rect;

begin

        new( Rect1 );
        Rect1^.x := x; 
        Rect1^.y := y; 
        Rect1^.w := w; 
        Rect1^.h := h;

        SDL_RenderDrawRect( Renderer, Rect1 );
end;


procedure closegraph;
var
	status:integer;
//dont want to alloc and then not free...ghosts are not nice...
begin

  if wantsJoyToo then
    SDL_JoystickClose( gGameController ); 
  gGameController := Nil;


  if WantsAudioToo then begin
     Mix_FreeMusic( music );
     Mix_FreeChunk( sound );
     Mix_CloseAudio;
  end;
  free(TextFore);
  free(TextBack);
  TTF_CloseFont(ttfFont);
  TTF_Quit;
  //its possible that extended images are used also for font datas...
  if wantsFullIMGSupport then 
     IMG_Quit;

  //kill the redraw_timer and then the interrupt handler...
  
  if (flip_timer_id <> NULL) then SDL_RemoveTimer(flip_timer_id);
 
  //Kill child if it is alive. we know the pid since we assigned it(the OS really knows it better than us)

  //we dont want to wait because were stuck in a loop
  //we can however, trip the loop to exit...

  exitloop:=true;
  SDL_WaitThread(thread,status);

  waittimer :=3;
  repeat
     SDL_Delay(1000);  
     dec(waittimer);
  until waittime=0; //should be more than enough time to exit..
  SDL_KillThread(thread);

  dispose( Event );

  //free viewports
{
  x:=32
  repeat
	if (Textures[i]<>Nil) then
		SDL_DestroyTexture(Textures[i]);
    dec(x);
  until x:=1;
  
}

//Dont free whats not allocated in initgraph.
//routines should free what they allocate on exit.

//  SDL_DestroyTexture( Texture );
  SDL_FreeSurface( MainSurface );
  SDL_DestroyRenderer( Renderer );
  SDL_DestroyWindow ( Window );

  SDL_Quit; 
  LIBGRAPHICS_ACTIVE:=0;  //Unset the variable (and disable all of our other functions in the process)

  if IsConsoleInvoked then begin
     textcolor(7); //..reset standards...
     clrscr;
     writeln;
  end;
  //unless you want to mimic the last doom screen here...usually were done....
  halt(0); //nothing special, just bail gracefully.
end;            	 

function GetX:word;
begin
  x:=currX;
end;

function GetY:word;
begin
  y:=currY;
end;

function GetXY:where;
begin
   where.X:=currX;
   where.Y:=currY;
end;


procedure setgraphmode(graphmode:integer,wantfullscreen:boolean); 
//initgraph should call us to prevent code duplication
   
begin
//bail if not enabled already.

if (LIBGRAPHICS_INIT=false) then 

begin
		
		if IsConsoleEnabled then writeln('Call initgraph before calling setGraphMode.'); 
		else SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Called setGraphMode too early. Call InitGraph first.','OK',NIL);
	    exit;
end
else if (LIBGRAPHICS_INIT=true) and (LIBGRAPHICS_ACTIVE=false) then begin //setup- initgraph called us
//FIXME: match this to the include file

  case(graphmode) of //we can do fullscreen, but dont force it...
	     mCGA:
			MaxX:=320;
			MaxY:=240;
			BitDepth:=4; 
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:false;	
		end;

        //crt mode
		VGALo:
			MaxX:=320;
			MaxY:=200;
			BitDepth:=8; 
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:false;	
		end;

        //color tv mode
		VGAMed:
            MaxX:=320;
			MaxY:=240;
			BitDepth:=8; 
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:false;	
		end;

		//spec breaks here for Borlands VGA support(not much of a specification thx to SDL...)
		//this is the "default VGA minimum".....since your not running below it, dont ask to set FS in it...
        // if you did that you would have to scale the output...
		//(more werk???)

		VGAHi:
            MaxX:=640;
			MaxY:=480;
			BitDepth:=4; 
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:false;	
		end;

		VGAHix256:
            MaxX:=640;
			MaxY:=480;
			BitDepth:=8; 
			MaxColors:=256;
           NonPalette:=False;
		   TrueColor:false;	
		end;

		VGAHix32k: //im not used to these ones (15bits)
           MaxX:=640;
		   MaxY:=480;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		VGAHix64k:
           MaxX:=640;
		   MaxY:=480;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		//standardize these as much as possible....

		m800x600x16:
            MaxX:=800;
			MaxY:=600;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m800x600x256:
            MaxX:=800;
			MaxY:=600;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;


		m800x600x32k:
           MaxX:=800;
		   MaxY:=600;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m800x600x64k:
           MaxX:=800;
		   MaxY:=600;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1024x768x16:
            MaxX:=1024;
			MaxY:=768;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1024x768x256:
            MaxX:=1024;
			MaxY:=768;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1024x768x32k:
           MaxX:=1024;
		   MaxY:=768;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1024x768x64k:
           MaxX:=1024;
		   MaxY:=768;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x720x16:
            MaxX:=1280;
			MaxY:=720;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1280x720x256:
            MaxX:=1280;
			MaxY:=720;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1280x720x32k:
          MaxX:=1280;
		   MaxY:=720;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x720x64k:
           MaxX:=1280;
		   MaxY:=720;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x720xMil:
		   MaxX:=1280;
		   MaxY:=720;
		   BitDepth:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1280x1024x16:
            MaxX:=1280;
			MaxY:=1024;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1280x1024x256:
            MaxX:=1280;
			MaxY:=1024;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1280x1024x32k:
           MaxX:=1280;
		   MaxY:=1024;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x1024x64k:
           MaxX:=1280;
		   MaxY:=1024;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x1024xMil:
           MaxX:=1280;
		   MaxY:=1024;
		   BitDepth:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1280x1024xMil2:
           MaxX:=1280;
		   MaxY:=1024;
		   BitDepth:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:true;	
		end;

 	    m1366x768x16:
            MaxX:=1366;
			MaxY:=768;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1366x768x256:
            MaxX:=1366;
			MaxY:=768;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1366x768x32k:
           MaxX:=1366;
		   MaxY:=768;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1366x768x64k:
           MaxX:=1366;
		   MaxY:=768;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1366x768xMil:
           MaxX:=1366;
		   MaxY:=768;
		   BitDepth:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1366x768xMil2:
           MaxX:=1366;
		   MaxY:=768;
		   BitDepth:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1920x1080x16:
            MaxX:=1920;
			MaxY:=1080;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1920x1080x256:
            MaxX:=1920;
			MaxY:=1080;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1920x1080x32k:
		   MaxX:=1920;
		   MaxY:=1080;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1920x1080x64k:
		   MaxX:=1920;
		   MaxY:=1080;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1920x1080xMil:
 	       MaxX:=1920;
		   MaxY:=1080;
		   BitDepth:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1920x1080xMil2:
 	       MaxX:=1920;
		   MaxY:=1080;
		   BitDepth:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:true;	
		end;
	    
  end;{case}
	RendedWindow := SDL_CreateWindowAndRenderer(MaxX, MaxY,SDL_WINDOW_OPENGL, window,renderer);

	if ( RendedWindow = NULL ) then begin
        //try software first...

         //posX,PosY,sizeX,sizeY,physScreenNum
         window = SDL_CreateWindow('SDLBGI Application', SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, MaxX, MaxY, 0);
    	 if (window = NULL) then begin
 			if IsConsoleInvoked then begin
	    	   	writeln('Something Fishy. No hardware render support and cant create a window.');
	    	   	writeln('SDL reports: ',' ', SDL_GetError);      
	    	end;
	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy. No hardware render support and cant create a window.','BYE..',NIL);
			
			_graphResult:=-1;
	    	closegraph;
        end;

        //we have a window but are forced into SW rendering(why?)
    	renderer := SDL_CreateSoftwareRenderer(Mainsurface);
		if (renderer = NULL ) then begin
 			if IsConsoleInvoked then begin
	    	   	writeln('Something Fishy. No hardware render support and cant setup a software one.');
	    	   	writeln('SDL reports: ',' ', SDL_GetError);      
	    	end;
	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy. No hardware render support and cant setup a software one.','BYE..',NIL);
	    	_graphResult:=-1;
	    	closegraph;
		end;
   end; 
   //we have arenderer and HW window, but no surface yet
    SDL_WM_SetIcon (SDL_LoadBMP(iconpath), NULL);
    free (iconpath);
    SDL_WM_SetCaption('SDLBGI Application', 0);  // Set the default libgraph window caption
 


    //either way we should have a window and renderer by now...   
   if wantFullscreen then begin
       //I dont know about double buffers yet but this looks yuumy..
       //SDL_SetVideoMode(MaxX, MaxY, BitDepth, SDL_DOUBLEBUF|SDL_FULLSCREEN);

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

    Mainsurface = SDL_CreateRGBSurface(0, MaxX, MaxY, bpp, 0, 0, 0, 0);
    if (Mainsurface = NiL) then begin //cant create a surface
        SDL_Log('SDL_CreateRGBSurface failed: %s', SDL_GetError());
        libGraph:=-1; //probly out of vram
        //we can exit w failure codes, if we check for them
        halt(0);
    end;

  if (bpp<=8) then begin
      if MaxColors=16 then
			SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, TPalette16.colors, 0, 16 );
	  else if MaxColors=256 then
			SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, TPalette256.colors, 0, 256 );
  end;

   LIBGRAPHICS_ACTIVE:=true;
   exit; //back to initgraph we go.

end else if (LIBGRAPHICS_ACTIVE=true) then begin //good to go

  case(graphmode) of //we can do fullscreen, but dont force it...
	
		mCGA:
			MaxX:=320;
			MaxY:=240;
			BitDepth:=4;
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:false;	
		end;

        //crt mode
		VGALo:
			MaxX:=320;
			MaxY:=200;
			BitDepth:=8; 
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:false;	
		end;

        //color tv mode
		VGAMed:
            MaxX:=320;
			MaxY:=240;
			BitDepth:=8; 
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:false;	
		end;

		//spec breaks here for Borlands VGA support(not much of a specification thx to SDL...)
		//this is the "default VGA minimum".....since your not running below it, dont ask to set FS in it...
        // if you did that you would have to scale the output...
		//(more werk???)

		VGAHi:
            MaxX:=640;
			MaxY:=480;
			BitDepth:=4; 
			MaxColors:=16;
           NonPalette:=false;
		   TrueColor:false;	
		end;

		VGAHix256:
            MaxX:=640;
			MaxY:=480;
			BitDepth:=8; 
			MaxColors:=256;
           NonPalette:=False;
		   TrueColor:false;	
		end;

		VGAHix32k: //im not used to these ones (15bits)
           MaxX:=640;
		   MaxY:=480;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		VGAHix64k:
           MaxX:=640;
		   MaxY:=480;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		//standardize these as much as possible....

		m800x600x16:
            MaxX:=800;
			MaxY:=600;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m800x600x256:
            MaxX:=800;
			MaxY:=600;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;


		m800x600x32k:
           MaxX:=800;
		   MaxY:=600;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m800x600x64k:
           MaxX:=800;
		   MaxY:=600;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1024x768x16:
            MaxX:=1024;
			MaxY:=768;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1024x768x256:
            MaxX:=1024;
			MaxY:=768;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1024x768x32k:
           MaxX:=1024;
		   MaxY:=768;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1024x768x64k:
           MaxX:=1024;
		   MaxY:=768;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x720x16:
            MaxX:=1280;
			MaxY:=720;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1280x720x256:
            MaxX:=1280;
			MaxY:=720;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1280x720x32k:
          MaxX:=1280;
		   MaxY:=720;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x720x64k:
           MaxX:=1280;
		   MaxY:=720;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x720xMil:
		   MaxX:=1280;
		   MaxY:=720;
		   BitDepth:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1280x1024x16:
            MaxX:=1280;
			MaxY:=1024;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1280x1024x256:
            MaxX:=1280;
			MaxY:=1024;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1280x1024x32k:
           MaxX:=1280;
		   MaxY:=1024;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x1024x64k:
           MaxX:=1280;
		   MaxY:=1024;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1280x1024xMil:
           MaxX:=1280;
		   MaxY:=1024;
		   BitDepth:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1280x1024xMil2:
           MaxX:=1280;
		   MaxY:=1024;
		   BitDepth:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:true;	
		end;

 	    m1366x768x16:
            MaxX:=1366;
			MaxY:=768;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1366x768x256:
            MaxX:=1366;
			MaxY:=768;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1366x768x32k:
           MaxX:=1366;
		   MaxY:=768;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1366x768x64k:
           MaxX:=1366;
		   MaxY:=768;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1366x768xMil:
           MaxX:=1366;
		   MaxY:=768;
		   BitDepth:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1366x768xMil2:
           MaxX:=1366;
		   MaxY:=768;
		   BitDepth:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1920x1080x16:
            MaxX:=1920;
			MaxY:=1080;
			BitDepth:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1920x1080x256:
            MaxX:=1920;
			MaxY:=1080;
			BitDepth:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:false;	
		end;

		m1920x1080x32k:
		   MaxX:=1920;
		   MaxY:=1080;
		   BitDepth:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1920x1080x64k:
		   MaxX:=1920;
		   MaxY:=1080;
		   BitDepth:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:false;	
		end;

		m1920x1080xMil:
 	       MaxX:=1920;
		   MaxY:=1080;
		   BitDepth:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:true;	
		end;

		m1920x1080xMil2:
 	       MaxX:=1920;
		   MaxY:=1080;
		   BitDepth:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:true;	
		end;
	    
  end;{case}

                   
    if wantFullscreen then begin

        case BitDepth of
		  4: mode.format:=
		  8:
          15:
		  16:
		  24:      
        end;

        mode.x:=MaxX;
		mode.y:=MaxY;
		mode.refresh_rate:=60; //assumed
		mode.driverdata:=0;

		success:=SDL_SetWindowDisplayMode(window,mode);
        if success (<> 0) then begin 
			//cant do it, sorry.

 
    //either way we should have a window and renderer by now...   
   if wantFullscreen then begin
       //I dont know about double buffers yet but this looks yuumy..
       //SDL_SetVideoMode(MaxX, MaxY, BitDepth, SDL_DOUBLEBUF|SDL_FULLSCREEN);

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
    Init16Palette;
  if bpp=8 then 
    Init256Palette; 
  //then set it back up
  if (bpp<=8) then begin
      if MaxColors=16 then
			SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, TPalette16.colors, 0, 16 );
	  else if MaxColors=256 then
			SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, TPalette256.colors, 0, 256 );
  end;

     clearviewscreen;
end;

function getgraphmode:string; 

var
	thisMode:^SDL_DisplayMode;
    bppstring:string;
    format:^SDL_PixelFormat;
    MaxModes:;
begin
   if LIBGRAPHICS_ACTIVE then begin 
        format:=MainSurface.format; 
		findbpp:=format.BitsPerPixel; //4,8,15,16,24,32
        SDL_GetCurrentDisplayMode(0, thismode); //go get w,h,format and refresh rate..
		
//format should give you a clue as to what bpp you are in.

        findX:=thismode.X;
		findY:=thismode.Y;
		x:=0;
        //we need to find X,Y,BPP in the modelist somehow...
		repeat //repeat until we run out of modes. we should hit something..
			if (findX=MaxX) and (findY=MaxY) and (findbpp=BitDepth) then begin		
					getgraphmode:=Modelist.modename[x];
					exit;
				end;
			inc(x);
		until x=32;

   end;   
end;    

procedure restorecrtmode; //wrapped closegraph function
begin
  if (not LIBGRAPHICS_ACTIVE) then  //if not in use, then dont call me...

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
     getMaxX:=(MainSurface.w - 1); 
end;

function getmaxY:word;
begin
   if LIBGRAPHICS_ACTIVE then
     GetMaxY:=(MainSurface.h - 1); 
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

// SDL_BlitSurface(NewLayer, NULL,MainSurface,NULL);


//procedure HowBlit(currentwriteMode);
//this can do some whacky tricks too...we are applying a color shift mask to the incoming blit or mini surface...

}

//ideally call before any putPixel incase we want whacky tricks..
procedure HowPutPixel(X,Y: integer; var Writemode:currentWriteMode);

begin

    //_fgcolor is a  DWord

    //needs more putPixel(x,y,_fgcolor) for 15bpp plus modes
    case WriteMode of
      XORPut:
        begin
          _fgColor := _fgcolor Xor _fgColor;
		  if MaxColors =16 then
		     SDL_PutPixel(X,Y,palette16.dwords[_fgcolor]);
		  if MaxColors =256 then
		     SDL_PutPixel(X,Y,palette256.dwords[_fgcolor]);
        end;
      OrPut:
        begin
          _fgColor := _fgcolor Or _fgColor;
	 	  if MaxColors =16 then
		    SDL_PutPixel(X,Y,palette16.dwords[_fgcolor]);
		  if MaxColors =256 then
		    SDL_PutPixel(X,Y,palette256.dwords[_fgcolor]);
        end;
      AndPut:
        begin
          _fgColor := _fgColor And _fgColor;
		  if MaxColors =16 then
		     SDL_PutPixel(X,Y,palette16.dwords[_fgcolor]);
		  if MaxColors =256 then
		     SDL_PutPixel(X,Y,palette256.dwords[_fgcolor]);
        end;
      NotPut: //yes, the inverse of grey is gray...lol
        //usually for erasing but not always....
        begin
	      _fgColor := MapRGB((MaxColors-r),(MaxColors-g),(MaxColors-b));
		if MaxColors =16 then
		  SDL_PutPixel(X,Y,palette16.dwords[_fgcolor]);
		if MaxColors =256 then
		  SDL_PutPixel(X,Y,palette256.dwords[_fgcolor]);
      end
      Straight: begin
		if MaxColors =16 then
			SDL_PutPixel(X,Y,palette16.dwords[_fgcolor]);

		else if MaxColors=256 then
			SDL_PutPixel(X,Y,palette256.dwords[_fgcolor]);
	 end;
   end; //case

end;

{

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
  TempSurface:^SDL_Surface;
  bpp:byte;
  p:^Uint8; //word or byte pointer
  GotColor:^SDL_Color;
  pewpew:longword; //DWord....
  pointpew:PtrUInt;

begin
	rect^.x:=x;
    rect^.y:=y;
	rect^.h:=1;
	rect^.w:=1;
    case bpp of
		8: begin
			    if maxColors:=256 then format:=SDL_PIXELFORMAT_INDEX8;
				else if maxColors:=16 then format:=SDL_PIXELFORMAT_INDEX4LSB; //msb??
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;
		16: format:=SDL_PIXELFORMAT_RGBA4444;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;


    //(we do this backwards....rendered to surface of the size of 1 pixel)
    if ((MaxColors=256) or (MaxColors=16)) then TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 8, format); 
    //its weird...get 4bit indexed colors list in longword format but force me into 256 color mode???

    else begin
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


    SDL_RenderReadPixels(renderer, rect, TempSurface.format, TempSurface.pixels, TempSurface.pitch);
    //read a 1x1 rectangle....
    
    bpp := TempSurface.format.BytesPerPixel /8; //8..16..32....so divide by 8.
    // Here p is the address to the pixel we want to retrieve
    
    p:= TempSurface.pixels + y * TempSurface.pitch + x * bpp ;

    case (bpp) of 
       1: //256 colors
        //now take the longword output 
        GetPixel:=SDL_GetRGBA(p, TempSurface.format, GotColor.r, GotColor.g, GotColor.b, GotColor.a);
        
      2: //16bit
        GetPixel:=SDL_GetRGBA(Longint(p), TempSurface.format, GotColor.r, GotColor.g, GotColor.b, GotColor.a);
        
      3://24bit
        if(SDL_BYTEORDER = SDL_BIG_ENDIAN) then
            pewpew:=(p[0] shl 16 or p[1] shl 8 or p[2]);
            GetPixel:=SDL_GetRGBA(pewpew, TempSurface.format, GotColor.r, GotColor.g, GotColor.b, GotColor.a);

        else (SDL_BYTEORDER = SDL_SMALL_ENDIAN) then
            pewpew:=(p[0] or p[1] shl 8 or p[2] shl 16);
            GetPixel:=SDL_GetRGBA(pewpew, TempSurface.format, GotColor.r, GotColor.g, GotColor.b, GotColor.a);

      4: //32bit
        pointpew:=p;
        GetPixel:=SDL_GetRGBA(pointpew, TempSurface.format, GotColor.r, GotColor.g, GotColor.b, GotColor.a);
        
      else:
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get Pixel values...','OK',NIL);
       
    end; //case

    SDL_FreeSurface(Tempsurface);
    
end;


Procedure PutPixel(Renderer:^SDL_Renderer; x,y:Word);

var
  someDWord:DWord;


begin
//set renderDrawPoint (putPixel) uses fgcolor set with SDL_SEtPenColor or similar


  case bpp of

		4: begin
            format:=SDL_PIXELFORMAT_INDEX4LSB;
            SDL_RenderDrawPoint( Renderer, X, Y );
        end;
        8: begin
            format:=SDL_PIXELFORMAT_INDEX8;
            SDL_RenderDrawPoint( Renderer, X, Y );
        end;
        15: begin

		     format:=SDL_PIXELFORMAT_RGB555;
			 SDL_RenderDrawPoint( Renderer, X, Y );

		end;
        16: format:=SDL_PIXELFORMAT_RGBA4444;
        24: format:=SDL_PIXELFORMAT_RGB888;
        32: format:=SDL_PIXELFORMAT_RGBA8888;
 
  end else begin
    		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Put Pixel values...','OK',NIL);
			exit;
  end;
  SDL_RenderDrawPoint( Renderer, X, Y );
end;


procedure Line(renderer1:^SDL_Renderer; X1, Y1, X2, Y2: word; LineStyle:Linestyles);

var
   x:integer;
   HexColor:Dword;
   rgbColor:^SDL_Color;
   r,g,b,a:byte;
   returnvalue:longword;

begin

  if LineStyle=normalLine then begin //this is the skinny line...
      case bpp of
		8:begin
{	  	   	if MaxColors =16 then
		    	   SDL_SetRenderDrawColor(renderer, palette16.colors[_fgcolor].r,palette16.colors[_fgcolor].g,palette16.colors[_fgcolor].b,$ff);
    	    else if MaxColors =256 then
				   SDL_SetRenderDrawColor(renderer, palette256.colors[_fgcolor].r,palette256.colors[_fgcolor].g,palette256.colors[_fgcolor].b,$ff);
 }   	    SDL_RenderDrawLine(renderer,x1, y1, x2, y2);   
  		    exit;
		end;
       15:begin

	{		GetRGB(HexColor,format,rgbColor.r,rgbColor.g,rgbColor.b);
			SDL_SetRenderDrawColor(renderer, r, g, b, $FF);
     }  		SDL_RenderDrawLine(renderer,x1, y1, x2, y2); 
	   
       end;
       16,24,32:begin

		{	GetRGBA(HexColor,format,rgbColor.r,rgbColor.g,rgbColor.b,rgbColor.a);
			SDL_SetRenderDrawColor(renderer, r, g, b, a);
      } 		SDL_RenderDrawLine(renderer,x1, y1, x2, y2); 
	   end;
 
  end 
  else if LineStyle=ThickLine or LineStyle=VeryThickLine then begin

  //this gets weird...its like drawing many lines but all at the same time...
  //as is "this" so above and below....

  	//ThickLine=3
  	//VeryThickLine=6
  	x:=1;
  	repeat {
		 case bpp of

			15:begin
		         SDL_SetRenderDrawColor(renderer, r, g, b, $FF);
			end;
			16,24,32:begin
		         SDL_SetRenderDrawColor(renderer, r, g, b, a);	
			end;

         end:
         SDL_SetRenderDrawColor(renderer, r, g, b, $FF);}
		 //draw one side
         SDL_RenderDrawLine(renderer,x1, y1-1, x2, y2-1); 	
 
    	 //the original line, untouched.  
		SDL_RenderDrawLine(renderer,x1, y1, x2, y2); 

		//the other side of the thick line
		SDL_RenderDrawLine(renderer,x1, y1+1, x2, y2+1); 

    	 inc(x);
  	until x=LineStyle;
  SDL_RenderPresent(renderer);
  end;
end;



procedure Rectangle(x,y,w,h,:integer);
//fill rectagle starting at x,y to w,h
//rectangle should already be defined..

begin

    new(Rect);
	rect.x:=x;
    rect.y:=y;
    rect.w:=w;
    rect.h:=h;
	SDL_RenderDrawRect(renderer, rect);
    SDL_RenderPresent(renderer);

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
end;


function getdrivername:string;
begin
//not really used anymore-this isnt dos


   getdrivername:='X11Unix.bgi'; //be a smartASS
end;



Function detectGraph:boolean; //:ModeList??

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
            
            MaxModeSupported.strings:=modeList.Modename[i]; //string
            MaxModeSupported.num:=i; //the mode number
	        MaxModeSupported.x:=modelist.MaxX[i];
	        MaxModeSupported.y:=modelist.MaxY[i];
	        MaxModeSupported.bpp:=modelist.bpp[i];
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
	MaxModeSupported.strings:=modeList.Modename[i]; //string
	MaxModeSupported.num:=i; //integer
	MaxModeSupported.x:=modelist.MaxX[i];
	MaxModeSupported.y:=modelist.MaxY[i];
	MaxModeSupported.bpp:=modelist.bpp[i];
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

{
followng code is from FPC graphics unit(mostly sane code)

AUTHORS:                                              
   Gernot Tenchio      - original version              
   Florian Klaempfl    - major updates                 
   Pierre Mueller      - major bugfixes                
   Carl Eric Codere    - complete rewrite              
   Thomas Schatzl      - optimizations,routines and    
                           suggestions.                
   Jonas Maebe         - bugfixes and optimizations    

}


function Long2String(l: longint): string;
begin
  str(l, strf)
end;


//Test SDL logging functions... this is to disk.

//logChar is pointless..
Procedure FileLogString(s: String);
Begin
//dont open a file if its already opened and why open/close repeatedly?
  if LoggingJustStarted then  Append(debuglog);

  if IsConsoleInvoked then
     write(s);
  Write(debuglog, s);
  if donelogging then Close(debuglog);
End;

Procedure FileLogLn(s: string);
Begin
  if LoggingJustStarted then  Append(debuglog);
  if IsConsoleInvoked then
     writeln(s);
  Writeln(debuglog,s);
  if donelogging then Close(debuglog);
End;
{ end fpc code }

function cloneSurface(surface1:SDL_Surface):SDL_Surface;
//i'll take the surface to the copy machine...
var
   surface2:^SDL_Surface;

begin
    Surface2 := SDL_ConvertSurface(Surface1, Surface1.format, Surface1.flags);

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
   RenderCopy(Texture[windowcount]);
   RenderPresent;
   
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
        RenderPresent;
		SDL_RenderSetViewport( Renderer, LastRect ); 
        RemoveViewPort:=LastRect;      
   end; 
   //else: last window remaining
   SDL_DestroyTexture(Texture[1]);
   SDL_RenderSetViewport( Renderer,NULL);  //reset to full size "screen"
   RenderCopy(Texture[0]);
   RenderPresent; //and update back to the old screen before the viewports came here.
   LastRect:=(0,0,MaxX,MaxY);
   RemoveViewPort:=LastRect;;
end;


procedure Line(x1,y1,x2,y2:integer);
//surface
var
   x:integer;

begin

//createSurface
  if LineStyle=normalLine then begin //this is the skinny line...
 	 SDL_DrawLine( MainSurface,x1, y1, x2, y2, _fgcolor);
	 Tex:=createTextureFromSurface(Mainsurface);
  	 RenderCopy(Renderer,Tex);
     RenderPresent(Renderer);
  	 exit;
  end; 

//this gets weird...its like drawing many lines but all at the same time...

    //the original line, untouched.
    SDL_DrawLine( MainSurface,x1, y1, x2, y2, _fgcolor);

  	i:=1;
  	repeat 
    	 SDL_DrawLine( MainSurface,x1, y1-i, x2, y2-i, _fgcolor);
    	 SDL_DrawLine( MainSurface,x1, y1+i, x2, y2+i, _fgcolor);
    	 inc(i);
  	until x=LineStyle;

  Tex:=createTextureFromSurface(Mainsurface);
  RenderCopy(Renderer,Tex);
  RenderPresent(Renderer);

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

//yes we can do other than BMP...this is a start.
//JPEG and PNG and GIF are here- lets do each in its own routine.

procedure LoadExtendedImage(filename:string; Rect:^SDL_Rect);
//I need to know what size you want the imported image, and where you want it.

var
  Newsurface:^SDL_surface;
  tex:^SDL_Texture;

begin

    surface:= NiL;
    surface := IMG_Load(filename); //Works with PNG images and more...
 
    //Filling texture with the image using a surface
    tex := SDL_CreateTextureFromSurface(renderer, temp); //this is an unchecked function

    SDL_FreeSurface(surface);

    SDL_RenderCopy(renderer, texture, Nil, rect);
    SDL_RenderPresent(renderer);
//SDL_FreeTexture(Tex);
end;

procedure LoadBMPImage(filename:string Rect:^SDL_Rect);
//loadBMP is SDL v1.2..

var
  Newsurface:^SDL_surface;
  NewTex:^SDL_Texture;

begin
// if IsGameEngine then  paused:=true;
   NewSurface:=SDL_LoadBMP(filename);
   NewTex:=SDL_CreateTexFromSurface(renderer,NewSurface);

    SDL_FreeSurface(surface);

    SDL_RenderCopy(renderer, texture, Nil, rect);
    SDL_RenderPresent(renderer);
//SDL_FreeTexture(Tex);
end;

//saving PNG is weird, requires extra headers for 8bit images.
//the other two can be implemented but arent yet.

procedure PlotPixelWNeighbors(x,y:integer);
//this makes the bigger dots 
// (in other words blocky bullet holes...)  
begin                
   //more efficient to render a 3x3 Rect.
   //Now add two to make a 3 pixel rectangle.
   New(Rect);
   Rect.x:=x;
   Rect.y:=y;
   Rect.w:=3;
   Rect.h:=3;
   SDL_RenderFillRect(renderer, rect);
   SDL_RenderPresent(renderer);
   Free(Rect);
   //now restore x and y
   x:=x+2;
   y:=y+2;   
end;


procedure SaveBMPImage(filename:string);
//ansi string?
var
  Newsurface:^SDL_surface;

begin
//the downside is that upon ea sdl init for our app/game..this resets.

  filename:='screenshot'+int2str(screenshots)+'.bmp';
  //screenshotXXXXX.BMP
  //formulate a name and then use it. Therefore we get called as a one-off by the event handler code.
  NewSurface:=NewSurfaceFromRenderer;
  SDL_SaveBMP( NewSurface, filename);
  FreeSurface(NewSurface);
  inc(Screenshots);
end;



begin  //main()

IsConsole:=true;

//theres no X11 on windows.

{$ifdef unix}

//and in console(tty)
  if GetEnvironmentVariable('DISPLAY') = Nil then begin

//might fail under Quartz on MacOS. (There are ways to load X11....)
    
    writeln('Incorrectly called. SDL NEEDS X11 but X11 was never started.');
    writeln('OpenGL isnt available until X11 Core loads.');
    PressAnyKey; //crtstuff routine
    halt(0);
  end;

//while I dont like the assumption that all linux apps are console apps- unless invoked w LCL
//we are in a console(xterm, etc). I dont see the need for the LCL with SDL/OGL but anyways...

//if LCL then EnableLogging; --be quiet
  {$IFDEF LCL}
        QuietlyLog:=true;
        IsConsoleEnabled:=false;
  {$endif}

{$ENDIF}

{$IFDEF NOCONSOLE}
    IsConsoleEnabled:=false; //GUI APP
    QuietlyLog:=true;

{$ENDIF}

// per pixel blit ops are slow as hell-too many ppixel ops going on - usually to care, and there is faster ways.
//see T and L demos for an example- Im not there yet, but others have gotten there.

//you invert a bitmap inside a bitmap or a section of the screen- is how the trick is pulled off.

end.
