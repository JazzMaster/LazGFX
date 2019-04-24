## Framebuffer Graphics

Framebuffer Graphics routines for Freepascal. 

We dont need Xlib- we DO need: freeGLUT,GL,GLU

        (To which- we need an input handler ring buffer loop)
	
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

This uses a graphics context(modeswitched from text mode) and possibly CPU only optimizations
for 2D or 3D calls. X11 or Win32 environment **IS recommended**.


