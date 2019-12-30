program bgitest;
//HERE WE GO. Lets crack open the FUN!
//extremely simplified with LazGfx Graphics/Game programming API
//being tweaked for "better SDL use"

{$mode objfpc}
uses
	lazgfx,sdl2;
var
	WantsAudioToo:boolean; export;
	WantsJoypad:boolean; export;

Procedure RenderCallback(renderer:PSDL_Renderer);

begin

//this is directRendering, you can also do this with a Texture (as a MainSurface)
//Renderer ops dont need to be wrapped, why theyre not included in LazGFX unit.
//see SDL documentation for these routines.

//renderpresent() is only required if not using DirectRender methods, we are.

//good enough for now.
        SetFGColor(0, 0, 255, 255);
		SDL_RenderDrawLine(renderer,3,3,50,3);

        SetFGColor(255, 255, 255, 255);
		
		//The Block..
		PlotpixelWithNeighbors(ThickWidth,15,23);
        
        //Red and Green Big X- notice its not a truely square 'X'
		SetFGColor( 255, 0, 0, 255 );
		SDL_RenderDrawLine( Renderer, 1, 1, 640, 480 );

		SetFGColor(  0, 255, 0, 255 );
		SDL_RenderDrawLine( Renderer, 1, 480, 640, 1 );
        
end;


begin

//specify- dont guess
	WantsAudioToo:=false;
	WantsJoypad:=false;

    renderer:=Initgraph(vga,m640x480x32k,'',false); //640x480x15bpp, Driver=Nil, windowed=true(FS=false) 

 //DEBUG:   writeln(longword(@renderer)); -GFX Context export check
  RenderCallBack(Renderer);
  
//waits for input or an event (like window close)
  New(event);
  IntHandler; //MyHandler

//The handler gives way to the "exit door": CloseGraph. 
//You dont have to call it in "event driven systems".

end.
