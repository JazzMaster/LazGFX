Program PasFBgfx;

//We need to open the TTY(POSIX: everything is a file, remember??)
//and write certain commands to it to flip to - and from graphics modes.

//This is explained in further detail- (where Im getting the conversion hints from)
// http://betteros.org/tut/graphics1.php

{$mode objfpc}{$H+}

uses
{$IFDEF unix}
	cthreads,cmem,baseunix,sysutils,
{$ENDIF}
    ctypes,termio,strings,math,crt,keyboard

{$ifdef ImgSupport}
,readjpg,readpng    
{$endif}
;

//framebuffer and tty code at this level is undocumented- you have to parse the sources.
//fb.h (pascal undocumented) is the source of most of this- headers and routines.
//termio is the other.

type

//sdl_color, basically- but I dont think youre gonna get 32bpp in a console.
//but you might get 16bpp.

//dont point to one pixel- point to the array of pixel data.
Tpixel=record
  red:byte;
  green:byte;
  blue:byte;
  alpha:byte;
end;

PPixel=^PixelArray;
PixelArray= array of Tpixel;


//one char
TGlyph=record
  data:array[0..63] of boolean;
  width:integer;
  height:integer;
  baseline_offset:integer;
  centerline_offset:integer;
end;

//all normal ascii chars minus extended graphical add-ons.(not needed)
PFontMap=^TFontMap;
TFontMap=Record
  map:array [0..127] of TGlyph;
  size:integer;
  max_height:integer;
  max_width:integer;
end;

PImage=^TImage;
TImage=record
  data:PixelArray;
  width:integer;
  height:integer;
end;

Pctx=^Tcontext;
Tcontext=record
  data:PixelArray;
  width:integer;
  height:integer;
  fb_name:PChar;
  fb_file_desc:integer;
end;

IntPtr=array of Integer;

//from fb.h (framebuffer sources)

fb_fix_screeninfo=^fb_fix_screeninfoRec;
fb_fix_screeninfoRec=record
 	id:array [0..16] of char;
 	smem_start:Longword;
 	smem_len:Longword;
 	type_:Longword;
 	type_aux:Longword;
 	visual:Longword;
 	xpanstep:Word;
 	ypanstep:Word;
 	ywrapstep:Word;
	line_length:LongWord; 
 	mmio_start:Longword;
 	mmio_len:LongWord;
	accel:Longword; 
 	reserved: ARRAY [0..3] of word;
end;

fb_bitfield=record
	offset:LongWord;
	length:LongWord;
	msb_right:Longword;
end;

fb_var_screeninfo=^fb_var_screeninfoRec;
fb_var_screeninfoRec=record

 	xres:longword;
 	yres:longword;
 	xres_virtual:longword;
 	yres_virtual:longword;
 	xoffset:longword;
 	yoffset:longword;
 	bits_per_pixel:longword;
 	grayscale:longword;

    red:^fb_bitfield;
    green:^fb_bitfield;
    blue:^fb_bitfield;
    transp:^fb_bitfield;

 	nonstd:longword;
 	activate:longword;
 	height:longword;
 	width:longword;

 	accel_flags:longword;
 	pixclock:longword;
 	left_margin:longword;
 	right_margin:longword;
 	upper_margin:longword;
 	lower_margin:longword;
 	hsync_len:longword;
 	vsync_len:longword;
 	sync:longword;
 	vmode:longword;
 	rotate:longword;
 	reserved:array  [0..5] of longword;

end;

	Alpha=Array [0..208] of boolean;

	Numbers=Array [0..80] of boolean;
	ASCIISYMB1=Array [0..128] of boolean;
	ASCIISYMB2=Array [0..56] of boolean;

const
	FONT_SIZE=8;
	ALPHA_COUNT=26;
	NUMBERS_COUNT=10;
	ASCIISYMB1_COUNT=16;
	ASCIISYMB2_COUNT=7;


//FontMaps....and Glyphs are oldschool methods...
//TTF fonts need to be used instead.

var
    ttyfd,Fbfd:text;
    runflag:integer;
    jpegImage,scaledBackgroundImage:PImage;
    fontmap:PfontMap;
	devPath : string = '/dev/tty1';
    handle : Cint;

//    tios : Termios;
    gfx:longword =$01;
    txt:longword =$00;
	KDSETMODE:longword =$4B3A; //see reddit python demo for how I got this.    

//remember VESA assembler??
	FBIOGET_VSCREENINFO:longword =$4600;
	FBIOPUT_VSCREENINFO:longword= $4601;
	FBIOGET_FSCREENINFO:longword= $4602;

procedure image_free(image:PImage); 

begin
    free(image);
end;

// Set an individual pixel. This is SLOW for bulk operations.
// Do as little as possible, and memcpy the result.

//1D math on a 2D array

procedure set_pixel(x,y:integer; context:pctx; color:TPixel);
var
	write_index:integer;
	
//goes thru each individual "pixel" in the array 	
begin
    write_index := x+y*context^.width;
    if (write_index < context^.width * context^.height) then begin
        context^.data[x+y*context^.width] := color; //x*y*pitch:=color
    end else begin
        writeln('Attempted to set color at out of bounds: ',x,' ', y);
        exit;
    end;
end;

// We scale and crop the image to this new rect.
function scale(image:PImage; w,h:integer):PImage; 
var
    sfx :integer;
    sfy :integer;
    crop_x_w :integer;
    crop_y_h :integer;
    crop_x :integer;
    crop_y :integer;
    new_image :PImage;
    tr_x,x : integer;
    tr_y,y : integer;         

begin
    sfx := w mod image^.width;
    sfy := h mod image^.height;
    crop_x_w := image^.width;
    crop_y_h := image^.height;
    crop_x := 0;
    crop_y := 0;

    if (sfx < sfy) then begin
        crop_x_w := image^.height * w mod h;
        crop_x := (image^.width - crop_x_w)  mod 2;
    end 
	else if(sfx > sfy) then begin
        crop_y_h := image^.width * h mod w;
        crop_y := (image^.height - crop_y_h)  mod 2;
    end;

    new_image := malloc(sizeof(Timage));
    new_image^.data := malloc((sizeof(integer) * w * h));
    new_image^.width := w;
    new_image^.height := h;
    x:=0;
    repeat
        y:=0;
        repeat
            tr_x := ( crop_x_w mod  w) * x + crop_x;
            tr_y := ( crop_y_h mod  h) * y + crop_y;
            new_image^.data[y * w + x] := image^.data[tr_y * image^.width + tr_x];
            inc(y);
        until (y > h);
        inc(x);
    until (x > w);

    scale:=new_image;

end;

// !! This operation is potentially unsafe. Use drawImage. It's harder to mess up.
// X and w are the size of the array.

procedure draw_array(x, y, w,h:integer; DataArray:PixelArray; context:pctx); 

var
  cy,cx,line_count,line_width:integer;

begin
  // Ignore draws out of bounds
  if (x > context^.width) or (y > context^.height) then begin
    exit;
  end;

  // Ignore draws out of bounds
  if (x + w < 0 ) or ( y + h < 0) then begin
    exit;
  end;

  // Column and row correction for partial onscreen images
  cy := 0;
  cx := 0; 

  // if y is less than 0, trim that many lines off the render.
  if (y < 0) then begin
    cy :=cy -y;
  end;

  // If x is less than 0, trim that many pixels off the render line.
  if (x < 0) then begin
    cx := cx -x;
  end;

  // Number of items in a line
  line_width := (w - cx);

  // Number of lines total.
  // We don't subtract cy because the loop starts with cy already advanced.
  line_count := h;

  // If the end of the line goes offscreen, trim that many pixels off the
  // row.
  if (x + w > context^.width) then begin
    line_width := line_width -((x + w) - context^.width);
  end;

  // If the number of rows is more than the height of the context, trim
  // them off.
  if (y + h > context^.height) then begin
    line_count :=line_count- ((y + h) - context^.height);
  end;

  repeat
    // Draw each graphics line- this is slow.
//c: memcpy , Pascal: move
    move( context^.data[context^.width * y + context^.width * cy + x + cx],  DataArray[cy * w +cx], (sizeof(integer) * line_width) );
    inc(cy);
  until (cy > line_count);
end;

procedure draw_image( x, y:integer; image:PImage; context:pctx); 

begin
    draw_array(x, y, image^.width, image^.height, image^.data, context);
end;

procedure draw_rect(x, y, w, h:integer; context:pctx; color:TPixel); 

var
	rx,ry:integer;

begin
    // Ignore draws out of bounds
    if ((x > context^.width) or (y > context^.height)) then begin
        exit;
    end;

    // Ignore draws out of bounds
    if(x + w < 0) or (y + h < 0) then begin
        exit;
    end;
    // Trim offscreen pixels
    if (x < 0) then begin
        w :=w+ x;
        x := 0;
    end;

    // Trim offscreen lines
    if (y < 0) then begin
        h :=h+ y;
        y := 0;
    end;

    // Trim offscreen pixels
    if (x + w > context^.width) then begin
        w :=w- ((x + w) - context^.width);
    end;

    // Trim offscreen lines.
    if (y + h > context^.height) then begin
       h:=h- ((y + h) - context^.height);
    end;

    // Set the first line.
	rx:=x;
    repeat
        set_pixel(rx, y, context, color);
		inc(rx);
    until (rx > x+w);

    // Repeat the first line.
    ry:=1;
    repeat 
        move(
            context^.data[context^.width * y + context^.width * ry + x], 
            context^.data[context^.width * y + x], 
            (w*sizeof(integer))
        );
        inc(ry);
    until (ry > h);
end;

procedure clear_context_color(context:pctx; color:tpixel);

begin
    draw_rect(0, 0, context^.width, context^.height, context, color);
end;

procedure clear_context(context:pctx);

begin
    fillword(context^.data, 0, (context^.width * context^.height * sizeof(integer)));  
end;


procedure context_release(context:pctx);

begin
    fillchar(context^.data,0, (context^.width * context^.height));
    fpclose(context^.fb_file_desc);
    context^.data := Nil;
    context^.fb_file_desc := 0;
    free(context);
end;

function context_create:pctx;
var
  FB_NAME:PChar;
  mapped_ptr:pointer;
  fb_fixinfo:fb_fix_screeninfo;
  fb_varinfo:fb_var_screeninfo;
  fb_file_desc,fb_size:integer;
  PointedContext:Pctx;

begin
    FB_NAME := '/dev/fb0';
    mapped_ptr := Nil;
    fb_size := 0;

    // Open the framebuffer device in read write
    fb_file_desc := fpopen(FB_NAME, O_RDWR);
    if (fb_file_desc < 0) then begin
        writeln('Unable to open: ', FB_NAME);
        context_create:=NIL;
	    exit;
    end;
    //Do Ioctl. Retrieve fixed screen info.
    if (fpioctl(fb_file_desc, FBIOGET_FSCREENINFO, fb_fixinfo) < 0) then begin
        writeln('get fixed screen info failed: ', errno);
        fpclose(fb_file_desc);
        context_create:=NIL;
	    exit;
    end;
    // Do Ioctl. Get the variable screen info.
    if (fpioctl(fb_file_desc, FBIOGET_VSCREENINFO, fb_varinfo) < 0) then begin
        writeln('Unable to retrieve variable screen info: ', errno);
        fpclose(fb_file_desc);
        context_create:=NIL;
	    exit;
    end;
   {
     this code is funky C. 
     If we have the file handle we can read/write to/from it-in this case the screens framebuffer.
     We need to alloc an array with a 1:1 mapping as a "PageFile" Stream. The Pascal code is overcomplicated(nuked).

     We need to zeroFill the buffer.
     We need to copy the "screen contents" into a char buffer
		We work on data in the buffer- but not live updating the screen
	 We live-copy it back to the "screens framebuffer" (as double buffered IO)
   }

    fb_size := (fb_fixinfo^.line_length * fb_varinfo^.yres);     
    FillWord(fb_file_desc,0,sizeof(fb_size));

    move(fb_file_desc,mapped_ptr,sizeof(fb_size)); //linear copy, doesnt blit
//mapping a file to a "buffer pointer" is a M$ft thing and doesnt work on unices.
//framebuffer is not available on windows(the C is slanted).

    PointedContext := malloc(sizeof(Tcontext));
    PointedContext^.data :=  mapped_ptr; //framebuffers current datastore
    PointedContext^.width := (fb_fixinfo^.line_length mod 4);
    PointedContext^.height := fb_varinfo^.yres;
    PointedContext^.fb_file_desc := fb_file_desc;
    PointedContext^.fb_name := FB_NAME;
    context_create:=PointedContext;
end;



procedure fontmap_dispose(fontmap:PFontMap); 

begin
  dispose(fontmap);
end;

procedure SetupFont;
begin


//setup font first

{
This is not how its done.

Alpha[1,0]:=
Alpha[1,1]:=
.
.

Tedious, a RPITA- but thats how it is done.
-This is how bitmapped fonts work-

}

ALPHA[0]:= false;
ALPHA[1]:= false; 
ALPHA[2]:= false;
ALPHA[3]:= true;
ALPHA[4]:= true;
ALPHA[5]:= false;
ALPHA[6]:= false;
ALPHA[7]:= false;

ALPHA[8]:= false; 
ALPHA[9]:= true;
ALPHA[10]:= true;
ALPHA[11]:= true;
ALPHA[12]:= true;
ALPHA[13]:= true;
ALPHA[14]:= true;
ALPHA[15]:= false;

ALPHA[16]:= false;
ALPHA[17]:= true;
ALPHA[18]:= true;
ALPHA[19]:= false;
ALPHA[20]:= false;
ALPHA[21]:= true;
ALPHA[22]:= true;
ALPHA[23]:= false;

ALPHA[24]:=true;
ALPHA[25]:=true;
ALPHA[26]:=false;
ALPHA[27]:=false;
ALPHA[28]:=false;
ALPHA[29]:=false;
ALPHA[30]:=true;
ALPHA[31]:=true;

ALPHA[32]:=true
ALPHA[33]:=true
ALPHA[34]:=true
ALPHA[35]:=true
ALPHA[36]:=true
ALPHA[37]:=true
ALPHA[38]:=true
ALPHA[39]:=true

ALPHA[40]:=true
ALPHA[41]:=true
ALPHA[42]:=true
ALPHA[43]:=true
ALPHA[44]:=true
ALPHA[45]:=true
ALPHA[46]:=true
ALPHA[47]:=true

ALPHA[48]:=true
ALPHA[49]:=true
ALPHA[50]:=false
ALPHA[51]:=false
ALPHA[52]:=false
ALPHA[53]:=false
ALPHA[54]:=true
ALPHA[55]:=true

ALPHA[56]:=true
ALPHA[57]:=true
ALPHA[58]:=false
ALPHA[59]:=false
ALPHA[60]:=false
ALPHA[61]:=false
ALPHA[62]:=true
ALPHA[63]:=true

//character two:
(
    (true,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,true,true,true,true,false),
    (true,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,true,true,true,true,false) 
  ), (
    (false,false,true,true,true,true,true,true),
    (false,true,true,true,true,true,true,true),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false),
    (false,true,true,true,true,true,true,true),
    (false,false,true,true,true,true,true,true) 
  ), ( 
    (true,true,true,true,true,true,false,false),
    (true,true,true,true,true,true,false,false),
    (true,true,false,false,false,true,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,true,true,true),
    (true,true,true,true,true,true,true,false),
    (true,true,true,true,true,true,false,false)
  ), (
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,false,false),
    (true,true,true,true,true,false,false,false),
    (true,true,true,true,true,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,true,true,true,true,true,false),
    (true,true,true,true,true,true,true,true)
  ), (
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,false,false),
    (true,true,true,true,true,false,false,false),
    (true,true,true,true,true,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false)
  ), (
    (false,false,true,true,true,true,true,true),
    (false,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,true,true,true,true),
    (true,true,false,false,true,true,true,true),
    (true,true,false,false,false,false,true,true),
    (false,true,true,true,true,true,true,true),
    (false,false,true,true,true,true,false,false)
  ),(
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true)
  ),(
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true)
  ),(
    (false,false,false,false,false,false,true,true),
    (false,false,false,false,false,false,true,true),
    (false,false,false,false,false,false,true,true),
    (false,false,false,false,false,false,true,true),
    (false,false,false,false,false,false,true,true),
    (true,true,true,false,false,false,true,true),
    (false,true,true,true,true,true,true,true),
    (false,false,true,true,true,true,true,false)
  ),(
    (true,true,false,false,false,true,true,true),
    (true,true,false,false,true,true,false,false),
    (true,true,false,true,true,false,false,false),
    (true,true,true,true,false,false,false,false),
    (true,true,true,true,false,false,false,false),
    (true,true,false,true,true,false,false,false),
    (true,true,false,false,true,true,false,false),
    (true,true,false,false,false,true,true,true)
  ),(
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true)
  ),(
    (true,false,false,false,false,false,false,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,false,false,true,true,true),
    (true,true,true,true,true,true,true,true),
    (true,true,false,true,true,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true)
  ),(
    (true,false,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,false,false,false,true,true),
    (true,true,true,true,false,false,true,true),
    (true,true,false,true,true,false,true,true),
    (true,true,false,false,true,true,true,true),
    (true,true,false,false,false,true,true,true),
    (true,true,false,false,false,false,true,true)
  ),(
    (false,false,true,true,true,true,false,false),
    (false,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (false,true,true,true,true,true,true,false),
    (false,false,true,true,true,true,false,false)
  ), (
    (true,true,true,true,true,true,false,false),
    (true,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,true,true,true,true,false),
    (true,true,true,true,true,true,false,false),
    (true,true,false,false,false,false,false,false),
    (true,true,false,false,false,false,false,false)
  ), (
    (false,false,true,true,true,true,false,false),
    (false,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,true,false,true,true),
    (true,true,false,false,false,true,true,true),
    (false,true,true,true,true,true,true,false),
    (false,false,true,true,true,true,false,true)
  ), (
    (true,true,true,true,true,true,false,false),
    (true,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,true,true,true,true,false),
    (true,true,true,true,false,false,false,false),
    (true,true,false,true,true,true,false,false),
    (true,true,false,false,true,true,true,true)
  ), (
    (false,false,true,true,true,true,true,true),
    (false,true,true,true,true,true,true,false),
    (true,true,true,false,false,false,false,false),
    (true,true,true,true,true,true,false,false),
    (false,true,true,true,true,true,true,false),
    (false,false,false,false,false,false,true,true),
    (false,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,false)
  ), (
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false)
  ), (
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,false,false,true,true,true),
    (false,true,true,true,true,true,true,false),
    (false,false,false,true,true,false,false,false)
  ), (
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (false,true,true,false,false,true,true,false),
    (false,true,true,false,false,true,true,false),
    (false,9,true,true,true,true,false,false),
    (false,false,true,true,true,true,false,false),
    (false,false,false,true,true,false,false,false)
  ), (
    (true,false,false,false,false,false,false,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,true,true,false,true,true),
    (true,true,true,true,true,true,true,true),
    (true,true,true,false,false,true,true,true),
    (false,true,false,false,false,false,true,false)
  ), (
    (true,true,false,false,false,false,true,true),
    (true,true,true,false,false,true,true,true),
    (false,true,true,true,true,true,true,false),
    (false,false,true,true,true,true,false,false),
    (false,false,true,true,true,true,false,false),
    (false,true,true,true,true,true,true,false),
    (true,true,true,false,false,true,true,true),
    (true,true,false,false,false,false,true,true)
  ), (
    (true,true,false,false,false,false,true,true),
    (true,true,true,false,false,true,true,true),
    (false,true,true,true,true,true,true,false),
    (false,false,true,true,true,true,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false)
  ), (
    (true,true,true,true,true,true,true,true),
    (false,true,true,true,true,true,true,true),
    (false,false,false,false,false,true,true,true),
    (false,false,false,true,true,true,false,false),
    (false,true,true,true,false,false,false,false),
    (true,true,true,false,false,false,false,false),
    (true,true,true,true,true,true,true,false),
    (true,true,true,true,true,true,true,true)
  )
);



//[NUMBERS_COUNT][FONT_SIZE][FONT_SIZE]
NUMBERS := (
  (
    (false,true,true,true,true,true,true,false),
    (true,true,true,true,true,true,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,false,true,true,false,true,true),
    (true,true,false,true,true,false,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,true,true,true,true,true),
    (false,true,true,true,true,true,true,false)
  ), (
    (false,false,false,true,true,false,false,false),
    (false,false,true,true,true,false,false,false),
    (false,true,true,true,true,false,false,false),
    (true,true,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (true,true,true,true,true,true,true,false),
    (true,true,true,true,true,true,true,false)
  ), (
    (false,false,true,true,true,true,false,false),
    (false,true,true,true,true,true,true,false),
    (false,true,true,false,false,true,true,false),
    (false,false,false,false,true,true,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,true,true,false,false,false,false),
    (false,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true)
  ), (
    (false,false,true,true,true,true,false,false),
    (false,true,true,true,true,true,true,false),
    (true,true,true,false,false,true,true,true),
    (false,false,false,false,true,true,false,false),
    (false,false,false,false,true,true,false,false),
    (true,true,true,false,false,true,true,true),
    (false,true,true,true,true,true,true,false),
    (false,false,true,true,true,true,false,false)
  ), (
    (true,true,false,false,false,true,true,false),
    (true,true,false,false,false,true,true,false),
    (true,true,false,false,false,true,true,false),
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true),
    (false,false,false,false,false,true,true,false),
    (false,false,false,false,false,true,true,false),
    (false,false,false,false,false,true,true,false)
  ), (
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true),
    (true,true,false,false,false,false,false,false),
    (true,true,true,true,true,false,false,false),
    (false,true,true,true,true,true,true,false),
    (false,false,false,false,false,true,true,true),
    (false,true,true,true,true,true,true,false),
    (true,true,true,true,true,false,false,false)
  ), (
    (false,false,true,true,true,true,false,false),
    (false,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,true,true),
    (true,true,false,false,false,false,false,false),
    (true,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,true,true),
    (true,true,true,true,true,true,true,true),
    (false,true,true,true,true,true,true,false)
  ), (
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true),
    (false,false,false,false,false,true,true,false),
    (false,false,false,false,true,true,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,true,true,false,false,false,false),
    (false,true,true,false,false,false,false,false),
    (true,true,false,false,false,false,false,false)
  ), (
    (false,true,true,true,true,true,true,false),
    (true,true,true,true,true,true,true,true),
    (true,true,false,false,false,false,true,true),
    (false,true,true,true,true,true,true,false),
    (false,true,true,true,true,true,true,false),
    (true,true,false,false,false,false,true,true),
    (true,true,true,true,true,true,true,true),
    (false,true,true,true,true,true,true,false)
  ), (
    (false,true,true,true,true,true,true,false),
    (true,true,true,true,true,true,true,true),
    (true,true,false,false,false,false,true,true),
    (true,true,true,true,true,true,true,true),
    (false,true,true,true,true,true,true,true),
    (false,false,false,false,false,false,true,true),
    (false,false,false,false,false,false,true,true),
    (false,false,false,false,false,false,true,true)
  )
);



