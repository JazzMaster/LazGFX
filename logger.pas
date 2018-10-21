unit logger;

var

  critical,normal,warning:string;

interface

Procedure FileLogString(s: String);
Procedure FileLogLn(s: string);


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


function Long2String(l: longint): string;
begin
  str(l, strf)
end;

//end FPC code - the rest has been modified "for an EXPLICIT PURPOSE"


//logChar is pointless..
Procedure FileLogString(s: String);
var
   output: file; //untyped text

Begin
//dont open a file if its already opened and why open/close repeatedly?
  if NotLogging then begin 
    Assign(output,'lazgfx.log'); 
    Append(debuglog);
 end;
  if IsConsoleInvoked then
     write(s);
  Write(otuput, s);
  if donelogging then Close(debuglog);
End;

Procedure FileLogLn(s: string);
var
   output: file; //untyped text

Begin

//dont open a file if its already opened and why open/close repeatedly?
  if NotLogging then begin 
    Assign(output,'lazgfx.log'); 
    Append(debuglog);
 end;
  if IsConsoleInvoked then
     writeln(s);
  Writeln(otuput,s);
  if donelogging then Close(debuglog);
End;


begin
//so we can compile custom error messages
   critical:='*** CRITICAL ERROR!! ';
   normal:='*** STATUS: ';
   warning:='*** WARNING!! ';


end.
 

