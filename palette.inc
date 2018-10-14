
{

256 and below "color" paletted modes-
this gets harder as we go along but this is the "last indexed mode". 

colors (indexes) above 255 should throw an error(undefined --and out of bounds). 

(technically they are rgb(a) colors and have no index anymore)
(so we are in true colors and straight rgb/rgba after this.....)

You need (full) DWords or RGB data for TRUE color modes.
 
'A' bit affects transparency and completes the 'DWord'.
The default setting is to ignore it(FF).
This is what is set.

Most bitmap or blitter or renderer or opengl based code uses some sort of shader(or composite image).
This isnt covered here.

This is for drawing "primitives" on the "surface".....
"advanced primitives" require alpha bit hacking or TRUE COLOR MODE.

-One step at a time.

each 256 SDL_color= r,g,b,a whereas in range of 0-255(FF FF) per color.
for 16 color modes we use 0-16(FF)
 
16 color mode is technically a wonky spec:
officially this is composed of:  RGB plus I(light/dark) modes.
in relaity thi is: RGB+CMY whereas W+K are seperate colors- its not quite CMYK nor RGB with two intensities(7 or F)

CMYK isnt really a video color standard normally because pixels are RGB. 
CMYK is for printing. The reason has to do with color gamut and other huffy-puff.
(Learn photography if you want the color headache)
 

--and THEN- 4 color , 4 palette hi bit resolution modes that are half ass documented. 
Theres no need for those modes anymore.(think t shirt half-tones for screen printing)

this is the best I can implement this given that specs are all over the place- and I want this standardized as much as pssible
given that we have very high color
VGA/SVGA (Video gate array and super video gate array) and VESA (video electronic standards association) modes available now.

}


//we can use SetColor(SkyBlue3); in 256 modes with this- since we know which color index it is.
//this is only for the default palette of course- if you muck with it.....
// and only up to 256 colors....sorry.
// you have no idea how hard to find and hard to put into code this shit is.


//blink is a "text attribute" ..a feature...
//write..wait.erase..wait..rewrite..just like the blinking cursor..

// blink used to be set at value 128;
// Color:=color+Blink; -is the old way.
// Blink('string'); -is the new way.

{

colors: 

	MUST be hard defined to set the pallete prior to drawing.
	No 16 color hacks allowed. They dont work anymore.

}
type
//There IS a way to ge the Names listed here- the magic type info library

//iirc - its ...RED,BLUE,GREEN... on the ol 8088s...
// K-R-B-G-C-M-Br Gy-Gyd R-B-G-C-M-Y-W (CGA)
// vs K-B-G-C-R-M-Br Gy-Gyd- B-G-C-R-M-Y-W (wikipedia)


