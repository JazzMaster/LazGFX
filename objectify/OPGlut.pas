Unit OPGlut;
{$mode objfpc}

//This is GLUt- not Lazarus GL method(differs)
//"class instantiated" OBJECT PASCAL(for LAZARUS/DELPHI)

// -J

interface
uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,strings, GL, GLext, GLU,OpenGLContext;

 
PFrameBuffer=^FrameBufferInfo;
FramebufferInfo=record
 
    flags:longword;
    msaa:boolean;//to enable or disable it when wee need it
 
end;

//Init_GLEW.h

Init_GLEW=class
   public:
        procedure Init;
end;

//ContextInfo.h
PContextInfo:^ContextInfo;
ContextInfo=record;
    major_version, minor_version:integer;
    core:boolean; //coreGL or compat profile?
end;
 
//windowInfo.h
PWindow:^WindowInfo; 
WindowInfo=record
    name:string;
    width, height:integer;
    position_x, position_y:integer;
    isReshapable:boolean;
end; 

Init=class 
 
      public             
		 procedure Init.Init_GLEW;
         procedure InitGLUT (window:PWindow; context:^ContextInfo; framebuffer:PFramebuffer);
	     procedure run;
	     procedure close;
		 procedure enterFullscreen;
         procedure exitFullscreen;
 
         //used to print info about GL
         procedure printOpenGLInfo(window:PWindow; GLcontext:PContextInfo);

      private
         procedure idleCallback;
         procedure displayCallback;
         procedure reshapeCallback(width, height:Integer);
         procedure closeCallback;
end;


implementation

 
var
  TextureId: GLuint;
  TextureData: Pointer; 
  OpenGLControl1: TOpenGLControl;
  Render3d:boolean; 

procedure InitGL;
begin
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glOrtho(0, OpenGLControl1.Width, OpenGLControl1.Height, 0, 0, 1);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  if not Render3d then begin
      glDisable(GL_DEPTH_TEST);
      glViewport(0, 0, OpenGLControl1.Width, OpenGLControl1.Height);
      glGenTextures(1, @TextureId);
      glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE); 
  end;
end;
 

procedure Init.Init_GLEW;
var
   glewExperimental :boolean;

begin
 
   glewExperimental := true;
  if (glewInit = GLEW_OK) then 
    LogLN('GLEW: Initialize');
 
  if (glewIsSupported('GL_VERSION_4_5')) then 
    LogLN('GL VERSION is 4.5');
  else begin
  if (glewIsSupported('GL_VERSION_4_0')) = false then
    LogLN('GL VERSION is 4.0');
    if (glewIsSupported('GL_VERSION_3_3')) = false then

//no vendor support below here- using linux default open src libs
    LogLN('GL VERSION is 3.3-MESA');

      if (glewIsSupported('GL_VERSION_3_2')) = false then
    LogLN('GL VERSION is 3.2');
        if (glewIsSupported('GL_VERSION_3_0'))= false then
    LogLN('GL VERSION is 3.0');
           if (glewIsSupported('GL_VERSION_2_1'))= false then
                begin
                    writeln(' ERROR: OpenGL 2.1 or higher needed. ');
                      HALT(-1);
                end;
  end;
end;

procedure glutInitPascal(ParseCmdLine: Boolean); 
var
  Cmd: array of string;
  CmdCount, I: Integer;
begin
  if ParseCmdLine then
    CmdCount := ParamCount + 1
  else
    CmdCount := 1;
  SetLength(Cmd, CmdCount);
  for I := 0 to CmdCount - 1 do
    Cmd[I] := ParamStr(I);
  glutInit(@CmdCount, @Cmd);
end;

procedure Init.Init_GLUT(window:^WindowInfo; context:^ContextInfo; framebuffer:^FramebufferInfo);

begin

 glutInitPascal;
 
  if assigned (contextInfo^.core) then begin
        glutInitContextVersion(contextInfo^.major_version, contextInfo^.minor_version);
        glutInitContextProfile(GLUT_CORE_PROFILE);
  end
  else begin
       //version doesn't matter in Compatibility mode
       glutInitContextProfile(GLUT_COMPATIBILITY_PROFILE);
  end;
 
  glutInitDisplayMode(framebuffer^.flags);

  glutInitWindowPosition(window^.position_x, window^.position_y);
  glutInitWindowSize(window^.width, window^.height);
 
  glutCreateWindow(window^.name^.c_str);
  LogLN('GLUT:initialized');


  glutIdleFunc(@idleCallback);
  glutCloseFunc(@closeCallback);
  glutDisplayFunc(@displayCallback);
  glutReshapeFunc(@reshapeCallback);
 
  Init_GLEW.Init();

  //cleanup
  glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_GLUTMAINLOOP_RETURNS);
 
  //our method to display some info. Needs contextInfo and windowinfo
  printOpenGLInfo(windowInfo, contextInfo);
 
end;

 
//starts the rendering Loop
procedure Init_GLUT.run;
begin
   LogLn('GLUT: MainLoop Running ');
   glutMainLoop();
end;


procedure Init_GLUT.close;
begin
   LogLn('GLUT: MainLoop Done. ');
   glutLeaveMainLoop();
end;
 
procedure Init_GLUT.idleCallback;
begin
   //do nothing, just update the screen
   sleep(2);
end;
 
procedure Init_GLUT.displayCallback;
begin
//   glutSwapBuffers();

   //do nothing, just update the screen
   glutPostRedisplay();

end;
 
//same as other fpc routine
procedure Init_GLUT.reshapeCallback(width, height:integer);
begin
//if this isnt here- it doesnt work
	glViewport(0, 0, width, height);
end; 

procedure Init_GLUT.closeCallback;
begin
  Init_GLUT.close;
end;
 
//theres waaay more to this...
procedure Init_GLUT.enterFullscreen;
begin
  glutFullScreen;
end;
 
procedure Init_GLUT.exitFullscreen;
begin
  glutLeaveFullScreen;
end;


procedure Init_GLUT.printOpenGLInfo(WindowInfo:PWindow; contextInfo:PContextInfo);

var
 
 renderer,vendor,version:PChar;                               
                                
begin
 renderer := glGetString(GL_RENDERER);
 vendor := glGetString(GL_VENDOR);
 version := glGetString(GL_VERSION);
  LogLN('**********************************');

  LogLN('GLUT: Initialise');
  LogLN('GLUT: Vendor :',vendor);
  LogLN('GLUT: Renderer :',renderer);
  LogLN('GLUT: Version :',version);

end;


end.
