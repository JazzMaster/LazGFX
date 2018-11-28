program testLazGraph;

{$IFDEF go32v2}

//ifdep ver70 (TP/BP)

//insert build options
//far calls enabled

uses
	graph; //were in DOS- use Borlands Code. Difference is we are in 16,32, and 64bit systems and the ASM code hasnt been updated thusly.
    //we dont use "ifdef FPC" because FPC routines fix this, if we are using FPC.

{$ENDIF}

{$IFDEF UNIX}
{$IFDEF XORG}

//need to ad in optimezed X11Corelibs routines instead of just "SDL ones"
uses
	SDLBGI; //SDL and or Xlib (xAPI)

{$ENDIF}
//heaven forbid...
uses
   FBSDL;   //libFB or lib(s)vga -does not use X11 (unoptimized)

{$ENDIF}

{$IFDEF windows}

uses
    WinSDL; //WinAPI

{$ENDIF}

var 
        gd,gm:SmallInt;
        e:PSDL_Event;
begin
//640x480x256
//drivers and modelist depends on the code that were using.

   //640x480x256 in a window
   initgraph(VGA,VGAHi,"",false);


  	if( not Minimized ) then begin
    	 //Clear screen 
		 SetBkColor(black); //color 0 in integer or byte format... 
		 clearscreen;

		   _fgcolor:Longword=$0000ffff; //blue
		   _bgcolor:Longword=$000000ff; //blue

    	 //Draw 
			lock;		
		    PlotPixelWithNeighbors(5,5); //(with neighbors is easier seen) 5x5
            SetColor(white);
            line(7,7,20,20); //from 7x7 to 20x20
			unlock;
  	end;
  fontpath:='/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf'; 
  font_size:=16; 
  style:=TTF_STYLE_NORMAL; 
  outline:=longint(0);
  //write font data w _fg and _bg colors by default.

  OutTextXY(15,15,'Press any key to end. ');

  // in this example-just wait for one keypress...
  // we want to render first, not render in a loop. Common for old code.
  quit:=false;
  repeat


    if (SDL_PollEvent(e) = 1) then begin      
      case e^.type_ of
 
               //keyboard events
        SDL_KEYDOWN: quit:=true;
       
//dont ignore mouse events but show the mouse and pretend we dont want its events instead.
	    SDL_MOUSEBUTTONDOWN: quit:=true;
        SDL_WINDOWEVENT: begin
                           
                           case e^.window.event of
                             SDL_WINDOWEVENT_MINIMIZED: minimized:=true; //pause
                             SDL_WINDOWEVENT_MAXIMIZED: minimized:=false; //resume
                             SDL_WINDOWEVENT_CLOSE: quit:=true;
                           end; //case
        end; //windowevent
                    
      end;  //case
    end; //if events waiting
  until quit=true; //mainloop
  closegraph;

end;

end.
