unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    procedure Create(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;


var
  Form2: TForm2;

implementation

{$R *.lfm}

procedure TForm2.Create(Sender: TObject);
begin
  Form2.Color:=clSkyBlue;
  Form2.Height:=495;

  canvas.brush.color:=clBlue;
  canvas.rectangle(0,310,form2.Width,form2.Height);

  canvas.pen.color:=clRed;
  canvas.brush.color:=clYellow;
  canvas.polygon([point(180,60),point(180,380),point(340,380)]);
  canvas.polygon([point(180,60),point(145,120),point(120,180),point(105,240),point(110,300),point(120,340),point(145,375),point(175,380),point(160,340),point(145,300),point(140,240),point(150,180),point(160,120)]);

  canvas.brush.color:=clred;
  canvas.polygon([point(80,395),point(130,420),point(360,420),point(380,400)]);
  canvas.polygon([point(180,40),point(180,60),point(220,50)]);

  canvas.brush.color:=clred;
  canvas.rectangle(180,40,178,420);
  canvas.brush.color:=clSkyBlue;;
  canvas.Font.color:=clGreen;
  canvas.Font.size:=18;
  canvas.TextOut(48,35,'Lazarus paint demo');

end;

end.

