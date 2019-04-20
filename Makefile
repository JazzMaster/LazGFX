#remember: this is NOT an application, its a unit(PPU).

include make.rules

# now were cooking with GAS.
all: main shapes

#linux first,then windows

main:
	$(FPC) -olazgfx-lin64.ppu $(RTLOUTDIR) lazgfx
	$(FPC) -Pi386 -olazgfx-lin32.ppu $(RTLOUTDIR) lazgfx
	$(FPC) -Twin32 -Pi386 -olazgfx-lin32.ppu $(RTLOUTDIR) lazgfx
	$(FPC) -Twin64 -Px86_64 -olazgfx-lin64.ppu $(RTLOUTDIR) lazgfx

shapes:
	$(FPC) -oshapes-lin64.ppu $(RTLOUTDIR) shapes
	$(FPC) -Pi386 -oshapes-lin32.ppu $(RTLOUTDIR) shapes
	$(FPC) -Twin32 -Pi386 -oshapes-lin32.ppu $(RTLOUTDIR) shapes
	$(FPC) -Twin64 -Px86_64 -oshapes-lin64.ppu $(RTLOUTDIR) shapes

clean:
	rm -f *.o *.ppu
