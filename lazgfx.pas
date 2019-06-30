Unit LazGFX;
{

**LAZARUS/FreePAscal GRAPHICS CORE LIBRARY**

A "fully creative rewrite" of the "Borland Graphic Interface" (c) 2017 (and beyond) by Richard Jasmin
with the assistance of others.

This code **should** port or crossplatform build, but no guarantees.
SEMI-"Borland compatible" w modifications.

This is the GL port- not the SDL one.


***** WARNING ******
GLUT (and similar) code may be "irreprebly fucked".
****  WARNING ****

Lazarus/ Typhon IDEs can use the LazGL FPContext demo as a base.
(You may be able to CHEAT and use this setup in "console mode"- but you may have issues with "class instantiation" and exceptions-
which were really made for graphics apps. DEBUGGING MAY BECOME a HEADACHE.)

Since these IDEs "run Units"(wrong- you run applications) we might be able to just "include" this code.
 
Ultimately- Lazarus UI apps are the goal- however, embedded systems (think LCARS) like the Pi-
may not have an XWindow up. This is sort of where libPTC (and GLES) come in.

libPTC "cheats with X11". XAPI and Input handling are already available(much like with WIn32 API).

We should not have to care what is below the vFB(framebuffer)- as long as we can get a graphical context atop of it.
(Its not really (DPMI) DOS- its DOS-like -UNIX- tty/console/terminal)



FIXED:
    GL is refusing to chainload via library (solution: export the graphics context pointer)
(FContext-done for us)

FIXME:
      Below 32bpp is now unavailable. Depth can be changed, but not app bpp.
      NO- you cant "GTK CHEAT" and change it later on.

(We need Textures and/or FBO for this-Textures may still yet be 32bpp internally)


Lazarus graphics unit is severely lacking(provides TCanvas)...use this instead.

THIS IS NOT A GAME ENGINE. 
This code stacks between "graphics routine filth" and your code.

Only OPEN/free units and code will ever be here.
Only cross-platform methods will be used. 

Specific platforms should be IFDEFd

IN NO WAY SHAPE OR FORM are proprietary functions to be added here.
	You may use them if you wish- but the result is non-portable. (more headache for ewe)

I dont care what you use the source code for.

I would prefer- however-
		THAT YOU STICK TO FPC/LAZARUS. 
My support for other programming languages is LIMITED.

You must cite original authors and sub authors, as appropriate(standard attribution rules) when modifying this code.
DO NOT CLAIM THIS CODE AS YOUR OWN and you MAY NOT remove this notice.

Notice that you use this unit-(or have modified it) and where to find the original sources (in your code) would be nice.
It is not required, however.


}

//exception handling requires oop- despite no oop or objects in use.
//classes unit may also require this

{$mode objfpc}

//Range and overflow checks =ON
{$Q+}
{$R+}

{$IFDEF debug}
	{$S+}
{$ENDIF}

{
Notes: (theres a lot of em)

90% of the routines in the CORE of this unit(not sub units) are setup/destroy of needed structures.

The main unit is "helper routines" and init/closegraph mostly.
Most of the meat and po-tae-toes are in the aux units.


Canvas ops are "mostly universal".
The differences in code are where the surface(Canvas) operations point to and color operations supported.

 (a surface is a surface is a surface)
	-For that matter:
			(A texture is a texture is a texture)


Although designed "for games programming"..the integration involved by the USE, ABUSE, and REUSE-
of SDL and X11Core/WinAPI(GDI)/Cairo(GTK/GDK)/OpenGL/DirectX highlights so many OS internals its not even funny.

GL -by itself(ES)- doesnt require X11- but (GLX?) does require some X11 code for "input processing".

-It is Linux that is the complex BEAST that needs taming.
	Everyone seems to be writing in proprietary windowsGL, DirectX,etc. these days.

}

interface

{

This is not -and never will be- your program. Sorry, Jim.
RELEASES are stable builds and nothing else is guaranteed.

We output thru Surface->Texture (buffer/video buffer) usually via memcopy operations.

For framebuffer(tty access):
	
For now- we settle for a Doom like experience.
	We start in text mode
		We switch to graphics mode and do something (catch all crashes)
	We drop back to text mode

(FBO- is a part of openGL--I skip over this mess- for now)


Macintosh:

Im still looking at Quartz seperately. OSX is funky in this regards.	


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
    You should log everything.

animations:
	to animate-
		screen savers, etc...you need to rendercopy TExture data and THEN POLL INPUT after pageflipping.
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

   GL Data is ALWAYS a packed Record (4 byte aligned)

  Note "the holes" can be used for overlay areas onscreen when stacking layers.
  The holes are standardized to xterm specs. I think theres like 5 (for VGA mode).

  Im seeing a Ton of correlation between OGL/SDL and DirectX/DirectDraw (and people think there isnt any).


WONTFIX:

"Rendering onto more than one window (or renderer) can cause issues"

("depth" in OGL is considered cubic depth (think layers of felt) , not bpp)


--Jazz
(comments -and code- by me unless otherwise noted)


TODO:

	Get some framebuffer fallback code working and put it here.	(DAMN YOU- and your changes, Linus!)
	
}

//this will not work "for callbacks":
//ifdef mswindows: cdecl-> stdcall


uses

{
Threading(required):

Requires baseunix unit:

cthreads has to be the first unit -in this case-
	we so happen to support the C version natively.

}

//cthreads and cmem have to be first.

//sysutils: IntToStr()

//you need to tell me- if you need fallback APIs.
//in most cases, you wont need them.


{$IFDEF UNIX}
      cthreads,cmem,sysUtils,baseunix,Classes,

	 {$IFNDEF fallback} //fallback uses FrameBuffer only code(slow), otherwise keep loading libs
		GL,GLext, GLU,GLUT,FreeGlut,
		//both free and not-so-free GLUT are REQUIRED! Use GLFW or something else if you dont like this!
        //probly cairo and pango too at this point.
	 {$ENDIF}
    
 {$IFDEF fallback} 
	 X, XLib,	//X11CorePrimitives
 {$ENDIF}

{$ENDIF}

    ctypes,

//ctypes: cint,uint,PTRUint,PTR-USINT,sint...etc.

// A hackish trick...test if LCL unit(s) are loaded or linked in, then adjust "console" logging...

{$IFDEF MSWINDOWS} //as if theres a non-MS WINDOWS?
    Windows,MMsystem, //audio subsystem

	 {$IFDEF fallback}
		WinGraph, //WinAPI-needs rework
	 {$endif}

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
      LazUtils,  Interfaces, Dialogs, LCLType,Forms,Controls, sysutils,
    {$IFDEF MSWINDOWS}
       //we will check if this is set later.
      {$DEFINE NOCONSOLE }
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

  uos,strings,typinfo,logger


// uos/Examples/lib folder has the required libraries for you.
// as a side-effect: CDROM Audio playback(CDDA) is added back


{
OpenGL requires Quartz, which prevents building below OSX 10.2.

direct rendering onto the renderer uses QuartzGL(on OSX up to Mtn LN- it wont stay active once set)
Cocoa (OBJ-C) is the new API
}


//lets be fair to the compiler..
{$IFDEF debug} ,heaptrc {$ENDIF} 

//Carbon is OS 8 and 9 to OSX API
{$IFDEF mac} 
  ,MacOSAll
{$ENDIF}

//Cocoa (OBJ-C) is the new API
//OSX 10.5+
{$IFDEF darwin}
	{$linkframework Cocoa}
    {$linklib SDLimg}
    {$linklib SDLttf}
    {$linklib SDLnet}
	{$linklib SDLmain}
	{$linklib gcc}

{$modeswitch objectivec2}

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

//dotted and dashed are stipple, center uses other math
//the rest is POLYFILL releated. POLYFILL types are handled by OGL/GLUT routines.

  LineStyle=(solid,dotted,center,dashed);

//as with drawing mechanical "lead pencils"
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


//sort of -SDL_Rect implementation

PSDL_Rect=^Rect;
SDLRect=record
	x:byte;
	y:byte;
	h:byte;
	w:byte;
end;


{
A Ton of code enforces a viewport mandate- that even sans viewports- the screen is one.
This is better used with screen shrinking effects


graphdriver is not really used half the time anyways..most people probe.

Theres only ONE Fatal Flaw in the old code:
    It presumes use on PC only. Presumption and ASSumptions are BAD.

How do you detect non-PC variants? In this case- you make another unit for that platform.

}
	graphics_driver=(DETECT, CGA,EGA, VGA,VESA); 


{

Modes and "the list":

byte because we cant have "the negativity"..
could be 5000 modes...we dont care...
the number is tricky..since we cant setup a variable here...its a "sequential byte".

yes we could do it another way...but then we have to pre-call the setup routine and do some other whacky crap.


1080p is reasonable stopping point until consumers buy better hardware...which takes years...
most computers support up to 1080p output..it will take some more lotta years for that to change.

}

Vertex=record
	x:Word;
	y:Word;
end;

Vertex3d=record
   x:Word;
   y:Word;
   z:Word;
end;

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

CHR code (FPC team) may help in that regards- but CHR files DO NOT SCALE WELL(>size 12).
(Its been done- but not with GL- at least like SDL does it in 2D)

Think of Text (in GL) like a "Transparent Label" or "clear sticker".

}

//usully goes around clock-wise
Quad=array [0..3] of Vertex;


//faked "SDL" 4-byte color setup

{$ifndef mswindows}

//bytes
PSDL_Color=^SDL_Color;
SDL_Color=record
	r,g,b,a:byte;
end;

//floats
GL_Color=record
	r,g,b,a:single;
end;

{$endif}


{$ifdef mswindows}
PSDL_Color=^SDL_Color;
SDL_Color=record
	b,g,r,a:byte;
end;


GL_Color=record
	b,g,r,a:single;

end;

{$endif}

    PImage=^Image;
    Image=array of Byte;

    pixelsP=^pixels;
    Pixels= array of Byte;
    TexturePixels= array of Byte;

    PPoints=^points;
    PolyPts= record
        x:word;
        y:word;
    end;

    data=^Word;

  pmypixels=^mypixels;
  pmyshortpixels=^myshortpixels;

  mypixels=array  of SDL_Color; //4byte array (pixel) for sizeof(screen)
  myshortPixels= array of Word; //GLshort

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


//There IS a way to ge the Names listed here- the magic type info library
//this cuts down on spurious string data and standardizes the palette names a bit also


//these names CANNOT overlap. If you want to change them, be my guest.

