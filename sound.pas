Unit sound;
//in otherwords...music and background FX..for your GAMES!!!!
//This includes 'music' by para-virtual forms of MIDI equivalent sound effects.

{

You need external libs to play the following:

    WAVE/RIFF (.wav)
    AIFF (.aiff)
    VOC (.voc)
    MOD (.mod .xm .s3m .669 .it .med and more) requiring libmikmod
    MIDI (.mid) using timidity (or native midi hardware)
    Ogg Vorbis (.ogg) -Theora is for VIDEO -requiring libraries on system (ubuntu open standard)
    MP3 (.mp3) requiring SMPEG or MAD library
    FLAC (.flac) requiring the FLAC library

ExitCode 309 is due to missing libs...dont come crying to me..

We should just hook FFMpeg or Mplayer but Im not the one writing SDL...
Dont be fooled, you can play audio with any of these...^^
}

uses 
    SDL2_mixer;
    
type

    Notes=record
        A,B,C,D,E,F,G: real; //freq
    end;

    InstrumentTypes=(Pianos,Guitars,Lutes,Harps,Drums,Flutes,Oboes,Uprights,Violins,Ukeleles,Banjoes); //SoundFont defined- this is to look at

    //must support at least 3 FX at the same time to support a electric guitar (as a practical application).
    //Intel and CPU support alone- usually CANNOT produce live guitar emulation (or FX) properly.
    //so the G3 emulation FAILURE in GarageBand is understood.
    
    //EffectType:
    //this is what guitar pedals do
    
//so you should be able or OR these together    
const
    FXNone=1
    FXEcho=2
    FXWahWah=3
    FXReverb=4
    FXFlange=5
    FXDistort=6
    FXFuzz=7
    
    //Loop- just reset the playing pointer location.

type    
    InstrumentNotes=record
        Octaves:array [0..6] of Notes;
        Flats,Sharps: array [0..6] of Notes;
    end;

var

//briefly, this defines all notes
//Ive been coding this shit- since- 95??? (like forever)

    Instrument:array[0..hi(InstrumentTypes)] of InstrumentNotes;
    EffectTheNote:boolean;
 
   music: PMix_Music;
   sound: PMix_Chunk;
   PlayNow:boolean;
   

interface

procedure PlayNote(freq,HowLong:integer);
procedure silentNote(time:intger);
procedure Load_Music(WhatVolume:integer; musicFile:string);
procedure Play_Music(var music:pointer);

implementation
//I aim to add MIDI playback but thats thru a external binary and library(Timidity, etc)...
//You need GOOD HQ "soundfonts" for that.
//(Loads kinda the way TTFFonts do.)


//basic notes:

//FIXME: I dont know if FPC forces use of PC Speaker or uses soundcard for that.

//	old method:enable pcspkr module(dont blacklist it)
//	new: try Pulse, then ALSA


{
frequencies have to come from a table somewhere- wikipedia??
using real or floats because on certain instruments things can sound canned- or FLAT.

for each instrument (banjo,flutes,drums) do begin
    x:=0;
    -all tones are in HZ
    repeat
        -not all instruments are the same  
        -I dont have the data here yet      
        InstrumentNotes.Octaves[x].A=440;
        //half notes: one note SHARP -is anothers FLAT
        InstrumentHalfNotes.Octaves[x].A=440;
        InstrumentNotes.Octaves[x].B=440;
        InstrumentHalfNotes.Octaves[x].A=440;
        InstrumentNotes.Octaves[x].C=440;
        InstrumentHalfNotes.Octaves[x].A=440;
        InstrumentNotes.Octaves[x].D=440;
        InstrumentHalfNotes.Octaves[x].A=440;
        InstrumentNotes.Octaves[x].E=440;
        InstrumentHalfNotes.Octaves[x].A=440;
        InstrumentNotes.Octaves[x].F=440;
        InstrumentHalfNotes.Octaves[x].A=440;
        InstrumentNotes.Octaves[x].G=440;
        inc(x);
    until x=ord(hi(InstrumentTypes));
end;

}

//FX are based on instrument used- Grand Piano (and computer) is/are "fairly basic plucked" CLEAN TONE.
//(normal Pianos have Pedals for FX-I never understood thier use)


{

Jazzmans guide to playing REAL music on the computer:

Good music is played by chords, over time- shifting to other chords over and over again.
Computers have one thing going for them. Timeslicing.

By timeslicing- 
    we cut the chord into notes(of the stumming hand for a guitar)
(broken chord theory)

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

what we need instead is a simulation of MIDI(synthesis)- 
        we need instruments
        and we need notes to play on them (like a MIDI driver board produces)

playing middle C is fine- 
    but on which instrument/synthboard?? 

Notes by themselves dont produce sound. (A MIDI driver board in this example.)

}

begin

end;

//The old FPC way of doing things
//default instrument is a Grand Piano esque output.
procedure PlayNote(freq,HowLong:integer);
begin
  Sound(freq);
  Delay(HowLong);
end;

procedure silentNote(time:intger);
begin
  NoSound;
  Delay(time);
end;

{
chipTunes modifies this is weird and whacky ways....
(overprocessing HACK)

kind of like QBasic on steroids...BLENDING MUSIC by playing it too fast...
to do this, screw the silentNotes...and multiply the notes put out the speaker for desired effect.

I did this some years ago (in QB) w Micheal W Smith's "Friends" track. Dont have the code anymore.

some FX in MegaZeux(OpenMegaZeux) did this too.

}

procedure PlayWAV;
//check the audio demo-incomplete
begin
{$ifdef windows}
    sndPlaySound('C:\sounds\test.wav', snd_Async or snd_NoDefault);
{$endif}

end;


function SDL_LoadWAV(_file: PAnsiChar; spec: PSDL_AudioSpec; audio_buf: PPUInt8; audio_len: PUInt32): PSDL_AudioSpec;
begin
  SDL_LoadWAV := SDL_LoadWAV_RW(SDL_RWFromFile(_file, 'rb'), 1, spec, audio_buf, audio_len);
end;
  
function SDL_AUDIO_BITSIZE(x: Cardinal): Cardinal;
begin
  SDL_AUDIO_BITSIZE := x and SDL_AUDIO_MASK_BITSIZE;
end;

function SDL_AUDIO_ISFLOAT(x: Cardinal): Cardinal;
begin
  SDL_AUDIO_ISFLOAT := x and SDL_AUDIO_MASK_DATATYPE;
end;

function SDL_AUDIO_ISBIGENDIAN(x: Cardinal): Cardinal;
begin
  SDL_AUDIO_ISBIGENDIAN := x and SDL_AUDIO_MASK_ENDIAN;
end;

function SDL_AUDIO_ISSIGNED(x: Cardinal): Cardinal;
begin
  SDL_AUDIO_ISSIGNED := x and SDL_AUDIO_MASK_SIGNED;
end;

function SDL_AUDIO_ISINT(x: Cardinal): Cardinal;
begin
  SDL_AUDIO_ISINT := not SDL_AUDIO_ISFLOAT(x);
end;

function SDL_AUDIO_ISLITTLEENDIAN(x: Cardinal): Cardinal;
begin
  SDL_AUDIO_ISLITTLEENDIAN := not SDL_AUDIO_ISLITTLEENDIAN(x);
end;

function SDL_AUDIO_ISUNSIGNED(x: Cardinal): Cardinal;
begin
  SDL_AUDIO_ISUNSIGNED := not SDL_AUDIO_ISSIGNED(x);
end;


//double check w the spec...
procedure Load_Music(WhatVolume:integer; musicFile:string);

var
  music:pointer;

begin
 
  //load music
  music := Mix_LoadMUS( MusicFile );
  if music = nil then begin
//    ShowMessage('Music file load failure.');
    exit;
  end;

  Mix_VolumeMusic( WhatVolume ); 
  if Paused then exit
  else Play_Music(music);
end;

procedure Play_Music(var music:pointer);

begin
    if Paused then exit;
    if Mix_PlayMusic( music, 0 ) < 0 then 
//    showmessage('I cant play for some reason...Hmph..');
end;

//main
begin

//suppose we should do so OS level checks here, like checking if OSS device exists,ALSA device exists, PA device exists
//and appropriate kernel modules are loaded.
//also: whats the OSX (and PRE OSX) method??
  
end.
