unit 3d;

{

Not Done:
	Line ->pipe (or wire)
	circle or ellipse ->sphere or donut
	Box ->cube 


Done:
	Pixel ->ball (a tiny sphere)
	Tri(angle) ->Pyramid (see demo)


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

}

interface

uses

    GL,GLU,GLUT; //macDraw,DirectDraw 1-3(software)
  

implementation

//PGL= Pascal GL
procedure PGL_Sphere
//Lets make a sphere!

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



begin
end.
