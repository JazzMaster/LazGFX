Unit LazGFX; 
//Range and overflow checks =ON
{$Q+} 
{$R+}

{$IFDEF debug}
//memory tracing only.
	{$S+}
{$ENDIF}

{
A "fully creative rewrite" of the "Borland Graphic Interface" in SDL(and maybe libSVGA) 
(c) 2017-18 (and beyond) Richard Jasmin
-with the assistance of others.

LPGL v2 ONLY. 
You may NOT use a higher version.

Commercial software is allowed- 
 	provided I get the backported changes and modifications(in source format).

I dont care what you use the source code for.

You must cite original authors and sub authors, as appropriate(standard attribution rules).
DO NOT CLAIM THIS CODE AS YOUR OWN and you MAY NOT remove this notice.

---

Although designed "for games programming"..the integration involved by the USE, ABUSE, and REUSE-
of SDL and X11Core/WinAPI(GDI)/Cairo(GTK/GDK)/OpenGL/DirectX highlights so many OS internals its not even funny.

I think this will go in this direction henceforth:

(equivalent SDL2+ support)

	freeGLUT/GL for 2D (QUADS) 
	freeGLUT for 3D (unless there is strong reason to use more detailed routines)


GL by itself doesnt require X11- but it does require some X11 code for "input processing".

It is Linux that is the complex BEAST that needs taming.

}

interface
{
-DONT RUN A LIBRARY..link to it.
-Anonymous C kernel dev (that runs a library)

This is not -and never will be- your program. Sorry, Jim.
RELEASES are stable builds and nothing else is guaranteed. 

The quote that never was- 

"Linus: Dont tell me what to do.
I write CODE for a living. 
Everything is mutable."


We output to Surface(buffer/video buffer) via memcopy operations.


For framebuffer:
	
For now- we settle for a Doom like experience. 
	We start in text mode
	We switch to graphics mode and do something (catch all crashes)
	We drop back to text mode

Im still looking at Quartz seperately. OSX is funky in this regards.	
90% of the routines in the CORE of this unit(not sub units) are setup/destroy of needed structures.

Canvas ops are "mostly universal".
The differences in code are where the surface(Canvas) operations point to and color operations supported.
 
 (a surface is a surface is a surface)
	-For that matter:
			(A texture is a texture is a texture)

INVOKATION:

There are two ways to invoke this unit-
1- with GUI and Lazarus

Project-> Application (kiss writeln() and readln() goodbye)
You can only log output.


2- as a Console Application

In Lazarus: 

Project-> Console App or
Project-> Program

Set Run Parameters:
"Use Launcher" -to enable runwait.sh and console output (otherwise you might not see it)

-This was the old school "compiler output window" in DOS Days.


Within FP application itself(FP IDE):

	-Just dont "uses" anything LCL or related.
	-Write the code normally
	-Check the output window

This method offers Readln() / writeln() 

What you wont get is the LCL and components and nice UI- but we are using SDL/freeGLUT for that.
:-P


-THIS CODE WILL CHECK WHICH IS USED and log accordingly.

---

Theres confusion in SDL:
	SDL 1.2 uses Surface ops
	SDL 2.x builds on Surfaces(you still need them in some cases) and adds Accellerated GPU rendering
		Most ops will switch to Render calls, but not all.
		Function calls were modified between SDL 1 and 2.
		all uses clauses and include files must point to SDL2. You cannot mix 1.2 and 2.x.
		
	SDL2 uses ortho 2D quads and 3D openGl calls.
		
	SDL_GPU isnt really an advanced unit- its optimized unit "utilizing the renderer".
		I inadvertently "half-assed" half the color routines myself.
			Fpc Dev team(more stable codebase based upon Borlands BGI) has the remaining routines.
				These may not be the most optimal routines- they are the most tested.

	So why all of the huff and puff "exquisite C" bullshit?

NOTE:
	Im getting "Lazarus bullshit" as of late....you dont need the LCL!

(createTextureFromSurface must use surface^.format -of chosen bpp- or it could be off)


How to write good games:

SDL1.2 (learn to page flip or animate)
SDL2.0 (renderer and "render to textures as surfaces")
Learn OpenGL or freeGLUT(natively)
CODE!

You need to know:

        event-driven input and rendering loops (forget the console and ReadKEY)

---

If you need to see SDL in action:

	Postal(1) uses SDL.
	Hedgewars uses SDL v1.2.
	Nexiuz and SuperTux uses SDL 2


The difference between an ellipse and a circle is that "an ellipse is corrected for the aspect ratio".
	Circles are "squarely PIE"- or have equal slices of the pie.(Like a rectangle)
	Ellipses do not necessarily- they could be tall, or wide- as well.

FONTS:

    I have some base fonts- most likely your OS has some - but not standardized ones.
    We do NOT use bitmapped fonts- we use TTF.
	8x8 internal routines were based on ANCIENT Video BIOS specs.
		Why cant we use another TTF file- and make it required distribution- instead??
		
	TTF and OTF are the new standard.


This code is Useful when you need VESA modes but cant have them because X11, etc. is running.
This code **should** port or crossplatform build, but no guarantees.

SEMI-"Borland compatible" w modifications.


Lazarus graphics unit is severely lacking...use this instead.


SDL adds mouse and joystick, even haptic/VR feedback support.
This wil be added in if I can find the hooks for it. It is a OpenGL issue as of now.


However, "licensing issues" (Fraunhoffer/MP3 is a cash cow) wreak havoc on us. 
 	-as with qb64 (which also uses SDL)
 	
Yes- I Have a merge tree of qb64 that builds, just ask...


LFB:

Linear Framebuffer is virtually required(OS Drivers). Bank switching has had some isues in DOS.
A lot of code back in the day(20 years ago) was written to use "banks" due to color or VRAM limitations.
The dos mouse was broken due to bank switching (at some point). 
The way around it was to not need bank switching-by using a LFB. 


CGA as implemented here is actually mCGA(pre-VGA 16 color mode).
True CGA is 4plane-4color mode (and its butt ugly).
 
It was designed for early GREEN and ORANGE monitors and 4 color monitors that had some limits.
As such-also due to "ROM bugs", some "yellows" were actually "oranges".

Full compatibilty CGA will require a lot of aspirin and "funky math" as well as code rewrites Im not ready for.
The idea is that the code otherwise works.


THIS CODE is written for 32 AND 64 bit systems.
TP code has a 32bit Overlay-> VM patching unit. 
(I suggest you use it. )

16 Bit systems will have to use code hacks and function relocation definitions as like the original hackish Borland unit used. 
Memory addressing MMU/PMU, etc. allows such things that Borland Pascal does not anymore.


----

It can be assumed that:
	The programmer knows what depth we are in
	At the very least -the current set video mode- has a depth
	

Things to keep in mind:

Data is often stored in 24bits mode, even though it needs to be displayed or manipulated in other modes.

-which means get and put pixel ops, file load and save ops have to take this into account.
Its another necessary nightmare if not using 32bit or paletted 256 modes.

---


Note the HALF-LIFE/POSTAL implementation of SDL(steam):

    start with a window
    set window to FS (hide the window)
    draw to sdl buffer offscreen and/or blit(invisible rendering)
    renderPresent  (making content visible)

this IS the proper workflow.


Most Games use transparency(PNG) for "invisible background" effects.
-While this is true, however, BMPs can also be used w "colorkey values".

Compressed textures use weird bitpacking methods to store data- both on disk, and in VRAM.

-for example:

SDL_BlitSurface (srcSurface,srcrect,dstSurface,dstrect);
SDL_SetColorKey(Mainsurface,SDL_TRUE,DWord);

-Where DWord is the color for the colorkey(greenscreen effect)

PNG can be quantized-
Quantization is not compression- its downgrading the color sheme used in storing the color
and then compensating for it by dithering.(Some 3D math algorithms are used.)
(Beyond the scope of this code)

PNG itself may or may not work as intended with a black color as a "hole".This is a known SDL issue.
PNG-Lite may come to the rescue- but I need the Pascal headers, not the C ones.


Not all games use a full 256-color (64x64) palette, even today.

This is even noted in SkyLander games lately with Activision.
"Bright happy cheery" Games use colors that are often "limited palettes" in use.

Most older games clear either VRAM or RAM while running (cheat) to accomplish most effects.
        RenderClear() -accomplishes this

Most FADE TO BLACK arent just visuals, they clear VRAM in the process.

Fading is easy- taking away and adding color---not so much.
However- its not impossible.

    you need two palettes for each color  :-)  and you need to step the colors used between the two values
    switching all colors (or each individual color) straight to grey wont work- the entire image would go grey.
    you want gracefully delayed steps(and block user input while doing it) over the course of nano-seconds.



Color Modes:

BPP 	 COLORS						RGB value
4		(16) 						NA (hacked in bit based RGBI)
8		(256) 						111

15		(32768) "thousands" 		- no alpha 555 /(16384 colors w alpha) 5551
16		(65536) "thousands" 		-(w alpha and 32K colors -5551) or (wo alpha -565)

24		(16,777,216) 				-TRUE COLOR mode "millions" - no alpha 888
32		(4,294,967,296) 			--(TRUE COLOR(24) plus full alpha-bit) 8888

Not yet supported:

30		(1,073,741,824) 			--DEEP color "billions" 10:10:10
32		4 Bil						10:10:10:2
36		(68,719,476,736) 			--DEEP color 12:12:12
48		(281,474,976,710,656) 		--VERY DEEP color "trillions" 12:12:12:12??

64      ????						16:16:16:16??

Common Resolutions:

RES							BPP Supported
320x200 					4/8bpp
320x240 					4/8bpp

640x480 					4/8/16bpp
800x600 					4/8/16bpp

1024x768 					8/16/24bpp
FlatPanels(1366x768)		8/16/24bpp

720p(1280x720)				8/16/24bpp
1366x768  					8/16/24bpp/32?
1280x1024 					8/16/24bpp/32?
1080p(1920x1080) 			8/16/24bpp/32?

These are weird: (its 4K but not 4K...)
2k (3840x2160)  			8/16/24bpp


Not Supported(SDL Limit):
4k (7680x4320) 				8/16/24/30/36bpp
8k (?? x ??)                8/16/24/30/36/48


I havent added in Android or MacOS modes yet.
You cant support portable Apple devices. Apple forbids it w FPC.

---

**CORE EFFICIENCY FAILURE**:

Pixel rendering (the old school methods)

We have to "lock pixels" to work with them, then "unlock pixels" and "pageFlip". 
Texture rendering(SDL2) uses the VRAM for ops -whereby SDL1 uses RAM and CPU(Surfaces).

rendering is a one-way street, however.

Our ops are restricted, even yet to "pixels" and not groups of them.
TandL is a "pixel-based operation".


MessageBox:

With Working messageBox(es) we dont need the console.
You can choose the color scheme and input methods- YES/NO, OK...

Lazarus Dialogs are only substituted IF LCL is loaded. 
(TVision routines wouldnt make sense, use GVision instead if you like)

GVision, routines can now be used where they could not before.
GVision requires Graphics modes(provided here) and TVision routines be present(or similar ones written).
FPC team is refusing to fix TVision bugs. 

        This is wrong.

LOGS:

Some idiot wrote the logging  code wrong and it needs to be updated for FILE STREAM IO.
I havent done this yet.

Logging will be forced in the folowing conditions:

    under windows or linux with LCL
    user flips the logging bit


Code upgraded from the following:

	original *VERY FLAWED* port (in C) coutesy: Faraz Shahbazker <faraz_ms@rediffmail.com>
	unfinished port (from go32v2 in FPC) courtesy: Evgeniy Ivanov <lolkaantimat@gmail.com> 
	some early and or unfinished FPK (FPC) and LCL graphics unit sources 
	SDLUtils(Get/PutPixel) SDL v1.2+ -in Pascal
    JEDI SDL headers(unfinished) and in some places- not needed.
    StackExchange SDL examples in C/CPP 

    libSVGA Lazarus wiki found here: http://wiki.lazarus.freepascal.org/svgalib
    libSVGA in C: http://www.svgalib.org/jay/beginners_guide/beginners_guide.html

manuals:
    SDL1.2 pdf
    Borland BGI documentation by QUE Publishing ISBN 0880224290
    TCanvas LCL Documentation (different implementation of a 'SDL_screen') 
    Lazarus Programming by Blaise Pascal Magazine ISBN 9789490968021 
    Getting started w Lazarus and FP ISBN 9781507632529
    JEDI chm file
	TurboVision(TVision) references (where I can find them and understand them.)

	mesa docs
	GLU docs
	OpenGL docs
	GLUT docs
	freeGLUT docs

NOTE: All visual rendering routines are 'far calls' if you insist building for DOS.
(I really cant help you if you do, but dont drop 32+ cpu support. I will merge the code if you fork it, however.)


to animate- screen savers, etc...you need to (page)flip/rendercopy and slow down rendering timers.
(trust me, this works-Ive written some soon-to-be-here demos)


bounds:
   cap pixels at viewport
   off screen..gets ignored but should throw an error- we should know screen bounds.
   (zoom in or out of a bitmap- but dont exceed bounds.) 


on 2d games...you are effectively preloading the fore and aft areas on the 'level' like mario.
there are ways to reduce flickering -control the amount of calls to renderClear() and RenderPresent(). 


Palettes:

   These are mostly standardized now.
   Max colors in a palette are always 256, unless in modified CGA modes- then 16. 
   Specify each DWORD value or leave it as a zero
  
  Note "the holes" can be used for overlay areas onscreen when stacking layers.
  The holes are standardized to xterm specs. I think theres like 5.

Im seeing a Ton of correlation between OGL/SDL and DirectX/DirectDraw (and people think there isnt any).


WONTFIX:

"Rendering onto more than one window (or renderer) can cause issues"
"You must render in the same window that handles input"

Converstion note:
SDL routines require more than just dropping a routine in here- 
    you have to know how the original routine wants the data-
        get it in the right format
        call the routine
        and if needed-catch errors.

SDL is not SIMPLE. 
The BGI was SIMPLE.

 --Jazz (comments -and code- by me unless otherwise noted)

TODO:

input:
	rely less on SDL and more on GL/freeGLUT operations(simpler)
	 
	
finish implementation of "if Render3D":

	all functions need OpenGL modifications
	RenderCopy ->  glSwapBuffers
	
	2d functions:
		surface ops with OUR INTERNAL screen buffer.(SDL_Surface doesnt exist)

	3d functions:
		no surface, no texture, no renderer, no "direct renderer" code
		(implement these in GL/GLUT)
	
	all color ops need mods for OpenGL(update from surface to texture ops)
	need to implement "format agnostic" color conversion with all bpp depths
		("depth" in OGL is considered cubic depth, not bpp)
		
	RECOMPILE(2.0)!!!
} 


uses
{
Threads and fpfork(forking), requires baseunix unit
cthreads has to be the first unit -in this case-we so happen to support the C version.

ctypes: cint,uint,PTRUint,PTR-USINT,sint...etc.
unless you want to rewrite someone elses C, use this.


There is a way to use SDL timers, signals and threads. 
  _type is used instead of the reserved word 'type'

}

//this Logic is weirdly (prove a negative) here. 
//while you cant prove a negative- you can "not prove" a positive

//cthreads and cmem have to be first.
{$IFDEF unix} 
	cthreads,cmem,baseunix, X, XLib,sysUtils,
	 {$IFNDEF fallback} //fallback uses XCorePrim only, otherwise keep loading libs
		Classes,GL,GLext, GLU,
		//probly cairo and pango too at this point.
	 {$ENDIF}
{$ENDIF}
 
    ctypes,
        
//This logic is normal
{$IFDEF MSWINDOWS} //as if theres a non-MS WINDOWS?
	 {$IFDEF fallback}
		WinAPI,
	 {$endif}
     Windows,
     //MMsystem, --audio subsystem does uos need this?
     {$IFNDEF LCL} //conio apps only
		crt,crtstuff,
     {$ENDIF}
{$ENDIF}

// A hackish trick...test if LCL unit(s) are loaded or linked in, then adjust.
//Most likely youre using one of these.

//LCL(Lazarus) wont fire unless Windows or X11 or Darwin(Quartz) are active.
//its such BS that framebuffer/XTerm routines were never written and everyone assumes X11
//is fired instead.

{

//messageDlg requires a result (if x=y, then..) 	


//MIM joke...
function AskMessagewButtonAnswer(title,question:string):Longint;
begin
  AskMessagewButtonAnswer:=longint(MessageDlg(title, question, mtConfirmation, [mbYes, mbNo,mbMaybe, mbRepeatTheQuestion],0));
end;

//(asking for strings and passwords is also possible)

endif
}

  {$IFDEF LCL}
	{$IFDEF LCLGTK2}
		gtk2,
	{$ENDIF}

	{$IFDEF LCLQT}
		qtwidgets,
	{$ENDIF}  
  
	  //works on Linux+Qt but not windows??? I have WINE and a VM- lets figure it out.
      LazUtils,  Interfaces, Dialogs, LCLType,Forms,Controls, 
    {$IFDEF MSWINDOWS}
       //we will check if this is set later.
      {$DEFINE NOCONSOLE }
      logger,
	{$ELSE }  
    {$IFDEF unix}
    //UNIX
    
      //LCL is linked in but we are not in windows.
      //remember Lazarus by itself doesnt output debugging windows. 
      //you have to enable this yourself.

      //we still technically DO have a console- even a GUI app can be launched from the commandline.
      //output then goes THERE-instead of the Lazarus equivalent.
      //THIS TRICK DOES NOT WORK on Windows. Windows removes crt and related units when building a UI app.
      crt,crtstuff,logger,
    {$ENDIF}
  {$ENDIF}


{
Lazarus Menu:  
	"View" menu, under "Debug Windows" there is an entry for a "console output" 

however, if you are in a input loop or waiting for keypress- 
 you will not get output until your program is complete (and has stopped execution)


In this case- Lazarus Menu:   
Run -> Run Parameters, then check the box for "Use launching application".
(You may have to 'chmod +x' that script.)


To build without the LCL(in Lazarus):

 Just make a normal "most basic" program and call me or SDL directly in your "uses clause".

 You will find that the LCL may be a burden or get in your way- 
	we dont really use the fundamentals of OBJFPC, OBJPAS, or Lazarus beyond basic functions.

}

//FPC generic units(OS independent)

  uoslib_h,strings,typinfo,
  
// uos/Examples/lib folder has the required libraries for you. 
// as a side-effect: CDROM Audio playback(CDDA) is added back


{$IFDEF debug} ,heaptrc {$ENDIF} 

{
OpenGL requires Quartz, which prevents building below OSX 10.2.

direct rendering onto the renderer uses QuartzGL(on OSX up to Mtn LN- it wont stay active once set)
Cocoa (OBJ-C) is the new API
}


{$IFDEF darwin}
	{$linkframework Cocoa}
	{$linkframework OpenGL}
	{$linkframework GLUT}


//you have to install fpc thru XCode and build a demo to patch this line.

//	{$linklib gcc} -REAL pascal doesnt use C. There is a dialect that does.
// apparently some programmers see C as a religion...they want to convert everyone to it.

//also requires:
//mode objpas + classes uses clause (in every pascal unit)
//modeswitch objectivec2

//iFruits, iTVs, etc:
// {linkframework CocoaTouch} -- but go kick apple in the ass for not letting us link to it.
// not legally, anyway....

{$ENDIF}


//Altogether- we are talking PCs running OSX, Windows(down to XP), and most unices.
//and Some android and RasPi ( thru GL-ES)

//do not remove the following semi-colon
;


{
NOTES on units used:

crt is a failsafe "ncurses-ish"....output...
crtstuff is MY enhanced dialog unit 
    I will be porting this and maybe more to the graphics routines in this unit.


mutex(es):

The idea is to talk when you have the rubber chicken or to request it or wait until others are done.
Ideally you would mutex events and process them like cpu interrupts- one at a time.

-Moreso for the event handler-
(creating a window apparently trips like 5 events??)


sephamores are like using a loo in a castle- 
only so many can do it at once. 
	first come- first served
		- but theres more than one toilet

}

//share the main unit headers for the expanded units

{$INCLUDE lazgfx.inc}

//break up sub units
{$INCLUDE palettesh.inc}
{$INCLUDE modelisth.inc}

//color conversion procs etc...taking up waay too much room in here...
//this will need modification since we should know the surface bpp set- or at least the output bpp
//(we dont need SDLv1 surface bpp checks)

{$INCLUDE colormodsh.inc}


implementation

{$INCLUDE palettes.inc}
{$INCLUDE modelist.inc}
{$INCLUDE colormods.inc}

//Get and MapRGB/RGBA in a nutshell

{
caveat: 15/16/24 bit color has no A value. 
in 256 color mode we set the palette assuming a 32bit full DWord.
in reality colors are 00-FF. we have simulate based on 32 bit colors- as there is no data for the old modes.

problem with 15/16 color modes(or similar 3:3:2 modes-) how do we tell if the color is out of range?
WE have to establish the params- not guess at them.

24 is the easiest- with the SDL_Color array. All color bytes, and no Alpha-bit.
-As long as we deal with RGBA values(or RGB,A=255) or DWords -we are ok.

}

{$IFDEF mswindows}
//Win only routines

function IsVistaOrGreater: Boolean;
begin
   IsWindows7:= (Win32MajorVersion => 6) or ((Win32MajorVersion = 6) and (Win32MinorVersion => 1));
end;

//if NOT- DONT USE ANYTHING HERE- OpenGL isnt supported at min version needed.
function IsWindowsXP: Boolean;
begin
 IsWindowsXP:=((Win32MajorVersion = 5) and (Win32MinorVersion >= 1));
end;

{$endif}


{
//FIXME:
	finish the OPENGL gaps before replacing this code
    (some of this code is extremely difficult to implement- and spans over 20 years missing)


//16 (candles) colors:

//background color(and clear):
glClearColor(0.0, 0.0, 0.0, 0.0); 
glClear(GL_COLOR_BUFFER_BIT);

//foreground color
glColor4b(color^.r,color^.b,color^.g,255);

//three-quarter tone
glColor4b(color^.r,color^.b,color^.g,192);

//half-tone
glColor4b(color^.r,color^.b,color^.g,127);

//quarter-tone
glColor4b(color^.r,color^.b,color^.g,63);


//set size of the pixel(draw w neighbors)
glPointSize(1);

//FAT lines, anyone?
glLineWidth(4);

//Dashed(stippled lines!!!!

glLineStipple(1, 0x3F07);
glEnable(GL_LINE_STIPPLE);

//FAT and stippled can be combined


---

//GLUT input:

procedure MouseButton(button, state, x, y:integer);
begin
//REM OUT
  // Respond to mouse button presses.
  // If button1 pressed, mark this state so we know in motion function.

  if (button = GLUT_LEFT_BUTTON) then
    begin
      g_bButton1Down := TRUE then
		state := GLUT_DOWN;
      else 
		state:=GLUT_UP;
      g_yClick := y - (3 * g_fViewDistance);
    end;

end;

procedure MouseMotion(x,y:integer);
begin
//REM OUT
  // If button1 pressed, zoom in/out if mouse is moved up/down.

  if (g_bButton1Down) then
    begin
      g_fViewDistance := (y - g_yClick) / 3.0;
      if (g_fViewDistance < VIEWING_DISTANCE_MIN) then
         g_fViewDistance := VIEWING_DISTANCE_MIN;
      glutPostRedisplay();
    end;

end;

--
//GLOpts:

var
  PixelData,mypixels:array [MaxX,MaxY] of SDL_Color; //4byte array (pixel) for sizeof(screen)
  pixels15,pixels16:array [MaxX,MaxY] of word; //Word=2bytes(16 bits) of data
  maxTextureSize:integer;


//bytes are too small for screen co-ords
procedure DrawGLRect(x1,y1,x2,y2:Word);
	glRecti(x1, y1, x2,y2);
end;

procedure DrawGLRect(Rect:PSDL_Rect); overload;
	glRecti(Rect^.x1, Rect^.y1, Rect^.x2,Rect^.y2);
end;


//gen and renderTex:
glGenTextures (1, texID);
glBindTextures (GL_TEXTURE_RECTANGLE, texID);


if bpp =32 then
	glTexImage2D (GL_TEXTURE_RECTANGLE, 0, GL_RGBA, MaxX, MaxY, 0, GL_RGBA, GL_UNSIGNED_INT_8_8_8_8, frame);

//make a QUAD
glBegin (GL_QUADS);
	glTexCoord2f (0, 0);
	glVertex2f (0, 0);

	glTexCoord2f (640, 0);
	glVertex2f (windowWidth, 0);

	glTexCoord2f (640, 480);
	glVertex2f (windowWidth, windowHeight);

	glTexCoord2f (0, 480);
	glVertex2f (0, windowHeight);
glEnd();

//draw(slow)
GLDrawPixels(1,1,GL_RGBA,GL_UNSIGNED_INT_8_8_8_8_REV,PSDL_Color);

//similar to SDL_GetPixels

function readpixels:(x,y,width,height:integer; Texture:textureID):somePixelData;
//fucked C output- so lets un-fuck it.
begin
  case (bpp) of: 

    //palettized (faked) 24bit
	4: glReadPixels(0, 0, width, height, GL_RGB, GL_BYTE, mypixels);  
	8: glReadPixels(0, 0, width, height, GL_RGB, GL_BYTE, mypixels);  

	15:glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_5_5_1, pixels15);
	16: glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, pixels16);

	//No upconversion.Settle for 32bit data(24+pad data).
	24: begin
			glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
			glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_BYTE, mypixels);  

		end;
    32: glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, mypixels);
  end;
  readpixels:=??
end;

//co-ordinates: update texture, update rect, or update screen?

