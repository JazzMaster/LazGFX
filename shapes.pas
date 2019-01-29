Unit shapes;

interface

//a pixel is not a shape- but many routines call on pixel ops
//or other basic primitives defined in the core unit

Uses 
    sdlbgi,math;

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
  Richard Jasmin	  - SDL portage

 Credits (external):                                   
   - Original FloodFill code by                        
        Menno Victor van der star                      
     (the code has been heavily modified)         
 
--- 

Most of THESE are functions- not core graphics routines
can be adjusted from FPC sources and mostly used semi-intact.
 
Usermode definitions cannot be trusted- so were removed.
 
 
Kepping in mind that operations are done on a surface- then rendercopy in place.
If we RenderPut every pixel(like in circle drawing)- this takes too much time.

Also floodfills are "x*y pixel array filled" and will have to be converted to SDL_FilledRect
-which internally memset/memcopy all pixels in the array -FASTER- with said color.

Squares are easier to do- thats why most BGI conversion units DONT HAVE THEM.

The FPC dev team knows how to do it- but the code isnt optimal-
and SDL was forgotten about and half-assed.
 
some of this was "due to compatibility" w TP7.
FPC is not TP- and never will be.

TP is circa 1985- yes 85- not 95:
(we had Delphi in 95)

I have seen, system unit level code that will utilize 32 bit longword/DWord and pointers
for older systems and TP7.

Its not common- this requires a 32VM, not 16BI DPMI routine "installed"
-moreso- and hooked with TP to be of any use.
 
Either people dont know how to do this the right way- or didnt have access to those setups.
Futhermore it requires multi-byte and int reads to accomplish things on 8088-level hardware.

If youre looking for speed (or the renderer) you just lost it.
(Rounding bytes from words -will only get you so far) 

Most recent computers circa ~20 years should be fine.


Arc:

	This also includes swirlies such as the dreamcast and createTV logos

	It is a "bended line" -like a straw- that has a begining and an end 
    but curves into itself logarithmicly by some math.

Think of it this way:

	If you make it 3d- you have sticky buns. (did someone steal your sweet roll?)



sdl_GPU functions?

// Circle 

circleColor(renderer,x, y, rad,colour); 
circleRGBA(renderer,x, y, rad, r, g, b, a); 

//Filled Circle

filledCircleColor(renderer,x, y, rad,colour); 
filledCircleRGBA(renderer,x, y, rad,r, g, b, a); 

// Ellipse (lopsided circle)

ellipseColor(renderer,x, y, rx, ry,colour); 

ellipseRGBA(renderer,x, y, rx, ry, r, g, b, a); 

// Filled Ellipse 

filledEllipseColor(renderer, x, y, rx, ry,colour); 
filledEllipseRGBA(renderer,x, y, rx, ry, r, g, b, a); 

// Trigon /Triangle 

trigonColor(renderer, x1, y1, x2, y2, x3, y3,colour); 
trigonRGBA(renderer, x1, y1, x2, y2, x3, y3,r, g, b, a); 

// Filled Trigon 

filledTrigonColor(renderer, x1, y1, x2, y2, x3, y3, colour); 
filledTrigonRGBA(renderer, x1, y1, x2, y2, x3, y3,r, g, b, a); 


// Rounded-Corner Rectangle (3DBAR)

roundedRectangleColor(renderer, x1, y1, x2, y2, rad, colour); 
roundedRectangleRGBA(renderer, x1, y1, x2, y2, rad, r, g, b, a); 

// Rounded-Corner Filled rectangle (Box or button) 

roundedBoxColor(renderer,x1, y1, x2, y2, rad,colour); 
roundedBoxRGBA(renderer, x1, y1, x2, y2, rad,r, g, b, a); 


// Arc 

arcColor(renderer, x, y, rad, start, finish,colour); 
arcRGBA(renderer,x, y, rad, start, finish, r, g, b, a); 


// Pie 

pieColor(renderer,x, y, rad, start, finish, colour); 
pieRGBA(renderer,x, y, rad, start, finish, r, g, b, a); 

// Filled Pie 

filledPieColor(renderer,x, y, rad, start, finish, colour); 
filledPieRGBA(renderer, x, y, rad, start, finish, r, g, b, a); 

// Filled Polys 

filledPolygonColor(renderer, vx, vy,numpts, color); 
filledPolygonRGBA(renderer, vx, vy,numpts, r, g, b, a); 

FPC code bug:
   using FPC code but not using FPC? WHY?
   if your going to rewrite the BGI- even with FPC units-then do it. 
   -when you do it- distribute those units in a TPL file for TP/BP(5 or 7). 
   (I dont see that happening)
   
   Problem is- you cant do this with BP or TP sources-its illegal.
   (Borland forbids modified unit distribution)
   
   FreeDos supports FPC. 
   So do come complaining to be about the code not working where its not supposed to.
   If you want to run FreeDOS on modern hardware- or in a VM- be my guest.
	  -Most people use X11, OSX, or Windows
	   
  Variables could be too small-8 or 16bit instead of 64.
  Bear with the portage.	 
   
  procedures with "var inputs" that start with "GET" .hmmmmmm.....
  (those are functions) 
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
	point:array of Points

//all functions should be rewritten to account for linestyles.
//SDL doesnt take this into account.

procedure bar3d ( Rect:PSDL_Rect);

procedure Line(renderer1:PSDL_Renderer; X1, Y1, X2, Y2: word; LineStyle:Linestyles);

//fills are with _fgcolor unless specified otherwise

procedure Rectangle(x,y,w,h:integer);
procedure FilledRectangle(x,y,w,h:integer);

procedure GetArcCoords(var ArcCoords: ArcCoordsType);

//the Pascal differs and will take some rework (will use offscreen surface rendering to speed up operations)

//custom- from C
procedure SDL_DrawEllipse(renderer:PSDL_Renderer; radiusX,radiusY:integer);
procedure DrawPoints(points:point; num:integer);

implementation
//dont assume- but it can be reasonably assumed that initgraph was called before
//using anything here.

procedure DrawPoly(numpoints : word;var polypoints);
    type
      ppointtype = ^pointtype;
      pt = array[0..8190] of pointtype;
    var
      i, j, LastPolygonStart: longint;
      Closing: boolean;
    begin
      if numpoints < 2 then
        begin
          
          exit;
        end;
      Closing := false;
      LastPolygonStart := 0;
      for i:=0 to numpoints-2 do begin
        { skip an edge after each 'closing' edge }
        if not Closing then
          line(pt(polypoints)[i].x, pt(polypoints)[i].y, pt(polypoints)[i+1].x, pt(polypoints)[i+1].y);

        { check if the current edge is 'closing'. This means that it 'closes'
          the polygon by going back to the first point of the polygon.
          Also, 0-length edges are never considered 'closing'. }
        if ((pt(polypoints)[i+1].x <> pt(polypoints)[i].x) or
            (pt(polypoints)[i+1].y <> pt(polypoints)[i].y)) and
            (LastPolygonStart < i) and
           ((pt(polypoints)[i+1].x = pt(polypoints)[LastPolygonStart].x) and
            (pt(polypoints)[i+1].y = pt(polypoints)[LastPolygonStart].y)) then
        begin
          Closing := true;
          LastPolygonStart := i + 2;
        end
        else
          Closing := false;
      end;
    end;


  procedure PieSlice(X,Y,stangle,endAngle:smallint;Radius: Word);
  begin
    Sector(x,y,stangle,endangle,radius,(longint(Radius)*XAspect) div YAspect);
  end;

//is the line bounds within the current viewports rect?
function LineClipped(x,y,w,h,startXViewport,startYViewport,ViewHeight,ViewWidth:DWord):boolean;

begin
   LineClipped:= (x<startXViewport) or (y>startYViewport) or (w> ViewWidth) or (h>ViewHeight);
end;


