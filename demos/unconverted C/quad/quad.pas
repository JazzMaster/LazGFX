program Quad;


uses
    X,Xlib,XUtil,ctypes,GL,glx,glu;

var
    cmap:TColorMap;
    display: PDisplay;
    window: Twindow;
    xev: PXEvent;
    screen: cint;

    att: array [0..5] of GLint;
    //cmap:Colormap;
    context:GLXContext;

    vinfo:PXVisualInfo; //XUtil
    swa:PXSetwindowAttributes;
    gwa:PXwindowAttributes;

procedure DrawAQuad; 

begin
 glBegin(GL_QUADS);
  glColor3f(1.0, 0.0, 0.0); glVertex3f(-0.75, -0.75, 0.0);
  glColor3f(0.0, 1.0, 0.0); glVertex3f( 0.75, -0.75, 0.0);
  glColor3f(0.0, 0.0, 1.0); glVertex3f( 0.75,  0.75, 0.0);
  glColor3f(1.0, 1.0, 0.0); glVertex3f(-0.75,  0.75, 0.0);
 glEnd();
end;
 


begin

 display:=Nil;
 display := XOpenDisplay(Nil);
 
 if(display = NiL) then begin
        writeln('cannot connect to X server.');
        halt(0);
 end;
  
 screen := DefaultScreen(display);
writeln('X11 initd');
 
  // Create the window
{
 cmap :=XCreateColormap( display, RootWindow(display, vinfo^.screen), vinfo^.visual, AllocNone);

 swa^.colormap := cmap;
 swa^.background_pixel := 0;
 swa^.border_pixel := 0;
 swa^.colormap := XCreateColormap( display, RootWindow(display, vinfo^.screen), vinfo^.visual, AllocNone);
 swa^.event_mask := (ExposureMask or KeyPressMask);

}

 { create windowdow }
 window := XCreateSimplewindow(display, Rootwindow(display, screen), 0, 0, 600, 600, 0, BlackPixel(display, screen), WhitePixel(display, screen)); 
// window :=  XCreateWindow(display,window, 0, 0, 600, 600, 0, vinfo^.depth, InputOutput, vinfo^.visual,  (CWColormap or CWEventMask), swa);


  { select kind of events we are interested in }
  XSelectInput(display, window, ExposureMask or KeyPressMask);
 
  XMapwindow(display, window);
  XFlush(display); 

{$ifdef Darwin }
  XStoreName(display, window, 'VERY SIMPLE APPLICATION-OSX');
{$endif}  

{$ifndef Darwin }
    XStoreName(display, window, 'VERY SIMPLE APPLICATION-unices');
{$endif}  

writeln('window shown');
// att= ( GLX_RGBA, GLX_DEPTH_SIZE, 24, GLX_DOUBLEBUFFER, None ); 

   att[0] := GLX_RGBA;
   att[1] := GLX_DEPTH_SIZE;
   att[2] := 24;
   att[3] := GLX_DOUBLEBUFFER;
   att[4] := None;
	
   vinfo := glXChooseVisual(display, 0,att);
   context := glXCreateContext(display, vinfo, nil, true);
writeln('we have GL context');

   glXMakeContextCurrent(display, window, window, context); 

   glDisable(GL_DEPTH_TEST); 

   glClearColor(1.0, 0.0, 0.0, 1.0);
   glClear(GL_COLOR_BUFFER_BIT);

   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   glOrtho(-1.0, 1.0, -1.0, 1.0, 1.0, 20.0);

   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();
   gluLookAt(0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
writeln('ready');
       DrawAQuad; 
 //  XFillRectangle(display, window, DefaultGC(display, screen), 20, 20, 10, 10);

       glXSwapBuffers(display, window);
 
 
  // event loop 
  while (True) do  begin
     while(XPending(display))= 1 do
        XNextEvent(display, xev);

writeln('got event');
//  while true do begin end;

//    XWindowEvent(display, window, (ExposureMask or KeyPressMask), xev);
   // if XCheckWindowEvent (display,window, (ExposureMask or KeyPressMask), xev) then begin

    // draw or redraw the windowdow 
    if (xev^._type = Expose) then
    begin

                XGetwindowAttributes(display, window, gwa);
                glViewport(0, 0, gwa^.width, gwa^.height);

    end;
    // exit on key press 
    if (xev^._type = KeyPress) then begin
                glXMakeCurrent(display, None, NiL);
                glXDestroyContext(display, context);
                XDestroywindow(display, window);
                exit; // not break, exit the event handler.
    end;

  end; //while true
 
  // close connection to server 
  XCloseDisplay(display);
  halt(0);


end. 

