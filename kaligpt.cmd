@echo off
REM KaliGPT v1.3 (HackerX) - Windows 11 Launcher
REM by SudoHopeX | Adapted for Windows 11

setlocal enabledelayedexpansion

REM Get the installation directory
if defined KALIGPT_HOME (
    set INSTALL_DIR=!KALIGPT_HOME!
) else (
    set INSTALL_DIR=%USERPROFILE%\KaliGPT
)

set VENV_PATH=!INSTALL_DIR!\.venv
set SCRIPTS_PATH=!VENV_PATH!\Scripts

REM Check if virtual environment exists
if not exist "!SCRIPTS_PATH!\activate.bat" (
    echo Error: Virtual environment not found at !VENV_PATH!
    echo Please run the installer first: powershell -ExecutionPolicy Bypass -File install.ps1
    pause
    exit /b 1
)

REM Activate virtual environment
call "!SCRIPTS_PATH!\activate.bat"

REM Change to installation directory
cd /d "!INSTALL_DIR!"

REM Handle different modes
if "%1"==\"\" goto default_mode
if "%1"==\"--help\" goto help
if "%1\"==\"-h\" goto help
if "%1"==\"--setup-keys\" goto setup_keys
if "%1"==\"--web\" goto web_launcher
if "%1\"==\"-g\" goto gemini
if "%1"==\"--gemini\" goto gemini
if "%1\"==\"-o\" goto ollama
if "%1"==\"--ollama\" goto ollama
if "%1\"==\"-or\" goto openrouter
if "%1"==\"--openrouter\" goto openrouter
if "%1\"==\"-c\" goto chatgpt
if "%1"==\"--chatgpt\" goto chatgpt
if "%1\"==\"-u\" goto update
if "%1"==\"--update\" goto update
if "%1\"==\"-v\" goto version
if "%1"==\"--version\" goto version

:default_mode
python -m agents %*
goto end

:gemini
python -m agents.gemini %*
goto end

:ollama
python -m agents.ollama %*
goto end

:openrouter
python -m agents.openrouter %*
goto end

:chatgpt
python -m agents.chatgpt %*
goto end

:web_launcher
python -m agents.web_launcher %*
goto end

:setup_keys
python -m agents --setup-keys
goto end

:update
echo Checking for updates...
git fetch origin windows-11-support
for /f %%A in ('git rev-parse HEAD') do set LOCAL=%%A
for /f %%A in ('git rev-parse origin/windows-11-support') do set REMOTE=%%A

if not "!LOCAL!"==\"!REMOTE!\" (
    echo New version found! Updating...
    git pull origin windows-11-support
    echo Reinstalling dependencies...
    python -m pip install -r requirements\pip-requirements.txt
    echo Update complete!
) else (
    echo KaliGPT is already up-to-date.
)
goto end

:version
git describe --tags
goto end

:help
echo.
echo KaliGPT v1.3 (HackerX) - Use AI in Windows via CLI easily
echo by SudoHopeX
echo.
echo Usage:
echo   kaligpt [MODE] [PROMPT]
echo.
echo Modes:
echo   -g, --gemini            Use Google Gemini (Online)
echo   -o, --ollama            Use Ollama (Offline)
echo   -or, --openrouter       Use OpenRouter (Online)
echo   -c, --chatgpt           Use OpenAI ChatGPT (Online)
echo   --web                   Launch web AI chat
echo   --setup-keys            Configure API keys
echo   -u, --update            Update KaliGPT
echo   -v, --version           Show version
echo   -h, --help              Show this help
echo.
echo Examples:
echo   kaligpt \"How to find XSS vulnerabilities?\"
echo   kaligpt -g \"Explain SQL injection\"
echo   kaligpt -o \"Write a port scanner\"
echo   kaligpt --web
echo.
goto end

:end
deactivate
endlocal
