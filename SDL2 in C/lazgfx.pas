Unit SDL2BGI;
//from the professors C. Home-work, prob-a-bly...

//(not for me)

//the only things left seem to be translating the functions/procedures and then updating the headers to match.
//This is very basic and lacking.

//-Jazz

interface

uses
    SDL2,SDL2_TTF,crt,math,strings;

const
    SDL_BGI_VERSION = 2.3.0;
    BGI_WINTITLE_LEN =512; // more than enough
    MAXCOLORS = 15; //only for EGA modes...FIXME

// number of concurrent windows that can be created

    NUM_BGI_WIN =16;

// available visual pages

    VPAGES= 4;

type

Decision= ( NO, YES );

// BGI fonts

// only DEFAULT_FONT (8x8) is implemented, Rest are TTF Loaded. BGI used to selectively link them in.
Fonts= (
  DEFAULT_FONT, TRIPLEX_FONT, SANSSERIF_FONT,
  GOTHIC_FONT, SCRIPT_FONT, SIMPLEX_FONT , SERIF_FONT
);

TextDirection= ( HORIZ_DIR, VERT_DIR );

TextLocation= (
  LEFT_TEXT, CENTER_TEXT, RIGHT_TEXT,
  BOTTOM_TEXT = 0, TOP_TEXT = 2
);

// BGI colours

Palette16Colors= (
  BLACK, BLUE, GREEN, CYAN, RED, MAGENTA, BROWN,
  LIGHTGRAY, DARKGRAY, LIGHTBLUE, LIGHTGREEN, LIGHTCYAN,
  LIGHTRED, LIGHTMAGENTA, YELLOW, WHITE 
);

// temporary colours

TempColors= ( TMP_FG_COL = 16, TMP_BG_COL = 17, TMP_FILL_COL = 18 );

// line style, thickness, and drawing mode

LineStyle= ( NORM_WIDTH = 1, THICK_WIDTH = 3 );

Thickness= ( SOLID_LINE, DOTTED_LINE, CENTER_LINE, DASHED_LINE, USERBIT_LINE );

DrawMode= ( COPY_PUT, XOR_PUT, OR_PUT, AND_PUT, NOT_PUT );


// fill styles

Fill_type= (
  EMPTY_FILL, SOLID_FILL, LINE_FILL, LTSLASH_FILL, SLASH_FILL,
  BKSLASH_FILL, LTBKSLASH_FILL, HATCH_FILL, XHATCH_FILL,
  INTERLEAVE_FILL, WIDE_DOT_FILL, CLOSE_DOT_FILL, USER_FILL
);

var

    bgi_window:PSDL_Window ;
    bgi_renderer:PSDL_Renderer;
    bgi_texture:PSDL_Texture;

const

// mouse buttons

     WM_LBUTTONDOWN  =SDL_BUTTON_LEFT;
     WM_MBUTTONDOWN  =SDL_BUTTON_MIDDLE;
     WM_RBUTTONDOWN  =SDL_BUTTON_RIGHT;
     WM_WHEEL        =SDL_MOUSEWHEEL;
     WM_WHEELUP      =SDL_USEREVENT;
     WM_WHEELDOWN    =SDL_USEREVENT + 1;
     WM_MOUSEMOVE    =SDL_MOUSEMOTION;

     PALETTE_SIZE    =512; // 256 colors ~ 512BYTES on disk(measured)

KEY_HOME=        SDLK_HOME;
KEY_LEFT  =      SDLK_LEFT;
KEY_UP    =      SDLK_UP;
KEY_RIGHT =      SDLK_RIGHT;
KEY_DOWN  =      SDLK_DOWN;
KEY_PGUP  =      SDLK_PAGEUP;
KEY_PGDN  =      SDLK_PAGEDOWN;
KEY_END   =      SDLK_END;
KEY_INSERT =     SDLK_INSERT;
KEY_DELETE =     SDLK_DELETE;
KEY_F1    =      SDLK_F1;
KEY_F2    =      SDLK_F2;
KEY_F3    =      SDLK_F3;
KEY_F4    =      SDLK_F4;
KEY_F5    =      SDLK_F5;
KEY_F6    =      SDLK_F6;
KEY_F7    =      SDLK_F7;
KEY_F8    =      SDLK_F8;
KEY_F9    =      SDLK_F9;
KEY_F10   =      SDLK_F10;
KEY_F11   =      SDLK_F11;
KEY_F12   =      SDLK_F12;
KEY_CAPSLOCK =   SDLK_CAPSLOCK;
KEY_LEFT_CTRL =  SDLK_LCTRL;
KEY_RIGHT_CTRL = SDLK_RCTRL;
KEY_LEFT_SHIFT = SDLK_LSHIFT;
KEY_RIGHT_SHIFT= SDLK_RSHIFT;
KEY_LEFT_ALT  =  SDLK_LALT;
KEY_RIGHT_ALT =  SDLK_RALT;
KEY_ALT_GR    =  SDLK_MODE;
KEY_LGUI      =  SDLK_LGUI;
KEY_RGUI      =  SDLK_RGUI;
KEY_MENU      =  SDLK_MENU;
KEY_TAB       =  SDLK_TAB;
KEY_BS        =  SDLK_BACKSPACE;
KEY_RET       =  SDLK_RETURN;
KEY_PAUSE     =  SDLK_PAUSE;
KEY_SCR_LOCK  =  SDLK_SCROLLOCK;
KEY_ESC       =  SDLK_ESCAPE;
QUIT          =  SDL_QUIT;


modes=(
  DETECT = -1,
  grOk = 0, SDL = 0,
  // all modes @ 32$200 
  SDL_32$200 = 1, SDL_CGALO = 1, CGA = 1, CGAC0 = 1, CGAC1 = 1,
  CGAC2 = 1, CGAC3 = 1, MCGAC0 = 1, MCGAC1 = 1, MCGAC2 = 1,
  MCGAC3 = 1, ATT400C0 = 1, ATT400C1 = 1, ATT400C2 = 1, ATT400C3 = 1,
  // all modes @ 64$200
  SDL_64$200 = 2, SDL_CGAHI = 2, CGAHI = 2, MCGAMED = 2,
  EGALO = 2, EGA64LO = 2,
  // all modes @ 64$350
  SDL_64$350 = 3, SDL_EGA = 3, EGA = 3, EGAHI = 3,
  EGA64HI = 3, EGAMONOHI = 3,
  // all modes @ 64$480
  SDL_64$480 = 4, SDL_VGA = 4, VGA = 4, MCGAHI = 4, VGAHI = 4,
  IBM8514LO = 4,
  // all modes @ 72$348
  SDL_72$348 = 5, SDL_HERC = 5,
  // all modes @ 72$350
  SDL_72$350 = 6, SDL_PC3270 = 6, HERCMONOHI = 6,
  // all modes @ 80$600
  SDL_80$600 = 7, SDL_SVGALO = 7, SVGA = 7,
  // all modes @ 1024x768
  SDL_1024x768 = 8, SDL_SVGAMED1 = 8,
  // all modes @ 1152x900
  SDL_1152x900 = 9, SDL_SVGAMED2 = 9,
  // all modes @ 128$1024
  SDL_128$1024 = 10, SDL_SVGAHI = 10,
  // all modes @ 1366x768
  SDL_1366x768 = 11, SDL_WXGA = 11,
  // other
  SDL_USER = 12, SDL_FULLSCREEN = 13
);

// libXbgi compatibility

const

X11_CGALO    =   1;
X11_CGAHI    =   2;
X11_EGA      =   3;
X11          =   0;
X11_VGA      =   4;
X11_64$480  =   4;
X11_HERC     =   5;
X11_PC3270   =   6;
X11_SVGALO   =   7;
X11_80$600  =   7;
X11_SVGAMED1 =   8;
X11_1024x768 =   8;
X11_SVGAMED2 =   9;
X11_1152x900 =   9;
X11_SVGAHI    =  10;
X11_128$1024 =  10;
X11_WXGA      =  11;
X11_1366x768  =  11;
X11_USER      =  12;
X11_FULLSCREEN = 13;


arccoords_type =record
  x:integer;
  y:integer;
  xstart:integer;
  ystart:integer;
  xend:integer;
  yend:integer;
end;

date =record
  da_year:integer;
  da_day:integer;
  da_mon:integer;
end;

fillsettings_type =record
  pattern:integer
  color:integer;
end;

linesettings_type =record
  linestyle:integer;
  upattern:word; //usint
  thickness:integer;
end;

palette_type =record
  size:byte=[MAXCOLORS + 1];
  colors:array of byte; //only for CGA, EGA modes 
end;

textsettings_type=record
  font:integer;
  direction:integer;
  charsize:integer;
  horiz:integer;
  vert:integer;
end;

viewport_type =record
  left:integer;
  top:integer;
  right:integer;
  bottom:integer;
  clip:integer;
end;


//procs and functions

procedure arc (int, int, int, int, int);
procedure bar3d (int, int, int, int, int, int);
procedure bar (int, int, int, int);
procedure circle (int, int, int);
procedure cleardevice ();
procedure clearviewport ();
procedure closegraph ;
procedure delay (int msec);
procedure detectgraph (int *, int *);
procedure drawpoly (int, int *);
procedure ellipse (int, int, int, int, int, int);
procedure fillellipse (int, int, int, int);
procedure fillpoly (int, int *);
procedure floodfill (int, int, int);
function  getactivepage:integer ;
procedure getarccoords (struct arccoords_type *);
procedure getaspectratio (int *, int *);
function  getbkcolor:integer ;

//readkey override
function  bgi_getch:char;
function  getcolor:integer;
function getdefaultpalette:Ppalette_type;
function getdrivername:PChar;

procedure getfillpattern (char *);
procedure getfillsettings (struct fillsettings_type *);

function  getgraphmode:integer;

procedure getimage (int, int, int, int, void *);
procedure getlinesettings (struct linesettings_type *);

function  getmaxcolor:integer ;
function  getmaxmode:integer ;
function  getmaxx:integer ;
function getmaxy:integer ;
function getmodename (int):Pchar;

procedure getmoderange (int, int *, int *);
procedure getpalette (struct palette_type *);

function getpalettesize (struct palette_type *):integer;
function getpixel (x,y:integer):SDL_Color; //byte

procedure gettextsettings (struct textsettings_type *);
procedure getviewsettings (struct viewport_type *);

function  getvisualpage:integer ;
function  getx:integer ;
function  gety:integer ;

procedure graphdefaults;

function grapherrormsg (int):PChar;
function graphresult:integer ;

function imagesize (x,y,w,h):word;

procedure initgraph (mode:integer; driver:integer; PathToDriver:PChar);
function installuserdriver (name:Pchar;detect:PtrUInt):integer;

function installuserfont (font:Pchar):integer;
function  kbhit ;

procedure line (int, int, int, int);
procedure linerel (int dx, int dy);
procedure lineto (int x, int y);
procedure moverel (int, int);
procedure moveto (int, int);
procedure outtext (char *);
procedure outtextxy (int, int, char *);
procedure pieslice (int, int, int, int, int);
procedure putimage (int, int, void *, int);
procedure putpixel (int, int, int);

procedure readimagefile (char *, int, int, int, int);
procedure rectangle (int, int, int, int);

//not used
function  registerbgidriver (driver:pointer):integer;
function  registerbgifont (font:pointer):integer;

procedure restorecrtmode ;
procedure sector (int, int, int, int, int, int);
procedure setactivepage (int);
procedure setallpalette (struct palette_type *);
procedure setaspectratio (int, int);
procedure setbkcolor (int);
procedure setcolor (int);
procedure setfillpattern (char *, int);
procedure setfillstyle (int, int);

function setgraphbufsize (unsigned):LongWord;

procedure setgraphmode (int);
procedure setlinestyle (int, unsigned, int);
procedure setpalette (int, int);
procedure settextjustify (int, int);
procedure settextstyle (int, int, int);
procedure setusercharsize (int, int, int, int);
procedure setviewport (int, int, int, int, int);
procedure setvisualpage (int);
procedure setwritemode (int);

function  textheight (char *):integer;
function  textwidth (char *):integer;

procedure writeimagefile (char *, int, int, int, int);

// SDL_bgi extensions

function  ALPHA_VALUE (int):integer;
function  BLUE_VALUE (int):integer;
procedure closewindow (int);
function COLOR (int, int, int):integer;
function  event:integer ;
function event_type:integer ;
function freeimage (image:pointer);
function getcurrentwindow:integer ;
function  getevent:integer ;
procedure getmouseclick (int, int *, int *);
function  GREEN_VALUE (int):integer;
procedure initwindow (int, int);
function  IS_BGI_COLOR (int color):integer;
function  ismouseclick (int):integer;
function  IS_RGB_COLOR (int color):integer;
function  mouseclick:integer ;
function  mousex:integer ;
function  mousey:integer ;
procedure _putpixel (int, int);
function  RED_VALUE (int ):integer;
procedure refresh ;
procedure sdlbgiauto ;
procedure sdlbgifast ;
procedure sdlbgislow ;
procedure setalpha (int, Uint8);
procedure setbkrgbcolor (int);
procedure setblendmode (int);
procedure setcurrentwindow (int);
procedure setrgbcolor (int);
procedure setrgbpalette (int, int, int, int);
procedure setwinoptions (char *, int, int, Uint32);
procedure showerrorbox (const char *);
procedure swapbuffers ;
function  xkbhit:integer ;

implementation

var

   bgi_window:PSDL_Window;
   bgi_renderer:PSDL_Renderer;
   bgi_texture:PSDL_Texture;

//SDL v1: Mainsurface,Surface(x)

  bgi_win: PSDL_Window =[NUM_BGI_WIN];
  bgi_rnd:PSDL_Renderer  =[NUM_BGI_WIN];
  bgi_txt: PSDL_Texture =[NUM_BGI_WIN];


  current_window:word = -1, // id of current window
  num_windows:word = 0;     // number of created windows

  active_windows:integer =[NUM_BGI_WIN];

// explanation: up to NUM_BGI_WIN windows can be created and deleted
// as needed. 'active_windows[]' keeps track of created (1) and closed (0)
// windows; 'current_window' is the ID of the current (= being drawn on)
// window; 'num_windows' keeps track of the current number of windows

  bgi_vpage: = array [0..VPAGES] of PSDL_Surface; // array of visual pages; single window only

// Note: 'Uint32' and 'int' are the same on modern machines

// pixel data of active and visual pages


  bgi_activepage:PtrUInt =[NUM_BGI_WIN]  // active (= being drawn on) page;
                                // may be hidden
  bgi_visualpage:PtrUInt =[NUM_BGI_WIN]; // visualised page

// This is how we draw stuff on the screen. Pixels pointed to by
// bgi_activepage (a pointer to pixel data in the active surface)
// are modified by functions like putpixel_copy(); bgi_texture is
// updated with the new bgi_activepage contents; bgi_texture is then
// copied to bgi_renderer, and finally bgi_renderer is made present.

// The palette contains the BGI colors, entries 0:MAXCOLORS;
// then three entries for temporary fg, bg, and fill ARGB colors
// allocated with COLOR(); then user-defined ARGB colors

const
   BGI_COLORS = MAXCOLORS + 1;
   TMP_COLORS =  3;

  palette:longword  =[BGI_COLORS + TMP_COLORS + PALETTE_SIZE]; // all colors

type //colors by index value- but stored in hex
  bgi_palette=( 
    // ARGB
    $ff000000, // BLACK
    $ff0000ff, // BLUE
    $ff00ff00, // GREEN
    $ff00ffff, // CYAN
    $ffff0000, // RED
    $ffff00ff, // MAGENTA
    $ffa52a2a, // BROWN
    $ffd3d3d3, // LIGHTGRAY
    $ffa9a9a9, // DARKGRAY
    $ffadd8e6, // LIGHTBLUE
    $ff90ee90, // LIGHTGREEN
    $ffe0ffff, // LIGHTCYAN
    $fff08080, // LIGHTRED
    $ffdb7093, // LIGHTMAGENTA
    $ffffff00, // YELLOW
    $ffffffff  // WHITE
  );

  line_patterns=(
   $ffff,  // SOLID_LINE  = 1111111111111111
   $cccc,  // DOTTED_LINE = 1100110011001100
   $f1f8,  // CENTER_LINE = 1111000111111000
   $f8f8,  // DASHED_LINE = 1111100011111000
   $ffff   // USERBIT_LINE  
  );  

  bgi_tmp_color_argb:longword;     // temporary color set up by COLOR()
  window_flags:longword = 0;       // window flags

  bgi_mouse_x:integer;            // coordinates of last mouse click
  bgi_mouse_y:integer;
  bgi_ap:integer;                 // active page number
  bgi_vp:integer;                 // visual page number
  bgi_maxx:integer;       // screen size
  bgi_maxy:integer;
  bgi_gm:integer;                 // graphics mode

  bgi_writemode:word;          // plotting method (COPY_PUT, XOR_PUT...)

  window_x :integer=  SDL_WINDOWPOS_CENTERED;            // window initial position    
  window_y :integer=  SDL_WINDOWPOS_CENTERED;
  bgi_fg_color :integer= WHITE;   // index of BGI foreground color
  bgi_bg_color :integer= BLACK;   // index of BGI background color
  bgi_fill_color :integer= WHITE; // index of BGI fill color
  bgi_font_width :integer= 8;    // default font width and height
  bgi_font_height :integer= 8;
  bgi_fast_mode :integer= 1;     // needs screen update?
  bgi_last_event :integer= 0;     // mouse click, keyboard event, or QUIT
  bgi_cp_x :integer= 0;           // current position
  bgi_cp_y :integer= 0;
  bgi_argb_mode :boolean= false;   // BGI or ARGB colors
  bgi_blendmode :integer=    SDL_BLENDMODE_BLEND;  // blending mode
  bgi_np :integer= 0;             // # of actual pages
  refresh_needed :boolean= false;  // update callback should be called
  refresh_rate :integer= 0;       // window refresh rate

// mutex for update timer/thread

  update_mutex :PSDL_mutex= NULL;

// BGI window title
  bgi_win_title:Pchar = "SDL_bgi";

// booleans
  window_is_hidden :boolean= NO,
  key_pressed :boolean= NO,
  xkey_pressed :boolean= NO;

  bgi_font_mag_x :single= 1.0,  // font magnification
  bgi_font_mag_y :single= 1.0;

// pointer to font array. Should I add more (ugly) bitmap fonts?

// 8x8 font definition

conswt GFX_FONTDATAMAX= (8*256)

gfxPrimitivesFontdata: array [0..GFX_FONTDATAMAX] of byte=(

  $00,$00,$00,$00,$00,$00,$00,$00, // 0 $00 '^@'
  $7e,$81,$a5,$81,$bd,$99,$81,$7e, // 1 $01 '^A'
  $7e,$ff,$db,$ff,$c3,$e7,$ff,$7e, // 2 $02 '^B'
  $6c,$fe,$fe,$fe,$7c,$38,$10,$00, // 3 $03 '^C'
  $10,$38,$7c,$fe,$7c,$38,$10,$00, // 4 $04 '^D'
  $38,$7c,$38,$fe,$fe,$d6,$10,$38, // 5 $05 '^E'
  $10,$38,$7c,$fe,$fe,$7c,$10,$38, // 6 $06 '^F'
  $00,$00,$18,$3c,$3c,$18,$00,$00, // 7 $07 '^G'
  $ff,$ff,$e7,$c3,$c3,$e7,$ff,$ff, // 8 $08 '^H'
  $00,$3c,$66,$42,$42,$66,$3c,$00, // 9 $09 '^I'
  $ff,$c3,$99,$bd,$bd,$99,$c3,$ff, // 10 $0a '^J'
  $0f,$07,$0f,$7d,$cc,$cc,$cc,$78, // 11 $0b '^K'
  $3c,$66,$66,$66,$3c,$18,$7e,$18, // 12 $0c '^L'
  $3f,$33,$3f,$30,$30,$70,$f0,$e0, // 13 $0d '^M'
  $7f,$63,$7f,$63,$63,$67,$e6,$c0, // 14 $0e '^N'
  $18,$db,$3c,$e7,$e7,$3c,$db,$18, // 15 $0f '^O'
  $80,$e0,$f8,$fe,$f8,$e0,$80,$00, // 16 $10 '^P'
  $02,$0e,$3e,$fe,$3e,$0e,$02,$00, // 17 $11 '^Q'
  $18,$3c,$7e,$18,$18,$7e,$3c,$18, // 18 $12 '^R'
  $66,$66,$66,$66,$66,$00,$66,$00, // 19 $13 '^S'
  $7f,$db,$db,$7b,$1b,$1b,$1b,$00, // 20 $14 '^T'
  $3e,$61,$3c,$66,$66,$3c,$86,$7c, // 21 $15 '^U'
  $00,$00,$00,$00,$7e,$7e,$7e,$00, // 22 $16 '^V'
  $18,$3c,$7e,$18,$7e,$3c,$18,$ff, // 23 $17 '^W'
  $18,$3c,$7e,$18,$18,$18,$18,$00, // 24 $18 '^X'
  $18,$18,$18,$18,$7e,$3c,$18,$00, // 25 $19 '^Y'
  $00,$18,$0c,$fe,$0c,$18,$00,$00, // 26 $1a '^Z'
  $00,$30,$60,$fe,$60,$30,$00,$00, // 27 $1b '^['
  $00,$00,$c0,$c0,$c0,$fe,$00,$00, // 28 $1c '^\'
  $00,$24,$66,$ff,$66,$24,$00,$00, // 29 $1d '^]'
  $00,$18,$3c,$7e,$ff,$ff,$00,$00, // 30 $1e '^^'
  $00,$ff,$ff,$7e,$3c,$18,$00,$00, // 31 $1f '^_'
  $00,$00,$00,$00,$00,$00,$00,$00, // 32 $20 ' '
  $18,$3c,$3c,$18,$18,$00,$18,$00, // 33 $21 '!'
  $66,$66,$24,$00,$00,$00,$00,$00, // 34 $22 '"'
  $6c,$6c,$fe,$6c,$fe,$6c,$6c,$00, // 35 $23 '#'
  $18,$3e,$60,$3c,$06,$7c,$18,$00, // 36 $24 '$'
  $00,$c6,$cc,$18,$30,$66,$c6,$00, // 37 $25 '%'
  $38,$6c,$38,$76,$dc,$cc,$76,$00, // 38 $26 '&'
  $18,$18,$30,$00,$00,$00,$00,$00, // 39 $27 '''
  $0c,$18,$30,$30,$30,$18,$0c,$00, // 40 $28 '('
  $30,$18,$0c,$0c,$0c,$18,$30,$00, // 41 $29 ')'
  $00,$66,$3c,$ff,$3c,$66,$00,$00, // 42 $2a '*'
  $00,$18,$18,$7e,$18,$18,$00,$00, // 43 $2b '+'
  $00,$00,$00,$00,$00,$18,$18,$30, // 44 $2c ','
  $00,$00,$00,$7e,$00,$00,$00,$00, // 45 $2d '-'
  $00,$00,$00,$00,$00,$18,$18,$00, // 46 $2e '.'
  $06,$0c,$18,$30,$60,$c0,$80,$00, // 47 $2f '/'
  $38,$6c,$c6,$d6,$c6,$6c,$38,$00, // 48 $30 '0'
  $18,$38,$18,$18,$18,$18,$7e,$00, // 49 $31 '1'
  $7c,$c6,$06,$1c,$30,$66,$fe,$00, // 50 $32 '2'
  $7c,$c6,$06,$3c,$06,$c6,$7c,$00, // 51 $33 '3'
  $1c,$3c,$6c,$cc,$fe,$0c,$1e,$00, // 52 $34 '4'
  $fe,$c0,$c0,$fc,$06,$c6,$7c,$00, // 53 $35 '5'
  $38,$60,$c0,$fc,$c6,$c6,$7c,$00, // 54 $36 '6'
  $fe,$c6,$0c,$18,$30,$30,$30,$00, // 55 $37 '7'
  $7c,$c6,$c6,$7c,$c6,$c6,$7c,$00, // 56 $38 '8'
  $7c,$c6,$c6,$7e,$06,$0c,$78,$00, // 57 $39 '9'
  $00,$18,$18,$00,$00,$18,$18,$00, // 58 $3a ':'
  $00,$18,$18,$00,$00,$18,$18,$30, // 59 $3b ';'
  $06,$0c,$18,$30,$18,$0c,$06,$00, // 60 $3c '<'
  $00,$00,$7e,$00,$00,$7e,$00,$00, // 61 $3d '='
  $60,$30,$18,$0c,$18,$30,$60,$00, // 62 $3e '>'
  $7c,$c6,$0c,$18,$18,$00,$18,$00, // 63 $3f '?'
  $7c,$c6,$de,$de,$de,$c0,$78,$00, // 64 $40 '@'
  $38,$6c,$c6,$fe,$c6,$c6,$c6,$00, // 65 $41 'A'
  $fc,$66,$66,$7c,$66,$66,$fc,$00, // 66 $42 'B'
  $3c,$66,$c0,$c0,$c0,$66,$3c,$00, // 67 $43 'C'
  $f8,$6c,$66,$66,$66,$6c,$f8,$00, // 68 $44 'D'
  $fe,$62,$68,$78,$68,$62,$fe,$00, // 69 $45 'E'
  $fe,$62,$68,$78,$68,$60,$f0,$00, // 70 $46 'F'
  $3c,$66,$c0,$c0,$ce,$66,$3a,$00, // 71 $47 'G'
  $c6,$c6,$c6,$fe,$c6,$c6,$c6,$00, // 72 $48 'H'
  $3c,$18,$18,$18,$18,$18,$3c,$00, // 73 $49 'I'
  $1e,$0c,$0c,$0c,$cc,$cc,$78,$00, // 74 $4a 'J'
  $e6,$66,$6c,$78,$6c,$66,$e6,$00, // 75 $4b 'K'
  $f0,$60,$60,$60,$62,$66,$fe,$00, // 76 $4c 'L'
  $c6,$ee,$fe,$fe,$d6,$c6,$c6,$00, // 77 $4d 'M'
  $c6,$e6,$f6,$de,$ce,$c6,$c6,$00, // 78 $4e 'N'
  $7c,$c6,$c6,$c6,$c6,$c6,$7c,$00, // 79 $4f 'O'
  $fc,$66,$66,$7c,$60,$60,$f0,$00, // 80 $50 'P'
  $7c,$c6,$c6,$c6,$c6,$ce,$7c,$0e, // 81 $51 'Q'
  $fc,$66,$66,$7c,$6c,$66,$e6,$00, // 82 $52 'R'
  $3c,$66,$30,$18,$0c,$66,$3c,$00, // 83 $53 'S'
  $7e,$7e,$5a,$18,$18,$18,$3c,$00, // 84 $54 'T'
  $c6,$c6,$c6,$c6,$c6,$c6,$7c,$00, // 85 $55 'U'
  $c6,$c6,$c6,$c6,$c6,$6c,$38,$00, // 86 $56 'V'
  $c6,$c6,$c6,$d6,$d6,$fe,$6c,$00, // 87 $57 'W'
  $c6,$c6,$6c,$38,$6c,$c6,$c6,$00, // 88 $58 'X'
  $66,$66,$66,$3c,$18,$18,$3c,$00, // 89 $59 'Y'
  $fe,$c6,$8c,$18,$32,$66,$fe,$00, // 90 $5a 'Z'
  $3c,$30,$30,$30,$30,$30,$3c,$00, // 91 $5b '['
  $c0,$60,$30,$18,$0c,$06,$02,$00, // 92 $5c '\'
  $3c,$0c,$0c,$0c,$0c,$0c,$3c,$00, // 93 $5d ']'
  $10,$38,$6c,$c6,$00,$00,$00,$00, // 94 $5e '^'
  $00,$00,$00,$00,$00,$00,$00,$ff, // 95 $5f '_'
  $30,$18,$0c,$00,$00,$00,$00,$00, // 96 $60 '`'
  $00,$00,$78,$0c,$7c,$cc,$76,$00, // 97 $61 'a'
  $e0,$60,$7c,$66,$66,$66,$dc,$00, // 98 $62 'b'
  $00,$00,$7c,$c6,$c0,$c6,$7c,$00, // 99 $63 'c'
  $1c,$0c,$7c,$cc,$cc,$cc,$76,$00, // 100 $64 'd'
  $00,$00,$7c,$c6,$fe,$c0,$7c,$00, // 101 $65 'e'
  $3c,$66,$60,$f8,$60,$60,$f0,$00, // 102 $66 'f'
  $00,$00,$76,$cc,$cc,$7c,$0c,$f8, // 103 $67 'g'
  $e0,$60,$6c,$76,$66,$66,$e6,$00, // 104 $68 'h'
  $18,$00,$38,$18,$18,$18,$3c,$00, // 105 $69 'i'
  $06,$00,$06,$06,$06,$66,$66,$3c, // 106 $6a 'j'
  $e0,$60,$66,$6c,$78,$6c,$e6,$00, // 107 $6b 'k'
  $38,$18,$18,$18,$18,$18,$3c,$00, // 108 $6c 'l'
  $00,$00,$ec,$fe,$d6,$d6,$d6,$00, // 109 $6d 'm'
  $00,$00,$dc,$66,$66,$66,$66,$00, // 110 $6e 'n'
  $00,$00,$7c,$c6,$c6,$c6,$7c,$00, // 111 $6f 'o'
  $00,$00,$dc,$66,$66,$7c,$60,$f0, // 112 $70 'p'
  $00,$00,$76,$cc,$cc,$7c,$0c,$1e, // 113 $71 'q'
  $00,$00,$dc,$76,$60,$60,$f0,$00, // 114 $72 'r'
  $00,$00,$7e,$c0,$7c,$06,$fc,$00, // 115 $73 's'
  $30,$30,$fc,$30,$30,$36,$1c,$00, // 116 $74 't'
  $00,$00,$cc,$cc,$cc,$cc,$76,$00, // 117 $75 'u'
  $00,$00,$c6,$c6,$c6,$6c,$38,$00, // 118 $76 'v'
  $00,$00,$c6,$d6,$d6,$fe,$6c,$00, // 119 $77 'w'
  $00,$00,$c6,$6c,$38,$6c,$c6,$00, // 120 $78 'x'
  $00,$00,$c6,$c6,$c6,$7e,$06,$fc, // 121 $79 'y'
  $00,$00,$7e,$4c,$18,$32,$7e,$00, // 122 $7a 'z'
  $0e,$18,$18,$70,$18,$18,$0e,$00, // 123 $7b 'begin'
  $18,$18,$18,$18,$18,$18,$18,$00, // 124 $7c '|'
  $70,$18,$18,$0e,$18,$18,$70,$00, // 125 $7d 'end;'
  $76,$dc,$00,$00,$00,$00,$00,$00, // 126 $7e '~'
  $00,$10,$38,$6c,$c6,$c6,$fe,$00, // 127 $7f ''
  $7c,$c6,$c0,$c0,$c6,$7c,$0c,$78, // 128 $80 ''
  $cc,$00,$cc,$cc,$cc,$cc,$76,$00, // 129 $81 ''
  $0c,$18,$7c,$c6,$fe,$c0,$7c,$00, // 130 $82 ''
  $7c,$82,$78,$0c,$7c,$cc,$76,$00, // 131 $83 ''
  $c6,$00,$78,$0c,$7c,$cc,$76,$00, // 132 $84 ''
  $30,$18,$78,$0c,$7c,$cc,$76,$00, // 133 $85 ''
  $30,$30,$78,$0c,$7c,$cc,$76,$00, // 134 $86 ''
  $00,$00,$7e,$c0,$c0,$7e,$0c,$38, // 135 $87 ''
  $7c,$82,$7c,$c6,$fe,$c0,$7c,$00, // 136 $88 ''
  $c6,$00,$7c,$c6,$fe,$c0,$7c,$00, // 137 $89 ''
  $30,$18,$7c,$c6,$fe,$c0,$7c,$00, // 138 $8a ''
  $66,$00,$38,$18,$18,$18,$3c,$00, // 139 $8b ''
  $7c,$82,$38,$18,$18,$18,$3c,$00, // 140 $8c ''
  $30,$18,$00,$38,$18,$18,$3c,$00, // 141 $8d ''
  $c6,$38,$6c,$c6,$fe,$c6,$c6,$00, // 142 $8e ''
  $38,$6c,$7c,$c6,$fe,$c6,$c6,$00, // 143 $8f ''
  $18,$30,$fe,$c0,$f8,$c0,$fe,$00, // 144 $90 ''
  $00,$00,$7e,$18,$7e,$d8,$7e,$00, // 145 $91 ''
  $3e,$6c,$cc,$fe,$cc,$cc,$ce,$00, // 146 $92 ''
  $7c,$82,$7c,$c6,$c6,$c6,$7c,$00, // 147 $93 ''
  $c6,$00,$7c,$c6,$c6,$c6,$7c,$00, // 148 $94 ''
  $30,$18,$7c,$c6,$c6,$c6,$7c,$00, // 149 $95 ''
  $78,$84,$00,$cc,$cc,$cc,$76,$00, // 150 $96 ''
  $60,$30,$cc,$cc,$cc,$cc,$76,$00, // 151 $97 ''
  $c6,$00,$c6,$c6,$c6,$7e,$06,$fc, // 152 $98 ''
  $c6,$38,$6c,$c6,$c6,$6c,$38,$00, // 153 $99 ''
  $c6,$00,$c6,$c6,$c6,$c6,$7c,$00, // 154 $9a ''
  $18,$18,$7e,$c0,$c0,$7e,$18,$18, // 155 $9b ''
  $38,$6c,$64,$f0,$60,$66,$fc,$00, // 156 $9c ''
  $66,$66,$3c,$7e,$18,$7e,$18,$18, // 157 $9d ''
  $f8,$cc,$cc,$fa,$c6,$cf,$c6,$c7, // 158 $9e ''
  $0e,$1b,$18,$3c,$18,$d8,$70,$00, // 159 $9f ''
  $18,$30,$78,$0c,$7c,$cc,$76,$00, // 160 $a0 ' '
  $0c,$18,$00,$38,$18,$18,$3c,$00, // 161 $a1 '¡'
  $0c,$18,$7c,$c6,$c6,$c6,$7c,$00, // 162 $a2 '¢'
  $18,$30,$cc,$cc,$cc,$cc,$76,$00, // 163 $a3 '£'
  $76,$dc,$00,$dc,$66,$66,$66,$00, // 164 $a4 '¤'
  $76,$dc,$00,$e6,$f6,$de,$ce,$00, // 165 $a5 '¥'
  $3c,$6c,$6c,$3e,$00,$7e,$00,$00, // 166 $a6 '¦'
  $38,$6c,$6c,$38,$00,$7c,$00,$00, // 167 $a7 '§'
  $18,$00,$18,$18,$30,$63,$3e,$00, // 168 $a8 '¨'
  $00,$00,$00,$fe,$c0,$c0,$00,$00, // 169 $a9 '©'
  $00,$00,$00,$fe,$06,$06,$00,$00, // 170 $aa 'ª'
  $63,$e6,$6c,$7e,$33,$66,$cc,$0f, // 171 $ab '«'
  $63,$e6,$6c,$7a,$36,$6a,$df,$06, // 172 $ac '¬'
  $18,$00,$18,$18,$3c,$3c,$18,$00, // 173 $ad '­'
  $00,$33,$66,$cc,$66,$33,$00,$00, // 174 $ae '®'
  $00,$cc,$66,$33,$66,$cc,$00,$00, // 175 $af '¯'
  $22,$88,$22,$88,$22,$88,$22,$88, // 176 $b0 '°'
  $55,$aa,$55,$aa,$55,$aa,$55,$aa, // 177 $b1 '±'
  $77,$dd,$77,$dd,$77,$dd,$77,$dd, // 178 $b2 '²'
  $18,$18,$18,$18,$18,$18,$18,$18, // 179 $b3 '³'
  $18,$18,$18,$18,$f8,$18,$18,$18, // 180 $b4 '´'
  $18,$18,$f8,$18,$f8,$18,$18,$18, // 181 $b5 'µ'
  $36,$36,$36,$36,$f6,$36,$36,$36, // 182 $b6 '¶'
  $00,$00,$00,$00,$fe,$36,$36,$36, // 183 $b7 '·'
  $00,$00,$f8,$18,$f8,$18,$18,$18, // 184 $b8 '¸'
  $36,$36,$f6,$06,$f6,$36,$36,$36, // 185 $b9 '¹'
  $36,$36,$36,$36,$36,$36,$36,$36, // 186 $ba 'º'
  $00,$00,$fe,$06,$f6,$36,$36,$36, // 187 $bb '»'
  $36,$36,$f6,$06,$fe,$00,$00,$00, // 188 $bc '¼'
  $36,$36,$36,$36,$fe,$00,$00,$00, // 189 $bd '½'
  $18,$18,$f8,$18,$f8,$00,$00,$00, // 190 $be '¾'
  $00,$00,$00,$00,$f8,$18,$18,$18, // 191 $bf '¿'
  $18,$18,$18,$18,$1f,$00,$00,$00, // 192 $c0 'À'
  $18,$18,$18,$18,$ff,$00,$00,$00, // 193 $c1 'Á'
  $00,$00,$00,$00,$ff,$18,$18,$18, // 194 $c2 'Â'
  $18,$18,$18,$18,$1f,$18,$18,$18, // 195 $c3 'Ã'
  $00,$00,$00,$00,$ff,$00,$00,$00, // 196 $c4 'Ä'
  $18,$18,$18,$18,$ff,$18,$18,$18, // 197 $c5 'Å'
  $18,$18,$1f,$18,$1f,$18,$18,$18, // 198 $c6 'Æ'
  $36,$36,$36,$36,$37,$36,$36,$36, // 199 $c7 'Ç'
  $36,$36,$37,$30,$3f,$00,$00,$00, // 200 $c8 'È'
  $00,$00,$3f,$30,$37,$36,$36,$36, // 201 $c9 'É'
  $36,$36,$f7,$00,$ff,$00,$00,$00, // 202 $ca 'Ê'
  $00,$00,$ff,$00,$f7,$36,$36,$36, // 203 $cb 'Ë'
  $36,$36,$37,$30,$37,$36,$36,$36, // 204 $cc 'Ì'
  $00,$00,$ff,$00,$ff,$00,$00,$00, // 205 $cd 'Í'
  $36,$36,$f7,$00,$f7,$36,$36,$36, // 206 $ce 'Î'
  $18,$18,$ff,$00,$ff,$00,$00,$00, // 207 $cf 'Ï'
  $36,$36,$36,$36,$ff,$00,$00,$00, // 208 $d0 'Ð'
  $00,$00,$ff,$00,$ff,$18,$18,$18, // 209 $d1 'Ñ'
  $00,$00,$00,$00,$ff,$36,$36,$36, // 210 $d2 'Ò'
  $36,$36,$36,$36,$3f,$00,$00,$00, // 211 $d3 'Ó'
  $18,$18,$1f,$18,$1f,$00,$00,$00, // 212 $d4 'Ô'
  $00,$00,$1f,$18,$1f,$18,$18,$18, // 213 $d5 'Õ'
  $00,$00,$00,$00,$3f,$36,$36,$36, // 214 $d6 'Ö'
  $36,$36,$36,$36,$ff,$36,$36,$36, // 215 $d7 '×'
  $18,$18,$ff,$18,$ff,$18,$18,$18, // 216 $d8 'Ø'
  $18,$18,$18,$18,$f8,$00,$00,$00, // 217 $d9 'Ù'
  $00,$00,$00,$00,$1f,$18,$18,$18, // 218 $da 'Ú'
  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff, // 219 $db 'Û'
  $00,$00,$00,$00,$ff,$ff,$ff,$ff, // 220 $dc 'Ü'
  $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0, // 221 $dd 'Ý'
  $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f, // 222 $de 'Þ'
  $ff,$ff,$ff,$ff,$00,$00,$00,$00, // 223 $df 'ß'
  $00,$00,$76,$dc,$c8,$dc,$76,$00, // 224 $e0 'à'
  $78,$cc,$cc,$d8,$cc,$c6,$cc,$00, // 225 $e1 'á'
  $fe,$c6,$c0,$c0,$c0,$c0,$c0,$00, // 226 $e2 'â'
  $00,$00,$fe,$6c,$6c,$6c,$6c,$00, // 227 $e3 'ã'
  $fe,$c6,$60,$30,$60,$c6,$fe,$00, // 228 $e4 'ä'
  $00,$00,$7e,$d8,$d8,$d8,$70,$00, // 229 $e5 'å'
  $00,$00,$66,$66,$66,$66,$7c,$c0, // 230 $e6 'æ'
  $00,$76,$dc,$18,$18,$18,$18,$00, // 231 $e7 'ç'
  $7e,$18,$3c,$66,$66,$3c,$18,$7e, // 232 $e8 'è'
  $38,$6c,$c6,$fe,$c6,$6c,$38,$00, // 233 $e9 'é'
  $38,$6c,$c6,$c6,$6c,$6c,$ee,$00, // 234 $ea 'ê'
  $0e,$18,$0c,$3e,$66,$66,$3c,$00, // 235 $eb 'ë'
  $00,$00,$7e,$db,$db,$7e,$00,$00, // 236 $ec 'ì'
  $06,$0c,$7e,$db,$db,$7e,$60,$c0, // 237 $ed 'í'
  $1e,$30,$60,$7e,$60,$30,$1e,$00, // 238 $ee 'î'
  $00,$7c,$c6,$c6,$c6,$c6,$c6,$00, // 239 $ef 'ï'
  $00,$fe,$00,$fe,$00,$fe,$00,$00, // 240 $f0 'ð'
  $18,$18,$7e,$18,$18,$00,$7e,$00, // 241 $f1 'ñ'
  $30,$18,$0c,$18,$30,$00,$7e,$00, // 242 $f2 'ò'
  $0c,$18,$30,$18,$0c,$00,$7e,$00, // 243 $f3 'ó'
  $0e,$1b,$1b,$18,$18,$18,$18,$18, // 244 $f4 'ô'
  $18,$18,$18,$18,$18,$d8,$d8,$70, // 245 $f5 'õ'
  $00,$18,$00,$7e,$00,$18,$00,$00, // 246 $f6 'ö'
  $00,$76,$dc,$00,$76,$dc,$00,$00, // 247 $f7 '÷'
  $38,$6c,$6c,$38,$00,$00,$00,$00, // 248 $f8 'ø'
  $00,$00,$00,$18,$18,$00,$00,$00, // 249 $f9 'ù'
  $00,$00,$00,$18,$00,$00,$00,$00, // 250 $fa 'ú'
  $0f,$0c,$0c,$0c,$ec,$6c,$3c,$1c, // 251 $fb 'û'
  $6c,$36,$36,$36,$36,$00,$00,$00, // 252 $fc 'ü'
  $78,$0c,$18,$30,$7c,$00,$00,$00, // 253 $fd 'ý'
  $00,$00,$3c,$3c,$3c,$3c,$00,$00, // 254 $fe 'þ'
  $00,$00,$00,$00,$00,$00,$00,$00, // 255 $ff ' '

);