//the only issue I see here is the overlapping names
TPalette16Names=(BLACK,RED,BLUE,GREEN,CYAN,MAGENTA,BROWN,LTGRAY,GRAY,LTRED,LTBLUE,LTGREEN,LTCYAN,LTMAGENTA,YELLOW,WHITE);
TPalette16NamesGrey=(BLACK,GREY,GREY2,GREY3,GREY4,GREY5,GREY6,GREY7,GRAY8,grey9,grey10,grey11,grey12,grey13,grey14,WHITE);
TPalette256Names=(

BLACK,
BLUE,
GREEN,
CYAN,
RED,
MAGENTA,
BROWN,
LTGRAY,
GRAY,
LTBLUE,
LTGREEN,
LTCYAN,
LTRED,
LTMAGENTA,
YELLOW,
WHITE,

Grey1,
NavyBlue,
DarkBlue,
Blue2,
Blue3,
Blue1,
DarkGreen,
DeepSkyBlue5,
DeepSkyBlue6,
DeepSkyBlue7,
DodgerBlue2,
DodgerBlue1,
Green4,
SpringGreen5,
Turquoise1,
DeepSkyBlue2,
DeepSkyBlue3,
DodgerBlue,
Green2,
SpringGreen,
DarkCyan,
LightSeaGreen,
DeepSkyBlue1,
DeepSkyBlue,
Green3,
SpringGreen4,
SpringGreen1,
Cyan3,
DarkTurquoise,
Turquoise,
Green1,
SpringGreen2,
SpringGreen,
MediumSpringGreen,
Cyan2,

Cyan1,
DarkRed,
DeepPink5,
Purple4,
Purple5,
Purple3,
BlueViolet,
Orange2,
Grey2,
MediumPurple6,
SlateBlue1,
SlateBlue2,
RoyalBlue1,
UnUsedHole5,
DarkSeaGreen7,
PaleTurquoise1,
SteelBlue,
SteelBlue3,
CornflowerBlue,
UnUsedHole3,
DarkSeaGreen8,
CadetBlue,
CadetBlue1,
SkyBlue2,
SteelBlue1,
UnUsedHole4,
PaleGreen2,
SeaGreen3,
Aquamarine2,
MediumTurquoise,
SteelBlue2,
UnUsedHole1,
SeaGreen2,
SeaGreen,
SeaGreen1,
Aquamarine,
DarkSlateGray1,
DarkRed1,
DeepPink6,
DarkMagenta,
DarkMagenta1,
DarkViolet,
Purple1,
Orange3,
LightPink2,
Plum3,
MediumPurple4,
MediumPurple5,
SlateBlue,
Yellow5,

Wheat1,
Grey3,
LightSlateGrey,
MediumPurple,
LightSlateBlue,
Yellow6,
DarkOliveGreen3,
DarkSeaGreen,
LightSkyBlue1,
LightSkyBlue2,
SkyBlue1,
UnUsedHole2,
DarkOliveGreen4,
PaleGreen3,
DarkSeaGreen5,
DarkSlateGray2,
SkyBlue,
UnUsedHole,
LightGreen,
LightGreen1,
PaleGreen,
Aquamarine1,
DarkSlateGray,
Red2,
DeepPink7,
MediumVioletRed,
Magenta4,
DarkViolet1, 
Purple2,
DarkOrange1,
IndianRed,
HotPink3,
MediumOrchid3,
MediumOrchid,
MediumPurple2,
DarkGoldenrod,
LightSalmon1,
RosyBrown,
Grey4,
MediumPurple3,
MediumPurple1,
Gold1,
DarkKhaki,
NavajoWhite1,
Grey5,
LightSteelBlue2,
LightSteelBlue,
Yellow3,
DarkOliveGreen5,
DarkSeaGreen6,

DarkSeaGreen3,
LightCyan2,
LightSkyBlue,
GreenYellow,
DarkOliveGreen2,
PaleGreen1,
DarkSeaGreen4,
DarkSeaGreen1,
PaleTurquoise,
Red3,
DeepPink3,
DeepPink4,
Magenta5,
Magenta6,
Magenta2,
DarkOrange2,
IndianRed1,
HotPink4,
HotPink2,
Orchid,
MediumOrchid1,
Orange1,
LightSalmon2,
LightPink1,
Pink1,

Plum2,
Violet,
Gold2,
LightGoldenrod4,
Tan,
MistyRose1,
Thistle1,
Plum1,
Yellow4,
Khaki1,
LightGoldenrod1,
LightYellow,
Grey6,
LightSteelBlue1,
Yellow2,
DarkOliveGreen,
DarkOliveGreen1,
DarkSeaGreen2,
Honeydew,
LightCyan1,
Red1,
DeepPink2,
DeepPink,
DeepPink1,
Magenta3,

Magenta1,
OrangeRed,
IndianRed2,
IndianRed3,
HotPink,
HotPink1,
MediumOrchid2,
DarkOrange,
Salmon,
LightCoral,
PaleVioletRed,
Orchid2,
Orchid1,
Orange,
SandyBrown,
LightSalmon,
LightPink,
Pink,
Plum,
Gold,
LightGoldenrod2,
LightGoldenrod3,
NavajoWhite,
MistyRose,
Thistle,
Yellow1,
LightGoldenrod,
Khaki,
Wheat,
Cornsilk,

Grey7,
Grey8,
Grey9,
Grey10,
Grey11,
Grey12,
Grey13,
Grey14,
Grey15,
Grey16,

Grey17,
Grey18,
Grey19,
Grey20,
Grey21,
Grey22,
Grey23,
Grey24,
Grey25,
Grey26,

Grey27,
Grey28,
Grey29,
Grey30,
Grey31);

//this one is HELL!
TPalette256NamesGrey=(

BLACK,
grey1,
grey2,
grey3,
grey4,
grey5,
grey6,
grey7,
grey8,
grey9,
grey10,

grey11,
grey12,
grey13,
grey14,
grey15,
grey16,
grey17,
grey18,
grey19,
grey20,

grey21,
grey22,
grey23,
grey24,
grey25,
grey26,
grey27,
grey28,
grey29,
grey30,

grey31,
grey32,
grey33,
grey34,
grey35,
grey36,
grey37,
grey38,
grey39,
grey40,

grey41,
grey42,
grey43,
grey44,
grey45,
grey46,
grey47,
grey48,
grey49,
grey50,

grey51,
grey52,
grey53,
grey54,
grey55,

grey56,
grey57,
grey58,
grey59,
grey60,
grey61,
grey62,
grey63,
grey64,
grey65,

grey66,
grey67,
grey68,
grey69,
grey70,
grey71,
grey72,
grey73,
grey74,
grey75, 

grey76,
grey77,
grey78, 

grey79,
grey80,
grey81,
grey82,
grey83,
grey84,
grey85,
grey86,
grey87,
grey88, 

grey89,
grey90,
grey91,
grey92,
grey93,
grey94,
grey95,
grey96,
grey97,
grey98, /

grey99,
grey100,
grey101,
grey102,
grey103,
grey104,
grey105,
grey106,
grey107,
grey108, 

grey109,
grey110,
grey111,
grey112,
grey113,
grey114,
grey115,
grey116,
grey117,
grey118, 

grey119,
grey120,
grey121,
grey122,
grey123,
grey124,
grey125,
grey126,
grey127,
grey128, 

grey129,
grey130,
grey131,
grey132,
grey133,
grey134,
grey135,
grey136,
grey137,
grey138, 

grey139,
grey140,
grey141,
grey142,
grey143,
grey144,
grey145,
grey146,
grey147,
grey148, 

grey149,
grey150,
grey151,
grey152,
grey153,
grey154,
grey155, 
grey156,
grey157,
grey158, 

grey159,
grey160,
grey161,
grey162,
grey163,
grey164,
grey165,
grey166,
grey167,
grey168, 

grey169,
grey170,
grey171,
grey172,
grey173,
grey174,
grey175,
grey176,
grey177,
grey178, 

grey179,
grey180,
grey181,
grey182,
grey183,
grey184,
grey185,
grey186,
grey187,
grey188, 

grey189,
grey190,
grey191,
grey192,
grey193,
grey194,
grey195,
grey196,
grey197,
grey198, 

grey199,
grey200,
grey201,
grey201,
grey203,
grey204,
grey205,
grey206,
grey207,
grey208,

grey209,
grey210,
grey211,
grey212,
grey213,
grey214,
grey215,
grey216,
grey217,
grey218,

grey219,
grey220,
grey221,
grey222,
grey223,
grey224,
grey225,
grey226,
grey227,
grey228,
grey229,

grey230,
grey231,
grey232,
grey233,
grey234,
grey235,
grey236,
grey237,
grey238,
grey239,
grey240,

grey241,
grey242,
grey243,
grey244,
grey245,
grey246,
grey247,
grey248,
grey249,
grey250,

grey251,
grey252,
grey253,
grey254,
white, 

);

TRec16=record
  
	colors=array [0..15] of PSDL_COLOR; //this is setup later on. 

{SDL defines this is as:

SDL_Color=record
	r,g,b,a:byte;
	...some other stuff we dont need to use.
end;

}

	DWords=array [0..15] of DWord;

end;


//this is the XTerm 256 definition...

//palette tricks would then need to use : colors[1].a hacks.

//just so you can see the amount of datas were dealing with here.
//really shouldnt go there..and waay too many palettes out there.
//this really should be read in from a file.

//anyways- as "standard" as I can get.Most UNICES use this.


TRec256=record

  colors=array [0..255] of PSDL_COLOR; //this is setup later on. 
  DWords=array [0..255] of DWord;

end;


var
//this one is unorthodox due to the totally destructive downsizing and image degredation needed
  GreyList16:array [0..48] of word;
  valuelist16: array [0..48] of Word;
  
//in case you want B/W greyscale images or modes or other cruft  
  GreyList256:array [0..765] of word;
  valuelist256: array [0..765] of Word;

  TPalette16:TRec16;
  TPalette16Grey:TRec256;

  TPalette256:TRec256;
  TPalette256Grey:TRec256;


procedure init16PaletteGrey;

var
   i:integer;


 begin  

valuelist16:=

(
$00, $00, $00,
$11, $11, $11,
$22, $22, $22,
$33, $33, $33,
$44, $44, $44,
$55, $55, $55, 
$66, $66, $66,
$77, $77, $77,
$88, $88, $88,
$99, $99, $99,
$AA, $AA, $AA,
$bb, $bb, $bb,
$cc, $cc, $cc,
$dd, $dd, $dd,
$ee, $ee, $ee, 
$ff, $ff, $ff);


   i:=0;
   num:=0; 
   for num:=0 to 15 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  end;


//16 color (M)CGA palette

TPalette16Grey.Name[0]:='black';
TPalette16Grey.Name[1]:='grey1';
TPalette16Grey.Name[2]:='grey2';
TPalette16Grey.Name[3]:='grey3';
TPalette16Grey.Name[4]:='grey4';
TPalette16Grey.Name[5]:='grey5';
TPalette16Grey.Name[6]:='grey6';
TPalette16Grey.Name[7]:='grey7';
TPalette16Grey.Name[8]:='grey8';
TPalette16Grey.Name[9]:='grey9';
TPalette16Grey.Name[10]:='grey10';
TPalette16Grey.Name[11]:='grey11';
TPalette16Grey.Name[12]:='grey12';
TPalette16Grey.Name[13]:='grey13';
TPalette16Grey.Name[14]:='grey14';
TPalette16Grey.Name[15]:='white';


TPalette16GRey.DWords[0]:=$000000ff;
TPalette16GRey.DWords[1]:=$111111ff;
TPalette16GRey.DWords[2]:=$222222ff;
TPalette16GRey.DWords[3]:=$333333ff;
TPalette16GRey.DWords[4]:=$444444ff;
TPalette16GRey.DWords[5]:=$555555ff;
TPalette16GRey.DWords[6]:=$666666ff;
TPalette16GRey.DWords[7]:=$777777ff;
TPalette16GRey.DWords[8]:=$888888ff;
TPalette16GRey.DWords[9]:=$999999ff;
TPalette16GRey.DWords[10]:=$aaaaaaff;
TPalette16GRey.DWords[11]:=$bbbbbbff;
TPalette16GRey.DWords[12]:=$ccccccff;
TPalette16GRey.DWords[13]:=$ddddddff;
TPalette16GRey.DWords[14]:=$eeeeeeff;
TPalette16GRey.DWords[15]:=$ffffffff; 


end;



procedure init16Palette;

var
   i:integer;


 begin  

valuelist16:=

(
$00, $00, $00,
$80, $00, $00,
$00, $80, $00,
$80, $80, $00,
$00, $00, $80,
$80, $00, $80, 
$00, $80, $80,
$c0, $c0, $c0,
$80, $80, $80,
$ff, $00, $00,
$00, $ff, $00,
$ff, $ff, $00,
$00, $00, $ff,
$ff, $00, $ff,
$ff, $ff, $00, 
$ff, $ff, $ff);


   i:=0;
   num:=0; 
   for num:=0 to 15 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  end;


//16 color (M)CGA palette

TPalette16.Name[0]:='black';
TPalette16.Name[1]:='blue';
TPalette16.Name[2]:='green';
TPalette16.Name[3]:='cyan';
TPalette16.Name[4]:='red';
TPalette16.Name[5]:='magenta';
TPalette16.Name[6]:='brown';
TPalette16.Name[7]:='light gray';
TPalette16.Name[8]:='gray';
TPalette16.Name[9]:='light blue';
TPalette16.Name[10]:='light green';
TPalette16.Name[11]:='light cyan';
TPalette16.Name[12]:='light red';
TPalette16.Name[13]:='light magenta';
TPalette16.Name[14]:='yellow';
TPalette16.Name[15]:='white';


TPalette16.DWords[0]:=$000000ff;
TPalette16.DWords[1]:=$0000aaff;
TPalette16.DWords[2]:=$00aa00ff;
TPalette16.DWords[3]:=$00aaaaff;
TPalette16.DWords[4]:=$aa0000ff;
TPalette16.DWords[5]:=$aa00aaff;
TPalette16.DWords[6]:=$aa5500ff;
TPalette16.DWords[7]:=$aaaaaaff;
TPalette16.DWords[8]:=$555555ff;
TPalette16.DWords[9]:=$5555ffff;
TPalette16.DWords[10]:=$55ff55ff;
TPalette16.DWords[11]:=$55ffffff;
TPalette16.DWords[12]:=$ff5555ff;
TPalette16.DWords[13]:=$ff55ffff;
TPalette16.DWords[14]:=$ffff55ff;
TPalette16.DWords[15]:=$ffffffff;

end;


procedure Save16Palette;

Var
	palette16File  : File of Tpalette16;
	i,num            : integer;

Begin
	init16Palette;
	Assign(palette16File, 'palette16.dat');
	ReWrite(palette16File);
    
	For num := 1 to 16 do

	Begin;
	  Write(palette16File, TPalette16.colors[num]); //sdl_Color
      inc(num);
	End;

    i:=0;
	For i := 1 to 16 do
	Begin;
		Write(palette16File, TPalette16.Name[i]); //string
		inc(i);
	End;

    i:=0;
	For i := 1 to 16 do
	Begin;
		Write(palette16File, TPalette16.DWords[i]); //dword
		inc(i);
	End;

	Close(palette16File);
	
End;

procedure Read16Palette;

Var
	palette16File  : File of Tpalette16;
	i,num            : integer;

Begin
	Assign(palette16File, 'palette16.dat');
	ReSet(palette16File);
    Seek(palette16File, 0); //find first record
    
	For num := 1 to 16 do

	Begin;
	  Read(palette16File, TPalette16.colors[num]); //sdl_Color
      inc(num); 
	End;

    i:=0;
	For i := 1 to 16 do
	Begin;
		Read(palette16File, TPalette16.Name[i]); //string
		inc(i);
	End;

    i:=0;
	For i := 1 to 16 do
	Begin;
		Read(palette16File, TPalette16.DWords[i]); //dword
		inc(i);
	End;

	Close(palette16File);
	//much much easier now....
    SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, Tpalette16.colors, 0, 16 );

end;

procedure init256Palette;

//furthermore there are other 256rgb palettes.
//-accurate as per xterm specs.


var
    i:integer;


 begin  

