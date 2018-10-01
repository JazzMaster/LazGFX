program BGIDemo;
//uses BGI instead of straight SDL.
//super ez....

uses
    sdlbgi;

//this might bitch about threading..I havent checked yet.

var
   minimized,quit:boolean;
  
begin

   //640x480x256 in a window
   initgraph(VGA,VGAHi,"",false);

//you should know how to write color code for the resolution/depth you are in.

  //draw when not minimized 

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

//implement this as you need it.


{                                                           
procedure IntHandler; //we should have forked and kick started....

var

   mouseWheel:integer;
   //Joystick direction 
   xDir:integer=0; 
   yDir:integer=0;

--
the question is becoming WHEN...before mainloop? or after it?
there shouldnt be any other handler code. 

functions very much like "OS interrupt handler code".

kill me if SDL is randomly closed...reason why is because we run continuously..
and otherwise we Deadlock the cpu and peg it at 100% needlessly with polling...as suggested elsewhere...
 buut...
not if we are waiting on events that have happened...no event and no CPU use....NICE....
most programmers DONT take this into account...

empty routines do nothing, much like OS-level interrupts. (hopefully we dont have to clear bits)

--



begin
 
  while (exitloop = false) do begin
    
    while (SDL_WaitEvent(event))   do begin //this pauses us...problem? this is why some poll.
    // is isConsoleInvoked then 	
		// writeln( 'Event detected: ' );
      case Event^.type_ of
 

        //mouse events
        SDL_MOUSEMOTION: begin
                        	mouseX:=sdlEvent^.motion.x+sdlEvent^.motion.xrel;
							mouseY:=sdlEvent^.motion.y+sdlEvent^.motion.yrel;
                         end;
        SDL_MOUSEBUTTONDOWN: mousePressed:=sdlEvent^.button.button;
        SDL_MOUSEBUTTONUP: mouseReleased:=sdlEvent^.button.button;
        SDL_MOUSEWHEEL: begin
                          
                          if sdlEvent^.wheel.y > 0 then scrolledMouse:=MouseWheel+sdlEvent^.wheel.y
                          else scrolledMouse:=MouseWheel-sdlEvent^.wheel.y;
                        end;
 

        //keyboard events
        SDL_KEYDOWN: begin //catch player movement and move user...
                       //scancode:=sdlEvent^.key.keysym.scancode;

                       case Event.key.keysym.sym of //by keycode
                         SDLK_ESCAPE: escapeRoutineDefault;  //we can mask this off

//check player movement keys on keyup. keydown is the wrong scancode.
//UP
//Down
//Left
//Right
 
                       end;
					   //if chr(event.key.keysym.sym) >32 and <128 then (alphanumeric)
						//find char
                       if EchoON then OutText(c) else exit; //games will turn echo OFF...
                     end;
        SDL_KEYUP: KeyUpEventDefault; //stop player movement...etc.
 
        //mouse events
        SDL_MOUSEMOTION: MouseMovedEventDefault;
        SDL_MOUSEBUTTONDOWN: MouseDownEventDefault;
        SDL_MOUSEBUTTONUP: MouseUpEventDefault;
        SDL_MOUSEWHEEL: MouseWheelEventDefault;
 
        SDL_JOYAXISMOTION: begin
        //Motion on controller 0 

            if( event.jaxis.which = 0 ) then begin
            //X axis motion 
                if( event.jaxis.axis = 0 ) then begin
                //Left of dead zone 
                     if( event.jaxis.value < JOYSTICK_DEAD_ZONE ) then //less than a minus value??
						xDir = -1;  
                //Right of dead zone 
                     else if( event.jaxis.value > JOYSTICK_DEAD_ZONE ) then 
						xDir = 1; 
                     else  xDir = 0; 

                //Y axis motion 

                end else if( e.jaxis.axis = 1 ) then begin
                   //Below of dead zone 
                   if( event.jaxis.value < JOYSTICK_DEAD_ZONE ) then
						 yDir = -1;  
				  //Above of dead zone 
 				   else if( e.jaxis.value > JOYSTICK_DEAD_ZONE ) then 
						 yDir = 1;  
				   else  yDir = 0; 
				end;
			end;
		end;
        //window events
        SDL_WINDOWEVENT: begin
                           //write( 'Window event: ' );
                           case Event.window.event of

                             SDL_WINDOWEVENT_MINIMIZED: SDL_MinimizeWindow; 
                             SDL_WINDOWEVENT_MAXIMIZED: begin
									SDL_MaximizeWindow;
									SDL_RestoreWindow;
							 end; 
                             SDL_WINDOWEVENT_ENTER: begin
								paused:=false;							
								SDL_RaiseWindow(Rendedwindow); //on top
							 	SDL_StartTextInput;
							 end;

                             SDL_WINDOWEVENT_LEAVE: begin; //not on top
								paused:=true;							
								//SDL_LowerWindow??
							 	SDL_StopTextInput;
							 end;

							 SDL_WINDOWEVENT_EXPOSED: SDL_RenderPresent( Renderer ); //we covered up the window but now- not so much..
							 SDL_WINDOWEVENT_SIZE_CHANGED: break; //ignore..we want a fixed mode.
                           end;
                         end;
      end;
    end;
    SDL_Delay( 20 ); //wait "around" 20 ms...and ....go
  end; //if we ever quit...were done w sdl...
  closegraph;

end;


procedure escapeRoutine;  // a 'pause' button

begin
   //your game logic takes care of this....this just sets things up.
   //is it right to freeze rendering? depends...look at zelda and skyrim..you might just want a menu.

   if not paused then begin //pause
      paused:=true; 
      SDL_StopTextInput;
      //showMenu
   end else begin //resume
      paused:=false;
      //HideMenu
      SDL_StartTextInput;
   end;

   //my idea freezes input and stops rendered output..a true "freeze"...
   //you unfreeze by hitting it again..SDL will get the event, just not process input until you say to.

end; 
 
procedure KeyUpEvent; //should be processing here

begin
end; 

procedure MouseMovedEvent;

begin
end; 

procedure MouseDownEvent;

begin
end; 

procedure MouseUpEvent;

begin
end; 

procedure MouseWheelEvent;

begin
end; 

procedure Minimized; //pause

begin
end; 

procedure Maximized; //resume

begin
end; 

procedure Focused; //resume

begin
//raise window
end; 

procedure Lost_Focus; //pause

begin
//hide window
end;               
}



    if (SDL_PollEvent(e) = 1) then begin      
      case e^.type_ of
 
               //keyboard events
        SDL_KEYDOWN: quit:=true;
       
//dont ignore mouse events but show the mouse and pretend we dont want its events instead.
	    SDL_MOUSEBUTTONDOWN: exit;
        SDL_WINDOWEVENT: begin
                           
                           case e^.window.event of
                             SDL_WINDOWEVENT_MINIMIZED: minimized:=true; //pause
                             SDL_WINDOWEVENT_MAXIMIZED: minimized:=false; //resume
                             SDL_WINDOWEVENT_ENTER: exit; //notice that nothing happens....
                             SDL_WINDOWEVENT_LEAVE: exit;
                             SDL_WINDOWEVENT_CLOSE: quit:=true;
                           end; //case
        end; //windowevent
                    
      end;  //case
    end; //if events waiting
  until quit=true; //mainloop
  closegraph;

end;


end.