//you cant fuck up the first 16- Borland INC (RIP) made that "the standard"
TPalette16Names=(BLACK,RED,BLUE,GREEN,CYAN,MAGENTA,BROWN,LTGRAY,GRAY,LTRED,LTBLUE,LTGREEN,LTCYAN,LTMAGENTA,YELLOW,WHITE);


//not pulled from specs yet
TPalette64Names=(
BLACK64,
RED64,
BLUE64,
GREEN64,
CYAN64,
MAGENTA64,
BROWN64,
LTGRAY64,
GRAY64,
LTRED64,
LTBLUE64,
LTGREEN64,
LTCYAN64,
LTMAGENTA64,
YELLOW64,
WHITE64,
color17,
color18,
color19,
color20,
color21,
color22,
color23,
color24,
color25,
color26,
color27,
color28,
color29,
color30,
color31,
color32,
color33,
color34,
color35,
color36,
color37,
color38,
color39,
color40,
color41,
color42,
color43,
color44,
color45,
color46,
color47,
color48,
color49,
color50,
color51,
color52,
color53,
color54,
color55,
color56,
color57,
color58,
color59,
color60,
color61,
color62,
color63,
color64
);

TPalette64NamesGrey=(gBLACK,g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14,gWHITE);

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

TRec2=record
  
	colors:array [0..1] of PSDL_COLOR; 

end;


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

  colors:array [0..255] of PSDL_COLOR; //this is setup later on. 

end;


	graphics_modes=(

CGALo,CGAMed,CGAMed2,CGAMedG,CGAHi,EGA, 
VGAMed,ModeX,vgaMedx256,
vgaHi,VGAHix256,VGAHix32k,VGAHix64k,
m800x600x16,m800x600x256,m800x600x32k,m800x800x64k,
m1024x768x256,m1024x768x32k,m1024x768x64k,m1024x768xMil,
m1280x720x256,m1280x720x32k,m1280x720x64k,m1280x720xMil,
m1280x1024x256,m1280x1024x32k,m1280x1024x64k,m1280x1024xMil,m1280x1024xMil2,
m1366x768x256,m1366x768x32k,m1366x768x64k,m1366x768xMil,m1366x768xMil2,
m1920x1080x256,m1920x1080x32k,m1920x1080x64k,m1920x1080xMil,m1920x1080xMil2);

 

//our ModeList data

//the lists..
  Pmodelist=^TmodeList;

//wants graphics_modes??
  TmodeList=array [0 .. 31] of TMode;


//single mode

  Pmode=^TMode;

//arent dynamic arrays fun?
   Points=array of PolyPts;

var

	GLFloat:single;
	FloatInt:single;
    Float:single;
    modePointer:Pmode;

StartXViewPort, StartYViewPort, ViewWidth ,ViewHeight:Word;

//CGA. I know what youre thinking...hmmm 16 colors..WRONG!

//NO! its not 16 colors in graphics modes!! (its only 16 colors in TEXT modes)
//CGA is a FOUR color palette!

  valuelist4a: array [0..11] of byte;
  valuelist4b: array [0..11] of byte;
  valuelist4c: array [0..11] of byte;
  valuelist4d: array [0..8] of byte;

//EGA- not CGA16. If this was a fixed and locked pallette- this might be accurate.
//CGA pulls from one of the four above.(DONT CHEAT!!)

  valuelist16: array [0..48] of byte; //actual palette
  valuelist64: array [0..191] of byte; //pull from this list- palette
//I have to work out a way of not cheating but leaving the 16 colors viable- even dragged back from 32bit floats...


//for your convienience- greyscale palettes
  GreyList16:array [0..48] of byte;
  valuelist256: array [0..767] of byte;

//note: use type defines if this doesnt work like it should.
  TPalette4a:TRec4;
  TPalette4b:TRec4;
  TPalette4c:TRec4;
  TPalette4d:TRec2;

  PPalette4a:^TRec4;
  PPalette4b:^TRec4;
  PPalette4c:^TRec4;
  PPalette4d:^TRec2;

//there is no 16color palette- you mean 64- set w 16..
  PPalette64:^TRec64;
  TPalette64:TRec64;

  PPalette256:^TRec256;
  TPalette256:TRec256;

//patchy hack
  PPalette16Grey:^TRec64;
  TPalette64Grey:TRec64;

  PPalette256Grey:^TRec256;
  TPalette256Grey:TRec256;

    FSMode:PChar; //passed thru to GLUTInit
  whichID:PGLint;
  maxTextureSize:integer;
  wordPixels:pmyshortpixels;
  texture:LongWord;
  pixelData:Texturepixels;
  PlotwNeighbors:boolean;

  red_mask,green_mask,blue_mask:word;
  red_value,green_value, blue_value:byte;

//OpenGL - its a little fuzzy on definitions.

  Vec3:Vertex3d;
  Vec4:Quad;

  texBounds: array [0..4] of Vertex;
  windownumber:byte;
  MouseHidden:boolean;

  Xaspect,YAspect:byte;
  CanChangePalette,HalfShadeCGA:boolean;
  where:Twhere;
	quit,minimized,paused,wantsFullIMGSupport,nojoy,exitloop:boolean;
    nogoautorefresh:boolean;
    _grResult:grErrortype;
    
    srcR,destR:PSDL_Rect;

    filename:String;
    fontpath,iconpath:PChar; // look in: "C:\windows\fonts\" or "/usr/share/fonts/"
    UseGRey:boolean=false;
    grErrorStrings: array [0 .. 7] of string; //or typinfo value thereof..
    AspectRatio:single; //computed from (AspectX mod AspectY)

  MaxColors:LongWord; //positive only!!
  ClipPixels: Boolean=true; //always clip, never an option "not to".
  //we will CLAMP GL to the screen

  WantsJoyPad,FilledPolys:boolean;
  screenshots:longint;

  NonPalette, TrueColor,WantsAudioToo,WantsCDROM:boolean;	
  DoubleSize,Blink:boolean;
  CenterText:boolean=false; //see crtstuff unit for the trick
  Render3d:boolean;
  MaxX,MaxY:word;
  bpp:byte;
  Fancyness:Thickness;
  _fgcolor, _bgcolor:SDL_Color;	
  //use index colors once setup(palette unit)
  DoneRendering,drawAA:boolean;
  LIBGRAPHICS_ACTIVE:boolean;
  LIBGRAPHICS_INIT:boolean;

  IsConsoleInvoked,CantDoAudio:boolean; //will audio init? and the other is tripped NOT if in X11.
  //can we modeset in a framebuffer graphics mode? YES. 
  
  himode,lomode:integer;


const
   maxMode=Ord(High(Graphics_Modes));

   //Analog joystick dead zone 
   JOYSTICK_DEAD_ZONE = 8000;
   //joysticks seem to be slow to respond in some games....

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

//forward declared defines

function ByteToFloat(hexColor:Byte):single;
function GLFloatToByte(someFloat:single):byte;
function Word15ToSDLColor(someWord:Word):PSDL_Color;
function Word16ToSDLColor(someWord:Word):PSDL_Color;
function SDLColorToWord15(someColor:PSDL_Color):Word;
function SDLColorToWord16(someColor:PSDL_Color):Word;
procedure initPaletteGrey16;
procedure initPaletteGrey256;
procedure initCGAPalette0;
procedure initCGAPalette1;
procedure initCGAPalette2;
procedure initCGAPalette3;
procedure initPalette64;
procedure Save16Palette(filename:string);
procedure Read16Palette(filename:string; ReadColorFile:boolean);
procedure initPalette256;
procedure Save256Palette(filename:string);
procedure Read256Palette(filename:string; ReadColorFile:boolean);
function GetRGBfromIndex(index:byte):PSDL_Color;
function GetBGColorIndex:byte;
function GetFGColorIndex:byte;
function GetFGName:string;
function GetBGName:string;
procedure invertfgColor;
procedure invertbgColor;

//os specific
{$ifdef mswindows}
    function IsVistaOrGreater: Boolean;
    function IsWindowsXP: Boolean;
{$endif}

function GetFGColor:Byte; overload;

procedure DrawGLRect(x,y,w,h:Word);
procedure DrawGLRect(Rect:PSDL_Rect); overload;
function GetPixelElse(x,y:word):SDL_Color;
function GetPixel1516(x,y:word):PSDL_Color;
function GetPixel(x,y:word):PSDL_Color;
function readpixels1516Tex(x,y,width,height:integer; Texture:LongWord):PmyShortPixels;
function readpixelsTex(x,y,width,height:integer; Texture:LongWord):Pmypixels;
procedure UpdateRect1516(x,y,width,height:integer; Texture:Longword; pixels:pmyshortpixels);
procedure UpdateRect(x,y,width,height:integer; Texture:Longword; pixels:pmypixels);
function RGB24To15bit(incolor:SDL_Color):SDL_Color;
function RGB24To16bit(incolor:SDL_Color):SDL_Color;
procedure EnableAAMode;
procedure DisableAAMode;
procedure SetRGBColor(r,g,b:byte);
procedure SetRGBAColor(r,g,b,a:byte);

procedure PutPixel(x,y:Word);
procedure PutPixelRGB(r,g,b:byte; x,y:word);
procedure PutPixelRGBA(r,g,b,a:byte;  x,y:word);

procedure DrawPoly(GiveMePoints:Points);
procedure CreateNewTexture;
//procedure RenderTargetWord15;
//procedure RenderTargetWord16;
//procedure RenderTargetRGB;
//procedure RenderTargetRGBA;
//procedure Load_ImageRGB;
//procedure Load_ImageRGBA;
//procedure Load_ImageScaledRGB(scaleX,ScaleY:integer);
//procedure Load_ImageScaledRGBA(scaleX,ScaleY:integer);
//Procedure SetViewPort(X1, Y1, X2, Y2: smallint);

procedure SetAspectRatio(Xasp, Yasp : word);
procedure SetWriteMode(WriteMode : word);
function FetchModeList:Tmodelist;
procedure GameControllerAddMappingsFromFile(FilePath:string);
function WindowPos_IsUndefined(WindowData:PSDL_Rect): boolean;
function WindowPos_IsCentered(WindowData:PSDL_Rect): boolean;
procedure RoughSteinbergDither(filename,filename2:string);
procedure setFGColor(color:byte);
procedure setFGColor(r,g,b:byte); overload;
procedure setFGColor(r,g,b,a:byte); overload;
procedure clearDevice;
procedure clearscreen;
procedure clearDevice(index:byte); overload;
procedure cleardevice(r,g,b:byte); overload;
procedure cleardevice(r,g,b,a:byte); overload;
procedure RenderStringB(x, y:Word; font:Pointer; instring:PChar; rgb:SDL_Color);

//procedure clearviewport;
procedure initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean);
procedure closegraph;
function GetX:word;
function GetY:word;
procedure glutInitPascal;
procedure RenderPresent(value:integer); //callback via timed interrupt(60Hz) IFFF done rendering and NOT paused
procedure ReSize(Width, Height: Integer); cdecl;
procedure GLKeyboard(Key: Byte; X, Y: Longint); cdecl;
procedure HideMouse;
procedure ShowMouse;
procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean);
function getgraphmode:string;
procedure restorecrtmode; //wrapped closegraph function
function getmaxX:word;
function getmaxY:word;
function getdrivername:string;
Function detectGraph:byte;
function RGBToHex32(color:SDL_Color):DWord;
function Hex32ToRGB(someDWord:DWord):SDL_Color;
procedure saveVideoState;
procedure restoreVideoState;
function RGB4FromLongWord(Someword:Longword):SDL_Color;
function RGB8FromLongWord(Someword:Longword):SDL_Color;
function RGB5551FromLongWord(Someword:Longword):SDL_Color;
function RGB565FromLongWord(Someword:Longword):SDL_Color;
function RGBFromLongWord24(SomeDWord:LongWord):SDL_Color;
function RGBAFromLongWord(SomeDWord:LongWord):SDL_Color;
function EGAtoVGA(color: LongWord): LongWord;
function Double320x200: Boolean;
function Double320x240: Boolean;
procedure FreeAndNil(q:Pointer);
procedure RenderSomething; cdecl; 

function getmaxmode:string;
procedure getmoderange(graphdriver:integer);
procedure BGColorBorderViewPort(Rect:SDLRect);
procedure ColorBorderViewPort(Rect:SDLRect; color:SDL_Color);
procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
procedure RegisterBGIDriver(driver: pointer);
function GetMaxColor: word;
//procedure LoadImageTexture(filename:PChar; Rect:PSDL_Rect);
procedure idle; cdecl;
//procedure LoadImageBackground(filename:PChar);

procedure PlotPixelWNeighbors(x,y:integer; drawAA:boolean);
procedure SaveBMPImage(filename:string);
Procedure MoveTo(X,Y: Word);
function DWordToFloat(Data: DWord; EndianSwap: Boolean): Single;

// end defines


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



implementation

{

Textures:

    as we generate these- we get assigned a number.

To remove on in a stack on screen:

    deduce by one.
    Update the entire screen/scene- just without this data (what was there before?)

-so dont remove textures unless you are done with them. 
This is SDLs problem- you have to "recreate everything on the renderer" to remove a texture stack on the "output surface"
- but you dont have "what was there before" if you follow SDL2 programming guidelines.


-OpenGl doesnt work that way.
If you want textures- thats fine. 

KEEP the variable and SDL_Color arrays. DO NOT FREE THEM.
Then FX can be stacked wo use of FragMent Shaders.

You can add/remove content as you see fit. You only need to redraw the visible screen/scene.
Its a weird whacky implementation- but it works for 2D and some 3D.
It also allows for faster TnL scene rendering.

Using Fragment shaders in Pascal **is a BITCH**. It can sort-of be done.

---

you could use normal GL coords and cap at floatMax of 1.0
 (but the coords are whacky-weird.)

fix the perspective and view- first.

}

{
//Horizontal line: use x, not y
//test this!
procedure CenteredHLine(x,x2,y:Word);
var
   newx,newy,newx2;

begin
	//where is the center??
	newx:= ( (x mod 2) - (x-x2 mod 2));
    newx2:= x+x2;
    newy:= (y mod 2);
	//from center : draw line from here
	HLIne(x,y,x2);
end;

//verticle line: use y, not x

procedure CenteredVLine(x,y,y2:Word);
var
   newx,newy,newy2;

begin
	newx:= (x mod 2);
    newy2:= y+y2;
    newy:= ( (y mod 2) - (y-y2 mod 2));

	//from center : draw line from here
	VLIne(x,y,y2);
end;
}

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
function ByteToFloat(hexColor:Byte):single;

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
function GLFloatToByte(someFloat:single):byte;
begin
   if (someFloat > 1.0) then 
		exit;
   GLFloatToByte:=byte(round(someFloat));
end;

{
    according to msft (example is in c)- 
    https://docs.microsoft.com/en-us/windows/desktop/DirectShow/working-with-16-bit-rgb

    -this is how its done:
}



//unfucks the inconsistent GLShort/Word into a RGB record(SDL_Color) we can use

function Word15ToSDLColor(someWord:Word):PSDL_Color;
var
    someColor:PSDL_Color;

begin
    red_mask := $F800;
    green_mask := $7E0;
    blue_mask := $1F;

    red_value := (someWord and red_mask) shr 11;
    green_value := (someWord and green_mask) shr 5;
    blue_value := (someWord and blue_mask);

    // Expand to 8-bit values.
    someColor^.r := red_value shl 3;
    someColor^.g := green_value shl 2;
    someColor^.b := blue_value shl 3;

    Word15ToSDLColor:=someColor;
end;

function Word16ToSDLColor(someWord:Word):PSDL_Color;
var
    someColor:PSDL_Color;

begin
    red_mask := $7C00;
    green_mask := $3E0;
    blue_mask := $1F;

    red_value := (someWord and red_mask) shr 10;
    green_value := (someWord and green_mask) shr 5;
    blue_value := (someWord and blue_mask);

    // Expand to 8-bit values.
    someColor^.r := red_value shl 3;
    someColor^.g := green_value shl 3;
    someColor^.b := blue_value shl 3;

    Word16ToSDLColor:=someColor;
end;

//converts SDL RGB record into GLShort/Word
function SDLColorToWord15(someColor:PSDL_Color):Word;
var
    someWord:Word;

begin
   someWord := ((someColor^.r shl 11) or (someColor^.g shl 5) or someColor^.b);
end;

function SDLColorToWord16(someColor:PSDL_Color):Word;
var
    someWord:Word;

begin
   someWord := ((someColor^.r shl 10) or (someColor^.g shl 5) or someColor^.b);
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

Greylist16[0]:=$00;
Greylist16[1]:=$00;
Greylist16[2]:=$00;
Greylist16[3]:=$11;
Greylist16[4]:=$11;
Greylist16[5]:=$11;
Greylist16[6]:=$22;
Greylist16[7]:=$22;
Greylist16[8]:=$22;
Greylist16[9]:=$33;
Greylist16[10]:=$33;
Greylist16[11]:=$33;
Greylist16[12]:=$44;
Greylist16[13]:=$44;
Greylist16[14]:=$44;
Greylist16[15]:=$55;
Greylist16[16]:=$55;
Greylist16[17]:=$55;
Greylist16[18]:=$66;
Greylist16[19]:=$66;
Greylist16[20]:=$66;
Greylist16[21]:=$77;
Greylist16[22]:=$77;
Greylist16[23]:=$77;
Greylist16[24]:=$88;
Greylist16[25]:=$88;
Greylist16[26]:=$88;
Greylist16[27]:=$99;
Greylist16[28]:=$99;
Greylist16[29]:=$99;
Greylist16[30]:=$aa;
Greylist16[31]:=$aa;
Greylist16[32]:=$aa;
Greylist16[33]:=$bb;
Greylist16[34]:=$bb;
Greylist16[35]:=$bb;
Greylist16[36]:=$cc;
Greylist16[37]:=$cc;
Greylist16[38]:=$cc;
Greylist16[39]:=$dd;
Greylist16[40]:=$dd;
Greylist16[41]:=$dd;
Greylist16[42]:=$ee;
Greylist16[43]:=$ee;
Greylist16[44]:=$ee;
Greylist16[45]:=$ff;
Greylist16[46]:=$ff;
Greylist16[47]:=$ff;

   i:=0;
   num:=0; 
   repeat 
      TPalette64Grey.colors[num]^.r:=Greylist16[i];
      TPalette64Grey.colors[num]^.g:=Greylist16[i+1];
      TPalette64Grey.colors[num]^.b:=Greylist16[i+2];
      TPalette64Grey.colors[num]^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  until num=15;

  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 16, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette16Grey);

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

  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 256, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette256Grey);

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
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 4, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette4a);

end;
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
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 4, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette4b);

end;
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
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 4, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette4c);

end;
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
    glColorTable(GL_COLOR_TABLE, GL_RGBA8, 2, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette4d);

end;


procedure initPalette64;
//there are 64 names- but theres no way of knowing if you changed the defaults-so I wont assume.
//only 16 out of those 64 are available at any time.

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
          CanChangePalette:=true
      else
          CanChangePalette:=false;
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 16, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette64);
end;


//you can use these for EGA also- same sized data.

procedure Save16Palette(filename:string);

var
	palette16File : File of TRec64;
	i,num            : integer;

Begin
	initPalette64;
	Assign(palette16File, filename);
	ReWrite(palette16File);

	Write(palette16File, TPalette64); //dump everything out
	Close(palette16File);
	
End;

//we should ask if we want to read a color or BW file, else we duplicate code for one line of changes.
//there is a way to check- but we would have to peek inside the file or just display it and assume things.
//this could shove a BW file in the color section or a color file in the BW section...
//anyway, theres two sets of arrays and you can reset to defaults if you need to.

procedure Read16Palette(filename:string; ReadColorFile:boolean);

Var
	palette16File  : File of TRec64;
	i,num            : integer;
    

Begin
	Assign(palette16File, filename);
	ReSet(palette16File);
    Seek(palette16File, 0); //find first record
    if ReadColorFile =true then
		Read(palette16File, TPalette64) //read everything in
	else
		Read(palette16File, TPalette64GRey); 
	    
	Close(palette16File);
    if ReadColorFile =true then
        glColorTable(GL_COLOR_TABLE, GL_RGBA8, 16, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette64)
    else
        glColorTable(GL_COLOR_TABLE, GL_RGBA8, 16, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette16GRey);

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
      TPalette64.colors[num]^.r:=valuelist256[i];
      TPalette64.colors[num]^.g:=valuelist256[i+1];
      TPalette64.colors[num]^.b:=valuelist256[i+2];
      TPalette64.colors[num]^.a:=$ff;
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
  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 256, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette256);

	
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

