Program svgaDEMO;

uses
    svgalib,vgamouse;

begin 
   vga_init;
   vga_setmode(G320x200x256);
   vga_setcolor(4);
   vga_drawpixel(10, 10);
 
   sleep(5);
   vga_setmode(TEXT);
end.
