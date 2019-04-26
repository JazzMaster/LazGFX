Unit LazGFX;

//now officially "a MESS v4...." DONT EVEN ASK ABOUT COMPILING while SDL code is here.

//Range and overflow checks =ON
{$Q+}
{$R+}

{$IFDEF debug}
//memory tracing only.
	{$S+}
{$ENDIF}

{
A "fully creative rewrite" of the "Borland Graphic Interface" (c) 2017 (and beyond) by Richard Jasmin
-with the assistance of others.

This code **should** port or crossplatform build, but no guarantees.
SEMI-"Borland compatible" w modifications.

Lazarus graphics unit is severely lacking...use this instead.


Only OPEN/free units and code will ever be used or linked to here.
Only cross-platform methods will be used.

IN NO WAY SHAPE OR FORM are proprietary functions to be added here.
	You may use them if you wish- but the result is non-portable. (more headache for ewe)

I dont care what you use the source code for.
	I would prefer- however-
		THAT YOU STICK TO FPC/LAZARUS.

You must cite original authors and sub authors, as appropriate(standard attribution rules).
DO NOT CLAIM THIS CODE AS YOUR OWN and you MAY NOT remove this notice.


Although designed "for games programming"..the integration involved by the USE, ABUSE, and REUSE-
of SDL and X11Core/WinAPI(GDI)/Cairo(GTK/GDK)/OpenGL/DirectX highlights so many OS internals its not even funny.

GL by itself doesnt require X11- but it does require some X11 code for "input processing".
This is moot point with libPTC.

-It is Linux that is the complex BEAST that needs taming.
	Everyone seem to be writing in proprietary windowsGL, DirectX,etc.

}

interface

{
-DONT RUN A LIBRARY..link to it.
-Anonymous C kernel dev (that runs a library)

This is not -and never will be- your program. Sorry, Jim.
RELEASES are stable builds and nothing else is guaranteed.

The quote that never was-

"Linus: Dont tell me what to do.
I write CODE for a living.
Everything is mutable."


We output to Surface/Texture (buffer/video buffer) usually via memcopy operations.


For framebuffer:
	
For now- we settle for a Doom like experience.
	We start in text mode
		We switch to graphics mode and do something (catch all crashes)
	We drop back to text mode

Im still looking at Quartz seperately. OSX is funky in this regards.	
90% of the routines in the CORE of this unit(not sub units) are setup/destroy of needed structures.

The main unit is aux routines and init/closegraph mostly.
Most of the meat and po-tae-toes are in the aux units.

Canvas ops are "mostly universal".
The differences in code are where the surface(Canvas) operations point to and color operations supported.

 (a surface is a surface is a surface)
	-For that matter:
			(A texture is a texture is a texture)

---
INVOKATION:

There are two ways to invoke this unit-
1- with GUI and Lazarus

	Project-> Application (kiss writeln() and readln() goodbye)

2- as a Console Application(NO GUI)

In Lazarus:

	Project-> Console App or
	Project-> Program

Set Run Parameters:
	"Use Launcher" -to enable runwait.sh and console output (otherwise you might not see it)
	-This was the old school "compiler output window" in DOS Days.


Within FP application itself(FP IDE):

	-Just dont "uses" anything LCL or related.
	-Write the code normally
	-Check the output window

**This method offers Readln() / writeln()

**THIS CODE WILL CHECK WHICH COMPILE METHOD IS USED and log accordingly.**

---

You need to know:

        event-driven input and rendering loops (forget the console and ReadKEY)

---

CIRCLES vs ELLIPSE:

The difference between an ellipse and a circle is that "an ellipse is corrected for the aspect ratio".
	Circles are "squarely PIE"- or have equal slices of the pie.(Like a rectangle)
	Ellipses do not necessarily- they could be tall, or wide- as well.

FONTS:
	Theres two ways to do this

	Old school butmap (glyph based- mipmap)
	New school OpenTTF (lacking support)

	There is limited Font support thru freeGLUT/GLUT.
	I am looking into a solution thru some Lazrus code.

BPP/depth:
It can be assumed that:
	The programmer knows what depth we are in
	At the very least -the current set video mode- has a depth
	

Note the HALF-LIFE/POSTAL implementation of SDL(steam):

    start with a window
    set window to FS (hide the window)
    draw to sdl buffer offscreen and/or blit(invisible rendering)
    pageFlip/renderPresent  (making content visible)

-this IS the proper workflow.


Most Games use transparency(PNG) for "invisible background" effects.
-While this is true, however, BMPs can also be used w "colorkey values".

-for example:

SDL_BlitSurface (srcSurface,srcrect,dstSurface,dstrect);
SDL_SetColorKey(Mainsurface,SDL_TRUE,DWord);

-Where DWord is the color for the colorkey(greenscreen effect)


Compressed textures use weird bitpacking methods to store data- both on disk, and in VRAM.
These are not compress image formats- the video card cannot understand those.

PNG can be quantized-
	Quantization is not compression-
		its downgrading the color sheme used in storing the color
		and then compensating for it by dithering.(Some 3D math algorithms are used.)
	(Beyond the scope of this code)

PNG itself may or may not work as intended with a black color as a "hole".This is a known SDL issue.

PALETTES:
Not all games use a full 256-color (64x64) palette, even today.

This is even noted in SkyLander games lately with Activision.
"Bright happy cheery" Games use colors that are often "limited palettes" in use.

Most older games clear either VRAM or RAM while running (cheat) to accomplish most effects.
Most FADE TO BLACK arent just visuals, they clear VRAM in the process.

Fading is easy- taking away and adding color---not so much.
However- its not impossible.

    you need two palettes for each color  :-)  and you need to step the colors used between the two values
    switching all colors (or each individual color) straight to grey wont work- the entire image would go grey.
    you want gracefully delayed steps(and block user input while doing it) over the course of nano-seconds.

Modes:

I havent added in Android or MacOS modes yet.
You cant support portable Apple devices.
		Apple forbids it w FPC.

---

MessageBox:

With Working messageBox(es) we dont need the console.
You can choose the color scheme and input methods- YES/NO, OK...

Lazarus Dialogs are only substituted IF LCL is loaded.
(TVision routines wouldnt make sense in graphics modes-
	you may use GVision routines instead)

GVision requires Graphics modes(provided here) and TVision code "be left around".
FPC team is refusing to fix TVision bugs.

        This is wrong.

LOGS:

Some idiot wrote the logging  code wrong and it needs to be updated for FILE STREAM IO.
I havent done this yet.
(Call me lazy or just not up "streaming Lazarus")

	You should log something.


animations:
	to animate-
		screen savers, etc...you need to (page)flip/rendercopy and slow down rendering timers.
		(trust me, this works-Ive written some soon-to-be-here demos)
		The biggest issue becomes OVER RENDERING.

bounds:
   cap pixels at viewport
   (zoom in or out of a bitmap- but dont exceed bounds.)


on 2d games...you are effectively preloading the fore and aft areas on the 'level' like mario.


Palettes:

   CGA
   EGA
   VGA
 
   These are mostly standardized now.
   Max colors in a palette are always 256, CGA modes 16, EGA (16 of 64).
   EGA is commonly mistaken for CGA due to the higher resolution.

  Data is a packed Record (4 byte aligned)

  Note "the holes" can be used for overlay areas onscreen when stacking layers.
  The holes are standardized to xterm specs. I think theres like 5 (for VGA mode).

  Im seeing a Ton of correlation between OGL/SDL and DirectX/DirectDraw (and people think there isnt any).


WONTFIX:

"Rendering onto more than one window (or renderer) can cause issues"
"You must render in the same window that handles input"

("depth" in OGL is considered cubic depth (think layers of felt) , not bpp)


--Jazz
(comments -and code- by me unless otherwise noted)


TODO:

	Get some framebuffer fallback code working and put it here.	
	
}


uses

{
Threading(required):

Requires baseunix unit:

cthreads has to be the first unit -in this case-
	we so happen to support the C version natively.

}

//this Logic is weirdly (prove a negative) here.
//while you cant prove a negative- you can "not prove" a positive

//cthreads and cmem have to be first.
{$IFDEF unix}
	cthreads,cmem,baseunix, X, XLib,sysUtils,

//you need to tell me- if you need fallback APIs.
//in most cases, you wont need them.

	 {$IFNDEF fallback} //fallback uses FrameBuffer only code(slow), otherwise keep loading libs
		Classes,GL,GLext, GLU,
		//probly cairo and pango too at this point.
	 {$ENDIF}
{$ENDIF}

//ctypes: cint,uint,PTRUint,PTR-usINT,sint...etc.
//unless you want to rewrite someone elses C, use this.

    ctypes,

//This logic is normal
{$IFDEF MSWINDOWS} //as if theres a non-MS WINDOWS?
     Windows,
//delphiGL
	 {$IFDEF fallback}
		WinGraph, //WinAPI-needs rework
	 {$endif}

     {$IFNDEF LCL} //conio apps only
		crt,crtstuff,
     {$ENDIF}
{$ENDIF}

// A hackish trick...test if LCL unit(s) are loaded or linked in, then adjust.
//Most likely youre using one of these.

//LCL(Lazarus) wont fire unless Windows or X11 or Darwin(Quartz) are active.
//its such BS that framebuffer/XTerm routines were never written and everyone assumes X11
//is fired instead.

{

messageDlg requires a result (if x=y, then..) 	


function AskMessagewButtonAnswer(title,question:string):Longint;
begin
  AskMessagewButtonAnswer:=longint(MessageDlg(title, question, mtConfirmation, [mbYes, mbNo,mbMaybe, mbRepeatTheQuestion],0));
end;

(asking for strings and passwords is also possible)


}

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

    {$IFDEF unix}

      //LCL is linked in but we are not in windows.
      //remember Lazarus by itself doesnt output debugging windows.
      //you have to enable this yourself.

      //we still technically DO have a console- even a GUI app can be launched from the commandline.
      //output then goes THERE-instead of the Lazarus equivalent.
      //THIS TRICK DOES NOT WORK on Windows. Windows removes crt and related units when building a UI app.
        crt,crtstuff,
    {$ENDIF}
{$ENDIF}

{
Lazarus Menu:
	"View" menu, under "Debug Windows" there is an entry for a "console output"

however, if you are in a input loop or waiting for keypress-
 you will not get output until your program is complete (and has stopped execution)


In this case- Lazarus Menu:
Run -> Run Parameters, then check the box for "Use launching application".
(You may have to 'chmod +x' that script.)


To build without the LCL(in Lazarus):

 Just make a normal "most basic" program and call me in your "uses clause".

 You will find that the LCL may be a burden or get in your way-
	we dont really use the fundamentals of OBJFPC, OBJPAS, or Lazarus beyond basic functions.

}

//FPC generic units(OS independent)

  uos,strings,typinfo


// uos/Examples/lib folder has the required libraries for you.
// as a side-effect: CDROM Audio playback(CDDA) is added back


{$IFDEF debug} ,heaptrc,logger {$ENDIF}

{
OpenGL requires Quartz, which prevents building below OSX 10.2.

direct rendering onto the renderer uses QuartzGL(on OSX up to Mtn LN- it wont stay active once set)
Cocoa (OBJ-C) is the new API
}


{$IFDEF darwin}
	{$linkframework Cocoa}
	{$linkframework OpenGL}
	{$linkframework GLUT}


//you have to install fpc thru XCode and build a demo -to patch the above includes.

//	{$linklib gcc} -REAL pascal doesnt use C. There is a dialect that does.
// apparently some programmers see C as a religion...they want to convert everyone to it.

//also requires:
//mode objpas + classes uses clause (in every pascal unit)
//modeswitch objectivec2

//iFruits, iTVs, etc:
// {linkframework CocoaTouch} -- but go kick apple in the ass for not letting us link to it.
// not legally, anyway....

{$ENDIF}


//Altogether- we are talking PCs running OSX, Windows(down to XP), and most unices.
//and Some android and RasPi ( thru GL-ES)

//do not remove the following semi-colon
;


{
NOTES on units used:

crt is a failsafe "ncurses-ish"....output...
crtstuff is MY enhanced dialog unit
    I will be porting this and maybe more to the graphics routines in this unit.


mutex(es):

The idea is to talk when you have the rubber chicken or to request it or wait until others are done.
Ideally you would mutex events and process them like cpu interrupts- one at a time.


sephamores are like using a loo in a castle-
only so many can do it at once.
	first come- first served
		- but theres more than one toilet

}


type


//You are probly used to "MotionJPEG Quantization error BLOCKS" on your TV- those are not pixels. 
//Those are compression artifacts after loss of signal (or in weak signal areas). 
//That started after the DVD MPEG2 standard and digital TV signals came to be.

//STIPPLE:
//when drawing a line- this is supposed to dictate if the line is dashed or not
//AND how thick it is.

//dotted and dashed are stipple, center uses routines above
//the rest is POLYFILL releated.

  LineStyle=(solid,dotted,center,dashed);
  Thickness=(normalwidth=1,thickwidth=3,superthickwidth=5,ultimateThickwidth=7);

//C style syntax-used to be a function, isnt anymore.
  grErrorType=(OK,NoGrMem,NoFontMem,FontNotFound,InvalidMode,GenError,IoError,InvalidFontType);


  TArcCoordsType = record
      x,y : word;
      xstart,ystart : word;
      xend,yend : word;
  end;

//for MoveRel(MoveRelative)
  Twhere=record
     x,y:word;
  end;

//all the types to be had 
//originally bugged as "off by one"

//yes you can represent via pointer but the conversion gets hairy, fast.

LongString=array [0..1] of string;
StringTuple,Striplet=array [0..2] of string;
QuadString=array [0..3] of string;
//You could go up to screen height-sizeOfStringOnScreen(24-48) depending on font size (10-12)

//0..7=8 = byte(stored in hex)
Bibble, Biplet=array [0..1] of boolean;
Tribble, Triblet=array [0..2] of boolean;
Quibble, Quiblet=array [0..3] of boolean;
Pibble, Piblet=array [0..4] of boolean;
Xibble, Hexlet=array [0..5] of boolean;
Hibble, Heptlet=array [0..6] of boolean;


//Word = 2bytes
//24bits storage hack(r,g,b) -in binary form
ByteTuple,Biplet=array [0..2] of Byte;
//DWord=4 bytes

//DWord=2words
//TriWord technically..
WordTuple,Wiplet=array [0..2] of Word;
//Quad=4words

//2 quads
Biqu=array [0..1] of QWord; //128bits
TriQuad=array [0..2] of QWord; //192bits
LongQuad=array [0..3] of QWord; //256bits

//sort of -SDL_Rect implementation

PRect=^Rect;
Rect=record
	x1:byte;
	y1:byte;
	x2:byte;
	y2:byte;
end;

{
A Ton of code enforces a viewport mandate- that even sans viewports- the screen is one.
This is better used with screen shrinking effects


graphdriver is not really used half the time anyways..most people probe.

Theres only ONE Fatal Flaw in the old code:
    It presumes use on PC only. Presumption and ASSumptions are BAD.

How do you detect non-PC variants? In this case- you make another unit.

cga,vga,vesa,hdmi,hdmi1.2
}
	graphics_driver=(DETECT, CGA, VGA,VESA); 


{

Modes and "the list":

byte because we cant have "the negativity"..
could be 5000 modes...we dont care...
the number is tricky..since we cant setup a variable here...its a "sequential byte".

yes we could do it another way...but then we have to pre-call the setup routine and do some other whacky crap.


1080p is reasonable stopping point until consumers buy better hardware...which takes years...
most computers support up to 1080p output..it will take some more lotta years for that to change.

}


var
  thick:thickness;

//This is for updating sections or "viewports".
//I doubt we need much more than 4 viewports. Dialogs are handled seperately(and then removed)
  texBounds: array [0..4] of PSDL_Rect;
  textures: array [0..4] of PSDL_Texture;

  windownumber:byte;
  somelineType:thickness;

//you only scroll,etc within a viewport- you cant escape from it without help.
//you can flip between them, however.

//think minimaps in games like Warcraft and Skyrim

const
   //Analog joystick dead zone 
   JOYSTICK_DEAD_ZONE = 8000;
   //joysticks seem to be slow to respond in some games....

var

    Xaspect,YAspect:byte;

    where:Twhere;
	quit,minimized,paused,wantsFullIMGSupport,nojoy,exitloop:boolean;
    nogoautorefresh:boolean;
    X,Y:integer;
    _grResult:grErrortype;
    
    srcR,destR:PSDL_Rect;

    filename:String;
    fontpath,iconpath:PChar; // look in: "C:\windows\fonts\" or "/usr/share/fonts/"

{

Fonts:

GLUT defines the following(bitmap fonts):

    GLUT_BITMAP_8_BY_13 - A variable-width font with every character fitting in a rectangle of 13 pixels high by at most 8 pixels wide.
    GLUT_BITMAP_9_BY_15 - A variable-width font with every character fitting in a rectangle of 15 pixels high by at most 9 pixels wide.

    GLUT_BITMAP_TIMES_ROMAN_10 - A 10-point variable-width Times Roman font.
    GLUT_BITMAP_TIMES_ROMAN_24 - A 24-point variable-width Times Roman font.
    
    GLUT_BITMAP_HELVETICA_10 - A 10-point variable-width Helvetica font.
    GLUT_BITMAP_HELVETICA_12 - A 12-point variable-width Helvetica font.
    GLUT_BITMAP_HELVETICA_18 - A 18-point variable-width Helvetica font.


GLUT defines the following(stroked fonts):


    GLUT_STROKE_ROMAN - A proportionally-spaced Roman Simplex font
    GLUT_STROKE_MONO_ROMAN - A fixed-width Roman Simplex font


}

  
    grErrorStrings: array [0 .. 7] of string; //or typinfo value thereof..
    AspectRatio:single; //computed from (AspectX mod AspectY)

  MaxColors:LongWord; //positive only!!
  ClipPixels: Boolean=true; //always clip, never an option "not to".
  //we will CLAMP GL to the screen

  WantsJoyPad:boolean;
  screenshots:longint;

  NonPalette, TrueColor,WantsAudioToo,WantsCDROM:boolean;	
  Blink:boolean;
  CenterText:boolean=false; //see crtstuff unit for the trick
  
  MaxX,MaxY:word;
  bpp:byte;

  _fgcolor, _bgcolor:DWord;	
  //use index colors once setup(palette unit)
 
  LIBGRAPHICS_ACTIVE:boolean;
  LIBGRAPHICS_INIT:boolean;

  IsConsoleInvoked,CantDoAudio:boolean; //will audio init? and the other is tripped NOT if in X11.
  //can we modeset in a framebuffer graphics mode? YES. 
  
  himode,lomode:integer;

//modelist data is derived from "our little C demo" output(XRandR probe) -on Unices


type 
//our ModeList data

//the lists..
  Pmodelist=^TmodeList;

//wants graphics_modes??
  TmodeList=array [0 .. 31] of TMode;


//single mode

  Pmode=^TMode;

var

	GLFloat:single;
	FloatInt:single;

    modePointer:Pmode;


//forward declared defines

//this needs xrandr rewrite. very hard code to find.
function FetchModeList:Tmodelist;
procedure RoughSteinbergDither(filename,filename2:string);

procedure clearscreen; 
procedure clearscreen(index:byte); overload;
procedure clearscreen(color:Dword); overload;
procedure clearscreen(r,g,b:byte); overload;
procedure clearscreen(r,g,b,a:byte); overload;

procedure clearviewport;
procedure initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean);
procedure closegraph;

function GetX:word;
function GetY:word;
function GetXY:longint; 

procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 
function getgraphmode:string; 

//dummy- use closeGraph
procedure restorecrtmode;

function getmaxX:word;
function getmaxY:word;

function GetPixel(x,y:integer):DWord;
function GetPixels(Rect:PSDL_Rect):pointer;

Procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word);

function getdrivername:string;
Function detectGraph:byte;
function getmaxmode:string;
procedure getmoderange(graphdriver:integer);

procedure SetViewPort(Rect:PSDL_Rect);
procedure RemoveViewPort(windownumber:byte);

procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
procedure RegisterBGIDriver(driver: pointer);

function GetMaxColor: word;

procedure SaveBMPImage(filename:string);

//libSOIL
procedure LoadImage(filename:PChar; Rect:PSDL_Rect);
procedure LoadImageStretched(filename:PChar);

function  getDwordFromSDLColor(someColor:PSDL_Color):DWord;
function  getDwordFromBytes(r,g,b,a:Byte):DWord;

function GetByesfromDWord(someD:DWord):SDL_Color;

procedure PlotPixelWNeighbors(x,y:integer);


const
   maxMode=Ord(High(Graphics_Modes));


type
	//r,g,b,a
	GL_Color= array [0..3] of float;

{

256 and below "color" paletted modes-
this gets harder as we go along but this is the "last indexed mode". 

colors (indexes) above 255 should throw an error if using palettes.

(technically they are rgb(a) colors and have no index anymore)
(so we are in true colors and straight rgb/rgba after this.....)

You need RGB data for TRUE color modes.
 
'A' bit affects transparency 

The default setting is to ignore it(FF) in 256 color modes.

Most bitmap or blitter or renderer or opengl based code uses some sort of shader(or composite image).

 
CGA modes threw us this curveball:
	4 color , 4 palette hi bit resolution modes that are half ass documented. 
	Theres no need for those modes anymore.(think t shirt half-tones for screen printing)

VGA/SVGA (Video gate array / super video gate array) and 
VESA (video electronic standards association) modes are available now.


we can use 'SetColor(SkyBlue3);' in 256 modes -since we know which color index it is.

this is only for the default palette of course- if you muck with it.....
 and only up to 256 colors....sorry.

blink is a "text attribute" ..a feature...not a color
 -it was implemented in hardware in early 80s

write..wait.erase..wait..rewrite..just like the blinking cursor..


colors: 

	MUST be hard defined to set the pallete prior to drawing.

}

type


//There IS a way to ge the Names listed here- the magic type info library
//this cuts down on spurious string data and standardizes the palette names a bit also


//these names CANNOT overlap. If you want to change them, be my guest.

//you cant fuck up the first 16- Borland INC (RIP) made that "the standard"
TPalette16Names=(BLACK,RED,BLUE,GREEN,CYAN,MAGENTA,BROWN,LTGRAY,GRAY,LTRED,LTBLUE,LTGREEN,LTCYAN,LTMAGENTA,YELLOW,WHITE);
TPalette16NamesGrey=(gBLACK,g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14,gWHITE);

//tfs=two fifty six

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

//faked "SDL"

{$ifndef mswindows}

SDL_Color=record
	r,g,b,a:byte;
end;

GL_Color=record
	r,g,b,a:single;
end;

{$endif}


{$ifdef mswindows}

SDL_Color=record
	b,g,r,a:byte;
end;


GL_Color=record
	b,g,r,a:single;
end;

{$endif}

//I dunno what I was thinkin here w "TSDLColors"-3-14-2019

TRec4=record
  
	colors:array [0..3] of PSDL_COLOR; 

end;

TRec16=record
  
	colors:array [0..15] of PSDL_COLOR; 

end;

TRec64=record
  
	colors:array [0..63] of PSDL_COLOR; 

end;

//this is the XTerm 256 definition...

//palette tricks would then need to use : colors[1]^.a hacks.

//just so you can see the amount of datas were dealing with here.
//really shouldnt go there..and waay too many palettes out there.
//this really should be read in from a file.

//anyways- as "standard" as I can get.Most UNICES use this.


TRec256=record

  colors:array [0..255] of PSDL_COLOR; ; //this is setup later on. 

end;


var

//this is whacky but necessary to automated data filing.
//individual record entries as split rgb data
  valuelist4a: array [0..11] of byte;
  valuelist4b: array [0..11] of byte;
  valuelist4c: array [0..11] of byte;
  valuelist4d: array [0..11] of byte;

  valuelist16: array [0..48] of byte;
  valuelist64: array [0..191] of byte;

  GreyList16:array [0..48] of byte;
  valuelist256: array [0..767] of byte;

//sdl contents
  TPalette4a:TRec4;
  TPalette4b:TRec4;
  TPalette4c:TRec4;
  TPalette4d:TRec4;

  TPalette16:TRec16;
  TPalette64:TRec64;

  TPalette256:TRec256;

  TPalette16Grey:TRec16;
  TPalette256Grey:TRec256;


type

	graphics_modes=(

CGA1,CGA2,CGA3,CGA4,EGA, 
VGAMed,vgaMedx256,
vgaHi,VGAHix256,VGAHix32k,VGAHix64k,
m800x600x16,m800x600x256,m800x600x32k,m800x800x64k,
m1024x768x256,m1024x768x32k,m1024x768x64k,m1024x768xMil,
m1280x720x256,m1280x720x32k,m1280x720x64k,m1280x720xMil,
m1280x1024x256,m1280x1024x32k,m1280x1024x64k,m1280x1024xMil,
m1366x768x256,m1366x768x32k,m1366x768x64k,m1366x768xMil,
m1920x1080x256,m1920x1080x32k,m1920x1080x64k,m1920x1080xMil);

//data is in InitGraph

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


//color conversion procs etc...taking up waay too much room in here...

//no more DWords! YAAAAY!

function GetRGBfromIndex(index:byte):PSDL_Color; 
function GetDWordfromIndex(index:byte):DWord; 

function GetFgRGB:PSDL_Color;
function GetFgRGBA:PSDL_Color;

function GetFGName:string;
function GetBGName:string;

function GetBGColorIndex:byte;
function GetFGColorIndex:byte;

procedure setFGColor(color:byte);
procedure setFGColor(r,g,b:word); overload;
procedure setFGColor(r,g,b,a:word); overload;

procedure setBGColor(index:byte);
procedure setBGColor(r,g,b:word); overload;
procedure setBGColor(r,g,b,a:word); overload;

procedure invertColors;


implementation
//some of these functions are not exported.

//you could use normal GL coords and cap at floatMax of 1.0
// (but the coords are whacky-weird.)


//Horizontal line: use x, not y

procedure CenteredHLine(x,x2,y:Word);
	//where is the center??
	center:= (((x mod 2)) - ((x-x2) mod 2),(y mod 2));
	//from center : draw line from here
	HLIne(x,y,x2);
end;

//verticle line: use y, not x

procedure CenteredVLine(x,y,y2:Word);
	//where is the center??
	center:= ((x mod 2),((y mod 2)) - ((y-y2) mod 2));
	//from center : draw line from here
	VLIne(x,y,y2);
end;


{
greyscale palettes are required for either loading or displaying in BW, or some subset thereof.
this isnt "exactly" duplicated code

hardspec it first, then allow user defined- or "pre-saved" files
that not to say you cant init, save, then load thru the main code instead of useing the hard spec.

the hardspec is here as a default setting, much like most 8x8 font sometimes are included
by default in graphics modes source code.

these are zero based colors. for 16 color modes- 88 or even 80 is not correct, 70 or 7f is.
ALL data set here was pulled from references to IBM specs.

(greyscale mCGA is a hackish guess based on rough math, given 14 colors, and also black and white)

Float to byte routine are optional-
	added because loads of OpenGL examples use floats (but YOU dont need to).

Since I went thru all the effort of using SDL bytes- 
 	Im going to BYTE YOU- instead of floating the boat(he he he).


SDL to GL value conversion-and back- (I dont see this anywhere)

What we need to do here is step from 0 to 1.0 (100) in about 2.55 (255) increments.
In this manner= each HEX byte value has a float corresponding value. 
 
dividing by 1k gives us 400 or so colors- we want about half of that
      
}


//we need these as GL is funky.
procedure ByteToFloat(hexColor:Byte):single;

var
	i:single;
begin 
  i:=ord(hexColor);  
  //imperfect math but it works
  i:=(i*2/1000)*2;
  
  //fix the funky overshoot
  if i>1.0 then 
	i:=1.0;
  ByteToFloat:=i;
end;   


//For GLFloats with max value of 1.0
function GLFloatToByte(someFloat:single):byte
begin
   if (someFloat > 1.0) then 
		exit;
   GLFloatToByte:=byte(round(someFloat));
end;

{
theres one flaw here:
    you need an initial setup before doing anything in low color modes
    if you like you can change values on-the-fly(these are SDL_Color "tuple"(24bit) bytes-alpha bit is skipped)
        **PLEASE dont change these HERE unless theres something wrong.**
        Change it in your code by using the GLPaletteColor command. You can always save your palette.

        Theres no way for me to know what the new color data is- im plugging vars blind here
        -at least until you reset the palette.

    This is accepted behaviour.
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
      Tpalette16Grey.colors[num]^.r:=valuelist16[i];
      Tpalette16Grey.colors[num]^.g:=valuelist16[i+1];
      Tpalette16Grey.colors[num]^.b:=valuelist16[i+2];
      Tpalette16Grey.colors[num]^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  until num=15;

  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 16, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette16Grey);

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

  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 256, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette256Grey);

end;

{
Thers a RUB here:
    CGA uses 4 colors from 16 possible but in higher depths-there is no way to tell what the color is set to.
        Ideally you would restrict to "nearest colors" using some algorithm.
        RGBK or CMYK is a sane, reasonable value for a CGA palette. Its just not "historically accurate".
        (I cant stop you- but Id start with THESE defaults)

    Same with EGA. EGA and above were programmable.
    VGA was a standard- but Ive seen some awkward VGA palettes, too.
    Thank God palettes stopped at 256 colors.

    Think in "crayon colors" and you will do fine here.
    (There is a small box, a medium box, and a YUGE box of crayons here.)

CGA Palette:

160x100: full 16 available
(Char 221 and 222 hacks not needed)

320x200: use ONE of these (modes 0,1,2) palettes

Black, as well as all of the other colors- are programmable- 
although most old apps did not change them. 
This applies to anything above 160x100.

    0: black,red, yellow, green
    1: black,cyan, magenta, white
    2: black,cyan,red,white (greyscale)

640x200: "Black" and "white" only

}

