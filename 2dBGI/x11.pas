Unit X11;
//Core 2DBGI API for Laz GFX for X11

interface

uses

    Logger;

    procedure InitGraph;
    procedure CloseGraph;
    procedure MainLoop;

implementation

procedure InitGraph;

begin
  
  { open connection with the server }
  d := XOpenDisplay(nil);
  if (d = nil) then  begin
    LogLn('Cannot open X11 display');
    exit;
  end;


  s := DefaultScreen(d);
  black:=BlackPixel(d,s);
  white:=WhitePixel(d,s);


  { create window }
  w := XCreateSimpleWindow(d, RootWindow(d, s), 10, 10, MaxX, MaxY, 1,  BlackPixel(d, s), WhitePixel(d, s));

  XSetStandardProperties(d,w,'Lazarus Graphics Application','',None,NiL,0,NiL);

 screen_colormap := DefaultColormap(d, DefaultScreen(d));

{
//problem with this is we dont know--could be 16K or more used...
  // allocate the set of colors we will want to use for the drawing. 

  rc := XAllocNamedColor(d, screen_colormap, 'red', @red, @red);
  if rc =0  then begin
    LogLn('XAllocNamedColor - failed to allocated red color.');
    exit;
  end;

  rc := XAllocNamedColor(d, screen_colormap, 'brown', @brown, @brown);
  if (rc = 0) then begin
    LogLn('XAllocNamedColor - failed to allocated brown color.');
    exit;
  end;

  rc := XAllocNamedColor(d, screen_colormap, 'blue', @blue, @blue);
  if (rc = 0) then begin
    LogLn('XAllocNamedColor - failed to allocated blue color.');
    exit;
  end;

  rc := XAllocNamedColor(d, screen_colormap, 'yellow', @yellow, @yellow);
  if (rc = 0) then begin
    LogLn('XAllocNamedColor - failed to allocated yellow color.');
    exit;
  end;
  rc := XAllocNamedColor(d, screen_colormap, 'green', @green, @green);
  if (rc = 0) then begin
    LogLn('XAllocNamedColor - failed to allocated green color.');
    exit;
  end;
}
  
  { select kind of events we are interested in }
  XSelectInput(d, w, ExposureMask or KeyPressMask or ButtonPressMask);

    Context:=XCreateGC(d, w, 0,Values);  
      
	XSetBackground(d,Context,white);
	XSetForeground(d,Context,black);

	XClearWindow(d, w);

  { map (show) the window }
  XMapWindow(d, w);

end;

Procedure MainLoop;

begin


  { event loop }
  while (True) do begin
    XNextEvent(d, @e);
    { draw or redraw the window }
    if (e._type = Expose) then  begin
	  XClearWindow(d, w);

   	  XSetForeground(d,Context,black);
      //do more?
      XFlush(d);
    end;

		if e._type=KeyPress then begin
//catch special keys

             if  e.xkey.keycode = $09  then
                close_x;		

		// use the XLookupString routine to convert the event
		//   KeyPress data into regular text.  Weird but necessary...

         if (XLookupString(@e,text,255,key,Nil)=1) then begin

			if (text='q') then begin
				close_x;
			end;
{
            Currx:=e.xbutton.x;
			Curry:=e.xbutton.y;
            
            NewMsg:='You pressed a key!';
            NewText:=PChar(NewMsg);

			XSetForeground(d,Context,3);
			XDrawString(d,w,Context,Currx,Curry, NewText, strlen(NewText)); }
          end;
       
		end;

        //when the mouse is pressed , draw a string at (x,y)
		if (e._type=ButtonPress) then begin
		{
			CurrX:=e.xbutton.x;
		    CurrY:=e.xbutton.y;

			NewMsg:='X is FUN!';
            NewText:=PChar(NewMsg);

			XSetForeground(d,Context,3);
			XDrawString(d,w,Context,CurrX,CurrY, NewText, strlen(NewText));}
		end;

  end;
end;


procedure CloseGraph;
begin
  { close connection to server }
	XFreeGC(d, Context);
	XDestroyWindow(d,w);
    XCloseDisplay(d);
    halt(0);
end;


begin

end.
