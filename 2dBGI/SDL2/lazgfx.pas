Unit LazGFX; 
{$mode objfpc}

//Range and overflow checks =ON
{$Q+}
{$R+}

{$IFDEF debug}
//memory tracing, along with heap.
	{$S+}
{$ENDIF}


{
A "fully creative rewrite" of the "Borland Graphic Interface" in SDL2 (c) 2014-2019 Guido Gonzato, PhD and
Richard Jasmin  -with the assistance of others.

GDI/GDI+ and core X11 Primitive ops(prior to XOrg merge) are excrutiatingly slow.
(Please write code for DX7+ or a newer X11).

Byte/SmallInt are 8bit references
Word/Integer are 16bit references
Longword are 32bit references
QuadWords are 64bit references

**Code Intentionally uses forced 32bit references.**

Too many shortcuts are taken with most BGI graphics units.
This is the 'most complete' version that I have found. As far as compatibility- I am porting some C here- to fix this.
A lot was added.

THIS IS THE SDL2 version- IT WILL NOT WORK ON OLDER SYSTEMS.
SDL2 is DESIGNED FOR AN OPENGL-BASED RENDERING PLATFORM(and pipeline).


Apache/Mozilla licensed(FREED).

**MODIFIED FROM C(recent revisions) to FreePascal**
Updated to support FreePascal by Richard Jasmin

Original Code Sections (CPP) By Guido Gonzato, PhD
Automatic refresh patch by Marco Diego Aurélio Mesquita

Sections from FPC unit are from Jonas Maebe-and other where noted.

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

--

This unit is for compatiblility -FPC can pull in this unit - if done correctly- bypassing 
FPCs ANCIENT libSVGA unit version of libGraph and "compensating for using X11" these days.

That old FPC libSVGA unit "may be useful" once we get Framebuffer or KMS functional-
either as a fallback- or for RasPi.

Commercial software is allowed- I would like the backported changes and modifications.
I dont care what you use the source code for- just give me credit.

You must cite original authors and sub authors, as appropriate(standard attribution rules).
DO NOT CLAIM THIS CODE AS YOUR OWN and you MAY NOT remove this notice.

Although designed "for games programming"..the integration involved by the USE, ABUSE, and REUSE-
of SDL2 highlights so many OS internals its not even funny.

The C is in a 'rough portage state' (due to compatibility backporting) but this unit in general -builds, compiles, and runs
without problems. This is the more recent work on GH, I had to backport the rest (SDL1) to work.

Previous demos had a SDL2 exit glitch. This has been fixed.


LCL/Lazarus references will be removed- Lazarus is NOT compatible with the Window/Graphical Context hooks provided here.
IT IS COMPATIBLE with 3D OpenGL ones. Until Windows/MacOSX/X11 hooks can be pulled thru correctly- this cannot be fixed.
SDL provides no way of doing this correctly in a 'sensible PASCAL manner'.

-If you figure out how to do this on modern hardware, with recent code- Im all ears.
}


interface


uses

//Threads requires baseunix unit
//cthreads has to be the first unit in this case-it so happens to support the C version.

{$IFDEF UNIX} //if coming from dos- sysutils is the equivalent unit.
      cthreads,cmem,baseunix,
    
{$ENDIF}

    ctypes,classes,sysutils,

//very hackish: sysutils and Dos use baseunix and linux but work on windows???
//HMMMMMMM

//ctypes: cint,uint,PTRUint,PTR-USINT,sint...etc.

// A hackish trick...test if LCL unit(s) are loaded or linked in, then adjust "console" logging...

{$IFDEF MSWINDOWS} //as if theres a non-MS WINDOWS?
    Windows,
    //MMsystem, //audio subsystem-32bits only

{$ENDIF}


{$IFDEF LCL}
	{$IFDEF LCLGTK2}
		gtk2,
	{$ENDIF}

	{$IFDEF LCLQT}
		qtwidgets,
	{$ENDIF}

	  //works on Linux+Qt but not windows??? I have WINE and a VM- lets figure it out.
      LazUtils,  Interfaces, Dialogs, LCLType,Forms,Controls, 
    {$IFDEF MSWINDOWS}
       //we will check if this is set later.
      {$DEFINE NOCONSOLE }
    {$ENDIF}

{$ENDIF}


//its possible to have a Windows "console app" thru FPC,
//just not thru Lazarus. Debugging thru console environment, however, IS supported on windows.

{$IFNDEF NOCONSOLE}
    crt,crtstuff,
{$ENDIF}

//ENSURE THESE ARE ALL INSTALLED OR YOU WILL GET LINKING ERRORS!
  SDL2,SDL2_ttf,strings,typinfo,logger,math

//sdl2_net,uos,FreeImage

//Pulse and Sox can give us a beep(via commandline intervention)- but dont expect much in the way of a over-driven speaker.
//Its a one-shot deal with enough delay to make you BEEP , yourself!
//Its "good enough" for our needs.

//stipple is what dashes lines are called


//lets be fair to the compiler..
{$IFDEF debug} ,heaptrc {$ENDIF} 

{$IFDEF Darwin}
  CarbonPrivate,CocoaAll //, Files
{$ENDIF}
;


//iFruits, iTVs, etc:
// {linkframework CocoaTouch} -- but go kick apple in the ass for not letting us link to it.
// not legally, anyway....



//Altogether- we are talking PCs running OSX, Windows(7+), and most unices.
//RasPis, and Some android (as a unice sub-derivative)

//(Pi and Droids are ARM CPUS)


{
NOTES on units used:

crt is a failsafe "ncurses-ish"....output...
crtstuff is MY enhanced dialog unit 
    I will be porting this and maybe more to the graphics routines in this unit.


FPC Devs: "It might be wise to include cmem for speedups"
"The uses clause definition of cthreads, enables theaded applications"


mutex(es):

The idea is to talk when you have the rubber chicken or to request it or wait until others are done.
Ideally you would mutex events and process them like cpu interrupts- one at a time.


sephamores:
these are like using a loo in a castle- 
only so many can do it at once, first come- first served
- but theres more than one toilet
}

//scale output(via SDL) if resolution is lower then the window canvas size-or fullscreen.
//typically, interlacing is used - "to cheat"

//wherein 320x240 can be blown up to 640x480 (as 480i)
//if you dont want to upscale(fuzzy), but want the "lo-res feel"- set "fat pixel mode" at intended resolution (and draw with neighbors).

//Droids and Pis can probably use "up to VGA modes" resolutions natively. Smaller screens= lower resolution needed.
//after 1024, modern hardware drops support for lower resolutions (and palettes), GL doesnt support less than 24bpp.
//I could force the issue(palettes), but why? Im using 24bpp inside the LUT.

//below 320 will probably be stretched anyways, the canvas is too small on modern screens.(Let me get to this)

//MAC: 640x480,800x600,1024x768 up to 24bpp is supported
//droids and pis will have to have weird half-resolutions and bpps added in later on.

//TrueColors modes (>24bpp) produce one problem: We can no longer track the maximum colors(exceeds bounds).
{
BitDepth	Colors 

1bit B/W = 2
2bit CGA = 4
4bit EGA = 16
8bit VGA = 256
15bit = 32k
16bit = 64k
24bit = 16M (max addressable colors with 32bit systems is: 4Million -2)
32bit = 4.2B (or 16M+ blends) 
 
}


{$I lazgfx.inc}

//FPC generic units(OS independent)
//uos is a substitute for SDL2_sound- use that if you like.
//sdl2_gfx is in rewrite and ticks isnt used yet.

{$I paletteh.inc}

implementation

{
greyscale palettes are required for either loading or displaying in BW, or some subset thereof.
this isnt "exactly" duplicated code

hardspec it first, then allow user defined- or "pre-saved" files
that not to say you cant init, save, then load thru the main code instead of useing the hard spec.

the hardspec is here as a default setting, much like most 8x8 font sometimes are included
by default in graphics modes source code.

these are zero based colors. for 16 color modes- 88 or even 80 is not correct, 70 or 77 is.
the 256 hex color data was pulled from xterm (and CGA) specs.


the only guaranteed perfect palette code is (m)CGA -tweaked by me, and Greyscale 256.
(greyscale mCGA is a hackish guess based on rough math, given 14 colors, and also black and white)
256 should mimic xterm colors IF the endianess is correct and I dont need DWord hex math ops

the question becomes- do we really need to set the DWords by hand.. (such a PITA)
while I did this thinking YES, possibly no. AYE AYE AYE!

SDL performs the bit-flapping for us. so- if we set the Grey256 color value as a RGBA record/struct(c) entry 
then we should be able to pull it back as a unknown DWord(in theory).
(SDL_Map and SDL_Get RGB/RGBA are here for this purpose)

}


function Word16_from_RGB(red,green, blue:byte):Word; //Word=GLShort
//565 16bit color

var
    alpha:byte;
begin
  red:= red shr 3;
  green:= green shr 2;
  blue:=  blue shr 3;
  alpha:=$ff; //ignored
  Word16_from_RGB:= (red shl 11) or (green shl 5) or blue;
end;

function Word15_from_RGB(red,green, blue:byte):Word; //Word=GLShort
//5551 16bit color

var
    alpha:byte;

begin
  red:= red shr 3;
  green:= green shr 3;
  blue:=  blue shr 3;
  alpha:=$ff; //dropped and ignored
  Word15_from_RGB:= (red shl 10) or (green shl 4) or blue;
end;

//sets "surface" as "texture" and flops back to render preSENT the data

//Suraface uses CPU, Textures use GPU

{
function loadTexture(filename:PChar; renderer:PSDL_RENDERER):PSDL_Texture;

var
    Texture:PSDL_TExture;

begin
	if (texture = nil) then begin
		logLn('Cant load an empty filename to a Texture.');
	end;
    texture := IMG_LoadTexture(renderer, filename);
	result:= texture;
end;
}

//rect size could be 1px for all we know- or the entire rendering surface...
//note this function is "slow ASS"

procedure GEtPixels(Rect:PSDL_Rect);
var

  pitch:integer;
  AttemptRead:longint;
  pixels:pointer;

begin
   pixels:=Nil;
   pitch:=0;

//case format of...

//format and rect we already can derive
//pixels and pitch will be returned for the given rect in SDL_Color format given by our set definition
//rect is Nil to copy the entire rendering target

   AttemptRead:= SDL_RenderReadPixels( renderer, rect, format, pixels, pitch);
   if AttemptRead=0 then
     exit;

end;



procedure initPaletteGrey16;

var
   i,num:integer;


begin  

valuelist16[0]:=$00;
valuelist16[1]:=$00;
valuelist16[2]:=$00;
valuelist16[3]:=$11;
valuelist16[4]:=$11;
valuelist16[5]:=$11;
valuelist16[6]:=$22;
valuelist16[7]:=$22;
valuelist16[8]:=$22;
valuelist16[9]:=$33;
valuelist16[10]:=$33;
valuelist16[11]:=$33;
valuelist16[12]:=$44;
valuelist16[13]:=$44;
valuelist16[14]:=$44;
valuelist16[15]:=$55;
valuelist16[16]:=$55;
valuelist16[17]:=$55;
valuelist16[18]:=$66;
valuelist16[19]:=$66;
valuelist16[20]:=$66;
valuelist16[21]:=$77;
valuelist16[22]:=$77;
valuelist16[23]:=$77;
valuelist16[24]:=$88;
valuelist16[25]:=$88;
valuelist16[26]:=$88;
valuelist16[27]:=$99;
valuelist16[28]:=$99;
valuelist16[29]:=$99;
valuelist16[30]:=$aa;
valuelist16[31]:=$aa;
valuelist16[32]:=$aa;
valuelist16[33]:=$bb;
valuelist16[34]:=$bb;
valuelist16[35]:=$bb;
valuelist16[36]:=$cc;
valuelist16[37]:=$cc;
valuelist16[38]:=$cc;
valuelist16[39]:=$dd;
valuelist16[40]:=$dd;
valuelist16[41]:=$dd;
valuelist16[42]:=$ee;
valuelist16[43]:=$ee;
valuelist16[44]:=$ee;
valuelist16[45]:=$ff;
valuelist16[46]:=$ff;
valuelist16[47]:=$ff;

   i:=0;
   num:=0; 
   repeat 
      Tpalette16[num].colors^.r:=valuelist16[i];
      Tpalette16[num].colors^.g:=valuelist16[i+1];
      Tpalette16[num].colors^.b:=valuelist16[i+2];
      Tpalette16[num].colors^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  until num=15;

//syntax change

TPalette16GRey[0].DWords:=$000000ff;
TPalette16GRey[1].DWords:=$111111ff;
TPalette16GRey[2].DWords:=$222222ff;
TPalette16GRey[3].DWords:=$333333ff;
TPalette16GRey[4].DWords:=$444444ff;
TPalette16GRey[5].DWords:=$555555ff;
TPalette16GRey[6].DWords:=$666666ff;
TPalette16GRey[7].DWords:=$777777ff;
TPalette16GRey[8].DWords:=$888888ff;
TPalette16GRey[9].DWords:=$999999ff;
TPalette16GRey[10].DWords:=$aaaaaaff;
TPalette16GRey[11].DWords:=$bbbbbbff;
TPalette16GRey[12].DWords:=$ccccccff;
TPalette16GRey[13].DWords:=$ddddddff;
TPalette16GRey[14].DWords:=$eeeeeeff;
TPalette16GRey[15].DWords:=$ffffffff; 

end;


procedure initPaletteGrey256;

//easy peasy to setup.

var
    i,num:byte;


begin  

//(we dont setup valuelist by hand this time)

   i:=0;
  repeat 
      Tpalette256Grey[i].colors^.r:=ord(i);
      Tpalette256Grey[i].colors^.g:=ord(i);
      Tpalette256Grey[i].colors^.b:=ord(i);
      Tpalette256Grey[i].colors^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i); //notice the difference <-HERE ..where RGB are the same values      
  until i=255;

	
//00-FF as shown above with all value the same in the DWord except the Alpha/transparency Bit, which stays at FF


Tpalette256Grey[0].DWords:=$000000ff;
//the only gauranteed correct values are 0 and 255 right now.
//this will have to be manually set according to the above math.

Tpalette256Grey[1].DWords:=$010101ff;
Tpalette256Grey[2].DWords:=$020202ff;
Tpalette256Grey[3].DWords:=$030303ff;
Tpalette256Grey[4].DWords:=$040404ff;
Tpalette256Grey[5].DWords:=$050505ff;
Tpalette256Grey[6].DWords:=$060606ff;
Tpalette256Grey[7].DWords:=$070707ff;
Tpalette256Grey[8].DWords:=$080808ff;
Tpalette256Grey[9].DWords:=$090909ff;
Tpalette256Grey[10].DWords:=$0a0a0aff;
Tpalette256Grey[11].DWords:=$0b0b0bff;
Tpalette256Grey[12].DWords:=$0c0c0cff;
Tpalette256Grey[13].DWords:=$0d0d0dff;
Tpalette256Grey[14].DWords:=$0e0e0eff;
Tpalette256Grey[15].DWords:=$0f0f0fff; 

Tpalette256Grey[16].DWords:=$101010ff;
Tpalette256Grey[17].DWords:=$111111ff;
Tpalette256Grey[18].DWords:=$121212ff;
Tpalette256Grey[19].DWords:=$131313ff;
Tpalette256Grey[20].DWords:=$141414ff;
Tpalette256Grey[21].DWords:=$151515ff;
Tpalette256Grey[22].DWords:=$161616ff;
Tpalette256Grey[23].DWords:=$171717ff;
Tpalette256Grey[24].DWords:=$181818ff;
Tpalette256Grey[25].DWords:=$191919ff;
Tpalette256Grey[26].DWords:=$1a1a1aff;
Tpalette256Grey[27].DWords:=$1b1b1bff;
Tpalette256Grey[28].DWords:=$1c1c1cff;
Tpalette256Grey[29].DWords:=$1d1d1dff;
Tpalette256Grey[30].DWords:=$1e1e1eff;
Tpalette256Grey[31].DWords:=$1f1f1fff;

Tpalette256Grey[32].DWords:=$202020ff;
Tpalette256Grey[33].DWords:=$212121ff;
Tpalette256Grey[34].DWords:=$222222ff;
Tpalette256Grey[35].DWords:=$232323ff;
Tpalette256Grey[36].DWords:=$242424ff;
Tpalette256Grey[37].DWords:=$252525ff;
Tpalette256Grey[38].DWords:=$262626ff;
Tpalette256Grey[39].DWords:=$272727ff;
Tpalette256Grey[40].DWords:=$282828ff;
Tpalette256Grey[41].DWords:=$292929ff;
Tpalette256Grey[42].DWords:=$2a2a2aff;
Tpalette256Grey[43].DWords:=$2b2b2bff;
Tpalette256Grey[44].DWords:=$2c2c2cff;
Tpalette256Grey[45].DWords:=$2d2d2dff;
Tpalette256Grey[46].DWords:=$2e2e2eff;
Tpalette256Grey[47].DWords:=$2f2f2fff;

Tpalette256Grey[48].DWords:=$303030ff;
Tpalette256Grey[49].DWords:=$313131ff;
Tpalette256Grey[50].DWords:=$323232ff;
Tpalette256Grey[51].DWords:=$333333ff;
Tpalette256Grey[52].DWords:=$343434ff;
Tpalette256Grey[53].DWords:=$353535ff;
Tpalette256Grey[54].DWords:=$363636ff;
Tpalette256Grey[55].DWords:=$373737ff;
Tpalette256Grey[56].DWords:=$383838ff;
Tpalette256Grey[57].DWords:=$393939ff;
Tpalette256Grey[58].DWords:=$3a3a3aff;
Tpalette256Grey[59].DWords:=$3b3b3bff;
Tpalette256Grey[60].DWords:=$3c3c3cff;
Tpalette256Grey[61].DWords:=$3d3d3dff;
Tpalette256Grey[62].DWords:=$3e3e3eff;
Tpalette256Grey[63].DWords:=$3f3f3fff;

Tpalette256Grey[64].DWords:=$404040ff;
Tpalette256Grey[65].DWords:=$414141ff;
Tpalette256Grey[66].DWords:=$424242ff;
Tpalette256Grey[67].DWords:=$434343ff;
Tpalette256Grey[68].DWords:=$444444ff;
Tpalette256Grey[69].DWords:=$454545ff;
Tpalette256Grey[70].DWords:=$464646ff;
Tpalette256Grey[71].DWords:=$474747ff;
Tpalette256Grey[72].DWords:=$484848ff;
Tpalette256Grey[73].DWords:=$494949ff;
Tpalette256Grey[74].DWords:=$4a4a4aff;
Tpalette256Grey[75].DWords:=$4b4b4bff;
Tpalette256Grey[76].DWords:=$4c4c4cff;
Tpalette256Grey[77].DWords:=$4d4d4dff;
Tpalette256Grey[78].DWords:=$4e4e4eff;
Tpalette256Grey[79].DWords:=$4f4f4fff;

Tpalette256Grey[80].DWords:=$505050ff;
Tpalette256Grey[81].DWords:=$515151ff;
Tpalette256Grey[82].DWords:=$525252ff;
Tpalette256Grey[83].DWords:=$535353ff;
Tpalette256Grey[84].DWords:=$545454ff;
Tpalette256Grey[85].DWords:=$555555ff;
Tpalette256Grey[86].DWords:=$565656ff;
Tpalette256Grey[87].DWords:=$575757ff;
Tpalette256Grey[88].DWords:=$585858ff;
Tpalette256Grey[89].DWords:=$595959ff;
Tpalette256Grey[90].DWords:=$5a5a5aff;
Tpalette256Grey[91].DWords:=$5b5b5bff;
Tpalette256Grey[92].DWords:=$5c5c5cff;
Tpalette256Grey[93].DWords:=$5d5d5dff;
Tpalette256Grey[94].DWords:=$5e5e5eff;
Tpalette256Grey[95].DWords:=$5f5f5fff;

Tpalette256Grey[96].DWords:=$606060ff;
Tpalette256Grey[97].DWords:=$616161ff;
Tpalette256Grey[98].DWords:=$626262ff;
Tpalette256Grey[99].DWords:=$636363ff;
Tpalette256Grey[100].DWords:=$646464ff;
Tpalette256Grey[101].DWords:=$656565ff;
Tpalette256Grey[102].DWords:=$666666ff;
Tpalette256Grey[103].DWords:=$676767ff;
Tpalette256Grey[104].DWords:=$686868ff;
Tpalette256Grey[105].DWords:=$696969ff;
Tpalette256Grey[106].DWords:=$6a6a6aff;
Tpalette256Grey[107].DWords:=$6b6b6bff;
Tpalette256Grey[108].DWords:=$6c6c6cff;
Tpalette256Grey[109].DWords:=$6d6d6dff;
Tpalette256Grey[110].DWords:=$6e6e6eff;
Tpalette256Grey[111].DWords:=$6f6f6fff;

Tpalette256Grey[112].DWords:=$707070ff;
Tpalette256Grey[113].DWords:=$717171ff;
Tpalette256Grey[114].DWords:=$727272ff;
Tpalette256Grey[115].DWords:=$737373ff;
Tpalette256Grey[116].DWords:=$747474ff;
Tpalette256Grey[117].DWords:=$757575ff;
Tpalette256Grey[118].DWords:=$767676ff;
Tpalette256Grey[119].DWords:=$777777ff;
Tpalette256Grey[120].DWords:=$787878ff;
Tpalette256Grey[121].DWords:=$797979ff;
Tpalette256Grey[122].DWords:=$7a7a7aff;
Tpalette256Grey[123].DWords:=$7b7b7bff;
Tpalette256Grey[124].DWords:=$7c7c7cff;
Tpalette256Grey[125].DWords:=$7d7d7dff;
Tpalette256Grey[126].DWords:=$7e7e7eff;
Tpalette256Grey[127].DWords:=$7f7f7fff;

Tpalette256Grey[128].DWords:=$808080ff;
Tpalette256Grey[129].DWords:=$818181ff;
Tpalette256Grey[130].DWords:=$828282ff;
Tpalette256Grey[131].DWords:=$838383ff;
Tpalette256Grey[132].DWords:=$848484ff;
Tpalette256Grey[133].DWords:=$858585ff;
Tpalette256Grey[134].DWords:=$868686ff;
Tpalette256Grey[135].DWords:=$878787ff;
Tpalette256Grey[136].DWords:=$888888ff;
Tpalette256Grey[137].DWords:=$898989ff;
Tpalette256Grey[138].DWords:=$8a8a8aff;
Tpalette256Grey[139].DWords:=$8b8b8bff;
Tpalette256Grey[140].DWords:=$8c8c8cff;
Tpalette256Grey[141].DWords:=$8d8d8dff;
Tpalette256Grey[142].DWords:=$8e8e8eff;
Tpalette256Grey[143].DWords:=$8f8f8fff;

Tpalette256Grey[144].DWords:=$909090ff;
Tpalette256Grey[145].DWords:=$919191ff;
Tpalette256Grey[146].DWords:=$929292ff;
Tpalette256Grey[147].DWords:=$939393ff;
Tpalette256Grey[148].DWords:=$949494ff;
Tpalette256Grey[149].DWords:=$959595ff;
Tpalette256Grey[150].DWords:=$969696ff;
Tpalette256Grey[151].DWords:=$979797ff;
Tpalette256Grey[152].DWords:=$989898ff;
Tpalette256Grey[153].DWords:=$999999ff;
Tpalette256Grey[154].DWords:=$9a9a9aff;
Tpalette256Grey[155].DWords:=$9b9b9bff;
Tpalette256Grey[156].DWords:=$9c9c9cff;
Tpalette256Grey[157].DWords:=$9d9d9dff;
Tpalette256Grey[158].DWords:=$9e9e9eff;
TPalette256GRey[159].DWords:=$9f9f9fff; 

Tpalette256Grey[160].DWords:=$a0a0a0ff;
Tpalette256Grey[161].DWords:=$a1a1a1ff;
Tpalette256Grey[162].DWords:=$a2a2a2ff;
Tpalette256Grey[163].DWords:=$a3a3a3ff;
Tpalette256Grey[164].DWords:=$a4a4a4ff;
Tpalette256Grey[165].DWords:=$a5a5a5ff;
Tpalette256Grey[166].DWords:=$a6a6a6ff;
Tpalette256Grey[167].DWords:=$a7a7a7ff;
Tpalette256Grey[168].DWords:=$a8a8a8ff;
Tpalette256Grey[169].DWords:=$a9a9a9ff;
Tpalette256Grey[170].DWords:=$aaaaaaff;
Tpalette256Grey[171].DWords:=$abababff;
Tpalette256Grey[172].DWords:=$acacacff;
Tpalette256Grey[173].DWords:=$adadadff;
Tpalette256Grey[174].DWords:=$aeaeaeff;
Tpalette256Grey[175].DWords:=$afafafff;

Tpalette256Grey[176].DWords:=$b0b0b0ff;
Tpalette256Grey[177].DWords:=$b1b1b1ff;
Tpalette256Grey[178].DWords:=$b2b2b2ff;
Tpalette256Grey[179].DWords:=$b3b3b3ff;
Tpalette256Grey[180].DWords:=$b4b4b4ff;
Tpalette256Grey[181].DWords:=$b5b5b5ff;
Tpalette256Grey[182].DWords:=$b6b6b6ff;
Tpalette256Grey[183].DWords:=$b7b7b7ff;
Tpalette256Grey[184].DWords:=$b8b8b8ff;
Tpalette256Grey[185].DWords:=$b9b9b9ff;
Tpalette256Grey[186].DWords:=$bababaff;
Tpalette256Grey[187].DWords:=$bbbbbbff;
Tpalette256Grey[188].DWords:=$bcbcbcff;
Tpalette256Grey[189].DWords:=$bdbdbdff;
Tpalette256Grey[190].DWords:=$bebebeff;
Tpalette256Grey[191].DWords:=$bfbfbfff;

Tpalette256Grey[192].DWords:=$c0c0c0ff;
Tpalette256Grey[193].DWords:=$c1c1c1ff;
Tpalette256Grey[194].DWords:=$c2c2c2ff;
Tpalette256Grey[195].DWords:=$c3c3c3ff;
Tpalette256Grey[196].DWords:=$c4c4c4ff;
Tpalette256Grey[197].DWords:=$c5c5c5ff;
Tpalette256Grey[198].DWords:=$c6c6c6ff;
Tpalette256Grey[199].DWords:=$c7c7c7ff;
Tpalette256Grey[200].DWords:=$c8c8c8ff;
Tpalette256Grey[201].DWords:=$c9c9c9ff;
Tpalette256Grey[202].DWords:=$cacacaff;
Tpalette256Grey[203].DWords:=$cbcbcbff;
Tpalette256Grey[204].DWords:=$ccccccff;
Tpalette256Grey[205].DWords:=$cdcdcdff;
Tpalette256Grey[206].DWords:=$cececeff;
Tpalette256Grey[207].DWords:=$cfcfcfff;

Tpalette256Grey[208].DWords:=$d0d0d0ff;
Tpalette256Grey[209].DWords:=$d1d1d1ff;
Tpalette256Grey[210].DWords:=$d2d2d2ff;
Tpalette256Grey[211].DWords:=$d3d3d3ff;
Tpalette256Grey[212].DWords:=$d4d4d4ff;
Tpalette256Grey[213].DWords:=$d5d5d5ff;
Tpalette256Grey[214].DWords:=$d6d6d6ff;
Tpalette256Grey[215].DWords:=$d7d7d7ff;
Tpalette256Grey[216].DWords:=$d8d8d8ff;
Tpalette256Grey[217].DWords:=$d9d9d9ff;
Tpalette256Grey[218].DWords:=$dadadaff;
Tpalette256Grey[219].DWords:=$dbdbdbff;
Tpalette256Grey[220].DWords:=$dcdcdcff;
Tpalette256Grey[221].DWords:=$ddddddff;
Tpalette256Grey[222].DWords:=$dededeff;
Tpalette256Grey[223].DWords:=$dfdfdfff;

Tpalette256Grey[224].DWords:=$e0e0e0ff;
Tpalette256Grey[225].DWords:=$e1e1e1ff;
Tpalette256Grey[226].DWords:=$e2e2e2ff;
Tpalette256Grey[227].DWords:=$e3e3e3ff;
Tpalette256Grey[228].DWords:=$e4e4e4ff;
Tpalette256Grey[229].DWords:=$e5e5e5ff;
Tpalette256Grey[230].DWords:=$e6e6e6ff;
Tpalette256Grey[231].DWords:=$e7e7e7ff;
Tpalette256Grey[232].DWords:=$e8e8e8ff;
Tpalette256Grey[233].DWords:=$e9e9e9ff;
Tpalette256Grey[234].DWords:=$eaeaeaff;
Tpalette256Grey[235].DWords:=$ebebebff;
Tpalette256Grey[236].DWords:=$ecececff;
Tpalette256Grey[237].DWords:=$edededff;
Tpalette256Grey[238].DWords:=$eeeeeeff;
Tpalette256Grey[239].DWords:=$efefefff;

Tpalette256Grey[240].DWords:=$f0f0f0ff;
Tpalette256Grey[241].DWords:=$f1f1f1ff;
Tpalette256Grey[242].DWords:=$f2f2f2ff;
Tpalette256Grey[243].DWords:=$f3f3f3ff;
Tpalette256Grey[244].DWords:=$f4f4f4ff;
Tpalette256Grey[245].DWords:=$f5f5f5ff;
Tpalette256Grey[246].DWords:=$f6f6f6ff;
Tpalette256Grey[247].DWords:=$f7f7f7ff;
Tpalette256Grey[248].DWords:=$f8f8f8ff;
Tpalette256Grey[249].DWords:=$f9f9f9ff;
Tpalette256Grey[250].DWords:=$fafafaff;
Tpalette256Grey[251].DWords:=$fbfbfbff;
Tpalette256Grey[252].DWords:=$fcfcfcff;
Tpalette256Grey[253].DWords:=$fdfdfdff;
Tpalette256Grey[254].DWords:=$fefefeff;
Tpalette256Grey[255].DWords:=$ffffffff;

end;

//FIXED- for good this time. (Oct-19-18)
procedure initPalette16;

var
   num,i:integer;
//80 in hex is beyond the halfway point at 128. 127 (7f) is more correct.

begin  
//Color Sequence:
//K HiR HiG HiB HiC HiM HiY HiGR LoGr LoR LoG LoB LoC LoM LoY W

valuelist16[0]:=$00;
valuelist16[1]:=$00;
valuelist16[2]:=$00;

valuelist16[3]:=$ff;
valuelist16[4]:=$00;
valuelist16[5]:=$00;

valuelist16[6]:=$00;
valuelist16[7]:=$ff;
valuelist16[8]:=$00;

valuelist16[9]:=$ff;
valuelist16[10]:=$ff;
valuelist16[11]:=$00;

valuelist16[12]:=$00;
valuelist16[13]:=$00;
valuelist16[14]:=$ff;

valuelist16[15]:=$ff;
valuelist16[16]:=$00;
valuelist16[17]:=$ff;

valuelist16[18]:=$ff;
valuelist16[19]:=$ff;
valuelist16[20]:=$00;


valuelist16[21]:=$c0;
valuelist16[22]:=$c0;
valuelist16[23]:=$c0;

valuelist16[24]:=$7f;
valuelist16[25]:=$7f;
valuelist16[26]:=$7f;


valuelist16[27]:=$7f;
valuelist16[28]:=$00;
valuelist16[29]:=$00;

valuelist16[30]:=$00;
valuelist16[31]:=$7f;
valuelist16[32]:=$00;

valuelist16[33]:=$7f;
valuelist16[34]:=$7f;
valuelist16[35]:=$00;

valuelist16[36]:=$00;
valuelist16[37]:=$00;
valuelist16[38]:=$7f;

valuelist16[39]:=$7f;
valuelist16[40]:=$00;
valuelist16[41]:=$7f;

valuelist16[42]:=$00;
valuelist16[43]:=$7f;
valuelist16[44]:=$7f;

valuelist16[45]:=$ff;
valuelist16[46]:=$ff;
valuelist16[47]:=$ff;


   i:=0;
   num:=0; 
   repeat 
      Tpalette16[num].colors^.r:=valuelist16[i];
      Tpalette16[num].colors^.g:=valuelist16[i+1];
      Tpalette16[num].colors^.b:=valuelist16[i+2];
      Tpalette16[num].colors^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      //see the remmed out notes below
      inc(i,3);
      inc(num); 
  until num=14;

//This is the proper way to do it but we have transparencys, not just intensities now.
//mucking w the alpha bit changes opacity levels- we dont want that.
//so we assume we are not going to "muck with it". 
//YOU can if you want.

{
//yes this is hackish- as were the days of (m)CGA...

   i:=0;
   num:=0; 
   for num:=0 to 7 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  end;


  num:=8;//force it
  i:=24;
   for num:=8 to 14 do begin 
      Tpalette16.colors[num].r:=valuelist16[i];
      Tpalette16.colors[num].g:=valuelist16[i+1];
      Tpalette16.colors[num].b:=valuelist16[i+2];
      Tpalette16.colors[num].a:=#7f; 
      inc(i,3);
      inc(num); 
  end;

  Tpalette16.colors[15].r:=valuelist16[45];
  Tpalette16.colors[15].g:=valuelist16[46];
  Tpalette16.colors[15].b:=valuelist16[47];
  Tpalette16.colors[15].a:=#ff; 

Color Sequence:

K HiR HiG HiB HiC HiM HiY HiGR LoGr LoR LoG LoB LoC LoM LoY W
}


TPalette16[0].DWords:=$000000ff;

TPalette16[1].DWords:=$ff0000ff;
TPalette16[2].DWords:=$00ff00ff;
TPalette16[3].DWords:=$ffff00ff;

TPalette16[4].DWords:=$0000ffff;
TPalette16[5].DWords:=$ff00ffff;
TPalette16[6].DWords:=$ffff55ff;

TPalette16[7].DWords:=$c0c0c0ff;
TPalette16[8].DWords:=$7f7f7fff;

TPalette16[9].DWords:=$7f0000ff;
TPalette16[10].DWords:=$007f00ff;
TPalette16[11].DWords:=$7f7f00ff;

TPalette16[12].DWords:=$00007fff;
TPalette16[13].DWords:=$7f007fff;
TPalette16[14].DWords:=$007f7fff;

TPalette16[15].DWords:=$ffffffff;

end;


procedure Save16Palette(filename:string);

var
	palette16File : File of TRec16;
	i,num            : integer;

Begin
	initPalette16;
	Assign(palette16File, filename);
	ReWrite(palette16File);
    i:=0;
    repeat
		Write(palette16File, TPalette16[i]); //dump everything out
        inc(i);
	until i=15;	
	Close(palette16File);
	
End;

//we should ask if we want to read a color or BW file, else we duplicate code for one line of changes.
//there is a way to check- but we would have to peek inside the file or just display it and assume things.
//this could shove a BW file in the color section or a color file in the BW section...
//anyway, theres two sets of arrays and you can reset to defaults if you need to.

procedure Read16Palette(filename:string; ReadColor:boolean);

Var
	palette16File  : File of TRec16;
	i,num            : integer;
    palette:PSDL_Palette;
	MY_Palette:TSDL_Colors;

Begin
	Assign(palette16File, filename);
	ReSet(palette16File);
    Seek(palette16File, 0); //find first record
	i:=0;
    if ReadColor=true then begin
        repeat
			Read(palette16File, TPalette16[i]); //read everything in
			inc(i);
		until i=15;
    end	else begin
        repeat
			Read(palette16File, TPalette16GRey[i]); 
			inc(i);
		until i=15;		
	end;    
	Close(palette16File);
	
    SDL_AllocPalette(16);    
    if ReadColor=true then begin
		x:=0;
		repeat
	        MY_Palette[x]:=Tpalette16[x].colors;
			inc(x);
		until x=15;

//this is reverse of what we want(palette[x].whatever), and a PITA.
          SDL_SetPaletteColors(palette,MY_palette,0,16);

    end else begin
		x:=0;
		repeat
	        MY_Palette[x]:=Tpalette16Grey[x].colors;
			inc(x);
		until x=15;

          SDL_SetPaletteColors(palette,MY_Palette,0,16);
   end;
end;

procedure initPalette256;

//256 color VGA palette based on XTerm colors(Unix)
// however the first 16 are off according to mCGA specs and have been corrected.
//xterms dont use "bold text by deault" an maybe this is where the confusion is.

//furthermore there are other 256rgb palettes.


var
    num,i:integer;


begin  

valuelist256[0]:=$00;
valuelist256[1]:=$00;
valuelist256[2]:=$00;
valuelist256[3]:=$ff;
valuelist256[4]:=$00;
valuelist256[5]:=$00;
valuelist256[6]:=$00;
valuelist256[7]:=$ff;
valuelist256[8]:=$00;
valuelist256[9]:=$ff;
valuelist256[10]:=$ff;
valuelist256[11]:=$00;
valuelist256[12]:=$00;
valuelist256[13]:=$00;
valuelist256[14]:=$ff;
valuelist256[15]:=$ff;
valuelist256[16]:=$00;
valuelist256[17]:=$ff;
valuelist256[18]:=$ff;
valuelist256[19]:=$ff;
valuelist256[20]:=$00;
valuelist256[21]:=$c0;
valuelist256[22]:=$c0;
valuelist256[23]:=$c0;
valuelist256[24]:=$7f;
valuelist256[25]:=$7f;
valuelist256[26]:=$7f;
valuelist256[27]:=$7f;
valuelist256[28]:=$00;
valuelist256[29]:=$00;
valuelist256[30]:=$00;
valuelist256[31]:=$7f;
valuelist256[32]:=$00;
valuelist256[33]:=$7f;
valuelist256[34]:=$7f;
valuelist256[35]:=$00;
valuelist256[36]:=$00;
valuelist256[37]:=$00;
valuelist256[38]:=$7f;
valuelist256[39]:=$7f;
valuelist256[40]:=$00;
valuelist256[41]:=$7f;
valuelist256[42]:=$00;
valuelist256[43]:=$7f;
valuelist256[44]:=$7f;
valuelist256[45]:=$ff;
valuelist256[46]:=$ff;
valuelist256[47]:=$ff;
valuelist256[48]:=$00;
valuelist256[49]:=$00;
valuelist256[50]:=$00;

valuelist256[51]:=$00;
valuelist256[52]:=$00;
valuelist256[53]:=$5f;
valuelist256[54]:=$00;
valuelist256[55]:=$00;
valuelist256[56]:=$87;
valuelist256[57]:=$00;
valuelist256[58]:=$00;
valuelist256[59]:=$af;
valuelist256[60]:=$00;
valuelist256[61]:=$00;
valuelist256[62]:=$d7;
valuelist256[63]:=$00;
valuelist256[64]:=$00;
valuelist256[65]:=$ff;
valuelist256[66]:=$00;
valuelist256[67]:=$5f;
valuelist256[68]:=$00;
valuelist256[69]:=$00;
valuelist256[70]:=$5f;
valuelist256[71]:=$5f;
valuelist256[72]:=$00;
valuelist256[73]:=$5f;
valuelist256[74]:=$87;
valuelist256[75]:=$00;
valuelist256[76]:=$5f;
valuelist256[77]:=$af;
valuelist256[78]:=$00;
valuelist256[79]:=$5f;
valuelist256[80]:=$d7;
valuelist256[81]:=$00;
valuelist256[82]:=$5f;
valuelist256[83]:=$ff;
valuelist256[84]:=$00;
valuelist256[85]:=$87;
valuelist256[86]:=$00;
valuelist256[87]:=$00;
valuelist256[88]:=$87;
valuelist256[89]:=$5f;
valuelist256[90]:=$00;
valuelist256[91]:=$87;
valuelist256[92]:=$87;
valuelist256[93]:=$00;
valuelist256[94]:=$87;
valuelist256[95]:=$af;
valuelist256[96]:=$00;
valuelist256[97]:=$87;
valuelist256[98]:=$d7;
valuelist256[99]:=$00;
valuelist256[100]:=$87;

valuelist256[101]:=$ff;
valuelist256[102]:=$00;
valuelist256[103]:=$af;
valuelist256[104]:=$00;
valuelist256[105]:=$00;
valuelist256[106]:=$af;
valuelist256[107]:=$5f;
valuelist256[108]:=$00;
valuelist256[109]:=$af;
valuelist256[110]:=$87;
valuelist256[111]:=$00;
valuelist256[112]:=$af;
valuelist256[113]:=$af;
valuelist256[114]:=$00;
valuelist256[115]:=$af;
valuelist256[116]:=$d7;
valuelist256[117]:=$00;
valuelist256[118]:=$af;
valuelist256[119]:=$ff;
valuelist256[120]:=$00;
valuelist256[121]:=$d7;
valuelist256[122]:=$00;
valuelist256[123]:=$00;
valuelist256[124]:=$d7;
valuelist256[125]:=$5f;
valuelist256[126]:=$00;
valuelist256[127]:=$d7;
valuelist256[128]:=$87;
valuelist256[129]:=$00;
valuelist256[130]:=$d7;
valuelist256[131]:=$af;
valuelist256[132]:=$00;
valuelist256[133]:=$d7;
valuelist256[134]:=$d7;
valuelist256[135]:=$00;
valuelist256[136]:=$d7;
valuelist256[137]:=$ff;
valuelist256[138]:=$00;
valuelist256[139]:=$ff;
valuelist256[140]:=$00;
valuelist256[141]:=$00;
valuelist256[142]:=$ff;
valuelist256[143]:=$5f;
valuelist256[144]:=$00;
valuelist256[145]:=$ff;
valuelist256[146]:=$87;
valuelist256[147]:=$00;
valuelist256[148]:=$ff;
valuelist256[149]:=$af;
valuelist256[150]:=$00;

valuelist256[151]:=$ff;
valuelist256[152]:=$d7;
valuelist256[153]:=$00;
valuelist256[154]:=$ff;
valuelist256[155]:=$ff;
valuelist256[156]:=$5f;
valuelist256[157]:=$00;
valuelist256[158]:=$00;
valuelist256[159]:=$5f;
valuelist256[160]:=$00;
valuelist256[161]:=$5f;
valuelist256[162]:=$5f;
valuelist256[163]:=$00;
valuelist256[164]:=$87;
valuelist256[165]:=$5f;
valuelist256[166]:=$00;
valuelist256[167]:=$af;
valuelist256[168]:=$5f;
valuelist256[169]:=$00;
valuelist256[170]:=$d7;
valuelist256[171]:=$5f;
valuelist256[172]:=$00;
valuelist256[173]:=$ff;
valuelist256[174]:=$5f;
valuelist256[175]:=$5f;
valuelist256[176]:=$00;
valuelist256[177]:=$5f;
valuelist256[178]:=$5f;
valuelist256[179]:=$5f;
valuelist256[180]:=$5f;
valuelist256[181]:=$5f;
valuelist256[182]:=$87;
valuelist256[183]:=$5f;
valuelist256[184]:=$5f;
valuelist256[185]:=$af;
valuelist256[186]:=$5f;
valuelist256[187]:=$5f;
valuelist256[188]:=$d7;
valuelist256[189]:=$5f;
valuelist256[190]:=$5f;
valuelist256[191]:=$ff;
valuelist256[192]:=$5f;
valuelist256[193]:=$87;
valuelist256[194]:=$00;
valuelist256[195]:=$5f;
valuelist256[196]:=$87;
valuelist256[197]:=$5f;
valuelist256[198]:=$5f;
valuelist256[199]:=$87;
valuelist256[200]:=$87;

valuelist256[201]:=$5f;
valuelist256[202]:=$87;
valuelist256[203]:=$af;
valuelist256[204]:=$5f;
valuelist256[205]:=$87;
valuelist256[206]:=$d7;
valuelist256[207]:=$5f;
valuelist256[208]:=$87;
valuelist256[209]:=$ff;
valuelist256[210]:=$5f;
valuelist256[211]:=$af;
valuelist256[212]:=$00;
valuelist256[213]:=$5f;
valuelist256[214]:=$af;
valuelist256[215]:=$5f;
valuelist256[216]:=$5f;
valuelist256[217]:=$af;
valuelist256[218]:=$87;
valuelist256[219]:=$5f;
valuelist256[220]:=$af;
valuelist256[221]:=$af;
valuelist256[222]:=$5f;
valuelist256[223]:=$af;
valuelist256[224]:=$d7;
valuelist256[225]:=$5f;
valuelist256[226]:=$af;
valuelist256[227]:=$ff;
valuelist256[228]:=$5f;
valuelist256[229]:=$d7;
valuelist256[230]:=$00;
valuelist256[231]:=$5f;
valuelist256[232]:=$d7;
valuelist256[233]:=$5f;
valuelist256[234]:=$5f;
valuelist256[235]:=$d7;
valuelist256[236]:=$87;
valuelist256[237]:=$5f;
valuelist256[238]:=$d7;
valuelist256[239]:=$af;
valuelist256[240]:=$5f;
valuelist256[241]:=$d7;
valuelist256[242]:=$d7;
valuelist256[243]:=$5f;
valuelist256[244]:=$d7;
valuelist256[245]:=$ff;
valuelist256[246]:=$5f;
valuelist256[247]:=$ff;
valuelist256[248]:=$00;
valuelist256[249]:=$5f;
valuelist256[250]:=$ff;
valuelist256[251]:=$5f;
valuelist256[252]:=$5f;
valuelist256[253]:=$ff;
valuelist256[254]:=$87;
valuelist256[255]:=$5f;
valuelist256[256]:=$ff;
valuelist256[257]:=$af;
valuelist256[258]:=$5f;
valuelist256[259]:=$ff;
valuelist256[260]:=$d7;

valuelist256[261]:=$5f;
valuelist256[262]:=$ff;
valuelist256[263]:=$ff;
valuelist256[264]:=$87;
valuelist256[265]:=$00;
valuelist256[266]:=$00;
valuelist256[267]:=$87;
valuelist256[268]:=$00;
valuelist256[269]:=$5f;
valuelist256[270]:=$87;
valuelist256[271]:=$00;
valuelist256[272]:=$87;
valuelist256[273]:=$87;
valuelist256[274]:=$00;
valuelist256[275]:=$af;
valuelist256[276]:=$87;
valuelist256[277]:=$00;
valuelist256[278]:=$d7;
valuelist256[279]:=$87;
valuelist256[280]:=$00;
valuelist256[281]:=$ff;
valuelist256[282]:=$87;
valuelist256[283]:=$5f;
valuelist256[284]:=$00;
valuelist256[285]:=$87;
valuelist256[286]:=$5f;
valuelist256[287]:=$5f;
valuelist256[288]:=$87;
valuelist256[289]:=$5f;
valuelist256[290]:=$87;
valuelist256[291]:=$87;
valuelist256[292]:=$5f;
valuelist256[293]:=$af;
valuelist256[294]:=$87;
valuelist256[295]:=$5f;
valuelist256[296]:=$d7;
valuelist256[297]:=$87;
valuelist256[298]:=$5f;
valuelist256[299]:=$ff;
valuelist256[300]:=$87;

valuelist256[301]:=$87;
valuelist256[302]:=$00;
valuelist256[303]:=$87;
valuelist256[304]:=$87;
valuelist256[305]:=$5f;
valuelist256[306]:=$87;
valuelist256[307]:=$87;
valuelist256[308]:=$87;
valuelist256[309]:=$87;
valuelist256[310]:=$87;
valuelist256[311]:=$af;
valuelist256[312]:=$87;
valuelist256[313]:=$87;
valuelist256[314]:=$d7;
valuelist256[315]:=$87;
valuelist256[316]:=$87;
valuelist256[317]:=$ff;
valuelist256[318]:=$87;
valuelist256[319]:=$af;
valuelist256[320]:=$00;
valuelist256[321]:=$87;
valuelist256[322]:=$af;
valuelist256[323]:=$5f;
valuelist256[324]:=$87;
valuelist256[325]:=$af;
valuelist256[326]:=$87;
valuelist256[327]:=$87;
valuelist256[328]:=$af;
valuelist256[329]:=$af;
valuelist256[330]:=$87;
valuelist256[331]:=$af;
valuelist256[332]:=$d7;
valuelist256[333]:=$87;
valuelist256[334]:=$af;
valuelist256[335]:=$ff;
valuelist256[336]:=$87;
valuelist256[337]:=$d7;
valuelist256[338]:=$00;
valuelist256[339]:=$87;
valuelist256[340]:=$d7;
valuelist256[341]:=$5f;
valuelist256[342]:=$87;
valuelist256[343]:=$d7;
valuelist256[344]:=$87;
valuelist256[345]:=$87;
valuelist256[346]:=$d7;
valuelist256[347]:=$af;
valuelist256[348]:=$87;
valuelist256[349]:=$d7;
valuelist256[350]:=$d7;
valuelist256[351]:=$87;
valuelist256[352]:=$d7;
valuelist256[353]:=$ff;
valuelist256[354]:=$87;
valuelist256[355]:=$ff;
valuelist256[356]:=$00;
valuelist256[357]:=$87;
valuelist256[358]:=$ff;
valuelist256[359]:=$5f;
valuelist256[360]:=$87;
valuelist256[361]:=$ff;
valuelist256[362]:=$87;
valuelist256[363]:=$87;
valuelist256[364]:=$ff;
valuelist256[365]:=$af;
valuelist256[366]:=$87;
valuelist256[367]:=$ff;
valuelist256[368]:=$d7;
valuelist256[369]:=$87;
valuelist256[370]:=$ff;
valuelist256[371]:=$ff;
valuelist256[372]:=$af;
valuelist256[373]:=$00;
valuelist256[374]:=$00;
valuelist256[375]:=$af;
valuelist256[376]:=$00;
valuelist256[377]:=$5f;
valuelist256[378]:=$af;
valuelist256[379]:=$00;
valuelist256[380]:=$87;
valuelist256[381]:=$af;
valuelist256[382]:=$00;
valuelist256[383]:=$af;
valuelist256[384]:=$af;
valuelist256[385]:=$00;
valuelist256[386]:=$d7;
valuelist256[387]:=$af;
valuelist256[388]:=$00;
valuelist256[389]:=$af;
valuelist256[390]:=$af;
valuelist256[391]:=$5f;
valuelist256[392]:=$00;
valuelist256[393]:=$af;
valuelist256[394]:=$5f;
valuelist256[395]:=$5f;
valuelist256[396]:=$af;
valuelist256[397]:=$5f;
valuelist256[398]:=$87;
valuelist256[399]:=$af;
valuelist256[400]:=$5f;

valuelist256[401]:=$af;
valuelist256[402]:=$af;
valuelist256[403]:=$5f;
valuelist256[404]:=$d7;
valuelist256[405]:=$af;
valuelist256[406]:=$5f;
valuelist256[407]:=$ff;
valuelist256[408]:=$af;
valuelist256[409]:=$87;
valuelist256[410]:=$00;
valuelist256[411]:=$af;
valuelist256[412]:=$87;
valuelist256[413]:=$5f;
valuelist256[414]:=$af;
valuelist256[415]:=$87;
valuelist256[416]:=$87;
valuelist256[417]:=$af;
valuelist256[418]:=$87;
valuelist256[419]:=$af;
valuelist256[420]:=$af;
valuelist256[421]:=$87;
valuelist256[422]:=$d7;
valuelist256[423]:=$af;
valuelist256[424]:=$87;
valuelist256[425]:=$ff;
valuelist256[426]:=$af;
valuelist256[427]:=$af;
valuelist256[428]:=$00;
valuelist256[429]:=$af;
valuelist256[430]:=$af;
valuelist256[431]:=$5f;
valuelist256[432]:=$af;
valuelist256[433]:=$af;
valuelist256[434]:=$87;
valuelist256[435]:=$af;
valuelist256[436]:=$af;
valuelist256[437]:=$af;
valuelist256[438]:=$af;
valuelist256[439]:=$af;
valuelist256[440]:=$d7;


valuelist256[441]:=$af;
valuelist256[442]:=$af;
valuelist256[443]:=$ff;
valuelist256[444]:=$af;
valuelist256[445]:=$d7;
valuelist256[446]:=$00;
valuelist256[447]:=$af;
valuelist256[448]:=$d7;
valuelist256[449]:=$5f;

valuelist256[450]:=$af;
valuelist256[451]:=$d7;
valuelist256[452]:=$87;
valuelist256[453]:=$af;
valuelist256[454]:=$d7;
valuelist256[455]:=$af;
valuelist256[456]:=$af;
valuelist256[457]:=$d7;
valuelist256[458]:=$d7;
valuelist256[459]:=$af;

valuelist256[460]:=$d7;
valuelist256[461]:=$ff;
valuelist256[462]:=$af;
valuelist256[463]:=$ff;
valuelist256[464]:=$00;
valuelist256[465]:=$af;
valuelist256[466]:=$ff;
valuelist256[467]:=$5f;
valuelist256[468]:=$af;
valuelist256[469]:=$ff;

valuelist256[470]:=$87;
valuelist256[471]:=$af;
valuelist256[472]:=$ff;
valuelist256[473]:=$af;
valuelist256[474]:=$af;
valuelist256[475]:=$ff;
valuelist256[476]:=$d7;
valuelist256[477]:=$af;
valuelist256[478]:=$ff;
valuelist256[479]:=$ff;

valuelist256[480]:=$d7;
valuelist256[481]:=$00;
valuelist256[482]:=$00;
valuelist256[483]:=$d7;
valuelist256[484]:=$00;
valuelist256[485]:=$5f;
valuelist256[486]:=$d7;
valuelist256[487]:=$00;
valuelist256[488]:=$87;
valuelist256[489]:=$d7;
valuelist256[490]:=$00;

valuelist256[491]:=$af;
valuelist256[492]:=$d7;
valuelist256[493]:=$00;
valuelist256[494]:=$d7;
valuelist256[495]:=$d7;
valuelist256[496]:=$00;
valuelist256[497]:=$ff;
valuelist256[498]:=$d7;
valuelist256[499]:=$5f;

valuelist256[500]:=$00;
valuelist256[501]:=$d7;
valuelist256[502]:=$5f;
valuelist256[503]:=$5f;
valuelist256[504]:=$d7;
valuelist256[505]:=$5f;
valuelist256[506]:=$87;
valuelist256[507]:=$d7;
valuelist256[508]:=$5f;
valuelist256[509]:=$af;
valuelist256[510]:=$d7;
valuelist256[511]:=$5f;
valuelist256[512]:=$d7;
valuelist256[513]:=$d7;
valuelist256[514]:=$5f;
valuelist256[515]:=$ff;
valuelist256[516]:=$d7;
valuelist256[517]:=$87;
valuelist256[518]:=$00;
valuelist256[519]:=$d7;
valuelist256[520]:=$87;
valuelist256[521]:=$5f;
valuelist256[522]:=$d7;
valuelist256[523]:=$87;
valuelist256[524]:=$87;
valuelist256[525]:=$d7;
valuelist256[526]:=$87;
valuelist256[527]:=$af;
valuelist256[528]:=$d7;
valuelist256[529]:=$87;

valuelist256[530]:=$d7;
valuelist256[531]:=$d7;
valuelist256[532]:=$87;
valuelist256[533]:=$ff;
valuelist256[534]:=$d7;
valuelist256[535]:=$af;
valuelist256[536]:=$00;
valuelist256[537]:=$d7;
valuelist256[538]:=$af;
valuelist256[539]:=$5f;

valuelist256[540]:=$d7;
valuelist256[541]:=$af;
valuelist256[542]:=$87;
valuelist256[543]:=$d7;
valuelist256[544]:=$af;
valuelist256[545]:=$af;
valuelist256[546]:=$d7;
valuelist256[547]:=$af;
valuelist256[548]:=$d7;
valuelist256[549]:=$d7;
valuelist256[550]:=$af;
valuelist256[551]:=$ff;
valuelist256[552]:=$d7;
valuelist256[553]:=$d7;
valuelist256[554]:=$00;
valuelist256[555]:=$d7;
valuelist256[556]:=$d7;
valuelist256[557]:=$5f;
valuelist256[558]:=$d7;
valuelist256[559]:=$d7;
valuelist256[560]:=$87;

valuelist256[561]:=$d7;
valuelist256[562]:=$d7;
valuelist256[563]:=$af;
valuelist256[564]:=$d7;
valuelist256[565]:=$d7;
valuelist256[566]:=$d7;
valuelist256[567]:=$d7;
valuelist256[568]:=$d7;
valuelist256[569]:=$ff;

valuelist256[570]:=$d7;
valuelist256[571]:=$ff;
valuelist256[572]:=$00;
valuelist256[573]:=$d7;
valuelist256[574]:=$ff;
valuelist256[575]:=$5f;
valuelist256[576]:=$d7;
valuelist256[577]:=$ff;
valuelist256[578]:=$87;
valuelist256[579]:=$d7;

valuelist256[580]:=$ff;
valuelist256[581]:=$af;
valuelist256[582]:=$d7;
valuelist256[583]:=$ff;
valuelist256[584]:=$d7;
valuelist256[585]:=$d7;
valuelist256[586]:=$ff;
valuelist256[587]:=$ff;
valuelist256[588]:=$ff;
valuelist256[589]:=$00;

valuelist256[590]:=$00;
valuelist256[591]:=$ff;
valuelist256[592]:=$00;
valuelist256[593]:=$5f;
valuelist256[594]:=$ff;
valuelist256[595]:=$00;
valuelist256[596]:=$87;
valuelist256[597]:=$ff;
valuelist256[598]:=$00;
valuelist256[599]:=$af;

valuelist256[600]:=$ff;
valuelist256[601]:=$00;
valuelist256[602]:=$d7;
valuelist256[603]:=$ff;
valuelist256[604]:=$00;
valuelist256[605]:=$ff;
valuelist256[606]:=$ff;
valuelist256[607]:=$5f;
valuelist256[608]:=$00;
valuelist256[609]:=$ff;

valuelist256[610]:=$5f;
valuelist256[611]:=$5f;
valuelist256[612]:=$ff;
valuelist256[613]:=$5f;
valuelist256[614]:=$87;
valuelist256[615]:=$ff;
valuelist256[616]:=$5f;
valuelist256[617]:=$af;
valuelist256[618]:=$ff;
valuelist256[619]:=$5f;

valuelist256[620]:=$d7;
valuelist256[621]:=$ff;
valuelist256[622]:=$5f;
valuelist256[623]:=$ff;
valuelist256[624]:=$ff;
valuelist256[625]:=$87;
valuelist256[626]:=$00;
valuelist256[627]:=$ff;
valuelist256[628]:=$87;
valuelist256[629]:=$5f;

valuelist256[630]:=$ff;
valuelist256[631]:=$87;
valuelist256[632]:=$87;
valuelist256[633]:=$ff;
valuelist256[634]:=$87;
valuelist256[635]:=$af;
valuelist256[636]:=$ff;
valuelist256[637]:=$87;
valuelist256[638]:=$d7;
valuelist256[639]:=$ff;

valuelist256[640]:=$87;
valuelist256[641]:=$ff;
valuelist256[642]:=$ff;
valuelist256[643]:=$af;
valuelist256[644]:=$00;
valuelist256[645]:=$ff;
valuelist256[646]:=$af;
valuelist256[647]:=$5f;
valuelist256[648]:=$ff;
valuelist256[649]:=$af;

valuelist256[650]:=$87;
valuelist256[651]:=$ff;
valuelist256[652]:=$af;
valuelist256[653]:=$af;
valuelist256[654]:=$ff;
valuelist256[655]:=$af;
valuelist256[656]:=$d7;
valuelist256[657]:=$ff;
valuelist256[658]:=$af;
valuelist256[659]:=$ff;

valuelist256[660]:=$ff;
valuelist256[661]:=$d7;
valuelist256[662]:=$00;
valuelist256[663]:=$ff;
valuelist256[664]:=$d7;
valuelist256[665]:=$5f;
valuelist256[666]:=$ff;
valuelist256[667]:=$d7;
valuelist256[668]:=$87;
valuelist256[669]:=$ff;

valuelist256[670]:=$d7;
valuelist256[671]:=$af;
valuelist256[672]:=$ff;
valuelist256[673]:=$d7;
valuelist256[674]:=$d7;
valuelist256[675]:=$ff;
valuelist256[676]:=$d7;
valuelist256[677]:=$ff;
valuelist256[678]:=$ff;
valuelist256[679]:=$ff;

valuelist256[680]:=$00;
valuelist256[681]:=$ff;
valuelist256[682]:=$ff;
valuelist256[683]:=$5f;
valuelist256[684]:=$ff;
valuelist256[685]:=$ff;
valuelist256[686]:=$87;
valuelist256[687]:=$ff;
valuelist256[688]:=$ff;
valuelist256[689]:=$af;

valuelist256[690]:=$ff;
valuelist256[691]:=$ff;
valuelist256[692]:=$d7;
valuelist256[693]:=$ff;
valuelist256[694]:=$ff;
valuelist256[695]:=$ff;
valuelist256[696]:=$08;
valuelist256[697]:=$08;
valuelist256[698]:=$08;
valuelist256[699]:=$12;

valuelist256[700]:=$12;
valuelist256[701]:=$12;
valuelist256[702]:=$1c;
valuelist256[703]:=$1c;
valuelist256[704]:=$1c;
valuelist256[705]:=$26;
valuelist256[706]:=$26;
valuelist256[707]:=$26;
valuelist256[708]:=$30;
valuelist256[709]:=$30;

valuelist256[710]:=$30;
valuelist256[711]:=$3a;
valuelist256[712]:=$3a;
valuelist256[713]:=$3a;
valuelist256[714]:=$44;
valuelist256[715]:=$44;
valuelist256[716]:=$44;
valuelist256[717]:=$4e;
valuelist256[718]:=$4e;
valuelist256[719]:=$4e;

valuelist256[720]:=$58;
valuelist256[721]:=$58;
valuelist256[722]:=$58;
valuelist256[723]:=$62;
valuelist256[724]:=$62;
valuelist256[725]:=$62;
valuelist256[726]:=$6c;
valuelist256[727]:=$6c;
valuelist256[728]:=$6c;
valuelist256[729]:=$76;

valuelist256[730]:=$76;
valuelist256[731]:=$76;
valuelist256[732]:=$80;
valuelist256[733]:=$80;
valuelist256[734]:=$80;
valuelist256[735]:=$8a;
valuelist256[736]:=$8a;
valuelist256[737]:=$8a;
valuelist256[738]:=$94;
valuelist256[739]:=$94;

valuelist256[740]:=$94;
valuelist256[741]:=$9e;
valuelist256[742]:=$9e;
valuelist256[743]:=$9e;
valuelist256[744]:=$a8;
valuelist256[745]:=$a8;
valuelist256[746]:=$a8;
valuelist256[747]:=$b2;
valuelist256[748]:=$b2;
valuelist256[749]:=$b2;

valuelist256[750]:=$bc;
valuelist256[751]:=$bc;
valuelist256[752]:=$bc;
valuelist256[753]:=$c6;
valuelist256[754]:=$c6;
valuelist256[755]:=$c6;
valuelist256[756]:=$d0;
valuelist256[757]:=$d0;
valuelist256[758]:=$d0;
valuelist256[759]:=$da;

valuelist256[760]:=$da;
valuelist256[761]:=$da;
valuelist256[762]:=$e4;
valuelist256[763]:=$e4;
valuelist256[764]:=$e4;
valuelist256[765]:=$ee;
valuelist256[766]:=$ee;
valuelist256[767]:=$ee;

//zero increments are always one short

   i:=0;
   num:=0; 
   repeat
      Tpalette256[num].colors^.r:=valuelist256[i];
      Tpalette256[num].colors^.g:=valuelist256[i+1];
      Tpalette256[num].colors^.b:=valuelist256[i+2];
      Tpalette256[num].colors^.a:=$ff; //rbgi technically but this is for SDL, not CGA VGA VESA ....
      inc(i,3);
      inc(num); 
  until num=767;

	
//256 color VGA palette based on XTerm colors(Unix)
//first 16 colors now should be more accurate!

TPalette256[0].DWords:=$000000ff;
TPalette256[1].DWords:=$ff0000ff;
TPalette256[2].DWords:=$00ff00ff;
TPalette256[3].DWords:=$ffff00ff;
TPalette256[4].DWords:=$0000ffff;
TPalette256[5].DWords:=$ff00ffff;
TPalette256[6].DWords:=$ffff55ff;
TPalette256[7].DWords:=$c0c0c0ff;
TPalette256[8].DWords:=$7f7f7fff;
TPalette256[9].DWords:=$7f0000ff;
TPalette256[10].DWords:=$007f00ff;
TPalette256[11].DWords:=$7f7f00ff;
TPalette256[12].DWords:=$00007fff;
TPalette256[13].DWords:=$7f007fff;
TPalette256[14].DWords:=$007f7fff;
TPalette256[15].DWords:=$ffffffff;

TPalette256[16].DWords:=$000000ff;
TPalette256[17].DWords:=$00005fff;
TPalette256[18].DWords:=$000087ff;
TPalette256[19].DWords:=$0000afff;
TPalette256[20].DWords:=$0000d7ff;
TPalette256[21].DWords:=$0000ffff;
TPalette256[22].DWords:=$005f00ff;
TPalette256[23].DWords:=$005f5fff;
TPalette256[24].DWords:=$005f87ff;
TPalette256[25].DWords:=$005fafff;
TPalette256[26].DWords:=$005fd7ff;
TPalette256[27].DWords:=$005fffff;
TPalette256[28].DWords:=$008700ff;
TPalette256[29].DWords:=$00875fff;
TPalette256[30].DWords:=$008787ff;

TPalette256[31].DWords:=$0087afff;
TPalette256[32].DWords:=$0087d7ff;
TPalette256[33].DWords:=$0087ffff;
TPalette256[34].DWords:=$00af00ff;
TPalette256[35].DWords:=$00af5fff;
TPalette256[36].DWords:=$00af87ff;
TPalette256[37].DWords:=$00afafff;
TPalette256[38].DWords:=$00afd7ff;
TPalette256[39].DWords:=$00afffff;
TPalette256[40].DWords:=$00d700ff;
TPalette256[41].DWords:=$00d75fff;
TPalette256[42].DWords:=$00d787ff;
TPalette256[43].DWords:=$00d7afff;
TPalette256[44].DWords:=$00d7d7ff;
TPalette256[45].DWords:=$00d7ffff;

TPalette256[46].DWords:=$00ff00ff;
TPalette256[47].DWords:=$00ff5fff;
TPalette256[48].DWords:=$00ff87ff;
TPalette256[49].DWords:=$00ffafff;
TPalette256[50].DWords:=$00ffd7ff;
TPalette256[51].DWords:=$00ffffff;
TPalette256[52].DWords:=$5f0000ff;
TPalette256[53].DWords:=$5f005fff;
TPalette256[54].DWords:=$5f0087ff;
TPalette256[55].DWords:=$5f00afff;
TPalette256[56].DWords:=$5f00d7ff;
TPalette256[57].DWords:=$5f00ffff;
TPalette256[58].DWords:=$5f5f00ff;
TPalette256[59].DWords:=$5f5f5fff;
TPalette256[60].DWords:=$5f5f87ff;

TPalette256[61].DWords:=$5f5fafff;
TPalette256[62].DWords:=$5f5fd7ff;
TPalette256[63].DWords:=$5f5fffff;
TPalette256[64].DWords:=$5f8700ff;
TPalette256[65].DWords:=$5f875fff;
TPalette256[66].DWords:=$5f8787ff;
TPalette256[67].DWords:=$5f87afff;
TPalette256[68].DWords:=$5f87d7ff;
TPalette256[69].DWords:=$5f87ffff;
TPalette256[70].DWords:=$5faf00ff;
TPalette256[71].DWords:=$5faf5fff;
TPalette256[72].DWords:=$5faf87ff;
TPalette256[73].DWords:=$5fafafff;
TPalette256[74].DWords:=$5fafd7ff;
TPalette256[75].DWords:=$5fafffff;

TPalette256[76].DWords:=$5fd700ff;
TPalette256[77].DWords:=$5fd75fff;
TPalette256[78].DWords:=$5fd787ff;
TPalette256[79].DWords:=$5fd7afff;
TPalette256[80].DWords:=$5fd7d7ff;
TPalette256[81].DWords:=$5fd7ffff;
TPalette256[82].DWords:=$5fff00ff;
TPalette256[83].DWords:=$5fff5fff;
TPalette256[84].DWords:=$5fff87ff;
TPalette256[85].DWords:=$5fffafff;
TPalette256[86].DWords:=$5fffd7ff;
TPalette256[87].DWords:=$5fffffff;
TPalette256[88].DWords:=$870000ff;
TPalette256[89].DWords:=$87005fff;
TPalette256[90].DWords:=$870087ff;

TPalette256[91].DWords:=$8700afff;
TPalette256[92].DWords:=$8700d7ff;
TPalette256[93].DWords:=$8700ffff;
TPalette256[94].DWords:=$875f00ff;
TPalette256[95].DWords:=$875f5fff;
TPalette256[96].DWords:=$875f87ff;
TPalette256[97].DWords:=$875fafff;
TPalette256[98].DWords:=$875fd7ff;
TPalette256[99].DWords:=$875fffff;
TPalette256[100].DWords:=$878700ff;
TPalette256[101].DWords:=$87875fff;
TPalette256[102].DWords:=$878787ff;
TPalette256[103].DWords:=$8787afff;
TPalette256[104].DWords:=$8787d7ff;
TPalette256[105].DWords:=$8787ffff;

TPalette256[106].DWords:=$87af00ff;
TPalette256[107].DWords:=$87af5fff;
TPalette256[108].DWords:=$87af87ff;
TPalette256[109].DWords:=$87afafff;


TPalette256[110].DWords:=$87afd7ff;
TPalette256[111].DWords:=$87afffff;
TPalette256[112].DWords:=$87d700ff;
TPalette256[113].DWords:=$87d75fff;
TPalette256[114].DWords:=$87d787ff;
TPalette256[115].DWords:=$87d7afff;
TPalette256[116].DWords:=$87d7d7ff;
TPalette256[117].DWords:=$87d7ffff;
TPalette256[118].DWords:=$87ff00ff;
TPalette256[119].DWords:=$87ff5fff;
TPalette256[120].DWords:=$87ff87ff;

TPalette256[121].DWords:=$87ffafff;
TPalette256[122].DWords:=$87ffd7ff;
TPalette256[123].DWords:=$87ffffff;
TPalette256[124].DWords:=$af0000ff;
TPalette256[125].DWords:=$af005fff;
TPalette256[126].DWords:=$af0087ff;
TPalette256[127].DWords:=$af00afff;
TPalette256[128].DWords:=$af00d7ff;
TPalette256[129].DWords:=$af00ffff;
TPalette256[130].DWords:=$af5f00ff;
TPalette256[131].DWords:=$af5f5fff;
TPalette256[132].DWords:=$af5f87ff;
TPalette256[133].DWords:=$af5fafff;
TPalette256[134].DWords:=$af5fd7ff;
TPalette256[135].DWords:=$af5fffff;

TPalette256[136].DWords:=$af8700ff;
TPalette256[137].DWords:=$af875fff;
TPalette256[138].DWords:=$af8787ff;
TPalette256[139].DWords:=$af87afff;
TPalette256[140].DWords:=$af87d7ff;
TPalette256[141].DWords:=$af87ffff;
TPalette256[142].DWords:=$afaf00ff;
TPalette256[143].DWords:=$afaf5fff;
TPalette256[144].DWords:=$afaf87ff;
TPalette256[145].DWords:=$afafafff;
TPalette256[146].DWords:=$afafd7ff;
TPalette256[147].DWords:=$afafffff;
TPalette256[148].DWords:=$afd700ff;
TPalette256[149].DWords:=$afd75fff;
TPalette256[150].DWords:=$afd787ff;

TPalette256[151].DWords:=$afd7afff;
TPalette256[152].DWords:=$afd7d7ff;
TPalette256[153].DWords:=$afd7ffff;
TPalette256[154].DWords:=$afff00ff;
TPalette256[155].DWords:=$afff5fff;
TPalette256[156].DWords:=$afff87ff;
TPalette256[157].DWords:=$afffafff;
TPalette256[158].DWords:=$afffd7ff;
TPalette256[159].DWords:=$afffffff;
TPalette256[160].DWords:=$d70000ff;
TPalette256[161].DWords:=$d7005fff;
TPalette256[162].DWords:=$d70087ff;
TPalette256[163].DWords:=$d700afff;
TPalette256[164].DWords:=$d700d7ff;
TPalette256[165].DWords:=$d700ffff;

TPalette256[166].DWords:=$d75f00ff;
TPalette256[167].DWords:=$d75f5fff;
TPalette256[168].DWords:=$d75f87ff;
TPalette256[169].DWords:=$d75fafff;
TPalette256[170].DWords:=$d75fd7ff;
TPalette256[171].DWords:=$d75fffff;
TPalette256[172].DWords:=$d78700ff;
TPalette256[173].DWords:=$d7875fff;
TPalette256[174].DWords:=$d78787ff;
TPalette256[175].DWords:=$d787afff;
TPalette256[176].DWords:=$d787d7ff;
TPalette256[177].DWords:=$d787ffff;
TPalette256[178].DWords:=$d7af00ff;
TPalette256[179].DWords:=$d7af5fff;
TPalette256[180].DWords:=$d7af87ff;

TPalette256[181].DWords:=$d7afafff;
TPalette256[182].DWords:=$d7afd7ff;
TPalette256[183].DWords:=$d7afffff;
TPalette256[184].DWords:=$d7d700ff;
TPalette256[185].DWords:=$d7d75fff;
TPalette256[186].DWords:=$d7d787ff;
TPalette256[187].DWords:=$d7d7afff;
TPalette256[188].DWords:=$d7d7d7ff;
TPalette256[189].DWords:=$d7d7ffff;
TPalette256[190].DWords:=$d7ff00ff;
TPalette256[191].DWords:=$d7ff5fff;
TPalette256[192].DWords:=$d7ff87ff;
TPalette256[193].DWords:=$d7ffafff;
TPalette256[194].DWords:=$d7ffd7ff;
TPalette256[195].DWords:=$d7ffffff;

TPalette256[196].DWords:=$ff0000ff;
TPalette256[197].DWords:=$ff005fff;
TPalette256[198].DWords:=$ff0087ff;
TPalette256[199].DWords:=$ff00afff;
TPalette256[200].DWords:=$ff00d7ff;
TPalette256[201].DWords:=$ff00ffff;
TPalette256[202].DWords:=$ff5f00ff;
TPalette256[203].DWords:=$ff5f5fff;
TPalette256[204].DWords:=$ff5f87ff;
TPalette256[205].DWords:=$ff5fafff;
TPalette256[206].DWords:=$ff5fd7ff;
TPalette256[207].DWords:=$ff5fffff;
TPalette256[208].DWords:=$ff8700ff;
TPalette256[209].DWords:=$ff875fff;
TPalette256[210].DWords:=$ff8787ff;

TPalette256[211].DWords:=$ff87afff;
TPalette256[212].DWords:=$ff87d7ff;
TPalette256[213].DWords:=$ff87ffff;
TPalette256[214].DWords:=$ffaf00ff;
TPalette256[215].DWords:=$ffaf5fff;
TPalette256[216].DWords:=$ffaf87ff;
TPalette256[217].DWords:=$ffafafff;
TPalette256[218].DWords:=$ffafd7ff;
TPalette256[219].DWords:=$ffafffff;
TPalette256[220].DWords:=$ffd700ff;

TPalette256[221].DWords:=$ffd75fff;
TPalette256[222].DWords:=$ffd787ff;
TPalette256[223].DWords:=$ffd7afff;
TPalette256[224].DWords:=$ffd7d7ff;

TPalette256[225].DWords:=$ffd7ffff;
TPalette256[226].DWords:=$ffff00ff;
TPalette256[227].DWords:=$ffff5fff;
TPalette256[228].DWords:=$ffff87ff;
TPalette256[229].DWords:=$ffffafff;
TPalette256[230].DWords:=$ffffd7ff;


TPalette256[231].DWords:=$ffffffff;
TPalette256[232].DWords:=$080808ff;
TPalette256[233].DWords:=$121212ff;
TPalette256[234].DWords:=$1c1c1cff;
TPalette256[235].DWords:=$262626ff;
TPalette256[236].DWords:=$303030ff;
TPalette256[237].DWords:=$3a3a3aff;
TPalette256[238].DWords:=$444444ff;
TPalette256[239].DWords:=$4e4e4eff;
TPalette256[240].DWords:=$585858ff;
TPalette256[241].DWords:=$626262ff;
TPalette256[242].DWords:=$6c6c6cff;
TPalette256[243].DWords:=$767676ff;
TPalette256[244].DWords:=$808080ff;
TPalette256[245].DWords:=$8a8a8aff;
TPalette256[246].DWords:=$949494ff;
TPalette256[247].DWords:=$9e9e9eff;
TPalette256[248].DWords:=$a8a8a8ff;
TPalette256[249].DWords:=$b2b2b2ff;
TPalette256[250].DWords:=$bcbcbcff;
TPalette256[251].DWords:=$c6c6c6ff;
TPalette256[252].DWords:=$d0d0d0ff;
TPalette256[253].DWords:=$dadadaff;
TPalette256[254].DWords:=$e4e4e4ff;
TPalette256[255].DWords:=$eeeeeeff;

end;


//supply a filename like:
// yes, you should be using long file names
// PAL256C.dat or PAL256BW.dat

//(dont make me duplicate code to change two lines)

procedure Save256Palette(filename:string);

Var
	palette256File  : File of TRec256;
	i,num            : integer;

Begin

    //save us a lot of code and work
    initPalette256;
	Assign(palette256File, filename);
	ReWrite(palette256File);

  i:=0;
    repeat
 		Write(palette256File, TPalette256[i]); 
        inc(i);
	until i=15;	
	Close(palette256File);
	
End;


procedure Read256Palette(filename:string; ReadColor:boolean);

Var
	palette256File  : File of TRec256;
	i,num            : integer;
    palette: PSDL_Palette;
    MY_Palette:TSDL_Colors;

Begin
	Assign(palette256File, filename);
	ReSet(palette256File);
    Seek(palette256File, 0); //find first record


   if ReadColor=true then begin
        repeat
			Read(palette256File, TPalette256[i]); //read everything in
			inc(i);
		until i=255;
    end	else begin
        repeat
			Read(palette256File, TPalette256GRey[i]); 
			inc(i);
		until i=255;		
	end;    
	Close(palette256File);
	SDL_AllocPalette(256);    
	 
    if ReadColor=true then begin
		x:=0;
		repeat
	        MY_Palette[x]:=Tpalette256[x].colors;
			inc(x);
		until x=255;

//this is reverse of what we want(palette[x].whatever), and a PITA.
          SDL_SetPaletteColors(palette,MY_palette,0,256);

    end else begin
		x:=0;
		repeat
	        MY_Palette[x]:=Tpalette256Grey[x].colors;
			inc(x);
		until x=255;

          SDL_SetPaletteColors(palette,MY_Palette,0,256);
	end;
end;

//semi-generic color functions


function GetRGBfromIndex(index:byte):PSDL_Color; 
//if its indexed- we have the rgb definition already!!

var
   somecolor:PSDL_Color;
   
begin
  if bpp=8 then begin

    if MaxColors =16 then
	      somecolor:=Tpalette16[index].colors //literally get the SDL_color from the index
    else if MaxColors=256 then
	      somecolor:=Tpalette256[index].colors; 
    GetRGBFromIndex:=somecolor;
  end else begin
    if IsVTerm then
		writeln('Attempt to fetch RGB from non-Indexed color.Wrong routine called.');
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to fetch RGB from non-Indexed color.Wrong routine called.','OK',NIL); 
   
    exit;
  end;
end;

function GetDWordfromIndex(index:byte):DWord; 
//if its indexed- we have the rgb definition already!!

var
   somecolor:DWord;
   
begin
  if bpp=8 then begin
    if MaxColors =16 then
	      somecolor:=Tpalette16[index].DWords //literally get the DWord from the index
    else if MaxColors=256 then
	      somecolor:=Tpalette256[index].DWords; 
    
   GetDWordFromIndex:=somecolor;
  end else begin
      if IsVTerm then
	    	writeln('Attempt to fetch indexed DWord from non-indexed color');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to fetch indexed DWord from non-indexed color','OK',NIL); 
      exit;

  end;
end;



function GetRGBFromHex(input:DWord):PSDL_Color;
var
	i:integer;
    somedata:PSDL_Color; 
    r,g,b:PUInt8;

begin

  if bpp=8 then begin
   if (MaxColors=256) then begin
	   i:=0;
	   while (i<255) do begin
		    if (Tpalette256[i].dwords = input) then begin //did we find a match?
 			   GetRGBFromHex:=Tpalette256[i].colors;
               exit;
           
           end else
				inc(i);  //no
       end;
	  //error:no match found
      exit;

   end else if (MaxColors=16) then begin
	    i:=0;
	    while (i<15) do begin

		    if (Tpalette16[i].dwords = input) then begin//did we find a match?
               GetRGBFromHex:=Tpalette16[i].colors;
               exit;
            end else
				inc(i);  //no
       end;
	  //error:no match found
      exit;

   end;
  end else if (bpp >8) then begin
  
       if IsVTerm then begin
             writeln('Wrong routine called. Try: TrueColorGetRGBfromHex');
             writeln('Wrong routine called. Try: TrueColorGetRGBfromHex');
       end;
       SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Wrong routine called. Try: TrueColorGetRGBfromHex','OK',NIL); 
 end;
end;


//its either we hack this to hell- or reimplement MainSurface- the easier option.
//MainSurface^.PixelFormat is unknown-but assignable.
//for a texture-WHICH? there is no MAIN-TEXTURE.

function TrueColorGetRGBfromHex(somedata:DWord; Texture:PSDL_Texture):PSDL_Color;
//I need to know from which Texture- (pre RenderCopy) that you want to get the data from.
//the reason why is that we DONT KNOW the RGB values- in paletted mode- WE DO.
//(we need to query a Texture to do this.)
//but WHICH ONE?

var
	pitch,format,i:integer;
    someColor:PSDL_Color;
    r,g,b:PUINT8;
    pixelFormat:PSDL_PixelFormat;

begin

//always wise to lock-and unlock but w textures(I was trying to avoid a bug) theres more to it.
lock;

// Now you want to format the color to a correct format that SDL can use.
// Basically we convert our RGB color to a hex-like BGR color.
  SDL_GetRGB(somedata,MainSurface^.Format, R, G, B);

       somecolor^.r:=byte(^r);
       somecolor^.g:=byte(^g);
       somecolor^.b:=byte(^b);

// Also don't forget to unlock your texture once you're done.
UnLock;

   	   TrueColorGetRGBfromHex:=somecolor;
end;

function GetRGBAFromHex(input:DWord):PSDL_Color;
var
	i:integer;
    somecolor:PSDL_Color; 
    r,g,b,a:PUInt8;

begin
   if (bpp <=8) then begin
         if IsVTerm then
			writeln('Cant Get RGBA data from indexed colors.');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get RGBA data from indexed colors.','OK',NIL);
      exit; 
   end;

	   SDL_GetRGBA(input,MainSurface^.format,r,g,b,a);
       somecolor^.r:=byte(^r);
       somecolor^.g:=byte(^g);
       somecolor^.b:=byte(^b);
       somecolor^.a:=byte(^a);
   	   GetRGBAFromHex:=somecolor;
end;


//DWord in - Index out
function GetIndexFromHex(input:DWord):byte;

var
	r,g,b:PUInt8;
    color:PSDL_Color;
    i:integer;