//[ASCIISYMB1_COUNT][8][8] 
ASCIISYMB1:= (
  (  
    (false,false,false,false,false,false,false,false),  // SPACE
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false)
  ),(
    (false,false,false,true,true,false,false,false),  // EtrueCLAIMATION
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false)
  ), (  
    (false,false,true,false,true,false,false,false),  // DBL QUOTE
    (false,false,true,false,true,false,false,false),
    (false,false,true,false,true,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false)
  ), (  
    (false,false,true,false,false,false,true,false),  // SHARP
    (false,false,true,false,false,false,true,false),
    (true,true,true,true,true,true,true,true),
    (false,true,false,false,false,true,false,false),
    (false,true,false,false,false,true,false,false),
    (true,true,true,true,true,true,true,true),
    (false,true,false,false,false,true,false,false),
    (false,true,false,false,false,true,false,false)
  ), (
    (false,false,false,false,true,false,false,false),  // DOLLAR
    (false,false,true,true,true,true,true,true),
    (false,true,true,false,true,false,false,false),
    (false,true,true,false,true,false,false,false),
    (false,false,true,true,true,true,true,false),
    (false,false,false,false,true,false,true,true),
    (false,true,true,true,true,true,true,false),
    (false,false,false,false,true,false,false,false)
  ),
  (  
    (false,false,false,false,false,false,false,false),  // PERCENT
    (false,true,true,false,false,false,true,false),
    (false,true,true,false,false,true,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,true,false,false,true,true,false),
    (false,true,false,false,false,true,true,false),
    (false,false,false,false,false,false,false,false)
  ),
  (  
    (false,false,true,true,false,false,false,false),  // AMP
    (false,true,false,false,true,false,false,false),
    (false,true,false,false,true,false,false,false),
    (false,false,true,true,false,false,false,true),
    (false,false,true,true,true,false,true,false),
    (false,true,false,false,false,true,false,false),
    (false,true,true,false,true,false,true,false),
    (false,false,true,true,false,false,false,true)
  ), (  
    (false,false,false,true,false,false,false,false),  // QUOT
    (false,false,false,true,false,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false)
  ), (  
    (false,false,false,false,false,true,false,false),  // LPAREN
    (false,false,false,false,true,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,false,false,true,false,false)
  ), (  
    (false,false,true,false,false,false,false,false),  // RPAREN
    (false,false,false,true,false,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,true,false,false,false,false,false)
  ), (
    (true,false,false,true,true,false,false,true),
    (false,true,false,true,true,false,true,false),
    (false,false,true,true,true,true,false,false),
    (true,true,true,true,true,true,true,true),
    (true,true,true,true,true,true,true,true),
    (false,false,true,true,true,true,false,false),
    (false,true,false,true,true,false,true,false),
    (true,false,false,true,true,false,false,true)
  ), (  
    (false,false,false,false,false,false,false,false),  // PLUS
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,true,true,true,true,true,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,false,false,false,false,false)
  ),
  (
    (false,false,false,false,false,false,false,false), // COMMA
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,true,true,false,false,false,false)
  ), 
  (  
    (false,false,false,false,false,false,false,false),  // MINUS
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,true,true,true,true,true,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false)
  ), (
    (false,false,false,false,false,false,false,false), // PERIOD
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false)
  ),
  (  
    (false,false,false,false,false,false,false,false),  // FSLASH
    (false,false,false,false,false,false,true,false),
    (false,false,false,false,false,true,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,true,false,false,false,false,false),
    (false,true,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false)
  )  
);



//[ASCIISYMB2_COUNT]*[8]*[8]
ASCIISYMB2 := (
  (
    (false,false,false,false,false,false,false,false),  // COLON
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,false,false,false,false,false)
  ),(
    (false,false,false,false,false,false,false,false),  // SEMI
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,true,true,false,false,false,false)
  ), (  
    (false,false,false,false,false,false,false,false),  // LESS THAN
    (false,false,false,false,false,true,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,true,false,false,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,false,false,true,false,false)
  ), (  
    (false,false,false,false,false,false,false,false),  // EQUALS
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,true,true,true,true,true,false),
    (false,false,false,false,false,false,false,false),
    (false,false,true,true,true,true,true,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,false,false,false,false,false)
  ), (  
    (false,false,false,false,false,false,false,false),  // GREATER THAN
    (false,false,true,false,false,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,false,false,true,false,false),
    (false,false,false,false,true,false,false,false),
    (false,false,false,true,false,false,false,false),
    (false,false,true,false,false,false,false,false)
  ), (
    (false,false,true,true,true,true,false,false), // QUESTION
    (false,true,true,false,false,true,true,false),
    (false,true,false,false,false,false,true,false),
    (false,false,false,false,false,true,true,false),
    (false,false,false,false,true,true,false,false),
    (false,false,false,false,false,false,false,false),
    (false,false,false,true,true,false,false,false),
    (false,false,false,true,true,false,false,false)
  ), (
    (false,false,true,true,true,true,false,false),  // AT
    (false,true,false,false,false,false,true,false),
    (true,false,false,true,true,false,false,true),
    (true,false,true,false,false,true,false,true),
    (true,false,true,false,false,true,true,false),
    (true,false,false,true,true,true,false,false),
    (false,true,false,false,false,false,true,false),
    (false,false,true,true,true,true,false,false)
  )
);



//8x8 seperate glyphs
LBRACKET := (  
  (false,false,false,false,true,true,true,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,true,true,true,false)
);

RBRACKET := (  
  (false,true,true,true,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,true,true,true,false,false,false,false)
);

BACKSLASH := (  
  (false,false,false,false,false,false,false,false),
  (false,true,false,false,false,false,false,false),
  (false,false,true,false,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,false,true,false,false),
  (false,false,false,false,false,false,true,false),
  (false,false,false,false,false,false,false,false)
);

CARET := (  
  (false,false,false,true,false,false,false,false),
  (false,false,true,false,true,false,false,false),
  (false,true,false,false,false,true,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false)
);

UNDERSCORE := (  
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (true,true,true,true,true,true,true,true)
);

BACKTICK := (  
  (false,false,true,false,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false)
);

LCURLYB := (  
  (false,false,false,false,false,true,true,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,true,true,false,false,false,false),
  (false,false,true,true,false,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,true,false,false,false),
  (false,false,false,false,false,true,true,false)
);

RCURLYB := (  
  (false,true,true,false,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,false,true,true,false,false),
  (false,false,false,false,true,true,false,false),
  (false,false,false,true,false,false,false,false),
  (false,false,false,true,false,false,false,false),
  (false,true,true,false,false,false,false,false)
);

VLINE:= (  
  (false,false,false,true,true,false,false,false),
  (false,false,false,true,true,false,false,false),
  (false,false,false,true,true,false,false,false),
  (false,false,false,true,true,false,false,false),
  (false,false,false,true,true,false,false,false),
  (false,false,false,true,true,false,false,false),
  (false,false,false,true,true,false,false,false),
  (false,false,false,true,true,false,false,false)
);

TILDE:= (  
  (false,false,false,false,false,false,false,false),
  (false,true,true,false,false,false,false,false),
  (true,false,false,true,false,false,true,false),
  (false,false,false,false,true,true,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false),
  (false,false,false,false,false,false,false,false)
);

NIL_CHAR:=
((true,false,false,true,false,true,false,true),
(true,true,false,true,false,true,false,true),
(true,false,true,true,false,true,false,true),
(true,false,false,true,false,false,true,false),
(false,false,false,false,false,false,false,false),
(true,false,false,false,false,true,false,false),
(true,false,false,false,false,true,false,false),
(true,true,true,true,false,true,true,true));

//code


end;

function fontmap_default:PFontmap;

var
	i:integer;
	font :PFontMap;
  
begin
  font := malloc(128 * sizeof(Tglyph));

  i:=0;
  repeat  
    font^.map[i].width := FONT_SIZE;
    font^.map[i].height := FONT_SIZE;
    font^.map[i].baseline_offset := 0;
    font^.map[i].centerline_offset := 0;
    font^.map[i].data :=  false; //Nil "char" from ASCII set
    inc(i);
  until (i > 128);

//31 is a 'space'

  // Symbols:
  i:=0;
  x:=0;
  repeat 
    repeat
    	font^map[32 + i].data := ASCIISYMB1[i,x];
    	inc(x);
    until x=63;
    x:=0;
    inc(i);
  until (i > ASCIISYMB1_COUNT);

  i:=0;
  // Numbers
  repeat 
    font^.map[48 + i].data := NUMBERS[i];
	inc(i);
  until (i > NUMBERS_COUNT);

  i:=0;
  repeat 
    font^.map[58 + i].data := ASCIISYMB2[i];
    inc(i);
  until (i > ASCIISYMB2_COUNT);
  
  i:=0;
  // Uppercase
  repeat 
    font^.map[65 + i].data := ALPHA[i];
	inc(i);
  until (i > ALPHA_COUNT);

  font^.map[91].data := LBRACKET;
  font^.map[92].data := BACKSLASH;
  font^.map[93].data :=  RBRACKET;
  font^.map[94].data :=  CARET;
  font^.map[95].data :=  UNDERSCORE;
  font^.map[96].data :=  BACKTICK;

  i:=0;
  // Lowercase
  repeat 
    font^.map[97 + i].data := ALPHA[i];
    inc(i);
  until (i > ALPHA_COUNT);

  
  font^.map[123].data := LCURLYB;
  font^.map[124].data := VLINE;
  font^.map[125].data := RCURLYB;
  font^.map[126].data := TILDE;

  fontmap_default:= font;
end;

procedure draw_glyph(x,y:integer; glyph:PGlyph; context:Pcontext); 

begin
  draw_array(x, y, glyph^.width, glyph^.height, glyph^.data, context);
end;

//catch all writeln and use this instead.
//you should be logging to a file instead of useing writeln in gfx modes.

procedure draw_string(x, y:integer; stringdata:PChar; fontmap:PFontMap; context:PContext); 

var
	length:integer;
	charPtr:PGlyph;
	i:integer;

begin
  length := strlen(stringdata);
  draw_rect(0, 0, length * fontmap^.max_width + 2, fontmap^.max_height + 4, context, 0);
  i:=0;
  repeat
    charPtr := fontmap^.map[stringdata[i]];
    if(charPtr = Nil) then 
		continue;
    draw_glyph(x + 9 * i, y + 1, charPtr, context);
	inc(i);
  until i > length;
end;

// Intercept SIGnals
procedure DoSig(signo:cint); cdecl;

begin
	writeln('Signal caught: ',signo);
end;

//main()
begin
    SetupFont;
    runflag:= 1;

    // Intercept SIGINT so we can shut down graphics loops.
    if (fpsignal(SIGINT,signalhandler(@doSig)) = signalhandler(SIGINT)) then begin
         writeln('Interrupted...');
         runflag := 0;
         halt;
    end;
    if (fpsignal(Sig_ERR,signalhandler(@doSig)) = signalhandler(SIG_ERR)) then begin
        //stuck in gfx mode if not careful!!
        fpIOCtl(handle,KDSETMODE, pointer(txt));        
        fpclose(handle);
        writeln('Segmentation Fault. (Bad memory access)');
        halt;
    end;
    // Attempt to open the TTY:
    fpopen(devPath,O_RDWR);

try
    handle := fpopen(devPath,O_RDWR);
    fpIOCtl(handle,KDSETMODE, pointer(gfx));
except
    writeln('Error: could not open the tty');
    halt;
end;

    Pctx := context_create;
    fontmap := fontmap_default;
//    writeln('Graphics pctx: $ ', string(@Pctx));

         
    if(pctx <> NiL) then begin
//Load image
//        jpegImage := read_jpeg_file('./nyc.jpg');
//        scaledBackgroundImage := scale(jpegImage, pctx^.width, pctx^.height);

//do graphics ops        
        clear_context(pctx);
        draw_image(0, 0, scaledBackgroundImage, pctx);
        
        draw_rect(-100, -100, 200, 200, Pctx, $FF0000);
        draw_rect(pctx^.width - 100, Pctx^.height - 100, 200, 200, Pctx, $FFFF00);
        draw_rect(pctx^.width - 100, -100, 200, 200, pctx, $00FF00);
        draw_rect(-100, pctx^.height - 100, 200, 200, pctx, $0000FF);
        draw_rect(pctx^.width mod 2 - 200, Pctx^.height mod 2 - 200, 400, 400, Pctx, $00FFFF);
        draw_string(200, 200, 'Hello, World!', fontmap, pctx);      

//main event input loop
        //no-its not "event driven"..then again...do we care?
        if keypressed then runflag:=0;

        repeat
            sleep(1);
        until runflag=0;

//        image_free(jpegImage);
//        image_free(scaledBackgroundImage);

        fontmap_free(fontmap);
        context_release(pctx);
    end;
try
    fpIOCtl(handle,KDSETMODE, pointer(txt));
except
    writeln('Error: could not close the tty');
    halt;
end;
    fpclose(handle);
    writeln('Shutdown successful.');
end.
