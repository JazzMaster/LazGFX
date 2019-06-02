This is the old SDL port.
Licensed GPL v2.

---		

state:  RELEASE .81
minor complier failure as I work thru some bugs.

---

This unit uses **modified** JEDI headers.

While the "C Syntax" is correct when utilizing SDL, the PASCAL needed some adjustment.
It makes more sense to use similar syntax, if possible.
Why this wasnt corrected and the patches released is beyond me- 

MY BGI HEADER defs are missing? RRRRR.
---

Other documentaion still applies here.
You wont notice much difference in code as its running or called-
	the differences should be internal.

#### Some SDL routines disappear- 

        knowing that /dev/input/jsX is the joystick
        /dev/input/ -the mouse, and even haptic device input

Can these still be used- or do we have to rewrite half of SDL?
Audio routines have been rewritten and the code is as much of a mess as KMS programming.

If youre going to rewrite code- make it optimal- and DO IT RIGHT. 
Dont drop useful routines and make others have to rewrite your code for you.


### Why SDL and not...

		BECAUSE ITS FUCKING BROKEN!

YOU WILL NEED SDL2 headers and development packages(including SDL Core) installed-
	to build
	recompile
	or USE these routines
	
Do not depend on the units sitting here(made under x64bit unix- my flavor of the week) to work for you.
**You will probably need to recompile these units.**

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