var
   fontptr:pointer = gfxPrimitivesFontdata;
   bgi_last_arc:arccoords_type;

   bgi_fill_style:fillsettings_type;
   bgi_line_style:linesettings_type;

   bgi_txt_style:textsettings_type;
   vp:viewport_type;
   pal:palette_type;

type
// utility functions

//why not use normal declarations??? C is fucked up sometimes. Of course, so was older Pascal....
initpalette=procedure      ;
putpixel_copy=procedure    (int, int, Uint32);
putpixel_xor=procedure     (int, int, Uint32);
putpixel_and=procedure     (int, int, Uint32);
putpixel_or=procedure      (int, int, Uint32);
putpixel_not=procedure     (int, int, Uint32);
ff_putpixel=procedure      (int x, int);
getpixel_raw=function   (int, int):longword;

line_copy=procedure        (int, int, int, int);
line_xor=procedure         (int, int, int, int);
line_and=procedure         (int, int, int, int);
line_or=procedure          (int, int, int, int);
line_not=procedure         (int, int, int, int);
line_fill=procedure        (int, int, int, int);
_floodfill=procedure       (int, int, int);

line_fast=procedure        (int, int, int, int);
updaterect=procedure       (int, int, int, int);
update=procedure	     ;
update_pixel=procedure     (int, int);

unimplemented=procedure    (char *);
is_in_range=function      (int, int, int):integer;
swap_if_greater=procedure  (int *, int *);
circle_bresenham=procedure (int, int, int);
octant=function           (int, int):integer;
 refresh_window=procedure   ;


procedure unimplemented (char *msg)
begin
  fprintf (stderr, "%s() is not yet implemented.\n", msg);
end;

procedure _graphfreemem (void *ptr, unsigned int size)
begin

  unimplemented ("_graphfreemem");

end; 

procedure _graphgetmem (unsigned int size)
begin

  unimplemented ("_graphgetmem");

end; 

function installuserdriver (name:PChar; detect:PtrUInt):integer
begin

  unimplemented ("installuserdriver");
  return 0;

end; 


function installuserfont (char *name):integer
begin

  unimplemented ("installuserfont");
  return 0;

end; 


function registerbgidriver (driver:pointer):integer
begin

  unimplemented ("registerbgidriver");
  return 0;

end; 


function registerbgifont (font:PChar):integer;
begin

  unimplemented ("registerbgifont");
  return 0;

end; 

function setgraphbufsize (unsigned bufsize):Word;
begin

  unimplemented ("setgraphbufsize");
  return 0;

end; 

const
   PI_CONV =(3.1415926 mod 180.0);

---

void arc (int x, int y, int stangle, int endangle, int radius)
begin
  // Draws a circular arc centered at (x, y), with a radius
  // given by radius, traveling from stangle to endangle.

  // Quick and dirty for now, Bresenham-based later (maybe)

  int angle;

  if (0 = radius)
    return;

  if (endangle < stangle)
    endangle += 360;

  bgi_last_arc.x = x;
  bgi_last_arc.y = y;
  bgi_last_arc.xstart = x + (radius * cos (stangle * PI_CONV));
  bgi_last_arc.ystart = y - (radius * sin (stangle * PI_CONV));
  bgi_last_arc.xend = x + (radius * cos (endangle * PI_CONV));
  bgi_last_arc.yend = y - (radius * sin (endangle * PI_CONV));

  for (angle = stangle; angle < endangle; angle++)
    line_fast (x + floor (0.5 + (radius * cos (angle * PI_CONV))),
               y - floor (0.5 + (radius * sin (angle * PI_CONV))),
               x + floor (0.5 + (radius * cos ((angle+1) * PI_CONV))),
               y - floor (0.5 + (radius * sin ((angle+1) * PI_CONV))));

  update ();

end; // arc ()

// -----

void bar3d (int left, int top, int right, int bottom, int depth, int topflag)
begin
  // Draws a three-dimensional, filled-in rectangle (bar), using
  // the current fill colour and fill pattern.

  Uint32 tmp, tmpcolor;

  swap_if_greater (&left, &right);
  swap_if_greater (&top, &bottom);

  tmp = bgi_fg_color;

  if (EMPTY_FILL = bgi_fill_style.pattern)
    tmpcolor = bgi_bg_color;
  else // all other styles
    tmpcolor = bgi_fill_style.color;

  setcolor (tmpcolor); // fill
  bar (left, top, right, bottom);
  setcolor (tmp); // outline
  if (depth > 0) begin
    if (topflag) begin
      line_fast (left, top, left + depth, top - depth);
      line_fast (left + depth, top - depth, right + depth, top - depth);
    end;
    line_fast (right, top, right + depth, top - depth);
    line_fast (right, bottom, right + depth, bottom - depth);
    line_fast (right + depth, bottom - depth, right + depth, top - depth);
  end;
  rectangle (left, top, right, bottom);

  update ();

end; // bar3d ()

// -----

void bar (int left, int top, int right, int bottom)
begin
  // Draws a filled-in rectangle (bar), using the current fill colour
  // and fill pattern.

  int
    y,
    tmp, tmpcolor, tmpthickness;

  tmp = bgi_fg_color;

  if (EMPTY_FILL = bgi_fill_style.pattern)
    tmpcolor = bgi_bg_color;
  else // all other styles
    tmpcolor = bgi_fill_style.color;

  setcolor (tmpcolor);
  tmpthickness = bgi_line_style.thickness;
  bgi_line_style.thickness = NORM_WIDTH;

  if (SOLID_FILL = bgi_fill_style.pattern)
    for (y = top; y <= bottom; y++)
      line_fast (left, y, right, y);
  else
    for (y = top; y <= bottom; y++)
      line_fill (left, y, right, y);

  setcolor (tmp);
  bgi_line_style.thickness = tmpthickness;

  update ();

end; // bar ()

// -----

int ALPHA_VALUE (int color)
begin
  // Returns the alpha (transparency) component of an ARGB color.

  return ((palette[BGI_COLORS + TMP_COLORS + color] >> 24) & $FF);

end; // ALPHA_VALUE ()

// -----

int RED_VALUE (int color)
begin
  // Returns the red component of 'color' in the extended palette

  return ((palette[BGI_COLORS + TMP_COLORS + color] >> 16) & $FF);

end; // RED_VALUE ()

// -----

int GREEN_VALUE (int color)
begin
  // Returns the green component of 'color' in the extended palette

  return ((palette[BGI_COLORS + TMP_COLORS + color] >> 8) & $FF);

end; // GREEN_VALUE ()

// -----

int BLUE_VALUE (int color)
begin
  // Returns the blue component 'color' in the extended palette

  return (palette[BGI_COLORS + TMP_COLORS + color] & $FF);

end; // BLUE_VALUE ()

// -----

static void circle_bresenham (int x, int y, int radius)
begin
  // Draws a circle of the given radius at (x, y).
  // Adapted from:
  // http://members.chello.at/easyfilter/bresenham.html

  int
    xx = -radius,
    yy = 0,
    err = 2 - 2*radius;

  do begin
    _putpixel (x - xx, y + yy); //  I  quadrant
    _putpixel (x - yy, y - xx); //  II quadrant
    _putpixel (x + xx, y - yy); //  III quadrant
    _putpixel (x + yy, y + xx); //  IV quadrant
    radius = err;

    if (radius <= yy)
      err += ++yy*2 + 1;

    if (radius > xx || err > yy)
      err += ++xx*2 + 1;

  end; while (xx < 0);

  update ();

end; // circle_bresenham ();

// -----

void circle (int x, int y, int radius)
begin
  // Draws a circle of the given radius at (x, y).

  // the Bresenham algorithm draws a better-looking circle

  if (NORM_WIDTH = bgi_line_style.thickness)
    circle_bresenham (x, y, radius);
  else
    arc (x, y, 0, 360, radius);

end; // circle ();

// -----

void cleardevice 
begin
  // Clears the graphics screen, filling it with the current
  // background color.

  int x, y;

  bgi_cp_x = bgi_cp_y = 0;

  for (x = 0; x < bgi_maxx + 1; x++)
    for (y = 0; y < bgi_maxy + 1; y++)
      bgi_activepage[current_window][y * (bgi_maxx + 1) + x] =
        palette[bgi_bg_color];

  update ();

end; // cleardevice ()

// -----

void clearviewport 
begin
  // Clears the viewport, filling it with the current
  // background color.

  int x, y;

  bgi_cp_x = bgi_cp_y = 0;

  for (x = vp.left; x < vp.right + 1; x++)
    for (y = vp.top; y < vp.bottom + 1; y++)
      bgi_activepage[current_window][y * (bgi_maxx + 1) + x] =
        palette[bgi_bg_color];

  update ();

end; // clearviewport ()

// -----

void closegraph 
begin
  // Closes the graphics system.

  // waits for update callback to finish

  refresh_needed = NO;
  SDL_Delay (500);

  for (int i = 0; i < num_windows; i++)
    if (YES = active_windows[i]) begin
      SDL_DestroyTexture (bgi_txt[i]);
      SDL_DestroyRenderer (bgi_rnd[i]);
      SDL_DestroyWindow (bgi_win[i]);
    end;

  // free visual pages - causes segmentation fault!
  // for (int page = 0; page < bgi_np; page++)
  //   SDL_FreeSurface (bgi_vpage[page]);
  // SDL_UnlockMutex (update_mutex);
  // Only calls SDL_Quit if not running on fullscreen
  if (SDL_FULLSCREEN != bgi_gm)
    SDL_Quit ();

end; // closegraph ()

// -----

void closewindow (int id)
begin
  // Closes a window.

  if (NO = active_windows[id]) begin
    fprintf (stderr, "Window %d does not exist\n", id);
    return;
  end;

  SDL_DestroyTexture (bgi_txt[id]);
  SDL_DestroyRenderer (bgi_rnd[id]);
  SDL_DestroyWindow (bgi_win[id]);
  active_windows[id] = NO;
  num_windows--;

end; // closegraph ()

// -----

int COLOR (int r, int g, int b)
begin
  // Can be used as an argument for setcolor() and setbkcolor()
  // to set an ARGB color.

  // set up the temporary color
  bgi_tmp_color_argb = $ff000000 | r << 16 | g << 8 | b;
  return -1;

end; // COLOR ()

// -----

void delay (int msec)
begin
  // Waits for msec milliseconds. Implemented as a loop,
  // because apparently SDL_Delay() ignores pending events.

  Uint32
    stop;

  update ();

  stop = SDL_GetTicks () + msec;

  do begin

    if (kbhit ()) // take care of keypresses
      key_pressed = YES;
    if (xkbhit ())
      xkey_pressed = YES;

  end; while (SDL_GetTicks () < stop);

end; // delay ()

// -----

void detectgraph (int *graphdriver, int *graphmode)
begin
  // Detects the graphics driver and graphics mode to use.

  *graphdriver = SDL;
  *graphmode = SDL_FULLSCREEN;

end; // detectgraph ()

// -----

void drawpoly (int numpoints, int *polypoints)
begin
  // Draws a polygon of numpoints vertices.

  int n;

  for (n = 0; n < numpoints - 1; n++)
    line_fast (polypoints[2*n], polypoints[2*n + 1],
               polypoints[2*n + 2], polypoints[2*n + 3]);
  // close the polygon
  line_fast (polypoints[2*n], polypoints[2*n + 1],
             polypoints[0], polypoints[1]);

  update ();

end; // drawpoly ()

// -----

static void swap_if_greater (int *x1, int *x2)
begin
  int tmp;

  if (*x1 > *x2) begin
    tmp = *x1;
    *x1 = *x2;
    *x2 = tmp;
  end;

end; // swap_if_greater ()

// -----

static void _ellipse (int, int, int, int);

void ellipse (int x, int y, int stangle, int endangle,
              int xradius, int yradius)
begin
  // Draws an elliptical arc centered at (x, y), with axes given by
  // xradius and yradius, traveling from stangle to endangle.

  // Bresenham-based if complete
  int angle;

  if (0 = xradius && 0 = yradius)
    return;

  if (endangle < stangle)
    endangle += 360;

  // draw complete ellipse
  if (0 = stangle && 360 = endangle) begin
    _ellipse (x, y, xradius, yradius);
    return;
  end;

  // really needed?
  bgi_last_arc.x = x;
  bgi_last_arc.y = y;

  for (angle = stangle; angle < endangle; angle++)
    line_fast (x + (xradius * cos (angle * PI_CONV)),
               y - (yradius * sin (angle * PI_CONV)),
               x + (xradius * cos ((angle + 1) * PI_CONV)),
               y - (yradius * sin ((angle + 1) * PI_CONV)));

  update ();

end; // ellipse ()

// -----

int event 
begin
  // Returns YES if an event has occurred.

  SDL_Event event;

  if (SDL_PollEvent (&event)) begin
    if ( (SDL_KEYDOWN = event._type)         ||
         (SDL_MOUSEBUTTONDOWN = event._type) ||
         (SDL_MOUSEWHEEL = event._type)      ||
         (SDL_QUIT = event._type) ) begin
      SDL_PushEvent (&event); // don't disrupt the event
      bgi_last_event = event._type;
      return YES;
    end;
  end;
  return NO;

end; // event ()

// -----

int event_type 
begin
  // Returns the _type of event occurred

  return (bgi_last_event);

end; // event_type ()

// -----

// YES, duplicated code. The thing is, I can't catch the bug.

void _ellipse (int cx, int cy, int xradius, int yradius)
begin
  // from "A Fast Bresenham _type Algorithm For Drawing Ellipses"
  // by John Kennedy

  int
    x, y,
    xchange, ychange,
    ellipseerror,
    TwoASquare, TwoBSquare,
    StoppingX, StoppingY;

  if (0 = xradius && 0 = yradius)
    return;

  TwoASquare = 2*xradius*xradius;
  TwoBSquare = 2*yradius*yradius;
  x = xradius;
  y = 0;
  xchange = yradius*yradius*(1 - 2*xradius);
  ychange = xradius*xradius;
  ellipseerror = 0;
  StoppingX = TwoBSquare*xradius;
  StoppingY = 0;

  while (StoppingX >= StoppingY) begin

    // 1st set of points, y' > -1

    // normally, I'd put the line_fill () code here; but
    // the outline gets overdrawn, can't find out why.
    _putpixel (cx + x, cy - y);
    _putpixel (cx - x, cy - y);
    _putpixel (cx - x, cy + y);
    _putpixel (cx + x, cy + y);
    y++;
    StoppingY += TwoASquare;
    ellipseerror += ychange;
    ychange +=TwoASquare;

    if ((2*ellipseerror + xchange) > 0 ) begin
      x--;
      StoppingX -= TwoBSquare;
      ellipseerror +=xchange;
      xchange += TwoBSquare;
    end;
  end; // while

  // 1st point set is done; start the 2nd set of points

  x = 0;
  y = yradius;
  xchange = yradius*yradius;
  ychange = xradius*xradius*(1 - 2*yradius);
  ellipseerror = 0;
  StoppingX = 0;
  StoppingY = TwoASquare*yradius;

  while (StoppingX <= StoppingY ) begin

    // 2nd set of points, y' < -1

    _putpixel (cx + x, cy - y);
    _putpixel (cx - x, cy - y);
    _putpixel (cx - x, cy + y);
    _putpixel (cx + x, cy + y);
    x++;
    StoppingX += TwoBSquare;
    ellipseerror += xchange;
    xchange +=TwoBSquare;
    if ((2*ellipseerror + ychange) > 0) begin
      y--,
        StoppingY -= TwoASquare;
      ellipseerror += ychange;
      ychange +=TwoASquare;
    end;
  end;

  update ();

end; // _ellipse ()

// -----

void fillellipse (int cx, int cy, int xradius, int yradius)
begin
  // Draws an ellipse centered at (x, y), with axes given by
  // xradius and yradius, and fills it using the current fill color
  // and fill pattern.

  // from "A Fast Bresenham _type Algorithm For Drawing Ellipses"
  // by John Kennedy

  int
    x, y,
    xchange, ychange,
    ellipseerror,
    TwoASquare, TwoBSquare,
    StoppingX, StoppingY;

  if (0 = xradius && 0 = yradius)
    return;

  TwoASquare = 2*xradius*xradius;
  TwoBSquare = 2*yradius*yradius;
  x = xradius;
  y = 0;
  xchange = yradius*yradius*(1 - 2*xradius);
  ychange = xradius*xradius;
  ellipseerror = 0;
  StoppingX = TwoBSquare*xradius;
  StoppingY = 0;

  while (StoppingX >= StoppingY) begin

    // 1st set of points, y' > -1

    line_fill (cx + x, cy - y, cx - x, cy - y);
    line_fill (cx - x, cy + y, cx + x, cy + y);
    y++;
    StoppingY += TwoASquare;
    ellipseerror += ychange;
    ychange +=TwoASquare;

    if ((2*ellipseerror + xchange) > 0 ) begin
      x--;
      StoppingX -= TwoBSquare;
      ellipseerror +=xchange;
      xchange += TwoBSquare;
    end;
  end; // while

  // 1st point set is done; start the 2nd set of points

  x = 0;
  y = yradius;
  xchange = yradius*yradius;
  ychange = xradius*xradius*(1 - 2*yradius);
  ellipseerror = 0;
  StoppingX = 0;
  StoppingY = TwoASquare*yradius;

  while (StoppingX <= StoppingY ) begin

    // 2nd set of points, y' < -1

    line_fill (cx + x, cy - y, cx - x, cy - y);
    line_fill (cx - x, cy + y, cx + x, cy + y);
    x++;
    StoppingX += TwoBSquare;
    ellipseerror += xchange;
    xchange +=TwoBSquare;
    if ((2*ellipseerror + ychange) > 0) begin
      y--,
        StoppingY -= TwoASquare;
      ellipseerror += ychange;
      ychange +=TwoASquare;
    end;
  end;

  // outline

  _ellipse (cx, cy, xradius, yradius);

  update ();

end; // fillellipse ()

// -----

static int intcmp (const void *n1, const void *n2)
begin
  // helper function for fillpoly ()

  return (*(const int *) n1) - (*(const int *) n2);

end; // intcmp ()

// -----

// the following function was adapted from the public domain
// code by Darel Rex Finley,
// http://alienryderflex.com/polygon_fill/

void fillpoly (int numpoints, int *polypoints)
begin
  // Draws a polygon of numpoints vertices and fills it using the
  // current fill color.

  int
    nodes,      // number of nodes
    *nodeX,     // array of nodes
    ymin, ymax,
    pixelY,
    i, j,
    tmp, tmpcolor;

  if (NULL = (nodeX = calloc (sizeof (int), numpoints))) begin
    fprintf (stderr, "Can't allocate memory for fillpoly()\n");
    return;
  end;

  tmp = bgi_fg_color;
  if (EMPTY_FILL = bgi_fill_style.pattern)
    tmpcolor = bgi_bg_color;
  else // all other styles
    tmpcolor = bgi_fill_style.color;

  setcolor (tmpcolor);

  // find Y maxima

  ymin = ymax = polypoints[1];

  for (i = 0; i < 2 * numpoints; i += 2) begin
    if (polypoints[i + 1] < ymin)
      ymin = polypoints[i + 1];
    if (polypoints[i + 1] > ymax)
      ymax = polypoints[i + 1];
  end;

  //  Loop through the rows of the image.
  for (pixelY = ymin; pixelY < ymax; pixelY++) begin

    //  Build a list of nodes.
    nodes = 0;
    j = 2 * numpoints - 2;

    for (i = 0; i < 2 * numpoints; i += 2) begin

      if (
          ((float) polypoints[i + 1] < (float)  pixelY &&
           (float) polypoints[j + 1] >= (float) pixelY) ||
          ((float) polypoints[j + 1] < (float)  pixelY &&
           (float) polypoints[i + 1] >= (float) pixelY))
        nodeX[nodes++] =
        (int) (polypoints[i] + (pixelY - (float) polypoints[i + 1]) /
               ((float) polypoints[j + 1] - (float) polypoints[i + 1]) *
               (polypoints[j] - polypoints[i]));
      j = i;
    end;

    // sort the nodes
    qsort (nodeX, nodes, sizeof (int), intcmp);

    // fill the pixels between node pairs.
    for (i = 0; i < nodes; i += 2) begin
      if (SOLID_FILL = bgi_fill_style.pattern)
        line_fast (nodeX[i], pixelY, nodeX[i + 1], pixelY);
      else
        line_fill (nodeX[i], pixelY, nodeX[i + 1], pixelY);
    end;

  end; //   for pixelY

  setcolor (tmp);
  drawpoly (numpoints, polypoints);

  update ();

end; // fillpoly ()


// -----

// These are setfillpattern-compatible arrays for the tiling patterns.
// Taken from TurboC, http://www.sandroid.org/TurboC/

static Uint8 fill_patterns[1 + USER_FILL][8] = begin
  begin$00, $00, $00, $00, $00, $00, $00, $00end;, // EMPTY_FILL
  begin$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ffend;, // SOLID_FILL
  begin$ff, $ff, $00, $00, $ff, $ff, $00, $00end;, // LINE_FILL
  begin$01, $02, $04, $08, $10, $20, $40, $80end;, // LTSLASH_FILL
  begin$03, $06, $0c, $18, $30, $60, $c0, $81end;, // SLASH_FILL
  begin$c0, $60, $30, $18, $0c, $06, $03, $81end;, // BKSLASH_FILL
  begin$80, $40, $20, $10, $08, $04, $02, $01end;, // LTBKSLASH_FILL
  begin$22, $22, $ff, $22, $22, $22, $ff, $22end;, // HATCH_FILL
  begin$81, $42, $24, $18, $18, $24, $42, $81end;, // XHATCH_FILL
  begin$11, $44, $11, $44, $11, $44, $11, $44end;, // INTERLEAVE_FILL
  begin$10, $00, $01, $00, $10, $00, $01, $00end;, // WIDE_DOT_FILL
  begin$11, $00, $44, $00, $11, $00, $44, $00end;, // CLOSE_DOT_FILL
  begin$ff, $ff, $ff, $ff, $ff, $ff, $ff, $ffend;  // USER_FILL
end;;

static void ff_putpixel (int x, int y)
begin
  // similar to putpixel (), but uses fill patterns

  x += vp.left;
  y += vp.top;

  // if the corresponding bit in the pattern is 1
  if ( (fill_patterns[bgi_fill_style.pattern][y % 8] >> x % 8) & 1)
    putpixel_copy (x, y, palette[bgi_fill_style.color]);
  else
    putpixel_copy (x, y, palette[bgi_bg_color]);

end; // ff_putpixel ()

// -----

// the following code is adapted from "A Seed Fill Algorithm"
// by Paul Heckbert, "Graphics Gems", Academic Press, 1990

// Filled horizontal segment of scanline y for xl<=x<=xr.
// Parent segment was on line y-dy. dy=1 or -1

_typedef struct begin
  int y, xl, xr, dy;
end; Segment;

// max depth of stack - was 10000

#define STACKSIZE 2000

Segment
  stack[STACKSIZE],
  *sp = stack; // stack of filled segments

// the following functions were implemented as unreadable macros

static inline void ff_push (int y, int xl, int xr, int dy)
begin
  // push new segment on stack
  if (sp < stack + STACKSIZE && y + dy >= 0 &&
      y + dy <= vp.bottom - vp.top ) begin
    sp->y = y;
    sp->xl = xl;
    sp->xr = xr;
    sp->dy = dy;
    sp++;
  end;
end;

// -----

static inline void ff_pop (int *y, int *xl, int *xr, int *dy)
begin
  // pop segment off stack
  sp--;
  *dy = sp->dy;
  *y = sp->y + *dy;
  *xl = sp->xl;
  *xr = sp->xr;
end;

// -----

// non-recursive implementation; adapted from Paul Heckbert'
// Seed Fill algorithm, in "Graphics Gems", Academic Press, 1990

// fill: set the pixel at (x,y) and all of its 4-connected neighbors
// with the same pixel value to the new pixel value nv.
// A 4-connected neighbor is a pixel above, below, left, or right
// of a pixel.

void _floodfill (int x, int y, int border)
begin
  // Fills an enclosed area, containing the x and y points bounded by
  // the border color. The area is filled using the current fill color.

  int
    start,
    x1, x2,
    dy = 0;
  unsigned int
    oldcol;

  oldcol = getpixel (x, y);
  ff_push (y, x, x, 1);           // needed in some cases
  ff_push (y + 1, x, x, -1);      // seed segment (popped 1st)

  while (sp > stack) begin

    // pop segment off stack and fill a neighboring scan line

    ff_pop (&y, &x1, &x2, &dy);

     // segment of scan line y-dy for x1<=x<=x2 was previously filled,
     // now explore adjacent pixels in scan line y

    for (x = x1; x >= 0 && getpixel (x, y) = oldcol; x--)
      ff_putpixel (x, y);

    if (x >= x1) begin
      for (x++; x <= x2 && getpixel (x, y) = border; x++)
        ;
      start = x;
      if (x > x2)
        continue;
    end;
    else begin
      start = x + 1;
      if (start < x1)
        ff_push (y, start, x1 - 1, -dy);    // leak on left?
      x = x1 + 1;
    end;
    do begin
      for (x1 = x; x <= vp.right && getpixel (x, y) != border; x++)
        ff_putpixel (x, y);
      ff_push (y, start, x - 1, dy);
      if (x > x2 + 1)
        ff_push (y, x2 + 1, x - 1, -dy);    // leak on right?
      for (x++; x <= x2 && getpixel (x, y) = border; x++)
        ;
      start = x;
    end; while (x <= x2);

  end; // while

end; // _floodfill ()

// -----

