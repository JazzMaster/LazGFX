## BGI Notes

I explicitly am targeting D2D, X11, and Quartz2D (thru SDL v1) for the BGI.<br>

REASONS:

        There is no guarantee that you have GTK/Gnome installed(you might).<br>
        X11 is usually installed, framebuffer/KMS is available otherwise.<br>
        Framebuffer is a RasPi fallback- GL ES is used otherwise.<br>
        Im not sure if SDL supports Framebuffer- but I have some working code.

We know 

        Windows has DirectX
        OSX has Quartz
        OS9 (should have) sprockets
        Most Unices have X11- up to date OSes have newer XOrg (vs XFree)
        RasPi can use FrameBuffer Mailbox acceleration

        Dos has "assembler acceleration" and/or VESA. 

### Cant I just USE SDL2_BGI and hook the C?

SDLBGI(SDL2) can be used- 
but "as-is" needs a lot of palette and other hacking.<br>

Im going to have to "diff the .12-.15 patches" for Mac OS9.

### Why SDL?

Its easier to understand SDL than it is X11/D2D/Quartz2D. I know this.<br>
We need Fallback code.<br>

You most likely will want SDLv2(Textures/hidden GL ops),<br>
but the compatibility for the "BGI" or "Graphics Context" is what Im after.

I will produce both SDL versions- **DO NOT MIX THEM. They are not-backwards compatible**.<br>
(They dont work that way, Ive tried.)<br>
Use v1 OR v2.

Output is **STILL ACCELERATED**.<br> 
These days we are not using slow GDI/GDI+ or Framebuffer calls-<br>
we have "driver supported" D2D/Quartz2d/X11 accelleration.

Very ancient win9x boxes may not have accelleration-<br>
but realisticly, who has those? They cant connect to the internet. 


However- 

        SDL2 has some limits I find annoying. 
        Further, Textures are the new default.<br>

Textures are one-way pipeline operations(GL). 

Newer systems can use SDL2. You probly wont notice **much** of a difference.

Keep in mind SDL is only 2d, anyone telling you that "SDL does 3d" is lying to you.<br>
(3D code either uses OpenGL- or Direct3D). <br>

Theres no such thing as a 2D "texture"- thats a 3D "object side".<br>
(You are just looking at it differently.)


#### The SDL_BGI Code "as-is" is bugged

Instead of forcing MESA(software ops) - lets probe for accelerated Renderers.<br>
Software rendering is **not accellerated**(BAD).

SDL2 cuts off some features that older OSes need- most SDL2 "BGI differences" can be backported to SDL1.<br>
(Texture->Surface ops)

(libuos , synapse, soil, freeimage will still be needed for some functionality)

The work so far- is not in vain- at any rate- the opposite- coding is accelerating by several factors.


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


#### Dos

Dos-Based systems generally dont connect to the internet.<br>
(You would be browsing in text mode if you were.)
    
        Again, Borland has a starting base , here.

RETRO-Computing (and curiosity) are really the only reasons for using (or emulating) such old systems.<br>
They are a real PITA to write code for, even with DPMI and LFB/VESA available.

(DOSBOX/DOSEMU and PC EM emulate these well.)



