unit sdl2;

{
  Simple DirectMedia Layer
  Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>

  Pascal-Header-Conversion
  Copyright (C) 2012-2017 Tim Blume aka End/EV1313

  SDL.pas is based on the files:
  "sdl.h",
  "sdl_audio.h",
  "sdl_blendmode.h",
  "sdl_clipboard.h",
  "sdl_cpuinfo.h",
  "sdl_events.h",
  "sdl_error.h",
  "sdl_filesystem.h",
  "sdl_gamecontroller.h",
  "sdl_gesture.h",
  "sdl_haptic.h",
  "sdl_hints.h",
  "sdl_joystick.h",
  "sdl_keyboard.h",
  "sdl_keycode.h",
  "sdl_loadso.h",
  "sdl_log.h",
  "sdl_pixels.h",
  "sdl_power.h",
  "sdl_main.h",
  "sdl_messagebox.h",
  "sdl_mouse.h",
  "sdl_mutex.h",
  "sdl_rect.h",
  "sdl_render.h",
  "sdl_rwops.h",
  "sdl_scancode.h",
  "sdl_shape.h",
  "sdl_stdinc.h",
  "sdl_surface.h",
  "sdl_system.h",
  "sdl_syswm.h",
  "sdl_thread.h",
  "sdl_timer.h",
  "sdl_touch.h",
  "sdl_version.h",
  "sdl_video.h",
  "sdl_types.h"

  I will not translate:
  "sdl_opengl.h",
  "sdl_opengles.h"
  "sdl_opengles2.h"

  The OpenGL header defs at opengl.comare found here: 
		https://github.com/SaschaWillems/dglOpenGL

  Parts of the SDL.pas are from the SDL-1.2-Header conversion from the JEDI-Team,
  written by Domenique Louis and others.

  I've changed the names of the dll for 32 & 64-Bit, so theres no conflict
  between 32 & 64 bit Libraries.

  This software is provided 'as-is', without any express or implied
  warranty.  In no case will the authors be held liable for any damages
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

  Special Thanks to:

   - DelphiGL.com - Community
   - Domenique Louis and everyone else from the JEDI-Team
   - Sam Latinga and everyone else from the SDL-Team

 Code cleaned up by Richard Jasmin
}

{$DEFINE SDL}

{$IFNDEF FPC}
  {$IFDEF Debug}
    {$F+,D+,Q-,L+,R+,I-,S+,Y+,A+}
  {$ELSE}
    {$F+,Q-,R-,S-,I-,A+}
  {$ENDIF}
{$ELSE}
  {$MODE DELPHI} //dont force delphi mode unless using it- JEDI is slanted torawrds that, which is wrong.
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


interface

//SDL shouldnt assume. It should probe.
//for BGI use: I set up the environment.
//So assume its sane.
//--Jazz

const

  {$IFDEF WINDOWS}
    SDL_LibName = 'SDL2.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      SDL_LibName = 'libSDL2.dylib';
    {$ELSE}
      {$IFDEF FPC}
        SDL_LibName = 'libSDL2.so';
      {$ELSE}
        SDL_LibName = 'libSDL2.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    SDL_LibName = 'SDL2';
    {$IFDEF FPC}
      {$linklib libSDL2}
    {$ENDIF}
  {$ENDIF}

{$I sdltype.inc}
{$I sdlversion.inc}
{$I sdlerror.inc}
{$I sdlplatform.inc}
{$I sdlpower.inc}
{$I sdlthread.inc}
{$I sdlmutex.inc}
{$I sdltimer.inc}
{$I sdlpixels.inc}
{$I sdlrect.inc}
{$I sdlrwops.inc}
{$I sdlaudio.inc}
{$I sdlblendmode.inc}
{$I sdlsurface.inc}
{$I sdlshape.inc}
{$I sdlvideo.inc}
{$I sdlhints.inc}
{$I sdlloadso.inc}
{$I sdlmessagebox.inc}
{$I sdlrenderer.inc}
{$I sdlscancode.inc}
{$I sdlkeyboard.inc}
{$I sdlmouse.inc}
{$I sdljoystick.inc}
{$I sdlgamecontroller.inc}
{$I sdlhaptic.inc}
{$I sdltouch.inc}
{$I sdlgesture.inc}
{$I sdlsyswm.inc}
{$I sdlevents.inc}
{$I sdlclipboard.inc}
{$I sdlcpuinfo.inc}
{$I sdlfilesystem.inc}
{$I sdlsystem.inc}
{$I sdl.inc}

implementation

//who really cares?
procedure SDL_VERSION(Out x: TSDL_Version);
begin
  x.major := SDL_MAJOR_VERSION;
  x.minor := SDL_MINOR_VERSION;
  x.patch := SDL_PATCHLEVEL;
end;

function SDL_Button(button: SInt32): SInt32;
begin
  Result := 1 shl (button - 1); 
end;

{$IFDEF WINDOWS}

//overloaded wrappers shouldnt use the same name- its confusing.
function SDL_WinCreateThread(fn: TSDL_ThreadFunction; name: PAnsiChar; data: Pointer): PSDL_Thread; overload;
begin
  Result := SDL_CreateThread(fn,name,data,nil,nil);
end;

{$ENDIF}


//SDL context ops(framebuffer? VTerm?)
function SDL_RWsize(ctx: PSDL_RWops): SInt64;
begin
  Result := ctx^.size(ctx);
end;

function SDL_RWseek(ctx: PSDL_RWops; offset: SInt64; whence: SInt32): SInt64;
begin
  Result := ctx^.seek(ctx,offset,whence);
end;

function SDL_RWtell(ctx: PSDL_RWops): SInt64;
begin
  Result := ctx^.seek(ctx, 0, RW_SEEK_CUR);
end;

function SDL_RWread(ctx: PSDL_RWops; ptr: Pointer; size: size_t; n: size_t): size_t;
begin
  Result := ctx^.read(ctx, ptr, size, n);
end;

function SDL_RWwrite(ctx: PSDL_RWops; ptr: Pointer; size: size_t; n: size_t): size_t;
begin
  Result := ctx^.write(ctx, ptr, size, n);
end;

function SDL_RWclose(ctx: PSDL_RWops): SInt32;
begin
  Result := ctx^.close(ctx);
end;


end.
