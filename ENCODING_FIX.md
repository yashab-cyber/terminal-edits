# ZehraSec Terminal - Encoding Fix Instructions

## Issue: 'charmap' codec can't encode characters

The error occurs because Windows console doesn't handle Unicode characters properly by default.

## Quick Fix Solutions:

### Solution 1: Use UTF-8 Environment Variable
```cmd
set PYTHONIOENCODING=utf-8
python zehrasec_terminal.py
```

### Solution 2: Use PowerShell with UTF-8
```powershell
$env:PYTHONIOENCODING="utf-8"
python zehrasec_terminal.py
```

### Solution 3: Use the UTF-8 Launcher
```cmd
launch_utf8.bat
```

### Solution 4: Set Console Code Page
```cmd
chcp 65001
python zehrasec_terminal.py
```

## Permanent Fix for Windows

Add this to your environment variables:
- Variable: `PYTHONIOENCODING`
- Value: `utf-8`

## Technical Details

The error occurs when the Python program tries to output Unicode characters (like emojis or special ASCII art characters) to the Windows console, which uses the 'charmap' codec by default. Setting `PYTHONIOENCODING=utf-8` tells Python to use UTF-8 encoding for input/output operations.

## Alternative

If you continue to have issues, you can edit the ASCII art files in `ascii_art/` directory to remove any special Unicode characters and replace them with standard ASCII characters.

---

**ZehraSec Terminal v2.2.0**  
*Developer: Yashab Alam - Founder & CEO of ZehraSec*
