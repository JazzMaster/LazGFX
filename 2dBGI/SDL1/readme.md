SDL1.2 implementation of LazGfx Core(Borland replacement BGI)

Leave some sort of Windows DLLs here. 

These are 64bit ones, 32bit ones are in the folder- 
if you need the older compatibility ones(32bit), remove those here('rm *.dll') and put the other ones here.
(keep your download- you might want all of the DLLs - and I need something to test with)


When you build using fpc(lazarus cant hook SDL correctly)- 

	SDL.pas header will require the DLLs if building on win32/64.

	If building on unices, it will pull the installed SDL shared0object files from the OS location
		/usr/lib/x86_64-linux-gnu , usually 
		-You just need to install SDL12 and SDL2 dev packages.
		
Distribute the DLLs when you distribute your application of LazGfx, PLEASE!<br>
(Dont make people hunt these down.)


The core routines are here- 
	I have to work on ellippses,polys, and fills- 
		but SDL has the routines(as does GL), Im not starting from scratch here(fillDWord).

The tricky parts are C-syncing and Line drawing.
(Bounds checks are everywhere as well.)

Licence updated to Apache/Mozilla "for your programming pleasure".

### Why SDL and not...

		BECAUSE ITS FUCKING BROKEN!
	
Do not depend on the units sitting here(made under x64bit unix- my flavor of the week) to work for you.
**You will probably need to recompile these units.**

type: 'fpc lazgfx.pas'
It will exit cleanly -unless I broke something. 

-THEN go and write an application based on "this" code.

The CRUX of the BITCH of the problem is that "Graphics contexts" are not passed between subroutines.
Once you fix this- the application now has the handles--and subroutines--to do what you need the app to do.

SDL: You cant render (or take input) on a different thread than the one you started with.
BULLSHIT. I JUST DID IT.

---		

state:  WIP 0.58(buggy, half-assed in places)

--

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
