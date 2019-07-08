#include <GLES2/gl2.h>
//Use GLES functions- not all GL core functions are here. (no pixels for ewe!)

#include <X11/Xlib.h>
#include  <X11/Xatom.h>
#include <X11/Xutil.h>
#include <EGL/egl.h>

#include <errno.h>
#include <math.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>

//This will get us going but- it "forces shaders on us"- not practical "for BGI use".


//to compile: gcc EGLDemo.c -lGLESv2 -lEGL -X11


static int win_width = 0, win_height = 0, win_posx = 0, win_posy = 0;

int main(int argc, char *argv[])
{
#ifdef __unix__
	// By default X11 isn't thread safe
	// Typically it avoid a crash on Mesa when glthread is enabled on DRI2
	//
	// I guess it could be removed once we migrate to Wayland (post 2020)
	XInitThreads();
#endif

  int err = 0, ret = EXIT_FAILURE;
  EGLDisplay egl_dpy =NULL;
  Display *xlib_dpy=NULL;
  Window x11_win = 0;
  int x11_event_mask = NoEventMask;
  XEvent x11_event;

  XVisualInfo *x11_visual = NULL;
  int x11_attr[5];
  EGLSurface egl_surface = NULL;
  EGLint egl_config_attr[19];
  EGLint egl_nconfigs = 0;
  EGLConfig *egl_configs = NULL, egl_config = NULL;
  EGLint egl_ctx_attr[3];
  EGLContext egl_ctx = NULL;
  EGLBoolean init=False;


 // get an EGL display connection

 // Initialize the display

  EGLBoolean ok;

  xlib_dpy = XOpenDisplay(NULL);
  if (!xlib_dpy) {
     printf("Cant open X11. \n");
     goto out;
  }

   Window root  =  DefaultRootWindow( xlib_dpy );   // get the root window (usually the whole screen)
 
   XSetWindowAttributes  swa;
//if you dont mask it off- you get no events of "said type"...
   swa.event_mask  =  ExposureMask | ButtonPressMask | KeyPressMask;
 
// create a window with the provided parameters
   x11_win  =  XCreateWindow (  xlib_dpy, root, 0, 0, 800, 480,   0, CopyFromParent, InputOutput,  CopyFromParent, CWEventMask,  &swa );
 
   XSetWindowAttributes  xattr;

//apparently the ATOM definition defines a forced FS mode...
//   Atom  atom;
   int   one = 1;
 
   xattr.override_redirect = False;
   XChangeWindowAttributes ( xlib_dpy, x11_win, CWOverrideRedirect, &xattr );
 
//   Atom wm_state = XInternAtom(xlib_dpy, "_NET_WM_STATE", False);
//   Atom fullscreen = XInternAtom(xlib_dpy, "_NET_WM_STATE_FULLSCREEN", False);

   XWMHints hints;
   hints.input = True;
   hints.flags = InputHint;
   XSetWMHints(xlib_dpy, x11_win, &hints);
 
   XMapWindow ( xlib_dpy , x11_win );             // make the window visible on the screen
   XStoreName ( xlib_dpy , x11_win , "EGL on X11 test-Press Q to quit" ); // give the window a name
 
   XEvent xev;
   memset ( &xev, 0, sizeof(xev) );
 
/*
   xev.type                 = ClientMessage;
   xev.xclient.window       = x11_win;
   xev.xclient.message_type = wm_state;
   xev.xclient.format       = 32;
   xev.xclient.data.l[0]    = 1;
   xev.xclient.data.l[1]    = fullscreen;
   xev.xclient.data.l[2] = 0;
                  // send an event mask to the X-server
   XSendEvent ( xlib_dpy, DefaultRootWindow (xlib_dpy ), False, SubstructureNotifyMask, &xev );
*/

  egl_dpy = eglGetDisplay(xlib_dpy);
  if (!egl_dpy) {
       printf("Cant get info from X11. \n");
      goto out;
  }

  printf("Got Display: %p. \n",egl_dpy);

  EGLint major, minor;

  ok = eglInitialize(egl_dpy, &major, &minor);
  if (!ok) {
     printf("Cant Init EGL on X11. \n");
      goto out;
  }
  printf("EGL initd \n");
  eglBindAPI(EGL_OPENGL_ES_API);

 if (major < 1 || minor < 3)
 {
  // Does not support EGL 1.3
  printf("System does not support at least EGL 1.3 \n");
  goto out;
 }

    egl_config_attr[0] = EGL_BUFFER_SIZE;
    egl_config_attr[1] = 32;
    egl_config_attr[2] = EGL_RED_SIZE;
    egl_config_attr[3] = 8;
    egl_config_attr[4] = EGL_BLUE_SIZE;
    egl_config_attr[5] = 8;
    egl_config_attr[6] = EGL_GREEN_SIZE;
    egl_config_attr[7] = 8;
    egl_config_attr[8] = EGL_ALPHA_SIZE;
    egl_config_attr[9] = 8;
    egl_config_attr[10] = EGL_DEPTH_SIZE;
    egl_config_attr[11] = EGL_DONT_CARE;
    egl_config_attr[12] = EGL_STENCIL_SIZE;
    egl_config_attr[13] = EGL_DONT_CARE;

    egl_config_attr[14] = EGL_RENDERABLE_TYPE;
    egl_config_attr[15] = EGL_OPENGL_ES2_BIT;
    egl_config_attr[16] = EGL_SURFACE_TYPE;
    egl_config_attr[17] = EGL_WINDOW_BIT | EGL_PIXMAP_BIT;

    egl_config_attr[18] = EGL_NONE;
  

  err = eglChooseConfig(egl_dpy, egl_config_attr, &egl_config,1, &egl_nconfigs);
    if (!err ==3000) {
      printf("eglChooseConfig failed: 0x%x \n", eglGetError());
      goto out;
    }

   if ( egl_nconfigs != 1 ) {
      printf("Didn't get exactly one config, but %x configs instead. \n" ,egl_nconfigs);
      goto out;
   }

 //egl_config = egl_configs[0];
 printf("config succeeded \n");


 egl_surface = eglCreateWindowSurface(egl_dpy, egl_config, (EGLNativeWindowType)x11_win, NULL);
 if (!egl_surface) {
      printf("EGL create surface failed \n");
      goto out;
    }
      printf("EGL surface Made \n");
   
    //// egl-contexts collect all state descriptions needed required for operation
   EGLint ctxattr[] = {
      EGL_CONTEXT_CLIENT_VERSION, 2,
      EGL_NONE
   };
 

  egl_ctx = eglCreateContext ( egl_dpy, egl_config, EGL_NO_CONTEXT, ctxattr );
   if ( egl_ctx == EGL_NO_CONTEXT ) {
      printf( "Unable to create EGL context eglError: %x " ,eglGetError());
      printf("\n");

      return 1;
   }

   printf("GLX Context: %p \n",egl_ctx);

    err =  eglMakeCurrent( egl_dpy, egl_surface, egl_surface, egl_ctx );
 
    if (!err==3000) {
      printf("could not make context current. eglError: %x " ,eglGetError());
      printf("\n");
      goto out;

    }

/*
glClear(GL_COLOR_BUFFER_BIT);
glMatrixMode( GL_PROJECTION );
glLoadIdentity();
//gluOrtho2D( 0.0, 500.0, 500.0,0.0 );

    glColor3f(0,0,0);
 glClear(GL_COLOR_BUFFER_BIT);
*/

//A crude clearscreen effect...
//FillDWord /memset(0,egl_sirface,sizeof(egl_surface);
    eglSwapBuffers(egl_dpy, egl_surface);

   // eglSwapInterval(egl_dpy, 0);


  // from now on use your OpenGL context:(eglCtx)

    KeySym key;		/* a dealie-bob to handle KeyPress Events */	
	char text[255];		/* a char buffer for KeyPress Events */
 
//event handler
  Bool quit = False;
  while ( !quit ) {    
 
      while ( XPending (  xlib_dpy ) ) {   // check for events from the x-server
 
       
         XNextEvent( xlib_dpy, &xev );

         if ( xev.type == ButtonPress ) {  // if mouse has moved
            printf("Dont Poke ME! (%i,%i)\n",xev.xbutton.x,xev.xbutton.y);
 //           glColor3f(0.7,0.5,0.7);
 //           glVertex2i(xev.xbutton.x,xev.xbutton.y);
            eglSwapBuffers(egl_dpy, egl_surface);

         }

        if (xev.type==Expose && xev.xexpose.count==0) {
		/* the window was exposed redraw it! */
			    eglSwapBuffers(egl_dpy, egl_surface);
		}
 
         if ( xev.type == KeyPress &&
             XLookupString(&xev.xkey,text,255,&key,0)==1) {
		/* use the XLookupString routine to convert the invent
		   KeyPress data into regular text.  Weird but necessary...
		*/
			if (text[0]=='q') {
				quit=True;
			}
			printf("You pressed the %c key!\n",text[0]);
         }
     } //nothing pending
  } //end mainloop

/*  glClear(GL_COLOR_BUFFER_BIT);

  glColor3f(0.7,0.5,0.7);
  glLineWidth(4);

    glBegin(GL_LINES);
    	glVertex2i(170,20);
	    glVertex2i(20,155);
    glEnd();
*/
  eglSwapBuffers(egl_dpy, egl_surface);



out:

 if (egl_surface) {
      eglDestroySurface(egl_dpy, egl_surface);
 }

 if (egl_configs) {
      free(egl_configs);
 }

 if (egl_dpy) {
      eglTerminate(egl_dpy);
 }

 if (x11_visual) {
      XFree(x11_visual);
 }
 XCloseDisplay(xlib_dpy);

  return 0;

}