procedure initCGAPalette0;

var
   num,i:integer;

begin  

valuelist4a[0]:=$00;
valuelist4a[1]:=$00;
valuelist4a[2]:=$00;

valuelist4a[3]:=$55;
valuelist4a[4]:=$ff;
valuelist4a[5]:=$55;

valuelist4a[6]:=$ff;
valuelist4a[7]:=$55;
valuelist4a[8]:=$55;

valuelist4a[9]:=$ff;
valuelist4a[10]:=$ff;
valuelist4a[11]:=$55;


if HalfShadeCGA then begin
   i:=0;
   num:=0; 
   repeat 
      Tpalette4a.colors[num]^.r:=valuelist4a[i];
      Tpalette4a.colors[num]^.g:=valuelist4a[i+1];
      Tpalette4a.colors[num]^.b:=valuelist4a[i+2];
      Tpalette4a.colors[num]^.a:=$7f;
      inc(i,3);
      inc(num); 
  until num=3;

end else begin
   i:=0;
   num:=0; 
   repeat 
      Tpalette4a.colors[num]^.r:=valuelist4a[i];
      Tpalette4a.colors[num]^.g:=valuelist4a[i+1];
      Tpalette4a.colors[num]^.b:=valuelist4a[i+2];
      Tpalette4a.colors[num]^.a:=$ff;
      inc(i,3);
      inc(num); 
  until num=3;
          CanChangePalette:=true;
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 4, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette4a);

end;

procedure initCGAPalette1;
var
   num,i:integer;
//remember these are dropped to half-intense if requested, so you need the "full color".
begin  

valuelist4b[00]:=$00;
valuelist4b[01]:=$00;
valuelist4b[02]:=$00;

valuelist4b[03]:=$55;
valuelist4b[04]:=$ff;
valuelist4b[05]:=$ff;

valuelist4b[06]:=$ff;
valuelist4b[07]:=$55;
valuelist4b[08]:=$ff;

valuelist4b[09]:=$ff;
valuelist4b[10]:=$ff;
valuelist4b[11]:=$ff;


if HalfShadeCGA then begin
   i:=0;
   num:=0; 
   repeat 
      Tpalette4b.colors[num]^.r:=valuelist4b[i];
      Tpalette4b.colors[num]^.g:=valuelist4b[i+1];
      Tpalette4b.colors[num]^.b:=valuelist4b[i+2];
      Tpalette4b.colors[num]^.a:=$7f;
      inc(i,3);
      inc(num); 
  until num=3;

end else begin
   i:=0;
   num:=0; 
   repeat 
      Tpalette4b.colors[num]^.r:=valuelist4b[i];
      Tpalette4b.colors[num]^.g:=valuelist4b[i+1];
      Tpalette4b.colors[num]^.b:=valuelist4b[i+2];
      Tpalette4b.colors[num]^.a:=$ff;
      inc(i,3);
      inc(num); 
  until num=3;
          CanChangePalette:=true;
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 4, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette4b);

end;

//Hackish- reserved for greyscale
procedure initCGAPalette2;
var
   num,i:integer;

begin

valuelist4c[00]:=$00;
valuelist4c[01]:=$00;
valuelist4c[02]:=$00;

valuelist4c[03]:=$3f;
valuelist4c[04]:=$3f;
valuelist4c[05]:=$3f;

valuelist4c[06]:=$7f;
valuelist4c[07]:=$7f;
valuelist4c[08]:=$7f;

valuelist4c[09]:=$ff;
valuelist4c[10]:=$ff;
valuelist4c[11]:=$ff;

if HalfShadeCGA then begin
   i:=0;
   num:=0; 
   repeat 
      Tpalette4c.colors[num]^.r:=valuelist4c[i];
      Tpalette4c.colors[num]^.g:=valuelist4c[i+1];
      Tpalette4c.colors[num]^.b:=valuelist4c[i+2];
      Tpalette4c.colors[num]^.a:=$7f;
      inc(i,3);
      inc(num); 
  until num=3;

end else begin
   i:=0;
   num:=0; 
   repeat 
      Tpalette4c.colors[num]^.r:=valuelist4c[i];
      Tpalette4c.colors[num]^.g:=valuelist4c[i+1];
      Tpalette4c.colors[num]^.b:=valuelist4c[i+2];
      Tpalette4c.colors[num]^.a:=$ff;
      inc(i,3);
      inc(num); 
  until num=3;
          CanChangePalette:=true;
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 4, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette4c);

end;

//Mode6 of original spec
procedure initCGAPalette3;
var
   num,i:integer;

begin

    valuelist4d[00]:=$00;
    valuelist4d[01]:=$00;
    valuelist4d[02]:=$00;

    valuelist4d[03]:=$ff;
    valuelist4d[04]:=$ff;
    valuelist4d[05]:=$ff;

    Tpalette4d.colors[num]^.r:=valuelist4d[i];
    Tpalette4d.colors[num]^.g:=valuelist4d[i+1];
    Tpalette4d.colors[num]^.b:=valuelist4d[i+2];
    Tpalette4d.colors[num]^.a:=$ff;

    Tpalette4d.colors[num]^.r:=valuelist4d[i];
    Tpalette4d.colors[num]^.g:=valuelist4d[i+1];
    Tpalette4d.colors[num]^.b:=valuelist4d[i+2];
    Tpalette4d.colors[num]^.a:=$ff;

    CanChangePalette:=true;
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 4, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette4d);

end;


procedure initPalette16;
// I swear these are PanTone corrected with "Light GRey 55s" -but Ill go with it.

var
   num,i:integer;

begin  
//Color Sequence(semi- in SDL_Color format):
//K LoR LoG LoB LoC LoM LoY(Brown) HiGR LoGr HiR HiG HiB HiC HiM HiY W

valuelist16[0]:=$00;
valuelist16[1]:=$00;
valuelist16[2]:=$00;

valuelist16[3]:=$AA;
valuelist16[4]:=$00;
valuelist16[5]:=$00;

valuelist16[6]:=$00;
valuelist16[7]:=$AA;
valuelist16[8]:=$00;

valuelist16[9]:=$00;
valuelist16[10]:=$AA;
valuelist16[11]:=$AA;

valuelist16[12]:=$AA;
valuelist16[13]:=$00;
valuelist16[14]:=$00;

valuelist16[15]:=$AA;
valuelist16[16]:=$00;
valuelist16[17]:=$AA;

//brown- dark yellow
valuelist16[18]:=$AA;
valuelist16[19]:=$55;
valuelist16[20]:=$00;

//2 greys
valuelist16[21]:=$AA;
valuelist16[22]:=$AA;
valuelist16[23]:=$AA;

valuelist16[24]:=$55;
valuelist16[25]:=$55;
valuelist16[26]:=$55;
//end greys

valuelist16[27]:=$55;
valuelist16[28]:=$55;
valuelist16[29]:=$ff;

valuelist16[30]:=$55;
valuelist16[31]:=$ff;
valuelist16[32]:=$55;

valuelist16[33]:=$55;
valuelist16[34]:=$ff;
valuelist16[35]:=$ff;

valuelist16[36]:=$ff;
valuelist16[37]:=$55;
valuelist16[38]:=$55;

valuelist16[39]:=$ff;
valuelist16[40]:=$55;
valuelist16[41]:=$ff;

//14=Y
valuelist16[42]:=$ff;
valuelist16[43]:=$ff;
valuelist16[44]:=$55;


//white is specified later(wonky palette)

   i:=0;
   num:=0; 
   repeat 
      Tpalette16.colors[num]^.r:=valuelist16[i];
      Tpalette16.colors[num]^.g:=valuelist16[i+1];
      Tpalette16.colors[num]^.b:=valuelist16[i+2];
      Tpalette16.colors[num]^.a:=$7f;
      inc(i,3);
      inc(num); 
  until num=7;

   i:=25;
   num:=8; 
   repeat 
      Tpalette16.colors[num]^.r:=valuelist16[i];
      Tpalette16.colors[num]^.g:=valuelist16[i+1];
      Tpalette16.colors[num]^.b:=valuelist16[i+2];
      Tpalette16.colors[num]^.a:=$ff;
      inc(i,3);
      inc(num); 
  until num=14;
  //white
      Tpalette16.colors[15]^.r:=$ff;
      Tpalette16.colors[15]^.g:=$ff;
      Tpalette16.colors[15]^.b:=$ff;
      Tpalette16.colors[15]^.a:=$ff;
      CanChangePalette:=false; //dont change this-youll break the spec
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 16, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette16);

end;


procedure initPalette64;
// I swear these are PanTone corrected with "Light GRey 55s" -but Ill go with it.
//set to initial 16- programmable- as long as MaxY=200.

{
This is the easiest way to do EGA colors:

for each of 16 colors
 
A=      0, 63, 127 and 255. 
HEXA:   0  3F  7F      FF

}


var
   num,i:integer;

begin  

valuelist64[0]:=$00;
valuelist64[1]:=$00;
valuelist64[2]:=$00;

valuelist64[3]:=$AA;
valuelist64[4]:=$00;
valuelist64[5]:=$00;

valuelist64[6]:=$00;
valuelist64[7]:=$AA;
valuelist64[8]:=$00;

valuelist64[9]:=$00;
valuelist64[10]:=$AA;
valuelist64[11]:=$AA;

valuelist64[12]:=$AA;
valuelist64[13]:=$00;
valuelist64[14]:=$00;

valuelist64[15]:=$AA;
valuelist64[16]:=$00;
valuelist64[17]:=$AA;

//brown- dark yellow
valuelist64[18]:=$AA;
valuelist64[19]:=$55;
valuelist64[20]:=$00;

valuelist64[21]:=$AA;
valuelist64[22]:=$AA;
valuelist64[23]:=$AA;

valuelist64[24]:=$55;
valuelist64[25]:=$55;
valuelist64[26]:=$55;

valuelist64[27]:=$55;
valuelist64[28]:=$55;
valuelist64[29]:=$ff;

valuelist64[30]:=$55;
valuelist64[31]:=$ff;
valuelist64[32]:=$55;

valuelist64[33]:=$55;
valuelist64[34]:=$ff;
valuelist64[35]:=$ff;

valuelist64[36]:=$ff;
valuelist64[37]:=$55;
valuelist64[38]:=$55;

valuelist64[39]:=$ff;
valuelist64[40]:=$55;
valuelist64[41]:=$ff;

//14=Y
valuelist64[42]:=$ff;
valuelist64[43]:=$ff;
valuelist64[44]:=$55;

valuelist64[45]:=$ff;
valuelist64[46]:=$ff;
valuelist64[47]:=$ff;


   i:=0;
   num:=0; 
   repeat 
      Tpalette64.colors[num]^.r:=valuelist64[i];
      Tpalette64.colors[num]^.g:=valuelist64[i+1];
      Tpalette64.colors[num]^.b:=valuelist64[i+2];
      Tpalette64.colors[num]^.a:=$7f;
      inc(i,3);
      inc(num); 
  until num=7;

   i:=25;
   num:=8; 
   repeat 
      Tpalette64.colors[num]^.r:=valuelist64[i];
      Tpalette64.colors[num]^.g:=valuelist64[i+1];
      Tpalette64.colors[num]^.b:=valuelist64[i+2];
      Tpalette64.colors[num]^.a:=$ff;
      inc(i,3);
      inc(num); 
  until num=15;
      if MaxY=200 then //HEY! I didnt write the spec...
          CanChangePalette:=true;
      else
          CanChangePalette:=false;
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 64, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette64);

end;

//you can use these for EGA also- same sized data.

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
    if ReadColorFile =true then
        glColorTable(GL_COLOR_TABLE, GL_RGBA8, 16, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette16);
    else
        glColorTable(GL_COLOR_TABLE, GL_RGBA8, 16, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette16GRey);

end;

procedure initPalette256;

//256 color VGA palette based on XTerm colors(Unix)
// however the first 16 are off according to mCGA specs and have been corrected.
//xterms dont use "bold text by deault" an maybe this is where the confusion is.

//furthermore there are other 256rgb palettes.


var
    num,i:integer;


begin  
//old cga palette
valuelist256[0]:=$00;
valuelist256[1]:=$00;
valuelist256[2]:=$00;

valuelist256[3]:=$7f;
valuelist256[4]:=$00;
valuelist256[5]:=$00;

valuelist256[6]:=$00;
valuelist256[7]:=$7f;
valuelist256[8]:=$00;

valuelist256[9]:=$00;
valuelist256[10]:=$00;
valuelist256[11]:=$7f;

valuelist256[12]:=$7f;
valuelist256[13]:=$7f;
valuelist256[14]:=$00;

valuelist256[15]:=$7f;
valuelist256[16]:=$00;
valuelist256[17]:=$7f;

valuelist256[18]:=$00;
valuelist256[19]:=$7f;
valuelist256[20]:=$7f;

valuelist256[21]:=$f0;
valuelist256[22]:=$f0;
valuelist256[23]:=$f0;

valuelist256[24]:=$f0;
valuelist256[25]:=$f0;
valuelist256[26]:=$f0;

valuelist256[27]:=$ff;
valuelist256[28]:=$00;
valuelist256[29]:=$00;

valuelist256[30]:=$00;
valuelist256[31]:=$ff;
valuelist256[32]:=$00;

valuelist256[33]:=$00;
valuelist256[34]:=$00;
valuelist256[35]:=$ff;

valuelist256[36]:=$00;
valuelist256[37]:=$00;
valuelist256[38]:=$ff;

valuelist256[39]:=$ff;
valuelist256[40]:=$00;
valuelist256[41]:=$ff;

valuelist256[42]:=$7f;
valuelist256[43]:=$7f;
valuelist256[44]:=$00;

valuelist256[45]:=$ff;
valuelist256[46]:=$ff;
valuelist256[47]:=$ff;

//end old 16 color palette

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

//correct for the wonky cga palette

   i:=0;
   num:=0; 
   repeat 
      Tpalette16.colors[num]^.r:=valuelist256[i];
      Tpalette16.colors[num]^.g:=valuelist256[i+1];
      Tpalette16.colors[num]^.b:=valuelist256[i+2];
      Tpalette16.colors[num]^.a:=$ff;
      inc(i,3);
      inc(num); 
  until num=7;

   i:=25;
   num:=8; 
   repeat 
      Tpalette256.colors[num]^.r:=valuelist256[i];
      Tpalette256.colors[num]^.g:=valuelist256[i+1];
      Tpalette256.colors[num]^.b:=valuelist256[i+2];
      Tpalette256.colors[num]^.a:=$7f;
      inc(i,3);
      inc(num); 
  until num=14;

  //white
      Tpalette256.colors[15]^.r:=$ff;
      Tpalette256.colors[15]^.g:=$ff;
      Tpalette256.colors[15]^.b:=$ff;
      Tpalette256.colors[15]^.a:=$ff;
  
