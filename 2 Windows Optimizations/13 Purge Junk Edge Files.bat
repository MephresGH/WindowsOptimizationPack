@ECHO off
CLS
GOTO :CHECKPERMS

:CHECKPERMS
    echo Administrative Permissions Required. Detecting Permissions...

    NET SESSION >nul 2>&1
    IF %errorLevel% == 0 (
        echo Success: Administrative Permissions Confirmed. Continuing As Usual... && GOTO :PROMPT
    ) ELSE (
        echo Current Permissions Inadequate. Requesting Elevated Rights... && (powershell start -verb runas '%0' am_admin & exit /b)
    )

:PROMPT
CLS
echo ==================================================================================
echo                               MICROSOFT EDGE CLEANUP
echo ==================================================================================
echo.
echo This script will remove leftover files from Microsoft Edge.
echo.
echo If you did not uninstall Microsoft Edge, this step should be skipped.
echo.
echo The following options can be chosen:
echo.
echo ----------------------------------
echo      [1] Remove And Exit
echo.
echo      [2] Remove And Continue
echo.
echo      [3] Abort
echo ----------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:"
IF ERRORLEVEL 3 GOTO :ABORT
IF ERRORLEVEL 2 GOTO :REMOVERUN
IF ERRORLEVEL 1 GOTO :REMOVEEXIT

:REMOVEEXIT
echo Removing Leftover Microsoft Edge Files And Checking Registry Fix...
rmdir /S /Q C:\ProgramData\Microsoft\EdgeUpdate >NUL 2>&1
rmdir /S /Q %homepath%\AppData\Local\Microsoft\WindowsApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe >NUL 2>&1
rmdir /S /Q %homepath%\AppData\Local\Microsoft\Edge >NUL 2>&1
rmdir /S /Q %homepath%\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe >NUL 2>&1
rmdir /S /Q %homepath%\AppData\Local\Packages\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe >NUL 2>&1
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EdgeUpdate /V DoNotUpdateToEdgeWithChromium >NUL 2>&1
IF %ERRORLEVEL%==0 GOTO :FINISH
IF %ERRORLEVEL%==1 GOTO :REGISTRYSETUP

:REMOVERUN
echo Removing Leftover Microsoft Edge Files And Checking Registry Fix...
rmdir /S /Q C:\ProgramData\Microsoft\EdgeUpdate >NUL 2>&1
rmdir /S /Q %homepath%\AppData\Local\Microsoft\WindowsApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe >NUL 2>&1
rmdir /S /Q %homepath%\AppData\Local\Microsoft\Edge >NUL 2>&1
rmdir /S /Q %homepath%\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe >NUL 2>&1
rmdir /S /Q %homepath%\AppData\Local\Packages\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe >NUL 2>&1
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EdgeUpdate /V DoNotUpdateToEdgeWithChromium >NUL 2>&1
IF %ERRORLEVEL%==0 GOTO :NEXT
IF %ERRORLEVEL%==1 GOTO :REGISTRYSETUP

:REGISTRYSETUP
CLS
echo This section of the script will add a D-Word key that prohibits Edge from reinstalling.
echo.
echo The following options can be chosen:
echo.
echo ----------------------------------------
echo      [1] Install
echo.
echo      [2] Skip And Start Next Script
echo ----------------------------------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :NEXT
IF ERRORLEVEL 1 GOTO :REGEDIT

:REGEDIT
echo Disabling Edge Update And Reinstallation...
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EdgeUpdate /V DoNotUpdateToEdgeWithChromium /T REG_DWORD /D 00000001 /F
GOTO :NEXT

:NEXT
echo Opening Next Script: Junk Files Removal...
call "%~dp0/14 Remove Junk Files.bat"

:FINISH
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:ABORT
echo The script has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe