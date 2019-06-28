unit GLContextWGL;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, Windows, GLContext, dglOpenGL;

type
  EWGLError = class(EGLError);

  { TGLContextWGL }

  TGLContextWGL = class(TGLContext)
  private
    FDC: HDC;
    FRC: HGLRC;
  protected
    procedure CloseContext; override;
    procedure OpenContext(FormatSettings: TglcContextPixelFormatSettings); override;
    function FindPixelFormat(FormatSettings: TglcContextPixelFormatSettings): Integer;
    function FindPixelFormatNoAA(FormatSettings: TglcContextPixelFormatSettings): Integer;
    procedure OpenFromPF(PixelFormat: Integer);
  public
    procedure Activate; override;
    procedure Deactivate; override;
    function IsActive: boolean; override;
    procedure SwapBuffers; override;
    procedure SetSwapInterval(const aInterval: GLint); override;
    function GetSwapInterval: GLint; override;
    procedure Share(const aContext: TGLContext); override;

    class function ChangeDisplaySettings(const aWidth, aHeight, aBitPerPixel, aFreq: Integer;
      const aFlags: TglcDisplayFlags): Boolean; override;
    class function IsAnyContextActive: boolean; override;
  end;

implementation

{ TGLContextWGL }

procedure TGLContextWGL.OpenContext(FormatSettings: TglcContextPixelFormatSettings);
var
  pf: integer;
begin
  pf:= FindPixelFormat(FormatSettings);
  if pf=0 then begin
    // try without MS
    FormatSettings.MultiSampling:= 1;
    pf:= FindPixelFormat(FormatSettings);
  end;

  OpenFromPF(pf);
end;

function TGLContextWGL.FindPixelFormat(FormatSettings: TglcContextPixelFormatSettings): Integer;
var
  OldRC: HGLRC; OldDC: HDC;
  tmpWnd: TForm;
  tmpContext: TGLContextWGL;
  pf, Count, i, max: integer;
  PFList, SampleList: array[0..31] of glInt;

  procedure ChoosePF(pPFList, pSampleList: PGLint; MaxCount: integer);
  var
    //ARB_Erweiterung vorhanden
    //|          EXT_Erweiterung vorhanden
    MultiARBSup, MultiEXTSup: Boolean;
    //Liste der Integer Attribute
    IAttrib: array[0..22] of Integer;
    //Liste der Float Attribute (nur 0, da kein Wert)
    FAttrib: GLFloat;
    QueryAtrib, i: Integer;
    PPosiblePF, PSample: PglInt;
  begin
    //Pixelformate mit AA auslesen
    MultiARBSup := false;
    MultiEXTSup := false;
    if WGL_ARB_extensions_string and
       WGL_ARB_pixel_format and
       (WGL_ARB_MULTISAMPLE or GL_ARB_MULTISAMPLE) then
      multiARBSup := true;
    if WGL_EXT_extensions_string and
       WGL_EXT_pixel_format and
       (WGL_EXT_MULTISAMPLE or GL_EXT_MULTISAMPLE) then
      multiEXTSup := true;

    if multiARBSup then
      Read_WGL_ARB_pixel_format
    else if multiEXTSup then
      Read_WGL_EXT_pixel_format;

    if not (MultiARBSup or MultiEXTSup) then
      exit;

    IAttrib[00] := WGL_DRAW_TO_WINDOW_ARB;
    IAttrib[01] := 1;

    IAttrib[02] := WGL_SUPPORT_OPENGL_ARB;
    IAttrib[03] := 1;

    IAttrib[04] := WGL_DOUBLE_BUFFER_ARB;
    if (FormatSettings.DoubleBuffered) then
      IAttrib[05] := 1
    else
      IAttrib[05] := 0;

    IAttrib[06] := WGL_PIXEL_TYPE_ARB;
    IAttrib[07] := WGL_TYPE_RGBA_ARB;

    IAttrib[08] := WGL_COLOR_BITS_ARB;
    IAttrib[09] := FormatSettings.ColorBits;

    IAttrib[10] := WGL_ALPHA_BITS_ARB;
    IAttrib[11] := 0; //TODO: FormatSettings.AlphaBits;

    IAttrib[12] := WGL_DEPTH_BITS_ARB;
    IAttrib[13] := FormatSettings.DepthBits;

    IAttrib[14] := WGL_STENCIL_BITS_ARB;
    IAttrib[15] := FormatSettings.StencilBits;

    IAttrib[16] := WGL_ACCUM_BITS_ARB;
    IAttrib[17] := FormatSettings.AccumBits;

    IAttrib[18] := WGL_AUX_BUFFERS_ARB;
    IAttrib[19] := FormatSettings.AuxBuffers;

    IAttrib[20] := WGL_SAMPLE_BUFFERS_ARB;
    IAttrib[21] := 1;

    IAttrib[22] := 0;
    FAttrib     := 0;

    if multiARBSup then
      wglChoosePixelFormatARB(tmpContext.FDC, @IAttrib, @FAttrib, MaxCount, pPFList, @Count)
    else if multiEXTSup then
      wglChoosePixelFormatEXT(tmpContext.FDC, @IAttrib, @FAttrib, MaxCount, pPFList, @Count);

    if Count > length(PFList) then
      Count := length(PFList);

    QueryAtrib := WGL_SAMPLES_ARB;
    PSample    := pSampleList;
    PPosiblePF := @PFList[0];
    for i := 0 to Count-1 do begin
      if multiARBSup then
        wglGetPixelFormatAttribivARB(tmpContext.FDC, PPosiblePF^, 0, 1, @QueryAtrib, PSample)
      else if multiEXTSup then
        wglGetPixelFormatAttribivEXT(tmpContext.FDC, PPosiblePF^, 0, 1, @QueryAtrib, PSample);
      inc(PSample);
      inc(PPosiblePF);
    end;
  end;
begin
  if FormatSettings.MultiSampling=1 then begin
    Result:= FindPixelFormatNoAA(FormatSettings);
    exit;
  end;
  Result:= 0;

  OldDC:= wglGetCurrentDC();
  OldRC:= wglGetCurrentContext();
  try
    tmpWnd:= TForm.Create(nil);
    tmpContext:= TGLContextWGL.Create(tmpWnd);
    try
      pf := tmpContext.FindPixelFormatNoAA(FormatSettings);
      tmpContext.OpenFromPF(pf);
      tmpContext.Activate;

      FillChar({%H-}PFList[0], Length(PFList), 0);
      FillChar({%H-}SampleList[0], Length(SampleList), 0);
      ChoosePF(@PFList[0], @SampleList[0], length(SampleList));
      max := 0;
      for i := 0 to Count-1 do begin
        if (max < SampleList[i]) and (SampleList[i] <= FormatSettings.MultiSampling) and (PFList[i] <> 0) then begin
          max := SampleList[i];
          result := PFList[i];
          if (max = FormatSettings.MultiSampling) then
            break;
        end;
      end;
      tmpContext.Deactivate;
    finally
      FreeAndNil(tmpContext);
      FreeAndNil(tmpWnd);
    end;
  finally
    if (OldDC <> 0) and (OldRC <> 0) then
     ActivateRenderingContext(OldDC, OldRC);
  end;
end;

function TGLContextWGL.FindPixelFormatNoAA(FormatSettings: TglcContextPixelFormatSettings): Integer;
const
  MemoryDCs = [OBJ_MEMDC, OBJ_METADC, OBJ_ENHMETADC];
var
  //DeviceContext
  DC: HDC;
  //Objekttyp des DCs
  AType: DWord;
  //Beschreibung zum passenden Pixelformat
  PFDescriptor: TPixelFormatDescriptor;
begin
  result := 0;
  DC := GetDC(Control.Handle);
  if DC = 0 then begin
    exit;
  end;
  FillChar(PFDescriptor{%H-}, SizeOf(PFDescriptor), #0);
  with PFDescriptor do begin
    nSize    := SizeOf(PFDescriptor);
    nVersion := 1;
    dwFlags  := PFD_SUPPORT_OPENGL;
    AType    := GetObjectType(DC);
    if AType = 0 then begin
      exit;
    end;
    if FormatSettings.DoubleBuffered then dwFlags := dwFlags or PFD_DOUBLEBUFFER;
    if FormatSettings.Stereo then dwFlags := dwFlags or PFD_STEREO;
    if AType            in MemoryDCs then dwFlags := dwFlags or PFD_DRAW_TO_BITMAP
                                     else dwFlags := dwFlags or PFD_DRAW_TO_WINDOW;

    iPixelType   := PFD_TYPE_RGBA;
    cColorBits   := FormatSettings.ColorBits;
//    cAlphaBits   := FormatSettings.AlphaBits; //TODO
    cDepthBits   := FormatSettings.DepthBits;
    cStencilBits := FormatSettings.StencilBits;
    cAccumBits   := FormatSettings.AccumBits;
    cAuxBuffers  := FormatSettings.AuxBuffers;

    if FormatSettings.Layer = 0 then
      iLayerType := PFD_MAIN_PLANE
    else if FormatSettings.Layer > 0 then
      iLayerType := PFD_OVERLAY_PLANE
    else
      iLayerType := Byte(PFD_UNDERLAY_PLANE);
  end;
  result := ChoosePixelFormat(DC, @PFDescriptor);
end;

procedure TGLContextWGL.OpenFromPF(PixelFormat: Integer);
begin
  if PixelFormat = 0 then begin
    raise EWGLError.Create('Invalid PixelFormat');
  end;

  FDC := GetDC(Control.Handle);
  if FDC = 0 then begin
    raise EWGLError.CreateFmt('Cannot create DC on %x',[Control.Handle]);
  end;

  if not SetPixelFormat(FDC, PixelFormat, nil) then begin
    ReleaseDC(Control.Handle, FDC);
    raise EWGLError.CreateFmt('Cannot set PF %d on Control %x DC %d',[PixelFormat, Control.Handle, FDC]);
  end;

  FRC := wglCreateContext(FDC);
  if FRC = 0 then begin
    ReleaseDC(Control.Handle, FDC);
    raise EWGLError.CreateFmt('Cannot create context on Control %x DC %d',[PixelFormat, Control.Handle, FDC]);
  end;
end;

procedure TGLContextWGL.CloseContext;
begin
  Deactivate;
  DestroyRenderingContext(FRC);
  ReleaseDC(Control.Handle, FDC);
  FRC:= 0;
  FDC:= 0;
end;

procedure TGLContextWGL.Activate;
begin
  ActivateRenderingContext(FDC, FRC);
end;

procedure TGLContextWGL.Deactivate;
begin
  if wglGetCurrentContext()=FRC then
    DeactivateRenderingContext;
end;

function TGLContextWGL.IsActive: boolean;
begin
  Result:= (FRC = wglGetCurrentContext()) and
           (FDC = wglGetCurrentDC());
end;

procedure TGLContextWGL.SwapBuffers;
begin
  Windows.SwapBuffers(FDC);
end;

procedure TGLContextWGL.SetSwapInterval(const aInterval: GLint);
begin
  wglSwapIntervalEXT(aInterval);
end;

function TGLContextWGL.GetSwapInterval: GLint;
begin
  result := wglGetSwapIntervalEXT();
end;

procedure TGLContextWGL.Share(const aContext: TGLContext);
begin
  wglShareLists(FRC, (aContext as TGLContextWGL).FRC);
end;

class function TGLContextWGL.ChangeDisplaySettings(const aWidth, aHeight,
  aBitPerPixel, aFreq: Integer; const aFlags: TglcDisplayFlags): Boolean;
var
  dm: TDeviceMode;
  flags: Cardinal;
begin
  FillChar(dm{%H-}, SizeOf(dm), 0);
  with dm do begin
    dmSize             := SizeOf(dm);
    dmPelsWidth        := aWidth;
    dmPelsHeight       := aHeight;
    dmDisplayFrequency := aFreq;
    dmBitsPerPel       := aBitPerPixel;
    dmFields           := DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL or DM_DISPLAYFREQUENCY;
  end;
  flags := 0; //CDS_TEST;
  if (dfFullscreen in aFlags) then
    flags := flags or CDS_FULLSCREEN;
  result := (Windows.ChangeDisplaySettings(dm, flags) = DISP_CHANGE_SUCCESSFUL);
end;

class function TGLContextWGL.IsAnyContextActive: boolean;
begin
  Result:= (wglGetCurrentContext()<>0) and (wglGetCurrentDC()<>0);
end;

end.

