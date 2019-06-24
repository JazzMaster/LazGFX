program glutOPDemo;

uses
	OPGlut;

procedure run(argc:integer; argv:PPChar);

var
	window:Pwindow;
	GLcontext:PContextInfo;
	FrameBuffer:PFrameBuffer;

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
      flags :=flags or GLUT_RGBA or GLUT_ALPHA or GLUT_DEPTH; //32bit 3D renering

      Framebuffer:=frameBufferInfo(true, true, true, true);
      Init_GLUT.init(window, context, frameBufferInfo);
      Init_GLUT.run;
end;



begin 
	run;
end.
