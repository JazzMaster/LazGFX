unit logger;

const
  critical='CRITICAL ERROR: ';
  normal='HMM: ';
  warning='WARNING: ';

var
   output: file; //untyped text
   logging,donelogging:boolean;

interface

Procedure LogString(s: String);
Procedure LogLn(s: string);


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
//SDL_GetError for example may spit out other crud...

//byte, word 2string, real2string,int2string

function Long2String(l: longint): string;
begin
  str(l, strf)
end;

//end FPC code - the rest has been modified "for an EXPLICIT PURPOSE"


Procedure LogString(s: String);
var
   output: file; //untyped text

Begin
  Write(otuput, s);
End;

//use me unless you need other variables added to the output.
//remember- files WRAP at odd points, depending on the width of the viewing application and output monitor.
Procedure LogLn(s: string);

Begin
  Writeln(otuput,s);
End;

procedure StopLogging; //finalization
//call just before SDL_Quit
begin
    donelogging:=true;
    logging:=false;
    Close(output);
end;

begin //init - main()
    Assign(output,'lazgfx-debug.log'); 
    Append(output); //do not re-write or re-set.
    Logging:=true;
end.
 

