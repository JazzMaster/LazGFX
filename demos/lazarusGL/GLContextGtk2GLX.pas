unit GLContextGtk2GLX;

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
  SysUtils, Controls, GLContext, LCLType, XUtil, XLib, gdk2x, gtk2, gdk2, dglOpenGL,
  LMessages, GLContextGtkCustomVisual;

type

                             
  EGLXError = class(EGLError);

  { TRenderControl }

  TRenderControl = class(TCustomVisualControl)
  private
    fTarget: TWinControl;
  protected
    procedure WndProc(var Message: TLMessage); override;
  public
    property Target: TWinControl read fTarget write fTarget;
  end;

  { TGLContextGtk2GLX }

  TGLContextGtk2GLX = class(TGLContext)
  private
    FDisplay: PDisplay;
    FWidget: PGtkWidget;
    FContext: GLXContext;
    FRenderControl: TRenderControl;
  protected
    procedure CloseContext; override;
    procedure OpenContext(pf: TglcContextPixelFormatSettings); override;
  public
    procedure Activate; override;
    procedure Deactivate; override;
    function IsActive: boolean; override;
    procedure SwapBuffers; override;
    procedure SetSwapInterval(const aInterval: GLint); override;
    procedure Share(const aContext: TGLContext); override;

    class function ChangeDisplaySettings(const aWidth, aHeight,
      aBitPerPixel, aFreq: Integer; const aFlags: TglcDisplayFlags): Boolean; override;
    class function IsAnyContextActive: boolean; override;
  end;



implementation


type
  TGLIntArray = packed array of GLInt;

{$region messages -fold}
procedure TRenderControl.WndProc(var Message: TLMessage);
var
  handled: Boolean;
begin
  handled := false;
  case Message.msg of
    LM_ACTIVATEITEM,
    LM_CHANGED,
    LM_FOCUS,
    LM_CLICKED,
    LM_RELEASED,
    LM_ENTER,
    LM_LEAVE,
    LM_CHECKRESIZE,
    LM_SETEDITABLE,
    LM_MOVEWORD,
    LM_MOVEPAGE,
    LM_MOVETOROW,
    LM_MOVETOCOLUMN,
    LM_KILLCHAR,
    LM_KILLWORD,
    LM_KILLLINE,
    LM_CLOSEQUERY,
    LM_DRAGSTART,
    LM_MONTHCHANGED,
    LM_YEARCHANGED,
    LM_DAYCHANGED,
    LM_LBUTTONTRIPLECLK,
    LM_LBUTTONQUADCLK,
    LM_MBUTTONTRIPLECLK,
    LM_MBUTTONQUADCLK,
    LM_RBUTTONTRIPLECLK,
    LM_RBUTTONQUADCLK,
    LM_MOUSEENTER,
    LM_MOUSELEAVE,
    LM_XBUTTONTRIPLECLK,
    LM_XBUTTONQUADCLK,

    SC_SIZE,
    SC_MOVE,
    SC_MINIMIZE,
    SC_MAXIMIZE,
    SC_NEXTWINDOW,
    SC_PREVWINDOW,
    SC_CLOSE,
    SC_VSCROLL,
    SC_HSCROLL,
    SC_MOUSEMENU,
    SC_KEYMENU,
    SC_ARRANGE,
    SC_RESTORE,
    SC_TASKLIST,
    SC_SCREENSAVE,
    SC_HOTKEY,
    SC_DEFAULT,
    SC_MONITORPOWER,
    SC_CONTEXTHELP,
    SC_SEPARATOR,

    LM_MOVE,
    LM_SIZE,
    LM_ACTIVATE,
    LM_SETFOCUS,
    LM_KILLFOCUS,
    LM_ENABLE,
    LM_GETTEXTLENGTH,
    LM_SHOWWINDOW,
    LM_CANCELMODE,
    LM_DRAWITEM,
    LM_MEASUREITEM,
    LM_DELETEITEM,
    LM_VKEYTOITEM,
    LM_CHARTOITEM,
    LM_COMPAREITEM,
    LM_WINDOWPOSCHANGING,
    LM_WINDOWPOSCHANGED,
    LM_NOTIFY,
    LM_HELP,
    LM_NOTIFYFORMAT,
    LM_CONTEXTMENU,
    LM_NCCALCSIZE,
    LM_NCHITTEST,
    LM_NCPAINT,
    LM_NCACTIVATE,
    LM_GETDLGCODE,
    LM_NCMOUSEMOVE,
    LM_NCLBUTTONDOWN,
    LM_NCLBUTTONUP,
    LM_NCLBUTTONDBLCLK,
    LM_KEYDOWN,
    LM_KEYUP,
    LM_CHAR,
    LM_SYSKEYDOWN,
    LM_SYSKEYUP,
    LM_SYSCHAR,
    LM_COMMAND,
    LM_SYSCOMMAND,
    LM_TIMER,
    LM_HSCROLL,
    LM_VSCROLL,
    LM_CTLCOLORMSGBOX,
    LM_CTLCOLOREDIT,
    LM_CTLCOLORLISTBOX,
    LM_CTLCOLORBTN,
    LM_CTLCOLORDLG,
    LM_CTLCOLORSCROLLBAR,
    LM_CTLCOLORSTATIC,
    LM_MOUSEMOVE,
    LM_LBUTTONDOWN,
    LM_LBUTTONUP,
    LM_LBUTTONDBLCLK,
    LM_RBUTTONDOWN,
    LM_RBUTTONUP,
    LM_RBUTTONDBLCLK,
    LM_MBUTTONDOWN,
    LM_MBUTTONUP,
    LM_MBUTTONDBLCLK,
    LM_MOUSEWHEEL,
    LM_XBUTTONDOWN,
    LM_XBUTTONUP,
    LM_XBUTTONDBLCLK,
    LM_PARENTNOTIFY,
    LM_CAPTURECHANGED,
    LM_DROPFILES,
    LM_SELCHANGE,
    LM_CUT,
    LM_COPY,
    LM_PASTE,
    LM_CLEAR,

    CM_ACTIVATE,
    CM_DEACTIVATE,
    CM_FOCUSCHANGED,
    CM_PARENTFONTCHANGED,
    CM_PARENTCOLORCHANGED,
    CM_HITTEST,
    CM_VISIBLECHANGED,
    CM_ENABLEDCHANGED,
    CM_COLORCHANGED,
    CM_FONTCHANGED,
    CM_CURSORCHANGED,
    CM_TEXTCHANGED,
    CM_MOUSEENTER,
    CM_MOUSELEAVE,
    CM_MENUCHANGED,
    CM_APPSYSCOMMAND,
    CM_BUTTONPRESSED,
    CM_SHOWINGCHANGED,
    CM_ENTER,
    CM_EXIT,
    CM_DESIGNHITTEST,
    CM_ICONCHANGED,
    CM_WANTSPECIALKEY,
    CM_RELEASE,
    CM_FONTCHANGE,
    CM_TABSTOPCHANGED,
    CM_UIACTIVATE,
    CM_CONTROLLISTCHANGE,
    CM_GETDATALINK,
    CM_CHILDKEY,
    CM_HINTSHOW,
    CM_SYSFONTCHANGED,
    CM_CONTROLCHANGE,
    CM_CHANGED,
    CM_BORDERCHANGED,
    CM_BIDIMODECHANGED,
    CM_PARENTBIDIMODECHANGED,
    CM_ALLCHILDRENFLIPPED,
    CM_ACTIONUPDATE,
    CM_ACTIONEXECUTE,
    CM_HINTSHOWPAUSE,
    CM_DOCKNOTIFICATION,
    CM_MOUSEWHEEL,
    CM_APPSHOWBTNGLYPHCHANGED,
    CM_APPSHOWMENUGLYPHCHANGED,

    CN_BASE,
    CN_CHARTOITEM,
    CN_COMMAND,
    CN_COMPAREITEM,
    CN_CTLCOLORBTN,
    CN_CTLCOLORDLG,
    CN_CTLCOLOREDIT,
    CN_CTLCOLORLISTBOX,
    CN_CTLCOLORMSGBOX,
    CN_CTLCOLORSCROLLBAR,
    CN_CTLCOLORSTATIC,
    CN_DELETEITEM,
    CN_DRAWITEM,
    CN_HSCROLL,
    CN_MEASUREITEM,
    CN_PARENTNOTIFY,
    CN_VKEYTOITEM,
    CN_VSCROLL,
    CN_KEYDOWN,
    CN_KEYUP,
    CN_CHAR,
    CN_SYSKEYUP,
    CN_SYSKEYDOWN,
    CN_SYSCHAR,
    CN_NOTIFY:
    begin
      if Assigned(fTarget) then begin
        Message.Result := fTarget.Perform(Message.msg, Message.wParam, Message.lParam);
        handled := true;
      end;
    end;

    LM_CONFIGUREEVENT,
    LM_EXIT,
    LM_QUIT,
    LM_NULL,
    LM_PAINT,
    LM_ERASEBKGND,
    LM_SETCURSOR,
    LM_SETFONT:
    begin
      inherited WndProc(Message);
      if Assigned(fTarget) then
        Message.Result := fTarget.Perform(Message.msg, Message.wParam, Message.lParam);
      handled := true;
    end;
  end;
  if not handled then
    inherited WndProc(Message);     
end;

{$endregion}

function CreateOpenGLContextAttrList(UseFB: boolean; pf: TglcContextPixelFormatSettings): TGLIntArray;
var
  p: integer;

  procedure Add(i: integer);
  begin
    SetLength(Result, p+1);
    Result[p]:=i;
    inc(p);
  end;

  procedure CreateList;
  begin
    if UseFB then begin Add(GLX_X_RENDERABLE); Add(1); end;
    if pf.DoubleBuffered then begin
      if UseFB then begin
        Add(GLX_DOUBLEBUFFER); Add(1);
      end else
        Add(GLX_DOUBLEBUFFER);
    end;
    if not UseFB and (pf.ColorBits>24) then Add(GLX_RGBA);
    if UseFB then begin
      Add(GLX_DRAWABLE_TYPE);
      Add(GLX_WINDOW_BIT);
    end;
    Add(GLX_RED_SIZE);  Add(8);
    Add(GLX_GREEN_SIZE);  Add(8);
    Add(GLX_BLUE_SIZE);  Add(8);
    if pf.ColorBits>24 then
      Add(GLX_ALPHA_SIZE);  Add(8);
    Add(GLX_DEPTH_SIZE);  Add(pf.DepthBits);
    Add(GLX_STENCIL_SIZE);  Add(pf.StencilBits);
    Add(GLX_AUX_BUFFERS);  Add(pf.AUXBuffers);

    if pf.MultiSampling > 1 then begin
      Add(GLX_SAMPLE_BUFFERS_ARB); Add(1);
      Add(GLX_SAMPLES_ARB); Add(pf.MultiSampling);
    end;

    Add(0); { 0 = X.None (be careful: GLX_NONE is something different) }
  end;

begin
  SetLength(Result, 0);
  p:=0;
  CreateList;
end;

function FBglXChooseVisual(dpy:PDisplay; screen:longint; attrib_list:Plongint):PXVisualInfo;
type
  PGLXFBConfig = ^GLXFBConfig;
var
  FBConfigsCount: integer;
  FBConfigs: PGLXFBConfig;
  FBConfig: GLXFBConfig;
begin
  Result:= nil;
  FBConfigsCount:=0;
  FBConfigs:= glXChooseFBConfig(dpy, screen, attrib_list, @FBConfigsCount);
  if FBConfigsCount = 0 then
    exit;

  { just choose the first FB config from the FBConfigs list.
    More involved selection possible. }
  FBConfig := FBConfigs^;
  Result:=glXGetVisualFromFBConfig(dpy, FBConfig);
end;


{ TGLContextGtk2GLX }

procedure TGLContextGtk2GLX.OpenContext(pf: TglcContextPixelFormatSettings);
var
  attrList: TGLIntArray;
  drawable: PGdkDrawable;
  vi: PXVisualInfo;
