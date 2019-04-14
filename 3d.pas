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
//pushed back- this takes up most of the screen real estate

begin

// Render a cube
glBegin( GL_QUADS );
    // Top face
    glColor3f(   0.0f, 1.0f,  0.0f );  // Green
    glVertex3f(  1.0f, 1.0f, -1.0f );  // Top-right of top face
    glVertex3f( -1.0f, 1.0f, -1.0f );  // Top-left of top face
    glVertex3f( -1.0f, 1.0f,  1.0f );  // Bottom-left of top face
    glVertex3f(  1.0f, 1.0f,  1.0f );  // Bottom-right of top face
 
    // Bottom face
    glColor3f(   1.0f,  0.5f,  0.0f ); // Orange
    glVertex3f(  1.0f, -1.0f, -1.0f ); // Top-right of bottom face
    glVertex3f( -1.0f, -1.0f, -1.0f ); // Top-left of bottom face
    glVertex3f( -1.0f, -1.0f,  1.0f ); // Bottom-left of bottom face
    glVertex3f(  1.0f, -1.0f,  1.0f ); // Bottom-right of bottom face
 
    // Front face
    glColor3f(   1.0f,  0.0f, 0.0f );  // Red
    glVertex3f(  1.0f,  1.0f, 1.0f );  // Top-Right of front face
    glVertex3f( -1.0f,  1.0f, 1.0f );  // Top-left of front face
    glVertex3f( -1.0f, -1.0f, 1.0f );  // Bottom-left of front face
    glVertex3f(  1.0f, -1.0f, 1.0f );  // Bottom-right of front face
 
    // Back face
    glColor3f(   1.0f,  1.0f,  0.0f ); // Yellow
    glVertex3f(  1.0f, -1.0f, -1.0f ); // Bottom-Left of back face
    glVertex3f( -1.0f, -1.0f, -1.0f ); // Bottom-Right of back face
    glVertex3f( -1.0f,  1.0f, -1.0f ); // Top-Right of back face
    glVertex3f(  1.0f,  1.0f, -1.0f ); // Top-Left of back face
 
    // Left face
    glColor3f(   0.0f,  0.0f,  1.0f);  // Blue
    glVertex3f( -1.0f,  1.0f,  1.0f);  // Top-Right of left face
    glVertex3f( -1.0f,  1.0f, -1.0f);  // Top-Left of left face
    glVertex3f( -1.0f, -1.0f, -1.0f);  // Bottom-Left of left face
    glVertex3f( -1.0f, -1.0f,  1.0f);  // Bottom-Right of left face
 
    // Right face
    glColor3f(   1.0f,  0.0f,  1.0f);  // Violet
    glVertex3f(  1.0f,  1.0f,  1.0f);  // Top-Right of left face
    glVertex3f(  1.0f,  1.0f, -1.0f);  // Top-Left of left face
    glVertex3f(  1.0f, -1.0f, -1.0f);  // Bottom-Left of left face
    glVertex3f(  1.0f, -1.0f,  1.0f);  // Bottom-Right of left face
glEnd();

end;

begin
end.
