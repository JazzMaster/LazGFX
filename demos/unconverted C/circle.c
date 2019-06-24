//this motherFN code- can port!

#include <GL/gl.h>
#include <GL/glut.h>
#include <math.h>

//cx – the translation on the x axis
//cy – the translation on the y axis
//r – the radius of the circle
//num_segments - how smooth a circle?

// Function that handles the drawing of a circle using the triangle fan
//method. This will create a filled circle.

void circle(float cx, float cy, float r, int num_segments) 
{ 
	float theta = 2 * 3.1415926 / (float) num_segments; 
	float c = cosf(theta);//precalculate the sine and cosine
	float s = sinf(theta);
	float t;

	float x = r;//we start at angle = 0 
	float y = 0; 
    
	glBegin(GL_LINE_LOOP); 
	for(int ii = 0; ii < num_segments; ii++) 
	{ 
		glVertex2f(x + cx, y + cy);//DrawPoint
        
		//apply the rotation matrix
		t = x;
		x = c * x - s * y;
		y = s * t + c * y;
	} 
	glEnd(); 
}

//createcircle(0,10,0);
//That would create a circle that is originated around (0,0) and with
//a radius of 10 units.

void display (void) {
    glClearColor (0.0,0.0,0.0,1.0);
    glClear (GL_COLOR_BUFFER_BIT);
    glLoadIdentity();

    //3D matrix translation(view?)
    glTranslatef(0,0,-20);

    glColor3f(1,1,1);
    circle(0,0,10,360);
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

// gcc circle.c -o circle  -I/usr/include/GL -I/usr/lib -lGL -lglut -lGLU -lm

