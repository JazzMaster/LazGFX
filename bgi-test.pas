program testLazGraph;
{$mode objfpc}
uses
	GL,GLU,GLext,GLUT,freeGLUT,lazgfx,sysutils,strings; 

var
    IsConsoleInvoked:boolean; export;

{
//isnt this easy?
procedure GLKeyboard(Key: Byte; X, Y: Longint); cdecl;
begin
  if Key = 27 then begin//ESC
//    LIBGRAPHICS_ACTIVE:=false; //refuse to do anything further(rendering wise)
    GlutLeaveMainloop; //manually kill the mainloop - and exit.
  end;
end;

procedure Rendersomething; cdecl;
begin
	glClearColor( 0.0, 0.0, 0.0, 1.0 );
    glClear(GL_COLOR_BUFFER_BIT);
 //   glutMainloop;

//		    PlotPixelWithNeighbors(5,5); //(with neighbors is easier seen) 5x5
            glColor3f(0.0,0.0,1.0);
            putPixel(7,7);
            glColor3f(0.0,1.0,0.0);
            putPixel(20,20); //from 7x7 to 20x20

//  OutTextXY(15,15,'Press ESC to end. ');

  glutSwapBuffers;
end;

procedure ReSize(Width, Height: Integer); cdecl;
var
    ar:single;

begin
  if Height = 0 then
    Height := 1;

  glViewport(0, 0, MaxX, MaxY);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  ar:= (width / height);
  glFrustum(-ar, ar, -1.0, 1.0, 2.0, 100.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

end;

procedure glutInitPascal;
var
  Cmd: array of PChar;
  CmdCount, I: Integer;

begin
    CmdCount := 1;
    SetLength(Cmd, CmdCount);
    Cmd[0] := PChar(ParamStr(0));
    glutInit(@CmdCount, @Cmd);
end;
}

begin
    Render3d:=false;
    IsConsoleInvoked:=false;
    UseGrey:=false;

//640x480x256(windowed)
   initgraph(VGA,VGAHix32k,'',false);

{
    glutInitPascal;
    glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB);	
    glutCreateWindow('Lazarus Graphics Application');
	glutKeyboardFunc(@GLKeyboard);
	glutDisplayFunc(@RenderSomething);
	glutReshapeFunc(@ReSize);

    gldisable(GL_DEPTH_TEST);

    glutMainloop;
}

end.
