
Unit grText;
//graphics text functions

interface 
uses
	strings;

type
  str80=string(80);
  str256=string(256);


// The text pointer 

TP=record
  x,y:integer;
end;

// Screen position pointer

CP = record 
   x,y:integer;
end;
				
{$I bgisdl.inc}


procedure GetTextSettings(var TextInfo : TextSettingsType);
function  TextHeight(const TextString : string) : word;
function  TextWidth(const TextString : string) : word;
procedure SetTextJustify(horiz,vert : word);
procedure SetTextStyle(font,direction : word;charsize : word);

implementation


procedure backspace( Font:^SDL_FontInfo, ch:char);

  dstrect:^SDL_Rect ;
  bufp:string;
  x1,y1,ofs:integer;
	
begin
  x1:=0;
  y1:=0;	
  if (ch=' ') then begin
    TP.x-=Font.CharPos[2]-Font.CharPos[1];
    if (TP.x<0) then
       TP.x=0;
    dstrect.w = Font.CharPos[2]-Font.CharPos[1];              
  end else begin
    ofs=(ch-33)*2+1;	//Calculating width of char to erase*/
    dstrect.w = (Font.CharPos[ofs+2]+Font.CharPos[ofs+1])/2-(Font.CharPos[ofs]+Font.CharPos[ofs-1])/2;
    TP.x:=TP.x -(Font.CharPos[ofs+1]-Font.CharPos[ofs]);
    if (TP.x<0) TP.x = 0;
  end;    
  dstrect.h = Font.Surface.h-1;
  x1=TP.x;
  while( x1<TP.x+dstrect.w) do begin
    y1=TP.y;
    while( y1<= TP.y+dstrect.h) do begin
	   bufp := screen.pixels + y1*screen.pitch + x1;
	   bufp := _bgcolor;
       inc(y1);
    end;
  inc(x1);
  SDL_UpdateRect(screen, 0, TP.y, x1, y1);	
  // For some reason partial update doesn't work here..
  // i am force to do a complete update from the beginning of the line till the point of erasure
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

  //this isnt practical but it works..shitty documentation.
  New(Where);

  //convert SDL_Surface to SDL_Texture
  Texture3 := SDL_CreateTextureFromSurface( Renderer, FontSurface ); //make a texture

  SDL_QueryTexture(texture3, Nil, Nil, wide, high); //query the actual size of the text, so as NOT to scale it.
  


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
//put into handler code...
function grReadkey:char;
var
      quit:boolean;
      c:char;
      event:SDL_Event;
	  somestring:string;

