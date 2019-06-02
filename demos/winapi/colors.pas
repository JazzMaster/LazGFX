// Program used to generate the picture 'colors.gif'
{$APPTYPE GUI}
program colors;
uses wingraph,wincrt,winmouse,sysutils;

var f            : text;
    line         : string[22];
    pal          : PaletteType;
    i,h,x0,y0,x,y: smallint;
    gd,gm        : smallint;
    col          : longword;
    r,g,b        : word;
    s            : shortstring;
begin
  {$I-} Assign(f,'colors.dat'); Reset(f); {$I+}
  if (IOResult <> 0) then Halt(1);
  gd:=nopalette; gm:=m1024x768;
  GetNamesPalette(pal);
  InitGraph(gd,gm,'');
  Rectangle(0,0,GetMaxX,GetMaxY);
  SetTextStyle(ArialFont,0,14);
  h:=TextHeight('H');
  i:=0;
  while not(Eof(f)) do with pal do
  begin
    Readln(f,line);
    x:=200*(i div 53); y:=h*(i mod 53);
    SetFillStyle(SolidFill,colors[i]);
    Bar(20+x,15+y,70+x,22+y);
    OutTextXY(90+x,12+y,line);
    Inc(i);
  end;
  Close(f);
  x0:=-1; y0:=-1;
  repeat
    x:=GetMouseX; y:=GetMouseY;
    if (x <> x0) or (y <> y0) then
    begin
      x0:=x; y0:=y;
      col:=GetPixel(x,y);
      SetColor(White); SetFillStyle(SolidFill,col);
      FillRect(820,655,980,740);
      GetRGBComponents(col,r,g,b);
      if (r+g+b < 300) then SetColor(White) else SetColor(Black);
      MoveTo(860,680); OutText('RGB: ');
      Str(r,s); OutText(s+', ');
      Str(g,s); OutText(s+', ');
      Str(b,s); OutText(s);
      MoveTo(860,700); OutText('HEX: $');
      s:=IntToHex(col,6); OutText(s);
    end;
    Delay(10);
  until KeyPressed;
  CloseGraph;
end.
