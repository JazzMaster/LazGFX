unit GLContext;

{$IFDEF FPC}
{$mode delphi}
{$ELSE} //Delphi
{$IFDEF MSWINDOWS}
  {$DEFINE WINDOWS}
{$ENDIF}
{$ENDIF}

interface

uses
  SysUtils, Controls, dglOpenGL;

type
  TMultiSample = 1..high(byte);
  TglcContextPixelFormatSettings = packed record
    DoubleBuffered: boolean;
    Stereo: boolean;
    MultiSampling: TMultiSample;
    ColorBits: Integer;
    DepthBits: Integer;
    StencilBits: Integer;
    AccumBits: Integer;
    AuxBuffers: Integer;
    Layer: Integer;
  end;

  TglcDisplayFlag = (
    dfFullscreen);
  TglcDisplayFlags = set of TglcDisplayFlag;

  EGLError = class(Exception);

  { TGLContext }
  TGLContextClass = class of TGLContext;
  TGLContext = class
  private
    FControl: TWinControl;
    function GetEnableVSync: Boolean;
    procedure SetEnableVSync(aValue: Boolean);
  protected
    procedure OpenContext(FormatSettings: TglcContextPixelFormatSettings); virtual; abstract;
    procedure CloseContext; virtual; abstract;
  public
    class function MakePF(DoubleBuffered: boolean = true;
                          Stereo: boolean=false;
                          MultiSampling: TMultiSample=1;
                          ColorBits: Integer=32;
                          DepthBits: Integer=24;
                          StencilBits: Integer=0;
                          AccumBits: Integer=0;
                          AuxBuffers: Integer=0;
                          Layer: Integer=0): TglcContextPixelFormatSettings;
    class function GetPlatformClass: TGLContextClass;
    class function ChangeDisplaySettings(const aWidth, aHeight,
      aBitPerPixel, aFreq: Integer; const aFlags: TglcDisplayFlags): Boolean; virtual; abstract;
    class function IsAnyContextActive: boolean; virtual;

    constructor Create(aControl: TWinControl);
    destructor Destroy; override;

    property Control: TWinControl read FControl;

    procedure BuildContext(FormatSettings: TglcContextPixelFormatSettings);
    procedure Activate; virtual; abstract;
    procedure Deactivate; virtual; abstract;
    function IsActive: boolean; virtual; abstract;
    procedure SwapBuffers; virtual; abstract;
    procedure SetSwapInterval(const aInterval: GLint); virtual; abstract;
    function GetSwapInterval: GLint; virtual; abstract;
    procedure Share(const aContext: TGLContext); virtual; abstract;
  end;

implementation

uses
  {$IFDEF WINDOWS}
    GLContextWGL
  {$ENDIF}
  {$IFDEF LINUX}
    GLContextGtk2GLX
  {$ENDIF}
  ;


{ TGLontext }

function TGLContext.GetEnableVSync: Boolean;
begin
  result := (GetSwapInterval() <> 0);
end;

procedure TGLContext.SetEnableVSync(aValue: Boolean);
begin
  if aValue then
    SetSwapInterval(1)
  else
    SetSwapInterval(0);
end;

class function TGLContext.MakePF(DoubleBuffered: boolean; Stereo: boolean;
  MultiSampling: TMultiSample; ColorBits: Integer; DepthBits: Integer; StencilBits: Integer;
  AccumBits: Integer; AuxBuffers: Integer; Layer: Integer): TglcContextPixelFormatSettings;
begin
  Result.DoubleBuffered:= DoubleBuffered;
  Result.Stereo:= Stereo;
  Result.MultiSampling:= MultiSampling;
  Result.ColorBits:= ColorBits;
  Result.DepthBits:= DepthBits;
  Result.StencilBits:= StencilBits;
  Result.AccumBits:= AccumBits;
  Result.AuxBuffers:= AuxBuffers;
  Result.Layer:= Layer;
end;

class function TGLContext.GetPlatformClass: TGLContextClass;
begin
  {$IFDEF WINDOWS}
  Result:= TGLContextWGL;
  {$ENDIF}
  {$IFDEF LINUX}
  Result:= TGLContextGtk2GLX;
  {$ENDIF}
end;

class function TGLContext.IsAnyContextActive: boolean;
begin
  Result:= GetPlatformClass.IsAnyContextActive;
end;

constructor TGLContext.Create(aControl: TWinControl);
begin
  inherited Create;
  FControl:= aControl;
  InitOpenGL();
end;

destructor TGLContext.Destroy;
begin
  CloseContext;
  inherited Destroy;
end;

procedure TGLContext.BuildContext(FormatSettings: TglcContextPixelFormatSettings);
begin
  OpenContext(FormatSettings);
  Activate;
  ReadImplementationProperties;
  ReadExtensions;
end;

end.
