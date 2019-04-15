Unit shapes;

{
FPC graphics original code copywright:

 This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by the Free Pascal development team    
    
 AUTHORS:                                                                      
  Gernot Tenchio      - original version              
  Florian Klaempfl    - major updates                 
  Pierre Mueller      - major bugfixes                
  Carl Eric Codere    - complete rewrite              
  Thomas Schatzl      - optimizations,routines and    
                           suggestions.                
  Jonas Maebe         - bugfixes and optimizations    
  Richard Jasmin	  - SDL /freeGLUT portage

  FloodFills are OpenGl defaults, unless specified otherwise.


 Sources modified from a combination of:
   OpenGL demos and public sources
   FPC Graphics unit sources

Framerate management is old school- you should be using deltas for refresh.
However, management of such needs to happen-
	Havoc engine -(Skyrim refresh bugs)- affect playability(in some cases very badly).

Some code courtesy released sources on disc:
        OpenGL for Delphi ISBN (w CD)

Object Colors:
    There is a setting for FLAT-shaded(what we want) but also
        every so many pixel-filled color gradient(OpenGL alt setting)
   -So plan accordingly if you want side of an object in different colors
   If the output isnt what you want- flip the OGL bit.
 
}

interface

//need headers
{$I sdlbgi.inc}

uses
	math,strings;

const
    PI=3.1415926535897932384626433832795;
    HalfPI=1.570796327;

{

Usermode definitions cannot be trusted- so were removed.

a pixel is not a shape- but many routines call on pixel ops
or other basic primitives defined in the core unit(where pixel/color ops are)


Arc=bent lines

Swirlie:
	It is a "bended line" -like a straw- that has a begining and an end 
    but curves into itself logarithmicly by some math.

Think of it this way:

	If you make it 3d- you have sticky buns. (did someone steal your sweet roll?)

There was too much old code here- OpenGL opens a TON of doors.

If I dont have a routine, Ill pull from FPC Dev sources.
Were not overly worried about speed of rendering as we are accuracy with BGI-"derivative output".

}

type

	PrevArc,NextArc:^arccordstype;
	arccoordstype=record 
		x, y:integer;			// Center point of arc 
		xstart, ystart:integer; // Start position 
		xend, yend:integer;	    // end position 
	end;

	Pointsrec=record
		X,Y:integer; 
	end;

//variable array-runtime specified

var
	points:array of Pointsrec;

//all functions should be rewritten to account for linestyles.
//SDL doesnt take this into account.

{
Provides:

Arc
BAR
Bar3d
Line
    HLine
    VLine
    DLine
Rect
Ellipse
Circle
Points (more than one)
RoundedRect
RoundedBox
stippled lines
thick and stippled lines

Pie(??)
PisSlice(??)

Tris
Polys

Beizier Curve/Nubes

-and filled of same

(use the fills mask)

Unfilled:

    of GL_LINE

Filled:

    of GL_LINE_LOOP


3D:

(wireframe if not filled- you can render in points, but why?)

    Cone

Optimal:
    Cube
    Pyramid

    Cylinder
    Dome

Tubes-> see GL Tubing and Extrusion libs
    (but I have a basic 3D tube)

}


//fills are with _fgcolor unless specified otherwise



Const
//in Hz
   FPS_UPPER_LIMIT = 200;
   FPS_LOWER_LIMIT = 1;
   FPS_DEFAULT = 60; //59.955555
//fallbacks
   FPS_HALF=30;
   FPS_QTR=15;

Type
    
    //Record holding the state and timing information of the framerate controller.   
   
   TFPSManager = record
      framecount : LongWord;
      rateticks : Single; // float rateticks;
      baseticks : LongWord;
      lastticks : LongWord;
      rate : LongWord;
   end;
   
   PFPSManager = ^TFPSManager;

var
   AASmoothing:boolean;

{
//rewrite
Procedure SDL_initFramerate(manager: PFPSManager);
Function SDL_setFramerate(manager: PFPSManager; rate: LongWord):LongInt;  
Function SDL_getFramerate(manager: PFPSManager):LongInt;
Function SDL_getFramecount(manager: PFPSManager):LongInt;
Function SDL_framerateDelay(manager: PFPSManager):LongWord;

}

procedure GetArcCoords(var ArcCoords: ArcCoordsType);


implementation

//AAAAHH! The GL!

{
match the GL Stipple pattern:

This is SOME of what we want.
SEE STIPPLE DEMO (in C)

       case LineStyle of           
            SolidLn:   Lineinfo.Pattern  := $ff ff;  ( ------- )
            DashedLn:  Lineinfo.Pattern := $F8 F8;   ( -- -- --)
            DottedLn:  LineInfo.Pattern := $CC CC;   ( - - - - )
            CenterLn:  LineInfo.Pattern :=  $FC 78;   ( -- - -- )
       end;  end case 

}

//draw one quadrant arc, and mirror the other 4 quadrants
//this is what we want to accomplish...sort of..
procedure DrawEllipse(radiusX,radiusY:integer);

//lord knows why its this friggin long long...
const
    pi=3.14159265358979323846264338327950288419716939937510;

var
    pih:float;
    prec:integer;
    step,theta:float;
    x,y,x1,y1:integer;

