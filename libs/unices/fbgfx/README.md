## Framebuffer Graphics

Framebuffer Graphics routines for Freepascal. 

A lot of what Im seeing requires libsvga or libvga be installed.<br>
You can compile an app- at least in C to use it using VESA or VGA setting.<br>
When I use said- I get zero output.

I cannot get the helper code and /dev/svga to build properly.

KMS is another workaround, however, this code needs to build FIRST.

I need the includes imported into the main routine and some help from unice' man pages...<br>
...but I think I can get this to compile at least.

	
FreeImage is better than this hackish code- GOD I H8 libJPEG.	


### What does this accomplish?

Its a fallback for other code- use it if you like(and can get it working)

At it's heart, this project aims to allow programs running on a "small device" <br>
(such as a raspberry pi) -or "not running X11" -to be able to draw graphics using a simple API.

## Dependencies

(libJPEG is NOT easy to understand, nor from experience -easy to get working)<br>
PNG, BMP, and TGA(targa)- however- are easy to implement.

-Ported from C by yours truely.
