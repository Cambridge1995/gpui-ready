@echo off
setlocal
for /f "tokens=2 delims=:" %%a in ('chcp') do set "ORIGINAL_CODEPAGE=%%a"
set "ORIGINAL_CODEPAGE=%ORIGINAL_CODEPAGE: =%"
chcp 65001 >nul
if "%~1"=="" (
    set /p "PROJECT_NAME=Project name (for example MyApp): "
) else (
    set "PROJECT_NAME=%~1"
)
if not defined PROJECT_NAME (
    chcp %ORIGINAL_CODEPAGE% >nul
    exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0new-project.ps1" -Name "%PROJECT_NAME%"
set "RESULT=%ERRORLEVEL%"
chcp %ORIGINAL_CODEPAGE% >nul
exit /b %RESULT%
