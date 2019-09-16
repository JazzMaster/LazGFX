Unit d2d;

//Core 2DBGI API for Laz GFX for Direct2D (modern Windows DirectDraw Interface)
//Focus is DX9- it can be updated to Vulkan/DX12, and older DX can be updated to it.


interface

uses  
  Windows, Classes, SysUtils, LResources, Forms,  Dialogs,  ExtCtrls,  // standard stuff
  Direct3D8, // the DirectX units
  D3DX8,
  Directinput,
  DirectMusic,
  DirectSound,
  MMsystem,typinfo; //Core audio subsystem

{$IFDEF LCL}
	{$IFDEF LCLGTK2}
		gtk2,
	{$ENDIF}

	{$IFDEF LCLQT}
		qtwidgets,
	{$ENDIF}

	  //works on Linux+Qt but not windows??? I have WINE and a VM- lets figure it out.
      LazUtils,  Interfaces, Dialogs, LCLType,Forms,Controls, 
    {$IFDEF MSWINDOWS}
       //we will check if this is set later.
      {$DEFINE NOCONSOLE }
    {$ENDIF}

{$ENDIF}

{$IFNDEF NOCONSOLE}
    crt,crtstuff,
{$ENDIF}

{$IFDEF debug} ,heaptrc {$ENDIF} 

implementation


begin

end.
