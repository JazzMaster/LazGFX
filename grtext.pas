
Unit grText;
//graphics text functions-not fully implemented, just the basics.

//vericle text- one char per "line" until end of screen or text- then pushes to the right.

interface 
				
{$I bgisdl.inc}

type
  str80=string(80);
  str256=string(256);
  directions=(horizontal,verticle);
  textinfo=record
        font      : PSDL_FontInfo;
        direction : directions;
        charsize  : integer; 
  end;

var
    fontdata:PSDL_FontInfo;
    IsJapanese:boolean;

procedure backspace( Font:^SDL_FontInfo, ch:char);

//string to pchar??
procedure OutText(text:PChar);
procedure outtextXY(x,y:integer; textstring:PChar);

procedure OutTextLn(text:PChar);
procedure outtextXYLn(x,y:integer; textstring:PChar);

function textheight (textstring:string):integer;
function textwidth (text:string)integer;

procedure GetTextSettings(TextInfo : TextSettingsType);

procedure SetTextJustify(direction:directions);
procedure SetTextStyle(font:string; direction : directions; font_size:integer;);

//style is italic,bold,normal,etc...
procedure installUserFont(fontpath:string; font_size:integer; style:fontflags; outline:boolean);

implementation


procedure installUserFont(fontpath:string; font_size:integer; style:fontflags; outline:boolean);

{
MOD: SDL, not BGI .CHR files which is where most code comes from.
SDL uses TTF Fonts

font_size: some number in px =12,18, etc
path: (varies by OS) to font we want....

style is one of: 
		TTF_STYLE_NORMAL
		TTF_STYLE_UNDERLINE
		TTF_STYLE_ITALIC 
		TTF_STYLE_BOLD
		TTF_STYLE_ITALIC
		TTF_STYLE_UNDERLINE
		TTF_STYLE_STRIKETHROUGH


outline: make it an outline (instead of drawn "stroked", the font is drawn inverted-hollow)

fontpath: MUST BE SPECIFIED - you will crash TTF routines(and possibly SDL and everything on top of it- if you dont)
-code is like a stack of cards in that way.
}

begin
  
  //initialization of TrueType font engine and loading of a font
  if TTF_Init = -1 then begin
    
    if IsConsoleInvoked then begin
        writeln('I cant engage the font engine, sirs.');
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: I cant engage the font engine, sirs. ','OK',NIL);
		
    _graphResult:=-3; //the most likely cause, not enuf ram.
    exit;
 
  end;
  if FontPath:='' then begin
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'ERROR: No Font Specified to Load. ','OK',NIL);
		_graphResult:=-7; //error 7 or 8....FontNotFound(Nothing)
		exit;
  end;
  ttfFont := TTF_OpenFont( fontpath, font_size ); //should import and make a surface, like bmp loading
  //fg and bg color should be set for us(or changed by the user in some other procedure)
  new(TextFore);
  new(TextBack);
  TextFore:=_fgcolor;
  TextBack:=_bgcolor;

  TTF_SetFontStyle( ttfFont, style ); 
  TTF_SetFontOutline( ttfFont, outline );
  TTF_SetFontHinting( ttfFont, TTF_HINTING_NORMAL );
  SetTextColor(TextFore,TextBack);

  //dont render yet...just set it up.

end;


procedure backspace( Font:PSDL_FontInfo, ch:char);

  dstrect:PSDL_Rect ;
  bufp:string;
  x1,y1,ofs:integer;
	
begin
//because we use the renderer- we need to convert back to a surface

  x1:=0;
  y1:=0;	

  dstrect.w := ( ((Font^.CharPos[ofs+2]+Font^.CharPos[ofs+1]) mod 2) -((Font^.CharPos[ofs]+Font^.CharPos[ofs-1]) mod 2) );

  Where.x:=(Where.x -(Font^.CharPos[ofs+1]-Font^.CharPos[ofs]));

  if (Where.x<0) then Where.x := 0;

  if (Where.x>MaxX) then begin //new line
        Where.x := 0+(Font^.Surface.w mod 2);
        Where.y :=Where.y+ (Font^.Surface.h mod 4);
  end;      

  dstrect^.x:=Where.x1;
  dstrect^.y:=Where.y1;
  dstrect^.w:=Font^.Surface.h;
  dstrect^.h:=Font^.Surface.w;

  setPenColor(_bgcolor); //(erase with background color by writing with it)
  SDL_RenderFillrect(Renderer,dstrect);	  

end;


procedure OutText(text:PChar); //write
//you dont this successively, you call writeln instead unless smacking things together.
var
  wide:PInt;
  high:PInt;
  somestring1,somestring2:string;  
  oldY,gap,newY:integer;
  where:SDL_Rect;

begin
  oldY:=Y;

  New(wide);
  New(high);

  //rendering a text to a SDL_Surface
  FontSurface := TTF_RenderText_Solid( ttfFont, text, TextFore^ ); //string w colors becomes surface
  Texture3 := SDL_CreateTextureFromSurface( Renderer, FontSurface ); //make a texture
  SDL_QueryTexture(texture3, Nil, Nil, wide, high); //query the actual size of the text, so as NOT to scale it.

  //this isnt practical but it works..shitty documentation.
  New(Where);
  
  //where we want this- as in OutTextXY or get currentX and Y- not implemented yet.
  Where^.X:=X;
  Where^.Y:=Y;
  Where^.w:=longint(wide^);
  Where^.h:=longint(high^);

  //rendering of the texture
  SDL_RenderCopy( Renderer, Texture3, Nil,Where ); //put tex into render-er

  Y:=newY;
  
end;

