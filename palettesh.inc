
{

256 and below "color" paletted modes-
this gets harder as we go along but this is the "last indexed mode". 

colors (indexes) above 255 should throw an error if using palettes.

(technically they are rgb(a) colors and have no index anymore)
(so we are in true colors and straight rgb/rgba after this.....)

You need (full) DWords or RGB data for TRUE color modes.
 
'A' bit affects transparency and completes the 'DWord'.
The default setting is to ignore it(FF) in 256 color modes.
(m)CGA is a touch whacky.

Most bitmap or blitter or renderer or opengl based code uses some sort of shader(or composite image).
This isnt covered here.

This is for drawing "primitives" on the "surface".....
"advanced primitives" require alpha bit hacking or TRUE COLOR MODE.

-One step at a time.

each 256 SDL_color= r,g,b,a whereas in range of 0-255(FF FF) per color.
for 16 color modes we use 0-7(0F) and an alpha mask to simulate RGBI mode
 
16 color mode is technically a wonky spec(RGB+CMY+WB):
	officially this is composed of:  RGB plus I(light/dark) modes.

CMYK isnt really a video color standard normally because pixels are RGB. 
CMYK is for printing. 
	The reason has to do with color gamut and other huffy-puff.

(Learn photography if you want the color headache)
 
CGA modes threw us this curveball:
	4 color , 4 palette hi bit resolution modes that are half ass documented. 
	Theres no need for those modes anymore.(think t shirt half-tones for screen printing)

this is the best I can implement this data given that specs are all over the place- 
	and I want this standardized as much as pssible given that we have very high color setings available
	
VGA/SVGA (Video gate array / super video gate array) and 
VESA (video electronic standards association) modes are available now.

-of course SDL just simulates all of this (inside a window)


we can use SetColor(SkyBlue3); in 256 modes with this- since we know which color index it is.

this is only for the default palette of course- if you muck with it.....
 and only up to 256 colors....sorry.

}

//blink is a "text attribute" ..a feature...not a color
//write..wait.erase..wait..rewrite..just like the blinking cursor..

{

colors: 

	MUST be hard defined to set the pallete prior to drawing.
	No 16 color bitshifting hacks allowed. They dont work anymore.
	    However: you can-
	         adjust the colors by some math
	         render something
	         and restore the colors before rendering again
			 then render something else
}

type


//There IS a way to ge the Names listed here- the magic type info library
//this cuts down on spurious string data and standardizes the palette names a bit also


//iirc - its ...RED,BLUE,GREEN... on the ol 8088s...
// K-R-B-G-C-M-Br Gy-Gyd R-B-G-C-M-Y-W (CGA)
// vs K-B-G-C-R-M-Br Gy-Gyd- B-G-C-R-M-Y-W (wikipedia) 
//the xterm 256 spec reflects this- oddly.


//these names CANNOT overlap. If you want to change them, be my guest.

//you cant fuck up the first 16- Borland INC (RIP) made that "the standard"
TPalette16Names=(BLACK,RED,BLUE,GREEN,CYAN,MAGENTA,BROWN,LTGRAY,GRAY,LTRED,LTBLUE,LTGREEN,LTCYAN,LTMAGENTA,YELLOW,WHITE);
TPalette16NamesGrey=(gBLACK,g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14,gWHITE);

//tfs=two fifty six
//original xterm must have these stored somewhere as string data because parts of "unused holes" and "duplicate data" exist

// I can guarantee you a shade of slateBlue etc.. but not the exact shade.
//(thank you very much whichever programmer fucked this up for us)