begin
  if (MaxColors >256) then begin
       if IsVTerm then
			writeln('Cant Get color name from an RGB mode colors.');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
      exit; 
  end;

    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
   end;

  SDL_GetRGB(input,MainSurface^.format,r,g,b); //Get the RGB color from the DWord given
     color^.r:=byte(^r);
     color^.g:=byte(^g);
     color^.b:=byte(^b);

	if MaxColors=256 then begin
        i:=0;
		repeat
			if ((color^.r=Tpalette256[i].colors^.r) and (color^.g=Tpalette256[i].colors^.g) and (color^.b=Tpalette256[i].colors^.b)) then begin
				GetIndexFromHex:=i;
				exit;
			end;
		    inc(i);
		until i=255;
   //error:no match found
   //exit

	end else if MaxColors=16 then begin
        i:=0;
		
        repeat
  			if ((color^.r=Tpalette16[i].colors^.r) and (color^.g=Tpalette16[i].colors^.g) and (color^.b=Tpalette16[i].colors^.b)) then begin
				GetIndexFromHex:=i;
				exit;
  			end;
  			inc(i);
		until i=15;
	end;
  //error:no match found
  //exit

end;


//get the last color set

function GetFgRGB:PSDL_Color;
var
  color:PSDL_Color;
  r,g,b,a:PUInt8;


begin
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    color^.r:=byte(^r);
    color^.g:=byte(^g);
    color^.b:=byte(^b);
    color^.a:= $ff;
    GetFgRGB:=color; 
end;

function GetFgRGBA:PSDL_Color;

var
  color:PSDL_Color;
  r,g,b,a:PUInt8;


begin
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    color^.r:=byte(^r);
    color^.g:=byte(^g);
    color^.b:=byte(^b);
    color^.a:= byte(^a);
    GetFgRGBA:=color; 

end;


//returns the current color index
//BG is the tricky part- we need to have set something previously.

function GetBGColorIndex:byte;

var
   i:integer;

begin
     //assumes 16+ colors...aghhhh......
     if MaxColors=16 then begin
     i:=0;
        repeat
	        if TPalette16[i].dwords= _bgcolor then begin
		        GetBGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;
    end;
     
     if MaxColors=256 then begin
       i:=0; 
       repeat
	        if TPalette256[i].dwords= _bgcolor then begin
		        GetBGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 end else begin
		If IsVTerm then
			Writeln('Cant Get index from an RGB mode (or non-palette) colors.');
	    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get index from an RGB mode (or non-palette) colors.','OK',NIL);
		exit;
	 end;
end;


function GetFGColorIndex:byte;

var
   i:integer;
   someColor:PSDL_Color;
   r,g,b,a:PUInt8;

begin
    SDL_GetRenderDrawColor(renderer,r,g,b,a); //returns SDL color but we want a DWord of it
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);
    somecolor^.a:= $ff;
     
     if MaxColors=16 then begin
       i:=0;  
       repeat
	        if ((TPalette16[i].colors^.r=somecolor^.r) and (TPalette16[i].colors^.g=somecolor^.g) and (TPalette16[i].colors^.b=somecolor^.b))  then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;
     end;
     
     if MaxColors=256 then begin
       i:=0; 
       repeat
	        if ((TPalette256[i].colors^.r=somecolor^.r) and (TPalette256[i].colors^.g=somecolor^.g) and (TPalette256[i].colors^.b=somecolor^.b))  then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 end else begin
		If IsVTerm then
			Writeln('Cant Get index from an RGB mode colors.');

		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get index from an RGB mode colors.','OK',NIL);
		exit;
	 end;
end;

procedure MoveTo(X,Y:word);
//anything needing co-ordinates already adjusts this, update internal state tracker.
//obsolete code
begin
	Where^.X:=X;
	Where^.Y=Y;
end;

{
How to implement "turtle graphics":

on start( the end of initgraph): 

show a turtle in center of the screen as a "mouse cursor"
and give user option of "mouse"(pen) or keyboard for input(or assume it)


PenUp -(GotoXY and wait for PenDown to be called)
PenDown -(Line x,y from relx,rely and wait for penUp to be called)


are the only routines we need.

to exit:

InTurtleGraphics:=false;
SDL_RenderClear;

closeGraph when done.

However- this was before the era of the mouse and we can do better in SDL.

Create a "clickable canvas".

PenDown is DownMouseButton[x]
PenUp is UpMouseButton[x]

- (you are drawing with the mouse, not the keyboard.)
- this demo has been done.

(easily catchable in the event handler)

}


//"overloading" make things so much easier for us....

//sets pen color given an indexed input
procedure setFGColor(color:byte);
var
	colorToSet:PSDL_Color;
    r,g,b:PUInt8;
begin
//presumes to know too much....

   if MaxColors=256 then begin
        colorToSet:=Tpalette256[color].colors;
        SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
   end else if MaxColors=16 then begin
		colorToSet:=Tpalette16[color].colors;
        SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
   end;
end;


//sets pen color to given dword.
procedure setFGColor(someDword:dword); overload;
var
    r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin

//again- as with below-
//check bpp <=8 to see if we have the data already.


   SDL_GetRGB(someDword,MainSurface^.format,r,g,b); //now gimmie the RGB pair of that color
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);

   SDL_SetRenderDrawColor( Renderer, ord(somecolor^.r), ord(somecolor^.g), ord(somecolor^.b), 255 ); 
   
end;

//"words" are not Pointers to "Unsigned 8-bit ints".. some type conversion is needed here
procedure setFGColor(r,g,b:word); overload;

begin
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
end;

procedure setFGColor(r,g,b,a:word); overload;

begin
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), ord(a)); 
end;



//sets background color based on index
procedure setBGColor(index:byte);
var
	colorToSet:PSDL_Color;
//if we dont store the value- we cant fetch it later on when we need it.
begin

    if MaxColors=256 then begin
        colorToSet:=Tpalette256[index].colors;
        _bgcolor:=Tpalette256[index].dwords; //set here- fetch later
	    SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
	    SDL_RenderClear(Renderer);
   end else if MaxColors=16 then begin 
		colorToSet:=Tpalette16[index].colors;
        _bgcolor:=Tpalette256[index].dwords; //set here- fetch later
   	    SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
   	    SDL_RenderClear(Renderer);
   end;
end;

procedure setBGColor(someDword:DWord); overload;
var
    r,g,b:PUInt8;
	somecolor:PSDL_Color;

begin

    SDL_GetRGB(someDword,MainSurface^.format,r,g,b); //now gimmie the RGB pair of that color
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);

   _bgcolor:=someDword; //store the value
   SDL_SetRenderDrawColor( Renderer, ord(somecolor^.r), ord(somecolor^.g), ord(somecolor^.b), 255 ); 
   SDL_RenderClear(renderer);
end;

procedure setBGColor(r,g,b:word); overload;

//bgcolor here and rgba *MAY* not match our palette..be advised.

var
 color:PSDL_Color;

begin
   _bgcolor:=SDL_MapRGB(MainSurface^.format,color^.r,color^.g,color^.b);
   SDL_SetRenderDrawColor( Renderer, ord(color^.r), ord(color^.g), ord(color^.b), 255 ); 
   SDL_RenderClear(renderer);
end;

procedure setBGColor(r,g,b,a:word); overload;

var
  color:PSDL_Color;

begin
   _bgcolor:=SDL_MapRGBA(MainSurface^.format,color^.r,color^.g,color^.b,color^.a);
   SDL_SetRenderDrawColor( Renderer, ord(color^.r), ord(color^.g), ord(color^.b), ord(color^.a)); 
   SDL_RenderClear(renderer);
end;


// ColorNameToNum(ColorName : string) : integer;
//isnt needed anymore because enums carry a number for the defined "NAME".


//remember: _fgcolor and _bgcolor are DWord(s).

function GetFgDWordRGBA:DWord;

var
  somecolor:PSDL_Color;
  r,g,b,a:PUint8;

begin
    if (bpp < 8) then begin
        //error: not indexed color
        exit; //rgba not supported
    end;
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);
    somecolor^.a:=byte(^a);

    GetFgDWordRGBA:=SDL_MapRGBA(MainSurface^.format,somecolor^.r,somecolor^.g,somecolor^.b,somecolor^.a); //gimmie the DWord instead
end;

//doesnt make sence w using _bgcolor as a DWord
//only makes sense if you are using RGB or RGBA "tuples" instead of a Dword but wanted a DWord.
//has a use but its limited.

function GetBgDWordRGB(r,g,b:byte):DWord;

begin
//really rare case
    if (MaxColors<=255) then exit; //use the other function for this
       if IsVTerm then begin
          writeln('Trying to fetch background color -when we have it- in Paletted mode.');
          writeln('We have the background color in paletted modes!');
          exit;
       end;
       SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'We already have the Background Color in Paletted mode.','OK',NIL);

    GetBgDWordRGB:=SDL_MapRGB(MainSurface^.format,ord(r),ord(g),ord(b));    
end;

function GetBgDWordRGBA(r,g,b,a:byte):DWord;
begin
    GetBgDWordRGBA:=SDL_MapRGBA(MainSurface^.format,ord(r),ord(g),ord(b),ord(a)); //gimmie the DWord instead
end;

procedure invertColors;

//so you see how to do manual shifting etc.. 
var
   r, g, b, a:PUInt8;
   somecolor:PSDL_Color;
begin

	SDL_GetRenderDrawColor(renderer, r, g, b, a);

    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);
    somecolor^.a:=byte(^a);

	SDL_SetRenderDrawColor(renderer, 255 - somecolor^.r, 255 - somecolor^.g, 255 - somecolor^.b, somecolor^.a); 

end;


{

DO NOT BLINDLY ALLOW any function to be called arbitrarily.(this was done in C- I removed the checks for a short while)

two exceptions:

making a 16 or 256 palette and/or modelist file

NET:

	init and teardown need to be added here- I havent gotten to that.

}

//this was ported from (SDL) C- 
//https://stackoverflow.com/questions/37978149/sdl1-sdl2-resolution-list-building-with-a-custom-screen-mode-class

//(its a VESA/VGA equivalent for SDL)
//checking supported is in another routine(DetectGraph)

function FetchModeList:Tmodelist;
var
    mode_index,modes_count ,display_index,display_count:integer;
    i:integer;


begin
   display_count := SDL_GetNumVideoDisplays; //1->display0
   writeln('Number of displays: '+ intTOstr(display_count));
   display_index := 0;

//for each monitor do..
while  (display_index <= display_count) do begin
    writeln('Display: '+intTOstr(display_index));

    modes_count := SDL_GetNumDisplayModes(display_index); //max number of supported modes
    mode_index:= 0;
    i:=0;

    //do for each mode in the number of possible modes
    while ( mode_index <= modes_count ) do begin

        SDLmodePointer^.format:= SDL_PIXELFORMAT_UNKNOWN;
        SDLmodePointer^.w:= 0;
        SDLmodePointer^.h:= 0;
        SDLmodePointer^.refresh_rate:= 0;
        SDLmodePointer^.driverdata:= Nil;


        if (SDL_GetDisplayMode(display_index, mode_index, SDLmodePointer) = 0) then begin //mode supported

            //Log: pixelFormat(bpp)MaxX,MaXy,refrsh_rate            
            writeln(IntToStr(SDL_BITSPERPIXEL(SDLmodePointer^.format))+' bpp'+ IntToStr(SDLmodePointer^.w)+ ' x '+IntToStr(SDLmodePointer^.h)+ '@ '+IntToStr(SDLmodePointer^.refresh_rate)+' Hz ');

            //store data in a modeList array

                SDLmodeArray[i].format:=SDL_BITSPERPIXEL(SDLmodePointer^.format);            
                SDLmodeArray[i].w:=SDLmodePointer^.w;                
                SDLmodeArray[i].h:=SDLmodePointer^.h;                
                SDLmodeArray[i].refresh_rate:=SDLmodePointer^.refresh_rate;                
                SDLmodeArray[i].driverdata:=SDLmodePointer^.driverdata;

        end;
        inc(i);
        inc(mode_index);
    end;
    inc(display_index);
    
end;

end;

{

Graphics detection is a wonky process.
1- fetch (or find) whats supported
2- find highest mode in that list
3- use it, or try to.

repeat num 2 and 3 if you fail- until no modes work


I was THIS mode, and none other- it had better be supported (but is it?)
(try or fail)


Although generally in SDL(and on hardware) smaller windows and color depths are supported(emulation),
SDL -by itself- might not support that mode.


Do we care- as mostly we are setting windows sizes? Not usually.
WE could care less if the data is scaled on fullsceen-since we arent responsible for the scaling

(whether things look good- is another matter)

A TON of old code was written when pixels were actually visible. NOT THE CASE, anymore.


DetectGraph is here more for compatibility than anything else.
It seems to be used as often as DEFINED modes.

-Custom modes are usually hackish and were removed.

Interrupt handling:

The reason this is remmed out is bc I want YOu to do this.
The code is however-reasonable- but untested.


}


procedure IntHandler;
//This is a dummy routine. Im only giving you the basics. SOMETHING HAS TO BE HERE.
//I want you- Users/programmers to override this routine and DO THINGS RIGHT.
// EXPORT the EVENT, then you can do that.

begin

  while true do begin //mainloop -should never exit

  if (SDL_PollEvent(event) = 1) then begin
      
      case event^.type_ of
 
               //keyboard events
        SDL_KEYDOWN: begin
			case event^.key.keysym.sym of
				//ESC always exits				
				SDLK_ESCAPE:begin
					quit:=true;                                
                    break;
				end;
			end;	
        end;

	    SDL_MOUSEBUTTONDOWN: begin
	    end;
        
        SDL_WINDOWEVENT: begin
                           
                           case event^.window.event of
                             SDL_WINDOWEVENT_MINIMIZED: minimized:=true; //pause
                             SDL_WINDOWEVENT_MAXIMIZED: minimized:=false; //resume
                             SDL_WINDOWEVENT_ENTER: begin
                                   //hidemouse
                             end; 
                             SDL_WINDOWEVENT_LEAVE: begin
                                   //showmouse
                             end;

                             SDL_WINDOWEVENT_SHOWN: begin
								//redraw window
								SDL_RenderPresent(renderer);
                             end;
                             
							//we got overlapped by something, redraw the window(PageFlip again).
                             SDL_WINDOWEVENT_EXPOSED: begin
								//redraw window
								SDL_RenderPresent(renderer);
								
                             end;
                             
                             SDL_WINDOWEVENT_CLOSE: begin
                                quit:=true;                                
                                break;
                             end;
                           end; //case
        end; //subcase
                    
      end;  //case

   end; //input loop
   // writeln('event handled: ',event^.type_);
  end; //mainloop
  closegraph;
end;

// from wikipedia(untested)
procedure RoughSteinbergDither(filename,filename2:string);

var
	pixel:array[0..1280,0..1024] of DWord;
	oldpixel,newpixel,quant_error:DWord;
	file1,file2:file;
    Buf : Array[1..4096] of byte;
    

begin
    assign(file1,filename); 
    assign(file2,filename2); 
  
    blockread(file1,buf,sizeof(file));

  while Y<MaxY do begin
	 while x<MaxX do begin

      oldpixel  := pixel[x,y];
      newpixel  := round(oldpixel mod 256);
      pixel[x,y]  := newpixel;
      quant_error  := oldpixel - newpixel;

      pixel[x + 1,y]:= longword(pixel[x + 1,y] + quant_error * 7 mod 16);
      pixel[x - 1,y + 1] := longword(pixel[x - 1,y + 1] + quant_error * 3 mod 16);
      pixel[x,y + 1] := longword(pixel[x,y + 1] + quant_error * 5 mod 16);
      pixel[x + 1,y + 1] := longword(pixel[x + 1,y + 1] + quant_error * 1 mod 16);

    end;
   end;
     blockwrite(file2,buf,sizeof(file));

     close(file1);
	 close(file2);
end;


{

Got weird fucked up c boolean evals? (JEEZ theyre a BITCH to understand....)
  wonky "what ? (eh vs uh) : something" ===>if (evaluation) then (= to this) else (equal to that)
(usually a boolean eval with a byte input- an overflow disaster waiting to happen)

such oddly is the case with xlib for X11. The boolean gives a negative false, not zero and one.
(Thats a disaster waiting to happen)
}

//basic Dword <-> SDL_Color conversion

//to get the longword
function RGBAToDWord(somecolor:PSDL_Color):DWord;
var
    someDword:DWord;

begin
    someDWord := (somecolor^.R or somecolor^.G or somecolor^.B or somecolor^.A);
    RGBAToDWord:=someDWord;
end;

//to break down into components using RGBA mask(ARGB is backwards mask)
function DWordToRGBA(someword:DWord):PSDL_Color;

var
    somecolor: PSDL_Color;
begin
    //if not mswindows (this is rgba), if so - flip to ARGB instead

    somecolor^.R := (someword and $FF000000);
    somecolor^.G := ((someword and $00FF0000) shr 8);
    somecolor^.B := ((someword  and $0000FF00) shr 16);
    somecolor^.A := ((someword and $000000FF) shr 24);
    DWordToRGBA:=somecolor;
end;


{
Create a new texture for most ops-

RenderPresent is being called automatically at minimum (screen_refresh) as an interval.
        If not ready(deltas..use deltas...) then set RenderingDone to false.

Refreshing the screen is fine- if data is in the backbuffer. 
Until its copied into the main buffer- its never displayed.

HOWEVER--
        DO NOT OVER RENDER. It will crash the best of systems.
    
DirectRender based ops- DO NOT NEED TEXTURES.


which surface/texture do we lock/unlock??
solve for X -by providing it. 
-dont beat your own brains out nuking the problem.

}

//FIXME:
//All SDL calls are unpredictable unless vars are Nil before checks are made.
//(This is secure code way of doing things)

procedure lock;
begin
    if SDL_MustLock(MainSurface)=true then
        SDL_LockSurface(Mainsurface);
    //else exit: no locking needed
end;


procedure unlock;
begin
    if SDL_MustLock(MainSurface)=true then
           SDL_UnlockSurface(Mainsurface);
    //else exit: no UNlocking needed
end;

//depending on how you call or if "MainSurface" isnt what you want.
procedure lock(someSurface:PSDL_Surface); overload;
begin
    if SDL_MustLock(someSurface)=true then
        SDL_LockSurface(someSurface);
    //else exit: no locking needed
end;


procedure unlock(someSurface:PSDL_Surface); overload;
begin
    if SDL_MustLock(someSurface)=true then
           SDL_UnlockSurface(someSurface);
    //else exit: no UNlocking needed
end;


procedure Texlock(Tex:PSDL_Texture);

var
  pitch:PInt;
  pixels:pointer;

begin
  pixels:=Nil;
  pitch^:=0;
  if (LIBGRAPHICS_ACTIVE=false) then begin
    writeln('I cant lock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
  if (Tex = Nil) then begin
     if IsVTerm then
		writeln('Cannot Lock unassigned Texture.');
        writeln('Cant Lock unassigned Texture');
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cannot Lock an unassigned Texture.','OK',NIL);
     exit;
  end;
//  SDL_QueryTexture(tex, format, Nil, w, h);
  SDL_SetRenderTarget(renderer, tex);

{$IFDEF mswindows}
  SDL_LockTexture(tex,Nil,pixels,pitch);
{$ENDIF}

end;

procedure TexlockwRect(Tex:PSDL_Texture; Rect:PSDL_Rect);

var

  pitch:PInt;
  pixels:pointer;

begin
  if (LIBGRAPHICS_ACTIVE=false) then begin
    writeln('I cant lock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
  if (Tex = Nil) then begin
     if IsVTerm then
		writeln('Cannot Lock unassigned Texture.');
        writeln('Cant Lock unassigned Texture');
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cannot Lock an unassigned Texture.','OK',NIL);
     exit;
  end;
//  SDL_QueryTexture(tex, format, rect, w, h);
  SDL_SetRenderTarget(renderer, tex);
{$IFDEF mswindows}
  SDL_LockTexture(tex,Nil,pixels,pitch);
{$ENDIF}
end;

function lockNewTexture:PSDL_Texture;

var
  tex:PSDL_Texture;
  pixels:pointer;
  pitch:PInt;

begin
  if (LIBGRAPHICS_ACTIVE=false) then begin
    writeln('I cant lock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
//case bpp of... sets PixelFormat(forcibly)

  tex:=Nil; //if we dont clear it before calling, results are unpredictable.
  tex:= SDL_CreateTexture(renderer, format, SDL_TEXTUREACCESS_TARGET, MaxX, MaxY);
  if (tex = Nil) then begin
     if IsVTerm then
		writeln('Cannot Alloc Texture.');
        writeln('Cant Alloc Texture');
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cannot Alloc Texture.','OK',NIL);
     exit;
  end;
//  SDL_QueryTexture(tex, format, Nil, w, h);
  SDL_SetRenderTarget(renderer, tex);

{$IFDEF mswindows}
  SDL_LockTexture(tex,Nil,pixels,pitch);
{$ENDIF}

  lockNewTexture:=Tex; //kick it back
end;

//call when done drawing pixels
procedure TexUnlock(Tex:PSDL_Texture);

begin

  if (LIBGRAPHICS_ACTIVE=false) then begin
    writeln('I cant unlock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
{$IFDEF mswindows}
    //we are done playing with pixels so....
    SDL_UnLockTexture(tex);
{$ENDIF}

//get stuff ready for the renderer and render.
  SDL_SetRenderTarget(renderer, NiL);
  SDL_RenderCopy(renderer, tex, NiL, NiL);
  SDL_DestroyTexture(tex); 

end;

//BGI spec
procedure clearDevice;

begin
    SDL_RenderClear(renderer);
end;

procedure clearscreen; 
//this is an alias routine

begin
    if LIBGRAPHICS_ACTIVE=true then
        clearDevice
    else //use crt unit
        clrscr;
end;



//all of these need to be rewritten-syn tax has been paid- calling convention is incorrect.
procedure clearscreen(index:byte); overload;

var
	r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin
    if MaxColors>256 then begin
        if IsVTerm then
           writeln('ERROR: i cant do that. not indexed.');
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempting to clearscreen(index) with non-indexed data.','OK',NIL);   
        writeln('Attempting to clearscreen(index) with non-indexed data.');           
        exit; 
    end;
    if MaxColors=16 then
       somecolor:=Tpalette16[index].colors;
    
    if MaxColors=256 then
       somecolor:=Tpalette256[index].colors;


    SDL_SetRenderDrawColor(Renderer,ord(somecolor^.r),ord(somecolor^.g),ord(somecolor^.b),255);
	SDL_RenderClear(renderer);
end;


procedure clearscreen(color:Dword); overload;

var
    somecolor:PSDL_Color;
    someDword:DWord;
    r,g,b:PUInt8;
    i:integer;

begin

//the only easy way is thru paletted mode due "to the renderer"
//we might just need the pixel format type....

	if bpp =4 then begin
	    //get index from DWord- if it matches
        i:=0;
        repeat
            if color=Tpalette16[i].DWords then begin;
                somecolor:=Tpalette16[i].colors;
                exit; 
            end;
            inc(i);
        until i=15;		
	end else
	if bpp =8 then begin
	    //get index from DWord- if it matches
        i:=0;
        repeat
            if color=Tpalette256[i].DWords then begin;
                somecolor:=Tpalette256[i].colors;
                exit; 
            end;
            inc(i);
        until i=255;		
	end;
	
	case bpp of
        15,16,24,32: begin
	    	SDL_GetRGB(color,MainSurface^.format,r,g,b);
	    	somecolor^.r:=byte(^r);
	    	somecolor^.g:=byte(^g);
		    somecolor^.b:=byte(^b);	
	    end;
    end;
    SDL_SetRenderDrawColor(Renderer,ord(somecolor^.r),ord(somecolor^.g),ord(somecolor^.b),255);
	SDL_RenderClear(renderer);
end;

//these two dont need conversion of the data
procedure clearscreen(r,g,b:byte); overload;


begin
	SDL_SetRenderDrawColor(Renderer,ord(r),ord(g),ord(b),255);
	SDL_RenderClear(renderer);
end;


procedure clearscreen(r,g,b,a:byte); overload;

begin
	SDL_SetRenderDrawColor(Renderer,ord(r),ord(g),ord(b),ord(a));
	SDL_RenderClear(renderer);
end;

//end hack


//This hack was for SDLv1 tracking, not needed with SDLv2.


//this is for dividing up the screen or dialogs (in game or in app)

//spec says clear the last one assigned
procedure clearviewport;

//clears it, doesnt remove or add a "layered window".
//usually the last viewport set..not necessary the whole "screen"
var
  viewport:PSDL_Rect;

begin
   viewport^.X:= texBounds[windownumber]^.x;
   viewport^.Y:= texBounds[windownumber]^.y;
   viewport^.W:= texBounds[windownumber]^.w;
   viewport^.H:= texBounds[windownumber]^.h;
//fill with current color?
   SDL_RenderFillRect(Renderer, viewport);
end;


function videoCallback(interval: Uint32; param: pointer): Uint32; cdecl; 
//this is a funky interrupt-ish callback in C. Its very specific code.
//that said, IO is pushed, then popped -from CPU registers in weird ways- why this is so specific.

//we dont always need the input params, nor the interval- its already assigned before we are called.
//(but it has to be given to us)

var
    TimerTicks:Longword;

begin
   param:=Nil; //not used
   
   if (not Paused) then begin //if paused then ignore screen updates
           SDL_RenderPresent(Renderer);
   end;
  
   videoCallback := interval; //we have to return something-the what, WE should be defining.
end;


//NEW: do you want fullscreen or not?
function initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean):PSDL_renderer;

{

we are halfway there according to some Wolf3D and POSTAL devs:
FS sets logical size but we want the window- a forced "physical" to be that size too.
Logic size allows upscaling of smaller resolutions on our behalf.

}
var
	i:integer;
	_initflag,_imgflags:longword; //PSDL_Flags?? no such beast 
    iconpath:string;
    imagesON,FetchGraphMode:integer;
	mode:PSDL_DisplayMode;
  //  AudioSystemCheck:integer;

begin

  if LIBGRAPHICS_ACTIVE then begin
    if IsVTerm then begin
        writeln('Graphics already active.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Initgraph: Graphics already active.','OK',NIL);	
    exit;
  end;
  pathToDriver:='';  //unused- code compatibility
//  iconpath:='./sdlbgi.bmp'; sdl2.0 doesnt use this.

  case(graphmode) of

{
         we have full frame LFB now- planar storage doesnt make sense, is very bit-wise...
         -and very hard to do animations with.

         bitshifting is significantly faster than math operations, however. Not everyone took this into account.

         SDL becomes slow on put/getpixel ops due to repeated "one shot" operations instead of batches(buffered ops/surfaces)
         each get/putPixel operation *may* have to shift colors- AND was slowed down further by a (now removed) Pixel Mask(BGI).
		 (this was supposed to be only for lines and pen strokes)

         Hardware surfaces add wait times during copy operations between graphics hardware and CPU memory.
         ** SDL1 MAY NOT SUPPORT HW Surfaces on newer hardware**
         
         Despite the GPU being several orders (10x?) of magnitude faster than the CPU,GPU ops must also be "byte aligned".
         -In this case, 32 bits.

         How 24bit is natively supported, nobody will ever know. Probably like I do 15bit modes.

         Despite rumors- 
                CGA is 4COLOR, 4Mode Graphics. 16 color mode is "extremely low resolution" on CGA systems.
                EGA and VGA use 16 color modes.

        You probably remember some text mode hack- or use of text mode symbols, like MegaZuex (openmzx) uses.

		bpp is always set to 8 on lower bitdepths, MaxColors variable checks the actual depth(SDL bug workaround).
		SDL supports these "LSB modes" but wont allow get/putpixel ops in these modes(why?).
}

		//standardize these as much as possible....

		//lo-res modes-try using SDL_SOFTSTRETCH()
		
		//CGALo
		m160x100x16:begin
            MaxX:=160;
			MaxY:=100;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;
		    //some of these its weird, 4x3 unless otherwise specified	
            XAspect:=4;
            YAspect:=3; 		
		end;
		
		//CGAMed - there are 4 viable palettes in this mode
		m320x200x4:begin
		    MaxX:=320;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=4;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;	
			
		//CGAHi
		m640x200x2:begin
		    MaxX:=640;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=2;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		//EGA
		m320x200x16:begin
		    MaxX:=320;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 		
		end;		
		
		//VGALo
		m320x200x256:begin
			MaxX:=320;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;
		
		//EGAHi (or VGAMed)
		m640x200x16:begin
			MaxX:=640;
			MaxY:=200;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 		
		end;		

		//end lo-res modes
		
		//VGAHi
		m640x480x16:begin
			MaxX:=640;
			MaxY:=480;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m640x480x256:begin
		    MaxX:=800;
			MaxY:=600;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m640x480x32k:begin
		    MaxX:=640;
			MaxY:=480;
			bpp:=15; 
			MaxColors:=32768;
            NonPalette:=True;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m640x480x64k:begin
		    MaxX:=640;
			MaxY:=480;
			bpp:=16; 
			MaxColors:=65535;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m640x480xMil:begin
		    MaxX:=640;
			MaxY:=480;
			bpp:=24; 
			MaxColors:=0; //no op
            NonPalette:=True;
		    TrueColor:=True;	
            XAspect:=4;
            YAspect:=3; 
		end;

		//SVGA (and VESA modes)
		m800x600x16:begin
            MaxX:=800;
			MaxY:=600;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m800x600x256:begin
            MaxX:=800;
			MaxY:=600;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;


		m800x600x32k:begin
           MaxX:=800;
		   MaxY:=600;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 
		end;
		m800x600xMil:begin
           MaxX:=800;
		   MaxY:=600;
		   bpp:=24; 
		   MaxColors:=0;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=4;
           YAspect:=3; 		
		end;

		m1024x768x16:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=8; 
		   MaxColors:=16;
           NonPalette:=false;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 				
		end;

		m1024x768x256:begin
            MaxX:=1024;
			MaxY:=768;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		m1024x768x32k:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1024x768x64k:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 
		end;

		m1024x768xMil:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=24; 
		   MaxColors:=0;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=4;
           YAspect:=3; 
		end;


		m1280x720x256:begin
            MaxX:=1280;
			MaxY:=720;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=9; 

		end;

		m1280x720x32k:begin
          MaxX:=1280;
		   MaxY:=720;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1280x720x64k:begin
           MaxX:=1280;
		   MaxY:=720;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1280x720xMil:begin
		   MaxX:=1280;
		   MaxY:=720;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1280x1024x16:begin
			MaxX:=1280;
			MaxY:=1024;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

		m1280x1024x256:begin
            MaxX:=1280;
			MaxY:=1024;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		m1280x1024x32k:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1280x1024x64k:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1280x1024xMil:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1366x768x256:begin
            MaxX:=1366;
			MaxY:=768;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=9; 

		end;

		m1366x768x32k:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1366x768x64k:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1366x768xMil:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1920x1080x256:begin
            MaxX:=1920;
			MaxY:=1080;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=9; 

		end;

		m1920x1080x32k:begin
		   MaxX:=1920;
		   MaxY:=1080;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1920x1080x64k:begin
		   MaxX:=1920;
		   MaxY:=1080;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1920x1080xMil:begin  
 	       MaxX:=1920;
		   MaxY:=1080;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;
	    
  end;{case}

//once is enough with this list...its more of a nightmare than you know.

{
If this 'chunk' isnt set- our output probably isnt accelerated as we would like it...
Thanks, folks, for not pointing this out....
There are claims that DX and HW Surfaces arent worth the headache- I say:
		Stop being a lazy fuck- and optimise your code.

Although I may not know these low-level APIs, someone in the SDL community seems to.
Lets use WHAT WE WANT, DAMNIT.
}

{
//bugged- or was Lazarus just giving me hell?

IFDEF mswindows
	_putenv('SDL_VIDEODRIVER=directx'); //Use DirectX, dont use GDI
	_putenv('SDL_AUDIODRIVER=dsound'); //Fuck it, use direct sound, too.
ENDIF
}

{$IFDEF darwin}
	_putenv('SDL_VIDEODRIVER=quartz'); //Quartz2D
	_putenv('SDL_AUDIODRIVER=coreaudio'); //The new OSX Audio Subsystem
{$ENDIF}

{$ifdef unix}
  if (GetEnvironmentVariable('DISPLAY') = '') then begin //X11 is not active
       //Were in a TTY, NO x11...
	   _putenv('SDL_VIDEODRIVER=svgalib'); //svgalib on FB (FPC has working-albeit tiny- Graphics unit for this.)
		
		//uses: libao
	   _putenv('SDL_AUDIODRIVER=alsa'); //Guessing here- should be available.        
  end;
  //We are running X11
	   _putenv('SDL_VIDEODRIVER=x11');
	   _putenv('SDL_AUDIODRIVER=pulse'); 
{$endif}

//Note this does not use OpenGL on purpose. You can still get 2D acceleration.


   //"usermode" must match available resolutions etc etc etc
   //this is why I removed all of that code..."define what exactly"??

  //attempt to trigger SDL...on most sytems this takes a split second- and succeeds.
  _initflag:= SDL_INIT_VIDEO or SDL_INIT_TIMER;

  if WantsAudioToo then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER; 
  if WantsJoyPad then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_JOYSTICK;
//if WantInet then SDL_Init_Net;


  if ( SDL_Init(_initflag) < 0 ) then begin
     //we cant speak- write something down.

        logln('Critical ERROR: Cant Init SDL for some reason.');
        logln(SDL_GetError);

        //if we cant init- dont bother with dialogs.

     _grResult:=GenError; //gen error
     halt(0); //the other routines are now useless- since we didnt init- dont just exit the routine, DIE instead.

  end;
 
{
  if wantsFullIMGSupport then begin

    _imgflags:= IMG_INIT_JPG or IMG_INIT_PNG or IMG_INIT_TIF;
    imagesON:=IMG_Init(_imgflags);

    //not critical, as we have bmp support but now are limping very very bad...
    if((imagesON and _imgflags) <> _imgflags) then begin
       if IsVTerm then begin
		 logln('IMG_Init: Failed to init required JPG, PNG, and TIFF support!');
		 logln(IMG_GetError);
	   end;
	   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'IMG_Init: Failed to init required JPG, PNG, and TIFF support','OK',NIL);	
    end;
  end;
}

{
 im going to skip the RAM requirements code and instead haarp on proper rendering requirements.
 note that a 12 yr old notebook-try as it may- might not have enough vRAM to pull things off.
 can you squeeze the code to fit into a 486??---you are pushing it.
(You are better off using SDLv1 instead)

now- how do we check if sdl2 is supported- and fall back, given uses clauses can only launch one or the other?
}

  if (graphdriver = DETECT) then begin
	//probe for it, dumbass...NEVER ASSUME.

//temporarily not available- SDL1 is working, v2 needs some help.
	   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Graphics detrection not available at this time.','Sorry',NIL);	

//    Fetchgraphmode := DetectGraph; //need to kick back the higest supported mode...
  end;

  NoGoAutoRefresh:=false;
  LIBGRAPHICS_INIT:=true; 
  LIBGRAPHICS_ACTIVE:=false; 

//we do it this way because we might already be active- why duplicate code?

//sets up mode- then clears it in standard "BGI" fashion.
  SetGraphMode(Graphmode,wantFullScreen);
 
  
//no atexit handler needed, just call CloseGraph
//that was a nasty SDL surprise...

{ here is how to set one up:
basically it prevents random exits- all exits must call whatever is in the routine,
in this case closegraph BEFORE leaving.

(You are a hung process if you dont leave at all)
This ports -via the compiler- to some whacky assembler far calls.(hence the F)

 OldExitProc := ExitProc;                - save previous exit proc -cpu: push exit()
  ExitProc := @MyExitProc;               - insert our exit proc in chain 

$F+
procedure MyExitProc;
begin
  ExitProc := OldExitProc;  Restore exit procedure address -cpu: pop exit()
  CloseGraph;               Shut down the graphics system 
end; 
$F-

}

  
//lets get the current refresh rate and set a screen timer to it.
// we cant fetch this from X11? sure we can.
{

  mode^.format := SDL_PIXELFORMAT_UNKNOWN;
  mode^.w:=0;
  mode^.h:=0;
  mode^.refresh_rate:=0;
  mode^.driverdata:=Nil;
  //for physical screen 0 do..
  
  //The SDl equivalent error of: attempting to probe VideoModeInfo block when (VESA) isnt initd results in issues....

  if(SDL_GetDisplayMode(0,0, mode) <> 0) then begin
    if IsVTerm then
			logln('Cant get current video mode info. Non-critical error.');
//    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SDL cant get the data for the current mode.','OK',NIL);
  end;


  //dont refresh faster than the screen.
  if (mode^.refresh_rate > 0)  then 
     //either force a longINT- or convert from REAL. Otherwise you have to pass it as a interrupt proc param--it hairy mess.
     flip_timer_ms := longint(mode^.refresh_rate)
  else
     flip_timer_ms := 17; 


  video_timer_id := SDL_AddTimer(flip_timer_ms, @videoCallback, nil);
  if video_timer_id=0 then begin
    if IsVTerm then begin
		logln('WARNING: cannot set drawing to video refresh rate. Non-critical error.');
		logln('you will have to manually update surfaces and the renderer.');
    end;
//    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SDL cant set video callback timer.Manually update surface.','OK',NIL);
    NoGoAutoRefresh:=true; //Now we can call Initgraph and check, even if quietly(game) If we need to issue RenderPresent calls.
  end;
}
  
  CantDoAudio:=false;
    //prepare mixer
{
  if WantsAudioToo then begin
//    audioFlags:=(MIX_INIT_FLAC or MIX_INIT_MP3 or MIX_INIT_OGG); //unless you need mikmod support, then or it in here.
//    Mix_Init(AudioFlags);
    AudioSystemCheck:=Mix_OpenAudio(44100,MIX_DEFAULT_FORMAT,2, 4096); //cd audio quality
    //(slower systems use smaller chunks and degraded quality.)
    if AudioSystemCheck <> 0 then begin
        if IsVTerm then
                logln('There is no audio. Mixer did not init.')
        else  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'There is no audio. Mixer did not init.','OK',NIL);
    end;

  end;}

  //initialization of TrueType font engine
  if TTF_Init = -1 then begin
    
    if IsVTerm then begin
        logln('I cant engage the font engine, sirs.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: I cant engage the font engine, sirs. ','OK',NIL);
		
    _graphResult:=-3; //the most likely cause, not enuf ram.
    closegraph;
  end;

//set some sane default variables
  _fgcolor := $FFFFFFFF;	//Default drawing color = white (15)
  _bgcolor := $000000FF;	//default background = black(0)
  someLineType:= NormalWidth; 


  LIBGRAPHICS_ACTIVE:=true;  //We are fully operational now.
  paused:=false;

  _grResult:=OK; //we can just check the dialogs (or text output) now.

  where.X:=0;
  where.Y:=0;


//set some sensible input specs
  //SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);

{
  //Check for joysticks 
  if WantsJoyPad then begin
 
    if( SDL_NumJoysticks < 1 ) then begin
        if IsVTerm then
			logln( 'Warning: No joysticks connected!' ); 
        
  		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Warning: No joysticks connected!','OK',NIL);
        
    end else begin //Load joystick 
	    gGameController := SDL_JoystickOpen( 0 ); 
    
        if( gGameController = NiL ) then begin  
	        if IsVTerm then begin
		    	logln( 'Warning: Unable to open game controller! SDL Error: '+ SDL_GetError); 
                logln(SDL_GetError);
            end;
            SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Warning: Unable to open game controller!','OK',NIL);
            noJoy:=true;
        end;
        noJoy:=false;
    end; 
  end; //Joypad 
}

 //DEBUG: logln(longword(@renderer));


  InitGraph:=renderer;
end; //initgraph


//these two are not, by themselves "feature coplete dialogs", nor do they check input.
//mimcs crt level double lined "thingy" chars

procedure DrawDoubleLinedWindowDialog(Rect:PSDL_Rect);
//I could use SDL_drawRects, but its only two..

var
    UL,UR,LR:Points; //PolyPts
    ShrunkenRect,ShrunkenRect2,NewRect:PSDL_Rect;

begin
    SDL_RenderSetViewPort(Renderer,Rect);

    //this is guesstimate math here, not actual.
    //the corner co ords
    
    //come in by 2px, drawRect, come in by 2px, drawrect, come in by 2px- setViewport (I trapped you twice in a box..)
    UL.x:=Rect^.x+2;
    UL.y:=Rect^.y+2;
    UR.x:=Rect^.w-2;
    LR.y:=Rect^.h-2;    
    NewRect^.x:=UL.x;
    NewRect^.y:=UL.y;
    NewRect^.w:=UR.x;
    NewRect^.h:=LR.y; //same in rect format
    //SDL_SetRenderDrawColor(_fgcolor);
    SDL_RenderDrawRect(Renderer,NewRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)

    //shink available space and...
    //do this again- further in
    UL.x:=Rect^.x+4;
    UL.y:=Rect^.y+4;
    UR.x:=Rect^.w-4;
    LR.y:=Rect^.h-4;
    ShrunkenRect^.x:=UL.x;
    ShrunkenRect^.y:=UL.y;
    ShrunkenRect^.w:=UR.x;
    ShrunkenRect^.h:=LR.y; //same in rect format
    SDL_RenderDrawRect(Renderer,ShrunkenRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)

    UL.x:=Rect^.x+6;
    UL.y:=Rect^.y+6;
    UR.x:=Rect^.w-6;
    LR.y:=Rect^.h-6;
    ShrunkenRect2^.x:=UL.x;
    ShrunkenRect2^.y:=UL.y;
    ShrunkenRect2^.w:=UR.x;
    ShrunkenRect2^.h:=LR.y; //same in rect format
    SDL_RenderSetViewPort(Renderer,ShrunkenRect2);

end;

procedure DrawSingleLinedWindowDialog(Rect:PSDL_Rect);

var
    UL,UR,LR:Points; //see header file(polypts is ok here)
    ShrunkenRect,NewRect:PSDL_Rect;

begin
    SDL_RenderSetViewPort(Renderer,Rect);

    //corect me if Im off- this is guesstimate math here, not actual.
    //the corner co ords
    UL.x:=Rect^.x+2;
    UL.y:=Rect^.y+2;
    UR.x:=Rect^.w-2;
    LR.y:=Rect^.h-2;
    NewRect^.x:=UL.x;
    NewRect^.y:=UL.y;
    NewRect^.w:=UR.x;
    NewRect^.h:=LR.y; //same in rect format
    //SDL_SetRenderDrawColor(_fgcolor);
    SDL_RenderDrawRect(Renderer,NewRect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)
    
    //do this again- further in
    UL.x:=Rect^.x+4;
    UL.y:=Rect^.y+4;
    UR.x:=Rect^.w-4;
    LR.y:=Rect^.h-4;
    ShrunkenRect^.x:=UL.x;
    ShrunkenRect^.y:=UL.y;
    ShrunkenRect^.w:=UR.x;
    ShrunkenRect^.h:=LR.y; //same in rect format
    SDL_RenderSetViewPort(Renderer,ShrunkenRect);
end;


var
    FontPointer:PTTF_Font;

procedure Rectangle(Rect:PSDL_Rect); //if you want one, give me four points

begin
	SDL_RenderDrawRect(renderer,Rect); //draw the box- inside the new "window" shrunk by 2 pixels (4-6 may be better)
end;

//everything is made of these, yet still...no primitive in SDL?

{
Incomplete SDL2 code- the drawing sequence is correct. SDL_functionX isnt correct

 
PixelTris are a smidge different. 
PixelTris are caddy-corner Pixels(up or down diagonal depending on the direction of the tri.)
Instead of Line, use PutPixel here.
PixelTris are for "more precise rendering".

Plop-drop em randomly for a neat effect...
 
 
procedure UDPixelTriangle(x,y:word; PointsUp:boolean); //if you want one, give me three points
begin
		PutPixel(x,y);
		if PointsUp then begin
			PutPixel(x-1,y+1);
			PutPixel(x+1,y+1);
		end else begin
		    PutPixel(x-1,y-1);
			PutPixel(x+1,y-1);
		end;
		//are we done?
end;

procedure LRPixelTriangle(x,y:word; PointsLeft:boolean); //if you want one, give me three points
begin
		PutPixel(x,y);
		if PointsLeft then begin
			PutPixel(x+1,y+1);
			PutPixel(x+1,y-1);
		end else begin
		    PutPixel(x-1,y+1);
			PutPixel(x-1,y-1);
		end;
		//are we done?
end;


procedure Triangle(Tri:TriPoints); //if you want one, give me three points
var
	TempTex:PSDL_Texture;
	TempSurface:PSDL_Surface;
begin

//use the above, but "bend the lines together", return to sender with 3, not 4 points instead.
		NewSurface:=CreateRGBSurface;
		
		Line(x,y,x1,y1);
		Line(x1,y1,y2,x2);
		Line(x2,y2,x,y);
		
		//ConvertsurfaceToTexture
		RenderTexture(Renderer,Texture);
		RenderPresent(Renderer);		
end;


Circles "are the bees knees" in Development.
Everybody wants one, nobody knows how to draw one.

Sin/Cos? Golden formulae(or shortcuts)? (very fast in some implementations)
 
Open: Bresenans? 4-point? GL: with squares...(yeah...)
Filled: Lines from Center?


Pies(like the ones you eat) are based on Circles, overlaping, then filled in the gaps.
WinAPI,X11(Prim) and OpenGL have these routines, I dunno why SDL is missing em...


}


procedure closegraph;
var
	Killstatus,Die:cint;
    waittimer:integer;

//free only what is allocated, nothing more- then make sure pointers are empty.
begin

  LIBGRAPHICS_ACTIVE:=false;  //Unset the variable (and disable all of our other functions in the process)
  logln('CloseGraph: Shutting Down');

  //if wantsInet then
//  SDLNet_Quit;

//  if wantsJoyPad then
//    SDL_JoystickClose( gGameController ); 
//  gGameController := Nil;
{
  if WantsAudioToo then begin
    Mix_CloseAudio; //close- even if playing

    if chunk<>Nil then
        Mix_FreeChunk(chunk); 
    if music<> Nil then 
        Mix_FreeMusic(music);

    Mix_Quit;
  end;
}
   if (video_timer_id <> 0) then begin 
	  SDL_RemoveTimer(video_timer_id);
	   video_timer_id := 0;
  end;

   SDL_DestroyMutex(eventLock);
   eventLock := nil;

   SDL_DestroyCond(eventWait);
   eventWait := nil;

  
  if (TextFore <> Nil) then begin
	TextFore:=Nil;
	dispose(TextFore);
  end;
  if (TextBack <> Nil) then begin
	TextBack:=Nil;
	Dispose(TextBack);
  end;
  TTF_CloseFont(FontPointer);
  TTF_Quit;
  //its possible that extended images are used also for font datas...
//  if wantsFullIMGSupport then 
  //   IMG_Quit;


  //Kill child if it is alive. we know the pid since we assigned it(the OS really knows it better than us)

  //we can trip the loop to exit...

  exitloop:=true;
 
//you cant kill what you didnt make... 
// SDL_WaitThread(EventThread,Nil);

  dispose(EventThread);
  dispose( Event );
  //free viewports memory buffers

{
Range ERROR:

x:=8;
  repeat
	if (Textures[x]<>Nil) then
		SDL_DestroyTexture(Textures[x]);
	Textures[x]:=Nil;
    dec(x);
  until x=0;
 } 
  //reset the viewport
  SDL_RenderSetViewport(Renderer,Nil);  

//Dont free whats not allocated in initgraph(do not double free)
//routines should free what they allocate on exit.

  if (MainSurface<> Nil) then begin
	SDL_FreeSurface( MainSurface );
	MainSurface:= Nil;
  end;	

  if (Renderer<> Nil) then begin
    Renderer:= Nil;
	SDL_DestroyRenderer( Renderer );
  end;	

  if (Window<> Nil) then begin
	Window:= Nil;
  	SDL_DestroyWindow ( Window );
  end;	

  if IsVTerm then begin
     
         textcolor(7); //..reset standards...
         clrscr; //text clearscreen
         writeln;
  end;
  //unless you want to mimic the last doom screen here...usually were done....  
  //Yes you can override this function- if you need a shareware screen on exit..Hackish, but it works.
  //"@ExitProc rerouting routines" (and checks) go here

  SDL_Quit; 
  logln('Done.');
  StopLogging;
  halt(0); //nothing special, just bail gracefully.
end;            	 

function GetX:word;
begin
  x:=where.X;
end;

function GetY:word;
begin
  y:=where.Y;
end;

function GetXY:longint; 
//This is the 1D location in the 2D graphics area(yes, its weird)

begin
  x:=where.X;
  y:=where.Y;
  GetXY := (y * (MainSurface^.pitch mod (sizeof(byte)) ) + x); //byte or word-(lousy USint definition)
end;

{
 Draw an Texture to an Renderer at x, y. 
 preserve the texture's width and height- also taking a clip of the texture if desired

- we can use just RenderCopy, but it doesnt take stretching or clipping into account.(its sloppy)

I didnt write this (from stackExchange in C) but it makes sense and SDL is at least "GPL", so we are "safe in licensing".

}

procedure renderTexture( tex:PSDL_Texture;  ren:PSDL_Renderer;  x,y:word;  clip:PSDL_Rect);

var
  dst:PSDL_Rect;

begin
	
	dst^.x := x;
	dst^.y := y;
	if (clip <> Nil)then begin
		dst^.w := clip^.w;
		dst^.h := clip^.h;
	end
	else begin
		SDL_QueryTexture(tex, NiL, NiL, @dst^.w, @dst^.h);
	end;
	SDL_RenderCopy(ren, tex, clip, dst); //clip is either Nil(whole surface) or assigned

end;


procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 
//initgraph should call us to prevent code duplication
//exporting a record is safer..but may change "a chunk of code" in places.   
var
	flags:longint;
    success,IsThere,RendedWindow:integer;
    surface1:PSDL_Surface;
    FSNotPossible:boolean;
    thismode:string;
    wantsFS:string;

begin
//we can do fullscreen, but dont force it...
//"upscale the small resolutions" is done with fullscreen.
//(so dont worry if the video hardware doesnt support it)



//if not active:
//are we coming up?
//no? EXIT

if (LIBGRAPHICS_INIT=false) then 

begin		
		if IsVTerm then logln('Call initgraph before calling setGraphMode.') 
		else SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'setGraphMode called too early. Call InitGraph first.','OK',NIL);
	    exit;