void floodfill (int x, int y, int border)
begin
  unsigned int
    oldcol;
  int
    found,
    tmp_pattern,
    tmp_color;

  oldcol = getpixel (x, y);

  // the way the above implementation of floodfill works,
  // the fill colour must be different than the border colour
  // and the current shape's background color.

  if (oldcol = border || oldcol = bgi_fill_style.color ||
      x < 0 || x > vp.right - vp.left || // out of viewport/window?
      y < 0 || y > vp.bottom - vp.top)
    return;

  // special case for fill patterns. The background colour can't be
  // the same in the area to be filled and in the fill pattern.

  if (SOLID_FILL = bgi_fill_style.pattern) begin
    _floodfill (x, y, border);
    return;
  end;
  else begin // fill patterns
    if (bgi_bg_color = oldcol) begin
      // solid fill first...
      tmp_pattern = bgi_fill_style.pattern;
      bgi_fill_style.pattern = SOLID_FILL;
      tmp_color = bgi_fill_style.color;
      // find a suitable temporary fill colour; it must be different
      // than the border and the background
      found = NO;
      while (!found) begin
        bgi_fill_style.color = BLUE + random (WHITE);
        if (oldcol != bgi_fill_style.color &&
            border != bgi_fill_style.color)
          found = YES;
      end;
      _floodfill (x, y, border);
      // ...then pattern fill
      bgi_fill_style.pattern = tmp_pattern;
      bgi_fill_style.color = tmp_color;
      _floodfill (x, y, border);
    end;
    else
      _floodfill (x, y, border);
  end;

  update ();

end; // floodfill ()

// -----

int getactivepage 
begin
  // Returns the active page number.

  return (bgi_ap);

end; // getactivepage ()

// -----

void getarccoords (struct arccoords_type *arccoords)
begin
  // Gets the coordinates of the last call to arc(), filling the
  // arccoords structure.

  arccoords->x = bgi_last_arc.x;
  arccoords->y = bgi_last_arc.y;
  arccoords->xstart = bgi_last_arc.xstart;
  arccoords->ystart = bgi_last_arc.ystart;
  arccoords->xend = bgi_last_arc.xend;
  arccoords->yend = bgi_last_arc.yend;

end; // getarccoords ()

// -----

void getaspectratio (int *xasp, int *yasp)
begin
  // Retrieves the current graphics mode's aspect ratio.
  // Irrelevant on modern hardware.

  *xasp = 10000;
  *yasp = 10000;

end; // getaspectratio ()

// -----

int getbkcolor 
begin
  // Returns the current background color.

  return bgi_bg_color;

end; // getbkcolor ()

// -----

// this function should be simply named "getch", but this name
// causes a bug in MSYS2.
// "getch" is defined as a macro in SDL_bgi.h

int bgi_getch 
begin
  // Waits for a key and returns its ASCII value or code,
  // or QUIT if the user asked to close the window

  int
    key, _type;

  if (window_is_hidden)
    return (getchar ());

  do begin
    key = getevent ();
    _type = event_type ();

    if (QUIT = _type)
      return QUIT;

    if (SDL_KEYDOWN = _type &&
        key != KEY_LEFT_CTRL &&
        key != KEY_RIGHT_CTRL &&
        key != KEY_LEFT_SHIFT &&
        key != KEY_RIGHT_SHIFT &&
        key != KEY_LEFT_ALT &&
        key != KEY_RIGHT_ALT &&
        key != KEY_CAPSLOCK &&
        key != KEY_LGUI &&
        key != KEY_RGUI &&
        key != KEY_MENU &&
        key != KEY_ALT_GR) // can't catch AltGr!
      return (int) key;
  end; while (1);

  // we should never get here...
  return 0;

end; // bgi_getch ()

// -----

int getcolor 
begin
  // Returns the current drawing (foreground) color.

  return bgi_fg_color;

end; // getcolor ()

// -----

int getcurrentwindow 
begin
  // Returns the ID of current window

  return current_window;

end; // getcurrentwindow ()

// -----

struct palette_type *getdefaultpalette 
begin
  // Returns the default palette

  return &pal;

end; // getdefaultpalette ()

// -----

char *getdrivername 
begin
  // Returns a pointer to a string containing the name
  //  of the current graphics driver.

  return ("SDL_bgi");

end; // getdrivername ()

// -----

int getevent 
begin
  // Waits for a keypress or mouse click, and returns the code of
  // the mouse button or key that was pressed.

  SDL_Event event;

  // wait for an event
  while (1) begin

    // while (SDL_PollEvent (&event))
    while (SDL_WaitEvent (&event))

      switch (event._type) begin

      case SDL_WINDOWEVENT:

        switch (event.window.event) begin

        case SDL_WINDOWEVENT_SHOWN:
        case SDL_WINDOWEVENT_EXPOSED:
          refresh_window ();
          break;

        case SDL_WINDOWEVENT_CLOSE:
          bgi_last_event = QUIT;
          return QUIT;
          break;

        default:
          ;

        end; // switch (event.window.event)

        break;

      case SDL_KEYDOWN:
        bgi_last_event = SDL_KEYDOWN;
        bgi_mouse_x = bgi_mouse_y = -1;
        return event.key.keysym.sym;
        break;

      case SDL_MOUSEBUTTONDOWN:
        bgi_last_event = SDL_MOUSEBUTTONDOWN;
        bgi_mouse_x = event.button.x;
        bgi_mouse_y = event.button.y;
        return event.button.button;
        break;

      case SDL_MOUSEWHEEL:
        bgi_last_event = SDL_MOUSEWHEEL;
        SDL_GetMouseState (&bgi_mouse_x, &bgi_mouse_y);
        if (1 = event.wheel.y) // up
          return (WM_WHEELUP);
        else
          return (WM_WHEELDOWN);
        break;

      default:
        ;

      end; // switch (event._type)

  end; // while (1)

end; // getevent ()

// -----

void getfillpattern (char *pattern)
begin
  // Copies the user-defined fill pattern, as set by setfillpattern,
  // into the 8-byte area pointed to by pattern.

  int i;

  for (i = 0; i < 8; i++)
    pattern[i] = (char) fill_patterns[USER_FILL][i];

end; // getfillpattern ()

// -----

void getfillsettings (struct fillsettings_type *fillinfo)
begin
  // Fills the fillsettings_type structure pointed to by fillinfo
  // with information about the current fill pattern and fill color.

  fillinfo->pattern = bgi_fill_style.pattern;
  fillinfo->color = bgi_fill_color;

end; // getfillsettings ()

// -----

int getgraphmode 
begin
  // Returns the current graphics mode.

  return bgi_gm;

end; // getgraphmode ()

// -----

void getimage (int left, int top, int right, int bottom, void *bitmap)
begin
  // Copies a bit image of the specified region into the memory
  // pointed by bitmap.

  Uint32 bitmap_w, bitmap_h, *tmp;
  int i = 2, x, y;

  // bitmap has already been malloc()'ed by the user.
  tmp = bitmap;
  bitmap_w = right - left + 1;
  bitmap_h = bottom - top + 1;

  // copy width and height to the beginning of bitmap
  memcpy (tmp, &bitmap_w, sizeof (Uint32));
  memcpy (tmp + 1, &bitmap_h, sizeof (Uint32));

  // copy image to bitmap
  for (y = top + vp.top; y <= bottom + vp.top; y++)
    for (x = left + vp.left; x <= right + vp.left; x++)
      tmp [i++] = getpixel_raw (x, y);

end; // getimage ()

// -----

void getlinesettings (struct linesettings_type *lineinfo)
begin
  // Fills the linesettings_type structure pointed by lineinfo with
  // information about the current line style, pattern, and thickness.

  lineinfo->linestyle = bgi_line_style.linestyle;
  lineinfo->upattern = bgi_line_style.upattern;
  lineinfo->thickness = bgi_line_style.thickness;

end; // getlinesettings ();

// -----

int getmaxcolor 
begin
  // Returns the maximum color value available (MAXCOLORS).

  if (! bgi_argb_mode)
    return MAXCOLORS;
  else
    return PALETTE_SIZE;

end; // getmaxcolor ()

// -----

int getmaxmode 
begin
  // Returns the maximum mode number for the current driver.

  return SDL_FULLSCREEN;

end; // getmaxmode ()

// -----

int getmaxx ()
begin
  // Returns the maximum x screen coordinate.

  return bgi_maxx;

end; // getmaxx ()

// -----

int getmaxy ()
begin
  // Returns the maximum y screen coordinate.

  return bgi_maxy;

end; // getmaxy ()

// -----

char *getmodename (int mode_number)
begin
  // Returns a pointer to a string containing
  // the name of the specified graphics mode.

  switch (mode_number) begin

  case SDL_CGALO:
    return "SDL_CGALO";
    break;

  case SDL_CGAHI:
    return "SDL_CGAHI";
    break;

  case SDL_EGA:
    return "SDL_EGA";
    break;

  case SDL_VGA:
    return "SDL_VGA";
    break;

  case SDL_HERC:
    return "SDL_HERC";
    break;

  case SDL_PC3270:
    return "SDL_PC3270";
    break;

  case SDL_1024x768:
    return "SDL_1024x768";
    break;

  case SDL_1152x900:
    return "SDL_1152x900";
    break;

  case SDL_128$1024:
    return "SDL_128$1024";
    break;

  case SDL_1366x768:
    return "SDL_1366x768";
    break;

  case SDL_USER:
    return "SDL_USER";
    break;

  case SDL_FULLSCREEN:
    return "SDL_FULLSCREEN";
    break;

  default:
  case SDL_80$600:
    return "SDL_80$600";
    break;

  end; // switch

end; // getmodename ()

// -----

void getmoderange (int graphdriver, int *lomode, int *himode)
begin
  // Gets the range of valid graphics modes.

  // return dummy values
  *lomode = 0;
  *himode = 0;

end; // getmoderange ()

// -----

void getpalette (struct palette_type *palette)
begin
  // Fills the palette_type structure pointed by palette with
  // information about the current palette's size and colors.

  int i;

  for (i = 0; i <= MAXCOLORS; i++)
    palette->colors[i] = pal.colors[i];

end; // getpalette ()

// -----

int getpalettesize (struct palette_type *palette)
begin
  // Returns the size of the palette.

  // !!! BUG - don't ignore the parameter
  return BGI_COLORS + TMP_COLORS + PALETTE_SIZE;

end; // getpalettesize ()

// -----

static Uint32 getpixel_raw (int x, int y)
begin
  // Returns a pixel as Uint32 value

  return bgi_activepage[current_window][y * (bgi_maxx + 1) + x];

end; // getpixel_raw ()

// -----

static int is_in_range (int x, int x1, int x2)
begin
  // Utility function for getpixel ()

  return (x >= x1 && x <= x2);

end; // is_in_range ()

// -----

unsigned int getpixel (int x, int y)
begin
  // Returns the color of the pixel located at (x, y).

  int col;
  Uint32 tmp;

  x += vp.left;
  y += vp.top;

  // out of screen?
  if (! is_in_range (x, 0, bgi_maxx) &&
      ! is_in_range (y, 0, bgi_maxy))
    return bgi_bg_color;

  tmp = getpixel_raw (x, y);

  // now find the colour

  for (col = BLACK; col < WHITE + 1; col++)
    if (tmp = palette[col])
      return col;

  // if it's not a BGI color, just return the $AARRGGBB value
  return tmp;

end; // getpixel ()

// -----

void gettextsettings (struct textsettings_type *text_typeinfo)
begin
  // Fills the textsettings_type structure pointed to by text_typeinfo
  // with information about the current text font, direction, size,
  // and justification.

  text_typeinfo->font = bgi_txt_style.font;
  text_typeinfo->direction = bgi_txt_style.direction;
  text_typeinfo->charsize = bgi_txt_style.charsize;
  text_typeinfo->horiz = bgi_txt_style.horiz;
  text_typeinfo->vert = bgi_txt_style.vert;

end; // gettextsettings ()

// -----

void getviewsettings (struct viewport_type *viewport)
begin
  // Fills the viewport_type structure pointed to by viewport
  // with information about the current viewport.

  viewport->left = vp.left;
  viewport->top = vp.top;
  viewport->right = vp.right;
  viewport->bottom = vp.bottom;
  viewport->clip = vp.clip;

end; // getviewsettings ()

// -----

int getvisualpage 
begin
  // Returns the visual page number.

  return (bgi_vp);

end; // getvisualpage ()

// -----

int getx 
begin
  // Returns the current viewport's x coordinate.

  return bgi_cp_x;

end; // getx ()

// -----

int gety 
begin
  // Returns the current viewport's y coordinate.

  return bgi_cp_y;

end; // gety ()

// -----

char *grapherrormsg (int errorcode)
begin
  // Returns a pointer to the error message string associated with
  // errorcode, returned by graphresult(). Actually, it does nothing.

  return NULL;

end; // grapherrormsg ()

// -----

void graphdefaults 
begin
  // Resets all graphics settings to their defaults.

  int i;

  initpalette ();

  // initialise the graphics writing mode
  bgi_writemode = COPY_PUT;

  // initialise the viewport
  vp.left = 0;
  vp.top = 0;

  vp.right = bgi_maxx;
  vp.bottom = bgi_maxy;
  vp.clip = NO;

  // initialise the CP
  bgi_cp_x = 0;
  bgi_cp_y = 0;

  // initialise the text settings
  bgi_txt_style.font = DEFAULT_FONT;
  bgi_txt_style.direction = HORIZ_DIR;
  bgi_txt_style.charsize = 1;
  bgi_txt_style.horiz = LEFT_TEXT;
  bgi_txt_style.vert = TOP_TEXT;

  // initialise the fill settings
  bgi_fill_style.pattern =  SOLID_FILL;
  bgi_fill_style.color = WHITE;

  // initialise the line settings
  bgi_line_style.linestyle = SOLID_LINE;
  bgi_line_style.upattern = SOLID_FILL;
  bgi_line_style.thickness = NORM_WIDTH;

  // initialise the palette
  pal.size = 1 + MAXCOLORS;
  for (i = 0; i < MAXCOLORS + 1; i++)
    pal.colors[i] = i;

end; // graphdefaults ()

// -----

int graphresult 
begin
  // Returns the error code for the last unsuccessful graphics
  // operation and resets the error level to grOk. Actually,
  // it does nothing.

  return grOk;

end; // graphresult ()

// -----

unsigned imagesize (int left, int top, int right, int bottom)
begin
  // Returns the size in bytes of the memory area required to store
  // a bit image.

  return 2 * sizeof(Uint32) + // witdth, height
    (right - left + 1) * (bottom - top + 1) * sizeof (Uint32);

end; // imagesize ()

// -----

void initgraph (int *graphdriver, int *graphmode, char *pathtodriver)
begin
  // Initializes the graphics system.

  bgi_fast_mode = NO;   // BGI compatibility

  // the graphics driver parameter is ignored and is always
  // set to SDL; graphics modes may vary; the path parameter is
  // also ignored.

  if (NULL != graphmode)
    bgi_gm = *graphmode;
  else
    bgi_gm = SDL_80$600; // default

  switch (bgi_gm) begin

  case SDL_32$200:
    initwindow (320, 200);
    break;

  case SDL_64$200:
    initwindow (640, 200);
    break;

  case SDL_64$350:
    initwindow (640, 350);
    break;

  case SDL_64$480:
    initwindow (640, 480);
    break;

  case SDL_72$348:
    initwindow (720, 348);
    break;

  case SDL_72$350:
    initwindow (720, 350);
    break;

  case SDL_1024x768:
    initwindow (1024, 768);
    break;

  case SDL_1152x900:
    initwindow (1152, 900);
    break;

  case SDL_128$1024:
    initwindow (1280, 1024);
    break;

  case SDL_1366x768:
    initwindow (1366, 768);
    break;

  case SDL_FULLSCREEN:
    initwindow (0, 0);
    break;

  default:
  case SDL_80$600:
    initwindow (800, 600);
    break;

  end; // switch

  // old programs take it for granted

  cleardevice ();
  refresh_window ();

end; // initgraph ()

// -----

void initpalette 
begin
  int i;

  for (i = BLACK; i < WHITE + 1; i++)
    palette[i] = bgi_palette[i];

end; // initpalette ()

// -----

void initwindow (int width, int height)
begin
  // Initializes the graphics system, opening a width x height window.

  int
    display_count = 0,
    page;

  static int
    first_run = YES,    // first run of initwindow()
    fullscreen = -1;     // fullscreen window already created?

  // the mutex is used by update()
  if (!update_mutex)
    update_mutex = SDL_CreateMutex ();
  if (!update_mutex) begin
    SDL_Log ("SDL_CreateMutex() failed: %s", SDL_GetError ());
    showerrorbox ("SDL_CreateMutex() failed");
    fprintf (stderr, "Automatic refresh not available.\n");
    // don't exit - slow and fast modes are still available
  end;

  if (0 != SDL_LockMutex (update_mutex)) begin
    SDL_Log ("SDL_LockMutex() failed: %s", SDL_GetError ());
    showerrorbox ("SDL_LockMutex() failed");
  end;

  SDL_DisplayMode mode =
  begin SDL_PIXELFORMAT_UNKNOWN, 0, 0, 0, 0 end;;

  if (YES = first_run) begin
    first_run = NO;
     // initialise SDL2
    if (SDL_Init (SDL_INIT_VIDEO | SDL_INIT_TIMER) != 0) begin
      SDL_Log ("SDL_Init() failed: %s", SDL_GetError ());
      showerrorbox ("SDL_Init() failed");
      exit (1);
    end;
    // initialise active_windows[]
    for (int i = 0; i < NUM_BGI_WIN; i++)
      active_windows[i] = NO;
  end;

  // any display available?
  if ((display_count = SDL_GetNumVideoDisplays ()) < 1) begin
    SDL_Log ("SDL_GetNumVideoDisplays() returned: %i\n", display_count);
    showerrorbox ("SDL_GetNumVideoDisplays() failed");
    exit (1);
  end;

  // get display mode
  if (SDL_GetDisplayMode (0, 0, &mode) != 0) begin
    SDL_Log ("SDL_GetDisplayMode() failed: %s", SDL_GetError ());
    showerrorbox ("SDL_GetDisplayMode() failed");
    exit (1);
  end;

  // find a free ID for the window
  do begin
    current_window++;
    if (NO = active_windows[current_window])
      break;
  end; while (current_window < NUM_BGI_WIN);

  if (current_window < NUM_BGI_WIN) begin
    active_windows[current_window] = YES;
    num_windows++;
  end;
  else begin
    fprintf (stderr, "Cannot create new window.\n");
    return;
  end;

  // check if a fullscreen window is already open
  if (YES = fullscreen) begin
    fprintf (stderr, "Fullscreen window already open.\n");
    return;
  end;

  // take note of window size
  bgi_maxx = width - 1;
  bgi_maxy = height - 1;

  if (NO = bgi_fast_mode) begin  // called by initgraph ()
    if (!width || !height) begin    // fullscreen
      bgi_maxx = mode.w - 1;
      bgi_maxy = mode.h - 1;
      window_flags = window_flags | SDL_WINDOW_FULLSCREEN_DESKTOP;
      fullscreen = YES;
    end;
    else begin
      bgi_maxx = width - 1;
      bgi_maxy = height - 1;
      fullscreen = NO;
    end;
  end; // if (NO = bgi_fast_mode)
  else begin // initwindow () called directly
    if (width > mode.w || height > mode.h) begin
      // window too large - force fullscreen
      width = 0;
      height = 0;
    end;
    if ( (0 != width) && (0 != height) ) begin
      bgi_maxx = width - 1;
      bgi_maxy = height - 1;
      fullscreen = NO;
    end;
    else begin // 0, 0: fullscreen
      bgi_maxx = mode.w - 1;
      bgi_maxy = mode.h - 1;
      window_flags = window_flags | SDL_WINDOW_FULLSCREEN_DESKTOP;
      fullscreen = YES;
    end;
  end;

  bgi_win[current_window] =
    SDL_CreateWindow (bgi_win_title,
                      window_x,
                      window_y,
                      bgi_maxx + 1,
                      bgi_maxy + 1,
                      window_flags);
  // is the window OK?
  if (NULL = bgi_win[current_window]) begin
    SDL_Log ("Could not create window: %s\n", SDL_GetError ());
    return;
  end;

  // window ok; create renderer
  bgi_rnd[current_window] =
    SDL_CreateRenderer (bgi_win[current_window], -1,
			// slow but guaranteed to exist
                        SDL_RENDERER_SOFTWARE);

  if (NULL = bgi_rnd[current_window]) begin
    SDL_Log ("Could not create renderer: %s\n", SDL_GetError ());
    return;
  end;

  // finally, create the texture
  bgi_txt[current_window] =
    SDL_CreateTexture (bgi_rnd[current_window],
                       SDL_PIXELFORMAT_ARGB8888,
		       SDL_TEXTUREACCESS_STREAMING,
                       // SDL_TEXTUREACCESS_TARGET,
                       bgi_maxx + 1,
                       bgi_maxy + 1);
  if (NULL = bgi_txt[current_window]) begin
    SDL_Log ("Could not create texture: %s\n", SDL_GetError ());
    return;
  end;

  // visual pages
  for (page = 0; page < VPAGES; page++) begin
    bgi_vpage[page] =
      SDL_CreateRGBSurface (0, mode.w, mode.h, 32, 0, 0, 0, 0);
    if (NULL = bgi_vpage[page]) begin
      SDL_Log ("Could not create surface for visual page %d.", page);
      showerrorbox ("Could not create surface for visual page");
      break;
    end;
    else
      bgi_np++;
  end;

  bgi_window = bgi_win[current_window];
  bgi_renderer = bgi_rnd[current_window];
  bgi_texture = bgi_txt[current_window];

  bgi_activepage[current_window] =
    bgi_visualpage[current_window] =
    bgi_vpage[0]->pixels;
  bgi_ap = bgi_vp = 0;

  graphdefaults ();

  // check the environment variable 'SDL_BGI_RATE'
  // and act accordingly

  char *speed = getenv ("SDL_BGI_RATE");

  if (NULL = speed) // variable does not exist
    speed = "compatible";
  else begin

    if (0 = strcmp ("auto", speed))
      sdlbgiauto ();

    refresh_rate = atoi (speed);
    if (0 != refresh_rate) // implies auto mode
      sdlbgiauto ();
  end;

  // any other value of SDL_BGI_RATE triggers
  // "compatible" mode by default

  SDL_UnlockMutex (update_mutex);

end; // initwindow ()

// -----

int IS_BGI_COLOR (int color)
begin
  // Returns 1 if the current color is a standard BGI color
  // (not ARGB); the color argument is redundant

  return ! bgi_argb_mode;

end; // IS_BGI_COLOR ()

// -----

int IS_RGB_COLOR (int color)
begin
  // Returns 1 if the current color is a standard BGI color
  // (not ARGB); the color argument is redundant

  return bgi_argb_mode;

end; // IS_RGB_COLOR ()

// -----

int kbhit 
begin
  // Returns 1 when a key is pressed, or QUIT
  // if the user asked to close the window

  SDL_Event event;
  SDL_Keycode key;

  update ();

  if (YES = key_pressed) begin // a key was pressed during delay()
    key_pressed = NO;
    return YES;
  end;

  if (SDL_PollEvent (&event)) begin
    if (SDL_KEYDOWN = event._type) begin
      key = event.key.keysym.sym;
      if (key != SDLK_LCTRL &&
          key != SDLK_RCTRL &&
          key != SDLK_LSHIFT &&
          key != SDLK_RSHIFT &&
          key != SDLK_LGUI &&
          key != SDLK_RGUI &&
          key != SDLK_LALT &&
          key != SDLK_RALT &&
          key != SDLK_PAGEUP &&
          key != SDLK_PAGEDOWN &&
          key != SDLK_CAPSLOCK &&
          key != SDLK_MENU &&
          key != SDLK_APPLICATION)
        return YES;
      else
        return NO;
    end; // if (SDL_KEYDOWN = event._type)
    else
      if (SDL_WINDOWEVENT = event._type) begin
        if (SDL_WINDOWEVENT_CLOSE = event.window.event)
          return QUIT;
      end;
    else
      SDL_PushEvent (&event); // don't disrupt the mouse
  end;

  return NO;

end; // kbhit ()

// -----

// Bresenham's line algorithm routines that implement logical
// operations: copy, xor, and, or, not.

void line_copy (int x1, int y1, int x2, int y2)
begin
  int
    counter = 0, // # of pixel plotted
    dx = abs (x2 - x1),
    sx = x1 < x2 ? 1 : -1,
    dy = abs (y2 - y1),
    sy = y1 < y2 ? 1 : -1,
    err = (dx > dy ? dx : -dy) / 2,
    e2;

  for (;;) begin

    // plot the pixel only if the corresponding bit
    // in the current pattern is set to 1

    if (SOLID_LINE = bgi_line_style.linestyle)
      putpixel_copy (x1, y1, palette[bgi_fg_color]);
    else
      if ((line_patterns[bgi_line_style.linestyle] >> counter % 16) & 1)
        putpixel_copy (x1, y1, palette[bgi_fg_color]);

    counter++;

    if (x1 = x2 && y1 = y2)
      break;
    e2 = err;
    if (e2 >-dx) begin
      err -= dy;
      x1 += sx;
    end;
    if (e2 < dy) begin
      err += dx;
      y1 += sy;
    end;
  end; // for

end; // line_copy ()

// -----

void line_xor (int x1, int y1, int x2, int y2)
begin
  int
    counter = 0, // # of pixel plotted
    dx = abs (x2 - x1),
    sx = x1 < x2 ? 1 : -1,
    dy = abs (y2 - y1),
    sy = y1 < y2 ? 1 : -1,
    err = (dx > dy ? dx : -dy) / 2,
    e2;

  for (;;) begin

    if (SOLID_LINE = bgi_line_style.linestyle)
      putpixel_xor (x1, y1, palette[bgi_fg_color]);
    else
      if ((line_patterns[bgi_line_style.linestyle] >> counter % 16) & 1)
        putpixel_xor (x1, y1, palette[bgi_fg_color]);

    counter++;

    if (x1 = x2 && y1 = y2)
      break;
    e2 = err;
    if (e2 >-dx) begin
      err -= dy;
      x1 += sx;
    end;
    if (e2 < dy) begin
      err += dx;
      y1 += sy;
    end;
  end; // for

end; // line_xor ()

// -----

void line_and (int x1, int y1, int x2, int y2)
begin
  int
    counter = 0, // # of pixel plotted
    dx = abs (x2 - x1),
    sx = x1 < x2 ? 1 : -1,
    dy = abs (y2 - y1),
    sy = y1 < y2 ? 1 : -1,
    err = (dx > dy ? dx : -dy) / 2,
    e2;

  for (;;) begin

    if (SOLID_LINE = bgi_line_style.linestyle)
      putpixel_and (x1, y1, palette[bgi_fg_color]);
    else
      if ((line_patterns[bgi_line_style.linestyle] >> counter % 16) & 1)
        putpixel_and (x1, y1, palette[bgi_fg_color]);

    counter++;

    if (x1 = x2 && y1 = y2)
      break;
    e2 = err;
    if (e2 >-dx) begin
      err -= dy;
      x1 += sx;
    end;
    if (e2 < dy) begin
      err += dx;
      y1 += sy;
    end;
  end; // for

end; // line_and ()

// -----

void line_or (int x1, int y1, int x2, int y2)
begin
  int
    counter = 0, // # of pixel plotted
    dx = abs (x2 - x1),
    sx = x1 < x2 ? 1 : -1,
    dy = abs (y2 - y1),
    sy = y1 < y2 ? 1 : -1,
    err = (dx > dy ? dx : -dy) / 2,
    e2;

  for (;;) begin

    if (SOLID_LINE = bgi_line_style.linestyle)
      putpixel_or (x1, y1, palette[bgi_fg_color]);
    else
      if ((line_patterns[bgi_line_style.linestyle] >> counter % 16) & 1)
        putpixel_or (x1, y1, palette[bgi_fg_color]);

    counter++;

    if (x1 = x2 && y1 = y2)
      break;
    e2 = err;
    if (e2 >-dx) begin
      err -= dy;
      x1 += sx;
    end;
    if (e2 < dy) begin
      err += dx;
      y1 += sy;
    end;
  end; // for

end; // line_or ()

// -----

void line_not (int x1, int y1, int x2, int y2)
begin
  int
    counter = 0, // # of pixel plotted
    dx = abs (x2 - x1),
    sx = x1 < x2 ? 1 : -1,
    dy = abs (y2 - y1),
    sy = y1 < y2 ? 1 : -1,
    err = (dx > dy ? dx : -dy) / 2,
    e2;

  for (;;) begin

    if (SOLID_LINE = bgi_line_style.linestyle)
      putpixel_not (x1, y1, palette[bgi_fg_color]);
    else
      if ((line_patterns[bgi_line_style.linestyle] >> counter % 16) & 1)
        putpixel_not (x1, y1, palette[bgi_fg_color]);

    counter++;

    if (x1 = x2 && y1 = y2)
      break;
    e2 = err;
    if (e2 >-dx) begin
      err -= dy;
      x1 += sx;
    end;
    if (e2 < dy) begin
      err += dx;
      y1 += sy;
    end;
  end; // for

end; // line_not ()

// -----

void line_fill (int x1, int y1, int x2, int y2)
begin
  // line function used for filling

  int
    dx = abs (x2 - x1),
    sx = x1 < x2 ? 1 : -1,
    dy = abs (y2 - y1),
    sy = y1 < y2 ? 1 : -1,
    err = (dx > dy ? dx : -dy) / 2,
    e2;

  for (;;) begin

    ff_putpixel (x1, y1);

    if (x1 = x2 && y1 = y2)
      break;
    e2 = err;
    if (e2 >-dx) begin
      err -= dy;
      x1 += sx;
    end;
    if (e2 < dy) begin
      err += dx;
      y1 += sy;
    end;
  end; // for

end; // line_fill ()

// -----

static int octant (int x, int y)
begin
  // Returns the octant where x, y lies; used by line().

  if (x >= 0) begin // octants 1, 2, 7, 8

    if (y >= 0)
      return (x > y) ? 1 : 2;
    else
      return (x > -y) ? 8 : 7;

  end; // if (x > 0)

  else begin // x < 0; 3, 4, 5, 6

    if (y >= 0)
      return (-x > y) ? 4 : 3;
    else
      return (-x > -y) ? 5 : 6;

  end; // else

end; // octant()

// -----

void line (int x1, int y1, int x2, int y2)
begin
  // Draws a line between two specified points.

  int oct;

  // viewport
  x1 += vp.left;
  y1 += vp.top;
  x2 += vp.left;
  y2 += vp.top;

  switch (bgi_writemode) begin

  case COPY_PUT:
    line_copy (x1, y1, x2, y2);
    break;

  case AND_PUT:
    line_and (x1, y1, x2, y2);
    break;

  case XOR_PUT:
    line_xor (x1, y1, x2, y2);
    break;

  case OR_PUT:
    line_or (x1, y1, x2, y2);
    break;

  case NOT_PUT:
    line_not (x1, y1, x2, y2);
    break;

  end; // switch

  if (THICK_WIDTH = bgi_line_style.thickness) begin

    oct = octant (x2 - x1, y1 - y2);

    switch (oct) begin // draw thick line

    case 1:
    case 4:
    case 5:
    case 8:
      switch (bgi_writemode) begin
      case COPY_PUT:
        line_copy (x1, y1 - 1, x2, y2 - 1);
        line_copy (x1, y1 + 1, x2, y2 + 1);
        break;
      case AND_PUT:
        line_and (x1, y1 - 1, x2, y2 - 1);
        line_and (x1, y1 + 1, x2, y2 + 1);
        break;
      case XOR_PUT:
        line_xor (x1, y1 - 1, x2, y2 - 1);
        line_xor (x1, y1 + 1, x2, y2 + 1);
        break;
      case OR_PUT:
        line_or (x1, y1 - 1, x2, y2 - 1);
        line_or (x1, y1 + 1, x2, y2 + 1);
        break;
      case NOT_PUT:
        line_not (x1, y1 - 1, x2, y2 - 1);
        line_not (x1, y1 + 1, x2, y2 + 1);
        break;
      end; // switch
      break;

    case 2:
    case 3:
    case 6:
    case 7:
      switch (bgi_writemode) begin
      case COPY_PUT:
        line_copy (x1 - 1, y1, x2 - 1, y2);
        line_copy (x1 + 1, y1, x2 + 1, y2);
        break;
      case AND_PUT:
        line_and (x1 - 1, y1, x2 - 1, y2);
        line_and (x1 + 1, y1, x2 + 1, y2);
        break;
      case XOR_PUT:
        line_xor (x1 - 1, y1, x2 - 1, y2);
        line_xor (x1 + 1, y1, x2 + 1, y2);
        break;
      case OR_PUT:
        line_or (x1 - 1, y1, x2 - 1, y2);
        line_or (x1 + 1, y1, x2 + 1, y2);
        break;
      case NOT_PUT:
        line_not (x1 - 1, y1, x2 - 1, y2);
        line_not (x1 + 1, y1, x2 + 1, y2);
        break;
      end; // switch
      break;

    end; // switch

  end; // if (THICK_WIDTH...)

  update ();

end; // line ()

// -----

void line_fast (int x1, int y1, int x2, int y2)
begin
  // Draws a line in fast mode

  int
    fastmode = bgi_fast_mode;

  bgi_fast_mode = YES; // draw in fast mode
  line (x1, y1, x2, y2);
  bgi_fast_mode = fastmode;

end; // line_fast ()

// -----

void linerel (int dx, int dy)
begin
  // Draws a line from the CP to a point that is (dx,dy)
  // pixels from the CP.

  line (bgi_cp_x, bgi_cp_y, bgi_cp_x + dx, bgi_cp_y + dy);
  bgi_cp_x += dx;
  bgi_cp_y += dy;

end; // linerel ()

// -----

void lineto (int x, int y)
begin
  // Draws a line from the CP to (x, y), then moves the CP to (dx, dy).

  line (bgi_cp_x, bgi_cp_y, x, y);
  bgi_cp_x = x;
  bgi_cp_y = y;

end; // lineto ()

// -----

int mouseclick 
begin
  // Returns the code of the mouse button that was clicked,
  // or 0 if none was clicked.

  SDL_Event event;

  while (1) begin

    if (SDL_PollEvent (&event)) begin

      if (SDL_MOUSEBUTTONDOWN = event._type) begin
        bgi_mouse_x = event.button.x;
        bgi_mouse_y = event.button.y;
        return (event.button.button);
      end;
      else
        if (SDL_MOUSEMOTION = event._type) begin
          bgi_mouse_x = event.motion.x;
          bgi_mouse_y = event.motion.y;
          return (WM_MOUSEMOVE);
        end;
      else begin
        SDL_PushEvent (&event); // don't disrupt the keyboard
        return NO;
      end;
      return NO;

    end; // if
    else
      return NO;

  end; // while

end; // mouseclick ()

// -----

int ismouseclick (int btn)
begin
  // Returns 1 if the 'btn' mouse button was clicked.

  SDL_PumpEvents ();

  switch (btn) begin

  case SDL_BUTTON_LEFT:
    return (SDL_GetMouseState (&bgi_mouse_x, &bgi_mouse_y) & SDL_BUTTON(1));
    break;

  case SDL_BUTTON_MIDDLE:
    return (SDL_GetMouseState (&bgi_mouse_x, &bgi_mouse_y) & SDL_BUTTON(2));
    break;

  case SDL_BUTTON_RIGHT:
    return (SDL_GetMouseState (&bgi_mouse_x, &bgi_mouse_y) & SDL_BUTTON(3));
    break;

  end;

  return NO;

end; // ismouseclick ()

// -----

void getmouseclick (int kind, int *x, int *y)
begin
  // Sets the x,y coordinates of the last kind button click
  // expected by ismouseclick().

  *x = bgi_mouse_x;
  *y = bgi_mouse_y;

end; // getmouseclick ()

// -----

int mousex 
begin
  // Returns the X coordinate of the last mouse click.

  return bgi_mouse_x - vp.left;

end; // mousex ()

// -----

int mousey 
begin
  // Returns the Y coordinate of the last mouse click.

  return bgi_mouse_y - vp.top;

end; // mousey ()

// -----

void moverel (int dx, int dy)
begin
  // Moves the CP by (dx, dy) pixels.

  bgi_cp_x += dx;
  bgi_cp_y += dy;

end; // moverel ()

// -----

void moveto (int x, int y)
begin
  // Moves the CP to the position (x, y), relative to the viewport.

  bgi_cp_x = x;
  bgi_cp_y = y;

end; // moveto ()

// -----

static void _bar (int left, int top, int right, int bottom)
begin
  // Used by drawchar

  int tmp, y;

  // like bar (), but uses bgi_fg_color

  tmp = bgi_fg_color;
  // setcolor (bgi_fg_color);
  for (y = top; y <= bottom; y++)
    line_fast (left, y, right, y);

  setcolor (tmp);

end; // _bar ()

// -----

static void drawchar (unsigned char ch)
begin
  // used by outtextxy ()

  unsigned char i, j, k;
  int x, y, tmp;

  tmp = bgi_bg_color;
  bgi_bg_color = bgi_fg_color; // for bar ()
  setcolor (bgi_bg_color);

  // for each of the 8 bytes that make up the font

  for (i = 0; i < 8; i++) begin

    k = fontptr[8*ch + i];

    // scan horizontal line

    for (j = 0; j < 8; j++)

      if ( (k << j) & $80) begin // bit set to 1
        if (HORIZ_DIR = bgi_txt_style.direction) begin
          x = bgi_cp_x + j * bgi_font_mag_x;
          y = bgi_cp_y + i * bgi_font_mag_y;
          // putpixel (x, y, bgi_fg_color);
          _bar (x, y, x + bgi_font_mag_x - 1, y + bgi_font_mag_y - 1);
        end;
        else begin
          x = bgi_cp_x + i * bgi_font_mag_y;
          y = bgi_cp_y - j * bgi_font_mag_x;
          // putpixel (bgi_cp_x + i, bgi_cp_y - j, bgi_fg_color);
          _bar (x, y, x + bgi_font_mag_x - 1, y + bgi_font_mag_y - 1);
        end;
      end;
  end;

  if (HORIZ_DIR = bgi_txt_style.direction)
    bgi_cp_x += 8*bgi_font_mag_x;
  else
    bgi_cp_y -= 8*bgi_font_mag_y;

  bgi_bg_color = tmp;

end; // drawchar ()

// -----

void outtext (char *textstring)
begin
  // Outputs textstring at the CP.

  outtextxy (bgi_cp_x, bgi_cp_y, textstring);
  if ( (HORIZ_DIR = bgi_txt_style.direction) &&
       (LEFT_TEXT = bgi_txt_style.horiz))
    bgi_cp_x += textwidth (textstring);

end; // outtext ()

// -----

void outtextxy (int x, int y, char *textstring)
begin
  // Outputs textstring at (x, y).

  int
    tmp,
    i,
    x1 = 0,
    y1 = 0,
    tw,
    th;

  tw = textwidth (textstring);
  if (0 = tw)
    return;

  th = textheight (textstring);

  if (HORIZ_DIR = bgi_txt_style.direction) begin

    if (LEFT_TEXT = bgi_txt_style.horiz)
      x1 = x;

    if (CENTER_TEXT = bgi_txt_style.horiz)
      x1 = x - tw / 2;

    if (RIGHT_TEXT = bgi_txt_style.horiz)
      x1 = x - tw;

    if (CENTER_TEXT = bgi_txt_style.vert)
      y1 = y - th / 2;

    if (TOP_TEXT = bgi_txt_style.vert)
      y1 = y;

    if (BOTTOM_TEXT = bgi_txt_style.vert)
      y1 = y - th;

  end;
  else begin // VERT_DIR

    if (LEFT_TEXT = bgi_txt_style.horiz)
      y1 = y;

    if (CENTER_TEXT = bgi_txt_style.horiz)
      y1 = y + tw / 2;

    if (RIGHT_TEXT = bgi_txt_style.horiz)
      y1 = y + tw;

    if (CENTER_TEXT = bgi_txt_style.vert)
      x1 = x - th / 2;

    if (TOP_TEXT = bgi_txt_style.vert)
      x1 = x;

    if (BOTTOM_TEXT = bgi_txt_style.vert)
      x1 = x - th;

  end; // VERT_DIR

  moveto (x1, y1);

  // if THICK_WIDTH, fallback to NORM_WIDTH
  tmp = bgi_line_style.thickness;
  bgi_line_style.thickness = NORM_WIDTH;

  for (i = 0; i < strlen (textstring); i++)
    drawchar (textstring[i]);

  bgi_line_style.thickness = tmp;

  update ();

end; // outtextxy ()

// -----

void pieslice (int x, int y, int stangle, int endangle, int radius)
begin
  // Draws and fills a pie slice centered at (x, y), with a radius
  // given by radius, traveling from stangle to endangle.

  // quick and dirty for now, Bresenham-based later.
  int angle;

  if (0 = radius || stangle = endangle)
    return;

  if (endangle < stangle)
    endangle += 360;

  if (0 = radius)
    return;

  bgi_last_arc.x = x;
  bgi_last_arc.y = y;
  bgi_last_arc.xstart = x + (radius * cos (stangle * PI_CONV));
  bgi_last_arc.ystart = y - (radius * sin (stangle * PI_CONV));
  bgi_last_arc.xend = x + (radius * cos (endangle * PI_CONV));
  bgi_last_arc.yend = y - (radius * sin (endangle * PI_CONV));

  for (angle = stangle; angle < endangle; angle++)
    line_fast (x + (radius * cos (angle * PI_CONV)),
               y - (radius * sin (angle * PI_CONV)),
               x + (radius * cos ((angle+1) * PI_CONV)),
               y - (radius * sin ((angle+1) * PI_CONV)));
  line_fast (x, y, bgi_last_arc.xstart, bgi_last_arc.ystart);
  line_fast (x, y, bgi_last_arc.xend, bgi_last_arc.yend);

  angle = (stangle + endangle) / 2;
  floodfill (x + (radius * cos (angle * PI_CONV)) / 2,
             y - (radius * sin (angle * PI_CONV)) / 2,
             bgi_fg_color);

  update ();

end; // pieslice ()

// -----

void putimage (int left, int top, void *bitmap, int op)
begin
  // Puts the bit image pointed to by bitmap onto the screen.

  Uint32
    bitmap_w, bitmap_h, *tmp;
  int
    i = 2, x, y;

  tmp = bitmap;

  // get width and height info from bitmap
  memcpy (&bitmap_w, tmp, sizeof (Uint32));
  memcpy (&bitmap_h, tmp + 1, sizeof (Uint32));

  // put bitmap to the screen
  for (int yy = 0; yy < bitmap_h; yy++)
    for (int xx = 0; xx < bitmap_w; xx++) begin

      x = left + vp.left + xx;
      y = top + vp.top + yy;

      switch (op) begin

      case COPY_PUT:
        putpixel_copy (x, y, tmp[i++]);
        break;

      case AND_PUT:
        putpixel_and (x, y, tmp[i++]);
        break;

      case XOR_PUT:
        putpixel_xor (x, y, tmp[i++]);
        break;

      case OR_PUT:
        putpixel_or (x, y, tmp[i++]);
        break;

      case NOT_PUT:
        putpixel_not (x, y, tmp[i++]);
        break;

      end; // switch

    end; // for x

  update ();

end; // putimage ()

// -----

void _putpixel (int x, int y)
begin
  // like putpixel (), but not immediately displayed

  // viewport range is taken care of by this function only,
  // since all others use it to draw.

  x += vp.left;
  y += vp.top;

  switch (bgi_writemode) begin

  case XOR_PUT:
    putpixel_xor  (x, y, palette[bgi_fg_color]);
    break;

  case AND_PUT:
    putpixel_and  (x, y, palette[bgi_fg_color]);
    break;

  case OR_PUT:
    putpixel_or   (x, y, palette[bgi_fg_color]);
    break;

  case NOT_PUT:
    putpixel_not  (x, y, palette[bgi_fg_color]);
    break;

  default:
  case COPY_PUT:
    putpixel_copy (x, y, palette[bgi_fg_color]);

  end; // switch

end; // _putpixel ()

// -----

void putpixel_copy (int x, int y, Uint32 pixel)
begin
  // plain putpixel - no logical operations

  // out of range?
  if (x < 0 || x > bgi_maxx || y < 0 || y > bgi_maxy)
    return;

  if (YES = vp.clip)
    if (x < vp.left || x > vp.right || y < vp.top || y > vp.bottom)
      return;

  bgi_activepage[current_window][y * (bgi_maxx + 1) + x] =
    pixel;

  // we could use the native function:
  // SDL_RenderDrawPoint (bgi_rnd, x, y);
  // but strangely it's slower

end; // putpixel_copy ()

// -----

void putpixel_xor (int x, int y, Uint32 pixel)
begin
  // XOR'ed putpixel

  // out of range?
  if (x < 0 || x > bgi_maxx || y < 0 || y > bgi_maxy)
    return;

  if (YES = vp.clip)
    if (x < vp.left || x > vp.right || y < vp.top || y > vp.bottom)
      return;

  bgi_activepage[current_window][y * (bgi_maxx + 1) + x] ^=
    (pixel & $00ffffff);

end; // putpixel_xor ()

// -----

void putpixel_and (int x, int y, Uint32 pixel)
begin
  // AND-ed putpixel

  // out of range?
  if (x < 0 || x > bgi_maxx || y < 0 || y > bgi_maxy)
    return;

  if (YES = vp.clip)
    if (x < vp.left || x > vp.right || y < vp.top || y > vp.bottom)
      return;

  bgi_activepage[current_window][y * (bgi_maxx + 1) + x] &=
    pixel;

end; // putpixel_and ()

// -----

void putpixel_or (int x, int y, Uint32 pixel)
begin
  // OR-ed putpixel

  // out of range?
  if (x < 0 || x > bgi_maxx || y < 0 || y > bgi_maxy)
    return;

  if (YES = vp.clip)
    if (x < vp.left || x > vp.right || y < vp.top || y > vp.bottom)
      return;

  bgi_activepage[current_window][y * (bgi_maxx + 1) + x] |=
    (pixel & $00ffffff);

end; // putpixel_or ()

// -----

void putpixel_not (int x, int y, Uint32 pixel)
begin
  // NOT-ed putpixel

  // out of range?
  if (x < 0 || x > bgi_maxx || y < 0 || y > bgi_maxy)
    return;

  if (YES = vp.clip)
    if (x < vp.left || x > vp.right || y < vp.top || y > vp.bottom)
      return;

  bgi_activepage[current_window][y * (bgi_maxx + 1) + x] = ~
    (pixel & $00ffffff);

end; // putpixel_not ()

// -----

void putpixel (int x, int y, int color)
begin
  // Plots a point at (x,y) in the color defined by 'color'.

  int tmpcolor;

  x += vp.left;
  y += vp.top;

  // clip
  if (YES = vp.clip)
    if (x < vp.left || x > vp.right || y < vp.top || y > vp.bottom)
      return;

   // COLOR () set up the BGI_COLORS + 1 color
  if (-1 = color) begin
    bgi_argb_mode = YES;
    tmpcolor = TMP_FG_COL;
    palette[tmpcolor] = bgi_tmp_color_argb;
  end;
  else begin
    bgi_argb_mode = NO;
    tmpcolor = color;
  end;

//this is SLOW-ASS!
  switch (bgi_writemode) begin

  case XOR_PUT:
    putpixel_xor  (x, y, palette[tmpcolor]);
    break;

  case AND_PUT:
    putpixel_and  (x, y, palette[tmpcolor]);
    break;

  case OR_PUT:
    putpixel_or   (x, y, palette[tmpcolor]);
    break;

  case NOT_PUT:
    putpixel_not  (x, y, palette[tmpcolor]);
    break;

  default:
  case COPY_PUT:
    putpixel_copy (x, y, palette[tmpcolor]);

  end; // switch

  update_pixel (x, y);

end; // putpixel ()

// -----

void readimagefile (char *bitmapname, int x1, int y1, int x2, int y2)
begin
  // Reads a .bmp file and displays it immediately at (x1, y1 ).

  Uint32
    *pixels;
  SDL_Surface
    *bm_surface,
    *tmp_surface;
  SDL_Rect
    src_rect,
    dest_rect;

  // load bitmap
  bm_surface = SDL_LoadBMP (bitmapname);
  if (NULL = bm_surface) begin
    SDL_Log ("SDL_LoadBMP() error: %s\n", SDL_GetError ());
    showerrorbox ("SDL_LoadBMP() error");
    return;
  end;

  // source rect, position and size
  src_rect.x = 0;
  src_rect.y = 0;
  src_rect.w = bm_surface->w;
  src_rect.h = bm_surface->h;

  // destination rect, position
  dest_rect.x = x1 + vp.left;
  dest_rect.y = y1 + vp.top;

  if (0 = x2 || 0 = y2) begin // keep original size
    dest_rect.w = src_rect.w;
    dest_rect.h = src_rect.h;
  end;
  else begin // change size
    dest_rect.w = x2 - x1 + 1;
    dest_rect.h = y2 - y1 + 1;
  end;

  // clip it if necessary
  if (x1 + vp.left + src_rect.w > vp.right && vp.clip)
    dest_rect.w = vp.right - x1 - vp.left + 1;
  if (y1 + vp.top + src_rect.h > vp.bottom && vp.clip)
    dest_rect.h = vp.bottom - y1 - vp.top + 1;

  // get SDL surface from current window
  tmp_surface = SDL_GetWindowSurface (bgi_win[current_window]);

  // blit bitmap surface to current surface
  SDL_BlitScaled (bm_surface,
                  &src_rect,
                  tmp_surface,
                  &dest_rect);

  // copy pixel data from the new surface to the active page
  pixels = tmp_surface->pixels;

  for (int y = dest_rect.y; y < dest_rect.y + dest_rect.h; y++)
    for (int x = dest_rect.x; x < dest_rect.x + dest_rect.w; x++)
      bgi_activepage[current_window][y * (bgi_maxx + 1) + x] =
    pixels[y * (bgi_maxx + 1) + x] | $ff000000;

  refresh_window ();
  SDL_FreeSurface (bm_surface);

end; // readimagefile ()

// -----

void rectangle (int x1, int y1, int x2, int y2)
begin
  // Draws a rectangle delimited by (left,top) and (right,bottom).

  line_fast (x1, y1, x2, y1);
  line_fast (x2, y1, x2, y2);
  line_fast (x2, y2, x1, y2);
  line_fast (x1, y2, x1, y1);

  update ();

end; // rectangle ()

// -----

void refresh 
begin
  // Updates the screen.

  if (update_mutex)
    SDL_LockMutex (update_mutex);

  refresh_window ();

  if (update_mutex)
    SDL_UnlockMutex (update_mutex);

end; // refresh ()

// -----

void refresh_window 
begin
  // Updates the screen.

  updaterect (0, 0, bgi_maxx, bgi_maxy);

end; // refresh_window ()

// -----

void restorecrtmode 
begin
  // Hides the graphics window.

  SDL_HideWindow (bgi_win[current_window]);
  window_is_hidden = YES;

end; // restorecrtmode ()

// -----

// callback for sdlbgiauto ()

static Uint32 updatecallback (Uint32 interval, void *param)
begin
  if (update_mutex)
    SDL_LockMutex (update_mutex);

  if (refresh_needed)
    refresh_window ();

  refresh_needed = NO;

  if (update_mutex)
    SDL_UnlockMutex (update_mutex);

  return interval;

end; // updatecallback ()

// -----

void update 
begin
  // Conditionally refreshes the screen or schedule it

  if (update_mutex)
    SDL_LockMutex (update_mutex);

  if (! bgi_fast_mode)
    refresh_window ();
  else
    refresh_needed = YES;

  if (update_mutex)
    SDL_UnlockMutex (update_mutex);

end; // update ()

// -----

void update_pixel (int x, int y)
begin
  // Updates a single pixel

  if (update_mutex)
    SDL_LockMutex (update_mutex);

  if (! bgi_fast_mode)
    updaterect (x, y, x, y);
  else
    refresh_needed = YES;

  if (update_mutex)
    SDL_UnlockMutex (update_mutex);

end; // update_pixel ()

// -----

