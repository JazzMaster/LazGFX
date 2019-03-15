{

Colors are bit banged to hell and back.

SDL_Color=record (internal definition)

	r:byte; //UInt8 in C
	g:byte;
	b:byte;
	a:byte; 

end;

^SDL_Color/PSDL_Color =array [0..3] of PUInt8; (BytePtr)

where- as long as the pointer points to SDL_Color record:
r:=PSDL_Color^
g:=PSDL_Color^[1]
b:=PSDL_Color^[2]
a:=PSDL_Color^[3]

(its a c-like hack that works)


24 bit and awkward modes:
Tuples (just RGB values) dont exist in Pascal(or C).Its a Python Thing.
*FIXED : 3/8/19  


Colors:

(try not to confuse BIT with BYTE here)

4bit(16 color) has to be mapped into RGB 8-bit colors(limited palette, not full)
ByteMask of 0f/f0 is traditionally used in the past because RGBA color modes didnt exist yet.

Alpha:(this is weird implementation but it works)

ff means use full color output
7f can be used as half-shading-giving us RGBI siulation
00 means "dont write the color"


8bit-(256 color) is paletted RGB mode (1:1:1)
	-this is the last paletted mode

JPEG format uses a 256 color palette(even a modified one).
Jpeg2000 uses 12bit

---
4bit(16)->8bit(256):

NO CHANGE, just switch palettes.


	just use the first 16 colors of the palette and add more colors to it
	its easier to not do 4bit conversion, but use 8bit color and convert that.

	- is it possible the original 16 colors can point elsewhere- yes, 
	but that would de-standardize "upscaling the colors"

Downsizing bits:

-you cant put whats not there- you can only "dither down" or "fake it" by using "odd patterns".
what this is -is tricking your eyes with "almost similar pixel data".

This will be put into functions, etc..soon.

32bit to 16bit RGB 565:
//drop the LSB

NewR: = R shr 3;
NewG: = G shr 2;
NewB: = B shr 3;
NewA:=$ff;

16bit(565) can also be 15bit color(5551):

mode 5551: 
 	ff or 7f for the last byte(not bit)
	we still have 32K colors, just two sets -light and dark-like 16 color mode but with more colors

RGB16->32:

NewR: =shl 3
NewG: =shl 2
NewB: =shl 3 
NewA:=A;

}

//SDL functions
function SDL_PIXELFLAG(X: Cardinal): Cardinal;
begin
  SDL_PIXELFLA := (X shr 28) and $0F;
end;

//most used.
function SDL_PIXELTYPE(X: Cardinal): Cardinal;
begin
  SDL_PIXELTYPE:= (X shr 24) and $0F;
end;

function SDL_PIXELORDER(X: Cardinal): Cardinal;
begin
  SDL_PIXELORDER := (X shr 20) and $0F;
end;

function SDL_BITSPERPIXEL(X: Cardinal): Cardinal;
begin
  SDL_BITSPERPIXEL := (X shr 8) and $FF;
end;

//end most used

function SDL_PIXELLAYOUT(X: Cardinal): Cardinal;
begin
  SDL_PIXELLAYOUT := (X shr 16) and $0F;
end;


function SDL_IsPixelFormat_FOURCC(format: Variant): Boolean;
begin
  {* The flag is set to 1 because 0x1? is not in the printable ASCII range *}
  SDL_IsPixelFormat_FOURCC:= format and SDL_PIXELFLAG(format) <> 1;
end;


//semi-generic color functions


function GetRGBfromIndex(index:byte):PSDL_Color; 
//if its indexed- we have the rgb definition already!!

var
   somecolor:PSDL_Color;
   
begin
  if bpp=8 then begin

    if MaxColors =16 then
	      somecolor:=Tpalette16.colors[index] //literally get the SDL_color from the index
    else if MaxColors=256 then
	      somecolor:=Tpalette256.colors[index]; 
    GetRGBFromIndex:=somecolor;
  end else begin
    if IsConsoleInvoked then
		writeln('Attempt to fetch RGB from non-Indexed color.Wrong routine called.');
   SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to fetch RGB from non-Indexed color.Wrong routine called.','OK',NIL); 
   
    exit;
  end;
end;

function GetDWordfromIndex(index:byte):DWord; 
//if its indexed- we have the rgb definition already!!

var
   somecolor:DWord;
   
begin
  if bpp=8 then begin
    if MaxColors =16 then
	      somecolor:=Tpalette16.DWords[index] //literally get the DWord from the index
    else if MaxColors=256 then
	      somecolor:=Tpalette256.DWords[index]; 
    
   GetDWordFromIndex:=somecolor;
  end else begin
      if IsConsoleInvoked then
	    	writeln('Attempt to fetch indexed DWord from non-indexed color');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Attempt to fetch indexed DWord from non-indexed color','OK',NIL); 
      exit;

  end;
end;



function GetRGBFromHex(input:DWord):PSDL_Color;
var
	i:integer;
    somedata:PSDL_Color; 
    r,g,b:PUInt8;

begin

  if bpp=8 then begin
   if (MaxColors=256) then begin
	   i:=0;
	   while (i<255) do begin
		    if (Tpalette256.dwords[i] = input) then begin //did we find a match?
 			   GetRGBFromHex:=Tpalette256.colors[i];
               exit;
           
           end else
				inc(i);  //no
       end;
	  //error:no match found
      exit;

   end else if (MaxColors=16) then begin
	    i:=0;
	    while (i<15) do begin

		    if (Tpalette16.dwords[i] = input) then begin//did we find a match?
               GetRGBFromHex:=Tpalette16.colors[i];
               exit;
            end else
				inc(i);  //no
       end;
	  //error:no match found
      exit;

   end;
  end else if (bpp >8) then begin
  
       if IsConsoleInvoked then begin
             writeln('Wrong routine called. Try: TrueColorGetRGBfromHex');
             LogLn('Wrong routine called. Try: TrueColorGetRGBfromHex');
       end;
       SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Wrong routine called. Try: TrueColorGetRGBfromHex','OK',NIL); 
 end;
end;


//its either we hack this to hell- or reimplement MainSurface- the easier option.
//MainSurface^.PixelFormat is unknown-but assignable.
//for a texture-WHICH? there is no MAIN-TEXTURE.

function TrueColorGetRGBfromHex(somedata:DWord; Texture:PSDL_Texture):PSDL_Color;
//I need to know from which Texture- (pre RenderCopy) that you want to get the data from.
//the reason why is that we DONT HAVE the RGB values- in paletted mode- WE DO.
//(we need to query a Texture to do this.)
//but WHICH ONE?

var
	pitch,format,i:integer;
    someColor:PSDL_Color;
    r,g,b:PUINT8;
    pixelFormat:PSDL_PixelFormat;

begin

//always wise to lock-and unlock but w textures(I was trying to avoid a bug) theres more to it.
lock;

// Now you want to format the color to a correct format that SDL can use.
// Basically we convert our RGB color to a hex-like BGR color.
  SDL_GetRGB(somedata,MainSurface^.Format, R, G, B);

       somecolor^.r:=byte(^r);
       somecolor^.g:=byte(^g);
       somecolor^.b:=byte(^b);

// Also don't forget to unlock your texture once you're done.
UnLock;

   	   TrueColorGetRGBfromHex:=somecolor;
end;

function GetRGBAFromHex(input:DWord):PSDL_Color;
var
	i:integer;
    somecolor:PSDL_Color; 
    r,g,b,a:PUInt8;

begin
   if (bpp <=8) then begin
         if IsConsoleInvoked then
			writeln('Cant Get RGBA data from indexed colors.');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get RGBA data from indexed colors.','OK',NIL);
      exit; 
   end;

	   SDL_GetRGBA(input,MainSurface^.format,r,g,b,a);
       somecolor^.r:=byte(^r);
       somecolor^.g:=byte(^g);
       somecolor^.b:=byte(^b);
       somecolor^.a:=byte(^a);
   	   GetRGBAFromHex:=somecolor;
end;


//DWord in - Index out
function GetIndexFromHex(input:DWord):byte;

var
	r,g,b:PUInt8;
    color:PSDL_Color;
    i:integer;

begin
  if (MaxColors >256) then begin
       if IsConsoleInvoked then
			writeln('Cant Get color name from an RGB mode colors.');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
      exit; 
  end;

    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
   end;

  SDL_GetRGB(input,MainSurface^.format,r,g,b); //Get the RGB color from the DWord given
     color^.r:=byte(^r);
     color^.g:=byte(^g);
     color^.b:=byte(^b);

	if MaxColors=256 then begin
        i:=0;
		repeat
			if ((color^.r=Tpalette256.colors[i]^.r) and (color^.g=Tpalette256.colors[i]^.g) and (color^.b=Tpalette256.colors[i]^.b)) then begin
				GetIndexFromHex:=i;
				exit;
			end;
		    inc(i);
		until i=255;
   //error:no match found
   //exit

	end else if MaxColors=16 then begin
        i:=0;
		
        repeat
  			if ((color^.r=Tpalette16.colors[i]^.r) and (color^.g=Tpalette16.colors[i]^.g) and (color^.b=Tpalette16.colors[i]^.b)) then begin
				GetIndexFromHex:=i;
				exit;
  			end;
  			inc(i);
		until i=15;
	end;
  //error:no match found
  //exit

end;

//DWord in - string out
function GetColorNameFromHex(input:dword):string;

var
	r,g,b:PUInt8;
    color:PSDL_Color;
     
    i:integer;

begin
  if (MaxColors >256) then begin
      if IsConsoleInvoked then
			writeln('Cant Get color name from an RGB mode colors.');
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
      exit; 
  end;
  i:=0;

  SDL_GetRGB(input,Mainsurface^.format,r,g,b); //Get the RGB color from the DWord given

  if MaxColors=256 then begin
	repeat
  		if ((color^.r=Tpalette256.colors[i]^.r) and (color^.g=Tpalette256.colors[i]^.g) and (color^.b=Tpalette256.colors[i]^.b)) then begin
			GetColorNameFromHex:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
			exit;
  		end;
  		inc(i);
	until i=255;
  //no match found
  //exit


  end else if MaxColors=16 then begin
	repeat
  		if ((color^.r=Tpalette256.colors[i]^.r) and (color^.g=Tpalette256.colors[i]^.g) and (color^.b=Tpalette256.colors[i]^.b)) then begin
			GetColorNameFromHex:=GEtEnumName(typeinfo(TPalette16Names),ord(i));
			exit;
  		end;
  		inc(i);
	until i=15;
  end;
  //no match found
  //exit

end;




//get the last color set

function GetFgRGB:PSDL_Color;
var
  color:PSDL_Color;
  r,g,b,a:PUInt8;


begin
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    color^.r:=byte(^r);
    color^.g:=byte(^g);
    color^.b:=byte(^b);
    color^.a:= $ff;
    GetFgRGB:=color; 
end;

function GetFgRGBA:PSDL_Color;

var
  color:PSDL_Color;
  r,g,b,a:PUInt8;


begin
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    color^.r:=byte(^r);
    color^.g:=byte(^g);
    color^.b:=byte(^b);
    color^.a:= byte(^a);
    GetFgRGBA:=color; 

end;

//give me the name(string) of the current fg or bg color (paletted modes only) from the screen

function GetFGName:string;

var
   i:byte;
   somecolor:PSDL_Color;
   someDWord:DWord;

begin
   if (MaxColors> 256) then begin

      If IsConsoleInvoked then
			Writeln('Cant Get color name from an RGB mode colors.');
	  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
	  exit;
   end;
   i:=0;
   i:=GetFGColorIndex;

   if MaxColors=256 then begin
	      GetFGName:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
		  exit;
   end else if MaxColors=16 then begin
	      GetFGName:=GEtEnumName(typeinfo(TPalette16Names),ord(i));
		  exit;
   end;	

end;


function GetBGName:string;

var
   i:byte;
   somecolor:PSDL_Color;
   someDWord:DWord;

begin
   if (MaxColors> 256) then begin

      If IsConsoleInvoked then
			Writeln('Cant Get color name from an RGB mode colors.');
	  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get color name from an RGB mode colors.','OK',NIL);
	  exit;
   end;
   i:=0;
   i:=GetBGColorIndex;

   if MaxColors=256 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette256Names),ord(i));
		  exit;
   end else if MaxColors=16 then begin
	      GetBGName:=GEtEnumName(typeinfo(TPalette16Names),ord(i));
		  exit;
   end;	

