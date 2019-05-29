program testLazGraph;


{$mode objfpc}
uses
	GL,GLU,GLext,GLUT,freeGLUT,lazgfx,sysutils,strings; 

var
    IsConsoleInvoked:boolean; export;

procedure Draw; cdecl;

begin

    glClearColor( 0.0, 1.0, 0.0, 1.0 );
    glClear(GL_COLOR_BUFFER_BIT);

    glColor3f(0.0,0.0,1.0);
    putPixel(7,7);
    glColor3f(0.0,1.0,0.0);
    putPixel(20,20); //from 7x7 to 20x20
    glutSwapBuffers;

end;


begin
    Render3d:=false;
    IsConsoleInvoked:=false;
    UseGrey:=false;


	glutInitPascal;

    glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB);	
    glutInitWindowSize(640, 480 );
    glutCreateWindow('Laugh!');

    //640x480x256(windowed)
    initgraph(VGA,VGAHix32k,'',false);

    glutDisplayFunc(@Draw);
    glutMainloop;


end.
