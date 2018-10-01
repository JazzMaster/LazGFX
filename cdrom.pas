unit cdrom

{
The closest reference I can give for this is:

1- a CDPlayer in Pascal
2- SEGA CD or Descent II based games(RedBook Audio)

This is the audio portion..not the game code...
}
interface

var

  NoDrives:boolean;

uses
   BGISDL;

implementation
//the audio subsystem gets initd on startup so im assuming its required or we couldnt play nothing.

Procedure GoGetADrive;

var
  Drives:integer;

begin
   Drives:=SDL_CDNumDrives;
   if Drives<0 then begin
     ShowMessage('AGH! I cant find a optical drive....');
     NoDrives:=true;
   end;
   //if opening drive 0 means the system default then 0 must be a valid response??
   //or someones C is really fucked up!
   
end;

//open, play...stop, close

{
cdrom demo code:

    cdrom:^SDL_CD;
    status:CDstatus;
    status_str:string;
    m,s,f:integer;

    cdrom := SDL_CDOpen(0);
    if ( cdrom = NULL ) then begin
        showmessage( 'Couldn't open default CD-ROM drive:  ',SDL_GetError);
        exit;
    end;

    status = SDL_CDStatus(cdrom);
    case (status) of
        CD_TRAYEMPTY: status_str := 'tray empty';
        CD_STOPPED: status_str := 'stopped';
        CD_PLAYING: status_str := 'playing';
        CD_PAUSED: status_str := 'paused';
        CD_ERROR: status_str := 'error state';
          
    end; //case
    showMessage('Drive Status: ',status_str);
    

    // Play entire CD:
    if ( CD_INDRIVE(SDL_CDStatus(cdrom)) ) then
        SDL_CDPlayTracks(cdrom, 0, 0, 0, 0);

    // Play last track:
    if ( CD_INDRIVE(SDL_CDStatus(cdrom)) ) then
       SDL_CDPlayTracks(cdrom, cdrom.numtracks-1, 0, 0, 0);
        

    if ( status >= CD_PLAYING ) then begin
        
        FRAMES_TO_MSF(cdrom.cur_frame, m, s, f);
        showMessage('Currently playing track ', cdrom.track[cdrom.cur_track].id, m, s);
    end;

}

end.﻿
