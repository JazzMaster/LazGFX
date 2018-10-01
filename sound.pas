Unit sound;
//in otherwords...music and background FX..for your GAMES!!!!

{

You need external libs or this wont work.
(except for the pianos....)

    WAVE/RIFF (.wav)
    AIFF (.aiff)
    VOC (.voc)

    MOD (.mod .xm .s3m .669 .it .med and more) requiring libmikmod
    MIDI (.mid) using timidity (or native midi hardware)
    OggVorbis (.ogg) requiring ogg/vorbis libraries on system (ubuntu open standard)
    MP3 (.mp3) requiring SMPEG or MAD library
    FLAC (.flac) requiring the FLAC library

ExitCode 309 is due to missing libs...dont come crying to me..

We should just hook FFMpeg or Mplayer but Im not the one writing SDL...

Dont be fooled, you can play any of these...^^
}

uses 
	SDLBGI, 
    SDL2_mixer;
 
var
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
//Loads kinda the way TTFFonts do.


//basic FPC "speaker" sounds...
//PC speaker oscillator tricks- not used much anymore..

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


some sound effects in MegaZeux did this too.

}

//double check w the spec...
procedure Load_Music(WhatVolume:integer; musicFile:string);

var
  music:pointer;

begin
 
  //load music
  music := Mix_LoadMUS( MusicFile );
  if music = nil then begin
    ShowMessage('Music file load failure.');
    exit;
  end;
  Mix_VolumeMusic( WhatVolume ); 
  if PlayNow then Play_Music(music) else exit; 
end;

procedure Play_Music(var music:pointer);

begin
    if Mix_PlayMusic( music, 0 ) < 0 then showmessage('I cant play for some reason...Hmph..');
end;

{
part of the physics engine...not written yet..
fine for apps but not a library or unit.


  //on collision load sound - 8 layers of effects possible.
  sound := Mix_LoadWAV( FXFile );
  if sound = nil then ShowMessage('FX load failure.');
  Mix_VolumeChunk( sound, MIX_MAX_VOLUME );

  
  //set these keys in the Keyboard handler
  if PauseMusic then Mix_PauseMusic;
  else if not PauseMusic then Mix_ResumeMusic;
}
  
end.
