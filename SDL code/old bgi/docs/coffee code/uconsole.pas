Unit uconsole;

interface

type
     string255=string[255];
//this is the User Mode portion of the console unit. I abstracted it to cut down on core kernel functions.
// this way we can concentrate on those routines doing assembler moves, and interrupt calls
// instead of worrying what function is implemented in the kernel.

//also reduces number of syscalls needed, until we get to the VESA unit.
//(where most calls require some form of int 10 functions)
//this can be abstracted further so that only these functions call the syscall or realMode interrupt vectors.
//FORWARDS thinking, remember?
// --Jazz

var
     HexTbl : array[0..15] of char='0123456789ABCDEF';
   cursornormalHI, cursornormalLO:word; 
      lastmode: word;            // text mode of CRT 
    // Blank (space) character for current color
  Blank: Word;  
   TextAttr: Word = $0F;
     CursorPosX: Word = 0;
  CursorPosY: Word = 0;
     ScrollDisabled:boolean;
    WindMinX : Word;
  WindMaxX : Word;
  WindMinY : Word;
  WindMaxY : Word;
 WindMin: Word  = $0;         //  Window upper left coordinates 
  WindMax: Word  = $0FA0;        //(4000) Window lower right coordinates
   x,y:word;
   VidMem: PChar=PChar($B8000);
    keypressed,EchoToConsole:boolean;

procedure update_cursor; 
procedure GotoXY ( x, y : word ); 
procedure Scroll; 
procedure blinkCursor; 
procedure ClearScreen; 

function dncase(p : char) : char; assembler; 
procedure SetMode(mode:word); assembler; 
procedure writeAt(x,y:integer; message:string);
procedure Center(Y:integer; message:string);
procedure whisper(var s:string);
procedure writelnAt(x,y:integer; message:string);
procedure scream(var s:string);
procedure noecho;
procedure Echo;
Procedure clreol; 
procedure TextMode (Mode: byte);
procedure writeDwordln(i:dword); 
procedure writedword(i: DWORD); 
procedure InstallConsole;
procedure Tabulate; 
function GetTextColor: Integer;
function GetTextBackground: Integer;
procedure textcolor(color:word);
Procedure TextBackground(Color: word);
procedure Up;
procedure Down;
procedure Left;
procedure Right;
//sound like a cheat code yet?? HE HE...

procedure LowVideo;
procedure HighVideo;
procedure NormVideo;

procedure PrintHex(Value: DWORD);
Function Hex_Char(Number: Word): Char;
Procedure Pause;
procedure CursorOn; //also turns it on, as well as restores.
procedure CursorNormal; //also turns it on, as well as restores.
procedure CursorBig; //also turns it on, as well as restores.
procedure CursorOff; //also turns it on, as well as restores.
Function IsFullWin:boolean;
procedure insline;  //used with cut+paste.try the routine above.
procedure delline;  
function readline:string255;
procedure ASCIITable;
function binstr(val : longint;cnt : byte) : pchar;
function hexstr(val : longint;cnt : byte) : string;
function octstr(val : longint;cnt : byte) : pchar;
procedure WriteIntLn(i: Integer);
procedure WriteLongLn(l: LongWord);
procedure WriteString(const S: String);
procedure WriteStrLn(const S: String);
procedure WriteLong(l: LongWord);
procedure WritePCharLn(P: PChar);
procedure WritePChar(P: PChar); 
procedure WriteInt(i: Integer);
procedure WriteChar(const c: Char); 
procedure Writeline;
function GetX: Word;
function GetY: Word;

implementation
uses
  x86,keybrd,timer;


procedure blinkCursor;
//updates cursor position (the blinky one, not the variables assigned to wit) 
var
  Temp: LongWord;
  tty_index : byte;

begin
  // X,Y mapped to VidMem ( 1-dim array.remains that way through mode 13h. )
  Temp:=(CursorPosY*80)+CursorPosX;

    writeportb($3D4, 14);
    writeportb($3D5, temp shr 8);
    writeportb($3D4, 15);
    writeportb($3D5, temp);

end;

procedure ClearScreen; [public, alias: 'ClearScreen'];
var
  i: Byte;
begin
  Blank := $0 or (textAttr shl 8);
  for i := 0 to 25 do
    FillWord((VidMem + i * 2 * 80)^, 80, Blank);
  CursorPosX := 0;
  CursorPosY := 0;
  BlinkCursor;
    update_cursor;
end;

procedure Scroll;

begin
  if scrolldisabled then exit;
      if (CursorPosY >= 24) then begin  //in case called before end of screen
    blank:= $20 or (TextAttr shl 8);        
    Move((VidMem+(2*80))^,VidMem^,24*(2*80));
    // Empty last line
    FillWord((VidMem+(24*2*80))^,80,Blank);
    CursorPosX:=1;
    CursorPosY:=23;
    update_cursor;
    blinkcursor;    
  end;
end;

procedure GotoXY ( x, y : word );
// procedure to move the cursor to the specified coordinates 
var
 
 lines,cols:integer;
 pos:integer;


begin

if not (X > 1) and (Y > 1)  and (X<80) and (Y<25) then exit;
   Dec (X);
   Dec (Y);
   if (X <= 80) and (Y <= 25) then begin
//We reset the positional pointer, then add the given values back to get the target address.
	CursorPosX:=0;
        inc(CursorPosX,X); //YES, its that easy.
	CursorPosY:=0;
        inc(CursorPosY,Y);   
        blinkcursor;
        exit;
  end;
  //otherwise we are outside of console bounds.
  CursorPosX:=0;
  CursorPosY:=0;
end;

procedure update_cursor;
//updates current cursor position AND color codes. ALWAYS USE on VRAM text output.
var
   position:smallint;
   x,y:word;
begin
    X:=GetX;
    Y:=GetY;
    
    position:=(Y*80) + X;
   // cursor LOW port to vga INDEX register
    writeportb($3D4, $0F);
    writeportb($3D5, position); //X
    // cursor HIGH port to vga INDEX register
    writeportb($3D4, $0E);
    writeportb($3D5, (position shr 8)); //Y 
  
end;

{$asmmode att}
function dncase(p : char) : char;assembler;
var
  saveeax,saveesi,saveedi : longint;
asm
        movl    %esi,saveesi
        movl    %edi,saveedi
        movl    p,%eax
        movl    %eax,saveeax
        movl    p,%esi
        orl     %esi,%esi
        jz      .LStrLowerNil
        movl    %esi,%edi
.LSTRLOWER1:
        lodsb
        cmpb    $65,%al
        jb      .LSTRLOWER3
        cmpb    $90,%al
        ja      .LSTRLOWER3
        addb    $0x20,%al
.LSTRLOWER3:
        stosb
        orb     %al,%al
        jnz     .LSTRLOWER1
.LStrLowerNil:
        movl    saveeax,%eax
        movl    saveedi,%edi
        movl    saveesi,%esi
end;
{$asmmode intel}

procedure writeAt(x,y:integer; message:string);
//assume it fill fit,eh?
begin
  gotoxy(x,y);
  writestrln(message);
  update_cursor;
 // blinkcursor;
end;

procedure Center(Y:integer; message:string);
//usually used for errors and warnings.

begin 
  //something about length of the message to write...
end;


procedure whisper(var s:string);

var 
  i:integer;

begin
   s[1]:=Upcase(s[1]); //Keep the first character proper.
   for i:=2 to length(s) do
      s[i]:=DnCase(s[i]);
end;


procedure writelnAt(x,y:integer; message:string);

begin
  gotoxy(x,y);
  writestrln(message);
  clreol;
  writeline;
end;

procedure scream(var s:string);

var 
  i:integer;

begin
   for i:=1 to length(s) do
      s[i]:=Upcase(s[i]);
end;


procedure noecho;
//disable echo to screen.
//Almighty flag tripper again.

begin
 EchoToConsole:=false; 
