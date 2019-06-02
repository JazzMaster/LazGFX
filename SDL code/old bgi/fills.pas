unit fills;

// The old method used to check scanlines
// and put or remove points, and other tedious work...

//filled polys, rects, etc for SDL

interface

//there are three types of fills:
// SOLID
// Gradients
// Pattern (blitter) -original BGI implementation but as an ASCII char

//--HEY-- everything was hackish back then!

const

 CheckerBoard : FillPatternType = (0, $10, $28, $44, $28, $10, 0, 0);

  Patterns : array[0..11] of FillPatternType = (
  ($AA, $55, $AA, $55, $AA, $55, $AA, $55),
  ($33, $33, $CC, $CC, $33, $33, $CC, $CC),
  ($F0, $F0, $F0, $F0, $F, $F, $F, $F),
  (0, $10, $28, $44, $28, $10, 0, 0),
  (0, $70, $20, $27, $25, $27, $4, $4),
  (0, 0, 0, $18, $18, 0, 0, 0),
  (0, 0, $3C, $3C, $3C, $3C, 0, 0),
  (0, $7E, $7E, $7E, $7E, $7E, $7E, 0),
  (0, 0, $22, $8, 0, $22, $1C, 0),
  ($FF, $7E, $3C, $18, $18, $3C, $7E, $FF),
  (0, $10, $10, $7C, $10, $10, 0, 0),
  (0, $42, $24, $18, $18, $24, $42, 0));

function max(a, b : Longint) : Longint;
function min(a, b : Longint) : Longint;


implementation

//we need to know the x,y of where the blit should be centered on...
// your mouse cursor is trick-flopped on screen this way. (sweetSpot)

{ fpc system internals?

function max(a, b : Longint) : Longint;
begin
  max := b;
  if (a > b) then max := a;
end;

function min(a, b : Longint) : Longint;
begin
  min := b;
  if (a < b) then min := a;
end;

function Int2Str(L : LongInt) : string;
 Converts an integer to a string for use with OutText, OutTextXY 
var
  S : string;
begin
  Str(L, S);
  Int2Str := S;
end;  Int2Str 
}
end.﻿
