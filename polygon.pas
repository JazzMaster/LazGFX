//polygon.pas
Unit Polygon;

{
AHEM- the "not quite" and beyond "just a line" objects

Theres some confusion here:

You cant have a 3d open ended polygon- thats a bunch of lines 
seen as pipes or wires in 3d.

Please close your polys. Unless of course you like running into pipes or staples or quills....ouch!

This is more for 20 sided dice, stop signs, those weird structures in math class you had to build...etc.

}


interface
Uses
	math,SDL;

var

  _scanlist:scanpt; //Stores the scanlist for a polygon

//reads number of vertices into argument pointer and returns allocated list of vertices, 
//which can be used for drawpoly or fillpoly.
  getpoly:^int;


type

//prev and next chain of points....
  scanpt:^scln;
  scln=record; 
      x,y:integer;
  end;

var
  fillpoly : procedure(numpoints : word;var polypoints);

procedure drawpoly(numpoints:integer, polypoints:^int);

implementation


procedure drawpoly(numpoints : word;var polypoints);
{draw a traced polygon}
var
  i : word;
  points : ^polygon;
begin
  points := @polypoints;
  for i := 0 to numpoints-1 do
  line(points^[i].x,points^[i].y,points^[(i+1) mod numpoints].x,points^[(i+1) mod numpoints].y);
end;


//Im noticing that a ton of the font routines use .CHR (old school fonts)
//although we *could* support them, this is very ancient tech. Id rather use TTF straight-up.

{??
procedure SetTextJustify(horiz,vert : word);

begin
    if (horiz<0) or (horiz>2) or (vert<0) or (vert>2) then
    begin
         _graphresult:=grError;
         exit;
    end;
    Currenttextinfo.horiz:=horiz;
    Currenttextinfo.vert:=vert;
end;

}

begin

end.

