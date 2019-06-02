// Playing with colors in Windows
program picture;
{$APPTYPE GUI}
uses wingraph,wincrt;

var k,s,x,y : longint;
    vr,vg,vb: longint;
    r,g,b   : smallint;
    r1,g1,b1,
    r2,g2,b2: word;
    i,j     : word;
    p       : word;
    gd,gm   : smallint;

function Choose(a,b:longint): smallint;
var c: longint;
begin
  if (a > b) then
  begin
    c:=a; a:=b; b:=c;
  end;
  a:=a-y; b:=b+y;
  if (a < 0) then a:=0; if (b > 255) then b:=255;
  Choose:=Random(b-a+1)+a;
end;

begin
  Randomize;
  gd:=nopalette; gm:=mFullScr;
  InitGraph(gd,gm,'Picture generator');
  OutTextXY(2,GetMaxY-2*TextHeight('H'),'Wait few seconds to generate first picture');
  OutTextXY(2,GetMaxY-TextHeight('H'),'Press any key to stop');
  p:=1;
  repeat
    SetActivePage(p);
    x:=1+10*Random(100); y:=Random(10);
    s:=0; k:=s;
    for j:=0 to GetMaxY do for i:=0 to GetMaxX do
    begin
      if (k = s) then
      begin
        if KeyPressed then Halt;
        vr:=Random(3)-1; vg:=Random(3)-1; vb:=Random(3)-1;
        s:=Random(x);
        k:=0;
      end        else Inc(k);
      if (j = 0) then
      begin
        if (i = 0) then
        begin
          r:=Random(256)+0; g:=Random(256)+0; b:=Random(256)+0;
        end;
      end        else
      begin
        if (i = 0) then
        begin
          GetRGBComponents(GetPixel(i,j-1),word(r),word(g),word(b));
          if (j = GetMaxY div 2) then
          begin
            SetActivePage(1-p);
            InvertRect(0,0,GetMaxX,GetMaxY);
            SetActivePage(p);
          end; 
        end        else
        begin
          GetRGBComponents(GetPixel(i,j-1),r1,g1,b1);
          GetRGBComponents(GetPixel(i-1,j),r2,g2,b2);
          r:=Choose(r1,r2); g:=Choose(g1,g2); b:=Choose(b1,b2);
        end;
      end;
      r:=r+vr; g:=g+vg; b:=b+vb;
      if (r < 0) then begin r:=0; vr:=-vr; end; if (r > 255) then begin r:=255; vr:=-vr; end;
      if (g < 0) then begin g:=0; vg:=-vg; end; if (g > 255) then begin g:=255; vg:=-vg; end;
      if (b < 0) then begin b:=0; vb:=-vb; end; if (b > 255) then begin b:=255; vb:=-vb; end;
      PutPixel(i,j,GetRGBColor(r,g,b));
    end;
    SetVisualPage(p);
    p:=1-p;
  until KeyPressed;
end.
