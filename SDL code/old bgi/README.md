This is the old SDL port.
Licensed GPL v2.

---		

state:  RELEASE .83

---

This unit uses **modified** JEDI headers.

While the "C Syntax" is correct when utilizing SDL, the PASCAL needed some adjustment.
It makes more sense to use similar syntax, if possible.
Why this wasnt corrected and the patches released is beyond me- 

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
It wil lexit cleanly unless I broke something. 
THEN go and write an application based on "this" code.

I will work the SDL issues out- so everything works.


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