valuelist256:=
(

$00, $00, $00,
$08, $00, $00,
$00, $80, $00,
$80, $80, $00,
$00, $00, $80,
$80, $00, $80,
$00, $80, $80,
$c0, $c0, $c0,
$80, $80, $80,
$ff, $00, $00,
$00, $ff, $00,
$ff, $ff, $00,
$00, $00, $ff,
$ff, $00, $ff,
$00, $ff, $ff,
$ff, $ff, $ff,
$00, $00, $00,
$00, $00, $5f,
$00, $00, $87,
$00, $00, $af,
$00, $00, $d7,
$00, $00, $ff,
$00, $5f, $00,
$00, $5f, $5f,
$00, $5f, $87,
$00, $5f, $af,
$00, $5f, $d7,
$00, $5f, $ff,
$00, $87, $00,
$00, $87, $5f,
$00, $87, $87,
$00, $87, $af,
$00, $87, $d7,
$00, $87, $ff,
$00, $af, $00,
$00, $af, $5f,
$00, $af, $87,
$00, $af, $af,
$00, $af, $d7,
$00, $af, $ff,
$00, $d7, $00,
$00, $d7, $5f,
$00, $d7, $87,
$00, $d7, $af,
$00, $d7, $d7,
$00, $d7, $ff,
$00, $ff, $00,
$00, $ff, $5f,
$00, $ff, $87,
$00, $ff, $af,
$00, $ff, $d7,
$00, $ff, $ff,
$5f, $00, $00,
$5f, $00, $5f,
$5f, $00, $87,
$5f, $00, $af,
$5f, $00, $d7,
$5f, $00, $ff,
$5f, $5f, $00,
$5f, $5f, $5f,
$5f, $5f, $87,
$5f, $5f, $af,
$5f, $5f, $d7,
$5f, $5f, $ff,
$5f, $87, $00,
$5f, $87, $5f,
$5f, $87, $87,
$5f, $87, $af,
$5f, $87, $d7,
$5f, $87, $ff,
$5f, $af, $00,
$5f, $af, $5f,
$5f, $af, $87,
$5f, $af, $af,
$5f, $af, $d7,
$5f, $af, $ff,
$5f, $d7, $00,
$5f, $d7, $5f,
$5f, $d7, $87,
$5f, $d7, $af,
$5f, $d7, $d7,
$5f, $d7, $ff,
$5f, $ff, $00,
$5f, $ff, $5f,
$5f, $ff, $87,
$5f, $ff, $af,
$5f, $ff, $d7,
$5f, $ff, $ff,
$87, $00, $00,
$87, $00, $5f,
$87, $00, $87,
$87, $00, $af,
$87, $00, $d7,
$87, $00, $ff,
$87, $5f, $00,
$87, $5f, $5f,
$87, $5f, $87,
$87, $5f, $af,
$87, $5f, $d7,
$87, $5f, $ff,
$87, $87, $00,
$87, $87, $5f,
$87, $87, $87,
$87, $87, $af,
$87, $87, $d7,
$87, $87, $ff,
$87, $af, $00,
$87, $af, $5f,
$87, $af, $87,
$87, $af, $af,
$87, $af, $d7,
$87, $af, $ff,
$87, $d7, $00,
$87, $d7, $5f,
$87, $d7, $87,
$87, $d7, $af,
$87, $d7, $d7,
$87, $d7, $ff,
$87, $ff, $00,
$87, $ff, $5f,
$87, $ff, $87,
$87, $ff, $af,
$87, $ff, $d7,
$87, $ff, $ff,
$af, $00, $00,
$af, $00, $5f,
$af, $00, $87,
$af, $00, $af,
$af, $00, $d7,
$af, $00, $ff,
$af, $5f, $00,
$af, $5f, $5f,
$af, $5f, $87,
$af, $5f, $af,
$af, $5f, $d7,
$af, $5f, $ff,
$af, $87, $00,
$af, $87, $5f,
$af, $87, $87,
$af, $87, $af,
$af, $87, $d7,
$af, $87, $ff,
$af, $af, $00,
$af, $af, $5f,
$af, $af, $87,
$af, $af, $af,
$af, $af, $d7,
$af, $af, $ff,
$af, $d7, $00,
$af, $d7, $5f,
$af, $d7, $87,
$af, $d7, $af,
$af, $d7, $d7,
$af, $d7, $ff,
$af, $ff, $00,
$af, $ff, $5f,
$af, $ff, $87,
$af, $ff, $af,
$af, $ff, $d7,
$af, $ff, $ff,
$d7, $00, $00,
$d7, $00, $5f,
$d7, $00, $87,
$d7, $00, $af,
$d7, $00, $d7,
$d7, $00, $ff,
$d7, $5f, $00,
$d7, $5f, $5f,
$d7, $5f, $87,
$d7, $5f, $af,
$d7, $5f, $d7,
$d7, $5f, $ff,
$d7, $87, $00,
$d7, $87, $5f,
$d7, $87, $87,
$d7, $87, $af,
$d7, $87, $d7,
$d7, $87, $ff,
$d7, $af, $00,
$d7, $af, $5f,
$d7, $af, $87,
$d7, $af, $af,
$d7, $af, $d7,
$d7, $af, $ff,
$d7, $d7, $00,
$d7, $d7, $5f,
$d7, $d7, $87,
$d7, $d7, $af,
$d7, $d7, $d7,
$d7, $d7, $ff,
$d7, $ff, $00,
$d7, $ff, $5f,
$d7, $ff, $87,
$d7, $ff, $af,
$d7, $ff, $d7,
$d7, $ff, $ff,
$ff, $00, $00,
$ff, $00, $5f,
$ff, $00, $87,
$ff, $00, $af,
$ff, $00, $d7,
$ff, $00, $ff,
$ff, $5f, $00,
$ff, $5f, $5f,
$ff, $5f, $87,
$ff, $5f, $af,
$ff, $5f, $d7,
$ff, $5f, $ff,
$ff, $87, $00,
$ff, $87, $5f,
$ff, $87, $87,
$ff, $87, $af,
$ff, $87, $d7,
$ff, $87, $ff,
$ff, $af, $00,
$ff, $af, $5f,
$ff, $af, $87,
$ff, $af, $af,
$ff, $af, $d7,
$ff, $af, $ff,
$ff, $d7, $00,
$ff, $d7, $5f,
$ff, $d7, $87,
$ff, $d7, $af,
$ff, $d7, $d7,
$ff, $d7, $ff,
$ff, $ff, $00,
$ff, $ff, $5f,
$ff, $ff, $87,
$ff, $ff, $af,
$ff, $ff, $d7,
$ff, $ff, $ff,
$08, $08, $08,
$12, $12, $12,
$1c, $1c, $1c,
$26, $26, $26,
$30, $30, $30,
$3a, $3a, $3a,
$44, $44, $44,
$4e, $4e, $4e,
$58, $58, $58,
$62, $62, $62,
$6c, $6c, $6c,
$76, $76, $76,
$80, $80, $80,
$8a, $8a, $8a,
$94, $94, $94,
$9e, $9e, $9e,
$a8, $a8, $a8,
$b2, $b2, $b2,
$bc, $bc, $bc,
$c6, $c6, $c6,
$d0, $d0, $d0,
$da, $da, $da,
$e4, $e4, $e4,
$ee, $ee, $ee

);

   i:=0;
   num:=0; 
   for num:=0 to 768 do begin 
      palette256.colors[num].r:=valuelist256[i];
      palette256.colors[num].g:=valuelist256[i+1];
      palette256.colors[num].b:=valuelist256[i+2];
      palette256.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  end;

	
//256 color VGA palette based on XTerm colors(Unix)


