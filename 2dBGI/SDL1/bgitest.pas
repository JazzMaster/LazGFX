program bgitest;
//HERE WE GO. Lets crack open the FUN!
//extremely simplified with LazGfx Graphics/Game programming API

{$mode objfpc}
uses
	lazgfx,sdl;
var
	WantsAudioToo:boolean; export;
	WantsJoypad:boolean; export;

begin
//specify- dont guess
	WantsAudioToo:=false;
	WantsJoypad:=false;

    MainSurface:=Initgraph(vga,VGAHix32k,'',false); //640x480x15bpp, Driver=Nil, windowed=true(FS=false) 
    SDL_Delay( 50 ); //cleanup the garbage

 //DEBUG:   writeln(longword(@MainSurace)); -GFX Context export check

        SetColor(renderer, 255, 255, 255);
		PutPixel(renderer,3,3);
		PutPixel(renderer,5,5);
		PutPixel(renderer,7,7);

		//The Block..
		PlotpixelWithNeighbors(ThickWidth,15,23);

//clear
//(blit)
SDL_Flip;

  SetColor( Renderer, 255, 0, 0, 255 );
  Line( Renderer, 30, 30, 520, 520 );
  SetColor( Renderer, 0, 255, 0, 255 );
  Line( Renderer, 30, 520, 520, 30 );

//clear
//(blit)
SDL_Flip;

//test here to see if the event handler is working..

  SDL_Delay( 1000 );

//waits for input or an event (like window close)
  New(event);
  IntHandler; //MyHandler

//ideally youd write your own handler routine

//The handler gives way to the "exit door": CloseGraph. 
//You dont have to call it in "event driven systems".

end.
