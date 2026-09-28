param(
    [string]$InstallDir = "$env:USERPROFILE\KaliGPT"
)

Write-Host "[+] KaliGPT v1.3 (HackerX) - Windows 11 Installer" -ForegroundColor Cyan
Write-Host "[+] Installation Directory: $InstallDir" -ForegroundColor Cyan
Write-Host ""

# Check Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Git not found. Download from https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}
Write-Host "[+] Git found" -ForegroundColor Green

# Check Python
if (-not (Get-Command py -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Python not found. Download from https://www.python.org/downloads/" -ForegroundColor Red
    exit 1
}
Write-Host "[+] Python found" -ForegroundColor Green
Write-Host ""

# Create directory
if (-not (Test-Path $InstallDir)) {
    Write-Host "[+] Creating directory: $InstallDir" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Clone KaliGPT
Write-Host "[+] Cloning KaliGPT repository..." -ForegroundColor Cyan
Push-Location $InstallDir
git clone https://github.com/SudoHopeX/KaliGPT.git . 2>&1 | Out-Null
git checkout hackerx 2>&1 | Out-Null
Write-Host "[+] KaliGPT cloned" -ForegroundColor Green

# Clone OpenSearchAPI
Write-Host "[+] Cloning OpenSearchAPI..." -ForegroundColor Cyan
$SearchDir = Join-Path $InstallDir "OpenSearchAPI"
git clone https://github.com/SudoHopeX/OpenSearchAPI.git $SearchDir 2>&1 | Out-Null
Write-Host "[+] OpenSearchAPI cloned" -ForegroundColor Green
Write-Host ""

# Create venv
Write-Host "[+] Creating virtual environment..." -ForegroundColor Cyan
$VenvPath = Join-Path $InstallDir ".venv"
py -3 -m venv $VenvPath
Write-Host "[+] Virtual environment created" -ForegroundColor Green

# Activate and install
Write-Host "[+] Installing dependencies..." -ForegroundColor Cyan
$ActivateScript = Join-Path $VenvPath "Scripts\Activate.ps1"
& $ActivateScript
python -m pip install --upgrade pip 2>&1 | Out-Null
pip install -r (Join-Path $InstallDir "requirements\pip-requirements.txt") 2>&1 | Out-Null
Write-Host "[+] Dependencies installed" -ForegroundColor Green
Write-Host ""

# Create launcher directory
$LauncherDir = "$env:USERPROFILE\AppData\Local\Programs\Python\Scripts"
if (-not (Test-Path $LauncherDir)) {
    New-Item -ItemType Directory -Path $LauncherDir -Force | Out-Null
}

# Create launcher batch file
$LauncherPath = Join-Path $LauncherDir "kaligpt.cmd"
$BatchContent = "@echo off`r`nsetlocal enabledelayedexpansion`r`nset KALIGPT_HOME=$InstallDir`r`nset VENV_PATH=!KALIGPT_HOME!\.venv`r`nset SCRIPTS_PATH=!VENV_PATH!\Scripts`r`ncall `"!SCRIPTS_PATH!\activate.bat`"`r`ncd /d `"!KALIGPT_HOME!`"`r`npython -m agents %*"

Set-Content -Path $LauncherPath -Value $BatchContent -Encoding ASCII
Write-Host "[+] Launcher created: $LauncherPath" -ForegroundColor Green

# Add to PATH
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$LauncherDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$LauncherDir", "User")
    Write-Host "[+] Added to PATH" -ForegroundColor Green
}

Write-Host ""
Write-Host "[+] Installation complete!" -ForegroundColor Green
Write-Host "[+] Run: kaligpt --help" -ForegroundColor Green

Pop-Location
