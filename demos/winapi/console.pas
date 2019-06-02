//Emulation of a graphic console
program console;
{$APPTYPE GUI}
uses wingraph,wincrt;

var gd,gm: smallint;
    str  : shortstring;
begin
  gd:=NoPalette; gm:=m720x350;
  InitGraph(gd,gm,'WinGraph '+WinGraphVer);
  if (GraphResult <> grOK) then Halt;
  SetBkColor(Black); ClearViewPort;
  SetColor(WhiteSmoke); WriteBuf('Write some text below and then press ENTER key'+#13);
  SetColor(Pear); ReadBuf(str,0);
  SetColor(WhiteSmoke); WriteBuf('You wrote:'+#13);
  SetColor(Salmon); WriteBuf(str+#13);
  SetColor(WhiteSmoke);
  WriteBuf(#13+'...but with a different color!'+#13);
  WriteBuf(#13+'Now close the window using your mouse!'+#13);
  repeat Delay(10); until CloseGraphRequest;
  CloseGraph;
end.
