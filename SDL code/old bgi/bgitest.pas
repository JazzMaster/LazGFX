program bgitest;
//HERE WE GO. Lets crack open the FUN!

{$mode objfpc}
uses
	lazgfx,sdl2;
var
	WantsAudioToo:boolean; export;
	WantsJoypad:boolean; export;
   // renderer:PSDL_Renderer;
 //   e:PSDL_Event;

begin
	WantsAudioToo:=false;
	WantsJoypad:=false;
    renderer:=Initgraph(vga,VGAHix32k,'',false); //640x480x15bpp
SDL_Delay( 50 );

 //   writeln(longword(@renderer));
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
//		PutPixel(renderer,3,3);
		PlotpixelWithNeighbors(ThickWidth,15,23);
//    SDL_RenderPresent(renderer);

  SDL_SetRenderDrawColor( Renderer, 255, 0, 0, 255 );
  SDL_RenderDrawLine( Renderer, 30, 30, 520, 520 );
  SDL_SetRenderDrawColor( Renderer, 0, 255, 0, 255 );
  SDL_RenderDrawLine( Renderer, 30, 520, 520, 30 );
  SDL_RenderPresent( Renderer );
  SDL_Delay( 1000 );

  New(event);
  IntHandler; //MyHandler
end.
