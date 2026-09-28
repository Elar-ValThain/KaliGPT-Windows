# ============================================================================
# KaliGPT v1.3 (HackerX) - Windows 11 Installation Script
# by SudoHopeX | Adapted for Windows 11 by GitHub Copilot
# ============================================================================

param(
    [string]$InstallDir = "$env:USERPROFILE\KaliGPT",
    [switch]$SkipVenv = $false,
    [switch]$SkipOllama = $false,
    [switch]$SetupKeys = $false
)

# Color codes for Windows terminal
$Colors = @{
    Reset  = "`e[0m"
    Green  = "`e[92m"
    Yellow = "`e[93m"
    Red    = "`e[91m"
    Cyan   = "`e[96m"
    Bold   = "`e[1m"
}

function Print-Status {
    param([string]$Message, [string]$Type = "info")
    switch ($Type) {
        "success" { Write-Host "$($Colors.Green)[✓]$($Colors.Reset) $Message" }
        "error"   { Write-Host "$($Colors.Red)[✗]$($Colors.Reset) $Message" -ForegroundColor Red }
        "warn"    { Write-Host "$($Colors.Yellow)[!]$($Colors.Reset) $Message" }
        "info"    { Write-Host "$($Colors.Cyan)[+]$($Colors.Reset) $Message" }
    }
}

function Test-Command {
    param([string]$CommandName)
    try {
        if (Get-Command $CommandName -ErrorAction Stop) {
            return $true
        }
    } catch {
        return $false
    }
}

# Check prerequisites
Print-Status "Checking prerequisites..." "info"

if (-not (Test-Command "git")) {
    Print-Status "Git is not installed. Download from https://git-scm.com/download/win" "error"
    exit 1
}
Print-Status "Git found" "success"

if (-not (Test-Command "py")) {
    Print-Status "Python is not installed. Download from https://www.python.org/downloads/" "error"
    exit 1
}
Print-Status "Python found" "success"

# Create installation directory
if (Test-Path $InstallDir) {
    Print-Status "Installation directory already exists at $InstallDir" "warn"
} else {
    Print-Status "Creating installation directory: $InstallDir" "info"
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Clone repository
Print-Status "Cloning KaliGPT repository..." "info"
cd $InstallDir
try {
    git clone https://github.com/Elar-ValThain/KaliGPT-Windows.git . 2>&1 | Out-Null
    Print-Status "Repository cloned successfully" "success"
} catch {
    Print-Status "Failed to clone repository: $_" "error"
    exit 1
}

# Clone OpenSearchAPI
Print-Status "Cloning OpenSearchAPI repository..." "info"
$OpenSearchDir = Join-Path $InstallDir "OpenSearchAPI"
try {
    git clone https://github.com/SudoHopeX/OpenSearchAPI.git $OpenSearchDir 2>&1 | Out-Null
    Print-Status "OpenSearchAPI cloned successfully" "success"
} catch {
    Print-Status "Failed to clone OpenSearchAPI: $_" "error"
}

# Create virtual environment
if (-not $SkipVenv) {
    Print-Status "Creating Python virtual environment..." "info"
    $VenvPath = Join-Path $InstallDir ".venv"
    
    try {
        py -3 -m venv $VenvPath
        Print-Status "Virtual environment created" "success"
    } catch {
        Print-Status "Failed to create virtual environment: $_" "error"
        exit 1
    }

    # Activate and install requirements
    $ActivateScript = Join-Path $VenvPath "Scripts\Activate.ps1"
    
    Print-Status "Installing Python dependencies..." "info"
    try {
        & $ActivateScript
        python -m pip install --upgrade pip 2>&1 | Out-Null
        pip install -r (Join-Path $InstallDir "requirements\pip-requirements.txt") 2>&1 | Out-Null
        Print-Status "Dependencies installed successfully" "success"
    } catch {
        Print-Status "Failed to install dependencies: $_" "error"
        exit 1
    }
}

# Ollama installation (optional)
if (-not $SkipOllama) {
    $response = Read-Host "Do you want to install Ollama for local AI models? (y/N)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        Print-Status "Installing Ollama..." "info"
        try {
            Invoke-WebRequest -Uri "https://ollama.com/download/windows" -OutFile "$env:TEMP\OllamaSetup.exe"
            & "$env:TEMP\OllamaSetup.exe" /S
            Print-Status "Ollama installed. Please restart your computer and then pull a model using: ollama pull llama3" "success"
        } catch {
            Print-Status "Failed to install Ollama: $_" "warn"
        }
    }
}

# Setup API keys (optional)
if ($SetupKeys) {
    Print-Status "Starting API key setup..." "info"
    $VenvPath = Join-Path $InstallDir ".venv"
    $ActivateScript = Join-Path $VenvPath "Scripts\Activate.ps1"
    & $ActivateScript
    python -m agents --setup-keys
}

# Create Windows batch launcher
Print-Status "Creating KaliGPT command launcher..." "info"
$LauncherPath = "$env:USERPROFILE\AppData\Local\Programs\Python\Scripts\kaligpt.cmd"
$LauncherDir = Split-Path $LauncherPath

if (-not (Test-Path $LauncherDir)) {
    New-Item -ItemType Directory -Path $LauncherDir -Force | Out-Null
}

$LauncherContent = @"
@echo off
REM KaliGPT v1.3 Launcher Script for Windows
REM by SudoHopeX | Adapted for Windows 11

setlocal enabledelayedexpansion

set KALIGPT_HOME=$InstallDir
set VENV_PATH=!KALIGPT_HOME!\.venv
set SCRIPTS_PATH=!VENV_PATH!\Scripts

REM Activate virtual environment
call "!SCRIPTS_PATH!\activate.bat"

REM Change to KaliGPT directory
cd /d "!KALIGPT_HOME!"

REM Start OpenSearchAPI in background (optional)
start "" python OpenSearchAPI/app.py

REM Run KaliGPT
python -m agents %*

pause
"@

Set-Content -Path $LauncherPath -Value $LauncherContent -Encoding ASCII
Print-Status "Launcher created at: $LauncherPath" "success"

# Add to PATH
Print-Status "Adding KaliGPT to system PATH..." "info"
$PathValue = [Environment]::GetEnvironmentVariable("Path", "User")
if ($PathValue -notlike "*$LauncherDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$PathValue;$LauncherDir", "User")
    Print-Status "Added to PATH. You may need to restart your terminal." "success"
}

Print-Status "KaliGPT v1.3 (HackerX) installation completed successfully!" "success"
Print-Status "You can now run KaliGPT using: kaligpt" "info"
Print-Status "For help, run: kaligpt --help" "info"
