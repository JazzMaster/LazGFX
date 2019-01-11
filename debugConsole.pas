unit DebugConsole;
//SDL Debug Console Unit

interface

{
The core of this unit is not to duplicate TILDE behaviour- that code is available to hook in C.
This unit is to give us a debugging output console in a new window.

Fires a new window and scrolls the text on output.
Nothing fancy. Ported code from CoffeeOS.
YW.

Logging will have to switch back and forth during rendering.

Using more than onw window is only supported with SDLv2 and above.
Each window has MainSurface, Renderer, etc... now.

SO far- we have been using just the original window for our application and test code. NOT ANY MORE!

--Jazz

}

var
	window:PSDL_Window;

function CreateDebugWindow:window;
procedure LogWindow;
procedure LogLnWindow;
procedure Scroll; //coffeeOS hack-in from VRAM buffer (B000)
procedure CloseDebugWindow;

implementation

//think more obj Pas: init and destructor
//as such initgraphs and closegraph(no need to rewrite them) need to call these routines on a boolean check.

function CreateDebugWindow:window;

begin
//make a window
 debugwindow = SDL_CreateWindow('SDLBGI Debugging output', SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, MaxX, MaxY, 0);
    	 if (window = NULL) then begin
 			if IsConsoleInvoked then begin
	    	   	writeln('Something Fishy. I cant create another window.');
	    	   	writeln('SDL reports: ',' ', SDL_GetError);      
	    	end;
	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy. I cant create a needed window.','BYE..',NIL);
		
 CreateDebugWindow:=debugwindow;	
 //no this isnt enough- we need surface at minimal (for the font) 
 //now we need simulated text console environment(8x12 monospaced system font w scroll features)


end;

//should be window x+1 but thats not guaranteed.
//HACK: how do we know the close attempt wasnt munged into the main Window pointer instead of the debug one?

//if WindowVal >1 then ... (set GraphMode would set this = to 1)

procedure CloseDebugWindow(debugwindow:PSDL_Window);
begin
	SDL_DestroyWindow(debugwindow);
end;

//resume the rest


//logChar is pointless..
Procedure LogWindow(s: String);
Begin
//bring to front-push to back

//raiseWindow(debugWindow);
  outText(s);

  if IsConsoleInvoked then
     write(s);
  if donelogging then Close(debuglog);
//lowerWindow(debugWindow);
End;

Procedure LogLnWindow(s: string);

Begin
//raiseWindow(debugWindow);

  outTextLn(s);
  if IsConsoleInvoked then
     writeln(s);

  if donelogging then Close(debuglog);
//lowerWindow(debugWindow);

End;

procedure Scroll; //coffeeOS hack-in from VRAM buffer @B000
begin
//shift screen value up sizeof((fontSize+ 1/4 FontSize));
//(blit the surface y axis up)

//repaint the background(if needed, offscreen)
//reset pointer to begining of line(font data goes on top of painted surface)


//keep doing this until the window gets closed or we stop logging.
end;

//mainRT():
begin


end.
