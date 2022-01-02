@ECHO off
CLS
GOTO :STATUS

:STATUS
    powershell -command wmic.exe COMPUTERSYSTEM GET BootupState | findstr /i "fail-safe" >NUL 2>&1
    IF "%SAFEBOOT_OPTION%"=="MINIMAL" GOTO :PROMPT (
    ) ELSE (
    GOTO :SAFEMODE
    )

:SAFEMODE
CLS
echo ======================================================================================
echo                               DISPLAY DRIVER UNINSTALLER
echo ======================================================================================
echo.
powershell -command write-host -back Red ------------------------------!!!!!!!! WARNING !!!!!!!!-------------------------------
echo.
echo The computer is currently not booted into Safe Mode. It is highly advised to boot into Safe Mode to continue.
echo.
echo The following options can be chosen:
echo.
echo ------------------------------------
echo      [1] Boot Into Safe Mode
echo.
echo      [2] Ignore And Continue
echo.
echo      [3] Abort
echo ------------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:" 
IF ERRORLEVEL 3 GOTO :ABORT
IF ERRORLEVEL 2 GOTO :FORCECONTINUE
IF ERRORLEVEL 1 GOTO :SAFEBOOT

:SAFEBOOT
echo Choose "Troubleshoot", "Advanced Options" and "Startup Settings" in a moment.
echo You can press any key to continue once you are ready.
pause >NUL 2>&1
echo Booting the computer into Advanced Startup in 5 seconds...
shutdown /r /o /t 5
timeout /t 3
taskkill /f /im cmd.exe

:PROMPT
CLS
echo ======================================================================================
echo                               DISPLAY DRIVER UNINSTALLER
echo ======================================================================================
echo.
echo The computer is currently booted in Safe Mode. It is safe to run this program now.
echo.
echo The following options can be chosen:
echo.
echo ------------------------------------
echo      [1] Run DDU With Guide
echo.
echo      [2] Run DDU Without Guide
echo.
echo      [3] Abort
echo ------------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:" 
IF ERRORLEVEL 3 GOTO :END
IF ERRORLEVEL 2 GOTO :NOINSTRUCTIONS
IF ERRORLEVEL 1 GOTO :INSTRUCTIONS

:FORCECONTINUE
echo Starting DDU In Normal Boot Mode...
"%~dp0/Files/DDU/Display Driver Uninstaller.exe"
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:INSTRUCTIONS
echo Opening Image Guide, Close After Inspection...
"%~dp0/Files/DDU/Display Driver Uninstaller Settings.png"
echo Opening ReadMe, Close After Inspection...
"%~dp0/Files/DDU/ReadMe.txt"
echo Starting Display Driver Uninstaller...
"%~dp0/Files/DDU/Display Driver Uninstaller.exe"
echo The process has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:NOINSTRUCTIONS
echo Toggled No-Instructions Setup.
echo Starting Display Driver Uninstaller...
"%~dp0/Files/DDU/Display Driver Uninstaller.exe"
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:END
echo The script has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:ABORT
echo The script has stopped, Safe Mode boot was denied. Please boot into Safe Mode before continuing...
echo Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe