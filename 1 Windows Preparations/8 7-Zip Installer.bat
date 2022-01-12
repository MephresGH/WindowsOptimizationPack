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
IF EXIST "C:\Program Files (x86)\7-Zip" GOTO :86UNINSTALL
IF EXIST "C:\Program Files\7-Zip" GOTO :64UNINSTALL
IF NOT EXIST "C:\Program Files (x86)\7-Zip" GOTO :NEXT
:NEXT
IF NOT EXIST "C:\Program Files\7-Zip" echo 7-Zip Not Found. Entering Setup... && GOTO :INSTALLER

    :64UNINSTALL
    echo 7-Zip 64-bit Found. Uninstalling...
    "C:\Program Files\7-Zip\Uninstall.exe"
    pause
    echo Stopping Explorer...
    taskkill /f /im explorer.exe
    timeout /t 3 /nobreak
    DEL /F /S /Q /A "C:\Program Files\7-Zip\*"
    rmdir /S /Q "C:\Program Files\7-Zip"
    explorer
    call "%~dp0/8 7-Zip Installer.bat"

    :86UNINSTALL
    echo 7-Zip 32-bit Found. Uninstalling...
    "C:\Program Files (x86)\7-Zip\Uninstall.exe"
    pause
    echo Stopping Explorer...
    taskkill /f /im explorer.exe
    timeout /t 3 /nobreak
    DEL /F /S /Q /A "C:\Program Files\7-Zip\*"
    rmdir /S /Q "C:\Program Files\7-Zip"
    explorer
    call "%~dp0/8 7-Zip Installer.bat"

    :INSTALLER
    echo ===========================================================================
    echo                               7-ZIP INSTALLER
    echo ===========================================================================
    echo.
    echo This script will install 7-Zip.
    echo.
    echo The following options can be chosen:
    echo.
    echo ------------------------------
    echo      [1] Select Version
    echo.
    echo      [2] Check SysInfo
    echo.
    echo      [3] Abort
    echo ------------------------------
    echo.
    CHOICE /C 123 /N /M "Enter Your Choice:" 
    IF ERRORLEVEL 3 GOTO :STOP
    IF ERRORLEVEL 2 GOTO :CHECKSYSTEM
    IF ERRORLEVEL 1 GOTO :INSTALLSELECT

    :CHECKSYSTEM
    cmd /c systeminfo | findstr /I type:
    echo.
    GOTO :INSTALLER

    :INSTALLSELECT
    echo You are in the installation menu.
    echo.
    echo You have the following options to choose from:
    echo.
    echo ------------------------------
    echo      [1] 64-Bit
    echo.
    echo      [2] 32-Bit
    echo.
    echo      [3] Abort
    echo ------------------------------
    echo.
    CHOICE /C 123 /N /M "Enter Your Choice:" 
    IF ERRORLEVEL 3 GOTO :STOP
    IF ERRORLEVEL 2 GOTO :86INSTALL
    IF ERRORLEVEL 1 GOTO :64INSTALL
    
    :64INSTALL
    "%~dp0/Files/7-Zip/7z2107-x64.exe"
    GOTO :NEXT

    :86INSTALL
    "%~dp0/Files/7-Zip/7z2107.exe"
    GOTO :NEXT

    :NEXT
    echo Opening Next Script: C++ Installer...
    call "%~dp0/9 Auto-Defrag Off.bat"

    :FINISH
    echo The script has been finished. Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

    :STOP
    echo The process has stopped, no user permission given. Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe