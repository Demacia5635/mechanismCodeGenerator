@echo off
cd /d C:\Users\Public\mechanism_generator
call flutter build windows --release

set ISCC_PATH=
if exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" set ISCC_PATH="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if exist "C:\Program Files\Inno Setup 6\ISCC.exe" set ISCC_PATH="C:\Program Files\Inno Setup 6\ISCC.exe"
if exist "%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe" set ISCC_PATH="%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe"

if defined ISCC_PATH (
    %ISCC_PATH% installer.iss
) else (
    echo ERROR: ISCC.exe not found. Please open installer.iss and compile manually.
)
pause