end;


//returns the current color index
//BG is the tricky part- we need to have set something previously.

function GetBGColorIndex:byte;

var
   i:integer;

begin
     
     if MaxColors=16 then begin
     i:=0;
        repeat
	        if TPalette16.dwords[i]= _bgcolor then begin
		        GetBGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;
    end;
     
     if MaxColors=256 then begin
       i:=0; 
       repeat
	        if TPalette256.dwords[i]= _bgcolor then begin
		        GetBGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 end else begin
		If IsConsoleInvoked then
			Writeln('Cant Get index from an RGB mode (or non-palette) colors.');
	    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get index from an RGB mode (or non-palette) colors.','OK',NIL);
		exit;
	 end;
end;


function GetFGColorIndex:byte;

var
   i:integer;
   someColor:PSDL_Color;
   r,g,b,a:PUInt8;

begin
    SDL_GetRenderDrawColor(renderer,r,g,b,a); //returns SDL color but we want a DWord of it
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);
    somecolor^.a:= $ff;
     
     if MaxColors=16 then begin
       i:=0;  
       repeat
	        if ((TPalette16.colors[i]^.r=somecolor^.r) and (TPalette16.colors[i]^.g=somecolor^.g) and (TPalette16.colors[i]^.b=somecolor^.b))  then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=15;
     end;
     
     if MaxColors=256 then begin
       i:=0; 
       repeat
	        if ((TPalette256.colors[i]^.r=somecolor^.r) and (TPalette256.colors[i]^.g=somecolor^.g) and (TPalette256.colors[i]^.b=somecolor^.b))  then begin
		        GetFGColorIndex:=i;
			    exit;
            end;
            inc(i);
       until i=255;

	 end else begin
		If IsConsoleInvoked then
			Writeln('Cant Get index from an RGB mode colors.');

		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Cant Get index from an RGB mode colors.','OK',NIL);
		exit;
	 end;
end;


{
How to implement "turtle graphics":

on start( the end of initgraph): 

show a turtle in center of the screen as a "mouse cursor"
and give user option of "mouse"(pen) or keyboard for input(or assume it)


PenUp -(GotoXY and wait for PenDown to be called)
PenDown -(Line x,y from relx,rely and wait for penUp to be called)


are the only routines we need.

to exit:

InTurtleGraphics:=false;
SDL_RenderClear;

closeGraph when done.

However- this was before the era of the mouse and we can do better in SDL.

Create a "clickable canvas".

PenDown is DownMouseButton[x]
PenUp is UpMouseButton[x]

- (you are drawing with the mouse, not the keyboard.)
- this demo has been done.

(easily catchable in the event handler)

}


//"overloading" make things so much easier for us....

//sets pen color given an indexed input
procedure setFGColor(color:byte);
var
	colorToSet:PSDL_Color;
    r,g,b:PUInt8;
begin

   if MaxColors=256 then begin
        colorToSet:=Tpalette256.colors[color];
        SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
   end else if MaxColors=16 then begin
		colorToSet:=Tpalette16.colors[color];
        SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
   end;
end;


//sets pen color to given dword.
procedure setFGColor(someDword:dword); overload;
var
    r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin

//again- as with below-
//check bpp <=8 to see if we have the data already.


   SDL_GetRGB(someDword,MainSurface^.format,r,g,b); //now gimmie the RGB pair of that color
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);

   SDL_SetRenderDrawColor( Renderer, ord(somecolor^.r), ord(somecolor^.g), ord(somecolor^.b), 255 ); 
   
end;

//"words" are not Pointers to "Unsigned 8-bit ints".. some type conversion is needed here
procedure setFGColor(r,g,b:word); overload;

begin
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), 255 ); 
end;

procedure setFGColor(r,g,b,a:word); overload;

begin
   SDL_SetRenderDrawColor( Renderer, ord(r), ord(g), ord(b), ord(a)); 
end;



//sets background color based on index
procedure setBGColor(index:byte);
var
	colorToSet:PSDL_Color;
