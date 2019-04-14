

uses
	   cthreads,cmem,ctypes,strings,math,crt,keyboard,baseunix,sysutils;

	   
PImage:=^TImage;
TImage:=record
  data:^integer;
  width:integer;
  height:integer;
end;

PContext:=^TContext;
TContext:=record
  data:^integer;
  int width:integer;
  int height:integer;
  fb_name:PChar;
  fb_file_desc:integer;
end;

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

procedure image_free(image:PImage); 

begin
    free(image^.data);
    image^.width := 0;
    image^.height := 0;
    image^.data := Nil;
    free(image);
end;

// Set an individual pixel. This is SLOW for bulk operations.
// Do as little as possible, and memcpy the result.

//1D math on a 2D array
procedure set_pixel(x,y:integer; context:PContext; color:integer);
var
	write_index:integer;
	
//goes thru each individual "pixel" in the array 	
begin
    write_index := x+y*context^.width;
    if (write_index < context^.width * context^.height) then begin
        context^.data[x+y*context^.width] := color; //x*y*pitch:=color
    end else begin
        logln('Attempted to set color at out of bounds: ',x,' ', y);
        exit;
    end;
end;

// We scale and crop the image to this new rect.
function scale(image:PImage, w,h:integer):PImage; 
var
    sfx :integer;
    sfy :integer;
    crop_x_w :integer;
    crop_y_h :integer;
    crop_x :integer;
    crop_y :integer;
    new_image :PImage;
    tr_x := integer;
    tr_y := integer;         

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
    end; else if(sfx > sfy) then begin
        crop_y_h := image^.width * h mod w;
        crop_y := (image^.height - crop_y_h)  mod 2;
    end;

    new_image := malloc(sizeof(image_t));
    new_image^.data := malloc(sizeof(int) * w * h);
    new_image^.width := w;
    new_image^.height := h;
    for(int x := 0; x < w; x++) do begin
        for(int y := 0; y < h; y++) do begin
            int tr_x := ((float) crop_x_w / (float) w) * x + crop_x;
            int tr_y := ((float) crop_y_h / (float) h) * y + crop_y;
            new_image^.data[y * w + x] := image^.data[tr_y * image^.width + tr_x];
        end;
    end;

    return new_image;

{

    for(int x := 0; x < w; x++) do begin
        for(int y := 0; y < h; y++) do begin
            int tr_x := ( image^.width / (float) w) *  x;
            int tr_y := ( image^.height / (float) h) *  y;
            new_image^.data[y * w + x] := image^.data[tr_y * image^.width + tr_x];
        end;
    end;
}
end;

// !! This operation is potentially unsafe. Use drawImage. It's harder to mess up.
// X and w are the size of the array.

procedure draw_array(x, y, w,h:integer; DataArray:^integer; context:PContext); 

var
  cy,cx,line_count,line_width:integer;

begin
  // Ignore draws out of bounds
  if (x > context^.width) or (y > context^.height) then begin
    exit;
  end;

  // Ignore draws out of bounds
  if (x + w < 0 ) or ( y + h < 0) begin
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

  for (cy; cy < line_count; cy++) do begin
    // Draw each graphics line.
    memcpy(
        context^.data[context^.width * y + context^.width * cy + x + cx], 
        DataArray[cy * w] + cx, 
        sizeof(int) * line_width
    );
  end;
end;

procedure draw_image( x, y:integer; image:PImage; context:PContext); 

begin
    draw_array(x, y, image^.width, image^.height, image^.data, context);
end;

procedure draw_rect(x, y, w, h:integer; context:PContext; color:integer); 

begin
    // Ignore draws out of bounds
    if (x > context^.width oror y > context^.height) then begin
        return;
    end;

    // Ignore draws out of bounds
    if(x + w < 0) or (y + h < 0) then begin
        return;
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
    for (int rx := x; rx < x+w; rx++) do begin
        set_pixel(rx, y, context, color);
    end;

    // Repeat the first line.
    for (int ry := 1; ry < h; ry++) do begin
        memcpy(
            context^.data[context^.width * y + context^.width * ry + x], 
            context^.data[context^.width * y + x], 
            w*sizeof(int)
        );
    end;
end;

procedure clear_context_color(context:PContext; color:integer);

begin
    draw_rect(0, 0, context^.width, context^.height, context, color);
end;

procedure clear_context(context:PContext);

begin
    memset(context^.data, 0, context^.width * context^.height * sizeof(int));  
end;


type
  pattern=array [0..7] of LongWord;

procedure test_pattern(context:PContext);
var
   columnWidth:USint;


begin
	pattern:=( $FFFFFF,
    $FFFF00,
    $00FFFF,
    $00FF00,
    $FF00FF,
    $FF0000,
    $0000FF,
    $000000
    );
	
	
    columnWidth := context^.width mod 8;
    for(int rx := 0; rx < context^.width; rx++) begin
        set_pixel(rx, 0, context, pattern[rx mod columnWidth]);
    end;

    // make it faster: memcpy the first row.
    for(int y := 1; y < context^.height; y++) begin
        memcpy(context[context^.width * y], context, context^.width*sizeof(int));
    end;
end;

procedure context_release(context:PContext);

begin
    munmap(context^.data, context^.width * context^.height);
    close(context^.fb_file_desc);
    context^.data := Nil;
    context^.fb_file_desc := 0;
    free(context);
end;

function context_create:Pcontext;
var
  FB_NAME:PChar;
  mapped_ptr:pointer;
  fb_fixinfo:fb_fix_screeninfo;
  fb_varinfo:fb_var_screeninfo;
  fb_file_desc:integer;
  fb_size:integer;

begin
    FB_NAME := '/dev/fb0';
    mapped_ptr := Nil;
    fb_size := 0;

    // Open the framebuffer device in read write
    fb_file_desc := open(FB_NAME, O_RDWR);
    if (fb_file_desc < 0) begin
        logln('Unable to open %s.\n', FB_NAME);
        return NIL;
    end;
    //Do Ioctl. Retrieve fixed screen info.
    if (ioctl(fb_file_desc, FBIOGET_FSCREENINFO, fb_fixinfo) < 0) begin
        logln('get fixed screen info failed: %s\n',
               strerror(errno));
        close(fb_file_desc);
        return NIL;
    end;
    // Do Ioctl. Get the variable screen info.
    if (ioctl(fb_file_desc, FBIOGET_VSCREENINFO, fb_varinfo) < 0) begin
        logln('Unable to retrieve variable screen info: %s\n',
               strerror(errno));
        close(fb_file_desc);
        return NIL;
    end;

    // Calculate the size to mmap
    fb_size := fb_fixinfo.line_length * fb_varinfo.yres;
    
    // Now mmap the framebuffer.
    mapped_ptr := mmap(Nil, fb_size, PROT_READ or PROT_WRITE, MAP_SHARED, fb_file_desc,0);

    if (mapped_ptr :=:= Nil) begin
        logln('mmap failed:\n');
        close(fb_file_desc);
        return NIL;
    end;

    context := malloc(sizeof(Tcontext));
    context^.data :=  mapped_ptr;
    context^.width := fb_fixinfo.line_length / 4;
    context^.height := fb_varinfo.yres;
    context^.fb_file_desc := fb_file_desc;
    context^.fb_name := FB_NAME;
    return context;
end;
