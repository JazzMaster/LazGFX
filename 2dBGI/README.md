## Notes

I explicitly am targeting D2D, X11, and Quartz2D for the API.<br>
SDL Headers(I will check the newer FPC version) for 1.2 are missing routines **that should be present**.<br>
This is no way to write an API.

Therefore I will try to find the resources to do this the right way- using the OS hooks provided.<br>
**This may not be easy, but its the correct way to do things.**

In the meanwhile- SDL2 it seems is the best code to hook.<br>
I have working external Audio routines, joystick/haptic and other input will have to be implemented some other way.<br>
Network API has yet to be tested.

This is not Borland's code, therefore "Borlands Graphics interface" is not an appropriate name.<br>
(I dont care if you like it- its "JazzMans Graphical Interface", Lazarus Graphics is more appropriate.)

**Lazarus Programmers will need to WAIT until TCanvas is rewritten, unless they want OpenGL graphics(3D).**
OpenGL appears to otherwise not be affected in the same manner, as long as you remember that the Context is inside a window.<br>
Therefore- "something must handle the window".<br>
(Both components are required.)

REASONS for doing this:

        There is no guarantee that you have GTK/Gnome installed(you might).<br>
        X11 is usually installed, framebuffer/KMS is available otherwise.<br>
        Framebuffer is a RasPi fallback- GL ES is used otherwise.<br>
        Im not sure if SDL supports Framebuffer- but I have some code that works(not libPTC).

We know 

        Windows has DirectX
        OSX has Quartz
        OS9 (should have) sprockets
        Most Unices have X11- up to date OSes have newer XOrg (vs XFree)
        RasPi can use "FrameBuffer Mailbox acceleration"

        Dos has "assembler acceleration" and/or VESA. 

### Cant I just USE SDL2_BGI and hook the C?

SDLBGI(SDL2) can be used- 
but "as-is" needs a lot of palette and other hacking.<br>

Im going to have to "diff the .12-.15 patches" for Mac OS9.<br>
I have no idea if JEDI sources tap the newer libs or not.

### Why SDL?

**MODIFIED JEDI HEADERS ARE USED**

It is easier to fix the flaws(on Github) than fix the JEDI teams work that is published online.

Its easier to understand SDL than it is X11/D2D/Quartz2D. I know this.<br>
SDL accomplishes the mission.<br>

It appears that the headers may be out of date. FPC uses newer patchset than JEDI provides.<br>
JEDI headers were all we had- until recently.<br>
(This is certainly the case for SDL1.2.)


You most likely will want SDLv2(Textures/ GL ops),<br>
but the compatibility for the "BGI" or "Graphics Context" is what Im after.

I will produce both SDL versions- **DO NOT MIX THEM. They are not-backwards compatible**.<br>
(They dont work that way, Ive tried.)<br>

Use one or the other.

If you are trying to do this with Lazarus:
**There are too many Lazarus flaws trying to link in SDL that it isnt funny. PLEASE WAIT**


Output is **STILL ACCELERATED**.<br> 
These days we are not using slow GDI/GDI+ or Framebuffer calls-<br>
we have "driver supported" D2D/Quartz2d/X11 accelleration.

Very ancient win9x boxes may not have accelleration-<br>
but realisticly, who has those? They cant connect to the internet. 


However- 

        SDL2 has some limits I find annoying. 
        Further, Textures are the new default.<br>

Textures are one-way pipeline operations(GL). 

Newer systems can use SDL2. <br>
You probly wont notice **much** of a difference.

Keep in mind SDL is only 2d, anyone telling you that "SDL does 3d" is lying to you.<br>
(3D code either uses OpenGL- or Direct3D). Combining the two is hackish at best.<br>

Theres no such thing as a 2D "texture"- thats a 3D "object side".<br>
(You are just looking at it differently.)


#### The SDL_BGI C Code is bugged

SDL uses MESA on Unices(for software mode) drawing/rendering.

Instead of forcing MESA(software ops) - lets probe for accelerated Renderers.<br>
Software rendering is **not accellerated** (BAD).

SDL2 cuts off some features that older OSes need- most SDL2 "differences" can be backported to SDL1.<br>
(Texture->Surface ops)

(libuos , synapse, soil, freeimage will still be needed for some functionality)

The work so far- is not in vain- at any rate- the opposite- coding is accelerating by several factors.

#### SDL code is bugged

Originally it was written for "CRT Beam racing" when making updates.<br>
On LCD and newer physical screens, this is no longer necessary, however can leave stray pixels behind.<br>

Modern Double buffering uses "full frame" updates (like B-frames in movies).

        SDL_Flip(when double Buffering or using HWSurfaces) is the same as SDL_UpdateRect(with x,y,w,h=0) -
        and will fall back to that operation mode if needed.

BitDepths and colors are passed aligned the way that Ive written them.<br>
Most people do not care to do this- and it creates issues when using OpenGL.<br>
Aligned data moves are faster and do not require re-work midflight.

Less than 8bpp are 8bpp palettes with "less color data". Less than 8bpp simply is not supported any other way.<br>

SDLv1 Get/PutPixel Core routines need to be reimplemented.<br>
SDL2 has Renderer support so these had to be modified to support the renderer.<br>

These are core routines- most other functions will not work unless these routines are implemented.<br>
While SDL2 has some routines that may not need PutPixel() every call- SDL1 does NOT.<br>

Code is intentionally written to support double buffer (offscreen) rendering methods.<br>
The VSYNC hint (and VSYNC timed drawing) may have to be set.

Keep in mind, Batch operations in VideoBuffer(VESA: LFB) space are faster than recursive calls to Put/GetPixel.<br>
**This is where SDL is bugged and slows down**.

There is also a SSE glitch on x86(i386) builds with FPC. It has to do with code alignment.<br>
Either write code for SSE on x64 processors or use MMX instead.<br>
This bug is hard to work around (FPC/GCC core) but modern processors with SSE2+ are probably x64 based anyways.

### WHYE WHY WHY not Tcanvas?

I dont want to hear the bickering. Could it be done, yes-and with acceleration.

        1- This is Lazarus only implementation. OSes not supporting Lazarus wont have the routines. (non-portable)
        2- The code is a mess.
        3- Class(instantiated) structures (TCanvas.PutPixel, etc...) need to be rewritten as per OS spec-not an easy task
                This requires knowledge of X11,OSX, and Win32 DirectX (5-7) APIs at a minimum                
                (However, We could hook SDL in here and forgettabout it.) 
                        On most Unices: SDLv1 is shipped, you have to ask for version 2.

        4- Which SDL(if any) method do we use?? 
                (Most people would say version 2 but HwSURFACE modes and version 1 can be used)
                This problem is highlighted HERE - with my code- with older systems. You cant mix the code.
                Some games like X11 flight sims seem to use SDLv1 and crash on mode switch(X11 -GL Threads issue?? Glitch??).

This is not my focus right now- but it may be soon.<br>
The focus is the use of Graphics unit "under windowing environments" with "framebuffer fallback".<br>
Unices have not had any working graphics units (if ever) since Kernel Framebuffer support was removed- and X11 in use.

Certainly games and aplications have not been written with what exists.<br>
Buggy developers assume that the Lazarus graphics unit is required- its not. Add it only when using TCanvas.<br>
Can TCanvas be used Fullscreen? YES! 

OpenGL is already implemented through FContext- theres no need to tie a Tcanvas to it.<br>

## OSes Supported

#### Windows Minimum version 

We will be stopping compatibility at Win 2K.
Windows 2K can use DirectX9c -(you have to hunt down an installer), XP ships with DX7+<br>
Win2K doesnt suffer from "activation bugs"-that service didnt exist yet.<br>
So- if you are having issues w emulating XP(and keeping it active)--try Win2K (Pro/Workstation) instead.

SDL wants XP- but ultimately its due to lack of DirectX being compatible- <br>
This can be worked around.

There is no reason to go below this- these OSes are very insecure - if they can ever surf the net.<br>


#### Win 95 and 98

Win 95/98 (DirectX 5 era) cannot connect to the "modern web" -choke on cryptography and algorithms, and 
do not thave the resources required to load sites like facebook. (often have less than 128MB ram)

Keep in mind that computers of this era need every ounce of RAM- max everything out, or it will be swapping 
to disk internally due to on-demand paging so much that you wont get anything done.

Im not saying you CANT write code for these platforms- Im saying "it may not be worth your time".
SDL1 does support Win9x systems.

(PC EM - if you are going to emulate)

#### Mac OS9

OS9 capable systems usually had a 512MB Dimm slot somewhere.<br>
This would put them on -par with WinME, Win2k -and possibly low end WinXP systems(if added).

CodeWarrior Base (OS9) is used as a base (Borland had a working Graphics lib) starting point.<br>

DrawSprockets(pre-OSX) are preferred over QuickDraw/QuickDraw GX.<br>
When OS9 updated QuickDraw for color modes(dodgy,hackish code) - the best performing was DrawSprockets.<br>
(The API merged into Quartz with OSX.)

OS9 WILL NOT **AND CANNOT** SUPPORT SDLv2.<br>
If you can dual-boot back into OSX- do so. Then you can use SDLv2 and OpenGL.


#### Dos

Dos-Based systems generally dont connect to the internet.<br>
(You would be browsing in text mode if you were.)
    
        Again, Borland has a starting base , here.

RETRO-Computing (and curiosity) are really the only reasons for using (or emulating) such old systems.<br>
They are a real PITA to write code for, even with DPMI and LFB/VESA available.

(DOSBOX/DOSEMU and PC EM emulate these well.)

---

14 Nov 2019:
SDL2 Palette Modes remain untested, partially implemented.

(Look for CGA modes 1-4)

SDL1 headers will need some work to get this section working correctly.
By default SDL team DOES NOT IMPLEMENT Get/PutPixel, which is required.


---

#### The Boat Demo

In case youre wondering- this demo is from a book.<br>
It was taken from Owen Bishops Java demo.<br>

It uses the following draw method code:
(You still need this unit and SDL.)

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


