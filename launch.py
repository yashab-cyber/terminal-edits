#!/usr/bin/env python3
"""
ZehraSec Terminal Launcher
Quick launcher for the ZehraSec Terminal application

Developed by: Yashab Alam - Founder & CEO of ZehraSec
GitHub Repository: https://github.com/yashab-cyber/terminal-edits
Support Email: yashabalam707@gmail.com
"""

import sys
import subprocess
import os
from pathlib import Path

def check_requirements():
    """Check if requirements are installed"""
    try:
        import colorama
        import rich
        import pyfiglet
        import psutil
        import bcrypt
        return True
    except ImportError:
        return False

def install_requirements():
    """Install required packages"""
    print("Installing required packages...")
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"])
        return True
    except subprocess.CalledProcessError:
        return False

def main():
    """Main launcher function"""
    script_dir = Path(__file__).parent
    main_script = script_dir / "zehrasec_terminal.py"
    
    if not main_script.exists():
        print("Error: zehrasec_terminal.py not found!")
        return 1
    
    # Check requirements
    if not check_requirements():
        print("Required packages not found. Installing...")
        if not install_requirements():
            print("Failed to install required packages.")
            print("Please run: pip install -r requirements.txt")
            return 1
    
    # Launch the terminal
    try:
        subprocess.run([sys.executable, str(main_script)])
        return 0
    except KeyboardInterrupt:
        print("\nLauncher interrupted.")
        return 0
    except Exception as e:
        print(f"Error launching ZehraSec Terminal: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
