//This is an adaptation of the "BGI Demo Program" from BP7 distribution
program demo;
{$APPTYPE CONSOLE}
uses wingraph,wincrt,
{$IFDEF FPC}gl,glu;{$ELSE}opengl;{$ENDIF}

const Fonts     : array[0..3] of string[17] =
      ('Courier New','MS Sans Serif','Times New Roman','Arial');
      LineStyles: array[0..5] of string[12] =
      ('SolidLn','DottedLn','DashDotLn','DashedLn','DashDotDotLn','UserBitLn');
      FillStyles: array[0..8] of string[14] =
      ('EmptyFill','SolidFill','LineFill','ColFill','HatchFill','SlashFill',
       'BkSlashFill','XHatchFill','UserFill');
      TextDirect: array[0..1] of string[8] =
      ('HorizDir','VertDir');
      HorizJust : array[0..2] of string[10] =
      ('LeftText','CenterText','RightText');
      VertJust  : array[0..2] of string[15] =
      ('TopText','BottomText','BaselineText');

var GraphDriver,GraphMode,ErrorCode: smallint;
    MaxX,MaxY,TextH,TextW          : word;
    MaxColor                       : longword;

procedure Initialize;
begin
  GraphDriver:=VGA; GraphMode:=VGAHi; //hardcoded VGA driver
  InitGraph(GraphDriver,GraphMode,'WinGraph Demo');
  ErrorCode:=GraphResult;
  if (ErrorCode <> grOK) then
  begin
    Writeln('Graphics error: ', GraphErrorMsg(ErrorCode));
    Readln;
    Halt(1);
  end;
  Randomize;
  MaxColor:=GetMaxColor;
  MaxX:=GetMaxX; MaxY:=GetMaxY;
  TextH:=TextHeight('H'); TextW:=TextWidth('H');
end;

function Int2Str(L:longint): string;
var S: string;
begin
  Str(L,S); Int2Str:=S;
end;

function RandColor:word;
begin
  RandColor:=Random(MaxColor)+1;
end;

procedure DefaultColors;
begin
  SetColor(White);
end;

procedure FullPort;
begin
  SetViewPort(0,0,MaxX,MaxY,ClipOn);
end;

procedure StatusLine(Msg: string);
begin
  FullPort;
  DefaultColors;
  SetTextStyle(DefaultFont,HorizDir,16);
  SetTextJustify(CenterText,TopText);
  SetLineStyle(SolidLn,0,NormWidth);
  SetFillStyle(EmptyFill,0);
  Bar(0,MaxY-(TextH+4),MaxX,MaxY);
  Rectangle(0,MaxY-(TextH+4),MaxX,MaxY);
  OutTextXY(MaxX div 2,MaxY-(TextH+2),Msg);
  SetViewPort(1,TextH+5, MaxX-1,MaxY-(TextH+5),ClipOn);
end;

procedure WaitToGo;
const Esc   = #27;
      Close = #107;
var ch: char;
begin
  StatusLine('Esc aborts or press a key...');
  ch:=ReadKey;
  if (ch = #0) then ch:=ReadKey;
  if (ch in [Esc,Close]) then Halt(0) else ClearDevice;
end;

procedure DrawBorder;
var ViewPort: ViewPortType;
begin
  DefaultColors;
  SetLineStyle(SolidLn,0,NormWidth);
  GetViewSettings(ViewPort);
  with ViewPort do Rectangle(0,0,x2-x1,y2-y1);
end;

procedure MainWindow(Header:string);
begin
  DefaultColors;
  ClearDevice;
  SetTextStyle(DefaultFont,HorizDir,16);
  SetTextJustify(CenterText,TopText);
  FullPort;
  OutTextXY(MaxX div 2,2,Header);
  SetViewPort(0,TextH+4,MaxX,MaxY-(TextH+4),ClipOn);
  DrawBorder;
  SetViewPort(1,TextH+5,MaxX-1,MaxY-(TextH+5),ClipOn);
end;

procedure GetDriverAndMode(var DriveStr,ModeStr:string);
begin
  DriveStr:=GetDriverName;
  ModeStr:=GetModeName(GetGraphMode);
end;

procedure ReportStatus;
// Display the status of all query functions after InitGraph
const X = 10;
var ViewInfo : ViewPortType;
    LineInfo : LineSettingsType;
    FillInfo : FillSettingsType;
    TextInfo : TextSettingsType;
    Palette  : PaletteType;
    DriverStr: string;
    ModeStr  : string;
    Xasp,Yasp: word;
    Y        : word;

  procedure WriteOut(S:string);
  begin
    OutTextXY(X,Y,S);
    Inc(Y,TextH+2);
  end;

begin
  GetDriverAndMode(DriverStr,ModeStr);
  GetAspectRatio(Xasp,Yasp);
  GetViewSettings(ViewInfo); GetLineSettings(LineInfo);
  GetFillSettings(FillInfo); GetTextSettings(TextInfo);
  GetPalette(Palette);
  Y:=4;
  MainWindow('Status report after InitGraph');
  SetTextStyle(DefaultFont,0,16);
  SetTextJustify(LeftText,TopText);
  WriteOut('WinGraph version   : '+wingraph.WinGraphVer);
  WriteOut('Graphics driver    : '+DriverStr);
  WriteOut('Graphics mode      : '+ModeStr);
  WriteOut('Screen resolution  : (0, 0, '+Int2Str(MaxX)+', '+Int2Str(MaxY)+')');
  WriteOut('Screen aspect ratio: '+Int2Str(Xasp)+'/'+Int2Str(Yasp));
  with ViewInfo do
  begin
    WriteOut('Current view port  : ('+Int2Str(x1)+', '+Int2Str(y1)+', '+
                                      Int2Str(x2)+', '+Int2Str(y2)+')');
    if Clip then WriteOut('Clipping           : ON')
            else WriteOut('Clipping           : OFF');
  end;
  WriteOut('Current position   : ('+Int2Str(GetX)+', '+Int2Str(GetY)+')');
  WriteOut('Palette entries    : '+Int2Str(Palette.Size));
  WriteOut('GetMaxColor        : '+Int2Str(MaxColor));
  WriteOut('Current color      : '+Int2Str(GetColor));
  with LineInfo do
  begin
    WriteOut('Line style         : '+LineStyles[LineStyle]);
    WriteOut('Line thickness     : '+Int2Str(Thickness));
  end;
  with FillInfo do
  begin
    WriteOut('Current fill style : '+FillStyles[Pattern]);
    WriteOut('Current fill color : '+Int2Str(Color));
  end;
  with TextInfo do
  begin
    WriteOut('Current font       : '+Fonts[Font]);
    WriteOut('Text direction     : '+TextDirect[Direction mod 90]);
    WriteOut('Character size     : '+Int2Str(CharSize));
    WriteOut('Horizontal justify : '+HorizJust[Horiz]);
    WriteOut('Vertical justify   : '+VertJust[Vert]);
  end;
  if OpenGLEnabled then
  begin
    SetOpenGLMode(DirectOn); //enabled in order to get correct OpenGL version
    WriteOut('OpenGL version     : '+pchar(glGetString(GL_VERSION)));
  end               else
    WriteOut('OpenGL version     : disabled');
  WaitToGo;
end;

procedure AspectRatioPlay;
// Demonstrate SetAspectRatio command
var
  ViewInfo  : ViewPortType;
  CenterX   : integer;
  CenterY   : integer;
  Radius    : word;
  Xasp,Yasp : word;
  i         : integer;
  RadiusStep: word;
begin
  MainWindow('SetAspectRatio demonstration');
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    CenterX:=(x2-x1) div 2;
    CenterY:=(y2-y1) div 2;
    Radius:=3*((y2-y1) div 5);
  end;
  RadiusStep:=(Radius div 30);
  Circle(CenterX,CenterY,Radius);
  GetAspectRatio(Xasp,Yasp);
  for i:=1 to 30 do
  begin
    SetAspectRatio(Xasp,Yasp+(i*GetMaxX));
    Circle(CenterX,CenterY,Radius);
    Dec(Radius,RadiusStep);
  end;
  Inc(Radius,RadiusStep*30);
  for i:=1 to 30 do
  begin
    SetAspectRatio(Xasp+(I*GetMaxX),Yasp);
    if (Radius > RadiusStep) then Dec(Radius,RadiusStep);
    Circle(CenterX,CenterY,Radius);
  end;
  SetAspectRatio(Xasp,Yasp);
  WaitToGo;
end;

procedure FillEllipsePlay;
// Random filled ellipse demonstration
const MaxFillStyles = 8; { patterns 0..7 }
var MaxRadius: word;
    FillColor: integer;
begin
  MainWindow('FillEllipse demonstration');
  StatusLine('Esc aborts or press a key');
  MaxRadius:= MaxY div 10;
  SetLineStyle(SolidLn,0,NormWidth);
  repeat
    FillColor:=RandColor;
    SetColor(FillColor);
    SetFillStyle(Random(MaxFillStyles),FillColor);
    FillEllipse(Random(MaxX),Random(MaxY),Random(MaxRadius),Random(MaxRadius));
  until KeyPressed;
  WaitToGo;
end;

procedure SectorPlay;
// Draw random sectors on the screen
const MaxFillStyles = 8; { patterns 0..7 }
var MaxRadius: word;
    FillColor: integer;
    EndAngle : integer;
begin
  MainWindow('Sector demonstration');
  StatusLine('Esc aborts or press a key');
  MaxRadius:=MaxY div 10;
  SetLineStyle(SolidLn,0,NormWidth);
  repeat
    FillColor:=RandColor;
    SetColor(FillColor);
    SetFillStyle(Random(MaxFillStyles),FillColor);
    EndAngle:=Random(360);
    Sector(Random(MaxX),Random(MaxY),Random(EndAngle),EndAngle,
           Random(MaxRadius),Random(MaxRadius));
  until KeyPressed;
  WaitToGo;
end;

procedure WriteModePlay;
// Demonstrate the SetWriteMode procedure for XOR lines
const DelayValue = 50;
var ViewInfo    : ViewPortType;
    Color       : word;
    Left,Top    : integer;
    Right,Bottom: integer;
    Step        : integer;
begin
  MainWindow('SetWriteMode demonstration');
  StatusLine('Esc aborts or press a key');
  GetViewSettings(ViewInfo);
  Left:=0; Top:=0;
  with ViewInfo do begin
                     Right:=x2-x1;
                     Bottom:=y2-y1;
                   end;
  Step:=Bottom div 50;
  SetColor(GetMaxColor);
  Line(Left,Top,Right,Bottom);
  Line(Left,Bottom,Right,Top);
  SetWriteMode(XORPut);
  repeat
    Line(Left,Top,Right,Bottom);
    Line(Left,Bottom,Right,Top);
    Rectangle(Left,Top,Right,Bottom);
    Delay(DelayValue);
    Line(Left,Top,Right,Bottom);
    Line(Left,Bottom,Right,Top);
    Rectangle(Left,Top,Right,Bottom);
    if (Left+Step < Right) and (Top+Step < Bottom) then
    begin
      Inc(Left, Step);
      Inc(Top, Step);
      Dec(Right, Step);
      Dec(Bottom, Step);
    end                                            else
    begin
      Color:=RandColor;
      SetColor(Color);
      Left:=0; Top:=0;
      with ViewInfo do begin
                         Right:=x2-x1;
                         Bottom:=y2-y1;
                       end;
    end;
  until KeyPressed;
  SetWriteMode(CopyPut);
  WaitToGo;
end;

procedure ColorPlay;
// Display all of the colors available for the current driver and mode
var Color   : longword;
    Width   : word;
    Height  : word;
    X, Y    : word;
    I, J    : word;
    ViewInfo: ViewPortType;

  procedure DrawBox(X,Y:word);
  begin
    SetFillStyle(SolidFill,Color);
    SetColor(Color);
    with ViewInfo do Bar(X,Y,X+Width,Y+Height);
    Rectangle(X,Y,X+Width,Y+Height);
    Color:=GetColor;
    if (Color = 0) then
    begin
      SetColor(MaxColor);
      Rectangle(X,Y,X+Width,Y+Height);
    end;
    OutTextXY(X+(Width div 2),Y+Height+4,Int2Str(Color));
    Color:=Succ(Color) mod (MaxColor+1);
  end;

begin
  MainWindow('Color demonstration');
  Color:=1;
  GetViewSettings(ViewInfo);
  with ViewInfo do begin
                     Width:=2*((x2+1) div 16);
                     Height:=2*((y2-10) div 10);
                   end;
  X:=Width div 2; Y:=Height div 2;
  for J:=1 to 3 do
  begin
    for I:=1 to 5 do begin
                       DrawBox(X,Y);
                       Inc(X,(Width div 2)*3);
                     end;
    X:=Width div 2;
    Inc(Y,(Height div 2)*3);
  end;
  WaitToGo;
end;

procedure PalettePlay;
// Demonstrate the use of the SetPalette command
const XBars = 15;
      YBars = 10;
var ViewInfo: ViewPortType;
    Width   : word;
    Height  : word;
    OldPal  : PaletteType;

  procedure PutBars;
  var I,J,X,Y,Color: word;
  begin
    X:=0; Y:=0; Color:=0;
    for J:=1 to YBars do
    begin
      for I:=1 to XBars do
      begin
        SetFillStyle(SolidFill,Color);
        Bar(X,Y,X+Width,Y+Height);
        Inc(X,Width+1);
        Inc(Color);
        Color:=Color mod (MaxColor+1);
      end;
      X:=0;
      Inc(Y,Height+1);
    end;
  end;

begin
  GetPalette(OldPal);
  MainWindow('Palette demonstration');
  StatusLine('Press any key...');
  GetViewSettings(ViewInfo);
  with ViewInfo do begin
                     Width:=(x2-x1) div XBars;
                     Height:=(y2-y1) div YBars;
                   end;
  PutBars;
  repeat
    SetPalette(Random(MaxColor+1),Random(MaxColor+1));
  until KeyPressed;
  SetAllPalette(OldPal);
  WaitToGo;
end;

procedure PutPixelPlay;
// Demonstrate the PutPixel and GetPixel commands
const Seed   = 1962;
      NumPts = 20000;
var I        : word;
    X,Y      : word;
    Color    : longword;
    XMax,YMax: integer;
    ViewInfo : ViewPortType;
begin
  MainWindow('PutPixel / GetPixel demonstration');
  StatusLine('Esc aborts or press a key...');
  GetViewSettings(ViewInfo);
  with ViewInfo do begin
                     XMax:=(x2-x1-1);
                     YMax:=(y2-y1-1);
                   end;
  while not KeyPressed do
  begin
    RandSeed:=Seed;
    I:=0;
    while (not KeyPressed) and (I < NumPts) do
    begin
      Inc(I);
      X:=Random(XMax)+1;
      Y:=Random(YMax)+1;
      Color:=RandColor;
      PutPixel(X,Y,Color);
    end;
    RandSeed:=Seed;
    I:=0;
    while (not KeyPressed) and (I < NumPts) do
    begin
      Inc(I);
      X:=Random(XMax)+1;
      Y:=Random(YMax)+1;
      Color:=GetPixel(X, Y);
      if (Color = RandColor) then PutPixel(X,Y,0);
    end;
  end;
  WaitToGo;
end;

procedure PutImagePlay;
// Demonstrate the GetImage and PutImage commands
const r      = 20;
      StartX = 100;
      StartY = 50;
var CurPort: ViewPortType;

  procedure MoveSaucer(var X,Y:integer; Width,Height:integer);
  var Step: integer;
  begin
    Step:=Random(2*r);
    if Odd(Step) then Step:=-Step;
    X:=X+Step;
    Step:=Random(r);
    if Odd(Step) then Step:=-Step;
    Y:=Y+Step;
    with CurPort do
    begin
      if (x1+X+Width-1 > x2) then X:=x2-x1-Width+1 else
        if (X < 0) then X:=0;
      if (y1+Y+Height-1 > y2) then Y:=y2-y1-Height+1 else
        if (Y < 0) then Y:=0;
    end;
  end;

var Pausetime: word;
    Saucer   : pointer;
    X, Y     : integer;
    ulx, uly : word;
    lrx, lry : word;
    Size     : longword;
    i        : word;
begin
  ClearDevice;
  FullPort;
  ClearDevice;
  MainWindow('GetImage / PutImage Demonstration');
  StatusLine('Esc aborts or press a key...');
  GetViewSettings(CurPort);
  Ellipse(StartX,StartY,0,360,r,(r div 3)+2);
  Ellipse(StartX,StartY-4,190,357,r,r div 3);
  Line(StartX+7,StartY-6,StartX+10,StartY-12);
  Circle(StartX+10,StartY-12,2);
  Line(StartX-7,StartY-6,StartX-10,StartY-12);
  Circle(StartX-10,StartY-12,2);
  SetFillStyle(SolidFill,White);
  FloodFill(StartX+1,StartY+4,GetColor);
  ulx:=StartX-(r+1);
  uly:=StartY-14;
  lrx:=StartX+(r+1);
  lry:=StartY+(r div 3)+3;
  Size:=ImageSize(ulx,uly,lrx,lry);
  GetMem(Saucer,Size);
  GetImage(ulx,uly,lrx,lry,Saucer^);
  PutImage(ulx,uly,Saucer^,XORput);
  for i:=1 to 10000 do PutPixel(Random(MaxX),Random(MaxY),RandColor);
  X:=MaxX div 2; Y:=MaxY div 2;
  PauseTime:=50;
  repeat
    PutImage(X,Y,Saucer^,XORput);
    Delay(PauseTime);
    PutImage(X,Y,Saucer^,XORput);
    MoveSaucer(X,Y,lrx-ulx+1,lry-uly+1);
  until KeyPressed;
  FreeMem(Saucer,Size);
  WaitToGo;
end;

procedure RandBarPlay;
// Draw random bars on the screen
var MaxWidth : integer;
    MaxHeight: integer;
    ViewInfo : ViewPortType;
    Color    : word;
begin
  MainWindow('Random Bars');
  StatusLine('Esc aborts or press a key');
  GetViewSettings(ViewInfo);
  with ViewInfo do begin
                     MaxWidth:=x2-x1;
                     MaxHeight:=y2-y1;
                   end;
  repeat
    Color:=RandColor;
    SetColor(Color);
    SetFillStyle(Random(UserFill),Color);
    Bar3D(Random(MaxWidth),Random(MaxHeight),
          Random(MaxWidth),Random(MaxHeight),0,TopOff);
  until KeyPressed;
  WaitToGo;
end;

procedure BarPlay;
// Demonstrate Bar command
const NumBars = 5;
      BarHeight: array[1..NumBars] of byte = (1,3,5,2,4);
      Styles   : array[1..NumBars] of byte = (6,3,2,5,7);
var ViewInfo   : ViewPortType;
    H          : word;
    XStep,YStep: real;
    i,j        : integer;
    Color      : word;
begin
  MainWindow('Bar / Rectangle demonstration');
  H:=3*TextH;
  GetViewSettings(ViewInfo);
  SetTextJustify(CenterText,TopText);
  SetTextStyle(DefaultFont,HorizDir,14);
  OutTextXY(MaxX div 2,6,'These are 2D bars!');
  with ViewInfo do SetViewPort(x1+50,y1+30,x2-50,y2-10,ClipOn);
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    Line(H,H,H,(y2-y1)-H); Line(H,(y2-y1)-H,(x2-x1)-H,(y2-y1)-H);
    YStep:=((y2-y1)-(2*H))/NumBars; XStep:=((x2-x1)-(2*H))/NumBars;
    j:=(y2-y1)-H;
    SetTextJustify(CenterText,CenterText);
    for i:=0 to NumBars do
    begin
      Line(H div 2,j,H,J);
      OutTextXY(10,j,Int2Str(i));
      j:=Round(j-Ystep);
    end;
    j:=H;
    SetTextJustify(CenterText,TopText);
    for i:=1 to Succ(NumBars) do
    begin
      SetColor(MaxColor);
      Line(j,(y2-y1)-H,j,(y2-y1-3)-(H div 2));
      OutTextXY(j,(y2-y1)-(H div 2),Int2Str(i));
      if (i <> Succ(NumBars)) then
      begin
        Color:=RandColor;
        SetFillStyle(Styles[i],Color);
        SetColor(Color);
        Bar(j,round((y2-y1-H)-(BarHeight[i]*Ystep)),round(j+Xstep),(y2-y1)-H-1);
        Rectangle(j,round((y2-y1-H)-(BarHeight[i]*Ystep)),Round(j+Xstep),(y2-y1)-H-1);
      end;
      j:=Round(j+Xstep);
    end;
  end;
  WaitToGo;
end;

procedure Bar3DPlay;
// Demonstrate Bar3D command
const NumBars = 7;
      BarHeight: array[1..NumBars] of byte = (1, 3, 2, 5, 4, 2, 1);
      YTicks = 5;
var ViewInfo   : ViewPortType;
    H          : word;
    XStep,YStep: real;
    i,j        : integer;
    Depth      : word;
    Color      : word;
begin
  MainWindow('Bar3D / Rectangle demonstration');
  H:=3*TextH;
  GetViewSettings(ViewInfo);
  SetTextJustify(CenterText,TopText);
  SetTextStyle(ArialFont,HorizDir,14);
  OutTextXY(MaxX div 2,6,'These are 3D bars !');
  SetTextStyle(DefaultFont,HorizDir,14);
  with ViewInfo do SetViewPort(x1+50,y1+40,x2-50,y2-10,ClipOn);
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    Line(H,H,H,(y2-y1)-H);
    Line(H,(y2-y1)-H,(x2-x1)-H,(y2-y1)-H);
    YStep:=((y2-y1)-(2*H))/YTicks;
    XStep:=((x2-x1)-(2*H))/NumBars;
    j:=(y2-y1)-H;
    SetTextJustify(CenterText,CenterText);
    for i:=0 to Yticks do
    begin
      Line(H div 2,J,H,J);
      OutTextXY(10,J,Int2Str(i));
      j:=Round(j-Ystep);
    end;
    Depth:=Trunc(0.25*XStep);
    SetTextJustify(CenterText,TopText);
    j:=H;
    for i:=1 to Succ(NumBars) do
    begin
      SetColor(MaxColor);
      Line(j,(y2-y1)-H,j,(y2-y1-3)-(H div 2));
      OutTextXY(j,(y2-y1)-(H div 2),Int2Str(i-1));
      if (i <> Succ(NumBars)) then
      begin
        Color:=RandColor;
        SetFillStyle(i,Color);
        SetColor(Color);
        Bar3D(j,Round((y2-y1-H)-(BarHeight[i]*Ystep)),
                Round(j+Xstep-Depth),Round((y2-y1)-H-1),Depth,TopOn);
        j:=Round(j+Xstep);
      end;
    end;
  end;
  WaitToGo;
end;

procedure ArcPlay;
// Draw random arcs on the screen
var MaxRadius: word;
    EndAngle : word;
    ArcInfo  : ArcCoordsType;
begin
  MainWindow('Arc / GetArcCoords demonstration');
  StatusLine('Esc aborts or press a key');
  MaxRadius:=MaxY div 10;
  repeat
    SetColor(RandColor);
    EndAngle:=Random(360);
    SetLineStyle(SolidLn,0,NormWidth);
    Arc(Random(MaxX),Random(MaxY),Random(EndAngle),EndAngle,Random(MaxRadius));
    GetArcCoords(ArcInfo);
    with ArcInfo do begin
                      Line(X,Y,XStart,YStart);
                      Line(X,Y,Xend,Yend);
                    end;
  until KeyPressed;
  WaitToGo;
end;

procedure CirclePlay;
// Draw random circles on the screen
var MaxRadius: word;
begin
  MainWindow('Circle demonstration');
  StatusLine('Esc aborts or press a key');
  MaxRadius:=MaxY div 10;
  SetLineStyle(SolidLn,0,NormWidth);
  repeat
    SetColor(RandColor);
    Circle(Random(MaxX),Random(MaxY),Random(MaxRadius));
  until KeyPressed;
  WaitToGo;
end;

procedure PiePlay;
// Demonstrate  PieSlice and GetAspectRatio commands
var ViewInfo  : ViewPortType;
    CenterX   : integer;
    CenterY   : integer;
    Radius    : word;
    Xasp,Yasp : word;
    X,Y       : integer;

  function AdjAsp(Value:integer): integer;
  begin
    AdjAsp:=(longint(Value)*Xasp) div Yasp;
  end;

  procedure GetTextCoords(AngleInDegrees,Radius:word; var X,Y:integer);
  var Radians: real;
  begin
    Radians:=AngleInDegrees*Pi/180;
    X:=Round(Cos(Radians)*Radius);
    Y:=Round(Sin(Radians)*Radius);
  end;

begin
  MainWindow('PieSlice / GetAspectRatio demonstration');
  GetAspectRatio(Xasp,Yasp);
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    CenterX:=(x2-x1) div 2;
    CenterY:=((y2-y1) div 2)+20;
    Radius:=(y2-y1) div 3;
    while (AdjAsp(Radius) < Round((y2-y1)/3.6)) do Inc(Radius);
  end;
  SetTextStyle(DefaultFont,HorizDir,14);
  SetTextJustify(CenterText,TopText);
  OutTextXY(CenterX,0,'This is a pie chart!');
  SetFillStyle(SolidFill,RandColor);
  PieSlice(CenterX+10,CenterY-AdjAsp(10),0,90,Radius);
  GetTextCoords(45,Radius,X,Y);
  SetTextJustify(LeftText,BottomText);
  OutTextXY(CenterX+10+X+TextW,CenterY-AdjAsp(10+Y),'25 %');
  SetFillStyle(HatchFill,RandColor);
  PieSlice(CenterX,CenterY,225,360,Radius);
  GetTextCoords(293,Radius,X,Y);
  SetTextJustify(LeftText,TopText);
  OutTextXY(CenterX+X+TextW,CenterY-AdjAsp(Y),'37.5 %');
  SetFillStyle(XHatchFill,RandColor);
  PieSlice(CenterX-10,CenterY,135,225,Radius);
  GetTextCoords(180,Radius,X,Y);
  SetTextJustify(RightText,CenterText);
  OutTextXY(CenterX-10+X-TextW,CenterY-AdjAsp(Y),'25 %');
  SetFillStyle(BkSlashFill,RandColor);
  PieSlice(CenterX,CenterY,90,135,Radius);
  GetTextCoords(112,Radius,X,Y);
  SetTextJustify(RightText,BottomText);
  OutTextXY(CenterX+X-TextW,CenterY-AdjAsp(Y),'12.5 %');
  WaitToGo;
end;

procedure LineToPlay;
// Demonstrate MoveTo and LineTo commands
const MaxPoints = 15;
var Points    : array[0..MaxPoints] of PointType;
    ViewInfo  : ViewPortType;
    i,j       : integer;
    CenterX   : integer;
    CenterY   : integer;
    Radius    : word;
    StepAngle : word;
    Xasp,Yasp : word;
    Radians   : real;

  function AdjAsp(Value:integer):integer;
  begin
    AdjAsp:=(longint(Value)*Xasp) div Yasp;
  end;

begin
  MainWindow('MoveTo, LineTo demonstration');
  GetAspectRatio(Xasp,Yasp);
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    CenterX:=(x2-x1) div 2;
    CenterY:=(y2-y1) div 2;
    Radius:=CenterY;
    while ((CenterY+AdjAsp(Radius)) < (y2-y1)-20) do Inc(Radius);
  end;
  StepAngle:=360 div MaxPoints;
  for i:=0 to MaxPoints-1 do
  begin
    Radians:=(StepAngle*i)*Pi/180;
    Points[i].X:=CenterX+Round(Cos(Radians)*Radius);
    Points[i].Y:=CenterY-AdjAsp(Round(Sin(Radians)*Radius));
  end;
  Circle(CenterX,CenterY,Radius);
  for i:=0 to MaxPoints-1 do
  begin
    for j:=i to MaxPoints-1 do
    begin
      MoveTo(Points[i].X,Points[i].Y);
      LineTo(Points[j].X,Points[j].Y);
    end;
  end;
  WaitToGo;
end;

procedure LineRelPlay;
// Demonstrate MoveRel and LineRel commands
const MaxPoints = 12;
var Poly    : array[1..MaxPoints] of PointType;
    CurrPort: ViewPortType;

  procedure DrawTesseract;
  const CheckerBoard: FillPatternType = ($00,$10,$28,$44,$28,$10,$00,$00);
  var X,Y,W,H: integer;

  begin
    GetViewSettings(CurrPort);
    with CurrPort do
    begin
      W:=(x2-x1) div 9; H:=(y2-y1) div 8;
      X:=((x2-x1) div 2)-Round(2.5*W);
      Y:=((y2-y1) div 2)-(3*H);
      Poly[1].X:=0;     Poly[1].Y:=0;
      Poly[2].X:=x2-x1; Poly[2].Y:=0;
      Poly[3].X:=x2-x1; Poly[3].Y:=y2-y1;
      Poly[4].X:=0;     Poly[4].Y:=y2-y1;
      Poly[5].X:=0;     Poly[5].Y:=0;
      MoveTo(X,Y);
      MoveRel(0,H);    Poly[ 6].X:= GetX; Poly[ 6].Y := GetY;
      MoveRel(W,-H);   Poly[ 7].X:= GetX; Poly[ 7].Y := GetY;
      MoveRel(4*W,0);  Poly[ 8].X:= GetX; Poly[ 8].Y := GetY;
      MoveRel(0,5*H);  Poly[ 9].X:= GetX; Poly[ 9].Y := GetY;
      MoveRel(-W,H);   Poly[10].X:= GetX; Poly[10].Y := GetY;
      MoveRel(-4*W,0); Poly[11].X:= GetX; Poly[11].Y := GetY;
      MoveRel(0,-5*H); Poly[12].X:= GetX; Poly[12].Y := GetY;
      SetFillPattern(CheckerBoard,White);
      FillPoly(12,Poly);
      MoveRel(W,-H);
      LineRel(0,5*H);  LineRel(2*W,0); LineRel(0,-3*H);
      LineRel(W,-H);   LineRel(0,5*H); MoveRel(0,-5*H);
      LineRel(-2*W,0); LineRel(0,3*H); LineRel(-W,H);
      MoveRel(W,-H);   LineRel(W,0);   MoveRel(0,-2*H);
      LineRel(-W,0);
      FloodFill((x2-x1) div 2,(y2-y1) div 2,White);
    end;
  end;

begin
  MainWindow('LineRel / MoveRel demonstration');
  GetViewSettings(CurrPort);
  with CurrPort do SetViewPort(x1-1,y1-1,x2+1,y2+1,ClipOn);
  DrawTesseract;
  WaitToGo;
end;

procedure LineStylePlay;
// Demonstrate the predefined line styles available
var Style   : word;
    Step    : word;
    X,Y     : word;
    ViewInfo: ViewPortType;
begin
  DefaultColors;
  MainWindow('Pre-defined line styles');
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    X:=35; Y:=10;
    Step:=(x2-x1) div 11;
    SetTextJustify(LeftText,TopText);
    OutTextXY(X,Y,'All styles');
    SetTextJustify(CenterText,TopText);
    for Style:=0 to 4 do
    begin
      SetLineStyle(Style,0,NormWidth);
      Line(X,Y+20,X,Y2-50);
      OutTextXY(X,Y2-40,Int2Str(Style));
      Inc(X,Step);
    end;
    Inc(X,2*Step);
    SetTextJustify(LeftText,TopText);
    OutTextXY(X,Y,'All widths');
    SetTextJustify(CenterText,TopText);
    for Style:=1 to 4 do
    begin
      SetLineStyle(SolidLn,0,Style);
      Line(X,Y+20,X,Y2-50);
      OutTextXY(X,Y2-40,Int2Str(Style));
      Inc(X,Step);
    end;
  end;
  SetTextJustify(LeftText,TopText);
  WaitToGo;
end;

procedure UserLineStylePlay;
// Demonstrate user defined line styles
var Style   : word;
    X,Y,i   : word;
    ViewInfo: ViewPortType;
begin
  MainWindow('User defined line styles');
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    X:=4; Y:=10;
    Style:=0;
    i:=0;
    while (X < X2-4) do
    begin
      Style:=Style or (1 shl (i mod 16));
      SetLineStyle(UserBitLn,Style,NormWidth);
      Line(X,Y,X,(y2-y1)-Y);
      Inc(X,5);
      Inc(i);
      if (Style = 65535) then
      begin
        i:=0;
        Style:=0;
      end;
    end;
  end;
  WaitToGo;
end;

procedure TextDump;
// Dump the complete character sets to the screen
var Font    : word;
    ViewInfo: ViewPortType;
    Ch      : char;
begin
  for Font:=0 to 3 do
  begin
    MainWindow(Fonts[Font]+' character set');
    GetViewSettings(ViewInfo);
    with ViewInfo do
    begin
      SetTextJustify(LeftText,TopText);
      MoveTo(2,3);
      SetTextStyle(Font,HorizDir,18);
      Ch:='!';
      repeat
        OutText(Ch);
        if (GetX+TextW > (x2-x1)) then MoveTo(2,GetY+TextH+3);
        Ch:=Succ(Ch);
      until (Ch >= #255);
    end;
    WaitToGo;
  end;
end;

procedure TextPlay;
// Demonstrate text justifications and text sizing
var Size    : word;
    H,X,Y   : word;
    ViewInfo: ViewPortType;
begin
  MainWindow('SetTextJustify / SetUserCharSize demo');
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    SetTextStyle(ArialFont,HorizDir,14);
    SetTextJustify(LeftText,TopText);
    OutTextXY(2*TextW,2,'Horizontal');
    SetTextJustify(CenterText,CenterText);
    X:=(x2-x1) div 2;
    Y:=TextH;
    for Size:=1 to 5 do
    begin
      SetTextStyle(DefaultFont,HorizDir,6*Size+2);
      H:=TextHeight('H');
      Inc(Y,H);
      OutTextXY(X,Y,'Size '+Int2Str(Size));
    end;
    SetTextStyle(ArialFont,HorizDir,64);
    H:=TextHeight('H');
    Inc(Y,H);
    OutTextXY(X,Y,'Any size');
    Inc(Y,H div 2);
    SetTextJustify(CenterText,TopText);
    SetUserCharSize(15,15,0,0);
    SetTextStyle(ArialFont,HorizDir,14);
    OutTextXY((x2-x1) div 2,Y,'User defined space size');
    SetUserCharSize(0,0,0,0);
    SetTextStyle(ArialFont,315,18);
    Y:=(y2-y1)-100;
    SetTextJustify(LeftText,BottomText);
    OutTextXY(2*TextW,Y,'Arbitrary direction');
  end;
  WaitToGo;
end;

procedure CrtModePlay;
// Demonstrate the use of RestoreCrtMode and SetGraphMode
var ViewInfo : ViewPortType;
begin
  MainWindow('SetGraphMode / RestoreCrtMode demo');
  GetViewSettings(ViewInfo);
  SetTextJustify(CenterText,CenterText);
  with ViewInfo do
  begin
    OutTextXY((x2-x1) div 2,(y2-y1) div 2,'Now you are in graphics mode');
    StatusLine('Press any key for text mode...');
    repeat until KeyPressed;
    RestoreCrtmode;
    Writeln('Now you are in text mode.');
    Write('Press ENTER key to go back to graphics...');
    Readln;
    SetGraphMode(GetGraphMode);
    MainWindow('SetGraphMode / RestoreCrtMode demo');
    SetTextJustify(CenterText,CenterText);
    OutTextXY((x2-x1) div 2,(y2-y1) div 2,'Back in graphics mode...');
  end;
  WaitToGo;
end;

procedure FillStylePlay;
// Display all of the predefined fill styles available
var Style   : word;
    Width   : word;
    Height  : word;
    X,Y     : word;
    i,j     : word;
    ViewInfo: ViewPortType;

  procedure DrawBox(X,Y:word);
  begin
    SetFillStyle(Style,White);
    with ViewInfo do Bar(X,Y,X+Width,Y+Height);
    Rectangle(X,Y,X+Width,Y+Height);
    OutTextXY(X+(Width div 2),Y+Height+4,Int2Str(Style));
    Inc(Style);
  end;

begin
  MainWindow('Pre-defined fill styles');
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    Width:=2*((x2+1) div 13);
    Height:=2*((y2-10) div 10);
  end;
  X:=Width div 2; Y:=Height div 2;
  Style:=0;
  for j:=1 to 2 do
  begin
    for i:=1 to 4 do begin
                       DrawBox(X,Y);
                       Inc(X,(Width div 2)*3);
                     end;
    X:=Width div 2;
    Inc(Y,(Height div 2)*3);
  end;
  SetTextJustify(LeftText,TopText);
  WaitToGo;
end;

procedure FillPatternPlay;
// Display some user defined fill patterns
const Patterns: array[0..11] of FillPatternType = (
      ($AA,$55,$AA,$55,$AA,$55,$AA,$55),
      ($33,$33,$CC,$CC,$33,$33,$CC,$CC),
      ($F0,$F0,$F0,$F0,$0F,$0F,$0F,$0F),
      ($00,$10,$28,$44,$28,$10,$00,$00),
      ($00,$70,$20,$27,$25,$27,$04,$04),
      ($00,$00,$00,$18,$18,$00,$00,$00),
      ($00,$00,$3C,$3C,$3C,$3C,$00,$00),
      ($00,$7E,$7E,$7E,$7E,$7E,$7E,$00),
      ($00,$00,$22,$08,$00,$22,$1C,$00),
      ($FF,$7E,$3C,$18,$18,$3C,$7E,$FF),
      ($00,$10,$10,$7C,$10,$10,$00,$00),
      ($00,$42,$24,$18,$18,$24,$42,$00));
var Style   : word;
    Width   : word;
    Height  : word;
    X,Y     : word;
    i,j     : word;
    ViewInfo: ViewPortType;

  procedure DrawBox(X,Y:word);
  begin
    SetFillPattern(Patterns[Style],White);
    with ViewInfo do Bar(X,Y,X+Width,Y+Height);
    Rectangle(X,Y,X+Width,Y+Height);
    Inc(Style);
  end;

begin
  MainWindow('User defined fill styles');
  GetViewSettings(ViewInfo);
  with ViewInfo do
  begin
    Width:=2*((x2+1) div 13);
    Height:=2*((y2-10) div 10);
  end;
  X:=Width div 2; Y:=Height div 2;
  Style:=0;
  for j:=1 to 3 do
  begin
    for i:=1 to 4 do begin
                       DrawBox(X,Y);
                       Inc(X,(Width div 2)*3);
                     end;
    X:=Width div 2;
    Inc(Y,(Height div 2)*3);
  end;
  SetTextJustify(LeftText,TopText);
  WaitToGo;
end;

procedure PolyPlay;
// Draw random polygons with random fill styles on the screen
const MaxPts = 5;
type PolygonType = array[1..MaxPts] of PointType;
var Poly   : PolygonType;
    i,Color: word;
begin
  MainWindow('FillPoly demonstration');
  StatusLine('Esc aborts or press a key...');
  repeat
    Color:=RandColor;
    SetFillStyle(Random(7)+1,Color);
    SetColor(Color);
    for i:=1 to MaxPts do with Poly[i] do
    begin
      X:=Random(MaxX); Y:=Random(MaxY);
    end;
    FillPoly(MaxPts,Poly);
  until KeyPressed;
  WaitToGo;
end;

procedure OpenGLPlay;
// OpenGL demonstration
const icos = 1;
var ViewInfo: ViewPortType;
    i,sp    : integer;
    rx,ry,rz: GLfloat;

  procedure InitScenery;
  begin
    glClearColor(0.0,0.0,0.0,1.0);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(30,GetMaxX/GetMaxY,0.1,10000);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(0,0,-5);
    glEnable(GL_DEPTH_TEST);
  end;

  procedure DrawScenery;
  const x = 0.525731112119133606;
        z = 0.850650808352039932;
        vdata: array[0..11,0..2] of GLfloat = (
               (-x, 0.0, z), (x, 0.0, z), (-x, 0.0, -z), (x, 0.0, -z),
               (0.0, z, x), (0.0, z, -x), (0.0, -z, x), (0.0, -z, -x),
               (z, x, 0.0), (-z, x, 0.0), (z, -x, 0.0), (-z, -x, 0.0));
        tindices: array[0..19,0..2] of longint = (
                  (0,4,1), (0,9,4), (9,5,4), (4,5,8), (4,8,1),
                  (8,10,1), (8,3,10), (5,3,8), (5,2,3), (2,7,3),
                  (7,10,3), (7,6,10), (7,11,6), (11,0,6), (0,1,6),
                  (6,1,10), (9,0,11), (9,11,2), (9,2,5), (7,2,11));
  var i,j: longint;
  begin
    glNewList(icos,GL_COMPILE);
      for i:=0 to 19 do
      begin
        glBegin(GL_TRIANGLES);
          glColor3f(Random,Random,Random);
          j:=tindices[i,0]; glVertex3f(vdata[j,0],vdata[j,1],vdata[j,2]);
          j:=tindices[i,1]; glVertex3f(vdata[j,0],vdata[j,1],vdata[j,2]);
          j:=tindices[i,2]; glVertex3f(vdata[j,0],vdata[j,1],vdata[j,2]);
        glEnd();
      end;
    glEndList();
  end;

begin
  MainWindow('OpenGL demonstration');
  StatusLine('Esc aborts or press a key...');
  SetOpenGLMode(DirectOn);
  GetViewSettings(ViewInfo);
  with ViewInfo do glViewPort(x1,y1,x2-x1+1,y2-y1+1);
  InitScenery; DrawScenery;
  i:=1;
  sp:=1+Random(6); rx:=2*Random-1; ry:=2*Random-1; rz:=2*Random-1;
  repeat
    Dec(i);
    if (i = 0) then
    begin
      sp:=1+Random(6); rx:=2*Random-1; ry:=2*Random-1; rz:=2*Random-1;
      i:=100;
    end;
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
    glRotatef(sp,rx,ry,rz);
    glCallList(icos);
    UpdateGraph(UpdateNow);
  until KeyPressed;
  SetOpenGLMode(DirectOff);
  Delay(100);
  WaitToGo;
end;

procedure SayGoodbye;
// Say goodbye and then exit the program
var ViewInfo: ViewPortType;
begin
  MainWindow('');
  GetViewSettings(ViewInfo);
  SetTextStyle(DefaultFont or BoldFont,HorizDir,3);
  SetTextJustify(CenterText,CenterText);
  with ViewInfo do OutTextXY((x2-x1) div 2,(y2-y1) div 2,'That''s all folks!');
  StatusLine('Press any key to quit...');
  repeat until KeyPressed;
end;

begin
  Writeln('This program illustrates some capabilities of the WinGraph Unit.');
  Writeln('Press ENTER to proceed!'); Readln;
  Initialize;
  ReportStatus;
  AspectRatioPlay;
  FillEllipsePlay;
  SectorPlay;
  WriteModePlay;
  ColorPlay;
  PalettePlay;
  PutPixelPlay;
  PutImagePlay;
  RandBarPlay;
  BarPlay;
  Bar3DPlay;
  ArcPlay;
  CirclePlay;
  PiePlay;
  LineToPlay;
  LineRelPlay;
  LineStylePlay;
  UserLineStylePlay;
  TextDump;
  TextPlay;
  CrtModePlay;
  FillStylePlay;
  FillPatternPlay;
  PolyPlay;
  OpenGLPlay;
  SayGoodbye;
end.

