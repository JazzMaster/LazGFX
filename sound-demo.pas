program soundDemo;
//play me the basics...

procedure playOneNote;
begin
	PlayNote(440,250); //aaaa
	NoSound;
end;

procedure playNotes;

begin
	PlayNote(550,250); //mmmmm
	silentNote(250); // dont turn it off forever...
	PlayNote(880,250); //eeeeee
	NoSound;
end;

end.﻿
