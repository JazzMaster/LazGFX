
type  

//you could use normal GL coords and cap at floatMax of 1.0
// (but the coords are whacky-weird.)

//these use normal co ord system:

//verticle line: use y, not x

procedure CenteredHLine(x,x2,y:Word);
	//where is the center??
	center:= (((x mod 2)) - ((x-x2) mod 2),(y mod 2));
	//from center : draw line from here
	
end;

//verticle line: use x, not y

procedure CenteredVLine(x,y,y2:Word);
	//where is the center??
	center:= ((x mod 2),((y mod 2)) - ((y-y2) mod 2));
	//from center : draw line from here
	
end;



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

//A Ton of code enforces a viewport mandate- that even sans viewports- the screen is one.
//This is better used with screen shrinking effects


//graphdriver is not really used half the time anyways..most people probe.
//these are range checked numbers internally.

	graphics_driver=(DETECT, CGA, VGA,VESA); //cga,vga,vesa,hdmi,hdmi1.2


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


//this isnt SDL- so for compatibility reasons- I can define this however I choose.
//A "Surface" is an "array of pixels"--up to max screen resolution

	PSDL_Surface=^SDL_Surface;
	SDL_Surface=array [0..MaX,0..MaxY] of SDL_Pixel;

const
   //Analog joystick dead zone 
   JOYSTICK_DEAD_ZONE = 8000;
   //joysticks seem to be slow to respond in some games....

var

    Xaspect,YAspect:byte;

    palette:PSDL_Palette;
    where:Twhere;
	quit,minimized,paused,wantsFullIMGSupport,nojoy,exitloop:boolean;
    nogoautorefresh:boolean;
    X,Y:integer;
    _grResult:grErrortype;
    

    //you want event driven, not input driven-the code seems to be here.
//    gGameController:PSDL_Joystick;


    MainSurface,FontSurface : PSDL_Surface;

    srcR,destR,TextRect:PSDL_Rect;

    filename:String;
    fontpath,iconpath:PChar; // look in: "C:\windows\fonts\" or "/usr/share/fonts/"

{

Fonts:
GLUT defines the following(stroked fonts):



}

    font_size:integer; 
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
//	GLContext: TSDL_GLContext;

	GLFloat:single;
	FloatInt:single;

    modePointer:Pmode;


//forward declared defines

function FetchModeList:Tmodelist;

procedure RoughSteinbergDither(filename,filename2:string);


//surfaceOps
//procedure lock;
//procedure unlock;

//works around SDL OpenGL bug where Windows got optimzed, but Unices didnt--WRONG BTW! (WRITE UNIVERSAL CODE)
//procedure Texlock(Tex:PSDL_Texture);
//procedure TexlockwRect(Tex:PSDL_Texture; Rect:PSDL_Rect);
//function lockNewTexture:PSDL_Texture;
//procedure TexUnlock(Tex:PSDL_Texture);


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

//this is like Update_Rect() in SDL v1.
procedure renderTexture( tex:PSDL_Texture;  ren:PSDL_Renderer;  x,y:integer;  clip:PSDL_Rect);

procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 
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

function  getDwordFromSDLColor(someColor:PSDL_Color):DWord;
function  getDwordFromBytes(r,g,b,a:Byte):DWord;
function GetByesfromDWord(someD:DWord):SDL_Color;

procedure PlotPixelWNeighbors(x,y:integer);

procedure SaveBMPImage(filename:string);

//pull a Rect (off the renderer-back to a surface-then kick out a 1D array of SDL_Colors from inside the Rect)
function GetPixels(Rect:PSDL_Rect):pointer;


const
   maxMode=Ord(High(Graphics_Modes));
