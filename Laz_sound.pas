Unit Laz_Sound;

interface

//briefly, this defines all notes
//Ive been coding this shit- since- 95??? (like forever)


type

    Notes=record
        A,B,C,D,E,F,G: real; //freq
    end;

    InstrumentTypes=(Pianos,Guitars,Lutes,Harps,Drums,Flutes,Oboes,Uprights,Violins,Ukeleles,Banjoes); //SoundFont defined- this is to look at

    //must support at least 3 FX at the same time to support a electric guitar (as a practical application).
    EffectType=(None,Echo,WahWah,Reverb,Flange,Distort,Fuzz); //this is what guitar pedals do
    //Loop- just reset the playing pointer location.
    
    InstrumentNotes=record
        Octaves:array [0..6] of Notes;
        Flats,Sharps: array [0..6] of Notes;
    end;

var

    Instrument:array[0..hi(InstrumentTypes)] of InstrumentNotes;
    EffectTheNote:boolean;


implementation

{
its a but funky- but code is not music, by itself.
frequencies have to come from a table somewhere- wikipedia??

using real values because on certain instruments things can sound canned, or FLAT.

for each instrument (banjo,flutes,drums) do begin
    x:=0;
    repeat
        InstrumentNotes.Octaves[x].A=(frequency)440;
        InstrumentNotes.Octaves[x].B=(frequency)440;
        InstrumentNotes.Octaves[x].C=(frequency)440;
        InstrumentNotes.Octaves[x].D=(frequency)440;
        InstrumentNotes.Octaves[x].E=(frequency)440;
        InstrumentNotes.Octaves[x].F=(frequency)440;
        InstrumentNotes.Octaves[x].G=(frequency)440;
        inc(x);
    until x=ord(hi(InstrumentTypes));
end;
}

//FX are based on instrument used- Grand Piano (and computer) is/are "fairly basic plucked" CLEAN TONE.

//(normal Pianos have Pedals for FX-I never understood thier use)



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

See above code before just dropping shit here.


}

begin //main()
//suppose we should do so OS level checks here, like checking if OSS device exists,ALSA device exists, PA device exists
//and appropriate kernel modules are loaded.

//windows: (the driver)
//less of an issue w SDL and Windows- more for Unices.

end.
