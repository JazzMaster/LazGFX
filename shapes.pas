//grshapes.pas??

Unit shapes;
interface
Uses sdl,math;
{

Arc:

	This also includes swirlies such as the dreamcast and createTV logos

	It is a "bended line" -like a straw- that has a begining and an end 
    but curves into itself logarithmicly by some math.

	If you make it 3d- you have sticky buns. (did someone steal your sweet roll?)

}


type
  line_styles=( SOLID_LINE, DOTTED_LINE, CENTER_LINE, DASHED_LINE, USERBIT_LINE );


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


end.
