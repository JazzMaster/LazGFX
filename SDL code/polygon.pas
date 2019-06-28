//polygon.pas
Unit Polygon;

{
AHEM- the "not quite" and beyond "just a line" objects

Theres some confusion here:

You cant have a 3d open ended polygon- thats a bunch of lines 
seen as pipes or wires in 3d.

Please close your polys. Unless of course you like running into pipes or staples or quills....ouch!

This is more for 20 sided dice, stop signs, those weird paper structures in math class you had to build...etc.

Remember this is SDL code- not BGI.

I suppose I can throw all of these in here:

(done)Tri-3
??-7


(Poly >8) 

Reason for doing so is this:
        speed
If we dont have to guess at sizeof(polypts) [based off of numpoints given] then we have less to worry about.
Pre defines are also faster- and only linked in (usually) if used.
 
Its internally a form of range checking.

(A Pentagon can only have five points-you cant memory leak predefined ranges, theres nothing to overflow,unlike C.)

}


interface
Uses
//main unit headers at minimal needed

	sdlbgi,math,SDL;

type
//this is going to be compied back- no worry.
    polypts=record
        x,y:integer;
    end;

var
//these are range checked.. minimum number of points are required.

	Rect:PSDL_Rect;
    Rhombus:PSDL_Rect; //tilted Rect

    Pentagon:array [0..4] of polypts;
    Hexagon:array [0..5] of polypts;
    Octogon:array [0..7] of polypts;
	Polygon: array[0..MaxPoints] of PolyPts; //9+

const
  MaxPoints = 99; //arbitrary

implementation

procedure Draw_Pentagon;

begin
  if GRAPHICS_ACTIVE= false then exit; //no surface/texture

  //check range
  if ((x<0) or (y<0) or (x1<0) or (y1<0) or (x2<0) or (y2<0) or (x3<0) or (y3<0) or (x4<0) or (y4<0)) then exit; 
  if ((x>MaxX) or (y>MaxY) or (x1>MaxX) or (y1>MaxY) or (x2>MaxX) or (y2>MaxY) or (x3>MaxX) or (y3>MaxY) or (x4>MaxX) or (y4>MaxY)) then exit; 
    
  SDL_RenderLine(x,y,x1,y1);
  SDL_RenderLine(x1,y1,x2,y2);
  SDL_RenderLine(x2,y2,x3,y3);
  SDL_RenderLine(x3,y3,x4,y4);
  SDL_RenderLine(x4,y4,x,y); //always return to origin to complete the poly
  end;
end;

//procedure Draw_FillPentagon;

//filled polys are a touch different. unless you want to rewrite the code, use SDL_RenderFillPoly
// and pad the routine as needed.


begin //main()
    //only put init routines to setup poly data here.

end.

