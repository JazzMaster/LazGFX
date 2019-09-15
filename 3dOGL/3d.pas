unit 3d;

{

Not Done:
	Line ->pipe (or wire) [GL extrusion lib]
	
Done:
	Pixel ->ball (a tiny sphere)
	Tri(angle) ->Pyramid (see demo)
	Cube
	Doughnut

3d objects from the GFX unit will be moved here

Rotating views is a core SDL/OpenGL function (camera angle) at this point that may require 3d (x,y,z) rotation parameters.


3d objects:
	"skins" are either compressed texture DDS files, or BMP files
	
	compressed textures(video cards dont understand JPEG natively for "skins"):
	
	Theres a special tool found here:
		https://github.com/GPUOpen-Tools/Compressonator
		
	That uses "texture compression" skins available (in hardware) and imports DDS(DirectDraw surfaces)
		from disk into the GPU natively.
	This code is forth coming.(I knew Dx had SDL similarities!)
	DXTc is ONE method- ensure you OS has the libs installed for decoding.

This is where code gets FUN!	 

No- Im not letting you leave without the Bagel/Donut- but Im stopping short of Scene rendering.
The reason is complexity.

TnL takes massive input and detail. Im not making your game- you are!

}

interface

uses

    GL,GLU,GLUT; 
  
procedure Render_Sphere;
procedure Render_Cube;


implementation
//for each 3D object You have to manually adjust the camera angle - or loop the draw command in 
//a Rotate3f loop(to spin it).

//Im not going to tell you what to do- the demos speak for themselves.

//size??
procedure Render_Sphere;

var
	pSphereQuadric:PGLUquadric;

begin
	g_SphereDisplayList := glGenLists(1);
	pSphereQuadric := gluNewQuadric;

	gluQuadricDrawStyle( pSphereQuadric, GLU_FILL );
	gluQuadricOrientation( pSphereQuadric, GLU_OUTSIDE );
	gluQuadricTexture( pSphereQuadric, GL_TRUE );
	gluQuadricNormals( pSphereQuadric, GLU_SMOOTH );

	glNewList( g_SphereDisplayList, GL_COMPILE );
		gluSphere( pSphereQuadric, 1.0, 360, 180 );
	glEndList;
	gluDeleteQuadric( pSphereQuadric );
end;

procedure Render_Cube;

//Takes 6 color inputs- you wouldnt want ME deciding what color your cube is....
//(you can also add "skins" or shaders to this)
begin

// Render a cube


procedure Cylinder;
var
  around: integer;
begin
  glBegin(GL_TRIANGLE_STRIP);
    for around := 0 to 35 do
    begin
      glVertex3f(circleX[around],circleY[around],-0.4);
      glVertex3f(circleX[around],circleY[around],+0.4);
    end; {for}
    glVertex3f(circleX[0],circleY[0],-0.4);
    glVertex3f(circleX[0],circleY[0],+0.4);
  glEnd;
end;

procedure Cone;
var
  around: integer;
begin
  glBegin(GL_TRIANGLE_FAN);
    glVertex3f(0.0,0.0,0.4);
    for around := 35 downto 0 do
      glVertex3f(circleX[around],circleY[around],0.0);
    glVertex3f(circleX[35],circleY[35],0.0);
  glEnd;
end;

procedure Dome;
var
  olddiam,
  oldlayer,
  diam,
  layer: double;
  place,
  around: integer;
begin
  for place := 1 to 9 do
  begin
    layer := circleY[place];
    diam := circleX[place]*2.5;
    if place=1 then
    begin
      glFrontFace(GL_CCW);
      glBegin(GL_TRIANGLE_FAN);
        glVertex3f(0.0,0.0,0.4);
        for around := 35 downto 0 do
          glVertex3f(circleX[around]*diam,circleY[around]*diam,layer);
        glVertex3f(circleX[35]*diam,circleY[35]*diam,layer);
    end else begin
      glFrontFace(GL_CW);
      glBegin(GL_TRIANGLE_STRIP);
        for around := 0 to 35 do
        begin
          glVertex3f(circleX[around]*olddiam,circleY[around]*olddiam,oldlayer);
          glVertex3f(circleX[around]*diam,circleY[around]*diam,layer);
        end; {for}
        glVertex3f(circleX[0]*olddiam,circleY[0]*olddiam,oldlayer);
        glVertex3f(circleX[0]*diam,circleY[0]*diam,layer);
    end;
    glEnd;
    olddiam := diam;
    oldlayer := layer;
  end; {for}
end;


procedure Pyramid;
begin
 glBegin(GL_TRIANGLES);
//yellow
    glCOLOR3f(1.0, 1.0, 0.0);
    glVERTEX3f(thh, 0.0, 0.0);
    glVERTEX3f(-thh, hh, 0.0);
    glVERTEX3f(-thh, -hh, 0.5);

//cyan 
    glCOLOR3f(0.0, 1.0, 1.0);
    glVERTEX3f(thh, 0.0, 0.0);
    glVERTEX3f(-thh, -hh, -0.5);
    glVERTEX3f(-thh, hh, 0.0);

//magenta 
    glCOLOR3f(1.0, 0.0, 1.0);
    glVERTEX3f(thh, 0.0, 0.0);
    glVERTEX3f(-thh, -hh, 0.5);
    glVERTEX3f(-thh, -hh, -0.5);

//white 
    glCOLOR3f(1.0, 1.0, 1.0);
    glVERTEX3f(-thh, -hh, 0.5);
    glVERTEX3f(-thh, hh, 0.0);
    glVERTEX3f(-thh, -hh, -0.5);
  glEnd;
end;


{
procedure Pyramid;
begin

  glBegin(GL_TRIANGLE_FAN);
    glVertex3f(+0.0,+0.0,+0.0);
    glVertex3f(-0.3,+0.3,-0.4);
    glVertex3f(+0.3,+0.3,-0.4);
    glVertex3f(+0.0,-0.3,-0.4);
    glVertex3f(-0.3,+0.3,-0.4);
  glEnd;
end;

procedure Cube;
//cubes have 6 sides...hmmmmm
begin
  glBegin(GL_TRIANGLE_STRIP);
    glVertex3f(-0.4,+0.4,+0.4);
    glVertex3f(-0.4,-0.4,+0.4);

    glVertex3f(+0.4,+0.4,+0.4);
    glVertex3f(+0.4,-0.4,+0.4);

    glVertex3f(+0.4,+0.4,-0.4);
    glVertex3f(+0.4,-0.4,-0.4);

    glVertex3f(-0.4,+0.4,-0.4);
    glVertex3f(-0.4,-0.4,-0.4);

    glVertex3f(-0.4,+0.4,+0.4);
    glVertex3f(-0.4,-0.4,+0.4);  
  glEnd;
end;
}

begin
end.
