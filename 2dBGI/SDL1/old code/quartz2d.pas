Unit Quartz2d;
//Core 2DBGI API for Laz GFX for OSX Quartz 2D API

{$mode objfpc}
//modeswitch -something-

interface

uses
    MacOSALL;

{$IFDEF darwin}
	{$linkframework Cocoa}
	{$linklib gcc}

{$modeswitch objectivec2}
{$ENDIF}

implementation


begin

end.