Begin
	Assign(palette256File, filename);
	ReSet(palette256File);
    Seek(palette256File, 0); //find first record

	Read(palette256File, TPalette256); 
	Close(palette256File);	
    if ReadColorFile =true then
        glColorTable(GL_COLOR_TABLE, GL_RGBA8, 256, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette256)
    else
    glColorTable(GL_COLOR_TABLE, GL_RGBA8, 256, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette256Grey);

end;


{

Colors are bit banged to hell and back.


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
	      somecolor:=TPalette64.colors[index] //literally get the SDL_color from the index
    else if MaxColors=64 then
	      somecolor:=Tpalette64.colors[index] 
    else if MaxColors=256 then
	      somecolor:=Tpalette256.colors[index]; 
    GetRGBFromIndex:=somecolor;
    exit;
  end else begin
    if IsConsoleInvoked then
		writeln('Attempt to fetch RGB from non-Indexed color.Wrong routine called.');
    {$ifdef lcl}
        ShowMessage('Attempt to fetch RGB from non-Indexed color.Wrong routine called.'); 
    {$endif}
    exit;
  end;
end;


//returns the current color index
//BG is the tricky part- we need to have set something previously.

function GetBGColorIndex:byte;

var
   i:byte;
   someColor:PSDL_Color;
   r,g,b,a:byte;

begin
    somecolor^:=_bgcolor; //cheat 

     if MaxColors=16 then begin
     i:=0;
        repeat
	        if ((TPalette64.colors[i]^.r=somecolor^.r) and (TPalette64.colors[i]^.g=somecolor^.g) and (TPalette64.colors[i]^.b=somecolor^.b))  then begin
		        GetBGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;
    end;
     
     if MaxColors=64 then begin
     i:=0;
        repeat
	        if ((TPalette64.colors[i]^.r=somecolor^.r) and (TPalette64.colors[i]^.g=somecolor^.g) and (TPalette64.colors[i]^.b=somecolor^.b))  then begin
		        GetBGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;
    end;
     
     if MaxColors=256 then begin
       i:=0; 
       repeat
	        if ((TPalette256.colors[i]^.r=somecolor^.r) and (TPalette256.colors[i]^.g=somecolor^.g) and (TPalette256.colors[i]^.b=somecolor^.b))  then begin
		        GetBGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 end else begin
		If IsConsoleInvoked then
			Writeln('Cant Get index from an RGB mode (or non-palette) colors.');
	    {$ifdef lcl}    
            ShowMessage('Cant Get index from an RGB mode (or non-palette) colors.');
        {$endif}
		exit;
	 end;
end;


function GetFGColorIndex:byte;

var
   i:byte;
   someColor:PSDL_Color;
   r,g,b,a:byte;

begin

    somecolor^:=_fgcolor; 

//checkme: this may return slighty 'off' converted data due to the way OGL handles the data stored on screen.
//this is unavoidable- and must be pulled as a float and converted.

     
     if MaxColors=64 then begin
       i:=0;  
       repeat
	        if ((TPalette64.colors[i]^.r=somecolor^.r) and (TPalette64.colors[i]^.g=somecolor^.g) and (TPalette64.colors[i]^.b=somecolor^.b))  then begin
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
        {$ifdef lcl}
    		ShowMessage(SDL_MESSAGEBOX_ERROR,'Cant Get index from an RGB mode colors.');
        {$endif}
		exit;
	 end;
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
      {$ifdef lcl}  
    	  ShowMessage('Cant Get color name from an RGB mode colors.');
      {$endif}
	  exit;
   end;
   i:=0;
   i:=GetFGColorIndex;
   if MaxColors=256 then begin
	      GetFGName:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
		  exit;
   end;
   if MaxColors=64 then begin
	      GetFGName:=GEtEnumName(typeinfo(TPalette64Names),ord(i));
		  exit;
   end;
   if MaxColors=16 then begin
	      GetFGName:=GEtEnumName(typeinfo(TPalette64Names),ord(i));
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
      {$ifdef lcl}
	    ShowMessage('Cant Get color name from an RGB mode colors.');
      {$endif}  
	  exit;
   end;
   i:=0;
   i:=GetBGColorIndex;

   if MaxColors=256 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
		  exit;
   end; 
   if MaxColors=64 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette64Names),ord(i));
		  exit;
   end; 
   if MaxColors=16 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette64Names),ord(i));
		  exit;
   end;
end;



{
How to implement "turtle graphics":
(in a sub-unit, PLEASE!)

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

procedure invertbgColor;

//so you see how to do manual shifting etc.. 
begin
	_bgcolor.r:=(255 - _bgcolor.r);
    _bgcolor.g:=(255 - _bgcolor.g);
    _bgcolor.b:=(255 - _bgcolor.b);
end;

procedure invertfgColor;

//so you see how to do manual shifting etc.. 
begin
	_fgcolor.r:=(255 - _fgcolor.r);
    _fgcolor.g:=(255 - _fgcolor.g);
    _fgcolor.b:=(255 - _fgcolor.b);
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
type
    psingle=^single;

function GetFGColor:Psingle;
var
	GotColor:Psingle;

begin
	glGetFloatv(GL_CURRENT_COLOR,GotColor);
    GetFGColor:=GotColor;
end;

function GetFGColor:Byte; overload;
var
	GotByte:byte;
	GotColor:Psingle;
begin
//or fetch _fgcolor...
	glGetFloatv(GL_CURRENT_COLOR,GotColor);
	GetFGColor:=GLFloatToByte(GotColor^);
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


//bytes are too small for screen co-ords
procedure DrawGLRect(x,y,w,h:Word);
begin
	glRects(x,y,w,h); //GLuShort=Word
end;

procedure DrawGLRect(Rect:PSDL_Rect); overload;
begin
	glRects(Rect^.x, Rect^.y, Rect^.w,Rect^.h);
end;

//reads one pixel- and only one pixel
function GetPixelElse(x,y:word):SDL_Color;
var
    someColor:PSDL_Color;

begin
    case (bpp) of
//need to read 24 or 32 bpp and convert these-much like 15 and 16bpp modes (sorry)

//        2: glReadPixels(x, y, 1,1, GL_COLOR_INDEX, GL_UNSIGNED_BYTE, someColor);
//        4: glReadPixels(x, y, 1,1, GL_COLOR_INDEX, GL_UNSIGNED_BYTE, someColor);
//        8: glReadPixels(x, y, 1,1, GL_COLOR_INDEX, GL_UNSIGNED_BYTE, someColor);

        24: glReadPixels(x, y, 1,1, GL_RGB, GL_UNSIGNED_BYTE, someColor);
        32: glReadPixels(x, y, 1,1, GL_RGBA, GL_UNSIGNED_BYTE, someColor);
    end;
end;


function GetPixel1516(x,y:word):PSDL_Color;
var
    someWord:word;
    someColor:PSDL_Color;
    shit:data;
begin
//gawd- you C and GL guys...are getting on my nerves...

    case (bpp) of

        15: begin
            //we get a word
            glReadPixels(x, y, 1,1, GL_RGB, GL_UNSIGNED_SHORT_5_5_5_1, shit);
            someWord:=shit^;
            //now give me a converted SDL_Color
            someColor:=Word15ToSDLColor(someword);
            someColor^.a:=$ff; //ignored
        end;
        16: begin 
            glReadPixels(x, y, 1,1, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, shit);
            someWord:=shit^;
            someColor:=Word16ToSDLColor(someword);
        end;
    end;
    GetPixel1516:=someColor;
end;


//necessary wrapper- output is "inconsistently fucked"
function GetPixel(x,y:word):PSDL_Color;
var
    someColor:PSDL_Color;
begin
    case (bpp) of
        2,4,8,24,32:GetPixelElse(x,y);
        15,16:GetPixel1516(x,y);
    end;
    GetPixel:=someColor;
end;


//similar to SDL_GetPixels- we read a Rect from a Texture.
function readpixels1516Tex(x,y,width,height:integer; Texture:LongWord):PmyShortPixels;

begin
  case (bpp) of

//these are 16bit values(words, not DWords)
//so unpack, then repack it.

	15: begin
  			glPixelStorei(GL_UNPACK_ALIGNMENT, 2);
            glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_5_5_1, wordpixels);
  			glPixelStorei(GL_PACK_ALIGNMENT, 4);
    end;
	16: begin
  			glPixelStorei(GL_UNPACK_ALIGNMENT, 2);
            glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, wordpixels);
  			glPixelStorei(GL_PACK_ALIGNMENT, 4);
    end;

    else begin
        //wrong routine called!!
    end;
  end;
    readpixels1516Tex:=wordpixels;
end;


function readpixelsTex(x,y,width,height:integer; Texture:LongWord):Pmypixels;

var
    PointedPixels:Pmypixels;    

begin
  case (bpp) of

    //palettized (faked) 24bit

    //if this fails- put GL_BYTE where UNSIGNED is.
	4: glReadPixels(0, 0, width, height, GL_COLOR_INDEX, GL_UNSIGNED_BYTE, PointedPixels);
	8: glReadPixels(0, 0, width, height, GL_COLOR_INDEX, GL_UNSIGNED_BYTE, PointedPixels);

	//No upconversion. Settle for 32bit data(24+pad data). I made this weird.
	24: glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_BYTE, PointedPixels);
    32: glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, PointedPixels);
    else begin
       //wrong routine called!
    end;
  
  end;
    readpixelsTex:=PointedPixels;
end;


//co-ordinates: update texture, update rect, or update screen?

//notice the use of -SUB- here-

procedure UpdateRect1516(x,y,width,height:integer; Texture:Longword; pixels:pmyshortpixels);
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

  case (bpp) of

	15: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_5_5_1, wordpixels);
	16: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB,  GL_UNSIGNED_SHORT_5_6_5, wordpixels);

   end; //case
end;


procedure UpdateRect(x,y,width,height:integer; Texture:Longword; pixels:pmypixels);
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

  case (bpp) of
    //faked RGB modes(24bits colors) w palettes
	4: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_BYTE, pixels);
	8: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_BYTE, pixels);

//the tuple...
	24:	glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_UNSIGNED_BYTE, pixels);

	32: begin
			{$ifdef mswindows}
				glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_BGRA, GL_UNSIGNED_BYTE, pixels);
			{$else}
				glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
			{$endif}
		end;
   end; //case
end;

//color ops:
//theres no need to query what depth/bpp we are in- we should know.


//the tricky part may be in reading pixels back from OGL/SDL
//-and converting the output to the format we want.

//"textures may not contain the color mode set"....(SDL)


