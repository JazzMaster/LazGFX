// "WinCrt Unit", Copyright (c) 2003-2010 by Stefan Berinde
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
unit wincrt;

interface

{caret format: block or underline}
var CaretBlock: boolean = true;

{caret blink rate in tenths of a second}
var BlinkRate: word = 2;

{keyboard exported routines}
procedure Delay(ms:word);
function KeyPressed: boolean;
procedure ReadBuf(out buf:shortstring; maxchar:byte);
function ReadKey: char;
procedure Sound(hz,dur:word);
procedure WriteBuf(buf:shortstring);


implementation
uses windows{$IFNDEF FPC},messages{$ENDIF},wingraph;

const KeyBufSize = 32;
var protect_keyboard        : TRTLCriticalSection;
    nr_readkey,nr_inputkey  : longint;
    keyBuf                  : array[1..KeyBufSize] of char;
    old_TextSettings        : TextSettingsType;
    textX,textY,textW,textH,
    maxX,maxY               : smallint;

{internal routines}

procedure InitKeyBuf;
begin
  nr_readkey:=1; nr_inputkey:=1;
end;

procedure IncKeyCyclic(var nr: longint);
begin
  Inc(nr); if (nr > KeyBufSize) then nr:=1;
end;

procedure AddKey(c:char);
begin
  EnterCriticalSection(protect_keyboard);
  KeyBuf[nr_inputkey]:=c;
  IncKeyCyclic(nr_inputkey);
  if (nr_readkey = nr_inputkey) then
  begin
    if (KeyBuf[nr_readkey] = #0) then IncKeyCyclic(nr_readkey);
    IncKeyCyclic(nr_readkey);
  end;
  LeaveCriticalSection(protect_keyboard);
end;

procedure AddExtKey(c:char);
begin
  AddKey(#0); AddKey(c);
end;

procedure TranslateKeys(code:WPARAM);
var shift_key,ctrl_key,alt_key: boolean;
begin
  shift_key:=(GetKeyState(VK_SHIFT) < 0);
  ctrl_key:=(GetKeyState(VK_CONTROL) < 0);
  alt_key:=(GetKeyState(VK_MENU) < 0);
  case code of
    VK_SPACE: if alt_key then AddExtKey(#11);
    VK_TAB: if ctrl_key then AddKey(#30);
    VK_BACK: if alt_key then AddExtKey(#14);
    VK_RETURN: if alt_key then AddExtKey(#166);
    VK_APPS: AddExtKey(#151);
    VK_INSERT: if ctrl_key then AddExtKey(#146) else
               if alt_key then AddExtKey(#162) else AddExtKey(#82);
    VK_DELETE: if ctrl_key then AddExtKey(#147) else
               if alt_key then AddExtKey(#163) else AddExtKey(#83);
    VK_HOME: if ctrl_key then AddExtKey(#119) else
             if alt_key then AddExtKey(#164) else AddExtKey(#71);
    VK_END: if ctrl_key then AddExtKey(#117) else
            if alt_key then AddExtKey(#165) else AddExtKey(#79);
    VK_NEXT: if ctrl_key then AddExtKey(#118) else
             if alt_key then AddExtKey(#161) else AddExtKey(#81);
    VK_PRIOR: if ctrl_key then AddExtKey(#132) else
              if alt_key then AddExtKey(#153) else AddExtKey(#73);
    VK_UP: if ctrl_key then AddExtKey(#141) else
           if alt_key then AddExtKey(#152) else AddExtKey(#72);
    VK_DOWN: if ctrl_key then AddExtKey(#145) else
             if alt_key then AddExtKey(#160) else AddExtKey(#80);
    VK_LEFT: if ctrl_key then AddExtKey(#115) else
             if alt_key then AddExtKey(#155) else AddExtKey(#75);
    VK_RIGHT: if ctrl_key then AddExtKey(#116) else
              if alt_key then AddExtKey(#157) else AddExtKey(#77);
    VK_F1..VK_F10: if shift_key then AddExtKey(chr(code-28)) else
                   if ctrl_key then AddExtKey(chr(code-18)) else
                   if alt_key then AddExtKey(chr(code-8))
                              else AddExtKey(chr(code-53));
    VK_F11,VK_F12: if shift_key then AddExtKey(chr(code+13)) else
                   if ctrl_key then AddExtKey(chr(code+15)) else
                   if alt_key then AddExtKey(chr(code+17))
                              else AddExtKey(chr(code+11));
    VK_PAUSE: if alt_key then AddExtKey(#169) else
              if not(ctrl_key) then AddExtKey(#12);
    VK_CLEAR: if ctrl_key then AddExtKey(#143) else AddExtKey(#76); //this is numpad 5 + numlock off
    VK_DIVIDE: if ctrl_key then AddExtKey(#148) else
               if alt_key then AddExtKey(#69);
    VK_MULTIPLY: if ctrl_key then AddExtKey(#149) else
                 if alt_key then AddExtKey(#70);
    VK_SUBTRACT: if ctrl_key then AddExtKey(#142) else
                 if alt_key then AddExtKey(#74);
    VK_ADD: if ctrl_key then AddExtKey(#144) else
            if alt_key then AddExtKey(#78);
    VK_DECIMAL: if ctrl_key then AddExtKey(#150) else
                if alt_key then AddExtKey(#114);
  else
    if ctrl_key then case code of
                       ord('0')          : AddExtKey(#10);
                       ord('1')..ord('9'): AddExtKey(chr(code-48));
                     end;
    if alt_key then case code of
                      ord('A'): AddExtKey(#30);
                      ord('B'): AddExtKey(#48);
                      ord('C'): AddExtKey(#46);
                      ord('D'): AddExtKey(#32);
                      ord('E'): AddExtKey(#18);
                      ord('F'): AddExtKey(#33);
                      ord('G'): AddExtKey(#34);
                      ord('H'): AddExtKey(#35);
                      ord('I'): AddExtKey(#23);
                      ord('J'): AddExtKey(#36);
                      ord('K'): AddExtKey(#37);
                      ord('L'): AddExtKey(#38);
                      ord('M'): AddExtKey(#50);
                      ord('N'): AddExtKey(#49);
                      ord('O'): AddExtKey(#24);
                      ord('P'): AddExtKey(#25);
                      ord('Q'): AddExtKey(#16);
                      ord('R'): AddExtKey(#19);
                      ord('S'): AddExtKey(#31);
                      ord('T'): AddExtKey(#20);
                      ord('U'): AddExtKey(#22);
                      ord('V'): AddExtKey(#47);
                      ord('W'): AddExtKey(#17);
                      ord('X'): AddExtKey(#45);
                      ord('Y'): AddExtKey(#21);
                      ord('Z'): AddExtKey(#44);
                      ord('0')          : AddExtKey(#129);
                      ord('1')..ord('9'): AddExtKey(chr(code+71));
                    end;
  end;
end;

function WinCrtProc(grHandle:HWND; mess:UINT; wParam:WPARAM;
                    lParam:LPARAM): LRESULT; stdcall;
begin
  Result:=0;
  case mess of
    WM_CREATE: begin
                 InitializeCriticalSection(protect_keyboard);
                 InitKeyBuf;
               end;
    WM_CHAR: AddKey(chr(wparam));
    WM_KEYDOWN: if (wParam <> VK_SHIFT) and (wParam <> VK_CONTROL) then TranslateKeys(wParam);
    WM_SYSKEYDOWN: if (wParam <> VK_MENU) then TranslateKeys(wParam);
    WM_CLOSE: AddExtKey(#107);
    WM_DESTROY: DeleteCriticalSection(protect_keyboard);
  end;
end;

procedure CheckNewLine;
var size  : longword;
    screen: pointer;
begin
  if (textX+textW > maxX) then begin
                                 textX:=0; Inc(textY,textH);
                               end;
  if (textY+textH > maxY) then //scroll entire text upwards
  begin
    repeat
      Dec(textY,textH);
    until (textY+textH <= maxY);
    size:=ImageSize(0,textH,maxX,maxY);
    GetMem(screen,size);
    GetImage(0,textH,maxX,maxY,screen^);
    ClearViewPort;
    PutImage(0,0,screen^,CopyPut);
    FreeMem(screen);
  end;
end;

procedure DrawCaret(nr:longint);
begin
  case nr of
    0: SetFillStyle(SolidFill,GetBkColor);
    1: SetFillStyle(SolidFill,GetColor);
  end;
  if CaretBlock or (nr = 0) then Bar(textX,textY,textX+textW,textY+textH)
                            else Bar(textX,textY+textH-1,textX+textW,textY+textH);
end;

procedure TextSettings;
var viewport: ViewPortType;
begin
  with old_TextSettings do
  begin
    SetTextStyle(DefaultFont or (font div $10) shl 4,0,charsize); //keep font format
    SetTextJustify(LeftText,TopText);
  end;
  textX:=GetX; textY:=GetY;
  textW:=TextWidth('W'); textH:=TextHeight('H');
  GetViewSettings(viewport);
  with viewport do begin
                     maxX:=x2-x1; maxY:=y2-y1;
                   end;
end;

{keyboard routines}

procedure Delay(ms:word);
begin
  Sleep(ms);
end;

function KeyPressed: boolean;
begin
  Result:=(nr_readkey <> nr_inputkey);
end;

procedure ReadBuf(out buf:shortstring; maxchar:byte);
var old_FillSettings     : FillSettingsType;
    nrpass,nrchar,nrcaret: longint;
    ch                   : char;
begin
  if GraphEnabled then
  begin
    GetTextSettings(old_TextSettings); GetFillSettings(old_FillSettings);
    TextSettings;
    CheckNewLine;
    nrpass:=0; nrcaret:=0; nrchar:=0; ch:=#0;
    if (maxchar <= 0) then maxchar:=255;
    repeat
      if (nrpass = 0) then
      begin
        nrcaret:=1-nrcaret;
        DrawCaret(nrcaret);
        nrpass:=10*BlinkRate;
      end             else Dec(nrpass);
      if KeyPressed then
      begin
        ch:=ReadKey;
        case ch of
          #32..#126: begin
                       if (nrcaret = 1) then begin
                                               DrawCaret(0);
                                               nrcaret:=0;
                                             end;
                       Inc(nrchar); buf[nrchar]:=ch;
                       OutTextXY(textX,textY,ch);
                       Inc(textX,textW);
                       CheckNewLine;
                       nrpass:=0;
                     end;
                 #8: if (nrchar > 0) and (textX > 0) then
                     begin
                       if (nrcaret = 1) then begin
                                               DrawCaret(0);
                                               nrcaret:=0;
                                             end;
                       Dec(nrchar); Dec(textX,textW);
                       nrpass:=0;
                     end;
                 #0: ReadKey;
        end;
      end;
      Sleep(10);
    until (ch = #13) or (nrchar = maxchar) or CloseGraphRequest;
    if (nrcaret = 1) then DrawCaret(0);
    buf[0]:=Chr(nrchar);
    MoveTo(0,textY+textH);
    with old_TextSettings do begin
                               SetTextStyle(font,direction,charsize);
                               SetTextJustify(horiz,vert);
                             end;
    with old_FillSettings do SetFillStyle(pattern,color);
  end;
end;

function ReadKey: char;
begin
  if GraphEnabled then
  begin
    while (nr_readkey = nr_inputkey) do Sleep(10);
    EnterCriticalSection(protect_keyboard);
    Result:=KeyBuf[nr_readkey];
    IncKeyCyclic(nr_readkey);
    LeaveCriticalSection(protect_keyboard);
  end             else Result:=#0;
end;

procedure Sound(hz,dur:word);
begin
  Beep(hz,dur);
end;

procedure WriteBuf(buf:shortstring);
var old_FillSettings: FillSettingsType;
    nrchar          : longint;
    ch              : char;
begin
  if GraphEnabled then
  begin
    GetTextSettings(old_TextSettings);
    GetFillSettings(old_FillSettings);
    TextSettings;
    CheckNewLine;
    for nrchar:=1 to Length(buf) do
    begin
      ch:=buf[nrchar];
      case ch of
        #32..#126: begin
                     DrawCaret(0);
                     OutTextXY(textX,textY,ch);
                     Inc(textX,textW);
                     CheckNewLine;
                   end;
              #13: begin
                     textX:=maxX;
                     CheckNewLine;
                   end;
      end;
    end;
    MoveTo(textX,textY);
    with old_TextSettings do
    begin
      SetTextStyle(font,direction,charsize);
      SetTextJustify(horiz,vert);
    end;
    with old_FillSettings do SetFillStyle(pattern,color);
  end;
end;

initialization
  KeyboardHook:=@WinCrtProc;
end.