end;

procedure Echo;
//just remember to reset it. Its CRUEL otherwise.
begin
  EchoToConsole:=True;
end;

//this works,believe it or not.
Procedure clreol; 

var
  empcount:integer;
  empty:string;

begin
 empty:='';
 x:=CurSorPosx;
 y:=CurSorPosy; 
 empcount:=0;
 repeat
     empty[empcount]:=' ';
     inc(empcount);
 until empcount=(79-CurSorPosx);  //gives us a quick and dirty empty line very easily.
 //adjusts for differing lines and random x,y location.
 dec(CurSorPosy);
 writestring(empty);
 update_cursor;
// blinkcursor;
END;

procedure TextMode (Mode: byte);
 //Use this procedure to set-up a specific text-mode.
begin
 TextAttr := $07;
 LastMode := Mode;
 if Mode <7 then
 	SetMode(Mode)
 else begin
 	writestrln('Invalid Text Mode.Must be graphics.Call InitGraph.');
	exit;
 end;
    	
 WindMin := 0;
 WindMaxX := Pred (80);
 WindMaxY := Pred (25);
 if WindMaxX >= 255 then
  WindMax := 255
 else
  WindMax := WindMaxX;
 if WindMaxY >= 255 then
  WindMax := WindMax or $FF00
 else
  WindMax := WindMax or (WindMaxY shl 8);
  ClearScreen;
end;


procedure writeDwordln(i:dword); [public, alias: 'kwritedwordln'];

begin
writedword(i);
//should wrap to next line
inc(CurSorPosy);
CurSorPosx:=0;
blinkcursor;
end;


procedure writedword(i: DWORD); [public, alias: 'kwritedword'];
var
        buffer: array [0..11] of Char;
        str: PChar;
        digit: DWORD;
begin
        for digit := 0 to 10 do
                buffer[digit] := '0';
 
        str := @buffer[11];
        str^ := #0;
 
        digit := i;
        repeat
                Dec(str);
                str^ := Char((digit mod 10) + Byte('0'));
                digit := digit div 10;
        until (digit = 0);
 
        writepchar(str);
end;

procedure InstallConsole;
const
  OS_LOGO = 'Coffee OS  Early Alpha version 0.64 ';

begin
  windmin := 0;
  windmax := $4000; //80x25 window on page 0.
  lastmode := 3;
  ClearScreen;
  Gotoxy(0,0);
  TextColor(2);
  writestrln(OS_LOGO);
  TextColor(8);
  Writestrln('Booting. ');
end;

procedure Tabulate; [public, alias: 'Tabulate'];
  Var x:Integer;
  begin
     writestring('        '); //eight spaces
//need to set up tab stops, though...
     update_cursor;
  end;


function GetTextColor: Integer;
begin
  GetTextColor := TextAttr and $F0;
end;

function GetTextBackground: Integer;
begin
  GetTextBackground := (TextAttr and $F0) shr 4;
end;
procedure textcolor(color:word);

Begin
  TextAttr := (TextAttr and $F0) or (Color and $0F);
End;

Procedure TextBackground(Color: word);
Begin
 TextAttr := (TextAttr and $0F) or ((Color shl 4) and $F0);
End;

{
used for screen navigation.

This was used way back in the day.
}
procedure Up;
      BEGIN
         if scrolldisabled then 
            dec(CursorPosX,1);
      END;

    procedure Down;
      BEGIN
	if scrolldisabled then
           Inc(CursorPosY,1);
      END;

   procedure Right;
      BEGIN
	if scrolldisabled then
            Inc(CursorPosX,1);
      END;

   procedure Left;
      BEGIN
	if scrolldisabled then
            dec(CursorPosX,1);
      END;

procedure LowVideo;
begin
  TextAttr := TextAttr and not 8
end;

procedure HighVideo;
begin
  TextAttr := TextAttr or 8
end;

Procedure NormVideo;
begin
   textcolor(7);
   textbackground(0);
end;

procedure PrintHex(Value: DWORD);
var
	C: Char;
  Hexa: Byte;
  I, Shift: Byte;
begin
  writechar('0');
  writechar('x');
  for I := 7 downto 0 do
  begin
  	Shift := I*4;
    Hexa := (Value shr Shift) and $0F;
    C := Hex_Char(Hexa);
    writechar(C);
  end;
end;

Function Hex_Char(Number: Word): Char;
Begin
If Number<10 then
Hex_Char:=Char(Number+48)
else
Hex_Char:=Char(Number+55);
end; { Function Hex_Char }

Procedure Pause;
Var 
   Ch : Char;
Begin
 writestrln('Press any key to continue...');
//why does this break my interrupts?
 while not keypressed do begin
    if keypressed then writestrln('key');
 end;

 ch:=char(readkey); //should be UsScanCode[readkey]
End;

procedure CursorOn; //also turns it on, as well as restores.
begin
	CursorNormal;
end;


//ALL VRAM functions are DERIVATIVES of writeport statements(PEEK/POKE), we CANNOT USE int 10
// WHATSOEVER.. it causes TRIPLE FAULT CONDITIONS...at least NOT YET..

// sets cursor size in bytes 0..7

procedure CursorNormal; 
//You have to hard specify these, even if you pull the value.
begin
  writeportb($3D4, $0A);
  writeportb($3D5,(( cursornormalLO shl 8)+12));
  writeportb($3D4, $0B);
  writeportb($3D5,((cursornormalHI shl 8 )+13));
  blinkcursor;
end;


procedure CursorBig;
begin
	   writeportb($3D4, $0A);
	   writeportb($3D5, $01);
           writeportb($3D4, $0B);
	   writeportb($3D5, $12);

end;


procedure CursorOff; 
begin

	   writeportb($3D4, $0A);
	   writeportb($3D5, $00);
           writeportb($3D4, $0B);
	   writeportb($3D5, $00);

end;


Function IsFullWin:boolean;

//  Check if Full Screen 80x25 Window(1,1,80,25) is used

begin
  IsFullWin:=(WindMinX=1) and (WindMinY=1) and
           (WindMaxX=80) and (WindMaxY=24);
end;

procedure insline;  //used with cut+paste.try the routine above.

//Inserts a line at the cursor position.

var row,left,right,bot:longint;
    fil:word;

begin
    x:=getx;
    y:=gety;
    gotoxy(0,y);
    if ScrollDisabled then exit;
    scroll;   
    clreol;
    gotoxy(0,y+1);
   // scroll_backwards;
    update_cursor;
   // blinkcursor;
    
end;

procedure delline;  
//Deletes the line at the cursor.

var row,left,right,bot:longint;
    fil:word;
    
begin
    x:=getx;
    y:=gety;
    gotoxy(0,y);
    clreol;
    gotoxy(0,y-1);
    update_cursor;
  //  blinkcursor;
end;

function readline:string255;
// use 'prompt' procedure if you want to ask and get an answer. This is supposed to just read one.

var
  ch:char;
  i:integer;
  stringline:string255;
