## Framebuffer Graphics

Framebuffer Graphics routines for Freepascal. 

Im not sure if PTC gives us FB or not-
if not - we need to implement it.

It gives us X11, OSX, and WinAPI.
We dont need Xlib- we DO need: freeGLUT,GL,GLU
	Xlib is a freeGLUT/GL depend(s).

	You can do GL with PTC.
	
FreeImage is better than this hackish code- GOD I H8 libJPEG.	


---
This code may or may not work with a KMS Kernel.

-If it doesnt-

Then we need to upgrade code to support KMS.

---

### What does this accomplish?

Its a fallback for other code- use it if you like(and can get it working)

At it's heart, this project aims to allow programs running on a "small device" 
(such as a raspberry pi) -or "not running X11" -to be able to draw graphics using a simple API.

## Dependencies

Install `libpng-dev` and `libjpeg-dev` ONLY IF if you are using the PNG or JPEG
functions.

(libJPEG is NOT easy to understand, nor from experience -easy to get working)
PNG, BMP, and TGA(targa)- however- are easy to implement.
