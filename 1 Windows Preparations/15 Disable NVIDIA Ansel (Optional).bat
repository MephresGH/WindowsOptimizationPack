@ECHO off
:PROMPT
CLS
IF EXIST "C:\Program Files (x86)\NVIDIA Corporation" echo NVIDIA Driver Existent. Starting Process... && GOTO :SETUP
IF NOT EXIST "C:\Program Files (x86)\NVIDIA Corporation" GOTO :NULL

:SETUP
CLS
echo ================================================================================
echo                               DISABLE NVIDIA ANSEL
echo ================================================================================
echo.
echo This script will disable the NVIDIA Ansel overlay.
echo.
echo The following options can be chosen:
echo.
echo ------------------------------------------------
echo      [1] Disable Ansel With Instructions
echo.
echo      [2] Disable Ansel Without Instructions
echo.
echo      [3] Intel
echo ------------------------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:" 
IF ERRORLEVEL 3 GOTO :ABORT
IF ERRORLEVEL 2 GOTO :NOINSTRUCTIONS
IF ERRORLEVEL 1 GOTO :INSTRUCTIONS

    :INSTRUCTIONS
    echo Opening Image Guidance, Close After Inspection...
    "%~dp0/Files/nvidiaProfileInspector/NVIDIA Profile Inspector Settings 1.png"
    "%~dp0/Files/nvidiaProfileInspector/NVIDIA Profile Inspector Settings 2.png"
    echo Starting NVIDIA Profile Inspector...
    "%~dp0/Files/nvidiaProfileInspector/nvidiaProfileInspector.exe"
    GOTO :NEWSCRIPT

    :NOINSTRUCTIONS
    echo Toggled No-Instructions Setup.
    echo Starting NVIDIA Profile Inspector...
    "%~dp0/Files/nvidiaProfileInspector/nvidiaProfileInspector.exe"
    GOTO :NEWSCRIPT

    :NEWSCRIPT
    echo.
    echo Do you want to run the next script(s)?
    echo.
    echo ----------------------
    echo      [1] Continue
    echo.
    echo      [2] Abort
    echo ----------------------
    echo.
    CHOICE /C 12 /N /M "Enter Your Choice:" 
    IF ERRORLEVEL 2 GOTO :ABORT
    IF ERRORLEVEL 1 GOTO :NEXT

    :NEXT
    echo Opening Next Script: System Service Manager...
    call "%~dp0/../2 Windows Optimizations/1 Turn Gamebar Off & Game Mode On.url"
    pause
    call "%~dp0/../2 Windows Optimizations/2 Disable Backgrounds Apps & Fix Privacy.url"
    pause
    call "%~dp0/../2 Windows Optimizations/3 Windows Fix Blurry Apps Off.url"
    pause
    call "%~dp0/../2 Windows Optimizations/4 Fix General Windows Settings.url"
    pause
    call "%~dp0/../2 Windows Optimizations/5 Remove Startup Apps.url"
    pause
    call "%~dp0/../2 Windows Optimizations/6 Uninstall Bloat Manually.url"
    pause
    call "%~dp0/../2 Windows Optimizations/7 Uninstall Bloat Manually (Legacy).lnk"
    pause
    call "%~dp0/../2 Windows Optimizations/8 Disable-Enable Services.bat"

    :FINISH
    echo The process has been finished. Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

    :NULL
    echo The process has been abandoned. Install the NVIDIA Driver to proceed with the script.
    echo Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

    :ABORT
    echo The script has stopped, no user permission given. Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe