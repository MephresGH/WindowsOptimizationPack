@ECHO off
CLS
GOTO :START

:START
CLS
echo =============================================================================
echo                               DIRECTX INSTALLER
echo =============================================================================
echo.
echo This script will install the newest versions of the DirectX Graphics API.
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
IF ERRORLEVEL 2 GOTO :INSTALLRUN
IF ERRORLEVEL 1 GOTO :INSTALLEXIT

:INSTALLRUN
start "Start DirectX Installer" "%~dp0/Files/DirectX/dxwebsetup.exe"
timeout /t -1
GOTO :NEXT

:INSTALLEXIT
start "Start DirectX Installer" "%~dp0/Files/DirectX/dxwebsetup.exe"
timeout /t -1
GOTO :FINISH

:NEXT
echo Opening Next Script: Debloat Script...
call "%~dp0/6 Debloat Script (Optional).bat"

:FINISH
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:NOPERMS
echo The process has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe