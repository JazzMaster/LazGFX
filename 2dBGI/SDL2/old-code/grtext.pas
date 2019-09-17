Unit grText;
// setFont and init and stop functions work
{$mode objfpc}

interface 
uses
	SDL2,SDL2_TTF,strings;

//sub units will not work until the main unit is abstrated.
//im holding off on this- as the main units have a lot of rewrite at the moment.
				
{$I lazgfx.inc}

type
  str80=string(80);
  str256=string(256);
  directions=(horizontal,verticle); //ord(horizontal)
  textinfo=record
        font      : PSDL_FontInfo;
        direction : directions;
        charsize  : integer; 
  end;

var
    fontdata:PSDL_FontInfo;
    IsJapanese:boolean;
    PasFont: TFreeTypeFont;

procedure backspace( Font:^SDL_FontInfo, ch:char);

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

//harp on default(built-in) or user if specified - since we dont know where the font files are.
//ask for the info. if nil- reset to default font.

procedure installUserFont(fontpath:string; font_size:integer; style:fontflags; outline:boolean);

{
BGI:
  Fonts : array[0..4] of string[13] =
  ('DefaultFont', 'TriplexFont', 'SmallFont', 'SansSerifFont', 'GothicFont');


MOD: TTF, not BGI .CHR files which is where most code comes from.

font_size: some number in px =12,18, etc

style is one of: 
		TTF_STYLE_NORMAL
		TTF_STYLE_UNDERLINE
		TTF_STYLE_ITALIC 
		TTF_STYLE_BOLD
		TTF_STYLE_ITALIC
		TTF_STYLE_UNDERLINE
		TTF_STYLE_STRIKETHROUGH

outline: make it an outline, instead of "Stroked"

fontpath: MUST BE SPECIFIED - you will crash TTF routines(and possibly SDL and everything on top of it- if you dont)
-code is like a stack of cards in that way.

}

begin
  
  end;
  if FontPath:='' then begin
		//use the internal one, LUKE.

//....

		_graphResult:=-7; //error 7 or 8....FontNotFound(Nothing)
		exit;
  end;
  ttfFont := TTF_OpenFont( fontpath, font_size ); //should import and make a surface, like bmp loading
  //fg and bg color should be set for us(or changed by the user in some other procedure)
  TextFore:=_fgcolor;
  TextBack:=_bgcolor;

  TTF_SetFontStyle( ttfFont, style ); 
  TTF_SetFontOutline( ttfFont, outline );
  TTF_SetFontHinting( ttfFont, TTF_HINTING_NORMAL );
  SetTextColor(TextFore,TextBack);

  //dont render yet...just set it up.

end;


{
Blinking: 

This isnt really used- but it is possible.

if you want to blink circles etc...I wil leave this to the reader(blits and colorkeys, people).
it can be done- but its very unused code. 

Ususally reserved for text warnings,notices, etc.
so anyway- heres how to do it.

blink used to be set at value 128;

 Color:=color+Blink; -is the old way.
 Blink('string'); -is the new way.

update your code. 
CANTFIX: and WONTFIX: this. 
(This was a hardwired spec in the past and is not anymore. 
VGA direct register access is no longer used.
Neither are int10 calls in assembled.)

}

//blink is a crt function
procedure Grblink(Text:string);

//SDL can only SLOWLY redraw over something to "erase"
//write..erase(redraw)..write..erase..
//yes this is how my kernel console code works -just implemented differently.
begin
//threads(sub-process), not fork(new app instance)
    
    BlinkPID:=fpfork; //fpfork(): this has to occur wo stopping while other ops are going on usually
	blink:=true; //this wont kill itself, naturally. 
    //I AM INVINCIBLE!! (only external forces can kill me now.)

        Curr^.X:=x;
        Curr^.Y:=y;  
		OutText(text);
		invertcolors;
		delay(500);
        x:=Curr^.X;
        y:=Curr^.Y;
		GotoXY(x,y);
    repeat		
		OutText(text);
		invertcolors;
		delay(500);
		GotoXY(x,y);
	until blink:=false;
end;

procedure GrSTOPBlink;
//often the simplest solution is the easiest and most sane.
//we walk up to the blinking text, nudge it- and say STOP.
   
begin
            blink:=false; //kill the loop
			delay(1000); //wait for routine to safely exit.
			killPID(BlinkPID); //BLAM! DIE.
			BlinkPID:=Nil;
end;


procedure backspace;
//get size of char-
//   go back that and a char space.
//   rewrite by overwriting both
//   go back and reset x,y
// -- this is how crt unit does it, btw.

var
  Font:PSDL_FontInfo;  
  dstrect:PSDL_Rect;
  bufp:string;
  x1,y1,ofs:integer;
  Tex:PSDL_Texture;
	
begin
//surface??

//do ops
  Where.x:=(Where.x -(Font^.CharPos[ofs+1]-Font^.CharPos[ofs]));

  if (Where.x<0) then Where.x := 0;

  if (Where.x>MaxX) then begin //new line
        Where.x := 0+(Font^.Surface.w mod 2);
        Where.y :=Where.y+ (Font^.Surface.h mod 4);
  end;      

  dstrect^.x:=(Where.x-(Font^.Surface.w));
  dstrect^.y:=Where.y; //on same line only!!
  dstrect^.w := ( ((Font^.CharPos[ofs+2]+Font^.CharPos[ofs+1]) mod 2) -((Font^.CharPos[ofs]+Font^.CharPos[ofs-1]) mod 2) );
  dstrect^.h:=Font^.Surface.h;

  setPenColor(_bgcolor); //(erase with background color by writing with it)
  SDL_Fillrect(MainSurface,dstrect,_bgcolor);
	  
  //go back the width of the erased rect
  Where.x:=( ((Font^.CharPos[ofs+2]+Font^.CharPos[ofs+1]) mod 2) -((Font^.CharPos[ofs]+Font^.CharPos[ofs-1]) mod 2) );
  
  //go feed the renderer
  Tex:= SDL_CreateTextureFromSurface( Renderer, MainSurface );
  SDL_RenderCopy( Renderer, Tex, Nil,dstrect ); //"SDL_UpdateRect"

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
  if fontname= '' then begin //use internal font
  
  end;
  //set some sane values- no writing off screen.
  // and no too-tiny text.

  if textsize<1 then textsize=4;
  if textsize >70 then textsize=70;
  //ttf_openFont
  SDL_SetFont(fontname,ord(direction),textsize); 
end;


procedure SetTextJustify(direction:directions);
//write one letter at a time if verticle, ignore and write normally if horizontal

begin
    if direction=verticle then
        IsJapanese:=true 
    else
        IsJapanese:=false;
    SDL_SetFont(fontname,ord(direction),textsize); 
        
end;



end.
