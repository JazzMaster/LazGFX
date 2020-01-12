Unit Laz_Sound;

interface

//Ive been coding this shit- since- 1995??? (like forever)
//Notes dont need to be defined, sox has them.

//what we need to work on is MIDI playback support(file and simulated input)

implementation


procedure LoadSoundFont;
{
Im still working on this-

The idea is to load a sound FONT- (a bunch of instrument definitions) before "typing" audio notes...
(using the sound card of course- much like OPLv3 synthesis)

D2X-Rebirth uses this method- much like The original Descent I and II - uses MIDI(or similar) output
-and we dont want it to sound like ASS- 

what we need instead is a simulation of MIDI(synthesis)- 
        we need instruments
        and we need notes to play on them (like a MIDI driver board produces)

playing middle C is fine- 
    but on which instrument/synthboard?? 
Notes by themselves dont produce sound.

(Programatically, however, we use "Grand" Piano frequencies)

}

begin

end;


begin //Pascalmain()
//check for PortAudio/libUos
//check for libao

end.
