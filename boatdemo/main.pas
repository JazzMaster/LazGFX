unit main;
//the TCanvas Lazarus "boat demo" in "getting started w lazarus and freepascal" by menkaura abiola-ellison
//"come sail away...."
{$mode objfpc}{$H+}

interface
//note: his code is wrong and has been corrected to run ok.
//technically waits for click but the form data says not to and to render on Load (or equivalent) instead.
//this took me a minute to figure out.
//--Jazz
uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
  private
     { private declarations }
  public
      Button1: TButton;
  end;

  canvas1 = class(TCanvas)
  private
  public
  end;
var
  Form1: TForm1;
  canvasd: canvas1;

implementation

{$R *.lfm}

Procedure TForm1.onClick(Sender:TObject);
begin
  Form1.Color:=clSkyBlue;
  Form1.Height:=495;

  canvasd.Brush.Color:=clBlue;
  canvasd.Rectangle(0,310,form1.width,form1.height);
  canvasd.pen.color:=clYellow;
  canvasd.polygon([point(180,60),point(180,380),point(340,380)]);
  canvasd.polygon([point(180,60),point(145,120),point(120,180),point(105,240),point(110,300),point(120,340),point(145,375),point(175,380),point(160,340),point(145,300),point(140,240),point(150,180),point(160,120)]);
  canvasd.brush.color:=clred;
  canvasd.polygon([point(80,395),point(130,420),point(360,420),point(380,400)]);
  canvasd.polygon([point(180,40),point(180,60),point(220,50)]);
  canvasd.rectangle(180,40,178,420);

end;

end.

