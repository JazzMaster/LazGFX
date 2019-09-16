Unit RetroPC;
//Retro 8088+ Dos - Based libGraph override (patched FPC version)

{
Most libGraphs units do not take into account several things.

1- assembler speed
2- potential inline of code
3- limited hardware
4- Borland's CRT.Delay bug (massive hit to old code, if unpatched or unhacked)
5- Palletted modes: Are we using CGA, EGA, or VGA (lots of hardware inbetween but its rare)
        IFDEF go32v2 (486+)

   Pallettes are NOT FIXED. Everyone assumed they were.


6- CPU optimizations - using on i8088, i286, i386--or i486(go32v2)??
        This is both build-time and compile time derived.

7- teensy resolutions allowed "Stack smashing recursive floodfills" - and other nasty code hacks
8- DPMI. Most libGraph units dont use VESA (or LFB) when available- thats an addon unit.
        Modern day OSes DO.

9- Driver accelleration??
10- memory segmentation (requires this unit be split out)

I will have to look at i8086 graphics unit before I add things here.

}

interface


implementation


begin
end.
