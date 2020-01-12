SDL2 implementation of LazGfx Core(Borland replacement BGI)

Leave the DLLs here.
The includes are required- Im abstracting out the main unit again.

When you build using fpc(lazarus cant hook SDL correctly)- 
	SDL.pas header will require the DLLS if building on win32/64.
	If building on unices, it will pull the installed SDL shared-object files from the OS location
		/usr/lib/x86_64-linux-gnu , usually 
		-You just need to install SDL12 and SDL2 dev packages.

I will aim to have both win32/win64 dlls available- 
as SDL1.2 still builds for playstation and older powerpc macs
(get the belkin usb grey/purple wifi stick -or similar, airport is outdated and insecure tech). 

The core routines are here- 
	I have to work on ellippses,polys, and fills- 
		but SDL has the routines(as does GL), Im not starting from scratch here(fillDWord).

The tricky parts are C-syncing the code.
(Bounds checks are everywhere as well.)



Licence updated to Apache/Mozilla "for your programming pleasure".

### Why SDL and not...

		BECAUSE ITS FUCKING BROKEN!

### Building	

type: 'fpc lazgfx.pas'<br>
It will exit cleanly -unless I broke something. <br>
DO NOT DEPEND ON THE BUILT UNITS to work for you, if in doubt- 

	RE-BUILD ALL SOURCE FILES.

---		

state:  WIP 0.8(buggy, see the released files)

---
You wont notice much difference in code(from SDL12) as its running or called-
	the differences should be internal.

Units SDL2_BGI and LazGFX will be merged. The C needs to be translated(and backported in).

#### Some SDL12 routines disappear- 

	Joystick/Haptic?

Sound is provided by libuos(Portaudio)


#### COPYLEFT
   
This code is a "black boxed spinoff" work written primarily for FPC in Pascal.
Nothing was reverse engineered- except published documentation.

Borland, INC. has been bought out and seems to "be no more".
Unlike Microsoft, I respect thier codebase and right to copyright.

Original code (for DOS) (c) Borland, INC. 
and ported (from C) via FreePascal (FPK) dev team, myself and a few others.

I have left reference in the code where it is due. 
I only accept credit where its due me.

## Final NOTE:

Code is universal language of itself. 
If I can understand German or russian programmers, you can understand my "sailored" english.
