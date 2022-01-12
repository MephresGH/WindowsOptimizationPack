@echo off
GOTO :CHECKPERMS

:CHECKPERMS
    echo Administrative Permissions Required. Detecting Permissions...

    NET SESSION >nul 2>&1
    IF %errorLevel% == 0 (
        echo Success: Administrative Permissions Confirmed. Continuing As Usual... && GOTO :FILECHECK
    ) ELSE (
        echo Current Permissions Inadequate. Requesting Elevated Rights... && (powershell start -verb runas '%0' am_admin & exit /b)
    )

:FILECHECK
CLS
IF EXIST "%~dp0..\bin\Standby Cleaner Lite.exe" GOTO :PROMPT (
) ELSE (
echo ERROR: no required files found. Closing terminal... && timeout /t 3
taskkill /f /im cmd.exe
)

:PROMPT
SCHTASKS /CREATE /TN "Standby Cleaner Lite" /TR "%~dp0..\bin\Standby Cleaner Lite.exe" /SC MINUTE /MO 5 /RU SYSTEM /RL HIGHEST /F >NUL 2>&1
SCHTASKS /QUERY /TN "Standby Cleaner Lite" /XML > "%~dp0..\bin\StandbyCleanerLite.xml"
cd /d "%~dp0..\bin"
powershell -Command "(gc 'StandbyCleanerLite.xml' -raw) -replace '<Settings>', '<Settings> <Hidden>true</Hidden>' | Set-Content 'StandbyCleanerLite.xml'"
SCHTASKS /END /TN "Standby Cleaner Lite" >NUL 2>&1
SCHTASKS /DELETE /TN "Standby Cleaner Lite" /F >NUL 2>&1
SCHTASKS /CREATE /XML "StandbyCleanerLite.xml" /TN "Standby Cleaner Lite"
SCHTASKS /RUN /TN "Standby Cleaner Lite"
DEL "StandbyCleanerLite.xml" /F >NUL 2>&1
pause