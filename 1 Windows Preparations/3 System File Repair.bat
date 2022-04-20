@ECHO off
CLS
GOTO :CHECKPERMS

:CHECKPERMS
    echo Administrative Permissions Required. Requesting Permissions...

    NET SESSION >nul 2>&1
    IF %errorLevel% == 0 (
        echo Success: Administrative Permissions Confirmed. Continuing As Usual... && GOTO :MESSAGE
    ) ELSE (
        echo Current Permissions Inadequate. Requesting Elevated Rights... && (powershell start -verb runas '%0' am_admin & exit /b)
    )

:MESSAGE
CLS
echo =====================================================================================
echo                               SYSTEM FILE REPAIR SCRIPT
echo =====================================================================================
echo.
echo This script will check the integrity of your device and restart Windows within 5 seconds.
echo.
echo The following options can be chosen:
echo.
echo --------------------------------
echo      [1] Run And Exit
echo.
echo      [2] Run Next Script
echo.
echo      [3] Abort
echo --------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:" 
IF ERRORLEVEL 3 GOTO :NOPERMS
IF ERRORLEVEL 2 GOTO :NEXT
IF ERRORLEVEL 1 GOTO :RUNREPAIR

:RUNREPAIR
CLS
echo Entering First Option...
echo.
echo Updating Windows Defender And Running Basic Antivirus Scan...
cd /d "C:\ProgramData\Microsoft\Windows Defender\Platform\4.*
MpCmdRun -SignatureUpdate >NUL 2>&1
MpCmdRun -Scan -ScanType 1 >NUL 2>&1
MpCmdRun -Scan -ScanType -BootSectorScan >NUL 2>&1
echo. 
echo Repairing Potential Errors...
cd /d C:\Windows\system32
chkdsk
sfc /scannow
timeout /t 3 /nobreak
DISM /Online /Cleanup-Image /CheckHealth
timeout /t 3 /nobreak
DISM /Online /Cleanup-Image /ScanHealth
timeout /t 3 /nobreak
DISM /Online /Cleanup-Image /RestoreHealth
timeout /t 3 /nobreak
sfc /scannow
timeout /t 3 /nobreak
chkdsk /r
shutdown /r /t 5
GOTO :NEXT

:NEXT
CLS
echo Opening Next Script: C++ Installer...
call "%~dp0/4 C++ Installer.bat"

:FINISH
CLS
echo The script was run successfully.
echo The computer will be restarted in 5 seconds. Please continue the optimizations after the restart.
timeout /t 3
taskkill /f /im cmd.exe

:NOPERMS
echo The process has stopped, no user permission given. Terminating script in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe