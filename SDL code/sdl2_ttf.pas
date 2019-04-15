unit sdl2_ttf;

{*
  SDL_ttf:  A companion library to SDL for working with TrueType (tm) fonts
  Copyright (C) 2001-2013 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgement in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*}

{* This library is a wrapper around the excellent FreeType 2.0 library,
   available at:
    http://www.freetype.org/
*}

{* ChangeLog: (Header Translation)
   ----------

   v.1.72-stable; 29.09.2013: fixed bug with procedures without parameters
                              (they must have brackets)
   v.1.70-stable; 11.09.2013: Initial Commit

*}

interface


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


uses
  SDL2;

const
  {$IFDEF WINDOWS}
    TTF_LibName = 'SDL2_ttf.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      TTF_LibName = 'libSDL2_tff.dylib';
    {$ELSE}
      {$IFDEF FPC}
        TTF_LibName = 'libSDL2_ttf.so';
      {$ELSE}
        TTF_LibName = 'libSDL2_ttf.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    TTF_LibName = 'SDL2_ttf';
    {$IFDEF FPC}
      {$linklib libSDL2_ttf}
    {$ENDIF}
  {$ENDIF}

{* Set up for C function definitions, even when using C++ *}

{* Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL *}
const
  SDL_TTF_MAJOR_VERSION = 2;
  SDL_TTF_MINOR_VERSION = 0;
  SDL_TTF_PATCHLEVEL    = 12;

Procedure SDL_TTF_VERSION(Out X:TSDL_Version);

{* Backwards compatibility *}
const
  TTF_MAJOR_VERSION = SDL_TTF_MAJOR_VERSION;
  TTF_MINOR_VERSION = SDL_TTF_MINOR_VERSION;
  TTF_PATCHLEVEL    = SDL_TTF_PATCHLEVEL;
  //TTF_VERSION(X)    = SDL_TTF_VERSION(X);

 {* This function gets the version of the dynamically linked SDL_ttf library.
   it should NOT be used to fill a version structure, instead you should
   use the SDL_TTF_VERSION() macro.
 *}
function TTF_Linked_Version: TSDL_Version cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Linked_Version' {$ENDIF} {$ENDIF};

{* ZERO WIDTH NO-BREAKSPACE (Unicode byte order mark) *}
const
  UNICODE_BOM_NATIVE  = $FEFF;
  UNICODE_BOM_SWAPPED = $FFFE;

{* This function tells the library whether UNICODE text is generally
   byteswapped.  A UNICODE BOM character in a string will override
   this setting for the remainder of that string.
*}
procedure TTF_ByteSwappedUNICODE(swapped: Integer) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_ByteSwappedUNICODE' {$ENDIF} {$ENDIF};

{* The internal structure containing font information *}
type
  PTTF_Font = ^TTTF_Font;
  TTTF_Font = record  end; //todo?

{* Initialize the TTF engine - returns 0 if successful, -1 on error *}
function TTF_Init(): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Init' {$ENDIF} {$ENDIF};

{* Open a font file and create a font of the specified point size.
 * Some .fon fonts will have several sizes embedded in the file, so the
 * point size becomes the index of choosing which size.  If the value
 * is too high, the last indexed size will be the default. *}
function TTF_OpenFont(_file: PAnsiChar; ptsize: Integer): PTTF_Font cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFont' {$ENDIF} {$ENDIF};
function TTF_OpenFontIndex(_file: PAnsiChar; ptsize: Integer; index: LongInt): PTTF_Font cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndex' {$ENDIF} {$ENDIF};
function TTF_OpenFontRW(src: PSDL_RWops; freesrc: Integer; ptsize: LongInt): PTTF_Font cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontRW' {$ENDIF} {$ENDIF};
function TTF_OpenFontIndexRW(src: PSDL_RWops; freesrc: Integer; ptsize: Integer; index: LongInt): PTTF_Font cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndexRW' {$ENDIF} {$ENDIF};

{* Set and retrieve the font style *}
const
  TTF_STYLE_NORMAL        = $00;
  TTF_STYLE_BOLD          = $01;
  TTF_STYLE_ITALIC        = $02;
  TTF_STYLE_UNDERLINE     = $04;
  TTF_STYLE_STRIKETHROUGH = $08;

function TTF_GetFontStyle(font: PTTF_Font): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontStyle' {$ENDIF} {$ENDIF};
procedure TTF_SetFontStyle(font: PTTF_Font; style: Integer) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontStyle' {$ENDIF} {$ENDIF};
function TTF_GetFontOutline(font: PTTF_Font): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontOutline' {$ENDIF} {$ENDIF};
procedure TTF_SetFontOutline(font: PTTF_Font; outline: Integer) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontOutline' {$ENDIF} {$ENDIF};

{* Set and retrieve FreeType hinter settings *}
const
  TTF_HINTING_NORMAL  = 0;
  TTF_HINTING_LIGHT   = 1;
  TTF_HINTING_MONO    = 2;
  TTF_HINTING_NONE    = 3;

function TTF_GetFontHinting(font: PTTF_Font): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontHinting' {$ENDIF} {$ENDIF};
procedure TTF_SetFontHinting(font: PTTF_Font; hinting: Integer) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontHinting' {$ENDIF} {$ENDIF};

{* Get the total height of the font - usually equal to point size *}
function TTF_FontHeight(font: PTTF_Font): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontHeight' {$ENDIF} {$ENDIF};

{* Get the offset from the baseline to the top of the font
   This is a positive value, relative to the baseline.
 *}
function TTF_FontAscent(font: PTTF_Font): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontAscent' {$ENDIF} {$ENDIF};

{* Get the offset from the baseline to the bottom of the font
   This is a negative value, relative to the baseline.
 *}
function TTF_FontDescent(font: PTTF_Font): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontDescent' {$ENDIF} {$ENDIF};

{* Get the recommended spacing between lines of text for this font *}
function TTF_FontLineSkip(font: PTTF_Font): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontLineSkip' {$ENDIF} {$ENDIF};

{* Get/Set whether or not kerning is allowed for this font *}
function TTF_GetFontKerning(font: PTTF_Font): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerning' {$ENDIF} {$ENDIF};
procedure TTF_SetFontKerning(font: PTTF_Font; allowed: Integer) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontKerning' {$ENDIF} {$ENDIF};

{* Get the number of faces of the font *}
function TTF_FontFaces(font: PTTF_Font): LongInt cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaces' {$ENDIF} {$ENDIF};

{* Get the font face attributes, if any *}
function TTF_FontFaceIsFixedWidth(font: PTTF_Font): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaceIsFixedWidth' {$ENDIF} {$ENDIF};
function TTF_FontFaceFamilyName(font: PTTF_Font): PAnsiChar cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaceFamilyName' {$ENDIF} {$ENDIF};
function TTF_FontFaceStyleName(font: PTTF_Font): PAnsiChar cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaceStyleName' {$ENDIF} {$ENDIF};

{* Check wether a glyph is provided by the font or not *}
function TTF_GlyphIsProvided(font: PTTF_Font; ch: UInt16): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphIsProvided' {$ENDIF} {$ENDIF};

{* Get the metrics (dimensions) of a glyph
   To understand what these metrics mean, here is a useful link:
    http://freetype.sourceforge.net/freetype2/docs/tutorial/step2.html
 *}
function TTF_GlyphMetrics(font: PTTF_Font; ch: UInt16;
                          minx, maxx: PInt;
                          miny, maxy: PInt; advance: PInt): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphMetrics' {$ENDIF} {$ENDIF};

{* Get the dimensions of a rendered string of text *}
function TTF_SizeText(font: PTTF_Font; text: PAnsiChar; w, h: PInt): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SizeText' {$ENDIF} {$ENDIF};
function TTF_SizeUTF8(font: PTTF_Font; text: PAnsiChar; w, h: PInt): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SizeUTF8' {$ENDIF} {$ENDIF};
function TTF_SizeUNICODE(font: PTTF_Font; text: PUInt16; w, h: PInt): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SizeUNICODE' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Solid(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Solid' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Solid(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Solid' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Solid(font: PTTF_Font; text: PUInt16; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Solid' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given glyph at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.  The glyph is rendered without any padding or
   centering in the X direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderGlyph_Solid(font: PTTF_Font; ch: UInt16; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Solid' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Shaded(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Shaded' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Shaded(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Shaded' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Shaded(font: PTTF_Font; text: PUInt16; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Shaded' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given glyph at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   The glyph is rendered without any padding or centering in the X
   direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderGlyph_Shaded(font: PTTF_Font; ch: UInt16; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Shaded' {$ENDIF} {$ENDIF};

{* Create a 32-bit ARGB surface and render the given text at high quality,
   using alpha blending to dither the font with the given color.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Blended(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Blended' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Blended(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Blended' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Blended(font: PTTF_Font; text: PUInt16; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Blended' {$ENDIF} {$ENDIF};

{* Create a 32-bit ARGB surface and render the given text at high quality,
   using alpha blending to dither the font with the given color.
   Text is wrapped to multiple lines on line endings and on word boundaries
   if it extends beyond wrapLength in pixels.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Blended_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: UInt32): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Blended_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Blended_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: UInt32): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Blended_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Blended_Wrapped(font: PTTF_Font; text: PUInt16; fg: TSDL_Color; wrapLength: UInt32): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Blended_Wrapped' {$ENDIF} {$ENDIF};

{* Create a 32-bit ARGB surface and render the given glyph at high quality,
   using alpha blending to dither the font with the given color.
   The glyph is rendered without any padding or centering in the X
   direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderGlyph_Blended(font: PTTF_Font; ch: UInt16; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Blended' {$ENDIF} {$ENDIF};

{* For compatibility with previous versions, here are the old functions *}
function TTF_RenderText(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
function TTF_RenderUTF8(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
function TTF_RenderUNICODE(font: PTTF_Font; text: PUInt16; fg, bg: TSDL_Color): PSDL_Surface;

{* Close an opened font file *}
procedure TTF_CloseFont(font: PTTF_Font) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CloseFont' {$ENDIF} {$ENDIF};

{* De-initialize the TTF engine *}
procedure TTF_Quit() cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Quit' {$ENDIF} {$ENDIF};

{* Check if the TTF engine is initialized *}
function TTF_WasInit: Boolean cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_WasInit' {$ENDIF} {$ENDIF};

{* Get the kerning size of two glyphs *}
function TTF_GetFontKerningSize(font: PTTF_Font; prev_index, index: Integer): Integer cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerningSize' {$ENDIF} {$ENDIF};

{* We'll use SDL for reporting errors *}
function TTF_SetError(const fmt: PAnsiChar): SInt32; cdecl;
function TTF_GetError: PAnsiChar; cdecl;

implementation

Procedure SDL_TTF_VERSION(Out X:TSDL_Version);
begin
  x.major := SDL_TTF_MAJOR_VERSION;
  x.minor := SDL_TTF_MINOR_VERSION;
  x.patch := SDL_TTF_PATCHLEVEL;
end;

function TTF_SetError(const fmt: PAnsiChar): SInt32; cdecl;
begin
  Result := SDL_SetError(fmt);
end;

function TTF_GetError: PAnsiChar; cdecl;
begin
  Result := SDL_GetError();
end;

function TTF_RenderText(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
begin
  Result := TTF_RenderText_Shaded(font, text, fg, bg);
end;

function TTF_RenderUTF8(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
begin
  Result := TTF_RenderUTF8_Shaded(font, text, fg, bg);
end;

function TTF_RenderUNICODE(font: PTTF_Font; text: PUInt16; fg, bg: TSDL_Color): PSDL_Surface;
begin
  Result := TTF_RenderUNICODE_Shaded(font, text, fg, bg);
end;

end.

