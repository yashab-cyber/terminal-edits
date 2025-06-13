@echo off
REM ZehraSec Terminal Windows Launcher with UTF-8 Support
REM This script ensures proper UTF-8 encoding for Windows console

REM Set console code page to UTF-8
chcp 65001 >nul 2>&1

REM Set Python I/O encoding to UTF-8
set PYTHONIOENCODING=utf-8

REM Set console title
title ZehraSec Terminal v2.2.0

REM Clear screen
cls

REM Launch ZehraSec Terminal
python "%~dp0zehrasec_terminal.py" %*

REM Restore original code page on exit
chcp 437 >nul 2>&1