//continue w rest of colors

   i:=48;
   num:=16; 
   repeat
      Tpalette256.colors[num]^.r:=valuelist256[i];
      Tpalette256.colors[num]^.g:=valuelist256[i+1];
      Tpalette256.colors[num]^.b:=valuelist256[i+2];
      Tpalette256.colors[num]^.a:=$ff; 
      inc(i,3);
      inc(num); 
  until num=767;
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 256, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette256);

	
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
    if ReadColorFile =true then
        glColorTable(GL_COLOR_TABLE, GL_RGBA8, 256, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette256);
    else
    glColorTable(GL_COLOR_TABLE, GL_RGBA8, 256, GL_RGBA, GL_UNSIGNED_BYTE, Tpalette256Grey);

end;


{

Colors are bit banged to hell and back.

type

SDL_Color=record (internal definition)

	r:byte; //UInt8 in C
	g:byte;
	b:byte;
	a:byte; 

end;

PSDL_Color =array [0..3] of PUInt8; //(BytePtr)


    r:=PSDL_Color^
    g:=PSDL_Color^[1]
    b:=PSDL_Color^[2]
    a:=PSDL_Color^[3]

(its a c-like hack that works)


24 bit and awkward modes:
Tuples (just RGB values) dont exist in Pascal(or C).Its a Python Thing.
-Further, non ^of2 byte packing isnt supported by OpenGL. It creates speed hiccups with unaligned data.

SO- align the data.(DUH)

*FIXED : 4/26/19  


Colors:

(try not to confuse BIT with BYTE here)


ff means use full color output
7f can be used as half-shading -giving us RGBI simulation
00 means  "extremely weak" blending- very transparent color


8bit-(256 color) is paletted RGB mode
	-this is the last paletted mode


---
4bit(16)->8bit(256):

NO CHANGE, just switch palettes.

EGA modes:
	just use the first 16 colors of the palette and change them as you need.
	its easier to not do 4bit conversion, but use 8bit color and convert that.

	- is it possible the original 16 colors can point elsewhere- yes, 
	but that would de-standardize "upscaling the colors" from 16-> 256 modes.

Downsizing bits:

-you cant put whats not there- you can only "dither down" or "fake it" by using "odd patterns".
what this is -is tricking your eyes with "almost similar pixel data".

}

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
   ShowMessage(SDL_MESSAGEBOX_ERROR,'Attempt to fetch RGB from non-Indexed color.Wrong routine called.','OK',NIL); 
   
    exit;
  end;
end;


//get the last color (that we already) set

function GetFgRGB:SDL_Color;
var
  color:SDL_Color;

begin
    color^.r:=_bgcolor^.r;
    color^.g:=_bgcolor^.g;
    color^.b:=_bgcolor^.b;
    color^.a:= $ff;
    GetFgRGB:=color; 
end;

function GetFgRGBA:SDL_Color;

var
  color:PSDL_Color;

begin
    color^.r:=_bgcolor^.r;
    color^.g:=_bgcolor^.g;
    color^.b:=_bgcolor^.b;
    color^.a:=_bgcolor^.a;
    GetFgRGBA:=color; 
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
	  ShowMessage('Cant Get color name from an RGB mode colors.');
	  exit;
   end;
   i:=0;
   i:=GetFGColorIndex;
//not good enough. FIXME.
   if MaxColors=256 then begin
	      GetFGName:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
		  exit;
   end else if MaxColors=64 then begin
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
	  ShowMessage(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
	  exit;
   end;
   i:=0;
   i:=GetBGColorIndex;

   if MaxColors=256 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
		  exit;
   end else if MaxColors=64 then begin
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
     
     if MaxColors=64 then begin
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
	    ShowMessage(SDL_MESSAGEBOX_ERROR,'Cant Get index from an RGB mode (or non-palette) colors.','OK',NIL);
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
     
     if MaxColors=64 then begin
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

		ShowMessage(SDL_MESSAGEBOX_ERROR,'Cant Get index from an RGB mode colors.','OK',NIL);
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
   end else if MaxColors=64 then begin
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

procedure setFGColor(r,g,b:byte); overload;

begin
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
end;

procedure setFGColor(r,g,b,a:byte); overload;

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
   end else if MaxColors=64 then begin 
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

procedure invertColors;

//so you see how to do manual shifting etc.. 
begin
	_bgcolor^.r:=(255 - _bgcolor^.r);
    _bgcolor^.g:=(255 - _bgcolor^.g);
    _bgcolor^.b:=(255 - _bgcolor^.b);
end;


{$IFDEF mswindows}
//Win only routines

function IsVistaOrGreater: Boolean;
begin
   IsWindows7:= (Win32MajorVersion => 6) or ((Win32MajorVersion = 6) and (Win32MinorVersion => 1));
end;

//if NOT- DONT USE ANYTHING HERE- OpenGL isnt supported at min version needed.
function IsWindowsXP: Boolean;
begin
 IsWindowsXP:=((Win32MajorVersion = 5) and (Win32MinorVersion >= 1));
end;

{$endif}


//returns the floatValue of the current "RGB (BYTE) quad"
//to be useful - or do math ops- we need the byte values.

function GetFGColor:single;
var
	GotColor:float;

begin
	glGetFloatv(GL_CURRENT_COLOR,GotColor);
    GetColor:=GotColor;
end;

function GetFGColor:Byte;
var
	GotByte:byte;
	GotColor:float;
begin
	glGetFloatv(GL_CURRENT_COLOR,GotColor);
	GetColor:=Float2Byte(GotColor);
end;

{ 

app devs need to use these:

procedure MouseButton(button, state, x, y:integer);
begin
  // Respond to mouse button presses.
  // If button1 pressed, mark this state so we know in motion function.

  if (button = GLUT_LEFT_BUTTON) then
    begin
      g_bButton1Down := TRUE then
		state := GLUT_DOWN;
      else
		state:=GLUT_UP;
//      g_yClick := y - (3 * g_fViewDistance);
    end;

end;

//has wheel moved?
procedure MouseMotion(x,y:integer);
begin
  // If button1 pressed, zoom in/out if mouse is moved up/down.

  if (g_bButton1Down) then
    begin
      g_fViewDistance := (y - g_yClick) / 3.0;
      if (g_fViewDistance < VIEWING_DISTANCE_MIN) then
         g_fViewDistance := VIEWING_DISTANCE_MIN;
      glutPostRedisplay(); 
    end;

end;

}


type
    pmypixels:^mypixels;

    pmyshortpixels:^myshortPixels;

var
  mypixels:array [0..MaxX,0..MaxY] of SDL_Color; //4byte array (pixel) for sizeof(screen)
  myshortPixels: array [0..MaxX,0..MaxY] of Word; //GLshort
  
  maxTextureSize:integer;

//bytes are too small for screen co-ords
procedure DrawGLRect(x1,y1,x2,y2:Word);
	glRects(x1, y1, x2,y2); //GLuShort=Word
end;

procedure DrawGLRect(Rect:PSDL_Rect); overload;
	glRects(Rect^.x1, Rect^.y1, Rect^.x2,Rect^.y2);
end;


//similar to SDL_GetPixels- we read a Rect from a Texture.

function readpixels1516Tex(x,y,width,height:integer; Texture:textureID):PmyShortPixels;
//fucked C output- so lets un-fuck it.

var
    PointedPixels:pointer;    

begin
  case (bpp) of:

//these are 16bit values(words, not DWords)
//so unpack, then repack it.

	15: begin
  			glPixelStorei(GL_UNPACK_ALIGNMENT, 2);
            glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_5_5_1, pixels15);
  			glPixelStorei(GL_PACK_ALIGNMENT, 4);
    end;
	16: begin
  			glPixelStorei(GL_UNPACK_ALIGNMENT, 2);
            glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, pixels16);
  			glPixelStorei(GL_PACK_ALIGNMENT, 4);
    end;

  end else begin
        //wrong routine called!!

  end;
    PointedPixels:^myshortpixels;
    readpixelsTex:=PointedPixels;
end;


function readpixelsTex(x,y,width,height:integer; Texture:textureID):Pmypixels;
//fucked C output- so lets un-fuck it.

var
    PointedPixels:pointer;    

begin
  case (bpp) of:

    //palettized (faked) 24bit

    //if this fails- put GL_BYTE where UNSIGNED is.
	4: glReadPixels(0, 0, width, height, GL_COLOR_INDEX, GL_UNSIGNED_BYTE, mypixels);
	8: glReadPixels(0, 0, width, height, GL_COLOR_INDEX, GL_UNSIGNED_BYTE, mypixels);

	//No upconversion. Settle for 32bit data(24+pad data). I made this weird.
	24: glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_BYTE, mypixels);
    32: glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, mypixels);
  end else begin
    //wrong routine called!

  end;
    PointedPixels:^mypixels;
    readpixelsTex:=PointedPixels;
end;

//read from Screen(framebuffer)?


//co-ordinates: update texture, update rect, or update screen?

procedure UpdateRect1516(x,y,width,height:integer; Texture:textureID; pixels:pmyshortpixels);
//remember SDlv1 updateRect? This is it - in OpenGL.
//only update modified pixels

begin
     if pixels=Nil then
        exit;

    //check for rubbish
    if (height <=0) or (width <=0) then begin
		LogLn('Invalid HxW data given for Texture update');
		exit;
    end;
    if (x <0) or (y <0) then begin
		LogLn('Invalid XxY data given for Texture update');
		exit;
    end;

  glBindTexture(GL_TEXTURE_2D, texture);    //A texture you have already created storage for

  case (bpp) of:

	15: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_5_5_1, pmyshortpixels);
	16: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB,  GL_UNSIGNED_SHORT_5_6_5, pmyshortpixels);

   end; //case
end;


procedure UpdateRect(x,y,width,height:integer; Texture:textureID; pixels:pmypixels);
//remember SDlv1 updateRect? This is it - in OpenGL.
//only update modified pixels


begin
     if pixels=Nil then
        exit;

    //check for rubbish
    if (height <=0) or (width <=0) then begin
		LogLn('Invalid HxW data given for Texture update');
		exit;
    end;
    if (x <0) or (y <0) then begin
		LogLn('Invalid XxY data given for Texture update');
		exit;
    end;

  glBindTexture(GL_TEXTURE_2D, texture);    //A texture you have already created storage for

  case (bpp) of:
    //faked RGB modes(24bits colors) w palettes
	4: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_BYTE, pmypixels);
	8: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_BYTE, pmypixels);

//the tuple...
	24:	glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_UNSIGNED_BYTE, pmypixels);

	32: begin
			{$ifdef mswindows}
				glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, pmypixels);
			{$else}
				glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_ARGB, GL_UNSIGNED_BYTE, pmypixels);
			{$endif}
		end;
   end; //case
end;

//color ops:
//theres no need to query what depth/bpp we are in- we should know.

//the tricky part may be in reading pixels back from OGL/SDL
//-and converting the output to the format we want.

//"textures may not contain the color mode set"....(SDL)

// for 32-> 15/16 routines, the A bit=FF. Then run one of these.


//(24bit RGB->15bits hex):
function RGB24To15bit(incolor:SDL_Color):SDL_Color;
begin
        outcolor^.r := incolor.r * (2 shl 5) mod (2 shl 8);
        outcolor^.g := incolor.g * (2 shl 5) mod (2 shl 8);
        outcolor^.b := incolor.b * (2 shl 5) mod (2 shl 8);
end;

procedure RGB24To16bit(incolor:SDL_Color):SDL_Color;
begin
        outcolor^.r := incolor.r * (2 shl 5) mod (2 shl 8);
        outcolor^.g := incolor.g * (2 shl 6) mod (2 shl 8);
        outcolor^.b := incolor.b * (2 shl 5) mod (2 shl 8);
end;


//Convert an array of four bytes into a 32-bit DWord/LongWord.
//rarely used now.

function  getDwordFromSDLColor(someColor:PSDL_Color):DWord;

begin
//array of 4 bytes or dword

{$ifndef mswindows}
    getDwordFromBytes:= (somecolor.^r) or (somecolor.^g shl 8) or (somecolor.^b shl 16) or (somecolor.^a shl 24);
{$endif}

{$ifdef mswindows}
    getDwordFromBytes:= (somecolor.^a) or (somecolor.^b shl 8) or (somecolor.^g shl 16) or (somecolor.^r shl 24);
{$endif}
end;

//in case we didnt use the SDL Color array--WHY?
function  getDwordFromBytes(r,g,b,a:Byte):DWord;

begin
{$ifndef mswindows}
    getDwordFromBytes:= (r) or (g shl 8) or (b shl 16) or (a shl 24);
{$endif}
{$ifdef mswindows}
   getDwordFromBytes:= (a) or (b shl 8) or (g shl 16) or (r shl 24);
{$endif}

end;

//where do the bytes go? into a record. 
function GetByesfromDWord(someD:DWord):SDL_Color;

var
	someDPtr:Pointer;
    someColor:PSDL_Color;

begin
    someDPtr:=Nil;
    someDPtr:^someD;

{$ifndef mswindows}
	r:=someDPtr^;
	g:=someDPtr^[1];
	b:=someDPtr^[2];
	a:=someDPtr^[3];
{$endif}

{$ifdef mswindows}
	a:=someDPtr^;
	b:=someDPtr^[1];
	g:=someDPtr^[2];
	r:=someDPtr^[3];
{$endif}

   somecolor^.r:=byte(^r);
   somecolor^.g:=byte(^g);
   somecolor^.b:=byte(^b);
   somecolor^.a:=byte(^a);

   GetByesfromDWord:=somecolor;
end;

// SDL FIXME: 50 million functs to do something!
//these two redraw after enable/disable

procedure EnableAAMode;

begin
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
      glEnable(GL_BLEND);
      glEnable(GL_POINT_SMOOTH);
      glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
      glEnable(GL_LINE_SMOOTH);
      glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
      glEnable(GL_POLYGON_SMOOTH);
      glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
      glutPostRedisplay;
end;

procedure DisableAAMode;

begin
	glDisable(GL_BLEND);
    glDisable(GL_LINE_SMOOTH);
    glDisable(GL_POINT_SMOOTH);
    glDisable(GL_POLYGON_SMOOTH);
	glutPostRedisplay;
end;


//just changes the value- doesnt put it on screen
procedure SetRGBColor(r,g,b:byte);
begin
	glColor3b (r, g, b); //sets implied 255 alpha level
end;

procedure SetRGBAColor(r,g,b,a:byte);
begin
	glColor4b (r, g, b,a); //YOU set alpha level-255 is solid, 0 is opaque (what are you drawing over?)
end;

procedure PutPixelRGB(r,g,b:byte);
begin
	glColor3b (r, g, b); //sets implied 255 alpha level
	PutPixelXY(x,y);
end;


procedure PutPixelRGBA(r,g,b,a:byte);
begin
	glColor4b (r, g, b,a); //YOU set alpha level-255 is solid, 0 is opaque (what are you drawing over?)
	PutPixelXY(x,y);
end;

type
    PPoints=^points;
    PolyPts= record
        x:word;
        y:word;
    end;

