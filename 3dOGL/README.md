## OpenGL

This is not and will never be a BGI or a BGI replacement. Those routines are 2D in nature only.<br>
You cannot mishmash 2/3D routines UNLESS using OpenGL inside of a Context..even as such the output
will not mimick a BGI, ever.

There are (some) 2D routines - I would not depend on them.

Text- moreso 3D TEXT- is for HUDs, overlays(like on TV), etc.

#### GLPT?? FContext??

GL PT is a way to get a Window handle in a uniform manner- to tap GL to.<br>
(Its like the FContext unit)<br>

You cannot setup GL without a window handle.<br>

Most of you have used GLUT- Ive intentionally removed that code- beyond being a PITA, proprietary hack-<br>
there are other serious flaws IMHO in using it.

#### Weve gone 3D !!

You have left FlatWorld behind and Approach a new 3D world co ordinate space,well...space.<br>
(Think Holodeck without the walls- theres nothing made yet)

People, Aliens, Objects(nouns), weather, and any type of ground surface are at your disposal..or not.<br>
Shove items to float in space if you wish...I dont care. Nobody cares..<br>
Its on you.


While HUD/menu 2D point co ords exist(I prefer them in the old ways)-

        They are no longer a forced standard
        They can be combined with other point coordinate systems(such as GL Float-based model) concurrently

Bpp is 24 or 32 bits, always. Once set- the context must be destroyed to change it.<br>
The support of any mode less than 24bpp in OpenGL (explicitly) must be emulated (or faked) somehow.

        This code has not been modified yet. It was a bug discovered when testing Laz-OGL routines.

### SHADERS

There has been - and will be heavy use of 3D shaders(vertex, lighting, fragment(color), etc) within most OGL apps.

This is somewhat confusing as its quasi-C and a sub GPU application being built..but the process works.<br>
See the Pyramid OGL DEMO- it builds a program from Pascal. SDL can be substituted for FreeGLUT, FContext,etc.

Vertex(point)<br>
and Fragment(Color) shaders are the most common used. You need both, usually.

FBO- Frame Buffer Overlays and Textures help you work around most other issues, usually.<br>
Sometimes this is confusing.



