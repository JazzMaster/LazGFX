type

	graphics_modes=(

mCGA, 
VGAMed,vgaMedx256,
vgaHi,VGAHix256,VGAHix32k,VGAHix64k,
m800x600x16,m800x600x256,m800x600x32k,m800x800x64k,
,m1024x768x256,m1024x768x32k,m1024x768x64k,m1024x768xMil,
,m1280x720x256,m1280x720x32k,m1280x720x64k,m1280x720xMil,
,m1280x1024x256,m1280x1024x32k,m1280x1024x64k,m1280x1024xMil,
,m1366x768x256,m1366x768x32k,m1366x768x64k,m1366x768xMil,
,m1920x1080x256,m1920x1080x32k,m1920x1080x64k,m1920x1080xMil);


Tmodes=record


 DriverNumber:byte;


{
modes (w color data):

(m)cga
mode13h and mode X (VGA)
vga
svga
svgaHI (new model-no 16 color modes)
720p (TV only)
1280 square
laptop
1080p (TV only-SDL limit)

}

  	ModeName:array [Low(graphics_modes)..High(graphics_modes)] of string;

//So y do I give you 32bpp? 24bit PLUS Alpha or transparent bits-->32
//15 and 24 are a hack

 	MaxColors:array [Low(graphics_modes)..High(graphics_modes)] of DWord;

//if we dont HW switch we can set <8bpp ....
//HELLO, CGA!

    bpp:array [Low(graphics_modes)..High(graphics_modes)] of byte;
  	MaxX:array [Low(graphics_modes)..High(graphics_modes)] of word;
    MaxY:array [Low(graphics_modes)..High(graphics_modes)] of word;

  
//I havent gotten to aspect ratios and scaling yet...
//4:3 or 16:9 etc etc 
	XAspect:array[Low(graphics_modes)..High(graphics_modes)] of smallint;
	YAspect:array[Low(graphics_modes)..High(graphics_modes)] of smallint;

end; //record

procedure SetupTheList;


begin

Tmodelist.ModeName[0]:='320x200x16';

Tmodelist.ModeName[0]:='320x200x16';
Tmodelist.ModeName[0]:='320x200x256';

Tmodelist.ModeName[0]:='320x240x16';
Tmodelist.ModeName[0]:='320x240x256'; 

Tmodelist.ModeName[0]:='640x480x16';
Tmodelist.ModeName[0]:='640x480x256';
Tmodelist.ModeName[0]:='640x480x32k';
Tmodelist.ModeName[0]:='640x480x64k';

Tmodelist.ModeName[0]:='800x600x16';
Tmodelist.ModeName[0]:='800x600x256';
Tmodelist.ModeName[0]:='800x600x32k';
Tmodelist.ModeName[0]:='800x600x64k';

Tmodelist.ModeName[0]:='1024x768x256';
Tmodelist.ModeName[0]:='1024x768x32k';
Tmodelist.ModeName[0]:='1024x768x64k';

Tmodelist.ModeName[0]:='1280x720x256';
Tmodelist.ModeName[0]:='1280x720x32k';
Tmodelist.ModeName[0]:='1280x720x64k';

Tmodelist.ModeName[0]:='1280x1024x256';
Tmodelist.ModeName[0]:='1280x1024x32k';
Tmodelist.ModeName[0]:='1280x1024x64k';
Tmodelist.ModeName[0]:='1280x1024xMil';

Tmodelist.ModeName[0]:='1366x768x256';
Tmodelist.ModeName[0]:='1366x768x32k';
Tmodelist.ModeName[0]:='1366x768x64k';
Tmodelist.ModeName[0]:='1366x768xMil';

Tmodelist.ModeName[0]:='1920x1080x256';
Tmodelist.ModeName[0]:='1920x1080x32k';
Tmodelist.ModeName[0]:='1920x1080x64k';
Tmodelist.ModeName[0]:='1920x1080xMil';


Tmodelist.MaxColors:[0]:=16;
Tmodelist.MaxColors:[0]:=16;
Tmodelist.MaxColors:[0]:=256;
Tmodelist.MaxColors:[0]:=16;
Tmodelist.MaxColors:[0]:=256;
Tmodelist.MaxColors:[0]:=16;
Tmodelist.MaxColors:[0]:=256;
Tmodelist.MaxColors:[0]:=32768;
Tmodelist.MaxColors:[0]:=65535;
Tmodelist.MaxColors:[0]:=16;
Tmodelist.MaxColors:[0]:=256;
Tmodelist.MaxColors:[0]:=32768;
Tmodelist.MaxColors:[0]:=65535;

Tmodelist.MaxColors:[0]:=256;
Tmodelist.MaxColors:[0]:=32768;
Tmodelist.MaxColors:[0]:=65535;

Tmodelist.MaxColors:[0]:=256;
Tmodelist.MaxColors:[0]:=32768;
Tmodelist.MaxColors:[0]:=65535;

Tmodelist.MaxColors:[0]:=256;
Tmodelist.MaxColors:[0]:=32768;
Tmodelist.MaxColors:[0]:=65535;
Tmodelist.MaxColors:[0]:=16777216;

