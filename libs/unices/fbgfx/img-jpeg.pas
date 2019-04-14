Unit img-jpeg;

{*
 *
 * This file illustrates how to use the IJG code as a subroutine library
 * to read or write JPEG image files.  You should look at this code in
 * conjunction with the documentation file libjpeg.doc.
 *
 * This code will not do anything useful as-is, but it may be helpful as a
 * skeleton for constructing routines that call the JPEG library.  
 *
 * We present these routines in the same coding style used in the JPEG code
 * (ANSI function definitions, etc); but you are of course free to code your
 * routines in a different style if you prefer.
 *

  * SOME FINE POINTS:
  *
  * In the code, we ignored the return value of jpeg_read_scanlines,
  * which is the number of scanlines actually read.  We could get away with
  * this because we asked for only one line at a time and we weren't using
  * a suspending data source.  See libjpeg.doc for more info.
  *
  * We cheated a bit by calling alloc_sarray() after jpeg_start_decompress();
  * we should have done it beforehand to ensure that the space would be
  * counted against the JPEG max_memory setting.  In some systems the above
  * code would risk an out-of-memory error.  However, in general we don't
  * know the output image dimensions before jpeg_start_decompress(), unless we
  * call jpeg_calc_output_dimensions().  See libjpeg.doc for more about this.
  *
  * Scanlines are returned in the same order as they appear in the JPEG file,
  * which is standardly top-to-bottom.  If you must emit data bottom-to-top,
  * you can use one of the virtual arrays provided by the JPEG memory manager
  * to invert the data.  See wrbmp.c for an example.
  *
  * As with compression, some operating modes may require temporary files.
  * On some systems you may need to set up a signal handler(SIGSEV) to ensure that
  * temporary files are deleted if the program is interrupted.  See libjpeg.doc.
  *}

interface

uses
	crt,strings; //jdapistd or imjpeglib

 
function read_jpeg_file (filename:PChar):Pimage;

implementation

type
 
// Adapted libjpeg code to write to our TImage record.

my_error_mgr =record
  error_mgr:jpeg_error_mgr; 
  setjmp_buffer:jmp_buf;	
end;

my_error_ptr:^my_error_mgr;

//sigsev....help..sort of...
procedure  my_error_exit (cinfo:j_common_ptr );
var
	myerr:my_error_ptr;

begin
  LogLn('JPEG Error!');
  myerr :=  cinfo^.err;
  //  Return control to the setjmp point */
  longjmp(myerr^.setjmp_buffer, 1);
end;

function read_jpeg_file (filename:PChar):PImage;

var
  cinfo:jpeg_decompress_struct;
  jerr:my_error_mgr;
   
   infile:^file;		//  source file */
   buffer:JSAMPARRAY;		//  Output row buffer */
   row_stride:integer;		//  physical row width in output buffer */
   buffer :^cinfo.mem^.alloc_sarray;
   image:PImage;
   row:integer;
  
begin
  LogLn('Read JPEG ', filename);
   //  This struct contains the JPEG decompression parameters and pointers to
   // working space (which is allocated as needed by the JPEG library).
   
   //  We use our private extension JPEG error handler.
   // Note that this struct must live as long as the main JPEG parameter
   // struct, to avoid dangling-pointer problems.
    
  
   //  In this example we want to open the input file before doing anything else,
   // so that the setjmp() error recovery below can assume the file is open.
   // VERY IMPORTANT: use "b" option to fopen() if you are on a machine that
   // requires it in order to read binary files.
 
 //I know- its not python...I dont care!
   try:
		infile := fopen(filename, "rb"))
   except (IOError):
		LogLn('can"t open ', filename);
		exit;
   finally:
   
   //  Step 1: allocate and initialize JPEG decompression object */
 
   //  We set up the normal JPEG error routines, then override error_exit. */
   cinfo.err := jpeg_std_error(^jerr);
   jerr.pub.error_exit := my_error_exit;
   
   //  Establish the setjmp return context for my_error_exit to use. */
   if (setjmp(jerr.setjmp_buffer)) <> 0 then
   
   begin
     //  If we get here, the JPEG code has signaled an error.
     // We need to clean up the JPEG object, close the input file, and return.
      
     jpeg_destroy_decompress(^cinfo);
     fclose(infile);
     exit;
   end;

   
   jpeg_create_decompress(^cinfo);
   jpeg_stdio_src(^cinfo, infile);
   jpeg_read_header(^cinfo, TRUE);
   cinfo.out_color_space := JCS_EXT_BGRX;
   jpeg_start_decompress(^cinfo);
   
   row_stride := cinfo.output_width * cinfo.output_components;
   
   //  Make a one-row-high sample array that will go away when done with image */
   buffer :=  ( ^cinfo, JPOOL_IMAGE, row_stride, 1);

  image := malloc(sizeof(image_t));
  image^.data := malloc(sizeof(int) * cinfo.output_width * cinfo.output_height);
  image^.width := cinfo.output_width;
  image^.height := cinfo.output_height;
  
{$ifdef debug}  
  LogLn('JPEG ', image^.width, image^.height);
  LogLn('output components: ',cinfo.output_components, 'stride: ', row_stride);
{$endif}

   row := 0;

   while (cinfo.output_scanline < cinfo.output_height) do begin
     //  jpeg_read_scanlines expects an array of pointers to scanlines.
     // Here the array is only one element long, but you could ask for
     // more than one scanline at a time if that's more convenient.
      
     jpeg_read_scanlines(^cinfo, buffer, 1);

      // for(int i = 0; i < row_stride; i+=3) begin
      //   int hexval = ((buffer[0][i] << 16) & 0xFF0000) | ((buffer[0][i+1] << 8) & 0x00FF00) | (buffer[0][i+2] & 0x0000FF);
      //   image->data[row * image->width + (i / cinfo.output_components)] = hexval;
      // end;
      
     memcpy(^image^.data[row * image->width], buffer[0], row_stride);
     inc(row);
   end;
 
   //  Step 7: Finish decompression */
 
   jpeg_finish_decompress(^cinfo);
   //  We can ignore the return value since suspension is not possible
   // with the stdio data source.
    
 
   //  Step 8: Release JPEG decompression object */
 
   //  This is an important step since it will release a good deal of memory. */
   jpeg_destroy_decompress(^cinfo);
 
   //  After finish_decompress, we can close the input file.
   // Here we postpone it until after no more JPEG errors are possible,
   // so as to simplify the setjmp error logic above.  (Actually, I don't
   // think that jpeg_destroy can do an error exit, but why assume anything...)
   
   close(infile);
 
   //  At this point you may want to check to see whether any corrupt-data
   // warnings occurred (test whether jerr.pub.num_warnings is nonzero).
    
 
{$ifdef DEBUG}
   LogLn('JPEG loaded.');
{$endif}
   //  And we're done! */
   read_jpeg_file:=image;
end;
 