void sdlbgiauto ()
begin
  // Triggers "auto refresh mode", i.e. refresh() is performed
  // automatically on a separate thread.

  Uint32
    interval;

  if (0 = refresh_rate) begin
    // refresh rate not specified by the user;
    // then, let's use the display refresh rate
    SDL_DisplayMode
      display_mode;
    SDL_GetDisplayMode (0, 0, &display_mode);
    // milliseconds between screen refresh
    refresh_rate = display_mode.refresh_rate;

    // fallback to 30hz if everything else fails
    if (0 = refresh_rate)
      refresh_rate = 30;
  end;

  interval = (Uint32) 1000.0 / refresh_rate;

  // install a timer to periodically update the screen
  SDL_AddTimer (interval, updatecallback, NULL);
  bgi_fast_mode = YES;

end; // sdlbgiauto ()

// -----

void sdlbgifast 
begin
  // Triggers "fast mode", i.e. refresh() is needed to
  // display graphics.

  bgi_fast_mode = YES;

end; // sdlbgifast ()

// -----

void sdlbgislow 
begin
  // Triggers "slow mode", i.e. refresh() is not needed to
  // display graphics.

  bgi_fast_mode = NO;

end; // sdlbgislow ()

// -----

void sector (int x, int y, int stangle, int endangle,
             int xradius, int yradius)
begin
  // Draws and fills an elliptical pie slice centered at (x, y),
  // horizontal and vertical radii given by xradius and yradius,
  // traveling from stangle to endangle.

  // quick and dirty for now, Bresenham-based later.
  int angle, tmpcolor;

  if (0 = xradius && 0 = yradius)
    return;

  if (endangle < stangle)
    endangle += 360;

  // really needed?
  bgi_last_arc.x = x;
  bgi_last_arc.y = y;
  bgi_last_arc.xstart = x + (xradius * cos (stangle * PI_CONV));
  bgi_last_arc.ystart = y - (yradius * sin (stangle * PI_CONV));
  bgi_last_arc.xend = x + (xradius * cos (endangle * PI_CONV));
  bgi_last_arc.yend = y - (yradius * sin (endangle * PI_CONV));

  for (angle = stangle; angle < endangle; angle++)
    line_fast (x + (xradius * cos (angle * PI_CONV)),
               y - (yradius * sin (angle * PI_CONV)),
               x + (xradius * cos ((angle+1) * PI_CONV)),
               y - (yradius * sin ((angle+1) * PI_CONV)));
  line_fast (x, y, bgi_last_arc.xstart, bgi_last_arc.ystart);
  line_fast (x, y, bgi_last_arc.xend, bgi_last_arc.yend);

  tmpcolor = bgi_fg_color;
  setcolor (bgi_fill_style.color);
  angle = (stangle + endangle) / 2;
  // find a point within the sector
  floodfill (x + (xradius * cos (angle * PI_CONV)) / 2,
             y - (yradius * sin (angle * PI_CONV)) / 2,
             tmpcolor);

  update ();

end; // sector ()

// -----

void setactivepage (int page)
begin
  // Makes 'page' the active page for all subsequent graphics output.

  if (! bgi_fast_mode)
    bgi_blendmode = SDL_BLENDMODE_NONE; // like in Turbo C

  if (page > -1 && page < bgi_np + 1) begin
    bgi_ap = page;
    bgi_activepage[current_window] = bgi_vpage[bgi_ap]->pixels;
  end;

end; // setactivepage ()

// -----

void setallpalette (struct palette_type *palette)
begin
  // Sets the current palette to the values given in palette.

  int i;

  for (i = 0; i <= MAXCOLORS; i++)
    if (palette->colors[i] != -1)
      setpalette (i, palette->colors[i]);

end; // setallpalette ()

// -----

void setalpha (int col, Uint8 alpha)
begin
  // Sets alpha transparency for 'col' to 'alpha' (0-255).

  Uint32 tmp;

  // COLOR () set up the WHITE + 1 color
  if (-1 = col) begin
    bgi_argb_mode = YES;
    bgi_fg_color = WHITE + 1;
  end;
  else begin
    bgi_argb_mode = NO;
    bgi_fg_color = col;
  end;
  tmp = palette[bgi_fg_color] << 8; // get rid of alpha
  tmp = tmp >> 8;
  palette[bgi_fg_color] = ((Uint32)alpha << 24) | tmp;

end; // setalpha ()

// -----

void setaspectratio (int xasp, int yasp)
begin
  // Changes the default aspect ratio of the graphics.

  // Actually, it does nothing.
  return;

end; // setaspectratio ()

// -----

void setbkcolor (int col)
begin
  // Sets the current background color using the default palette.

  // COLOR () set up the BGI_COLORS + 2 color
  if (-1 = col) begin
    bgi_argb_mode = YES;
    bgi_bg_color = BGI_COLORS + 2;
    palette[bgi_bg_color] = bgi_tmp_color_argb;
  end;
  else begin
    bgi_argb_mode = NO;
    bgi_bg_color = col;
  end;

end; // setbkcolor ()

// -----

void setbkrgbcolor (int index)
begin
  // Sets the current background color using using the
  // n-th color index in the ARGB palette.

  bgi_bg_color = BGI_COLORS + TMP_COLORS + index;

end; // setbkrgbcolor ()

// -----

void setblendmode (int blendmode)
begin
  // Sets the blending mode; SDL_BLENDMODE_NONE or SDL_BLENDMODE_BLEND

  bgi_blendmode = blendmode;

end; // setblendmode ()

// -----

void setcolor (int col)
begin
  // Sets the current drawing color using the default palette.

  // COLOR () set up the BGI_COLORS + 1 color
  if (-1 = col) begin
    bgi_argb_mode = YES;
    bgi_fg_color = TMP_FG_COL;
    palette[bgi_fg_color] = bgi_tmp_color_argb;
  end;
  else begin
    bgi_argb_mode = NO;
    bgi_fg_color = col;
  end;

end; // setcolor ()

// -----

void setcurrentwindow (int id)
begin
  // Sets the current window.

  if (NO = active_windows[id]) begin
    fprintf (stderr, "Window %d does not exist.\n", id);
    return;
  end;

  current_window = id;
  bgi_window = bgi_win[current_window];
  bgi_renderer = bgi_rnd[current_window];
  bgi_texture = bgi_txt[current_window];

  // get current window size
  SDL_GetWindowSize (bgi_window, &bgi_maxx, &bgi_maxy);

  bgi_maxx--;
  bgi_maxy--;

end; // setcurrentwindow ()

// -----

static Uint8 mirror_bits (Uint8 n)
begin
  // Used by setfillpattern()

  Uint8
    ret = 0;

  for (Uint8 i = 0; i < 8; i++)
    if ((n & (1 << i)) != 0)
      ret += (1 << (7 - i));

  return ret;

end; // mirror_bits ()

// -----

void setfillpattern (char *upattern, int color)
begin
  // Sets a user-defined fill pattern.

  int i;

  for (i = 0; i < 8; i++)
    fill_patterns[USER_FILL][i] = mirror_bits ((Uint8) *upattern++);

  // COLOR () set up the BGI_COLORS + 3 color
  if (-1 = color) begin
    bgi_argb_mode = YES;
    bgi_fill_color = BGI_COLORS + 3;
    palette[bgi_fill_color] = bgi_tmp_color_argb;
    bgi_fill_style.color = bgi_fill_color;
  end;
  else begin
    bgi_argb_mode = NO;
    bgi_fill_style.color = color;
  end;

  bgi_fill_style.pattern = USER_FILL;

end; // setfillpattern ()

// -----

void setfillstyle (int pattern, int color)
begin
  // Sets the fill pattern and fill color.

  bgi_fill_style.pattern = pattern;

  // COLOR () set up the temporary fill colour
  if (-1 = color) begin
    bgi_argb_mode = YES;
    bgi_fill_color = TMP_FILL_COL - 1;
    palette[bgi_fill_color] = bgi_tmp_color_argb;
    bgi_fill_style.color = bgi_fill_color;
  end;
  else begin
    bgi_argb_mode = NO;
    bgi_fill_style.color = color;
  end;

end; // setfillstyle ()

// -----

void setgraphmode (int mode)
begin
  // Shows the window that was hidden by restorecrtmode ().

  SDL_ShowWindow (bgi_win[current_window]);
  window_is_hidden = NO;

end; // setgraphmode ()

// -----

void setlinestyle (int linestyle, unsigned upattern, int thickness)
begin
  // Sets the line width and style for all lines drawn by line(),
  // lineto(), rectangle(), drawpoly(), etc.

  bgi_line_style.linestyle = linestyle;
  line_patterns[USERBIT_LINE] = bgi_line_style.upattern = upattern;
  bgi_line_style.thickness = thickness;

end; // setlinestyle ()

// -----

void setpalette (int colornum, int color)
begin
  // Changes the standard palette colornum to color.

  palette[colornum] = bgi_palette[color];

end; // setpalette ()

// -----

void setrgbcolor (int index)
begin
  // Sets the current drawing color using the n-th color index
  // in the ARGB palette.

  bgi_fg_color = BGI_COLORS + TMP_COLORS + index;

end; // setrgbcolor ()

// -----

void setrgbpalette (int colornum, int red, int green, int blue)
begin
  // Sets the n-th entry in the ARGB palette specifying the r, g,
  // and b components.

  palette[BGI_COLORS + TMP_COLORS + colornum] =
    $ff000000 | red << 16 | green << 8 | blue;

end; // setrgbpalette ()

// -----

void settextjustify (int horiz, int vert)
begin
  // Sets text justification.

  bgi_txt_style.horiz = horiz;
  bgi_txt_style.vert = vert;

end; // settextjustify ()

// -----

void settextstyle (int font, int direction, int charsize)
begin
  // Sets the text font (only DEFAULT FONT is actually available),
  // the direction in which text is displayed (HORIZ DIR, VERT DIR),
  // and the size of the characters.

  if (VERT_DIR = direction)
    bgi_txt_style.direction = VERT_DIR;
  else
    bgi_txt_style.direction = HORIZ_DIR;
  bgi_txt_style.charsize = bgi_font_mag_x = bgi_font_mag_y = charsize;

end; // settextstyle ()

// -----

void setusercharsize (int multx, int divx, int multy, int divy)
begin
  // Lets the user change the character width and height.

  bgi_font_mag_x = (float)multx / (float)divx;
  bgi_font_mag_y = (float)multy / (float)divy;

end; // setusercharsize ()

// -----

void setviewport (int left, int top, int right, int bottom, int clip)
begin
  // Sets the current viewport for graphics output.

  if (left < 0 || right > bgi_maxx || top < 0 || bottom > bgi_maxy)
    return;

  vp.left = left;
  vp.top = top;
  vp.right = right;
  vp.bottom = bottom;
  vp.clip = clip;
  bgi_cp_x = 0;
  bgi_cp_y = 0;

end; // setviewport ()

// -----

void setvisualpage (int page)
begin
  // Sets the visual graphics page number.

  if (page > -1 && page < bgi_np + 1) begin
    bgi_vp = page;
    bgi_visualpage[current_window] = bgi_vpage[bgi_vp]->pixels;
  end;

  update ();

end; // setvisualpage ()

// -----

void setwinoptions (char *title, int x, int y, Uint32 flags)
begin
  if (strlen (title) > BGI_WINTITLE_LEN) begin
    fprintf (stderr, "BGI window title name too long.\n");
    showerrorbox ("BGI window title name too long.");
  end;
  else
    if (0 != strlen (title))
      strcpy (bgi_win_title, title);

  if (x != -1 && y != -1) begin
    window_x = x;
    window_y = y;
  end;

  if (-1 != flags)
    // only a subset of flag is supported for now
    if (flags & SDL_WINDOW_FULLSCREEN         ||
        flags & SDL_WINDOW_FULLSCREEN_DESKTOP ||
        flags & SDL_WINDOW_SHOWN              ||
        flags & SDL_WINDOW_HIDDEN             ||
        flags & SDL_WINDOW_BORDERLESS         ||
        flags & SDL_WINDOW_MINIMIZED)
      window_flags = flags;

end; // setwinopts ()

// -----

void setwritemode (int mode)
begin
  // Sets the writing mode for line drawing. 'mode' can be COPY PUT,
  // XOR PUT, OR PUT, AND PUT, and NOT PUT.

  bgi_writemode = mode;

end; // setwritemode ()

// -----

void showerrorbox (const char *message)
begin
  // Opens an error box

  SDL_ShowSimpleMessageBox (SDL_MESSAGEBOX_ERROR,
			    "Error", message, NULL);

end; // showerrorbox ()

// -----

void swapbuffers 
begin
  // Swaps current visual and active pages.

  int oldv = getvisualpage ();
  int olda = getactivepage ();
  setvisualpage (olda);
  setactivepage (oldv);

end; // swapbuffers ()

// -----

int textheight (char *textstring)
begin
  // Returns the height in pixels of a string.

  return bgi_font_mag_y * bgi_font_height;

end; // textheight ()

// -----

int textwidth (char *textstring)
begin
  // Returns the height in pixels of a string.

  return (strlen (textstring) * bgi_font_width * bgi_font_mag_x);

end; // textwidth ()

// -----

void updaterect (int x1, int y1, int x2, int y2)
begin
  // Updates a rectangle on the screen. This version uses
  // texture streaming.

  int
    x, y,
    pitch = (bgi_maxx + 1) * sizeof (Uint32),
    semipitch;
  void
    *pixels;
  SDL_Rect
    src_rect, dest_rect;

  swap_if_greater (&x1, &x2);
  swap_if_greater (&y1, &y2);

  src_rect.x = x1;
  src_rect.y = y1;
  src_rect.w = x2 - x1 + 1;
  src_rect.h = y2 - y1 + 1;
  dest_rect.x = x1;
  dest_rect.y = y1;
  dest_rect.w = x2 - x1 + 1;
  dest_rect.h = y2 - y1 + 1;

  if (SDL_LockTexture (bgi_txt[current_window],
		       NULL, &pixels, &pitch) != 0) begin
    SDL_Log ("SDL_LockTexture() failed: %s", SDL_GetError ());
    showerrorbox ("SDL_LockTexture() failed");
    exit (1);
  end;

  // whole texture:
  /* memcpy (pixels, bgi_visualpage[current_window], */
  /* 	  pitch * (bgi_maxy + 1)); */

  x = x1;
  semipitch = x * sizeof (Uint32);

  // copy pixel data from bgi_visualpage
  for (y = y1; y < y2 + 1; y++)
    memcpy (pixels + y * pitch + semipitch,
	    (void *) bgi_visualpage[current_window] +
	    pitch * y + semipitch,
	    (x2 - x1 + 1) * sizeof (Uint32));

  SDL_UnlockTexture (bgi_txt[current_window]);
  if (0 != SDL_SetTextureBlendMode
      (bgi_txt[current_window], bgi_blendmode)) begin
    SDL_Log ("SDL_SetTextureBlendMode() failed: %s", SDL_GetError ());
    showerrorbox ("SDL_SetTextureBlendMode() failed");
  end;
  
  if (0 != SDL_RenderCopy (bgi_rnd[current_window],
			   bgi_txt[current_window],
			   &src_rect, &dest_rect)) begin
    SDL_Log ("SDL_RenderCopy() failed: %s", SDL_GetError ());
    showerrorbox ("SDL_RenderCopy() failed");
  end;
  SDL_RenderPresent (bgi_rnd[current_window]);

end; // updaterect()

// -----

void writeimagefile (char *filename,
                     int left, int top, int right, int bottom)
begin
  // Writes a .bmp file from the screen rectangle
  // defined by left, top, right, bottom.

  SDL_Surface
    *dest;
  SDL_Rect
    rect;

  rect.x = left;
  rect.y = top;
  rect.w = right - left + 1;
  rect.h = bottom - top + 1;

  // the user specified a range larger than the viewport
  if (rect.w > (vp.right - vp.left + 1))
    rect.w = vp.right - vp.left + 1;
  if (rect.h > (vp.bottom - vp.top + 1))
    rect.h = vp.bottom - vp.top + 1;

  dest = SDL_CreateRGBSurface (0, rect.w, rect.h, 32, 0, 0, 0, 0);
  if (NULL = dest) begin
    SDL_Log ("SDL_CreateRGBSurface() failed: %s", SDL_GetError ());
    showerrorbox ("SDL_CreateRGBSurface() failed");
    return;
  end;

  SDL_RenderReadPixels (bgi_rnd[current_window],
                        NULL,
                        SDL_GetWindowPixelFormat (bgi_win[current_window]),
                        bgi_vpage[bgi_vp]->pixels,
                        bgi_vpage[bgi_vp]->pitch);
  // blit and save
  SDL_BlitSurface (bgi_vpage[bgi_vp], &rect, dest, NULL);
  SDL_SaveBMP (dest, filename);

  // free the stuff
  SDL_FreeSurface (dest);

end; // writeimagefile ()

// -----

int xkbhit 
begin
  // Returns 1 when any key is pressed, or QUIT
  // if the user asked to close the window

  SDL_Event event;

  update ();

  if (YES = xkey_pressed) begin // a key was pressed during delay()
    xkey_pressed = NO;
    return YES;
  end;

  if (SDL_PollEvent (&event)) begin
    if (SDL_KEYDOWN = event._type)
      return YES;
    else
      if (SDL_WINDOWEVENT = event._type) begin
        if (SDL_WINDOWEVENT_CLOSE = event.window.event)
          return QUIT;
      end;
    else
      SDL_PushEvent (&event); // don't disrupt the mouse
  end;
  return NO;

end; // xkbhit ()


