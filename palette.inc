
{

256 and paletted modes-
this gets harder as we go along but this is the "last indexed mode". 

colors (indexes) above 255 should throw an error(undefined --and out of bounds). 

(technically they are rgb(a) colors and have no index anymore)
(so we are in true colors and straight rgb after this.....)

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

}


const 

//we can use SetColor(SkyBlue3); in 256 modes with this- since we know which color index it is.
//this is only for the default palette of course- if you muck with it.....
// and only up to 256 colors....sorry.

BLACK=0;
BLUE=1;
GREEN=2;
CYAN=3;
RED=4;
MAGENTA=5;
BROWN=6;
LTGRAY=7;
GRAY=8;
LTBLUE=9;
LTGREEN=10;
LTCYAN=11;
LTRED=12;
LTMAGENTA=13;
YELLOW=14;
WHITE=15;

//note there are multiple shades and a few "holes".
Grey1=16;
NavyBlue=17;
DarkBlue=18;
Blue2=19;
Blue3=20;
Blue1=21;
DarkGreen=22;
DeepSkyBlue5=23;
DeepSkyBlue6=24;
DeepSkyBlue7=25;
DodgerBlue2=26;
DodgerBlue1=27;
Green4=28;
SpringGreen5=29;
Turquoise1=30;
DeepSkyBlue2=31;
DeepSkyBlue3=32;
DodgerBlue=33;
Green2=34;
SpringGreen3=35;
DarkCyan=36;
LightSeaGreen=37;
DeepSkyBlue1=38;
DeepSkyBlue=39;
Green3=40;
SpringGreen4=41;
SpringGreen1=42;
Cyan3=43;
DarkTurquoise=44;
Turquoise=45;
Green1=46;
SpringGreen2=47;
SpringGreen=48;
MediumSpringGreen=49;
Cyan2=50;

Cyan1=51;
DarkRed=52;
DeepPink5=53;
Purple4=54;
Purple5=55;
Purple3=56;
BlueViolet=57;
Orange2=58;
Grey2=59;
MediumPurple6=60;
SlateBlue1=61;
SlateBlue2=62;
RoyalBlue1=63;
UnUsedHole5=64;
DarkSeaGreen7=65;
PaleTurquoise1=66;
SteelBlue=67;
SteelBlue3=68;
CornflowerBlue=69;
UnUsedHole3=70;
DarkSeaGreen8=71;
CadetBlue=72;
CadetBlue1=73;
SkyBlue2=74;
SteelBlue1=75;
UnUsedHole4=76;
PaleGreen2=77;
SeaGreen3=78;
Aquamarine2=79;
MediumTurquoise=80;
SteelBlue2=81;
UnUsedHole1=82;
SeaGreen2=83;
SeaGreen=84;
SeaGreen1=85;
Aquamarine=86;
DarkSlateGray1=87;
DarkRed1=88;
DeepPink6=89;
DarkMagenta=90;
DarkMagenta1=91;
DarkViolet=92;
Purple1=93;
Orange3=94;
LightPink2=95;
Plum3=96;
MediumPurple4=97;
MediumPurple5=98;
SlateBlue=99;
Yellow5=100;

Wheat1=101;
Grey3=102;
LightSlateGrey=103;
MediumPurple=104;
LightSlateBlue=105;
Yellow6=106;
DarkOliveGreen3=107;
DarkSeaGreen=108;
LightSkyBlue1=109;
LightSkyBlue2=110;
SkyBlue1=111;
UnUsedHole2=112;
DarkOliveGreen4=113;
PaleGreen3=114;
DarkSeaGreen5=115;
DarkSlateGray2=116;
SkyBlue=117;
UnUsedHole=118;
LightGreen=119;
LightGreen1=120;
PaleGreen=121;
Aquamarine1=122;
DarkSlateGray=123;
Red2=124;
DeepPink7=125;
MediumVioletRed=126;
Magenta4=127;
DarkViolet1=128; 
Purple2=129;
DarkOrange1=130;
IndianRed=131;
HotPink3=132;
MediumOrchid3=133;
MediumOrchid=134;
MediumPurple2=135;
DarkGoldenrod=136;
LightSalmon1=137;
RosyBrown=138;
Grey4=139;
MediumPurple3=140;
MediumPurple1=141;
Gold1=142;
DarkKhaki=143;
NavajoWhite1=144;
Grey5=145;
LightSteelBlue2=146;
LightSteelBlue=147;
Yellow3=148;
DarkOliveGreen5=149;
DarkSeaGreen6=150;

DarkSeaGreen3=151;
LightCyan2=152;
LightSkyBlue=153;
GreenYellow=154;
DarkOliveGreen2=155;
PaleGreen1=156;
DarkSeaGreen4=157;
DarkSeaGreen1=158;
PaleTurquoise=159;
Red3=160;
DeepPink3=161;
DeepPink4=162;
Magenta5=163;
Magenta6=164;
Magenta2=165;
DarkOrange2=166;
IndianRed1=167;
HotPink4=168;
HotPink2=169;
Orchid=170;
MediumOrchid1=171;
Orange1=172;
LightSalmon2=173;
LightPink1=174;
Pink1=175;

Plum2=176;
Violet=177;
Gold2=178;
LightGoldenrod4=179;
Tan=180;
MistyRose1=181;
Thistle1=182;
Plum1=183;
Yellow4=184;
Khaki1=185;
LightGoldenrod1=186;
LightYellow=187;
Grey6=188;
LightSteelBlue1=189;
Yellow2=190;
DarkOliveGreen=191;
DarkOliveGreen1=192;
DarkSeaGreen2=193;
Honeydew=194;
LightCyan1=195;
Red1=196;
DeepPink2=197;
DeepPink=198;
DeepPink1=199;
Magenta3=200;

Magenta1=201;
OrangeRed=202;
IndianRed2=203;
IndianRed3=204;
HotPink=205;
HotPink1=206;
MediumOrchid2=207;
DarkOrange=208;
Salmon=209;
LightCoral=210;
PaleVioletRed=211;
Orchid2=212;
Orchid1=213;
Orange=214;
SandyBrown=215;
LightSalmon=216;
LightPink=217;
Pink=218;
Plum=219;
Gold=220;
LightGoldenrod2=221;
LightGoldenrod3=222;
NavajoWhite=223;
MistyRose=224;
Thistle=225;
Yellow1=226;
LightGoldenrod=227;
Khaki=228;
Wheat=229;
Cornsilk=230;

//yes "the GREYS"..important for shading flat images...

Grey7=231;
Grey8=232;
Grey9=233;
Grey10=234;
Grey11=235;
Grey12=236;
Grey13=237;
Grey14=238;
Grey15=239;
Grey16=240;

Grey17=241;
Grey18=242;
Grey19=243;
Grey20=244;
Grey21=245;
Grey22=246;
Grey23=247;
Grey24=248;
Grey25=249;
Grey26=250;

Grey27=251;
Grey28=252;
Grey29=253;
Grey30=254;
Grey31=255;

//blink is a "text attribute" ..a feature...
//write..wait.erase..wait..rewrite..just like the blinking cursor..
//128 is hex 0F- bit hackery with the color palette.
//(which may have worked at the time)

// Color:=color+Blink; -is the old way.
// Blink('string'); -is the new way.

{

colors: 

	MUST be hard defined to set the pallete prior to drawing.
	No 16 color hacks allowed. They dont work anymore.

}
type

TRec16=record
  
	colors=array [0..15] of PSDL_COLOR; //this is setup later on. 

{SDL defines this is as:

SDL_Color=record
	r,g,b,a:byte;
	...some other stuff we dont need to use.
end;

}

	DWords=array [0..15] of DWord;
	Name=array [0..15] of string;

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
  Name=array [0..255] of string;

end;


var

  valuelist16: array [0..48] of Word;
  valuelist256: array [0..765] of Word;
  TPalette16:TRec16;
  TPalette256:TRec256;

//Do we want GreyScale 256??
//if so, we can speed assign it by using steps

//  GreyList256:array [0..765] of word;


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


TPalette256.Name[0]:='black';
TPalette256.Name[1]:='blue';
TPalette256.Name[2]:='green';
TPalette256.Name[3]:='cyan';
TPalette256.Name[4]:='red';
TPalette256.Name[5]:='magenta';
TPalette256.Name[6]:='brown';
TPalette256.Name[7]:='light grey';
TPalette256.Name[8]:='grey';
TPalette256.Name[9]:='light blue';
TPalette256.Name[10]:='light green';
TPalette256.Name[11]:='light cyan';
TPalette256.Name[12]:='lightred';
TPalette256.Name[13]:='light magenta';
TPalette256.Name[14]:='yellow';
TPalette256.Name[15]:='white';


TPalette256.Name[16]:='Hole';
TPalette256.Name[17]:='NavyBlue';
TPalette256.Name[18]:='DarkBlue';
TPalette256.Name[19]:='Blue2';
TPalette256.Name[20]:='Blue3';
TPalette256.Name[21]:='Blue1';
TPalette256.Name[22]:='DarkGreen';
TPalette256.Name[23]:='DeepSkyBlue5';
TPalette256.Name[24]:='DeepSkyBlue6';
TPalette256.Name[25]:='DeepSkyBlue7';
TPalette256.Name[26]:='DodgerBlue2';
TPalette256.Name[27]:='DodgerBlue1';
TPalette256.Name[28]:='Green4';
TPalette256.Name[29]:='SpringGreen5';
TPalette256.Name[30]:='Turquoise1';

TPalette256.Name[31]:='DeepSkyBlue2';
TPalette256.Name[32]:='DeepSkyBlue3';
TPalette256.Name[33]:='DodgerBlue';
TPalette256.Name[34]:='Green2';
TPalette256.Name[35]:='SpringGreen3';
TPalette256.Name[36]:='DarkCyan';
TPalette256.Name[37]:='LightSeaGreen';
TPalette256.Name[38]:='DeepSkyBlue1';
TPalette256.Name[39]:='DeepSkyBlue';
TPalette256.Name[40]:='Green3';
TPalette256.Name[41]:='SpringGreen4';
TPalette256.Name[42]:='SpringGreen1';
TPalette256.Name[43]:='Cyan3';
TPalette256.Name[44]:='DarkTurquoise';
TPalette256.Name[45]:='Turquoise';

TPalette256.Name[46]:='Green1';
TPalette256.Name[47]:='SpringGreen2';
TPalette256.Name[48]:='SpringGreen';
TPalette256.Name[49]:='MediumSpringGreen';
TPalette256.Name[50]:='Cyan2';
TPalette256.Name[51]:='Cyan1';
TPalette256.Name[52]:='DarkRed';
TPalette256.Name[53]:='DeepPink5';
TPalette256.Name[54]:='Purple4';
TPalette256.Name[55]:='Purple5';
TPalette256.Name[56]:='Purple3';
TPalette256.Name[57]:='BlueViolet';
TPalette256.Name[58]:='Orange2';
TPalette256.Name[59]:='Grey2';
TPalette256.Name[60]:='MediumPurple6';

TPalette256.Name[61]:='SlateBlue1';
TPalette256.Name[62]:='SlateBlue2';
TPalette256.Name[63]:='RoyalBlue1';
TPalette256.Name[64]:= 'UnUsedHole5';   // DWord #000000ff
TPalette256.Name[65]:='DarkSeaGreen7';
TPalette256.Name[66]:='PaleTurquoise1';
TPalette256.Name[67]:='SteelBlue';
TPalette256.Name[68]:='SteelBlue3';
TPalette256.Name[69]:='CornflowerBlue';
TPalette256.Name[70]:='UnUsedHole3'; // DWord #000000ff
TPalette256.Name[71]:='DarkSeaGreen8';
TPalette256.Name[72]:='CadetBlue';
TPalette256.Name[73]:='CadetBlue1';
TPalette256.Name[74]:='SkyBlue2';
TPalette256.Name[75]:='SteelBlue1';

TPalette256.Name[76]:='UnUsedHole4';  // DWord #000000ff
TPalette256.Name[77]:='PaleGreen2';
TPalette256.Name[78]:='SeaGreen3';
TPalette256.Name[79]:='Aquamarine2';
TPalette256.Name[80]:='MediumTurquoise';
TPalette256.Name[81]:='SteelBlue2';
TPalette256.Name[82]:='UnUsedHole1'; // DWord #000000ff
TPalette256.Name[83]:='SeaGreen2';
TPalette256.Name[84]:='SeaGreen';
TPalette256.Name[85]:='SeaGreen1';
TPalette256.Name[86]:='Aquamarine';
TPalette256.Name[87]:='DarkSlateGray1';
TPalette256.Name[88]:='DarkRed1';
TPalette256.Name[89]:='DeepPink6';
TPalette256.Name[90]:='DarkMagenta';

