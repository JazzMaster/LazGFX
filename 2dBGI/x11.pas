Unit X11;
{
Core 2DBGI API for Laz GFX (X11)

some of this is reworked from fpGUI- which uses X11 core(amongst other ports)

A good chunk of workable code was pulled from fpGUI. 
There is some question if it works- may be due to the broken widget set w CoreX11 that changed??(unused sections)

The init and destructor routines here, work.
(So should everything else here)

I may be missing a few variables- I have the code to plug them in from.

I will pull in the color manipulation parts in a minute-from my old code(release v2).
We have XFreetype support(xft)- so we should have decent font capabilities.

Its not something easily understood- but I get what is here.

keep in mind that X11(and anyone else) can over complicate things(nuke them).
COLOR is no exception. X11 will "nuke" color ops.

So far this is about 3 days worth of work- 
much faster than the old ways I was doing things.


}

interface

{$mode objfpc}
{$H+}

uses

    x,Xlib,Xutil,baseunix,sysutils,ctypes,Logger,strings,typinfo;

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

type
    PixelPoint=record
        X,Y:word;
    end;

var
  APos:PixelPoint;
  d: PDisplay;
  w: TWindow;
  e: TXEvent;
  msg: PChar;
  s: cint;

  attr: TXSetWindowAttributes;
  mask: longword;
  hints: TXSizeHints;
  IconPixmap: TPixmap;
  WMHints: PXWMHints;

  rc:Longword;
  screen_colormap:TColormap;     // color map to use for allocating colors.   
  red, brown, blue, yellow, green:TXColor;
	
  Context:PXGC;
  key:PKeySym;

  CurrX,CurrY:word;
  text:array [0..254] of char;
  NewMsg:String;
  Values:PXGCValues;
  black,white:longword;
  NewText:PChar;
  xc: TXColor;

procedure ClearViewport;
procedure ClearViewportwColor(color:TXColor);
procedure LoadFont9x15(var FontInfo: PXFontStruct);
function ConvertTo565Pixel(rgb: longword): word;
function ConvertTo555Pixel(rgb: longword): word;
function GetFontFaceList: TStringList;
function X11keycodeToScanCode(akeycode: word): word;
function  GetScreenWidth: word;
function  GetScreenHeight: word;
function  GetPixel(Spot: APos): DWord;
function  Screen_dpi_x: integer;
function  Screen_dpi_y: integer;
function FindValidModeMatching(Xres,Yres,Requestedbpp):boolean;
procedure InitGraph(Xres,Yres,RequestedBpp:Word; WantsFullscreen:boolean);
function ColorToXColor(c: longword): longword;
procedure PutPixel(color:DWord);
procedure PutPixelXY(TextX, TextY: integer);
procedure DrawArc(x, y, w, h: word; a1, a2: Extended);
procedure FillArc(x, y, w, h: word; a1, a2: Extended);
procedure DrawPolygon(Points: PPoint; NumPts: Integer; Winding: boolean);
procedure SetLineStyle(width: integer; style: LineStyle);
procedure FillRectangle(x, y, w, h: word);
procedure XORFillRectangle(col: DWord; x, y, w, h: Word);
procedure FillTriangle(x1, y1, x2, y2, x3, y3: Word);
procedure Line(x1, y1, x2, y2: Word);
procedure Rectangle(x, y, w, h: Word);
procedure MoveWindow(x,y: Word);
procedure UpdateWindowPosition;
procedure BringToFront;
procedure CreateFontResource(afontdesc: string);
procedure DestroyFontResource;
function FontResourceHandleIsValid: boolean;
function FontResourceGetAscent: integer;
function FontResourceGetDescent: integer;
function FontResourceGetHeight: integer;
procedure CaptureMouse;
procedure ReleaseMouse;
procedure SetWindowTitle( ATitle: string);
procedure SetMouseCursor;
Procedure MainLoop;
procedure CloseGraph;

implementation

{

X11 color allocation en mass:

XAllocColorCells/ XAllocColorPlanes
(To store colors-use for palettes) XStoreColors

You can currently pull "defined colors" into the colormap(required) but to set them- 
(as with palettes)- requires write access. PseudoColor= Pallette.


}

procedure ClearViewport;

begin
    XSetBackground(d,Context,white);
    XClearWindow(d, w);
end;

procedure ClearViewportwColor(color:TXColor);

begin
    XSetBackground(d,Context,color.pixel);
    XClearWindow(d, w);
end;

//this is an internal font
procedure LoadFont9x15(var FontInfo: PXFontStruct);
const
  FontName: PChar = '9x15';
begin
  FontInfo := XLoadQueryFont(D, FontName);
  if FontInfo = nil then
    begin
      Writeln(Progname, ': Cannot open 9x15 font.');
      Halt(1);
    end;
end; 


function ConvertTo565Pixel(rgb: longword): word;
begin
  Result := (rgb and $F8) shr 3;
  Result := Result or ((rgb and $FC00) shr 5);
  Result := Result or ((rgb and $F80000) shr 8);
end;

function ConvertTo555Pixel(rgb: longword): word;
begin
  Result := (rgb and $F8) shr 3;
  Result := Result or ((rgb and $F800) shr 6);
  Result := Result or ((rgb and $F80000) shr 9);
end;

//similar to sdl color split
//function DWordtoSDL_Color(somecolor:Dword):SDL_Color;

//begin
    //xc.red=
    //xc.green=
    //xc.blue=
    //xc.flags = DoRed | DoGreen | DoBlue;
//end;


function GetFontFaceList: TStringList;
var
  pfs: PFcFontSet;
  ppat: PPFcPattern;
  n: integer;
  s: string;
  pc: PChar;
begin
  // this now even returns non-scaleable fonts which is what we sometimes want.
  pfs := XftListFonts(D, w, [0, FC_FAMILY, 0]);

  if pfs = nil then
    Exit; 

  Result := TStringList.Create;

  GetMem(pc, 128);
  n := 0;
  ppat := pfs^.fonts;
  while n < pfs^.nfont do
  begin
    XftNameUnparse(ppat^, pc, 127);  //XftNameUnparse does not free the name string!
    s := pc;
    Result.Add(s);
    inc(PChar(ppat), sizeof(pointer));
    inc(n);
  end;
  FreeMem(pc);
  FcFontSetDestroy(pfs);

  Result.Sort;
end;


function X11keycodeToScanCode(akeycode: word): word;
begin
  case akeycode and $ff of
    $09..$5B: Result := akeycode - 8;
    $6C: Result := $11C; // numpad enter
    $6D: Result := $11D; // right ctrl
    $70: Result := $135; // numpad /
    $62: Result := $148; // up arrow
    $64: Result := $14B;
    $66: Result := $14D;
    $68: Result := $150; // down arrow
    $6A: Result := $152;
    $61: Result := $147;
    $63: Result := $149;
    $6B: Result := $153;
    $67: Result := $14F;
    $69: Result := $151;
    $71: Result := $138;
    else
      Result := akeycode;
  end;
end;

function  GetScreenWidth: word;
var
  wa: TXWindowAttributes;
begin
  XGetWindowAttributes(D, W, @wa);
  Result := wa.Width;
end;

function  GetScreenHeight: word;
var
  wa: TXWindowAttributes;
begin
  XGetWindowAttributes(D, W, @wa);
  Result := wa.Height;
end;

//assumes 24/32bpp
function  GetPixel(Spot: APos): DWord;
var
  Image: PXImage;
  Pixel: Cardinal;
  x_Color: TXColor;
begin
  Result := 0;
  Image := XGetImage(D, w, Spot.X, Spot.Y, 1, 1, $FFFFFFFF, ZPixmap);
  if Image = nil then
    raise Exception.Create('fpGFX/X11: Invalid XImage');
  try
    Pixel := XGetPixel(Image, 0, 0);
    x_Color.pixel := Pixel;
    XQueryColor(Display, DefaultColorMap, @x_Color);
    Result := DWord( ((x_Color.red and $00FF) shl 16) or ((x_Color.green and $00FF) shl 8) or (x_Color.blue and $00FF) );
  finally
    XDestroyImage(Image);
  end;
end;

function  Screen_dpi_x: integer;
var
  mm: integer;
begin
  // 25.4 is millimeters per inch
  mm := 0;
  mm := DisplayWidthMM(Display, DefaultScreen);
  if mm > 0 then
    Result := Round((GetScreenWidth * 25.4) / mm)
  else
    Result := 96; // seems to be a well known default. :-(
end;

function  Screen_dpi_y: integer;
var
  mm: integer;
begin
  // 25.4 is millimeters per inch
  mm := 0;
  mm := DisplayHeightMM(Display, DefaultScreen);
  if mm > 0 then
    Result := Round((GetScreenHeight * 25.4) / mm)
  else
    Result := Screen_dpi_x; // same as width
end;

function FindValidModeMatching(Xres,Yres,Requestedbpp):boolean;

begin
    //right now we check to see if given data matches possible modes, then we see if we can set that mode-
    //or given a reasonable lower one.


//probe:
    //query xrandr: get the available modes and bpp- see if we are above the requested.
    //if below - then x,y,bpp must match us or below ONLY. 
    //cycle thru modes until we find a match

    //if above(or equal)- we can set window or FS mode-we are ok
    

end;

procedure InitGraph(Xres,Yres,RequestedBpp:Word; WantsFullscreen:boolean);

begin
  
  //before we even open a window/session we can check resolutions against the current modelist(PC).

  {if not FindValidModeMatching(Xres,Yres,Requestedbpp); then begin
        LogLn('Invalid Mode Requested.');
        halt;
   end;
  }

  { open connection with the server }
  d := XOpenDisplay(nil);
  if (d = nil) then  begin
    LogLn('Cannot open X11 display');
    exit;
  end;


  s := DefaultScreen(d);
  black:=BlackPixel(d,s);
  white:=WhitePixel(d,s);

  ScreenNum := XDefaultScreen(D);
  DisplayWidth := XDisplayWidth(D, S);
  DisplayHeight := XDisplayHeight(D, S);
  DefaultVisual := XDefaultVisual(d, S);
  DisplayDepth  := XDefaultDepth(d, S);
//  DefaultColorMap := XDefaultColorMap(D, S);


  { create window }
  w := XCreateSimpleWindow(d, RootWindow(d, s), 10, 10, XRes, YRes, 1,  BlackPixel(d, s), WhitePixel(d, s));

//  w := XCreateWindow(d, RootWindow(d,s), FLeft, FTop, FWidth, FHeight, 0, CopyFromParent, InputOutput, DefaultVisual,mask, @attr);
  if w = 0 then
    raise Exception.Create('fpGUI/X11: Failed to create window ' );


    IconPixMap := XCreateBitmapFromData(d, w, @IconBitmapBits, IconBitmapWidth, IconBitmapHeight);

    Hints := XAllocWMHints;
    Hints^.icon_pixmap := IconPixmap;
    Hints^.flags := IconPixmapHint;

    hints.flags      := hints.flags or PMinSize or PMaxSize;
    hints.min_width  := FWidth;
    hints.min_height := FHeight;
    hints.max_width  := FWidth;
    hints.max_height := FHeight;

    XSetWMNormalHints(d, W, @hints);

    XSetWMProperties(d, FWinHandle, nil, nil, nil, 0, nil, Hints, nil);

//  XSetStandardProperties(d,w,'Lazarus Graphics Application','',None,NiL,0,NiL);

 screen_colormap := DefaultColormap(d, DefaultScreen(d));

{
//problem with this is we dont know--could be 16K or more used...
  // allocate the set of colors we will want to use for the drawing. 

This fetches the DWord of the known RGB values

  rc := XAllocNamedColor(d, screen_colormap, 'red', @red, @red);

  if rc =0  then begin
    LogLn('XAllocNamedColor - failed to allocated red color.');
    exit;
  end;

  rc := XAllocNamedColor(d, screen_colormap, 'brown', @brown, @brown);
  if (rc = 0) then begin
    LogLn('XAllocNamedColor - failed to allocated brown color.');
    exit;
  end;

  rc := XAllocNamedColor(d, screen_colormap, 'blue', @blue, @blue);
  if (rc = 0) then begin
    LogLn('XAllocNamedColor - failed to allocated blue color.');
    exit;
  end;

  rc := XAllocNamedColor(d, screen_colormap, 'yellow', @yellow, @yellow);
  if (rc = 0) then begin
    LogLn('XAllocNamedColor - failed to allocated yellow color.');
    exit;
  end;
  rc := XAllocNamedColor(d, screen_colormap, 'green', @green, @green);
  if (rc = 0) then begin
    LogLn('XAllocNamedColor - failed to allocated green color.');
    exit;
  end;
}
  
  { select kind of events we are interested in 

  XSelectInput(D, w, KeyPressMask or KeyReleaseMask or
      ButtonPressMask or ButtonReleaseMask or
      EnterWindowMask or LeaveWindowMask or
      ButtonMotionMask or PointerMotionMask or
      ExposureMask or FocusChangeMask or
      StructureNotifyMask);

}
  XSelectInput(d, w, ExposureMask or KeyPressMask or ButtonPressMask);


  //LoadFont(FontInfo);
  //GetDC(win, GC, FontInfo);

{
Do we need this if we can set it later on?
 
   values.foreground := WhitePixel(dpy, screen_num);
	values.line_width := 1;
	values.line_style := LineSolid;
}

//this is what we are after. (All "related ops" in a single context-but you can have more.)
    Context:=XCreateGC(d, w, 0,Values);  
//    XSetLineAttributes(d, Context, 0, LineSolid, CapNotLast, JoinMiter);
      
	XSetBackground(d,Context,black);
	XSetForeground(d,Context,white);

	XClearWindow(d, w);

  { map (show) the window }
  XMapWindow(d, w);

end;

function ColorToXColor(c: longword): longword;

var
    TempResult:DWord;

begin

//the odd circumstance that we are in 15 or 16bpp(strange) and using palettes must be taken into account.
//older hardware?

//assumes ARGB colrspace...(windows default)
  if bpp = 32  then
    xc.blue  := (c and $000000FF) shl 8;
    xc.green := (c and $0000FF00);
    xc.red   := (c and $00FF0000) shr 8;
  end; //theres no 32bpp paletted colors(they are all opaque/solid fills)


  else if (bpp = 24 and notPaletted) then
    TempResult   := c and $FFFFFF       { No Alpha channel information }
  else if (bpp = 24 and Paletted) then begin //emulated pallette under 24bpp
        someDWord:=convertFromPalletted(c);
        TempResult   := c and $FFFFFF       { No Alpha channel information }
  end
  else if (bpp = 16 and notpaletted) then //need words here
       TempResult := ConvertTo565Pixel(c)

  else if (bpp = 16 and Paletted) then begin //emulated pallette under 24bpp
        someDWord:=convertFromPalletted(c);
       TempResult  := ConvertTo565Pixel(someDWord)
  end
  else if (bpp = 15 and notPaletted) then
        TempResult  := ConvertTo555Pixel(c)

  else if (bpp = 15 and Paletted) then begin //emulated pallette under 24bpp
        someDWord:=convertFromPalletted(c);
       TempResult  := ConvertTo555Pixel(someDWord)
  end;

    // X11 valid color strings: "rgb:00/ff/00"
    // XColor.pixel is a DWord (converted from input)
    xc.pixel:=TempResult;

    //we cant use what is not in the "colormap" .. so add the color
    XAllocColor(d, screen_colormap, @xc); 
    Result := xc.pixel;
  end;
end;


procedure PutPixel(color:DWord);

begin
    XSetForeGround(d, context, ColorToXColor(color));
    //(if not specified: get X and Y first)
    PutPixelXY(CurrX,CurrY);
end;

procedure PutPixelXY(TextX, TextY: integer);

begin
  XDrawPoint(d, w, context, TextX, TextY);
end;


procedure DrawArc(x, y, w, h: word; a1, a2: Extended);
begin
  XDrawArc(d, w, context, x, y, w-1, h-1, Trunc(64 * a1), Trunc(64 * a2));
end;

procedure FillArc(x, y, w, h: word; a1, a2: Extended);
begin
  XFillArc(d, w, context, x, y, w, h,  Trunc(64 * a1), Trunc(64 * a2));
end;

procedure DrawPolygon(Points: PPoint; NumPts: Integer; Winding: boolean);
var
  PointArray: PXPoint;
  i: integer;
begin
  { convert TPoint to TXPoint }
  GetMem(PointArray, SizeOf(TXPoint)*(NumPts+1)); // +1 for return line
  for i := 0 to NumPts-1 do
  begin
    PointArray[i].x := Points[i].x;
    PointArray[i].y := Points[i].y;
  end;
  XFillPolygon(d, w, context, PointArray, NumPts, CoordModeOrigin, X.Complex);
  if PointArray <> nil then
    FreeMem(PointArray);
end;


procedure SetLineStyle(width: integer; style: LineStyle);
const
  cDot: array[0..1] of Char = #1#1;
  cDash: array[0..1] of Char = #4#2;
  cDashDot: array[0..3] of Char = #4#1#1#1;
  cDashDotDot: array[0..5] of Char = #4#1#1#1#1#1;
begin

  case Style of
    lsDot:
        begin
          XSetLineAttributes(d, context, width, LineOnOffDash, 0, JoinMiter);
          XSetDashes(d, context, 0, cDot, 2);
        end;
    lsDash:
        begin
          XSetLineAttributes(d, context, width, LineOnOffDash, 0, JoinMiter);
          XSetDashes(d, context, 0, cDash, 2);
        end;
    lsDashDot:
        begin
          XSetLineAttributes(d, context, width, LineOnOffDash, 0, JoinMiter);
          XSetDashes(d, context, 0, cDashDot, 4);
        end;
    lsDashDotDot:
        begin
          XSetLineAttributes(d, context, width, LineOnOffDash, 0, JoinMiter);
          XSetDashes(d, context, 0, cDashDotDot, 6);
        end;
    else  // which includes lsSolid
      XSetLineAttributes(d, context, width, LineSolid, 0, JoinMiter);
  end;  { case }
end;

{
//subTextureOps - semi used with Blits and Images
procedure DrawImagePart(x, y: Word; img: TImage; xi, yi, w, h: word);
var
  msk: TPixmap;
  GcValues: TXGcValues;
begin
  if img = nil then
    Exit; 

  if img.Masked then
  begin
    // rendering the mask
    msk := XCreatePixmap(d, XDefaultRootWindow(d), w, h, 1);
    GcValues.foreground := 1;
    GcValues.background := 0;

    // clear mask
    context1 := XCreateGc(d, msk, GCForeground or GCBackground, @GcValues);
    XSetForeground(d, context, 0);
    XFillRectangle(d, msk, context, 0, 0, w, h);

    XSetForeground(d, context, 1);
    XPutImage(d, msk, context, TImage(img).XImageMask, xi, yi, 0, 0, w, h);

    context2 := XCreateGc(d, context, 0, @GcValues);
    XSetClipMask(d, context1, msk);
    XSetClipOrigin(d, context1, x, y);

    XPutImage(d, context1, context2, TImage(img).XImage, xi, yi, x, y, w, h);
    XFreePixmap(d, msk);
    XFreeGc(d, context1);
    XFreeGc(d, context2);
  end

  else
    XPutImage(d, w, context, TfpgImage(img).XImage, xi, yi, x, y, w, h);
end;

}

procedure FillRectangle(x, y, w, h: word);
begin
  XFillRectangle(d, w, context, x, y, w, h);
end;

procedure XORFillRectangle(col: DWord; x, y, w, h: Word);
begin
  XSetForeGround(d, context, ColorToXColor(Col));
  XSetFunction(d, context, GXxor);
  XFillRectangle(d, w, context, x, y, w, h);
  XSetForeGround(d, context, 0);
  XSetFunction(d, context, GXcopy);
end;

procedure FillTriangle(x1, y1, x2, y2, x3, y3: Word);
var
  pts: array[1..3] of TXPoint;
begin
  pts[1].x := x1;   pts[1].y := y1;
  pts[2].x := x2;   pts[2].y := y2;
  pts[3].x := x3;   pts[3].y := y3;

  XFillPolygon(d, w, context, @pts, 3, CoordModeOrigin, X.Complex);
end;


