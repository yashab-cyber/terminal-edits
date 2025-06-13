@echo off
echo.
echo =====================================
echo   ZehraSec Terminal v2.2.0
echo   Enhanced Security Terminal Interface
echo   Developed by Yashab Alam - CEO ZehraSec
echo =====================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python 3.7+ from https://python.org
    pause
    exit /b 1
)

REM Check if requirements.txt exists
if not exist "requirements.txt" (
    echo Error: requirements.txt not found
    echo Please ensure you're in the correct directory
    pause
    exit /b 1
)

REM Check if main script exists
if not exist "zehrasec_terminal.py" (
    echo Error: zehrasec_terminal.py not found
    echo Please ensure all files are present
    pause
    exit /b 1
)

echo Checking dependencies...
python -c "import colorama, rich, pyfiglet, psutil, bcrypt" >nul 2>&1
if errorlevel 1 (
    echo Installing required packages...
    python -m pip install -r requirements.txt
    if errorlevel 1 (
        echo Error: Failed to install dependencies
        echo Please run: pip install -r requirements.txt
        pause
        exit /b 1
    )
)

echo.
echo Starting ZehraSec Terminal...
echo.
python zehrasec_terminal.py

pause
