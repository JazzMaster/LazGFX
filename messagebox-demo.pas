program MsgBoxDemo;

//sdltest unit
uses
	sdl2,strings,crt;

begin
    if( ( SDL_Init(SDL_INIT_VIDEO or SDL_INIT_AUDIO)= -1 ) ) then
    begin
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Couldn''t initialize SDL','Error somewhere',NIL);
      halt(-1);
    end;
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_WARNING,'SDL Initialized.', 'ok',NIL);

    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'Quiting SDL.', 'ok',NIL);            
    // Shutdown all subsystems
    SDL_Quit;
    halt(0);
end.
