#remember: this is NOT an application, its a unit(PPU).

all:
	everything

everything:
	fpc -Twin32 -Pi386 lazgfx.pas -o lazgfx-win32.ppu -Fe units
	fpc -Twin64 -Px86_64 lazgfx.pas -o lazgfx-win64.ppu -Fe units
	fpc lazgfx.pas -Pi386 -o lazgfx-lin32.ppu -Fe units
	fpc lazgfx.pas -o lazgfx-lin64.ppu -Fe units

clean:
	rm -f *.o *.ppu
