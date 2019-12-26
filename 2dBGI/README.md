## Notes

I explicitly am targeting D2D, OpenGL(2D), and QDraw2D/Quartz2D, even through SDL.<br>

Noob notes:
DONT PRESUME ANYTHING.

## Which SDL to use?

(I am so confused...)

how old is your computer?<br>
**Seriously**.

Very old computers should use the older X11(r6?) vs XOrg and/or older Windows and os9, therefore-

		-they should use SDL1.

Newer computers can benefit from video acceleration and true 32bpp modes offered by SDL2.
Use of the renderer (and Textures) is better(and faster), but **know their limits**.

		However, you lose a few things in the process. (which uos is trying to fill the gap with).

If you use SDL1 on new hardware you might not get HWSurfaces (or acceleration).<br>
SDL2 wont run on older hardware.<br>
In this regards, they are not backward-compatible.

I will produce both SDL versions- **DO NOT MIX THEM. 
(They dont work that way, Ive tried.)<br>

Use one -<br>
or the other.

However- 

        SDL2 has some limits I find annoying. 
        Textures are "usually" one-way pipeline operations(GL). 

Keep in mind SDL is only 2d, anyone telling you that "SDL does 3d" is lying to you.<br>
(3D code either uses OpenGL- or Direct3D). Combining the two is hackish at best.<br>

Theres no such thing as a 2D "texture"- thats a 3D "object side".<br>
You are just looking at it differently in 3 dimensions.<br>
(Adjust your ModelVIew matrice...)


### ARG! My output is corrupted!

corrupted video(windows?) are due to task switching the vram out to other apps, even the window manager- that are running.<br>
you arent clearing that corruption, when accessing the vram your app uses- youre just throwing more data at it.<br>
**This is why things get corrupted.**

To fix this:
	
		Some use single bufferring instead of double. Not wise.

when double bufferring:

		Clear, blit(update from elsewhere), then flip(or update rect).

YES, both 1.2 and 2.0 have "clear" methods.

SDL1:

		SDL_FillRect(MainSurface,Nil,0),Blit , then (UpdateRect) flip.
SDL2:

		RenderClear,RenderCopy(Put texture to the renderer), RenderPresent

Using successive Flip/Present calls (instead of clearing) is hackish.<br> 
It accomplishes the same, but its not the right way to do it.

Remember, render one frame- then bail. Come back for more.<br>
**DO NOT RENDER IN A LOOP(render thru a videoCallback function instead)-<br>
 it blocks input processing and can lead to CPU lockups otherwise**


Both JEDI hack-team and SDL team seem to have some major flaws, 
I believe SDL(++) can be rewritten BETTER in FPC than C devs have written similar in C. 
You have a "Lazarus limitation" for the time being.

JEDI Headers are severely lacking (user :EVxyzza) and are broken in places they should not be, 
(I am using modified ALTERNATE Pascal JEDI headers that have been patched).

Network API has yet to be tested.

**Lazarus Programmers will need to WAIT until TCanvas is rewritten, unless they want OpenGL graphics(3D).**

OpenGL appears to otherwise not be affected by Lazarus in the same manner as SDL is, 
as long as you remember that the Context is inside a window.(you need GLUT or something to switch to Fullscreen)<br>

Therefore- "something must handle the window".<br>
(Both components are required.)

We know 

        Windows has DirectX
        OSX has Quartz
        OS9 (should have) sprockets
        Most Unices have X11- up to date OSes have newer XOrg (vs XFree)
        RasPi can use "FrameBuffer Mailbox acceleration"
        Dos has "assembler acceleration" and/or VESA. 

### Cant I just USE SDL2_BGI and hook the C?

SDLBGI: SDL2 (in C) can be used- 
but "as-is" needs a lot of palette and other hacking.<br>

The code is "very dodgy" in places.<br> 
If you need something "in a pinch" that "fully" supports "most" BGI functions, use it.

Otherwise, use my routines. They are more "feature complete".


### Can I mix Other SDL code with LazGfx?

In otherwords:

	Do I have to limit myself to the BGI Core?
	NO. 

Yes, you can mix the routines-

		as long as a "Graphics Rendering Context" is open(call Initgraph first).