TPalette256Names=(

tfsBLACK,
maroon,
tfsGREEN,
olive,
navy,
purple,
teal,
silver,
grey,
tfsRED,
lime,
tfsYELLOW,
tfsBLUE,
fuchsia,
aqua,
tfsWHITE,

Grey0,
NavyBlue,
DarkBlue,
Blue3,
Blue4,
Blue1,

DarkGreen,
DeepSkyBlue4,
DeepSkyBlue6,
DeepSkyBlue7,
DeepSkyBlue3,

DodgerBlue3,
DodgerBlue2,

Green4,
SpringGreen4,


Turquoise4,
DeepSkyBlue5,
DeepSkyBlue2,
DodgerBlue1,
Green3,

SpringGreen3,
DarkCyan,
LightSeaGreen,

DeepSkyBlue1,
DeepSkyBlue8,
Green5,

SpringGreen5,
SpringGreen1,
Cyan3,

DarkTurquoise,
Turquoise2,

Green1,

SpringGreen2,
SpringGreen,
MediumSpringGreen,
Cyan2,
Cyan1,

DarkRed,
DeepPink4,
Purple4,
Purple5,
Purple3,

BlueViolet,
Orange4,
Grey37,
MediumPurple4,
SlateBlue3,
SlateBlue2,
RoyalBlue1,

UnUsedHole5,
DarkSeaGreen5,

PaleTurquoise4,
SteelBlue,
SteelBlue3,

CornflowerBlue,
UnUsedHole3,

DarkSeaGreen4,
CadetBlue,
CadetBlue1,

SkyBlue2,
SteelBlue1,

UnUsedHole4,
PaleGreen3,
SeaGreen3,

Aquamarine3,
MediumTurquoise,

SteelBlue2,
UnUsedHole1,

SeaGreen2,
SeaGreen,
SeaGreen1,

Aquamarine1,
DarkSlateGray2,
DarkRed2,
DeepPink5,

DarkMagenta,
DarkMagenta1,

DarkViolet,
Purple1,
Orange5,
LightPink4,
Plum4,
MediumPurple3,
MediumPurple5,
SlateBlue1,
Yellow4,


Wheat4,
Grey53,
LightSlateGrey,
MediumPurple,
LightSlateBlue,
Yellow5,

DarkOliveGreen3,
DarkSeaGreen,
LightSkyBlue1,
LightSkyBlue2,
SkyBlue3,

UnUsedHole2,

DarkOliveGreen4,
PaleGreen4,
DarkSeaGreen3,
DarkSlateGray3,

SkyBlue1,
UnUsedHole,

LightGreen,
LightGreen1,

PaleGreen1,
Aquamarine2,
DarkSlateGray1,

Red3,
DeepPink6,
MediumVioletRed,
Magenta3,
DarkViolet2, 
Purple2,
DarkOrange1,
IndianRed,

HotPink3,
MediumOrchid3,
MediumOrchid,
MediumPurple2,
DarkGoldenrod,

LightSalmon3,
RosyBrown,
Grey63,
MediumPurple6,
MediumPurple1,
Gold3,
DarkKhaki,
NavajoWhite3,
Grey69,
LightSteelBlue3,
LightSteelBlue,

Yellow3,
DarkOliveGreen5,
DarkSeaGreen6,
DarkSeaGreen2,

LightCyan3,
LightSkyBlue3,
GreenYellow,

DarkOliveGreen2,
PaleGreen2,
DarkSeaGreen7,
DarkSeaGreen1,

PaleTurquoise1,
Red4,
DeepPink3,
DeepPink7,
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
MistyRose3,
Thistle3,

Plum3,
Yellow7,
Khaki3,
LightGoldenrod2,
LightYellow3,
Grey84,
LightSteelBlue1,
Yellow2,

DarkOliveGreen,
DarkOliveGreen1,
DarkSeaGreen8,
Honeydew2,
LightCyan1,
Red1,
DeepPink2,
DeepPink,
DeepPink1,
Magenta4,
Magenta1,
OrangeRed,
IndianRed2,
IndianRed3,
HotPink,
HotPink1,
MediumOrchid2,
DarkOrange,
Salmon1,

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
LightGoldenrod5,
LightGoldenrod3,
NavajoWhite1,
MistyRose1,
Thistle1,
Yellow1,
LightGoldenrod1,
Khaki1,
Wheat1,
Cornsilk,

Grey100,
Grey3,
Grey7,
Grey11,
Grey15,
Grey19,
Grey23,
Grey27,
Grey30,
Grey35,

Grey39,
Grey42,
Grey46,
Grey50,
Grey54,
Grey58,
Grey62,
Grey66,
Grey70,
Grey74,

Grey78,
Grey82,
Grey85,
Grey89,
Grey93);


