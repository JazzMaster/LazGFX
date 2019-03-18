Unit OpenGLProcs;

{$IFDEF FPC}
  {$MODE OBJFPC}
  {$LONGSTRINGS ON}
{$ENDIF}

Interface

Uses
  Classes, GL, GLExt;

{$R Shaders.rc}

Type
  TRectArray = Array[0..7] Of GLUInt;

Var
  SelectionArrayObject: GLUInt;

Var
  OpenGLErrors: String;

Function OpenGLVersion: String;
Function VendorName: String;
Function RendererName: String;
Function ShadingLanguageVersion: String;
Function VersionDetails: String;
Function PrepareGL: Boolean;
Procedure ResizeGL(OutputRect: TRect);
Procedure UpdateRectBuffer(ArrayObject: GLUInt; Rect: TRect);
Procedure BuildBuffers;
Procedure ClearGL;
Procedure RenderGL;

Implementation

Var
  VertexShader: TGLuint;
  FragmentShader: TGLuint;
  ShaderProgram: TGLuint;

Function OpenGLVersion: String;
Begin
  Result := glGetString(GL_VERSION);
End;

Function VendorName: String;
Begin
  Result := glGetString(GL_VENDOR);
End;

Function RendererName: String;
Begin
  Result := glGetString(GL_RENDERER);
End;

Function ShadingLanguageVersion: String;
Begin
  Result := glGetString(GL_SHADING_LANGUAGE_VERSION);
End;

Function VersionDetails: String;
Begin
  Result := 'OpenGL Version: '+OpenGLVersion+LineEnding+
            'Vendor: '+VendorName+LineEnding+
            'Renderer: '+RendererName+LineEnding+
            'GLSL Version: '+ShadingLanguageVersion;
End;

Function PrepareGL: Boolean;
Var
  ErrorLength: GLInt;
  ErrorText: String;
  Function LoadStringResource(ResourceName: String): String;
  Var
    DataStream: TResourceStream;
  Begin
    DataStream := TResourceStream.Create(HInstance, ResourceName, 'GLSL');
    Result := PChar(DataStream.Memory);
    SetLength(Result, DataStream.Size);
    DataStream.Free;
  End;
  Function CreateShader(ShaderType: TGLenum; Source: String): TGLuint;
  Var
    ShaderValid: GLInt;
  Begin
    Result := glCreateShader(ShaderType);
    glShaderSource(Result, 1, @Source, Nil);
    glCompileShader(Result);
    glGetShaderiv(Result, GL_COMPILE_STATUS, @ShaderValid);
    If ShaderValid=GL_FALSE Then
      Begin
	glGetShaderiv(Result, GL_INFO_LOG_LENGTH, @ErrorLength);
        SetLength(ErrorText, ErrorLength);
	glGetShaderInfoLog(Result, ErrorLength, @ErrorLength, @ErrorText[1]);
        If Result<>0 Then
          Begin
	    glDeleteShader(Result);
            Result := 0;
          End;
        OpenGLErrors := OpenGLErrors+ErrorText+LineEnding;
      End;
  End;
Begin
  Result := False;
  If Load_GL_VERSION_2_0 Then
    Begin
      If ShaderProgram<>0 Then
        Begin
          glDeleteShader(VertexShader);
          glDeleteShader(FragmentShader);
          glDeleteProgram(ShaderProgram);
        End;
      ShaderProgram := glCreateProgram();
      If ShaderProgram=0 Then
        Begin
          OpenGLErrors := OpenGLErrors+ErrorText+LineEnding;
          Exit;
        End
      Else
        Begin
          VertexShader := CreateShader(GL_VERTEX_SHADER, LoadStringResource('VertexShader'));
          If VertexShader=0 Then
            Begin
              glDeleteProgram(ShaderProgram);
              Exit;
            End;
          glAttachShader(ShaderProgram, VertexShader);
          FragmentShader := CreateShader(GL_FRAGMENT_SHADER, LoadStringResource('FragmentShader'));
          If FragmentShader=0 Then
            Begin
              glDeleteShader(VertexShader);
              glDeleteProgram(ShaderProgram);
              Exit;
            End;
          glAttachShader(ShaderProgram, FragmentShader);
          glLinkProgram(ShaderProgram);
          glGetProgramiv(ShaderProgram, GL_LINK_STATUS, @Result);
          If Not Result Then
            Begin
	      glGetProgramiv(ShaderProgram, GL_INFO_LOG_LENGTH, @ErrorLength);
              SetLength(ErrorText, ErrorLength);
	      glGetProgramInfoLog(ShaderProgram, ErrorLength, @ErrorLength, @ErrorText[1]);
	      OpenGLErrors := OpenGLErrors+ErrorText+LineEnding;
              glDeleteShader(VertexShader);
              glDeleteShader(FragmentShader);
              glDeleteProgram(ShaderProgram);
            End;
        End;
    End
  Else
    OpenGLErrors := OpenGLErrors+'Extension initialization failed.'+LineEnding;
End;

Procedure ResizeGL(OutputRect: TRect);
Var
  MidpointUniform: GLint;
  UniformName: PGLchar;
  MidPointX: GLFloat;
  MidPointY: GLFloat;
Begin
  With OutputRect Do
    glViewport(Left, Top, Right, Bottom);
  UniformName := 'midpoint';
  MidpointUniform := glGetUniformLocation(ShaderProgram, UniformName);
  MidPointX := GLFloat(OutputRect.Width Div 2);
  MidPointY := GLFloat(OutputRect.Height Div 2);
  glUseProgram(ShaderProgram);
  glUniform2f(MidpointUniform, MidPointX, MidPointY);
End;

Function CreateRectBuffer(Rect: TRect): GLUInt;
Begin
  glGenBuffers(1, @Result);
  UpdateRectBuffer(Result, Rect);
End;

Procedure UpdateRectBuffer(ArrayObject: GLUInt; Rect: TRect);
Var
  Data: TRectArray;
Begin
  With Rect Do
    Begin
      Data[0] := Left;
      Data[1] := Bottom;
      Data[2] := Left;
      Data[3] := Top;
      Data[4] := Right;
      Data[5] := Top;
      Data[6] := Right;
      Data[7] := Bottom;
    End;
  glBindBuffer(GL_ARRAY_BUFFER, ArrayObject);
  glBufferData(GL_ARRAY_BUFFER, SizeOf(TRectArray), @Data[0], GL_DYNAMIC_DRAW);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
End;

Procedure BuildBuffers;
Begin
  If SelectionArrayObject<>0 Then
    glDeleteBuffers(1, @SelectionArrayObject);
  SelectionArrayObject := CreateRectBuffer(Rect(0, 0, 0, 0));
End;

Procedure ClearGL;
Begin
  glClearColor(1.0, 1.0, 1.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT);
End;

Procedure RenderGL;
  Procedure DrawQuadBuffer(ArrayObject: GLUInt);
  Begin
    glBindBuffer(GL_ARRAY_BUFFER, ArrayObject);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_INT, GL_FALSE, 0, Nil);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
    glDisableVertexAttribArray(0);
  End;
Begin
  { Activate drawing program. }
  glUseProgram(ShaderProgram);
  { Output geometry objects. }
  DrawQuadBuffer(SelectionArrayObject);
  { Deactivate drawing program. }
  glUseProgram(0);
End;

End.

