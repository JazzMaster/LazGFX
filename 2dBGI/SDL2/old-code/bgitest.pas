program bgitest;
//HERE WE GO. Lets crack open the FUN!
//extremely simplified with LazGfx Graphics/Game programming API


//screw with this code - to demo the Graphics routines(SDL)

{$mode objfpc}
uses
	lazgfx,sdl2;
var
	WantsAudioToo:boolean; export;
	WantsJoypad:boolean; export;
 //   e:PSDL_Event;

begin
//specify- dont guess
	WantsAudioToo:=false;
	WantsJoypad:=false;

    renderer:=Initgraph(vga,VGAHix32k,'',false); //640x480x15bpp Driver=Nil (windowed) 
    SDL_Delay( 50 ); //cleanup the garbage

 //   writeln(longword(@renderer)); -export reference check

//Im calling routines directly(SDL) -but I dont have to.
//The point is we have the context - and were ready to ROCK!

        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
//		PutPixel(renderer,3,3);
		PlotpixelWithNeighbors(ThickWidth,15,23);

//seems to be an out-of-phase glitch going on(vrefresh not sync?)
    SDL_RenderPresent(renderer);
 SDL_RenderPresent(renderer);

  SDL_SetRenderDrawColor( Renderer, 255, 0, 0, 255 );
  SDL_RenderDrawLine( Renderer, 30, 30, 520, 520 );
  SDL_SetRenderDrawColor( Renderer, 0, 255, 0, 255 );
  SDL_RenderDrawLine( Renderer, 30, 520, 520, 30 );
  SDL_RenderPresent( Renderer );
  SDL_Delay( 1000 );

//btw- the text routines work- (just not combined w OGL routines)


//theres still a few (SDL! GL!) mainloop "bugs" to work thru...
//but for simple rendering, this works.

//waits for input or an event (like window close)
  New(event);
  IntHandler; //MyHandler

//ideally youd write your own handler routine and pop a New(eventVariable).

//The handler gives way to the "exit door": CloseGraph. You dont have to call it in "event driven systems".

end.