begin
    quit:=false;
    while not quit
	if (SDL_PollEvent( event )) 
	  case( event.type ) of
	  SDL_KEYDOWN:
	    c=event.key.keysym.sym;
	    if (isprint(c) then begin  //I dont care if you hit enter.
	      if echo=true then begin
			somestring[1]:=c;
			MPutString(somestring);	
          end;		
          grReadkey:=c;    
	      exit;
        end;
	  SDL_ACTIVEEVENT:
	    if ((event.active.state = SDL_APPINPUTFOCUS) and event.active.gain) then
	      //resume
	    break;
	  SDL_QUIT:
	    quit = true;
	    exit;
	  else:
	    //SDL_PushEvent(event); or
		//SDL_WaitEVent(0);
	    exit;
	  end else begin
	    SDL_WaitEvent(0);
	  end;
    end;
end;                

function grReadString:string;
//this is where we fucked up...console has a bug in it when SDL is active...so use a "hacked SDL readline"....
// all were doing anyways is fetching multiple keypresses until <return> or <enter> is hit...
//(so do it in a non-blocking event-driven way.)

var
      quit:boolean;
      c:char;
      i:integer;
      somedata:string;
      event:SDL_Event;

begin
    quit:=false;
    while not quit
	if (SDL_PollEvent( event )) 
	  case( event.type ) of
	  SDL_KEYDOWN:
	    c=event.key.keysym.sym;
	    if (isprint(c)) then begin  
	      i:=0;
          repeat 
			c:=grReadkey;

            somedata[i]:=c;
            inc(i);
          until (c=SDLK_RETURN) or (i=len(somedata));
          
        end;
        grReadString:=somedata;
	    exit;
	  SDL_ACTIVEEVENT:
	    if ((event.active.state = SDL_APPINPUTFOCUS) and event.active.gain) then
	      //resume
	    break;
	  SDL_QUIT:
	    quit := true;
	    exit;
	  else:
	 //   SDL_PushEvent(event); or
	//	SDL_WaitEvent(0);
	    exit;
	  end else begin
	    SDL_WaitEvent(0);
	  end;
    end;
end;                

//integrate w interrupt routine. grReadkey
function kbhit:char;

var
  c:char;

begin
  if (LIBGRAPHICS_ACTIVE=0) then
    ch:=readkey;

  else begin	
       event:^SDL_Event;
      if(SDL_PollEvent(&event) and (event.type = SDL_KEYDOWN)) then begin
	    SDL_PushEvent(&event);
	    kbhit:=(event.key.keysym.sym);
  end;
  
  if ((event.type = SDL_ACTIVEEVENT) and (event.active.state = SDL_APPINPUTFOCUS) and event.active.gain) then
	  //resume
      
end;



function grReadLineWithLimits:string;

var
  i,num:integer;
  ch:char;
  quit:boolean;
  input:string;
  SCAN_BUF:string; //while not end of input str(80).....
  event:SDL_Event;
	    

begin
   num:=0;
	
  if (LIBGRAPHICS_ACTIVE=0) then    begin
      ch := readkey;
      exit;
  end;  
  else begin
    
      event:SDL_Event;
      md:SDLMod;
      i:=0;
      quit:=false;

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
	  SDL_QUIT:
	    quit = 1;
	    exit;
	  SDL_ACTIVEEVENT:
	    if ((event.active.state = SDL_APPINPUTFOCUS) and event.active.gain)
	      //resume
	    exit;
	  default:
	    exit;
	  end;
	else begin
	  
	    MPutString('_');  	//draw the text-cursor
	    SDL_WaitEvent(event);
	    SDL_PushEvent(event);
	    makespace(internalFont,'_'); //erase the text-cursor 
	  end;
    end;
end;

		
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

function textheight (textstring:string):integer;
begin
  if LIBGRAPHICS_ACTIVE then begin
   	TextHeight:=internalFont.h;
  end;
end;

function textwidth (text:string)integer;

var
   ofs,i,count:integer;
begin

  i:= 0;
  count := 0;

 if LIBGRAPHICS_ACTIVE then begin
 
   while (text[i]<>#10) do begin
      if (text[i]=' ') then begin
	    count += internalFont.CharPos[2]-internalFont.CharPos[1];
	    inc(i);
      end
      else if (text[i]=#13) then begin 
	    inc(i);
      end
      else if (text[i]=#8) then begin
	     count += + 8*(internalFont.CharPos[2]-internalFont.CharPos[1]);
	     inc(i);
      end else begin			// Actual printable characters.*/
	    ofs=(text[i]-33)*2+1;	
	    count += inernalfont.CharPos[ofs+1]-internalfont.CharPos[ofs]; // inc text pointer by char width*/
	    inc(i);
      end;
    end;
   textwidth:=(count+5); // Add 5 to actual length to prevent accidental overlap and allow clean fitting onto lines.*/
   end;
 end;
end;


procedure gettextsettings(var textinfo : textsettingstype);
begin
  textinfo.font      := font;
  textinfo.direction := direction;
  textinfo.charsize  := charsize; //these were intended to be different
  textinfo.horiz     := horizsize;
  textinfo.vert      := vertsize;
end;


{
procedure settextstyle(fontname:string direction:boolean; textsize:integer);
//backwads compatible with some changes
begin
  //give me the path to a font....
  //give me the size you want it
  //do we write it sideways or up and down like japanese?


  //direction may have to be implemented--but whats to say that you cant write matrix-style?

  SDL_SetFont(fontname,direction,textsize); 
end;
}



//Im noticing that a ton of the font routines use .CHR (old school fonts)
//although we *could* support them, this is very ancient tech. Id rather use TTF straight-up.

{
procedure SetTextJustify(horiz,vert : word);
//write one letter at a time if verticle, ignore and write normally if horizontal


begin
    if (horiz<0) or (horiz>2) or (vert<0) or (vert>2) then
    begin
         _graphresult:=grError;
         exit;
    end;
    Currenttextinfo.horiz:=horiz;
    Currenttextinfo.vert:=vert;

end;

}


end.
