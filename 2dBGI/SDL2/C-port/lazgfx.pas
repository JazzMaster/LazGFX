begin

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

// only DEFAULT_FONT (8x8) is implemented, Rest are TTF Loaded
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
  // all modes @ 320x200 
  SDL_320x200 = 1, SDL_CGALO = 1, CGA = 1, CGAC0 = 1, CGAC1 = 1,
  CGAC2 = 1, CGAC3 = 1, MCGAC0 = 1, MCGAC1 = 1, MCGAC2 = 1,
  MCGAC3 = 1, ATT400C0 = 1, ATT400C1 = 1, ATT400C2 = 1, ATT400C3 = 1,
  // all modes @ 640x200
  SDL_640x200 = 2, SDL_CGAHI = 2, CGAHI = 2, MCGAMED = 2,
  EGALO = 2, EGA64LO = 2,
  // all modes @ 640x350
  SDL_640x350 = 3, SDL_EGA = 3, EGA = 3, EGAHI = 3,
  EGA64HI = 3, EGAMONOHI = 3,
  // all modes @ 640x480
  SDL_640x480 = 4, SDL_VGA = 4, VGA = 4, MCGAHI = 4, VGAHI = 4,
  IBM8514LO = 4,
  // all modes @ 720x348
  SDL_720x348 = 5, SDL_HERC = 5,
  // all modes @ 720x350
  SDL_720x350 = 6, SDL_PC3270 = 6, HERCMONOHI = 6,
  // all modes @ 800x600
  SDL_800x600 = 7, SDL_SVGALO = 7, SVGA = 7,
  // all modes @ 1024x768
  SDL_1024x768 = 8, SDL_SVGAMED1 = 8,
  // all modes @ 1152x900
  SDL_1152x900 = 9, SDL_SVGAMED2 = 9,
  // all modes @ 1280x1024
  SDL_1280x1024 = 10, SDL_SVGAHI = 10,
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
X11_640x480  =   4;
X11_HERC     =   5;
X11_PC3270   =   6;
X11_SVGALO   =   7;
X11_800x600  =   7;
X11_SVGAMED1 =   8;
X11_1024x768 =   8;
X11_SVGAMED2 =   9;
X11_1152x900 =   9;
X11_SVGAHI    =  10;
X11_1280x1024 =  10;
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

int  ALPHA_VALUE (int);
int  BLUE_VALUE (int);
void closewindow (int);
int  COLOR (int, int, int);
int  event ;
int event_type ;
void freeimage (void *);
int  getcurrentwindow ;
int  getevent ;
void getmouseclick (int, int *, int *);
int  GREEN_VALUE (int);
void initwindow (int, int);
int  IS_BGI_COLOR (int color);
int  ismouseclick (int);
int  IS_RGB_COLOR (int color);
int  mouseclick ;
int  mousex ;
int  mousey ;
void _putpixel (int, int);
int  RED_VALUE (int );
void refresh ;
void sdlbgiauto ;
void sdlbgifast ;
void sdlbgislow ;
void setalpha (int, Uint8);
void setbkrgbcolor (int);
void setblendmode (int);
void setcurrentwindow (int);
void setrgbcolor (int);
void setrgbpalette (int, int, int, int);
void setwinoptions (char *, int, int, Uint32);
void showerrorbox (const char *);
void swapbuffers ;
int  xkbhit ;

implementation

SDL_Window   *bgi_window;
SDL_Renderer *bgi_renderer;
SDL_Texture  *bgi_texture;

//SDL v1: Mainsurface,Surface(x)

static SDL_Window   *bgi_win[NUM_BGI_WIN];
static SDL_Renderer *bgi_rnd[NUM_BGI_WIN];
static SDL_Texture  *bgi_txt[NUM_BGI_WIN];

static short int
  current_window = -1, // id of current window
  num_windows = 0;     // number of created windows

static int
  active_windows[NUM_BGI_WIN];

// explanation: up to NUM_BGI_WIN windows can be created and deleted
// as needed. 'active_windows[]' keeps track of created (1) and closed (0)
// windows; 'current_window' is the ID of the current (= being drawn on)
// window; 'num_windows' keeps track of the current number of windows

static SDL_Surface
  *bgi_vpage[VPAGES]; // array of visual pages; single window only

// Note: 'Uint32' and 'int' are the same on modern machines

// pixel data of active and visual pages

static Uint32
  *bgi_activepage[NUM_BGI_WIN], // active (= being drawn on) page;
                                // may be hidden
  *bgi_visualpage[NUM_BGI_WIN]; // visualised page

// This is how we draw stuff on the screen. Pixels pointed to by
// bgi_activepage (a pointer to pixel data in the active surface)
// are modified by functions like putpixel_copy(); bgi_texture is
// updated with the new bgi_activepage contents; bgi_texture is then
// copied to bgi_renderer, and finally bgi_renderer is made present.

// The palette contains the BGI colors, entries 0:MAXCOLORS;
// then three entries for temporary fg, bg, and fill ARGB colors
// allocated with COLOR(); then user-defined ARGB colors

#define BGI_COLORS  MAXCOLORS + 1
#define TMP_COLORS  3

static Uint32
  palette[BGI_COLORS + TMP_COLORS + PALETTE_SIZE]; // all colors

static Uint32
  bgi_palette[1 + MAXCOLORS] = begin // 0 - 15
    // ARGB
    0xff000000, // BLACK
    0xff0000ff, // BLUE
    0xff00ff00, // GREEN
    0xff00ffff, // CYAN
    0xffff0000, // RED
    0xffff00ff, // MAGENTA
    0xffa52a2a, // BROWN
    0xffd3d3d3, // LIGHTGRAY
    0xffa9a9a9, // DARKGRAY
    0xffadd8e6, // LIGHTBLUE
    0xff90ee90, // LIGHTGREEN
    0xffe0ffff, // LIGHTCYAN
    0xfff08080, // LIGHTRED
    0xffdb7093, // LIGHTMAGENTA
    0xffffff00, // YELLOW
    0xffffffff  // WHITE
  end;;

