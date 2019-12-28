program bgitest;
//HERE WE GO. Lets crack open the FUN!
//extremely simplified with LazGfx Graphics/Game programming API

{$mode objfpc}
uses
	lazgfx,sdl;
var
	WantsAudioToo:boolean; export;
	WantsJoypad:boolean; export;

Procedure VideoCallback(someSurface:PSDL_Surface);

begin
 //DEBUG:   writeln(longword(@MainSurace)); -GFX Context export check

//good enough for now.
        SetFGColor(0, 0, 255, 255);
		Line(renderer,3,3,50,3);

        SetFGColor(255, 255, 255, 255);
		
		//The Block..
		PlotpixelWithNeighbors(ThickWidth,15,23);
        
        //Red and Green Big X- notice its not a truely square 'X'
		SetFGColor( 255, 0, 0, 255 );
		Line( Renderer, 1, 1, 640, 480 );

		SetFGColor(  0, 255, 0, 255 );
		Line( Renderer, 1, 480, 640, 1 );

end;


begin

//specify- dont guess
	WantsAudioToo:=false;
	WantsJoypad:=false;

    MainSurface:=Initgraph(vga,m640x480x32k,'',false); //640x480x15bpp, Driver=Nil, windowed=true(FS=false) 

 //DEBUG:   writeln(longword(@renderer)); -GFX Context export check
  VideoCallBack(MainSurface);
  
//waits for input or an event (like window close)
  New(event);
  IntHandler; //MyHandler

//The handler gives way to the "exit door": CloseGraph. 
//You dont have to call it in "event driven systems".

end.
