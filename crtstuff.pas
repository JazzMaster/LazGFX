Unit crtstuff;
// "This shit is ancient..."
//this is an advanced "ncurses" interface -written for DOS , 
// but mostly applicable in console mode(no X11) 

//this is shit not found in CRT unit.
// I need to check my code...GAWD...this is older than dirt and waaay off...

interface


//we dont load if theres no CRT unit to use- check is in lazgfx.pas unit.


//(Hx)DPMI loader and 32bit cpu preferred.

//dos mode FPC - go is another language
{$IFDEF go32v2} 
//be sure that crt sources are recompiled(cant distribute sources), 
//this is a "dinosaur PC" 
// -OR- 
//we use the modded timer fixes (runtime 200 error in Delay routine)
uses

  dos,crt; //FPC doesnt suffer from the RT200 bug, only BP/TP7.

//check for BP/TP7
{$ENDIF}


{$IFDEF ver70}

uses

  {$IFDEF Debug}
    {$F+,D+,Q-,L+,R+,I-,S+,Y+,A+}
  {$ELSE}
    {$F+,Q-,R-,S-,I-,A+}
  {$ENDIF}


//quirky build mode fix
   {$IFDEF MSDOS}
     {$DEFINE NO_EXPORTS}
   {$ENDIF MSDOS}

//forcidng this is wrong, what if its the 16bit, not the 32 it one?
   {$IFDEF DPMI}
     {$DEFINE BP_DPMI}
   {$ENDIF}

   dos,crt,NewDelay; //patch crt unit - or patch your binary program once built
{$ENDIF}

{
We can use 'sets' with input

repeat
  YN := Readkey;
Until (YN IN ['N','n']);
}

const

//line 25 scrolls, line 24 is for status messages
//Indenting by one character gives us a nice, margin, tho..
//tricky, not impossible.

   MAXCRTCOL=80;
   MAXCRTROW=23;


type
   crtcommand =(Home,Clear,Eraseol,Up,Down,Left,Right,Beep); 
//you could use funky ansi methods here...like linux does
//I am using standard routines

   charset=set of char;
   Pchar=^Char;
   PString=AnsiString;
   str80=string[80];
   str256=string[255];
   

var
   col,row,x,y:integer;
   prompt:str80;
   valid:charset; 
   shiftlock,scrollEnabled:boolean;
  // SuperLongString:AnsiString;
   ch:char;
   CurrX,CurrY:integer;
   crtcommands:crtcommand;

procedure PressAnyKey;
procedure Crta (cc:crtcommand);
function Getkey:char;
procedure addchar(s:str80;  ch:char; maxlen:integer);
procedure chopchar(s:str80; index:integer);
procedure Eraseline(row:byte);
procedure center (prompt:str80; col,row:byte);
procedure askYN(prompt,inpstr:str80);
function getboolean(inputstr:string):boolean;
procedure waitforenter;
procedure disptitle (prompt:str80);

 
implementation

procedure PressAnyKey;
// the blasted thing....I never could find the "ANY" key....
begin
   writeln('Press a key...');
   ch:=readkey;
// we dont return..we want user to read something and the program to halt until further interaction...
// usually used on error messages on output.
end;

procedure Crta (cc:crtcommand);
{ do crt command }


begin
//up and down navigation here usually doesnt work w scrolling..
//mini game engine by itself...think megazeux..if you dont know what that is..go find out.

if scrollEnabled then exit;

   case cc of
	   HOME:
			gotoxy(CurrX,CurrY); //wrong
	   CLEAR:
			clrscr;
	   ERASEOL:
			clreol;
	   Up:
			gotoxy(CurrX,CurrY-1);
	   DOWN: 
			gotoxy(CurrX,CurrY+1);