TPalette256.Name[91]:='DarkMagenta1';
TPalette256.Name[92]:='DarkViolet';
TPalette256.Name[93]:='Purple1';
TPalette256.Name[94]:='Orange3';
TPalette256.Name[95]:='LightPink2';
TPalette256.Name[96]:='Plum3';
TPalette256.Name[97]:='MediumPurple4';
TPalette256.Name[98]:='MediumPurple5';
TPalette256.Name[99]:='SlateBlue';
TPalette256.Name[100]:='Yellow5';
TPalette256.Name[101]:='Wheat1';
TPalette256.Name[102]:='Grey3';
TPalette256.Name[103]:='LightSlateGrey';
TPalette256.Name[104]:='MediumPurple';
TPalette256.Name[105]:='LightSlateBlue';

TPalette256.Name[106]:='Yellow6';
TPalette256.Name[107]:='DarkOliveGreen3';
TPalette256.Name[108]:='DarkSeaGreen';
TPalette256.Name[109]:='LightSkyBlue1';
TPalette256.Name[110]:='LightSkyBlue2';
TPalette256.Name[111]:='SkyBlue1';
TPalette256.Name[112]:='UnUsedHole2'; // DWord #000000ff
TPalette256.Name[113]:='DarkOliveGreen4';
TPalette256.Name[114]:='PaleGreen3';
TPalette256.Name[115]:='DarkSeaGreen5';
TPalette256.Name[116]:='DarkSlateGray2';
TPalette256.Name[117]:='SkyBlue';
TPalette256.Name[118]:='UnUsedHole';  // DWord #000000ff
TPalette256.Name[119]:='LightGreen';
TPalette256.Name[120]:='LightGreen1';

TPalette256.Name[121]:='PaleGreen';
TPalette256.Name[122]:='Aquamarine1';
TPalette256.Name[123]:='DarkSlateGray';
TPalette256.Name[124]:='Red2';
TPalette256.Name[125]:='DeepPink7';
TPalette256.Name[126]:='MediumVioletRed';
TPalette256.Name[127]:='Magenta4';
TPalette256.Name[128]:='DarkViolet1';
TPalette256.Name[129]:='Purple2';
TPalette256.Name[130]:='DarkOrange1';
TPalette256.Name[131]:='IndianRed';
TPalette256.Name[132]:='HotPink3';
TPalette256.Name[133]:='MediumOrchid3';
TPalette256.Name[134]:='MediumOrchid';
TPalette256.Name[135]:='MediumPurple2';

TPalette256.Name[136]:='DarkGoldenrod';
TPalette256.Name[137]:='LightSalmon1';
TPalette256.Name[138]:='RosyBrown';
TPalette256.Name[139]:='Grey4';
TPalette256.Name[140]:='MediumPurple3';
TPalette256.Name[141]:='MediumPurple1';
TPalette256.Name[142]:='Gold1';
TPalette256.Name[143]:='DarkKhaki';
TPalette256.Name[144]:='NavajoWhite1';
TPalette256.Name[145]:='Grey5';
TPalette256.Name[146]:='LightSteelBlue2';
TPalette256.Name[147]:='LightSteelBlue';
TPalette256.Name[148]:='Yellow3';
TPalette256.Name[149]:='DarkOliveGreen5';
TPalette256.Name[150]:='DarkSeaGreen6';

TPalette256.Name[151]:='DarkSeaGreen3';
TPalette256.Name[152]:='LightCyan2';
TPalette256.Name[153]:='LightSkyBlue';
TPalette256.Name[154]:='GreenYellow';
TPalette256.Name[155]:='DarkOliveGreen2';

TPalette256.Name[156]:='PaleGreen1';
TPalette256.Name[157]:='DarkSeaGreen4';
TPalette256.Name[158]:='DarkSeaGreen1';
TPalette256.Name[159]:='PaleTurquoise';
TPalette256.Name[160]:='Red3';
TPalette256.Name[161]:='DeepPink3';
TPalette256.Name[162]:='DeepPink4';
TPalette256.Name[163]:='Magenta5';
TPalette256.Name[164]:='Magenta6';
TPalette256.Name[165]:='Magenta2';

TPalette256.Name[166]:='DarkOrange2';
TPalette256.Name[167]:='IndianRed1';
TPalette256.Name[168]:='HotPink4';
TPalette256.Name[169]:='HotPink2';
TPalette256.Name[170]:='Orchid';
TPalette256.Name[171]:='MediumOrchid1';
TPalette256.Name[172]:='Orange1';
TPalette256.Name[173]:='LightSalmon2';
TPalette256.Name[174]:='LightPink1';
TPalette256.Name[175]:='Pink1';
TPalette256.Name[176]:='Plum2';
TPalette256.Name[177]:='Violet';
TPalette256.Name[178]:='Gold2';
TPalette256.Name[179]:='LightGoldenrod4';
TPalette256.Name[180]:='Tan';

TPalette256.Name[181]:='MistyRose1';
TPalette256.Name[182]:='Thistle1';
TPalette256.Name[183]:='Plum1';
TPalette256.Name[184]:='Yellow4';
TPalette256.Name[185]:='Khaki1';
TPalette256.Name[186]:='LightGoldenrod1';
TPalette256.Name[187]:='LightYellow';
TPalette256.Name[188]:='Grey6';
TPalette256.Name[189]:='LightSteelBlue1';
TPalette256.Name[190]:='Yellow2';
TPalette256.Name[191]:='DarkOliveGreen';
TPalette256.Name[192]:='DarkOliveGreen1';
TPalette256.Name[193]:='DarkSeaGreen2';
TPalette256.Name[194]:='Honeydew';
TPalette256.Name[195]:='LightCyan1';

TPalette256.Name[196]:='Red1';
TPalette256.Name[197]:='DeepPink2';
TPalette256.Name[198]:='DeepPink';
TPalette256.Name[199]:='DeepPink1';
TPalette256.Name[200]:='Magenta3';


TPalette256.Name[201]:='Magenta1';
TPalette256.Name[202]:='OrangeRed';
TPalette256.Name[203]:='IndianRed2';
TPalette256.Name[204]:='IndianRed3';
TPalette256.Name[205]:='HotPink';
TPalette256.Name[206]:='HotPink1';
TPalette256.Name[207]:='MediumOrchid2';
TPalette256.Name[208]:='DarkOrange';
TPalette256.Name[209]:='Salmon';
TPalette256.Name[210]:='LightCoral';

TPalette256.Name[211]:='PaleVioletRed';
TPalette256.Name[212]:='Orchid2';
TPalette256.Name[213]:='Orchid1';
TPalette256.Name[214]:='Orange';
TPalette256.Name[215]:='SandyBrown';
TPalette256.Name[216]:='LightSalmon';
TPalette256.Name[217]:='LightPink';
TPalette256.Name[218]:='Pink';
TPalette256.Name[219]:='Plum';
TPalette256.Name[220]:='Gold';
TPalette256.Name[221]:='LightGoldenrod2';
TPalette256.Name[222]:='LightGoldenrod3';
TPalette256.Name[223]:='NavajoWhite';
TPalette256.Name[224]:='MistyRose';
TPalette256.Name[225]:='Thistle';

TPalette256.Name[226]:='Yellow1';
TPalette256.Name[227]:='LightGoldenrod';
TPalette256.Name[228]:='Khaki';
TPalette256.Name[229]:='Wheat';
TPalette256.Name[230]:='Cornsilk';

TPalette256.Name[231]:='Grey7';
TPalette256.Name[232]:='Grey8';
TPalette256.Name[233]:='Grey9';
TPalette256.Name[234]:='Grey10';
TPalette256.Name[235]:='Grey11';
TPalette256.Name[236]:='Grey12';
TPalette256.Name[237]:='Grey13';
TPalette256.Name[238]:='Grey14';
TPalette256.Name[239]:='Grey15';
TPalette256.Name[240]:='Grey16';

TPalette256.Name[241]:='Grey17';
TPalette256.Name[242]:='Grey18';
TPalette256.Name[243]:='Grey19';
TPalette256.Name[244]:='Grey20';
TPalette256.Name[245]:='Grey21';
TPalette256.Name[246]:='Grey22';
TPalette256.Name[247]:='Grey23';
TPalette256.Name[248]:='Grey24';
TPalette256.Name[249]:='Grey25';
TPalette256.Name[250]:='Grey26';
TPalette256.Name[251]:='Grey27';
TPalette256.Name[252]:='Grey28';
TPalette256.Name[253]:='Grey29';
TPalette256.Name[254]:='Grey30';
TPalette256.Name[255]:='Grey31';



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