//(24bit RGB->15bits hex):
function RGB24To15bit(incolor:SDL_Color):SDL_Color;
var
    outcolor:SDL_Color;
begin
        outcolor.r := incolor.r * (2 shl 5) mod (2 shl 8);
        outcolor.g := incolor.g * (2 shl 5) mod (2 shl 8);
        outcolor.b := incolor.b * (2 shl 5) mod (2 shl 8);
end;

function RGB24To16bit(incolor:SDL_Color):SDL_Color;
var
    outcolor:SDL_Color;

begin
        outcolor.r := incolor.r * (2 shl 5) mod (2 shl 8);
        outcolor.g := incolor.g * (2 shl 6) mod (2 shl 8);
        outcolor.b := incolor.b * (2 shl 5) mod (2 shl 8);
end;


//shouldnt be using DWord style data- not to say that you cant.

//Convert an array of four bytes into a 32-bit DWord/LongWord.
//rarely used now.

function  getDwordFromSDLColor(someColor:SDL_Color):DWord;

begin
//array of 4 bytes or dword

{$ifndef mswindows}
    getDwordFromSDLColor:= (somecolor.r) or (somecolor.g shl 8) or (somecolor.b shl 16) or (somecolor.a shl 24);
{$endif}

{$ifdef mswindows}
    getDwordFromSDLColor:= (somecolor.a) or (somecolor.b shl 8) or (somecolor.g shl 16) or (somecolor.r shl 24);
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


function SDLColorFromDWord(someD:DWord):SDL_Color;

var
	somecolor:SDL_Color;
    r,g,b,a:Byte;

begin

 R := (someD shr 16) and $ff;
 G := (someD shr 8) and $ff;
 B := (someD) and $ff;
 A := (someD shr 24) and $ff;

  SDLColorFromDWord:=somecolor;
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
      glFlush;
end;

procedure DisableAAMode;

begin
	glDisable(GL_BLEND);
    glDisable(GL_LINE_SMOOTH);
    glDisable(GL_POINT_SMOOTH);
    glDisable(GL_POLYGON_SMOOTH);
	glFlush;
end;


//just changes the value- doesnt put it on screen
procedure SetRGBColor(r,g,b:byte);
begin
	glColor3b (r, g, b); //sets implied 255 alpha level
    _fgcolor.r:=r;
    _fgcolor.g:=g;
    _fgcolor.b:=b;
    _fgcolor.a:=$ff;
end;

procedure SetRGBAColor(r,g,b,a:byte);
begin
	glColor4b (r, g, b,a); 
    _fgcolor.r:=r;
    _fgcolor.g:=g;
    _fgcolor.b:=b;
    _fgcolor.a:=a;
end;


//uses current color set
procedure PutPixel(x,y:Word);

//create a 2D vertex(point) using "normal values(shorts)" instead of floats.
//DOES NOT WORK outside of GLbegin..GLend pair

begin
	glbegin(GL_POINTS); //draw WHAT? Dots/points/pixels
		if PlotwNeighbors then 
			glPointSize(8.0);
		glVertex2s(x, y);
	glend;
	glFlush; 
end;

//FIXME: need paletted type

procedure PutPixelRGB(r,g,b:byte; x,y:word);
begin
	glColor3b (r, g, b); //sets implied 255 alpha level
	PutPixel(x,y);
    _fgcolor.r:=r;
    _fgcolor.g:=g;
    _fgcolor.b:=b;
    _fgcolor.a:=$ff;
end;


procedure PutPixelRGBA(r,g,b,a:byte;  x,y:word);
begin
	glColor4b (r, g, b,a); 
	PutPixel(x,y);
    _fgcolor.r:=r;
    _fgcolor.g:=g;
    _fgcolor.b:=b;
    _fgcolor.a:=a;
end;




procedure DrawPoly(GiveMePoints:Points);	
//use predefind objects or tessellate if you have need of more surface "curvature"
var
    num:integer;

begin	
    num:=0;
	if FilledPolys then	
		// draw solids:
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)	

	else
		//dont draw solids:
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

	glBegin(GL_POLYGON);
		repeat
			glVertex2s(GiveMePoints[num].x,GiveMePoints[num].y);	
			inc(num);
		until num=sizeof(GiveMePoints);
	glEnd;

	glFlush;
end;


procedure CreateNewTexture;
var
   tex:PGLuint;

begin

	glGenTextures(1, tex);
	glBindTexture(GL_TEXTURE_2D, tex^);

	//keep coord sane between 0 and 1
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE); //X
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE); //Y

	if not drawAA then begin
		//pixely -lookig mode
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	end else begin
		//smooth everything
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
   end;
end;

{
//FLOW: Create Texture, edit Texture, RenderTexture(Tex) then RenderPresent.
//RenderTargetWord15(Texture,x,y,w,h,data)

procedure RenderTargetWord15;

begin
    glbindTexture(GL_TEXTURE_2D,Tex)
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


//libSOIL-not linked yet
procedure Load_ImageRGB;

var
	width, height:integer;

begin
  image:=SOIL_load_image('img.png', width, height, 0, SOIL_LOAD_RGB); //load image
  glTexImage2D(GL_TEXTURE_2D, 0, x,y,width, height,GL_RGB, GL_UNSIGNED_BYTE, pmypixels); //copyTex
  
end;


procedure Load_ImageRGBA;
var
	width, height:integer;

begin
  image:=SOIL_load_image('img.png', width, height, 0, SOIL_LOAD_RGBA); //load image
  glTexImage2D(GL_TEXTURE_2D, 0, x,y,width, height,GL_RGBA, GL_UNSIGNED_BYTE, pmypixels); //copyTex
  
end;


procedure Load_ImageScaledRGB(scaleX,ScaleY:integer);

begin
  image:=SOIL_load_image('img.png', width, height, 0, SOIL_LOAD_RGB); //load image

  //I dont think this is how its done...GL is weird in whacky ways...

  glTexImage2D(GL_TEXTURE_2D, 0, x,y, ScaleX, ScaleY, 0, GL_RGB, GL_UNSIGNED_BYTE, pmypixels); //copyTex

end;

procedure Load_ImageScaledRGBA(scaleX,ScaleY:integer);

begin
  image:=SOIL_load_image('img.png', width, height, 0, SOIL_LOAD_RGBA); //load image

  //I dont think this is how its done...GL is weird in whacky ways...

  glTexImage2D(GL_TEXTURE_2D, 0, x,y, ScaleX, ScaleY, 0, GL_RGBA, GL_UNSIGNED_BYTE, pmypixels); //copyTex

end;



SERIOUS FIXME: any pointer used must be =NIL before assignment

**DO NOT BLINDLY ALLOW any function to be called arbitrarily.**
(this was done in C- I removed the checks for a short while)

two exceptions:

	making a 16 or 256 palette and/or modelist file


NET:
	init and teardown need to be added here- I havent gotten to that.
	(I was trying to find viable non-C,non-SDL Net code)

}



//change
procedure SetAspectRatio(Xasp, Yasp : word);
begin
    Xaspect:= XAsp;
    YAspect:= YAsp;
    glViewport(0, 0, MaxX, MaxY);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45.0, XAsp mod YAsp, 0.1, 100.0);
    glflush;
end;

{
if your wondering why pixel ops are slow- this is why. 

Each Pixel (and Line) in the past were checked to see if we needed to invert them.
This was forced during the init of the main unit- according to gfx unit source code.

This is unwise- the routines work(well)- there is no need to slow them down.
If anything- SPEED THEM UP!

If you need to invert a pixmap(bitmap/texture) then do that instead. 
Affect only the texture in question.
(ALL AT ONCE!)

So the whole arguement as to how things are put on screen(xor,not,and,or) is moot.
-Its an age-old arguement, too.

some of this came to be from outdated linestyle code:
        linestyles wanted instructions on the HOW to draw lines AND the MEANS and the THICKNESS.

The means is a stippled bitmap(blit)- which will remain- and "the thickness" can remain.
But Im not modifying(or checking to modify) -each pixel-in flight.

If you want color inversion- change the fucking colormap/Palette to allow it. 
Its waaay faster.

}
procedure SetWriteMode(WriteMode : word);
//code removed by Jazz- irrelevant
begin
    if IsConsoleInvoked then
        LogLn('Fuck you- and your beligerent slothness- regarding pixel writes.');     
    {$ifdef lcl}
        ShowMessage('NO- you will NOT- modify pixel data in-flight!');
    {$endif}
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


Although generally in SDL(and on hardware) smaller windows and color depths are supported(emulation)-
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
	WindowPos_IsUndefined:=( (WindowData^.x<0) or (WindowData^.y<0) or (WindowData^.h<1) or (WindowData^.h>MaxY) or (WindowData^.w<1) or (WindowData^.w>MaxX) or (WindowData^.h=0) or (WindowData^.w=0) );
end;

//I actually compute this for text positioning, inside the window.
function WindowPos_IsCentered(WindowData:PSDL_Rect): boolean;
begin
  //something like this
  WindowPos_IsCentered := (((WindowData^.x mod 2)=MaxX mod 2) and ((WindowData^.y mod 2)=MaxY mod 2));
end;


// from wikipedia(untested)
procedure RoughSteinbergDither(filename,filename2:string);
//assumes 24 or 32 bit image

var
	pixel:array[0..1280,0..1024] of DWord;
	oldpixel,newpixel,quant_error:DWord;
	file1,file2:file;
    Buf : Array[1..4096] of byte;
    x,y:word;

begin
    x:=0;
    y:=0;
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
SDL2:
    Create a new texture for most ops-

Rendering is being called automatically at minimum (screen_refresh) as an interval.
Refresh is fine if data is in the backbuffer. 

Until its copied into the main buffer- its never displayed.

}

//"Texture locking thru OGL on Unices is unpredictable." -SDL DEv team. NICE JOKE.
//what you mean was glBindTexture's "second call = Nil", right?

//set FGColor

//paletted
procedure setFGColor(color:byte);
var
	colorToSet:PSDL_Color;
    r,g,b:byte;
    

