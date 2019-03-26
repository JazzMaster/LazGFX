Unit OPGlut;

// This is Object Pascal - derived from OBJ C- implementation of: freeGLUT core routines

//this is so you Laz folks can import/help rewrite the rest of the new  routines.


//not compile tested- logic tested only
//"class instantiated" OBJECT PASCAL(for LAZARUS/DELPHI)

//TODO: add the logger code in here


// -J

interface
 
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
 
ContextInfo=record;
  
    major_version, minor_version:integer;
    core:boolean;
end;
 
//windowInfo.h
uses
	strings;
 
WindowInfo=record
    name:string;
    width, height:integer;
    position_x, position_y:integer;
    isReshapable:boolean;
end; 

Init=class 
 
      public             
		 procedure Init.Init_GLEW;
         procedure InitGLUT (window:^WindowInfo; context:^ContextInfo; framebuffer:^FramebufferInfo);
	     procedure run;
	     procedure close;
		 procedure enterFullscreen;
         procedure exitFullscreen;
 
         //used to print info about GL
         procedure printOpenGLInfo(window:^WindowInfo; GLcontext:^ContextInfo);

      private
         procedure idleCallback;
         procedure displayCallback;
         procedure reshapeCallback(width, height:Integer);
         procedure closeCallback;
end;


implementation


procedure Init.Init_GLEW;
var
   glewExperimental :boolean;

begin
 
   glewExperimental := true;
  if (glewInit = GLEW_OK) then 
    LogLN('GLEW: Initialize');
 
  if (glewIsSupported('GL_VERSION_4_5')) then 
    LogLN('GLEW GL_VERSION is 4.5');
  
  else
    LogLN('GLEW GL_VERSION 4.5 not supported');
end;

//same as the faked FPC one - so Im not going to rewrite this rouinte- Im going to replace it.

procedure Init.Init_GLUT(window:^WindowInfo; context:^ContextInfo; framebuffer:^FramebufferInfo);

begin

  //we need to create these fake arguments
  int fakeargc = 1;
  char *fakeargv[] = { "fake", NULL };
  glutInit(&fakeargc, fakeargv);
 
//end rewrite

  if assigned (contextInfo.core) then begin
  
        glutInitContextVersion(contextInfo.major_version, contextInfo.minor_version);
        glutInitContextProfile(GLUT_CORE_PROFILE);
  end
  else begin
  
       //version doesn't matter in Compatibility mode
       glutInitContextProfile(GLUT_COMPATIBILITY_PROFILE);
  end;
 
  glutInitDisplayMode(framebuffer.flags);

  glutInitWindowPosition(window.position_x, window.position_y);
  glutInitWindowSize(window.width, window.height);
 
  glutCreateWindow(window.name.c_str);
  LogLN('GLUT:initialized');

//user level
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
   glutPostRedisplay();
end;
 
procedure Init_GLUT.displayCallback;
begin
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   glClearColor(0.0, 0.0, 0.0, 1);
   glutSwapBuffers();
end;
 
//same as other fpc routine
procedure Init_GLUT.reshapeCallback(width, height:integer);
begin
//if this isnt here- it doesnt work
	glViewport(0, 0, width, height);
end; 

procedure Init_GLUT.closeCallback;
begin
  close;
end;
 
procedure Init_GLUT.enterFullscreen;
begin
  glutFullScreen;
end;
 
procedure Init_GLUT.exitFullscreen;
begin
  glutLeaveFullScreen;
end;


procedure Init_GLUT.printOpenGLInfo(WindowInfo:^window; contextInfo:^GLContext);

var
 
 renderer,vendro,version:PChar;                               
                                
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

{
//this should be defined in the running application- not here
//The C is a bit dodgy in class and record cloning and defines.

begin

      WindowInfo^.name := 'OpenGL tutorial';
      WindowInfo^.width := 800; 
      WindowInfo^.height := 600;
      WindowInfo^.position_x := 300;
      WindowInfo^.position_y := 300;
      WindowInfo^.isReshapable := true;

      ContextInfo^.major_version := 3;
      ContextInfo^.minor_version := 3;
      ContextInfo^.core := true;

      FramebufferInfo^.flags := GLUT_DOUBLE; //this is a must
      if (color) then
        flags :=flags or GLUT_RGBA or GLUT_ALPHA;
     if (depth) then
        flags := flags or GLUT_DEPTH;
     if (stencil) then
        flags :=flags or GLUT_STENCIL;
     if (msaa) then
        flags :=flags or GLUT_MULTISAMPLE;
}
end.
