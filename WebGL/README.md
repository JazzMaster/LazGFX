This is derived from (Github-WebGL)[https://github.com/mdn/webgl-examples]

This is based off of GL ES- no direct GL rendering, uses shaders only.<br>
There are a few APIs to help, here. I will add more as time goes on.

A huge core of this library involves direct GL rendering/ similar SDL1 calls in 2d.<br>
Palettes are generally not allowed in 3D space- and you are in minimal 24bpp, although 32 bpp may be allowed.

Bearing this in mind- can it be done thru a browser- YES. <br>
Is it the same library as I am providing-NO.

The goal was to write code for the Context- start in 2d, and try to learn/teach 3d.<br>
GL ES automagically assumes that you know GL Core- most do not, nor understand how it works.

GL ES is for 3D scenes- like OpenSceneGraph is used for(GTA-Like environment).

I find that games are usually compiled- not "scripted" or "ran".<br>
Shortcutting to WebGL and Python is just that. Cheating.

Just because it CAN be done- doesnt mean it SHOULD be done...

GAMBAS is clearly an exception here- as is VB.(I havent written basic in forever)


