// see the file 'funny.dat'
program funny;
{$APPTYPE GUI}
{$R wingraph.res}
uses wingraph,wincrt,winmouse;

type Twheel = record
                a,b,cx,cy,dur,rot,dir,spd: integer;
                color                    : longword;
              end;
     Tball = record
                rad,x0,y0        : integer;
                xdir,ydir,spd,fac: double;
                color            : longword;
              end;
   Tbanner = record
               x0,y0,del,rot,dir,spd: integer;
               color                : longword;
               mes                  : string;
             end;
      Ttxt = record
               x0,y0,spd: integer;
               mes      : string;
             end;
const RD: double = Pi/180;
         NrBalls = 16;

var gd,gm : smallint;
    wheel : Twheel;
    ball  : array[1..NrBalls] of Tball;
    banner: Tbanner;
    f     : text;
    txt   : Ttxt;
    ch    : char;
    i     : longint;

procedure Init;
var i: longint;
begin
  Randomize;
  {$I-} Assign(f,'funny.dat'); Reset(f); {$I+}
  if (IOResult <> 0) then Halt(1);
  gd:=D4bit; gm:=mDefault; InitGraph(gd,gm,'');
  UpdateGraph(UpdateOff);
  with wheel do
  begin
    a:=80; b:=30; cx:=GetMaxX div 2; cy:=GetMaxY div 2;
    dur:=50; rot:=0; spd:=0; dir:=1;
    color:=Yellow;
    for i:=1 to NrBalls do with ball[i] do
    begin
      rad:=10; x0:=i*(GetMaxX div (NrBalls+1)); y0:=2*(rad+i);
      xdir:=10; ydir:=-10; spd:=3;
      fac:=spd/Sqrt(xdir*xdir+ydir*ydir);
      if (i mod 3 = 1) then color:=LightBlue else color:=LightRed;
    end;
  end;
  with banner do
  begin
    del:=200; color:=LightGreen; mes:='FUNNY!';
  end;
  with txt do
  begin
    y0:=GetMaxY-20; spd:=4; mes:='';
  end;
end;

procedure DisplayText;
begin
  with txt do if (mes <> '') then
  begin
    Dec(x0,spd);
    SetWriteMode(Opaque);
    SetTextJustify(LeftText,TopText);
    SetTextStyle(ArialFont or ItalicFont or BoldFont,0,18);
    SetColor(White);
    OutTextXY(x0,y0,mes);
    if (x0+TextWidth(mes) < 0) then mes:='';
  end                        else
  if not(Eof(f)) then begin
                        x0:=GetMaxX;
                        Readln(f,mes);
                      end;
end;

procedure RotateWheel;
begin
  with wheel do
  begin
    if (dur = 0) then
    begin
      dur:=1+Random(180); dir:=1-2*Random(2); spd:=1+Random(10);
    end;
    rot:=rot+spd*dir; Dec(dur);
    SetColor(color);
    RotEllipse(cx,cy,rot,a,b);
    SetFillStyle(SolidFill,color);
    FloodFill(cx,cy,color);
    SetFillStyle(SolidFill,Black);
    FillEllipse(cx,cy,3,3);
  end;
end;

procedure TestCollision(i: longint);
var u,r,dx,dy,dr,px,py,pr,tx,ty: double;
begin
  with wheel,ball[i] do
  begin
    if (x0 < rad) or (x0 > GetMaxX-rad) then xdir:=-xdir;
    if (y0 < rad) or (y0 > GetMaxY-rad) then ydir:=-ydir;
    dx:=x0-cx; dy:=-(y0-cy); dr:=dx*dx+dy*dy;
    if (a >= b) then r:=a else r:=b;
    if (dr < r*r) then
    begin
      if (dx <> 0) then u:=ArcTan(dy/dx) else u:=Pi/2; if (dx < 0) then u:=u+Pi;
      r:=rot*RD;
      u:=u-r;
      px:=a*Cos(r)*Cos(u)-b*Sin(r)*Sin(u);
      py:=a*Sin(r)*Cos(u)+b*Cos(r)*Sin(u);
      pr:=px*px+py*py;
      tx:=-a*Cos(r)*Sin(u)-b*Sin(r)*Cos(u);
      ty:=-a*Sin(r)*Sin(u)+b*Cos(r)*Cos(u);
      if (dr+rad*rad <= pr) then
      begin
        xdir:=ty; ydir:=-tx;
        ball[i].spd:=Sqrt(pr)*wheel.spd*RD;
        fac:=ball[i].spd/Sqrt(xdir*xdir+ydir*ydir);
        if (color = LightGray) then
          if (i mod 3 = 1) then color:=LightBlue else color:=LightRed;
      end;
    end;
  end;
end;

procedure MoveBall(i: longint);
begin
  TestCollision(i);
  with ball[i] do
  begin
    x0:=x0+Round(fac*xdir); y0:=y0-Round(fac*ydir);
  end;
end;

procedure DisplayBall(i: longint);
var s: string;
begin
  with ball[i] do
  begin
    SetColor(color);
    SetFillStyle(SolidFill,color);
    FillEllipse(x0,y0,rad,rad);
    SetColor(White); SetBkColor(color);
    SetTextJustify(CenterText,BaselineText);
    SetTextStyle(ArialFont or BoldFont,0,16);
    Str(i,s); OutTextXY(x0,y0+5,s);
  end;
end;

procedure DisplayCurve;
var pt: array[1..NrBalls] of PointType;
    i : longint;
begin
  for i:=1 to NrBalls do with ball[i] do
  begin
    pt[i].x:=x0; pt[i].y:=y0;
  end;
  SetLineStyle(SolidLn,0,2);
  SetColor(LightBlue);
  DrawBezier(NrBalls,pt);
  SetLineStyle(SolidLn,0,1);
end;

procedure TestMouse;
var i: longint;
begin
  if (GetMouseButtons and MouseLeftButton <> 0) then
  begin
    for i:=1 to NrBalls do with ball[i] do
    if (Sqr(x0-GetMouseX)+Sqr(y0-GetMouseY) <= Sqr(rad)) then
    begin
      xdir:=0; ydir:=0; color:=LightGray;
      Break;
    end;
  end;
end;

procedure RotateBanner;
var w: longint;
begin
  with banner do
  begin
    w:=TextWidth(mes);
    if (del <= 0) then
    begin
      if (del = 0) then
      begin
        x0:=-w; y0:=w+Random(GetMaxY-2*w);
        rot:=0; dir:=1-2*Random(2); spd:=1+Random(10);
      end;
      rot:=rot+dir*spd; if (rot < 0) then rot:=360+rot;
      SetWriteMode(Transparent);
      SetColor(color);
      SetTextJustify(CenterText,TopText);
      SetTextStyle(TimesNewRomanFont,rot,24);
      OutTextXY(x0,y0,mes);
      Inc(x0,11-spd);
      if (x0-w > GetMaxX) then del:=integer(Random(1000));
    end;
    Dec(del);
  end;
end;

procedure Ending;
var bit,bitinv: AnimatType;
    i         : smallint;
begin
  GetAnim(0,0,GetMaxX,GetMaxY,LightGray,bit);
  InvertRect(0,0,GetMaxX,GetMaxY);
  GetAnim(0,0,GetMaxX,GetMaxY,Black,bitinv);
  i:=0;
  repeat
    Inc(i,7);
    PutAnim(0,0,bitinv,CopyPut);
    PutAnim(0,i,bit,TransPut);
    UpdateGraph(UpdateNow);
    Delay(10);
  until (i >= GetMaxY);
  FreeAnim(bit); FreeAnim(bitinv);
  Close(f);
  Delay(200);
end;

begin
  Init;
  ch:=#0;
  repeat
    SetFillStyle(SolidFill,Black);
    SetBkColor(Black); ClearViewPort;
    DisplayText;
    RotateWheel;
    for i:=1 to NrBalls do MoveBall(i);
    DisplayCurve;
    for i:=1 to NrBalls do DisplayBall(i);
    RotateBanner;
    UpdateGraph(UpdateNow);
    Delay(20);
    TestMouse;
    if KeyPressed then begin
                         ch:=ReadKey; if (ch = #0) then ch:=ReadKey;
                       end;
  until (ch in [#27,#107]);
  Ending;
end.

