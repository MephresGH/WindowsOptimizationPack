@ECHO off
CLS
IF EXIST %homepath%\Downloads\Tron* GOTO :FOUND
IF NOT EXIST %homepath%\Downloads\Tron* GOTO :PROMPT

:FOUND
ECHO Tron Script Found. Cancelling Script...
GOTO :NEWSCRIPT

:DOWNLOADSETUP
ECHO Tron Script Not Found. Requesting Permissions...
GOTO :PROMPT

:PROMPT
CLS
echo ==================================================================================
echo                               TRON SCRIPT DOWNLOADER
echo ==================================================================================
echo.
echo This script will download the Tron script, which is focused on fixing Windows and removing a vast majority of viruses.
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
IF ERRORLEVEL 3 GOTO :ABORT
IF ERRORLEVEL 2 GOTO :DOWNLOADRUN
IF ERRORLEVEL 1 GOTO :DOWNLOADEXIT

:DOWNLOADEXIT
start https://bmrf.org/repos/tron
GOTO :FINISH

:DOWNLOADRUN
start https://bmrf.org/repos/tron
GOTO :NEXT

:NEXT
echo Opening Next Script: 7-Zip Installer...
call "%~dp0/8 7-Zip Installer.bat"

:FINISH
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:ABORT
echo The script has been stopped. No user permissions given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe