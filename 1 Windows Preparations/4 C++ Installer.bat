@ECHO off

:START
CLS
echo =========================================================================
echo                               C++ INSTALLER
echo =========================================================================
timeout /t 1 >NUL 2>&1
echo.
echo This script will purge or reinstall the newest versions of the Microsoft Visual C++ Runtimes And Redistributables.
echo.
timeout /t 1 >NUL 2>&1
echo To install the newest C++ Runtimes, you have to be connected to the internet.
echo.
timeout /t 1 >NUL 2>&1
powershell write-host -fore Red Note: You should ONLY uninstall Runtimes if you know what you are doing.
timeout /t 1 >NUL 2>&1
echo.
echo The following options can be chosen:
echo.
echo ------------------------------
echo      [1] Install And Exit
echo.
echo      [2] Install And Continue
echo.
echo      [3] Uninstall And Exit
echo.
echo      [4] Abort
echo ------------------------------
echo.
CHOICE /C 1234 /N /M "Enter Your Choice:"
IF ERRORLEVEL 4 GOTO :NOPERMS
IF ERRORLEVEL 3 GOTO :UNINSTALLER
IF ERRORLEVEL 2 GOTO :INSTALLER
IF ERRORLEVEL 1 GOTO :INSTALLEREXIT

:INSTALLER
echo.
mkdir "%~dp0/Files/C++ Installer"
echo Closing Background Applications...
PowerShell "(get-process | ? { $_.mainwindowtitle -ne '' -and $_.processname -ne 'cmd' } )| stop-process"
echo.
echo Downloading Newest AIO-Installer...
echo.
curl -L "https://kutt.it/vcppredist" -o "%~dp0/Files/C++ Installer/C++ Installer.zip"
powershell Expand-Archive -LiteralPath "'%~dp0\Files\C++ Installer\C++ Installer.zip'" -DestinationPath "'C:\Users\Mephres\Downloads\Mephres Optimization Pack\1 Windows Preparations\Files\C++ Installer'"
"%~dp0/Files/C++ Installer/VisualCppRedist_AIO_x86_x64.exe"
rmdir /S /Q "%~dp0/Files/C++ Installer" >NUL 2>&1
GOTO :NEXT

:INSTALLEREXIT
echo.
mkdir "%~dp0/Files/C++ Installer"
echo Closing Background Applications...
PowerShell "(get-process | ? { $_.mainwindowtitle -ne '' -and $_.processname -ne 'cmd' } )| stop-process"
echo.
echo Downloading Newest AIO-Installer...
echo.
curl -L "https://kutt.it/vcppredist" -o "%~dp0/Files/C++ Installer/C++ Installer.zip"
powershell Expand-Archive -LiteralPath "'%~dp0\Files\C++ Installer\C++ Installer.zip'" -DestinationPath "'C:\Users\Mephres\Downloads\Mephres Optimization Pack\1 Windows Preparations\Files\C++ Installer'"
"%~dp0/Files/C++ Installer/VisualCppRedist_AIO_x86_x64.exe"
timeout /t 1 >NUL 2>&1
rmdir /S /Q "%~dp0/Files/C++ Installer" >NUL 2>&1
GOTO :FINISH

:UNINSTALLER
echo.
mkdir "%~dp0/Files/C++ Installer"
echo Closing Background Applications...
PowerShell "(get-process | ? { $_.mainwindowtitle -ne '' -and $_.processname -ne 'cmd' } )| stop-process"
echo.
echo Downloading Newest AIO-Installer...
echo.
curl -L "https://kutt.it/vcppredist" -o "%~dp0/Files/C++ Installer/C++ Installer.zip"
powershell Expand-Archive -LiteralPath "'C:\Users\Mephres\Downloads\Mephres Optimization Pack\1 Windows Preparations\Files\C++ Installer\C++ Installer.zip'" -DestinationPath "'C:\Users\Mephres\Downloads\Mephres Optimization Pack\1 Windows Preparations\Files\C++ Installer'"
"%~dp0/Files/C++ Installer/VisualCppRedist_AIO_x86_x64.exe" /aiR
rmdir /S /Q "%~dp0/Files/C++ Installer" >NUL 2>&1
GOTO :FINISH

:NEXT
echo Opening Next Script: DirectX Installer...
call "%~dp0/5 DirectX Installer.bat"
taskkill /f /im cmd.exe

:FINISH
echo The script has been finished. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe

:NOPERMS
echo The process has stopped, no user permission given. Terminating console in 3 seconds...
timeout /t 3
taskkill /f /im cmd.exe