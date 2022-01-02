@ECHO off

:START
CLS
echo =========================================================================
echo                               C++ INSTALLER
echo =========================================================================
echo.
echo This script will install the newest versions and libraries of the MS Visual C++ Runtimes And Redistributables.
echo.
echo The following options can be chosen:
echo.
echo ------------------------------
echo      [1] Run And Exit
echo.
echo      [2] Run And Continue
echo.
echo      [3] Abort
echo ------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:"
IF ERRORLEVEL 3 GOTO :NOPERMS
IF ERRORLEVEL 2 GOTO :INSTALLER
IF ERRORLEVEL 1 GOTO :INSTALLEREXIT

:INSTALLER
start "Start Installer" "%~dp0/Files/C++ Installer/C++ Installer.exe"
GOTO :NEXT

:INSTALLEREXIT
start "Start Installer" "%~dp0/Files/C++ Installer/C++ Installer.exe"
GOTO :FINISH

:NEXT
echo Opening Next Script: DirectX Installer...
call "%~dp0/5 DirectX Installer.bat"

:FINISH
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:NOPERMS
echo The process has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe