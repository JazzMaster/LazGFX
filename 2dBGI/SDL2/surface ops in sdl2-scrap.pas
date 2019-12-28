//sdl2 only  
  
  var
  
		infosurface,somesurface:PSDL_Surface;
		someTexture: PSDL_Texture;
		
  begin
  
  infoSurface := SDL_GetWindowSurface(Window);
  
  //dont change the Surface Format..we could, just dont do it.
  someSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, 
			(infoSurface^.w * infoSurface^.format^.BytesPerPixel),longword( infoSurface^.format));


  ... do something ...
  
  someTexture:=SDL_CreateTextureFromSurface(renderer,someSurface);
    
    if (blitWholeSurf) then
		SDL_RenderCopy(renderer, tex, Nil, Nil); //scales image to output window size(size of undefined Rect)
    else
		SDL_RenderCopy(renderer, tex, Nil, rect); //PutImage at x,y but only for size of WxH
    
    
    
    SDL_RenderPresent(renderer); //FLIP
    