//if we dont store the value- we cant fetch it later on when we need it.
begin

    if MaxColors=256 then begin
        colorToSet:=Tpalette256.colors[index];
        _bgcolor:=Tpalette256.dwords[index]; //set here- fetch later
	    SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
	    SDL_RenderClear(Renderer);
   end else if MaxColors=16 then begin 
		colorToSet:=Tpalette16.colors[index];
        _bgcolor:=Tpalette256.dwords[index]; //set here- fetch later
   	    SDL_SetRenderDrawColor( Renderer, ord(colorToSet^.r), ord(colorToSet^.g), ord(colorToSet^.b), 255 ); 
   	    SDL_RenderClear(Renderer);
   end;
end;

procedure setBGColor(someDword:DWord); overload;
var
    r,g,b:PUInt8;
	somecolor:PSDL_Color;

begin

    SDL_GetRGB(someDword,MainSurface^.format,r,g,b); //now gimmie the RGB pair of that color
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);

   _bgcolor:=someDword; //store the value
   SDL_SetRenderDrawColor( Renderer, ord(somecolor^.r), ord(somecolor^.g), ord(somecolor^.b), 255 ); 
   SDL_RenderClear(renderer);
end;

procedure setBGColor(r,g,b:word); overload;

//bgcolor here and rgba *MAY* not match our palette..be advised.

var
 color:PSDL_Color;

begin
   _bgcolor:=SDL_MapRGB(MainSurface^.format,color^.r,color^.g,color^.b);
   SDL_SetRenderDrawColor( Renderer, ord(color^.r), ord(color^.g), ord(color^.b), 255 ); 
   SDL_RenderClear(renderer);
end;

procedure setBGColor(r,g,b,a:word); overload;

var
  color:PSDL_Color;

begin
   _bgcolor:=SDL_MapRGBA(MainSurface^.format,color^.r,color^.g,color^.b,color^.a);
   SDL_SetRenderDrawColor( Renderer, ord(color^.r), ord(color^.g), ord(color^.b), ord(color^.a)); 
   SDL_RenderClear(renderer);
end;


// ColorNameToNum(ColorName : string) : integer;
//isnt needed anymore because enums carry a number for the defined "NAME".


//remember: _fgcolor and _bgcolor are DWord(s).

function GetFgDWordRGBA:DWord;

var
  somecolor:PSDL_Color;
  r,g,b,a:PUint8;

begin
    if (bpp < 8) then begin
        //error: not indexed color
        exit; //rgba not supported
    end;
	SDL_GetRenderDrawColor(renderer,r,g,b,a);
    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);
    somecolor^.a:=byte(^a);

    GetFgDWordRGBA:=SDL_MapRGBA(MainSurface^.format,somecolor^.r,somecolor^.g,somecolor^.b,somecolor^.a); //gimmie the DWord instead
end;

//doesnt make sence w using _bgcolor as a DWord
//only makes sense if you are using RGB or RGBA "tuples" instead of a Dword but wanted a DWord.
//has a use but its limited.

function GetBgDWordRGB(r,g,b:byte):DWord;

begin
//really rare case
    if (MaxColors<=255) then exit; //use the other function for this
       if IsConsoleInvoked then begin
          LogLn('Trying to fetch background color -when we have it- in Paletted mode.');
          writeln('We have the background color in paletted modes!');
          exit;
       end;
       SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'We already have the Background Color in Paletted mode.','OK',NIL);

    GetBgDWordRGB:=SDL_MapRGB(MainSurface^.format,ord(r),ord(g),ord(b));    
end;

function GetBgDWordRGBA(r,g,b,a:byte):DWord;
begin
    GetBgDWordRGBA:=SDL_MapRGBA(MainSurface^.format,ord(r),ord(g),ord(b),ord(a)); //gimmie the DWord instead
end;

procedure invertColors;

//so you see how to do manual shifting etc.. 
var
   r, g, b, a:PUInt8;
   somecolor:PSDL_Color;
begin

	SDL_GetRenderDrawColor(renderer, r, g, b, a);

    somecolor^.r:=byte(^r);
    somecolor^.g:=byte(^g);
    somecolor^.b:=byte(^b);
    somecolor^.a:=byte(^a);

	SDL_SetRenderDrawColor(renderer, 255 - somecolor^.r, 255 - somecolor^.g, 255 - somecolor^.b, somecolor^.a); 

end;

