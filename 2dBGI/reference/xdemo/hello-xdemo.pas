{*
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */
 
	C/CPP: Brian Hammond 2/9/96
    FreePascal: Richard Jasmin 12/20/2018

Using some hints from SDL- heres what we have:

some X init routines
window init
OutText routine
basic event driven input handling

    onClick handler to draw text in the window

strings are copied prior to display(sloppy C), not reassigned(proper code) before display

}

{$mode objfpc}
{$H+}

uses

    x,Xlib,Xutil,baseunix,sysutils,ctypes;

var

  d: PDisplay;
  w: TWindow;
  e: TXEvent;
  msg: PChar;
  s: cint;

  rc:Longword;
  screen_colormap:TColormap;     // color map to use for allocating colors.   
  red, brown, blue, yellow, green:TXColor;
	
  Context:PXGC;
  key:PKeySym;

  CurrX,CurrY:word;
  text:array [0..254] of char;
  NewMsg:String;
  Values:PXGCValues;
  black,white:longword;
  NewText:PChar;

procedure close_x;
begin
  { close connection to server }
	XFreeGC(d, Context);
	XDestroyWindow(d,w);
    XCloseDisplay(d);
    halt(0);
end;


procedure ModalShowX11Window(AMsg: string);

begin
  msg := PChar(AMsg);
  
  { open connection with the server }
  d := XOpenDisplay(nil);
  if (d = nil) then  begin
    WriteLn('Cannot open X11 display');
    exit;
  end;


  s := DefaultScreen(d);
  black:=BlackPixel(d,s);
  white:=WhitePixel(d,s);


  { create window }
  w := XCreateSimpleWindow(d, RootWindow(d, s), 10, 10, 640, 480, 1,  BlackPixel(d, s), WhitePixel(d, s));

  XSetStandardProperties(d,w,'Howdy','Hi',None,NiL,0,NiL);

 screen_colormap := DefaultColormap(d, DefaultScreen(d));

  // allocate the set of colors we will want to use for the drawing. 
  rc := XAllocNamedColor(d, screen_colormap, 'red', @red, @red);
  if rc =0  then begin
    writeln('XAllocNamedColor - failed to allocated red color.');
    exit;
  end;

  rc := XAllocNamedColor(d, screen_colormap, 'brown', @brown, @brown);
  if (rc = 0) then begin
    writeln('XAllocNamedColor - failed to allocated brown color.');
    exit;
  end;

  rc := XAllocNamedColor(d, screen_colormap, 'blue', @blue, @blue);
  if (rc = 0) then begin
    writeln('XAllocNamedColor - failed to allocated blue color.');
    exit;
  end;

  rc := XAllocNamedColor(d, screen_colormap, 'yellow', @yellow, @yellow);
  if (rc = 0) then begin
    writeln('XAllocNamedColor - failed to allocated yellow color.');
    exit;
  end;
  rc := XAllocNamedColor(d, screen_colormap, 'green', @green, @green);
  if (rc = 0) then begin
    writeln('XAllocNamedColor - failed to allocated green color.');
    exit;
  end;
  


  { select kind of events we are interested in }
  XSelectInput(d, w, ExposureMask or KeyPressMask or ButtonPressMask);

    Context:=XCreateGC(d, w, 0,Values);  
      
	XSetBackground(d,Context,white);
	XSetForeground(d,Context,black);

	XClearWindow(d, w);

  { map (show) the window }
  XMapWindow(d, w);


  { event loop }
  while (True) do begin
    XNextEvent(d, @e);
    { draw or redraw the window }
    if (e._type = Expose) then  begin
	  XClearWindow(d, w);

   	  XSetForeground(d,Context,black);
      XFillRectangle(d, w, Context, 20, 20, 10, 10);

      XSetForeground(d, Context, green.pixel);
      XFillRectangle(d, w, Context, 60, 150, 50, 60);

      XSetForeground(d, Context, red.pixel);
      XDrawPoint(d, w, Context, 5, 5);

      XDrawString(d, w, Context, 50, 50, msg, strlen(msg));
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

            Currx:=e.xbutton.x;
			Curry:=e.xbutton.y;
            
            NewMsg:='You pressed a key!';
            NewText:=PChar(NewMsg);

			XSetForeground(d,Context,3);
			XDrawString(d,w,Context,Currx,Curry, NewText, strlen(NewText)); 
          end;
       
		end;

        //when the mouse is pressed , draw a string at (x,y)
		if (e._type=ButtonPress) then begin
		
			CurrX:=e.xbutton.x;
		    CurrY:=e.xbutton.y;

			NewMsg:='X is FUN!';
            NewText:=PChar(NewMsg);

			XSetForeground(d,Context,3);
			XDrawString(d,w,Context,CurrX,CurrY, NewText, strlen(NewText));
		end;

  end;
end;

//main:
begin
  ModalShowX11Window('My message');
end.