TPalette256.DWords[0]:=$000000ff;
TPalette256.DWords[1]:=$080000ff;
TPalette256.DWords[2]:=$008000ff;
TPalette256.DWords[3]:=$808000ff;
TPalette256.DWords[4]:=$000080ff;
TPalette256.DWords[5]:=$800080ff;
TPalette256.DWords[6]:=$008080ff;
TPalette256.DWords[7]:=$c0c0c0ff;
TPalette256.DWords[8]:=$808080ff;
TPalette256.DWords[9]:=$ff0000ff;
TPalette256.DWords[10]:=$00ff00ff;
TPalette256.DWords[11]:=$ffff00ff;
TPalette256.DWords[12]:=$0000ffff;
TPalette256.DWords[13]:=$ff00ffff;
TPalette256.DWords[14]:=$00ffffff;
TPalette256.DWords[15]:=$ffffffff;

TPalette256.DWords[16]:=$000000ff;
TPalette256.DWords[17]:=$00005fff,
TPalette256.DWords[18]:=$000087ff,
TPalette256.DWords[19]:=$0000afff,
TPalette256.DWords[20]:=$0000d7ff,
TPalette256.DWords[21]:=$0000ffff,
TPalette256.DWords[22]:=$005f00ff,
TPalette256.DWords[23]:=$005f5fff,
TPalette256.DWords[24]:=$005f87ff,
TPalette256.DWords[25]:=$005fafff,
TPalette256.DWords[26]:=$005fd7ff,
TPalette256.DWords[27]:=$005fffff,
TPalette256.DWords[28]:=$008700ff,
TPalette256.DWords[29]:=$00875fff,
TPalette256.DWords[30]:=$008787ff,

TPalette256.DWords[31]:=$0087afff,
TPalette256.DWords[32]:=$0087d7ff,
TPalette256.DWords[33]:=$0087ffff,
TPalette256.DWords[34]:=$00af00ff,
TPalette256.DWords[35]:=$00af5fff,
TPalette256.DWords[36]:=$00af87ff,
TPalette256.DWords[37]:=$00afafff,
TPalette256.DWords[38]:=$00afd7ff,
TPalette256.DWords[39]:=$00afffff,
TPalette256.DWords[40]:=$00d700ff,
TPalette256.DWords[41]:=$00d75fff,
TPalette256.DWords[42]:=$00d787ff,
TPalette256.DWords[43]:=$00d7afff,
TPalette256.DWords[44]:=$00d7d7ff,
TPalette256.DWords[45]:=$00d7ffff,

TPalette256.DWords[46]:=$00ff00ff,
TPalette256.DWords[47]:=$00ff5fff,
TPalette256.DWords[48]:=$00ff87ff,
TPalette256.DWords[49]:=$00ffafff,
TPalette256.DWords[50]:=$00ffd7ff,
TPalette256.DWords[51]:=$00ffffff,
TPalette256.DWords[52]:=$5f0000ff,
TPalette256.DWords[53]:=$5f005fff,
TPalette256.DWords[54]:=$5f0087ff,
TPalette256.DWords[55]:=$5f00afff,
TPalette256.DWords[56]:=$5f00d7ff,
TPalette256.DWords[57]:=$5f00ffff,
TPalette256.DWords[58]:=$5f5f00ff,
TPalette256.DWords[59]:=$5f5f5fff,
TPalette256.DWords[60]:=$5f5f87ff,

TPalette256.DWords[61]:=$5f5fafff,
TPalette256.DWords[62]:=$5f5fd7ff,
TPalette256.DWords[63]:=$5f5fffff,
TPalette256.DWords[64]:=$5f8700ff,
TPalette256.DWords[65]:=$5f875fff,
TPalette256.DWords[66]:=$5f8787ff,
TPalette256.DWords[67]:=$5f87afff,
TPalette256.DWords[68]:=$5f87d7ff,
TPalette256.DWords[69]:=$5f87ffff,
TPalette256.DWords[70]:=$5faf00ff,
TPalette256.DWords[71]:=$5faf5fff,
TPalette256.DWords[72]:=$5faf87ff,
TPalette256.DWords[73]:=$5fafafff,
TPalette256.DWords[74]:=$5fafd7ff,
TPalette256.DWords[75]:=$5fafffff,

TPalette256.DWords[76]:=$5fd700ff,
TPalette256.DWords[77]:=$5fd75fff,
TPalette256.DWords[78]:=$5fd787ff,
TPalette256.DWords[79]:=$5fd7afff,
TPalette256.DWords[80]:=$5fd7d7ff,
TPalette256.DWords[81]:=$5fd7ffff,
TPalette256.DWords[82]:=$5fff00ff,
TPalette256.DWords[83]:=$5fff5fff,
TPalette256.DWords[84]:=$5fff87ff,
TPalette256.DWords[85]:=$5fffafff,
TPalette256.DWords[86]:=$5fffd7ff,
TPalette256.DWords[87]:=$5fffffff,
TPalette256.DWords[88]:=$870000ff,
TPalette256.DWords[89]:=$87005fff,
TPalette256.DWords[90]:=$870087ff,

TPalette256.DWords[91]:=$8700afff,
TPalette256.DWords[92]:=$8700d7ff,
TPalette256.DWords[93]:=$8700ffff,
TPalette256.DWords[94]:=$875f00ff,
TPalette256.DWords[95]:=$875f5fff,
TPalette256.DWords[96]:=$875f87ff,
TPalette256.DWords[97]:=$875fafff,
TPalette256.DWords[98]:=$875fd7ff,
TPalette256.DWords[99]:=$875fffff,
TPalette256.DWords[100]:=$878700ff,
TPalette256.DWords[101]:=$87875fff,
TPalette256.DWords[102]:=$878787ff,
TPalette256.DWords[103]:=$8787afff,
TPalette256.DWords[104]:=$8787d7ff,
TPalette256.DWords[105]:=$8787ffff,

TPalette256.DWords[106]:=$87af00ff,
TPalette256.DWords[107]:=$87af5fff,
TPalette256.DWords[108]:=$87af87ff,
TPalette256.DWords[109]:=$87afafff,


TPalette256.DWords[110]:=$87afd7ff,
TPalette256.DWords[111]:=$87afffff,
TPalette256.DWords[112]:=$87d700ff,
TPalette256.DWords[113]:=$87d75fff,
TPalette256.DWords[114]:=$87d787ff,
TPalette256.DWords[115]:=$87d7afff,
TPalette256.DWords[116]:=$87d7d7ff,
TPalette256.DWords[117]:=$87d7ffff,
TPalette256.DWords[118]:=$87ff00ff
TPalette256.DWords[119]:=$87ff5fff,
TPalette256.DWords[120]:=$87ff87ff,

TPalette256.DWords[121]:=$87ffafff,
TPalette256.DWords[122]:=$87ffd7ff,
TPalette256.DWords[123]:=$87ffffff,
TPalette256.DWords[124]:=$af0000ff,
TPalette256.DWords[125]:=$af005fff,
TPalette256.DWords[126]:=$af0087ff,
TPalette256.DWords[127]:=$af00afff,
TPalette256.DWords[128]:=$af00d7ff,
TPalette256.DWords[129]:=$af00ffff,
TPalette256.DWords[130]:=$af5f00ff,
TPalette256.DWords[131]:=$af5f5fff,
TPalette256.DWords[132]:=$af5f87ff,
TPalette256.DWords[133]:=$af5fafff,
TPalette256.DWords[134]:=$af5fd7ff,
TPalette256.DWords[135]:=$af5fffff,

TPalette256.DWords[136]:=$af8700ff,
TPalette256.DWords[137]:=$af875fff,
TPalette256.DWords[138]:=$af8787ff,
TPalette256.DWords[139]:=$af87afff,
TPalette256.DWords[140]:=$af87d7ff,
TPalette256.DWords[141]:=$af87ffff,
TPalette256.DWords[142]:=$afaf00ff,
TPalette256.DWords[143]:=$afaf5fff,
TPalette256.DWords[144]:=$afaf87ff,
TPalette256.DWords[145]:=$afafafff,
TPalette256.DWords[146]:=$afafd7ff,
TPalette256.DWords[147]:=$afafffff,
TPalette256.DWords[148]:=$afd700ff,
TPalette256.DWords[149]:=$afd75fff,
TPalette256.DWords[150]:=$afd787ff,

TPalette256.DWords[151]:=$afd7afff,
TPalette256.DWords[152]:=$afd7d7ff,
TPalette256.DWords[153]:=$afd7ffff,
TPalette256.DWords[154]:=$afff00ff,
TPalette256.DWords[155]:=$afff5fff,
TPalette256.DWords[156]:=$afff87ff,
TPalette256.DWords[157]:=$afffafff,
TPalette256.DWords[158]:=$afffd7ff,
TPalette256.DWords[159]:=$afffffff,
TPalette256.DWords[160]:=$d70000ff,
TPalette256.DWords[161]:=$d7005fff,
TPalette256.DWords[162]:=$d70087ff,
TPalette256.DWords[163]:=$d700afff,
TPalette256.DWords[164]:=$d700d7ff,
TPalette256.DWords[165]:=$d700ffff,

TPalette256.DWords[166]:=$d75f00ff,
TPalette256.DWords[167]:=$d75f5fff,
TPalette256.DWords[168]:=$d75f87ff,
TPalette256.DWords[169]:=$d75fafff,
TPalette256.DWords[170]:=$d75fd7ff,
TPalette256.DWords[171]:=$d75fffff,
TPalette256.DWords[172]:=$d78700ff,
TPalette256.DWords[173]:=$d7875fff,
TPalette256.DWords[174]:=$d78787ff,
TPalette256.DWords[175]:=$d787afff,
TPalette256.DWords[176]:=$d787d7ff,
TPalette256.DWords[177]:=$d787ffff,
TPalette256.DWords[178]:=$d7af00ff,
TPalette256.DWords[179]:=$d7af5fff,
TPalette256.DWords[180]:=$d7af87ff,

TPalette256.DWords[181]:=$d7afafff,
TPalette256.DWords[182]:=$d7afd7ff,
TPalette256.DWords[183]:=$d7afffff,
TPalette256.DWords[184]:=$d7d700ff,
TPalette256.DWords[185]:=$d7d75fff,
TPalette256.DWords[186]:=$d7d787ff,
TPalette256.DWords[187]:=$d7d7afff,
TPalette256.DWords[188]:=$d7d7d7ff,
TPalette256.DWords[189]:=$d7d7ffff,
TPalette256.DWords[190]:=$d7ff00ff,
TPalette256.DWords[191]:=$d7ff5fff,
TPalette256.DWords[192]:=$d7ff87ff,
TPalette256.DWords[193]:=$d7ffafff,
TPalette256.DWords[194]:=$d7ffd7ff,
TPalette256.DWords[195]:=$d7ffffff,

