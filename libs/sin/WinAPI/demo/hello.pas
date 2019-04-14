// Hello world program
program hello;
{$APPTYPE GUI}
uses wingraph;

var mess   : string;
    gd,gm  : smallint;
    errcode: smallint;

begin
  gd:=Detect;
  InitGraph(gd,gm,'');
  errcode:=GraphResult;
  if (errcode = grOK) then
  begin
    mess:='Hello world by WinGraph';
    OutTextXY((GetMaxX-TextWidth (mess)) div 2,
              (GetMaxY-TextHeight(mess)) div 2,mess);
    repeat until CloseGraphRequest;
    CloseGraph;
  end;
end.
