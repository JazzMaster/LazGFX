Unit img-png;

{*
 * A modification of:
 * http://zarb.org/~gc/html/libpng.html
 *
 * Modified by Yoshimasa Niwa to make it much simpler
 * and support all defined color_type.
 *
 * Copyright 2002-2010 Guillaume Cottenceau.
 * Updated 2019 by Richard Jasmin
 *
 * This software may be freely redistributed under the terms
 * of the X11 license.
 *
*}
interface

uses
	png,crt,logger;



function read_png_file (filename:PChar):PImage;

implementation

 // Adapted libpng code to write to our TImage record
function read_png_file(filename:PChar):PImage;

var
   width, height:integer;
   color_type:png_byte;
   bit_depth:png_byte;
   row_pointers:png_bytep; //^png_byte
   fp:^file;
   png:png_structp;
   info:png_infop;
   image_array:PImage;
   px :png_bytep;
   hexval:integer;
   
   
begin

   fp := fopen(filename, "rb");
 
   png := png_create_read_struct(PNG_LIBPNG_VER_STRING, Nil, Nil, Nil);
   if(not png) then
	   exit;
 
   info := png_create_info_struct(png);
   if( not info) then
	  exit;
 
   //segfault protection...of sorts...
   if(setjmp(png_jmpbuf(png)))<>0 then
		exit;
 
   png_init_io(png, fp);
   png_read_info(png, info);
 
   width      := png_get_image_width(png, info);
   height     := png_get_image_height(png, info);
   color_type := png_get_color_type(png, info);
   bit_depth  := png_get_bit_depth(png, info);
 
   // Read any color_type into 8bit depth, RGBA format.
   // See http://www.libpng.org/pub/png/libpng-manual.txt
 
   if(bit_depth = 16) then
     png_set_strip_16(png);
 
   if(color_type = PNG_COLOR_TYPE_PALETTE) then
     png_set_palette_to_rgb(png);
 
   // PNG_COLOR_TYPE_GRAY_ALPHA is always 8 or 16bit depth.
   if(color_type = PNG_COLOR_TYPE_GRAY and bit_depth < 8)
     png_set_expand_gray_1_2_4_to_8(png);
 
   if(png_get_valid(png, info, PNG_INFO_tRNS)) then
     png_set_tRNS_to_alpha(png);
 
   // These color_type don't have an alpha channel then fill it with 0xff.
   if(color_type = PNG_COLOR_TYPE_RGB or
      color_type = PNG_COLOR_TYPE_GRAY or
      color_type = PNG_COLOR_TYPE_PALETTE) then
		png_set_filler(png, $FF, PNG_FILLER_AFTER);
 
   if(color_type = PNG_COLOR_TYPE_GRAY or
      color_type = PNG_COLOR_TYPE_GRAY_ALPHA) then
		png_set_gray_to_rgb(png);
 
   png_read_update_info(png, info);
 
   row_pointers := malloc(sizeof(png_bytep) * height);
   for(int y := 0; y < height; y++) do begin
     row_pointers[y] := malloc(png_get_rowbytes(png,info));
   end;
 
   png_read_image(png, row_pointers);
 
   image_array := malloc(sizeof(Timage));
   image_array^.data := malloc(width * height * sizeof(int));
   image_array^.width := width;
   image_array^.height := height;

   for(int y := 0; y < height; y++) do begin
    png_bytep row := row_pointers[y];
    for(int x := 0; x < width; x++) do begin
      px := px  and (row[x * 4]);
      hexval := ((px[0] shl 16) and $FF0000) or ((px[1] shl 8) and $00FF00) or ((px[2]) and $0000FF);
      
      // Save to the thing. todo: take image background param.
      image_array^.data[y * width + x] := hexval;
    end;
  end;

  // Free the rows, 
  for(int y := 0; y < height; y++) do begin
    free(row_pointers[y]);
  end;

  free(row_pointers);

  fclose(fp);

  read_png_file :=image_array;
 end;


procedure write_png_file(filename:PChar); 

var
	y:integer;
	fp:^file
    png:png_structp;
    info:png_infop;
    
begin
    
    fp := fopen(filename, "wb");
    if(fp)=Nil then
		exit;
 
    png := png_create_write_struct(PNG_LIBPNG_VER_STRING, Nil, Nil, Nil);
    if ( not png) then
		exit;
 
    png_infop info := png_create_info_struct(png);
    if ( not info) then 
		exit;
 
    //segfault protection..sort of.
    if (setjmp(png_jmpbuf(png)))<>0 then 
		exit;
 
    png_init_io(png, fp);
 
  // Output is 8bit depth, RGBA format.
    png_set_IHDR(
      png,
      info,
      width, height,
      8,
      PNG_COLOR_TYPE_RGBA,
      PNG_INTERLACE_NONE,
      PNG_COMPRESSION_TYPE_DEFAULT,
      PNG_FILTER_TYPE_DEFAULT
    );
    png_write_info(png, info);
 
 // To remove the alpha channel for PNG_COLOR_TYPE_RGB format,
 // Use png_set_filler().
   //png_set_filler(png, 0, PNG_FILLER_AFTER);
 
    png_write_image(png, row_pointers);
    png_write_end(png, Nil);
 
    for(int y := 0; y < height; y++) do begin
      free(row_pointers[y]);
    end;
    free(row_pointers);
 
    fclose(fp);
  end;

end.
