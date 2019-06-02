// the body of Execute routine contains the old BP7 graph code;
// a separate thread is creating for doing graphics with WinGraph
unit maincode;

interface

uses
  Classes, wingraph, wincrt;

type
  TGraphThread = class(TThread)
  public
    SignalMain: procedure(mess: string);
    constructor Create(item1,item2,item3,cw,ch:integer);
  protected
    gd,gm,gp: integer;
    err_code: integer;
    err_mess: string;
    procedure Execute; override;
    procedure OnExit(Sender: TObject);
  end;

var GraphThread : TGraphThread;
implementation


procedure TGraphThread.OnExit(Sender: TObject);
begin
  if (err_code <> grOK) then err_mess:=GraphErrorMsg(err_code)
                        else err_mess:='none';
  if GraphEnabled then CloseGraph;
  SignalMain(err_mess);
end;

constructor TGraphThread.Create(item1,item2,item3,cw,ch:integer);
begin
  case item1 of
    1: gd:=D1bit;
    2: gd:=D4bit;
    3: gd:=D8bit;
    4: gd:=nopalette;
  else
    gd:=detect;
  end;
  case item2 of
     0: gm:=m320x200;
     1: gm:=m640x200;
     2: gm:=m640x350;
     3: gm:=m640x480;
     4: gm:=m720x350;
     5: gm:=m800x600;
     6: gm:=m1024x768;
     7: gm:=m1280x1024;
     8: gm:=mDefault;
     9: gm:=mMaximized;
    10: gm:=mFullScr;
    11: gm:=mCustom;
  end;
  gp:=item3;
  SetWindowSize(cw,ch); //only if needed
  OnTerminate:=OnExit;
  inherited Create(true);
end;

procedure GetMonoPalette(var palette:PaletteType); //user defined palette
var i,shade: longint;
begin
  with palette do
  begin
    size:=64; if (size > GetMaxColor+1) then size:=GetMaxColor+1;
    for i:=0 to size-1 do
    begin
      shade:=(255*i) div (size-1);
      colors[i]:=shade+(shade shl 8)+(shade shl 16);
    end;
  end;
end;

procedure TGraphThread.Execute;
var pal           : PaletteType;
    c,w,h,r,nr,x,y: longint;
    i,j,k         : integer;
    d             : double;
    gDriver,gMode : smallint;
begin
  gDriver:=gd; gMode:=gm;
  InitGraph(gDriver,gMode,'');
  err_code:=GraphResult; if (err_code <> grOK) then Exit;
  SetWriteMode(Opaque);
  if (gDriver <> nopalette) then
  begin
    case gp of
      0: GetDefaultPalette(pal);
      1: GetNamesPalette(pal);
      2: GetSystemPalette(pal);
      3: GetMonoPalette(pal);
    end;
    SetAllPalette(pal);
  end;
  err_code:=GraphResult; if (err_code <> grOK) then Exit;
  w:=GetMaxX+1; h:=GetMaxY+1;
  SetBkColor(Yellow); SetColor(Black); SetTextJustify(CenterText,TopText);
  OutTextXY(w div 2,h div 2,GetDriverName+' / '+GetModeName(GetGraphMode));
  SetBkColor(Black);
  SetColor(White); SetTextJustify(LeftText,TopText);
  if (gDriver <> nopalette) then
  begin
    Delay(500);
    SetActivePage(1);
    SetBkColor(Black); ClearViewPort;
    d:=Sqrt(GetMaxColor+3); w:=Round(w/d); h:=Round(h/d);
    nr:=Round(d); if (nr = 1) then nr:=2; r:=h div 3;
    for c:=0 to GetMaxColor do
    begin
      x:=(w div 2)+w*(c mod nr); y:=(h div 2)+h*(c div nr);
      SetFillStyle(SolidFill,c); FillEllipse(x,y,r,r);
    end;
  end                  else
  begin
    OutTextXY(0,h-TextHeight('H'),'Please wait...');
    SetActivePage(1);
    nr:=Round(Exp(Ln(w*h)/3)); {nr = (w*h)^(1/3)}
    d:=255/(nr-1); c:=0;
    for i:=nr-1 downto 0 do
    begin
      if KeyPressed or CloseGraphRequest or Terminated then Break;
      for j:=nr-1 downto 0 do for k:=nr-1 downto 0 do
      begin
        x:=c mod GetMaxX; y:=c div GetMaxX;
        Inc(c);
        PutPixel(x,y,GetRGBColor(Round(d*k),Round(d*j),Round(d*i)));
      end;
    end;
  end;
  SetVisualPage(1);
  Delay(200);
  repeat
    Delay(10);
  until KeyPressed or CloseGraphRequest or Terminated;
  CloseGraph;
  err_code:=GraphResult;
end;

end.
