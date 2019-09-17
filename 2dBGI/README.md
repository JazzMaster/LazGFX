## BGI Notes

I explicitly am using D2D, X11, and Quartz2D.<br>
Its not something people usually target. Usually add-on libs like Cairo(GTK) are used.<br>

There is no guarantee that you have GTK/Gnome installed(you might).<br>
X11 is usually installed, framebuffer/KMS is available otherwise.<br>

We know 

        Windows has DirectX
        OSX has Quartz
        OS9 (should have) sprockets
        Dos has assembler or VESA. 
        Most Unices have X11- up to date OSes have newer XOrg (vs XFree)
        RasPi can use FrameBuffer Mailbox acceleration

#### Why not just do it in SDL?

SDLBGI(SDL2) can be used- but "as-is" needs a lot of palette and other hacking.<br>
I have notes on this. Use of SDL1 would be better. Im going to have to "diff the .12-.15 patches" for OS9.<br>
(There may be a way to use 1.2.15 on OS9)

Its easier to understand SDL than it is X11/D2D/Quartz2D. I know this.

However- SDL2 has some limits I find annoying. Further, Textures are the new default.<br>
Textures are one-way pipeline operations(GL). 

Instead of forcing MESA(software GL ops) "in 3D Perspective"- lets just do it in 2D to begin with.<br>
Your OS already uses core APIs. Its a matter of "tapping the right ones".

(Nobody said this was easy.) Further- we are looking for acceleration.<br>
Software rendering is not accellerated(although you can probe if its supported).

SDL2 cuts off some features that older OSes need- most SDL2 "BGI differences" can be backported to SDL1.<br>
(Texture->Surface ops)

Newer systems can use SDL2. Keep in mind SDL is only 2d, anyone telling you that "SDL does 3d" is lying to you.<br>
(3D code either uses OpenGL- or Direct3D).

As far as- CAN IT BE DONE, yes.<br> 
I could uphack SDL2_BGI(C) in Pascal and "be done with it"-backporting the changes for older systems.<br>
(libuos , synapse, soil, freeimage may still be needed for some functionality)


SDL1 at least will use Quartz2D. I will check into the rest- I have X11 functionality (or soon will).<br>
I may just integrate Linux framebuffer and X11 ops into the SDL units that Ive made.

The work is not in vain- at any rate- coding is accelerating by several factors.

#### Windows Minimum version 

DirectDraw has been scrapped. <br>
We will be stopping compatibility at Win 2K.

Windows 2K can use DirectX9c.<br>
WIn 2K is Pre-XP. XP has been around forever.<br>
Win2K doesnt suffer from "activation bugs"-that service didnt exist yet.


There is no reason to go below this- these OSes are very insecure - if they can ever surf the net.<br>


#### Win 95 and 98

Win 95/98 (DirectX 5 era) cannot connect to the "modern web" -choke on cryptography and algorithms, and 
do not thave the resources required to load sites like facebook. (often have less than 128MB ram)

Keep in mind that computers of this era need every ounce of RAM- max everything out, or it will be swapping 
to disk internally due to on-demand paging so much that you wont get anything done.


#### Mac OS9

OS9 capable systems usually had a 512MB Dimm slot somewhere.<br>
This would put them on -par with WinME, Win2k -and possibly low end WinXP systems(if added).

CodeWarrior Base (OS9) is used as a base (Borland had a working Graphics lib) starting point.<br>

DrawSprockets(pre-OSX) are preferred over QuickDraw/QuickDraw GX.<br>
When OS9 update QuickDraw for color modes(dodgy,hackish code) - the best performing was DrawSprockets.<br>
(The API merged into Quartz with OSX.)


#### Dos

Dos-Based systems generally dont connect to the internet.<br>
(You would be browsing in text mode if you were.)
    
        Again, Borland has a starting base , here.



