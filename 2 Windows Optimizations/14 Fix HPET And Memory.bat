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
echo ==============================================================================
echo                               HPET AND MEMORY FIX
echo ==============================================================================
echo.
echo This script will optimize Windows latency and timers. It will automatically reboot your system.
echo.
echo The following options can be chosen:
echo -----------------------------
echo      [1] Run Script
echo.
echo      [2] Run Next Script
echo.
echo      [3] Abort
echo -----------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:"
IF ERRORLEVEL 3 GOTO :ABORT
IF ERRORLEVEL 2 GOTO :NEXT
IF ERRORLEVEL 1 GOTO :SETUP

:SETUP
echo Preparing HPET...
cd /d "%~dp0\Files\Timer Resolution & Empty Standby List"
SetTimerResolutionService -uninstall >NUL 2>&1
SCHTASKS /END /TN "STR" >NUL 2>&1
SCHTASKS /DELETE /TN "STR" /F >NUL 2>&1
SCHTASKS /END /TN "Empty Standby Memory" >NUL 2>&1
SCHTASKS /DELETE /TN "Empty Standby Memory" /F >NUL 2>&1
SCHTASKS /END /TN "Empty Standby List" >NUL 2>&1
SCHTASKS /DELETE /TN "Empty Standby List" /F >NUL 2>&1
SCHTASKS /END /TN "Emptystandbylist" >NUL 2>&1
SCHTASKS /DELETE /TN "Emptystandbylist" /F >NUL 2>&1
SCHTASKS /END /TN "Empty" >NUL 2>&1
SCHTASKS /DELETE /TN "Empty" /F >NUL 2>&1
SCHTASKS /END /TN "Minimal Standby List Cleaner" >NUL 2>&1
SCHTASKS /DELETE /TN "Minimal Standby List Cleaner" /F >NUL 2>&1
SCHTASKS /END /TN "Standby Cleaner Lite" >NUL 2>&1
SCHTASKS /DELETE /TN "Standby Cleaner Lite" /F >NUL 2>&1
SCHTASKS /END /TN "ISLC" >NUL 2>&1
SCHTASKS /DELETE /TN "ISLC" /F >NUL 2>&1
SCHTASKS /END /TN "Intelligent StandbyList Cleaner" >NUL 2>&1
SCHTASKS /DELETE /TN "Intelligent StandbyList Cleaner" /F >NUL 2>&1
taskkill /f /im "Intelligent standby list cleaner ISLC.exe" >NUL 2>&1
taskkill /f /im SetTimerResolutionService.exe >NUL 2>&1
taskkill /f /im EmptyStandbyList.exe >NUL 2>&1
taskkill /f /im "Minimal Standby List Cleaner" >NUL 2>&1
taskkill /f /im "Minimal Timer.exe" >NUL 2>&1
taskkill /f /im TimerResolution.exe >NUL 2>&1
bcdedit /set useplatformclock yes
bcdedit /set useplatformtick yes
bcdedit /set disabledynamictick no
bcdedit /set tscsyncpolicy Enhanced
timeout /t 5 /nobreak
GOTO :HPET

:HPET
echo Fixing HPET Permanently...
lodctr /r
lodctr /r | more
SCHTASKS /CREATE /TN "Empty Standby List" /TR "%~dp0Files\Timer Resolution & Empty Standby List\EmptyStandbyList.exe" /SC MINUTE /MO 5 /RU SYSTEM /RL HIGHEST >NUL 2>&1
SCHTASKS /QUERY /TN "Empty Standby List" /XML > "%~dp0Files\Timer Resolution & Empty Standby List\EmptyStandbyList.xml"
cd /d "%~dp0Files\Timer Resolution & Empty Standby List"
powershell "(gc 'EmptyStandbyList.xml' -raw) -replace '<Settings>', '<Settings> <Hidden>true</Hidden>' | Set-Content 'EmptyStandbyList.xml'"
SCHTASKS /END /TN "Empty Standby List" >NUL 2>&1
SCHTASKS /DELETE /TN "Empty Standby List" /F >NUL 2>&1
SCHTASKS /CREATE /XML "EmptyStandbyList.xml" /TN "Empty Standby List"
SCHTASKS /RUN /TN "Empty Standby List"
DEL "EmptyStandbyList.xml" /F >NUL 2>&1
start "Start Minimal Resolution" "TimerResolution.exe"

:BCDEDIT
bcdedit /deletevalue useplatformclock
bcdedit /set useplatformtick no
bcdedit /set disabledynamictick yes
bcdedit /set tscsyncpolicy Default
GOTO :END

:NEXT
echo Opening Next Script: MSI Mode Utility...
call "%~dp0/15 Overclock Graphics Card And RTSS.bat"

:END
echo The script was run successfully. Restarting the computer in 5 seconds.
echo Thank you for using my optimization pack!
shutdown /r /t 5
timeout /t 3 /nobreak
taskkill /f /im cmd.exe

:ABORT
echo The script has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe