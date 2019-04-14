:: Batch script version 06-2007
::
:: Description: Script for calling the Free Pascal Compiler 2.4	(for Windows)
::
:: Usage: fpc.bat prg_name [option]
::        where option is one of the following:
::              -i  for implicit compilation (or without any option)
::              -r  for releasing the code
::              -d  for debugging the code
::        other options are included in 'fpc.cfg' file
@echo off
if "%1"=="" goto usage
if "%2"=="" goto implicit
if "%2"=="-i" goto implicit
if "%2"=="-r" goto release
if "%2"=="-d" goto debug
goto usage
::
:implicit
fpc.exe %1
goto end
::
:release
echo Compiling RELEASE version
fpc.exe %1 -dRELEASE
goto end
::
:debug
echo Compiling DEBUG version
fpc.exe %1 -dDEBUG
goto end
::
:usage
echo Description: Script for calling the Free Pascal Compiler 2.2 (for Windows)
echo.
echo Usage: fpc.bat prg_name [option]
echo        where option is one of the following:
echo              -i  for implicit compilation (or without any option)
echo              -r  for releasing the code
echo              -d  for debugging the code
echo        other options are included in 'fpc.cfg' file
:end
