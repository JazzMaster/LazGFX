//I dont take credit for this one- frepascal meets SDL.net author, however, does.
//this is here because LAZARUS seems to have an OpenGL issue- we need to know if OGL linkage is working.

PROGRAM pyrOGLDEMO;

//you dont need CRT- use SDL event queue for this(keypressed check).
//this guy is lazy. and this code is old as heck.
//sdl v1.2
USES CRT, SDL, GL, GLU;
 
VAR
userkey:CHAR;
screen:pSDL_SURFACE;
h,hh,th,thh:REAL;
 
BEGIN
//some calculations needed for a regular tetrahedron with side length of 1
h:=SQRT(0.75); //height of equilateral triangle
hh:=h/2;       //half height of equilateral triangle
th:=0.75;      //height of tetrahedron
thh:=th/2;     //half height of tetrahedron
 
SDL_INIT(SDL_INIT_VIDEO);
 
SDL_GL_SETATTRIBUTE(SDL_GL_RED_SIZE, 5);
SDL_GL_SETATTRIBUTE(SDL_GL_GREEN_SIZE, 5);
SDL_GL_SETATTRIBUTE(SDL_GL_BLUE_SIZE, 5);
SDL_GL_SETATTRIBUTE(SDL_GL_DEPTH_SIZE, 16);
SDL_GL_SETATTRIBUTE(SDL_GL_DOUBLEBUFFER, 1);
 
screen:=SDL_SETVIDEOMODE(640, 480, 0, SDL_OPENGL);
IF screen=NIL THEN HALT;
 
glCLEARCOLOR(0.0, 0.0, 1.0, 0.0);
glVIEWPORT(0,0,640,480);
glMATRIXMODE(GL_PROJECTION);
glLOADIDENTITY;
gluPERSPECTIVE(45.0, 640.0/480.0, 1.0, 3.0);
glMATRIXMODE(GL_MODELVIEW);
glLOADIDENTITY;
glCLEAR(GL_COLOR_BUFFER_BIT);
glENABLE(GL_CULL_FACE);
glTRANSLATEf(0.0, 0.0, -2.0);
 
REPEAT
SDL_DELAY(50);
 
glROTATEf(5, 0.0, 1.0, 0.0);
glCLEAR(GL_COLOR_BUFFER_BIT );
 
glBEGIN(GL_TRIANGLES);
    glCOLOR3f(1.0, 1.0, 0.0);
    glVERTEX3f(thh, 0.0, 0.0);
    glVERTEX3f(-thh, hh, 0.0);
    glVERTEX3f(-thh, -hh, 0.5);
 
    glCOLOR3f(0.0, 1.0, 1.0);
    glVERTEX3f(thh, 0.0, 0.0);
    glVERTEX3f(-thh, -hh, -0.5);
    glVERTEX3f(-thh, hh, 0.0);
 
    glCOLOR3f(1.0, 0.0, 1.0);
    glVERTEX3f(thh, 0.0, 0.0);
    glVERTEX3f(-thh, -hh, 0.5);
    glVERTEX3f(-thh, -hh, -0.5);
 
    glCOLOR3f(1.0, 1.0, 1.0);
    glVERTEX3f(-thh, -hh, 0.5);
    glVERTEX3f(-thh, hh, 0.0);
    glVERTEX3f(-thh, -hh, -0.5);
glEND;
 
SDL_GL_SWAPBUFFERS;
UNTIL keypressed;
 
SDL_QUIT;
END.