//arent dynamic arrays fun?

var
   Points:array of PolyPts;

procedure DrawPoly(GiveMePoints:Points);	
//use predefind objects or tessellate if you have need of more surface "curvature"

begin	
	if FilledPolys then	
		// draw solids:
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);	

	else
		//dont draw solids:
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

	glBegin(GL_POLYGON);
		repeat
			glVertex2s(GiveMePoints[num]^.x,GiveMePoints[num]^.y);	
			dec(num);
		until sizeof(GiveMePoints);
	glEnd;

	glFlush;
end;


procedure CreateNewTexture;
var
   tex:GLuint; //LongWord

begin

	glGenTextures(1, tex);
	glBindTexture(GL_TEXTURE_2D, tex);

	//keep coord sane between 0 and 1
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE); //X
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE); //Y

	if not drawAA then begin
		//pixely -lookig mode
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	end else
		//smooth ele-va-tor...
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
end;

type
    pixelsP=^pixels;
    TexturePixels= array of Byte;

var
    texture:LongWord;
    pixelData:Texturepixels;

//RenderTexture then glFlush/RenderPresent/PageFlip)

procedure RenderTargetWord15;

begin
    glTexImage2D(GL_TEXTURE_2D, 0, x,y, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_5_5_1, texture);
end;

procedure RenderTargetWord16;

begin
    glTexImage2D(GL_TEXTURE_2D, 0, x,y, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, texture);
end;

procedure RenderTargetRGB;

begin
    glTexImage2D(GL_TEXTURE_2D, 0, x,y, width, height, GL_RGB, GL_UNSIGNED_BYTE, texture);
end;


procedure RenderTargetRGBA;

begin
    glTexImage2D(GL_TEXTURE_2D, 0, x,y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, texture);
end;


//libSOIL
procedure Load_ImageRGB

var
	width, height:integer;

begin
  image:=SOIL_load_image("img.png", width, height, 0, SOIL_LOAD_RGB); //load image
  glTexImage2D(GL_TEXTURE_2D, 0, x,y,width, height,GL_RGB, GL_UNSIGNED_BYTE, pmypixels); //copyTex
  
end;

procedure Load_ImageRGBA

var
	width, height:integer;

begin
  image:=SOIL_load_image("img.png", width, height, 0, SOIL_LOAD_RGBA); //load image
  glTexImage2D(GL_TEXTURE_2D, 0, x,y,width, height,GL_RGBA, GL_UNSIGNED_BYTE, pmypixels); //copyTex
  
end;


procedure Load_ImageScaledRGB(scaleX,ScaleY:integer);

begin
  image:=SOIL_load_image("img.png", width, height, 0, SOIL_LOAD_RGB); //load image

  //I dont think this is how its done...GL is weird in whacky ways...

  glTexImage2D(GL_TEXTURE_2D, 0, x,y, ScaleX, ScaleY, 0, GL_RGB, GL_UNSIGNED_BYTE, pmypixels); //copyTex

end;

procedure Load_ImageScaledRGB(scaleX,ScaleY:integer);

begin
  image:=SOIL_load_image("img.png", width, height, 0, SOIL_LOAD_RGBA); //load image

  //I dont think this is how its done...GL is weird in whacky ways...

  glTexImage2D(GL_TEXTURE_2D, 0, x,y, ScaleX, ScaleY, 0, GL_RGBA, GL_UNSIGNED_BYTE, pmypixels); //copyTex

end;


{
SERIOUS FIXME: any pointer used must be =NIL before assignment

**DO NOT BLINDLY ALLOW any function to be called arbitrarily.**
(this was done in C- I removed the checks for a short while)

two exceptions:

	making a 16 or 256 palette and/or modelist file


NET:
	init and teardown need to be added here- I havent gotten to that.
	(I was trying to find viable non-C,non-SDL Net code)

}



Procedure SetViewPort(X1, Y1, X2, Y2: smallint);
Begin
   if not GRAPHICSENABLED then exit;
   //this doesnt check bounds of existing viewports
  if (X1 > MaxX) or (X2 > MaxX) or (X1 > X2) or (X1 < 0)  or (Y1 > MaxY) or (Y2 > MaxY) or (Y1 > Y2) or (Y1 < 0) then
  Begin
    if IsConsoleInvoked then begin
		logln('invalid viewport parameters: ('+strf(x1)+','+strf(y1)+'), ('+strf(x2)+','+strf(y2)+')');
		
		logln('maxx = '+strf(maxx)+', maxy = '+strf(maxy));
    end else begin
       {$ifdef lcl}
			ShowMessage('Invalid viewport parameters. Resetting to defaults.');
	   {$endif}
	   //in case you do something stupid later on.
	   X1:=0;
	   Y1:=0;
	   X2:=MaxX;
	   Y2:=MaxY;
       exit;
    end;
  end;

  // sets the RECT- doesnt do anything with it.
  StartXViewPort := X1;
  StartYViewPort := Y1;
  ViewWidth :=  X2-X1;
  ViewHeight:=  Y2-Y1;

  //FIXME: add viewport array code so we can remove screen 'contents' later on

end;

procedure GetViewSettings(var viewport : ViewPortType);
begin
  ViewPort.X1 := StartXViewPort;
  ViewPort.Y1 := StartYViewPort;
  ViewPort.X2 := ViewWidth + StartXViewPort;
  ViewPort.Y2 := ViewHeight + StartYViewPort;
end;

//change
procedure SetAspectRatio(Xasp, Yasp : word);
begin
    Xaspect:= XAsp;
    YAspect:= YAsp;
    glViewport(0, 0, Width, Height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45.0, XAsp mod YAsp, 0.1, 100.0);
    glflush;
end;


procedure SetWriteMode(WriteMode : word);
  // TP sets the writemodes according to the following scheme (Jonas Maebe)

{
Word    Function        CPU BOOLEAN Instruction

0       CopyPut         MOV (to new buffer)

Blend Modes:
1       XORPut          XOR (XOR color)
2       ORPut           OR  (or color)
3       AndPut          AND (and color)

4       NotPut          NOT (dont put it- move XY pointer instead)

}

begin
     Case writemode of
       //for each pixel in surface.^pixels do:
       //put pixel according to mode, update surface
       0: begin
            CurrentWriteMode := CopyPut;

       end;
       1: begin
            CurrentWriteMode := XorPut;

       end; 
       2:  begin
            CurrentWriteMode := orPut;

       end;
       3:  begin
            CurrentWriteMode := AndPut;

        end;
       //'Not' is atypical for unixes. (not implemented)

       //either your putting the color- or your NOT--according to boolean logic.
       //so therefore: a NOTPut means this: draw with the background color
       5: begin
            CurrentWriteMode := NotPut;
            _fgcolor:=_bgcolor;
       end;
End;
     
end;

//FIXME: needs a rewrite
function FetchModeList:Tmodelist;

begin

end;

{

Graphics detection is a wonky process.
1- fetch (or find) whats supported
2- find highest mode in that list
3- use it, or try to.

repeat num 2 and 3 if you fail- until no modes work


I was THIS mode, and none other- it had better be supported (but is it?)
(try or fail)


Although generally in SDL(and on hardware) smaller windows and color depths are supported(emulation).
Fullscreen modes need to pull up or use "FatPixel modes" to correct for the lack of resolution.
(whether things look good- is another matter)

A TON of old code was written when pixels were actually visible. 
NOT THE CASE, anymore.


DetectGraph is here more for compatibility than anything else.
It seems to be used as often as DEFINED modes.

-Custom modes are usually hackish and were removed.

}


//  Load a set of mappings from a file.
procedure GameControllerAddMappingsFromFile(FilePath:string);
begin
	//open file for reading
	//read into some record
    //close file

//log any errors
end;


function WindowPos_IsUndefined(WindowData:PSDL_Rect): boolean;
//basically these settings violate bounds.
begin
	WindowPos_IsUndefined:=((WindowData^.x<0) or (WindowData^.y<0) or (WindowData^.h<1) or (WindowData^.h>MaxY) or (WindowData^.w<1) or (WindowData^.w>MaxX) or (WindowData.x=Nil) or (WindowData.y=Nil) or (WindowData.h=Nil) or (WindowData.w=Nil));
end;

//I actually compute this for text positioning, inside the window.
function WindowPos_IsCentered(WindowData:PSDL_Rect): boolean;
begin
  //something like this
  WindowPos_IsCentered := (((WindowData.x mod 2)=MaxX mod 2) and ((WindowData.y mod 2)=MaxY mod 2));
end;

//Locking Textures is a good idea. It ensures that we want to render there- 
// and that nothing can interupt us when doing so- like a sephamore or spinlock.


// from wikipedia(untested)
procedure RoughSteinbergDither(filename,filename2:string);
//assumes 24 or 32 bit image

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
  wonky "what ? (eh vs uh) : something" ===> if (evaluation) then (= to this) else (equal to that)
(usually a boolean eval with a byte input- an overflow disaster waiting to happen)

for example:
	SDL_SetRenderDrawBlend(renderer, (a = 255) ? SDL_BLEND_NONE : SDL_BLEND_BLEND);

}


{
Create a new texture for most ops-
DO NOT call RenderCopy(or unlock),meaning that rendering is NOT done yet.

Rendering is being called automatically at minimum (screen_refresh) as an interval.
Refresh is fine if data is in the backbuffer. 

Until its copied into the main buffer- its never displayed.


which surface/texture do we lock/unlock??
solve for X -by providing it. Dont beat your own brains out nuking the problem.

dont render Present(page_Flip) while a surface is locked for operations.(PAUSE rendering)

we could be presented with a situation that causes an issue where locked surfaces are forced onto the screen
with potentially no way to unlock them.
This may create a "double free error"-or the like.

}

//"Texture locking thru OGL on Unices is unpredictable." -SDL DEv team. NICE JOKE.
//what you mean was glBindTexture's "second call to Nil", right?

procedure clearDevice;

begin
    if LIBGRAPHICS_ACTIVE=true then
		GL_Clear;
end;

procedure clearscreen;
//this is an alias routine

begin
    if LIBGRAPHICS_ACTIVE=true then
        clearDevice
    else //use crt unit
        clrscr;
end;

//clear with color
procedure clearscreen(index:byte); overload;

var
	r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin
    if MaxColors>256 then begin
        if IsConsoleInvoked then
           Logln('ERROR: i cant do that. not indexed.');
		 {$ifdef lcl}
			ShowMessage('Attempted to Clearscreen(index) with non-indexed data.');
		 {$endif}

        LogLn('Attempting to clearscreen(index) with non-indexed data.');
        exit;
    end;

    if MaxColors=16 then
       somecolor:=Tpalette16.colors[index];

    if MaxColors=64 then
       somecolor:=Tpalette64.colors[index];

    if MaxColors=256 then
       somecolor:=Tpalette256.colors[index];
end;

{

//only works in 2D

type
    objectStyle=(dotted, dashed, complete);

var
//need a unique variable name that makes sense
   VTX : array of TVertex2f ;  // array of XY coordinates

    
procedure circle;

begin
//points of the circle are used. so ~180 is good.
//these can be programmed in sin/cos fashion...I already have THAT code.


//dotted object

   // Draw Pixels
   glPointSize ( lineSize ) ;  // dots diameter 5 pixels.
   glColor3f ( 0.0 , 0.0 , 1.0 ) ;  // blue

//for each XY vertex(point) starting with the first(0)- draw the vertexPoint in manner described above.

   glDrawArrays ( GL_POINTS , 0 , Length ( VTX )) ;

//dashed object

   // Draw LINES
   glLineWidth ( lineSize ) ;  // line 3 pixels wide.
   glColor3f ( 1.0 , 1.0 , 0.0 ) ;  // yellow
   glDrawArrays ( GL_LINES , 0 , Length ( VTX )) ;

//complete object(circle)

   // Draw A closed loop of lines
   glLineWidth ( lineSize ) ;  // line 6 pixels wide.
   glColor3f ( 0.0 , 1.0 , 0.0 ) ;  // green
   glDrawArrays ( GL_LINE_LOOP , 0 , Length ( VTX )) ;

end;

}


//these two dont need conversion of the data(24 and 32 bpp)
procedure clearscreen(r,g,b:byte); overload;


begin
	glColor3b(ord(r),ord(g),ord(b),255);
end;


procedure clearscreen(r,g,b,a:byte); overload;

begin
	glColor3b(ord(r),ord(g),ord(b),ord(a));
end;


//RenderStringB(15, 15, GLUT_BITMAP_TIMES_ROMAN_24, "Hello", someSDLColor);

//Byte color input(like SDL)
procedure RenderStringB(x, y:Word; font:Pointer; string:PChar; rgb:SDL_Color);

begin

  glColor3b(rgb^.r, rgb^.g, rgb^.b);
  glRasterPos2s(x, y);

  glutBitmapString(font, string);
end;


//uses current color set with glColor

procedure PutPixel(x,y:Word);

//GL_SHORT is 2 bytes(a Word)
//create a 2D vertex(point) using "normal values" instead of floats.
//DOES NOT WORK outside of GLbegin..GLend pair

begin
	glbegin(GL_POINTS); //draw WHAT? Dots/points/pixels
		if PlotwNeighbors then begin
			gl_PointSize = 8.0;
			//linestyle:=THICK;

		glVertex2s(x, y);
	glend;
	glFlush; //swoosh!
end;


//this is for dividing up the screen or dialogs (in game or in app)
//TP spec says clear the last one assigned
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
   glClear;
end;


//NEW: do you want fullscreen or not?
procedure initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean);

{
GraphDriver:


PC
    if Def mswindows

    endif

    if Def Darwin(OSX)
        if Def fallback:
            use X11 core routines- but only if X11.app (installed in default location) present
        else:
            use CoreGL routines in a window (figure this out in C , first) /GLUT for input and modeswitching 
    endif

    if Def DOS (PTC can help with this)
        int 10 functs go here:
            (Mode switching primarily-- int 10: 3f02 .......)

        Dos and Palette init isnt needed: thats implemented in hardware.
        (This code is designed to mimic the hardware)

        -INPUT needs a looped RING buffer- OSX, X11 and Windows give us one.
    endif

    (else)

    if Def Unix
        if def fallback:
            use X11 core routines
        else:
            use GLUT for input and mode switching
    endif

//no other such PC OS

Android

MBed

    if Def Raspi(or bananaPi)

    endif

    if Def BeageBoard

    endif

    if Def GameDuino(heaven forbid)

    endif

}

var
	bpp,i:integer;
    iconpath:string;
    FetchGraphMode:integer;
//	mode:PSDL_DisplayMode;
//    AudioSystemCheck:integer;
//	rate:integer;
	Half_Width:float;
	Half_Height:float;