begin
   if MaxColors=2 then begin
        colorToSet:=Tpalette4d.colors[color];
        glColor3b(colorToSet^.r,colorToSet^.g,colorToSet^.b ); 
   end; 
{
//these 3 have to check mode requested
   if ((MaxColors=4) and (Mode=CGA)) then begin
        colorToSet:=Tpalette4a.colors[color];
        glColor3b(colorToSet^.r,colorToSet^.g,colorToSet^.b ); 
   end if ((MaxColors=4) and (Mode=CGA1)) then begin
        colorToSet:=Tpalette4b.colors[color];
        glColor3b(colorToSet^.r,colorToSet^.g,colorToSet^.b ); 
   end if ((MaxColors=4) and (Mode=CGA2)) then begin
        colorToSet:=Tpalette4c.colors[color];
        glColor3b(colorToSet^.r,colorToSet^.g,colorToSet^.b ); 
   end;
}
   if MaxColors=256 then begin
        colorToSet:=Tpalette256.colors[color];
        glColor3b(colorToSet^.r,colorToSet^.g,colorToSet^.b ); 
   end else if MaxColors=64 then begin
		colorToSet:=Tpalette64.colors[color];
        glColor3b(colorToSet^.r,colorToSet^.g,colorToSet^.b ); 
   end;
end;

procedure setFGColor(r,g,b:byte); overload;

begin
   glColor3b(r,g,b ); 
end;

procedure setFGColor(r,g,b,a:byte); overload;

begin
   glColor4b(r,g,b,a); 
end;



{
//just--WHY??
//sets pen color to given dword.

procedure setFGColor(someDword:dword); overload;
var
    r,g,b:byte;
    somecolor:PSDL_Color;

begin
//break apart the dwrod into bytes


ifdef mswindows
    somecolor^.r:=;
    somecolor^.g:=;
    somecolor^.b:=;
endif
ifdef mswindows
    somecolor^.r:=;
    somecolor^.g:=;
    somecolor^.b:=;
endif

   glColor3b(somecolor^.r,somecolor^.g,somecolor^.b, 255 ); 
   
end;

}


//set BGColor

//just clear the screen- or do it with a set color/gradient?
procedure clearDevice;

begin
    if LIBGRAPHICS_ACTIVE=true then begin
        if Render3d then
        	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
        else	
        	glClear(GL_COLOR_BUFFER_BIT); //no Z axis to work with
    end;
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
procedure clearDevice(index:byte); overload;
//we deal with RGB data - borrow some floats along the way
//this specific RGB data is in a LUT(look up table-its not given by the user)
var
	r,g,b:byte;
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
        somecolor:=TPalette64.colors[index];

    if MaxColors=64 then
        somecolor:=Tpalette64.colors[index];

    if MaxColors=256 then
        somecolor:=Tpalette256.colors[index];

    glClearColor(ByteToFloat(somecolor^.r), ByteToFloat(somecolor^.g), ByteToFloat(somecolor^.b), 1.0);
    if Render3d then
        	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    else	 
        glClear(GL_COLOR_BUFFER_BIT);
    //the color changed- so reset _bgcolor internal value
    _bgcolor.r:=r;
    _bgcolor.g:=g;
    _bgcolor.b:=b;
    _bgcolor.a:=$ff;
end;

//these two dont need conversion of the data(24 and 32 bpp)
procedure cleardevice(r,g,b:byte); overload;


begin
    glClearColor(ByteToFloat(r), ByteToFloat(g), ByteToFloat(b), 1.0); 
    if Render3d then
        	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    else	 
        glClear(GL_COLOR_BUFFER_BIT);
    //the color changed- so reset _bgcolor internal value
    _bgcolor.r:=r;
    _bgcolor.g:=g;
    _bgcolor.b:=b;
    _bgcolor.a:=$ff;

end;


procedure cleardevice(r,g,b,a:byte); overload;

begin
    glClearColor(ByteToFloat(r), ByteToFloat(g), ByteToFloat(b),ByteToFloat(a)); 
    if Render3d then
        	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    else	 
        glClear(GL_COLOR_BUFFER_BIT);
    //the color changed- so reset _bgcolor internal value
    _bgcolor.r:=r;
    _bgcolor.g:=g;
    _bgcolor.b:=b;
    _bgcolor.a:=a;

end;


//MAJOR FIXME:
//procedure OutTextXY(x,y:word; font:pointer; instring:PChar);
//where rgb:=_fgcolor;


//RenderStringB(15, 15, GLUT_BITMAP_TIMES_ROMAN_24, "Hello", someSDLColor);

procedure RenderStringB(x, y:Word; font:Pointer; instring:PChar; rgb:SDL_Color);

begin

  glColor3b(rgb.r, rgb.g, rgb.b);
  glRasterPos2s(x, y);

//this is how you tell if you have freeGLUT installed or not:

{GLUT:
  n=0;
  repeat
        glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, instring[n]);
        inc(n);
  until n>sizeof(instring);
}

//freeGLUT:
  glutBitmapString(font, instring);
end;


{

put this in an aux unit- cyclical callbacks otherwise

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
   FillRect(viewport);
end;
}

{
I know.. I Know...
I removed initgraph because Laz GL has no way at all get things working.
I dont want you dicking around with "code that doesnt work".
 
If bychance I can get this working- I will re-add init and closeGraph
Window modes are easy. FS modes will depend. Are we using GLFW, GLUT, what?
 
Net and sound and ... init routines will be added to the Laz Demo.
Screen probing-
	we can start with current resolution, pulled from xrandr(xrender) unit.
	generally- we are already too big than "these old modes".

I may leave the specs for you.

	     CGALo:begin
			MaxX:=160;
			MaxY:=100;
			bpp:=4;
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=10;
		end;
	     CGAMed:begin
			MaxX:=320;
			MaxY:=200;
			bpp:=2;
			MaxColors:=4;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=10;
		end;
	     CGAMed2:begin
			MaxX:=320;
			MaxY:=200;
			bpp:=2;
			MaxColors:=4;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=10;
		end;
	     CGAMedG:begin
			MaxX:=320;
			MaxY:=200;
			bpp:=2;
			MaxColors:=4;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=10;
		end;
	     CGAHi:begin
			MaxX:=640;
			MaxY:=200;
			bpp:=2;
			MaxColors:=2;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=10;
		end;

	     EGA:begin
			MaxX:=320;
			MaxY:=240;
			bpp:=4;
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=10;
		end;

        //Heres your 16 colors in VGA mode
		VGAMed:begin
            MaxX:=320;
			MaxY:=200;
			bpp:=8;
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=10;

		end;

        //Normal aspect ratios
        //ModeX - this is what youre used to
		ModeX:begin
            MaxX:=320;
			MaxY:=240;
			bpp:=8;
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3;
		end;

        //ModeQ (cubed)
        //word addressed in the past (x=lo, y=hi byte) with a 256 pallette index
		VGAMed:begin
            MaxX:=256;
			MaxY:=256;
			bpp:=8;
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3;
		end;

		//spec breaks here for Borlands VGA support(not much of a specification thx to SDL...)
		//this is the "default VGA minimum".....since your not running below it, dont ask to set FS in it...

        // if you did that you would have to scale the output...
		//(more werk??? mhm)

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

		m1280x1024xMil2:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=32;
		   MaxColors:=4294967295; //longint max
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
		   MaxColors:=4294967295;
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
		   MaxColors:=4294967295;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9;

		end;
	
  end;
}


//use this with line and pixel drawing instead of linestyle method.
procedure SetPixelSize(size:single);

begin
  // Set width of point to one unit 
    glPointSize(size); 
    glMatrixMode(GL_PROJECTION); 
    glLoadIdentity(); 
end;

//ReSizeWindow??
procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean);

begin
end;


//state-tracking
function GetX:word;
begin
  Getx:=where.X;
end;

function GetY:word;
begin
  Gety:=where.Y;
end;


//get pallette DWord LUT of index [x]
//then set GL color with the Dword(unsigned longint)

//FIXME: these two are wrong
Procedure SetIndexFGColor;

begin
	glIndexi(color);
end;

Procedure SetIndexBGColor;

//the value of a byte- never the byte itself
//Wtf is an unsigned Byte?

begin
	glIndexb(ord(color));
	glClear(GL_COLOR_BUFFER_BIT)
end;



type
	PImageData=^ImageData;
    ImageData= array  of byte; //variable
    
var
	Image:PImageDAta;

//GetPixels/ReadPixels

//32bit is from the framebuffer- not a Texture.

//this is for 15/16/24 bpp
function ReadPixelsFromTexture:Image;

begin
	glGetTexLevelParameterfi( GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, TextureWidth );
	glGetTexLevelParameterfi( GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, TextureHeight );


	//Fetches RGBA - even if not in RGBA mode.(gl glitch)

	//PASCAL: sizeof(ImageData):= (4 * TextureWidth * TextureHeight);

	//front left..front right...center..rear left....rear right...
	//Stereo video output is possible(think holo-lens/AR/VR) but not the default. LEFT is.

	//read from the screen
	glReadBuffer( GL_FRONT );
	// if reading from content not yet rendered yet:  GL_BACK

	glReadPixels( 0, 0, TextureWidth, TextureHeight, GL_RGBA, GL_UNSIGNED_BYTE, ImageData );

	//ImageData should now contain ALL PIXEL data from OGL Texture
	//(not necessarily the whole screen)
	//(in Byte format)
	ReadPixelsFromTexture:=ImageData;
end;


//Surfaces are in a "software mode" buffer

var
	Surface: array [0..MaxX,0..MaxY] of SDL_Color;

//we can create differing bpp textures seperately- but the idea was to force bpp with the FBO.
//these could be forced 32bpp internally at any time

//15bit
function create_texture15(width, height:longword):GLuint;

var
	tex:GLuint;

begin
    glGenTextures(1, &tex);
    glBindTexture(GL_TEXTURE_2D, tex);

    // initialize texture to nil 
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB5, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, NiL);

    // disable mipmapping 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    result:=tex;
end;


//16bit
function create_texture16(width, height:longword):GLuint;

var
	tex:GLuint;

begin
    glGenTextures(1, &tex);
    glBindTexture(GL_TEXTURE_2D, tex);

    // initialize texture to nil 
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB5_A1, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, NiL);

    // disable mipmapping 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    result:=tex;
end;

//24bit
function create_texture24(width, height:longword):GLuint;

var
	tex:GLuint;

begin
    glGenTextures(1, &tex);
    glBindTexture(GL_TEXTURE_2D, tex);

    // initialize texture to nil 
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, NiL);

    // disable mipmapping 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    result:=tex;
end;

//32bit
function create_texture32(width, height:longword):GLuint;

var
	tex:GLuint;

begin
    glGenTextures(1, &tex);
    glBindTexture(GL_TEXTURE_2D, tex);

    // initialize texture to nil 
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NiL);

    // disable mipmapping 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    result:=tex;
end;


