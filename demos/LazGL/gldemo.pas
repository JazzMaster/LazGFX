unit gldemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, OpenGLContext, gl;

type
  { TForm1 }
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure GLboxPaint(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
 var
  GLBox:TOpenGLControl;
{ TForm1 }

procedure TForm1.GLboxPaint(Sender: TObject);
begin
//  glClearColor(0.27, 0.53, 0.71, 1.0); //Set blue background
//  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glLoadIdentity;
  glBegin(GL_TRIANGLES);
    glColor3f(1, 0, 0);
    glVertex3f( 0.0, 1.0, 0.0);
    glColor3f(0, 1, 0);
    glVertex3f(-1.0,-1.0, 0.0);
    glColor3f(0, 0, 1);
    glVertex3f( 1.0,-1.0, 0.0);
  glEnd;
  GLbox.SwapBuffers;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GLbox:= TOpenGLControl.Create(Form1);
  GLbox.AutoResizeViewport:= true;
  GLBox.Parent := self;
  GLBox.MultiSampling:= 4;
  GLBox.Align := alClient;
  GLBox.OnPaint := @GLboxPaint; //for "mode delphi" this would be "GLBox.OnPaint := GLboxPaint"
 // GLBox.invalidate;
end;

end.
