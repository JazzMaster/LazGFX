
Hey look! its Object Oriented Pascal.....

Yes- I know I said "I didnt want this"...and here it is.
If you understand why the modelist and palette data are "pointers to the actual data"(in RAM) instead of in the HEAP-

        Youll know why Im looking at the OOP code to be written to replace TCanvas (or run alongside it).

Its just "more efficient" and "less hackish". Im not trying to compete with DOS based code.
Pointers can point to anywhere- disk, ram, etc. (The HEAP is only so big.)

Basically we fall into the following categories(objects) which SDL helps us with:

Core:

        Palettes
        Modelist
        PixelOps

Text
Input
Color Adjustments/Manipulation
Flats:

        Square/Rect
        Circle/Ellipse
        Line
        Tris
        Polys

Usage/Comments/Help:

        Run loops
        RenderingOps

Anything else is not "the BGI", its "an advanced SDL feature"..

**THIS** is the only code that can ever replace TCanvas, as TCanvas is OBJ-Pas code.
As a "alternative routine" "TPainter" is more appropriate and "prevents code collisions".

This pulls from the changes from the Straight and PURE Pascal rouintes and gets updated later as a result.

need to unload TCanvas- if linked or in uses clause -as this code conflicts with it- and does NOT extend it.
(if your mission is to fork this code INTO TCanvas- youa re on your own)