begin

  if LIBGRAPHICS_ACTIVE then begin
    if ISConsoleInvoked then begin
        LogLn('Graphics already active.');
    end;
		 {$ifdef lcl}
			ShowMessage('Initgraph: Graphics already active.');
		 {$endif}

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

    //fire and forget- surface formats
    case bpp of

		8: begin
			    if maxColors=256 then MainSurface^.format:=SDL_PIXELFORMAT_INDEX8
				else if MaxColors=64 then MainSurface^.format:=SDL_PIXELFORMAT_INDEX4MSB;
		end;
		15: MainSurface^.format:=SDL_PIXELFORMAT_RGB555;

        //we assume on 16bit that we are in 565 not 5551.
		16: begin
			
			MainSurface^.format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: MainSurface^.format:=SDL_PIXELFORMAT_RGB888;
		32: MainSurface^.format:=SDL_PIXELFORMAT_RGBA8888;

    end;

   //"usermode" must match available resolutions etc etc etc
   //this is why I removed all of that code..."define what exactly"??


//  if WantsAudioToo then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER;
//  if WantsJoyPadAudio then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_JOYSTICK;
//if WantInet then _initflag:= SDL_Init_Net;

//if GLINIT error:

//     _grResult:=GenError; //gen error
//     halt(0); //the other routines are now useless- since we didnt init- dont just exit the routine, DIE instead.


{
  if wantsFullIMGSupport then begin

    _imgflags:= IMG_INIT_JPG or IMG_INIT_PNG or IMG_INIT_TIF;
    imagesON:=IMG_Init(_imgflags);

    //not critical, as we have bmp support but now are limping very very bad...
    if((imagesON and _imgflags) <> _imgflags) then begin
       if IsConsoleInvoked then begin
		 Logln('IMG_Init: Failed to init required JPG, PNG, and TIFF support!');
		 LogLn(IMG_GetError);
	   end;
	   $ifdef lcl
			ShowMessage('IMG_Init: Failed to init required JPG, PNG, and TIFF support');
   	   $endif
    end;
  end;
}


  if (graphdriver = DETECT) then begin
	//probe for it, dumbass...NEVER ASSUME.

       //temporarily not available
	   {$ifdef lcl}
			ShowMessage('Graphics detrection not available at this time.');
   	   {$endif}

//    Fetchgraphmode := DetectGraph; //need to kick back the higest supported mode...
  end;

  NoGoAutoRefresh:=false;
  LIBGRAPHICS_INIT:=true;
  LIBGRAPHICS_ACTIVE:=false;


//force a safe shutdown.
//(NO NEED to call closegraph this way)

//if the app crashes we could be in an unknown state-which is bad.
 AddExitProc(CloseGraph);

{
atexit handling:
basically it prevents random exits- all exits must do whatever is in the routine.


FPC:  AddExitProc(CloseGraph);

TP: use the olschool method:

 OldExitProc := ExitProc;                - save previous exit proc -cpu: push exit()
 ExitProc := @MyExitProc;               - insert our exit proc in chain

$F+
procedure MyExitProc;
begin
  //shut everything down
  ExitProc := OldExitProc;  Restore exit procedure address -cpu: pop exit()
  CloseGraph;               Shut down the graphics system
end;
$F-

}



{  //Hide, mouse.
  if not Render3d then
	SDL_ShowCursor(SDL_DISABLE);


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
		$ifdef lcl
			ShowMessage('SDL cant get the data for the current mode.');
   	   $endif
	end;

  //dont refresh faster than the screen.
  if (mode^.refresh_rate > 0)  then
     //either force a INT- or convert from REAL.

     flip_timer_ms := round(mode^.refresh_rate)

  else
     flip_timer_ms := 17; //60Hz

  video_timer_id := SDL_AddTimer(flip_timer_ms, @videoCallback, nil);
  if video_timer_id=0 then begin
    if IsConsoleInvoked then begin
		Logln('WARNING: cannot set drawing to video refresh rate. Non-critical error.');
		Logln('you will have to manually update surfaces and the renderer.');
    end;
    $ifdef lcl
			ShowMessage('SDL cant set video callback timer.Manually update surface.');
    $endif

    NoGoAutoRefresh:=true; //Now we can call Initgraph and check, even if quietly(game) If we need to issue RenderPresent calls.
  end;
}

//  if flip_timer_ms=17 then rate=60;

  rate:=60; //temp code
  FSMode:=MaxX,'x',MaxY,':',bpp,'@',rate; //build the string

  SetGraphMode(Graphmode,wantFullScreen);

	//the event handler
	GlutMainLoop;


 {
  CantDoAudio:=false;
    //prepare mixer
  if WantsAudioToo then begin
    AudioSystemCheck:=InitAudio;
    if AudioSystemCheck <> 0 then begin
        if IsConsoleInvoked then
                LogLn('There is no audio. Mixer did not init.')
        else  ShowMessage(SDL_MESSAGEBOX_ERROR,'There is no audio. Mixer did not init.','OK',NIL);
    end;

  end;

  //initialization of TrueType font engine
  if TTF_Init = -1 then begin

    if IsConsoleInvoked then begin
        Logln('I cant engage the font engine, sirs.');
    end;
    $ifdef lcl
			ShowMessage('ERROR: I cant engage the font engine, sirs.');
    $endif
		
    _graphResult:=-3; //the most likely cause, not enuf ram.
    closegraph;
  end;
}

//set some sane default variables
  _fgcolor := $FFFFFFFF;	//Default drawing color = white (15)
  _bgcolor := $000000FF;	//default background = black(0)

{
  GL_fgcolor:=1.0;
  GL_bgcolor:=0;
}

  someLineType:= NormalWidth;

//  lineinfo.linestyle:=solidln;
//     fillsettings.pattern:=solidfill;

  ClipPixels := TRUE;

  // Set initial viewport
  StartXViewPort := 0;
  StartYViewPort := 0;
  ViewWidth := MaxX;
  ViewHeight := MaxY;

  // normal write mode
  CurrentWriteMode := CopyPut;

  // set default font (8x8)
//  installUserFont('./fonts/code.ttf', 10,TTF_STYLE_NORMAL,false);

//     CurrentTextInfo.direction:=HorizDir;


  LIBGRAPHICS_ACTIVE:=true;  //We are fully operational now.
  paused:=false;

  _grResult:=OK; //we can just check the dialogs (or text output) now.


	
//gimmie floats from the word based coord system
	floatedMaxX:=Int2Float(MaxX);
	floatedMaxY:=Int2Float(MaxY);


    HALF_WIDTH := floatedMaxX / 2.0f;
    HALF_HEIGHT := floatedMaxY / 2.0f;

    // Setup the projection matrix
    glMatrixMode(GL_PROECTION);
    glLoadIDentity();
    glOrtho(0, MaxX, MaxY, 0.0f, 0.0f, 1000.0f);

    // Setup the BGI-to-view matrix(Allegro uses similar)
    //(setup to that we flip the X axis to get proper co ordinate system)
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(-HALF_WIDTH, HALF_HEIGHT, 0.0f);
    glScalef(1.0f, -1.0f, 1.0f);

	if Render3d then begin
		glEnable(GL_DEPTH_TEST);
		glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
	end

	else begin
		glDisable(GL_DEPTH_TEST);
		glClear(GL_COLOR_BUFFER_BIT);
		
		glEnable(GL_TEXTURE_2D); // Enable 2D Textures
		glEnable(GL_PROGRAM_POINT_SIZE); //enables fat pixels(linestyles);

		//makes no sence in 3D realms to not have a Z axis(depth).
		//we want pixels to override each other by default (unless blending)

    end;	


  where.X:=0;
  where.Y:=0;

{
  SDL_ShowCursor(SDL_ENABLE);

  //Check for joysticks
  if WantsJoyPad then begin

    if( SDL_NumJoysticks < 1 ) then begin
        if IsConsoleInvoked then
			Logln( 'Warning: No joysticks connected!' );
    $ifdef lcl
			ShowMessage('Warning: No joysticks connected!');
    $endif

    end else begin //Load joystick
	    gGameController := SDL_JoystickOpen( 0 );

        if( gGameController = NiL ) then begin
	        if IsConsoleInvoked then begin
		    	Logln( 'Warning: Unable to open game controller! SDL Error: '+ SDL_GetError);
                LogLn(SDL_GetError);
            end;
    $ifdef lcl
			ShowMessage('Warning: Unable to open game controller!');
    $endif

            noJoy:=true;
        end;
        noJoy:=false;
    end;
  end; //Joypad
}

end; //initgraph

//uos will handle Audio

procedure closegraph;
var
	Killstatus,Die:cint;
    waittimer:integer;

//free only what is Allocated, nothing more- then make sure pointers are empty.
begin

  LIBGRAPHICS_ACTIVE:=false;  //Unset the variable (and disable all of our other functions in the process)

{
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
   video_timer_id := 0;


   SDL_DestroyMutex(eventLock);
   eventLock := nil;

   SDL_DestroyCond(eventWait);
   eventWait := nil;

  if (TextFore <> Nil) then begin
	TextFore:=Nil;
	dispose(TextFore);
  end;
  if (TextBack <> Nil) then begin
	TextBack:=Nil;
	dispose(TextBack);
  end;
  TTF_CloseFont(ttfFont);
  TTF_Quit;
  //its possible that extended images are used also for font datas...
  if wantsFullIMGSupport then
     IMG_Quit;

  x:=8;
  repeat
	if (Textures[x]<>Nil) then
		SDL_DestroyTexture(Textures[x]);
		Textures[x]:=Nil;
    dec(x);
  until x=0;


//Dont free whats not Allocated in initgraph(do not double free)
//routines should free what they AllocMemate on exit.

  if (MainSurface<> Nil) then begin
	SDL_FreeSurface( MainSurface );
	MainSurface:= Nil;
  end;	

  if not Render3d then begin
	if (Renderer<> Nil) then begin
		Renderer:= Nil;
		SDL_DestroyRenderer( Renderer );
	end;	
}

  glutLeaveMainLoop;
  Window:=Nil;

  if IsConsoleInvoked then begin
         textcolor(7); //..reset standards...
         clrscr; //text clearscreen
         writeln;
  end;

  halt(0); //nothing special, just bail gracefully.
end;            	

//not really used
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

//"X pixels into the screen (or buffer) is the location of XY"
var
	pitch:integer;
begin
//ATI HD7850 -in console mode

  pitch:=54928;
  x:=where.X;
  y:=where.Y;
  GetXY := (y * (pitch mod (sizeof(word)) ) + x);
end;


procedure glutInitPascal;
var
	myargc:integer;
	myargv: PChar;
begin
	//dummy this- seems to fire with or without data, according to C devs.
	myargc:=1;
	myargv:='LazGFX';
	glutInit(myargc, myargv);
end;


//all callbacks need to be 'C declared'

procedure DrawGLScene; cdecl;
begin
  if Render3d then
	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  else	
	glClear(GL_COLOR_BUFFER_BIT); //no Z axis to work with

  glutSwapBuffers; //glFlush;
end;

procedure ReSizeGLScene(Width, Height: Integer); cdecl;
begin
  if Height = 0 then
    Height := 1;

  glViewport(0, 0, MaxX, MaxY);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(45, Width mod Height, 0.1, 1000);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;


end;

//isnt this easy?
procedure GLKeyboard(Key: Byte); cdecl;
begin
  if Key = 27 then //ESC
    Halt(0); //make sure all Halt commands and errors call closegraph!
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
    GLmode:PChar;

begin
//we can do fullscreen, but dont force it...
//"upscale the small resolutions" is done with fullscreen.
//(so dont worry if the video hardware doesnt support it)


//if not active:
//are we coming up?
//no? EXIT

	if (LIBGRAPHICS_INIT=false) then begin
		
		if IsConsoleInvoked then
			Logln('Call initgraph before calling setGraphMode.')
		else
    {$ifdef lcl}
			ShowMessage('setGraphMode called too early. Call InitGraph first.');
    {$endif}

	    exit;
	end
	else if (LIBGRAPHICS_INIT=true) and (LIBGRAPHICS_ACTIVE=false) then begin //initgraph called us
			glutInitPascal(False);

			glutInitWindowSize(MaxX, MaxY);
		case(bpp) of: //with chosen resolutions bpp do
		//always use double buffering(pageFLipping)
		//force a compatible 555 15bit depth		
		//force a compatible 565 16bit depth
        //4bit is a limited paletted 8 bit mode (mode hack)

			4:GLMode:='index double';
			8:GLMode:='index double';
			15:GLMode:='rgb depth=15 double';
			16:GLMode:='red=5 green=6 blue=5 depth=16 double';
			24:GLMode:='rgb double';
			32:	GLMode:='rgba double';
		end; //case
		glutInitDisplayString(GLMode);
		if WantsFullScreen then begin
				glutGameModeString(FSMode);
				glutEnterGameMode;
				glutSetCursor(GLUT_CURSOR_NONE);
		end else begin //windowed
			
			ScreenWidth := glutGet(GLUT_SCREEN_WIDTH);
			ScreenHeight := glutGet(GLUT_SCREEN_HEIGHT);
			glutInitWindowPosition((ScreenWidth - AppWidth) div 2, (ScreenHeight - AppHeight) div 2);
			glutCreateWindow('Lazarus Graphics Application');
			
		end
	    prepareOpenGL;	

	   	//r,g,b=0,a=1
		glClearColor( 0.f, 0.f, 0.f, 1.f );
		glClear( GL_COLOR_BUFFER_BIT );
		
		//set callbacks-you need to override- or define these
		//external declarations.
		glutDisplayFunc(@DrawGLScene);
		glutReshapeFunc(@ReSizeGLScene);
		glutKeyboardFunc(@GLKeyboard);
		glutMouseFunc(@GLMouse);
		glutIdleFunc(@DrawGLScene);

    end; //setup renderer

	glutSetIconTitle(iconpath);


    if bpp=4 then
      InitPalette16
    else if bpp=8 then
      InitPalette256;

	if (bpp<=8) then begin
		for x:=0 to MaxColors do begin
			if MaxColors =16 then
				glutSetColor(x,ByteToFloat(Tpalette16.colors[x]^.r),ByteToFloat(Tpalette16.colors[x]^.g),ByteToFloat(Tpalette16.colors[x]^.b))
			else if MaxColors =256 then
				glutSetColor(x,ByteToFloat(Tpalette256.colors[x]^.r),ByteToFloat(Tpalette256.colors[x]^.g),ByteToFloat(Tpalette256.colors[x]^.b))
			inc(x);
		end;
	end;

	LIBGRAPHICS_ACTIVE:=true;
	exit; //back to initgraph we go.

	end else if (LIBGRAPHICS_ACTIVE=true) then begin //good to go
    //modeChange

		if Render3d then //we use DEPTH(3D) instead of 2D QUADS
			glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB or GLUT_DEPTH);
		
		glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB);	
		if WantsFullScreen then begin
				glutGameModeString(FSMode);
				glutEnterGameMode;
				glutSetCursor(GLUT_CURSOR_NONE);
		end else begin //windowed
			
			glutInitWindowSize(MaxX, MaxY);
		case(bpp) of: //with chosen resolutions bpp do
		//always use double buffering(pageFLipping)
		//force a compatible 555 15bit depth		
		//force a compatible 565 16bit depth
        //4bit is a limited paletted 8 bit mode (mode hack)

			4:GLMode:='index double';
			8:GLMode:='index double';
			15:GLMode:='rgb depth=15 double';
			16:GLMode:='red=5 green=6 blue=5 depth=16 double';
			24:GLMode:='rgb double';
			32:	GLMode:='rgba double';
		end; //case
		glutInitDisplayString(GLMode);
		if WantsFullScreen then begin
				glutGameModeString(FSMode);
				glutEnterGameMode;
				glutSetCursor(GLUT_CURSOR_NONE);
		end else begin //windowed
			
			ScreenWidth := glutGet(GLUT_SCREEN_WIDTH);
			ScreenHeight := glutGet(GLUT_SCREEN_HEIGHT);
			glutInitWindowPosition((ScreenWidth - AppWidth) div 2, (ScreenHeight - AppHeight) div 2);
			glutCreateWindow('Lazarus Graphics Application');
			
		end
	    prepareOpenGL;	

	   	//r,g,b=0,a=1
		glClearColor( 0.f, 0.f, 0.f, 1.f );
		glClear( GL_COLOR_BUFFER_BIT );
		
		//set callbacks-you need to override- or define these
		//external declarations.
		glutDisplayFunc(@DrawGLScene);
		glutReshapeFunc(@ReSizeGLScene);
		glutKeyboardFunc(@GLKeyboard);
		glutMouseFunc(@GLMouse);
		glutIdleFunc(@DrawGLScene);

    end; //setup renderer

	glutSetIconTitle(iconpath);


    if bpp=4 then
      InitPalette16
    else if bpp=8 then
      InitPalette256;

	if (bpp<=8) then begin
		for x:=0 to MaxColors do begin
			if MaxColors =16 then
				glutSetColor(x,ByteToFloat(Tpalette16.colors[x]^.r),ByteToFloat(Tpalette16.colors[x]^.g),ByteToFloat(Tpalette16.colors[x]^.b))
			else if MaxColors =256 then
				glutSetColor(x,ByteToFloat(Tpalette256.colors[x]^.r),ByteToFloat(Tpalette256.colors[x]^.g),ByteToFloat(Tpalette256.colors[x]^.b))
			inc(x);
		end;
	end;

  end; //already in gfx mode
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
            LogLN('Cant find current mode in modelist.');
        end;

    {$ifdef lcl}
			ShowMessage('ERROR: Cant find current mode in modelist.');
    {$endif}

   end;
