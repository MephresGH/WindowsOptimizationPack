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
echo ====================================================================================
echo                               DISPLAY DRIVER INSTALLER
echo ====================================================================================
echo.
echo This script will install a corresponding driver for your graphics card.
echo.
echo The following options can be chosen:
echo.
echo --------------------
echo      [1] NVIDIA
echo.
echo      [2] AMD
echo.
echo      [3] Intel
echo --------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:" 
IF ERRORLEVEL 3 GOTO :INTEL
IF ERRORLEVEL 2 GOTO :AMD
IF ERRORLEVEL 1 GOTO :NVIDIA

:AMD
IF EXIST "C:\Program Files\AMD" echo Drivers Found. Cancelling Script... GOTO :NEWSCRIPT
IF NOT EXIST "C:\Program Files\AMD" GOTO :AMDSETUP

    :AMDSETUP
    CLS
    echo ====================================================================================
    echo                               DISPLAY DRIVER INSTALLER
    echo ====================================================================================
    echo.
    powershell -command write-host -fore Red This section of the script will install a corresponding driver for your AMD graphics card.
    echo.
    echo The following options can be chosen:
    echo.
    echo -----------------------------
    echo      [1] Download Driver
    echo.
    echo      [2] Abort
    echo -----------------------------
    echo.
    CHOICE /C 12 /N /M "Enter Your Choice:" 
    IF ERRORLEVEL 2 GOTO :ABORT
    IF ERRORLEVEL 1 GOTO :AMDDOWNLOAD

    :AMDDOWNLOAD
    start https://www.amd.com/en/support
    echo The script has been finished. Download the fitting driver and proceed from there.
    echo Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

:INTEL
IF EXIST "C:\Program Files\Intel" GOTO :NULL
IF NOT EXIST "C:\Program Files\Intel" GOTO :INTELSETUP

    :INTELSETUP
    CLS
    echo ====================================================================================
    echo                               DISPLAY DRIVER INSTALLER
    echo ====================================================================================
    echo.
    powershell -command write-host -fore Blue This section of the script will install a corresponding driver for your Intel graphics card.
    echo.
    echo The following options can be chosen:
    echo.
    echo -----------------------------
    echo      [1] Download Driver
    echo.
    echo      [2] Abort
    echo -----------------------------
    echo.
    CHOICE /C 12 /N /M "Enter Your Choice:" 
    IF ERRORLEVEL 2 GOTO :ABORT
    IF ERRORLEVEL 1 GOTO :INTELDOWNLOAD

    :INTELDOWNLOAD
    start https://www.intel.com/content/www/us/en/support/products/80939/graphics.html#identify-your-product
    echo The script has been finished. Download the fitting driver and proceed from there.
    echo Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

:NVIDIA
IF NOT EXIST "C:\Program Files (x86)\NVIDIA Corporation" GOTO :NVIDIASETUP
IF EXIST "C:\Program Files (x86)\NVIDIA Corporation" GOTO :NULL

    :NVIDIASETUP
    CLS
    echo ====================================================================================
    echo                               DISPLAY DRIVER INSTALLER
    echo ====================================================================================
    echo.
    powershell -command write-host -fore Green This section of the script will install a corresponding driver for your NVIDIA graphics card.
    echo.
    echo The following options can be chosen:
    echo.
    echo -----------------------------
    echo      [1] NVCleanstall
    echo.
    echo      [2] Direct Download
    echo.
    echo      [3] Abort
    echo -----------------------------
    echo.
    CHOICE /C 123 /N /M "Enter Your Choice:" 
    IF ERRORLEVEL 3 GOTO :ABORT
    IF ERRORLEVEL 2 GOTO :NVIDIADOWNLOAD
    IF ERRORLEVEL 1 GOTO :CLEANINSTALL

    :CLEANINSTALL
    echo =========================================================================================
    echo                               NVCLEANSTALL DRIVER INSTALLER
    echo =========================================================================================
    echo.
    powershell -command write-host -fore DarkGreen This section of the script will install a corresponding driver for your NVIDIA graphics card.
    echo.
    echo The following options can be chosen:
    echo.
    echo -----------------------------
    echo      [1] Run With Instructions
    echo.
    echo      [2] Run Without Instructions
    echo.
    echo      [3] Abort
    echo -----------------------------
    echo.
    CHOICE /C 123 /N /M "Enter Your Choice:" 
    IF ERRORLEVEL 3 GOTO :ABORT
    IF ERRORLEVEL 2 GOTO :NOINSTRUCTIONS
    IF ERRORLEVEL 1 GOTO :INSTRUCTIONS

    :INSTRUCTIONS
    ECHO Opening Instructions, Close After Inspection...
    "%~dp0/Files/NVCleanstall/ReadMe.txt"
    echo Starting NVIDIA Driver Installer And Waiting For Installation Process To Be Finished...
    "%~dp0/Files/NVCleanstall/NVCleanstall.exe"
    GOTO :FINISH

    :NOINSTRUCTIONS
    echo Toggled Manual Install.
    echo Starting NVIDIA Driver Installer And Waiting For Installation Process To Be Finished...
    "%~dp0/Files/NVCleanstall/NVCleanstall.exe"
    GOTO :FINISH    

    :FINISH
    echo The installation has been finished. Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

    :NVIDIADOWNLOAD
    echo Opening Advanced NVIDIA Driver Site...
    start https://www.nvidia.com/Download/Find.aspx?lang=en-us
    GOTO :FINISHEX

    :FINISHEX
    echo The script has been finished. Installation can be done outside of script now.
    echo Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

    :NULL
    echo The script has been stopped, a graphics card driver was found.
    echo Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

    :ABORT
    echo The script has stopped, no user permission given. Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe