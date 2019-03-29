unit fills;

//filled polys, rects, etc..

//just use polys instead of lines
//or dis(en)able filled polys setting in GL.

//to me- the latter is easier.

interface

// SOLID
// Gradients(random color)
// Pattern fill- see below

const
{
Patern Fills:

  //BGI standard (11 patterns, 8 bytes(lines) define the pattern) 
//		-with an assumed 8x8 font size

  //GL specs this as a DWord (BYTE BYTE) of (an array of) binary flags.
  //what we can do is "modify the stipple" (in flight) and output more than one line.

  //so what are we ultimately after?

  backgroundColor(erase)
  Normal
  PacManStipple(--------)
  Stipple(////////)
  ThickStipple(////////)
  Stipple(\\\\\\\\\)
  ThickStipple(\\\\\\\\)
  LtHatch/Cross(xxxxxxxx)
  ThickHatch/Cross(XXXXXXXX)
  Plus/Interleaving(++++++++)

//mimics ascii 8x8 dot extended char
  WideSPCDots(. . . . . . . )
  CloseSPCDots(.. .. .. ..)

//I have the 8x8 CHAR DATA this represents.
}

//notice these are bytes -and need to be words(for GL).

  Patterns : array[0..11] of FillPatternType = (
  ($AA
   $55
   $AA
   $55
   $AA 
   $55
   $AA
   $55),

  ($33,
   $33, 
   $CC, 
   $CC, 
   $33, 
   $33, 
   $CC, 
   $CC),
  
 ($F0, 
  $F0, 
  $F0, 
  $F0, 
  $0F, 
  $0F, 
  $0F, 
  $0F),

  (0, 
  $10, 
  $28, 
  $44, 
  $28, 
  $10, 
  0, 
  0),
  
 (0, 
  $70, 
  $20, 
  $27, 
  $25, 
  $27, 
  $04, 
  $04),

  (0, 
   0, 
   0, 
   $18, 
   $18, 
   0, 
   0, 
   0),

  (0, 
   0, 
   $3C, 
   $3C, 
   $3C, 
   $3C, 
   0, 
   0),
  
 (0, 
  $7E, 
  $7E, 
  $7E, 
  $7E, 
  $7E, 
  $7E, 
  0),
  
 (0, 
  0, 
  $22, 
  $8, 
  0, 
  $22, 
  $1C, 
  0),

  ($FF, 
  $7E, 
  $3C, 
  $18, 
  $18, 
  $3C, 
  $7E, 
  $FF),

  (0, 
  $10, 
  $10, 
  $7C, 
  $10, 
  $10, 
  0, 
  0),
  
 (0, 
 $42, 
 $24, 
 $18, 
 $18, 
 $24, 
 $42, 
 0)

 );


//function max(a, b : Longint) : Longint;
//function min(a, b : Longint) : Longint;

implementation


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

//insert stille code here

//insert GL_QUADS code here (filled polys/polys)
end.﻿