end
else if (LIBGRAPHICS_INIT=true) and (LIBGRAPHICS_ACTIVE=false) then begin //initgraph called us

               
    case bpp of
		8: begin
			    if maxColors<=256 then format:=SDL_PIXELFORMAT_INDEX8;
			    
//			Get/PutPixel dont work below depth 8, thats why we mod/hack it. Presume its 8bit, even if MaxColors says otherwise.

		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

        //we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;

    logln('MaxX: '+Inttostr(MaxX));
    logln('MaxY: '+Inttostr(MaxY));
    logln('bpp: '+Inttostr(bpp));

    if wantfullscreen = true then
        wantsFS:='True'
    else
		wantsFS:='False';
    logln('Full screen requested: '+wantsFS);
   
//Not using Lazarus   
         {$IFNDEF LCL}
         //posX,PosY,sizeX,sizeY,flags
         window:= SDL_CreateWindow(PChar('Lazarus Graphics Application'), SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, MaxX, MaxY, 0);
    	 if (window = Nil) then begin
 			if IsVTerm then begin
	    	   	logln('Something Fishy. No hardware render support and cant create a window.');
	    	   	logln('SDL reports: '+' '+ SDL_GetError);      
	    	end;
	    	closegraph;
	     end;	
         {$ENDIF}

//this code doesnt seem to be working- but to remove it would be wrong, lets fix it instead, somehow.

//else: using Lazarus
         {$IFDEF LCL}
			//Handle -> Application.MainForm.Handle as per the forums

            {$IFDEF mswindows}
                window:=SDL_CreateWindowFrom(Pointer(Application.MainForm.Handle));
            {$ENDIF}
            
            {$IFDEF unix} 
                {$IFDEF LCLGTK} //GTK- never assume                
                    window:=SDL_CreateWindowFrom(Pointer(GDK_WINDOW_XWINDOW(PGTKWidget(PtrUInt(Application.MainForm.Handle))^.window)));
                {$ENDIF}

                {$IFDEF LCLQt} //QT- never assume                
                    window:=SDL_CreateWindowFrom(Pointer(PQtWidget(PtrUInt(Application.MainForm.Handle))^.widget));
                {$ENDIF}

                //ELSE: X11Core
					GetXHandle(Application.MainForm.Handle);
				
            {$ENDIF}
            
            //MacOSX
            {$IFDEF Darwin}
                    window:=SDL_CreateWindowFrom(Pointer(TCarbonWidget(PtrUInt(Application.MainForm.Handle))^.widget));  
            {$ENDIF}
         {$ENDIF}
		 if (window = Nil) then begin
 			if IsVTerm then begin
	    	   	logln('Something Fishy. I cant create a window.');
	    	   	logln('SDL reports: '+' '+ SDL_GetError);
	    	end;
	    	closegraph;
		end;
        logln('initgraph: Window is online.');
  
    	renderer := SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
		if (renderer = Nil ) then begin
 			if IsVTerm then begin
	    	   	logln('Something Fishy. No hardware render support and cant setup a software one.');
	    	   	logln('SDL reports: '+' '+ SDL_GetError);      
	    	end;
	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy.',' No hardware render support. BYE..',NIL);
	    	closegraph;
		end;
        // SDL_RenderSetLogicalSize(renderer,MaxX,MaxY);
    logln('initgraph: renderER online');
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        SDL_RenderClear(renderer);
     SDL_RenderPresent(renderer); 

 // SDL_RenderSetLogicalSize(renderer,MaxX,MaxY);
   if wantFullscreen then begin
       //I dont know about double buffers yet but this looks yuumy..
       //SDL_SetVideoMode(MaxX, MaxY, bpp, SDL_DOUBLEBUF|SDL_FULLSCREEN);

       flags:=(SDL_GetWindowFlags(window));
       flags:=(flags or SDL_WINDOW_FULLSCREEN_DESKTOP); //fake it till u make it..
       //we dont want to change HW videomodes because 4bpp isnt supported.
       
       //autoscale us to the monitors actual resolution
       SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'linear');
       SDL_RenderSetLogicalSize(renderer, MaxX, MaxY);
//phones: SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1"); 

	   IsThere:=SDL_SetWindowFullscreen(window, flags);
       //Hide, mouse.
       SDL_ShowCursor(SDL_DISABLE);

       //thisMode:=getgraphmode;
  	   if ( IsThere < 0 ) then begin
    	      if IsVTerm then begin
    	         logln('Unable to set FS: ');
    	         logln('SDL reports: '+' '+ SDL_GetError);      
     	      end;

              FSNotPossible:=true;      
       
         //if we failed then just gimmie a yuge window..      
         SDL_SetWindowSize(window, MaxX, MaxY);
         SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set FS.','OK',NIL);
         if IsVTerm then begin
            logln('ERROR: SDL cannot set FS.');
            logln(SDL_GetError);
         end;
       end;

    end; 
    //if bpp=1 then
    //  (you only have white to draw with)
    //if bpp=2 then 
		//which palette - out of 4(CGA)? - mode has determine this, even if reprogrammed later on.
    if bpp=4 then //EGA
      InitPalette16;
    if bpp=8 then //VGA
      InitPalette256; 

     LIBGRAPHICS_ACTIVE:=true;
     exit; //back to initgraph we go.

  end else if (LIBGRAPHICS_ACTIVE=true) then begin //good to go

                   
    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

        //we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;

        mode^.w:=MaxX;
		mode^.h:=MaxY;
		mode^.refresh_rate:=60; //assumed
		mode^.driverdata:=Nil;


		success:=SDL_SetWindowDisplayMode(window,mode);
        if (success <> 0) then begin 
			SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set DisplayMode.','OK',NIL);
	        if IsVTerm then begin
                logln('ERROR: SDL cannot set DisplayMode.');		
                logln(SDL_GetError);
            end;
			exit;
        end;
		logln('Resolution Re-Size requested.');
        logln('New MaxX: '+InttoStr(MaxX));
		logln('New MaxY: '+Inttostr(MaxY));
		logln('New bpp: '+Inttostr(bpp));
		if wantfullscreen = true then
			wantsFS:='True'
		else
			wantsFS:='False';
		logln('Full screen requested: '+wantsFS);

   if wantFullscreen then begin
       //I dont know about double buffers yet but this looks yuumy..
       //SDL_SetVideoMode(MaxX, MaxY, bpp, SDL_DOUBLEBUF|SDL_FULLSCREEN);

       flags:=(SDL_GetWindowFlags(window));
       flags:=flags or SDL_WINDOW_FULLSCREEN_DESKTOP; //fake it till u make it..
       //we dont want to change HW videomodes because 4bpp isnt supported.
       
       
       if ((flags and SDL_WINDOW_FULLSCREEN_DESKTOP) <> 0) then begin
            SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'linear');
            SDL_RenderSetLogicalSize(renderer, MaxX, MaxY);
//phones: SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1"); 
       end;

	   IsThere:=SDL_SetWindowFullscreen(window, flags);
      //Hide, mouse.
       SDL_ShowCursor(SDL_DISABLE);

  	 //  thisMode:=getgraphmode;
  	   if ( IsThere < 0 ) then begin
    	      if IsVTerm then begin
    	         logln('Unable to set FS: ');
    	         logln('SDL reports: '+' '+ SDL_GetError);      
     	      end;
              FSNotPossible:=true;      
       
          //if we failed then just gimmie a yuge window..      
          SDL_SetWindowSize(window, MaxX, MaxY);
          SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set FS.','OK',NIL);
          if IsVTerm then begin            
            logln('ERROR: SDL cannot set FS.');
            logln(SDL_GetError);
          end;
          exit;
       end;

    end;

  //reset palette data
    //if bpp=1 then
    //  (you only have white to draw with)
    //if bpp=2 then 
		//which palette - out of 4(CGA)? - mode has determine this, even if reprogrammed later on.
    if bpp=4 then //EGA
      InitPalette16;
    if bpp=8 then //VGA
      InitPalette256; 
      
  end; 

end; //setGraphMode

function getgraphmode:string; 
//it could also be that the monitor output is not in the modelist
var
    bppstring:string;
    format:PSDL_PixelFormat;
    MaxMode:integer;
    findX,findY:word;
    findbpp:byte;
    thismode:PSDL_DisplayMode;

begin
   if LIBGRAPHICS_ACTIVE then begin 
        SDL_GetCurrentDisplayMode(0, thismode); //go get w,h,format and refresh rate..
        findX:=MainSurface^.w;
		findY:=MainSurface^.h;
		x:=0;
        //we need to find X,Y,BPP in the modelist somehow...
		while (x< (Ord(High(Graphics_Modes))-1)) do begin
			if (findX=MaxX) and (findY=MaxY)  then begin		
                    if (MainSurface^.format^.BitsPerPixel<>bpp) then break;			       	
                    //typinfo shit:                      	
			        getgraphmode:=GetEnumName(TypeInfo(Graphics_modes), Ord(x));
					exit;
			end;
            
            bpp:=bpp * bpp; //bpp^2 - if x and y match, save time
			inc(x);
		end;
        if IsVTerm then begin
            logln('Cant find current mode in modelist.');
        end;
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: Cant find current mode in modelist.','OK',NIL);        
   end;   
end;    

procedure restorecrtmode; //wrapped closegraph function
begin
  if (not LIBGRAPHICS_ACTIVE) then begin //if not in use, then dont call me...

	if IsVTerm then 
        logln('you didnt call initGraph yet...try again?') 
    else
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Restore WHAT exactly?','Clarify the Stupid',NIL);
  end;
  closegraph;
end;

function getmaxX:word;
var
	w,h:word;
	
begin
   if LIBGRAPHICS_ACTIVE then
   //pulling from ModeList data is much faster than querying the renderer or unfetching rendered surface data
   //if graphics is active- assume we have the data set.
     getMaxX:=(MaxX - 1); 
end;

function getmaxY:word;
begin
   if LIBGRAPHICS_ACTIVE then
     GetMaxY:=(MaxY - 1); 
end;

{ 

Blitter, Blittering, Blits, BitBlit (or RenderCopy- with a maybe on freeSurface..)

Wikipedia-

A blitter is a circuit, sometimes as a coprocessor or a logic block on a microprocessor, 
dedicated to the rapid movement and modification of data within a computer's memory.

A blitter can copy large quantities of data from one memory area to another relatively quickly, 
and in parallel with the CPU, while freeing up the CPU's more complex capabilities for other operations. 

A typical use for a blitter is the movement of a bitmap, such as windows and fonts in a graphical user interface 
or images and backgrounds in a 2D computer game. 

The name comes from the bit blit operation of the 1973 Xerox Alto, which stands for bit-block transfer.

A "blit operation" is more than a memory copy, because it can involve data that's not byte aligned 
(hence the bit in bit blit), handling transparent pixels (pixels which should not overwrite the destination data), 
and various ways of combining the source and destination data.

//NewLayer is a loaded (BMP) pointer (filled rect)

// SDL_BlitSurface(NewLayer, nil,MainSurface,nil);


//procedure HowBlit(currentwriteMode);
    //perpixel anything is horrendously slow. use the "blitting cpu functions" to our advantage instead.

--shift the palette,stupid
    --apply the shifted palette to the blit
        BLIT
        RenderCopy 
        reset the palette and renderPresent

        //xorBlit
        //andBlit
        //orBlit
        //notBlit(inverted colors)

//GetSurface from Renderer (or Create SurfaceFromRenderer) 
SDL_ScrollX(Surface,DifX);
SDL_ScrollY(Surface,DifY);
//Then renderCopy it back as a "texture"


if youre looking for batched ops:

procedure BatchRenderPixels;
var 
  PolyArray=array[1..points] of SDL_Point;

begin
  polyarray[1].x:=5
  polyarray[1].y:=3

  polyarray[2].x:=7
  polyarray[2].y:=7

  SDL_RenderDrawPoints( renderer,polyarray,points);  
end;


Polygons:
    SDL_RenderDrawLines(renderer,LineData,numLines);

}

function GetPixel(x,y:word):DWord;

// this function is "inconsistently fucked" from C...so lets standardize it...
// this works, its hackish -but it works..SDL_GetPixel is for Surfaces/screens, not renderers.
var
  format:longword;
  TempSurface:PSDL_Surface;
  bpp:byte;
  p:pointer; //the pixel data we want 
  GotColor:PSDL_Color;
  pewpew:longword; //DWord....
  pointpew:PtrUInt;
  r,g,b,a:PUInt8;
  index:byte;
  someDWord:DWord;


begin
	rect^.x:=x;
    rect^.y:=y;
	rect^.h:=1;
	rect^.w:=1;
    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

//we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;


    //(we do this backwards....rendered to surface of the size of 1 pixel)
    if ((MaxColors=256) or (MaxColors=16)) then TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 8, format) 
    //its weird...get 4bit indexed colors list in longword format but force me into 256 color mode???

    else if (MaxColors>256) then begin
        case (bpp) of
		    15: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 15, format); 
			16: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 16, format); 
			24: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 24, format); 
			32: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 32, format); 
			else begin
				SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Wrong bpp given to get a pixel. I dont how you did this.','OK',NIL);
				 if IsVTerm then
                logln('Wrong bpp given to get a pixel. I dont how you did this.');
			end;

		end;
     end;

    //read a 1x1 rectangle....
    SDL_RenderReadPixels(renderer, rect, format, TempSurface^.pixels, TempSurface^.pitch);


    p:=TempSurface^.pixels;  
    bpp := TempSurface^.format^.BytesPerPixel; 
    //The C is flawed! 15bpp not taken into account.
    //ignorance is stupidity and laziness!

    // Here TempSurface^.pixels is the address to the pixel data (1px) we want to retrieve
    

