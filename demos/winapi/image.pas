{$APPTYPE CONSOLE}
program image;
uses wingraph,wincrt;
const  width = 32; //image width and height
      height = 32;
      Pi12 = Pi/12;
var bitmap: pointer;
    anim  : AnimatType;
    size,i: longint;
    gd,gm : smallint;
    f     : file;
begin
  size:=ImageSize(1,1,width,height);
  GetMem(bitmap,size);
  {$I-} Assign(f,'comp.bmp'); Reset(f,1); {$I+}
  if (IOResult <> 0) or (FileSize(f) <> size) then
  begin
    writeln('Error: unable to load image file.');
    Exit;
  end;
  BlockRead(f,bitmap^,size);
  Close(f);
  gd:=NoPalette; gm:=mCustom;
  SetWindowSize(200,200);
  InitGraph(gd,gm,'');
  Rectangle(10,10,GetMaxX-10,GetMaxY-10);
  OutTextXY(50,20,'Static image');
  OutTextXY(50,120,'Dynamic image');
  PutImage(80,40,bitmap^,NormalPut);
  FreeMem(bitmap);
  GetAnim(80,40,80+width-1,40+height-1,Black,anim);
  PutAnim(80,140,anim,CopyPut);
  Delay(500);
  i:=0;
  UpdateGraph(UpdateOff); //used to reduce flickering
  repeat
    Delay(25);
    PutAnim(80+Round(10*Sin(i*Pi12)),130+Round(10*Cos(i*Pi12)),anim,BkgPut);
    Inc(i);
    PutAnim(80+Round(10*Sin(i*Pi12)),130+Round(10*Cos(i*Pi12)),anim,TransPut);
    UpdateGraph(UpdateNow);
  until KeyPressed;
  FreeAnim(anim);
  CloseGraph;
end.

