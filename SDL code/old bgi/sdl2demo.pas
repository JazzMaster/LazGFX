
program SDL_WindowAndRenderer;
 
uses SDL2;
 
var
  sdlWindow1: PSDL_Window;
  sdlRenderer: PSDL_Renderer;
    i:integer;

begin
 
  //initilization of video subsystem
  if SDL_Init(SDL_INIT_VIDEO) < 0 then Halt;
 
  // full set up
  sdlWindow1 := SDL_CreateWindow('Window1', 50, 50, 500, 500, SDL_WINDOW_SHOWN);
  if sdlWindow1 = nil then Halt;
 
  sdlRenderer := SDL_CreateRenderer(sdlWindow1, -1, 0);
  if sdlRenderer = nil then Halt;
 
  // quick set up
  {
  if SDL_CreateWindowAndRenderer(500, 500, SDL_WINDOW_SHOWN, @sdlWindow1, @sdlRenderer) <> 0
    then Halt;
  }
   SDL_SetRenderDrawColor(sdlrenderer, 0, 0, 0, 255);
   SDL_RenderClear(sdlrenderer);
   SDL_RenderPresent(sdlRenderer);

  SDL_Delay( 1000 );
 
  SDL_SetRenderDrawColor( sdlRenderer, 255, 0, 0, 255 );
  SDL_RenderDrawLine( sdlRenderer, 10, 10, 490, 490 );
  SDL_RenderPresent( sdlRenderer );
  SDL_Delay( 1000 );
 
  SDL_SetRenderDrawColor( sdlRenderer, 0, 255, 0, 255 );
  for i := 0 to 47 do SDL_RenderDrawPoint( sdlRenderer, 490-i*10, 10+i*10 );
  SDL_RenderPresent( sdlRenderer );
  SDL_Delay( 1000 );
   
   //do something here

  //wait 2 seconds
  SDL_Delay(2000);
 
  // clear memory
  SDL_DestroyRenderer(sdlRenderer);
  SDL_DestroyWindow (sdlWindow1);
 
  //closing SDL2
  SDL_Quit;
 
end.  