procedure SetLineStyle(LineStyle: word; Thickness: word);

   var
    i: byte;
    j: byte;

   Begin
    if (LineStyle > UserBitLn) or ((Thickness <> Normwidth) and (Thickness <> ThickWidth)) then
      //show_message
      //exit
    else
      begin
       LineInfo.Thickness := Thickness;
       LineInfo.LineStyle := LineStyle;
       case LineStyle of
            
            SolidLn:   Lineinfo.Pattern  := $ffff;  { ------- }
            DashedLn : Lineinfo.Pattern := $F8F8;   { -- -- --}
            DottedLn:  LineInfo.Pattern := $CCCC;   { - - - - }
            CenterLn: LineInfo.Pattern :=  $FC78;   { -- - -- }
       end; { end case }
       { setup pattern styles }
       j:=16;
       for i:=0 to 15 do
        Begin
         dec(j);
         { bitwise mask for each bit in the word }
         if (word($01 shl i) AND LineInfo.Pattern) <> 0 then
               LinePatterns[j]:=TRUE
             else
               LinePatterns[j]:=FALSE;
        end;
      end;
   end;


  procedure HLine(x,x2,y: smallint); 

   var
    xtmp: smallint;
   Begin

    { must we swap the values? }
    if x >= x2 then
      Begin
        xtmp := x2;
        x2 := x;
        x:= xtmp;
      end;
    { First convert to global coordinates }
    X   := X + StartXViewPort;
    X2  := X2 + StartXViewPort;
    Y   := Y + StartYViewPort;
    if ClipPixels then
      Begin
         if LineClipped(x,y,x2,y,StartXViewPort,StartYViewPort,
                StartXViewPort+ViewWidth, StartYViewPort+ViewHeight) then
            exit;
      end;
    for x:= x to x2 do
      SDL_PutPixel(X,Y);
   end;


  procedure VLine(x,y,y2: smallint); 

   var
    ytmp: smallint;
  Begin
    { must we swap the values? }
    if y >= y2 then
     Begin
       ytmp := y2;
       y2 := y;
       y:= ytmp;
     end;
    { First convert to global coordinates }
    X   := X + StartXViewPort;
    Y2  := Y2 + StartYViewPort;
    Y   := Y + StartYViewPort;
    if ClipPixels then
      Begin
         if LineClipped(x,y,x,y2,StartXViewPort,StartYViewPort,
                StartXViewPort+ViewWidth, StartYViewPort+ViewHeight) then
            exit;
      end;
    for y := y to y2 do SDL_PutPixel(x,y)
  End;

procedure DrawPoints(points:point; num:integer);

begin
    if (sizeof(points) =0) or (num<2) then begin
		Logln('DrawPoints: empty points array passed to draw with or not enough points to draw.');     
		exit;
    end;
	if num > 1 do begin
		SDL_RenderDrawPoints(points,num)
	end;
	
end;


 procedure Sector(x, y: smallint; StAngle,EndAngle, XRadius, YRadius: Word);
  begin
     internalellipse(XRadius, YRadius, StAngle, EndAngle);
     Line(ArcCall.XStart, ArcCall.YStart, x,y);
     Line(x,y,ArcCall.Xend,ArcCall.YEnd);
  end;



//QUE:
//why two radii? becuase an ellipse. thats y.
// (a football has a greater x radii than a circle- where x and y radii would be the same).

//incomplete elippses are arc(tangents)

//QUE=TP definition- copied here- with mods from FPC Dev Team



//test this- sometimes C devs are Fing LAZY- or worse- WRONG!

//draw one quadrant arc, and mirror the other 4 quadrants
procedure SDL_DrawEllipse(renderer:PSDL_Renderer; radiusX,radiusY:integer);

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

            SDL_RenderDrawLine(r, x0 + x, y0 - y,    x0 + x1, y0 - y1 );//quadrant TR
            SDL_RenderDrawLine(r, x0 - x, y0 - y,    x0 - x1, y0 - y1 );//quadrant TL
            SDL_RenderDrawLine(r, x0 - x, y0 + y,    x0 - x1, y0 + y1 );//quadrant BL
            SDL_RenderDrawLine(r, x0 + x, y0 + y,    x0 + x1, y0 + y1 );//quadrant BR
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
        SDL_RenderDrawLine(r, x0 + x, y0 - y,    x0 + x1, y0 - y1 );//quadrant TR
        SDL_RenderDrawLine(r, x0 - x, y0 - y,    x0 - x1, y0 - y1 );//quadrant TL
        SDL_RenderDrawLine(r, x0 - x, y0 + y,    x0 - x1, y0 + y1 );//quadrant BL
        SDL_RenderDrawLine(r, x0 + x, y0 + y,    x0 + x1, y0 + y1 );//quadrant BR
    end;
