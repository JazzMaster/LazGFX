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


end.﻿
