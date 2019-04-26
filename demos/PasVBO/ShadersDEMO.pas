	
program chap10_SDL2;
uses Classes, SysUtils, GL,GLU, GLext,GLUT,freeglut;
 
const
  vertexShaderFile = 'VertexShader.txt';
  fragmentShaderFile = 'FragShader.txt';
  triangleData: array[0..8] of GLfloat = ( -1.0, -1.0, 0.0,
                                            1.0, -1.0, 0.0,
                                            0.0,  1.0, 0.0  );

type
    extentionsP=^Glint;


var
   OutPutList: TStringList;

    i: integer;
    superlongstring:String;
    VertexArrayID: GLuint;
    triangleVBO: GLuint;
    VertexShaderID: GLuint;
    VertexShaderCode: PGLchar;
    FragmentShaderID: GLuint;
    FragmentShaderCode: PGLchar;
    ShaderCode: TStringList;
    ProgramID: GLuint;
    compilationResult: GLint = GL_FALSE;

    InfoLogLength: GLint;
    ErrorMessageArray: array of GLChar;
 

procedure changeSize(w,h:integer);
var
    ratio:single;

begin

	// Prevent a divide by zero, when window is too short
	if(h = 0) then
		h := 1;
	// set the viewport to be the entire window
	glViewport(0, 0, w, h);
	// set the projection matrix
	ratio := (1.0 * w) / h;
	 glMatrixMode(GL_PROJECTION);
    glLoadIDentity();
    glOrtho(53.13, w, h, ratio, 0.1, 1000.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
end;


procedure renderScene; cdecl;

begin
  glClearColor( 0.0, 0.0, 0.0, 1.0 );
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glutSwapBuffers;

glMatrixMode(GL_PROJECTION); // Projection transformation
glLoadIdentity(); // We initialize the projection matrix as identity
gluPerspective(45.0,1,1.0,1000.0);

//green to blue
  for i := 0 to 255 do
  begin

    glClearColor( 0.0, 1.0-i/255, 0.0+i/255, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT );
    glEnableVertexAttribArray( 0 );
        glBindBuffer( GL_ARRAY_BUFFER, triangleVBO );
        glVertexAttribPointer( 0, 3, GL_FLOAT, GL_FALSE, 0, nil );
        glDrawArrays( GL_TRIANGLES, 0, 3 );
        
    glDisableVertexAttribArray( 0 );

    glutSwapBuffers;
   end;
//blue to green
  for i := 0 to 255 do
  begin

    glClearColor( 0.0, 0.0+i/255, 1.0-i/255, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT );
    glEnableVertexAttribArray( 0 );
        glBindBuffer( GL_ARRAY_BUFFER, triangleVBO );
        glVertexAttribPointer( 0, 3, GL_FLOAT, GL_FALSE, 0, nil );
        glDrawArrays( GL_TRIANGLES, 0, 3 );
    glDisableVertexAttribArray( 0 );
    glutSwapBuffers;

  end;
//inter-fade (green to red)
  for i := 0 to 255 do
  begin

    glClearColor( 0.0+i/255, 1.0-i/255, 0.0, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT );
    glEnableVertexAttribArray( 0 );
        glBindBuffer( GL_ARRAY_BUFFER, triangleVBO );
        glVertexAttribPointer( 0, 3, GL_FLOAT, GL_FALSE, 0, nil );
        glDrawArrays( GL_TRIANGLES, 0, 3 );
    glDisableVertexAttribArray( 0 );
    glutSwapBuffers;

  end;
//red to green
  for i := 0 to 255 do
  begin

    glClearColor( 1.0-i/255, 0.0+i/255, 0.0, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT );
    glEnableVertexAttribArray( 0 );
        glBindBuffer( GL_ARRAY_BUFFER, triangleVBO );
        glVertexAttribPointer( 0, 3, GL_FLOAT, GL_FALSE, 0, nil );
        glDrawArrays( GL_TRIANGLES, 0, 3 );
    glDisableVertexAttribArray( 0 );
    glutSwapBuffers;

  end;

//green to blue
  for i := 0 to 255 do
  begin

    glClearColor( 0.0, 1.0-i/255, 0.0+i/255, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT );
    glEnableVertexAttribArray( 0 );
        glBindBuffer( GL_ARRAY_BUFFER, triangleVBO );
        glVertexAttribPointer( 0, 3, GL_FLOAT, GL_FALSE, 0, nil );
        glDrawArrays( GL_TRIANGLES, 0, 3 );
        
    glDisableVertexAttribArray( 0 );

    glutSwapBuffers;
   end;

  halt(0);
end;


procedure processKeys(key:byte; xx,yy:longint); cdecl;
begin
	if Key = 27 then begin
        glutLeaveMainLoop;
   end;
end;

procedure glutInitPascal(ParseCmdLine: Boolean); 
var
  Cmd: array of string;
  CmdCount, I: Integer;
begin
  if ParseCmdLine then
    CmdCount := ParamCount + 1
  else
    CmdCount := 1;
  SetLength(Cmd, CmdCount);
  for I := 0 to CmdCount - 1 do
    Cmd[I] := ParamStr(I);
  glutInit(@CmdCount, @Cmd);
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

begin

//  GLUT initialization
	glutInitPascal(false);

//bgi unit needs 2,1
    glutInitContextVersion (3,3);

//return for this example- so we can clean up.
    glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_CONTINUE_EXECUTION);

//need this for the BGI unit
    glutInitContextProfile (GLUT_COMPATIBILITY_PROFILE);

//optional
    glutInitContextFlags (GLUT_DEBUG);

	glutInitDisplayMode(GLUT_DEPTH or GLUT_DOUBLE or GLUT_RGBA);
	glutInitWindowPosition(100,100);
	glutInitWindowSize(512,512);
	glutCreateWindow('Lighthouse3D - Simple Shader -FADER- Demo');

//	glutIdleFunc(@processKeys);
    glutDisplayFunc(@renderscene); 
	glutKeyboardFunc(@processKeys);


  //print out OpenGL vendor, version and shader version
  writeln( 'Vendor: ' , glGetString( GL_VENDOR ) );
  writeln( 'OpenGL Version: ' , glGetString( GL_VERSION ) );
  writeln('Supported OpenGL extensions: ');

  superlongstring:=glGetString(GL_EXTENSIONS);

   OutPutList := TStringList.Create;
     Split(' ', superlongstring, OutPutList) ;
     Writeln(OutPutList.Text);
     
     OutPutList.Free;


  writeln( 'Shader Version: ' , glGetString( GL_SHADING_LANGUAGE_VERSION ) );
  writeln ('GLSL: ' , glGetString (GL_SHADING_LANGUAGE_VERSION));
  writeln ('Renderer: ' ,glGetString(GL_RENDERER));

//this is fine if compat profile is enabled.

  //init OpenGL and load extensions
  if Load_GL_VERSION_4_0 = false then
    if Load_GL_VERSION_3_3 = false then
      if Load_GL_VERSION_3_2 = false then
        if Load_GL_VERSION_3_0 = false then
            if Load_GL_VERSION_2_1 = false then

        begin
          writeln(' ERROR: OpenGL 2.1 or higher needed. ');
          HALT(-1);
        end;


  //create Vertex Array Object (VAO)
  glGenVertexArrays( 1, @VertexArrayID );
  glBindVertexArray( VertexArrayID );

  //creating Vertex Buffer Object (VBO)
  glGenBuffers( 1, @triangleVBO );

  glBindBuffer( GL_ARRAY_BUFFER, triangleVBO );
  glBufferData( GL_ARRAY_BUFFER, SizeOf( triangleData ), @triangleData, GL_STATIC_DRAW );
 
  //creating shaders
  VertexShaderID := glCreateShader( GL_VERTEX_SHADER );
  FragmentShaderID := glCreateShader( GL_FRAGMENT_SHADER );

 
  //load shader code and get PChars
  ShaderCode := TStringList.Create;
  ShaderCode.LoadFromFile( VertexShaderFile );
  VertexShaderCode := ShaderCode.GetText;
  if VertexShaderCode = nil then HALT;
  ShaderCode.LoadFromFile( FragmentShaderFile );
  FragmentShaderCode := ShaderCode.GetText;
  if FragmentShaderCode = nil then HALT;
  ShaderCode.Free;
 
  //compiling and error checking vertex shader
  write('Compiling and error checking Vertex Shader... ' );
  glShaderSource( VertexShaderID, 1, @VertexShaderCode, nil );
  glCompileShader( VertexShaderID );
 
  glGetShaderiv( VertexShaderID, GL_COMPILE_STATUS, @compilationResult );
  glGetShaderiv( VertexShaderID, GL_INFO_LOG_LENGTH, @InfoLogLength );
  if compilationResult = GL_FALSE then
  begin
    writeln( 'failure' );
    SetLength( ErrorMessageArray, InfoLogLength+1 );
    glGetShaderInfoLog( VertexShaderID, InfoLogLength, nil, @ErrorMessageArray[0] );
    for i := 0 to InfoLogLength do write( String( ErrorMessageArray[i] ) );
    halt;
  end else writeln( 'success' );
 
  //compiling and error checking fragment shader
  write('Compiling and error checking Fragment Shader... ' );
  glShaderSource( FragmentShaderID, 1, @FragmentShaderCode, nil );
  glCompileShader( FragmentShaderID );
 
  glGetShaderiv( FragmentShaderID, GL_COMPILE_STATUS, @compilationResult );
  glGetShaderiv( FragmentShaderID, GL_INFO_LOG_LENGTH, @InfoLogLength );
  if compilationResult = GL_FALSE then
  begin
    writeln( 'failure' );
    SetLength( ErrorMessageArray, InfoLogLength+1 );
    glGetShaderInfoLog( VertexShaderID, InfoLogLength, nil, @ErrorMessageArray[0] );
    for i := 0 to InfoLogLength do write( String( ErrorMessageArray[i] ) );
    halt;
  end else writeln( 'success' );
 
  //creating and linking program
  write('Creating and linking program... ' );
  ProgramID := glCreateProgram();
  glAttachShader( ProgramID, VertexShaderID );
  glAttachShader( ProgramID, FragmentShaderID );
  glLinkProgram( ProgramID );
 
  glGetShaderiv( ProgramID, GL_LINK_STATUS, @compilationResult );
  glGetShaderiv( ProgramID, GL_INFO_LOG_LENGTH, @InfoLogLength );
  if compilationResult = GL_FALSE then
  begin
    writeln( 'failure' );
    SetLength( ErrorMessageArray, InfoLogLength+1 );
    glGetShaderInfoLog( VertexShaderID, InfoLogLength, nil, @ErrorMessageArray[0] );
    for i := 0 to InfoLogLength do write( String( ErrorMessageArray[i] ) );
    halt;
  end else writeln( 'success' );
    
    glUseProgram( ProgramID ); 

	//  GLUT main loop
	glutMainLoop();

  //clean up
  glDetachShader( ProgramID, VertexShaderID );
  glDetachShader( ProgramID, FragmentShaderID );
 
  glDeleteShader( VertexShaderID );
  glDeleteShader( FragmentShaderID );
  glDeleteProgram( ProgramID );
 
  StrDispose( VertexShaderCode );
  StrDispose( FragmentShaderCode );
 
  glDeleteBuffers( 1, @triangleVBO );
  glDeleteVertexArrays( 1, @VertexArrayID );
 
end.
