unit 3d;

{
Will have eventually a GL context (or similar) for 3D shapes and primitives 

Be mindful of the changes in 3d:

Line ->pipe (or wire)
Pixel ->ball (a tiny sphere)
circle or 3Dellipse ->sphere or donut or (plastic sliver) 
Box ->cube (or a room/house if somewhat transparent)

Tri(angle) ->Pyramid ( or mountain w other tris attached) or cone
	there are other types of "trigons" in 3d

-SDL includes filled ones

Rotating views is a core SDL function (camera angle) at this point that may require 3d (x,y,z) rotation parameters.

}

interface

uses

    GL,GLU; //(get yer own API under pre directX v9 hardware)

implementation


begin
end.
