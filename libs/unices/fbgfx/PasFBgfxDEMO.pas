Program PasFBgfx;
//the header must match the filename

//We need to open the TTY(POSIX: everything is a file, remember??)
//and write certain commands to it to flip to - and from graphics modes.

//This is explained in further detail- (where Im getting the conversion hints from)
// http://betteros.org/tut/graphics1.php

uses
{$IFDEF unix}
	cthreads,cmem,baseunix,sysutils,
{$ENDIF}
    ctypes,strings,math,crt,keyboard;
    //signals,fb,vt??

type

PGlyph=^TGlyph;
TGlyph=record

  data:^Integer;
  width:integer;
  height:integer;
  baseline_offset:integer;
  centerline_offset:integer;
end;

PFontMap=^TFontMap;
TFontMap=Record
  map:PGlyph;
  size:integer;
  max_height:integer;
  max_width:integer;
end;

PImage=^TImage;
TImage=record
  data:^integer;
  width:integer;
  height:integer;
end;

PContext=^TContext;
TContext=record
  data:^integer;
  int width:integer;
  int height:integer;
  fb_name:PChar;
  fb_file_desc:integer;
end;


//FontMaps....and Glyphs are oldschool methods...
//TTF fonts need to be used instead.


procedure fontmap_free(fontmap:PFontMap);
function fontmap_default:PFontMap;
procedure draw_string(x, y:integer; strint:PChar; fontmap:PFontMap; context:PContext);

procedure image_free(image:Pimage);
procedure set_pixel(x,y:integer; context:PContext; color:integer);
function scale(image:Pimage; w, h:integer):Pimage;
procedure draw_array(x, y, w,h:integer; IntArray:^Integer; context:Pcontext);
procedure draw_image(x, y:integer; image:PImage; context:PContext);
procedure draw_rect(x, y, w, h:integer; context:PContext, color:integer);
procedure clear_context_color(context:Pcontext; color:integer);
procedure clear_context(context:Pcontext);

procedure test_pattern(context:PContext);

procedure context_release(context:PContext);
function context_create:PContext;

{$ifdef ImgSupport}
	function read_png_file (filename:PChar):PImage;
    function read_jpeg_file (filename:PChar):Pimage;
{$endif}


var

    runflag,ttyfd:integer;
    jpegImage,scaledBackgroundImage:PTImage;
    fontmap:PfontMap;

// Intercept SIGINT
procedure sig_handler(signo:integer);


begin
    if (signo = SIGINT) then begin //may just want to wait for the task scheduler in the kernel...
        writeln('Interrupted...');
        runflag := 0;
    end;

    // If we segfault in graphics mode, we can't get out. So catch it.
    if (signo = SIGSEGV) then begin
        if (ttyfd = -1) then 
            writeln('Error: could not open the tty.');
        else 
            FpIOCtl(ttyfd, KDSETMODE, KD_TEXT);
        
        writeln('Segmentation Fault. (Bad memory access)');

        exit(1);
    end;
end;

//main()
begin
    
    runflag:= 1;

    // Intercept SIGINT so we can shut down graphics loops.
    if (signal(SIGINT, sig_handler) = SIG_ERR) then
         writeln('cant catch INTERRUPTS');
    
    if (signal(SIGSEGV, sig_handler) = SIG_ERR) then
        writeln('cant catch INVALID memory accesses');
    

    context := context_create;
    fontmap := fontmap_default;
    writeln('Graphics Context: $ ', context);

    
    // Attempt to open the TTY:

    Assign(filename,'/dev/tty1');
    ReWrite(filename);

    //try..except IOError..finally
    //makes a lot more sense


    if (ttyfd = -1) then
      writeln('Error: could not open the tty');
    else begin
      // This line enables graphics mode on the tty.
      FpIOCtl(ttyfd, KDSETMODE, KD_GRAPHICS);
    end;
  
   
    if(context <> NiL) then begin
//Load image
        jpegImage := read_jpeg_file('./nyc.jpg');
        scaledBackgroundImage := scale(jpegImage, context^.width, context^.height);

//do graphics ops        
        clear_context(context);
        draw_image(0, 0, scaledBackgroundImage, context);
        
        draw_rect(-100, -100, 200, 200, context, $FF0000);
        draw_rect(context^.width - 100, context^.height - 100, 200, 200, context, $FFFF00);
        draw_rect(context^.width - 100, -100, 200, 200, context, $00FF00);
        draw_rect(-100, context^.height - 100, 200, 200, context, $0000FF);
        draw_rect(context^.width / 2 - 200, context^.height / 2 - 200, 400, 400, context, $00FFFF);
        draw_string(200, 200, "Hello, World!", fontmap, context);      

//main event input loop
        //no-its not "event driven"..then again...do we care?
        if keypressed then runflag:=0;

        repeat
            sleep(1);
        until runflag=0;

        image_free(jpegImage);
        image_free(scaledBackgroundImage);
        fontmap_free(fontmap);
        context_release(context);
    end;
    
    FpIOCtl(ttyfd, KDSETMODE, KD_TEXT);
    close(ttyfd);
  
    writeln('Shutdown successful.');

end.

