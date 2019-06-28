Unit shapes;

interface
Uses 
    math;

procedure bar3d ( Rect:PSDL_Rect);
procedure Line(renderer1:PSDL_Renderer; X1, Y1, X2, Y2: word; LineStyle:Linestyles);
procedure Rectangle(x,y,w,h:integer);
procedure FilledRectangle(x,y,w,h:integer);

{

Arc:

	This also includes swirlies such as the dreamcast and createTV logos

	It is a "bended line" -like a straw- that has a begining and an end 
    but curves into itself logarithmicly by some math.

Think of it this way:

	If you make it 3d- you have sticky buns. (did someone steal your sweet roll?)



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



//return values can be ignored(unless there are problems) these are proceedures.


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



//these are confusing...you need to pass in multiple point(s)...

Points=record
   X,Y:integer; 
end;

while num < maxpoints
point:array [0..num] of Points
else exit //throwerror

SDL_RenderDrawPoints(points,num)


// Filled Polys 

filledPolygonColor(renderer, vx, vy,numpts, color); 
filledPolygonRGBA(renderer, vx, vy,numpts, r, g, b, a); 

}


PrevArc,NextArc:^arccordstype;
arccoordstype=record 
	x, y:integer;			// Center point of arc 
	xstart, ystart:integer; // Start position 
	xend, yend:integer;	    // end position 
end;

procedure GetArcCoords(var ArcCoords: ArcCoordsType);


implementation


procedure getarccoords(given_struct:^arccoordstype);
begin
  given_struct := PrevArc;
end;

//modified BGI implementation- If the math is off, dont blame me.

procedure bar3d ( Rect:PSDL_Rect);
//"flowchart presentation" 3d bar graphs, not a CUBEish TOWER.


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


procedure Line(renderer1:PSDL_Renderer; X1, Y1, X2, Y2: word; LineStyle:Linestyles);

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

procedure Rectangle(Rect1:PSDL_Rect); overload;
var
    rect1:PSDL_Rect;

begin
  	SDL_RenderFillRect(renderer, rect1);
end;


end.
