//pyramid OGL demo code for SDLv2(Renderer) using SDL_GL and event driven input
//modified and updated by Richard Jasmin
//original sources: https://www.freepascal-meets-sdl.net/chapter-8-sdl-and-opengl-jedi-sdl/

PROGRAM pyrOGLDEMO;

uses
    sdl2,sdl2_ttf,gl,glu,glext;
var
	quit,minimized:boolean;
    X,y:integer;
	e:PSDL_Event;
    Context: pointer; //SDL undefined quirk

    Renderer:PSDL_Renderer;
   
    window:PSDL_Window; //A window... heh..."windows" he he...

h,hh,th,thh:REAL;

procedure QuitRoutine;
//no more crashes on exit....

begin
//say goodbye to everyone (one at a time) in french....
  TTF_Quit;
  Dispose(e);

//  SDL_DestroyTexture(texture2);
   
  SDL_DestroyRenderer( Renderer );
  SDL_DestroyWindow ( Window );
  
  halt(0); 
end;

//Font rendering requires OpenGl code- not renderer code.Removed.


//MAIN():

begin

 //some calculations needed for a regular tetrahedron with side length of 1
h:=SQRT(0.75); //height of equilateral triangle
hh:=h/2;       //half height of equilateral triangle
th:=0.75;      //height of tetrahedron
thh:=th/2;     //half height of tetrahedron

quit:=false;

   if( ( SDL_Init(SDL_INIT_VIDEO)= -1 ) ) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt initialize SDL','BYE..',NIL);
      writeln(SDL_GetError);
      SDL_delay(500);
      quitroutine;
   end;


Window:= SDL_CreateWindow('My Game Window- click or close to exit.',
                          SDL_WINDOWPOS_UNDEFINED,
                          SDL_WINDOWPOS_UNDEFINED,
                          640, 480,
                          0);
renderer := SDL_CreateRenderer(Window, -1, 0);
 SDL_GL_SetAttribute(SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);

SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3); 
SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2); 
SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 32); 
Context:= SDL_GL_CreateContext(window);

glCLEARCOLOR(0.0, 0.0, 1.0, 0.0);
glVIEWPORT(0,0,640,480);
glMATRIXMODE(GL_PROJECTION);
glLOADIDENTITY;
gluPERSPECTIVE(45.0, 640.0/480.0, 1.0, 3.0);
glMATRIXMODE(GL_MODELVIEW);
glLOADIDENTITY;
glCLEAR(GL_COLOR_BUFFER_BIT);
glENABLE(GL_CULL_FACE);
glTRANSLATEf(0.0, 0.0, -2.0);

   New(e);

  while true do begin //mainloop -should never exit

  if (SDL_PollEvent(e) = 1) then begin
      
      case e^.type_ of
 
               //keyboard events
        SDL_KEYDOWN: begin
                       quit:=true;                                
                       QuitRoutine;
        end;

	    SDL_MOUSEBUTTONDOWN: begin
                       quit:=true;                                
                       QuitRoutine;
	    end;
        
        SDL_WINDOWEVENT: begin
                           
                           case e^.window.event of
                             SDL_WINDOWEVENT_MINIMIZED: minimized:=true; //pause
                             SDL_WINDOWEVENT_MAXIMIZED: minimized:=false; //resume
                             SDL_WINDOWEVENT_ENTER: begin
                                    //nop
                             end; 
                             SDL_WINDOWEVENT_LEAVE: begin
                                   //nop
                             end;
                             SDL_WINDOWEVENT_CLOSE: begin
                                quit:=true;                                
                                QuitRoutine;
                             end;
                           end; //case
        end; //subcase
                    
      end;  //case
   end; //input loop

    if ( not Minimized ) then begin //draw when not minimized and no events firing
//render here

glROTATEf(3, 0.0, 1.0, 0.0);
glCLEAR(GL_COLOR_BUFFER_BIT );

 glBegin(GL_TRIANGLES);
//yellow
    glCOLOR3f(1.0, 1.0, 0.0);
    glVERTEX3f(thh, 0.0, 0.0);
    glVERTEX3f(-thh, hh, 0.0);
    glVERTEX3f(-thh, -hh, 0.5);
 
    glCOLOR3f(0.0, 1.0, 1.0);
    glVERTEX3f(thh, 0.0, 0.0);
    glVERTEX3f(-thh, -hh, -0.5);
    glVERTEX3f(-thh, hh, 0.0);
 
    glCOLOR3f(1.0, 0.0, 1.0);
    glVERTEX3f(thh, 0.0, 0.0);
    glVERTEX3f(-thh, -hh, 0.5);
    glVERTEX3f(-thh, -hh, -0.5);

//white 
    glCOLOR3f(1.0, 1.0, 1.0);
    glVERTEX3f(-thh, -hh, 0.5);
    glVERTEX3f(-thh, hh, 0.0);
    glVERTEX3f(-thh, -hh, -0.5);
  glEnd;
  SDL_GL_SwapWindow(window);
  sdl_delay(10);
    end; //notminimized
  
  
   end; //mainloop
   writeln('exiting...');

   //SDL might be cleaning up...use pascal SDL_delay
   SDL_delay(500);
   SDL_GL_DeleteContext(context); 
   quitroutine;
end.
