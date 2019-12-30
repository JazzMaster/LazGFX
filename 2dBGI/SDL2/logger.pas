unit logger;
{$mode objfpc}

interface

uses
{$ifndef windows}
    crt,
{$endif}
sysutils;


const
  critical='CRITICAL ERROR: ';
  normal='HMM: ';
  warning='WARNING: ';

var
   outputfile: Textfile; 
   logging,donelogging:boolean;

   IsConsoleInvoked:boolean; external;

function Long2String(l: longint): string;
Procedure LogLn(s: string);
procedure StopLogging; 
procedure StartLogging;

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

//use me unless you need other variables added to the outputfile.

procedure LogGLFloat(data:single);
var
	stringdata:string;

begin
		write(data:4:2);
		stringdata:=FloatToStr(data);
  	    Write(outputfile,stringdata);
end;


procedure LogGLFloatLn(data:single);
var
	stringdata:string;

begin
		writeln(data:4:2);
		stringdata:=FloatToStr(data);
  	    Writeln(outputfile,stringdata);
end;


Procedure LogLn(s: string);
var
    v:string;
Begin
  {$ifdef lcl}
          {$ifndef windows}
           writeln( DateTimeToStr(Now),' : ',s); //to the debugging outputfile console first, then file.
           {$endif}
  {$else}
         {$ifndef noconsole}
                  writeln( DateTimeToStr(Now),' : ',s); //to the debugging outputfile console first, then file.
         {$endif}

  {$endif}

  v:=( (DateTimeToStr(Now))+' : '+s);
  Writeln(outputfile,v);
End;



procedure StartLogging; 
begin
    assign(outputfile,'lazgfx-debug.log');
    rewrite(outputfile);
    logging:=true;
    donelogging:=false;
end;

procedure StopLogging; //finalization

begin
    donelogging:=true;
    logging:=false;
    close(outputfile);
end;


begin 

end.
 