begin
  i:=1;
  repeat
     ch:=char(readkey);   
     if EchoToConsole=true  then     //do we WANT the read line hidden?
     writechar(ch);
     stringline[i]:=ch;
     inc(i);
     update_cursor;
  until (ch=#13) or (ch=#10);  ///change it if you need to.
  readline:=stringline;
end;

procedure ASCIITable;
var
   i:integer;

begin
//The Table is in the BIOS somewhere...
   i:=0;
   repeat
     writechar(char(i));
     update_cursor;
     inc(i);
   until i=254;
end;

function binstr(val : longint;cnt : byte) : pchar;
var
  i : longint;
begin
  binstr[0]:=char(cnt);
  for i:=cnt downto 1 do
   begin
     binstr[i]:=char(48+val and 1);
     val:=val shr 1;
   end;
end;

function hexstr(val : longint;cnt : byte) : string;
var
  i : longint;
begin
  hexstr[0]:=char(cnt);
  for i:=cnt downto 1 do begin
     hexstr[i]:=hextbl[val and $f];
     val:=val shr 4;
   end;
end;

function octstr(val : longint;cnt : byte) : pchar;
var
  i : longint;
begin
  octstr[0]:=char(cnt);
  for i:=cnt downto 1 do
   begin
     octstr[i]:=hextbl[val and 7];
     val:=val shr 3;
   end;
end;

procedure WriteIntLn(i: Integer);
begin
  WriteInt(i);
  cursorposx:=0;
  inc(CursorPosy);
  update_cursor;
end;

procedure WriteLongLn(l: LongWord);
begin
  WriteLong(l);
  cursorposx:=0;
  inc(CursorPosy);
  update_cursor;
end;

procedure WriteString(const S: String);
var
  i: Byte;
begin
  for i := 1 to Length(S) do
    WriteChar(S[i]);
  update_cursor;

end;

procedure WriteStrLn(const S: String);
begin
  WriteString(S);
  cursorposx:=0;
  inc(CursorPosy);
  update_cursor;
end;

procedure WriteLong(l: LongWord);
var
  s: String;
begin
  Str(l, s);
  WriteString(s);
 update_cursor;
end;

procedure WritePCharLn(P: PChar);
begin
  WritePChar(P);
  cursorposx:=0;
  inc(CursorPosy);
  update_cursor;
end;

procedure WritePChar(P: PChar); [public, alias: 'WritePChar'];
begin
  while P^ <> #0 do begin
    WriteChar(P^);
    Inc(P);
  end;
   update_cursor;
end;

procedure WriteInt(i: Integer);
var
  s: String;
begin
  Str(i, s);
  WriteString(s);
   update_cursor;
end;

procedure WriteChar(const c: Char); [public, alias: 'WriteChar'];
var
  Offset: Word;

  procedure Print(const c: Char);
  begin
    // First byte = character to print
    Offset := (CursorPosX shl 1) + (CursorPosY* 160);
    VidMem[Offset] := c;
    // Second byte = color attributes
    Inc(Offset);
    VidMem[Offset] := Char(textAttr);
  end;

begin
  // Blank character based on current color attributes
  Blank := $20 or (textAttr shl 8);
  case c of
    // Backspaces
    #08: if Length(CommandBuffer) > 0 then begin
        if CursorPosX > 5 then begin
            Dec(CursorPosX);
          if CursorPosX < 5 then exit;
        end;
        update_cursor;
    end;
    // Tabs, only to a position which is divisible by 8
    #09:begin
	CursorPosX:= (CursorPosX + 8) and not 7;
	update_cursor;
   end;
    { Newlines, DOS and BIOS way ( consider as if a carriage
      return is also there ) }
    #10: begin
      CursorPosX := 0;
      Inc(CursorPosY);
      update_cursor;
    end;
    // Carriage return
    #13:begin
        CursorPosX := 0;
        Inc(CursorPosY);
        update_cursor;
    end;
    // Printable characters, starting from space

    #32..#255: begin
      Print(c);
      Inc(CursorPosX);
      update_cursor;
    end;

  end;
  // Whoops! Line limit, move on to the next line
  if CursorPosX > 79 then begin
    CursorPosX := 0;
    Inc(CursorPosY);
    update_cursor;
  end;
  if not ScrollDisabled then Scroll;
  BlinkCursor;
  update_cursor;
end;

procedure Writeline;
var
 empty:string;
 i:integer;
begin
  empty:='';
  for i:=0 to 78 do begin
    empty:=empty+' ';
  end;
  writestring(empty);
  CurSorPosX:=0;
  inc(CurSorPosY);
end;

function GetX: Word;
begin
  GetX := CursorPosX;
end;

function GetY: Word;
begin
  GetY := CursorPosY;
end;


procedure SetMode(mode:word); assembler;
//set low-res TEXT modes, see graph units for HIGHer RES--up to 1280x1024...

asm
//realint($10);
end;

end.
