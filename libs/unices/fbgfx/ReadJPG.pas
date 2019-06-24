Unit ReadJPG;

interface

{
 
  This file illustrates how to use the IJG code as a subroutine library
  to read or write JPEG image files.  You should look at this code in
  conjunction with the documentation file libjpeg and PasJPEG
 
  We present these routines in the same coding style used in the JPEG code
  (ANSI function definitions, etc); but you are of course free to code your
  routines in a different style if you prefer.
 
}
uses 
	strings;

 #include <setjmp.h>
 #include "jpeglib.h"
 #include "img-jpeg.h"
 
// Adapted libjpeg demo to write to our TImage record.


function read_jpeg_file (filename:PChar):PImage; 

implementation


function read_jpeg_file (filename:PChar):PImage; 

var

//   jerr:my_error_mgr;

   infile:file;		
   buffer:JSAMPARRAY;		

// physical row width in output buffer 
   row,row_stride:integer;
   cinfo:jpeg_decompress_struct;
   image:PImage;

begin
  LogLn('Read JPEG: '+ filename);

   if ((infile = fpopen(filename, "rb")) = NiL) then begin
     LogLn('cant open filename provided');
     exit;
   end;

{ 

exit error procs??

   cinfo.err = jpeg_std_error(@jerr.pub);
   jerr.pub.error_exit := my_error_exit;

   if (setjmp(jerr.setjmp_buffer)) then begin

     // If we get here, the JPEG code has signaled an error.
     // We need to clean up the JPEG object, close the input file, and return.
      
     jpeg_destroy_decompress(@cinfo);
     fclose(infile);
     return 0;
   end;

}
   
   jpeg_create_decompress(@cinfo);
   jpeg_stdio_src(@cinfo, infile);
   jpeg_read_header(@cinfo, TRUE);
   cinfo.out_color_space := JCS_EXT_BGRX;
   jpeg_start_decompress(@cinfo);
   
   row_stride := cinfo.output_width * cinfo.output_components;

   // Make a one-row-high sample array that will go away when done with image 
   buffer := (@cinfo, JPOOL_IMAGE, row_stride, 1);

  image := malloc(sizeof(TImage));
  image.data := malloc(sizeof(int) * cinfo.output_width * cinfo.output_height);
  image.width:= cinfo.output_width;
  image.height := cinfo.output_height;
  
{$ifdef DEBUG}
  LogLn('JPEG: '+'width: '+ image.width+'height: '+ image.height);
  LogLn('output components: '+cinfo.output_components+' row stride: '+row_stride);
{$endif}

  int row := 0;

   while (cinfo.output_scanline < cinfo.output_height) do begin
     { jpeg_read_scanlines expects an array of pointers to scanlines.
       Here the array is only one element long, but you could ask for
       more than one scanline at a time if that's more convenient.
      }

     jpeg_read_scanlines(@cinfo, buffer, 1);

     memcpy(@image.data[row * image.width], buffer[0], row_stride);
     row:=row + 1;
   end;
 
 
   jpeg_finish_decompress(@cinfo);

   { We can ignore the return value since suspension is not possible
     with the stdio data source. }
    
   jpeg_destroy_decompress(@cinfo);
 
   { After finish_decompress, we can close the input file.
     Here we postpone it until after no more JPEG errors are possible,
     so as to simplify the setjmp error logic above.  (Actually, I don't
     think that jpeg_destroy can do an error exit, but why assume anything...)
   }
   close(infile);
 
   { At this point you may want to check to see whether any corrupt-data
     warnings occurred (test whether jerr.pub.num_warnings is nonzero).}
    
 
{$ifdef DEBUG}
   LogLn('JPEG done.');
{$endif}

   // And we're done! 
   read_jpeg_file:=image;
end;
 
 
{
  * SOME FINE POINTS:
  *
  * In the above code, we ignored the return value of jpeg_read_scanlines,
  * which is the number of scanlines actually read.  We could get away with
  * this because we asked for only one line at a time and we weren't using
  * a suspending data source. 
  *
  * We cheated a bit by calling alloc_sarray() after jpeg_start_decompress();
  * we should have done it beforehand to ensure that the space would be
  * counted against the JPEG max_memory setting.  In some systems the above
  * code would risk an out-of-memory error.  However, in general we don't
  * know the output image dimensions before jpeg_start_decompress(), unless we
  * call jpeg_calc_output_dimensions(). 
  *
  * Scanlines are returned in the same order as they appear in the JPEG file,
  * which is standardly top-to-bottom.  If you must emit data bottom-to-top,
  * you can use one of the virtual arrays provided by the JPEG memory manager
  * to invert the data.  See wrbmp.c for an example.
  *
  * As with compression, some operating modes may require temporary files.
  * On some systems you may need to set up a signal handler to ensure that
  * temporary files are deleted if the program is interrupted.  
  
}

