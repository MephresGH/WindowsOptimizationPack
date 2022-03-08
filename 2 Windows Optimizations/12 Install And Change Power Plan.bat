@ECHO off

:PROMPT
CLS
echo =======================================================================================
echo                               CUSTOM POWER PLAN INSTALLER
echo =======================================================================================
echo.
echo This script will install a custom power plan with settings optimized for workflow and gaming.
echo.
echo The following options can be chosen:
echo.
echo ----------------------------------
echo      [1] Install And Continue
echo.
echo      [2] Install And Exit
echo.
echo      [3] Abort
echo ----------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:"
IF ERRORLEVEL 3 GOTO :ABORT
IF ERRORLEVEL 2 GOTO :POWERPLANEXIT
IF ERRORLEVEL 1 GOTO :POWERPLANRUN

:POWERPLANRUN
echo Installing Bitsum Highest Performance Power Plan...
powercfg /import "%~dp0/files/Power Plan/Bitsum Highest Performance.pow" 77777777-7777-7777-7777-777777777777 >NUL 2>&1
echo Installed. Setting Bitsum Power Plan As Active...
powercfg /setactive "77777777-7777-7777-7777-777777777777" >NUL 2>&1
echo Set Bitsum Power Plan As Active.
powercfg.cpl
GOTO :NEXT

:POWERPLANEXIT
echo Installing Bitsum Highest Performance Power Plan...
powercfg /import "%~dp0/files/Power Plan/Bitsum Highest Performance.pow" 77777777-7777-7777-7777-777777777777 >NUL 2>&1
echo Installed. Setting Bitsum Power Plan As Active...
powercfg /setactive "77777777-7777-7777-7777-777777777777" >NUL 2>&1
echo Set Bitsum Power Plan As Active.
powercfg.cpl
GOTO :FINISH

:NEXT
echo Opening Next Script: Edge Junk Files Removal...
call "%~dp0/13 Remove Junk Files.bat"
taskkill /f /im cmd.exe

:FINISH
echo The installation process has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:ABORT
echo The script has been stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe