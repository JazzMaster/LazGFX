unit sdl2_gfx;

(*

SDL2_framerate.h: framerate manager
SDL2_gfxPrimitives.h: graphics primitives for SDL
SDL2_imageFilter.h: byte-image "filter" routines 
SDL2_rotozoom.h: rotozoomer, zoomer and shrinker for 32bit or 8bit surfaces

Copyright (C) 2001-2012  Andreas Schiffler

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

3. This notice may not be removed or altered from any source
distribution.

Andreas Schiffler -- aschiffler at ferzkopp dot net

*)


{$IFNDEF FPC}
  {$IFDEF Debug}
    {$F+,D+,Q-,L+,R+,I-,S+,Y+,A+}
  {$ELSE}
    {$F+,Q-,R-,S-,I-,A+}
  {$ENDIF}
{$ELSE}
  {$MODE DELPHI}
{$ENDIF}

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

{$IFDEF WIN16}
  {$DEFINE 16BIT}
  {$DEFINE WINDOWS}
{$ELSE}
  {$IFDEF WIN32}
    {$DEFINE 32BIT}
    {$DEFINE WINDOWS}
  {$ELSE}
    {$IFDEF WIN64}
      {$DEFINE 64BIT}
      {$DEFINE WINDOWS}
    {$ELSE}
      //TODO!!
      {$DEFINE 32BIT}
    {$ENDIF}
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


interface
   uses SDL2;

const
  {$IFDEF WINDOWS}
    GFX_LibName = 'SDL2_gfx.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      GFX_LibName = 'libSDL2_gfx.dylib';
    {$ELSE}
      {$IFDEF FPC}
        GFX_LibName = 'libSDL2_gfx.so';
      {$ELSE}
        GFX_LibName = 'libSDL2_gfx.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    GFX_LibName = 'SDL2_gfx';
    {$IFDEF FPC}
      {$linklib libSDL2_gfx}
    {$ENDIF}
  {$ENDIF}

  {$IF DEFINED(DELPHI) AND DEFINED(MACOS)}
     {$DEFINE DELMAC}
  {$ENDIF}

Procedure SDL_GFX_VERSION(Out X: TSDL_Version);

{---< SDL2_framerate.h >---}

Const
   {*!
    \brief Highest possible rate supported by framerate controller in Hz (1/s).
    *}
   FPS_UPPER_LIMIT = 200;

   {*!
    \brief Lowest possible rate supported by framerate controller in Hz (1/s).
    *}
   FPS_LOWER_LIMIT = 1;

   {*!
    \brief Default rate of framerate controller in Hz (1/s).
    *}
   FPS_DEFAULT = 30;

Type
   {*! 
    \brief Structure holding the state and timing information of the framerate controller. 
    *}
   
   TFPSManager = record
      framecount : uInt32;
      rateticks : Single; // float rateticks;
      baseticks : uInt32;
      lastticks : uInt32;
      rate : uInt32;
   end;
   
   PFPSManager = ^TFPSManager;

Procedure SDL_initFramerate(manager: PFPSManager);
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_initFramerate' {$ENDIF};

Function SDL_setFramerate(manager: PFPSManager; rate: uInt32):sInt32;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_setFramerate' {$ENDIF};
   
Function SDL_getFramerate(manager: PFPSManager):sInt32;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_getFramerate' {$ENDIF};
   
Function SDL_getFramecount(manager: PFPSManager):sInt32;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_getFramecount' {$ENDIF};

Function SDL_framerateDelay(manager: PFPSManager):uInt32;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_framerateDelay' {$ENDIF};


{---< SDL2_gfxPrimitives.h >---}

Const
   SDL2_GFXPRIMITIVES_MAJOR = 1;
   SDL2_GFXPRIMITIVES_MINOR = 0;
   SDL2_GFXPRIMITIVES_MICRO = 1;

(* Note: all ___Color routines expect the colour to be in format 0xRRGGBBAA *)


{* Pixel *}

Function pixelColor(renderer: PSDL_Renderer; x, y: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_pixelColor' {$ENDIF};
      
Function pixelRGBA(renderer: PSDL_Renderer; x, y: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_pixelRGBA' {$ENDIF};

{ Horizontal line }

Function hlineColor(renderer: PSDL_Renderer; x1, x2, y: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_hlineColor' {$ENDIF};
   
Function hlineRGBA(renderer: PSDL_Renderer; x1, x2, y:sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_hlineRGBA' {$ENDIF};

{ Vertical line }

Function vlineColor(renderer: PSDL_Renderer; x, y1, y2: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_vlineColor' {$ENDIF};
   
Function vlineRGBA(renderer: PSDL_Renderer; x, y1, y2: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_vlineRGBA' {$ENDIF};

{ Rectangle }

Function rectangleColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_rectangleColor' {$ENDIF};
   
Function rectangleRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_rectangleRGBA' {$ENDIF};

{ Rounded-Corner Rectangle }

Function roundedRectangleColor(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_roundedRectangleColor' {$ENDIF};
   
Function roundedRectangleRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_roundedRectangleRGBA' {$ENDIF};

{ Filled rectangle (Box) }

Function boxColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_boxColor' {$ENDIF};
   
Function boxRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_boxRGBA' {$ENDIF};

{ Rounded-Corner Filled rectangle (Box) }

Function roundedBoxColor(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_roundedBoxColor' {$ENDIF};
   
Function roundedBoxRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, rad: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_roundedBoxRGBA' {$ENDIF};

{ Line }

Function lineColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_lineColor' {$ENDIF};
   
Function lineRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_lineRGBA' {$ENDIF};

{ AA Line }

Function aalineColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aalineColor' {$ENDIF};
   
Function aalineRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aalineRGBA' {$ENDIF};

{ Thick Line }
Function thickLineColor(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; width: uInt8; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_thickLineColor' {$ENDIF};
   
Function thickLineRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2: sInt16; width, r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_thickLineRGBA' {$ENDIF};

{ Circle }

Function circleColor(renderer: PSDL_Renderer; x, y, rad: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_circleColor' {$ENDIF};
   
Function circleRGBA(renderer: PSDL_Renderer; x, y, rad: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_circleRGBA' {$ENDIF};

{ Arc }

Function arcColor(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_arcColor' {$ENDIF};
   
Function arcRGBA(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_arcRGBA' {$ENDIF};

{ AA Circle }

Function aacircleColor(renderer: PSDL_Renderer; x, y, rad: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aacircleColor' {$ENDIF};
   
Function aacircleRGBA(renderer: PSDL_Renderer; x, y, rad: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aacircleRGBA' {$ENDIF};

{ Filled Circle }

Function filledCircleColor(renderer: PSDL_Renderer; x, y, rad: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledCircleColor' {$ENDIF};
   
Function filledCircleRGBA(renderer: PSDL_Renderer; x, y, rad: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledCircleRGBA' {$ENDIF};

{ Ellipse }

Function ellipseColor(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_ellipseColor' {$ENDIF};
   
Function ellipseRGBA(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_ellipseRGBA' {$ENDIF};

{ AA Ellipse }

Function aaellipseColor(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aaellipseColor' {$ENDIF};
   
Function aaellipseRGBA(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aaellipseRGBA' {$ENDIF};

{ Filled Ellipse }

Function filledEllipseColor(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledEllipseColor' {$ENDIF};
   
Function filledEllipseRGBA(renderer: PSDL_Renderer; x, y, rx, ry: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledEllipseRGBA' {$ENDIF};

{ Pie }

Function pieColor(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_pieColor' {$ENDIF};
   
Function pieRGBA(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_pieRGBA' {$ENDIF};

{ Filled Pie }

Function filledPieColor(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledPieColor' {$ENDIF};
   
Function filledPieRGBA(renderer: PSDL_Renderer; x, y, rad, start, finish: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledPieRGBA' {$ENDIF};

{ Trigon }

Function trigonColor(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_trigonColor' {$ENDIF};
   
Function trigonRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_trigonRGBA' {$ENDIF};

{ AA-Trigon }

Function aatrigonColor(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aatrigonColor' {$ENDIF};
   
Function aatrigonRGBA(renderer: PSDL_Renderer;  x1, y1, x2, y2, x3, y3: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aatrigonRGBA' {$ENDIF};

{ Filled Trigon }

Function filledTrigonColor(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledTrigonColor' {$ENDIF};
   
Function filledTrigonRGBA(renderer: PSDL_Renderer; x1, y1, x2, y2, x3, y3: sInt16; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledTrigonRGBA' {$ENDIF};

{ Polygon }

Function polygonColor(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: sInt32; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_polygonColor' {$ENDIF};
   
Function polygonRGBA(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: sInt32; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_polugonRGBA' {$ENDIF};

{ AA-Polygon }

Function aapolygonColor(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: sInt32; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aapolygonColor' {$ENDIF};
   
Function aapolygonRGBA(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: sInt32; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_aapolygonRGBA' {$ENDIF};

{ Filled Polygon }

Function filledPolygonColor(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: sInt32; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledPolygonColor' {$ENDIF};
   
Function filledPolygonRGBA(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: sInt32; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_filledPolygonRGBA' {$ENDIF};

{ Textured Polygon }

Function texturedPolygon(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n: sInt32; texture: PSDL_Surface; texture_dx, texture_dy: sInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_texturedPolygon' {$ENDIF};

{ Bezier }

Function bezierColor(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n, s: sInt32; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_bezierColor' {$ENDIF};
   
Function bezierRGBA(renderer: PSDL_Renderer; Const vx, vy: PsInt16; n, s: sInt32; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_bezierRGBA' {$ENDIF};

{ Characters/Strings }

Procedure gfxPrimitivesSetFont(Const fontdata: Pointer; cw, ch: uInt32); cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_gfxPrimitivesSetFont' {$ENDIF};

Procedure gfxPrimitivesSetFontRotation(rotation: uInt32); cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_gfxPrimitivesSetFontRotation' {$ENDIF};


Function characterColor(renderer: PSDL_Renderer; x, y: sInt16; c: Char; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_characterColor' {$ENDIF};
   
Function characterRGBA(renderer: PSDL_Renderer; x, y: sInt16; c: Char; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_characterRGBA' {$ENDIF};
   
   
Function stringColor(renderer: PSDL_Renderer; x, y: sInt16; Const str: PChar; colour: uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_stringColor' {$ENDIF};
   
Function stringRGBA(renderer: PSDL_Renderer; x, y: sInt16; Const syt: PChar; r, g, b, a: uInt8):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_stringRGBA' {$ENDIF};



{---< SDL2_imageFilter.h >---}

(* Comments:                                                                           *
 *  1.) MMX functions work best if all data blocks are aligned on a 32 bytes boundary. *
 *  2.) Data that is not within an 8 byte boundary is processed using the C routine.   *
 *  3.) Convolution routines do not have C routines at this time.                      *)

// Detect MMX capability in CPU
Function SDL_imageFilterMMXdetect():sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterMMXdetect' {$ENDIF};

// Force use of MMX off (or turn possible use back on)
Procedure SDL_imageFilterMMXoff(); cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterMMXoff' {$ENDIF};
   
Procedure SDL_imageFilterMMXon(); cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterMMXon' {$ENDIF};


//  SDL_imageFilterAdd: D = saturation255(S1 + S2)
Function SDL_imageFilterAdd(Src1, Src2, Dest : PuInt8; Length : uInt32):sInt32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterAdd' {$ENDIF};

//  SDL_imageFilterMean: D = S1/2 + S2/2
Function SDL_imageFilterMean(Src1, Src2, Dest : PuInt8; Length:uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterMean' {$ENDIF};

//  SDL_imageFilterSub: D = saturation0(S1 - S2)
Function SDL_imageFilterSub(Src1, Src2, Dest : PuInt8; Length:uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterSub' {$ENDIF};

//  SDL_imageFilterAbsDiff: D = | S1 - S2 |
Function SDL_imageFilterAbsDiff(Src1, Src2, Dest : PuInt8; Length:uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterAbsDiff' {$ENDIF};


//  SDL_imageFilterMult: D = saturation(S1 * S2)
Function SDL_imageFilterMult(Src1, Src2, Dest : PuInt8; Length:uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterMult' {$ENDIF};

//  SDL_imageFilterMultNor: D = S1 * S2   (non-MMX)
Function SDL_imageFilterMultNor(Src1, Src2, Dest : PuInt8; Length:uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterMultNor' {$ENDIF};

//  SDL_imageFilterMultDivby2: D = saturation255(S1/2 * S2)
Function SDL_imageFilterMultDivby2(Src1, Src2, Dest : PuInt8; Length: uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterMultDivby2' {$ENDIF};

//  SDL_imageFilterMultDivby4: D = saturation255(S1/2 * S2/2)
Function SDL_imageFilterMultDivby4(Src1, Src2, Dest : PuInt8; Length : uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterMultDivby4' {$ENDIF};


//  SDL_imageFilterBitAnd: D = S1 & S2
Function SDL_imageFilterBitAnd(Src1, Src2, Dest : PuInt8; Length:uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterBitAnd' {$ENDIF};

//  SDL_imageFilterBitOr: D = S1 | S2
Function SDL_imageFilterBitOr(Src1, Src2, Dest : PuInt8; Length:uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterBitOr' {$ENDIF};


//  SDL_imageFilterDiv: D = S1 / S2   (non-MMX)
Function SDL_imageFilterDiv(Src1, Src2, Dest : PuInt8; Length:uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterDiv' {$ENDIF};

//  SDL_imageFilterBitNegation: D = !S
Function SDL_imageFilterBitNegation(Src1, Dest : PuInt8; Length:uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterBitNegation' {$ENDIF};


//  SDL_imageFilterAddByte: D = saturation255(S + C)
Function SDL_imageFilterAddByte(Src1, Dest : PuInt8; Length:uInt32; C : uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterAddByte' {$ENDIF};

//  SDL_imageFilterAddUsInt32: D = saturation255(S + (usInt32)C)
Function SDL_imageFilterAddUsInt32(Src1, Dest : PuInt8; Length:uInt32; C : uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterAddUsInt32' {$ENDIF};

//  SDL_imageFilterAddByteToHalf: D = saturation255(S/2 + C)
Function SDL_imageFilterAddByteToHalf(Src1, Dest : PuInt8; Length:uInt32; C : uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterAddByteToHalf' {$ENDIF};


//  SDL_imageFilterSubByte: D = saturation0(S - C)
Function SDL_imageFilterSubByte(Src1, Dest : PuInt8; Length:uInt32; C : uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterSubByte' {$ENDIF};

//  SDL_imageFilterSubUsInt32: D = saturation0(S - (usInt32)C)
Function SDL_imageFilterSubUsInt32(Src1, Dest : PuInt8; Length:uInt32; C : uInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterSubUsInt32' {$ENDIF};


//  SDL_imageFilterShiftRight: D = saturation0(S >> N)
Function SDL_imageFilterShiftRight(Src1, Dest : PuInt8; Length:uInt32; N : uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterShiftRight' {$ENDIF};

//  SDL_imageFilterShiftRightUsInt32: D = saturation0((usInt32)S >> N)
Function SDL_imageFilterShiftRightUsInt32(Src1, Dest : PuInt8; Length:uInt32; N : uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterShiftRightUsInt32' {$ENDIF};


//  SDL_imageFilterMultByByte: D = saturation255(S * C)
Function SDL_imageFilterMultByByte(Src1, Dest : PuInt8; Length:uInt32; C : uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterMultByByte' {$ENDIF};

//  SDL_imageFilterShiftRightAndMultByByte: D = saturation255((S >> N) * C)
Function SDL_imageFilterShiftRightAndMultByByte(Src1, Dest : PuInt8; Length:uInt32; N, C : uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterShiftRightAndMultByByte' {$ENDIF};


//  SDL_imageFilterShiftLeftByte: D = (S << N)
Function SDL_imageFilterShiftLeftByte(Src1, Dest : PuInt8; Length:uInt32; N: uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterShiftLeftByte' {$ENDIF};

//  SDL_imageFilterShiftLeftUsInt32: D = ((usInt32)S << N)
Function SDL_imageFilterShiftLeftUsInt32(Src1, Dest : PuInt8; Length:uInt32; N:uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterShiftLeftUsInt32' {$ENDIF};

//  SDL_imageFilterShiftLeft: D = saturation255(S << N)
Function SDL_imageFilterShiftLeft(Src1, Dest : PuInt8; Length:uInt32; N : uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterShiftLeft' {$ENDIF};


//  SDL_imageFilterBinarizeUsingThreshold: D = S >= T ? 255:0
Function SDL_imageFilterBinarizeUsingThreshold(Src1, Dest : PuInt8; Length:uInt32; T: uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterBinarizeUsingThreshold' {$ENDIF};

//  SDL_imageFilterClipToRange: D = (S >= Tmin) & (S <= Tmax) 255:0
Function SDL_imageFilterClipToRange(Src1, Dest : PuInt8; Length:uInt32; Tmin, Tmax: uInt8):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterClipToRange' {$ENDIF};

//  SDL_imageFilterNormalizeLinear: D = saturation255((Nmax - Nmin)/(Cmax - Cmin)*(S - Cmin) + Nmin)
Function SDL_imageFilterNormalizeLinear(Src, Dest: PuInt8; Length, Cmin, Cmax, Nmin, Nmax: sInt32):Sint32; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_SDL_imageFilterNormalizeLinear' {$ENDIF};


{---< SDL2_rotozoom.h >---}

Const
   {*!
    \brief Disable anti-aliasing (no smoothing).
   *}
   SMOOTHING_OFF = 0;

   {*!
    \brief Enable anti-aliasing (smoothing).
   *}
   SMOOTHING_ON = 1;

{ Rotozoom functions }

Function rotozoomSurface(src: PSDL_Surface; angle, zoom: Double; smooth: sInt32):PSDL_Surface; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_rotozoomSurface' {$ENDIF};

Function rotozoomSurfaceXY(src: PSDL_Surface; angle, zoomx, zoomy: Double; smooth: sInt32):PSDL_Surface; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_rotozoomSurfaceXY' {$ENDIF};


Procedure rotozoomSurfaceSize(width, height: sInt32; angle, zoom: Double; dstwidth, dstheight: PuInt32); cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_rotozoomSurfaceSize' {$ENDIF};

Procedure rotozoomSurfaceSizeXY(width, height: sInt32; angle, zoomx, zoomy: Double; dstwidth, dstheight:PuInt32); cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_rotozoomSurfaceSizeXY' {$ENDIF};


{ Zooming functions }

Function zoomSurface(src: PSDL_Surface; zoomx, zoomy: Double; smooth: sInt32):PSDL_Surface; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_zoomSurface' {$ENDIF};

Procedure zoomSurfaceSize(width, height: sInt32; zoomx, zoomy: Double; dstwidth, dstheight: PuInt32); cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_zoomSurfaceSize' {$ENDIF};

{ Shrinking functions }

Function shrinkSurface(src: PSDL_Surface; factorx, factory: sInt32):PSDL_Surface; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_shrinkSurface' {$ENDIF};

{ Specialized rotation functions }

Function rotateSurface90Degrees(src: PSDL_Surface; numClockwiseTurns: sInt32):PSDL_Surface; cdecl;
   external GFX_LibName {$IFDEF DELMAC} name '_rotateSurface90Degrees' {$ENDIF};


implementation

Procedure SDL_GFX_VERSION(Out X: TSDL_Version);
begin
   X.Major := SDL2_GFXPRIMITIVES_MAJOR;
   X.Minor := SDL2_GFXPRIMITIVES_MINOR;
   X.Patch := SDL2_GFXPRIMITIVES_MICRO
end;

end.
