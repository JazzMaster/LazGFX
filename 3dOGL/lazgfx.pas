Unit LazGFX;
{

**LAZARUS/FreePAscal GRAPHICS CORE LIBRARY**

A "fully creative rewrite" of the "Borland Graphic Interface" (c) 2017 (and beyond) by Richard Jasmin
with the assistance of others.

This code **should** port or crossplatform build, but no guarantees.
SEMI-"Borland compatible" w modifications.

This is the GL port- not the SDL one.



This will either become an aux unit for DGL+ FContext, or needs a rewrite using some other GL Interface
GLUT isnt going to work for us, the interface is hackish in places, and doesnt allow enough flexibility in places.
 
Therefore initgraph and closegraph have been removed(in the demo program)

You can still use this in a "uses statement" but I doubt that FContext, nor DGL will allow another unit to "pass thru".


Palettes and modes less then 800x600x24bpp have been removed.
(This is a GL limitation.)


** USE Video Callback TIMERS for video draw methods, do not draw with an input loop(blocks input) **
DEBUGGING MAY BECOME a HEADACHE in CONSOLE builds.

 
Ultimately- Lazarus UI apps are the goal- however, embedded systems (think LCARS) like the Pi-
may not have an XWindow up. This is sort of where libPTC (and GLES) come in.

libPTC "cheats with X11". XAPI and Input handling are already available(much like with WIn32 API).

We should not have to care what is below us- as long as we can get a graphical context atop of it.

(We need Textures and/or FBO for this-Textures may still yet be 32bpp internally)



Lazarus graphics unit is severely lacking(provides TCanvas)...use this instead.


THIS IS NOT A GAME ENGINE. 
This code stacks between "graphics routine filth" and your code.


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


Macintosh:

Im still looking at Quartz seperately. OSX is funky in this regards.	


---
INVOKATION:

There are two ways to invoke this unit-

In Lazarus:

	New Project-> Console App or
	New Project-> Program

Run-> Run Parameters:
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


--Jazz
(comments -and code- by me unless otherwise noted)

	
}


uses

{
Threading(required):

Requires baseunix unit:

cthreads has to be the first unit -in this case-
	we so happen to support the C version natively.

}


//sysutils: IntToStr()


{$IFDEF UNIX}
      cthreads,cmem,sysUtils,baseunix,Classes,

//Android with SDL is going to take some hacking, GL needs "GL ES".

{$ifdef cpujvm}
uses
  {$ifdef java}jdk15{$else}androidr14{$endif};

{$macro on}
{$define writeln:=jlsystem.fout.println}
{$define write:=jlsystem.fout.println}

{$else}
uses
  SysUtils;

{$endif}


	 {$IFNDEF fallback} //fallback uses FrameBuffer only code(slow), otherwise keep loading libs
		GL,GLext, GLU,GLUT,FreeGlut,
		//both free and not-so-free GLUT are REQUIRED! Use GLFW or something else if you dont like this!
        //probly cairo and pango too at this point.
	 {$ENDIF}
    
 {$IFDEF fallback} 
    //mesa  --use software GL, then (instead of hardware-slower)
	// svga,directfb  -this can support 3d but its horrendously slow on most unices, sans RasPi.	
 {$ENDIF}

{$ENDIF}

    ctypes,

//ctypes: cint,uint,PTRUint,PTR-USINT,sint...etc.

// A hackish trick...test if LCL unit(s) are loaded or linked in, then adjust "console" logging...

{$IFDEF MSWINDOWS} //as if theres a non-MS WINDOWS?
    Windows,MMsystem, //audio subsystem-MMsystem is only for 32bit

	 {$IFDEF fallback}
		WinGraph, //WinAPI-needs rework
	 {$endif}

{$ENDIF}

//LCL is invoked thru FContext and DGL, not here.


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


{
if you are in a input loop or waiting for keypress-
 you will not get output until your program is complete (and has stopped execution)


In this case- Lazarus Menu:
Run -> Run Parameters, then check the box for "Use launching application".
(You may have to 'chmod +x' that script.)

}

//FPC generic units(OS independent)

  uos,strings,typinfo,logger


{
OpenGL requires Quartz, which prevents building below OSX 10.2.

direct rendering onto the renderer uses QuartzGL(on OSX up to Mtn LN- it wont stay active once set)
Cocoa (OBJ-C) is the new API
}


//lets be fair to the compiler..
{$IFDEF debug} ,heaptrc {$ENDIF} 

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

//Fragment, not vertex
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

//pat attn: stores the data in a different format.
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
    bpp:byte;
  	MaxX:Word;
    MaxY:Word;
	XAspect:byte;
	YAspect:byte;
	AspectRatio:real; //things are computed from this somehow...
end; //record

//color names arent needed because wre in 24 or 32bpp


	graphics_modes=(

//fixme: patchme from the other two units

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

  WantsAudioToo,WantsCDROM:boolean;	
  DoubleSize,Blink:boolean;
  CenterText:boolean=false; //see crtstuff unit for the trick
  Render3d:boolean; //turn off for HUDs
  MaxX,MaxY:word;
  bpp:byte;
  Fancyness:Thickness;
  _fgcolor, _bgcolor:SDL_Color;	
  //use index colors once setup(palette unit)
  DoneRendering,drawAALines:boolean;
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
function GetPixel(x,y:word):PSDL_Color;
function readpixelsTex(x,y,width,height:integer; Texture:LongWord):Pmypixels;
procedure UpdateRect(x,y,width,height:integer; Texture:Longword; pixels:pmypixels);
procedure EnableAAMode;
procedure DisableAAMode;
procedure SetRGBColor(r,g,b:byte);
procedure SetRGBAColor(r,g,b,a:byte);

procedure PutPixel(x,y:Word);
procedure PutPixelRGB(r,g,b:byte; x,y:word);
procedure PutPixelRGBA(r,g,b,a:byte;  x,y:word);

procedure DrawPoly(GiveMePoints:Points);
procedure CreateNewTexture;
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



  glColorTable(GL_COLOR_TABLE, GL_RGBA8, 16, GL_RGBA, GL_UNSIGNED_BYTE, Ppalette16Grey);

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

}

//semi-generic color functions

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

//return SDL_Color???
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

        24: glReadPixels(x, y, 1,1, GL_RGB, GL_UNSIGNED_BYTE, someColor);
        32: glReadPixels(x, y, 1,1, GL_RGBA, GL_UNSIGNED_BYTE, someColor);
    end;
end;

//necessary wrapper- output is "inconsistently fucked"
function GetPixel(x,y:word):PSDL_Color;
var
    someColor:PSDL_Color;
begin
    case (bpp) of
        24,32:GetPixelElse(x,y);
    end;
    GetPixel:=someColor;
end;


function readpixelsTex(x,y,width,height:integer; Texture:LongWord):Pmypixels;

var
    PointedPixels:Pmypixels;    

begin
  case (bpp) of

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


//switch to freeImage
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

NET:
	init and teardown need to be added here- I havent gotten to that.
	(I was trying to find viable non-C,non-SDL Net code)

}


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


{

Got weird fucked up c boolean evals? (JEEZ theyre a BITCH to understand....)

  wonky "what ? (eh vs uh) : something" ===> if (evaluation) then (= to this) else (equal to that)
(usually a boolean eval with a byte input- an overflow disaster waiting to happen)

for example:
	SDL_SetRenderDrawBlend(renderer, (a = 255) ? SDL_BLEND_NONE : SDL_BLEND_BLEND);

SDL2:
    Create a new texture for most ops-

Rendering is being called automatically at minimum (screen_refresh) as an interval.
Refresh is fine if data is in the backbuffer. 

Until its copied into the main buffer- its never displayed.

}

//"Texture locking thru OGL on Unices is unpredictable." -SDL DEv team. NICE JOKE.
//what you mean was glBindTexture's "second call = Nil", right?



//set FGColor

procedure setFGColor(r,g,b:byte); overload;

begin
   glColor3b(r,g,b ); 
end;

procedure setFGColor(r,g,b,a:byte); overload;

begin
   glColor4b(r,g,b,a); 
end;



{

procedure setFGColor(someDword:dword); overload;
var
    r,g,b:byte;
    somecolor:PSDL_Color;

begin
//break apart the dword into bytes


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
 
If bychance I can get this working- I will re-add init and closeGraph.

Window modes are easy. FS modes will depend. Are we using GLFW, GLUT, what?
 
Net and sound and ... init routines will be added to the Laz Demo.

Screen probing-
	we can start with current resolution, pulled from xrandr(xrender) unit.
	generally- we are already too big than "these old modes".

I may leave the specs for you.

//patchme: add the GC Modelist here from the other two units.
 
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


type
	PImageData=^ImageData;
    ImageData= array  of byte; //variable
    
var
	Image:PImageDAta;

//GetPixels/ReadPixels

//32bit is from the framebuffer- not a Texture.

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

//we may be able to use textures at 15/16bpp, but FS GetPixel/PutPixel and 
//other ops, especially below 24bpp may be limited.

//GL refuses to init below 24bpp..This much I can tell you.
// support, however for lower depth bpp textures appears to still be present.

//Paletted mode arent supported, TExtures may be.

//-as a result Ive remove most of the <24bpp code already. This can stay.

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

//FBO code isnt what we want, either...
//seems to be a TON of OGL that we dont want (for one reason or another)
  
//Texture, not FBO  
procedure RenderPresentLessThanNative;

begin  
	glBindFramebuffer(GL_FRAMEBUFFER, 0);  
	//swapbuffers;
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
         glFlush 
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
       getdrivername:='LazGL'; 
   {$endif}
   {$ifdef mswindows}
   getdrivername:='LazGL'; //DX: D3D? 
   {$endif}
{$endif}

{$ifdef unix}
       getdrivername:='LazFBGL'; 
{$endif}
{$ifdef mswindows}
   getdrivername:='LazWinGL'; //DX: D3D?
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

//SDL equivalents

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

//These two only worn in VTerms, but how to test if we are in one?
//Yes, GL will screw up output- which is usually scrolled(via shell).

//save before GL init
procedure saveVideoState;
//leaving text mode for graphics mode
begin
{$ifndef fallback}
    LogLn('function not implemented: restoreVideoState. Nothing to save.');
{$endif}

end;

//restore after it
procedure restoreVideoState;
//leaving graphics mode for text mode
begin
{$ifndef fallback}
    LogLn('function not implemented: restoreVideoState. Nothing to restore.');
{$endif}

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
//FIXME:
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

//FIXME: FreeImage
procedure SaveBMPImage(filename:string);

begin
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

       //insert fbGL init routines here

    //old behaviour
    LogLN('X11 has not fired. Bailing.');	
    halt(0);

  end;
{$ENDIF}


//with initgraph (as a function) it returns one of these codes
//these are the strings of the error codes

   screenshots:=00000000;

   windownumber:=0;
   
   MyTime:= Now;

    Logging:=true;
    donelogging:=false;

end.
