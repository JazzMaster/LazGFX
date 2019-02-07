
program To32Bit;
var f:file of char;
    n,ss,sr,as:string;
    dpos:longint;
    c:byte;
    ch:char;
begin
   WriteLn('TO32BIT 32-Bit-DPMI-Patcher'#10#13);
   if ParamCount=0 then
   begin
      WriteLn('Syntax: TO32BIT file [/U]'#10#13); halt;
   end;
   n:=ParamStr(1);
   {$I-} Assign(f,n); Reset(f); {$I+}
   if IOResult<>0 then
   begin
      WriteLn('File not found'#10#13); halt;
   end;
   sr:='DPMI32VM.OVL'; ss:='DPMI16BI.OVL';
   if (ParamCount>1) then
   if (ParamStr(2)='/U') or (ParamStr(2)='/u') then
   begin
      sr:='DPMI16BI.OVL'; ss:='DPMI32VM.OVL';
   end;
   dpos:=-1; as:='';
   while not eof(f) do
   begin
      Read(f,ch);
      as:=as+UpCase(ch);
      if as<>copy(ss,1,length(as)) then
      begin
         dpos:=-1; as:='';
      end;
      if as=ss then
      begin
         dpos:=FilePos(f)-12;
         Seek(f,dpos);
         for c:=1 to length(sr) do
         begin
            Write(f,sr[c]);
         end;
         dpos:=-1;
      end;
   end;
   Close(f);
   WriteLn(#10#13);
end.