end;

procedure restorecrtmode; //wrapped closegraph function
begin
  if (not LIBGRAPHICS_ACTIVE) then begin //if not in use, then dont call me...

	if IsConsoleInvoked then begin
        LogLn('you didnt call initGraph yet...try again?');
        exit;
    end;
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
Blittering and doing things by hand is very ancient means of doing things.
OpenGL fills in the pixels for us- this is no longer needed, nor is the math for it.

SDL_ScrollX(Surface,DifX);
SDL_ScrollY(Surface,DifY);

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
				else if MaxColors=64 then format:=SDL_PIXELFORMAT_INDEX4MSB;
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
    if ((MaxColors=256) or (MaxColors=64)) then TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 8, format)
    //its weird...get 4bit indexed colors list in longword format but force me into 256 color mode???

    else if (MaxColors>256) then begin
        case (bpp) of
		    15: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 15, format);
			16: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 16, format);
			24: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 24, format);
			32: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 32, format);
			else begin
    {$ifdef lcl}
			ShowMessage('Wrong bpp given to get a pixel. I dont how you did this.');
    {$endif}

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
          if MaxColors=64 then begin
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
		     gotcolor^.g:=(byte(^g) );
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
      {$ifdef lcl}
			ShowMessage('Cant Get Pixel values...');
      {$endif}

         if IsConsoleInvoked then
                LogLn('Cant Get Pixel values...');
    end; //case

    SDL_FreeSurface(Tempsurface);

end;

Procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word);
//use SDL_SetRenderDrawColor to set the _fgcolor
//color is already set- just drop a pixel HERE
begin

  if (bpp<4) or (bpp >32) then

  begin
    {$ifdef lcl}
			ShowMessage('Cant Put Pixel values...');
    {$endif}
            if IsConsoleInvoked then
                LogLn('Cant Put Pixel values...');
			exit;
  end;

  SDL_RenderDrawPoint( Renderer, X, Y );

end;

//PUT a pixel HERE- with THIS color
procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word; color:byte); overload;
//indexed
var
	someColor:PSDL_Color;
	r,g,b:byte;

begin
//these are in an array already.

//wrong routine called
  if bpp>8 then exit;

  if (bpp=4) then
	someColor:=Tpalette16.Colors[color]
  else if (bpp=8) then
	someColor:=Tpalette256.Colors[color];
	
	r:=somecolor^.r;
	g:=somecolor^.g;
	b:=somecolor^.b;

	SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_NONE);
	SDL_SetRenderDrawColor(renderer, r, g, b, 255);
	SDL_RenderDrawPoint(renderer, x, y);
end;

//RGB colors above 256 paletted mode
procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word; r,g,b:byte); overload;

begin
	SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_NONE);
	SDL_SetRenderDrawColor(renderer, r, g, b, 255);
	SDL_RenderDrawPoint(renderer, x, y);
end;

procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word; r,g,b,a:byte); overload;

begin
	SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
	SDL_SetRenderDrawColor(renderer, r, g, b, a);
	SDL_RenderDrawPoint(renderer, x, y);
end;	
	


function getdrivername:string;
begin
//not really used anymore-this isnt dos

   getdrivername:='Internal.SDL'; //be a smartASS
end;


//we should limit detectGraph calls also and allow quick checks if libGfx is already active.

Function detectGraph:byte; 
//should return max mode supported(enum value) -but cant be negative
//called *once* per "graphics init"-which is only called "if not active".

//we detected a mode or we didnt. 
//If we failed, exit. (we should have at least one graphics mode)
//if we succeeeded- we already have the higest mode supported.

//use xrandr for this. Its been done in C- lets do it in Pascal.

//(nobody else has done this- much a talk about nothing)

var

    i,testbpp:integer;

begin

if ((IsGraphicsActive=false) and (InitGraph=true)) then begin//coming up

//pull the current mode from xrandr.
//calls to detect graph ASSUME you want the highest mode available. 
//(hint: its probly already set- but what is it?)



//    DetectGraph:=;
    exit;
end else
    //we already have the highest mode. Pull the stored variable.
    DetectGraph:=HighestMode;

end; //detectGraph

{
save/restore video states = saving to RAM, not DISK the current output(2d).
This can use a BMP image record, etc.

On TP7 this pushes/pops the text mode around init and close graph.
whatever was on screen before the context switch is stored and reset
(generally- its the same idea)


however- we are in a windowing environment (usually).
on init we tell that we want a window. Windows have drawables.
We let GL make us a canvas to work with.

since theres no text mode setup- theres nothing to store and recall

THIS IS NOT TRUE is using framebuffered console output(DOS-ish crt).

NOTE:
    OSX prevents most users from running as single user-root.
    Therefore you will NOT have a framebuffered console. This is for other unices.
    

these are basically the same within SDL code but its hidden from you.
you need to know the depth in SDL because of bpp fiasco.

what happens is this:
    you are in 24 or 32bpp native but want a texture/surface with less data.
    internally its still stored(byte packed as 24/32 bit data)
    retrieving the data now results in the wrong data- you have to manipulate it back.
        -this fucks with GetPixel

SDL tries to alleiviate this headache- but inadvertently make more headache w SDL2 Textures.
   while you can render to Texture(offscreen buffer, subwindow,tile) its often better just to update a BufferedRect. 

}


//this only works with RGB8888 mode
function RGBToHex32(color:SDL_Color):DWord;
begin
{$ifndef mswindows}
//RGBA
    RGBToHex32 := (color^.r or (color^.g shl 8) or (color^.b shl 16) or (color^.a shl 24));
{$endif}

{$ifdef mswindows}
//ABGR
    RGBToHex32 := (color^.a or (color^.b shl 8) or (color^.g shl 16) or (color^.r shl 24));
{$endif}
end;

function Hex32ToRGB(someDWord:DWord):SDL_Color;
var
    red,green,blue,alpha:byte;
    someColor:SDL_Color;
begin

//RGBA Mask

{$ifdef mswindows}
//use a color mask and fetch only that data, then put it into a byte.
   someColor^.r := (colour & 0xFF000000) >> 16;
   someColor^.g := (colour & 0x00FF0000) >> 16;
   someColor^.b := (colour & 0x0000FF00) >> 16;
   someColor^.a := (colour & 0x000000FF) >> 16;
{$endif}

{$ifdef mswindows}
   someColor^.r :=   (colour & 0x000000FF) >> 16;
   someColor^.g := (colour & 0x0000FF00) >> 16;
   someColor^.b :=  (colour & 0x00FF0000) >> 16;
   someColor^.a := (colour & 0xFF000000) >> 16;

{$endif}

  Hex32ToRGB:=someColor;
end;


procedure saveVideoState;
//leaving text mode for graphics mode
begin
{$ifndef fallback}
    LogLn('function not implemented: restoreVideoState. Nothing to save.');
{$endif}

end;

procedure restoreVideoState;
//leaving graphics mode for text mode
begin
{$ifndef fallback}
    LogLn('function not implemented: restoreVideoState. Nothing to restore.');
{$endif}

end;

{
//CGA is a RPITA- you probly want EGA.

//pallettes h:

var
    CGAPalette: array [0..3] of palette4; //we have 4 -4bit pallettes
    
procedure initCGAPalette0;

begin
        palette4^.DWords[1]:=
        palette4^.DWords[2]:=
        palette4^.DWords[3]:=
        
        palette4^.colors[1]^.r:=
        palette4^.colors[1]^.g:=
        palette4^.colors[1]^.b:=

        palette4^.colors[2]^.r:=
        palette4^.colors[2]^.g:=
        palette4^.colors[2]^.b:=

        palette4^.colors[3]^.r:=
        palette4^.colors[3]^.g:=
        palette4^.colors[3]^.b:=

//set OpenGL palette entry 0..3

end;

procedure initCGAPalette1;

begin
        palette4^.DWords[1]:=
        palette4^.DWords[2]:=
        palette4^.DWords[3]:=
        
        palette4^.colors[1]^.r:=
        palette4^.colors[1]^.g:=
        palette4^.colors[1]^.b:=

        palette4^.colors[2]^.r:=
        palette4^.colors[2]^.g:=
        palette4^.colors[2]^.b:=

        palette4^.colors[3]^.r:=
        palette4^.colors[3]^.g:=
        palette4^.colors[3]^.b:=

//set OpenGL palette entry 0..3

end;

procedure initCGAPalette2;

begin
        palette4^.DWords[1]:=
        palette4^.DWords[2]:=
        palette4^.DWords[3]:=
        
        palette4^.colors[1]^.r:=
        palette4^.colors[1]^.g:=
        palette4^.colors[1]^.b:=

        palette4^.colors[2]^.r:=
        palette4^.colors[2]^.g:=
        palette4^.colors[2]^.b:=

        palette4^.colors[3]^.r:=
        palette4^.colors[3]^.g:=
        palette4^.colors[3]^.b:=

//set OpenGL palette entry 0..3

end;

procedure initCGAPalette3;

begin
        palette4^.DWords[1]:=
        palette4^.DWords[2]:=
        palette4^.DWords[3]:=
        
        palette4^.colors[1]^.r:=
        palette4^.colors[1]^.g:=
        palette4^.colors[1]^.b:=

        palette4^.colors[2]^.r:=
        palette4^.colors[2]^.g:=
        palette4^.colors[2]^.b:=

        palette4^.colors[3]^.r:=
        palette4^.colors[3]^.g:=
        palette4^.colors[3]^.b:=

//set OpenGL palette entry 0..3

end;

//initgraph:

    case bpp of:
        4: case CGAMode of
                //get the requested resolution

                0: initCGAPalette0;
                1: initCGAPalette1;
                2: initCGAPalette2;
                3: initCGAPalette3;
          end else begin  
            LogLn('invalid CGA palette mode-initgraph aborting');
            exit;
          end;  


var
    pixels: array [0..( texWidth * texHeight * 4 )] of byte;

}

//B+W=1bit

//1/4 of available palette used:
//CGA modes=2bit (only 4 colors used out of 16)
//EGA modes=4bit (only 16 colors used out of 64)


//4 and 8 bits modes:
//we have to get a longword in 24+ bpp color mode - from the "screen context"
//then pull the "RGB pair" out of the palette somehow

{
SDL wont support this, but OpenGL will:
64bit color.

RGBA64 =record
        R, G, B, A :Word; 
end;

}

function RGB4FromLongWord(Someword:Longword):SDL_Color;

begin
var
    LoColor,color:SDL_Color;
    index:=byte;

begin

