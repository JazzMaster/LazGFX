unit fills;
//filled polys, rects, etc..

interface

const

{
Patern Fills:

BGI uses HATCH drawing methods and Self-Recursive algorithms which "waste the stack"
This wont work with larger screens or images.

HATCHES on GL involves vertex shaders-are a mess..and a PITA to get going.


}

type
    Filltype=(Full,HalfTone,Gradient,Flat,None);

const
//    STIPPLE FILL:
        EqualDot=$AA;
        WideDots=$88;
        LooseDots=$22;


var
    halftone: array [0..16] of GLubyte; //GL unsugned byte
    LinePattern: GLushort;  //array[0..16] of boolean; (word)
    PolyStippleEnabled,SmoothShading:boolean;

procedure FillPoly(Phil:FillType);


implementation

procedure FillPoly(Phil:FillType);

begin

   case Phil of
        Full: begin
            glPolygonMode(GL_FRONT, GL_FILL);
        end;
        HalfTone: begin
                glEnable(GL_POLYGON_STIPPLE);               
                PolyStippleEnable:=True;
                glPolygonStipple(halftone);   


                //do the draw operation.
                //AFTER:
                // if PolyStippleEnable=true then
                //   glDisable(GL_POLYGON_STIPPLE);               
                // glFlush();

        end;
        Gradient: begin 
            //now just set each vertex point to a different color
            glShadeModel(GL_SMOOTH);
            SmoothShading:=true;
        end;
        Flat: begin 
            //its all one color
            glShadeModel(GL_FLAT);
            SmoothShading:=false;
        end;

        None: begin
            glPolygonMode(GL_FRONT, GL_LINE);
        end;
   end; 

end;

//like: $AA or $55
procedure StippledLine(Pattern:LinePattern);


begin
   glEnable(GL_LINE_STIPPLE);   
       glLineStipple(1,Pattern);
   glDisable(GL_LINE_STIPPLE);   
end;


begin
   glShadeModel(GL_FLAT);


//32x32 stipple pattern
halftone := (
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55,
    $AA, $AA, $AA, $AA, $55, $55, $55, $55);

{

This is HATCHing (cross hatch) in art:    

        LSlash(\\\\\\\\\)
        RSlash(/////////)
        Cross(xxxxxxxx)
        Plus(++++++++)

In reality- Dithering or Fading(blending) will probably be used

}


end.﻿
