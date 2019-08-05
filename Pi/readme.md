This is cross built.
Pardon the layout of this file- its not meant for GH, its meant to read as a text file.

Pi comes in two flavors:
		
		ARM HF(hard float) 	32bit		RasPi 1+2(v1 not available??)
		A(rm)Arch64		64Bit		RasPi Models 3+4


Approx Specs of Original Xbox(in terms of speed):

Pi-Zero is the Target- similar specs as per RasPi model 1
(I have a Custom-Padd use for this)

CPU		1GHz  Broadcom BCM2835 ARM11
memory		512MB LPDDR2 SDRAM
Storage		MicroSD Card Slot
Graphics	Broadcom VideoCore IV 300 MHz/400 MHz
Ethernet	None

HDMI Out	Mini HDMI socket for 1080p60

Power		5v 200mA   (average when idle)
		5v 250mA   (maximum under stress)

W Model(want this):

EtherNet	802.11n wireless LAN (wifi)
BlueTooth	Bluetooth 4.0


The thickening:
	
		Portable power at 2-3A (touch screen support) will yield limited time otherwise
		Li-Ion shall be used to overcome the limited time of use in portable mode

The goodness is that RasPi doesnt take excessively long to boot- 
		kernel optimization compilation can improve this.

Reduction of USB/FW/FTDI drivers in kernel can massively shrink boot times.
Use of Alpine or TinyCore (DiY OS) is reccommended.

MESA(openGL) over EGL -at minimum- is required. X11 is NOT.

Classes and Exception Unit are Reccommended and REQUIRED for proper debugging and operation.
The GL Core/SDL Core can be used without Lazarus/Lazarus Applications esp FS- on these devices. 

Power draw becomes an issue with larger screens.

BACON (Basic to C conversion)??

Mode 128/192MB Vram configs are the only ones supported. 
If you pull more- you cant do video conversion (or 264/265 playback).


-There are some framebuffers demos here. Talking to the GPU 'Mailbox' is how to get accellerated 'FX'..
(http://raspberrycompote.blogspot.com/2014/03/low-level-graphics-on-raspberry-pi-part_16.html)

see here for the Pascal conversion of the C.
(https://www.freepascal.org/docs-html/3.0.2/rtl/baseunix/fpmmap.html)

-This is in TTY/Console. X11 may use another method. Lazarus is supported on the RasPi.

(You may not be using it in portable mode- but likely--I will be)

Padd needs input buttons (ScrollU-PageUp,ScrollD-PageDown) 
The Touchscreen allows for text editing and pixel-based drawing. 
Maybe an embedded FIDO/UD2 hasher(for signing docs??)

		-perhaps later on a iPad-ish fingerprint reader??

ModeSetting(KMS) or "X11 running" seems to prevent mode (and depth) changes- 
RasPi doesnt seem to have this problem.


Adds the following modes (16) to the list(and an 8088 cpu check):

320 x 480
480 x 320
800 x 480
1024 x 600

15/16/24/32 bpp 
(2/4/8 bpp are emulated anyways)


