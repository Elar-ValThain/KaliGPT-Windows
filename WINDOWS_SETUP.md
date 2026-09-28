# KaliGPT v1.3 (HackerX) — Windows 11 Installation Guide

## Prerequisites

Before starting, ensure you have:

1. **Python 3.10+** — Download from [python.org](https://www.python.org/downloads/)
   - During installation, **check "Add Python to PATH"**

2. **Git** — Download from [git-scm.com](https://git-scm.com/download/win)

3. **Windows 11** (Windows 10 21H2+ also supported)

## Installation Steps

### Step 1: Open PowerShell as Administrator

1. Press `Win + R`
2. Type `powershell` and press `Ctrl + Shift + Enter` (to run as admin)

### Step 2: Allow PowerShell Scripts

Run this command:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

When prompted, type `Y` and press Enter.

### Step 3: Run the Installer

Download the `install.ps1` script from the repository, then run:

```powershell
powershell -ExecutionPolicy Bypass -File "C:\path\to\install.ps1"
```

Or install to a custom directory:

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1 -InstallDir "C:\MyApps\KaliGPT"
```

The installer will:
- ✅ Clone the KaliGPT repository
- ✅ Clone OpenSearchAPI
- ✅ Create a Python virtual environment
- ✅ Install dependencies
- ✅ Create Windows batch launcher
- ✅ Add `kaligpt` command to your PATH

### Step 4: (Optional) Install Ollama

For offline AI models, download and install [Ollama for Windows](https://ollama.com/download/windows).

After installation, pull a model:

```powershell
ollama pull llama3
ollama pull mistral
```

## Usage

After installation, you can use KaliGPT from any terminal:

```cmd
kaligpt "Your prompt here"
kaligpt -g "Use Google Gemini"
kaligpt -o "Use Ollama"
kaligpt -c "Use ChatGPT"
kaligpt --web
kaligpt --help
```

## Setting Up API Keys

For online models, configure your API keys:

```cmd
kaligpt --setup-keys
```

You'll need:
- **Google Gemini**: Get free key at [makersuite.google.com](https://makersuite.google.com)
- **OpenAI ChatGPT**: Get key at [platform.openai.com](https://platform.openai.com)
- **OpenRouter**: Get key at [openrouter.io](https://openrouter.io)

## Troubleshooting

### `python` command not found

Make sure Python is added to PATH:
- Reinstall Python and check "Add Python to PATH"
- Or restart your terminal after installation

### PowerShell execution policy error

Run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Virtual environment activation fails

Delete the `.venv` folder and reinstall:

```powershell
rm "$env:USERPROFILE\KaliGPT\.venv" -Recurse
powershell -ExecutionPolicy Bypass -File install.ps1
```

### Dependencies installation fails

Manually install dependencies:

```cmd
kaligpt
cd %USERPROFILE%\KaliGPT
.venv\Scripts\activate
pip install -r requirements\pip-requirements.txt
```

### Ollama not found

Make sure Ollama is installed and running. On Windows, it runs as a background service. Start it:

1. Open Services (services.msc)
2. Find "Ollama"
3. Click "Start Service"

Or install from [ollama.com/download/windows](https://ollama.com/download/windows)

## Updating KaliGPT

To update to the latest version:

```cmd
kaligpt --update
```

Or manually:

```cmd
cd %USERPROFILE%\KaliGPT
git pull origin windows-11-support
pip install -r requirements\pip-requirements.txt
```

## File Locations

- **Installation**: `%USERPROFILE%\KaliGPT`
- **Config**: `%APPDATA%\KaliGPT\api.config.json`
- **Cache**: `%TEMP%\KaliGPT-Cache`
- **Launcher**: `%USERPROFILE%\AppData\Local\Programs\Python\Scripts\kaligpt.cmd`

## Running in Different Terminals

### Command Prompt (cmd.exe)
```cmd
kaligpt "Your prompt"
```

### PowerShell
```powershell
kaligpt "Your prompt"
```

### Windows Terminal
```cmd
kaligpt "Your prompt"
```

All terminals are supported!

## Advanced Configuration

Edit the configuration manually:

```json
%APPDATA%\KaliGPT\api.config.json
```

Or within KaliGPT:

```cmd
kaligpt --setup-keys
kaligpt /change-model
```

## Getting Help

- GitHub Issues: [Elar-ValThain/KaliGPT-Windows/issues](https://github.com/Elar-ValThain/KaliGPT-Windows/issues)
- Original Repo: [SudoHopeX/KaliGPT](https://github.com/SudoHopeX/KaliGPT)
- Documentation: [hope.is-a.dev](https://hope.is-a.dev)

---

**Made with ❤️ by SudoHopeX | Windows 11 Support by GitHub Copilot**