There can be a few issues- most SDL functions are not checked for sanity and need to be wrapped, but if you "feel the need"
I will not stop you. (SDL doesnt care, either, just give it a Surface -or Renderer- to work with)

Same for OpenGL. <br>
(Passing this context around took a bit of work.)

Passing the window handler around will fix the Lazarus<-->SDL link bug, allowing Lazarus apps to use SDL.<br>
(I dont know how to do this, its not working)

### SDL? You can do better.

Its easier to understand SDL than it is X11/D2D/Quartz2D. I know this.<br>
SDL "accomplishes the mission".<br>
It is a starting point for me before I start rewriting a dozen other units on five platforms (in 15 languages).

SDL code is not generally of very much use by itself.<br>
People just dont understand how to use it- or its shortcomings(theres a lot).

If you think you can do better- stop talking smack, and start writing code. <br>
(CLEAN LOGICAL CODE, not that VC and CPP OOP garbage.)


#### The SDL_BGI C Code is bugged

YES, I know. Its SAD.

BitDepths and colors are passed aligned now.<br>
SDL and GL assume you have done this.<br>

Aligned data moves are faster and do not require re-work midflight.<br>
**GL will crash** if your color data is not aligned properly.

Less than 8bpp (and 8bpp) are palettes(LUT w SDL_COLOR limits) with "less color data". 

Code is intentionally written to support double buffer (offscreen) rendering methods.<br>
The VSYNC hint (and VSYNC timed drawing) may have to be set on some OSes.

Keep in mind, Batch operations in VideoBuffer(VESA: LFB) "Surfaces" are faster than recursive calls to Put/GetPixel-<br>
(or the Renderer equivalents).

**This is where SDL is bugged and slows down**.

There is also a SSE glitch on x86(i386) builds with FPC. It has to do with code alignment.<br>
Either write code for SSE on x64 processors or use MMX instead.<br>
This bug is hard to work around (FPC/GCC core) but modern processors with SSE2+ are probably x64 based anyways.


### WHYE WHY WHY not Tcanvas?

I dont want to hear the bickering. <br>
Could it be done, yes-and with acceleration.

        1- This is Lazarus only implementation. 
	OSes not supporting Lazarus wont have the routines. (non-portable)

        2- The code is a mess.

        3- Class(instantiated) structures (TCanvas.PutPixel, etc...) need to be rewritten per OS 

                This requires knowledge of X11,OSX, and Win32 DirectX (5-7) APIs at a minimum                

        4- Which SDL(if any) method do we use?? 
                (Most people would say version 2 but HwSURFACE modes and version 1 can be used)

                This problem is highlighted  with my code- on older systems. You cant mix the code.
		

Unices have not had any working graphics units (if ever) since Kernel Framebuffer support was removed- and X11 used.

Can TCanvas be used Fullscreen? YES! 

There is hope for TCanvas- but the author, Tom Gregorovic(Tombo) , is on subversion.<br>
The Package name is LazRGBGraphics. With some modifications- it can incorporate everything here.
-As such, I am including it here on GH.

As such, I will focus primarily on Unices and SDL command-line apps until further notice.<br>
If Windows port builds, its a bonus, but I wont stop it from building.


## OSes Supported

### Unices

		:-)

This should work on most unices/Linux-es that fpc (or Lazarus) supports.<br>
The only requirement is SDL 1 or SDL 2(and its depends).

If SDL doesnt support your box, I cant either.

Dont forget to install the dev libraries/units if building source code.

Basically, if its TUX- it should build(assuming I havent broken the code)-and work.<br>
I dont have BSD, I dont USE BSD(open or free)--please dont ask about it.

NO, I dont give a damn about backwards POSIX, AIUX, SOUIX (OS9 terminal hack) compatibility.<br>
Either it works, or it doesnt. (Its a confusing mess to implement.)


### Windows  

**WINDOWS 2K is the MINIMUM SUPPORTED WINDOWS OS**

Windows 2K can use DirectX9c -(you have to hunt down an installer), XP ships with DX7+<br>

Win2K doesnt suffer from "activation bugs"-that service didnt exist yet.<br>
So- if you are having issues w emulating XP(and keeping it active)--try Win2K (Pro/Workstation) instead.

