@echo off
cd /d "%~dp0.."
IF EXIST "%~dp0..\bin" echo WARNING: directory found. Starting assembly... && GOTO :ASSEMBLY (
) ELSE (
GOTO :FIRSTASSEMBLY
)

:FIRSTASSEMBLY
mkdir "%~dp0..\bin"
c:\windows\Microsoft.NET\Framework\v3.5\csc.exe /t:exe /out:"Standby Cleaner Lite.exe" "Program.cs" "AssemblyInfo.cs" /win32icon:"StandbyCleanerLite.ico"
move "Standby Cleaner Lite.exe" "bin"
explorer "%~dp0..\bin"
pause

:ASSEMBLY
del "Standby Cleaner Lite\Standby Cleaner Lite.exe" >NUL 2>&1
c:\windows\Microsoft.NET\Framework\v3.5\csc.exe /t:exe /out:"Standby Cleaner Lite.exe" "Program.cs" "AssemblyInfo.cs" /win32icon:"StandbyCleanerLite.ico"
move "Standby Cleaner Lite.exe" "bin"
explorer "%~dp0..\bin"
pause