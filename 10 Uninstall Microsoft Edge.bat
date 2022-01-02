@ECHO off
CLS
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
IF EXIST "C:\Program Files (x86)\Microsoft\Edge\Application" ECHO Microsoft Edge found. Uninstalling... && GOTO :UNINSTALLER
IF NOT EXIST "C:\Program Files (x86)\Microsoft\Edge\Application" GOTO :NEXT

:UNINSTALLER
CLS
echo ======================================================================================
echo                               MICROSOFT EDGE UNINSTALLER
echo ======================================================================================
echo.
echo This script will uninstall Microsoft Edge. If you use Edge, you can skip this script.
echo The following options can be chosen:
echo.
echo ------------------------------------
echo      [1] Uninstall And Exit
echo.
echo      [2] Uninstall And Continue
echo.
echo      [3] Abort
echo ------------------------------------
echo.
CHOICE /C 123 /N /M "Enter Your Choice:" 
IF ERRORLEVEL 3 GOTO :END
IF ERRORLEVEL 2 GOTO :UNINSTALLRUN
IF ERRORLEVEL 1 GOTO :UNINSTALLEXIT

    :UNINSTALLEXIT
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\1*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\2*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\3*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\4*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\5*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\6*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\7*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\8*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\9*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    echo The script has been paused. The next script file will finish the procedure. Please continue.
    echo Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

    :UNINSTALLRUN
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\1*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\2*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\3*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\4*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\5*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\6*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\7*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\8*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    cd "C:\Program Files (x86)\Microsoft\Edge\Application\9*\Installer" >NUL 2>&1
    setup.exe --uninstall --system-level --verbose-logging --force-uninstall >NUL 2>&1
    echo The script has been paused. The next script file below will finish the procedure. Please continue.
    timeout /t 3
    GOTO :NEXT

    :NEXT
    echo Opening Next Script: Display Driver Uninstaller...
    call "%~dp0/11 Display Driver Uninstaller.bat"

    :NULL
    echo No Edge installations found. Exiting...
    echo The script has been finished, Microsoft Edge was not found. Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe

    :END
    echo The process has stopped, no user permission given. Terminating console in 3 seconds...
    timeout /t 3
    taskkill /f /im cmd.exe