begin
    //save current x,y

    //haf-a-sum-pi...
    pih := pi mod 2.0; 
    prec := 27; // precision value; value of 1 will draw a diamond, 27 makes pretty smooth circles.
    theta := 0;     // angle that will be increased each loop

    //starting point
    x  := radiusX * cos(theta);//start point
    y  := radiusY * sin(theta);//start point
    x1 := x;
    y1 := y;

    //repeat until theta >= 90;

    step = pih mod prec; // amount to add to theta each time (degrees)
    theta:=step;
    while (theta <= pih ) do begin //step through only a 90 arc (1 quadrant)
    
        //get new point location
        x1 := radiusX * cosf(theta) + 0.5; //new point (+.5 is a quick rounding method)
        y1 := radiusY * sinf(theta) + 0.5; //new point (+.5 is a quick rounding method)

        //draw line from previous point to new point, ONLY if point incremented
        if( (x <> x1) or (y <> y1) ) then begin //only draw if coordinate changed
            //putpixel 

            Line(r, x0 + x, y0 - y,    x0 + x1, y0 - y1 );//quadrant TR
            Line(r, x0 - x, y0 - y,    x0 - x1, y0 - y1 );//quadrant TL
            Line(r, x0 - x, y0 + y,    x0 - x1, y0 + y1 );//quadrant BL
            Line(r, x0 + x, y0 + y,    x0 + x1, y0 + y1 );//quadrant BR
        end;

        //save previous points
        x := x1;//save new previous point
        y := y1;//save new previous point
       theta:=theta+step;
    end;

    //arc did not finish because of rounding, so finish the arc
    if(x<>0) then begin
    
        x:=0;
        //putpixel
        Line(r, x0 + x, y0 - y,    x0 + x1, y0 - y1 );//quadrant TR
        Line(r, x0 - x, y0 - y,    x0 - x1, y0 - y1 );//quadrant TL
        Line(r, x0 - x, y0 + y,    x0 - x1, y0 + y1 );//quadrant BL
        Line(r, x0 + x, y0 + y,    x0 + x1, y0 + y1 );//quadrant BR
    end;
end;


procedure bar3d ( Rect:PSDL_Rect);
//"flowchart presentation" 3d bar graphs


var
   y,x,w,h:word;
   top,left,right,bottom: word; 
  
begin

  left:=Rect^.x;
  top:=Rect^.y;
  bottom:=GetXY(Rect^.y,Rect^.h);
  right:=GetXY(Rect^.x,Rect^.h);
  
  FillRect(rect);

  GotoXY(right, bottom);
  linerel(h*cos(PI/6), (-h)*sin(PI/6) );
  linerel(0, (top-bottom));

end;

//thanks to this- we have "turtle" graphics(LOGO)

//relative to current x,y using deltas(could be negative) 
  procedure LineRel(Dx, Dy: smallint);

   Begin
     Line(X, where.Y, where.X + Dx, where.Y + Dy);
     X := where.X + Dx;
     Y := where.Y + Dy;
   end;

//from current x,y to a,b
  procedure LineTo(a,b : smallint);

   Begin
     Line(where.X, where.Y, a, b);
     where.X := a;
     where.Y := b;
   end;


Function DefaultImageSize(X1,Y1,X2,Y2: smallint): longint; 
Begin
  DefaultImageSize := (ViewportWidth*ViewportHeight);
end;


//I said Id get to the line characters..here we go.
procedure DrawSingleLinedWindowDialog(Rect:PSDL_Rect; colorToSet:DWord);

var
    UL,UR,LL,LR:Points; //see header file(polypts is ok here)
    ShrunkenRect,NewRect:PSDL_Rect;

begin
    Tex:=NewTexture;
    SDL_SetViewPort(Rect);

    //corect me if Im off- this is guesstimate math here, not actual.
    //the corner co ords
    UL.x:=x+2;
    UL.y:=y+2;
    LL.x:=h-2;
    LL.y:=x+2;
    UR.x:=w-2;
    UR.y:=y+2;
    LR.x:=w-2;
    LR.y:=h-2;
    
    NewRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetPenColor(_fgcolor);
    SDL_RenderDrawRect(NewRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)

//shink available space

    //do this again- further in
    UL.x:=x+6;
    UL.y:=y+6;
    LL.x:=h-6;
    LL.y:=x+6;
    UR.x:=w-6;
    UR.y:=y+6;
    LR.x:=w-6;
    LR.y:=h-6;

    ShrunkenRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetViewPort(ShrunkenRect);

end;

procedure DrawDoubleLinedWindowDialog(Rect:PSDL_Rect);

var
    UL,UR,LL,LR:Points; //see header file(polypts is ok here)
    ShrunkenRect,NewRect:PSDL_Rect;

begin
    Tex:=NewTexture;
    SDL_SetViewPort(Rect);

    //corect me if Im off- this is guesstimate math here, not actual.
    //the corner co ords
    UL.x:=x+2;
    UL.y:=y+2;
    LL.x:=h-2;
    LL.y:=x+2;
    UR.x:=w-2;
    UR.y:=y+2;
    LR.x:=w-2;
    LR.y:=h-2;
    NewRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetPenColor(ColorToSet);
    SDL_RenderDrawRect(NewRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)
    
    //do this again- further in
    UL.x:=x+4;
    UL.y:=y+4;
    LL.x:=h-4;
    LL.y:=x+4;
    UR.x:=w-4;
    UR.y:=y+4;
    LR.x:=w-4;
    LR.y:=h-4;
    NewRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetPenColor(ColorToSet);
    SDL_RenderDrawRect(NewRect); 

//shink available space

    //do this again- further in
    UL.x:=x+6;
    UL.y:=y+6;
    LL.x:=h-6;
    LL.y:=x+6;
    UR.x:=w-6;
    UR.y:=y+6;
    LR.x:=w-6;
    LR.y:=h-6;

    ShrunkenRect:=(UL.x,UL.y,UR.x,LR.y); //same in rect format
    SDL_SetViewPort(ShrunkenRect);

end;



begin
  ArcCall.X := 0;
  ArcCall.Y := 0;
  ArcCall.XStart := 0;
  ArcCall.YStart := 0;
  ArcCall.XEnd := 0;
  ArcCall.YEnd := 0;
end.