//Focus of most ops need to be "24 and 32 bit" - everything else needs to be a conversion subroutine.


//GLRenderCopy (put "Surface data" into a Texture)

//24bit

//Update_Rect/Texture
procedure GLRenderCopy(tex:GLuint; r:SDL_Rect; pixels:surface);

begin
    glBindTexture(GL_TEXTURE_2D, tex);
    glTexSubImage2D(GL_TEXTURE_2D, 0, r.x, r.h, r.w-r.x, r.y-r.h, GL_RGB, GL_UNSIGNED_BYTE, pixels );
end;

procedure GLRenderCopyScreen(tex:GLuint; pixels:surface);

begin
    glBindTexture(GL_TEXTURE_2D, tex);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, MaxX, MaxY, GL_RGB, GL_UNSIGNED_BYTE, pixels );
end;


//32bit
procedure GLRenderCopy(tex:GLuint; r:SDL_Rect; pixels:surface);

begin
    glBindTexture(GL_TEXTURE_2D, tex);
    glTexSubImage2D(GL_TEXTURE_2D, 0, r.x, r.h, r.w-r.x, r.y-r.h, GL_RGBA, GL_UNSIGNED_BYTE, pixels );
end;

procedure GLRenderCopyScreen(tex:GLuint; pixels:surface);

begin
    glBindTexture(GL_TEXTURE_2D, tex);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, MaxX, MaxY, GL_RGBA, GL_UNSIGNED_BYTE, pixels );
end;

{

below 15bpp is a 32bpp LUT in an array.
(BE SURE we check against it-or restrict users to those colors.)
32bit colors are natively supported

15/16/24bpp modes need some FBO love
	
I dont know that one can do direct GlBegin..glEND ops with this.
This may be designed soley for the Frag/Vertex shaders- a lot of code is.
-we may have to settle for Textures instead -to get the desired result.	

}

procedure Setup15bpp;

//2D has no depth , 3D will

var
	fbo,textue:Longword;
    draw_buffers:array of GlEnum;

begin

glGenFramebuffers(1, @fbo);
glBindFramebuffer(GL_FRAMEBUFFER, fbo); 

glGenTextures(1, @texture);
glBindTexture(GL_TEXTURE_2D, texture);

//assign nil data as the framebuffer will write to us.  
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB5, MaxX, MaxY, 0, GL_RGB, GL_UNSIGNED_BYTE, NiL);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);  

glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);  

if(glCheckFramebufferStatus(GL_FRAMEBUFFER) <> GL_FRAMEBUFFER_COMPLETE) then
	writeln( 'Framebuffer is not complete!');

glBindFramebuffer(GL_FRAMEBUFFER, fbo);  

//draw into our "texture buffer"
glDrawBuffer(GL_COLOR_ATTACHMENT0);
 
end;  

procedure Setup16bpp;

//2D has no depth , 3D will

var
	fbo,textue:Longword;
    draw_buffers:array of GlEnum;

begin

glGenFramebuffers(1, @fbo);
glBindFramebuffer(GL_FRAMEBUFFER, fbo); 

glGenTextures(1, @texture);
glBindTexture(GL_TEXTURE_2D, texture);

//assign nil data as the framebuffer will write to us.  
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB5_A1, MaxX, MaxY, 0, GL_RGB, GL_UNSIGNED_BYTE, NiL);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);  

glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);  

if(glCheckFramebufferStatus(GL_FRAMEBUFFER) <> GL_FRAMEBUFFER_COMPLETE) then
	writeln( 'Framebuffer is not complete!');

glBindFramebuffer(GL_FRAMEBUFFER, fbo);  

//draw into our "texture buffer"
glDrawBuffer(GL_COLOR_ATTACHMENT0);

end;  

procedure Setup24bpp;


//2D has no depth , 3D will

var
	fbo,textue:Longword;
    draw_buffers:array of GlEnum;

begin
glGenFramebuffers(1, @fbo);
glBindFramebuffer(GL_FRAMEBUFFER, fbo); 

glGenTextures(1, @texture);
glBindTexture(GL_TEXTURE_2D, texture);

//assign nil data as the framebuffer will write to us.  
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, MaxX, MaxY, 0, GL_RGB, GL_UNSIGNED_BYTE, NiL);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);  

glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);  

if(glCheckFramebufferStatus(GL_FRAMEBUFFER) <> GL_FRAMEBUFFER_COMPLETE) then
	writeln( 'Framebuffer is not complete!');

glBindFramebuffer(GL_FRAMEBUFFER, fbo);  

//draw into our "texture buffer"
glDrawBuffer(GL_COLOR_ATTACHMENT0);

end;

//32 is missing- NOT GOING TO IMPLEMENT- use the default FB. 
  
procedure RenderPresentLessThanNative;

begin  
	glBindFramebuffer(GL_FRAMEBUFFER, 0);  
	//swapbuffers;
end;

function Word16_from_RGB(red,green, blue:byte):Word; //Word=GLShort
//565 16bit color
begin
  red:= red shr 3;
  green:= green shr 2;
  blue:=  blue shr 3;
  alpha:=$ff; //ignored
  Word16_from_RGB:= (red shl 11) or (green shl 5) or blue;
end;

function Word15_from_RGB(red,green, blue:byte):Word; //Word=GLShort
//5551 16bit color
begin
  red:= red shr 3;
  green:= green shr 3;
  blue:=  blue shr 3;
  alpha:=$ff; //dropped and ignored
  Word16_from_RGB:= (red shl 10) or (green shl 4) or blue;
end;


//lets see ellipse code which works better

//x,y,W,H,100

procedure DrawEllipse(cx, cy, rx, ry:single; num_segments:integer);
var 
   theta,c,s,t,x,y:single;
   ii:integer;

begin
    //2Pi divided by segments
    theta := 2 * 3.1415926 / num_segments; 
    c := cosf(theta);//precalculate the sine and cosine
    s := sinf(theta);

    x := 1;//we start at angle = 0 
    y := 0; 

    glBegin(GL_LINE_LOOP); 
    ii:=0;
    repeat 
        //apply radius and offset
        glVertex2f(x * rx + cx, y * ry + cy);//output vertex 

        //apply the rotation matrix
        t := x;
        x := c * x - s * y;
        y := s * t + c * y;
	inc(ii);
    until(ii > num_segments;) 
    glEnd(); 
end;

//if W+H= then circle, if not- its an ellipse(flattened bubble)
//n=segments


proceedure DrawEllipse(w,h:word; filled:boolean);
var
	x,y,z:single;
	t:word;

//2d Z=0;

begin
  if  FILLED then
	glBegin(GL_POLYGON);

  else if (not filled) then
        glBegin(GL_POINTS); //or  glBegin(GL_LINE_LOOP); 

  t:=0;
  repeat
      x := w*sin(t);
      y := h*cos(t);
      z := 0;
      //s=short(word) -use instead of f= float(single)
      glVertex3s(x,y,z);
      inc(t);
  until (t = 360);
  glEnd();
end;

procedure RenderPresent(value:integer);
begin
if ((Paused=false) and (DoneRendering=true)) then
//        glutSwapBuffers; //glFlush 
end;

procedure ReSize(Width, Height: Integer); cdecl;
var
    ar:single;

begin
  if Height = 0 then
    Height := 1;

  glViewport(0, 0, MaxX, MaxY);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  ar:= (width / height);
  glFrustum(-ar, ar, -1.0, 1.0, 2.0, 100.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

end;

procedure RenderSomething; cdecl; 

begin
    if Render3d then
		glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    else begin
		glDisable(GL_DEPTH_TEST);
		glClear(GL_COLOR_BUFFER_BIT);
    end;
	 //black
  	 glClearColor( 0.0, 0.0, 0.0, 1.0 );

	 glutSwapBuffers;
end;


//isnt this easy?
procedure GLKeyboard(Key: Byte; X, Y: Longint); cdecl;
begin
  if Key = 27 then begin //ESC
    
  stoplogging;

{  //free textures used
  glGetIntegerv(GL_TEXTURE_BINDING_2D, whichID);

  //effectively Nil each Texture as we are done with all of them.
  glDeleteTextures(whichID^, @whichID);
}
  LIBGRAPHICS_ACTIVE:=false; //refuse to do anything further(rendering wise)
  closegraph;
  
  end;

end;

//idle callback
procedure idle; cdecl;
begin
    glutPostRedisplay; //great for animations
end;


procedure HideMouse;
begin
    if not MouseHidden then
    	glutSetCursor(GLUT_CURSOR_NONE);
   MouseHidden:=true;
end;

procedure ShowMouse;
begin
    if MouseHidden then
    	glutSetCursor(GLUT_CURSOR_TOP_LEFT_CORNER); //Mate+Linux default
    MouseHidden:=false;
end;

{
//easter egg
procedure DanceMouse;
begin
    if not MouseHidden then begin
        repeat
        	glutSetCursor(GLUT_CURSOR_TOP_LEFT_CORNER);
            sleep(300);     
            glutSetCursor(GLUT_CURSOR_TOP_RIGHT_CORNER);
            sleep(300);
        until StopDancing=true;
    end;    
end;
}



function getgraphmode:string;
begin
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


function getdrivername:string;
begin
//not really used anymore-this isnt dos

{$ifdef LCL}
   {$ifdef unix}
       getdrivername:='LazX11GFX'; 
   {$endif}
   {$ifdef mswindows}
   getdrivername:='LazWinGFX'; 
   {$endif}
{$endif}

{$ifdef unix}
       getdrivername:='LazFBGFX'; 
{$endif}
{$ifdef mswindows}
   getdrivername:='LazWinGFX'; 
{$endif}

//   getdrivername:='LazOSXGFX'; 

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

if ((LIBGRAPHICS_ACTIVE=false) and (LIBGRAPHICS_INIT=true)) then begin//coming up

//pull the current mode from xrandr.
//calls to detect graph ASSUME you want the highest mode available. 
//(hint: its probly already set- but what is it?)



//    DetectGraph:=;
    exit;
end else
    //we already have the highest mode. Pull the stored variable.
//    DetectGraph:=HighestMode;

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
    RGBToHex32 := (color.r or (color.g shl 8) or (color.b shl 16) or (color.a shl 24));
{$endif}

{$ifdef mswindows}
//ABGR
    RGBToHex32 := (color.a or (color.b shl 8) or (color.g shl 16) or (color.r shl 24));
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


function RGB4FromLongWord(Someword:Longword):SDL_Color;

var
    LoColor,color:SDL_Color;
    index:byte;
    x:integer;

begin

    if MaxColors =4 then begin
        x:=0;
        repeat
{
//which?? theres four of them...
            if  ((RGBToHex32(Tpalette4^.Colors[x])=SomeWord) then begin //we found a match
                 RGB4FromLongWord:= palette4^.colors[x];
                 exit;
            end;
} 
           inc(x);
        until x=4;
    end else begin //data invalid
             color.r := $00;
             color.g:= $00;
             color.b:= $00;
             color.a:= $00;
            RGB4FromLongWord:= color;
            exit;
    end;
    
    if MaxColors =16 then begin
        //use the DWord to check the limited pallette for a match. Do not shift splitRGB values.
        x:=0;
        repeat
            if  ( (RGBToHex32(Tpalette64.Colors[x]^)=SomeWord)) then begin //we found a match
                 RGB4FromLongWord:= color;
                 exit;
            end;
            inc(x);
        until x=16;
    end else begin //data invalid
             color.r := $00;
             color.g:= $00;
             color.b:= $00;
             color.a:= $00;
            RGB4FromLongWord:= color;
            exit;
    end;


end;

function RGB8FromLongWord(Someword:Longword):SDL_Color;
var
    color:SDL_Color;
    x:integer;

begin

{$ifndef mswindows}

//get the DWord
    color.r:= (someword shr 24) mod 255;
    color.g:= (((someword shr 16) and $ff) mod 255);
    color.b:= ((someword shr 8 and $ff) mod 255);
    color.a:= $ff;
{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color.b:= (someword shr 16) mod 255;
    color.g:= (((someword shr 8) and $ff) mod 255);
    color.r:= ((someword and $ff) mod 255);
    color.a:=$ff;

{$endif}    

    
//CGA,EGA is 4bit, not 8. That was a SDL hack.

    if MaxColors=256 then begin
    //to save time - and hell on me- let use the RGB pair from the DWord and compare it to whats in the palette, unshifted.
        x:=0;
        repeat
            if  (Tpalette256.colors[x]^.r=color.r) and (Tpalette256.colors[x]^.g=color.g) and (Tpalette256.colors[x]^.b=color.b) then begin
                RGB8FromLongWord:= color;
                exit;
            end;
            inc(x);
        until x=256;
    end else begin //data invalid
             color.r := $00;
             color.g:= $00;
             color.b:= $00;
             color.a:= $00;
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
    color.r:= (someword shr 16) mod 255;
    color.g:= (((someword shr 8) and $ff) mod 255);
    color.b:= ((someword and $ff) mod 255);
    color.a:=$ff;
{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color.b:= (someword shr 16) mod 255;
    color.g:= (((someword shr 8) and $ff) mod 255);
    color.r:= ((someword and $ff) mod 255);
    color.a:=$ff;

{$endif}

//333 mod

    color.r:= color.r shr 3;
    color.g:= color.g shr 3;
    color.b:= color.b shr 3;

    RGB5551FromLongWord:=color;
end;

function RGB565FromLongWord(Someword:Longword):SDL_Color;
var
    HiWord:Word;
    color:SDL_Color;
begin
{$ifndef mswindows}

//get the DWord
    color.r:= (someword shr 16) mod 255;
    color.g:= (((someword shr 8) and $ff) mod 255);
    color.b:= ((someword and $ff) mod 255);
    color.a:=$ff;
{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color.b:= (someword shr 16) mod 255;
    color.g:= (((someword shr 8) and $ff) mod 255);
    color.r:= ((someword and $ff) mod 255);
    color.a:=$ff;

{$endif}
//323 mod
    color.r:= color.r shr 3;
    color.g:= color.g shr 2;
    color.b:= color.b shr 3;

    RGB565FromLongWord:=color;
end;

//theres no alpha bit here
function RGBFromLongWord24(SomeDWord:LongWord):SDL_Color;

var
    color:SDL_Color;

begin
{$ifndef mswindows}


//get the DWord
    color.r:= (someDword shr 24) mod 255;
    color.g:= (((someDword shr 16) and $ff) mod 255);
    color.b:= ((someDword shr 8 and $ff) mod 255);
    color.a:= $ff;
{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color.b:= (someDword shr 16) mod 255;
    color.g:= (((someDword shr 8) and $ff) mod 255);
    color.r:= ((someDword and $ff) mod 255);
    color.a:=$ff;

{$endif}    

    RGBFromLongWord24:=color;
end;

//there IS an alpha bit here
function RGBAFromLongWord(SomeDWord:LongWord):SDL_Color;

var
    color:SDL_Color;

begin

{$ifndef mswindows}

    color.r:= (someDword shr 24) mod 255;
    color.g:= (((someDword shr 16) and $ff) mod 255);
    color.b:= ((someDword shr 8 and $ff) mod 255);
    color.a:= (someDword and $ff);

{$endif}


{$ifdef mswindows}
//windows stores it backwards for the GPU
//get the DWord
    color.b:= (someDword shr 24) mod 255;
    color.g:= (((someDword shr 16) and $ff) mod 255);
    color.r:= ((someDword shr 8 and $ff) mod 255);
    color.a:= (someDword and $ff);

{$endif}
    RGBAFromLongWord:=color;
end;

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
//  Dispose(q);
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

begin

	if not graphdriver = ord(detect) then begin
  		if (graphdriver = ord(VGA)) then begin
    		  lomode := ord(VGAMed);
    		  himode := ord(m1024x768xMil);
  		end else

  		if (graphdriver= ord(VESA)) then begin
    		 lomode := ord(CGALo);
    		 himode := ord(m1920x1080xMil);
  		end else

		if (graphdriver = ord(CGALO)) then begin
    	  lomode := ord(CGALo);
    	  himode := ord(CGAHi);
  		end;

	end else begin
        if (graphdriver=ord(DETECT)) then begin
            himode:=detectgraph;	 //unfortunate probe here...   	
// FIXME: return value: (byte to enum value conversion?? - or use a bunch of consts)
// default enum type reads: longword

	    	lomode:= ord(CGALo); //no less than this.
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
//    setViewport(0,0,MaxX,MaxY);
    if ((Rect.x >0) and (Rect.x >0) and (Rect.w < MaxX) and (Rect.h < MaxY)) then begin
        glClearColor(_bgcolor.r,_bgcolor.g,_bgcolor.b, $FF);
//        setViewPort(Rect.x, Rect.y,Rect.w, Rect.h);
    end else 
        exit;
end;


//create a shrunken viewport within the screen - like your bios boot logo-
// but set background color to something other than black.
procedure ColorBorderViewPort(Rect:SDLRect; color:SDL_Color);

begin
//    setViewport(0,0,MaxX,MaxY);
     if ((Rect.x >0) and (Rect.x >0) and (Rect.w < MaxX) and (Rect.h < MaxY)) then begin
        glClearColor(_bgcolor.r,_bgcolor.g,_bgcolor.b, $FF);
//        setViewPort(Rect.x, Rect.y,Rect.w, Rect.h);
    end else 
        exit;
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
    if (bpp < 32) then
      // based on an index of zero so add one 255=>256
      GetMaxColor:=MaxColors+1 
    else //you cant add one- youve hit the LongInt limit already.
        GetMaxColor:=MaxColors;
end;


//Allocate a new texture and flap data onto screen (or scrape data off of it) into a file.
//yes we can do other than BMP.

{


procedure LoadImageTexture(filename:PChar; Rect:PSDL_Rect);
//Rect: I need to know what size you want the imported image, and where you want it.

var
  tex:Longword;
  
begin
   glGenTextures(1,tex);
   Pimage:=SOIL_load_image(filename, Rect^.w, Rect^.h, 0, SOIL_LOAD_RGB);
   glBindTexture(GL_TEXTURE_2D, tex);
   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, Rect^.w, Rect^.h, 0, GL_RGB, GL_UNSIGNED_BYTE, Pimage);
   SOIL_free_image_data(image);
end;



//rootWindow-esque
procedure LoadImageBackground(filename:PChar);

var
  tex:PSDL_Texture;

begin
   glGenTextures(1,tex);
   Pimage:=SOIL_load_image(filename, MaxX, MaxY, 0, SOIL_LOAD_RGB);
   glBindTexture(GL_TEXTURE_2D, tex);
   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, Rect^.w, Rect^.h, 0, GL_RGB, GL_UNSIGNED_BYTE, Pimage);
   SOIL_free_image_data(image);
end;
}

//linestyle is: (patten,thickness) "passed together" (QUE)
//this uses thickness variable only

procedure PlotPixelWNeighbors(x,y:integer; drawAA:boolean);
//this makes the bigger Pixels

// (in other words "blocky bullet holes"...)
var
    myRect:SDLRect;

begin
  if drawAA then
      glEnable(GL_LINE_SMOOTH);
   //more efficient to render a Rect.
//even more to tell OGL that the pixel size is X, drop a vertex, then reset pixel size....

{
   myRect.x:=x;
   myRect.y:=y;
   case Fancyness of
       NormalWidth: begin
             myRect.w:=2;
			 myRect.h:=2;
       end;
       ThickWidth: begin
             myRect.w:=4;
			 myRect.h:=4;
       end;
       SuperThickWidth: begin
             myRect.w:=6;
			 myRect.h:=6;
       end;
       UltimateThickWidth: begin
             myRect.w:=8;
			 myRect.h:=8;
       end;
   end;
   //ensure fills are on
   GLRects(myRect.x,myRect.y,myRect.w,myRect.h);
   //now restore x and y
   case Fancyness of
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
}

if drawAA then
   gldisable(GL_LINE_SMOOTH);

end;

//FIXME: libSOIL
procedure SaveBMPImage(filename:string);

begin
end;


//TURTLE GRAPHICS:

//penUp, moveTo,PenDown....
Procedure MoveTo(X,Y: Word);
//precursor to functions that dont explicity use XY. 
//Rather they assume XY is set before an operation.

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

   DWordToFloat := ASingle;
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
		LogLN('LazGfx CORE refusing to run.');
		halt(0);
{$endif}

{$IFDEF unix}
  IsConsoleInvoked:=true; //All Linux apps are console apps

  if (GetEnvironmentVariable('DISPLAY') = '') then begin //theres no X11 running

       //insert fbGFX init routines here

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

    MyTime:= Now;

//python in pascal(for this routine) is allowed -with the exception handler unit

            AssignFile(output,'lazgfx-debug.log'); 
            ReWrite(output); //do not re-write or re-set.
   
    Logging:=true;
    donelogging:=false;

end.