{			begin  //lets be OS-"safe" here...otherwise its non portable code.
				$IFDEF windows
					write(chr(10)); //#10#13 on sin..
					write(chr(13));
				$ELSE
					write(chr(10)); //10 on unices..bsd...mac...
				$ENDIF
			end; }
	   LEFT:
			gotoxy(CurrX-1,CurrY);
	   RIGHT:
			gotoxy(CurrX+1,CurrY);
	   BEEP:
			write(chr(7));
   end
end;

function Getkey:char;
// Get key typed at keyboard, no echo 
// whats valid? you cant type extended keys on a keyboard by default...

//should work for most non EESE languages...I dont know how to work w kanji.
var
   ch:char;

begin
   shiftlock:=false;
   ch :=readkey;

   //is capslock pressed or is shift pressed??
   //xev seems to report these keys...
   if  ((ord(ch)=50) or (ord(ch)=62) or (ord(ch)=66)) then shiftlock:=true;       

   if shiftlock and(ch in['a'..'z','1'..'6']) then ch:=chr(ord(ch)-32);
         
   GetKey:=ch;
end;


procedure addchar(s:str80;  ch:char; maxlen:integer);
{ add character to end of string }

begin
   if length(s)<maxlen then begin //string bounds check
	  s:=s+ch;
   end;
end;

procedure chopchar(s:str80; index:integer);
{ delete char from end of string }

begin
   if length(s)>0 then
   index:=length(s);
   delete(s,index,1);
end;

procedure Eraseline(row:byte);
{ erase a line on the crt }
begin
	gotoxy(1,row);
	crta(ERASEOL);
end;

procedure center (prompt:str80; col,row:byte);
{ center a line on the crt }

begin
   Eraseline(row);
   if ((col=0) or (row=0)) then exit;
   gotoxy(col,row);
   write(prompt);
end;



procedure askYN(prompt,inpstr:str80);
{ ask user a yes-or-no question 
x,y assumed init already somehow}

begin
   center(prompt,15,y);
   readln(inpstr);
end;


function getboolean(inputstr:string):boolean;
{ get yes-or-no from user }

var
   tempstr:str80;
   ok,inputok:boolean;
   inpstr:char;

begin
   ok:=false; 
   writeln(inputstr);
   repeat
	  inpstr:=readkey;
      if inpstr='Y' then begin
		ok:=true; 
        inputok:=true;
        break;	
      end else if inpstr='N' then begin
        ok:=false; 
        inputok:=true;
        break;
     end else begin //input not ok
	     row:=23;
	     Eraseline(row);
		 crta(BEEP);
		 tempstr:='Please enter Yes or No (Y/N): ';
		 center(tempstr,15,maxcrtrow);
	  end
   until inputok;
   getboolean:=ok;
end;

procedure waitforenter;
{ put a message on the screen }

var
   tempstr:str80;
   ystr:integer;
   ch:char ;
begin
   ystr:=24;
   crta(BEEP);

   tempstr:='Press  <ENTER> to continue ';
//   textcolor:=textcolor+128; //blink at me!
   center(tempstr,15,MAXCRTROW);
//   textcolor:=textcolor-128;
   repeat
	  ch:=Readkey;
   until ord(ch)=13; //only get <enter> ..a ton of games wait for keypress instead..
   ystr:=23;
   Eraseline(ystr);
end;


procedure disptitle (prompt:str80);
{ display title in a box at the top of the screen }
//this is the safe way to do it, using hi ansi chars isnt supported on unices..

//what we should do is VGA font hack the charset for text mode w the default pascal one for cp437-ish...
var
   i,line1,line2:integer;

begin
   line1:=0;
   line2:=3;
   Eraseline(line1);
   Eraseline(line2);
   gotoxy(27,1);
   for i:=1 to length(prompt)+1 do
   write('*');
   center(prompt,27,2);
   crta(RIGHT);
   write('*');
   gotoxy(26,1);
   write('*');
   gotoxy(46,3);
   write('*');
   gotoxy(27,1);
   write('*');
   gotoxy(46,2);
   write('*');
   gotoxy(26,3);
   for i:=1 to length(prompt)+2 do
	  write('*');
end;


end.
