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
echo ==============================================================================
echo                               JUNK FILES CLEANUP
echo ==============================================================================
echo.
echo This script will purge all caches and temporary files. Most programs will be closed.
echo.
echo The following options can be chosen:
echo.
echo ------------------------
echo      [1] Run Script
echo.
echo      [2] Abort
echo ------------------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :END
IF ERRORLEVEL 1 GOTO :CONTINUE

:CONTINUE
echo Temporarily Enabling Windows Updates...
sc config "wuauserv" start= demand
sc start "wuauserv"
echo Enabling Update Orchestrator Service...
sc config "UsoSvc" start= demand
sc start "UsoSvc"

echo Clearing Microsoft Store Cache...
wsreset.exe
echo Deactivate everything possible in the Windows Store settings.
pause
GOTO :CLOSE

:CLOSE
echo Removing Leftover Files And Closing Programs...
PowerShell -command "(get-process | ? { $_.mainwindowtitle -ne '' -and $_.processname -ne 'cmd' } )| stop-process"
taskkill /f /t /fi "status eq not responding" >NUL 2>&1
taskkill /f /t /im steam.exe >NUL 2>&1
taskkill /f /t /im "NVDisplay.Container.exe" >NUL 2>&1
taskkill /f /t /im winstore.app.exe >NUL 2>&1
taskkill /f /im MSIAfterburner.exe >NUL 2>&1
taskkill /f /im RTSS.exe >NUL 2>&1
taskkill /f /im explorer.exe >NUL 2>&1
rmdir /S /Q "%homepath%\AppData\Local\mbamtray" >NUL 2>&1
rmdir /S /Q "%homepath%\AppData\Local\OO Software" >NUL 2>&1
rmdir /S /Q "C:\Program Files\NVIDIA Corporation\Installer2" >NUL 2>&1
rmdir /S /Q C:\logs >NUL 2>&1
rmdir /S /Q C:\Temp >NUL 2>&1
rmdir /S /Q C:\PerfLogs >NUL 2>&1
rmdir /S /Q C:\NVIDIA >NUL 2>&1
rmdir /S /Q C:\AMD >NUL 2>&1
rmdir /S /Q C:\ProgramData\Sophos >NUL 2>&1
rmdir /S /Q C:\ProgramData\Malwarebytes >NUL 2>&1
GOTO :SERVICES

:SERVICES
echo This section of the script will disable Windows Updates.
echo.
echo The following options can be chosen:
echo.
echo -------------------------------------
echo      [1] Disable Windows Updates
echo.
echo      [2] Skip Script Section
echo -------------------------------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :CLEAR
IF ERRORLEVEL 1 GOTO :DISABLE

:SERVICES
SET /P AREYOUSURE=Do you want to disable Windows Updates? (Y/N) 
IF /I "%AREYOUSURE%" EQU "Y" GOTO :DISABLE
IF /I "%AREYOUSURE%" EQU "N" GOTO :CLEAR
IF /I "%AREYOUSURE%" NEQ "Y,N" echo Invalid input detected. Repeating prompt.
GOTO :SERVICES

:DISABLE
echo Disabling Windows Updates...
sc stop "wuauserv"
sc config "wuauserv" start= disabled
echo Disabling Update Orchestrator Service...
sc stop "UsoSvc"
sc config "UsoSvc" start= disabled
echo Updating Time Settings...
sc config "W32Time" start= demand
sc start "W32Time"
echo Disabling Windows Time Auto-Configuration...
sc config W32Time start= disabled
sc stop W32Time
GOTO :CLEAR

:CLEAR
echo Cleaning Temporary Files And Cached Data...
takeown /F %homepath%\AppData\Local\D3DSCache >NUL 2>&1
icacls %homepath%\AppData\Local\D3DSCache /grant Everyone:F >NUL 2>&1
takeown /F "C:\ProgramData\NVIDIA Corporation" >NUL 2>&1
icacls "C:\ProgramData\NVIDIA Corporation\NV_Cache /grant Everyone:F" >NUL 2>&1
takeown /F %homepath%\AppData\Local\Microsoft\Windows\Explorer >NUL 2>&1
icacls %homepath%\AppData\Local\Microsoft\Windows\Explorer /grant Everyone:F >NUL 2>&1
DEL /F /S /Q /A %homepath%\AppData\Local\NVIDIA\* >NUL 2>&1
DEL /F /S /Q /A "%homepath%\AppData\Local\NVIDIA Corporation\NV_Cache\*" >NUL 2>&1
DEL /F /S /Q /A "C:\ProgramData\NVIDIA Corporation\NV_Cache\*" >NUL 2>&1
DEL /F /S /Q /A %homepath%\AppData\Local\AMD\GLCache\* >NUL 2>&1
DEL C:\bootex.txt >NUL 2>&1
DEL C:\custom-lists.ps1 >NUL 2>&1
NET STOP TrustedInstaller >NUL 2>&1
DEL /F /S /Q /A C:\Windows\Temp\cab* >NUL 2>&1
DEL /F /S /Q /A C:\Windows\Logs\CBS >NUL 2>&1
DEL /F /S /Q /A C:\Windows\Logs\WindowsUpdate >NUL 2>&1
NET START TrustedInstaller >NUL 2>&1
DEL /F /S /Q /A %homepath%\AppData\Local\D3DSCache\*
DEL /F /S /Q /A C:\Windows\SoftwareDistribution\Download\*
DEL /F /S /Q /A C:\Windows\Temp\*
DEL /F /S /Q /A C:\Windows\Logs\DISM\*
DEL /F /S /Q /A %homepath%\AppData\Local\Temp\*
GOTO :CACHE

:CACHE
echo Deleting System Cache And Disabling Hibernation...
cd /d %userprofile%\AppData\Local\Microsoft\Windows\Explorer
attrib -h iconcache_*.db
attrib -h thumbcache_*.db 
DEL /F /S /Q /A iconcache_*.db
DEL /F /S /Q /A thumbcache_*.db
DEL /F /S /Q /A %LocalAppData%\Microsoft\Windows\Explorer\*
powercfg -h off
%windir%\System32\cmd.exe /c "echo off | clip"
wmic service where "name like '%%cbdhsvc%%'" call stopservice
wmic service where "name like '%%cbdhsvc%%'" call startservice
GOTO :GAMEBARCHECK

:GAMEBARCHECK
echo Deleting GameBarPresenceWriter1...
IF NOT EXIST "C:\Windows\System32\GameBarPresenceWriter1.exe" GOTO :GAMEBAR
takeown /F "C:\Windows\System32\GameBarPresenceWriter1.exe"
icacls "C:\Windows\System32\GameBarPresenceWriter1.exe" /grant Everyone:F
del "C:\Windows\System32\GameBarPresenceWriter1.exe"
:GAMEBAR
IF NOT EXIST "C:\Windows\SysWOW64\GameBarPresenceWriter1.exe" GOTO :SKIP
takeown /F "C:\Windows\SysWOW64\GameBarPresenceWriter1.exe"
icacls "C:\Windows\SysWOW64\GameBarPresenceWriter1.exe" /grant Everyone:F
del "C:\Windows\SysWOW64\GameBarPresenceWriter1.exe"
GOTO :SKIP

:SKIP
echo GameBarPresenceWriter1 Not Found. Skipping Procedure...
echo Clearing System Cache...
ipconfig /release
ipconfig /flushdns
netsh int ip reset
netsh winsock reset
netsh branchcache flush
ipconfig /renew
GOTO :PURGESHADOWSETUP

:PURGESHADOWSETUP
CLS
echo This section of the script will remove all, the oldest, or no shadow backups from the current installation.
echo.
echo The following options can be chosen:
echo.
echo --------------------------------------
echo      [1] Purge All Shadow Copies
echo.
echo      [2] Purge Oldest Shadow Copy
echo.
echo      [3] Skip This Section
echo --------------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:"
IF ERRORLEVEL 3 GOTO :DISKCLEANUP
IF ERRORLEVEL 2 GOTO :PURGESHADOWOLDEST
IF ERRORLEVEL 1 GOTO :PURGESHADOWALL

:PURGESHADOWALL
echo Purging All Shadow Copies...
vssadmin delete shadows /For=C: /All /Quiet
taskkill /f /t /im VSSVC.exe >NUL 2>&1
SCHTASKS /END /TN "VSS" >NUL 2>&1
GOTO :DISKCLEANUP

:PURGESHADOWOLDEST
echo Purging Oldest Shadow Copies...
vssadmin delete shadows /For=C: /Oldest /Quiet
taskkill /f /t /im VSSVC.exe >NUL 2>&1
SCHTASKS /END /TN "VSS" >NUL 2>&1
GOTO :DISKCLEANUP

:DISKCLEANUP
echo Starting Disk Cleanup...
start /wait %systemroot%\System32\cleanmgr.exe /sagerun:100
start /wait %systemroot%\System32\cleanmgr.exe /sagerun:65565

:DEVICECLEANUP
echo Clearing Temporary- And Disconnected Devices...
cd /d "%~dp0/files/DeviceCleanup
"DeviceCleanupCmd.exe" -s *
GOTO :BLEACHBIT

:BLEACHBIT
echo Running BleachBit And Purging Last Leftovers...
cd /d "%~dp0/files/BleachBit"
bleachbit_console.exe -v
bleachbit.exe
bleachbit_console.exe -s >NUL 2>&1
rmdir /S /Q "%userprofile%/.dbus-keyrings"
taskkill /f /im bleachbit.exe >NUL 2>&1
taskkill /f /im bleachbit_console.exe >NUL 2>&1
explorer
GOTO :NEWSCRIPT

:NEWSCRIPT
CLS
echo Do you want to run the next script?
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
echo Opening Next Script: HPET And Memory Fix...
call "%~dp0/15 Fix HPET And Memory.bat"

:FINISH
echo The script has been finished. Terminating console in 20 seconds...
timeout /t 20
taskkill /f /im cmd.exe

:END
echo The script has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe