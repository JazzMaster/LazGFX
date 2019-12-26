Unit DDraw-mac;
//Core 2DBGI API for Laz GFX for OSX Quicktime DirectDraw 2D API
//may have to run this thru codewarrior, not fpc. FPC has issues installing and assumes a non-existant console.
//further: OS9 chunks are 68k code, not PowerPC(explains the OS limitations).

{//codewarrior/mpw mode:  mode macpas}

interface

uses
//    MacOSALL;

{$IFDEF darwin}
	{$linkframework Cocoa}
	{$linklib gcc}
    {$modeswitch objectivec1}
{$ENDIF}

implementation


begin

end.
