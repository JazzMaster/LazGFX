Unit grText;
{$mode objfpc}

interface 
uses
	SDL2,SDL2_TTF,strings;
				
//This unit works as-is but needs the LazGFX headers "extracted" to do so.				
{$I lazgfx.inc}

type
  str80=string[80];
  str256=string[255];
  
  //directions=(horizontal,verticle); //ord(horizontal)
  
  textinfoRec=record
        font      :  PTTF_Font;
        direction : boolean;
        charsize  : integer; 
  end;

var
    textinfo:textInfoRec;
    BlinkPID:longint;
    IsJapanese,UseInternalFont:boolean;
    //From this we determind which TTF file to load.
    //CHR support is outdated, and "an ugly mess" larger then 12pt.
    Fonts : array[0..4] of string[13] = ('DefaultFont', 'TriplexFont', 'SmallFont', 'SansSerifFont', 'GothicFont');
    ttfFont : PTTF_Font;
    
//redo this!
procedure backspace;

procedure OutText(text:PChar);
procedure outtextXY(x,y:integer; textstring:PChar);

procedure OutTextLn(text:PChar);
procedure outtextXYLn(x,y:integer; textstring:PChar);

function textheight:integer;
function textwidth:integer;
function GetTextSettings:textinfoRec;

procedure SetTextJustify(direction:boolean);
procedure SetTextStyle(font:string; direction : boolean; font_size:integer);

//style is italic,bold,normal,etc...
procedure installUserFont(fontpath:string; font_size:integer; style:integer; outline:boolean);

implementation

//harp on default(built-in) or user if specified - since we dont know where the font files are.
//ask for the info. if nil- reset to default font.

procedure installUserFont(fontpath:PChar; font_size:integer; style:integer; outline:boolean);

{

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

fontpath: SPECIFY IT or I assume you want an ugly default font

}

begin
  
  if FontPath=Nil then
		UseInternalFont:=true;
  //else:
  ttfFont := TTF_OpenFont( fontpath, font_size ); //should import and make a surface, like bmp loading
  //fg and bg color should be set for us(or changed by the user in some other procedure)

{
wants PSDL_Color, not longword

  TextFore:=_fgcolor;
  TextBack:=_bgcolor;
}

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

//SDL_CreateThread
    
//    BlinkPID:=fpfork; //fpfork(): this has to occur wo stopping while other ops are going on usually
	blink:=true; //this wont kill itself, naturally. 
    //I AM INVINCIBLE!! (only external forces can kill me now.)

        Where.X:=x;
        Where.Y:=y;  
		OutText(text);
		invertcolors;
		SDL_Delay(500);
        x:=Where.X;
        y:=Where.Y;
		moveto(x,y);
    repeat		
		OutText(text);
		invertcolors;
		SDL_Delay(500);
		moveto(x,y);
	until blink=false;
end;

procedure GrSTOPBlink;
//often the simplest solution is the easiest and most sane.
//we walk up to the blinking text, nudge it- and say STOP.
   
begin
            blink:=false; //kill the loop
			SDL_Delay(1000); //wait for routine to safely exit.
			SDL_WaitThread(BlinkPID,Nil); //BLAM! DIE.
		//	BlinkPID:=0;
end;


//how this shitty C code ever works, is beyond me ShazBakker...


procedure backspace;
//get size of char-
//   go back sizeof(that and a char space).
//   rewrite by overwriting both
//   go back and reset x,y
// -- this is how crt unit does it, btw.
{
var
  
  dstrect:PSDL_Rect;
  bufp:string;
  x1,y1,ofs:integer;
  Tex:PSDL_Texture;
	
begin
//MainSurface should be allocated, although any will do.
//if you dont use MainSurface(yes, it is optional), then 
// SDL_CreateRGBSurface()

with TextInfo do begin
  Where.x:=(Where.x -(Font^.CharPos[ofs+1]-Font^.CharPos[ofs]));

  if (Where.x<0) then Where.x := 0;

  if (Where.x>MaxX) then begin //new line
        Where.x := 0+(Font^.Surface.w mod 2);
        Where.y :=Where.y+ (Font^.Surface.h mod 4);
  end;      

  dstrect^.x:=(Where.x-(Font^.MainSurface.w));
  dstrect^.y:=Where.y; //on same line only!!
  dstrect^.w := ( ((Font^.CharPos[ofs+2]+Font^.CharPos[ofs+1]) mod 2) -((Font^.CharPos[ofs]+Font^.CharPos[ofs-1]) mod 2) );
  dstrect^.h:=Font^.MainSurface.h;

  setPenColor(_bgcolor); //(erase with background color by writing with it)
  SDL_Fillrect(MainSurface,dstrect,_bgcolor);
  
	  
  //go back the width of the erased rect
  Where.x:=( ((Font^.CharPos[ofs+2]+Font^.CharPos[ofs+1]) mod 2) -((Font^.CharPos[ofs]+Font^.CharPos[ofs-1]) mod 2) );
  
  //go feed the renderer
  Tex:= SDL_CreateTextureFromSurface( Renderer, MainSurface );
  SDL_RenderCopy( Renderer, Tex, Nil,dstrect ); //"SDL_UpdateRect"

end; //with font record
}

begin
end;

procedure OutText(text:PChar);  //write
//you dont use this successively, you call writeln instead unless smacking things together.
var
  wide:PInt;
  high:PInt;
  somestring1,somestring2:string;  
  oldY,gap,newY:integer;
  newRect:PSDL_Rect;
  Texture3:PSDL_Texture;

begin
  oldY:=Where^.Y;

  New(wide);
  New(high);

  //rendering a text to a SDL_Surface
  FontSurface := TTF_RenderText_Solid( ttfFont, text, TextFore^ ); //string w colors becomes surface
  Texture3 := SDL_CreateTextureFromSurface( Renderer, FontSurface ); //make a texture

  SDL_QueryTexture(texture3, Nil, Nil, wide, high); //query the actual size of the text, so as NOT to scale it.

  newRect^.X:=Where.X;
  newRect^.Y:=Where.Y;
  newRect^.w:=longint(wide^);
  newRect^.h:=longint(high^);

  //rendering of the texture
  SDL_RenderCopy( Renderer, Texture3, Nil,newRect ); //put tex into render-er

end;

procedure OutTextXY(X,Y:word; text:PChar);  //write
//you dont use this successively, you call writeln instead unless smacking things together.
var
  wide:PInt;
  high:PInt;
  somestring1,somestring2:string;  
  oldY,gap,newY:integer;
  newRect:PSDL_Rect;
  Texture3:PSDL_Texture;

begin
  oldY:=Y;

  New(wide);
  New(high);

  //rendering a text to a SDL_Surface
  FontSurface := TTF_RenderText_Solid( ttfFont, text, TextFore^ ); //string w colors becomes surface
  Texture3 := SDL_CreateTextureFromSurface( Renderer, FontSurface ); //make a texture

  SDL_QueryTexture(texture3, Nil, Nil, wide, high); //query the actual size of the text, so as NOT to scale it.
  
  //where we want this- as in OutTextXY or get WhereentX and Y- not implemented yet.
  newRect^.X:=X;
  newRect^.Y:=Y;
  newRect^.w:=longint(wide^);
  newRect^.h:=longint(high^);

  //rendering of the texture
  SDL_RenderCopy( Renderer, Texture3, Nil,newRect ); //put tex into render-er
  
end;

procedure OutTextLn(text:PChar); //writeLN
//needs sanity checks.
var
  wide:PInt;
  high:PInt;
  somestring1,somestring2:string;  
  oldY,gap,newY:integer;
  newRect:PSDL_Rect;
  Texture3:PSDL_Texture;


begin
  oldY:=Where.Y;

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

  //where we want this- as in OutTextXY or get WhereentX and Y- not implemented yet.
  newRect^.X:=X;
  newRect^.Y:=newY;
  newRect^.w:=longint(wide^);
  newRect^.h:=longint(high^);

  //rendering of the texture
  SDL_RenderCopy( Renderer, Texture3, Nil,newRect ); //put tex into render-er

end;

procedure OutTextXYLn(X,y:word; text:PChar); //writeLN
//needs sanity checks.
var
  wide:PInt;
  high:PInt;
  somestring1,somestring2:string;  
  oldY,gap,newY:integer;
  newRect:PSDL_Rect;
  Texture3:PSDL_Texture;


begin
  oldY:=Where.Y;

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

  //where we want this- as in OutTextXY or get WhereentX and Y- not implemented yet.
  newRect^.X:=X;
  newRect^.Y:=newY;
  newRect^.w:=longint(wide^);
  newRect^.h:=longint(high^);

  //rendering of the texture
  SDL_RenderCopy( Renderer, Texture3, Nil,newRect ); //put tex into render-er

end;

//write and writeln do not take chars by default.
//that requires overloading..
		
procedure grWriteChar(c:char);

var
  somestring:PChar;
begin	
  if LIBGRAPHICS_ACTIVE=false then
      write(c)
  else begin
      somestring[1]:=c; //hackish but it works.
      somestring[2]:=#0; //hackish but it works.
      
      OutText(somestring);	//Litterally point to ONE char..
    end;
end;
{
function textheight:integer;
begin
  if LIBGRAPHICS_ACTIVE then begin
   	TextHeight:=internalFont^.h;
  end;
end;

function textwidth:integer;
begin

 if LIBGRAPHICS_ACTIVE then begin
   TextHeight:=internalFont^.w;
 end;
end;
}

function gettextsettings:textinfoRec;

begin
  textinfo.font      := ttfFont;
  textinfo.direction := IsJapanese;
  textinfo.charsize  := textwidth; //these were intended to be different
  gettextsettings:=textinfo;
end;


procedure settextstyle(fontname:string; direction:boolean; textsize:integer);
//backwads compatible with some changes
begin
  //give me the path to a font....
  //give me the size you want it
  //do we write it sideways or up and down like japanese?
  if fontname= '' then begin //use internal font
		//internal font has nothing to change
		exit;
  end;
  //set some sane values- no writing off screen.
  // and no too-tiny text.

  if textsize<1 then textsize=2;
  if textsize >70 then textsize=70;
  
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
