Program svgaDEMO;

uses
    uses
    svgalib,vgamouse,GL,GLU;
// -vgaGL,vgaGLU-

var

physicalscreen,virtualscreen:^GraphicsContext;

i,j,b,y,c:integer;

begin 
   vga_init;
   vga_setmode(G320x200x256);

//make a virtual screen on top of the physical one, and switch contexts in successive order
   gl_setcontextvga(G320x200x256);
   physicalscreen := gl_allocatecontext;

   gl_getcontext(physicalscreen);
   gl_setcontextvgavirtual(G320x200x256);

   virtualscreen := gl_allocatecontext;
   gl_getcontext(virtualscreen);
   gl_setcontext(virtualscreen);

   vga_setcolor(4);

   y := 0;
   c := 0;
   gl_setpalettecolor(c, 0, 0, 0);
   inc(c);
   i := 0;
   while ( i < 64 ) do begin
   
      b := 63 - i;
      gl_setpalettecolor(c, 0, 0, b);
      j := 0;
      while ( j < 3 ) do begin
         gl_hline(0, y, 319, c);
         inc(y);
         inc(j);
      end;
      inc(c);
      inc(i);
   end;
 
   gl_copyscreen(physicalscreen); //SDL_Flip or (RenderCopy(Texture,renderer) and RenderPresent(renderer));
 
   vga_getch;
   gl_clearscreen(0);
   vga_setmode(TEXT);
 
   sleep(5);
   vga_setmode(TEXT);
end.


