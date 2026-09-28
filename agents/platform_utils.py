#!/usr/bin/env python3
"""
agents/platform_utils.py
Cross-platform utilities for KaliGPT on Windows 11, Linux, macOS
Last Modified: 2026-09-28
"""

import os
import sys
import platform
import subprocess
import shlex
from typing import Dict, Optional


# --- PLATFORM DETECTION ---

def get_platform() -> str:
    """Returns the platform: 'windows', 'linux', or 'darwin' (macOS)."""
    return sys.platform.split()[0]


def is_windows() -> bool:
    """Check if running on Windows."""
    return get_platform() == 'win32'


def is_linux() -> bool:
    """Check if running on Linux."""
    return sys.platform.startswith('linux')


def is_macos() -> bool:
    """Check if running on macOS."""
    return sys.platform == 'darwin'


# --- COMMAND EXECUTION (CROSS-PLATFORM) ---

def execute_command(command: str, shell: bool = False) -> Dict[str, any]:
    """
    Execute a command in a cross-platform manner.
    
    Args:
        command (str): The command to execute
        shell (bool): Whether to use shell (NOT recommended for security)
    
    Returns:
        dict: {\"output\": str, \"error\": str, \"returncode\": int, \"success\": bool}
    """
    try:
        if is_windows():
            # On Windows, wrap command in cmd /c for shell commands
            if shell or any(c in command for c in ['|', '>', '<', '&&', '||']):
                result = subprocess.run(
                    [\"cmd\", \"/c\", command],
                    capture_output=True,
                    text=True,
                    timeout=30
                )
            else:
                # For simple commands, split normally
                args = command.split()
                result = subprocess.run(
                    args,
                    capture_output=True,
                    text=True,
                    timeout=30
                )
        else:
            # On Unix-like systems, use shlex
            args = shlex.split(command)
            result = subprocess.run(
                args,
                capture_output=True,
                text=True,
                timeout=30
            )

        return {
            \"output\": result.stdout,
            \"error\": result.stderr,
            \"returncode\": result.returncode,
            \"success\": result.returncode == 0
        }

    except subprocess.TimeoutExpired:
        return {
            \"output\": None,
            \"error\": \"Command timed out after 30 seconds\",
            \"returncode\": -1,
            \"success\": False
        }
    except Exception as e:
        return {
            \"output\": None,
            \"error\": str(e),
            \"returncode\": -1,
            \"success\": False
        }


# --- CONFIGURATION PATH MANAGEMENT ---

def get_config_dir() -> str:
    """
    Get the appropriate config directory for the platform.
    
    Windows: %APPDATA%\KaliGPT
    Linux: ~/.config/kaligpt
    macOS: ~/Library/Application Support/KaliGPT
    """
    if is_windows():
        config_dir = os.path.join(os.getenv('APPDATA'), 'KaliGPT')
    elif is_macos():
        config_dir = os.path.expanduser('~/Library/Application Support/KaliGPT')
    else:  # Linux
        config_dir = os.path.expanduser('~/.config/kaligpt')
    
    os.makedirs(config_dir, exist_ok=True)
    return config_dir


def get_cache_dir() -> str:
    """Get the appropriate cache directory for the platform."""
    if is_windows():
        cache_dir = os.path.join(os.getenv('TEMP'), 'KaliGPT-Cache')
    else:
        cache_dir = os.path.expanduser('~/.cache/kaligpt')
    
    os.makedirs(cache_dir, exist_ok=True)
    return cache_dir


# --- BROWSER LAUNCHING (CROSS-PLATFORM) ---

def open_browser(url: str) -> bool:
    """
    Open URL in default browser.
    
    Args:
        url (str): URL to open
    
    Returns:
        bool: Success status
    """
    try:
        import webbrowser
        webbrowser.open(url)
        return True
    except Exception as e:
        print(f\"[!] Failed to open browser: {e}\")
        return False


# --- ENVIRONMENT & PATH HELPERS ---

def get_python_executable() -> str:
    """Get the current Python executable."""
    return sys.executable


def add_to_path(directory: str) -> bool:
    """
    Temporarily add directory to PATH.
    Note: This only affects the current process.
    """
    if directory not in os.environ.get('PATH', ''):
        os.environ['PATH'] = directory + os.pathsep + os.environ.get('PATH', '')
        return True
    return False


# --- VENV ACTIVATION HELPERS ---

def get_venv_python() -> Optional[str]:
    """
    Get Python executable from active virtual environment.
    Returns None if not in a venv.
    """
    venv_base = os.environ.get('VIRTUAL_ENV')
    if venv_base:
        if is_windows():
            return os.path.join(venv_base, 'Scripts', 'python.exe')
        else:
            return os.path.join(venv_base, 'bin', 'python')
    return None


# --- ANSI COLOR SUPPORT ---

def supports_ansi_colors() -> bool:
    """Check if terminal supports ANSI colors."""
    if is_windows():
        # Windows 10+ supports ANSI if running in Windows Terminal or modern cmd
        return os.environ.get('TERM_PROGRAM') in ['WindowsTerminal', 'mintty'] or \
               os.environ.get('ANSICON') is not None or \
               sys.stdout.isatty()
    return sys.stdout.isatty()


if __name__ == \"__main__\":
    print(f\"Platform: {get_platform()}\")
    print(f\"Is Windows: {is_windows()}\")
    print(f\"Is Linux: {is_linux()}\")
    print(f\"Is macOS: {is_macos()}\")
    print(f\"Config Dir: {get_config_dir()}\")
    print(f\"Cache Dir: {get_cache_dir()}\")
    print(f\"Python: {get_python_executable()}\")
    print(f\"ANSI Colors Supported: {supports_ansi_colors()}\")
