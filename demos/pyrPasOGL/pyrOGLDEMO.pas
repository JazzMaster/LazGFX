//pyramid OGL code for SDLv2(Renderer) using event driven input(proper)
//modified and updated from PAscal Demos online  

//forgive the breakage- its temporary while "learning"... -J

PROGRAM pyrOGLDEMO;

uses
    sdl2,sdl2_ttf,gl,glu;
var
	quit,minimized:boolean;
    X,y:integer;
	e:PSDL_Event;
    
    Renderer:PSDL_Renderer;
    screen,screen2,FontSurface : PSDL_Surface; //main drawing screen
    window:PSDL_Window; //A window... heh..."windows" he he...
    Texture1,texture2,texture3:PSDL_Texture;
    Rect1,srcR,destR:PSDL_Rect;
    rmask,gmask,bmask,amask:longword;
    _bgcolor:Longword=$0000ffff; //blue
    _fgcolor:Longword=$ffffffff; //white

  Font_surface:PSDL_Surface;	//font screen 
  ttfFont : PTTF_Font;
  TextFore,TextBack : PSDL_Color; //font fg and bg...


    fontpath:PChar; 
    font_size:integer; 
    style:byte; 
    outline:longint;
    Where:PSDL_Rect;
    
   
userkey:CHAR;
screen:pSDL_SURFACE;
h,hh,th,thh:REAL;
done:boolean;


procedure QuitRoutine;
//no more crashes on exit....

begin
//say goodbye to everyone (one at a time) in french....
  TTF_Quit;
  Dispose(e);
  dispose( Rect1 );
//  SDL_DestroyTexture(texture2);
   
  SDL_DestroyRenderer( Renderer );
  SDL_DestroyWindow ( Window );
  
  halt(0); 
end;


procedure OutText(text:PChar); //write
//needs sanity checks.
var
  wide:PInt;
  high:PInt;
  somestring1,somestring2:string;  
  oldY,gap,newY:integer;

begin
  oldY:=Y;

  New(wide);
  New(high);
  //rendering a text to a SDL_Surface
  FontSurface := TTF_RenderText_Solid( ttfFont, text, TextFore^ ); //string w colors becomes surface

  //this isnt practical but it works..shitty documentation.
  New(Where);

  //convert SDL_Surface to SDL_Texture
  Texture3 := SDL_CreateTextureFromSurface( Renderer, FontSurface ); //make a texture

  SDL_QueryTexture(texture3, Nil, Nil, wide, high); //query the actual size of the text, so as NOT to scale it.
  
//for a single write call this is ok..for multiple we need to track the last X and Y locations used
//and adjust accordingly.

  gap:=(high^ mod 8);
  newY:=(oldY+high^+gap);

  //where we want this- as in OutTextXY or get currentX and Y- not implemented yet.
  Where^.X:=45;
  Where^.Y:=newY;
  Where^.w:=longint(wide^);
  Where^.h:=longint(high^);


  //rendering of the texture
  SDL_RenderCopy( Renderer, Texture3, Nil,Where ); //put tex into render-er

  Y:=newY;

end;

procedure SetupFont; //dont loop this code

begin
{$IFDEF unix}
    fontpath:='/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf'; 
{$ENDIF}
{$IFDEF windows}
    fontpath:='c:\windows\fonts\arial.ttf';
{$ENDIF}

    font_size:=16; 
    style:=TTF_STYLE_NORMAL; 
    outline:=longint(0);


  if TTF_Init = -1 then begin //complain loudly!!
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: I cant engage the font engine, sirs. ','OK',NIL);
  end;
  
  ttfFont := TTF_OpenFont( fontpath, font_size ); //should import and make a surface, like bmp loading
  //get memory for color manipulations
  new(TextFore);
  new(TextBack);

  TextFore^.r:=ord($00);
  TextFore^.g:=ord($00);
  TextFore^.b:=ord($00);

