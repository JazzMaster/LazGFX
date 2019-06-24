program testLazGraph;

{
so far this is testing (free)GLUT (inadvertently) while testing "core GL routines".

The main issue is not OpenGL- its either the translation matrix/view being "off"
-or-

calling conventions creating headache between (free)GLUT - the main unit, and this routine.
IT APPEARS AS IF GLUT prevents the main unit from passing around GLUT routines(which is what we need).

GLUT- by itself is mostly used for windoing events, etc.
Lazarus has a working (OBJECTIVE PASCAL) routine for those--

so Im not sweating THAT-- 

immeadate rendering seems to be limited to QUADS?

The entire reason for writing the Quasi-BGI was to make things easier- not to "create issues".

}

{$mode objfpc}
uses
	crt,GL,GLU,GLext,GLUT,freeGLUT,sysutils,strings; 
//glm -GL Math

//lets make things easier...
type
//not SDL per-se..but 24bit RGB color container, for sure.
    PSDL_Color=^TSDL_Color;
    TSDL_Color=record
        r:byte;
        g:byte;
        b:byte;
        a:byte;
    end;
    Tpixeldata=array of TSDL_Color;   
    PPixels=^TPixeldata;

var
    Tex: GLuint;
    Pixels:PPixels;
    x:longint;

procedure reshape (w,h:integer); cdecl; 

begin
    glViewport (0, 0, w, h);
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity;
    gluPerspective (45, w div h, 1, 3);
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity;
end;

//isnt this easy?
procedure GLKeyboard(Key: Byte; X, Y: Longint); cdecl;
begin
  
end;

//idle callback
procedure idle; cdecl;
begin
    //sleep- or we chew up cpu cycles
end;

procedure DrawPixels(somedata:PPixels);

begin
    glGenTextures(1, @tex);
    glBindTexture(GL_TEXTURE_2D, tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 640, 480, 0, GL_RGB, GL_FLOAT, somedata);
    glBindTexture(GL_TEXTURE_2D, 0);
end;

procedure Draw; cdecl;
begin
  glutpostredisplay;
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
//    glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE,GLUT_ACTION_CONTINUE_EXECUTION);
end;


begin

	glutInitPascal;

    glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB or GLUT_DEPTH);	
    glutInitDisplayString('rgb double');
    glutInitWindowSize(640, 480 );
    glutCreateWindow('Laz GL Demos!');

    glEnable(GL_DEPTH_TEST);
    // Accept fragment if it closer to the camera than the former one
    glDepthFunc(GL_GEQUAL);    // Set the type of depth-test
  
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity;

    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity;

    //clears background
    glClearColor( 0.0, 0.0, 0.0, 0.5 );
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
    glutswapbuffers;

    while true do begin
    //do this- or get crap
    glClear(GL_COLOR_BUFFER_BIT);
  
    glROTATEf(1.5, 0.5, 0.5, 0.0); 

 // make smaller:  glScalef(0.7, 0.7, 0.7);
   
//This seems to be either a GL or a vertex issue...I am debugging(HOW?)    
glBegin( GL_quadS );


    glColor3f(   1.0,  0.0, 0.0 );  // Red

    glVertex3f( -0.5,  -0.5, -0.5 );  // Top-left of front face
    glVertex3f( 0.5, -0.5, 0.5 );  // Bottom-left of front face
    glVertex3f(  0.5,  0.5, 0.5 );  // Top-Right of front face
    glVertex3f(  -0.5, 0.5, 0.5 );  // Bottom-right of front face
 

    glColor3f(   1.0,  1.0,  0.0 ); // Yellow

    glVertex3f(  -0.5, 0.5, 0.5 ); // Bottom-Left of back face
    glVertex3f( 0.5, 0.5, 0.5 ); // Bottom-Right of back face
    glVertex3f( 0.5,  0.5, -0.5 ); // Top-Right of back face
    glVertex3f(  -0.5,  0.5, -0.5 ); // Top-Left of back face


    glColor3f(   0.0, -1.0,  -0.0 );  // Green

    glVertex3f(  0.5, -0.5, -0.5 );  // Top-right of top face
    glVertex3f( -0.5, -0.5, -0.5 );  // Top-left of top face
    glVertex3f( -0.5, 0.5,  -0.5 );  // Bottom-left of top face
    glVertex3f(  0.5, 0.5,  -0.5 );  // Bottom-right of top face
 
    // Bottom face
    glColor3f(   1.0,  0.5,  0.0 ); // Orange

    glVertex3f(  -0.5, -0.5, -0.5 ); // Top-right of bottom face
    glVertex3f( 0.5, -0.5, -0.5 ); // Top-left of bottom face
    glVertex3f( 0.5, -0.5,  0.5 ); // Bottom-left of bottom face
    glVertex3f(  -0.5, -0.5,  0.5 ); // Bottom-right of bottom face
 
    // Left face
    glColor3f(   0.0,  0.0,  1.0);  // Blue
    glVertex3f( -0.5,  -0.5,  -0.5);  // Top-Right of left face
    glVertex3f( -0.5,  -0.5, 0.5);  // Top-Left of left face
    glVertex3f( -0.5, 0.5, 0.5);  // Bottom-Left of left face
    glVertex3f( -0.5, 0.5,  -0.5);  // Bottom-Right of left face
 
    // Right face
    glColor3f(   1.0,  0.0,  1.0);  // Violet
    glVertex3f(  0.5,  -0.5,  0.5);  // Top-Right of left face
    glVertex3f(  0.5,  -0.5, -0.5);  // Top-Left of left face
    glVertex3f(  0.5, 0.5, -0.5);  // Bottom-Left of left face
    glVertex3f(  0.5, 0.5,  0.5);  // Bottom-Right of left face
glEnd();


 
{
    
//2D
   glBegin(GL_POINTS);
//yellow
    glCOLOR3f(0.5, 0.5, 0.0);
    glVERTEX3i(15, 17, 0);
   
//white 
    glCOLOR3f(0.5, 0.5, 0.5);
    glVERTEX3i(7, 7, 0);

//green
    glCOLOR3f(0.0, 0.5, 0.0);
    glVERTEX3i(33, 33, 0);
    glVERTEX3i(33, 34, 0);
    glVERTEX3i(34, 33, 0);
    glVERTEX3i(34, 34, 0);

//red
    glCOLOR3f(0.5, 0.0, 0.0);

    glVERTEX3i(50, 13, 0);
    glVERTEX3i(50, 14, 0);
    glVERTEX3i(51, 13, 0);
    glVERTEX3i(51, 14, 0);

    glVERTEX3i(49, 12, 0);
    glVERTEX3i(49, 15, 0);
    glVERTEX3i(52, 12, 0);
    glVERTEX3i(52, 15, 0);
    
//blue
    glCOLOR3f(0.0, 0.0, 0.5);
    glVERTEX3i(27, 27, 0);

  glEnd;
}

     
   

  x:=0;
  repeat
      if ((x mod 10)=1) then begin
        x:=0;
         
        break;
      end;
     inc(x);
  until ((x mod 10)=1);
  glutswapbuffers;
{
  hackish but may work
  if keypressed then begin
    key:=readkey;
  if Ord(Key) = 27 then  //ESC
    halt(0); 
  end;  }
   end;

	glutKeyboardFunc(@GLKeyboard);
	glutIdleFunc(@Idle);
    glutReshapeFunc(@reshape);
    glutDisplayFunc(@Draw);

//    glutMainloop;

end.
