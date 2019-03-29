unit gameThings;

{

I bet you were wondering when this unit was coming.

High Scores
Counters
Objects

etc.etc..

No, I hadnt forgotten. I just hadnt gotten there yet.
These are generic but give you a framework for your use.

As I said- This is a UNIT. I will not write your code for you.
YOU need to write it.

ScreenShots and "pausing the game" are covered in the main BGI unit.
..or were...

This will throw a lot of hints and unused variable warnings.
YOu will probably NOT use everything here.


The Basics:

Cards, board games, monsters, etc.

MTG has been done (cockatrice) and Pokemon,etc have "weird rules" to implement on a per card basis.
That is beyond the scope of this code.

}

interface

type
//theres some weird math with this that most games share -- CURSES, DND! (It wont DIE!)
//usually random dice involved and percentages of percentages and more random dice.....

effects=(none,ice,fire,drainHealth,drainMagic,drainStamina,Sleep,zombie,fury,hate,Attractlover);
Races=(dwarf,elf,human,furryThing);

chest=record
	name:string;
	weight:integer;
    affected:effects;
	price:integer;
end;

Crime=record
    ZombiesKilled,
    ChestsLooted,
    Assaults,
    DoorsBustedIn,
    Murders,
    Bribes:integer;
end;


roomType=(shipCompartment,HouseRoom,kitchen,gallery,dungeonRoom,GreatHall,arena,CitySection,forge,medicalBay); 
//derived from AGT- yes AGT.(Adventure Game Toolkit)

cardsType=(Spades,Hearts,Flowers,Diamonds); //clover
cardsValueSpecial=(Ace,King,Queen,Jack);
cardsValue=(Ace,King,Queen,Jack,Ten,Nine,Eight,Seven,Sox,Five,FOur,Three,Two); //ace(1)-King: this is backwards

currentChessBoardColor=(Black,White);
//defaults for othello/reversi and go also

var

//Carry Weight is a weird one..its affected by items at current char level (limits inventory max items)
Rummied,GinRummied,MadeASet:boolean;
IsSorry:boolean; //parcheesy,sorry,etc.
KingME:boolean; //checkers
CharLevel:integer; //affects everything
currentCarryLimit:integer; //dynamic var, but set in game begining.
CanCarryIT,IsDrunk,IsNaked:boolean;
Inventory:array [1..currentCarryLimit] of Chest;
CharacterEffects=(stamina,health,magic,hate,love);
Hungry,IsVampire,IsWereWolf,IsTired:boolean;
MonsterCount,HasntSleptIn:integer;
CurrentCash,ValidMovesLeft,MovesLeft:integer; //may be a hole but is move valid
DiceValue:integer; //random(6),random(20),etc)

implementation
//these two might assume a black background(which is correct- 
//never assume, SET it.

//a 8x8 w green background( I hope)
procedure DrawChessBoard(renderer:PSDL_Renderer);

var
  row,column,x,y:integer;
  darea,rect:PSDL_Rect;

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
  darea,rect:PSDL_Rect;

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

//define character levels(or at least lvl 100 and divide accordingly.
//presonally- Id present up an array instead of dividing things all the time..its faster , for one.


//  CharLevel:=1; 
//  CarryWeight:=110;


end.
