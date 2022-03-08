@ECHO off
CLS
GOTO :CHECKPERMS

:CHECKPERMS
    echo Administrative Permissions Required. Requesting Permissions...

    NET SESSION >nul 2>&1
    IF %errorLevel% == 0 (
        echo Success: Administrative Permissions Confirmed. Continuing As Usual... && GOTO :CLEAR
    ) ELSE (
        echo Current Permissions Inadequate. Requesting Elevated Rights... && (powershell start -verb runas '%0' am_admin & exit /b)
    )

:CLEAR
CLS

:INSTALLER
echo ==================================================================================
echo                               AUTO-DEFRAG FIX SCRIPT
echo ==================================================================================
echo.
echo This script will fix the Windows SSD Auto-Defragmentation issues.
echo.
echo The following options can be chosen:
echo.
echo ------------------------------------
echo      [1] Apply Fix And Exit
echo.
echo      [2] Apply Fix And Continue
echo.
echo      [3] Abort
echo ------------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:" 
IF ERRORLEVEL 3 GOTO :ABORT
IF ERRORLEVEL 2 GOTO :START
IF ERRORLEVEL 1 GOTO :STARTEXIT

:START
echo Disabling Scheduled Defragmentations...
schtasks /Change /DISABLE /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" >NUL 2>&1
echo Opening Defragmentation Manager User Interface...
dfrgui.exe
GOTO :NEXT

:STARTEXIT
echo Disabling Scheduled Defragmentations...
schtasks /Change /DISABLE /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" >NUL 2>&1
echo Opening Defragmentation Manager User Interface...
dfrgui.exe
GOTO :FINISH

:NEXT
echo Opening Next Script: Displaz Driver Uninstaller...
call "%~dp0/10 Display Driver Uninstaller.bat"

:FINISH
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:ABORT
echo The process has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe