program SDL_RenderDemo;
//doesnt use "BGI"..you can see how complex this gets.
//each and every thing needs to be checked for and handled...or ignored.

//rendering: LIMIT the calls to renderPresent. You only need one- you are in a loop, remember?
//surface functions arent liking the rect calls..maybe someone is linking them wrong? carets in the wrong place?

//backport in progress...WE ARE THERE!

//gawd I need "pointer schooling..."
uses
    sdl2,sdl2_ttf,crt;
var
    paused,quit,minimized:boolean;
    X,y:integer;
	event:PSDL_Event;
    
    Renderer:PSDL_Renderer;
    screen,screen2,FontSurface : PSDL_Surface; //main drawing screen
    window:PSDL_Window; //A window... heh..."windows" he he...
    Texture1,texture2,texture3:PSDL_Texture;
    Rect1,srcR,destR:PSDL_Rect;
    rmask,gmask,bmask,amask:longword;
    _fgcolor:Longword=$0000ffff; //blue

  Font_surface:PSDL_Surface;	//font screen 
  ttfFont : PTTF_Font;
  TextFore,TextBack : PSDL_Color; //font fg and bg...


    fontpath:PChar; 
    font_size:integer; 
    style:byte; 
    outline:longint;
    Where:PSDL_Rect;

{ Return the pixel value at (x, y)}


function SDL_GetPixel( SrcSurface : PSDL_Surface; x : integer; y : integer ) : Longword;
var
  bpp          : UInt32;
  p            : PInteger;
  byte1,byte2,byte3:^byte;

begin
  SDL_LockSurface(SrcSurface);
  bpp := PtrUInt(SrcSurface^.format^.BytesPerPixel);
  // Here p is the address to the pixel we want to retrieve

//7 yr outstanding unpatched bug(pascal game development website)
//64bit fix(that works on 32bit) due to an internal FPC fuckup....
p := Pointer( PtrUInt( SrcSurface^.pixels ) + UInt32( y ) * SrcSurface^.pitch + UInt32( x ) * bpp );
//  p := Pointer( Uint32( SrcSurface.pixels ) + UInt32( y ) * SrcSurface.pitch + UInt32( x ) * bpp );
  case bpp of
    1 : SDL_GetPixel := Longword(PUint8( p )^);
    2 : SDL_GetPixel:= Longword(PUint16( p )^);
    3 : begin
{      if ( SDL_BYTEORDER = SDL_BIG_ENDIAN ) then
        SDL_GetPixel:= PUInt8Array( p )[ 0 ] shl 16 or PUInt8Array( p )[ 1 ] shl 8 or
          PUInt8Array( p )[ 2 ]
      else}
        byte1:= PUInt8(p);
        byte2:= PUInt8((p^ shl 8 ));
        byte3:= PUInt8(( p^ shl 16 ));
        SDL_GetPixel:=Longword(byte1^ or byte2^ or byte3^);
    end;
    4 : SDL_GetPixel:= PUint32( p )^;
  else
    SDL_GetPixel := 0; // shouldn't happen, but avoids warnings
  end; //case
  SDL_UnLockSurface(SrcSurface);
end;

{ Set the pixel at (x, y) to the given value}


procedure SDL_PutPixel( DstSurface : PSDL_Surface; x : integer; y : integer; pixel : Longword );
var
  bpp          : Longword;
  p            : PInteger;
begin
  bpp := DstSurface^.format^.BytesPerPixel;
//    p := Pointer( PtrUInt( DstSurface^.pixels ) + Longword( y ) * DstSurface^.pitch + Longword( x ) * bpp);
  p := Pointer( Uint32( DstSurface^.pixels ) + UInt32( y ) * DstSurface^.pitch + UInt32( x ) * bpp );
  case bpp of
    1 : PUint8( p )^ := pixel;
    2 : PUint16( p )^ := pixel;
    3 :
   {   if ( SDL_BYTEORDER = SDL_BIG_ENDIAN ) then
      begin
        PUInt8Array( p )[ 0 ] := ( pixel shr 16 ) and $FF;
        PUInt8Array( p )[ 1 ] := ( pixel shr 8 ) and $FF;
        PUInt8Array( p )[ 2 ] := pixel and $FF;
      end
      else}
      begin

        PUInt8Array( p )[ 0 ] := PUInt8(pixel and $FF);
        PUInt8Array( p )[ 1 ] := PUInt8(( pixel shr 8 ) and $FF);
        PUInt8Array( p )[ 2 ] := PUInt8(( pixel shr 16 ) and $FF);

      end;
    4 :  PUint32( p )^ := pixel;
  end; //case
end;

procedure QuitRoutine;
//no more crashes on exit....

begin
//say goodbye to everyone (one at a time) in french....
  TTF_Quit;
  Dispose(event);
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
//SDL_RenderPresent(Renderer);
  Y:=newY;
  dispose(where);
  dispose(high);
  dispose(wide);

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

procedure PlotPixelWNeighbors(x,y:integer);
//this makes the bigger dots 

var

  SrcR1:PSDL_Rect;
  DestR1:PSDL_Rect;

  
begin
   rmask := $ff000000;
   gmask := $00ff0000;
   bmask := $0000ff00;
   amask := $000000ff;
                
   //only create ONE surface, not a surface each time we are called.
   screen2 := SDL_CreateRGBSurface(0, 320, 240, 32, rmask,gmask,bmask,amask);


   SDL_LockSurface(screen2);
   SDL_PutPixel(screen2,x,y,_fgcolor);
   SDL_PutPixel(screen2,x+1,y,_fgcolor);
   SDL_PutPixel(screen2,x,y+1,_fgcolor);
   SDL_PutPixel(screen2,x-1,y,_fgcolor);
   SDL_PutPixel(screen2,x,y-1,_fgcolor);
   SDL_PutPixel(screen2,x+1,y+1,_fgcolor);
   SDL_PutPixel(screen2,x-1,y-1,_fgcolor);
   SDL_PutPixel(screen2,x-1,y+1,_fgcolor);
   SDL_PutPixel(screen2,x+1,y-1,_fgcolor);
   SDL_UnlockSurface(screen2);
   
   texture1:=SDL_CreateTextureFromSurface(Renderer, screen2);
   SDL_RenderCopy(Renderer, texture1, Nil,Nil);
  // SDL_RenderPresent(Renderer);

   SDL_FreeSurface(screen2);
   SDL_DestroyTexture(texture1);
end;


//MAIN()

begin
  quit:=false;
  Y:=15; //start text here
//this is the "flow"...
   //engage SDL

   if( ( SDL_Init(SDL_INIT_VIDEO or SDL_INIT_TIMER)= -1 ) ) then begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldnt initialize SDL','BYE..',NIL);
      writeln(SDL_GetError);
      delay(500);
      quitroutine;
   end;
  minimized:=false;
  window :=SDL_CreateWindow(
        'SDL Renderer Demo',                  // window title
        SDL_WINDOWPOS_CENTERED,           // initial x position
        SDL_WINDOWPOS_CENTERED,           // initial y position
        320,                               // width, in pixels
        240,                               // height, in pixels
        SDL_WINDOW_OPENGL       // windowflags
  );

  if ( window = Nil ) then begin
    {if IsConsoleInvoked then begin
       writeln('Unable to setup window: ');
       writeln('SDL reports: ',' ', SDL_GetError);      
    end;}
 //   ShowMessage('I cannot setup the window.'+SDL_GetError);
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: SDL cannot set this forced video mode.','BYE..',NIL);
     writeln(SDL_GetError);
      delay(500);
      quitroutine;
  end;
   

  Renderer := SDL_CreateRenderer( Window, 0, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC ); //this windows and driver(OGL) and accel if possible
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


  	 //Clear screen -there is a slight unavoidable delay with repainting the screen.
     //should only be limited to primitives such as these. 
		 SDL_SetRenderDrawColor( Renderer, $FF, $FF, $FF, $FF ); 
		 SDL_RenderClear( Renderer ); 
    //update screen
   SDL_RenderPresent(Renderer);
  SDL_RenderPresent(Renderer);

   SetupFont;

//do this "the first time"

          //I moved the code here- to update the window(ONCE)--not repeatedly.
    	 //Draw dots
         SDL_SetRenderDrawColor( Renderer, ord($FF), ord($00), ord($00), ord($FF) ); 
		 SDL_RenderDrawPoint( Renderer, 5, 5 );
		 SDL_RenderDrawPoint( Renderer, 8, 8 );
		 SDL_RenderDrawPoint( Renderer, 12, 12 );
         SDL_RenderDrawPoint( Renderer, 15, 15 );
		 SDL_RenderDrawPoint( Renderer, 20, 20 );

        //draw rectangle

        new( Rect1 );
        Rect1^.x := 10; 
        Rect1^.y := 10; 
        Rect1^.w := 120; 
        Rect1^.h := 120;

        SDL_SetRenderDrawColor( Renderer, 0, 255, 0, 255 );
        SDL_RenderDrawRect( Renderer, Rect1 );
        dispose(Rect1);      

  	    PlotPixelWNeighbors(25,25);
        PlotPixelWNeighbors(35,35);


//issue is that we are called within a loop.
//therefore the text will quickly run off of the screen.

//alternative is to gotoXY during repaint(loop) and keep resetting X and Y.
y:=15;
        OutText('This is Ubuntu Sans Regular.');
        OutText('Did the mouse leave us?');
SDL_RenderPresent(renderer);


   New(event);
  while true do begin //mainloop -should never exit
        

  if (SDL_PollEvent(event) = 1) then begin
      
      case event^.type_ of
 
               //keyboard events
        SDL_KEYDOWN: begin
                       outText( 'Key pressed: ');
                       //print scancode
        end;

	    SDL_MOUSEBUTTONDOWN: exit; //outText( 'Mouse button pressed: '+ chr(e^.button.button) );
        
        SDL_WINDOWEVENT: begin
                           
                           case event^.window.event of
                             SDL_WINDOWEVENT_MINIMIZED: minimized:=true; //pause
                             SDL_WINDOWEVENT_MAXIMIZED: minimized:=false; //resume
                             SDL_WINDOWEVENT_ENTER: begin
                                    //resume input and restore
                                    SDL_EventState( SDL_MOUSEMOTION, SDL_ENABLE ); 
                                    SDL_EventState( SDL_TEXTINPUT, SDL_ENABLE );
                                    SDL_SetRenderDrawColor( Renderer, $FF, $FF, $FF, $FF ); 
		                            SDL_RenderClear( Renderer ); 
                                    SDL_RenderPresent(renderer);
                                     SDL_RenderPresent(renderer);
                                    paused:=false;

          //I moved the code here- to update the window(ONCE)--not repeatedly.
    	 //Draw dots
         SDL_SetRenderDrawColor( Renderer, ord($FF), ord($00), ord($00), ord($FF) ); 
		 SDL_RenderDrawPoint( Renderer, 5, 5 );
		 SDL_RenderDrawPoint( Renderer, 8, 8 );
		 SDL_RenderDrawPoint( Renderer, 12, 12 );
         SDL_RenderDrawPoint( Renderer, 15, 15 );
		 SDL_RenderDrawPoint( Renderer, 20, 20 );

        //draw rectangle

        new( Rect1 );
        Rect1^.x := 10; 
        Rect1^.y := 10; 
        Rect1^.w := 120; 
        Rect1^.h := 120;

        SDL_SetRenderDrawColor( Renderer, 0, 255, 0, 255 );
        SDL_RenderDrawRect( Renderer, Rect1 );
        dispose(Rect1);      

  	    PlotPixelWNeighbors(25,25);
        PlotPixelWNeighbors(35,35);


//issue is that we are called within a loop.
//therefore the text will quickly run off of the screen.

//alternative is to gotoXY during repaint(loop) and keep resetting X and Y.
y:=15;
        OutText('This is Ubuntu Sans Regular.');
        OutText('Did the mouse leave us?');
SDL_RenderPresent(renderer);
                             end; 
                             SDL_WINDOWEVENT_LEAVE: begin
                                   //ignore input and fade out
                                    SDL_EventState( SDL_MOUSEMOTION, SDL_IGNORE );
                                    SDL_EventState( SDL_TEXTINPUT,SDL_IGNORE );
                                    SDL_SetRenderDrawColor( Renderer, $77, $77, $77, $FF ); 
		                            SDL_RenderClear( Renderer ); 
                                    SDL_RenderPresent(renderer);
                                    Paused:=true;
                             end;
                             SDL_WINDOWEVENT_CLOSE: begin
                                quit:=true;                                
                                QuitRoutine;
                             end;
                           end; //case
        end; //subcase
                    
      end;  //case
   end; //input loop

    SDL_Delay(3);
    
  
   end; //mainloop
   
   //SDL might be cleaning up...use pascal delay
   delay(500);
end.