//dont need with solid..Your requirements may vary.
  TextBack^.r:=ord($ff);
  TextBack^.g:=ord($ff);
  TextBack^.b:=ord($ff);


  TTF_SetFontStyle( ttfFont, style ); 
  TTF_SetFontOutline( ttfFont, outline );
  TTF_SetFontHinting( ttfFont, TTF_HINTING_NORMAL );

end;

//MAIN():

begin

 //some calculations needed for a regular tetrahedron with side length of 1
h:=SQRT(0.75); //height of equilateral triangle
hh:=h/2;       //half height of equilateral triangle
th:=0.75;      //height of tetrahedron
thh:=th/2;     //half height of tetrahedron

quit:=false;

//this is the "flow"...
   //engage SDL

   if( ( SDL_Init(SDL_INIT_VIDEO or SDL_INIT_TIMER)= -1 ) ) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt initialize SDL','BYE..',NIL);
      writeln(SDL_GetError);
      delay(500);
      quitroutine;
   end;

//we need a window -but Im a touch unsure on the rest, at the moment.
//the demo uses sdl+opengl not straight gl

  minimized:=false;
  window :=SDL_CreateWindow(
        'SDL Pyramid Demo',                  // window title
        SDL_WINDOWPOS_CENTERED,           // initial x position
        SDL_WINDOWPOS_CENTERED,           // initial y position
        640,                               // width, in pixels
        480,                               // height, in pixels
        SDL_WINDOW_OPENGL                  // windowflags
  );

  if ( window = Nil ) then begin
    {if IsConsoleInvoked then begin
       writeln('Unable to setup window: ');
       writeln('SDL reports: ',' ', SDL_GetError);      
    end;}
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set this forced video mode.','BYE..',NIL);
     writeln(SDL_GetError);
      delay(500);
      quitroutine;
  end;
   

  Renderer := SDL_CreateRenderer( Window, -1, SDL_RENDERER_ACCELERATED ); //this windows and driver(OGL) and accel if possible
  if ( Renderer = Nil ) then begin
    {if IsConsoleInvoked then begin
       writeln('Unable to draw ');
       writeln('SDL reports: ',' ', SDL_GetError);      
    end;}
//    ShowMessage('I cannot draw.'+SDL_GetError);
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot draw.','BYE..',NIL);
    writeln(SDL_GetError);
    delay(500);
    quitroutine;
  end;

 
///15bit mode 
GL_SETATTRIBUTE(SDL_GL_RED_SIZE, 5);
GL_SETATTRIBUTE(SDL_GL_GREEN_SIZE, 5);
GL_SETATTRIBUTE(SDL_GL_BLUE_SIZE, 5);
//ok-16bit..
GL_SETATTRIBUTE(SDL_GL_DEPTH_SIZE, 16);

GL_SETATTRIBUTE(SDL_GL_DOUBLEBUFFER, 1);
 

glCLEARCOLOR(0.0, 0.0, 1.0, 0.0);
glCLEAR(GL_COLOR_BUFFER_BIT);

glVIEWPORT(0,0,640,480);

glMATRIXMODE(GL_PROJECTION);
glLOADIDENTITY;

gluPERSPECTIVE(45.0, 640.0/480.0, 1.0, 3.0);

glMATRIXMODE(GL_MODELVIEW);
glLOADIDENTITY;


glENABLE(GL_CULL_FACE);
glTRANSLATEf(0.0, 0.0, -2.0);



   SetupFont;
   Gotoxy(14,40); //moveTo(x,y);
   OutText('Press any key (or close) to EXIT.');
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

glROTATEf(5, 0.0, 1.0, 0.0);
glCLEAR(GL_COLOR_BUFFER_BIT );
 
glBEGIN(GL_TRIANGLES);
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
 
    glCOLOR3f(1.0, 1.0, 1.0);
    glVERTEX3f(-thh, -hh, 0.5);
    glVERTEX3f(-thh, hh, 0.0);
    glVERTEX3f(-thh, -hh, -0.5);
glEND;
 
GL_SWAPBUFFERS;

  	end; //notminimized
    SDL_Delay(50);
    
  
   end; //mainloop
   
   //SDL might be cleaning up...use pascal delay
   delay(500);

end.