Tmodelist.MaxColors:[0]:=256;
Tmodelist.MaxColors:[0]:=32768;
Tmodelist.MaxColors:[0]:=65535;
Tmodelist.MaxColors:[0]:=16777216;

Tmodelist.MaxColors:[0]:=256;
Tmodelist.MaxColors:[0]:=32768;
Tmodelist.MaxColors:[0]:=65535;
Tmodelist.MaxColors:[0]:=16777216;


Tmodelist.bpp[0]:=#4
Tmodelist.bpp[0]:=#4
Tmodelist.bpp[0]:=#8
Tmodelist.bpp[0]:=#4
Tmodelist.bpp[0]:=#8
Tmodelist.bpp[0]:=#4
Tmodelist.bpp[0]:=#8
Tmodelist.bpp[0]:=#15
Tmodelist.bpp[0]:=#16
Tmodelist.bpp[0]:=#4
Tmodelist.bpp[0]:=#8

Tmodelist.bpp[0]:=#15
Tmodelist.bpp[0]:=#16
Tmodelist.bpp[0]:=#8
Tmodelist.bpp[0]:=#15
Tmodelist.bpp[0]:=#16
Tmodelist.bpp[0]:=#8
Tmodelist.bpp[0]:=#15
Tmodelist.bpp[0]:=#16

Tmodelist.bpp[0]:=#8
Tmodelist.bpp[0]:=#15
Tmodelist.bpp[0]:=#16
Tmodelist.bpp[0]:=#24

Tmodelist.bpp[0]:=#8
Tmodelist.bpp[0]:=#15
Tmodelist.bpp[0]:=#16
Tmodelist.bpp[0]:=#24

Tmodelist.bpp[0]:=#8
Tmodelist.bpp[0]:=#15
Tmodelist.bpp[0]:=#16
Tmodelist.bpp[0]:=#24


Tmodelist.MaxX[0]:=319,
Tmodelist.MaxX[0]:=319,
Tmodelist.MaxX[0]:=319,
Tmodelist.MaxX[0]:=319,
Tmodelist.MaxX[0]:=319,
Tmodelist.MaxX[0]:=319,
Tmodelist.MaxX[0]:=639,
Tmodelist.MaxX[0]:=639,


Tmodelist.MaxX[0]:=799,
Tmodelist.MaxX[0]:=799,
Tmodelist.MaxX[0]:=799,
Tmodelist.MaxX[0]:=799,
Tmodelist.MaxX[0]:=1023,
Tmodelist.MaxX[0]:=1023,
Tmodelist.MaxX[0]:=1023,
Tmodelist.MaxX[0]:=1023,
Tmodelist.MaxX[0]:=1279,

Tmodelist.MaxX[0]:=1279,
Tmodelist.MaxX[0]:=1279,
Tmodelist.MaxX[0]:=1279,
Tmodelist.MaxX[0]:=1279,
Tmodelist.MaxX[0]:=1279,
Tmodelist.MaxX[0]:=1279,
Tmodelist.MaxX[0]:=1279,

Tmodelist.MaxX[0]:=1365,
Tmodelist.MaxX[0]:=1365,
Tmodelist.MaxX[0]:=1365,
Tmodelist.MaxX[0]:=1365,
Tmodelist.MaxX[0]:=1919,

Tmodelist.MaxX[0]:=1919,
Tmodelist.MaxX[0]:=1919,
Tmodelist.MaxX[0]:=1919


Tmodelist.MaxY[0]:=199

Tmodelist.MaxY[0]:=199
Tmodelist.MaxY[0]:=199
Tmodelist.MaxY[0]:=239
Tmodelist.MaxY[0]:=239
Tmodelist.MaxY[0]:=479
Tmodelist.MaxY[0]:=479
Tmodelist.MaxY[0]:=479
Tmodelist.MaxY[0]:=479

Tmodelist.MaxY[0]:=599
Tmodelist.MaxY[0]:=599
Tmodelist.MaxY[0]:=599
Tmodelist.MaxY[0]:=599
Tmodelist.MaxY[0]:=767

Tmodelist.MaxY[0]:=767
Tmodelist.MaxY[0]:=767

Tmodelist.MaxY[0]:=719
Tmodelist.MaxY[0]:=719
Tmodelist.MaxY[0]:=719

Tmodelist.MaxY[0]:=1023
Tmodelist.MaxY[0]:=1023
Tmodelist.MaxY[0]:=1023
Tmodelist.MaxY[0]:=1023

Tmodelist.MaxY[0]:=765
Tmodelist.MaxY[0]:=765
Tmodelist.MaxY[0]:=765
Tmodelist.MaxY[0]:=765

Tmodelist.MaxY[0]:=1079
Tmodelist.MaxY[0]:=1079
Tmodelist.MaxY[0]:=1079
Tmodelist.MaxY[0]:=1079

Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4


Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=16

Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4
Tmodelist.XAspect[0]:=4

Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=16
Tmodelist.XAspect[0]:=16



Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=9

Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3

Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=3
Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=9
Tmodelist.XAspect[0]:=9



end;
