unit DebugConsole;
//SDL Debug Console Unit

interface

{
The core of this unit is not to duplicate TILDE behaviour- that code is available to hook in C.
This unit is to give us a debugging output console in case we are built inside Lazarus app and dont have one.

Ususally you might have one if working with Lazarus, or inside it.
Since there is no guarantee of that- lets make one.

If you build the unit or your app for debugging- you should have one.
I dont see the code, so here it is.

Fires a new window and scrolls the text on output.
Nothing fancy. Ported code from CoffeeOS.
YW.

--Jazz

}

procedure CreateDebugWindow;
procedure Log;
procedure LogLn;
procedure Scroll; //coffeeOS hack-in from VRAM buffer (B000)

implementation

procedure CreateDebugWindow;

begin
//make a window
 window = SDL_CreateWindow('SDLBGI Debugging output', SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, MaxX, MaxY, 0);
    	 if (window = NULL) then begin
 			if IsConsoleInvoked then begin
	    	   	writeln('Something Fishy. I cant create another window.');
	    	   	writeln('SDL reports: ',' ', SDL_GetError);      
	    	end;
	    	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Something Fishy. I cant create a needed window.','BYE..',NIL);
			
end;


//logChar is pointless..
Procedure Log(s: String);
Begin
//raiseWindow(debugWindow);
  outText(s);

  if IsConsoleInvoked then
     write(s);
  if donelogging then Close(debuglog);
//lowerWindow(debugWindow);
End;

Procedure LogLn(s: string);

Begin
//raiseWindow(debugWindow);

  outTextLn(s);
  if IsConsoleInvoked then
     writeln(s);

  if donelogging then Close(debuglog);
//lowerWindow(debugWindow);

End;

procedure Scroll; //coffeeOS hack-in from VRAM buffer (B000)
begin
end;

begin
end.