procedure UpdateRect(x,y,width,height:integer; Texture:textureID; pixels:PixelData);
//remember SDlv1 updateRect? This is it - in OpenGL.
//only update modified pixels


begin
    //check for rubbish
    if (height <=0) or (width <=0) then begin
		LogLn('Invalid HxW data given for Texture update');
		exit;
    end;
    if (x <0) or (y <0) then begin
		LogLn('Invalid XxY data given for Texture update');
		exit;
    end;

  glBindTexture(GL_TEXTURE_2D, texture);    //A texture you have already created storage for

  case (bpp) of:
    //faked RGB modes(24bits colors) w palettes
	4: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_BYTE, pixels);
	8: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_BYTE, pixels);

//hacked 16bit support wo alpha 

	15: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_UNSIGNED_SHORT_5_5_5_1, pixels15);
	16: glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB565,  GL_UNSIGNED_SHORT_5_6_5, pixels16);

//the tuple...
	24:	glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGB, GL_UNSIGNED_BYTE, pixels);

	32: begin
			{$ifdef mswindows}
				glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
			{$else}
				glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_ARGB, GL_UNSIGNED_BYTE, pixels);
			{$endif}
		end;
   end; //case
end;
---

//color ops:
//theres no need to query what depth/bpp we are in- we should know.

//the tricky part may be in reading pixels back from OGL/SDL 
//-and converting the output to the format we want.

//"textures may not contain the color mode set"....(SDL)

//15bit is 5551 but the alpha bit is ignored/dropped. (OGL sanity fix)

type

	PRGB=^TRGB;
	TRGB=record
		r,g,b:Byte;
	end;

//4bit=8bit but less colors.
//4 and 8bit routines(palette) -and look up tables- have been written already.

// for 32-> 15/16 routines, drop the A bit completely. Then run one of these. 

//(24bit RGB->15bits hex):
procedure RGB24To15bit(in:TRGB; out:PRGB);
begin
        out^.r := in.r * (2 shl 5) / (2 shl 8);
        out^.g := in.g * (2 shl 5) / (2 shl 8);
        out^.b := in.b * (2 shl 5) / (2 shl 8);
end;

procedure RGB24To16bit(in:TRGB; out:PRGB);
begin
        out^.r := in.r * (2 shl 5) / (2 shl 8);
        out^.g := in.g * (2 shl 6) / (2 shl 8);
        out^.b := in.b * (2 shl 5) / (2 shl 8);
end;


}

//Convert an array of four bytes into a 32-bit DWord/LongWord.

function  getDwordFromSDLColor(someColor:PSDL_Color):DWord;

begin
//array of 4 bytes or dword
//(theres a simpler way to do endian flappening)

//LE
    getDwordFromBytes:= (somecolor.^r) or (somecolor.^g shl 8) or (somecolor.^b shl 16) or (somecolor.^a shl 24);
//BE
  // getDwordFromBytes:= (somecolor.^a) or (somecolor.^b shl 8) or (somecolor.^g shl 16) or (somecolor.^r shl 24);
end;

//in case we didnt use the SDL Color array--WHY?
function  getDwordFromBytes(r,g,b,a:Byte):DWord;

begin
//LE
    getDwordFromBytes:= (r) or (g shl 8) or (b shl 16) or (a shl 24);
//BE
  // getDwordFromBytes:= (a) or (b shl 8) or (g shl 16) or (r shl 24);
end;

//where do the bytes go? into a record. (the data goes out-to where?--we dont care...)
function GetByesfromDWord(someD:DWord):SDL_Color;

var
	someDPtr:Pointer;
    someColor:PSDL_Color;
    
begin
    someDPtr:=Nil;
    someDPtr:^someD;
//LE
	r:=someDPtr^;
	g:=someDPtr^[1];
	b:=someDPtr^[2];
	a:=someDPtr^[3];

{
//BE
	a:=someDPtr^;
	r:=someDPtr^[1];
	g:=someDPtr^[2];
	b:=someDPtr^[3];
}
   somecolor^.r:=byte(^r);
   somecolor^.g:=byte(^g);
   somecolor^.b:=byte(^b);
   somecolor^.a:=byte(^a);

end;


{
SERIOUS FIXME: any pointer used must be =NIL before assignment

**DO NOT BLINDLY ALLOW any function to be called arbitrarily.**
(this was done in C- I removed the checks for a short while)

two exceptions:

	making a 16 or 256 palette and/or modelist file


NET:
	init and teardown need to be added here- I havent gotten to that.
	(I was trying to find viable non-C,non-SDL Net code)

CLipping:
	we always clip.  PERIOD.
}
 


Procedure SetViewPort(X1, Y1, X2, Y2: smallint);
Begin
   if not GRAPHICSENABLED then exit;
   //this doesnt check bounds of existing viewports
  if (X1 > MaxX) or (X2 > MaxX) or (X1 > X2) or (X1 < 0)  or (Y1 > MaxY) or (Y2 > MaxY) or (Y1 > Y2) or (Y1 < 0) then
  Begin
    if IsConsoleInvoked then begin
		logln('invalid viewport parameters: ('+strf(x1)+','+strf(y1)+'), ('+strf(x2)+','+strf(y2)+')');
		
		logln('maxx = '+strf(maxx)+', maxy = '+strf(maxy));
    end else begin
       {$ifdef lcl}
			ShowMessage('Invalid viewport parameters. Resetting to defaults.');
	   {$endif}
	   //in case you do something stupid later on.
	   X1:=0;
	   Y1:=0;
	   X2:=MaxX;
	   Y2:=MaxY;
       exit;
    end;   
  end;

  // sets the RECT- doesnt do anything with it. 
  StartXViewPort := X1;
  StartYViewPort := Y1;
  ViewWidth :=  X2-X1;
  ViewHeight:=  Y2-Y1;
   
  //add viewport array code so we can remove screen 'contents' later on
  
end;

procedure GetViewSettings(var viewport : ViewPortType);
begin
  ViewPort.X1 := StartXViewPort;
  ViewPort.Y1 := StartYViewPort;
  ViewPort.X2 := ViewWidth + StartXViewPort;
  ViewPort.Y2 := ViewHeight + StartYViewPort;
end;
 

  procedure SetAspectRatio(Xasp, Yasp : word);
  begin
    Xaspect:= XAsp;
    YAspect:= YAsp;
    //fix the SDL/freeglut variables for display output,then...

    //redraw the screen(or wait)
  end;


  procedure SetWriteMode(WriteMode : smallint);
  // TP sets the writemodes according to the following scheme (Jonas Maebe) 
   begin
     Case writemode of
       //for each pixel in surface.^pixels do:
       //put pixel according to mode, update surface
       
       xorput, andput: CurrentWriteMode := XorPut;
       orput, copyput: CurrentWriteMode := CopyPut;
       //'Not' is atypical for unixes. (not properly implemented)
       //1- inverted color ((MaxColors mod 2) -1) 
       //2- background color instead of fore color(erase mode)
       notput: CurrentWriteMode := NotPut;
     End;
     //until reset- use the mode given.
   end;


//this was ported from (SDL) C- 
//https://stackoverflow.com/questions/37978149/sdl1-sdl2-resolution-list-building-with-a-custom-screen-mode-class

function FetchModeList:Tmodelist;
var
    mode_index,modes_count ,display_index,display_count:integer;
    i:integer;


begin
   display_count := SDL_GetNumVideoDisplays; //1->display0
   LogLn('Number of displays: '+ intTOstr(display_count));
   display_index := 0;

//for each monitor do..
while  (display_index <= display_count) do begin
    LogLn('Display: '+intTOstr(display_index));

    modes_count := SDL_GetNumDisplayModes(display_index); //max number of supported modes
    mode_index:= 0;
    i:=0;

    //do for each mode in the number of possible modes
    while ( mode_index <= modes_count ) do begin

        SDLmodePointer^.format:= SDL_PIXELFORMAT_UNKNOWN;
        SDLmodePointer^.w:= 0;
        SDLmodePointer^.h:= 0;
        SDLmodePointer^.refresh_rate:= 0;
        SDLmodePointer^.driverdata:= Nil;


        if (SDL_GetDisplayMode(display_index, mode_index, SDLmodePointer) = 0) then begin //mode supported

            //Log: pixelFormat(bpp)MaxX,MaXy,refrsh_rate            
            LogLn(IntToStr(SDL_BITSPERPIXEL(SDLmodePointer^.format))+' bpp'+ IntToStr(SDLmodePointer^.w)+ ' x '+IntToStr(SDLmodePointer^.h)+ '@ '+IntToStr(SDLmodePointer^.refresh_rate)+' Hz ');

            //store data in a modeList array

                SDLmodeArray[i].format:=SDL_BITSPERPIXEL(SDLmodePointer^.format);            
                SDLmodeArray[i].w:=SDLmodePointer^.w;                
                SDLmodeArray[i].h:=SDLmodePointer^.h;                
                SDLmodeArray[i].refresh_rate:=SDLmodePointer^.refresh_rate;                
                SDLmodeArray[i].driverdata:=SDLmodePointer^.driverdata;

        end;
        inc(i);
        inc(mode_index);
    end;
    inc(display_index);
    
end;

end;

{

Graphics detection is a wonky process.
1- fetch (or find) whats supported
2- find highest mode in that list
3- use it, or try to.

repeat num 2 and 3 if you fail- until no modes work


I was THIS mode, and none other- it had better be supported (but is it?)
(try or fail)


Although generally in SDL(and on hardware) smaller windows and color depths are supported(emulation),
SDL -by itself- might not support that mode.


Do we care- as mostly we are setting windows sizes? Not usually.
WE could care less if the data is scaled on fullsceen-since we arent responsible for the scaling

(whether things look good- is another matter)

A TON of old code was written when pixels were actually visible. NOT THE CASE, anymore.


DetectGraph is here more for compatibility than anything else.
It seems to be used as often as DEFINED modes.

-Custom modes are usually hackish and were removed.

Interrupt handling:

The reason this is remmed out is bc I want YOu to do this.
The code is however-reasonable- but untested.

}


//  Load a set of mappings from a file.
procedure GameControllerAddMappingsFromFile(FilePath:string);
begin
	//open file for reading
	//read into some record
    //close file

//log any errors
end;

//you pass the array, or direct co ordinates in.
function WindowPos_IsUndefined(WindowData:PSDL_Rect): boolean;
//basically these settings violate bounds.
begin
	WindowPos_IsUndefined:=((WindowData^.x<1) or (WindowData^.y<1) or (WindowData^.h<1) or (WindowData^.h>MaxY) or (WindowData^.w<1) or (WindowData^.w>MaxX)
	or (WindowData.x=Nil) or (WindowData.y=Nil) or (WindowData.h=Nil) or (WindowData.w=Nil));
end;

//I actually compute this for text positioning, inside the window.
function WindowPos_IsCentered(WindowData:PSDL_Rect): boolean;
begin
  //something like this
  WindowPos_IsCentered := (((WindowData.x mod 2)=MaxX mod 2) and ((WindowData.y mod 2)=MaxY mod 2));
end;


//accellerated rendering requires locked surfaces? Lets see.
function SDL_MUSTLOCK(Const S:PSDL_Surface):Boolean;
begin
  SDL_MUSTLOCK := ((S^.flags and SDL_RLEACCEL) <> 0);
  if SDL_MUSTLOCK:=true then logLn('need to lock surface');
end;

procedure IntHandler;
//This is a dummy routine.

//I want you- Users/programmers to override this routine and DO THINGS RIGHT.

//with freeGLUT - we may not have to fork. It knows to call us. AND kill us.
var
   MoonOrange:boolean;

begin
  EventThread:=fpfork; 
  
  if (EventThread=0) then begin //we didnt fpfork....
     if IsConsoleInvoked then begin
        Logln('EPIC FAILURE: SDL requires multiprocessing. I cant seem to fpfork. ');
        closegraph;
     end;
       {$ifdef lcl}
			ShowMessage('EPIC FAILURE: Cant fork. I need to. CRITICAL ERROR.');
	   {$endif}
      closegraph;
  end;

    MoonOrange:=false;
    repeat
      delay(1000);

{ 
this is how to do it- 
//FIXME: needs freeGLUT mod

var
      kbhit,GetString,quit,echo:boolean;
      GetChar,c:char;
      event:SDL_Event;
	  somestring:string;
      i:integer;

//Readkey,KeyPressedm and ReadString combo with one handler.

	if ((SDL_PollEvent( event ) <> Nil) and (event^._type = SDL_KEYDOWN))) then begin
        SDL_PushEvent(event);
	    kbhit:=true;

	  case( event.type ) of
	  SDL_KEYDOWN:
	    c=event.key.keysym.sym;
	    if (isprint(c)) then begin  
	      i:=0;
          if GetString=true then begin
              repeat 
                somestring[i]:=c;
                inc(i);
              until (c=SDLK_RETURN) or (i=len(somestring));
          end else begin
             GetChar:=c;    
          end;
        end; //Is printable char
            
	    exit;
      end;
	  SDL_ACTIVEEVENT:
	//    if ((event.active.state = SDL_APPINPUTFOCUS) and event.active.gain) then
	      //resume
	    break;
	  SDL_QUIT:
	    MoonOrange := true;
	    exit;
	  else:
	    //SDL_PushEvent(event); or
		//SDL_WaitEVent(0);
	    exit;
	  end else begin
	    SDL_WaitEvent(0);
	  end;
    end;

}

    until MoonOrange=true;
    //exit gracefully.
