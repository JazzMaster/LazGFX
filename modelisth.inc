type
//required

	graphics_modes=(

mCGA, 
VGAMed,vgaMedx256,
vgaHi,VGAHix256,VGAHix32k,VGAHix64k,
m800x600x16,m800x600x256,m800x600x32k,m800x800x64k,
m1024x768x256,m1024x768x32k,m1024x768x64k,m1024x768xMil,
m1280x720x256,m1280x720x32k,m1280x720x64k,m1280x720xMil,
m1280x1024x256,m1280x1024x32k,m1280x1024x64k,m1280x1024xMil,
m1366x768x256,m1366x768x32k,m1366x768x64k,m1366x768xMil,
m1920x1080x256,m1920x1080x32k,m1920x1080x64k,m1920x1080xMil);


//it appears we need the structure but not the data, as its assigned in the initGraph and sub units
//with Modelist.bpp do --case Modelist.bpp of ()

Tmodes=record
//non-negative and some values are yuuge
	DriverNumber:byte;
  	ModeName:array [Low(graphics_modes)..High(graphics_modes)] of string;
 	MaxColors:array [Low(graphics_modes)..High(graphics_modes)] of DWord; //QWord??
    bpp:array [Low(graphics_modes)..High(graphics_modes)] of byte;
  	MaxX:array [Low(graphics_modes)..High(graphics_modes)] of Word;
    MaxY:array [Low(graphics_modes)..High(graphics_modes)] of Word;
	XAspect:array [Low(graphics_modes)..High(graphics_modes)] of byte;
	YAspect:array [Low(graphics_modes)..High(graphics_modes)] of byte;
	AspectRatio:real; //things are computed from this somehow...
end; //record


