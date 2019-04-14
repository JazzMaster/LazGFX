// "WinMouse Unit", Copyright (c) 2003-2010 by Stefan Berinde
//   Version: as WinGraph unit
//
// Source code: Free Pascal 2.4 (http://www.freepascal.org) &
//              Delphi 7
//
// Unit dependences:
//   windows  (standard)
//   messages (standard, only for Delphi)
//   wingraph
//
unit winmouse;

interface

type MouseEventType = record
                        action : word;
                        buttons: word;
                        x,y    : word;
                        wheel  : smallint;
                      end;
{mouse constants}
const MouseActionDown   = word($01);
      MouseActionUp     = word($02);
      MouseActionMove   = word($03);
      MouseActionWheel  = word($04);
      MouseLeftButton   = word($01);
      MouseRightButton  = word($02);
      MouseMiddleButton = word($04);
      MouseShiftKey     = word($08);
      MouseCtrlKey      = word($10);

{mouse exported routines}
function GetMouseButtons: word;
procedure GetMouseEvent(out mouseEvent:MouseEventType);
function GetMouseX: word;
function GetMouseY: word;
function GetMouseWheel: smallint;
function PollMouseEvent(out mouseEvent:MouseEventType): boolean;
procedure PutMouseEvent(const mouseEvent:MouseEventType);
procedure SetMouseXY(x,y:word);

implementation
uses windows{$IFNDEF FPC},messages{$ENDIF},wingraph;

const MouseBufSize = 16;
var graphHandle               : HWND;
    protect_mouse             : TRTLCriticalSection;
    nr_readmouse,nr_inputmouse: longint;
    mouseButtons,mouseX,mouseY: word;
    mouseWheel                : smallint;
    mouseBuf                  : array[1..MouseBufSize] of MouseEventType;

{internal routines}

procedure InitMouseBuf;
begin
  nr_readmouse:=1; nr_inputmouse:=1;
end;

procedure IncMouseCyclic(var nr: longint);
begin
  Inc(nr); if (nr > MouseBufSize) then nr:=1;
end;

procedure AddMouseEvent(act:word; wParam:WPARAM; lParam:LPARAM);
begin
  EnterCriticalSection(protect_mouse);
  with mouseBuf[nr_inputmouse] do
  begin
    action:=act;
    buttons:=0;
    if (wParam and MK_LBUTTON <> 0) then buttons:=buttons or MouseLeftButton;
    if (wParam and MK_RBUTTON <> 0) then buttons:=buttons or MouseRightButton;
    if (wParam and MK_MBUTTON <> 0) then buttons:=buttons or MouseMiddleButton;
    if (wParam and MK_SHIFT   <> 0) then buttons:=buttons or MouseShiftKey;
    if (wParam and MK_CONTROL <> 0) then buttons:=buttons or MouseCtrlKey;
    mouseButtons:=buttons;
    x:=LOWORD(lParam); y:=HIWORD(lParam);
    mouseX:=x; mouseY:=y;
    if (act = MouseActionWheel) then
    begin
      wParam:=HIWORD({$IFNDEF FPC}DWORD{$ENDIF}(wParam)); //Delphi needs this typecast
      if (wParam < 32768) then wheel:=wParam else wheel:=wParam-65536;
    end                         else wheel:=0;
    mouseWheel:=wheel;
  end;
  IncMouseCyclic(nr_inputmouse);
  if (nr_readmouse = nr_inputmouse) then IncMouseCyclic(nr_readmouse);
  LeaveCriticalSection(protect_mouse);
end;

function WinMouseProc(grHandle:HWND; mess:UINT; wParam:WPARAM;
                      lParam:LPARAM): LRESULT; stdcall;
begin
  Result:=0;
  case mess of
    WM_CREATE: begin
                 graphHandle:=grHandle;
                 InitializeCriticalSection(protect_mouse);
                 InitMouseBuf;
               end;
    WM_MOUSEMOVE: AddMouseEvent(MouseActionMove,wParam,lParam);
    WM_LBUTTONDOWN: AddMouseEvent(MouseActionDown,wParam,lParam);
    WM_RBUTTONDOWN: AddMouseEvent(MouseActionDown,wParam,lParam);
    WM_MBUTTONDOWN: AddMouseEvent(MouseActionDown,wParam,lParam);
    WM_LBUTTONUP: AddMouseEvent(MouseActionUp,wParam,lParam);
    WM_RBUTTONUP: AddMouseEvent(MouseActionUp,wParam,lParam);
    WM_MBUTTONUP: AddMouseEvent(MouseActionUp,wParam,lParam);
    WM_MOUSEWHEEL: AddMouseEvent(MouseActionWheel,wParam,lParam);
    WM_DESTROY: DeleteCriticalSection(protect_mouse);
  end;
end;

{mouse routines}

function GetMouseButtons: word;
begin
  Result:=mouseButtons;
end;

procedure GetMouseEvent(out mouseEvent:MouseEventType);
begin
  while (nr_readmouse = nr_inputmouse) do Sleep(10);
  EnterCriticalSection(protect_mouse);
  PollMouseEvent(mouseEvent);
  IncMouseCyclic(nr_readmouse);
  LeaveCriticalSection(protect_mouse);
end;

function GetMouseX: word;
begin
  Result:=mouseX;
end;

function GetMouseY: word;
begin
  Result:=mouseY;
end;

function GetMouseWheel: smallint;
begin
  EnterCriticalSection(protect_mouse);
  Result:=mouseWheel;
  mouseWheel:=0;
  LeaveCriticalSection(protect_mouse);
end;

function PollMouseEvent(out mouseEvent:MouseEventType): boolean;
begin
  if (nr_readmouse = nr_inputmouse) then Result:=false else
  begin
    mouseEvent:=mouseBuf[nr_readmouse];
    Result:=true;
  end;
end;

procedure PutMouseEvent(const mouseEvent:MouseEventType);
begin
  EnterCriticalSection(protect_mouse);
  mouseBuf[nr_inputmouse]:=mouseEvent;
  IncMouseCyclic(nr_inputmouse);
  if (nr_readmouse = nr_inputmouse) then IncMouseCyclic(nr_readmouse);
  LeaveCriticalSection(protect_mouse);
end;

procedure SetMouseXY(x,y:word);
var lpRect: TRect;
begin
  if GraphEnabled then
  begin
    GetWindowRect(graphHandle,lpRect);
    if (graphHandle = GetForegroundWindow) then with lpRect do
      SetCursorPos(x+GetSystemMetrics(SM_CXFIXEDFRAME)+left,
                   y+GetSystemMetrics(SM_CYFIXEDFRAME)+
                   GetSystemMetrics(SM_CYCAPTION)+top);
  end;
end;

initialization
  MouseHook:=@WinMouseProc;
end.