Be sure and get the "128Bit security patch", not just Service Packs 4 and 5.

NTFS "has file loss", be aware of this in Win2K- Win10. <br>
(The bug has not been patched to date, Ive recently lost 1.2TB on Win10, the drive is fine, its the FS.)

#### What about Win 95 and 98?

95/98/and ME(486-Pentium era) are "glorified user-interfaced DOS-boxes".<br>
Code for DOS (go32v2) and youll be fine here.

These OSes do not use the "NT core"(VM86 cpu modes).


### Mac OS9

OS9 capable systems usually had a 512MB Dimm slot somewhere.<br>
This would put them on -par with WinME, Win2k -and possibly low end WinXP systems(if added).

CodeWarrior Base (OS9) is used as a starting point.<br>
Syntax is similar to fpc's MacPascal modes, and win32 build mode(xp era) is available, this is much like Lazarus.
(CW Pro v4 is the last to support Pascal.)

DrawSprockets(pre-OSX) are preferred over QuickDraw/QuickDraw GX. <br>
Documentation does exist.<br>

OS9 WILL NOT **AND CANNOT** SUPPORT SDLv2.<br>
If you can dual-boot back into OSX- do so. <br>
-Then you can use SDLv2 and OpenGL.

### OSX

OSX can use Lazarus(now)- or the older FP UInterfaces+XCode method. Both work.
Be wary of "distribution specific issues" like FAT BINARIES and "forced 64bit compatibility" imposed by "Apple".

fpc should run but its buried inside of Lazarus on the command line.
(/usr/local/lib/something/somewhere....)

### Dos

Dos-Based systems generally dont connect to the internet.<br>
(You would be browsing in text mode if you were.)
    
        Again, Borland has a starting base , here.
	The trick is to setup Packet Communications and use (NE2000?) an ISA network card with dos mode drivers(10BaseT).

RETRO-Computing (and curiosity) are really the only reasons for using (or emulating) such old systems.<br>
They are a real PITA to write code for, even with DPMI and LFB/VESA available.

(DOSBOX/DOSEMU and PC EM emulate these well.)

There are 3 modes:

	PURE 8088/86 (fpc i8086 8-bit port)
	286 (used??) (16bit cpu port)
	386-486DX(Qemu can take over here- fpc go32v2 can build Pentium/Pentium II code)

Integer and math addressing still use 16bits, until the 486.
Newer Pentiums and clones add multimedia cpu extensions.


#### The Boat Demo

The boat image is actual TCanvas output:

Heres how you draw it.

In case youre wondering- this demo is from a book.<br>
It was taken from Owen Bishops Java demo.The port was for a Pascal book.<br>
(Its not my work, I dont take credit for it)<br>

Expected output size: (640,480)

---

SetBackgroundColor(SkyBlue);

SetColor(Blue);
SDL_Rect(0,310,640,480); //the ocean


//brush and pen color are a TCanvas hack- bump in one pixel of specified Poly and trace it with a different color
//ignored for now- but the boat will not have a red outline.

SDL_FilledPolyGon((180,60),(180,380),(340,380));
SDL_FilledPolyGon((180,60),(145,120),(120,180),(105,240),(110,300),(120,340),(145,375),(175,380),(160,340),(145,300),(140,240),(150,180),(160,120));

SetColor(Red);
SDL_FilledPolyGon((80,395),(130,420),(360,420),(380,400);
SDL_FilledPolyGon((180,40),(180,60),(220,50));
SDL_Rect(180,40,178,420);

Fontsize(12);
FontColor(Green)
outText(150,50,'Graphics with Lazarus')


### Credit

This is not Borland's code, therefore "Borlands Graphics interface" is not an appropriate name.<br>
(I dont care if you like it- its "JazzMans Graphical Interface", Lazarus Graphics is more appropriate.)

If I didnt write the code, Ill let you know. <br>
Otherwise I wrote it. I wrote 98% of this unit myself.<br>
The "C merge" will change this percentage, the Professor/Doctorate seems to have a better implementation of input APIs.

The Palette and ModeList code is 100% my implementation.<br>
I take no credit for SDL/SDL2 nor JEDI teams code(just my mods and hacks).