static Uint16
  line_patterns[1 + USERBIT_LINE] =
  begin0xffff,  // SOLID_LINE  = 1111111111111111
   0xcccc,  // DOTTED_LINE = 1100110011001100
   0xf1f8,  // CENTER_LINE = 1111000111111000
   0xf8f8,  // DASHED_LINE = 1111100011111000
   0xffffend;; // USERBIT_LINE

static Uint32
  bgi_tmp_color_argb,     // temporary color set up by COLOR()
  window_flags = 0;       // window flags

static int
  window_x =              // window initial position
    SDL_WINDOWPOS_CENTERED,
  window_y =
    SDL_WINDOWPOS_CENTERED,
  bgi_fg_color = WHITE,   // index of BGI foreground color
  bgi_bg_color = BLACK,   // index of BGI background color
  bgi_fill_color = WHITE, // index of BGI fill color
  bgi_mouse_x,            // coordinates of last mouse click
  bgi_mouse_y,
  bgi_font_width = 8,     // default font width and height
  bgi_font_height = 8,
  bgi_fast_mode = 1,      // needs screen update?
  bgi_last_event = 0,     // mouse click, keyboard event, or QUIT
  bgi_cp_x = 0,           // current position
  bgi_cp_y = 0,
  bgi_maxx,               // screen size
  bgi_maxy,
  bgi_gm,                 // graphics mode
  bgi_argb_mode = NO,   // BGI or ARGB colors
  bgi_writemode,          // plotting method (COPY_PUT, XOR_PUT...)
  bgi_blendmode =
    SDL_BLENDMODE_BLEND,  // blending mode
  bgi_ap,                 // active page number
  bgi_vp,                 // visual page number
  bgi_np = 0,             // # of actual pages
  refresh_needed = NO,  // update callback should be called
  refresh_rate = 0;       // window refresh rate

// mutex for update timer/thread
static SDL_mutex
  *update_mutex = NULL;

// BGI window title
char
  bgi_win_title[BGI_WINTITLE_LEN] = "SDL_bgi";

// booleans
static int
  window_is_hidden = NO,
  key_pressed = NO,
  xkey_pressed = NO;

static float
  bgi_font_mag_x = 1.0,  // font magnification
  bgi_font_mag_y = 1.0;

// pointer to font array. Should I add more (ugly) bitmap fonts?

// 8x8 font definition

/*  ZLIB (c) A. Schiffler 2012 */

#define GFX_FONTDATAMAX (8*256)

