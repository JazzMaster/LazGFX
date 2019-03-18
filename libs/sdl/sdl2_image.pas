unit sdl2_image;

{*
  SDL_image:  An example image loading library for use with SDL
  Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>

  Pascal-Header-Translation 2013 by Tim Blume

  Both, header translation and sdl_image, under following license:

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
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

  ChangeLog (Header-Translation):
  -------------------------------

  v.1.72-stable; 29.09.2013: fixed bug with procedure without parameters 
                             (they must have brackets)
  v.1.70-stable; 11.09.2013: MacOS compatibility (with Delphi)
  v.1.33-Alpha; 31.07.2013: Initial Commit

*}

{$DEFINE SDL_IMAGE}


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

uses
  SDL2;

const
  {$IFDEF WINDOWS}
    IMG_LibName = 'SDL2_image.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      IMG_LibName = 'libSDL2_image.dylib';
    {$ELSE}
      {$IFDEF FPC}
        IMG_LibName = 'libSDL2_image.so';
      {$ELSE}
        IMG_LibName = 'libSDL2_image.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    IMG_LibName = 'SDL2_image';
    {$IFDEF FPC}
      {$linklib libSDL2_image}
    {$ENDIF}
  {$ENDIF}

  {* Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL *}
  SDL_IMAGE_MAJOR_VERSION = 2;
  SDL_IMAGE_MINOR_VERSION = 0;
  SDL_IMAGE_PATCHLEVEL    = 0;

  {* This macro can be used to fill a version structure with the compile-time
   * version of the SDL_image library.
   *}

procedure SDL_IMAGE_VERSION(Out X: TSDL_Version);

  {* This function gets the version of the dynamically linked SDL_image library.
   * 
   * Note that this function does NOT allocate a new TSDL_Version and fill it with info,
   * but returns a pointer to a TSDL_Version residing inside dynlinked file.
   * 
   * As such, attempting to Dispose() of this memory will result in access violation.
   *}
function IMG_Linked_Version: PSDL_Version cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_Linked_Version' {$ENDIF} {$ENDIF};

const
  IMG_INIT_JPG  = $00000001;
  IMG_INIT_PNG  = $00000002;
  IMG_INIT_TIF  = $00000004;
  IMG_INIT_WEBP = $00000008;

type
  TIMG_InitFlags = DWord;

  {* Loads dynamic libraries and prepares them for use.  Flags should be
     one or more flags from IMG_InitFlags OR'd together.
     It returns the flags successfully initialized, or 0 on failure.
   *}
function IMG_Init(flags: SInt32): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_Init' {$ENDIF} {$ENDIF};

  {* Unloads libraries loaded with IMG_Init *}
procedure IMG_Quit() cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_Quit' {$ENDIF} {$ENDIF};

  {* Load an image from an SDL data source.
     The 'type' may be one of: "BMP", "GIF", "PNG", etc.

     If the image format supports a transparent pixel, SDL will set the
     colorkey for the surface.  You can enable RLE acceleration on the
     surface afterwards by calling:
      SDL_SetColorKey(image, SDL_RLEACCEL, image->format->colorkey);
   *}
function IMG_LoadTyped_RW(src: PSDL_RWops; freesrc: SInt32; _type: PAnsiChar): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTyped_RW' {$ENDIF} {$ENDIF};
  {* Convenience functions *}
function IMG_Load(_file: PAnsiChar): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_Load' {$ENDIF} {$ENDIF};
function IMG_Load_RW(src: PSDL_RWops; freesrc: SInt32): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_Load_RW' {$ENDIF} {$ENDIF};

  {* Load an image directly into a render texture. *}
function IMG_LoadTexture(renderer: PSDL_Renderer; _file: PAnsiChar): PSDL_Texture cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTexture' {$ENDIF} {$ENDIF};
function IMG_LoadTexture_RW(renderer: PSDL_Renderer; src: PSDL_RWops; freesrc: SInt32): PSDL_Texture cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTexture_RW' {$ENDIF} {$ENDIF};
function IMG_LoadTextureTyped_RW(renderer: PSDL_Renderer; src: PSDL_RWops; freesrc: SInt32; _type: PAnsiChar): PSDL_Texture cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTextureTyped_RW' {$ENDIF} {$ENDIF};

  {* Functions to detect a file type, given a seekable source *}
function IMG_isICO(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isICO' {$ENDIF} {$ENDIF};
function IMG_isCUR(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isCUR' {$ENDIF} {$ENDIF};
function IMG_isBMP(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isBMP' {$ENDIF} {$ENDIF};
function IMG_isGIF(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isGIF' {$ENDIF} {$ENDIF};
function IMG_isJPG(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isJPG' {$ENDIF} {$ENDIF};
function IMG_isLBM(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isLBM' {$ENDIF} {$ENDIF};
function IMG_isPCX(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isPCX' {$ENDIF} {$ENDIF};
function IMG_isPNG(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isPNG' {$ENDIF} {$ENDIF};
function IMG_isPNM(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isPNM' {$ENDIF} {$ENDIF};
function IMG_isTIF(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isTIF' {$ENDIF} {$ENDIF};
function IMG_isXCF(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '-IMG_isXCF' {$ENDIF} {$ENDIF};
function IMG_isXPM(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isXPM' {$ENDIF} {$ENDIF};
function IMG_isXV(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isXV' {$ENDIF} {$ENDIF};
function IMG_isWEBP(src: PSDL_RWops): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_isWEBP' {$ENDIF} {$ENDIF};

  {* Individual loading functions *}
function IMG_LoadICO_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadICO_RW' {$ENDIF} {$ENDIF};
function IMG_LoadCUR_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadCUR_RW' {$ENDIF} {$ENDIF};
function IMG_LoadBMP_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadBMP_RW' {$ENDIF} {$ENDIF};
function IMG_LoadGIF_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadGIF_RW' {$ENDIF} {$ENDIF};
function IMG_LoadJPG_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadJPG_RW' {$ENDIF} {$ENDIF};
function IMG_LoadLBM_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadLBM_RW' {$ENDIF} {$ENDIF};
function IMG_LoadPCX_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadPCX_RW' {$ENDIF} {$ENDIF};
function IMG_LoadPNG_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadPNG_RW' {$ENDIF} {$ENDIF};
function IMG_LoadPNM_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadPNM_RW' {$ENDIF} {$ENDIF};
function IMG_LoadTGA_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTGA_RW' {$ENDIF} {$ENDIF};
function IMG_LoadTIF_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadTIF_RW' {$ENDIF} {$ENDIF};
function IMG_LoadXCF_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadXCF_RW' {$ENDIF} {$ENDIF};
function IMG_LoadXPM_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadXMP_RW' {$ENDIF} {$ENDIF};
function IMG_LoadXV_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadXV_RW' {$ENDIF} {$ENDIF};
function IMG_LoadWEBP_RW(src: PSDL_RWops): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_LoadWEBP_RW' {$ENDIF} {$ENDIF};

function IMG_ReadXPMFromArray(xpm: PPChar): PSDL_Surface cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_ReadXPMFromArray' {$ENDIF} {$ENDIF};

  {* Individual saving functions *}
function IMG_SavePNG(surface: PSDL_Surface; const _file: PAnsiChar): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_SavePNG' {$ENDIF} {$ENDIF};
function IMG_SavePNG_RW(surface: PSDL_Surface; dst: PSDL_RWops; freedst: SInt32): SInt32 cdecl; external IMG_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_IMG_SavePNG_RW' {$ENDIF} {$ENDIF};

{* We'll use SDL for reporting errors *}
function IMG_SetError(fmt: PAnsiChar): SInt32; cdecl;
function IMG_GetError: PAnsiChar; cdecl;

implementation

procedure SDL_IMAGE_VERSION(Out X: TSDL_Version);
begin
  X.major := SDL_IMAGE_MAJOR_VERSION;
  X.minor := SDL_IMAGE_MINOR_VERSION;
  X.patch := SDL_IMAGE_PATCHLEVEL;
end;

function IMG_SetError(fmt: PAnsiChar): SInt32; cdecl;
begin
  Result := SDL_SetError(fmt);
end;

function IMG_GetError: PAnsiChar; cdecl;
begin
  Result := SDL_GetError();
end;

end.
