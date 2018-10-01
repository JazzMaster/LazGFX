unit gameThings;

{

I bet you were wondering when this unit was coming.

High Scores
Save States
MENUS
Counters
Objects

etc.etc..

No, I hadnt forgotten. I just hadnt gotten there yet.
These are generic but give you a framework for your use.

As I said- This is a UNIT. I will not write your code for you.
YOU need to write it.

ScreenShots and "pausing the game" are covered in the main BGI unit.
..or were...

}

interface

type
//theres some weird math with this that most games share -- CURSES, DND! (It wont DIE!)
//usually random dice involved and percentages of percentages and more random dice.....

effects=(ice,fire,drainHealth,drainMagic,drainStamina,Sleep,zombie,fury,hate,love);

chest=record
	name:string;
	weight:integer;
    affected:effects;
	price:integer;
end;

CharacterEffects=(stamina,health,magic,hate,love);
Hungry,IsVampire,IsWereWolf,IsTired:boolean;
MonsterCount,HasntSleptIn:integer;


implementation
//these two might assume a black background(which is correct- (but an ASS out of EWE and ME)

//a 8x8 w green background( I hope)
procedure DrawChessBoard(renderer:^SDL_Renderer);

var
  row,column,x,y:integer;
  darea,rect:^SDL_Rect;

begin
    row = 0;
    column = 0;
    x = 0;

    // Get the Size of drawing surface 
    SDL_RenderGetViewport(renderer, darea);

    while (row < 8) do begin
        column := (row mod 2);
        x := column;
        while (column < (4+(row mod 2)) do begin
            SDL_SetRenderDrawColor(renderer, 0, $99, 0, $FF);

            rect.w = (darea.w div 8);
            rect.h = (darea.h div 8);
            rect.x = (x * rect.w);
            rect.y = (row * rect.h);
            x = x + 1;
            SDL_RenderFillRect(renderer, rect);
            inc(column);
        end;
       inc (row);
    end;
end;


//literally a BW chessboard
procedure DrawChessBoard(renderer:^SDL_Renderer);

var
  row,column,x,y:integer;
  darea,rect:^SDL_Rect;

begin
    row = 0;
    column = 0;
    x = 0;

    // Get the Size of drawing surface 
    SDL_RenderGetViewport(renderer, darea);

    while (row < 8) do begin
        column := (row mod 2);
        x := column;
        while (column < (4+(row mod 2)) do begin
            SDL_SetRenderDrawColor(renderer, 0, 0, 0, $FF);

            rect.w = (darea.w div 8);
            rect.h = (darea.h div 8);
            rect.x = (x * rect.w);
            rect.y = (row * rect.h);
            x = x + 2;
            SDL_RenderFillRect(renderer, rect);
            inc(column);
        end;
       inc (row);
    end;
end;


begin
end.
