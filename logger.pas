unit logger;

interface

uses
    sysutils;


const
  critical='CRITICAL ERROR: ';
  normal='HMM: ';
  warning='WARNING: ';

var
   output: Text; //untyped text
   logging,donelogging:boolean;
   MyTime: TDateTime;
   IsConsoleInvoked:boolean; external;

function Long2String(l: longint): string;
Procedure LogLn(s: string);
procedure StopLogging; //finalization


implementation
{
followng code is from FPC graphics unit(mostly sane code)

AUTHORS:                                              
   Gernot Tenchio      - original version              
   Florian Klaempfl    - major updates                 
   Pierre Mueller      - major bugfixes                
   Carl Eric Codere    - complete rewrite              
   Thomas Schatzl      - optimizations,routines and    
                           suggestions.                
   Jonas Maebe         - bugfixes and optimizations    

}


//more advanced debugging requires everything be converted to a string

//byte, word 2string, real2string,int2string

function Long2String(l: longint): string;
var
  strf:string;
begin
  str(l, strf);
  Long2String:=strf;
end;

//end FPC code - the rest has been modified "for an EXPLICIT PURPOSE"

//usually you want to write a line.

//use me unless you need other variables added to the output.
//remember- files WRAP at odd points, depending on the width of the viewing application and output monitor.

procedure LogGLFloat(data:single);
var
	stringdata:string;

begin
	if IsConsoleInvoked then
		write(data:4:2)
	else
		stringdata:=FloatToStr(data);
  	    Write(output,stringdata);
end;


procedure LogGLFloatLn(data:single);
var
	stringdata:string;

begin
	if IsConsoleInvoked then
		writeln(data:4:2)
	else
		stringdata:=FloatToStr(data);
  	    Writeln(output,stringdata);
end;


Procedure LogLn(s: string);

Begin
  Write((DateTimeToStr(MyTime)),' : ');
  Writeln(s); //to the debugging output console first, then file.
  Writeln(output,s);
End;

procedure StopLogging; //finalization
//call just before SDL_Quit
begin
    donelogging:=true;
    logging:=false;
    Close(output);
end;


begin //init - main()

    MyTime:= Now;
    Assign(output,'lazgfx-debug.log'); 
    Append(output); //do not re-write or re-set.
    Logging:=true;
    donelogging:=false;
end.
 