end;

// from wikipedia(untested)
procedure RoughSteinbergDither(filename,filename2:string);

var
	pixel:array[0..1280,0..1024] of DWord;
	oldpixel,newpixel,quant_error:DWord;
	file1,file2:file;
    Buf : Array[1..4096] of byte;
    

begin
    assign(file1,filename); 
    assign(file2,filename2); 
  
    blockread(file1,buf,sizeof(file));

  while Y<MaxY do begin
	 while x<MaxX do begin

      oldpixel  := pixel[x,y];
      newpixel  := round(oldpixel mod 256);
      pixel[x,y]  := newpixel;
      quant_error  := oldpixel - newpixel;

      pixel[x + 1,y]:= longword(pixel[x + 1,y] + quant_error * 7 mod 16);
      pixel[x - 1,y + 1] := longword(pixel[x - 1,y + 1] + quant_error * 3 mod 16);
      pixel[x,y + 1] := longword(pixel[x,y + 1] + quant_error * 5 mod 16);
      pixel[x + 1,y + 1] := longword(pixel[x + 1,y + 1] + quant_error * 1 mod 16);

    end;
   end;
     blockwrite(file2,buf,sizeof(file));

     close(file1);
	 close(file2);
end;


{

Got weird fucked up c boolean evals? (JEEZ theyre a BITCH to understand....)
  wonky "what ? (eh vs uh) : something" ===> if (evaluation) then (= to this) else (equal to that)
(usually a boolean eval with a byte input- an overflow disaster waiting to happen)

for example: 
	SDL_SetRenderDrawBlend(renderer, (a = 255) ? SDL_BLEND_NONE : SDL_BLEND_BLEND);

}


{
Create a new texture for most ops-or DO NOT call RenderCopy(or unlock),meaning that rendering is NOT done yet.

RenderPresent is being called automatically at minimum (screen_refresh) as an interval.
Refresh is fine if data is in the backbuffer. Until its copied into the main buffer- its never displayed.

DO NOT use TextureLocking functions/procs if using Render based ops- they may do this automagically.
(Texture is only a context if using "surface opertions on a Texture" )


which surface/texture do we lock/unlock??
solve for X -by providing it. dont beat your own brains out nuking the problem.

unfortunately- a texture -based SDL2 only solution "nukes the problem".
Methinks it twas an intermediary drawing method for those routines not converted to Render calls.

Therefore surface ops-need to be added back in(or still used)

}

//dont render Present(page_Flip) while a surface is locked for operations.(PAUSE rendering)
//we could be presented with a situation that causes an issue where locked surfaces are forced onto the screen
// with potentially no way to unlock them.
//This may create a "double free error"-or the like.

procedure lock;
begin
    if SDL_MustLock(MainSurface)=true then
        SDL_LockSurface(Mainsurface);
    //else exit: no locking needed
    paused:=true;
end;


procedure unlock;
begin
    if SDL_MustLock(MainSurface)=true then
           SDL_UnlockSurface(Mainsurface);
    //else exit: no UNlocking needed
    paused:=false;
end;

//depending if "MainSurface" isnt what you want.
procedure lock(someSurface:PSDL_Surface); overload;
begin
    if SDL_MustLock(someSurface)=true then
        SDL_LockSurface(someSurface);
    //else exit: no locking needed
    paused:=true;
end;


procedure unlock(someSurface:PSDL_Surface); overload;
begin
    if SDL_MustLock(someSurface)=true then
           SDL_UnlockSurface(someSurface);
    //else exit: no UNlocking needed
    paused:=false;
end;

//Texture locking thru OGL on Unices is unpredictable.
//Use "direct Render ops" or SDL 1.2 methods instead.
procedure Texlock(Tex:PSDL_Texture);

var
  w,h:PInt;
  pitch:integer;
  pixels:^longword;

begin
  pixels:=Nil;
  pitch:=0;
  if (LIBGRAPHICS_ACTIVE=false) then begin
    Logln('I cant lock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
  if (Tex = Nil) then begin
     if IsConsoleInvoked then
        LogLn('Cant Lock unassigned Texture');
     {$ifdef lcl}
			ShowMessage('Cannot Lock an unassigned Texture.');
	 {$endif}   
     exit;
  end;
  paused:=true;
//  SDL_QueryTexture(tex, format, Nil, w, h);
  SDL_SetRenderTarget(renderer, tex);

{$IFDEF mswindows}
  SDL_LockTexture(tex,Nil,pixels,pitch);
{$ENDIF}

end;

procedure TexlockwRect(Tex:PSDL_Texture; Rect:PSDL_Rect);

var
  w,h,pitch:integer;
  pixels:^longword;

begin
  if (LIBGRAPHICS_ACTIVE=false) then begin
    Logln('I cant lock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
  if (Tex = Nil) then begin
     if IsConsoleInvoked then
        LogLn('Cant Lock unassigned Texture');
     {$ifdef lcl}
			ShowMessage('Cannot Lock an unassigned Texture.');
	 {$endif}   
     exit;
  end;
  paused:=true;
//  SDL_QueryTexture(tex, format, rect, w, h);
  SDL_SetRenderTarget(renderer, tex);
{$IFDEF mswindows}
  SDL_LockTexture(tex,Nil,pixels,pitch);
{$ENDIF}
end;

function lockNewTexture:PSDL_Texture;

var
  tex:PSDL_Texture;

begin
  if (LIBGRAPHICS_ACTIVE=false) then begin
    Logln('I cant lock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
//case bpp of... sets PixelFormat(forcibly)
  Paused:=true;
  tex:=Nil; //if we dont clear it before calling, results are unpredictable.
  tex:= SDL_CreateTexture(renderer, format, SDL_TEXTUREACCESS_TARGET, MaxX, MaxY);
  if (tex = Nil) then begin
     if IsConsoleInvoked then
		
        LogLn('Cant Allocate Texture');
     {$ifdef lcl}
			ShowMessage('Cannot Allocate Texture.');
	 {$endif}   

     exit;
  end;
//  SDL_QueryTexture(tex, format, Nil, w, h);
  SDL_SetRenderTarget(renderer, tex);
{$IFDEF mswindows}
  SDL_LockTexture(tex,Nil,pixels,pitch);
{$ENDIF}
  lockNewTexture:=Tex; //kick it back
end;

//call when done drawing pixels
procedure TexUnlock(Tex:PSDL_Texture);

begin

  if (LIBGRAPHICS_ACTIVE=false) then begin
    Logln('I cant unlock a Texture if we are not active: Call initgraph first');
    exit;    
  end;
{$IFDEF mswindows}
    //we are done playing with pixels so....
    SDL_UnLockTexture(tex);
{$ENDIF}

//get stuff ready for the renderer and render.
  SDL_SetRenderTarget(renderer, NiL);
  SDL_RenderCopy(renderer, tex, NiL, NiL);
  SDL_DestroyTexture(tex); 
  Paused:=false;
end;

//BGI spec
procedure clearDevice;

begin
    if LIBGRAPHICS_ACTIVE=true then
		SDL_RenderClear(renderer);		
		// if Render3d then GL_Clear;
end;

procedure clearscreen; 
//this is an alias routine

begin
    if LIBGRAPHICS_ACTIVE=true then
        clearDevice
    else //use crt unit
        clrscr;
end;

procedure clearscreen(index:byte); overload;

var
	r,g,b:PUInt8;
    somecolor:PSDL_Color;
begin
    if MaxColors>256 then begin
        if IsConsoleInvoked then
           Logln('ERROR: i cant do that. not indexed.');
		 {$ifdef lcl}
			ShowMessage('Attempted to Clearscreen(index) with non-indexed data.');
		 {$endif}   

        LogLn('Attempting to clearscreen(index) with non-indexed data.');           
        exit; 
    end;
    if MaxColors=16 then
       somecolor:=Tpalette16.colors[index];
    
    if MaxColors=256 then
       somecolor:=Tpalette256.colors[index];


    SDL_SetRenderDrawColor(Renderer,ord(somecolor^.r),ord(somecolor^.g),ord(somecolor^.b),255);
	SDL_RenderClear(renderer);
end;


procedure clearscreen(color:Dword); overload;

var
    somecolor:PSDL_Color;
    someDword:DWord;
    r,g,b:PUInt8;
    i:integer;

begin
    if LIBGRAPHICS_ACTIVE=true then begin

//the only easy way is thru paletted mode due "to the renderer"
//we might just need the pixel format type....

	if bpp =4 then begin
	    //get index from DWord- if it matches
        i:=0;
        repeat
            if color=Tpalette16.DWords[i] then begin;
                somecolor:=Tpalette16.colors[i];
                exit; 
            end;
            inc(i);
        until i=15;		
	end else
	if bpp =8 then begin
	    //get index from DWord- if it matches
        i:=0;
        repeat
            if color=Tpalette256.DWords[i] then begin;
                somecolor:=Tpalette256.colors[i];
                exit; 
            end;
            inc(i);
        until i=255;		
	end;
	
	case bpp of
        15,16,24,32: begin
        //mainSurface will be set upon initGraph invocation
	    	SDL_GetRGB(color,MainSurface^.format,r,g,b);
	    	somecolor^.r:=byte(^r);
	    	somecolor^.g:=byte(^g);
		    somecolor^.b:=byte(^b);	
	    end;
    end;
    SDL_SetRenderDrawColor(Renderer,ord(somecolor^.r),ord(somecolor^.g),ord(somecolor^.b),255);
	SDL_RenderClear(renderer);
	end;
end;

//these two dont need conversion of the data(24 and 32 bpp)
procedure clearscreen(r,g,b:byte); overload;


begin
	SDL_SetRenderDrawColor(Renderer,ord(r),ord(g),ord(b),255);
	SDL_RenderClear(renderer);
end;


procedure clearscreen(r,g,b,a:byte); overload;

begin
	SDL_SetRenderDrawColor(Renderer,ord(r),ord(g),ord(b),ord(a));
	SDL_RenderClear(renderer);
end;


//this is for dividing up the screen or dialogs (in game or in app)

//TP spec says clear the last one assigned
procedure clearviewport;

//clears it, doesnt remove or add a "layered window".
//usually the last viewport set..not necessary the whole "screen"
var
  viewport:PSDL_Rect;

begin
   viewport^.X:= texBounds[windownumber]^.x;
   viewport^.Y:= texBounds[windownumber]^.y;
   viewport^.W:= texBounds[windownumber]^.w;
   viewport^.H:= texBounds[windownumber]^.h;
   SDL_RenderFillRect(Renderer, viewport);
end;

//at each 60hz/75hz cycle--attempt to update the screen--if not paused.

Proceedure videoCallback;

begin

   if (not Paused) then begin //if paused then ignore screen updates
   //interval will be one of:
   //	60,72,75,90(VR),120
		if not Render3d then
           SDL_RenderPresent(Renderer);
        else //OGL
			glutSwapBuffers;
   end;
end;

//NEW: do you want fullscreen or not?
procedure initgraph(graphdriver:graphics_driver; graphmode:graphics_modes; pathToDriver:string; wantFullScreen:boolean);

var
	bpp,i:integer;
	_initflag,_imgflags:longword; //PSDL_Flags?? no such beast 
    iconpath:string;
    imagesON,FetchGraphMode:integer;
	mode:PSDL_DisplayMode;
    AudioSystemCheck:integer;
	rate:integer;

begin

  if LIBGRAPHICS_ACTIVE then begin
    if ISConsoleInvoked then begin
        LogLn('Graphics already active.');
    end;
		 {$ifdef lcl}
			ShowMessage('Initgraph: Graphics already active.');
		 {$endif}   

    exit;
  end;
  pathToDriver:='';  //unused- code compatibility
  iconpath:='./sdlbgi.bmp'; //sdl2.0 doesnt use this.

//this has to be done inline to the running code, unfortunately
  case(graphmode) of 
	     mCGA:begin
			MaxX:=320;
			MaxY:=240;
			bpp:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 
		end;

        //color tv mode
		VGAMed:begin
            MaxX:=320;
			MaxY:=240;
			bpp:=8; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		//spec breaks here for Borlands VGA support(not much of a specification thx to SDL...)
		//this is the "default VGA minimum".....since your not running below it, dont ask to set FS in it...
        // if you did that you would have to scale the output...
		//(more werk???)

		VGAHi:begin
            MaxX:=640;
			MaxY:=480;
			bpp:=4; 
			MaxColors:=16;
            NonPalette:=false;
    		TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		VGAHix256:begin
            MaxX:=640;
			MaxY:=480;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=False;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		VGAHix32k:begin //im not used to these ones (15bits)
           MaxX:=640;
		   MaxY:=480;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
           TrueColor:=false;
           XAspect:=4;
           YAspect:=3; 

		end;

		VGAHix64k:begin
           MaxX:=640;
		   MaxY:=480;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		//standardize these as much as possible....

		m800x600x16:begin
            MaxX:=800;
			MaxY:=600;
			bpp:=4; 
			MaxColors:=16;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		m800x600x256:begin
            MaxX:=800;
			MaxY:=600;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;


		m800x600x32k:begin
           MaxX:=800;
		   MaxY:=600;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;


		m1024x768x256:begin
            MaxX:=1024;
			MaxY:=768;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		m1024x768x32k:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1024x768x64k:begin
           MaxX:=1024;
		   MaxY:=768;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;


		m1280x720x256:begin
            MaxX:=1280;
			MaxY:=720;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=9; 

		end;

		m1280x720x32k:begin
          MaxX:=1280;
		   MaxY:=720;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1280x720x64k:begin
           MaxX:=1280;
		   MaxY:=720;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1280x720xMil:begin
		   MaxX:=1280;
		   MaxY:=720;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1280x1024x256:begin
            MaxX:=1280;
			MaxY:=1024;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=4;
            YAspect:=3; 

		end;

		m1280x1024x32k:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1280x1024x64k:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=4;
           YAspect:=3; 

		end;

		m1280x1024xMil:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=4;
           YAspect:=3; 

		end;

{		m1280x1024xMil2:begin
           MaxX:=1280;
		   MaxY:=1024;
		   bpp:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=4;
           YAspect:=3; 

		end;
}
		m1366x768x256:begin
            MaxX:=1366;
			MaxY:=768;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=9; 

		end;

		m1366x768x32k:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1366x768x64k:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1366x768xMil:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;

{		m1366x768xMil2:begin
           MaxX:=1366;
		   MaxY:=768;
		   bpp:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;
}

		m1920x1080x256:begin
            MaxX:=1920;
			MaxY:=1080;
			bpp:=8; 
			MaxColors:=256;
            NonPalette:=false;
		    TrueColor:=false;	
            XAspect:=16;
            YAspect:=9; 

		end;

		m1920x1080x32k:begin
		   MaxX:=1920;
		   MaxY:=1080;
		   bpp:=15; 
		   MaxColors:=32768;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1920x1080x64k:begin
		   MaxX:=1920;
		   MaxY:=1080;
		   bpp:=16; 
		   MaxColors:=65535;
           NonPalette:=true;
		   TrueColor:=false;	
           XAspect:=16;
           YAspect:=9; 

		end;

		m1920x1080xMil:begin  
 	       MaxX:=1920;
		   MaxY:=1080;
		   bpp:=24; 
		   MaxColors:=16777216;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;

{
		m1920x1080xMil2: begin
 	       MaxX:=1920;
		   MaxY:=1080;
		   bpp:=32; 
		   MaxColors:=4294967296;
           NonPalette:=true;
		   TrueColor:=true;	
           XAspect:=16;
           YAspect:=9; 

		end;
}	    
  end;{case}

//once is enough with this list...its more of a nightmare than you know.
//(its assigned before entries are checked)

    //fire and forget- surface formats               
    case bpp of

		8: begin
			    if maxColors=256 then MainSurface^.format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then MainSurface^.format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
		15: MainSurface^.format:=SDL_PIXELFORMAT_RGB555;

        //we assume on 16bit that we are in 565 not 5551.
		16: begin
			
			MainSurface^.format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: MainSurface^.format:=SDL_PIXELFORMAT_RGB888;
		32: MainSurface^.format:=SDL_PIXELFORMAT_RGBA8888;

    end;

   //"usermode" must match available resolutions etc etc etc
   //this is why I removed all of that code..."define what exactly"??


//  if WantsAudioToo then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER; 
//  if WantsJoyPadAudio then _initflag:= SDL_INIT_VIDEO or SDL_INIT_AUDIO or SDL_INIT_TIMER or SDL_INIT_JOYSTICK;
//if WantInet then _initflag:= SDL_Init_Net;

//if GLINIT error:

//     _grResult:=GenError; //gen error
//     halt(0); //the other routines are now useless- since we didnt init- dont just exit the routine, DIE instead.


{
  if wantsFullIMGSupport then begin

    _imgflags:= IMG_INIT_JPG or IMG_INIT_PNG or IMG_INIT_TIF;
    imagesON:=IMG_Init(_imgflags);

    //not critical, as we have bmp support but now are limping very very bad...
    if((imagesON and _imgflags) <> _imgflags) then begin
       if IsConsoleInvoked then begin
		 Logln('IMG_Init: Failed to init required JPG, PNG, and TIFF support!');
		 LogLn(IMG_GetError);
	   end;
	   $ifdef lcl
			ShowMessage('IMG_Init: Failed to init required JPG, PNG, and TIFF support');
   	   $endif
    end;
  end;
}


  if (graphdriver = DETECT) then begin
	//probe for it, dumbass...NEVER ASSUME.

       //temporarily not available
	   {$ifdef lcl}
			ShowMessage('Graphics detrection not available at this time.');
   	   {$endif}   

//    Fetchgraphmode := DetectGraph; //need to kick back the higest supported mode...
  end;

  NoGoAutoRefresh:=false;
  LIBGRAPHICS_INIT:=true; 
  LIBGRAPHICS_ACTIVE:=false; 


//force a safe shutdown.
//(NO NEED to call closegraph this way)

//if the app crashes we could be in an unknown state-which is bad.
 AddExitProc(CloseGraph);
 
{
atexit handling:
basically it prevents random exits- all exits must do whatever is in the routine.


FPC:  AddExitProc(CloseGraph);

TP: use the olschool method:
 
 OldExitProc := ExitProc;                - save previous exit proc -cpu: push exit()
 ExitProc := @MyExitProc;               - insert our exit proc in chain 

$F+
procedure MyExitProc;
begin
  //shut everything down
  ExitProc := OldExitProc;  Restore exit procedure address -cpu: pop exit()
  CloseGraph;               Shut down the graphics system 
end; 
$F-

}



{  //Hide, mouse.
  if not Render3d then
	SDL_ShowCursor(SDL_DISABLE);
   

//lets get the current refresh rate and set a screen timer to it.
// we cant fetch this from X11? sure we can.

  
  mode^.format := SDL_PIXELFORMAT_UNKNOWN;
  mode^.w:=0;
  mode^.h:=0;
  mode^.refresh_rate:=0;
  mode^.driverdata:=Nil;
  //for physical screen 0 do..
  
  //The SDl equivalent error of: attempting to probe VideoModeInfo block when (VESA) isnt initd results in issues....
  
  if(SDL_GetCurrentDisplayMode(0, mode) <> 0) then begin
    if IsConsoleInvoked then
			Logln('Cant get current video mode info. Non-critical error.');
		$ifdef lcl
			ShowMessage('SDL cant get the data for the current mode.');
   	   $endif   
	end;

  //dont refresh faster than the screen.
  if (mode^.refresh_rate > 0)  then 
     //either force a INT- or convert from REAL. 
     
     flip_timer_ms := round(mode^.refresh_rate)

  else
     flip_timer_ms := 17; //60Hz

  video_timer_id := SDL_AddTimer(flip_timer_ms, @videoCallback, nil);
  if video_timer_id=0 then begin
    if IsConsoleInvoked then begin
		Logln('WARNING: cannot set drawing to video refresh rate. Non-critical error.');
		Logln('you will have to manually update surfaces and the renderer.');
    end;
    $ifdef lcl
			ShowMessage('SDL cant set video callback timer.Manually update surface.');
    $endif

    NoGoAutoRefresh:=true; //Now we can call Initgraph and check, even if quietly(game) If we need to issue RenderPresent calls.
  end;
}

//  if flip_timer_ms=17 then rate=60;

  rate:=60; //temp code
  FSMode:=MaxX,'x',MaxY,':',bpp,'@',rate; //build the string
  
  SetGraphMode(Graphmode,wantFullScreen);
  
	//the event handler
	GlutMainLoop;


 { 
  CantDoAudio:=false;
    //prepare mixer
  if WantsAudioToo then begin
    AudioSystemCheck:=InitAudio;    
    if AudioSystemCheck <> 0 then begin
        if IsConsoleInvoked then
                LogLn('There is no audio. Mixer did not init.')
        else  SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'There is no audio. Mixer did not init.','OK',NIL);
    end;

  end;

  //initialization of TrueType font engine
  if TTF_Init = -1 then begin
    
    if IsConsoleInvoked then begin
        Logln('I cant engage the font engine, sirs.');
    end;
    $ifdef lcl
			ShowMessage('ERROR: I cant engage the font engine, sirs.');
    $endif  
		
    _graphResult:=-3; //the most likely cause, not enuf ram.
    closegraph;
  end;
}

//set some sane default variables
  _fgcolor := $FFFFFFFF;	//Default drawing color = white (15)
  _bgcolor := $000000FF;	//default background = black(0)
  
{
  GL_fgcolor:=1.0;
  GL_bgcolor:=0;
}

  someLineType:= NormalWidth; 

//  lineinfo.linestyle:=solidln;
//     fillsettings.pattern:=solidfill;

  ClipPixels := TRUE;
  
  // Set initial viewport 
  StartXViewPort := 0;
  StartYViewPort := 0;
  ViewWidth := MaxX;
  ViewHeight := MaxY;

  // normal write mode 
  CurrentWriteMode := CopyPut;

  // set default font (8x8)
//  installUserFont('./fonts/code.ttf', 10,TTF_STYLE_NORMAL,false);

//     CurrentTextInfo.direction:=HorizDir;


  LIBGRAPHICS_ACTIVE:=true;  //We are fully operational now.
  paused:=false;

  _grResult:=OK; //we can just check the dialogs (or text output) now.

  //give us standard LH corner coordinate system and reset to 0,0.
  
  glOrtho( 0, MaxX, MaxY, 0, 0, 1.0 );
  where.X:=0;
  where.Y:=0;

{
  SDL_ShowCursor(SDL_ENABLE);

  //Check for joysticks 
  if WantsJoyPad then begin
 
    if( SDL_NumJoysticks < 1 ) then begin
        if IsConsoleInvoked then
			Logln( 'Warning: No joysticks connected!' ); 
    $ifdef lcl
			ShowMessage('Warning: No joysticks connected!');
    $endif   
        
    end else begin //Load joystick 
	    gGameController := SDL_JoystickOpen( 0 ); 
    
        if( gGameController = NiL ) then begin  
	        if IsConsoleInvoked then begin
		    	Logln( 'Warning: Unable to open game controller! SDL Error: '+ SDL_GetError); 
                LogLn(SDL_GetError);
            end;
    $ifdef lcl
			ShowMessage('Warning: Unable to open game controller!');
    $endif   

            noJoy:=true;
        end;
        noJoy:=false;
    end; 
  end; //Joypad 
}

end; //initgraph


{--seems incomplete
//stream is a chunk of audio

//uos (portaudio) is significantly easier

procedure InitAudio;
var

	want, have:PSDL_AudioSpec;
	dev:SDL_AudioDeviceID;

begin
	SDL_memset(@want, 0, sizeof(want)); 
	want^.freq = 48000;
	want^.format = AUDIO_F32;
	want^.channels = 2;
	want^.samples = 4096;
	want^.callback = MyAudioCallback; //@MyAudioCallBack??

	dev := SDL_OpenAudioDevice(NiL, 0, @want, @have, SDL_AUDIO_ALLOW_FORMAT_CHANGE);
	if (dev = 0) then 
	    LogLn('Failed to open audio: ' + SDL_GetError);
	else begin
	    if (have^.format <> want^.format) then 
    	    SDL_Log('We didnt get Float32 audio format.');
    
//    SDL_PauseAudioDevice(dev, 0); // start audio playing. 
//    SDL_Delay(5000); // let the audio callback play some sound for 5 seconds. 
end;
}

procedure closegraph;
var
	Killstatus,Die:cint;
    waittimer:integer;

//free only what is Allocated, nothing more- then make sure pointers are empty.
begin

  LIBGRAPHICS_ACTIVE:=false;  //Unset the variable (and disable all of our other functions in the process)

  //if wantsInet then
//  SDLNet_Quit;

  if wantsJoyPad then
    SDL_JoystickClose( gGameController ); 
  gGameController := Nil;

  if WantsAudioToo then begin
    Mix_CloseAudio; //close- even if playing

    if chunk<>Nil then
        Mix_FreeChunk(chunk); 
    if music<> Nil then 
        Mix_FreeMusic(music);

    Mix_Quit;
  end;

   SDL_RemoveTimer(video_timer_id);
   video_timer_id := 0;


   SDL_DestroyMutex(eventLock);
   eventLock := nil;

   SDL_DestroyCond(eventWait);
   eventWait := nil;

  
  if (TextFore <> Nil) then begin
	TextFore:=Nil;
	dispose(TextFore);
  end;
  if (TextBack <> Nil) then begin
	TextBack:=Nil;
	dispose(TextBack);
  end;
  TTF_CloseFont(ttfFont);
  TTF_Quit;
  //its possible that extended images are used also for font datas...
  if wantsFullIMGSupport then 
     IMG_Quit;


  die:=9; //signal number 9=kill
  //Kill child if it is alive. we know the pid since we assigned it(the OS really knows it better than us)

  //were stuck in a loop
  //we can however, trip the loop to exit...

  exitloop:=true;
  Killstatus:=FpKill(EventThread,Die); //send signal (DIE) to thread

  EventThread:=0;

  dispose( Event );
  //free viewports

  x:=8;
  repeat
	if (Textures[x]<>Nil) then
		SDL_DestroyTexture(Textures[x]);
		Textures[x]:=Nil;
    dec(x);
  until x=0;
  

//Dont free whats not Allocated in initgraph(do not double free)
//routines should free what they AllocMemate on exit.

  if (MainSurface<> Nil) then begin
	SDL_FreeSurface( MainSurface );
	MainSurface:= Nil;
  end;	

  if not Render3d then begin
	if (Renderer<> Nil) then begin
		Renderer:= Nil;
		SDL_DestroyRenderer( Renderer );
	end;	

	if (Window<> Nil) then begin
		Window:= Nil;
		SDL_DestroyWindow ( Window );
	end;	
  end;
  if Render3D then
	glutLeaveMainLoop;
  
  SDL_Quit; 


  if IsConsoleInvoked then begin
     
         textcolor(7); //..reset standards...
         clrscr; //text clearscreen
         writeln;
  end;
  //unless you want to mimic the last doom screen here...usually were done....  
  //Yes you can override this function- if you need a shareware screen on exit..Hackish, but it works.
  
  halt(0); //nothing special, just bail gracefully.
end;            	 

function GetX:word;
begin
  x:=where.X;
end;

function GetY:word;
begin
  y:=where.Y;
end;

function GetXY:longint; 
//This is the 1D location in the 2D graphics area(yes, its weird)

//"pitch" in console mode is like 54928 or something..
begin
  x:=where.X;
  y:=where.Y;
  GetXY := (y * (MainSurface^.pitch mod (sizeof(byte)) ) + x); //byte or word-(lousy USint definition)
end;


//GLUT functions
//is OGL easier- not for everything.

procedure glutInitPascal(ParseCmdLine: Boolean); 
var
	myargc:integer;
	myargv:array[0..1] of PChar;
begin
	//dummy this- seems to fire with or without data, according to C devs.
	myargc:=1;
	myargv [0]="LazGFX";
	glutInit(@myargc, @myargv); 
end;


//renderPresent
procedure DrawGLScene; cdecl;
begin
  if Render3d then
	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  else	
	glClear(GL_COLOR_BUFFER_BIT); //no Z axis to work with

  glutSwapBuffers;
end;

procedure ReSizeGLScene(Width, Height: Integer); cdecl;
begin
  if Height = 0 then
    Height := 1;
 
  glViewport(0, 0, MaxX, MaxY);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(45, Width mod Height, 0.1, 1000);
 
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  
end;

//isnt this easy?
procedure GLKeyboard(Key: Byte); cdecl;
begin
  if Key = 27 then //ESC
    Halt(0);
end;

{
 Draw an Texture to an Renderer at x, y. 
 preserve the texture's width and height- also taking a clip of the texture if desired

- we can use just RenderCopy, but it doesnt take stretching or clipping into account.(its sloppy)

I didnt write this (from stackExchange in C) but it makes sense and SDL is at least "GPL", so we are "safe in licensing".

}

procedure renderTexture( tex:PSDL_Texture;  ren:PSDL_Renderer;  x,y:integer;  clip:PSDL_Rect);

var
  dst:PSDL_Rect;

begin
	
	dst^.x := x;
	dst^.y := y;
	if (clip <> Nil)then begin
		dst^.w := clip^.w;
		dst^.h := clip^.h;
	end
	else begin
		SDL_QueryTexture(tex, NiL, NiL, @dst^.w, @dst^.h);
	end;
	SDL_RenderCopy(ren, tex, clip, dst); //clip is either Nil(whole surface) or assigned

end;


procedure setgraphmode(graphmode:graphics_modes; wantfullscreen:boolean); 
//initgraph should call us to prevent code duplication
//exporting a record is safer..but may change "a chunk of code" in places.   
var
	flags:longint;
    success,IsThere,RendedWindow:integer;
    surface1:PSDL_Surface;
    FSNotPossible:boolean;
    thismode:string;
    GLmode:PChar;

begin
//we can do fullscreen, but dont force it...
//"upscale the small resolutions" is done with fullscreen.
//(so dont worry if the video hardware doesnt support it)


//if not active:
//are we coming up?
//no? EXIT

	if (LIBGRAPHICS_INIT=false) then begin
		
		if IsConsoleInvoked then 
			Logln('Call initgraph before calling setGraphMode.') 
		else 
    {$ifdef lcl}
			ShowMessage('setGraphMode called too early. Call InitGraph first.');
    {$endif}   

	    exit;
	end
	else if (LIBGRAPHICS_INIT=true) and (LIBGRAPHICS_ACTIVE=false) then begin //initgraph called us
			glutInitPascal(False);

			glutInitWindowSize(MaxX, MaxY); 
		case(bpp) of: //with chosen resolutions bpp do
		//always use double buffering(pageFLipping)
		//force a compatible 555 15bit depth		
		//force a compatible 565 16bit depth
        //4bit is a limited paletted 8 bit mode (mode hack)

			4:GLMode:='index double';
			8:GLMode:='index double'; 
			15:GLMode:='rgb depth=15 double'; 
			16:GLMode:='red=5 green=6 blue=5 depth=16 double'; 
			24:GLMode:='rgb double'; 
			32:	GLMode:='rgba double'; 
		end; //case
		glutInitDisplayString(GLMode); 
		if WantsFullScreen then begin
				glutGameModeString(FSMode);
				glutEnterGameMode;
				glutSetCursor(GLUT_CURSOR_NONE);
		end else begin //windowed
			
			ScreenWidth := glutGet(GLUT_SCREEN_WIDTH); 
			ScreenHeight := glutGet(GLUT_SCREEN_HEIGHT); 
			glutInitWindowPosition((ScreenWidth - AppWidth) div 2, (ScreenHeight - AppHeight) div 2); 
			glutCreateWindow('Lazarus Graphics Application'); 
			
		end
	    prepareOpenGL;	

	   	//r,g,b=0,a=1
		glClearColor( 0.f, 0.f, 0.f, 1.f );
		glClear( GL_COLOR_BUFFER_BIT );
		
		//set callbacks-you need to override- or define these
		//external declarations.
		glutDisplayFunc(@DrawGLScene);
		glutReshapeFunc(@ReSizeGLScene);
		glutKeyboardFunc(@GLKeyboard);
		glutMouseFunc(@GLMouse);
		glutIdleFunc(@DrawGLScene);

    end; //setup renderer

	glutSetIconTitle(iconpath);


    if bpp=4 then
      InitPalette16
    else if bpp=8 then 
      InitPalette256; 
      
	if (bpp<=8) then begin
		for x:=0 to MaxColors do begin
			if MaxColors =16 then
				glutSetColor(x,ByteToFloat(Tpalette16.colors[x]^.r),ByteToFloat(Tpalette16.colors[x]^.g),ByteToFloat(Tpalette16.colors[x]^.b))
			else if MaxColors =256 then
				glutSetColor(x,ByteToFloat(Tpalette256.colors[x]^.r),ByteToFloat(Tpalette256.colors[x]^.g),ByteToFloat(Tpalette256.colors[x]^.b))
			inc(x);
		end;
	end;

	LIBGRAPHICS_ACTIVE:=true;
	exit; //back to initgraph we go.

	end else if (LIBGRAPHICS_ACTIVE=true) then begin //good to go
    //modeChange

		if Render3d then //we use DEPTH(3D) instead of 2D QUADS
			glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB or GLUT_DEPTH);
		
		glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB);	
		if WantsFullScreen then begin
				glutGameModeString(FSMode);
				glutEnterGameMode;
				glutSetCursor(GLUT_CURSOR_NONE);
		end else begin //windowed
			
			glutInitWindowSize(MaxX, MaxY); 
		case(bpp) of: //with chosen resolutions bpp do
		//always use double buffering(pageFLipping)
		//force a compatible 555 15bit depth		
		//force a compatible 565 16bit depth
        //4bit is a limited paletted 8 bit mode (mode hack)

			4:GLMode:='index double';
			8:GLMode:='index double'; 
			15:GLMode:='rgb depth=15 double'; 
			16:GLMode:='red=5 green=6 blue=5 depth=16 double'; 
			24:GLMode:='rgb double'; 
			32:	GLMode:='rgba double'; 
		end; //case
		glutInitDisplayString(GLMode); 
		if WantsFullScreen then begin
				glutGameModeString(FSMode);
				glutEnterGameMode;
				glutSetCursor(GLUT_CURSOR_NONE);
		end else begin //windowed
			
			ScreenWidth := glutGet(GLUT_SCREEN_WIDTH); 
			ScreenHeight := glutGet(GLUT_SCREEN_HEIGHT); 
			glutInitWindowPosition((ScreenWidth - AppWidth) div 2, (ScreenHeight - AppHeight) div 2); 
			glutCreateWindow('Lazarus Graphics Application'); 
			
		end
	    prepareOpenGL;	

	   	//r,g,b=0,a=1
		glClearColor( 0.f, 0.f, 0.f, 1.f );
		glClear( GL_COLOR_BUFFER_BIT );
		
		//set callbacks-you need to override- or define these
		//external declarations.
		glutDisplayFunc(@DrawGLScene);
		glutReshapeFunc(@ReSizeGLScene);
		glutKeyboardFunc(@GLKeyboard);
		glutMouseFunc(@GLMouse);
		glutIdleFunc(@DrawGLScene);

    end; //setup renderer

	glutSetIconTitle(iconpath);


    if bpp=4 then
      InitPalette16
    else if bpp=8 then 
      InitPalette256; 
      
	if (bpp<=8) then begin
		for x:=0 to MaxColors do begin
			if MaxColors =16 then
				glutSetColor(x,ByteToFloat(Tpalette16.colors[x]^.r),ByteToFloat(Tpalette16.colors[x]^.g),ByteToFloat(Tpalette16.colors[x]^.b))
			else if MaxColors =256 then
				glutSetColor(x,ByteToFloat(Tpalette256.colors[x]^.r),ByteToFloat(Tpalette256.colors[x]^.g),ByteToFloat(Tpalette256.colors[x]^.b))
			inc(x);
		end;
	end;

  end; //already in gfx mode
end; //setGraphMode


function getgraphmode:string; 
//it could also be that the monitor output is not in the modelist
var
    bppstring:string;
    format:PSDL_PixelFormat;
    MaxMode:integer;
    findX,findY:word;
    findbpp:byte;
    thismode:PSDL_DisplayMode;

begin
   if LIBGRAPHICS_ACTIVE then begin 
        SDL_GetCurrentDisplayMode(0, thismode); //go get w,h,format and refresh rate..
        findX:=MainSurface^.w;
		findY:=MainSurface^.h;
		x:=0;
        //we need to find X,Y,BPP in the modelist somehow...
		while (x< (Ord(High(Graphics_Modes))-1)) do begin
			if (findX=MaxX) and (findY=MaxY)  then begin		
                    if (MainSurface^.format^.BitsPerPixel<>bpp) then break;			       	
                    //typinfo shit:                      	
			        getgraphmode:=GetEnumName(TypeInfo(Graphics_modes), Ord(x));
					exit;
			end;
            
            bpp:=bpp * bpp; //bpp^2 - if x and y match, save time
			inc(x);
		end;
        if IsConsoleInvoked then begin
            LogLN('Cant find current mode in modelist.');
        end;

    {$ifdef lcl}
			ShowMessage('ERROR: Cant find current mode in modelist.');
    {$endif}   

   end;   
end;    

procedure restorecrtmode; //wrapped closegraph function
begin
  if (not LIBGRAPHICS_ACTIVE) then begin //if not in use, then dont call me...

	if IsConsoleInvoked then begin
        LogLn('you didnt call initGraph yet...try again?');
        exit;
    end;    
  end;
  closegraph;
end;

function getmaxX:word;
var
	w,h:word;
	
begin
   if LIBGRAPHICS_ACTIVE then
   //pulling from ModeList data is much faster than querying the renderer or unfetching rendered surface data
   //if graphics is active- assume we have the data set.
     getMaxX:=(MaxX - 1); 
end;

function getmaxY:word;
begin
   if LIBGRAPHICS_ACTIVE then
     GetMaxY:=(MaxY - 1); 
end;

{ 
Blittering and doing things by hand is very ancient means of doing things.
OpenGL fills in the pixels for us- this is no longer needed, nor is the math for it. 

SDL_ScrollX(Surface,DifX);
SDL_ScrollY(Surface,DifY);

if youre looking for batched ops:

procedure BatchRenderPixels;
var 
  PolyArray=array[1..points] of SDL_Point;

begin
  polyarray[1].x:=5
  polyarray[1].y:=3

  polyarray[2].x:=7
  polyarray[2].y:=7

  SDL_RenderDrawPoints( renderer,polyarray,points);  
end;

Polygons:
    SDL_RenderDrawLines(renderer,LineData,numLines);

}

function GetPixel(x,y:integer):DWord;

// this function is "inconsistently fucked" from C...so lets standardize it...
// this works, its hackish -but it works..SDL_GetPixel is for Surfaces/screens, not renderers.
var
  format:longword;
  TempSurface:PSDL_Surface;
  bpp:byte;
  p:pointer; //the pixel data we want 
  GotColor:PSDL_Color;
  pewpew:longword; //DWord....
  pointpew:PtrUInt;
  r,g,b,a:PUInt8;
  index:byte;
  someDWord:DWord;


begin
	rect^.x:=x;
    rect^.y:=y;
	rect^.h:=1;
	rect^.w:=1;
    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

//we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;


    //(we do this backwards....rendered to surface of the size of 1 pixel)
    if ((MaxColors=256) or (MaxColors=16)) then TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 8, format) 
    //its weird...get 4bit indexed colors list in longword format but force me into 256 color mode???

    else if (MaxColors>256) then begin
        case (bpp) of
		    15: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 15, format); 
			16: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 16, format); 
			24: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 24, format); 
			32: TempSurface := SDL_CreateRGBSurfaceWithFormat(0, 1, 1, 32, format); 
			else begin
    {$ifdef lcl}
			ShowMessage('Wrong bpp given to get a pixel. I dont how you did this.');
    {$endif}   

				 if IsConsoleInvoked then
					LogLn('Wrong bpp given to get a pixel. I dont how you did this.');
			end;

		end;
     end;

    //read a 1x1 rectangle....
    SDL_RenderReadPixels(renderer, rect, format, TempSurface^.pixels, TempSurface^.pitch);


    p:=TempSurface^.pixels;  
    bpp := TempSurface^.format^.BytesPerPixel; 
    //The C is flawed! 15bpp not taken into account.
    //ignorance is stupidity and laziness!

    // Here TempSurface^.pixels is the address to the pixel data (1px) we want to retrieve
    

{

"nuking the problem" (unnessessary overcomplication)
 the problem - not well documented for surfaces in C-

is thusly:

  P can be of any size up to 32bit values (because sdl doesnt support 64bit modes)

  is P a byte? (16/256 colors)
  is P a Word? NO. NEVER.Not enough BPP data returned.
  is P a partial DWord? (15/16bit/24bit colors) - spew SDL_Color data (for each byte inside P), 
      then fetch an appropriate DWord from that
      (this is a bitwise operation, so we need the DWord inside the pointer to work with the data)

  is P a DWord? (32bit colors)

no type conversion is needed as pointers are flexible
however endianness, although it should be checked for (ALWALYS) plays no role in how P is interpreted.

-and people wonder why thier data coming back from P is flawed?? mhm...

-you nuked it!

}
    case (bpp) of 
       8:begin //256 colors
        //now take the longword output 

          //check for the hidden 4bpp modes we made available
          if MaxColors=16 then begin
             index:=ord(Byte(^p));
             GetPixel:=Tpalette16.Dwords[index];
          end;

          //ok safely in 256 colors mode
          if MaxColors=256 then begin
             index:=ord(Byte(^p));
             GetPixel:=Tpalette256.Dwords[index];
          end;
          exit;
      end;

//these three need some work
//not its not a trick, we need the alpha-bit set to FF on non 32bit colors.
//its ignored but its also "padded data"

      15: begin //15bit
            //to do this one- we split out the RGB pairs, shift them,then recombine them.
            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );;
	         gotcolor^.b:=(byte(^b) );

            //shift adjust me
			gotcolor^.r:= (gotcolor^.r shr 3);
			gotcolor^.g:= (gotcolor^.g shr 3);
			gotcolor^.b:= (gotcolor^.b shr 3) ;

            //repack
            someDWord:= SDL_MapRGB(TempSurface^.format,gotcolor^.r,gotcolor^.g,gotcolor^.b);
            GetPixel:=someDWord;
            exit;
      end;
      16: begin //16bit-565
        //    if (TempSurface^.format=SDL_PIXELFORMAT_RGB565) then begin

            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );
	         gotcolor^.b:=(byte(^b) );

            //shift adjust me
			gotcolor^.r:= (gotcolor^.r shr 3);
			gotcolor^.g:= (gotcolor^.g shr 2);
			gotcolor^.b:= (gotcolor^.b shr 3) ;

           //repack
            someDWord:= SDL_MapRGB(TempSurface^.format,gotcolor^.r,gotcolor^.g,gotcolor^.b);
            GetPixel:=someDWord;
      		exit;
      end;


      24: begin //24bit
            SDL_GetRGB(Longword(^p),TempSurface^.format,r,g,b);

			//play fetch            

             gotcolor^.r:=(byte(^r) );
		     gotcolor^.g:=(byte(^g) );
	         gotcolor^.b:=(byte(^b) );
           //repack
            someDWord:= SDL_MapRGB(TempSurface^.format,gotcolor^.r,gotcolor^.g,gotcolor^.b);
            GetPixel:=someDWord;
			exit;
      end;
      32: //32bit

	        GetPixel:=DWord(p);
   
      else
      {$ifdef lcl}
			ShowMessage('Cant Get Pixel values...');
      {$endif}   
  
         if IsConsoleInvoked then
                LogLn('Cant Get Pixel values...');
    end; //case

    SDL_FreeSurface(Tempsurface);
    
end;

Procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word);
//use SDL_SetRenderDrawColor to set the _fgcolor
//color is already set- just drop a pixel HERE
begin

  if (bpp<4) or (bpp >32) then
 
  begin
    {$ifdef lcl}
			ShowMessage('Cant Put Pixel values...');
    {$endif}   
            if IsConsoleInvoked then
                LogLn('Cant Put Pixel values...');
			exit;
  end;
  
  SDL_RenderDrawPoint( Renderer, X, Y );
  
end;

//PUT a pixel HERE- with THIS color
procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word; color:byte); overload;
//indexed 
var
	someColor:PSDL_Color;
	r,g,b:byte;

begin
//these are in an array already.

//wrong routine called
  if bpp>8 then exit;
  
  if (bpp=4) then
	someColor:=Tpalette16.Colors[color]
  else if (bpp=8) then
	someColor:=Tpalette256.Colors[color];
	
	r:=somecolor^.r;
	g:=somecolor^.g;
	b:=somecolor^.b;

	SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_NONE);
	SDL_SetRenderDrawColor(renderer, r, g, b, 255); 
	SDL_RenderDrawPoint(renderer, x, y);
end;

//RGB colors above 256 paletted mode
procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word; r,g,b:byte); overload;

begin
	SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_NONE);
	SDL_SetRenderDrawColor(renderer, r, g, b, 255); 
	SDL_RenderDrawPoint(renderer, x, y);
end;

procedure PutPixel(Renderer:PSDL_Renderer; x,y:Word; r,g,b,a:byte); overload;

begin
	SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
	SDL_SetRenderDrawColor(renderer, r, g, b, a);
	SDL_RenderDrawPoint(renderer, x, y);
end;	
	


function getdrivername:string;
begin
//not really used anymore-this isnt dos

   getdrivername:='Internal.SDL'; //be a smartASS
end;


//FIXME:dont use Graphics_mode=detect for the moment.
//(reqd fix for version 1.0)

//we should limit detectGraph calls also and allow quick checks if libGfx is already active.

Function detectGraph:byte; //should return max mode supported(enum value) -but cant be negative
//called *once* per "graphics init"-which is only called if not active.

//we detected a mode or we didnt. If we failed, exit. (we should have at least one graphics mode)
//if we succeeeded- get the highest mode.

//we only need the entire list (enum) while probing. The DATA is in the initgraph subroutine.

var

    i,testbpp:integer;

begin

//if InitGraph then...
//(AND ONLY WHILE INITing....initgraph needs to call us)

{
BAD C detected!

this is the "shove a byte where a boolean goes bug" in C...(boolean words etc..)
if its zero then its not ok. we dont want any other mode or similar mode...
in this case-
    if its 1, we found the mode.

the trick is to prevent SDL from setting "whatever is closest"..we want this mode and only this...
most people dont usually care but with the BGI -WE DO.

SDL2:

    How do we scan the unknown? 
    1- ask SDL for supported list of Modes supported (solve X by providing it)
    2- we have to compare it to something. This is the puzzle-to what? 
        we are set higher than the mode we want. (We WANT the unsupported modes and depths)

so- we get the current screen resolution and check if requested mode is smaller-if so, GOOD.
(if its bigger, then we have a problem. DROP one mode with same color depth.)


}

{    i:=(Ord(High(Graphics_Modes))-1)

    //CurrentMode:=SDL_GetCurrentMode	 
	repeat

   		testbpp:=SDL_VideoModeOK(modelist.width[i], modelist.height[i], modelist.bpp[i], _initflag); //flags from initgraph

        //if Currentmode=ModeRequested (testbpp=1) then...
	 
        if (testbpp=1) then begin 
            
            //initGraph just wants the number of the enum value, which we check for
            DetectGraph:=byte(i); 
            exit;
    	end;
		dec(i);
	until i:=1;
    //there is still one mode remaining.
	testbpp:=SDL_VideoModeOK(modelist.width[i], modelist.height[i], modelist.bpp[i], _initflag);		         
	if (testbpp=0) then begin //did we run out of modes?
        if IsConsoleInvoked then
            writeln('We ran out of modes to check.');
            //LogLn('We ran out of modes to check.');
		SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'There are no graphics modes available to set. Bailing..','OK',NIL);
		CloseGraph; 
	end;
	DetectGraph:=byte(i);

	//usermode should be within these parameters, however, since that cant be checked for...
	//why not just remove it(usermode)? [enforce sanity]
    //otherwise we need to see if its valid data too....or skew up SDL window output and rendering.....
    //-which is wrong.
}

end; //detectGraph


function getmaxmode:string;
var
   maxmodetest:byte;
begin
  if LIBGRAPHICS_ACTIVE then begin
      maxmodetest:=detectgraph;
      getmaxmode:=GetEnumName(TypeInfo(graphics_modes), Ord(maxmodetest)); //use the number and get the name of it.
  end;
end;


//the only real use for the "driver" setting...
procedure getmoderange(graphdriver:integer);

begin

	if not graphdriver = ord(detect) then begin
  		if (graphdriver = ord(VGA)) then begin
    		  lomode := ord(VGAMed);
    		  himode := ord(m1024x768xMil);
  		end else

  		if (graphdriver= ord(VESA)) then begin
    		 lomode := ord(mCGA);
    		 himode := ord(m1920x1080xMil);
  		end else

		if (graphdriver = ord(mCGA)) then begin
    	  lomode := ord(mCGA);
    	  himode := ord(mCGA);
  		end;

	end else begin
        if (graphdriver=ord(DETECT)) then begin
            himode:=detectgraph;	 //unfortunate probe here...   	
// FIXME: return value: (byte to enum value conversion?? - or use a bunch of consts)
// default enum type reads: longword

	    	lomode:= ord(mCGA); //no less than this.
		end else begin
			if IsConsoleInvoked then
				Logln('Unknown graphdriver setting.');
    {$ifdef lcl}
			ShowMessage('Unknown graphdriver setting.');
    {$endif}   

		end;
	end;
end; //getModeRange



//(Its an odd rare case,such as TnL --not discussed here)

function cloneSurface(surface1:PSDL_Surface):PSDL_Surface;
//Lets take the surface to the copy machine...

begin
    cloneSurface := SDL_ConvertSurface(Surface1, Surface1^.format, Surface1^.flags);
end;

{viewports-
    the trick is that we are technically always in one(FPC).
    the joke is:
         what are the co ords?

this might not be BGI spec- but it makes sense.

}

procedure SetViewPort(Rect:PSDL_Rect);

var
    LastRect:PSDL_Rect;
    ScreenData:Pointer;
    infosurface,savesurface:PSDL_Surface;

