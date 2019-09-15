Unit grText;
//graphics text functions.
//This uses Lazarus Freetype instead of SDL2TTF routines- should yield the same result.

interface 
uses

//FTGL?? Try Laz Free Type first. May have to port some headers, here.
	EasyLazFreeType, LazFreeTypeFontCollection,strings;
				

type
  str80=string(80);
  str256=string(256);
  directions=(horizontal,verticle); //ord(horizontal)
  textinfo=record
        font      : string; //filename
        direction : directions;
        charsize  : integer; 
  end;

FontPtr=^font;
font=array [0..2] of FTGLfont;

var
    IsJapanese:boolean; //text that goes down-matrix style- not sideways
    PasFont: TFreeTypeFont;
    FontP:FontPtr;
    FontFile:PChar;

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
procedure SetFont(fontpath:string; font_size:integer; style:fontflags; outline:boolean);

//RotoZoom?(These are Texture tricks)

//backwards is flipped(mirrored) - like "english arabic"
//It would be upside -down otherwise
//procedure MirrorText;

//rotate 90 right=read like Japanese posters
//rotate 90 left=?? (read it up-ways)
//Procedure SetFontRotation(rotation: uInt32); 

//write font data to screen AND set color

procedure OutTextColor(color:DWord);
procedure OutTextColor(r,g,b:byte);
procedure OutTextColor(r,g,b,a:byte);


//add back text color routines

implementation

//harp on default(built-in) or user if specified - since we dont know where the font files are.
//ask for the info. if nil- reset to default font.

procedure installUserFont(fontpath:string; font_size:integer; style:fontflags; outline:boolean);

{
BGI:
  Fonts : array[0..4] of string[13] =
  ('DefaultFont', 'TriplexFont', 'SmallFont', 'SansSerifFont', 'GothicFont');


font_size: some number in px =12,18, etc
path: (varies by OS) to font we want....

FontStyle(Load an alt file-only applies to nonstd fonts): 
		NORMAL
		ITALIC 
		BOLD
		
style FX:
        UNDERLINE		
		STRIKETHROUGH


outline: make it an outline (instead of drawn "stroked", the font is drawn hollow)

fontpath: MUST BE SPECIFIED unless you want the default fonts (NORMAL)
}

begin
  
  end;
  if FontPath:='' then 
		//use the internal one, LUKE.

    FontPath:='./'

{
if FontChoice='' then FontChoice='Gothic.ttf'

 glColor3f(1,1,1);

file = "/usr/share/fonts/truetype/lato/Lato-Bold.ttf";
font[0] = ftglCreateBitmapFont(file); //extruded, bitmap,pixmap
    ftglSetFontFaceSize(font[0], fontsize, fontsize);
    ftglSetFontDepth(font[0], fontsize-2);
    ftglSetFontOutset(font[0], 0, 3); -??
    ftglSetFontCharMap(font[0], ft_encoding_unicode);


  //dont render yet...just set it up.
}

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
    
//    BlinkPID:=AddTimer; - this has to occur wo stopping while other ops are going on usually
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
//   go back that a 'char' based on fontsize.
//   blank the space with background color
//   go back and reset x,y
//   add the next char


{
var
//  Font:PSDL_FontInfo;  
  dstrect:PSDL_Rect;
  bufp:string;
  x1,y1,ofs:integer;
//  Tex:PSDL_Texture;
	
begin
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

//GLCreateTExturewData()

//  Tex:= SDL_CreateTextureFromSurface( Renderer, MainSurface );
//  SDL_RenderCopy( Renderer, Tex, Nil,dstrect ); //"SDL_UpdateRect"
}
end;

//These core routines should work now.

procedure OutTextXY(somestring:String; x,y:word); //write
//you dont this successively, you call writeln instead unless smacking things together.

begin
  
  //where we want this  
  glRasterPos2f(x,y);
  //rendering of the text
  ftglRenderFont(font[0], somestring, FTGL_RENDER_ALL);

end;

procedure OutTextLn(somestring:string); //writeLN
//needs sanity checks.
var
  wide:PInt;
  high:PInt;
  oldY,gap,newY:integer;
  Where:PSDL_Rect;

begin
  oldY:=Y;


{
FIXME: japanese style not done
push each char/pchar and check for rendering offscreen..if it would be, go to the next (Y+textsize) line and keep going.
iff off the screen, stop.

right now this pushes Y down- assuming theres room and assuming that the text doesnt go beyond the screen
80x25=> graphics mode(320x240) 
50-64 (1/2 width) horizontal chars (or 1/2 the num of them) and 24-30 verticle text lines

}


//for a single write call this is ok..for multiple we need to track the last X and Y locations used
//and adjust accordingly.

  gap:=(fontsize mod 8);
  newY:=(oldY+fontsize^+gap);
   
  OutTextXY(somestring,x,newy); //write

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
      OutTextXY(current,x,y);	//draws the last entered char. outtext does same.
    end;
end;


procedure outtext(textstring:string);

begin
  if IsGRAPHICS_ENABLED then begin

    outTextXY(textstring,x,y);

  end;
end;

procedure outtextXYLn(x,y:integer; textstring:PChar);

var
  xbak,ybak:integer;
begin
  if IsGRAPHICS_ENABLED then begin
    outTextLn(textstring);
  end;
end;


function textheight:integer;
begin
  if LIBGRAPHICS_ACTIVE then begin
   	TextHeight:=fontsize;
  end;
end;

function textwidth:integer;
begin

 if LIBGRAPHICS_ACTIVE then begin
   TextWidth:=fontsize;
 end;
end;

function gettextsettings:textinfo;

begin
  textinfo.font      := fontdata;
  textinfo.direction := direction;
  textinfo.charsize  := textwidth; //these were intended to be different
end;

{
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
  SDL_SetFont(fontname,ord(direction),textsize); 
end;

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
