Unit Laz_Sound;

interface

//briefly, this defines all notes
//Ive been coding this shit- since- 95??? (like forever)

type

    Notes=(A,B,C,D,E,F,G);
    Octaves=(1,2,3,4,5,6,7); //Or "octave window"
    NoteFXtype=(None,Sharp,Flat); //Flat of one is Sharp of another. At least in Guitar
    Instruments=(Pianos,Guitars,Lutes,Harps,Drums,Flutes,Oboes,Uprights,Violins,Ukeleles,Banjoes); //SoundFont defined- this is to look at

var
    //"whacky Pascal redefinitions" to use the enums
    Octave:Octaves;
    Note:Notes;
    NoteFX:NoteFXtype;

//realistically- this is whats used
//FX are based on instrument used- Grand Piano is "fairly basic plucked" CLEAN TONE.

//(normal Pianos have Pedals for FX-I never understood thier use)

const
//frequencies in Hz
//seven octaves standard "GAMUT" -as it were

//some instruments go higher, some lower

//"Grand Piano computer" example

    middleA=440;
    middleC=220;

//delays(in ms)

    sixteenth=63; //62.5
    eigth=125;
    quarter=250;
    half=500;
    whole=1000;

{

JazzMans guide to playing REAL music on the computer:

Good music is played by chords, over time- shifting to other chords over and over again.
Computers have one thing going for them. Timeslicing.

By timeslicing- 
    we cut the chord into notes(of the stumming hand for a guitar)

We play one note at a time, play another (accompaning note), then another until the chord is complete.
Then we play another chord in the same manner. 

We do "this" over and over. 
Most people call this method PLAYING MUSIC.

We build up- in effect- to playing songs, by dividing the task of "playing chords".


The question becomes what the delay between notes in a chord is.
Find this- and we can "play chords" on a computer.

(Usually, at this point we are dealing with waveforms- or compressed waveforms.
However, it can be done)

We are in effect- teaching the computer- or telling it (sans AI)- how to play music.

This of course doesnt include "swayed notes" or "string bending" 
    -what a lot of guitarists do with music.

The "hawaiian warble" is produced by drop tuning(slack tuning) guitars, ukeleles and similar stringed intruments.
It sounds awesome- but is hard on the computer to pull off.

(You are effectively DE-TUNEing notes-AND the note is effected by the thickness of the strings-
and furthermore by how its played)

So the types of music- and how its played has some limits. 

At least without AI- 
    which requires FX modification of an in-flight audio note.
    FX require some Processor PUNCH as it is. Even Milisecond delays are a BIG NO-NO. (and very detectable)

This said- we should still be able to RENDER SOUND (to the ears) much like we do with video on screen.
In fact- even 8088s can be forced into "audio blurs" by repeating notes at an extremely high rate of speed.
-Ive done it.

5-7-9 seems to be the magic guitar combo.
    5th root note-lets say A (open... 3rd fret- doesnt matter)
    7th harmonic of the above
    9th hrmonic of the above 5th root note

}

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

{

For the basics:

Note definitions, scalle definitions (never thought Id be re writing this code)
Are included here. There are several implementations and I am trying to standardize these also.

A=440Hz


}

implementation



begin //main()
end.
