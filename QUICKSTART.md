# ZehraSec Terminal - Quick Start Guide

## 🚀 Quick Installation & Setup

### For Linux/macOS/WSL:
```bash
# 1. Clone the repository
git clone https://github.com/yashab-cyber/terminal-edits.git
cd terminal-edits

# 2. Run the installer
chmod +x install.sh
./install.sh

# 3. Start ZehraSec Terminal
zehrasec
```

### For Windows (PowerShell):
```powershell
# 1. Clone the repository
git clone https://github.com/yashab-cyber/terminal-edits.git
cd terminal-edits

# 2. Install dependencies and setup
.\build.ps1 -Install

# 3. Start ZehraSec Terminal
zehrasec
```

### For Termux (Android):
```bash
# 1. Update Termux
pkg update && pkg upgrade

# 2. Install dependencies
pkg install git python bash

# 3. Clone and install
git clone https://github.com/yashab-cyber/terminal-edits.git
cd terminal-edits
chmod +x .terminal.sh

# 4. Create alias
echo 'alias zehrasec="~/terminal-edits/.terminal.sh"' >> ~/.bashrc
source ~/.bashrc

# 5. Start terminal
zehrasec
```

## 🔐 First Run Setup

1. **Set Your Password**: On first run, you'll be prompted to create a secure password
2. **Explore Themes**: Try `changebanner` to browse 50+ ASCII art themes
3. **Customize Prompt**: Use `changeprompt` to personalize your command prompt
4. **Get Help**: Type `help` to see all available commands

## 🎨 Popular Commands

- `help` - Show all commands
- `changebanner` - Interactive banner customization
- `changeprompt` - Customize your command prompt
- `matrix` - Matrix rain effect
- `status` - System status
- `randombanner` - Random theme selection

## 🛡️ Developed by Yashab Alam - CEO of ZehraSec

Start your secure terminal journey today!
