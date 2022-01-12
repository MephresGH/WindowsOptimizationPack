@ECHO off
:CHECK
IF EXIST "%~dp0/files/MSI Afterburner" IF EXIST "%~dp0/files/RivaTuner Statistics Server" GOTO :SETUP (
) ELSE (
GOTO :NULL
)

:SETUP
CLS
echo ==========================================================================================
echo                               MSI AFTERBURNER AND RTSS SETUP
echo ==========================================================================================
echo.
echo This script will start MSI Afterburner and RTSS for FPS Overlay purposes.
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
IF ERRORLEVEL 2 GOTO :ABORT
IF ERRORLEVEL 1 GOTO :RUN

:RUN
echo Starting Up MSI Afterburner And RTSS...
SCHTASKS /END /TN "MSIAfterburner" >NUL 2>&1
SCHTASKS /DELETE /TN "MSIAfterburner" /F >NUL 2>&1
taskkill /f /t /im MSIAfterburner.exe >NUL 2>&1
taskkill /f /t /im RTSS.exe >NUL 2>&1
taskkill /f /im EncoderServer.exe >NUL 2>&1
taskkill /f /im RTSSHooksLoader.exe >NUL 2>&1
taskkill /f /im RTSSHooksLoader64.exe >NUL 2>&1
start "Start MSI Afterburner" "%~dp0/files/MSI Afterburner/MSIAfterburner.exe"
start "Start RTSS" "%~dp0/files/RivaTuner Statistics Server/RTSS.exe"
GOTO :FINISH

:FINISH
echo The script was run successfully. Thank you for using my optimization pack!
timeout /t 3 /nobreak
taskkill /f /im cmd.exe

:ABORT
echo The script has been stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3 /nobreak
taskkill /f /im cmd.exe

:NULL
echo The script has been stopped, required files were not found. Terminating console in 3 seconds...
timeout /t 3 /nobreak
taskkill /f /im cmd.exe