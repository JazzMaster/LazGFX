McQuacking at me already?

os9:

        SDL1.2 is supported up to 2 releases shy of the last revision. 
        (They are marked OSX10.4 for some reason)
        Pascal compilers are abandonware(yet updated for OSX) or proprietary.

        (FPC has a cross-compiler joke here....)

OSX:

        You need XCode and SDL installed- at least until xLIB support is implemented. 
        You need FPC and you need it setup. (DUH)

        XCODE pulls in the build-essential side of things for the Mac. 

This is the only reason that you need XCODE installed(besides wanting to build Lazarus/UI apps yourself).
There seems to be a trick here-

        Most OSX versions have a X11 as an optional installed application. (It is found on the OS install disc.) 
        XlibCore routines are already optimized for the OS in question.
        So in theory- any app using Xlibs(or built against them) should run on OSX- despite being a "UNIX UI" app.

(This was Apple idea- really- it was)

So in effect, the xAPI code should run on OSX- despite being "unsupported" and without all of the other hell
in depends or requiremnets that other code may need. 

(We would be bypassing SDL -and its requirements -by implementing our own BGI atop xLIB core routines instead.)
