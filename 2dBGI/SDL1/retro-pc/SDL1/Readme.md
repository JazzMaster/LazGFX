This is the JEDI SDLv1 Pascal original Pascal headers.<br>
They will need to be modified.

        DWords only exist for CPU Math operations on these older systems.

        The old (Borland) hack method tied Longwords, Pointers to 32bits with DPMI and LFB modes.
            However- this only works on 386,486, early Pentium systems that supported it.

        CGA graphics were common- This limited available colors to (Nibbles and) BYTEs (and 4 planar modes).
        Audio was limited to the PC Speaker, CDROMs didnt exist yet.

Other than educational and retro programmer use- these systems are relics.<br>
Even under PCem emulation(8088 @8/16Mhz), there will be difficulties(who still has these?).

Yes- SDL1 existed for Borland Pascal. <br>
Output should be similar to Framebuffer modes in Older Linux-es(KMS is used now) - and RasPi.<br>
I have intentionally removed the errant code for FPC because usually its not needed(and 1000s of line of fluff).<br>

        We dont need every compiler listed and known to man to compile the code- just FPC and BP/TP 5 (unless you have v7).


