program sdldemo;

uses
    crt,SDL;

var
    MainSurface:PSDL_Surface;
    Nope:pointer;
    ch:char;
    Pixel:^Word;
    Color:Dword;

begin
    Nope:=SDL_Init;
    if Nope <> Nil then halt(0);
    MainSurface:=SDL_SetVideoMode(640,480,24,SDL_HWSURFACE);
    if MainSurface = Nil then halt(0);
    Color:=$FF00FFFF; //inverse?
    Pixel:=Color;
    ch:=Readkey;
    SDL_Quit;
    

end.