end;

//?
procedure getarccoords(given_struct:^arccoordstype);
begin
  given_struct := PrevArc;
end;

//modified BGI implementation- If the math is off, dont blame me.

procedure bar3d ( Rect:PSDL_Rect);
//"flowchart presentation" 3d bar graphs


var
   y,x,w,h:word;
   top,left,right,bottom: word; 
  
begin

  left:=x;
  top:=y;
  bottom:=GetXY(y,h);
  right:=GetXY(x,h);
  
  SDL_RenderFillRect(renderer, rect);
  GotoXY(right, bottom);
  linerel(h*cos(PI/6), (-h)*sin(PI/6) );
  linerel(0, (top-bottom));

end;

//aim for compatibility with existing code-where possible.

procedure Line(X1, Y1, X2, Y2: word);

var
   x:integer;

begin
  
  if LineStyle=NormalWidth then begin //this is the skinny line...
    
    	    SDL_RenderDrawLine(renderer,x1, y1, x2, y2);   
  		    exit;

  end 
  else begin

    //basically draw the line, then fatten it

    //the original line, untouched.  
	SDL_RenderDrawLine(renderer,x1, y1, x2, y2); 
    x:=1;

    repeat
		if odd(x) then begin
  
			//draw one side
			SDL_RenderDrawLine(renderer,x1, y1-x, x2, y2-x); 	
 
			//the other side of the thick line
			SDL_RenderDrawLine(renderer,x1, y1+x, x2, y2+x); 
			inc(x);
		end;
		inc(x);
  	until x=ord(Linestyle);
  
//  SDL_RenderPresent(renderer);
  end;
end;

//thanks to this- we have "turtle" graphics(LOGO)

//relative to current x,y using deltas(could be negative) 
  procedure LineRel(Dx, Dy: smallint);

   Begin
     SDL_RenderDrawLine(X, where.Y, where.X + Dx, where.Y + Dy);
     X := where.X + Dx;
     Y := where.Y + Dy;
   end;

//from current x,y to a,b
  procedure LineTo(a,b : smallint);

   Begin
     SDL_RenderDrawLine(where.X, where.Y, a, b);
     where.X := a;
     where.Y := b;
   end;


procedure Rectangle(x,y,w,h:integer);
//draw rectagle starting at x,y to w,h

var
    rect1:PSDL_Rect;

begin
// if w=h then IsSquare:=true;

    new(Rect1);
	rect1^.x:=x;
    rect1^.y:=y;
    rect1^.w:=w;
    rect1^.h:=h;
  	SDL_RenderDrawRect(renderer, rect1);
    free(Rect1);
end;

procedure Rectangle(Rect1:PSDL_Rect); overload;
var
    rect1:PSDL_Rect;

begin
  	SDL_RenderDrawRect(renderer, rect1);
end;



Function DefaultImageSize(X1,Y1,X2,Y2: smallint): longint; 
Begin
  DefaultImageSize := (ViewportWidth*ViewportHeight);
end;

procedure FilledRectangle(x,y,w,h:integer);
var
    rect1:PSDL_Rect;

begin
	New(Rect1);
	rect1^.x:=x;
    rect1^.y:=y;
    rect1^.w:=w;
    rect1^.h:=h;
	SDL_RenderFillRect(renderer, rect1);
    free(Rect1);
end;

begin
  ArcCall.X := 0;
  ArcCall.Y := 0;
  ArcCall.XStart := 0;
  ArcCall.YStart := 0;
  ArcCall.XEnd := 0;
  ArcCall.YEnd := 0;
end.