static unsigned char gfxPrimitivesFontdata[GFX_FONTDATAMAX] = begin

  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, // 0 0x00 '^@'
  0x7e,0x81,0xa5,0x81,0xbd,0x99,0x81,0x7e, // 1 0x01 '^A'
  0x7e,0xff,0xdb,0xff,0xc3,0xe7,0xff,0x7e, // 2 0x02 '^B'
  0x6c,0xfe,0xfe,0xfe,0x7c,0x38,0x10,0x00, // 3 0x03 '^C'
  0x10,0x38,0x7c,0xfe,0x7c,0x38,0x10,0x00, // 4 0x04 '^D'
  0x38,0x7c,0x38,0xfe,0xfe,0xd6,0x10,0x38, // 5 0x05 '^E'
  0x10,0x38,0x7c,0xfe,0xfe,0x7c,0x10,0x38, // 6 0x06 '^F'
  0x00,0x00,0x18,0x3c,0x3c,0x18,0x00,0x00, // 7 0x07 '^G'
  0xff,0xff,0xe7,0xc3,0xc3,0xe7,0xff,0xff, // 8 0x08 '^H'
  0x00,0x3c,0x66,0x42,0x42,0x66,0x3c,0x00, // 9 0x09 '^I'
  0xff,0xc3,0x99,0xbd,0xbd,0x99,0xc3,0xff, // 10 0x0a '^J'
  0x0f,0x07,0x0f,0x7d,0xcc,0xcc,0xcc,0x78, // 11 0x0b '^K'
  0x3c,0x66,0x66,0x66,0x3c,0x18,0x7e,0x18, // 12 0x0c '^L'
  0x3f,0x33,0x3f,0x30,0x30,0x70,0xf0,0xe0, // 13 0x0d '^M'
  0x7f,0x63,0x7f,0x63,0x63,0x67,0xe6,0xc0, // 14 0x0e '^N'
  0x18,0xdb,0x3c,0xe7,0xe7,0x3c,0xdb,0x18, // 15 0x0f '^O'
  0x80,0xe0,0xf8,0xfe,0xf8,0xe0,0x80,0x00, // 16 0x10 '^P'
  0x02,0x0e,0x3e,0xfe,0x3e,0x0e,0x02,0x00, // 17 0x11 '^Q'
  0x18,0x3c,0x7e,0x18,0x18,0x7e,0x3c,0x18, // 18 0x12 '^R'
  0x66,0x66,0x66,0x66,0x66,0x00,0x66,0x00, // 19 0x13 '^S'
  0x7f,0xdb,0xdb,0x7b,0x1b,0x1b,0x1b,0x00, // 20 0x14 '^T'
  0x3e,0x61,0x3c,0x66,0x66,0x3c,0x86,0x7c, // 21 0x15 '^U'
  0x00,0x00,0x00,0x00,0x7e,0x7e,0x7e,0x00, // 22 0x16 '^V'
  0x18,0x3c,0x7e,0x18,0x7e,0x3c,0x18,0xff, // 23 0x17 '^W'
  0x18,0x3c,0x7e,0x18,0x18,0x18,0x18,0x00, // 24 0x18 '^X'
  0x18,0x18,0x18,0x18,0x7e,0x3c,0x18,0x00, // 25 0x19 '^Y'
  0x00,0x18,0x0c,0xfe,0x0c,0x18,0x00,0x00, // 26 0x1a '^Z'
  0x00,0x30,0x60,0xfe,0x60,0x30,0x00,0x00, // 27 0x1b '^['
  0x00,0x00,0xc0,0xc0,0xc0,0xfe,0x00,0x00, // 28 0x1c '^\'
  0x00,0x24,0x66,0xff,0x66,0x24,0x00,0x00, // 29 0x1d '^]'
  0x00,0x18,0x3c,0x7e,0xff,0xff,0x00,0x00, // 30 0x1e '^^'
  0x00,0xff,0xff,0x7e,0x3c,0x18,0x00,0x00, // 31 0x1f '^_'
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, // 32 0x20 ' '
  0x18,0x3c,0x3c,0x18,0x18,0x00,0x18,0x00, // 33 0x21 '!'
  0x66,0x66,0x24,0x00,0x00,0x00,0x00,0x00, // 34 0x22 '"'
  0x6c,0x6c,0xfe,0x6c,0xfe,0x6c,0x6c,0x00, // 35 0x23 '#'
  0x18,0x3e,0x60,0x3c,0x06,0x7c,0x18,0x00, // 36 0x24 '$'
  0x00,0xc6,0xcc,0x18,0x30,0x66,0xc6,0x00, // 37 0x25 '%'
  0x38,0x6c,0x38,0x76,0xdc,0xcc,0x76,0x00, // 38 0x26 '&'
  0x18,0x18,0x30,0x00,0x00,0x00,0x00,0x00, // 39 0x27 '''
  0x0c,0x18,0x30,0x30,0x30,0x18,0x0c,0x00, // 40 0x28 '('
  0x30,0x18,0x0c,0x0c,0x0c,0x18,0x30,0x00, // 41 0x29 ')'
  0x00,0x66,0x3c,0xff,0x3c,0x66,0x00,0x00, // 42 0x2a '*'
  0x00,0x18,0x18,0x7e,0x18,0x18,0x00,0x00, // 43 0x2b '+'
  0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x30, // 44 0x2c ','
  0x00,0x00,0x00,0x7e,0x00,0x00,0x00,0x00, // 45 0x2d '-'
  0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x00, // 46 0x2e '.'
  0x06,0x0c,0x18,0x30,0x60,0xc0,0x80,0x00, // 47 0x2f '/'
  0x38,0x6c,0xc6,0xd6,0xc6,0x6c,0x38,0x00, // 48 0x30 '0'
  0x18,0x38,0x18,0x18,0x18,0x18,0x7e,0x00, // 49 0x31 '1'
  0x7c,0xc6,0x06,0x1c,0x30,0x66,0xfe,0x00, // 50 0x32 '2'
  0x7c,0xc6,0x06,0x3c,0x06,0xc6,0x7c,0x00, // 51 0x33 '3'
  0x1c,0x3c,0x6c,0xcc,0xfe,0x0c,0x1e,0x00, // 52 0x34 '4'
  0xfe,0xc0,0xc0,0xfc,0x06,0xc6,0x7c,0x00, // 53 0x35 '5'
  0x38,0x60,0xc0,0xfc,0xc6,0xc6,0x7c,0x00, // 54 0x36 '6'
  0xfe,0xc6,0x0c,0x18,0x30,0x30,0x30,0x00, // 55 0x37 '7'
  0x7c,0xc6,0xc6,0x7c,0xc6,0xc6,0x7c,0x00, // 56 0x38 '8'
  0x7c,0xc6,0xc6,0x7e,0x06,0x0c,0x78,0x00, // 57 0x39 '9'
  0x00,0x18,0x18,0x00,0x00,0x18,0x18,0x00, // 58 0x3a ':'
  0x00,0x18,0x18,0x00,0x00,0x18,0x18,0x30, // 59 0x3b ';'
  0x06,0x0c,0x18,0x30,0x18,0x0c,0x06,0x00, // 60 0x3c '<'
  0x00,0x00,0x7e,0x00,0x00,0x7e,0x00,0x00, // 61 0x3d '='
  0x60,0x30,0x18,0x0c,0x18,0x30,0x60,0x00, // 62 0x3e '>'
  0x7c,0xc6,0x0c,0x18,0x18,0x00,0x18,0x00, // 63 0x3f '?'
  0x7c,0xc6,0xde,0xde,0xde,0xc0,0x78,0x00, // 64 0x40 '@'
  0x38,0x6c,0xc6,0xfe,0xc6,0xc6,0xc6,0x00, // 65 0x41 'A'
  0xfc,0x66,0x66,0x7c,0x66,0x66,0xfc,0x00, // 66 0x42 'B'
  0x3c,0x66,0xc0,0xc0,0xc0,0x66,0x3c,0x00, // 67 0x43 'C'
  0xf8,0x6c,0x66,0x66,0x66,0x6c,0xf8,0x00, // 68 0x44 'D'
  0xfe,0x62,0x68,0x78,0x68,0x62,0xfe,0x00, // 69 0x45 'E'
  0xfe,0x62,0x68,0x78,0x68,0x60,0xf0,0x00, // 70 0x46 'F'
  0x3c,0x66,0xc0,0xc0,0xce,0x66,0x3a,0x00, // 71 0x47 'G'
  0xc6,0xc6,0xc6,0xfe,0xc6,0xc6,0xc6,0x00, // 72 0x48 'H'
  0x3c,0x18,0x18,0x18,0x18,0x18,0x3c,0x00, // 73 0x49 'I'
  0x1e,0x0c,0x0c,0x0c,0xcc,0xcc,0x78,0x00, // 74 0x4a 'J'
  0xe6,0x66,0x6c,0x78,0x6c,0x66,0xe6,0x00, // 75 0x4b 'K'
  0xf0,0x60,0x60,0x60,0x62,0x66,0xfe,0x00, // 76 0x4c 'L'
  0xc6,0xee,0xfe,0xfe,0xd6,0xc6,0xc6,0x00, // 77 0x4d 'M'
  0xc6,0xe6,0xf6,0xde,0xce,0xc6,0xc6,0x00, // 78 0x4e 'N'
  0x7c,0xc6,0xc6,0xc6,0xc6,0xc6,0x7c,0x00, // 79 0x4f 'O'
  0xfc,0x66,0x66,0x7c,0x60,0x60,0xf0,0x00, // 80 0x50 'P'
  0x7c,0xc6,0xc6,0xc6,0xc6,0xce,0x7c,0x0e, // 81 0x51 'Q'
  0xfc,0x66,0x66,0x7c,0x6c,0x66,0xe6,0x00, // 82 0x52 'R'
  0x3c,0x66,0x30,0x18,0x0c,0x66,0x3c,0x00, // 83 0x53 'S'
  0x7e,0x7e,0x5a,0x18,0x18,0x18,0x3c,0x00, // 84 0x54 'T'
  0xc6,0xc6,0xc6,0xc6,0xc6,0xc6,0x7c,0x00, // 85 0x55 'U'
  0xc6,0xc6,0xc6,0xc6,0xc6,0x6c,0x38,0x00, // 86 0x56 'V'
  0xc6,0xc6,0xc6,0xd6,0xd6,0xfe,0x6c,0x00, // 87 0x57 'W'
  0xc6,0xc6,0x6c,0x38,0x6c,0xc6,0xc6,0x00, // 88 0x58 'X'
  0x66,0x66,0x66,0x3c,0x18,0x18,0x3c,0x00, // 89 0x59 'Y'
  0xfe,0xc6,0x8c,0x18,0x32,0x66,0xfe,0x00, // 90 0x5a 'Z'
  0x3c,0x30,0x30,0x30,0x30,0x30,0x3c,0x00, // 91 0x5b '['
  0xc0,0x60,0x30,0x18,0x0c,0x06,0x02,0x00, // 92 0x5c '\'
  0x3c,0x0c,0x0c,0x0c,0x0c,0x0c,0x3c,0x00, // 93 0x5d ']'
  0x10,0x38,0x6c,0xc6,0x00,0x00,0x00,0x00, // 94 0x5e '^'
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff, // 95 0x5f '_'
  0x30,0x18,0x0c,0x00,0x00,0x00,0x00,0x00, // 96 0x60 '`'
  0x00,0x00,0x78,0x0c,0x7c,0xcc,0x76,0x00, // 97 0x61 'a'
  0xe0,0x60,0x7c,0x66,0x66,0x66,0xdc,0x00, // 98 0x62 'b'
  0x00,0x00,0x7c,0xc6,0xc0,0xc6,0x7c,0x00, // 99 0x63 'c'
  0x1c,0x0c,0x7c,0xcc,0xcc,0xcc,0x76,0x00, // 100 0x64 'd'
  0x00,0x00,0x7c,0xc6,0xfe,0xc0,0x7c,0x00, // 101 0x65 'e'
  0x3c,0x66,0x60,0xf8,0x60,0x60,0xf0,0x00, // 102 0x66 'f'
  0x00,0x00,0x76,0xcc,0xcc,0x7c,0x0c,0xf8, // 103 0x67 'g'
  0xe0,0x60,0x6c,0x76,0x66,0x66,0xe6,0x00, // 104 0x68 'h'
  0x18,0x00,0x38,0x18,0x18,0x18,0x3c,0x00, // 105 0x69 'i'
  0x06,0x00,0x06,0x06,0x06,0x66,0x66,0x3c, // 106 0x6a 'j'
  0xe0,0x60,0x66,0x6c,0x78,0x6c,0xe6,0x00, // 107 0x6b 'k'
  0x38,0x18,0x18,0x18,0x18,0x18,0x3c,0x00, // 108 0x6c 'l'
  0x00,0x00,0xec,0xfe,0xd6,0xd6,0xd6,0x00, // 109 0x6d 'm'
  0x00,0x00,0xdc,0x66,0x66,0x66,0x66,0x00, // 110 0x6e 'n'
  0x00,0x00,0x7c,0xc6,0xc6,0xc6,0x7c,0x00, // 111 0x6f 'o'
  0x00,0x00,0xdc,0x66,0x66,0x7c,0x60,0xf0, // 112 0x70 'p'
  0x00,0x00,0x76,0xcc,0xcc,0x7c,0x0c,0x1e, // 113 0x71 'q'
  0x00,0x00,0xdc,0x76,0x60,0x60,0xf0,0x00, // 114 0x72 'r'
  0x00,0x00,0x7e,0xc0,0x7c,0x06,0xfc,0x00, // 115 0x73 's'
  0x30,0x30,0xfc,0x30,0x30,0x36,0x1c,0x00, // 116 0x74 't'
  0x00,0x00,0xcc,0xcc,0xcc,0xcc,0x76,0x00, // 117 0x75 'u'
  0x00,0x00,0xc6,0xc6,0xc6,0x6c,0x38,0x00, // 118 0x76 'v'
  0x00,0x00,0xc6,0xd6,0xd6,0xfe,0x6c,0x00, // 119 0x77 'w'
  0x00,0x00,0xc6,0x6c,0x38,0x6c,0xc6,0x00, // 120 0x78 'x'
  0x00,0x00,0xc6,0xc6,0xc6,0x7e,0x06,0xfc, // 121 0x79 'y'
  0x00,0x00,0x7e,0x4c,0x18,0x32,0x7e,0x00, // 122 0x7a 'z'
  0x0e,0x18,0x18,0x70,0x18,0x18,0x0e,0x00, // 123 0x7b 'begin'
  0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x00, // 124 0x7c '|'
  0x70,0x18,0x18,0x0e,0x18,0x18,0x70,0x00, // 125 0x7d 'end;'
  0x76,0xdc,0x00,0x00,0x00,0x00,0x00,0x00, // 126 0x7e '~'
  0x00,0x10,0x38,0x6c,0xc6,0xc6,0xfe,0x00, // 127 0x7f ''
  0x7c,0xc6,0xc0,0xc0,0xc6,0x7c,0x0c,0x78, // 128 0x80 ''
  0xcc,0x00,0xcc,0xcc,0xcc,0xcc,0x76,0x00, // 129 0x81 ''
  0x0c,0x18,0x7c,0xc6,0xfe,0xc0,0x7c,0x00, // 130 0x82 ''
  0x7c,0x82,0x78,0x0c,0x7c,0xcc,0x76,0x00, // 131 0x83 ''
  0xc6,0x00,0x78,0x0c,0x7c,0xcc,0x76,0x00, // 132 0x84 ''
  0x30,0x18,0x78,0x0c,0x7c,0xcc,0x76,0x00, // 133 0x85 ''
  0x30,0x30,0x78,0x0c,0x7c,0xcc,0x76,0x00, // 134 0x86 ''
  0x00,0x00,0x7e,0xc0,0xc0,0x7e,0x0c,0x38, // 135 0x87 ''
  0x7c,0x82,0x7c,0xc6,0xfe,0xc0,0x7c,0x00, // 136 0x88 ''
  0xc6,0x00,0x7c,0xc6,0xfe,0xc0,0x7c,0x00, // 137 0x89 ''
  0x30,0x18,0x7c,0xc6,0xfe,0xc0,0x7c,0x00, // 138 0x8a ''
  0x66,0x00,0x38,0x18,0x18,0x18,0x3c,0x00, // 139 0x8b ''
  0x7c,0x82,0x38,0x18,0x18,0x18,0x3c,0x00, // 140 0x8c ''
  0x30,0x18,0x00,0x38,0x18,0x18,0x3c,0x00, // 141 0x8d ''
  0xc6,0x38,0x6c,0xc6,0xfe,0xc6,0xc6,0x00, // 142 0x8e ''
  0x38,0x6c,0x7c,0xc6,0xfe,0xc6,0xc6,0x00, // 143 0x8f ''
  0x18,0x30,0xfe,0xc0,0xf8,0xc0,0xfe,0x00, // 144 0x90 ''
  0x00,0x00,0x7e,0x18,0x7e,0xd8,0x7e,0x00, // 145 0x91 ''
  0x3e,0x6c,0xcc,0xfe,0xcc,0xcc,0xce,0x00, // 146 0x92 ''
  0x7c,0x82,0x7c,0xc6,0xc6,0xc6,0x7c,0x00, // 147 0x93 ''
  0xc6,0x00,0x7c,0xc6,0xc6,0xc6,0x7c,0x00, // 148 0x94 ''
  0x30,0x18,0x7c,0xc6,0xc6,0xc6,0x7c,0x00, // 149 0x95 ''
  0x78,0x84,0x00,0xcc,0xcc,0xcc,0x76,0x00, // 150 0x96 ''
  0x60,0x30,0xcc,0xcc,0xcc,0xcc,0x76,0x00, // 151 0x97 ''
  0xc6,0x00,0xc6,0xc6,0xc6,0x7e,0x06,0xfc, // 152 0x98 ''
  0xc6,0x38,0x6c,0xc6,0xc6,0x6c,0x38,0x00, // 153 0x99 ''
  0xc6,0x00,0xc6,0xc6,0xc6,0xc6,0x7c,0x00, // 154 0x9a ''
  0x18,0x18,0x7e,0xc0,0xc0,0x7e,0x18,0x18, // 155 0x9b ''
  0x38,0x6c,0x64,0xf0,0x60,0x66,0xfc,0x00, // 156 0x9c ''
  0x66,0x66,0x3c,0x7e,0x18,0x7e,0x18,0x18, // 157 0x9d ''
  0xf8,0xcc,0xcc,0xfa,0xc6,0xcf,0xc6,0xc7, // 158 0x9e ''
  0x0e,0x1b,0x18,0x3c,0x18,0xd8,0x70,0x00, // 159 0x9f ''
  0x18,0x30,0x78,0x0c,0x7c,0xcc,0x76,0x00, // 160 0xa0 ' '
  0x0c,0x18,0x00,0x38,0x18,0x18,0x3c,0x00, // 161 0xa1 '¡'
  0x0c,0x18,0x7c,0xc6,0xc6,0xc6,0x7c,0x00, // 162 0xa2 '¢'
  0x18,0x30,0xcc,0xcc,0xcc,0xcc,0x76,0x00, // 163 0xa3 '£'
  0x76,0xdc,0x00,0xdc,0x66,0x66,0x66,0x00, // 164 0xa4 '¤'
  0x76,0xdc,0x00,0xe6,0xf6,0xde,0xce,0x00, // 165 0xa5 '¥'
  0x3c,0x6c,0x6c,0x3e,0x00,0x7e,0x00,0x00, // 166 0xa6 '¦'
  0x38,0x6c,0x6c,0x38,0x00,0x7c,0x00,0x00, // 167 0xa7 '§'
  0x18,0x00,0x18,0x18,0x30,0x63,0x3e,0x00, // 168 0xa8 '¨'
  0x00,0x00,0x00,0xfe,0xc0,0xc0,0x00,0x00, // 169 0xa9 '©'
  0x00,0x00,0x00,0xfe,0x06,0x06,0x00,0x00, // 170 0xaa 'ª'
  0x63,0xe6,0x6c,0x7e,0x33,0x66,0xcc,0x0f, // 171 0xab '«'
  0x63,0xe6,0x6c,0x7a,0x36,0x6a,0xdf,0x06, // 172 0xac '¬'
  0x18,0x00,0x18,0x18,0x3c,0x3c,0x18,0x00, // 173 0xad '­'
  0x00,0x33,0x66,0xcc,0x66,0x33,0x00,0x00, // 174 0xae '®'
  0x00,0xcc,0x66,0x33,0x66,0xcc,0x00,0x00, // 175 0xaf '¯'
  0x22,0x88,0x22,0x88,0x22,0x88,0x22,0x88, // 176 0xb0 '°'
  0x55,0xaa,0x55,0xaa,0x55,0xaa,0x55,0xaa, // 177 0xb1 '±'
  0x77,0xdd,0x77,0xdd,0x77,0xdd,0x77,0xdd, // 178 0xb2 '²'
  0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18, // 179 0xb3 '³'
  0x18,0x18,0x18,0x18,0xf8,0x18,0x18,0x18, // 180 0xb4 '´'
  0x18,0x18,0xf8,0x18,0xf8,0x18,0x18,0x18, // 181 0xb5 'µ'
  0x36,0x36,0x36,0x36,0xf6,0x36,0x36,0x36, // 182 0xb6 '¶'
  0x00,0x00,0x00,0x00,0xfe,0x36,0x36,0x36, // 183 0xb7 '·'
  0x00,0x00,0xf8,0x18,0xf8,0x18,0x18,0x18, // 184 0xb8 '¸'
  0x36,0x36,0xf6,0x06,0xf6,0x36,0x36,0x36, // 185 0xb9 '¹'
  0x36,0x36,0x36,0x36,0x36,0x36,0x36,0x36, // 186 0xba 'º'
  0x00,0x00,0xfe,0x06,0xf6,0x36,0x36,0x36, // 187 0xbb '»'
  0x36,0x36,0xf6,0x06,0xfe,0x00,0x00,0x00, // 188 0xbc '¼'
  0x36,0x36,0x36,0x36,0xfe,0x00,0x00,0x00, // 189 0xbd '½'
  0x18,0x18,0xf8,0x18,0xf8,0x00,0x00,0x00, // 190 0xbe '¾'
  0x00,0x00,0x00,0x00,0xf8,0x18,0x18,0x18, // 191 0xbf '¿'
  0x18,0x18,0x18,0x18,0x1f,0x00,0x00,0x00, // 192 0xc0 'À'
  0x18,0x18,0x18,0x18,0xff,0x00,0x00,0x00, // 193 0xc1 'Á'
  0x00,0x00,0x00,0x00,0xff,0x18,0x18,0x18, // 194 0xc2 'Â'
  0x18,0x18,0x18,0x18,0x1f,0x18,0x18,0x18, // 195 0xc3 'Ã'
  0x00,0x00,0x00,0x00,0xff,0x00,0x00,0x00, // 196 0xc4 'Ä'
  0x18,0x18,0x18,0x18,0xff,0x18,0x18,0x18, // 197 0xc5 'Å'
  0x18,0x18,0x1f,0x18,0x1f,0x18,0x18,0x18, // 198 0xc6 'Æ'
  0x36,0x36,0x36,0x36,0x37,0x36,0x36,0x36, // 199 0xc7 'Ç'
  0x36,0x36,0x37,0x30,0x3f,0x00,0x00,0x00, // 200 0xc8 'È'
  0x00,0x00,0x3f,0x30,0x37,0x36,0x36,0x36, // 201 0xc9 'É'
  0x36,0x36,0xf7,0x00,0xff,0x00,0x00,0x00, // 202 0xca 'Ê'
  0x00,0x00,0xff,0x00,0xf7,0x36,0x36,0x36, // 203 0xcb 'Ë'
  0x36,0x36,0x37,0x30,0x37,0x36,0x36,0x36, // 204 0xcc 'Ì'
  0x00,0x00,0xff,0x00,0xff,0x00,0x00,0x00, // 205 0xcd 'Í'
  0x36,0x36,0xf7,0x00,0xf7,0x36,0x36,0x36, // 206 0xce 'Î'
  0x18,0x18,0xff,0x00,0xff,0x00,0x00,0x00, // 207 0xcf 'Ï'
  0x36,0x36,0x36,0x36,0xff,0x00,0x00,0x00, // 208 0xd0 'Ð'
  0x00,0x00,0xff,0x00,0xff,0x18,0x18,0x18, // 209 0xd1 'Ñ'
  0x00,0x00,0x00,0x00,0xff,0x36,0x36,0x36, // 210 0xd2 'Ò'
  0x36,0x36,0x36,0x36,0x3f,0x00,0x00,0x00, // 211 0xd3 'Ó'
  0x18,0x18,0x1f,0x18,0x1f,0x00,0x00,0x00, // 212 0xd4 'Ô'
  0x00,0x00,0x1f,0x18,0x1f,0x18,0x18,0x18, // 213 0xd5 'Õ'
  0x00,0x00,0x00,0x00,0x3f,0x36,0x36,0x36, // 214 0xd6 'Ö'
  0x36,0x36,0x36,0x36,0xff,0x36,0x36,0x36, // 215 0xd7 '×'
  0x18,0x18,0xff,0x18,0xff,0x18,0x18,0x18, // 216 0xd8 'Ø'
  0x18,0x18,0x18,0x18,0xf8,0x00,0x00,0x00, // 217 0xd9 'Ù'
  0x00,0x00,0x00,0x00,0x1f,0x18,0x18,0x18, // 218 0xda 'Ú'
  0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff, // 219 0xdb 'Û'
  0x00,0x00,0x00,0x00,0xff,0xff,0xff,0xff, // 220 0xdc 'Ü'
  0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0, // 221 0xdd 'Ý'
  0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f, // 222 0xde 'Þ'
  0xff,0xff,0xff,0xff,0x00,0x00,0x00,0x00, // 223 0xdf 'ß'
  0x00,0x00,0x76,0xdc,0xc8,0xdc,0x76,0x00, // 224 0xe0 'à'
  0x78,0xcc,0xcc,0xd8,0xcc,0xc6,0xcc,0x00, // 225 0xe1 'á'
  0xfe,0xc6,0xc0,0xc0,0xc0,0xc0,0xc0,0x00, // 226 0xe2 'â'
  0x00,0x00,0xfe,0x6c,0x6c,0x6c,0x6c,0x00, // 227 0xe3 'ã'
  0xfe,0xc6,0x60,0x30,0x60,0xc6,0xfe,0x00, // 228 0xe4 'ä'
  0x00,0x00,0x7e,0xd8,0xd8,0xd8,0x70,0x00, // 229 0xe5 'å'
  0x00,0x00,0x66,0x66,0x66,0x66,0x7c,0xc0, // 230 0xe6 'æ'
  0x00,0x76,0xdc,0x18,0x18,0x18,0x18,0x00, // 231 0xe7 'ç'
  0x7e,0x18,0x3c,0x66,0x66,0x3c,0x18,0x7e, // 232 0xe8 'è'
  0x38,0x6c,0xc6,0xfe,0xc6,0x6c,0x38,0x00, // 233 0xe9 'é'
  0x38,0x6c,0xc6,0xc6,0x6c,0x6c,0xee,0x00, // 234 0xea 'ê'
  0x0e,0x18,0x0c,0x3e,0x66,0x66,0x3c,0x00, // 235 0xeb 'ë'
  0x00,0x00,0x7e,0xdb,0xdb,0x7e,0x00,0x00, // 236 0xec 'ì'
  0x06,0x0c,0x7e,0xdb,0xdb,0x7e,0x60,0xc0, // 237 0xed 'í'
  0x1e,0x30,0x60,0x7e,0x60,0x30,0x1e,0x00, // 238 0xee 'î'
  0x00,0x7c,0xc6,0xc6,0xc6,0xc6,0xc6,0x00, // 239 0xef 'ï'
  0x00,0xfe,0x00,0xfe,0x00,0xfe,0x00,0x00, // 240 0xf0 'ð'
  0x18,0x18,0x7e,0x18,0x18,0x00,0x7e,0x00, // 241 0xf1 'ñ'
  0x30,0x18,0x0c,0x18,0x30,0x00,0x7e,0x00, // 242 0xf2 'ò'
  0x0c,0x18,0x30,0x18,0x0c,0x00,0x7e,0x00, // 243 0xf3 'ó'
  0x0e,0x1b,0x1b,0x18,0x18,0x18,0x18,0x18, // 244 0xf4 'ô'
  0x18,0x18,0x18,0x18,0x18,0xd8,0xd8,0x70, // 245 0xf5 'õ'
  0x00,0x18,0x00,0x7e,0x00,0x18,0x00,0x00, // 246 0xf6 'ö'
  0x00,0x76,0xdc,0x00,0x76,0xdc,0x00,0x00, // 247 0xf7 '÷'
  0x38,0x6c,0x6c,0x38,0x00,0x00,0x00,0x00, // 248 0xf8 'ø'
  0x00,0x00,0x00,0x18,0x18,0x00,0x00,0x00, // 249 0xf9 'ù'
  0x00,0x00,0x00,0x18,0x00,0x00,0x00,0x00, // 250 0xfa 'ú'
  0x0f,0x0c,0x0c,0x0c,0xec,0x6c,0x3c,0x1c, // 251 0xfb 'û'
  0x6c,0x36,0x36,0x36,0x36,0x00,0x00,0x00, // 252 0xfc 'ü'
  0x78,0x0c,0x18,0x30,0x7c,0x00,0x00,0x00, // 253 0xfd 'ý'
  0x00,0x00,0x3c,0x3c,0x3c,0x3c,0x00,0x00, // 254 0xfe 'þ'
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, // 255 0xff ' '

end;;

static const Uint8 *fontptr = gfxPrimitivesFontdata;

static struct arccoords_type bgi_last_arc;
static struct fillsettings_type bgi_fill_style;
static struct linesettings_type bgi_line_style;
static struct textsettings_type bgi_txt_style;
static struct viewport_type vp;
static struct palette_type pal;

// utility functions

static void initpalette      ;
static void putpixel_copy    (int, int, Uint32);
static void putpixel_xor     (int, int, Uint32);
static void putpixel_and     (int, int, Uint32);
static void putpixel_or      (int, int, Uint32);
static void putpixel_not     (int, int, Uint32);
static void ff_putpixel      (int x, int);
static Uint32 getpixel_raw   (int, int);

static void line_copy        (int, int, int, int);
static void line_xor         (int, int, int, int);
static void line_and         (int, int, int, int);
static void line_or          (int, int, int, int);
static void line_not         (int, int, int, int);
static void line_fill        (int, int, int, int);
static void _floodfill       (int, int, int);

static void line_fast        (int, int, int, int);
static void updaterect       (int, int, int, int);
static void update	     ;
static void update_pixel     (int, int);

static void unimplemented    (char *);
static int  is_in_range      (int, int, int);
static void swap_if_greater  (int *, int *);
static void circle_bresenham (int, int, int);
static int  octant           (int, int);
static void refresh_window   ;

// -----

// unimplemented stuff

static void unimplemented (char *msg)
begin
  fprintf (stderr, "%s() is not yet implemented.\n", msg);
end;

// -----

void _graphfreemem (void *ptr, unsigned int size)
begin

  unimplemented ("_graphfreemem");

end; // _graphfreemem ()

// -----

void _graphgetmem (unsigned int size)
begin

  unimplemented ("_graphgetmem");

end; // _graphgetmem ()

// -----

int installuserdriver (char *name, int (*detect))
begin

  unimplemented ("installuserdriver");
  return 0;

end; // installuserdriver ()

// -----

int installuserfont (char *name)
begin

  unimplemented ("installuserfont");
  return 0;

end; // installuserfont ()

// -----

int registerbgidriver (void (*driver))
begin

  unimplemented ("registerbgidriver");
  return 0;

end; // registerbgidriver ()

// -----

int registerbgifont (void (*font))
begin

  unimplemented ("registerbgifont");
  return 0;

end; // registerbgifont ()

// -----

unsigned int setgraphbufsize (unsigned bufsize)
begin

  unimplemented ("setgraphbufsize");
  return 0;

end; // setgraphbufsize ()

// -----

// ----- implemented stuff starts here -----

#define PI_CONV (3.1415926 / 180.0)

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

  return ((palette[BGI_COLORS + TMP_COLORS + color] >> 24) & 0xFF);

