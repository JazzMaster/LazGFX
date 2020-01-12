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
 
CGA modes threw us this curveball:
	4 color , 4 palette hi bit resolution modes that are half ass documented. 
	Theres no need for those modes anymore.(think t shirt half-tones for screen printing)

this is the best I can implement this data given that specs are all over the place- 
	and I want this standardized as much as pssible given that we have very high color setings available
	
VGA/SVGA (Video gate array / super video gate array) and VESA (video electronic standards association) modes are available now.

-of course SDL just simulates all of this (inside a window)

}


//we can use SetColor(SkyBlue3); in 256 modes with this- since we know which color index it is.

//this is only for the default palette of course- if you muck with it.....
// and only up to 256 colors....sorry.

// you have no idea how hard to find and hard to put into code this shit is.


//blink is a "text attribute" ..a feature...
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

//"color names" are Tied to Static Consts up to 256 Colors.
// with 256Greys, its a "moot point".
//The Palette[MaxColors].DWords holds the values, so this can be any var we want, just be consistent.

//with consts, we can specify an index color as a name and we will get the index, as it were.
//(its also easier to copy palette colors with)

	BLACK=0;
	RED=1;
	BLUE=2;
	GREEN=3;
	CYAN=4;
	MAGENTA=5;
	BROWN=6;
	LTGRAY=7;
	GRAY=8;
	LTRED=9;
	LTBLUE=10;
	LTGREEN=11;
	LTCYAN=12;
	LTMAGENTA=13;
	YELLOW=14;
	WHITE=15;

//Greyscale colors dont have names.
//original xterm must have these stored somewhere as string data because parts of "unused holes" and "duplicate data" exist

// I can guarantee you a shade of slateBlue etc.. but not the exact shade.
//(thank you very much whichever programmer fucked this up for us)

Grey0=16;
NavyBlue=17;
DarkBlue=18;
Blue3=19;
Blue4=20;
Blue1=21;
DarkGreen=22;
DeepSkyBlue4=23;
DeepSkyBlue6=24;
DeepSkyBlue7=25;
DeepSkyBlue3=26;
DodgerBlue3=27;
DodgerBlue2=28;
Green4=29;
SpringGreen4=30;
Turquoise4=31;
DeepSkyBlue5=32;
DeepSkyBlue2=33;
DodgerBlue1=34;
Green3=35;
SpringGreen3=36;
DarkCyan=37;
LightSeaGreen=38;
DeepSkyBlue1=39;
DeepSkyBlue8=40;
Green5=41;
SpringGreen5=42;
SpringGreen1=43;
Cyan3=44;
DarkTurquoise=45;
Turquoise2=46;
Green1=47;
SpringGreen2=48;
SpringGreen=49;
MediumSpringGreen=50;
Cyan2=51;
Cyan1=52;
DarkRed=53;
DeepPink4=54;
Purple4=55;
Purple5=56;
Purple3=57;
BlueViolet=58;
Orange4=59;
Grey37=60;
MediumPurple4=61;
SlateBlue3=62;
SlateBlue2=63;
RoyalBlue1=64;
UnUsedHole5=65;
DarkSeaGreen5=66;
PaleTurquoise4=67;
SteelBlue=68;
SteelBlue3=69;
CornflowerBlue=70;
UnUsedHole3=71;
DarkSeaGreen4=72;
CadetBlue=73;
CadetBlue1=74;
SkyBlue2=75;
SteelBlue1=76;
UnUsedHole4=77;
PaleGreen3=78;
SeaGreen3=79;
Aquamarine3=80;
MediumTurquoise=81;
SteelBlue2=82;
UnUsedHole1=83;
SeaGreen2=84;
SeaGreen=85;
SeaGreen1=86;
Aquamarine1=87;
DarkSlateGray2=88;
DarkRed2=89;
DeepPink5=90;
DarkMagenta=91;
DarkMagenta1=92;
DarkViolet=93;
Purple1=94;
Orange5=95;
LightPink4=96;
Plum4=97;
MediumPurple3=98;
MediumPurple5=99;
SlateBlue1=100;
Yellow4=101;
Wheat4=102;
Grey53=103;
LightSlateGrey=104;
MediumPurple=105;
LightSlateBlue=106;
Yellow5=107;
DarkOliveGreen3=108;
DarkSeaGreen=109;
LightSkyBlue1=110;
LightSkyBlue2=111;
SkyBlue3=112;
UnUsedHole2=113;
DarkOliveGreen4=114;
PaleGreen4=115;
DarkSeaGreen3=116;
DarkSlateGray3=117;
SkyBlue1=118;
UnUsedHole=119;
LightGreen=120;
LightGreen1=121;
PaleGreen1=122;
Aquamarine2=123;
DarkSlateGray1=124;
Red3=125;
DeepPink6=126;
MediumVioletRed=127;
Magenta3=128;
DarkViolet2=129;
Purple2=130;
DarkOrange1=131;
IndianRed=132;
HotPink3=133;
MediumOrchid3=134;
MediumOrchid=135;
MediumPurple2=136;
DarkGoldenrod=137;
LightSalmon3=138;
RosyBrown=139;
Grey63=140;
MediumPurple6=141;
MediumPurple1=142;
Gold3=143;
DarkKhaki=144;
NavajoWhite3=145;
Grey69=146;
LightSteelBlue3=147;
LightSteelBlue=148;
Yellow3=149;
DarkOliveGreen5=150;
DarkSeaGreen6=151;
DarkSeaGreen2=152;
LightCyan3=153;
LightSkyBlue3=154;
GreenYellow=155;
DarkOliveGreen2=156;
PaleGreen2=157;
DarkSeaGreen7=158;
DarkSeaGreen1=159;
PaleTurquoise1=160;
Red4=161;
DeepPink3=162;
DeepPink7=163;
Magenta5=164;
Magenta6=165;
Magenta2=166;
DarkOrange2=167;
IndianRed1=168;
HotPink4=169;
HotPink2=170;
Orchid=171;
MediumOrchid1=172;
Orange1=173;
LightSalmon2=174;
LightPink1=175;
Pink1=176;
Plum2=177;
Violet=178;
Gold2=179;
LightGoldenrod4=180;
Tan=181;
MistyRose3=182;
Thistle3=183;
Plum3=184;
Yellow7=185;
Khaki3=186;
LightGoldenrod2=187;
LightYellow3=188;
Grey84=189;
LightSteelBlue1=190;
Yellow2=191;
DarkOliveGreen=192;
DarkOliveGreen1=193;
DarkSeaGreen8=194;
Honeydew2=195;
LightCyan1=196;
Red1=197;
DeepPink2=198;
DeepPink=199;
DeepPink1=200;
Magenta4=201;
Magenta1=202;
OrangeRed=203;
IndianRed2=204;
IndianRed3=205;
HotPink=206;
HotPink1=207;
MediumOrchid2=208;
DarkOrange=209;
Salmon1=210;
LightCoral=211;
PaleVioletRed=212;
Orchid2=213;
Orchid1=214;
Orange=215;
SandyBrown=216;
LightSalmon=217;
LightPink=218;
Pink=219;
Plum=220;
Gold=221;
LightGoldenrod5=222;
LightGoldenrod3=223;
NavajoWhite1=224;
MistyRose1=225;
Thistle1=226;
Yellow1=227;
LightGoldenrod1=228;
Khaki1=229;
Wheat1=230;
Cornsilk=231;
Grey100=232;
Grey3=233;
Grey7=234;
Grey11=235;
Grey15=236;
Grey19=237;
Grey23=238;
Grey27=239;
Grey30=240;
Grey35=241;
Grey39=242;
Grey42=243;
Grey46=244;
Grey50=245;
Grey54=246;
Grey58=247;
Grey62=248;
Grey66=249;
Grey70=250;
Grey74=251;
Grey78=252;
Grey82=253;
Grey85=254;
Grey93=255;

type


TRec16=record
  
	colors:PSDL_COLOR; 

{SDL defines this is as:

SDL_Color=record
	r,g,b,a:byte;
	...some other stuff we dont need to use.
end;

}

	DWords:DWord;

end;


//this is the XTerm 256 definition...

//palette tricks would then need to use : colors[1].a hacks.

//just so you can see the amount of datas were dealing with here.
//really shouldnt go there..and waay too many palettes out there.
//this really should be read in from a file.

//anyways- as "standard" as I can get.Most UNICES use this.


TRec256=record

  colors:PSDL_COLOR; //this is setup later on. 
  DWords:DWord;

end;

var
   palette:PSDL_Palette;

//this one is unorthodox due to the totally destructive downsizing and image degredation needed
//and its "best guess"
  GreyList16:array [0..48] of byte;

  valuelist16: array [0..48] of byte;
  valuelist256: array [0..767] of byte;

  TPalette16: array [0..15] of TRec16;
  TPalette16Grey:array [0..15] of TRec16;

  TPalette256:array [0..255] of TRec256; 
  TPalette256Grey:array [0..255] of TRec256;