//this one is HELL!
TPalette256NamesGrey=(

tfsGBlack,
tfsG1,
tfsG2,
tfsG3,
tfsG4,
tfsG5,
tfsG6,
tfsG7,
tfsG8,
tfsG9,
tfsG10,

tfsG11,
tfsG12,
tfsG13,
tfsG14,
tfsG15,

tfsG16,
tfsG17,
tfsG18,
tfsG19,
tfsG20,

tfsG21,
tfsG22,
tfsG23,
tfsG24,
tfsG25,
tfsG26,
tfsG27,
tfsG28,
tfsG29,
tfsG30,

tfsG31,
tfsG32,
tfsG33,
tfsG34,
tfsG35,
tfsG36,
tfsG37,
tfsG38,
tfsG39,
tfsG40,

tfsG41,
tfsG42,
tfsG43,
tfsG44,
tfsG45,
tfsG46,
tfsG47,
tfsG48,
tfsG49,
tfsG50,

tfsG51,
tfsG52,
tfsG53,
tfsG54,
tfsG55,

tfsG56,
tfsG57,
tfsG58,
tfsG59,
tfsG60,
tfsG61,
tfsG62,
tfsG63,
tfsG64,
tfsG65,

tfsG66,
tfsG67,
tfsG68,
tfsG69,
tfsG70,
tfsG71,
tfsG72,
tfsG73,
tfsG74,
tfsG75, 

tfsG76,
tfsG77,
tfsG78, 

tfsG79,
tfsG80,
tfsG81,
tfsG82,
tfsG83,
tfsG84,
tfsG85,
tfsG86,
tfsG87,
tfsG88, 

tfsG89,
tfsG90,
tfsG91,
tfsG92,
tfsG93,
tfsG94,
tfsG95,
tfsG96,
tfsG97,
tfsG98, 

tfsG99,
tfsG100,
tfsG101,
tfsG102,
tfsG103,
tfsG104,
tfsG105,
tfsG106,
tfsG107,
tfsG108, 

tfsG109,
tfsG110,
tfsG111,
tfsG112,
tfsG113,
tfsG114,
tfsG115,
tfsG116,
tfsG117,
tfsG118, 

tfsG119,
tfsG120,
tfsG121,
tfsG122,
tfsG123,
tfsG124,
tfsG125,
tfsG126,
tfsG127,
tfsG128, 

tfsG129,
tfsG130,
tfsG131,
tfsG132,
tfsG133,
tfsG134,
tfsG135,
tfsG136,
tfsG137,
tfsG138, 

tfsG139,
tfsG140,
tfsG141,
tfsG142,
tfsG143,
tfsG144,
tfsG145,
tfsG146,
tfsG147,
tfsG148, 

tfsG149,
tfsG150,
tfsG151,
tfsG152,
tfsG153,
tfsG154,
tfsG155, 
tfsG156,
tfsG157,
tfsG158, 

tfsG159,
tfsG160,
tfsG161,
tfsG162,
tfsG163,
tfsG164,
tfsG165,
tfsG166,
tfsG167,
tfsG168, 

tfsG169,
tfsG170,
tfsG171,
tfsG172,
tfsG173,
tfsG174,
tfsG175,
tfsG176,
tfsG177,
tfsG178, 

tfsG179,
tfsG180,
tfsG181,
tfsG182,
tfsG183,
tfsG184,
tfsG185,
tfsG186,
tfsG187,
tfsG188, 

tfsG189,
tfsG190,
tfsG191,
tfsG192,
tfsG193,
tfsG194,
tfsG195,
tfsG196,
tfsG197,
tfsG198, 

tfsG199,
tfsG200,
tfsG201,
tfsG202,
tfsG203,
tfsG204,
tfsG205,
tfsG206,
tfsG207,
tfsG208,

tfsG209,
tfsG210,
tfsG211,
tfsG212,
tfsG213,
tfsG214,
tfsG215,
tfsG216,
tfsG217,
tfsG218,

tfsG219,
tfsG220,
tfsG221,
tfsG222,
tfsG223,
tfsG224,
tfsG225,
tfsG226,
tfsG227,
tfsG228,
tfsG229,

tfsG230,
tfsG231,
tfsG232,
tfsG233,
tfsG234,
tfsG235,
tfsG236,
tfsG237,
tfsG238,
tfsG239,
tfsG240,

tfsG241,
tfsG242,
tfsG243,
tfsG244,
tfsG245,
tfsG246,
tfsG247,
tfsG248,
tfsG249,
tfsG250,

tfsG251,
tfsG252,
tfsG253,
tfsG254,
tfsGWhite

);

TRec16=record
  
	colors:TSDL_COLORS; 

{SDL defines this is as:

SDL_Color=record
	r,g,b,a:byte;
	...some other stuff we dont need to use.
end;

}

	DWords:array [0..15] of DWord;

end;


//this is the XTerm 256 definition...

//palette tricks would then need to use : colors[1].a hacks.

//just so you can see the amount of datas were dealing with here.
//really shouldnt go there..and waay too many palettes out there.
//this really should be read in from a file.

//anyways- as "standard" as I can get.Most UNICES use this.


TRec256=record

  colors:TSDL_COLORS; //this is setup later on. 
  DWords:array [0..255] of DWord;

end;


var
//this one is unorthodox due to the totally destructive downsizing and image degredation needed
//and its "best guess"
  GreyList16:array [0..48] of byte;

  valuelist16: array [0..48] of byte;
  valuelist256: array [0..767] of byte;

  TPalette16:TRec16;
  TPalette16Grey:TRec16;

  TPalette256:TRec256;
  TPalette256Grey:TRec256;


