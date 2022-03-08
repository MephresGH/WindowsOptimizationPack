@ECHO off
CLS
GOTO :CHECKPERMS

:CHECKPERMS
    echo Administrative Permissions Required. Requesting Permissions...

    NET SESSION >nul 2>&1
    IF %errorLevel% == 0 (
        echo Success: Administrative Permissions Confirmed. Continuing As Usual... && GOTO :PROMPT
    ) ELSE (
        echo Current Permissions Inadequate. Requesting Elevated Rights... && (powershell start -verb runas '%0' am_admin & exit /b)
    )

:PROMPT
CLS
echo ============================================================================
echo                               MSI MODE UTILITY
echo ============================================================================
echo.
echo This script will allow you to enable MSI Mode on your graphics card and other devices.
echo.
echo Recommended: activate MSI Mode on graphics card(s), set mode to 'default' and exit.
echo.
echo The following options can be chosen:
echo.
echo -------------------------
echo      [1] Run Program
echo.
echo      [2] Abort
echo -------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :ABORT
IF ERRORLEVEL 1 GOTO :RUN

:RUN
echo Starting MSI Mode...
"%~dp0/files/MSI Mode/Msi Mode.exe"
GOTO :NEWSCRIPT

:NEWSCRIPT
echo.
echo Do you want to continue and run the next script?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :FINISH
IF ERRORLEVEL 1 GOTO :NEXT

:NEXT
echo Opening Next Script: Custom Power Plan Installer...
call "%~dp0/12 Install And Change Power Plan.bat"

:FINISH
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:ABORT
echo Aborting...
echo The script has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe