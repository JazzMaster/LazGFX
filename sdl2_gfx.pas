unit sdl2_gfx;

{
 
 Sources modified from a combination of:
   SDL2_GFX add-on unit for SDL2 
   FPC Graphics unit sources

Ive done some of this work with RGB/RGBA- just not to this extent.
I personally feel that these should be a part of any main graphics routines.
So Ive imported the routines.

AFAIK:
	This uses Xlib/WinAPI backend, not OpenGL quads.
		WinAPI is explicitly available for WindowsFPC
		Supposedly similar functionality is available-will test.
	OpenGL Quads/DirectX are another set of demos, etc. (may be worth your while)

"Roto-zooming" is a late 90s "thing" with games like:
		Final Fantasy 7,SonicCD (temporal teleportation) 
  or TV series like: stargate SG:1,	etc.
  
(Not widely used)

Framerate management is old school- you should be using deltas for refresh.
However, management of such needs to happen-
	Havoc engine -Skyrim refresh bugs- affect playability(in some cases very badly)


ImageFiltering and Rotozooming(less important):

	-need to shift into -or out of- RGB/RGBA modes to support 24 and 15/16 bit depths.

Original code (in C) Copyright (C) 2001-2012  Andreas Schiffler
 -- aschiffler at ferzkopp dot net

}


{$IFNDEF FPC}
  {$IFDEF Debug}
    {$F+,D+,Q-,L+,R+,I-,S+,Y+,A+}
  {$ELSE}
    {$F+,Q-,R-,S-,I-,A+}
  {$ENDIF}
{$ELSE}
  {$/E DELPHI} //dont force delphi mode unless using it- JEDI is slanted torawrds that, which is wrong.
{$ENDIF}

//BP7 but assumes a 16bit OVL unit- there is a 32bit available.
//-I have it. -Jazz

{$IFDEF LINUX}
{$DEFINE UNIX}
{$ENDIF}

{$IFDEF ver70}
   {$IFDEF Windows}
     {$DEFINE Win16}
   {$ENDIF Windows}
   {$IFDEF MSDOS}
     {$DEFINE NO_EXPORTS}
   {$ENDIF MSDOS}
   {$IFDEF DPMI}
     {$DEFINE BP_DPMI}
   {$ENDIF}
   {$DEFINE OS_16_BIT}
   {$DEFINE __OS_DOS__}
{$ENDIF ver70}

{$IFDEF ver80}
   {$DEFINE Delphi}      {Delphi 1.x}
   {$DEFINE Delphi16}
   {$DEFINE Win16}
   {$DEFINE OS_16_BIT}
   {$DEFINE __OS_DOS__}
{$ENDIF ver80}

{$IFDEF ver90}
   {$DEFINE Delphi}      {Delphi 2.x}
   {$DEFINE WIN32}
   {$DEFINE WINDOWS}
{$ENDIF ver90}

{$IFDEF ver100}
   {$DEFINE Delphi}      {Delphi 3.x}
   {$DEFINE WIN32}
   {$DEFINE WINDOWS}
{$ENDIF ver100}

{$IFDEF ver93}
   {$DEFINE Delphi}      {C++ Builder 1.x}
   {$DEFINE WINDOWS}
{$ENDIF ver93}

{$IFDEF ver110}
   {$DEFINE Delphi}      {C++ Builder 3.x}
   {$DEFINE WINDOWS}
{$ENDIF ver110}

{$IFDEF ver120}
   {$DEFINE Delphi}      {Delphi 4.x}
   {$DEFINE Delphi4UP}
   {$DEFINE Has_Int64}
   {$DEFINE WINDOWS}
{$ENDIF ver120}

{$IFDEF ver130}
   {$DEFINE Delphi}      {Delphi / C++ Builder 5.x}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Has_Int64}
   {$DEFINE WINDOWS}
{$ENDIF ver130}

{$IFDEF ver140}
   {$DEFINE Delphi}      {Delphi / C++ Builder 6.x}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Has_Int64}
   {$DEFINE HAS_TYPES}
{$ENDIF ver140}

{$IFDEF ver150}
   {$DEFINE Delphi}      {Delphi 7.x}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver150}

{$IFDEF ver160}
   {$DEFINE Delphi}      {Delphi 8.x}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver160}

{$IFDEF ver170}
   {$DEFINE Delphi}      {Delphi / C++ Builder 2005}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver170}

{$IFDEF ver180}
   {$DEFINE Delphi}      {Delphi / C++ Builder 2006 / 2007}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver180}

{$IFDEF ver185}
   {$DEFINE Delphi}      {Delphi / C++ Builder 2007}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver185}

{$IFDEF ver190}
   {$DEFINE Delphi}      {Delphi / C++ Builder 2007 }
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver190}

{$IFDEF ver200}
   {$DEFINE Delphi}      {Delphi / C++ Builder 2009 }
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$DEFINE Delphi13UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver200}

{$IFDEF ver210}
   {$DEFINE Delphi}      {Delphi / C++ Builder 2010}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$DEFINE Delphi13UP}
   {$DEFINE Delphi14UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver210}

{$IFDEF ver220}
   {$DEFINE Delphi}      {Delphi / C++ Builder XE}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$DEFINE Delphi13UP}
   {$DEFINE Delphi14UP}
   {$DEFINE Delphi15UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver220}

{$IFDEF ver230}
   {$DEFINE Delphi}      {Delphi / C++ Builder XE2}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$DEFINE Delphi13UP}
   {$DEFINE Delphi14UP}
   {$DEFINE Delphi15UP}
   {$DEFINE Delphi16UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver230}

{$IFDEF ver240}
   {$DEFINE Delphi}      {Delphi / C++ Builder XE4}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$DEFINE Delphi13UP}
   {$DEFINE Delphi14UP}
   {$DEFINE Delphi15UP}
   {$DEFINE Delphi16UP}
   {$DEFINE Delphi17UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver240}

{$IFDEF ver250}
   {$DEFINE Delphi}      {Delphi / C++ Builder XE5}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$DEFINE Delphi13UP}
   {$DEFINE Delphi14UP}
   {$DEFINE Delphi15UP}
   {$DEFINE Delphi16UP}
   {$DEFINE Delphi17UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver250}

{$IFDEF ver260}
   {$DEFINE Delphi}      {Delphi / C++ Builder XE6}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$DEFINE Delphi13UP}
   {$DEFINE Delphi14UP}
   {$DEFINE Delphi15UP}
   {$DEFINE Delphi16UP}
   {$DEFINE Delphi17UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver260}

{$IFDEF ver270}
   {$DEFINE Delphi}      {Delphi / C++ Builder XE7}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$DEFINE Delphi13UP}
   {$DEFINE Delphi14UP}
   {$DEFINE Delphi15UP}
   {$DEFINE Delphi16UP}
   {$DEFINE Delphi17UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$ENDIF ver270}

{$IFNDEF FPC}	  
{$IF CompilerVersion > 27}
   {$DEFINE Delphi}      {Delphi / C++ Builder}
   {$DEFINE Delphi4UP}
   {$DEFINE Delphi5UP}
   {$DEFINE Delphi6UP}
   {$DEFINE Delphi7UP}
   {$DEFINE Delphi8UP}
   {$DEFINE Delphi9UP}
   {$DEFINE Delphi10UP}
   {$DEFINE Delphi11UP}
   {$DEFINE Delphi12UP}
   {$DEFINE Delphi13UP}
   {$DEFINE Delphi14UP}
   {$DEFINE Delphi15UP}
   {$DEFINE Delphi16UP}
   {$DEFINE Delphi17UP}
   {$WARN UNSAFE_TYPE OFF} {Disable warning for unsafe types}
   {$DEFINE Has_Int64}
   {$DEFINE Has_UInt64}
   {$DEFINE Has_Native}
   {$DEFINE HAS_TYPES}
{$IFEND}
{$ENDIF}
	  
{*************** define 16/32/64 Bit ********************}

{$IFDEF MSWINDOWS}
{$IFDEF WIN16}
  {$DEFINE 16BIT}
  {$DEFINE WINDOWS}
{$ENDIF}

{$IFDEF WIN32}
    {$DEFINE 32BIT}
    {$DEFINE WINDOWS}
{$ENDIF}

{$IFDEF WIN64}
      {$DEFINE 64BIT}
      {$DEFINE WINDOWS}
{$ENDIF}

{$ENDIF}

{$IFDEF Delphi}
  {$DEFINE USE_STDCALL}
  {$IFDEF 32Bit}
    {$DEFINE DELPHI32}
  {$ELSE}
    {$IFDEF 64Bit}
	  {$DEFINE DELPHI64}
	{$ELSE}
	  {$DEFINE DELPHI16}
	{$ENDIF}
  {$ENDIF}
  //{$ALIGN ON}
{$ENDIF Delphi}

{$IFDEF FPC}
  {$H+}
  {$PACKRECORDS C}        // Added for record
  {$PACKENUM DEFAULT}     // Added for c-like enumerators
  {$MACRO ON}             // Added For OpenGL
  {$DEFINE Delphi}
  {$DEFINE UseAT}
  {$UNDEF USE_STDCALL}
  {$DEFINE OS_BigMem}
  {$DEFINE NO_EXPORTS}
  {$DEFINE Has_UInt64}
  {$DEFINE Has_Int64}
  {$DEFINE Has_Native}
  {$DEFINE NOCRT}
  {$IFDEF UNIX}
     {$DEFINE fpc_unix}
  {$ELSE}
     {$DEFINE __OS_DOS__}
  {$ENDIF}
  {$IFDEF WIN32}
   {$DEFINE UseWin}
  {$ENDIF}
  {$DEFINE HAS_TYPES}
{$ENDIF FPC}

{$IFDEF Win16}
  {$K+}   {smart callbacks}
{$ENDIF Win16}

{$IFDEF Win32}
  {$DEFINE OS_BigMem}
{$ENDIF Win32}

{ ************************** dos/dos-like platforms **************}
{$IFDEF Windows}
   {$DEFINE __OS_DOS__}
   {$DEFINE UseWin}
   {$DEFINE MSWINDOWS}
{$ENDIF Delphi}

{$IFDEF OS2}
   {$DEFINE __OS_DOS__}
   {$DEFINE Can_Use_DLL}
{$ENDIF Delphi}

{$IFDEF UseWin}
   {$DEFINE Can_Use_DLL}
{$ENDIF}

{$IFDEF Win16}
   {$DEFINE Can_Use_DLL}
{$ENDIF}

{$IFDEF BP_DPMI}
   {$DEFINE Can_Use_DLL}
{$ENDIF}

{$IFDEF USE_STDCALL}
  {$DEFINE BY_NAME}
{$ENDIF}

{*************** define LITTLE ENDIAN platforms ********************}


{$IFDEF Delphi}
  {$DEFINE IA32}
{$ENDIF}

{$IFDEF FPC}
  {$IFDEF FPC_LITTLE_ENDIAN}
    {$DEFINE IA32}
  {$ENDIF}
{$ENDIF}
uses
	SDL2,math,strings;



{$ifndef M_PI}
{$define M_PI	3.1415926535897932384626433832795}
{$endif}

{$include SDL.inc}

{
const
	SDL2_GFXPRIMITIVES_MAJOR=2
	SDL2_GFXPRIMITIVES_MINOR=0
	SDL2_GFXPRIMITIVES_MICRO=0

Procedure SDL_GFX_VERSION(Out X: TSDL_Version);

}


Const
//in Hz
   FPS_UPPER_LIMIT = 200;
   FPS_LOWER_LIMIT = 1;
   FPS_DEFAULT = 30;

Type
    
    //Record holding the state and timing information of the framerate controller.   
   
   TFPSManager = record
      framecount : LongWord;
      rateticks : Single; // float rateticks;
      baseticks : LongWord;
      lastticks : LongWord;
      rate : LongWord;
   end;
   
   PFPSManager = ^TFPSManager;


SDL2_gfxBresenhamIterator=record
	x, y:LongInt;
	dx, dy, s1, s2, swapdir, error:integer;
	count:LongWord;
end;	

SDL2_gfxMurphyIterator=record
	renderer:PSDL_Renderer;
	u, v:integer;		/* delta x , delta y */
	ku, kt, kv, kd:integer;	/* loop constants */
	oct2:integer;
	quad4:integer;
	last1x, last1y, last2x, last2y, first1x, first1y, first2x, first2y, tempx, tempy:SmallInt;
end; 

//LongWord= Longword

Procedure SDL_initFramerate(manager: PFPSManager);
Function SDL_setFramerate(manager: PFPSManager; rate: LongWord):LongInt;  
Function SDL_getFramerate(manager: PFPSManager):LongInt;
Function SDL_getFramecount(manager: PFPSManager):LongInt;
Function SDL_framerateDelay(manager: PFPSManager):LongWord;

//FIXME: all Color routines expect the colour to be in format RRGGBBAA 
//This SHOULD NOT be assumed.


Function pixelColor(renderer: PSDL_Renderer; x, y: sInt16; colour: LongWord):LongInt; 
Function pixelRGBA(renderer: PSDL_Renderer; x, y: sInt16; r, g, b, a: uInt8):LongInt; 

{ Horizontal line }

Function hlineColor(renderer: PSDL_Renderer; x1, x2, y: sInt16; colour: LongWord):LongInt; 
Function hlineRGBA(renderer: PSDL_Renderer; x1, x2, y:sInt16; r, g, b, a: uInt8):LongInt; 

{ Vertical line }

Function vlineColor(renderer: PSDL_Renderer; x, y1, y2: sInt16; colour: LongWord):LongInt; 
Function vlineRGBA(renderer: PSDL_Renderer; x, y1, y2: sInt16; r, g, b, a: uInt8):LongInt; 

{ Rectangle }

Function rectangleColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; colour: LongWord):LongInt; 
Function rectangleRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; r, g, b, a: uInt8):LongInt; 

{ Rounded-Corner Rectangle }

Function roundedRectangleColor(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: sInt16; colour: LongWord):LongInt; 
Function roundedRectangleRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: sInt16; r, g, b, a: uInt8):LongInt; 

{ Filled rectangle (Box) }

Function boxColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; colour: LongWord):LongInt; 
Function boxRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; r, g, b, a: uInt8):LongInt; 

{ Rounded-Corner Filled rectangle (Box) }

Function roundedBoxColor(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: sInt16; colour: LongWord):LongInt; 
Function roundedBoxRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: sInt16; r, g, b, a: uInt8):LongInt; 

{ Line }

Function lineColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; colour: LongWord):LongInt; 
Function lineRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; r, g, b, a: uInt8):LongInt; 

{ AA Line }

Function aalineColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; colour: LongWord):LongInt; 
Function aalineRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; r, g, b, a: uInt8):LongInt; 

{ Thick Line }
Function thickLineColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; width: uInt8; colour: LongWord):LongInt; 
Function thickLineRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; width, r, g, b, a: uInt8):LongInt; 

{ Circle }

Function circleColor(renderer: PSDL_Renderer; x, y, rad: sInt16; colour: LongWord):LongInt; 
Function circleRGBA(renderer: PSDL_Renderer; x, y, rad: sInt16; r, g, b, a: uInt8):LongInt; 

{ Arc }

Function arcColor(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; colour: LongWord):LongInt; 
Function arcRGBA(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; r, g, b, a: uInt8):LongInt; 

{ AA Circle }

Function aacircleColor(renderer: PSDL_Renderer; x, y, rad: sInt16; colour: LongWord):LongInt; 
Function aacircleRGBA(renderer: PSDL_Renderer; x, y, rad: sInt16; r, g, b, a: uInt8):LongInt; 

{ Filled Circle }

Function filledCircleColor(renderer: PSDL_Renderer; x, y, rad: sInt16; colour: LongWord):LongInt; 
Function filledCircleRGBA(renderer: PSDL_Renderer; x, y, rad: sInt16; r, g, b, a: uInt8):LongInt; 

{ Ellipse }

Function ellipseColor(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; colour: LongWord):LongInt; 
Function ellipseRGBA(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; r, g, b, a: uInt8):LongInt; 

{ AA Ellipse }

Function aaellipseColor(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; colour: LongWord):LongInt; 
Function aaellipseRGBA(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; r, g, b, a: uInt8):LongInt; 

{ Filled Ellipse }

Function filledEllipseColor(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; colour: LongWord):LongInt; 
Function filledEllipseRGBA(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; r, g, b, a: uInt8):LongInt; 

{ Pie }

Function pieColor(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; colour: LongWord):LongInt; 
Function pieRGBA(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; r, g, b, a: uInt8):LongInt; 

{ Filled Pie }

Function filledPieColor(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; colour: LongWord):LongInt; 
Function filledPieRGBA(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; r, g, b, a: uInt8):LongInt; 

{ Trigon }

Function trigonColor(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; colour: LongWord):LongInt; 
   
Function trigonRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; r, g, b, a: uInt8):LongInt; 

{ AA-Trigon }

Function aatrigonColor(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; colour: LongWord):LongInt; 
Function aatrigonRGBA(renderer: PSDL_Renderer;  x1, y1, x2, y2, x3, y3: sInt16; r, g, b, a: uInt8):LongInt; 

{ Filled Trigon }

Function filledTrigonColor(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; colour: LongWord):LongInt; 
Function filledTrigonRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; r, g, b, a: uInt8):LongInt; 

{ Polygon }

Function polygonColor(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: LongInt; colour: LongWord):LongInt; 
Function polygonRGBA(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: LongInt; r, g, b, a: uInt8):LongInt; 

{ AA-Polygon }

Function aapolygonColor(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: LongInt; colour: LongWord):LongInt; 
Function aapolygonRGBA(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: LongInt; r, g, b, a: uInt8):LongInt; 

{ Filled Polygon }

Function filledPolygonColor(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: LongInt; colour: LongWord):LongInt; 
Function filledPolygonRGBA(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: LongInt; r, g, b, a: uInt8):LongInt; 

{ Textured Polygon }

Function texturedPolygon(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: LongInt; texture: PSDL_Surface; texture_dx, texture_dy: LongInt):LongInt; 

{ Bezier }

Function bezierColor(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n, s: LongInt; colour: LongWord):LongInt; 
Function bezierRGBA(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n, s: LongInt; r, g, b, a: uInt8):LongInt; 



{ Comments:             
on x86 and derivatives- optimized for MMX
on Power arch- optimize for AltiVec 
on ARM (v5+ is 32+bits)- ???
                                                              
   1.) MMX functions work best if all data blocks are aligned on a 32 bytes boundary. 

   2.) Data that is not within an 8 byte boundary is processed using the C routine.   
   3.) Convolution routines is not processed at this time.                      

}

// Detect MMX capability in CPU
//This should be done HERE in FPC - then use of which determined if CPU function is available.

{
Function SDL_imageFilterMMXdetect():LongInt; 

// Force use of MMX off (or turn possible use back on)
Procedure SDL_imageFilterMMXoff(); cdecl;
Procedure SDL_imageFilterMMXon(); cdecl;
}

//  SDL_imageFilterAdd: D = saturation255(S1 + S2)
Function SDL_imageFilterAdd(Src1, Src2, Dest : PuInt8; Length : LongWord):LongInt; 

//  SDL_imageFilterMean: D = S1/2 + S2/2
Function SDL_imageFilterMean(Src1, Src2, Dest : PuInt8; Length:LongWord):LongInt; 

//  SDL_imageFilterSub: D = saturation0(S1 - S2)
Function SDL_imageFilterSub(Src1, Src2, Dest : PuInt8; Length:LongWord):LongInt; 

//  SDL_imageFilterAbsDiff: D = | S1 - S2 |
Function SDL_imageFilterAbsDiff(Src1, Src2, Dest : PuInt8; Length:LongWord):LongInt; 

//  SDL_imageFilterMult: D = saturation(S1 * S2)
Function SDL_imageFilterMult(Src1, Src2, Dest : PuInt8; Length:LongWord):LongInt; 

//  SDL_imageFilterMultNor: D = S1 * S2   (non-MMX)
Function SDL_imageFilterMultNor(Src1, Src2, Dest : PuInt8; Length:LongWord):LongInt; 

//  SDL_imageFilterMultDivby2: D = saturation255(S1/2 * S2)
Function SDL_imageFilterMultDivby2(Src1, Src2, Dest : PuInt8; Length: LongWord):LongInt; 

//  SDL_imageFilterMultDivby4: D = saturation255(S1/2 * S2/2)
Function SDL_imageFilterMultDivby4(Src1, Src2, Dest : PuInt8; Length : LongWord):LongInt; 

//  SDL_imageFilterBitAnd: D = S1 & S2
Function SDL_imageFilterBitAnd(Src1, Src2, Dest : PuInt8; Length:LongWord):LongInt; 

//  SDL_imageFilterBitOr: D = S1 | S2
Function SDL_imageFilterBitOr(Src1, Src2, Dest : PuInt8; Length:LongWord):LongInt; 

//  SDL_imageFilterDiv: D = S1 / S2   (non-MMX)
Function SDL_imageFilterDiv(Src1, Src2, Dest : PuInt8; Length:LongWord):LongInt; 

//  SDL_imageFilterBitNegation: D = !S
Function SDL_imageFilterBitNegation(Src1, Dest : PuInt8; Length:LongWord):LongInt; 

//  SDL_imageFilterAddByte: D = saturation255(S + C)
Function SDL_imageFilterAddByte(Src1, Dest : PuInt8; Length:LongWord; C : uInt8):LongInt; 

//  SDL_imageFilterAddULongInt: D = saturation255(S + (uLongInt)C)
Function SDL_imageFilterAddULongInt(Src1, Dest : PuInt8; Length:LongWord; C : LongWord):LongInt; 

//  SDL_imageFilterAddByteToHalf: D = saturation255(S/2 + C)
Function SDL_imageFilterAddByteToHalf(Src1, Dest : PuInt8; Length:LongWord; C : uInt8):LongInt; 

//  SDL_imageFilterSubByte: D = saturation0(S - C)
Function SDL_imageFilterSubByte(Src1, Dest : PuInt8; Length:LongWord; C : uInt8):LongInt; 

//  SDL_imageFilterSubULongInt: D = saturation0(S - (uLongInt)C)
Function SDL_imageFilterSubULongInt(Src1, Dest : PuInt8; Length:LongWord; C : LongWord):LongInt; 

//  SDL_imageFilterShiftRight: D = saturation0(S >> N)
Function SDL_imageFilterShiftRight(Src1, Dest : PuInt8; Length:LongWord; N : uInt8):LongInt; 

//  SDL_imageFilterShiftRightULongInt: D = saturation0((uLongInt)S >> N)
Function SDL_imageFilterShiftRightULongInt(Src1, Dest : PuInt8; Length:LongWord; N : uInt8):LongInt; 

//  SDL_imageFilterMultByByte: D = saturation255(S * C)
Function SDL_imageFilterMultByByte(Src1, Dest : PuInt8; Length:LongWord; C : uInt8):LongInt; 

//  SDL_imageFilterShiftRightAndMultByByte: D = saturation255((S >> N) * C)
Function SDL_imageFilterShiftRightAndMultByByte(Src1, Dest : PuInt8; Length:LongWord; N, C : uInt8):LongInt; 

//  SDL_imageFilterShiftLeftByte: D = (S << N)
Function SDL_imageFilterShiftLeftByte(Src1, Dest : PuInt8; Length:LongWord; N: uInt8):LongInt; 

//  SDL_imageFilterShiftLeftULongInt: D = ((uLongInt)S << N)
Function SDL_imageFilterShiftLeftULongInt(Src1, Dest : PuInt8; Length:LongWord; N:uInt8):LongInt; 

//  SDL_imageFilterShiftLeft: D = saturation255(S << N)
Function SDL_imageFilterShiftLeft(Src1, Dest : PuInt8; Length:LongWord; N : uInt8):LongInt; 

//  SDL_imageFilterBinarizeUsingThreshold: D = S >= T ? 255:0
Function SDL_imageFilterBinarizeUsingThreshold(Src1, Dest : PuInt8; Length:LongWord; T: uInt8):LongInt; 

//  SDL_imageFilterClipToRange: D = (S >= Tmin) & (S <= Tmax) 255:0
Function SDL_imageFilterClipToRange(Src1, Dest : PuInt8; Length:LongWord; Tmin, Tmax: uInt8):LongInt; 

//  SDL_imageFilterNormalizeLinear: D = saturation255((Nmax - Nmin)/(Cmax - Cmin)*(S - Cmin) + Nmin)
Function SDL_imageFilterNormalizeLinear(Src, Dest: PuInt8; Length, Cmin, Cmax, Nmin, Nmax: LongInt):LongInt; 


Const
   SMOOTHING_OFF = 0;
   SMOOTHING_ON = 1;

{ Rotozoom functions }

Function rotozoomSurface(src: PSDL_Surface; angle, zoom: Double; smooth: LongInt):PSDL_Surface; 
Function rotozoomSurfaceXY(src: PSDL_Surface; angle, zoomx, zoomy: Double; smooth: LongInt):PSDL_Surface; 
Procedure rotozoomSurfaceSize(width, height: LongInt; angle, zoom: Double; dstwidth, dstheight: PLongWord); 
Procedure rotozoomSurfaceSizeXY(width, height: LongInt; angle, zoomx, zoomy: Double; dstwidth, dstheight:PLongWord); 

{ Zooming functions }

Function zoomSurface(src: PSDL_Surface; zoomx, zoomy: Double; smooth: LongInt):PSDL_Surface; 
Procedure zoomSurfaceSize(width, height: LongInt; zoomx, zoomy: Double; dstwidth, dstheight: PLongWord); 

{ Shrinking functions }

Function shrinkSurface(src: PSDL_Surface; factorx, factory: LongInt):PSDL_Surface; 

{ Specialized rotation functions }

Function rotateSurface90Degrees(src: PSDL_Surface; numClockwiseTurns: LongInt):PSDL_Surface; 


implementation

//the C isnt ported yet-
//we are using THIS library, not a 'EXTERNAL c' reference.
//because of my changes- both JEDI port and SDL_GPU_ need to be rewritten.

{
THE C!
 

\brief Draw pixel  in currently set color.

  renderer The renderer to draw on.
  x X (horizontal) coordinate of the pixel.
  y Y (vertical) coordinate of the pixel.

\returns Returns 0 on success, -1 on failure.


int pixel(SDL_Renderer *renderer, Sint16 x, Sint16 y)
begin
	return SDL_RenderDrawPoint(renderer, x, y);
end;

/*!
\brief Draw pixel with blending enabled if a<255.

  renderer The renderer to draw on.
  x X (horizontal) coordinate of the pixel.
  y Y (vertical) coordinate of the pixel.
  color The color value of the pixel to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int pixelColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return pixelRGBA(renderer, x, y, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw pixel with blending enabled if a<255.

  renderer The renderer to draw on.
  x X (horizontal) coordinate of the pixel.
  y Y (vertical) coordinate of the pixel.
  r The red color value of the pixel to draw. 
  g The green color value of the pixel to draw.
  b The blue color value of the pixel to draw.
  a The alpha value of the pixel to draw.

\returns Returns 0 on success, -1 on failure.
*/

int pixelRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);
	result |= SDL_RenderDrawPoint(renderer, x, y);
	return result;
end;

/*!
\brief Draw pixel with blending enabled and using alpha weight on color.

  renderer The renderer to draw on.
  x The horizontal coordinate of the pixel.
  y The vertical position of the pixel.
  r The red color value of the pixel to draw. 
  g The green color value of the pixel to draw.
  b The blue color value of the pixel to draw.
  a The alpha value of the pixel to draw.
  weight The weight multiplied into the alpha value of the pixel.

\returns Returns 0 on success, -1 on failure.
*/

int pixelRGBAWeight(SDL_Renderer * renderer, Sint16 x, Sint16 y, Uint8 r, Uint8 g, Uint8 b, Uint8 a, LongWord weight)
begin
	/*
	* /ify Alpha by weight 
	*/
	
	LongWord ax = a;
	ax = ((ax * weight) >> 8);
	if (ax > 255) begin
		a = 255;
	end else begin
		a = (Uint8)(ax & 0x000000ff);
	end;

	return pixelRGBA(renderer, x, y, r, g, b, a);
end;

/* ---- Hline */

/*!
\brief Draw horizontal line in currently set color

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. left) of the line.
  x2 X coordinate of the second point (i.e. right) of the line.
  y Y coordinate of the points of the line.

\returns Returns 0 on success, -1 on failure.
*/

int hline(SDL_Renderer * renderer, Sint16 x1, Sint16 x2, Sint16 y)
begin
	return SDL_RenderDrawLine(renderer, x1, y, x2, y);;
end;


/*!
\brief Draw horizontal line with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. left) of the line.
  x2 X coordinate of the second point (i.e. right) of the line.
  y Y coordinate of the points of the line.
  color The color value of the line to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int hlineColor(SDL_Renderer * renderer, Sint16 x1, Sint16 x2, Sint16 y, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return hlineRGBA(renderer, x1, x2, y, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw horizontal line with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. left) of the line.
  x2 X coordinate of the second point (i.e. right) of the line.
  y Y coordinate of the points of the line.
  r The red value of the line to draw. 
  g The green value of the line to draw. 
  b The blue value of the line to draw. 
  a The alpha value of the line to draw. 

\returns Returns 0 on success, -1 on failure.
*/

int hlineRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 x2, Sint16 y, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);
	result |= SDL_RenderDrawLine(renderer, x1, y, x2, y);
	return result;
end;

/* ---- Vline */

/*!
\brief Draw vertical line in currently set color

  renderer The renderer to draw on.
  x X coordinate of points of the line.
  y1 Y coordinate of the first point (i.e. top) of the line.
  y2 Y coordinate of the second point (i.e. bottom) of the line.

\returns Returns 0 on success, -1 on failure.
*/

int vline(SDL_Renderer * renderer, Sint16 x, Sint16 y1, Sint16 y2)
begin
	return SDL_RenderDrawLine(renderer, x, y1, x, y2);;
end;

/*!
\brief Draw vertical line with blending.

  renderer The renderer to draw on.
  x X coordinate of the points of the line.
  y1 Y coordinate of the first point (i.e. top) of the line.
  y2 Y coordinate of the second point (i.e. bottom) of the line.
  color The color value of the line to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int vlineColor(SDL_Renderer * renderer, Sint16 x, Sint16 y1, Sint16 y2, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return vlineRGBA(renderer, x, y1, y2, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw vertical line with blending.

  renderer The renderer to draw on.
  x X coordinate of the points of the line.
  y1 Y coordinate of the first point (i.e. top) of the line.
  y2 Y coordinate of the second point (i.e. bottom) of the line.
  r The red value of the line to draw. 
  g The green value of the line to draw. 
  b The blue value of the line to draw. 
  a The alpha value of the line to draw. 

\returns Returns 0 on success, -1 on failure.
*/

int vlineRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y1, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);
	result |= SDL_RenderDrawLine(renderer, x, y1, x, y2);
	return result;
end;

/* ---- Rectangle */

/*!
\brief Draw rectangle with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. top right) of the rectangle.
  y1 Y coordinate of the first point (i.e. top right) of the rectangle.
  x2 X coordinate of the second point (i.e. bottom left) of the rectangle.
  y2 Y coordinate of the second point (i.e. bottom left) of the rectangle.
  color The color value of the rectangle to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int rectangleColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return rectangleRGBA(renderer, x1, y1, x2, y2, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw rectangle with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. top right) of the rectangle.
  y1 Y coordinate of the first point (i.e. top right) of the rectangle.
  x2 X coordinate of the second point (i.e. bottom left) of the rectangle.
  y2 Y coordinate of the second point (i.e. bottom left) of the rectangle.
  r The red value of the rectangle to draw. 
  g The green value of the rectangle to draw. 
  b The blue value of the rectangle to draw. 
  a The alpha value of the rectangle to draw. 

\returns Returns 0 on success, -1 on failure.
*/

int rectangleRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result;
	Sint16 tmp;
	SDL_Rect rect;

	/*
	* Test for special cases of straight lines or single point 
	*/
	if (x1 = x2) begin
		if (y1 = y2) begin
			return (pixelRGBA(renderer, x1, y1, r, g, b, a));
		end else begin
			return (vlineRGBA(renderer, x1, y1, y2, r, g, b, a));
		end
	end else begin
		if (y1 = y2) begin
			return (hlineRGBA(renderer, x1, x2, y1, r, g, b, a));
		end;
	end;

	/*
	* Swap x1, x2 if required 
	*/
	if (x1 > x2) begin
		tmp = x1;
		x1 = x2;
		x2 = tmp;
	end;

	/*
	* Swap y1, y2 if required 
	*/
	if (y1 > y2) begin
		tmp = y1;
		y1 = y2;
		y2 = tmp;
	end;

	/* 
	* Create destination rect
	*/	
	rect.x = x1;
	rect.y = y1;
	rect.w = x2 - x1;
	rect.h = y2 - y1;
	
	/*
	* Draw
	*/
	result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);	
	result |= SDL_RenderDrawRect(renderer, &rect);
	return result;
end;

/* ---- Rounded Rectangle */

/*!
\brief Draw rounded-corner rectangle with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. top right) of the rectangle.
  y1 Y coordinate of the first point (i.e. top right) of the rectangle.
  x2 X coordinate of the second point (i.e. bottom left) of the rectangle.
  y2 Y coordinate of the second point (i.e. bottom left) of the rectangle.
  rad The radius of the corner arc.
  color The color value of the rectangle to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int roundedRectangleColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return roundedRectangleRGBA(renderer, x1, y1, x2, y2, rad, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw rounded-corner rectangle with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. top right) of the rectangle.
  y1 Y coordinate of the first point (i.e. top right) of the rectangle.
  x2 X coordinate of the second point (i.e. bottom left) of the rectangle.
  y2 Y coordinate of the second point (i.e. bottom left) of the rectangle.
  rad The radius of the corner arc.
  r The red value of the rectangle to draw. 
  g The green value of the rectangle to draw. 
  b The blue value of the rectangle to draw. 
  a The alpha value of the rectangle to draw. 

\returns Returns 0 on success, -1 on failure.
*/

int roundedRectangleRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result = 0;
	Sint16 tmp;
	Sint16 w, h;
	Sint16 xx1, xx2;
	Sint16 yy1, yy2;
	
	/*
	* Check renderer
	*/
	if (renderer = NULL)
	begin
		return -1;
	end;

	/*
	* Check radius vor valid range
	*/
	if (rad < 0) begin
		return -1;
	end;

	/*
	* Special case - no rounding
	*/
	if (rad <= 1) begin
		return rectangleRGBA(renderer, x1, y1, x2, y2, r, g, b, a);
	end;

	/*
	* Test for special cases of straight lines or single point 
	*/
	if (x1 = x2) begin
		if (y1 = y2) begin
			return (pixelRGBA(renderer, x1, y1, r, g, b, a));
		end else begin
			return (vlineRGBA(renderer, x1, y1, y2, r, g, b, a));
		end;
	end else begin
		if (y1 = y2) begin
			return (hlineRGBA(renderer, x1, x2, y1, r, g, b, a));
		end;
	end;

	/*
	* Swap x1, x2 if required 
	*/
	if (x1 > x2) begin
		tmp = x1;
		x1 = x2;
		x2 = tmp;
	end;

	/*
	* Swap y1, y2 if required 
	*/
	if (y1 > y2) begin
		tmp = y1;
		y1 = y2;
		y2 = tmp;
	end;

	/*
	* Calculate width&height 
	*/
	w = x2 - x1;
	h = y2 - y1;

	/*
	* Maybe adjust radius
	*/
	if ((rad * 2) > w)  
	begin
		rad = w / 2;
	end;
	if ((rad * 2) > h)
	begin
		rad = h / 2;
	end;

	/*
	* Draw corners
	*/
	xx1 = x1 + rad;
	xx2 = x2 - rad;
	yy1 = y1 + rad;
	yy2 = y2 - rad;
	result |= arcRGBA(renderer, xx1, yy1, rad, 180, 270, r, g, b, a);
	result |= arcRGBA(renderer, xx2, yy1, rad, 270, 360, r, g, b, a);
	result |= arcRGBA(renderer, xx1, yy2, rad,  90, 180, r, g, b, a);
	result |= arcRGBA(renderer, xx2, yy2, rad,   0,  90, r, g, b, a);

	/*
	* Draw lines
	*/
	if (xx1 <= xx2) begin
		result |= hlineRGBA(renderer, xx1, xx2, y1, r, g, b, a);
		result |= hlineRGBA(renderer, xx1, xx2, y2, r, g, b, a);
	end;
	if (yy1 <= yy2) begin
		result |= vlineRGBA(renderer, x1, yy1, yy2, r, g, b, a);
		result |= vlineRGBA(renderer, x2, yy1, yy2, r, g, b, a);
	end;

	return result;
end;

/* ---- Rounded Box */

/*!
\brief Draw rounded-corner box (filled rectangle) with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. top right) of the box.
  y1 Y coordinate of the first point (i.e. top right) of the box.
  x2 X coordinate of the second point (i.e. bottom left) of the box.
  y2 Y coordinate of the second point (i.e. bottom left) of the box.
  rad The radius of the corner arcs of the box.
  color The color value of the box to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int roundedBoxColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return roundedBoxRGBA(renderer, x1, y1, x2, y2, rad, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw rounded-corner box (filled rectangle) with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. top right) of the box.
  y1 Y coordinate of the first point (i.e. top right) of the box.
  x2 X coordinate of the second point (i.e. bottom left) of the box.
  y2 Y coordinate of the second point (i.e. bottom left) of the box.
  rad The radius of the corner arcs of the box.
  r The red value of the box to draw. 
  g The green value of the box to draw. 
  b The blue value of the box to draw. 
  a The alpha value of the box to draw. 

\returns Returns 0 on success, -1 on failure.
*/

int roundedBoxRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result;
	Sint16 w, h, r2, tmp;
	Sint16 cx = 0;
	Sint16 cy = rad;
	Sint16 ocx = (Sint16) 0xffff;
	Sint16 ocy = (Sint16) 0xffff;
	Sint16 df = 1 - rad;
	Sint16 d_e = 3;
	Sint16 d_se = -2 * rad + 5;
	Sint16 xpcx, xmcx, xpcy, xmcy;
	Sint16 ypcy, ymcy, ypcx, ymcx;
	Sint16 x, y, dx, dy;

	/* 
	* Check destination renderer 
	*/
	if (renderer = NULL)
	begin
		return -1;
	end;

	/*
	* Check radius vor valid range
	*/
	if (rad < 0) begin
		return -1;
	end;

	/*
	* Special case - no rounding
	*/
	if (rad <= 1) begin
		return boxRGBA(renderer, x1, y1, x2, y2, r, g, b, a);
	end;

	/*
	* Test for special cases of straight lines or single point 
	*/
	if (x1 = x2) begin
		if (y1 = y2) begin
			return (pixelRGBA(renderer, x1, y1, r, g, b, a));
		end else begin
			return (vlineRGBA(renderer, x1, y1, y2, r, g, b, a));
		end;
	end else begin
		if (y1 = y2) begin
			return (hlineRGBA(renderer, x1, x2, y1, r, g, b, a));
		end;
	end;

	/*
	* Swap x1, x2 if required 
	*/
	if (x1 > x2) begin
		tmp = x1;
		x1 = x2;
		x2 = tmp;
	end;

	/*
	* Swap y1, y2 if required 
	*/
	
	if (y1 > y2) begin
		tmp = y1;
		y1 = y2;
		y2 = tmp;
	end;

	/*
	* Calculate width&height 
	*/
	w = x2 - x1 + 1;
	h = y2 - y1 + 1;

	/*
	* Maybe adjust radius
	*/
	r2 = rad + rad;
	if (r2 > w)  
	begin
		rad = w / 2;
		r2 = rad + rad;
	end;
	if (r2 > h)
	begin
		rad = h / 2;
	end;

	/* Setup filled circle drawing for corners */
	x = x1 + rad;
	y = y1 + rad;
	dx = x2 - x1 - rad - rad;
	dy = y2 - y1 - rad - rad;

	/*
	* Set color
	*/
	result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);

	/*
	* Draw corners
	*/
	
	while (cx <= cy) do begin
		xpcx = x + cx;
		xmcx = x - cx;
		xpcy = x + cy;
		xmcy = x - cy;
		if (ocy != cy) begin
			if (cy > 0) begin
				ypcy = y + cy;
				ymcy = y - cy;
				result |= hline(renderer, xmcx, xpcx + dx, ypcy + dy);
				result |= hline(renderer, xmcx, xpcx + dx, ymcy);
			end else begin
				result |= hline(renderer, xmcx, xpcx + dx, y);
			end;
			ocy = cy;
		end;
		if (ocx != cx) begin
			if (cx != cy) begin
				if (cx > 0) begin
					ypcx = y + cx;
					ymcx = y - cx;
					result |= hline(renderer, xmcy, xpcy + dx, ymcx);
					result |= hline(renderer, xmcy, xpcy + dx, ypcx + dy);
				end else begin
					result |= hline(renderer, xmcy, xpcy + dx, y);
				end;
			end;
			ocx = cx;
		end;

		/*
		* Update 
		*/
		if (df < 0) begin
			df += d_e;
			d_e += 2;
			d_se += 2;
		end else begin
			df += d_se;
			d_e += 2;
			d_se += 4;
			cy--;
		end;
		cx++;
		
	 end;

	/* Inside */
	if (dx > 0 && dy > 0) begin
		result |= boxRGBA(renderer, x1, y1 + rad + 1, x2, y2 - rad, r, g, b, a);
	end;

	return (result);
end;

/* ---- Box */

/*!
\brief Draw box (filled rectangle) with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. top right) of the box.
  y1 Y coordinate of the first point (i.e. top right) of the box.
  x2 X coordinate of the second point (i.e. bottom left) of the box.
  y2 Y coordinate of the second point (i.e. bottom left) of the box.
  color The color value of the box to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int boxColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return boxRGBA(renderer, x1, y1, x2, y2, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw box (filled rectangle) with blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. top right) of the box.
  y1 Y coordinate of the first point (i.e. top right) of the box.
  x2 X coordinate of the second point (i.e. bottom left) of the box.
  y2 Y coordinate of the second point (i.e. bottom left) of the box.
  r The red value of the box to draw. 
  g The green value of the box to draw. 
  b The blue value of the box to draw. 
  a The alpha value of the box to draw.

\returns Returns 0 on success, -1 on failure.
*/

int boxRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result;
	Sint16 tmp;
	SDL_Rect rect;

	/*
	* Test for special cases of straight lines or single point 
	*/
	if (x1 = x2) begin
		if (y1 = y2) begin
			return (pixelRGBA(renderer, x1, y1, r, g, b, a));
		end else begin
			return (vlineRGBA(renderer, x1, y1, y2, r, g, b, a));
		end;
	end else begin
		if (y1 = y2) begin
			return (hlineRGBA(renderer, x1, x2, y1, r, g, b, a));
		end;
	end;

	/*
	* Swap x1, x2 if required 
	*/
	if (x1 > x2) begin
		tmp = x1;
		x1 = x2;
		x2 = tmp;
	end;

	/*
	* Swap y1, y2 if required 
	*/
	if (y1 > y2) begin
		tmp = y1;
		y1 = y2;
		y2 = tmp;
	end;

	/* 
	* Create destination rect
	*/	
	rect.x = x1;
	rect.y = y1;
	rect.w = x2 - x1 + 1;
	rect.h = y2 - y1 + 1;
	
	/*
	* Draw
	*/
	result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);	
	result |= SDL_RenderFillRect(renderer, &rect);
	return result;
end;

/* ----- Line */

/*!
\brief Draw line with alpha blending using the currently set color.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the line.
  y1 Y coordinate of the first point of the line.
  x2 X coordinate of the second point of the line.
  y2 Y coordinate of the second point of the line.

\returns Returns 0 on success, -1 on failure.
*/

int line(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2)
begin
	/*
	* Draw
	*/
	return SDL_RenderDrawLine(renderer, x1, y1, x2, y2);
end;

/*!
\brief Draw line with alpha blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the line.
  y1 Y coordinate of the first point of the line.
  x2 X coordinate of the second point of the line.
  y2 Y coordinate of the seond point of the line.
  color The color value of the line to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int lineColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return lineRGBA(renderer, x1, y1, x2, y2, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw line with alpha blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the line.
  y1 Y coordinate of the first point of the line.
  x2 X coordinate of the second point of the line.
  y2 Y coordinate of the second point of the line.
  r The red value of the line to draw. 
  g The green value of the line to draw. 
  b The blue value of the line to draw. 
  a The alpha value of the line to draw.

\returns Returns 0 on success, -1 on failure.
*/

int lineRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	/*
	* Draw
	*/
	int result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);	
	result |= SDL_RenderDrawLine(renderer, x1, y1, x2, y2);
	return result;
end;

/* ---- AA Line */

const
	AAlevels=256;
	AAbits=8;

/*!
\brief Internal function to draw anti-aliased line with alpha blending and endpoint control.

This implementation of the Wu antialiasing code is based on Mike Abrash's
DDJ article which was reprinted as Chapter 42 of his Graphics Programming
Black Book, but has been optimized to work with SDL and utilizes 32-bit
fixed-point arithmetic by A. Schiffler. The endpoint control allows the
supression to draw the last pixel -useful for rendering continous aa-lines
with alpha<255.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the aa-line.
  y1 Y coordinate of the first point of the aa-line.
  x2 X coordinate of the second point of the aa-line.
  y2 Y coordinate of the second point of the aa-line.
  r The red value of the aa-line to draw. 
  g The green value of the aa-line to draw. 
  b The blue value of the aa-line to draw. 
  a The alpha value of the aa-line to draw.
  draw_endpoint Flag indicating if the endpoint should be drawn; draw if non-zero.

\returns Returns 0 on success, -1 on failure.
*/

int _aalineRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a, int draw_endpoint)
begin
	LongInt xx0, yy0, xx1, yy1;
	int result;
	LongWord intshift, erracc, erradj;
	LongWord erracctmp, wgt, wgtcompmask;
	int dx, dy, tmp, xdir, y0p1, x0pxdir;

	/*
	* Keep on working with 32bit numbers 
	*/
	xx0 = x1;
	yy0 = y1;
	xx1 = x2;
	yy1 = y2;

	/*
	* Reorder points to make dy positive 
	*/
	if (yy0 > yy1) begin
		tmp = yy0;
		yy0 = yy1;
		yy1 = tmp;
		tmp = xx0;
		xx0 = xx1;
		xx1 = tmp;
	end;

	/*
	* Calculate distance 
	*/
	dx = xx1 - xx0;
	dy = yy1 - yy0;

	/*
	* Adjust for negative dx and set xdir 
	*/
	if (dx >= 0) begin
		xdir = 1;
	end else begin
		xdir = -1;
		dx = (-dx);
	end;
	
	/*
	* Check for special cases 
	*/
	if (dx = 0) begin
		/*
		* Vertical line 
		*/
		if (draw_endpoint)
		begin
			return (vlineRGBA(renderer, x1, y1, y2, r, g, b, a));
		end else begin
			if (dy > 0) begin
				return (vlineRGBA(renderer, x1, yy0, yy0+dy, r, g, b, a));
			end else begin
				return (pixelRGBA(renderer, x1, y1, r, g, b, a));
			end;
		end;
	end else if (dy = 0) begin
		/*
		* Horizontal line 
		*/
		if (draw_endpoint)
		begin
			return (hlineRGBA(renderer, x1, x2, y1, r, g, b, a));
		end else begin
			if (dx > 0) begin
				return (hlineRGBA(renderer, xx0, xx0+(xdir*dx), y1, r, g, b, a));
			end else begin
				return (pixelRGBA(renderer, x1, y1, r, g, b, a));
			end;
		end;
	end else if ((dx = dy) and (draw_endpoint=true)) begin
		/*
		* Diagonal line (with endpoint)
		*/
		return (lineRGBA(renderer, x1, y1, x2, y2,  r, g, b, a));
	end;


	/*
	* Line is not horizontal, vertical or diagonal (with endpoint)
	*/
	result = 0;

	/*
	* Zero accumulator 
	*/
	erracc = 0;

	/*
	* # of bits by which to shift erracc to get intensity level 
	*/
	intshift = 32 - AAbits;

	/*
	* Mask used to flip all bits in an intensity weighting 
	*/
	wgtcompmask = AAlevels - 1;

	/*
	* Draw the initial pixel in the foreground color 
	*/
	result |= pixelRGBA(renderer, x1, y1, r, g, b, a);

	/*
	* x-major or y-major? 
	*/
	if (dy > dx) begin

		/*
		* y-major.  Calculate 16-bit fixed point fractional part of a pixel that
		* X advances every time Y advances 1 pixel, truncating the result so that
		* we won't overrun the endpoint along the X axis 
		*/
		/*
		* Not-so-portable version: erradj = ((Uint64)dx << 32) / (Uint64)dy; 
		*/
		erradj = ((dx shl 16) / dy) shl 16;

		/*
		* draw all pixels other than the first and last 
		*/
		x0pxdir = xx0 + xdir;
		while (--dy) begin
			erracctmp = erracc;
			erracc += erradj;
			if (erracc <= erracctmp) begin
				/*
				* rollover in error accumulator, x coord advances 
				*/
				xx0 = x0pxdir;
				x0pxdir += xdir;
			end;
			yy0++;		/* y-major so always advance Y */

			/*
			* the AAbits most significant bits of erracc give us the intensity
			* weighting for this pixel, and the complement of the weighting for
			* the paired pixel. 
			*/
			wgt = (erracc >> intshift) & 255;
			result |= pixelRGBAWeight (renderer, xx0, yy0, r, g, b, a, 255 - wgt);
			result |= pixelRGBAWeight (renderer, x0pxdir, yy0, r, g, b, a, wgt);
		end;

	end else begin

		/*
		* x-major line.  Calculate 16-bit fixed-point fractional part of a pixel
		* that Y advances each time X advances 1 pixel, truncating the result so
		* that we won't overrun the endpoint along the X axis. 
		*/
		/*
		* Not-so-portable version: erradj = ((Uint64)dy << 32) / (Uint64)dx; 
		*/
		erradj = ((dy shl 16) / dx) shl 16;

		/*
		* draw all pixels other than the first and last 
		*/
		y0p1 = yy0 + 1;
		while (--dx) begin

			erracctmp = erracc;
			erracc += erradj;
			if (erracc <= erracctmp) begin
				/*
				* Accumulator turned over, advance y 
				*/
				yy0 = y0p1;
				y0p1++;
			end;
			xx0 += xdir;	/* x-major so always advance X */
			/*
			* the AAbits most significant bits of erracc give us the intensity
			* weighting for this pixel, and the complement of the weighting for
			* the paired pixel. 
			*/
			wgt = (erracc >> intshift) & 255;
			result |= pixelRGBAWeight (renderer, xx0, yy0, r, g, b, a, 255 - wgt);
			result |= pixelRGBAWeight (renderer, xx0, y0p1, r, g, b, a, wgt);
		end;
	end;

	/*
	* Do we have to draw the endpoint 
	*/
	if (draw_endpoint=true) begin
		/*
		* Draw final pixel, always exactly intersected by the line and doesn't
		* need to be weighted. 
		*/
		result |= pixelRGBA (renderer, x2, y2, r, g, b, a);
	end;

	return (result);
end;

/*!
\brief Draw anti-aliased line with alpha blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the aa-line.
  y1 Y coordinate of the first point of the aa-line.
  x2 X coordinate of the second point of the aa-line.
  y2 Y coordinate of the second point of the aa-line.
  color The color value of the aa-line to draw (0xRRGGBBAA).

\returns Returns 0 on success, -1 on failure.
*/

int aalineColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return _aalineRGBA(renderer, x1, y1, x2, y2, c[0], c[1], c[2], c[3], 1);
end;

/*!
\brief Draw anti-aliased line with alpha blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the aa-line.
  y1 Y coordinate of the first point of the aa-line.
  x2 X coordinate of the second point of the aa-line.
  y2 Y coordinate of the second point of the aa-line.
  r The red value of the aa-line to draw. 
  g The green value of the aa-line to draw. 
  b The blue value of the aa-line to draw. 
  a The alpha value of the aa-line to draw.

\returns Returns 0 on success, -1 on failure.
*/

int aalineRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	return _aalineRGBA(renderer, x1, y1, x2, y2, r, g, b, a, 1);
end;

/* ----- Circle */

/*!
\brief Draw circle with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the circle.
  y Y coordinate of the center of the circle.
  rad Radius in pixels of the circle.
  color The color value of the circle to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int circleColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return ellipseRGBA(renderer, x, y, rad, rad, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw circle with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the circle.
  y Y coordinate of the center of the circle.
  rad Radius in pixels of the circle.
  r The red value of the circle to draw. 
  g The green value of the circle to draw. 
  b The blue value of the circle to draw. 
  a The alpha value of the circle to draw.

\returns Returns 0 on success, -1 on failure.
*/

int circleRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	return ellipseRGBA(renderer, x, y, rad, rad, r, g, b, a);
end;

/* ----- Arc */

/*!
\brief Arc with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the arc.
  y Y coordinate of the center of the arc.
  rad Radius in pixels of the arc.
  start Starting radius in degrees of the arc. 0 degrees is down, increasing counterclockwise.
  end Ending radius in degrees of the arc. 0 degrees is down, increasing counterclockwise.
  color The color value of the arc to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int arcColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return arcRGBA(renderer, x, y, rad, start, end, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Arc with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the arc.
  y Y coordinate of the center of the arc.
  rad Radius in pixels of the arc.
  start Starting radius in degrees of the arc. 0 degrees is down, increasing counterclockwise.
  end Ending radius in degrees of the arc. 0 degrees is down, increasing counterclockwise.
  r The red value of the arc to draw. 
  g The green value of the arc to draw. 
  b The blue value of the arc to draw. 
  a The alpha value of the arc to draw.

\returns Returns 0 on success, -1 on failure.
*/

/* TODO: rewrite algorithm; arc endpoints are not always drawn */

int arcRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result;
	Sint16 cx = 0;
	Sint16 cy = rad;
	Sint16 df = 1 - rad;
	Sint16 d_e = 3;
	Sint16 d_se = -2 * rad + 5;
	Sint16 xpcx, xmcx, xpcy, xmcy;
	Sint16 ypcy, ymcy, ypcx, ymcx;
	Uint8 drawoct;
	int startoct, endoct, oct, stopval_start = 0, stopval_end = 0;
	double dstart, dend, temp = 0.;

	/*
	* Sanity check radius 
	*/
	if (rad < 0) begin
		return (-1);
	end;

	/*
	* Special case for rad=0 - draw a point 
	*/
	if (rad = 0) begin
		return (pixelRGBA(renderer, x, y, r, g, b, a));
	end;

	/*
	 Octant labeling
	      
	  \ 5 | 6 /
	   \  |  /
	  4 \ | / 7
	     \|/
	------+------ +x
	     /|\
	  3 / | \ 0
	   /  |  \
	  / 2 | 1 \
	      +y

	 Initially reset bitmask to 0x00000000
	 the set whether or not to keep drawing a given octant.
	 For example: 0x00111100 means we're drawing in octants 2-5
	*/
	
	drawoct = 0; 

	/*
	* Fixup angles
	*/
	start mod= 360;
	end mod= 360;
	
	/* 0 <= start & end < 360; note that sometimes start > end - if so, arc goes back through 0. */
	while (start < 0) start += 360;
	while (end < 0) end += 360;
	
	start mod= 360;
	end mod= 360;

	/* now, we find which octants we're drawing in. */
	startoct = start / 45;
	endoct = end / 45;
	oct = startoct - 1;

	/* stopval_start, stopval_end; what values of cx to stop at. */
	while (oct <> endoct) do begin
		oct = (oct + 1) mod 8;

		if (oct = startoct) begin
			/* need to compute stopval_start for this octant.  Look at picture above if this is unclear */
			dstart = (double)start;
			switch (oct) 
			begin
			case 0:
			case 3:
				temp = sin(dstart * M_PI / 180.);
				break;
			case 1:
			case 6:
				temp = cos(dstart * M_PI / 180.);
				break;
			case 2:
			case 5:
				temp = -cos(dstart * M_PI / 180.);
				break;
			case 4:
			case 7:
				temp = -sin(dstart * M_PI / 180.);
				break;
			end;
			temp *= rad;
			stopval_start = (int)temp;

			/* 
			This isnt arbitrary, but requires graph paper to explain well.
			The basic idea is that were always changing drawoct after we draw, so we
			stop immediately after we render the last sensible pixel at x = (temp).
			and whether to draw in this octant initially
			*/
			
			if (oct mod 2) drawoct |= (1 shl oct);			/* this is basically like saying drawoct[oct] = true, if drawoct were a bool array */
			else		 drawoct &= 255 - (1 shl oct);	/* this is basically like saying drawoct[oct] = false */
		end;
		if (oct = endoct) begin
			/* need to compute stopval_end for this octant */
			dend = (double)end;
			switch (oct)
			begin
			case 0:
			case 3:
				temp = sin(dend * M_PI / 180);
				break;
			case 1:
			case 6:
				temp = cos(dend * M_PI / 180);
				break;
			case 2:
			case 5:
				temp = -cos(dend * M_PI / 180);
				break;
			case 4:
			case 7:
				temp = -sin(dend * M_PI / 180);
				break;
			end;
			temp *= rad;
			stopval_end = (int)temp;

			/* and whether to draw in this octant initially */
			if (startoct = endoct)	begin
				/* note:      we start drawing, stop, then start again in this case */
				/* otherwise: we only draw in this octant, so initialize it to false, it will get set back to true */
				if (start > end) begin
					/* unfortunately, if we're in the same octant and need to draw over the whole circle, */
					/* we need to set the rest to true, because the while loop will end at the bottom. */
					drawoct = 255;
				end else begin
					drawoct &= 255 - (1 << oct);
				end;
			end; 
			else if ((oct mod 2) 
			 	drawoct &= 255 - (1 shl oct));
			else
			 	drawoct |= (1 shl oct);
		end else if (oct <> startoct) { /* already verified that it's != endoct */
			drawoct |= (1 shl oct); /* draw this entire segment */
		end;
	end;

	/* so now we have what octants to draw and when to draw them. all that's left is the actual raster code. */

	/*
	* Set color 
	*/
	result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);

	/*
	* Draw arc 
	*/
	while (cx <= cy) do begin
		ypcy = y + cy;
		ymcy = y - cy;
		if (cx > 0) begin
			xpcx = x + cx;
			xmcx = x - cx;

			/* always check if we're drawing a certain octant before adding a pixel to that octant. */
			if (drawoct & 4)  result |= pixel(renderer, xmcx, ypcy);
			if (drawoct & 2)  result |= pixel(renderer, xpcx, ypcy);
			if (drawoct & 32) result |= pixel(renderer, xmcx, ymcy);
			if (drawoct & 64) result |= pixel(renderer, xpcx, ymcy);
		end else begin
			if (drawoct & 96) result |= pixel(renderer, x, ymcy);
			if (drawoct & 6)  result |= pixel(renderer, x, ypcy);
		end;

		xpcy = x + cy;
		xmcy = x - cy;
		if (cx > 0 && cx != cy) begin
			ypcx = y + cx;
			ymcx = y - cx;
			if (drawoct & 8)   result |= pixel(renderer, xmcy, ypcx);
			if (drawoct & 1)   result |= pixel(renderer, xpcy, ypcx);
			if (drawoct & 16)  result |= pixel(renderer, xmcy, ymcx);
			if (drawoct & 128) result |= pixel(renderer, xpcy, ymcx);
		end else if (cx = 0) begin
			if (drawoct & 24)  result |= pixel(renderer, xmcy, y);
			if (drawoct & 129) result |= pixel(renderer, xpcy, y);
		end;

		/*
		* Update whether were drawing an octant
		*/
		if (stopval_start = cx) begin
			/* works like an on-off switch. */  
			/* This is just in case start & end are in the same octant. */
			if (drawoct & (1 shl startoct)) 
			 	drawoct &= 255 - (1 shl startoct);		
			else
			 	drawoct |= (1 shl startoct);
		end;
		if (stopval_end = cx) begin
			if (drawoct & (1 shl endoct)) 
			 	drawoct &= 255 - (1 << endoct);
			else
				drawoct |= (1 shl endoct);
		end;

		/*
		* Update pixels
		*/
		if (df < 0) begin
			df += d_e;
			d_e += 2;
			d_se += 2;
		end else begin
			df += d_se;
			d_e += 2;
			d_se += 4;
			cy--;
		end;
		cx++;
	end;

	return (result);
end;

/* ----- AA Circle */

/*!
\brief Draw anti-aliased circle with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the aa-circle.
  y Y coordinate of the center of the aa-circle.
  rad Radius in pixels of the aa-circle.
  color The color value of the aa-circle to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int aacircleColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return aaellipseRGBA(renderer, x, y, rad, rad, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw anti-aliased circle with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the aa-circle.
  y Y coordinate of the center of the aa-circle.
  rad Radius in pixels of the aa-circle.
  r The red value of the aa-circle to draw. 
  g The green value of the aa-circle to draw. 
  b The blue value of the aa-circle to draw. 
  a The alpha value of the aa-circle to draw.

\returns Returns 0 on success, -1 on failure.
*/

int aacircleRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	/*
	* Draw 
	*/
	return aaellipseRGBA(renderer, x, y, rad, rad, r, g, b, a);
end;

/* ----- Ellipse */

/*!
\brief Internal function to draw pixels or lines in 4 quadrants.

  renderer The renderer to draw on.
  x X coordinate of the center of the quadrant.
  y Y coordinate of the center of the quadrant.
  dx X offset in pixels of the corners of the quadrant.
  dy Y offset in pixels of the corners of the quadrant.
  f Flag indicating if the quadrant should be filled (1) or not (0).

\returns Returns 0 on success, -1 on failure.
*/

int _drawQuadrants(SDL_Renderer * renderer,  Sint16 x, Sint16 y, Sint16 dx, Sint16 dy, LongInt f)
begin
	int result = 0;
	Sint16 xpdx, xmdx;
	Sint16 ypdy, ymdy;

	if (dx = 0) begin
		if (dy = 0) begin
			result |= pixel(renderer, x, y);
		end else begin
			ypdy = y + dy;
			ymdy = y - dy;
			if (f) begin
				result |= vline(renderer, x, ymdy, ypdy);
			end else begin
				result |= pixel(renderer, x, ypdy);
				result |= pixel(renderer, x, ymdy);
			end;
		end;
	end else begin	
		xpdx = x + dx;
		xmdx = x - dx;
		ypdy = y + dy;
		ymdy = y - dy;
		if (f) begin
				result |= vline(renderer, xpdx, ymdy, ypdy);
				result |= vline(renderer, xmdx, ymdy, ypdy);
		end else begin
				result |= pixel(renderer, xpdx, ypdy);
				result |= pixel(renderer, xmdx, ypdy);
				result |= pixel(renderer, xpdx, ymdy);
				result |= pixel(renderer, xmdx, ymdy);
		end;
	end;

	return result;
end;

/*!
\brief Internal function to draw ellipse or filled ellipse with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the ellipse.
  y Y coordinate of the center of the ellipse.
  rx Horizontal radius in pixels of the ellipse.
  ry Vertical radius in pixels of the ellipse.
  r The red value of the ellipse to draw. 
  g The green value of the ellipse to draw. 
  b The blue value of the ellipse to draw. 
  a The alpha value of the ellipse to draw.
  f Flag indicating if the ellipse should be filled (1) or not (0).

\returns Returns 0 on success, -1 on failure.
*/

const 
	DEFAULT_ELLIPSE_OVERSCAN=4;
	
int _ellipseRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a, LongInt f)
begin
	int result;
	LongInt rxi, ryi;
	LongInt rx2, ry2, rx22, ry22; 
    LongInt error;
    LongInt curX, curY, curXp1, curYm1;
	LongInt scrX, scrY, oldX, oldY;
    LongInt deltaX, deltaY;
	LongInt ellipseOverscan;

	/*
	* Sanity check radii 
	*/
	if ((rx < 0) or (ry < 0)) begin
		return (-1);
	end;

	/*
	* Set color
	*/
	result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);

	/*
	* Special cases for rx=0 and/or ry=0: draw a hline/vline/pixel 
	*/
	if (rx = 0) begin
		if (ry = 0) begin
			return (pixel(renderer, x, y));
		end else begin
			return (vline(renderer, x, y - ry, y + ry));
		end;
	end else begin
		if (ry = 0) begin
			return (hline(renderer, x - rx, x + rx, y));
		end;
	end;
	
	/*
 	 * Adjust overscan 
	 */
	rxi = rx;
	ryi = ry;
	if (rxi >= 512 or ryi >= 512)
	
		ellipseOverscan = DEFAULT_ELLIPSE_OVERSCAN / 4;
	 
	else if (rxi >= 256 or ryi >= 256)
	
		ellipseOverscan = DEFAULT_ELLIPSE_OVERSCAN / 2;
	
	else
	
		ellipseOverscan = DEFAULT_ELLIPSE_OVERSCAN / 1;
	

	/*
	 * Top/bottom center points.
	 */
	oldX = scrX = 0;
	oldY = scrY = ryi;
	result |= _drawQuadrants(renderer, x, y, 0, ry, f);

	/* Midpoint ellipse algorithm with overdraw */
	rxi *= ellipseOverscan;
	ryi *= ellipseOverscan;
	rx2 = rxi * rxi;
	rx22 = rx2 + rx2;
    ry2 = ryi * ryi;
	ry22 = ry2 + ry2;
    curX = 0;
    curY = ryi;
    deltaX = 0;
    deltaY = rx22 * curY;
 
	/* Points in segment 1 */ 
    error = ry2 - rx2 * ryi + rx2 / 4;
    while (deltaX <= deltaY) do begin
    
          curX++;
          deltaX += ry22;
 
          error +=  deltaX + ry2; 
          if (error >= 0) then begin
          
               curY--;
               deltaY -= rx22; 
               error -= deltaY;
          end;

		  scrX = curX / ellipseOverscan;
		  scrY = curY / ellipseOverscan;
		  if ((scrX != oldX and scrY = oldY) or (scrX != oldX && scrY != oldY)) {
			result |= _drawQuadrants(renderer, x, y, scrX, scrY, f);
			oldX = scrX;
			oldY = scrY;
		  end;
    end;

	/* Points in segment 2 */
	if (curY > 0) 
	begin
		curXp1 = curX + 1;
		curYm1 = curY - 1;
		error = ry2 * curX * curXp1 + ((ry2 + 3) / 4) + rx2 * curYm1 * curYm1 - rx2 * ry2;
		while (curY > 0) do begin
		
			curY--;
			deltaY -= rx22;

			error += rx2;
			error -= deltaY;
 
			if (error <= 0) 
			begin
               curX++;
               deltaX += ry22;
               error += deltaX;
			end;

		    scrX = curX / ellipseOverscan;
		    scrY = curY / ellipseOverscan;
		    if ((scrX <> oldX and scrY = oldY) or (scrX <> oldX and scrY <> oldY)) begin
				oldY--;
				for (;oldY >= scrY; oldY--) begin
					result |= _drawQuadrants(renderer, x, y, scrX, oldY, f);
					/* prevent overdraw */
					if (f) begin
						oldY = scrY - 1;
					end;
				end;
  				oldX = scrX;
				oldY = scrY;
		    end;		
		end;

		/* Remaining points in vertical */
		if (<>f) begin
			oldY--;
			for (;oldY >= 0; oldY--) begin
				result |= _drawQuadrants(renderer, x, y, scrX, oldY, f);
			end;
		end;
	end;

	return (result);
end;

/*!
\brief Draw ellipse with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the ellipse.
  y Y coordinate of the center of the ellipse.
  rx Horizontal radius in pixels of the ellipse.
  ry Vertical radius in pixels of the ellipse.
  color The color value of the ellipse to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int ellipseColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return _ellipseRGBA(renderer, x, y, rx, ry, c[0], c[1], c[2], c[3], 0);
end;

/*!
\brief Draw ellipse with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the ellipse.
  y Y coordinate of the center of the ellipse.
  rx Horizontal radius in pixels of the ellipse.
  ry Vertical radius in pixels of the ellipse.
  r The red value of the ellipse to draw. 
  g The green value of the ellipse to draw. 
  b The blue value of the ellipse to draw. 
  a The alpha value of the ellipse to draw.

\returns Returns 0 on success, -1 on failure.
*/

int ellipseRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	return _ellipseRGBA(renderer, x, y, rx, ry, r, g, b, a, 0);
end;

/* ----- Filled Circle */

/*!
\brief Draw filled circle with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the filled circle.
  y Y coordinate of the center of the filled circle.
  rad Radius in pixels of the filled circle.
  color The color value of the filled circle to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int filledCircleColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return filledEllipseRGBA(renderer, x, y, rad, rad, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw filled circle with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the filled circle.
  y Y coordinate of the center of the filled circle.
  rad Radius in pixels of the filled circle.
  r The red value of the filled circle to draw. 
  g The green value of the filled circle to draw. 
  b The blue value of the filled circle to draw. 
  a The alpha value of the filled circle to draw.

\returns Returns 0 on success, -1 on failure.
*/

int filledCircleRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	return _ellipseRGBA(renderer, x, y, rad, rad, r, g ,b, a, 1);
end;

}

//code is better left optimized by the compiler. 
//DO IT IN PASCAL instead.

function lrint(f:float):LongInt; 
//Float to Long -Rounded
//"Bankers method" is FPC default

begin
	lrint:=round(f);
end;

{
/* ----- AA Ellipse */


/*!
\brief Draw anti-aliased ellipse with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the aa-ellipse.
  y Y coordinate of the center of the aa-ellipse.
  rx Horizontal radius in pixels of the aa-ellipse.
  ry Vertical radius in pixels of the aa-ellipse.
  color The color value of the aa-ellipse to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int aaellipseColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return aaellipseRGBA(renderer, x, y, rx, ry, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw anti-aliased ellipse with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the aa-ellipse.
  y Y coordinate of the center of the aa-ellipse.
  rx Horizontal radius in pixels of the aa-ellipse.
  ry Vertical radius in pixels of the aa-ellipse.
  r The red value of the aa-ellipse to draw. 
  g The green value of the aa-ellipse to draw. 
  b The blue value of the aa-ellipse to draw. 
  a The alpha value of the aa-ellipse to draw.

\returns Returns 0 on success, -1 on failure.
*/

int aaellipseRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result;
	int i;
	int a2, b2, ds, dt, dxt, t, s, d;
	Sint16 xp, yp, xs, ys, dyt, od, xx, yy, xc2, yc2;
	float cp;
	double sab;
	Uint8 weight, iweight;

	/*
	* Sanity check radii 
	*/
	if ((rx < 0) || (ry < 0)) begin
		return (-1);
	end;

	/*
	* Special cases for rx=0 and/or ry=0: draw a hline/vline/pixel 
	*/
	if (rx = 0) begin
		if (ry = 0) begin
			return (pixelRGBA(renderer, x, y, r, g, b, a));
		end else begin
			return (vlineRGBA(renderer, x, y - ry, y + ry, r, g, b, a));
		end;
	end; else begin
		if (ry = 0) begin
			return (hlineRGBA(renderer, x - rx, x + rx, y, r, g, b, a));
		end;
	end;

	/* Variable setup */
	a2 = rx * rx;
	b2 = ry * ry;

	ds = 2 * a2;
	dt = 2 * b2;

	xc2 = 2 * x;
	yc2 = 2 * y;

	sab = sqrt((a2 + b2));
	od = lrint(sab*0.01) + 1; // introduce some overdraw 
	dxt =lrint(a2 / sab) + od;

	t = 0;
	s = -2 * a2 * ry;
	d = 0;

	xp = x;
	yp = y - ry;

	/* Draw */
	result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);

	/* "End points" */
	result |= pixelRGBA(renderer, xp, yp, r, g, b, a);
	result |= pixelRGBA(renderer, xc2 - xp, yp, r, g, b, a);
	result |= pixelRGBA(renderer, xp, yc2 - yp, r, g, b, a);
	result |= pixelRGBA(renderer, xc2 - xp, yc2 - yp, r, g, b, a);

	for (i = 1; i <= dxt; i++) begin
		xp--;
		d += t - b2;

		if (d >= 0)
			ys = yp - 1;
		else if ((d - s - a2) > 0) begin
			if ((2 * d - s - a2) >= 0)
				ys = yp + 1;
			else begin
				ys = yp;
				yp++;
				d -= s + a2;
				s += ds;
			end;
		end else begin
			yp++;
			ys = yp + 1;
			d -= s + a2;
			s += ds;
		end;

		t -= dt;

		/* Calculate alpha */
		if (s != 0) begin
			cp = (float) abs(d) / (float) abs(s);
			if (cp > 1.0) begin
				cp = 1.0;
			end;
		end else begin
			cp = 1.0;
		end;

		/* Calculate weights */
		weight = (Uint8) (cp * 255);
		iweight = 255 - weight;

		/* Upper half */
		xx = xc2 - xp;
		result |= pixelRGBAWeight(renderer, xp, yp, r, g, b, a, iweight);
		result |= pixelRGBAWeight(renderer, xx, yp, r, g, b, a, iweight);

		result |= pixelRGBAWeight(renderer, xp, ys, r, g, b, a, weight);
		result |= pixelRGBAWeight(renderer, xx, ys, r, g, b, a, weight);

		/* Lower half */
		yy = yc2 - yp;
		result |= pixelRGBAWeight(renderer, xp, yy, r, g, b, a, iweight);
		result |= pixelRGBAWeight(renderer, xx, yy, r, g, b, a, iweight);

		yy = yc2 - ys;
		result |= pixelRGBAWeight(renderer, xp, yy, r, g, b, a, weight);
		result |= pixelRGBAWeight(renderer, xx, yy, r, g, b, a, weight);
	end;

	// Replaces original approximation code dyt := abs(yp - yc); 
	dyt = lrint(b2 / sab ) + od;    

	for (i = 1; i <= dyt; i++) begin
		yp++;
		d -= s + a2;

		if (d <= 0)
			xs = xp + 1;
		else if ((d + t - b2) < 0) begin
			if ((2 * d + t - b2) <= 0)
				xs = xp - 1;
			else begin
				xs = xp;
				xp--;
				d += t - b2;
				t -= dt;
			end;
		end else begin
			xp--;
			xs = xp - 1;
			d += t - b2;
			t -= dt;
		end;

		s += ds;

		/* Calculate alpha */
		if (t != 0) begin
			cp = (float) abs(d) / (float) abs(t);
			if (cp > 1.0) begin
				cp = 1.0;
			end;
		end else begin
			cp = 1.0;
		end;

		/* Calculate weight */
		weight = (Uint8) (cp * 255);
		iweight = 255 - weight;

		/* Left half */
		xx = xc2 - xp;
		yy = yc2 - yp;
		result |= pixelRGBAWeight(renderer, xp, yp, r, g, b, a, iweight);
		result |= pixelRGBAWeight(renderer, xx, yp, r, g, b, a, iweight);

		result |= pixelRGBAWeight(renderer, xp, yy, r, g, b, a, iweight);
		result |= pixelRGBAWeight(renderer, xx, yy, r, g, b, a, iweight);

		/* Right half */
		xx = xc2 - xs;
		result |= pixelRGBAWeight(renderer, xs, yp, r, g, b, a, weight);
		result |= pixelRGBAWeight(renderer, xx, yp, r, g, b, a, weight);

		result |= pixelRGBAWeight(renderer, xs, yy, r, g, b, a, weight);
		result |= pixelRGBAWeight(renderer, xx, yy, r, g, b, a, weight);		
	end;

	return (result);
end;

/* ---- Filled Ellipse */

/*!
\brief Draw filled ellipse with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the filled ellipse.
  y Y coordinate of the center of the filled ellipse.
  rx Horizontal radius in pixels of the filled ellipse.
  ry Vertical radius in pixels of the filled ellipse.
  color The color value of the filled ellipse to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int filledEllipseColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return _ellipseRGBA(renderer, x, y, rx, ry, c[0], c[1], c[2], c[3], 1);
end;

/*!
\brief Draw filled ellipse with blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the filled ellipse.
  y Y coordinate of the center of the filled ellipse.
  rx Horizontal radius in pixels of the filled ellipse.
  ry Vertical radius in pixels of the filled ellipse.
  r The red value of the filled ellipse to draw. 
  g The green value of the filled ellipse to draw. 
  b The blue value of the filled ellipse to draw. 
  a The alpha value of the filled ellipse to draw.

\returns Returns 0 on success, -1 on failure.
*/

int filledEllipseRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rx, Sint16 ry, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	return _ellipseRGBA(renderer, x, y, rx, ry, r, g, b, a, 1);
end;

/* ----- Pie */

/*!
\brief Internal float (low-speed) pie-calc implementation by drawing polygons.

Note: Determines vertex array and uses polygon or filledPolygon drawing routines to render.

  renderer The renderer to draw on.
  x X coordinate of the center of the pie.
  y Y coordinate of the center of the pie.
  rad Radius in pixels of the pie.
  start Starting radius in degrees of the pie.
  end Ending radius in degrees of the pie.
  r The red value of the pie to draw. 
  g The green value of the pie to draw. 
  b The blue value of the pie to draw. 
  a The alpha value of the pie to draw.
  filled Flag indicating if the pie should be filled (=1) or not (=0).

\returns Returns 0 on success, -1 on failure.
*/

/* TODO: rewrite algorithm; pie is not always accurate */

int _pieRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end,  Uint8 r, Uint8 g, Uint8 b, Uint8 a, Uint8 filled)
begin
	int result;
	double angle, start_angle, end_angle;
	double deltaAngle;
	double dr;
	int numpoints, i;
	Sint16 *vx, *vy;

	/*
	* Sanity check radii 
	*/
	if (rad < 0) begin
		return (-1);
	end;

	/*
	* Fixup angles
	*/
	start = start mod 360;
	end = end mod 360;

	/*
	* Special case for rad=0 - draw a point 
	*/
	if (rad = 0) begin
		return (pixelRGBA(renderer, x, y, r, g, b, a));
	end;

	/*
	* Variable setup 
	*/
	dr = (double) rad;
	deltaAngle = 3.0 / dr;
	start_angle = (double) start *(2.0 * M_PI / 360.0);
	end_angle = (double) end *(2.0 * M_PI / 360.0);
	if (start > end) begin
		end_angle += (2.0 * M_PI);
	end;

	/* We will always have at least 2 points */
	numpoints = 2;

	/* Count points (rather than calculating it) */
	angle = start_angle;
	while (angle < end_angle) begin
		angle += deltaAngle;
		numpoints++;
	end;

	/* Allocate combined vertex array */
	vx = vy = (Sint16 *) malloc(2 * sizeof(Uint16) * numpoints);
	if (vx = NULL) begin
		return (-1);
	end;

	/* Update point to start of vy */
	vy += numpoints;

	/* Center */
	vx[0] = x;
	vy[0] = y;

	/* First vertex */
	angle = start_angle;
	vx[1] = x + (int) (dr * cos(angle));
	vy[1] = y + (int) (dr * sin(angle));

	if (numpoints<3)
	begin
		result = lineRGBA(renderer, vx[0], vy[0], vx[1], vy[1], r, g, b, a);
	end;
	else begin
	
		/* Calculate other vertices */
		i = 2;
		angle = start_angle;
		while (angle < end_angle) begin
			angle += deltaAngle;
			if (angle>end_angle)
			begin
				angle = end_angle;
			end;
			vx[i] = x + (int) (dr * cos(angle));
			vy[i] = y + (int) (dr * sin(angle));
			i++;
		end;

		/* Draw */
		if (filled) begin
			result = filledPolygonRGBA(renderer, vx, vy, numpoints, r, g, b, a);
		end else begin
			result = polygonRGBA(renderer, vx, vy, numpoints, r, g, b, a);
		end;
	end;

	/* Free combined vertex array */
	free(vx);

	return (result);
end;

/*!
\brief Draw pie (outline) with alpha blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the pie.
  y Y coordinate of the center of the pie.
  rad Radius in pixels of the pie.
  start Starting radius in degrees of the pie.
  end Ending radius in degrees of the pie.
  color The color value of the pie to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int pieColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, 
	Sint16 start, Sint16 end, LongWord color) 
begin
	Uint8 *c = (Uint8 *)&color; 
	return _pieRGBA(renderer, x, y, rad, start, end, c[0], c[1], c[2], c[3], 0);
end;

/*!
\brief Draw pie (outline) with alpha blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the pie.
  y Y coordinate of the center of the pie.
  rad Radius in pixels of the pie.
  start Starting radius in degrees of the pie.
  end Ending radius in degrees of the pie.
  r The red value of the pie to draw. 
  g The green value of the pie to draw. 
  b The blue value of the pie to draw. 
  a The alpha value of the pie to draw.

\returns Returns 0 on success, -1 on failure.
*/

int pieRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad,
	Sint16 start, Sint16 end, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	return _pieRGBA(renderer, x, y, rad, start, end, r, g, b, a, 0);
end;

/*!
\brief Draw filled pie with alpha blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the filled pie.
  y Y coordinate of the center of the filled pie.
  rad Radius in pixels of the filled pie.
  start Starting radius in degrees of the filled pie.
  end Ending radius in degrees of the filled pie.
  color The color value of the filled pie to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int filledPieColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad, Sint16 start, Sint16 end, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return _pieRGBA(renderer, x, y, rad, start, end, c[0], c[1], c[2], c[3], 1);
end;

/*!
\brief Draw filled pie with alpha blending.

  renderer The renderer to draw on.
  x X coordinate of the center of the filled pie.
  y Y coordinate of the center of the filled pie.
  rad Radius in pixels of the filled pie.
  start Starting radius in degrees of the filled pie.
  end Ending radius in degrees of the filled pie.
  r The red value of the filled pie to draw. 
  g The green value of the filled pie to draw. 
  b The blue value of the filled pie to draw. 
  a The alpha value of the filled pie to draw.

\returns Returns 0 on success, -1 on failure.
*/

int filledPieRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, Sint16 rad,
	Sint16 start, Sint16 end, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	return _pieRGBA(renderer, x, y, rad, start, end, r, g, b, a, 1);
end;

/* ------ Trigon */

/*!
\brief Draw trigon (triangle outline) with alpha blending.

Note: Creates vertex array and uses polygon routine to render.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the trigon.
  y1 Y coordinate of the first point of the trigon.
  x2 X coordinate of the second point of the trigon.
  y2 Y coordinate of the second point of the trigon.
  x3 X coordinate of the third point of the trigon.
  y3 Y coordinate of the third point of the trigon.
  color The color value of the trigon to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int trigonColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, LongWord color)
begin
	Sint16 vx[3]; 
	Sint16 vy[3];

	vx[0]=x1;
	vx[1]=x2;
	vx[2]=x3;
	vy[0]=y1;
	vy[1]=y2;
	vy[2]=y3;

	return(polygonColor(renderer,vx,vy,3,color));
end;

/*!
\brief Draw trigon (triangle outline) with alpha blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the trigon.
  y1 Y coordinate of the first point of the trigon.
  x2 X coordinate of the second point of the trigon.
  y2 Y coordinate of the second point of the trigon.
  x3 X coordinate of the third point of the trigon.
  y3 Y coordinate of the third point of the trigon.
  r The red value of the trigon to draw. 
  g The green value of the trigon to draw. 
  b The blue value of the trigon to draw. 
  a The alpha value of the trigon to draw.

\returns Returns 0 on success, -1 on failure.
*/

int trigonRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3,
	Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	Sint16 vx[3]; 
	Sint16 vy[3];

	vx[0]=x1;
	vx[1]=x2;
	vx[2]=x3;
	vy[0]=y1;
	vy[1]=y2;
	vy[2]=y3;

	return(polygonRGBA(renderer,vx,vy,3,r,g,b,a));
end;				 

/* ------ AA-Trigon */

/*!
\brief Draw anti-aliased trigon (triangle outline) with alpha blending.

Note: Creates vertex array and uses aapolygon routine to render.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the aa-trigon.
  y1 Y coordinate of the first point of the aa-trigon.
  x2 X coordinate of the second point of the aa-trigon.
  y2 Y coordinate of the second point of the aa-trigon.
  x3 X coordinate of the third point of the aa-trigon.
  y3 Y coordinate of the third point of the aa-trigon.
  color The color value of the aa-trigon to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int aatrigonColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, LongWord color)
begin
	Sint16 vx[3]; 
	Sint16 vy[3];

	vx[0]=x1;
	vx[1]=x2;
	vx[2]=x3;
	vy[0]=y1;
	vy[1]=y2;
	vy[2]=y3;

	return(aapolygonColor(renderer,vx,vy,3,color));
end;

/*!
\brief Draw anti-aliased trigon (triangle outline) with alpha blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the aa-trigon.
  y1 Y coordinate of the first point of the aa-trigon.
  x2 X coordinate of the second point of the aa-trigon.
  y2 Y coordinate of the second point of the aa-trigon.
  x3 X coordinate of the third point of the aa-trigon.
  y3 Y coordinate of the third point of the aa-trigon.
  r The red value of the aa-trigon to draw. 
  g The green value of the aa-trigon to draw. 
  b The blue value of the aa-trigon to draw. 
  a The alpha value of the aa-trigon to draw.

\returns Returns 0 on success, -1 on failure.
*/

int aatrigonRGBA(SDL_Renderer * renderer,  Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3,
	Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	Sint16 vx[3]; 
	Sint16 vy[3];

	vx[0]=x1;
	vx[1]=x2;
	vx[2]=x3;
	vy[0]=y1;
	vy[1]=y2;
	vy[2]=y3;

	return(aapolygonRGBA(renderer,vx,vy,3,r,g,b,a));
end;				   

/* ------ Filled Trigon */

/*!
\brief Draw filled trigon (triangle) with alpha blending.

Note: Creates vertex array and uses aapolygon routine to render.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the filled trigon.
  y1 Y coordinate of the first point of the filled trigon.
  x2 X coordinate of the second point of the filled trigon.
  y2 Y coordinate of the second point of the filled trigon.
  x3 X coordinate of the third point of the filled trigon.
  y3 Y coordinate of the third point of the filled trigon.
  color The color value of the filled trigon to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int filledTrigonColor(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3, LongWord color)
begin
	Sint16 vx[3]; 
	Sint16 vy[3];

	vx[0]=x1;
	vx[1]=x2;
	vx[2]=x3;
	vy[0]=y1;
	vy[1]=y2;
	vy[2]=y3;

	return(filledPolygonColor(renderer,vx,vy,3,color));
end;

/*!
\brief Draw filled trigon (triangle) with alpha blending.

Note: Creates vertex array and uses aapolygon routine to render.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the filled trigon.
  y1 Y coordinate of the first point of the filled trigon.
  x2 X coordinate of the second point of the filled trigon.
  y2 Y coordinate of the second point of the filled trigon.
  x3 X coordinate of the third point of the filled trigon.
  y3 Y coordinate of the third point of the filled trigon.
  r The red value of the filled trigon to draw. 
  g The green value of the filled trigon to draw. 
  b The blue value of the filled trigon to draw. 
  a The alpha value of the filled trigon to draw.

\returns Returns 0 on success, -1 on failure.
*/

int filledTrigonRGBA(SDL_Renderer * renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Sint16 x3, Sint16 y3,
	Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
//array 0..2 of LongInt

	Sint16 vx[3]; 
	Sint16 vy[3];

	vx[0]=x1;
	vx[1]=x2;
	vx[2]=x3;
	vy[0]=y1;
	vy[1]=y2;
	vy[2]=y3;

	return(filledPolygonRGBA(renderer,vx,vy,3,r,g,b,a));
end;

/* ---- Polygon */

/*!
\brief Draw polygon with alpha blending.

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the polygon.
  vy Vertex array containing Y coordinates of the points of the polygon.
  n Number of points in the vertex array. Minimum number is 3.
  color The color value of the polygon to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int polygonColor(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return polygonRGBA(renderer, vx, vy, n, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw polygon with the currently set color and blend /e.

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the polygon.
  vy Vertex array containing Y coordinates of the points of the polygon.
  n Number of points in the vertex array. Minimum number is 3.

\returns Returns 0 on success, -1 on failure.
*/

int polygon(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n)
begin
	/*
	* Draw 
	*/
	int result = 0;
	int i, nn;
	SDL_Point* points;

	/*
	* Vertex array NULL check 
	*/
	if (vx = NULL) begin
		return (-1);
	end;
	if (vy = NULL) begin
		return (-1);
	end;

	/*
	* Sanity check 
	*/
	if (n < 3) begin
		return (-1);
	end;

	/*
	* Create array of points
	*/
	nn = n + 1;
	points = (SDL_Point*)malloc(sizeof(SDL_Point) * nn);
	if (points = NULL)
	begin
		return -1;
	end;
	for (i=0; i<n; i++)
	begin
		points[i].x = vx[i];
		points[i].y = vy[i];
	end;
	points[n].x = vx[0];
	points[n].y = vy[0];

	/*
	* Draw 
	*/
	result |= SDL_RenderDrawLines(renderer, points, nn);
	free(points);

	return (result);
end;

/*!
\brief Draw polygon with alpha blending.

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the polygon.
  vy Vertex array containing Y coordinates of the points of the polygon.
  n Number of points in the vertex array. Minimum number is 3.
  r The red value of the polygon to draw. 
  g The green value of the polygon to draw. 
  b The blue value of the polygon to draw. 
  a The alpha value of the polygon to draw.

\returns Returns 0 on success, -1 on failure.
*/

int polygonRGBA(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	/*
	* Draw 
	*/
	int result;
	const Sint16 *x1, *y1, *x2, *y2;

	/*
	* Vertex array NULL check 
	*/
	if (vx = NULL) begin
		return (-1);
	end;
	if (vy = NULL) begin
		return (-1);
	end;

	/*
	* Sanity check 
	*/
	if (n < 3) begin
		return (-1);
	end;

	/*
	* Pointer setup 
	*/
	x1 = x2 = vx;
	y1 = y2 = vy;
	x2++;
	y2++;

	/*
	* Set color 
	*/
	result = 0;
	result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);	

	/*
	* Draw 
	*/
	result |= polygon(renderer, vx, vy, n);

	return (result);
end;

/* ---- AA-Polygon */

/*!
\brief Draw anti-aliased polygon with alpha blending.

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the aa-polygon.
  vy Vertex array containing Y coordinates of the points of the aa-polygon.
  n Number of points in the vertex array. Minimum number is 3.
  color The color value of the aa-polygon to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int aapolygonColor(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return aapolygonRGBA(renderer, vx, vy, n, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw anti-aliased polygon with alpha blending.

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the aa-polygon.
  vy Vertex array containing Y coordinates of the points of the aa-polygon.
  n Number of points in the vertex array. Minimum number is 3.
  r The red value of the aa-polygon to draw. 
  g The green value of the aa-polygon to draw. 
  b The blue value of the aa-polygon to draw. 
  a The alpha value of the aa-polygon to draw.

\returns Returns 0 on success, -1 on failure.
*/

int aapolygonRGBA(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result;
	int i;
	const Sint16 *x1, *y1, *x2, *y2;

	/*
	* Vertex array NULL check 
	*/
	if (vx = NULL) begin
		return (-1);
	end;
	if (vy = NULL) begin
		return (-1);
	end;

	/*
	* Sanity check 
	*/
	if (n < 3) begin
		return (-1);
	end;

	/*
	* Pointer setup 
	*/
	x1 = x2 = vx;
	y1 = y2 = vy;
	x2++;
	y2++;

	/*
	* Draw 
	*/
	result = 0;
	for (i = 1; i < n; i++) begin
		result |= _aalineRGBA(renderer, *x1, *y1, *x2, *y2, r, g, b, a, 0);
		x1 = x2;
		y1 = y2;
		x2++;
		y2++;
	end;

	result |= _aalineRGBA(renderer, *x1, *y1, *vx, *vy, r, g, b, a, 0);

	return (result);
end;

/* ---- Filled Polygon */



boolean: Is B within A?
Is SDL_Point in BOX?

}


//FIXME: ANY comparator should always return boolean.
//to not do so (flawed C) is a BUG

function gfxPrimitivesCompareInt(a,b:PtrUInt):integer;
begin
//is point in box??
end;

static int *gfxPrimitivesPolyIntsGlobal = NULL;
static int gfxPrimitivesPolyAllocatedGlobal = 0;

{

/*!
\brief Draw filled polygon with alpha blending (multi-threaded capable).

Note: The last two parameters are optional; but are required for multithreaded operation.  

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the filled polygon.
  vy Vertex array containing Y coordinates of the points of the filled polygon.
  n Number of points in the vertex array. Minimum number is 3.
  r The red value of the filled polygon to draw. 
  g The green value of the filled polygon to draw. 
  b The blue value of the filled polygon to draw. 
  a The alpha value of the filled polygon to draw.
  polyInts Preallocated, temporary vertex array used for sorting vertices. Required for multithreaded operation; set to NULL otherwise.
  polyAllocated Flag indicating if temporary vertex array was allocated. Required for multithreaded operation; set to NULL otherwise.

\returns Returns 0 on success, -1 on failure.
*/

int filledPolygonRGBAMT(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a, int **polyInts, int *polyAllocated)
begin
	int result;
	int i;
	int y, xa, xb;
	int miny, maxy;
	int x1, y1;
	int x2, y2;
	int ind1, ind2;
	int ints;
	int *gfxPrimitivesPolyInts = NULL;
	int *gfxPrimitivesPolyIntsNew = NULL;
	int gfxPrimitivesPolyAllocated = 0;

	/*
	* Vertex array NULL check 
	*/
	if (vx = NULL) begin
		return (-1);
	end;
	if (vy = NULL) begin
		return (-1);
	end;

	/*
	* Sanity check number of edges
	*/
	if (n < 3) begin
		return -1;
	end;

	/*
	* Map polygon cache  
	*/
	if ((polyInts=NULL) || (polyAllocated=NULL)) begin
		/* Use global cache */
		gfxPrimitivesPolyInts = gfxPrimitivesPolyIntsGlobal;
		gfxPrimitivesPolyAllocated = gfxPrimitivesPolyAllocatedGlobal;
	end else begin
		/* Use local cache */
		gfxPrimitivesPolyInts = *polyInts;
		gfxPrimitivesPolyAllocated = *polyAllocated;
	end;

	/*
	* Allocate temp array, only grow array 
	*/
	if (!gfxPrimitivesPolyAllocated) begin
		gfxPrimitivesPolyInts = (int *) malloc(sizeof(int) * n);
		gfxPrimitivesPolyAllocated = n;
	end else begin
		if (gfxPrimitivesPolyAllocated < n) begin
			gfxPrimitivesPolyIntsNew = (int *) realloc(gfxPrimitivesPolyInts, sizeof(int) * n);
			if (!gfxPrimitivesPolyIntsNew) begin
				if (!gfxPrimitivesPolyInts) begin
					free(gfxPrimitivesPolyInts);
					gfxPrimitivesPolyInts = NULL;
				end;
				gfxPrimitivesPolyAllocated = 0;
			end else begin
				gfxPrimitivesPolyInts = gfxPrimitivesPolyIntsNew;
				gfxPrimitivesPolyAllocated = n;
			end;
		end;
	end;

	/*
	* Check temp array
	*/
	if (gfxPrimitivesPolyInts=NULL) begin
		gfxPrimitivesPolyAllocated = 0;
	end;

	/*
	* Update cache variables
	*/
	if ((polyInts=NULL) || (polyAllocated=NULL)) begin
		gfxPrimitivesPolyIntsGlobal =  gfxPrimitivesPolyInts;
		gfxPrimitivesPolyAllocatedGlobal = gfxPrimitivesPolyAllocated;
	end else begin
		*polyInts = gfxPrimitivesPolyInts;
		*polyAllocated = gfxPrimitivesPolyAllocated;
	end;

	/*
	* Check temp array again
	*/
	if (gfxPrimitivesPolyInts=NULL) begin
		return(-1);
	end;

	/*
	* Determine Y maxima 
	*/
	miny = vy[0];
	maxy = vy[0];
	for (i = 1; (i < n); i++) begin
		if (vy[i] < miny) begin
			miny = vy[i];
		end else if (vy[i] > maxy) begin
			maxy = vy[i];
		end;
	end;

	/*
	* Draw, scanning y 
	*/
	
	result = 0;
	for (y = miny; (y <= maxy); y++) begin
		ints = 0;
		for (i = 0; (i < n); i++) begin
			if (!i) begin
				ind1 = n - 1;
				ind2 = 0;
			end else begin
				ind1 = i - 1;
				ind2 = i;
			end;
			y1 = vy[ind1];
			y2 = vy[ind2];
			if (y1 < y2) {
				x1 = vx[ind1];
				x2 = vx[ind2];
			end else if (y1 > y2) begin
				y2 = vy[ind1];
				y1 = vy[ind2];
				x2 = vx[ind1];
				x1 = vx[ind2];
			end else begin
				continue;
			end;
			if ( ((y >= y1) && (y < y2)) || ((y = maxy) && (y > y1) && (y <= y2)) ) begin
				gfxPrimitivesPolyInts[ints++] = ((65536 * (y - y1)) / (y2 - y1)) * (x2 - x1) + (65536 * x1);
			end; 	    
		end;
        //??
		qsort(gfxPrimitivesPolyInts, ints, sizeof(int), _gfxPrimitivesCompareInt);

		/*
		* Set color 
		*/
		
		result = 0;
	    result |= SDL_SetRenderDrawBlend/e(renderer, (a = 255) ? SDL_BLEND/E_NONE : SDL_BLEND/E_BLEND);
		result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);	

		for (i = 0; (i < ints); i += 2) begin
			xa = gfxPrimitivesPolyInts[i] + 1;
			xa = (xa >> 16) + ((xa & 32768) >> 15);
			xb = gfxPrimitivesPolyInts[i+1] - 1;
			xb = (xb >> 16) + ((xb & 32768) >> 15);
			result |= hline(renderer, xa, xb, y);
		end;
	end;

	return (result);
end;

/*!
\brief Draw filled polygon with alpha blending.

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the filled polygon.
  vy Vertex array containing Y coordinates of the points of the filled polygon.
  n Number of points in the vertex array. Minimum number is 3.
  color The color value of the filled polygon to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int filledPolygonColor(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return filledPolygonRGBAMT(renderer, vx, vy, n, c[0], c[1], c[2], c[3], NULL, NULL);
end;

/*!
\brief Draw filled polygon with alpha blending.

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the filled polygon.
  vy Vertex array containing Y coordinates of the points of the filled polygon.
  n Number of points in the vertex array. Minimum number is 3.
  r The red value of the filled polygon to draw. 
  g The green value of the filled polygon to draw. 
  b The blue value of the filed polygon to draw. 
  a The alpha value of the filled polygon to draw.

\returns Returns 0 on success, -1 on failure.
*/

int filledPolygonRGBA(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	return filledPolygonRGBAMT(renderer, vx, vy, n, r, g, b, a, NULL, NULL);
end;


/*!
\brief Internal function to draw a textured horizontal line.

  renderer The renderer to draw on.
  x1 X coordinate of the first point (i.e. left) of the line.
  x2 X coordinate of the second point (i.e. right) of the line.
  y Y coordinate of the points of the line.
  texture The texture to retrieve color information from.
  texture_w The width of the texture.
  texture_h The height of the texture.
  texture_dx The X offset for the texture lookup.
  texture_dy The Y offset for the textured lookup.

\returns Returns 0 on success, -1 on failure.
*/

int _HLineTextured(SDL_Renderer *renderer, Sint16 x1, Sint16 x2, Sint16 y, SDL_Texture *texture, int texture_w, int texture_h, int texture_dx, int texture_dy)
begin
	Sint16 w;
	Sint16 xtmp;
	int result = 0;
	int texture_x_walker;    
	int texture_y_start;    
	SDL_Rect source_rect,dst_rect;
	int pixels_written,write_width;

	/*
	* Swap x1, x2 if required to ensure x1<=x2
	*/
	
	if (x1 > x2) begin
		xtmp = x1;
		x1 = x2;
		x2 = xtmp;
	end;

	/*
	* Calculate width to draw
	*/
	w = x2 - x1 + 1;

	/*
	* Determine where in the texture we start drawing
	*/
	
	texture_x_walker =   (x1 - texture_dx)  mod texture_w;
	if (texture_x_walker < 0) begin
		texture_x_walker = texture_w + texture_x_walker ;
	end;

	texture_y_start = (y + texture_dy) mod texture_h;
	if (texture_y_start < 0) begin
		texture_y_start = texture_h + texture_y_start;
	end;

	/* setup the source rectangle; we are only drawing one horizontal line */
	source_rect.y = texture_y_start;
	source_rect.x = texture_x_walker;
	source_rect.h = 1;

	/* we will draw to the current y */
	dst_rect.y = y;
	dst_rect.h = 1;

	/* if there are enough pixels left in the current row of the texture */
	/* draw it all at once */
	
	if (w <= texture_w -texture_x_walker) begin
		source_rect.w = w;
		source_rect.x = texture_x_walker;
		dst_rect.x= x1;
		dst_rect.w = source_rect.w;
		result = (SDL_RenderCopy(renderer, texture, &source_rect, &dst_rect) = 0);
	end else begin
		/* we need to draw multiple times */
		/* draw the first segment */
		pixels_written = texture_w  - texture_x_walker;
		source_rect.w = pixels_written;
		source_rect.x = texture_x_walker;
		dst_rect.x= x1;
		dst_rect.w = source_rect.w;
		result |= (SDL_RenderCopy(renderer, texture, &source_rect, &dst_rect) = 0);
		write_width = texture_w;

		/* now draw the rest */
		/* set the source x to 0 */
		source_rect.x = 0;
		while (pixels_written < w) begin
			if (write_width >= w - pixels_written) begin
				write_width =  w - pixels_written;
			end;
			source_rect.w = write_width;
			dst_rect.x = x1 + pixels_written;
			dst_rect.w = source_rect.w;
			result |= (SDL_RenderCopy(renderer, texture, &source_rect, &dst_rect) = 0);
			pixels_written += write_width;
		end;
	end;

	return result;
end;

/*!
\brief Draws a polygon filled with the given texture (Multi-Threading Capable). 

  renderer The renderer to draw on.
  vx array of x vector components
  vy array of x vector components
  n the amount of vectors in the vx and vy array
  texture the sdl surface to use to fill the polygon
  texture_dx the offset of the texture relative to the screeen. If you move the polygon 10 pixels 
to the left and want the texture to apear the same you need to increase the texture_dx value
  texture_dy see texture_dx
  polyInts Preallocated temp array storage for vertex sorting (used for multi-threaded operation)
  polyAllocated Flag indicating oif the temp array was allocated (used for multi-threaded operation)

\returns Returns 0 on success, -1 on failure.
*/

int texturedPolygonMT(SDL_Renderer *renderer, const Sint16 * vx, const Sint16 * vy, int n, 
	SDL_Surface * texture, int texture_dx, int texture_dy, int **polyInts, int *polyAllocated)
begin
	int result;
	int i;
	int y, xa, xb;
	int minx,maxx,miny, maxy;
	int x1, y1;
	int x2, y2;
	int ind1, ind2;
	int ints;
	int *gfxPrimitivesPolyInts = NULL;
	int *gfxPrimitivesPolyIntsTemp = NULL;
	int gfxPrimitivesPolyAllocated = 0;
	SDL_Texture *textureAsTexture = NULL;

	/*
	* Sanity check number of edges
	*/
	if (n < 3) begin
		return -1;
	end;

	/*
	* Map polygon cache  
	*/
	if ((polyInts=NULL) || (polyAllocated=NULL)) begin
		/* Use global cache */
		gfxPrimitivesPolyInts = gfxPrimitivesPolyIntsGlobal;
		gfxPrimitivesPolyAllocated = gfxPrimitivesPolyAllocatedGlobal;
	end else begin
		/* Use local cache */
		gfxPrimitivesPolyInts = *polyInts;
		gfxPrimitivesPolyAllocated = *polyAllocated;
	end;

	/*
	* Allocate temp array, only grow array 
	*/
	if (!gfxPrimitivesPolyAllocated) begin
		gfxPrimitivesPolyInts = (int *) malloc(sizeof(int) * n);
		gfxPrimitivesPolyAllocated = n;
	end else begin
		if (gfxPrimitivesPolyAllocated < n) begin
			gfxPrimitivesPolyIntsTemp = (int *) realloc(gfxPrimitivesPolyInts, sizeof(int) * n);
			if (gfxPrimitivesPolyIntsTemp = NULL) begin
				/* Realloc failed - keeps original memory block, but fails this operation */
				return(-1);
			end;
			gfxPrimitivesPolyInts = gfxPrimitivesPolyIntsTemp;
			gfxPrimitivesPolyAllocated = n;
		end;
	end;

	/*
	* Check temp array
	*/
	if (gfxPrimitivesPolyInts=NULL) begin
		gfxPrimitivesPolyAllocated = 0;
	end;

	/*
	* Update cache variables
	*/
	if ((polyInts=NULL) || (polyAllocated=NULL)) begin
		gfxPrimitivesPolyIntsGlobal =  gfxPrimitivesPolyInts;
		gfxPrimitivesPolyAllocatedGlobal = gfxPrimitivesPolyAllocated;
	end else begin
		*polyInts = gfxPrimitivesPolyInts;
		*polyAllocated = gfxPrimitivesPolyAllocated;
	end;

	/*
	* Check temp array again
	*/
	if (gfxPrimitivesPolyInts=NULL) begin
		return(-1);
	end;

	/*
	* Determine X,Y minima,maxima 
	*/
	miny = vy[0];
	maxy = vy[0];
	minx = vx[0];
	maxx = vx[0];
	for (i = 1; (i < n); i++) begin
		if (vy[i] < miny) begin
			miny = vy[i];
		end else if (vy[i] > maxy) begin
			maxy = vy[i];
		end;
		if (vx[i] < minx) begin
			minx = vx[i];
		end else if (vx[i] > maxx) begin
			maxx = vx[i];
		end;
	end;

    /* Create texture for drawing */
	textureAsTexture = SDL_CreateTextureFromSurface(renderer, texture);
	if (textureAsTexture = NULL)
	begin
		return -1;
	end;
	SDL_SetTextureBlend/e(textureAsTexture, SDL_BLEND/E_BLEND);
	
	/*
	* Draw, scanning y 
	*/
	
	result = 0;
	for (y = miny; (y <= maxy); y++) begin
		ints = 0;
		for (i = 0; (i < n); i++) begin
			if (!i) begin
				ind1 = n - 1;
				ind2 = 0;
			end else begin
				ind1 = i - 1;
				ind2 = i;
			end;
			y1 = vy[ind1];
			y2 = vy[ind2];
			if (y1 < y2) begin
				x1 = vx[ind1];
				x2 = vx[ind2];
			end else if (y1 > y2) begin
				y2 = vy[ind1];
				y1 = vy[ind2];
				x2 = vx[ind1];
				x1 = vx[ind2];
			end else begin
				continue;
			end;
			if ( ((y >= y1) && (y < y2)) || ((y = maxy) && (y > y1) && (y <= y2)) ) begin
				gfxPrimitivesPolyInts[ints++] = ((65536 * (y - y1)) / (y2 - y1)) * (x2 - x1) + (65536 * x1);
			end; 
		end;

		qsort(gfxPrimitivesPolyInts, ints, sizeof(int), _gfxPrimitivesCompareInt);

		for (i = 0; (i < ints); i += 2) begin
			xa = gfxPrimitivesPolyInts[i] + 1;
			xa = (xa >> 16) + ((xa & 32768) >> 15);
			xb = gfxPrimitivesPolyInts[i+1] - 1;
			xb = (xb >> 16) + ((xb & 32768) >> 15);
			result |= _HLineTextured(renderer, xa, xb, y, textureAsTexture, texture->w, texture->h, texture_dx, texture_dy);
		end;
	end;

	SDL_RenderPresent(renderer);
	SDL_DestroyTexture(textureAsTexture);

	return (result);
end;

/*!
\brief Draws a polygon filled with the given texture. 

This standard version is calling multithreaded versions with NULL cache parameters.

  renderer The renderer to draw on.
  vx array of x vector components
  vy array of x vector components
  n the amount of vectors in the vx and vy array
  texture the sdl surface to use to fill the polygon
  texture_dx the offset of the texture relative to the screeen. if you move the polygon 10 pixels 
to the left and want the texture to apear the same you need to increase the texture_dx value
  texture_dy see texture_dx

\returns Returns 0 on success, -1 on failure.
*/

int texturedPolygon(SDL_Renderer *renderer, const Sint16 * vx, const Sint16 * vy, int n, SDL_Surface *texture, int texture_dx, int texture_dy)
begin
	/*
	* Draw
	*/
	return (texturedPolygonMT(renderer, vx, vy, n, texture, texture_dx, texture_dy, NULL, NULL));
end;
}

{
All 8x8 font code is going to have to be re written.
It assumes an 8x8 bitpacked array for each character.
 
- We dont use that anymore.
SetFontSize=8, then use a 8x8 "system font", designed for code,etc.
  
Furthermore this reduces code complexity and "slowness" used by:
 		 bits and bit alignments,unalign issues,etc.


---

static SDL_Texture *gfxPrimitivesFont[256];
static const unsigned char *currentFontdata = gfxPrimitivesFontdata;

static LongWord charWidth = 8;
static LongWord charHeight = 8;
static LongWord charWidthLocal = 8;
static LongWord charHeightLocal = 8;
static LongWord charPitch = 1;
static LongWord charRotation = 0;
static LongWord charSize = 8;

Sets or resets the current global font data.

The font data array is organized in follows: 
[fontdata] = [character 0]..[character 255] where

[character n] = 
	[byte 1 row 1]
	[byte 2 row 1]..[byte (pitch) row 1] 
	[byte 1 row 2] ...[byte (pitch) row height] 

where
	
[byte n] = [bit 0]...[bit 7] 

where 
[bit n] = [0 for transparent pixel|1 for colored opaque pixel] (boolean)

fontdata Pointer to array of font data. 
	Set to NULL, to reset global font to the default 8x8 font.

cw Width of character in bytes. Ignored if fontdata=NULL.
ch Height of character in bytes. Ignored if fontdata=NULL.

/FIXME: FONT
void gfxPrimitivesSetFont(const void *fontdata, LongWord cw, LongWord ch)
begin
	int i;

	if ((fontdata) && (cw) && (ch)) begin
		currentFontdata = (unsigned char *)fontdata;
		charWidth = cw;
		charHeight = ch;
	end else begin
		currentFontdata = gfxPrimitivesFontdata;
		charWidth = 8;
		charHeight = 8;
	end;

	charPitch = (charWidth+7)/8;
	charSize = charPitch * charHeight;

	/* Maybe flip width/height for rendering */
	if ((charRotation=1) || (charRotation=3))
	begin
		charWidthLocal = charHeight;
		charHeightLocal = charWidth;
	end
	else
	begin
		charWidthLocal = charWidth;
		charHeightLocal = charHeight;
	end;

	/* Clear character cache */
	for (i = 0; i < 256; i++) begin
		if (gfxPrimitivesFont[i]) begin
			SDL_DestroyTexture(gfxPrimitivesFont[i]);
			gfxPrimitivesFont[i] = NULL;
		end;
	end;
end;

/*!

Default is 0 (no rotation). 
1 = 90deg clockwise. 
2 = 180deg clockwise. 

3 = 270deg clockwise.(backwards)

Changing the rotation, will reset the character cache.

*/

void gfxPrimitivesSetFontRotation(LongWord rotation)
begin
	int i;

	rotation = rotation & 3;
	if (charRotation != rotation)
	begin
		/* Store rotation */
		charRotation = rotation;

		/* Maybe flip width/height for rendering */
		if ((charRotation=1) || (charRotation=3))
		begin
			charWidthLocal = charHeight;
			charHeightLocal = charWidth;
		end
		else
		begin
			charWidthLocal = charWidth;
			charHeightLocal = charHeight;
		end;

		/* Clear character cache */
		for (i = 0; i < 256; i++) begin
			if (gfxPrimitivesFont[i]) begin
				SDL_DestroyTexture(gfxPrimitivesFont[i]);
				gfxPrimitivesFont[i] = NULL;
			end;
		end;
	end;
end;

/*!
\brief Draw a character of the currently set font.

  renderer The Renderer to draw on.
  x X (horizontal) coordinate of the upper left corner of the character.
  y Y (vertical) coordinate of the upper left corner of the character.
  c The character to draw.
  r The red value of the character to draw. 
  g The green value of the character to draw. 
  b The blue value of the character to draw. 
  a The alpha value of the character to draw.

\returns Returns 0 on success, -1 on failure.
*/

int characterRGBA(SDL_Renderer *renderer, Sint16 x, Sint16 y, char c, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	SDL_Rect srect;
	SDL_Rect drect;
	int result;
	LongWord ix, iy;
	const unsigned char *charpos;
	Uint8 *curpos;
	Uint8 patt, mask;
	Uint8 *linepos;
	LongWord pitch;
	SDL_Surface *character;
	SDL_Surface *rotatedCharacter;
	LongWord ci;

	/*
	* Setup source rectangle
	*/
	srect.x = 0;
	srect.y = 0;
	srect.w = charWidthLocal;
	srect.h = charHeightLocal;

	/*
	* Setup destination rectangle
	*/
	drect.x = x;
	drect.y = y;
	drect.w = charWidthLocal;
	drect.h = charHeightLocal;

	/* Character index in cache */
	ci = (unsigned char) c;

	/*
	* Create new charWidth x charHeight bitmap surface if not already present.
	* Might get rotated later.
	*/
	if (gfxPrimitivesFont[ci] = NULL) begin
		/*
		* Redraw character into surface
		*/
		character =	SDL_CreateRGBSurface(SDL_SWSURFACE,
			charWidth, charHeight, 32,
			0xFF000000, 0x00FF0000, 0x0000FF00, 0x000000FF);
		if (character = NULL) begin
			return (-1);
		end;

		charpos = currentFontdata + ci * charSize;
				linepos = (Uint8 *)character->pixels;
		pitch = character->pitch;

		/*
		* Drawing loop 
		*/
		patt = 0;
		for (iy = 0; iy < charHeight; iy++) begin
			mask = 0x00;
			curpos = linepos;
			for (ix = 0; ix < charWidth; ix++) begin
				if (!(mask >>= 1)) begin
					patt = *charpos++;
					mask = 0x80;
				end;
				if (patt & mask) begin
					*(LongWord *)curpos = 0xffffffff;
				end else begin
					*(LongWord *)curpos = 0;
				end;
				curpos += 4;
			end;
			linepos += pitch;
		end;

		/* Maybe rotate and replace cached image */
		if (charRotation>0)
		begin
			rotatedCharacter = rotateSurface90Degrees(character, charRotation);
			SDL_FreeSurface(character);
			character = rotatedCharacter;
		end;

		/* Convert temp surface into texture */
		gfxPrimitivesFont[ci] = SDL_CreateTextureFromSurface(renderer, character);
		SDL_FreeSurface(character);

		/*
		* Check pointer 
		*/
		if (gfxPrimitivesFont[ci] = NULL) begin
			return (-1);
		end;
	end;

	/*
	* Set color 
	*/
	result = 0;
	result |= SDL_SetTextureColor/(gfxPrimitivesFont[ci], r, g, b);
	result |= SDL_SetTextureAlpha/(gfxPrimitivesFont[ci], a);

	/*
	* Draw texture onto destination 
	*/
	result |= SDL_RenderCopy(renderer, gfxPrimitivesFont[ci], &srect, &drect);

	return (result);
end;


/*!
\brief Draw a character of the currently set font.

  renderer The renderer to draw on.
  x X (horizontal) coordinate of the upper left corner of the character.
  y Y (vertical) coordinate of the upper left corner of the character.
  c The character to draw.
  color The color value of the character to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int characterColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, char c, LongWord color)
begin
	Uint8 *co = (Uint8 *)&color; 
	return characterRGBA(renderer, x, y, c, co[0], co[1], co[2], co[3]);
end;


/*!
\brief Draw a string in the currently set font.

The spacing between consequtive characters in the string is the fixed number of pixels 
of the character width of the current global font.

  renderer The renderer to draw on.
  x X (horizontal) coordinate of the upper left corner of the string.
  y Y (vertical) coordinate of the upper left corner of the string.
  s The string to draw.
  color The color value of the string to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int stringColor(SDL_Renderer * renderer, Sint16 x, Sint16 y, const char *s, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return stringRGBA(renderer, x, y, s, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw a string in the currently set font.

  renderer The renderer to draw on.
  x X (horizontal) coordinate of the upper left corner of the string.
  y Y (vertical) coordinate of the upper left corner of the string.
  s The string to draw.
  r The red value of the string to draw. 
  g The green value of the string to draw. 
  b The blue value of the string to draw. 
  a The alpha value of the string to draw.

\returns Returns 0 on success, -1 on failure.
*/

int stringRGBA(SDL_Renderer * renderer, Sint16 x, Sint16 y, const char *s, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result = 0;
	Sint16 curx = x;
	Sint16 cury = y;
	const char *curchar = s;

	while ( *curchar and not result) begin
		result |= characterRGBA(renderer, curx, cury, *curchar, r, g, b, a);
		switch (charRotation)
		begin
		case 0:
			curx += charWidthLocal;
			break;
		case 2:
			curx -= charWidthLocal;
			break;
		case 1:
			cury += charHeightLocal;
			break;
		case 3:
			cury -= charHeightLocal;
			break;
		end;
		curchar++;
	end;

	return (result);
end;

/* ---- Bezier curve */

/*!
\brief Internal function to calculate bezier interpolator of data array with ndata values at position 't'.

  data Array of values.
  ndata Size of array.
  t Position for which to calculate interpolated value. t should be between [0, ndata].

\returns Interpolated value at position t, value[0] when t<0, value[n-1] when t>n.
*/

double _evaluateBezier (double *data, int ndata, double t) 
begin
	double mu, result;
	int n,k,kn,nn,nkn;
	double blend,muk,munk;

	/* Sanity check bounds */
	if (t<0.0) begin
		return(data[0]);
	end;
	if (t>=(double)ndata) begin
		return(data[ndata-1]);
	end;

	/* Adjust t to the range 0.0 to 1.0 */ 
	mu=t/(double)ndata;

	/* Calculate interpolate */
	n=ndata-1;
	result=0.0;
	muk = 1;
	munk = pow(1-mu,(double)n);
	for (k=0;k<=n;k++) begin
		nn = n;
		kn = k;
		nkn = n - k;
		blend = muk * munk;
		muk *= mu;
		munk /= (1-mu);
		while (nn >= 1) begin
			blend *= nn;
			nn--;
			if (kn > 1) begin
				blend /= (double)kn;
				kn--;
			end;
			if (nkn > 1) begin
				blend /= (double)nkn;
				nkn--;
			end;
		end;
		result += data[k] * blend;
	end;

	return (result);
end;

/*!
\brief Draw a bezier curve with alpha blending.

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the bezier curve.
  vy Vertex array containing Y coordinates of the points of the bezier curve.
  n Number of points in the vertex array. Minimum number is 3.
  s Number of steps for the interpolation. Minimum number is 2.
  color The color value of the bezier curve to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int bezierColor(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, int s, LongWord color)
begin
	Uint8 *c = (Uint8 *)&color; 
	return bezierRGBA(renderer, vx, vy, n, s, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw a bezier curve with alpha blending.

  renderer The renderer to draw on.
  vx Vertex array containing X coordinates of the points of the bezier curve.
  vy Vertex array containing Y coordinates of the points of the bezier curve.
  n Number of points in the vertex array. Minimum number is 3.
  s Number of steps for the interpolation. Minimum number is 2.
  r The red value of the bezier curve to draw. 
  g The green value of the bezier curve to draw. 
  b The blue value of the bezier curve to draw. 
  a The alpha value of the bezier curve to draw.

\returns Returns 0 on success, -1 on failure.
*/

int bezierRGBA(SDL_Renderer * renderer, const Sint16 * vx, const Sint16 * vy, int n, int s, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int result;
	int i;
	double *x, *y, t, stepsize;
	Sint16 x1, y1, x2, y2;

	/*
	* Sanity check 
	*/
	if (n < 3) begin
		return (-1);
	end;
	if (s < 2) begin
		return (-1);
	end;

	/*
	* Variable setup 
	*/
	stepsize=(double)1.0/(double)s;

	/* Transfer vertices into float arrays */
	if ((x=(double *)malloc(sizeof(double)*(n+1)))=NULL) begin
		return(-1);
	end;
	if ((y=(double *)malloc(sizeof(double)*(n+1)))=NULL) begin
		free(x);
		return(-1);
	end;    
	for (i=0; i<n; i++) begin
		x[i]=(double)vx[i];
		y[i]=(double)vy[i];
	end;      
	x[n]=(double)vx[0];
	y[n]=(double)vy[0];

	/*
	* Set color 
	*/
	result = 0;
	result |= SDL_SetRenderDrawBlend(renderer, (a = 255) ? SDL_BLEND_NONE : SDL_BLEND_BLEND);
	result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);

	/*
	* Draw 
	*/
	
	t=0.0;
	x1=(Sint16)lrint(_evaluateBezier(x,n+1,t));
	y1=(Sint16)lrint(_evaluateBezier(y,n+1,t));
	for (i = 0; i <= (n*s); i++) begin
		t += stepsize;
		x2=(Sint16)_evaluateBezier(x,n,t);
		y2=(Sint16)_evaluateBezier(y,n,t);
		result |= line(renderer, x1, y1, x2, y2);
		x1 = x2;
		y1 = y2;
	end;

	/* Clean up temporary array */
	free(x);
	free(y);

	return (result);
end;


/*!
\brief Draw a thick line with alpha blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the line.
  y1 Y coordinate of the first point of the line.
  x2 X coordinate of the second point of the line.
  y2 Y coordinate of the second point of the line.
  width Width of the line in pixels. Must be >0.
  color The color value of the line to draw (0xRRGGBBAA). 

\returns Returns 0 on success, -1 on failure.
*/

int thickLineColor(SDL_Renderer *renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 width, LongWord color)
begin	
	Uint8 *c = (Uint8 *)&color; 
	return thickLineRGBA(renderer, x1, y1, x2, y2, width, c[0], c[1], c[2], c[3]);
end;

/*!
\brief Draw a thick line with alpha blending.

  renderer The renderer to draw on.
  x1 X coordinate of the first point of the line.
  y1 Y coordinate of the first point of the line.
  x2 X coordinate of the second point of the line.
  y2 Y coordinate of the second point of the line.
  width Width of the line in pixels. Must be >0.
  r The red value of the character to draw. 
  g The green value of the character to draw. 
  b The blue value of the character to draw. 
  a The alpha value of the character to draw.

\returns Returns 0 on success, -1 on failure.
*/	

int thickLineRGBA(SDL_Renderer *renderer, Sint16 x1, Sint16 y1, Sint16 x2, Sint16 y2, Uint8 width, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
begin
	int wh;
	double dx, dy, dx1, dy1, dx2, dy2;
	double l, wl2, nx, ny, ang, adj;
	Sint16 px[4], py[4];

	if (renderer = NULL) begin
		return -1;
	end;

	if (width < 1) begin
		return -1;
	end;

	/* Special case: thick "point" */
	if ((x1 = x2) && (y1 = y2)) begin
		wh = width / 2;
		return boxRGBA(renderer, x1 - wh, y1 - wh, x2 + width, y2 + width, r, g, b, a);		
	end;

	/* Special case: width = 1 */
	if (width = 1) begin
		return lineRGBA(renderer, x1, y1, x2, y2, r, g, b, a);		
	end;

	/* Calculate offsets for sides */
	dx = (double)(x2 - x1);
	dy = (double)(y2 - y1);
	l = SDL_sqrt(dx*dx + dy*dy);
	ang = SDL_atan2(dx, dy);
	adj = 0.1 + 0.9 * SDL_fabs(SDL_cos(2.0 * ang));
	wl2 = ((double)width - adj)/(2.0 * l);
	nx = dx * wl2;
	ny = dy * wl2;

	/* Build polygon */
	dx1 = (double)x1;
	dy1 = (double)y1;
	dx2 = (double)x2;
	dy2 = (double)y2;
	px[0] = (Sint16)(dx1 + ny);
	px[1] = (Sint16)(dx1 - ny);
	px[2] = (Sint16)(dx2 - ny);
	px[3] = (Sint16)(dx2 + ny);
	py[0] = (Sint16)(dy1 - nx);
	py[1] = (Sint16)(dy1 + nx);
	py[2] = (Sint16)(dy2 + nx);
	py[3] = (Sint16)(dy2 - nx);

	/* Draw polygon */
	return filledPolygonRGBA(renderer, px, py, 4, r, g, b, a);
end;
 
 
 
}
end.
