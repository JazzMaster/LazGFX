unit logger;
{$mode objfpc}

interface

uses
    sysutils;


const
  critical='CRITICAL ERROR: ';
  normal='HMM: ';
  warning='WARNING: ';

var
   output: Textfile; 
   logging,donelogging:boolean;
   MyTime: TDateTime;
   IsConsoleInvoked:boolean; external;

function Long2String(l: longint): string;
Procedure LogLn(s: string);
procedure StopLogging; //finalization


implementation
{
The aux routines here are copywright FPC/FPK Dev Team

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

procedure LogGLFloat(data:single);
var
	stringdata:string;

begin
		write(data:4:2);
		stringdata:=FloatToStr(data);
  	    Write(output,stringdata);
end;


procedure LogGLFloatLn(data:single);
var
	stringdata:string;

begin
		writeln(data:4:2);
		stringdata:=FloatToStr(data);
  	    Writeln(output,stringdata);
end;


Procedure LogLn(s: string);
var
    v:string;
Begin
  Write((DateTimeToStr(MyTime)),' : ');
  v:=((DateTimeToStr(MyTime))+' : '+s);
  Writeln(output,v);
  Writeln(v); //to the debugging output console first, then file.
 
End;

procedure StopLogging; //finalization

begin
    donelogging:=true;
    logging:=false;
    
end;


begin 

end.
 

