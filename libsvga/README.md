libSVGA/libVGA is EXPERIMENTAL.

add this to the program or units:

uses
    svgalib,vgamouse;

you have to link the executable natively thru fpc, THEN do a:

        chmod u+s 

To make it SETUID.

Either this- or you run it as root. 

No worries- libSVGA drops priviledges- 
but does NEED direct hardware (VRAM) support to work-
much like X11 does.

To trigger the binary- 

DO NOT RUN WITHIN X11. 
IT WILL NOT WORK with the graphics "framebuffer" already in use-
or the results will be disastrous (and unpredictable)!

do a 'init 3' (as root) in one of the vTerms(1-6)-
be prepared to lose any open work in X11-or have booted with "linux single".
(The latter is unwise-it disables netowrking and multi-user logins.)

As with init 3- init 5 *SHOULD* bring you back to an X11 login. No guarantees.

All else fails- reboot(as root or sudo).

I will *TRY* to "port the code as it comes along", no guarantees....

NOTE:

issue loading the library?

ls /proc/fb (it should be there)
edit the file /etc/vga/libvga.config and remove the # at the start of the line for VESA chipsets, so it now looks like this:

		chipset VESA # nicely behaved VESA bioses