{

"nuking the problem" (unnessessary overcomplication)
 the problem - not well documented for surfaces in C-

is thusly:

  P can be of any size up to 32bit values (because sdl doesnt support 64bit modes)

  is P a byte? (16/256 colors)
  is P a Word? NO. NEVER.Not enough BPP data returned.
  is P a partial DWord? (15/16bit/24bit colors) - spew SDL_Color data (for each byte inside P), 
      then fetch an appropriate DWord from that
      (this is a bitwise operation, so we need the DWord inside the pointer to work with the data)

  is P a DWord? (32bit colors)

no type conversion is needed as pointers are flexible
however endianness, although it should be checked for (ALWALYS) plays no role in how P is interpreted.

-and people wonder why thier data coming back from P is flawed?? mhm...

-you nuked it!

}
    case (bpp) of 
       8:begin //256 colors
        //now take the longword output 

          //check for the hidden 4bpp modes we made available
          if MaxColors=16 then begin
             index:=ord(Byte(^p));
             GetPixel:=Tpalette16[index].Dwords;
          end;

          //ok safely in 256 colors mode
          if MaxColors=256 then begin
             index:=ord(Byte(^p));
             GetPixel:=Tpalette256[index].Dwords;
          end;
          exit;
      end;

//these three need some work
//not its not a trick, we need the alpha-bit set to FF on non 32bit colors.
//its ignored but its also "padded data"

      15: begin //15bit
            //to do this one- we split out the RGB pairs, shift them,then recombine them.
            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );
	         gotcolor^.b:=(byte(^b) );

            //shift adjust me
			gotcolor^.r:= (gotcolor^.r shr 3);
			gotcolor^.g:= (gotcolor^.g shr 3);
			gotcolor^.b:= (gotcolor^.b shr 3);

            //repack
            someDWord:= SDL_MapRGB(TempSurface^.format,gotcolor^.r,gotcolor^.g,gotcolor^.b);
            GetPixel:=someDWord;
            exit;
      end;
      16: begin //16bit-565
        //    if (TempSurface^.format=SDL_PIXELFORMAT_RGB565) then begin

            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );
	         gotcolor^.b:=(byte(^b) );

            //shift adjust me
			gotcolor^.r:= (gotcolor^.r shr 3);
			gotcolor^.g:= (gotcolor^.g shr 2);
			gotcolor^.b:= (gotcolor^.b shr 3) ;

           //repack
            someDWord:= SDL_MapRGB(TempSurface^.format,gotcolor^.r,gotcolor^.g,gotcolor^.b);
            GetPixel:=someDWord;
      		exit;
      end;


      24: begin //24bit
            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );
	         gotcolor^.b:=(byte(^b) );
           //repack
            someDWord:= SDL_MapRGB(TempSurface^.format,gotcolor^.r,gotcolor^.g,gotcolor^.b);
            GetPixel:=someDWord;
			exit;
      end;
      32: //32bit

	        GetPixel:=DWord(p);
   
      else
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get Pixel values...','OK',NIL);
         if IsVTerm then
                logln('Cant Put Pixel values...');
    end; //case

    SDL_FreeSurface(Tempsurface);
    
end;


Procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word);

begin
//SDL_renderDrawPoint uses _fgcolor set with SDL_SetRenderDrawColor

  if (bpp<4) or (bpp >32) then
 
  begin
    		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Put Pixel values...','OK',NIL);
            if IsVTerm then
                logln('Cant Put Pixel values...');
			exit;
  end;
  SDL_RenderDrawPoint( Renderer, X, Y );
  
end;

procedure Line(x,y,a,b:Word);
//alias- for compatibility
begin
	SDL_RenderDrawLine(Renderer,x,y,a,b);
end;

function getdrivername:string;
begin
//not really used anymore-this isnt dos

   getdrivername:='Internal.SDL'; //be a smartASS
end;


//FIXME:dont use Graphics_mode=detect for the moment.
//(reqd fix for version 1.0)

//we should limit detectGraph calls also and allow quick checks if libGfx is already active.

Function detectGraph:byte; //should return max mode supported(enum value) -but cant be negative
//called *once* per "graphics init"-which is only called if not active.

//we detected a mode or we didnt. If we failed, exit. (we should have at least one graphics mode)
//if we succeeeded- get the highest mode.

//we only need the entire list (enum) while probing. The DATA is in the initgraph subroutine.

var

    i,testbpp:integer;

begin

//if InitGraph then...
//(AND ONLY WHILE INITing....initgraph needs to call us)

{
BAD C detected!

this is the "shove a byte where a boolean goes bug" in C...(boolean words etc..)
if its zero then its not ok. we dont want any other mode or similar mode...
in this case-
    if its 1, we found the mode.

the trick is to prevent SDL from setting "whatever is closest"..we want this mode and only this...
most people dont usually care but with the BGI -WE DO.

SDL_VideoModeOK:
    this is SDLv1.2 code
    IT also assumes that you want to switch physical screen modes(we dont) 
        (like telling X11 to drop to 320x240x256-we dont want this)
        -we will stretch for higher resolutions, or use a window for lower resolutions

SDL2:

    How do we scan the unknown? 
    1- ask SDL for supported list of Modes supported (solve X by providing it)
    2- we have to compare it to something. This is the puzzle-to what? 
        we are set higher than the mode we want. (We WANT the unsupported modes and depths)

so- we get the current screen resolution and check if requested mode is smaller-if so, GOOD.
(if its bigger, then we have a problem. DROP one mode with same color depth.)


}

{    i:=(Ord(High(Graphics_Modes))-1)

    //CurrentMode:=SDL_GetCurrentMode	 
	repeat

   		testbpp:=SDL_VideoModeOK(modelist.width[i], modelist.height[i], modelist.bpp[i], _initflag); //flags from initgraph

        //if Currentmode=ModeRequested (testbpp=1) then...
	 
        if (testbpp=1) then begin 
            
            //initGraph just wants the number of the enum value, which we check for
            DetectGraph:=byte(i); 
            exit;
    	end;
		dec(i);
	until i:=1;
    //there is still one mode remaining.
	testbpp:=SDL_VideoModeOK(modelist.width[i], modelist.height[i], modelist.bpp[i], _initflag);		         
	if (testbpp=0) then begin //did we run out of modes?
        if IsVTerm then
            logln('We ran out of modes to check.');
            //logln('We ran out of modes to check.');
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'There are no graphics modes available to set. Bailing..','OK',NIL);
		CloseGraph; 
	end;
	DetectGraph:=byte(i);

	//usermode should be within these parameters, however, since that cant be checked for...
	//why not just remove it(usermode)? [enforce sanity]
    //otherwise we need to see if its valid data too....or skew up SDL window output and rendering.....
    //-which is wrong.
}

end; //detectGraph


function getmaxmode:string;
var
   maxmodetest:byte;
begin
  if LIBGRAPHICS_ACTIVE then begin
      maxmodetest:=detectgraph;
      getmaxmode:=GetEnumName(TypeInfo(graphics_modes), Ord(maxmodetest)); //use the number and get the name of it.
  end;
end;


//the only real use for the "driver" setting...
procedure getmoderange(graphdriver:integer);

begin
{
I have to figure out what mode is what again...
- no im not lazy, just busy. 

	if not graphdriver = ord(detect) then begin
  		if (graphdriver = ord(VGA)) then begin
    		  lomode := ord(VGAMed);
    		  himode := ord(m1024x768x24);
  		end else

  		if (graphdriver= ord(VESA)) then begin
    		 lomode := ord(mCGA);
    		 himode := ord(m1920x1080x24);
  		end else

		if (graphdriver = ord(mCGA)) then begin
    	  lomode := ord(mCGA);
    	  himode := ord(mCGA);
  		end;

	end else begin
        if (graphdriver=ord(DETECT)) then begin
            himode:=detectgraph;	 //unfortunate probe here...   	
// FIXME: return value: (byte to enum value conversion?? - or use a bunch of consts)
// default enum type reads: longword

	    	lomode:= ord(mCGA); //no less than this.
		end else begin
			if IsVTerm then
				logln('Unknown graphdriver setting.');
			SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Unknown graphdriver setting.','ok',NIL);
		end;
	end;
}
end; //getModeRange



//(Its an odd rare case,such as TnL --not discussed here)

function cloneSurface(surface1:PSDL_Surface):PSDL_Surface;
//Lets take the surface to the copy machine...

begin
    cloneSurface := SDL_ConvertSurface(Surface1, Surface1^.format, Surface1^.flags);
end;

{viewports-
    the trick is that we are technically always in one(FPC).
    the joke is:
         what are the co ords?

this might not be BGI spec- but it makes sense.

}

procedure SetViewPort(Rect:PSDL_Rect);

var
    LastRect:PSDL_Rect;
    ScreenData:Pointer;
    infosurface,savesurface:PSDL_Surface;

begin
//freeze movement
   if windownumber=8 then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to create too many viewports.','OK',NIL);
      if IsVTerm then
        logln('Attempt to create too many viewports.');
      exit;
   end;
   //get viewport size and put into LastRect
   SDL_RenderGetViewport(renderer,Lastrect); 
   //current co ords = last, then add one.
   inc(windownumber);

   //LINUX claims of xor,xnor "not being supported"- so let "work around it".
   
  //store the current viewport data
  saveSurface := NiL;
  infosurface:=Nil;
  ScreenData:=Nil;

  //pixels and info abt the pixels. from the renderer-to a surface, then throw it back into a texture
  ScreenData:=GetPixels(LastRect);
  infoSurface := SDL_GetWindowSurface(Window);
  saveSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface^.w * infoSurface^.format^.BytesPerPixel),longword( infoSurface^.format));

  if (saveSurface = NiL) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt create SDL_Surface from renderer pixel data','OK',NIL);
      logln('Couldnt create SDL_Surface from renderer pixel data. ');
      logln(SDL_GetError);
      exit;
                    
  end;
   
   Textures[windownumber]:=SDL_CreateTextureFromSurface(renderer,saveSurface);

   //free data
   SDL_FreeSurface(saveSurface);

   saveSurface := NiL;
   infosurface:=Nil;
   ScreenData:=Nil;
  

   SDL_RenderSetViewport( Renderer, Rect );  
   //clearviewport(_fgcoor);
  
   //"Clipping" is a joke- we always clip.
   //The trick is: do we zoom out? In Most cases- NO. We zoom IN.

end;


procedure RemoveViewPort(windownumber:byte);
//the opposite of above...
//set the last window coords..(we might be trying to write to them)
//and redraw the prior window as if the new one was not there(not an easy task).
var
  ThisRect,LastRect:PSDL_Rect;

begin

   if windownumber=0 then begin
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to remove non-existant viewport.','UH oh.',NIL);
  
    if IsVTerm then
        logln('Attempt to remove non-existant viewport.');
    exit; 
   end;
   if windownumber > 1 then begin
  		ThisRect^.X:=TexBounds[windownumber]^.X;
		ThisRect^.Y:=TexBounds[windownumber]^.Y;
	    ThisRect^.W:=TexBounds[windownumber]^.W;
	    ThisRect^.H:=TexBounds[windownumber]^.H;

        //get co ords of the previous

        LastRect^.X:=TexBounds[windownumber-1]^.X;
 	    LastRect^.Y:=TexBounds[windownumber-1]^.Y;
 	    LastRect^.W:=TexBounds[windownumber-1]^.W;
	    LastRect^.H:=TexBounds[windownumber-1]^.H;
   
       //remove the viewport by removing the texture and redrawing the screen.
       //the problem with textures is that they are part of a one-way road. ARG!

        Textures[windownumber]:=nil; //Destroy the current Texture

        SDL_RenderCopy(renderer,Textures[windownumber-1],Nil,LastRect);
        SDL_RenderPresent(renderer);

		SDL_RenderSetViewport( Renderer, LastRect ); 
        dec(windownumber);
//unfreeze movement
        exit;
   end; 
   //else: last window remaining
   Textures[1]:=nil;
   SDL_RenderSetViewport( Renderer,nil);  //reset to full size "screen"

   //this only works if we freeze input and dont update the screen- otherwise, we jitter
   // and update with old data on the "overlayed area".

   SDL_RenderCopy(Renderer,Textures[0],nil,LastRect);
   SDL_RenderPresent(renderer); //and update back to the old screen before the viewports came here.

   LastRect^.X:=0;
   LastRect^.Y:=0;
   LastRect^.W:=MaxX;
   LastRect^.H:=MaxY;
   
   dec(windownumber);

   //unfreeze movement
end;



//compatibility
//these were hooks to load or unload "driver support code modules" (mostly for DOS)
procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
begin
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Function No longer supported: InstallUserDriver','OK',NIL);
   logln('Function No longer supported: InstallUserDriver');
end;

procedure RegisterBGIDriver(driver: pointer);

begin
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Function No longer supported: RegisterBGIDriver','OK',NIL);
   logln('Function No longer supported: RegisterBGIDriver');
end;


function GetMaxColor: word;
//Use "MaxColors" if looking to use Random(Color).
//This gives you the HUMAN READABLE MAX amount of colors available.
  
begin
      GetMaxColor:=MaxColors+1; // based on an index of zero so add one 255=>256
end;



//alloc a new texture and flap data onto screen (or scrape data off of it) into a file.


//yes we can do other than BMP.
{
procedure LoadImage(filename:PChar; Rect:PSDL_Rect);
//Rect: I need to know what size you want the imported image, and where you want it.

var
  tex:PSDL_Texture;

begin

    tex:= NiL;
    Tex:=IMG_LoadTexture(renderer,filename);
    SDL_RenderCopy(renderer, tex, Nil, rect); //PutImage at x,y but only for size of WxH
end;

procedure LoadImageStretched(filename:PChar);

var
  tex:PSDL_Texture;

begin

    tex:= NiL;
    Tex:=IMG_LoadTexture(renderer,filename); 
    SDL_RenderCopy(renderer, tex, Nil, Nil); //scales image to output window size(size of undefined Rect)
end;
}
//linestyle is: (patten,thickness) "passed together" (QUE)
//this uses thickness variable only

procedure PlotPixelWithNeighbors(Thick:thickness; x,y:word);
//this makes the bigger Pixels
 
// (in other words "blocky bullet holes"...)  
// EXPERT topic: smoothing reduces jagged edges

begin                
   //more efficient to render a Rect.

   New(Rect);
   Rect^.x:=x;
   Rect^.y:=y;
   case (Thick) of
       NormalWidth: begin
             Rect^.w:=2;
			 Rect^.h:=2;   
       end;
       ThickWidth: begin  
             Rect^.w:=4;
			 Rect^.h:=4;   
       end;
       SuperThickWidth: begin
             Rect^.w:=6;
			 Rect^.h:=6;   
       end;
       UltimateThickWidth: begin  
             Rect^.w:=8;
			 Rect^.h:=8;   
       end;
   end;
   SDL_RenderFillRect(renderer, rect);

   Dispose(Rect);
   //now restore x and y
   case Thick of
		NormalWidth:begin
			x:=x+2;
			y:=y+2;   		
		end;
		ThickWidth:begin
			x:=x+4;
			y:=y+4;  
		end;
		SuperThickWidth: begin
            x:=x+6;
			y:=y+6;  
       end;
       UltimateThickWidth: begin  
            x:=x+8;
			y:=y+8;  
       end;
   end;
end;


procedure SaveBMPImage(filename:string);
//hmmm stuck with this for time being
var
  ScreenData:Pointer;
  infosurface,savesurface:PSDL_Surface;

begin
//the downside is that upon ea sdl init for our app/game..this resets.

  filename:='screenshot'+intTostr(screenshots)+'.bmp';
  //screenshotXXXXX.BMP
  saveSurface := NiL;
  infosurface:=Nil;
  ScreenData:=Nil;
  ScreenData:=GetPixels(Nil); 
  
  infoSurface := SDL_GetWindowSurface(Window);
  saveSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface^.w * infoSurface^.format^.BytesPerPixel), longword(infoSurface^.format));

  if (saveSurface = NiL) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt create SDL_Surface from renderer pixel data','OK',NIL);
      if IsVTerm then begin
          logln('Couldnt create SDL_Surface from renderer pixel data');      
          logln(SDL_GetError);
      end;
      exit;
                    
  end;
  SDL_SaveBMP(saveSurface, filename);
  SDL_FreeSurface(saveSurface);
  saveSurface := NiL;
  infosurface:=Nil;
  ScreenData:=Nil;
  inc(Screenshots);
end;


//note this function is "slow ASS"


function GetPixels(Rect:PSDL_Rect):pointer;
//this does NOT return a single pixel by default and is written intentionally that way.
//GetPixel checks also the output pointer length and fudges it into a single "SDL_Color".

//this routine expects YOU to handle the array of data
//SDL_Color SDL_Color SDL_Color .....

var

  pitch:integer;
  pixels:pointer; //^array [0..x*y] of SDL_Color

{
  the array size is dependant on current screen resoluton- I can only give MAXIMUM defaults if I set this value.
  This is an SDL_Color limitation. If it were me, Id just copy the array in 2D, not 1D.
  Yes, technically, even kernel write to screen are stored in VRAM(or buffers) as:
		[X,Y,RGBColor] however...SDL treats it as a 1D array.

  I didnt design SDL, sorry. Maybe thats why its SLOW???
  src: VGA graphics 101 - address A000, 386+ VRAM (and LFB) access.
  NOTE: 
     You probly CANNOT directly write here.. (blame X11 or Windows or Apple)
     (Because youre staring at the array right now, reading this.)
}

  AttemptRead:integer;

begin
   if ((Rect^.w=1) or (Rect^.h=1)) then begin    
     if IsVTerm then begin       
        logln('USE GetPixel. This routine FETCHES MORE THAN ONE');
     end;  
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'USE GetPixel. This routine FETCHES MORE THAN ONE','OK',NIL);
     exit;
   end;

   pixels:=Nil;
   pitch:=0;

                 
    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

//we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;
//format and rect we already can derive
//pixels and pitch will be returned for the given rect in SDL_Color format given by our set definition
//rect is Nil to copy the entire rendering target

   AttemptRead:= SDL_RenderReadPixels( renderer, rect, format, pixels, pitch);
   
   //pitch at this point could be 2,3,4,etc.. and must otherwise be taken into account.
   if (AttemptRead<0) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to read pixel data failed.','OK',NIL);
      if IsVTerm then begin
          logln('Attempt to read pixel data failed.');
          logln(string(SDL_GetError));
      end;
     exit;
   end;
   GetPixels:=pixels;
end;




begin  //PascalMain()

StartLogging;

//On unices we dont care if LCL is used or not- were still a "console app", even if not in a VTerm.
//UI apps just dont have a "console output window". LOG ANYWAY.

{$IFDEF unix}
  //GetEnv ..an egg by another name...
  if (GetEnvironmentVariable('DISPLAY') = '') then begin //X11 is not active
	NeedFrameBuffer:=true;
    IsVTerm:=true; //This is the proper way to check, dont assume based on "flawed Unix logic".
  end;
{$ENDIF}

  
{
  libSVGA note:
		NO- Im not rewriting THAT TOO!

  -Although maybe we could "hook the C"-inadvertently enabling FreeDOS support for "SDL and associates"
   Graphics modes. There is some BASIC support with HXDPMI and its associate Win32 loaders....
   (I have personally not had a practical use for it yet.) 
   
  PCs boot in x86 mode-(or emu86 mode) in 8bit-jump to 16/32/64 bits unless EFI loaded (into 64). 
  FREEDOS takes advantage of emu86 mode-(so does DosBox--or is it DosEmu)??
  Anyway- DPMI kicks us back into 16 and 32 bit operating modes.
  
  in all practicallity- libSVGA libs may set the screen up--
  but everyone depends on libX11, libCocoa(OSX),libCarbon(OSX),or WinAPI these days...
  you are going to be limited to the LFB--which is very slow compared to NATIVE DRIVERS.
  
  There's no reason we shouldnt utilize libSVGA if its our only option, however.
  This may require - as a result SDLv1, not SDLv2- due to video ram constraints.
  
  (There has to be some reason you arent running X11....)
  
  if X11 EVER gets loaded- then libSVGA is out-of-the-question.
  
  libSVGA is extremely unpractical on most modern day "workstations" and "common PCs".
  (This is why it has no future support in FreePascal)
  
  But let's say you are running a specific setup (NASA? BOEING? FLight controls, etc.) and dont want X11:
  -what then?
       
       You can load the driver module and associated LFB- but is it "accelerated" without X11? 
			-DirectFB is.
  
  This is the case of "Nuking it" or "not thinking at all" when writing code- instead of planning for "as many
  as possible" scenarios.
  
}

{$IFDEF LCL}
        {$ifndef debug} //Lazarus default is to debug while running
			{$IFDEF mswindows}
				IsVTerm:=false; //ui app- NO CONSOLE AVAILABLE
			{$ENDIF}        
        {$endif}
{$ENDIF}

   screenshots:=00000000;
   windownumber:=0;

end.


