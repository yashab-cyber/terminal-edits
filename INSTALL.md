# ZehraSec Terminal - Installation Guide

> **🛡️ Developed by Yashab Alam - Founder & CEO of ZehraSec 🛡️**

## Links & Support

- **GitHub Repository**: https://github.com/yashab-cyber/terminal-edits
- **Support Email**: yashabalam707@gmail.com
- **Donations**: See [DONATE.md](DONATE.md) or [PayPal](https://paypal.me/yashab07)

## Quick Start

### Prerequisites
- Python 3.7 or higher
- pip (Python package installer)

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yashab-cyber/terminal-edits.git
   cd terminal-edits
   ```

2. **Navigate to the project directory:**
   ```bash
   cd path/to/project02  # If not already in the directory
   ```

3. **Install required dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run ZehraSec Terminal:**
   ```bash
   python launch.py
   ```
   
   Or directly:
   ```bash
   python zehrasec_terminal.py
   ```

## Alternative Installation Methods

### Using Virtual Environment (Recommended)

```bash
# Create virtual environment
python -m venv zehrasec_env

# Activate virtual environment
# On Windows:
zehrasec_env\Scripts\activate
# On macOS/Linux:
source zehrasec_env/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the terminal
python zehrasec_terminal.py
```

### Manual Package Installation

If you prefer to install packages individually:

```bash
pip install colorama>=0.4.6
pip install pyfiglet>=0.8.post1
pip install bcrypt>=4.0.1
pip install cryptography>=41.0.0
pip install psutil>=5.9.0
pip install rich>=13.7.0
pip install click>=8.1.7
```

## First Run Setup

1. **Launch the terminal:**
   ```bash
   python zehrasec_terminal.py
   ```

2. **Set up your password** (first time only)
   - You'll be prompted to create a secure password
   - Password must be at least 6 characters with letters and numbers

3. **Explore the features:**
   - Type `help` to see all available commands
   - Try `changebanner` to customize your terminal theme
   - Use `changeprompt` to personalize your command prompt

## Features Overview

### 🛡️ Security Features
- **Multi-layer Authentication**: Secure password-based login
- **Account Lockout Protection**: Automatic lockout after failed attempts
- **Session Management**: Automatic timeouts and validation
- **Audit Logging**: Complete activity logging

### 🎨 Customization Features
- **Interactive Banner System**: 50+ ASCII art themes across 6 categories
- **Custom Prompts**: 10 predefined prompts + custom text support
- **Real-time Theme Switching**: Instant changes without restart
- **Persistent Settings**: Customizations saved across sessions

### 🎭 Visual Effects
- **Matrix Rain Effect**: Animated terminal display
- **Typing Effects**: Realistic command-line animations
- **Color Themes**: Multiple color schemes
- **Progress Indicators**: Visual feedback for operations

### 🔧 Built-in Commands

#### Core Commands
- `help` - Display command reference
- `status` - Show system and security status
- `clear` - Clear screen and redisplay banner
- `matrix` - Show matrix effect animation
- `sysinfo` - Display system information
- `changepass` - Change password
- `logout` / `exit` - Exit terminal

#### Banner Customization
- `changebanner` - Interactive banner menu
- `randombanner` - Set random theme
- `previewthemes` - Preview all themes
- `resetbanner` - Reset to default
- `browseart` - Browse categories
- `currentbanner` - Show current info

#### Prompt Customization
- `changeprompt` - Interactive prompt menu
- `setprompt [text]` - Set custom prompt
- `resetprompt` - Reset to default
- `listprompts` - Show predefined options
- `currentprompt` - Show current info

#### System Commands
- `clean` - Clean temporary files
- `backup` - Backup customizations
- `restore` - Restore from backup
- `update` - Check for updates

## Troubleshooting

### Common Issues

1. **"ModuleNotFoundError" when running:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Permission errors on Windows:**
   - Run Command Prompt as Administrator
   - Or use: `python -m pip install --user -r requirements.txt`

3. **Python not found:**
   - Ensure Python is installed and in PATH
   - Try `python3` instead of `python`

4. **Colors not displaying properly:**
   - Use Windows Terminal, PowerShell, or Git Bash
   - Avoid basic Command Prompt for best experience

5. **Password forgotten:**
   - Delete the `.zehrasec` folder in your home directory
   - Restart the terminal to set up a new password

### Platform-Specific Notes

#### Windows Users
- **Recommended terminals:** Windows Terminal, PowerShell, Git Bash
- **Avoid:** Basic Command Prompt (limited color support)
- **Best experience:** Windows Terminal with full Unicode support

#### macOS Users
- **Recommended terminals:** Terminal.app, iTerm2
- **May need:** `brew install python` for latest Python version

#### Linux Users
- **Most terminals supported:** GNOME Terminal, Konsole, xterm
- **Package managers:** apt, yum, dnf, pacman all supported

## Security Notes

- **Password Storage**: Passwords are hashed using bcrypt
- **Session Management**: Automatic timeouts prevent unauthorized access
- **Audit Logging**: All activities logged to `~/.zehrasec/access.log`
- **Account Lockout**: Protection against brute force attempts
- **Input Validation**: All user inputs are sanitized and validated

## File Structure

```
project02/
├── zehrasec_terminal.py     # Main terminal application
├── launch.py                # Launcher script
├── requirements.txt         # Python dependencies
├── INSTALL.md              # This installation guide
├── README.md               # Project documentation
├── DONATE.md               # Support information
└── ascii_art/              # ASCII art collections
    ├── logoasciiart/       # Technology logos
    ├── codingasciiart/     # Programming themes
    ├── loveasciiart/       # Love/heart themes
    ├── terminalskullasciiart/ # Skull/warning themes
    └── fuckoff/            # Access denied themes
```

## Configuration Directory

The terminal creates a configuration directory at:
- **Windows:** `C:\Users\[Username]\.zehrasec\`
- **macOS/Linux:** `~/.zehrasec/`

This contains:
- `pass` - Encrypted password hash
- `fails` - Failed login attempts
- `locktime` - Account lockout timestamp
- `access.log` - Security audit log
- `session` - Active session info
- `prompt` - Custom prompt settings
- `banner` - Current banner theme
- `preferences` - User customizations

## Support

For issues, questions, or contributions:
- **Developer:** Yashab Alam - CEO of ZehraSec
- **Company:** ZehraSec - Cybersecurity Solutions
- **Version:** 2.2.0

---

**🛡️ Developed by Yashab Alam - Founder & CEO of ZehraSec 🛡️**
