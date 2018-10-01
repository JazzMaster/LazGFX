unit 3dShapes;

{
Nothing here yet-

Will have eventually a GL context (or similar) for 3D shapes and primitives 

Really these are kind of overloads...

all are rendered, this is not a texture by itself, textures are crated..from the renderer

in a way scenes can be compiled from this and basic 2d primitives.

Be mindful of the changes in 3d:

Line ->pipe (or wire)
Pixel ->ball (a tiny sphere)
circle or 3Dellipse ->sphere or donut or (plastic sliver) 
Box ->cube (or a room/house if somewhat transparent)

Tri(angle) ->Pyramid ( or mountain w other tris attached) or cone
	there are other types of "trigons" in 3d

-SDL includes filled ones

Rotating views is a core SDL function (camera angle) at this point that may require 3d (x,y,z) rotation parameters.
Maybe you just want to look around the room?

All objects at this point are affected by SHADERS-
   which is a bitmask of sorts in black and white(muru-buru in Japanese).

}

interface

implementation
{

I will move the SDL functions here- I have them elsewhere.

}

begin
end.
