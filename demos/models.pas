Program Models;

{
This is how you get those fancy looking Teapots..or Bunnies...etc.

You put a Texture (flat) onto a (wireframe) mesh.
Make sure Shaders and "Light sources"(TnL) are enabled.

This does not use GLScene - but does use GL 3D.
Since Ive done GL 3D and demos- Im providing this.

Uses 3D (x,y,z) coordinates system. 

First:
    You need a teapot or something
Then:
    you need a SKIN.

}

uses
    LazGfx;

// {I lazgfx.inc}

//push this to the library.
var
    Render3d:boolen; export;


procedure Drawteapot;

begin

end;

//the stanford rabbit
procedure Drawrabbit;
begin

end;

begin
    Render3D:=true;
    //driver, mode, Fullscreen
    initgraph(PCVesa,m640x480x32,false)
        //right now - we should be in OGL 3D Perspective+model view at 0,0,0 (center screen) at chosen resolution + bpp

        DrawRabbit;

        //ask for <spacebar>        
        //glClear
        DrawTeapot;
        //ask for <spacebar>        
        //glClear
    //exit - automagically calls closegraph- as hooked- in initgraph
end.
