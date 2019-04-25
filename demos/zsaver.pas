
Program Zsaver:

var
    Color:Longint; //only works for 15/16bits modes
    Color:byte; //only works for 8bit modes
    Color:SDL_Color; //24 and 32 bit modes

procedure DrawZ;
var
    sizeofZ:word;

begin
//while no input do..begin:
//repeat

//THIS IS ONLY one 'Z'.


    sizeofZ:=Random(500); //size in pixels
    Color:=Random(Maxcolors);
    if color = 0 then Color:=Random(MaxColors); //try again
    
    startX:=Random(MaxX);
    startY:=Random(MaxY);

    if (startX > (MaxX - sizeofZ)) then begin //try again- (The 'Z' is cutoff.)
        startX:=Random(MaxX);
        startY:=Random(MaxY);
    end;

    //the math is a bit funky to apply.
    //we use "Relative line co-ords" -but also modified HLine and VLIne to draw with
    //one variable doesnt change- (X or Y)

    //from start to length of line, draw pixels

    x2:= (startX+sizeofZ);
    Line(startX,startY,x2,startY);

    //drop Y down, reset X -starting at last position(LineRel)
    y2:= (startY+sizeofZ);
    x3:= (startX);

    Line(x2,startY,x3,y2);

    //repeat the first line
    
    Line(x3,y2,x2,y2);

//flush
//delay(20);
//clear background(black)

//until keypress;
//end;

end;