TPalette256.DWords[196]:=$ff0000ff,
TPalette256.DWords[197]:=$ff005fff,
TPalette256.DWords[198]:=$ff0087ff,
TPalette256.DWords[199]:=$ff00afff,
TPalette256.DWords[200]:=$ff00d7ff,
TPalette256.DWords[201]:=$ff00ffff,
TPalette256.DWords[202]:=$ff5f00ff,
TPalette256.DWords[203]:=$ff5f5fff,
TPalette256.DWords[204]:=$ff5f87ff,
TPalette256.DWords[205]:=$ff5fafff,
TPalette256.DWords[206]:=$ff5fd7ff,
TPalette256.DWords[207]:=$ff5fffff,
TPalette256.DWords[208]:=$ff8700ff,
TPalette256.DWords[209]:=$ff875fff,
TPalette256.DWords[210]:=$ff8787ff,

TPalette256.DWords[211]:=$ff87afff,
TPalette256.DWords[212]:=$ff87d7ff,
TPalette256.DWords[213]:=$ff87ffff,
TPalette256.DWords[214]:=$ffaf00ff,
TPalette256.DWords[215]:=$ffaf5fff,
TPalette256.DWords[216]:=$ffaf87ff,
TPalette256.DWords[217]:=$ffafafff,
TPalette256.DWords[218]:=$ffafd7ff,
TPalette256.DWords[219]:=$ffafffff,
TPalette256.DWords[220]:=$ffd700ff,

TPalette256.DWords[221]:=$ffd75fff,
TPalette256.DWords[222]:=$ffd787ff,
TPalette256.DWords[223]:=$ffd7afff,
TPalette256.DWords[224]:=$ffd7d7ff,

TPalette256.DWords[225]:=$ffd7ffff,
TPalette256.DWords[226]:=$ffff00ff,
TPalette256.DWords[227]:=$ffff5fff,
TPalette256.DWords[228]:=$ffff87ff,
TPalette256.DWords[229]:=$ffffafff,
TPalette256.DWords[230]:=$ffffd7ff,


//greyscales -this code is ok-

TPalette256.DWords[231]:=$ffffffff;
TPalette256.DWords[232]:=$080808ff;
TPalette256.DWords[233]:=$121212ff;
TPalette256.DWords[234]:=$1c1c1cff;
TPalette256.DWords[235]:=$262626ff;
TPalette256.DWords[236]:=$303030ff;
TPalette256.DWords[237]:=$3a3a3aff;
TPalette256.DWords[238]:=$444444ff;
TPalette256.DWords[239]:=$4e4e4eff;
TPalette256.DWords[240]:=$585858ff;
TPalette256.DWords[241]:=$626262ff;
TPalette256.DWords[242]:=$6c6c6cff;
TPalette256.DWords[243]:=$767676ff;
TPalette256.DWords[244]:=$808080ff;
TPalette256.DWords[245]:=$8a8a8aff;
TPalette256.DWords[246]:=$949494ff;
TPalette256.DWords[247]:=$9e9e9eff;
TPalette256.DWords[248]:=$a8a8a8ff;
TPalette256.DWords[249]:=$b2b2b2ff;
TPalette256.DWords[250]:=$bcbcbcff;
TPalette256.DWords[251]:=$c6c6c6ff;
TPalette256.DWords[252]:=$d0d0d0ff;
TPalette256.DWords[253]:=$dadadaff;
TPalette256.DWords[254]:=$e4e4e4ff;
TPalette256.DWords[255]:=$eeeeeeff;

end;



procedure Save256Palette;

Var
	palette256File  : File of Tpalette256;
	i,num            : integer;

Begin

    //save us a lot of code and work
    init256Palette;
	Assign(palette256File, 'palette256.dat');
	ReWrite(palette256File);

    i:=0;
    num:=0;
    
	For num := 1 to 256 do

	Begin;
	  Write(palette256File, TPalette256.colors[num]); //sdl_Color
      inc(num);
	End;

    i:=0;
	For i := 1 to 256 do
	Begin;
		Write(palette256File, TPalette256.Name[i]); //string
		inc(i);
	End;

    i:=0;
	For i := 1 to 256 do
	Begin;
		Write(palette256File, TPalette256.DWords[i]); //dword
		inc(i);
	End;

	Close(palette256File);
	
End;

procedure Read256Palette;

Var
	palette16File  : File of Tpalette256;
	i,num            : integer;

Begin
	Assign(palette256File, 'palette256.dat');
	ReSet(palette256File);
    Seek(palette256File, 0); //find first record
    
	For num := 1 to 256 do

	Begin;
	  Read(palette256File, TPalette256.colors[num]); //sdl_Color
      inc(num); 
	End;

    i:=0;
	For i := 1 to 256 do
	Begin;
		Read(palette256File, TPalette256.Name[i]); //string
		inc(i);
	End;

    i:=0;
	For i := 1 to 256 do
	Begin;
		Read(palette256File, TPalette256.DWords[i]); //dword
		inc(i);
	End;

	Close(palette256File);
	//much much easier now....
    SDL_SetPalette( screen, SDL_LOGPAL or SDL_PHYSPAL, Tpalette16.colors, 0, 16 );

end;

