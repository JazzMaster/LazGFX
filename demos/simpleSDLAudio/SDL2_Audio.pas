Unit SDL2_Audio;

{

  Simple-SDL2-Audio
 
  Copyright 2016 Jake Besworth
 
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
 
      http://www.apache.org/licenses/LICENSE-2.0
 
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
 
	ReWritten for FPC in 2019 
	(c) 2019  Richard Jasmin 

USE:
	SDL2 changed things around. 
	See the demo for details.

Pardon my horrid C portage.
}

interface

uses
	SDL2;

// sdlaudio.inc (go up a few folders) has some variable we use.

// Queue for all loaded sounds
//this is a "linked list"- its hard to read in C.

//Also: multiple references to audio->audio and audio:audio which make no sense.

type

Sound=record

    length:uint32;
    lengthTrue:uint32; //bool
    bufferTrue:^uint8; //bool
    buffer:^uint8;
    loop:uint8;
    fade:uint8;
    free:uint8;
    volume:uint8;
    audiorec:SDL_AudioSpec;
    next:^Sound;
end; 

var
	Audio:Sound; //-or of a pointer of it. C is WEIRD!
	Next:^Sound;

{
  Create a Audio object
 
  @param filename      Filename for the WAVE file to load
  @param loop          0 ends after playing once (sound), 1 repeats and fades when other music added (music)
  @param volume        Volume, read playSound()
 
  @return returns a new Audio or NULL on failure, you must call freeAudio() on return Audio
 
}

function createAudio(filename:PChar; loop:uint8; volume:integer):Audio;

{
  Frees as many chained Audios as given
 
  @param audio     Chain of sounds to free
 
}

procedure freeAudio(audio1:^Audio);

{
  Play a wave file currently must be S16LE format 2 channel stereo
 
  @param filename      Filename to open, use getAbsolutePath
  @param volume        Volume 0 - 128. SDL_MIX_MAXVOLUME constant for max volume
 
}

procedure playSound(filename:PChar; volume:integer);

{
  Plays a new music, only 1 at a time plays
 
  @param filename      Filename of the WAVE file to load
  @param volume        Volume read playSound for moree
 
}

procedure playMusic(filename:PChar; volume:integer);

{
  Plays a sound from a createAudio object (clones), only 1 at a time plays
  Advantage to this method is no more disk reads, only once, data is stored and constantly reused
 
  @param audio         Audio object to clone and use
  @param volume        Volume read playSound for moree
 
}

procedure playSoundFromMemory(audio1:^Audio; volume:integer);

{
  Plays a music from a createAudio object (clones), only 1 at a time plays
  Advantage to this method is no more disk reads, only once, data is stored and constantly reused

  @param audio         Audio object to clone and use
  @param volume        Volume read playSound for moree
}

procedure playMusicFromMemory(audio1:^Audio;volume:integer);


//Free all audio related variables
//Note, this needs to be run even if initAudio fails, because it frees the global audio device

procedure endAudio;
procedure initAudio;
procedure pauseAudio;
procedure unpauseAudio;


{
  Native WAVE format
 
  On some GNU/Linux you can identify a files properties using:
       mplayer -identify music.wav
 
  On some GNU/Linux to convert any music to this or another specified format use:
       ffmpeg -i in.mp3 -acodec pcm_s16le -ac 2 -ar 48000 out.wav
 
}

const

//define what SDL doesnt already.

// SDL_AudioFormat of files, such as s16 little endian 

    AUDIO_FORMAT=AUDIO_S16LSB

// Frequency of the file = 44100 or 48000
	AUDIO_FREQUENCY=48000

// 1 mono, 2 stereo, 4 quad, 6 (5.1) */
	AUDIO_CHANNELS=2

// Specifies a unit of audio data to be used at a time. Must be a power of 2 */
	AUDIO_SAMPLES=4096

// Max number of sounds that can be in the audio queue at anytime, stops too much mixing */
	AUDIO_MAX_SOUNDS=25

{
  Flags OR'd together, which specify how SDL should behave when a device cannot offer a specific feature
  If flag is set, SDL will change the format in the actual audio file structure (as opposed to gDevice->want)
 
  Note: If you're having issues with Emscripten / EMCC play around with these flags
 
  0                                    Allow no changes
  SDL_AUDIO_ALLOW_FREQUENCY_CHANGE     Allow frequency changes (e.g. AUDIO_FREQUENCY is 48k, but allow files to play at 44.1k
  SDL_AUDIO_ALLOW_FORMAT_CHANGE        Allow Format change (e.g. AUDIO_FORMAT may be S32LSB, but allow wave files of S16LSB to play)
  SDL_AUDIO_ALLOW_CHANNELS_CHANGE      Allow any number of channels (e.g. AUDIO_CHANNELS being 2, allow actual 1)
  SDL_AUDIO_ALLOW_ANY_CHANGE           Allow all changes above
}
 
  SDL_AUDIO_ALLOW_CHANGES=SDL_AUDIO_ALLOW_ANY_CHANGE

type 

// Definition for the global sound device

privateAudioDevice=record

    device:SDL_AudioDeviceID;
    want:SDL_AudioSpec;
    audioEnabled:uint8; //ByteBool
end;

var
// File scope variables to persist data 
	gDevice:^PrivateAudioDevice;
    gSoundCount:uint32;

{

  Add a music to the queue, addAudio wrapper for music due to fade
 
  @param new       New Audio to add
  
}

procedure addMusic(root,new:^Audio);

{

  Wrapper function for playMusic, playSound, playMusicFromMemory, playSoundFromMemory
 
  @param filename      Provide a filename to load WAV from, or NULL if using FromMemory
  @param audio         Provide an Audio object if copying from memory, or NULL if using a filename
  @param sound         1 if looping (music), 0 otherwise (sound)
  @param volume        See playSound for explanation
 
}

procedure playAudio(filename:PChar; audio1:^Audio;  loop:uint8; volume:integer);

{
  Add a sound to the end of the queue
 
  @param root      Root of queue
  @param new       New Audio to add
 
}

procedure addAudio(root,new:Audio);

{
  Audio callback function for OpenAudioDevice
 
  @param userdata      Points to linked list of sounds to play, first being a placeholder
  @param stream        Stream to mix sound into
  @param len           Length of sound to play
 
}

procedure audioCallback(userdata:pointer; stream:Puint8; len:intger);

implementation


procedure playSound(filename:PChar; volume:integer);
begin
    playAudio(filename, NULL, 0, volume);
end;

procedure playMusic(filename:PChar; volume:integer);
begin
    playAudio(filename, NULL, 1, volume);
end;

procedure playSoundFromMemory(filename:PChar; volume:integer);
begin
    playAudio(NULL, audio, 0, volume);
end;

procedure playMusicFromMemory(audio1:^Audio; volume:integer);
begin
    playAudio(NULL, audio, 1, volume);
end;

procedure initAudio;
var
	global:^Audio;

begin
	
    gDevice = Malloc(sizeof(PrivateAudioDevice);
    gSoundCount := 0;

    if(gDevice = NiL) then begin
    
        LogLn('Fatal Error: Memory allocation error');
        exit;
    end;

    gDevice.audioEnabled := 0;

    if(not (SDL_WasInit(SDL_INIT_AUDIO) and SDL_INIT_AUDIO)) then begin
    
        LogLn('Error: SDL_INIT_AUDIO not initialized');
        exit;
    end;

    SDL_memset((gDevice.want), 0, sizeof(gDevice.want));

    gDevice.want.freq := AUDIO_FREQUENCY;
    gDevice.want.format := AUDIO_FORMAT;
    gDevice.want.channels := AUDIO_CHANNELS;
    gDevice.want.samples := AUDIO_SAMPLES;
    gDevice.want.callback := audioCallback; //@audiocallback??

    gDevice.want.userdata := malloc(sizeof(Audio));

    global := gDevice.want.userdata;

    if(global = NiL) then begin
    
        LogLN('Error: Memory allocation error');
        exit;
    end;

    global.buffer = NiL;
    global.next = NiL;

    if((gDevice.device = SDL_OpenAudioDevice(NiL, 0, gDevice.want, NiL, SDL_AUDIO_ALLOW_CHANGES)) = 0)
    then
        LogLN('Warning: failed to open audio device: '+SDL_GetError);
    
    else
    begin
//         Set audio device enabled global flag 
        gDevice.audioEnabled := 1;

//         Unpause active audio stream 
        unpauseAudio;
    end;
end;

procedure endAudio;


begin
    if(gDevice.audioEnabled) then begin
    
        pauseAudio;

        freeAudio(gDevice.want.userdata);

//       Close down audio 
        SDL_CloseAudioDevice(gDevice.device);
    end;

    free(gDevice);
end;

procedure pauseAudio;
begin
    if(gDevice.audioEnabled) then    
        SDL_PauseAudioDevice(gDevice.device, 1);
    //else complain
end;

procedure unpauseAudio;
begin
    if(gDevice.audioEnabled) then    
        SDL_PauseAudioDevice(gDevice.device, 0);
    //else complain
end;

procedure freeAudio(audio1:^Audio);

var
	temp:^Audio;

begin

    while(audio1 <> NiL) do begin
    
        if(audio1.free = 1) then
            SDL_FreeWAV(audio1.bufferTrue);
        
        temp := audio1;
        audio := audio1.next;

        free(temp);
    end;
end;

function createAudio(filename:PChar; loop:uint8; volume:integer):Audio; 

var
	Audioptr:Audio;

begin

    AudioPtr  := Malloc(sizeof(Audio));

    if(AudioPtr = NiL) then begin
    
        LogLn('Error: Memory allocation error ');
    end;

    if(filename = NiL) then begin
    
        LogLn('Cant open a NilFILE...');
    end;

    AudioPtr^.next := NiL;
    AudioPtr^.loop := loop;
    AudioPtr^.fade := 0;
    AudioPtr^.free := 1;
    AudioPtr^.volume := volume;

    if(SDL_LoadWAV(filename,AudioPtr^.audiorec, AudioPtr^.bufferTrue, AudioPtr^.lengthTrue) = NiL) then begin
    
        LogLn('Warning: failed to open wave file: '+SDL_GetError());
        free(AudioPtr);
        
    end;

    AudioPtr^.buffer := AudioPtr^.bufferTrue;
    AudioPtr^.length := AudioPtr^.lengthTrue;
    AudioPtr^.audiorec.callback = NiL;
    AudioPtr^.audiorec.userdata = NiL;

    createAudio :=AudioPtr;
end;

procedure playAudio(filename:Pchar; audio1:Audio; loop:uint8; volume:integer);

var
	new:Audio;
begin

//     Check if audio is enabled 

    if( not gDevice.audioEnabled) then    
        exit;
    

//     If sound, check if under max number of sounds allowed, else don't play 
    if(loop = 0) then begin
    
        if(gSoundCount >= AUDIO_MAX_SOUNDS)
            exit
        else
            inc(gSoundCount);
    end;

    // Load from filename or from Memory 
    if(filename <> NiL) then
    
        // Create new music sound with loop 
        new := createAudio(filename, loop, volume)
    
    else if(audio1 <> NiL) then
    begin
        new := malloc(sizeof(Audio1));

        if(new = NiL) then begin
        
            LogLn('Fatal Error: Memory allocation error: ');
            exit;
        end;

        memcpy(new, audio, sizeof(Audio1));

        new.volume := volume;
        new.loop := loop;
        new.free := 0;
    end
    else begin
    
        LogLn('Warning: filename and Audio parameters = NiL');
        exit;;
    end;

    // Lock callback function 
    SDL_LockAudioDevice(gDevice.device);

    if(loop = 1) then
    
        addMusic(gDevice.want.userdata, new);
    
    else
    
        addAudio(gDevice.want.userdata, new);

    SDL_UnlockAudioDevice(gDevice.device);

end;

procedure addMusic(root,new:Audio);

var
	rootNext:Audio;
	musicFound:uint8;

begin
    musicFound := 0;
    rootNext := root.next;

    // Find any existing musics, 0, 1 or 2 and fade them out 
    while(rootNext <> NiL) do begin
    
        // Phase out any current music 
        if(rootNext.loop = 1 and rootNext.fade = 0) then begin
        
            if(musicFound) then begin
            
                rootNext.length := 0;
                rootNext.volume := 0;
            end;

            rootNext.fade := 1;
        end;
        // Set flag to remove any queued up music in favour of new music 
        else if(rootNext.loop = 1 and rootNext.fade = 1) then
        
            musicFound := 1;
        

        rootNext := rootNext.next;
    end;

    addAudio(root, new);
end;

procedure audioCallback(userdata:pointer; stream:^uint8; len:integer);

var
    audio1:Audio;
    previous:audio;
    tempLength:integer;
    music:uint8;


begin
    audio1:=userdata;
    previous := audio1;
    music := 0;

    // Silence the main buffer 
    SDL_memset(stream, 0, len);

    // First one is place holder 
    audio1 = audio1.next;

    while(audio1 <> NiL) do begin
    
        if(audio1.length > 0) then begin
        
            if(audio1.fade = 1 and audio1.loop = 1) then begin
            
                music := 1;

                if(audio1.volume > 0) then
                
                    dec(audio1.volume);
                
                else
                
                    audio1.length := 0;
                
            end;

            if(music and audio1.loop = 1 and audio1.fade = 0) then
            
                tempLength := 0;
            
            else
//if a >b then bolvalue --else other bool value--- wonky C!
                if len> audio1.length then
					templength:=1;
				else
					templength:=0;
            

            SDL_MixAudioFormat(stream, audio1.buffer, AUDIO_FORMAT, tempLength, audio1.volume);

            audio1.buffer:= audio1.buffer +tempLength;
            audio1.length:= audio1.length - tempLength;

            previous: = audio1;
            audio1 := audio1.next;
        end
        else if(audio1.loop = 1 and audio1.fade = 0) then begin
        
            audio1.buffer:= audio1.bufferTrue;
            audio1.length:= audio1.lengthTrue;
        end
        else begin
        
            previous.next = audio1.next;

            if(audio1.loop = 0) then
            
                dec(gSoundCount);

            audio1.next := NiL;
            freeAudio(audio);

            audio1 := previous.next;
        end;
    end;
end;

procedure addAudio(root,new:^Audio);

begin
    if(root = NiL) then exit;

    while(root,next <> NiL) do begin
    
        root := root^.next;
    end;

    root^.next := new;
end;

end.
