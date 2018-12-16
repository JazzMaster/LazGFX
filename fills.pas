unit fills;

// The old method used to check scanlines
// and put or remove points, and other tedious work...

//filled polys, rects, etc for SDL

interface
implementation

//we need to know the x,y of where the blit should be centered on...
// your mouse cursor is trick-flopped on screen this way. (sweetSpot)

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

//there are three types of fills:
// SOLID
// Gradients
// Pattern (blitter) -original BGI implementation

{

pattern started as an 8x8 VGA ASCII implementation
        (a scale-able font)

a blit would be better- and easily constrained in a circle or ellipse - not just a rect.


}

end.﻿