end; // ALPHA_VALUE ()

// -----

int RED_VALUE (int color)
begin
  // Returns the red component of 'color' in the extended palette

  return ((palette[BGI_COLORS + TMP_COLORS + color] >> 16) & 0xFF);

end; // RED_VALUE ()

// -----

int GREEN_VALUE (int color)
begin
  // Returns the green component of 'color' in the extended palette

  return ((palette[BGI_COLORS + TMP_COLORS + color] >> 8) & 0xFF);

end; // GREEN_VALUE ()

// -----

int BLUE_VALUE (int color)
begin
  // Returns the blue component 'color' in the extended palette

  return (palette[BGI_COLORS + TMP_COLORS + color] & 0xFF);

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
  bgi_tmp_color_argb = 0xff000000 | r << 16 | g << 8 | b;
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
  begin0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00end;, // EMPTY_FILL
  begin0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xffend;, // SOLID_FILL
  begin0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00end;, // LINE_FILL
  begin0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80end;, // LTSLASH_FILL
  begin0x03, 0x06, 0x0c, 0x18, 0x30, 0x60, 0xc0, 0x81end;, // SLASH_FILL
  begin0xc0, 0x60, 0x30, 0x18, 0x0c, 0x06, 0x03, 0x81end;, // BKSLASH_FILL
  begin0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01end;, // LTBKSLASH_FILL
  begin0x22, 0x22, 0xff, 0x22, 0x22, 0x22, 0xff, 0x22end;, // HATCH_FILL
  begin0x81, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42, 0x81end;, // XHATCH_FILL
  begin0x11, 0x44, 0x11, 0x44, 0x11, 0x44, 0x11, 0x44end;, // INTERLEAVE_FILL
  begin0x10, 0x00, 0x01, 0x00, 0x10, 0x00, 0x01, 0x00end;, // WIDE_DOT_FILL
  begin0x11, 0x00, 0x44, 0x00, 0x11, 0x00, 0x44, 0x00end;, // CLOSE_DOT_FILL
  begin0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xffend;  // USER_FILL
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

  case SDL_1280x1024:
    return "SDL_1280x1024";
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
  case SDL_800x600:
    return "SDL_800x600";
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

  // if it's not a BGI color, just return the 0xAARRGGBB value
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
    bgi_gm = SDL_800x600; // default

  switch (bgi_gm) begin

  case SDL_320x200:
    initwindow (320, 200);
    break;

  case SDL_640x200:
    initwindow (640, 200);
    break;

  case SDL_640x350:
    initwindow (640, 350);
    break;

  case SDL_640x480:
    initwindow (640, 480);
    break;

  case SDL_720x348:
    initwindow (720, 348);
    break;

  case SDL_720x350:
    initwindow (720, 350);
    break;

  case SDL_1024x768:
    initwindow (1024, 768);
    break;

  case SDL_1152x900:
    initwindow (1152, 900);
    break;

  case SDL_1280x1024:
    initwindow (1280, 1024);
    break;

  case SDL_1366x768:
    initwindow (1366, 768);
    break;

  case SDL_FULLSCREEN:
    initwindow (0, 0);
    break;

  default:
  case SDL_800x600:
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

      if ( (k << j) & 0x80) begin // bit set to 1
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
    (pixel & 0x00ffffff);

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
    (pixel & 0x00ffffff);

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
    (pixel & 0x00ffffff);

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
    pixels[y * (bgi_maxx + 1) + x] | 0xff000000;

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
    0xff000000 | red << 16 | green << 8 | blue;

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