procedure OutTextLn(text:PChar); //writeLN
//needs sanity checks.
var
  wide:PInt;
  high:PInt;
  somestring1,somestring2:string;  
  oldY,gap,newY:integer;
  Where:PSDL_Rect;

begin
  oldY:=Y;

  New(wide);
  New(high);
  //rendering a text to a SDL_Surface-push to a Texture

{
FIXME: japanese style not done
push each char/pchar and check for rendering offscreen..if it would be, go to the next (Y+textsize) line and keep going.
iff off the screen, stop.

right now this pushes Y down- assuming theres room and assuming that the text doesnt go beyond the screen
80x25=> graphics mode(320x240) 
50-64 (1/2 width) horizontal chars (or 1/2 the num of them) and 24-30 verticle text lines

}

  FontSurface := TTF_RenderText_Solid( ttfFont, text, TextFore^ ); //string w colors becomes surface
  Texture3 := SDL_CreateTextureFromSurface( Renderer, FontSurface ); //make a texture
  SDL_QueryTexture(texture3, Nil, Nil, wide, high); //query the actual size of the text, so as NOT to scale it.

//for a single write call this is ok..for multiple we need to track the last X and Y locations used
//and adjust accordingly.

  gap:=(high^ mod 8);
  newY:=(oldY+high^+gap);

  //this isnt practical but it works..shitty documentation.
  New(Where);

  //where we want this- as in OutTextXY or get currentX and Y- not implemented yet.
  Where^.X:=X;
  Where^.Y:=newY;
  Where^.w:=longint(wide^);
  Where^.h:=longint(high^);

  //rendering of the texture
  SDL_RenderCopy( Renderer, Texture3, Nil,Where ); //put tex into render-er

  Y:=newY;

end;


{
function grReadLineWithLimits:string;


begin

      SDL_EnableKeyRepeat( SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_interval);
      SDL_EnableUNICODE(1);
      while not quit do begin

   	   if (SDL_PollEvent( &event )) 
	     case( event.type ) of
	  
         SDL_KEYDOWN:
	       ch=event.key.keysym.unicode;
	       if (isprint(ch) and i<len(SCAN_BUF)-1) // Check that buffer isn't full
	       begin
		     input[i]=ch;
             inc(i);
             if echo=true then
				MPutString(ch);
		     if input[i]=#10 then
		        MPutString(current);	//draws the last entered char
	      end
	    else if (ch=SDLK_BACKSPACE and i>0) then begin
		
		  dec(i);
		  dec(current);
		
          makespace(InternalFont, input[i]);//clears last entered char
		  input[i]=#10;
		end else if (ch=SDLK_RETURN) then begin
			 
			 TP.x = 0;		// Reset X position.
		     TP.y :=TP.y+ internalFont.Surface.h;  //inc y position.
		 
        end;
	  end;
	  SDL_KEYUP:
	    md := event.key.keysym.mod;
	    if( (md and KMOD_RCTRL) or ( md and KMOD_LCTRL ) ) then begin
	      if  (event.key.keysym.sym=SDLK_c)	then begin //Check for CTRL-C
		     MPutString('Keyboard interrupt detected. Qutting...');
		     SDL_Delay(200);
		     exit(0);  
		  end;
       
		end; 
    end;
end;
}

//write and writeln do not take chars by default.
//that requires overloading..
		
procedure grWriteChar(c:char);

var
  current:string;
begin	
  if LIBGRAPHICS_ACTIVE=0 then
      write(c);
  else begin
      current[1]:=c; //hackish but it works.
      OutText(current);	//draws the last entered char. outtext does same.
    end;
end;


procedure outtextXY(x,y:integer; textstring:PChar);

var
  xbak,ybak:integer;
begin
  if IsGRAPHICS_ENABLED then begin
  	xbak :=TP.x;
  	ybak := TP.y;	//save current text position
	TP.x := x; 
	TP.y := y;			//set text position to arguments
    outText(textstring);
    TP.x := xbak;
    TP.y := ybak;		//restore text position
  end;
end;

procedure outtextXYLn(x,y:integer; textstring:PChar);

var
  xbak,ybak:integer;
begin
  if IsGRAPHICS_ENABLED then begin
  	xbak :=TP.x;
  	ybak := TP.y;	//save current text position
	TP.x := x; 
	TP.y := y;			//set text position to arguments
    outTextLn(textstring);
    TP.x := xbak;
    TP.y := ybak;		//restore text position
  end;
end;


function textheight:integer;
begin
  if LIBGRAPHICS_ACTIVE then begin
   	TextHeight:=internalFont.h;
  end;
end;

function textwidth:integer;
begin

 if LIBGRAPHICS_ACTIVE then begin
   TextHeight:=internalFont.w;
 end;
end;

function gettextsettings:textinfo;

begin
  textinfo.font      := fontdata;
  textinfo.direction := direction;
  textinfo.charsize  := textwidth; //these were intended to be different
end;


procedure settextstyle(fontname:string direction:directions; textsize:integer);
//backwads compatible with some changes
begin
  //give me the path to a font....
  //give me the size you want it
  //do we write it sideways or up and down like japanese?

//  SDL_SetFont(fontname,direction,textsize); 
end;


//Im noticing that a ton of the font routines use .CHR (old school fonts)
//although we *could* support them, this is very ancient tech. Id rather use TTF straight-up.

{
procedure SetTextJustify(direction:directions);
//write one letter at a time if verticle, ignore and write normally if horizontal

begin
    if direction=verticle then
        IsJapanese:=true 
    else
        IsJapanese:=false;
    SDL_SetFont(fontname,direction,textsize); 
        
end;

}


end.
