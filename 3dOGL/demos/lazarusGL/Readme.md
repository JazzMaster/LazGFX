Binaries are built under Linux on Ubuntu18.<br>
(open the lpi in Lazarus and recompile).

dglOpenGL is semi-universal.<br>
GLContext has been tested with windows and Linux.

              The code should work also under OSX (Carbon)

-But I havent tested it yet.

This is the **only working method** for OpenGL under Lazarus that I can get working.

pCrossTest is a DEMO LAzarus (GUI) Application

The lazgfx API will be added as subroutines -to this code- most likely.<br>
I will not be hooking InitGraph or Closegraph functions. <br>
GTK and XGL are too difficult to write code for in these regards.

" uses: Lazgfx"

Im still working on Palettes and "lower bit depths".

-J
