# .o or .a technically.... not quite .so
# or .tpu

all:
	win32 win64 lin32 lin64

win32:
	fpc -Twin32 -Pi386 sdlbgi.pas -o sdlbgi-win32.ppu -FU sin
win64:
	fpc -Twin64 -Px86_64 sdlbgi.pas -o sdlbgi-win64.ppu -FU sin
lin32:
	fpc sdlbgi.pas -Pi386 -o sdlbgi-lin32.ppu
lin64:
	fpc sdlbgi.pas -o sdlbgi-lin64.ppu
