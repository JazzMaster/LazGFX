

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

 //   PTTF_Font=^TTF_Font;
    //TTF_Font

//A Ton of code enforces a viewport mandate- that even sans viewports- the screen is one.
//This is better used with screen shrinking effects such as status bars, etc.


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
    Xaspect,YAspect:byte;
    eventLock: PSDL_Mutex;
    eventWait: PSDL_Cond;
    video_timer_id: TSDL_TimerID;

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

//this pre-definition shit is a ~PITA~

//our data may differ from SDLs.
type 
//the lists..
  Pmodelist=^TmodeList;

//wants graphics_modes??
  TmodeList=array [0 .. 31] of TMode;

  PSDLmodeList=^TSDLmodeList;
  TSDLmodeList=array [0 .. 31] of TSDL_DisplayMode;

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

//forward declared defines

function FetchModeList:Tmodelist;

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
function lockNewTexture:PSDL_Texture;
procedure TexUnlock(Tex:PSDL_Texture);


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

procedure initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean);
procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 


//this is like Update_Rect() in SDL v1.
procedure renderTexture( tex:PSDL_Texture;  ren:PSDL_Renderer;  x,y:integer;  clip:PSDL_Rect);
//(use SDL_RenderCopy otherwise)

function getgraphmode:string; 
procedure restorecrtmode;

function getmaxX:word;
function getmaxY:word;

function GetPixel(x,y:integer):DWord;
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

procedure LoadImage(filename:PChar; Rect:PSDL_Rect);
procedure LoadImageStretched(filename:PChar);


procedure PlotPixelWNeighbors(x,y:integer);

procedure SaveBMPImage(filename:string);

//pull a Rect (off the renderer-back to a surface-then kick out a 1D array of SDL_Colors from inside the Rect)
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

