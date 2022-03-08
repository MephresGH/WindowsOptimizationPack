@ECHO off
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
echo ====================================================================================
echo                               DISABLE WINDOWS SERVICES
echo ====================================================================================
echo.
echo This script will disable unnecessary, bloating Windows program services.
echo.
echo The following options can be chosen:
echo.
echo ------------------------------
echo      [1] Manual Setup
echo.
echo      [2] Automatic Setup
echo.
echo      [3] Activation Setup
echo.
echo      [4] Abort
echo ------------------------------
echo.
CHOICE /C 1234 /N /M "Enter Your Choice:"
IF ERRORLEVEL 4 GOTO :NOPERMS
IF ERRORLEVEL 3 GOTO :ENABLE
IF ERRORLEVEL 2 GOTO :AUTO
IF ERRORLEVEL 1 GOTO :MANUAL

:ENABLE
echo Entered Enable section of script.
echo.
echo The following options can be chosen:
echo.
echo -----------------------------
echo      [1] Manual Setup
echo.
echo      [2] Automatic Setup
echo.
echo      [3] Abort
echo -----------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:"
IF ERRORLEVEL 3 GOTO :NOPERMS
IF ERRORLEVEL 2 GOTO :AUTOENABLE
IF ERRORLEVEL 1 GOTO :MANUALENABLE

:MANUALENABLE
echo Entered Manual Setup.
echo.
echo Do you want to enable Windows Search?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :TWOENABLE
IF ERRORLEVEL 1 GOTO :ONEENABLE

:MANUAL
echo Entered Manual Setup.
echo.
echo Do you want to disable Windows Search?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :TWO
IF ERRORLEVEL 1 GOTO :ONE

:ONE
echo Disabling Windows Search...
sc stop "WSearch"
sc config "WSearch" start= disabled
echo Windows Search has been disabled.

:TWO
echo.
echo Do you want to disable Superfetch?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :FOUR
IF ERRORLEVEL 1 GOTO :THREE

:THREE
echo Disabling Superfetch...
sc stop "SysMain"
sc config "SysMain" start= disabled
echo Superfetch has been disabled.

:FOUR
echo.
echo Do you want to disable Bluetooth Services?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :SIX
IF ERRORLEVEL 1 GOTO :FIVE

:FIVE
echo Disabling Bluetooth Services...
sc stop "BTAGService"
sc config "BTAGService" start= disabled
sc stop "bthserv"
sc config "bthserv" start= disabled
echo Disabled Bluetooth Services.

:SIX
echo.
echo Do you want to disable Xbox Live Networking?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :EIGHT
IF ERRORLEVEL 1 GOTO :SEVEN

:SEVEN
echo Disabling Xbox Live Networking...
sc stop "XboxNetApiSvc"
sc config "XboxNetApiSvc" start= disabled
echo Disabled Xbox Live Networking.

:EIGHT
echo.
echo Do you want to disable Windows Quality Audio?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :TEN
IF ERRORLEVEL 1 GOTO :NINE

:NINE
echo Disabling Windows Quality Audio Service...
sc stop "QWAVE"
sc config "QWAVE" start= disabled
echo Disabled Windows Quality Audio Service.

:TEN
echo.
echo Do you want to disable Windows Telemetry?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :NEWSCRIPT
IF ERRORLEVEL 1 GOTO :ELEVEN

:TWELVE
SET /P AREYOUSURE=Do you want to disable Windows Telemetry? (Y/N) 
IF /I "%AREYOUSURE%" EQU "Y" GOTO :THIRTEEN
IF /I "%AREYOUSURE%" EQU "N" GOTO :NEWSCRIPT
IF /I "%AREYOUSURE%" NEQ "Y,N" echo Invalid input detected. Repeating prompt.
GOTO :TWELVE

:ELEVEN
echo Disabling Telemetry...
sc stop "dmwappushservice"
sc config "dmwappushservice" start= disabled
sc stop "DiagTrack"
sc config "DiagTrack" start= disabled
echo Telemetry Disabled.

:AUTO
echo Entered Auto Setup.
sc stop "WSearch"
sc config "WSearch" start= disabled
sc stop "SysMain"
sc config "SysMain" start= disabled
sc stop "BTAGService"
sc config "BTAGService" start= disabled
sc stop "DiagTrack"
sc config "DiagTrack" start= disabled
sc stop "bthserv"
sc config "bthserv" start= disabled
sc stop "XboxNetApiSvc"
sc config "XboxNetApiSvc" start= disabled
sc stop "QWAVE"
sc config "QWAVE" start= disabled
GOTO :NEWSCRIPT

:ONEENABLE
echo Enabling Windows Search...
sc config "WSearch" start= demand
sc start "WSearch"
echo Windows Search has been enabled.

:TWOENABLE
echo.
echo Do you want to enable Superfetch?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :FOURENABLE
IF ERRORLEVEL 1 GOTO :THREEENABLE

:THREEENABLE
echo Enabling Superfetch...
sc config "SysMain" start= demand
sc start "SysMain"
echo Superfetch has been enabled.

:FOURENABLE
echo.
echo Do you want to enable Bluetooth Services?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :SIXENABLE
IF ERRORLEVEL 1 GOTO :FIVEENABLE

:FIVEENABLE
echo Enabling Bluetooth Services...
sc config "BTAGService" start= demand
sc start "BTAGService"
sc config "bthserv" start= demand
sc start "bthserv"
echo Enabled Bluetooth Services.

:SIXENABLE
echo.
echo Do you want to enable Xbox Live Networking?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :EIGHTENABLE
IF ERRORLEVEL 1 GOTO :SEVENENABLE

:SEVENENABLE
echo Enabling Xbox Live Networking...
sc config "XboxNetApiSvc" start= demand
sc start "XboxNetApiSvc"
echo Enabled Xbox Live Networking.

:EIGHTENABLE
echo.
echo Do you want to enable Windows Quality Audio?
echo.
echo -----------------
echo      [1] Yes
echo.
echo      [2] No
echo -----------------
echo.
CHOICE /C 12 /N /M "Enter Your Choice:"
IF ERRORLEVEL 2 GOTO :NEWSCRIPT
IF ERRORLEVEL 1 GOTO :NINEENABLE

:NINEENABLE
echo Enabling Windows Quality Audio Service...
sc config "QWAVE" start= demand
sc start "QWAVE"
echo Enabled Windows Quality Audio Service.

:AUTOENABLE
echo Entered Auto Setup.
sc config "WSearch" start= demand
sc start "WSearch"
sc config "SysMain" start= demand
sc start "SysMain"
sc config "BTAGService" start= demand
sc start "BTAGService"
sc config "bthserv" start= demand
sc start "bthserv"
sc config "XboxNetApiSvc" start= demand
sc start "XboxNetApiSvc"
sc config "QWAVE" start= demand
sc start "QWAVE"
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
IF ERRORLEVEL 2 GOTO :END
IF ERRORLEVEL 1 GOTO :NEXT

:NEXT
echo Opening Next Script: Mouse Acceleration Fix, Regsitry Tweaks And MSI Mode...
call "%~dp0/9 Enhance Pointer Precision Off & 6-11.lnk"
pause
call "%~dp0/10 Registry Tweaks.reg"
call "%~dp0/11 MSI Mode Utility.bat"

:END
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:NOPERMS
echo The script has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe