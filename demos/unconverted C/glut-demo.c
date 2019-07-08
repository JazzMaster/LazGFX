#include<gl/glut.h>


void lineSegments(void)
{
glClear(GL_COLOR_BUFFER_BIT);
glColor3f(0.7,0.5,0.7);
glLineWidth(4);

    glBegin(GL_LINES);
	glVertex2i(170,20);
	glVertex2i(20,155);
    glEnd();

glFlush();

glClear(GL_COLOR_BUFFER_BIT);
glColor3f(0.5,0.7,0.5);
glLineWidth(4);

    glBegin(GL_LINES);
	glVertex2i(20,170);
	glVertex2i(155,20);
    glEnd();

glFlush();
}

int main(int argc, char** argv)
{
	glutInit(&argc,argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);

	glutInitWindowPosition(100,100);

	glutInitWindowSize(640,480);
	glutCreateWindow("An Example of open GL");

	glClearColor(0.5,0.7,1.0,0.5);
	glMatrixMode(GL_PROJECTION);
	gluOrtho2D(0.0,200.0,0.0,200.0);

	glutDisplayFunc(lineSegments);

	glutMainLoop();

}