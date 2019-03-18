Unit Main;

{$IFDEF FPC}
  {$MODE OBJFPC}
  {$LONGSTRINGS ON}
{$ENDIF}

Interface

Uses
  Classes, LCLType, SysUtils, FileUtil, OpenGLContext, Forms, Controls, Graphics,
  Dialogs, ActnList, OpenGLProcs;

Type
  TMainForm = Class(TForm)
    FullscreenAction: TAction;
    InformationAction: TAction;
    RefreshAction: TAction;
    ActionList: TActionList;
    OpenGLControl: TOpenGLControl;
    Procedure FormCreate(Sender: TObject);
    Procedure FullscreenActionExecute(Sender: TObject);
    Procedure InformationActionExecute(Sender: TObject);
    Procedure OpenGLControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure OpenGLControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    Procedure OpenGLControlPaint(Sender: TObject);
    Procedure OpenGLControlResize(Sender: TObject);
    Procedure RefreshActionExecute(Sender: TObject);
  Private
    StartPoint: TPoint;
    ModernOpenGLEnabled: Boolean;
    Function PrepareOpenGLControl: Boolean;
  Public
    Procedure EraseBackground(DC: HDC); Override;
  End;

Var
  MainForm: TMainForm;

Implementation

{$R *.lfm}

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
  ModernOpenGLEnabled := PrepareOpenGLControl;
  If ModernOpenGLEnabled Then
    BuildBuffers;
End;

{$HINTS OFF}
Procedure TMainForm.EraseBackground(DC: HDC);
Begin
  { Do nothing since painting will cover the whole control window. }
  { This will prevent screen flicker during rapid repainting such as resizing the window. }
End;
{$HINTS ON}

Function TMainForm.PrepareOpenGLControl: Boolean;
Begin
  Result := False;
  OpenGLControl.MakeCurrent;
  If ShadingLanguageVersion='' Then
    Begin
      ShowMessage('Modern OpenGL unavailable on this system.');
    End
  Else If Not PrepareGL Then
    Begin
      ShowMessage('Unable to initialize Modern OpenGL:'+LineEnding+OpenGLErrors);
    End
  Else
    Result := True;
End;

Procedure TMainForm.OpenGLControlResize(Sender: TObject);
Begin
  If ModernOpenGLEnabled Then
    ResizeGL(OpenGLControl.ClientRect);
End;

Var
  RestoreRect: TRect;

Procedure TMainForm.FullscreenActionExecute(Sender: TObject);
Begin
  If FullscreenAction.Checked Then
    Begin
      RestoreRect := BoundsRect;
      BorderStyle := bsNone;
      WindowState := wsFullScreen;
    End
  Else
    Begin
      WindowState := wsMaximized;
      BoundsRect := RestoreRect;
      BorderStyle := bsSizeable;
      WindowState := wsNormal;
    End;
  If ModernOpenGLEnabled Then
    Begin
      PrepareOpenGLControl;
      BuildBuffers;
      ResizeGL(OpenGLControl.ClientRect);
    End;
End;

Procedure TMainForm.InformationActionExecute(Sender: TObject);
Begin
  ShowMessage(VersionDetails);
End;

Procedure TMainForm.OpenGLControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  StartPoint := Point(X, Y);
End;

Procedure TMainForm.OpenGLControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Var
  OutputRect: TRect;
Begin
  If ModernOpenGLEnabled Then
    If ssLeft In Shift Then
      Begin
        OutputRect.BottomRight := StartPoint;
        OutputRect.TopLeft := Point(X, Y);
        UpdateRectBuffer(SelectionArrayObject, OutputRect);
        OpenGLControl.Repaint;
      End;
End;

Procedure TMainForm.RefreshActionExecute(Sender: TObject);
Begin
  OpenGLControl.Refresh;
End;

Procedure TMainForm.OpenGLControlPaint(Sender: TObject);
Begin
  ClearGL;
  If ModernOpenGLEnabled Then
    RenderGL;
  OpenGLControl.SwapBuffers;
End;

End.

