program bgitest;

uses
	lazgfx,sdl2;
var
	WantsAudioToo:boolean; export;
	WantsJoypad:boolean; export;
    renderer:PSDL_Renderer;

begin
	WantsAudioToo:=false;
	WantsJoypad:=false;
        Initgraph(vga,VGAHix32k,'',false);
		PutPixel(renderer,3,3);
		PutPixel(renderer,7,7);
        while true do; //sit here
	closegraph;
end.
