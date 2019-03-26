program glutOPDemo;

uses
	OPGlut;

procedure (argc:integer; argv:PPChar);

var
	window
	GLcontext
	FrameBuffer

begin
  Window:=window('in2gpu OpenGL Beginner Tutorial',
                         400, 200,//position
                         800, 600, //size
                         true);//reshape
 
  GLContext:=context(4, 5, true);
  Framebuffer:=frameBufferInfo(true, true, true, true);
  Init_GLUT.init(window, context, frameBufferInfo);
  Init_GLUT.run;
end;



begin 
	run;
end.