{
method 1:

fetch DWord, break it apart, check wether it complies with 4bit specs
its either high or low intensity

 Abit:= (SomeDWord and $ff);
 if ((Abit and 8)!=0) then 
    color^.a:=$ff 
 else 
    color^.a:=$7f;

 Rbit:= (someword shr 24) mod 255;
 if ((Rbit and 4)!=0) then 
    color^.r:=RBit +191; 
 else 
    color^.r:=RBit;

 Gbit:= (((someword shr 16) and $ff) mod 255);
 if ((Gbit and 4)!=0) then 
    color^.r:=GBit +191; 
 else 
    color^.r:=GBit;

 Bbit:= ((someword shr 8 and $ff) mod 255);
 if ((Bbit and 4)!=0) then 
    color^.r:=BBit +191; 
 else 
    color^.r:=BBit;

Method 2:
    just check the damn palette Dword entries. (or the on-the-fly converted values thereof)
}

    if MaxColors =4 then begin
        x:=0;
        repeat
            if  ((RGBToHex32(palette4^.Colors[x])=SomeWord) then begin //we found a match
                 RGB4FromLongWord:= palette4^.colors[x];
                 exit;
            end;
            inc(x);
        until x=4;
        else begin //data invalid
             color^.r := $00;
             color^.g:= $00;
             color^.b:= $00;
             color^.a:= $00;
            RGB4FromLongWord:= color;
            exit;
        end;
    end;

    if MaxColors =16 then begin
        //use the DWord to check the limited pallette for a match. Do not shift splitRGB values.
        x:=0;
        repeat
            if  ((RGBToHex32(palette16^.Colors[x])=SomeWord) then begin //we found a match
                 RGB4FromLongWord:= color;
                 exit;
            end;
            inc(x);
        until x=16;
    end else begin //data invalid
             color^.r := $00;
             color^.g:= $00;
             color^.b:= $00;
             color^.a:= $00;
            RGB4FromLongWord:= color;
            exit;
    end;


end;

function RGB8FromLongWord(Someword:Longword):SDL_Color
var
    color:SDL_Color;
begin

{$ifndef mswindows}

//get the DWord
    color^.r:= (someword shr 24) mod 255;
    color^.g:= (((someword shr 16) and $ff) mod 255);
    color^.b:= ((someword shr 8 and $ff) mod 255);
    color^.a:= $ff;
{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color^.b:= (someword shr 16) mod 255;
    color^.g:= (((someword shr 8) and $ff) mod 255);
    color^.r:= ((someword and $ff) mod 255);
    color^.a:=$ff;

{$endif}    

    
//CGA,EGA is 4bit, not 8. That was a SDL hack.

    if MaxColors=256 then begin
    //to save time - and hell on me- let use the RGB pair from the DWord and compare it to whats in the palette, unshifted.
        x:=0;
        repeat
            if  (palette256^.colors[x]^.r=color^.r) and (palette256^.colors[x]^.g=color^.g) and (palette256^.colors[x]^.b=color^.b) then begin
                RGB8FromLongWord:= color;
                exit;
            end;
            inc(x);
        until x=256;
    end else begin //data invalid
             color^.r := $00;
             color^.g:= $00;
             color^.b:= $00;
             color^.a:= $00;
            RGB8FromLongWord:= color;
    end;
end;

//if you get hell- you shouldnt- take off the 255 limiter

function RGB5551FromLongWord(Someword:Longword):SDL_Color;
var
    HiWord:Word;
    color:SDL_Color;
begin

{$ifndef mswindows}

//get the DWord
    color^.r:= (someword shr 16) mod 255;
    color^.g:= (((someword shr 8) and $ff) mod 255);
    color^.b:= ((someword and $ff) mod 255);
    color^.a:=$ff;
{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color^.b:= (someword shr 16) mod 255;
    color^.g:= (((someword shr 8) and $ff) mod 255);
    color^.r:= ((someword and $ff) mod 255);
    color^.a:=$ff;

{$endif}

//333 mod

    color^.r:= color^.r shr 3;
    color^.g:= color^.g shr 3;
    color^.b:= color^.b shr 3;

    RGB5551FromLongWord:=color;
end;

function RGB565FromLongWord(Someword:Longword):SDL_Color;
var
    HiWord:Word;
    color:SDL_Color;
begin
{$ifndef mswindows}

//get the DWord
    color^.r:= (someword shr 16) mod 255;
    color^.g:= (((someword shr 8) and $ff) mod 255);
    color^.b:= ((someword and $ff) mod 255);
    color^.a:=$ff;
{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color^.b:= (someword shr 16) mod 255;
    color^.g:= (((someword shr 8) and $ff) mod 255);
    color^.r:= ((someword and $ff) mod 255);
    color^.a:=$ff;

{$endif}
//323 mod
    color^.r:= color^.r shr 3;
    color^.g:= color^.g shr 2;
    color^.b:= color^.b shr 3;

    RGB565FromLongWord:=color;
end;

//theres no alpha bit here
function RGBFromLongWord24(SomeDWord:LongWord):SDL_Color;

var
    color:SDL_Color;

begin
{$ifndef mswindows}


//get the DWord
    color^.r:= (someword shr 24) mod 255;
    color^.g:= (((someword shr 16) and $ff) mod 255);
    color^.b:= ((someword shr 8 and $ff) mod 255);
    color^.a:= $ff;
{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color^.b:= (someword shr 16) mod 255;
    color^.g:= (((someword shr 8) and $ff) mod 255);
    color^.r:= ((someword and $ff) mod 255);
    color^.a:=$ff;

{$endif}    

    RGBFromLongWord:=color;
end;

//there IS an alpha bit here
function RGBAFromLongWord(SomeDWord:LongWord):SDL_Color;

var
    color:SDL_Color;

begin

{$ifndef mswindows}

    color^.r:= (someword shr 24) mod 255;
    color^.g:= (((someword shr 16) and $ff) mod 255);
    color^.b:= ((someword shr 8 and $ff) mod 255);
    color^.a:= (someword and $ff);

{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color^.b:= (someword shr 24) mod 255;
    color^.g:= (((someword shr 16) and $ff) mod 255);
    color^.r:= ((someword shr 8 and $ff) mod 255);
    color^.a:= (someword and $ff);

{$endif}
    RGBFromLongWord:=color;
end;



{
putpixel (2D coords in a 1d array):

(x+y*pitch)

  case CurrentWriteMode of
    XORPut:
      begin
        pixels[x+y*PTCWidth] := pixels[x+y*PTCWidth] xor CurrentColor;
      end;
    OrPut:
      begin
        pixels[x+y*PTCWidth] := pixels[x+y*PTCWidth] or CurrentColor;
      end;
    AndPut:
      begin
        pixels[x+y*PTCWidth] := pixels[x+y*PTCWidth] and CurrentColor;
      end;
    NotPut:
      begin
        pixels[x+y*PTCWidth] := CurrentColor xor $FFFF; //32: FFFFFFFF
      end
  else
    pixels[x+y*PTCWidth] := CurrentColor;
  end;
}

function getPixel(x,y:word):SDL_Color;

begin

    case bpp of:

    //these top two have to fetch exactly our palette definitions
        4:
            GetPixel:=RGB4FromLongWord(pixels[x*y*4]);
        8:
            GetPixel:=RGB8FromLongWord(pixels[x*y*4]);

    //these dont have palettes, but are limited
    //5551 or 565?- make sure data is in the right format

        15: 
            GetPixel:=RGB5551FromLongWord(pixels[x*y*4]);
        16:
            GetPixel:=RGB565FromLongWord(pixels[x*y*4]);

    //these two fetch the same, 32bit can have alpha-bit set different then $ff    

        24:
            GetPixel:=RGBFromLongWord24(pixels[x*y*4]);

        32:
            GetPixel:=RGBAFromLongWord(pixels[x*y*4]);

    end; //case

end;

}


//hex value, not palette number
function EGAtoVGA(color: LongWord): LongWord;
begin
  EGAtoVGA := color shl 2;
end;

{
surface/texture locking:

you cant update a surface/texture while rendering to it.
Generally not a problem w either the backbuffer- or 2D rendering in general

This is only an issue if you update (screen refresh) and dont bother to check if you are currently rendering.
What you do is set a "Paused or RenderingDone flag" instead and avoid all of the un-necessary "fiasco code".

**boolean FLAGS save your ass every time**

}

//PasPTC uses these for another use- we can use fat pixels or 2x2 scaling (and possible AA smoothing) instead.
//I dont care if your are in FS or not

//you would be quadupling CGA resolutions- which is why EGA is generally used instead.

//test if these modes are set
function Double320x200: Boolean;
begin
  Double320x200 := ((MaxX=320) and (MaxY=200) and (DoubleSize=true));
end;

function Double320x240: Boolean;
begin
  Double320x240 := ((MaxX=320) and (MaxY=240) and (DoubleSize=true));
end;

//fpc modified (freed) from Lazarus (G)oop
procedure FreeAndNil(q:Pointer);
begin
  q:= Nil;
  Dispose(q);
end;

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
//cga/ega are off now...

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
				Logln('Unknown graphdriver setting.');
    {$ifdef lcl}
			ShowMessage('Unknown graphdriver setting.');
    {$endif}

		end;
	end;
end; //getModeRange



//(Its an odd rare case,such as TnL --not discussed here)

function cloneSurface(surface1:PSDL_Surface):PSDL_Surface;
//Lets take the surface to the copy machine...

begin
    cloneSurface := Surface1;
end;

{viewports-
    the trick is that we are technically always in one(FPC).
    the joke is:
         what are the co ords?

this might not be BGI spec- but it makes sense.

}

//create a shrunken viewport within the screen - like your bios boot logo-
// but set background color to background color(its only black if not changed).
procedure BGColorBorderViewPort(Rect:SDLRect);

begin
    setViewport(0,0,MaxX,MaxY);
    if Rect^.x >0 and Rect^.x >0 and Rect^.w < MaxX and Rect^.h < MaxY then begin
        glClearColor(_bgcolor^.r,_bgcolor^.g,_bgcolor^.b, $FF);
        setViewPort(Rect^.x, Rect^.y,Rect^.w, Rect^.h);
    end else 
        exit;
end;


//create a shrunken viewport within the screen - like your bios boot logo-
// but set background color to something other than black.
procedure ColorBorderViewPort(Rect:SDLRect; color:SDL_Color);

begin
    setViewport(0,0,MaxX,MaxY);
    if Rect^.x >0 and Rect^.x >0 and Rect^.w < MaxX and Rect^.h < MaxY then begin
        glClearColor(color^.r,color^.g,color^.b,color^.a);
        setViewPort(Rect^.x, Rect^.y,Rect^.w, Rect^.h);
    end else 
        exit;
end;


procedure SetViewPort(Rect:PSDL_Rect);

var
    LastRect:PSDL_Rect;
    ScreenData:Pointer;
    infosurface,savesurface:PSDL_Surface;

begin
//freeze movement
   if windownumber=8 then begin
    {$ifdef lcl}
			ShowMessage('Attempt to create too many viewports.');
    {$endif}

      if IsConsoleInvoked then
        LogLn('Attempt to create too many viewports.');
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

    {$ifdef lcl}
			ShowMessage('Couldnt create SDL_Surface from renderer pixel data');
    {$endif}


      LogLn('Couldnt create SDL_Surface from renderer pixel data. ');
      LogLn(SDL_GetError);
      exit;

  end;

   Textures[windownumber]:=SDL_CreateTextureFromSurface(renderer,saveSurface);

   //free data
   SDL_FreeSurface(saveSurface);

   saveSurface := NiL;
   infosurface:=Nil;
   ScreenData:=Nil;


   SDL_RenderSetViewport( Renderer, Rect );
   clearviewport(_fgcolor);

   //"Clipping" is a joke- we always clip.
   //The trick is: do we zoom out? In Most cases- NO. We zoom IN.

end;


procedure RemoveViewPort(windownumber:byte);
//the opposite of above...
//set the last window coords..(we might be trying to write to them)
//and redraw the prior window (from a texture or the camera angle) as if the last window was not there.
var
  ThisRect,LastRect:PSDL_Rect;

begin

   if windownumber=0 then begin

    {$ifdef lcl}
			ShowMessage('Attempt to remove non-existant viewport.');
    {$endif}

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

        Textures[windownumber]:=nil; //Destroy the current Texture

        SDL_RenderCopy(renderer,Textures[windownumber-1],Nil,LastRect);
        SDL_RenderPresent(renderer);

		SDL_RenderSetViewport( Renderer, LastRect );
        dec(windownumber);
        //unfreeze movement
        Paused:=False;
        exit;
   end;
   //else: last window remaining
   Textures[1]:=nil;
   SDL_RenderSetViewport( Renderer,nil);  //reset to full size "screen"

   //this only works if we freeze input and dont update the screen- otherwise, we jitter
   // and update with old data on the "overlayed area".

   SDL_RenderCopy(Renderer,Textures[0],nil,LastRect);
   SDL_RenderPresent(renderer); //and update back to the old screen before the viewports came here.

   LastRect^.X:=0;
   LastRect^.Y:=0;
   LastRect^.W:=MaxX;
   LastRect^.H:=MaxY;

   dec(windownumber);

   //unfreeze movement
   Paused:=False;
end;


//compatibility

procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
begin
    {$ifdef lcl}
			ShowMessage('Function No longer supported: InstallUserDriver');
    {$endif}

   LogLn('Function No longer supported: InstallUserDriver');
end;

procedure RegisterBGIDriver(driver: pointer);
//the only way possible was for DOS.
begin
    {$ifdef lcl}
			ShowMessage('Function No longer supported: RegisterBGIDriver');
    {$endif}


   LogLn('Function No longer supported: RegisterBGIDriver');
end;


function GetMaxColor: word;
//Use "MaxColors" if looking to use Random(Color).
//This gives you the HUMAN READABLE MAX amount of colors available.

begin
//bpp sets this
      GetMaxColor:=MaxColors+1; // based on an index of zero so add one 255=>256
end;


//Allocate a new texture and flap data onto screen (or scrape data off of it) into a file.

//yes we can do other than BMP.


type
    PImage=^Image;
    Image=array of Byte;

//these two have a syntax bug in someone else code. Use Kronos spec.

procedure LoadImageTexture(filename:PChar; Rect:PSDL_Rect);
//Rect: I need to know what size you want the imported image, and where you want it.

var
  tex:TextureID;
  
begin
   Pimage:=SOIL_load_image(filename, Rect^.w, Rect^.h, 0, SOIL_LOAD_RGB);
//Rect^.x,Rect^.y
//   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, image);
   SOIL_free_image_data(image);
end;

procedure LoadImageBackground(filename:PChar);

var
  tex:PSDL_Texture;

begin
   Pimage:=SOIL_load_image(filename, MaxX, MaxY, 0, SOIL_LOAD_RGB);
//0,0 to MaxX,MaxY
//   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, image);
   SOIL_free_image_data(image);
end;

//linestyle is: (patten,thickness) "passed together" (QUE)
//this uses thickness variable only

procedure PlotPixelWNeighbors(x,y:integer; TurnSmoothingOn:boolean);
//this makes the bigger Pixels

// (in other words "blocky bullet holes"...)

begin
  if turnsmoothingon then
  GL_Enable(smooth);

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
   //ensure fills are on
   GL_Rects(Rect^.x,Rect^.y,Rect^.w,Rect^.h);
   dispose(Rect);
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

if turnsmoothingon then
   GL_Disable(smooth);

end;

//FIXME: libSOIL
procedure SaveBMPImage(filename:string);

begin
end;


//gotoxy
Procedure MoveTo(X,Y: Word);
//precursor to functions that dont explicity use XY. 
//Rather they assume XY is set before an operation.

//there is no GOTOXY in graphics modes as per BGI spec- and Im not rewriting the spec.
//its called: Moveto 
Begin
  glRasterPos2s(x, y);
end;


//utility functions:

function DWordToFloat(Data: DWord; EndianSwap: Boolean): Single;

var
   ASingle: Single absolute Data;

begin
   if EndianSwap then
		SwapEndian(DWord(Data));

   DWordToSingle := ASingle;
end;

begin  //main()
{$IFDEF debug}
        Log:=true; //we have output window in DEBUG mode (in windows too!)
{$ENDIF}

//while I dont like the assumption that all linux apps are console apps- technically its true.

{$IFDEF LCL}
		IsConsoleInvoked:=false; //ui app- NO CONSOLE AVAILABLE
{$ENDIF}

{$IFDEF mswindows}
	if ((not IsWindowsXP) or (not IsVistaOrGreater)) then
		LogLn('OpenGL 2.0+ not detected on Windows or not running in Win32 environment.');
		LogLn('Try SDL v.1 routines on these platforms.');
		LogLN('Laz Gfx refusing to run.');
		halt(0);
{$endif}

{$IFDEF unix}
  IsConsoleInvoked:=true; //All Linux apps are console apps

  if (GetEnvironmentVariable('DISPLAY') = '') then begin //init frameBuffer code here

       //insert libPTC or fbGFX here

    //old behaviour
    LogLN('X11 has not fired. Bailing.');	
    halt(0);

  end;
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
