procedure GLFontDemo;
var

    s:string;
    font:pointer;

begin

    //MoveTo (Global 0,0 is top left, not bottom left)
    glRasterPos2i(x, y);

    s: = "Respect mah authoritah!";
    font:= GLUT_BITMAP_TIMES_ROMAN_10;
    glutBitmapString ( font, s );

    if render3D then begin

        glMatrixMode(GL_MODELVIEW);
        glPopMatrix();

        glMatrixMode(GL_PROJECTION);
        glPopMatrix();

    end;

end;
