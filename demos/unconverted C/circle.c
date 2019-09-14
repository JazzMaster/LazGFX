//this motherFN code- can port!

#include <GL/gl.h>
#include <GL/glut.h>
#include <math.h>

#include <stdlib.h> /* exit() */
#include <FTGL/ftgl.h>

//cx – the translation on the x axis
//cy – the translation on the y axis
//r – the radius of the circle
//num_segments - how smooth a circle?

// Function that handles the drawing of a circle using the triangle fan
//method. This will create a filled circle.

static FTGLfont *font[3];
char const *file; 


void circle()
//void circle(float cx, float cy, float r, int num_segments) 
{ 
//	float theta = 2 * 3.1415926 / (float) num_segments; 
//	float c = cosf(theta);//precalculate the sine and cosine
//	float s = sinf(theta);
//	float t;

//	float x = r;//we start at angle = 0 
//	float y = 0; 
    
//	glBegin(GL_LINE_LOOP); 
//	for(int ii = 0; ii < num_segments; ii++) 
//	{ 
//		glVertex2f(x + cx, y + cy);//DrawPoint
        
		//apply the rotation matrix
//		t = x;
//		x = c * x - s * y;
//		y = s * t + c * y;
//	} 
//	glEnd(); 


//stippled circle
int	i, steps = 36;
float	x = 0.0, y = 0.0, r = 1.0, phi, dphi = 2.*M_PI / (float)(steps);

glEnable(GL_LINE_STIPPLE);
glLineStipple(1, 0xff);

glBegin(GL_LINE_LOOP);

for(i = 0, phi = 0.0; i < steps; i ++, phi += dphi)

	glVertex3f(x+r*cos(phi), y+r*sin(phi), 0.0);

glEnd();

glDisable(GL_LINE_STIPPLE);
glFlush();

}

//createcircle(0,10,0);
//That would create a circle that is originated around (0,0) and with
//a radius of 10 units.

void display (void) {
    glClearColor (0.0,0.0,0.0,1.0);
    glClear (GL_COLOR_BUFFER_BIT);

// Set to 2D orthographic projection with the specified clipping area
    glMatrixMode(GL_PROJECTION);      // Select the Projection matrix for operation
    glLoadIdentity();                 // Reset Projection matrix

//this ortho uses GL 1 to -1 co ords
    gluOrtho2D(-1.0, 1.0, -1.0, 1.0); 
    glMatrixMode (GL_MODELVIEW);
 
    glColor3f(1,1,1);
    circle(0,0,25,360);
 
//this one uses standard co ords
    glOrtho (0, 640, 480, 0, 0, 1); 
    glMatrixMode (GL_MODELVIEW);
 
    glRasterPos2f(320.0,240.0);

file = "/usr/share/fonts/truetype/lato/Lato-Bold.ttf";
font[0] = ftglCreateBitmapFont(file); //extruded, bitmap,pixmap
    ftglSetFontFaceSize(font[0], 12, 12);
    ftglSetFontDepth(font[0], 10);
    ftglSetFontOutset(font[0], 0, 3);
    ftglSetFontCharMap(font[0], ft_encoding_unicode);
    ftglRenderFont(font[0], "Hello FTGL!", FTGL_RENDER_ALL);


    glutSwapBuffers();
   
}

void reshape (int w, int h) {
    glViewport (0, 0, (GLsizei)w, (GLsizei)h);
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity ();
    gluPerspective (60, (GLfloat)w / (GLfloat)h, 0.1, 100.0);
    glMatrixMode (GL_MODELVIEW);
}


int main (int argc, char **argv) 
{
   glutInit(&argc, argv);
   glutInitDisplayMode (GLUT_SINGLE | GLUT_RGB);
   glutInitWindowSize (640, 480); 
   glutInitWindowPosition (100, 100);
   glutCreateWindow (argv[0]);

   glClearColor (0.0, 0.0, 0.0, 0.0);
   glShadeModel (GL_FLAT);

   glutDisplayFunc(display); 
   glutReshapeFunc(reshape);
   glutMainLoop();
   return 0;
}

// gcc circle.c -o circle  -I/usr/include/GL -I/usr/include/freetype2/ -I/usr/lib -lGL -lglut -lGLU -lftgl -lm