procedure Line(x1, y1, x2, y2: Word);
begin
  // Same behavior as Windows. See documentation for reason.
  XDrawLine(d, w, context, x1, y1, x2, y2);
end;

procedure Rectangle(x, y, w, h: Word);
begin
  // Same behavior as Windows. See documentation for reason.
  if (w = 1) and (h = 1) then // a dot
    Line(x, y, x+w, y+w)
  else
    XDrawRectangle(d, w, context, x, y, w-1, h-1);
end;

procedure MoveWindow(x,y: Word);
begin
  if HandleIsValid then
    XMoveWindow(d, w, x, y);
end;

procedure UpdateWindowPosition;
var
  w: longword;
  h: longword;
begin
  if HasHandle then
  begin
    if FWidth > 1 then
      w := FWidth
    else
      w := 1;
    if FHeight > 1 then
      h := FHeight
    else
      h := 1;

    XMoveResizeWindow(d, w, FLeft, FTop, w, h);
  end;
end;

//if not in front- dont attemtpt to draw, raise first.
procedure BringToFront;
begin
  if HasHandle then
    XRaiseWindow(d, w);
end;

procedure CreateFontResource(afontdesc: string);
begin
  FFontData := XftFontOpenName(d, w, PChar(afontdesc));
end;

procedure DestroyFontResource;
begin
  if HandleIsValid then
    XftFontClose(d, FFontData);
  inherited;
end;

function FontResourceHandleIsValid: boolean;
begin
  Result := (FFontData <> nil);
end;

function FontResourceGetAscent: integer;
begin
  Result := FFontData^.ascent;
end;

function FontResourceGetDescent: integer;
begin
  Result := FFontData^.descent;
end;

function FontResourceGetHeight: integer;
begin
  Result := FFontData^.Height;
end;

{
function FontResourceGetTextWidth(txt: string): integer;
begin
  if length(txt) < 1 then
  begin
    Result := 0;
    Exit;
  end;
  // Xft uses smallint to return text extent information, so we have to
  // check if the text width is small enough to fit into smallint range
  if DoGetTextWidthClassic('W') * Length(txt) < High(smallint) then
    Result := DoGetTextWidthClassic(txt)
  else
    Result := DoGetTextWidthWorkaround(txt);
end;
}

procedure CaptureMouse;
begin
  XGrabPointer(d, w, TBool(False), ButtonPressMask or ButtonReleaseMask or ButtonMotionMask or PointerMotionMask or EnterWindowMask or LeaveWindowMask, GrabModeAsync, GrabModeAsync, None, 0, CurrentTime);
end;

procedure ReleaseMouse;
begin
  XUngrabPointer(d, CurrentTime);
end;


procedure SetWindowTitle( ATitle: string);
var
  tp: TXTextProperty;
begin
  if w <= 0 then
    Exit;

  tp.value    := PCUChar(ATitle);
  tp.encoding := XA_WM_NAME;
  tp.format   := 8;
  tp.nitems   := UTF8Length(ATitle);

  XStoreName(d, w, PChar(ATitle));
  XSetIconName(d, w, PChar(ATitle));
end;


procedure SetMouseCursor;
var
  xct: TCursor;
  shape: integer;
begin
  if not HasHandle then
  begin
    FMouseCursorIsDirty := True;
    Exit; 
  end;

  case FMouseCursor of
    mcDefault:    shape := XC_left_ptr;
    mcArrow:      shape := XC_arrow;
    mcSizeEW:     shape := XC_sb_h_double_arrow;
    mcSizeNS:     shape := XC_sb_v_double_arrow;
    mcIBeam:      shape := XC_xterm;
    mcSizeNWSE:   shape := XC_bottom_right_corner;
    mcSizeNESW:   shape := XC_bottom_left_corner;
    mcSizeSWNE:   shape := XC_top_right_corner;
    mcSizeSENW:   shape := XC_top_left_corner;
    mcMove:       shape := XC_fleur;
    mcCross:      shape := XC_crosshair;
    mcHourGlass:  shape := XC_watch;
    mcHand:       shape := XC_hand2;
    mcDrag:       shape := XC_target;
    mcNoDrop:     shape := XC_pirate;
  else
    shape := XC_left_ptr; //XC_arrow;
  end;

  xct := XCreateFontCursor(d, shape);
  XDefineCursor(d, w, xct);
  XFreeCursor(d, xct);

  FMouseCursorIsDirty := False;
