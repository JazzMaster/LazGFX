unit uCrosstest;
{$ifdef mswindows}
     Set8087CW($133F); //fix GTK bug
{$endif}
{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  dglOpenGL, GLContext,gdk2x, gtk2, gdk2;

//since using GTK- give us some control back
var
  widget:PGtkWidget;
  pixmap:PGdkPixmap;
  LastBoundTexID:Cardinal;
type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    FContext: TGLContext;
    runtime: double;
  public
    { public declarations }
    procedure Idle(Sender: TObject; var Done: boolean);
    procedure Render;
  end;


var
  Form1: TForm1;
  texture:PGLuint;
implementation

{$R *.lfm}
const
  FOV = 45;
  CLIP_NEAR = 0.1;
  CLIP_FAR = 1000;

procedure glResizeWnd(Width, Height : Integer);
begin
  if (Height = 0) then Height := 1;
  glViewport(0, 0, Width, Height);    // Set the Viewport for OpenGL
  glMatrixMode(GL_PROJECTION);        // set Matrix Mode and Projection
  glLoadIdentity();                   // Reset View
  gluPerspective(FOV, Width/Height, CLIP_NEAR, CLIP_FAR);  // set Perspective
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();                   // Reset View
end;

{ TForm1 }

procedure TForm1.FormClick(Sender: TObject);
begin
  ShowMessage('Click!');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnIdle:= Idle;
  //since we are talking an application, here... (or edit inside "object inspector" window)
  //Form1.Width:= 640;
  //Form1.Height:= 480;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FContext);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if not Assigned(FContext) then exit;
  glResizeWnd(ClientWidth, ClientHeight);
end;

procedure TForm1.FormShow(Sender: TObject);
var
  pf: TglcContextPixelFormatSettings;

begin
  //instantiate "ourself"
  FContext:= TGLContext.GetPlatformClass.Create(Self);
  //setup the "PixelFormat"
  pf:= TGLContext.MakePF(true,false,1,32,24,0,0,0,0);

  { Working defaults:
   DoubleBuffered: boolean = true;
   Stereo: boolean=false; -gl can do stereoscopic/VR
   MultiSampling: TMultiSample=1;
   ColorBits: Integer=32;
   DepthBits: Integer=16/24;
   StencilBits: Integer=0;
   AccumBits: Integer=0;
   AuxBuffers: Integer=0;
   Layer: Integer=0 --use textures for 1+

   kronos forums:
   "glXChooseVisual() doesn’t allow you to filter directly on the number of bits per pixel.

   so we cant change "color depth" here
  }

  //Not what you think- PixelFormat (above) determines how this is used.
  pf.MultiSampling:= 16;

  //build the GL context
  FContext.BuildContext(pf);

  //which calls in turn- GTK (or win32) and dgl to "fire up" the GL core

  // (internal) FContext := glXCreateContext(FDisplay, vi, nil, true);

  // FContext is the "magic" pointer (vFB area)

  //this process *CAN* fail if proper settings are not provided.

  if Fcontext=Nil then begin
    ShowMessage('Couldnt create context as requested. ' );
    halt;
  end;
  //32 bit RGBA color context(as per window) but watch this:




  runtime:= 0; //our rotation axis -demo
end;
//you are supposed to create a texture and know what to put there- not always the case
//we may not have the data when we make one

procedure CreateRGBTexture(Width,Height:Word);
Begin
  glGenTextures(1, Texture);
  glBindTexture(GL_TEXTURE_2D, Texture^);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  LastBoundTexID:=Texture^;
end;

//add data to texture
procedure RenderTexture(Width,Height:Word; Texture:cardinal; pdata:pointer);
begin
  if LastBoundTexID <> TExture then
     glBindTexture(GL_TEXTURE_2D, Texture);

if pdata <> Nil then
   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, pdata)
else
    ShowMessage('Cant push a Nil texture to the GL context.');
//Dispose(pdata);

end;

procedure TForm1.Idle(Sender: TObject; var Done: boolean);
begin
  Done:= false;
  runtime:= runtime + 1;
  if not Assigned(FContext) then exit; //close if Context destroyed
  Render;
end;

procedure TForm1.Render;
begin
  //reset the view every frame?
  glMatrixMode(GL_PROJECTION);
  glViewport(0, 0, ClientWidth, ClientHeight);
  glLoadIdentity();

  gluPerspective(FOV, ClientWidth / ClientHeight, CLIP_NEAR, CLIP_FAR);

  glMatrixMode(GL_MODELVIEW);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glLoadIdentity();

  glEnable(GL_DEPTH_TEST); //3D ops coming
  //end reset view

  glClear(GL_COLOR_BUFFER_BIT); //do this or get garbage

  glTranslatef(0,0,-5);       //push "back" on the Z
  glRotatef(runtime*0.50,0,1,0);  //spin

  glBegin(GL_TRIANGLES);
  //gradient-filled between these colors w 3vertex points
    glColor3f(1, 0, 0); glVertex3f(-1,-1, 0);
    glColor3f(0, 0, 1); glVertex3f( 1,-1, 0);
    glColor3f(0, 1, 0); glVertex3f( 0, 1, 0);
  glEnd;

  FContext.SwapBuffers; //update screen (SDL: pageFlip/RenderPresent)
end;

end.

