McQuacking at me already?


os9:

        SDL1.2 is supported up to 2 releases shy of the last revision. 
        (They are marked OSX10.4 for some reason)
        Pascal compilers are abandonware-- or proprietary.

        (FPC has a cross-compiler joke here....)
		You are going to have to find a compiler for OS9- 
			not only does Apple no longer support it-
			You usually had to pay for those, back then. 
			"There are no freebies". (unless you cheat)

OSX:

        You need XCode and SDL installed- "XLib is highly depreciated as of late" with OSX.
        Apps requiring X11 are basically "forbidden to run".
        You need FPC setup and installed
        XCODE "console development package" pulls in the "build-essential" side of things for the Mac. 
		There are Lazarus versions now and the build instructions work to build the binaries w "future support".
		
Carbon or Cocoa? Depends on your current version of OSX. 
Most are pushing "swift" now.

No guarantee on the LazGfx build- I am still working out "some major issues".
OpenGL- as used for some time with OSX- DOES NOT LIKE being unit-i-zed. 
	SDL doesnt seem to care.


