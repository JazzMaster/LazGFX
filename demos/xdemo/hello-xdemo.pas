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

the only problems I see are ^.type needs a new variable define- its a reserved pascal word.
(SDL JEDI headers may have a fix for this)

}


uses

    Xlib,Xutil,baseunix,sysutils;

// include the X library headers 

var

    dis:PDisplay;
    screen,x,y:integer;
    win:PWindow;
    callback:GC;

	event:XEvent;		// the XEvent declaration 
	key:KeySym;		// a dealie-bob to handle KeyPress Events 
	text:array [0..255] of char;    //a char buffer for KeyPress Events 

	black,wite:longword;

    
//closegraph
procedure closeX;

begin
	XFreeGC(dis, gc);
	XDestroyWindow(dis,win);
	XCloseDisplay(dis);	
	exit(0);				
end;

//main():

begin

	dis:=XOpenDisplay(0); // open display 0 
   	screen:=DefaultScreen(dis);

	black:=BlackPixel(dis,screen),
	white:=WhitePixel(dis, screen);

   	win:=XCreateSimpleWindow(dis,DefaultRootWindow(dis),0,0,300, 300, 5,black, white);
	XSetStandardProperties(dis,win,"Howdy","Hi",None,NiL,0,NiL);

	XSelectInput(dis, win, (ExposureMask or ButtonPressMask or KeyPressMask));
    callback:=XCreateGC(dis, win, 0,0);  
      
	XSetBackground(dis,callback,white);
	XSetForeground(dis,callback,black);

	XClearWindow(dis, win);

	XMapRaised(dis, win);

	// look for events forever... 
    while true do begin

		// get the next event and stuff it into our event variable.
		//   Note:  only events we set the mask for are detected!
		
		XNextEvent(dis, event);
	
		if (event^.type=Expose and event^.xexpose.count=0) then begin
		// the window was exposed redraw it! 
			XClearWindow(dis, win);

		end;
		if (event^.type=KeyPress and XLookupString(event^.xkey,text,255,key,0)=1) then begin
		// use the XLookupString routine to convert the event
		//   KeyPress data into regular text.  Weird but necessary...
		
			if (text[0]='q') then begin
				close_x;
			end;

            x=event^.xbutton.x,
			y=event^.xbutton.y;
            
            text:='You pressed the',text[0], ' key!';
			XSetForeground(dis,callback,3);
			XDrawString(dis,win,callback,x,y, text, sizeof(text)); 
       
		end;
        //when the mouse is pressed , draw a string at (x,y)
		if (event^.type=ButtonPress) then begin
		
			x:=event^.xbutton.x,
		    y:=event^.xbutton.y;

			text:='X is FUN!';

			XSetForeground(dis,callback,3);
			XDrawString(dis,win,callback,x,y, text, sizeof(text));
		end;
	end;

end;

end.