begin
  {
    Temporary (realized) widget to get to display
  }
  FWidget:= {%H-}PGtkWidget(PtrUInt(Control.Handle));
  gtk_widget_realize(FWidget);
  drawable:= GTK_WIDGET(FWidget)^.window;

  FDisplay:= GDK_WINDOW_XDISPLAY(drawable);

  {
    Find a suitable visual from PixelFormat using GLX 1.3 FBConfigs or
    old-style Visuals
  }
  if Assigned(glXChooseFBConfig) then begin
    attrList:=CreateOpenGLContextAttrList(true, pf);
    vi:= FBglXChooseVisual(FDisplay, DefaultScreen(FDisplay), @attrList[0]);
    if vi=nil then begin
      pf.MultiSampling:= 1;
      attrList:=CreateOpenGLContextAttrList(true, pf);
      vi:= FBglXChooseVisual(FDisplay, DefaultScreen(FDisplay), @attrList[0]);
    end;
  end else begin
    attrList:=CreateOpenGLContextAttrList(false, pf);
    vi:= glXChooseVisual(FDisplay, DefaultScreen(FDisplay), @attrList[0]);
    if vi=nil then begin
      pf.MultiSampling:= 1;
      attrList:=CreateOpenGLContextAttrList(false, pf);
      vi:= glXChooseVisual(FDisplay, DefaultScreen(FDisplay), @attrList[0]);
    end;
  end;

  if vi=nil then
    raise EGLXError.Create('Failed to find Visual');

  {
    Create Context
  }
  try
    FContext := glXCreateContext(FDisplay, vi, nil, true);

    if (FContext = nil) then
      raise EGLXError.Create('Failed to create Context');

    {
      Most widgets inherit the drawable of their parent. In contrast to Windows, descending from
      TWinControl does not mean it's actually always a window of its own.
      Famous example: TPanel is just a frame painted on a canvas.
      Also, the LCL does somethin weird to colormaps in window creation, so we have
      to use a custom widget here to have full control about visual selection.
    }
    FRenderControl:= TRenderControl.Create(Control, vi^.visual^.visualid);
    try
      FRenderControl.Parent := Control;
      FRenderControl.HandleNeeded;
      FRenderControl.Target := Control;
    except
      FreeAndNil(FRenderControl);
      raise;
    end;

    {
      Real Widget handle, unrealized!!!
    }
    FWidget:= FRenderControl.Widget;
    gtk_widget_realize(FWidget);
    drawable:= GTK_WIDGET(FWidget)^.window;
    FDisplay:= GDK_WINDOW_XDISPLAY(drawable);

    // FRenderControl.Align:= alClient breaks the context or something
    FRenderControl.BoundsRect:= Control.ClientRect;
    FRenderControl.Anchors:= [akLeft, akTop, akRight, akBottom];
  finally
    XFree(vi);
  end;
end;

procedure TGLContextGtk2GLX.CloseContext;
begin
  if not Assigned(FWidget) then exit;
  glXDestroyContext(FDisplay, FContext);
  FreeAndNil(FRenderControl);
end;

procedure TGLContextGtk2GLX.Activate;
begin
  if not Assigned(FWidget) then exit;
  // make sure the widget is realized
  gtk_widget_realize(FWidget);
  if not GTK_WIDGET_REALIZED(FWidget) then exit;

  // make current

  glXMakeCurrent(FDisplay, GDK_DRAWABLE_XID(GTK_WIDGET(FWidget)^.window), FContext);
end;

procedure TGLContextGtk2GLX.Deactivate;
begin
  if not Assigned(FWidget) then exit;
  glXMakeCurrent(FDisplay, GDK_DRAWABLE_XID(GTK_WIDGET(FWidget)^.window), nil);
end;

function TGLContextGtk2GLX.IsActive: boolean;
begin
  Result:= (FContext = glXGetCurrentContext()) and
           Assigned(FWidget) and
           (GDK_DRAWABLE_XID(GTK_WIDGET(FWidget)^.window) = glXGetCurrentDrawable());
end;

procedure TGLContextGtk2GLX.SwapBuffers;
var
  drawable: PGdkDrawable;
begin
  if not Assigned(FWidget) then exit;
  drawable:= GTK_WIDGET(FWidget)^.window;
  glXSwapBuffers(FDisplay, GDK_DRAWABLE_XID(drawable));
end;

procedure TGLContextGtk2GLX.SetSwapInterval(const aInterval: GLint);
var
  drawable: PGdkDrawable;
begin
  drawable:= GTK_WIDGET(FWidget)^.window;
  if GLX_EXT_swap_control then
    glXSwapIntervalEXT(FDisplay, GDK_WINDOW_XWINDOW(drawable), aInterval);
end;

procedure TGLContextGtk2GLX.Share(const aContext: TGLContext);
begin
  raise Exception.Create('not yet implemented');
end;

class function TGLContextGtk2GLX.ChangeDisplaySettings(const aWidth, aHeight,
  aBitPerPixel, aFreq: Integer; const aFlags: TglcDisplayFlags): Boolean;
begin
  raise Exception.Create('not yet implemented');
end;

class function TGLContextGtk2GLX.IsAnyContextActive: boolean;
begin
  Result:= (glXGetCurrentContext()<>nil) and (glXGetCurrentDrawable()<>0);
end;

end.