begin
//freeze movement
   if windownumber=8 then begin
    {$ifdef lcl}
			ShowMessage('Attempt to create too many viewports.');
    {$endif}   

      if IsConsoleInvoked then
        LogLn('Attempt to create too many viewports.');
      exit;
   end;
   //get viewport size and put into LastRect
   SDL_RenderGetViewport(renderer,Lastrect); 
   //current co ords = last, then add one.
   inc(windownumber);

   //LINUX claims of xor,xnor "not being supported"- so let "work around it".
   
  //store the current viewport data
  saveSurface := NiL;
  infosurface:=Nil;
  ScreenData:=Nil;

  //pixels and info abt the pixels. from the renderer-to a surface, then throw it back into a texture
  ScreenData:=GetPixels(LastRect);
  infoSurface := SDL_GetWindowSurface(Window);

  saveSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface^.w * infoSurface^.format^.BytesPerPixel),longword( infoSurface^.format));

  if (saveSurface = NiL) then begin
  
    {$ifdef lcl}
			ShowMessage('Couldnt create SDL_Surface from renderer pixel data');
    {$endif}   


      LogLn('Couldnt create SDL_Surface from renderer pixel data. ');
      LogLn(SDL_GetError);
      exit;
                    
  end;
   
   Textures[windownumber]:=SDL_CreateTextureFromSurface(renderer,saveSurface);

   //free data
   SDL_FreeSurface(saveSurface);

   saveSurface := NiL;
   infosurface:=Nil;
   ScreenData:=Nil;
  

   SDL_RenderSetViewport( Renderer, Rect );  
   //clearviewport(_fgcoor);
  
   //"Clipping" is a joke- we always clip.
   //The trick is: do we zoom out? In Most cases- NO. We zoom IN.

end;


procedure RemoveViewPort(windownumber:byte);
//the opposite of above...
//set the last window coords..(we might be trying to write to them)
//and redraw the prior window as if the new one was not there(not an easy task).
var
  ThisRect,LastRect:PSDL_Rect;

begin

   if windownumber=0 then begin
   
    {$ifdef lcl}
			ShowMessage('Attempt to remove non-existant viewport.');
    {$endif}   
  
    if IsConsoleInvoked then
        LogLn('Attempt to remove non-existant viewport.');
    exit; 
   end;
   if windownumber > 1 then begin
  		ThisRect^.X:=TexBounds[windownumber]^.X;
		ThisRect^.Y:=TexBounds[windownumber]^.Y;
	    ThisRect^.W:=TexBounds[windownumber]^.W;
	    ThisRect^.H:=TexBounds[windownumber]^.H;

        //get co ords of the previous

        LastRect^.X:=TexBounds[windownumber-1]^.X;
 	    LastRect^.Y:=TexBounds[windownumber-1]^.Y;
 	    LastRect^.W:=TexBounds[windownumber-1]^.W;
	    LastRect^.H:=TexBounds[windownumber-1]^.H;
   
       //remove the viewport by removing the texture and redrawing the screen.
       //the problem with textures is that they are part of a one-way road. ARG!

        Textures[windownumber]:=nil; //Destroy the current Texture

        SDL_RenderCopy(renderer,Textures[windownumber-1],Nil,LastRect);
        SDL_RenderPresent(renderer);

		SDL_RenderSetViewport( Renderer, LastRect ); 
        dec(windownumber);
//unfreeze movement
        exit;
   end; 
   //else: last window remaining
   Textures[1]:=nil;
   SDL_RenderSetViewport( Renderer,nil);  //reset to full size "screen"

   //this only works if we freeze input and dont update the screen- otherwise, we jitter
   // and update with old data on the "overlayed area".

   SDL_RenderCopy(Renderer,Textures[0],nil,LastRect);
   SDL_RenderPresent(renderer); //and update back to the old screen before the viewports came here.

   LastRect^.X:=0;
   LastRect^.Y:=0;
   LastRect^.W:=MaxX;
   LastRect^.H:=MaxY;
   
   dec(windownumber);

   //unfreeze movement
end;



//compatibility
//these were hooks to load or unload "driver support code modules" (mostly for DOS)
procedure InstallUserDriver(Name: string; AutoDetectPtr: Pointer);
begin
    {$ifdef lcl}
			ShowMessage('Function No longer supported: InstallUserDriver');
    {$endif}   

   LogLn('Function No longer supported: InstallUserDriver');
end;

procedure RegisterBGIDriver(driver: pointer);

begin
    {$ifdef lcl}
			ShowMessage('Function No longer supported: RegisterBGIDriver');
    {$endif}   


   LogLn('Function No longer supported: RegisterBGIDriver');
end;


function GetMaxColor: word;
//Use "MaxColors" if looking to use Random(Color).
//This gives you the HUMAN READABLE MAX amount of colors available.
  
begin
      GetMaxColor:=MaxColors+1; // based on an index of zero so add one 255=>256
end;



//AllocMem a new texture and flap data onto screen (or scrape data off of it) into a file.


//yes we can do other than BMP.

procedure LoadImage(filename:PChar; Rect:PSDL_Rect);
//Rect: I need to know what size you want the imported image, and where you want it.

var
  tex:PSDL_Texture;

begin

    tex:= NiL;
    Tex:=IMG_LoadTexture(renderer,filename);
    SDL_RenderCopy(renderer, tex, Nil, rect); //PutImage at x,y but only for size of WxH
end;

procedure LoadImageStretched(filename:PChar);

var
  tex:PSDL_Texture;

begin

    tex:= NiL;
    Tex:=IMG_LoadTexture(renderer,filename); 
    SDL_RenderCopy(renderer, tex, Nil, Nil); //scales image to output window size(size of undefined Rect)
end;

//linestyle is: (patten,thickness) "passed together" (QUE)
//this uses thickness variable only

procedure PlotPixelWNeighbors(x,y:integer);
//this makes the bigger Pixels
 
// (in other words "blocky bullet holes"...)  
// EXPERT topic: smoothing reduces jagged edges

begin                
   //more efficient to render a Rect.

   New(Rect);
   Rect^.x:=x;
   Rect^.y:=y;
   case (Thick) of
       NormalWidth: begin
             Rect^.w:=2;
			 Rect^.h:=2;   
       end;
       ThickWidth: begin  
             Rect^.w:=4;
			 Rect^.h:=4;   
       end;
       SuperThickWidth: begin
             Rect^.w:=6;
			 Rect^.h:=6;   
       end;
       UltimateThickWidth: begin  
             Rect^.w:=8;
			 Rect^.h:=8;   
       end;
   end;
   SDL_RenderFillRect(renderer, rect);
// limit calls to "render present"
//   SDL_RenderPresent(renderer);
   dispose(Rect);
   //now restore x and y
   case Thick of
		NormalWidth:begin
			x:=x+2;
			y:=y+2;   		
		end;
		ThickWidth:begin
			x:=x+4;
			y:=y+4;  
		end;
		SuperThickWidth: begin
            x:=x+6;
			y:=y+6;  
       end;
       UltimateThickWidth: begin  
            x:=x+8;
			y:=y+8;  
       end;
   end;
end;



procedure SaveBMPImage(filename:string);
//hmmm stuck with this for time being
var
  ScreenData:Pointer;
  infosurface,savesurface:PSDL_Surface;

begin
//the downside is that upon ea sdl init for our app/game..this resets.

  filename:='screenshot'+intTostr(screenshots)+'.bmp';
  //screenshotXXXXX.BMP
  saveSurface := NiL;
  infosurface:=Nil;
  ScreenData:=Nil;
  ScreenData:=GetPixels(Nil); 
  
  infoSurface := SDL_GetWindowSurface(Window);
  saveSurface := SDL_CreateRGBSurfaceWithFormatFrom(ScreenData, infoSurface^.w, infoSurface^.h, infoSurface^.format^.BitsPerPixel, (infoSurface^.w * infoSurface^.format^.BytesPerPixel), longword(infoSurface^.format));

  if (saveSurface = NiL) then begin
    {$ifdef lcl}
			ShowMessage('Couldnt create SDL_Surface from renderer pixel data');
    {$endif}   

      if IsConsoleInvoked then begin
          LogLn('Couldnt create SDL_Surface from renderer pixel data');      
          LogLn(SDL_GetError);
      end;
      exit;
                    
  end;
  SDL_SaveBMP(saveSurface, filename);
  SDL_FreeSurface(saveSurface);
  saveSurface := NiL;
  infosurface:=Nil;
  ScreenData:=Nil;
  inc(Screenshots);
end;


//note this function is "slow ASS"


function GetPixels(Rect:PSDL_Rect):pointer;
//this does NOT return a single pixel by default and is written intentionally that way.
//GetPixel checks also the output pointer length and fudges it into a single "SDL_Color".

//this routine expects YOU to handle the array of data
//SDL_Color SDL_Color SDL_Color .....

var

  pitch:integer;
  pixels:pointer; //^array [0..x*y] of SDL_Color

{
  the array size is dependant on current screen resoluton- I can only give MAXIMUM defaults if I set this value.
  This is an SDL_Color limitation. If it were me, Id just copy the array in 2D, not 1D.
  Yes, technically, even kernel write to screen are stored in VRAM(or buffers) as:
		[X,Y,RGBColor] however...SDL treats it as a 1D array.

  I didnt design SDL, sorry. Maybe thats why its SLOW???
  src: VGA graphics 101 - address A000, 386+ VRAM (and LFB) access.
  NOTE: 
     You probly CANNOT directly write here.. (blame X11 or Windows or Apple)
     (Because youre staring at the array right now, reading this.)
}

  AttemptRead:integer;

begin
   if ((Rect^.w=1) or (Rect^.h=1)) then begin    
     if IsConsoleInvoked then begin       
        LogLn('USE GetPixel. This routine FETCHES MORE THAN ONE');
     end;  
    {$ifdef lcl}
			ShowMessage('USE GetPixel. This routine FETCHES MORE THAN ONE');
    {$endif}   

     exit;
   end;

   pixels:=Nil;
   pitch:=0;

                 
    case bpp of
		8: begin
			    if maxColors=256 then format:=SDL_PIXELFORMAT_INDEX8
				else if maxColors=16 then format:=SDL_PIXELFORMAT_INDEX4MSB; 
		end;
		15: format:=SDL_PIXELFORMAT_RGB555;

//we assume on 16bit that we are in 565 not 5551, we should not assume
		16: begin
			
			format:=SDL_PIXELFORMAT_RGB565;

        end;
		24: format:=SDL_PIXELFORMAT_RGB888;
		32: format:=SDL_PIXELFORMAT_RGBA8888;

    end;
//format and rect we already can derive
//pixels and pitch will be returned for the given rect in SDL_Color format given by our set definition
//rect is Nil to copy the entire rendering target

   AttemptRead:= SDL_RenderReadPixels( renderer, rect, format, pixels, pitch);
   
   //pitch at this point could be 2,3,4,etc.. and must otherwise be taken into account.
   if (AttemptRead<0) then begin
    {$ifdef lcl}
			ShowMessage('Attempt to read pixel data failed.');
    {$endif}   

      if IsConsoleInvoked then begin
          LogLn('Attempt to read pixel data failed.');
          LogLn(SDL_GetError);
      end;
     exit;
   end;
   GetPixels:=pixels;
end;

//gotoxy
   Procedure MoveTo(X,Y: smallint);
  {********************************************************}
  { Procedure MoveTo()                                     }
  {--------------------------------------------------------}
  { Moves the current pointer in VIEWPORT relative         }
  { coordinates to the specified X,Y coordinate.           }
  {********************************************************}
    Begin
     where.X := X;
     where.Y := Y;
    end;

//utility function(DWord to float)
function DWordToSingle(Data: DWord; EndianSwap: Boolean): Single;

var
   ASingle: Single absolute Data;

begin
   if EndianSwap then
		SwapEndian(DWord(Data));

   Result := ASingle;
end;
    
begin  //main()

//while I dont like the assumption that all linux apps are console apps- technically its true.

{$IFDEF LCL}
        Log:=true; //we have output window in DEBUG mode (in windows too!)
		IsConsoleInvoked:=false; //ui app- NO CONSOLE AVAILABLE
{$ENDIF}

{$IFDEF mswindows}
	if (not IsWindowsXP) or (not IsVistaOrGreater) then
		LogLn('OpenGL 2.0+ not detected on Windows or not running in Win32 environment.');
		LogLn('Try SDL v.1 routines on these platforms.');
		LogLN('Laz Gfx refusing to run.');
		halt(0);
{$endif}

{$IFDEF unix}
  IsConsoleInvoked:=true; //All Linux apps are console apps

  if (GetEnvironmentVariable('DISPLAY') = '') then begin //init frameBuffer code here


//old behaviour 
    LogLN('X11 has not fired. Bailing.');	
    halt(0);

  end;   
{$ENDIF}


//with initgraph (as a function) it returns one of these codes
//these are the strings of the error codes

   screenshots:=00000000;

   windownumber:=0;
   grErrorStrings[0]:='No Error';
   grErrorStrings[1]:='Not enough memory for graphics';
   grErrorStrings[2]:='Not enough memory to load font';
   grErrorStrings[3]:='Font file not found';
   grErrorStrings[4]:='Invalid graphics mode';
   grErrorStrings[5]:='General Graphics error';
   grErrorStrings[6]:='Graphics I/O error';
   grErrorStrings[7]:='Invalid font';

end.
