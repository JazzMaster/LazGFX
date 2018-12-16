program soundDemo;
{ 

This uses FPC internals and the PC speaker- YIKES!
You need two things for this to work on Unices:

    1- pcspeaker module not blacklisted (/etc/modprobe.d/blacklist.conf))
    2- pc speaker module loaded (sound system will emit a beep- and- speaker will emit one also in X11)
    (so you get a soundacrd eep -and a bloop)

    3- a motherboard 2-wire speaker actually attached to the motherboard (sometimes 4wires wide)

actual soundcard support isnt as easy as it used to be with DOS.

While most Linux-es will find the hardware- we need to find the adstracted hooks.
Linus has several means to do this:

OSS (ancient) /dev/dsp
ALSA 
PulseAudio

SDL "overlord" which finds one of the above and uses it.

Now we need to figure out how to hook the C invoking the sound functions, and setup a buffer.
We need to tell the soundcard system when to fire the event(in/out) via a buffer.

(SDL2 uses a funky timer callback method to achieve this)

We also- while doing THAT- need to stack sound effects onto the audio stream in flight as well.
(keep in mind- sound threading -and network redirection-is only possible with PulseAudio)

Any effects added need to expand the audio stream size(someone wasnt thinking) -like fades, etc.
(Pad with silence if nothing else)

}

//these two use FPC internals, not SDL.
//thats not to say SFX cant mux in as MIDI events(in this case piano notes) in lieu of a PC speaker
//(which is actually reccommended these days).

// if FPC redirects to the sound card instead of pc speaker- thats cool too!

procedure playOneNote;
begin
	PlayNote(440,250); //aaaa - (440hz =A, 250 ms)
	NoSound;
end;

procedure playNotes;

begin
	PlayNote(550,250); //mmmmm
	silentNote(250); // dont turn it off forever...
	PlayNote(880,250); //eeeeee
	NoSound; //ok now do it forever.
end;

//will be added in when I figure out the SDL sequence.
procedure Play_WAV;

begin
end;

procedure Play_OGG;

begin
end;


end.﻿
