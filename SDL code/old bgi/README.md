This is the old SDL port.
Licence changed "for your programming pleaseure".

---		

state:  RELEASE .84

---

Other documentaion still applies here.
You wont notice much difference in code as its running or called-
	the differences should be internal.

#### Some SDL routines disappear- 

	Joystick/Haptic?

Sound is provided by libuos(Portaudio)


### Why SDL and not...

		BECAUSE ITS FUCKING BROKEN!

YOU WILL NEED SDL2 headers and development packages(including SDL Core) installed-
	to build
	recompile
	or USE these routines
	
Do not depend on the units sitting here(made under x64bit unix- my flavor of the week) to work for you.
**You will probably need to recompile these units.**

type: 'fpc lazgfx.pas'
It will exit cleanly -unless I broke something. 

-THEN go and write an application based on "this" code.

The CRUX of the BITCH of the problem is that "Graphics contexts" are not passed between subroutines.
Once you fix this- the application now has the handles--and subroutines--to do what you need the app to do.

SDL: You cant render (or take input) on a different thread than the one you started with.
BULLSHIT.



#### COPYLEFT
   
This code is a "black boxed spinoff" work written primarily for FPC in Pascal.
Nothing was reverse engineered- except published documentation.

Borland, INC. has been bought out and seems to "be no more".
Unlike Microsoft, I respect thier codebase and right to copyright.

Original code for DOS (c) Borland, INC. and reported (from C) via FreePascal (FPK) dev team, myself and a few others.
I have left reference where its due in the code. I only accept credit where its due me.

## Final NOTE:

Code is universal language of itself. 
If I can understand German or russian programmers, you can understand my english.