end;


Procedure MainLoop;

begin


  { event loop }
  while (True) do begin
    XNextEvent(d, @e);
    { draw or redraw the window }
    if (e._type = Expose) then  begin
	  XClearWindow(d, w);

   	  XSetForeground(d,Context,black);
      //do more?
      XFlush(d);
    end;

		if e._type=KeyPress then begin
//catch special keys

             if  e.xkey.keycode = $09  then
                close_x;		

{

  case KeySym of
    0..Ord('a')-1, Ord('z')+1..$bf, $f7:
      Result := KeySym;
    Ord('a')..Ord('z'), $c0..$f6, $f8..$ff:
      Result := KeySym - 32;  // ignore case: convert lowercase a-z to A-Z keysyms;
    $20a0..$20ac: Result := Table_20aX[KeySym];
    $fe20: Result := keyTab;
    $fe50..$fe60: Result := Table_feXX[KeySym];
    XK_BackSpace:   Result := keyBackspace;
    XK_Tab:         Result := keyTab;
    XK_Linefeed:    Result := keyLinefeed;
    $ff0b: Result := keyClear;
    $ff0d: Result := keyReturn;
    $ff13: Result := keyPause;
    $ff14: Result := keyScrollLock;
    $ff15: Result := keySysRq;
    $ff1b: Result := keyEscape;
    $ff50..$ff58: Result := Table_ff5X[KeySym];
    $ff60..$ff6b: Result := Table_ff6X[KeySym];
    $ff7e: Result := keyModeSwitch;
    $ff7f: Result := keyNumLock;
    $ff80: Result := keyPSpace;
    $ff89: Result := keyPTab;
    $ff8d: Result := keyPEnter;
    $ff91..$ff9f: Result := Table_ff9X[KeySym];
    $ffaa: Result := keyPAsterisk;
    $ffab: Result := keyPPlus;
    $ffac: Result := keyPSeparator;
    $ffad: Result := keyPMinus;
    $ffae: Result := keyPDecimal;
    $ffaf: Result := keyPSlash;
    $ffb0..$ffb9: Result := keyP0 + KeySym - $ffb0;
    $ffbd: Result := keyPEqual;
    $ffbe..$ffe0: Result := keyF1 + KeySym - $ffbe;
    $ffe1..$ffee: Result := Table_ffeX[KeySym];
    $ffff: Result := keyDelete;
  else
    Result := keyNIL;
  end;



}

		// use the XLookupString routine to convert the event
		//   KeyPress data into regular text.  Weird but necessary...

         if (XLookupString(@e,text,255,key,Nil)=1) then begin

			if (text='q') then begin
				close_x;
			end;
{
            Currx:=e.xbutton.x;
			Curry:=e.xbutton.y;
            
            NewMsg:='You pressed a key!';
            NewText:=PChar(NewMsg);

			XSetForeground(d,Context,3);
			XDrawString(d,w,Context,Currx,Curry, NewText, strlen(NewText)); }
          end;
       
		end;

//FocusIn
//FocusOut

        if (e._type=ConfigureNotify) then begin
			if (width != e.xconfigure.width	or height != e.xconfigure.height) then begin
				width = e.xconfigure.width;
				height = e.xconfigure.height;
				XClearWindow(d, w);
				logLn('Size changed to: ', width, ' x ', height);
            end;
        end;

        //when the mouse is pressed , draw a string at (x,y)
		if (e._type=ButtonPress) then begin
		{
			CurrX:=e.xbutton.x;
		    CurrY:=e.xbutton.y;

			NewMsg:='X is FUN!';
            NewText:=PChar(NewMsg);

			XSetForeground(d,Context,3);
			XDrawString(d,w,Context,CurrX,CurrY, NewText, strlen(NewText));}
		end;

  end;
end;


procedure CloseGraph;
begin
  { close connection to server }
	XFreeGC(d, Context);
	XDestroyWindow(d,w);
    XCloseDisplay(d);
    halt(0);
end;


begin

end.
