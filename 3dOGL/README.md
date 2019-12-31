## OpenGL

The new co-ordinate sytem requires some 3D thinking (and College algebra).<br>
No, I CANT go easy on you, it requires MATH. Lots of math.<br>
Brush up on your (intermediary) "matrice math".

-Then follow me in 3D, because if you thought the games "Portal" or "PREY" were whack...HERE WE GO...<br>
lookout for the- "OMG, we're rotating....."

When things dont twist(or pull) correctly(or are too far away)- "blame your math with the matrix".<br>
-because thats where the fault usually lies.

Furthermore, decide on LEFT or RIGHT handed(view and models), early on.<br>
-Try to be consistent.

While HUD/menu 2D point co ords exist(I prefer them in the old ways)-

        They are no longer a forced standard(but I like 0,0 on the UL corner)
        They can be combined with other point coordinate systems(such as GL Float-based model) concurrently


**Bpp is 24 or 32 bits, always.** <br>
Once set- the context must be destroyed to change it.<br>

**The support of any mode less than 24bpp in OpenGL (explicitly) must be emulated (or faked) somehow.**

        This code has not been fixed yet. 

It may be possible using a Texture as a "screen quad", and updating THAT.<br>
(it doenst change the bpp, it limits the colors used on a Texture)

Some are claiming the use of very advanced FBO(framebuffer objects), its more headache than its worth.<br>
(Youll find this a lot in GL.)

**BRING ASPIRIN** , GL will confuse you.

####  why use GL at all?

I can see 3 means right now:

	Display an object(like a teapot)-Holodeck style (ST:O uses the idea to the extreme)
	Display a static RENDERED or COMPUTED scene(chessboard, a bunch of balls...etc)
	Bust open a GLScene (and smash everything in it)- A lot of games do this.	

Try not to confuse SHADERS with TEXTURES(wallpaper).<br>

You can texturize an entire scene(cityscape,etc) yet never use a shader.<br>
However, If you use a shader, you are probably using a texture as well.<br>
(The two mean different things.)

	SHADER is a 3D object(colors and vertexes- think pixel points- are COMPILED together)
	TEXTURE is like Wallpaper. Anything can become wallpaper, and it can go (hilariously) on anything.


## 2d in 3D space

Either you used the wrong unit type for the "flatlands" and got lost, or you want a "game HUD".


This is not and will never be a BGI or a BGI replacement. <br>
Those routines are 2D in nature only.<br>

You cannot mishmash 2D/3D routines UNLESS using OpenGL inside of a Context..even as such the output
will not mimick a BGI, ever. 

SDL DOES NOT DO 3D.<br> 
IT NEVER DID.<br>

There are (some) 2D OpenGL routines - I would not depend on them for a "BGI replacement".


There is some Text(and 3D text) support, it needs a large workout- Pascal sources have been neglected for over a decade.


Do we look at things LEFT, or RIGHT? Decide now.


#### GL PT?? FContext??

GL PT is a way to get a Window handle in a uniform manner- to paste GL onto.<br>
(Its like the FContext unit)<br>

GL is a "3D portal", it has to be "plastered onto a wall", somewhere, somehow.<br>
Thats what PT and FContext do.(they make a mirror out of a picture framed section of wall).

You cannot setup GL without a window handle(the picture frame).<br>

Most of you have used GLUT- Ive intentionally removed that code- beyond being a PITA, proprietary hack-<br>
there are other serious flaws (IMHO) in using it.

Either find another console-way, or use Lazarus.<br>
The Lazarus code works this time around.<br>
It could work with SDL, however, getting that "picture frame"(window handle) seems to be the problem.<br>
(I like where DGL is headed with GL, its universal code and FContext so happens to get BUGGY Lazarus/FPC to work with it.)


### Weve gone 3D !!

You have left "FlatWorld" behind and Approach a new 3D world co ordinate space,well...space.<br>
(Think Holodeck without the walls- theres nothing made yet)

People, Aliens, Objects(nouns), weather, and any type of ground surface are at your disposal..or not.<br>
Shove items to float in space if you wish...I dont care. Nobody cares..<br>
-Its on you.

Part of using this type of "space" now requires loading various models, shaders, and texture types.<br>
I have not gotten to that code yet(OGRE/assIMP).


### SHADERS

There has been - (and will be) heavy use of 3D shaders(vertex, lighting, fragment(color), etc) within most OGL apps.

This is somewhat confusing as its quasi-C and a sub GPU application being built..but the process works.<br>

See the Pyramid OGL DEMO- 	
	-it builds a program from Pascal. 

SDL(in that application) can be substituted for FreeGLUT, FContext,etc.


Vertex(point) and Fragment(Color) shaders are the most common used. <br>
You need both, usually.

As a mod to the "fragment shaders", you can use smaller bit-depths, but not globally.

