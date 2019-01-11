This is work in progress- not much different than JEDI headers.
This provides some more functionality.

internally calls one of: 

		WinAPI
		X11(and OpenGL)
		Quartz(OpenGL)
		framebuffer(with touch)
		sdl(2)
		WindowsCE


Need to port some headers to FPC:
	
		buried under EFL(enlightenment corelib) library and src tree folders.
		I will have to "unfuck the C mess".

Furthermore:

		changes are not backported as files, but as the "whole tree"- so keeping this up to date **will be a bitch**


Evas.h
Evas_Engine_Buffer.h

I think "package config" is "C- muddle wort" for files of the same name being linked from various options.
Thats wrong.

Fix: Rename your lib files.

AGAIN: buried in mailing lists(SPAM), doesnt use Git bug tracking system. (BULLSHIT)

What they should have done is "fork the sub projects". 
Then forking updates of the forked code is easier.



