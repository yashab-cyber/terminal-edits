#!/bin/bash
# ZehraSec Terminal - Universal Linux Installation Script
# Supports major Linux distributions with automatic package manager detection
# Version: 2.2.0
#
# Developed by: Yashab Alam - Founder & CEO of ZehraSec
# GitHub Repository: https://github.com/yashab-cyber/terminal-edits
# Support Email: yashabalam707@gmail.com
# Donation Support: See DONATE.md for donation options

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Color definitions
readonly RED='\033[1;31m'
readonly GREEN='\033[1;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[1;34m'
readonly MAGENTA='\033[1;35m'
readonly CYAN='\033[1;36m'
readonly WHITE='\033[1;37m'
readonly BOLD='\033[1m'
readonly RESET='\033[0m'

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/share/zehrasec"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.zehrasec"
DISTRO=""
PACKAGE_MANAGER=""
PYTHON_CMD=""
SUDO_CMD=""

# Distribution detection
detect_distribution() {
    echo -e "${BLUE}🔍 Detecting Linux distribution...${RESET}"
    
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        DISTRO="$ID"
    elif [[ -f /etc/redhat-release ]]; then
        DISTRO="rhel"
    elif [[ -f /etc/debian_version ]]; then
        DISTRO="debian"
    elif [[ -f /etc/arch-release ]]; then
        DISTRO="arch"
    elif [[ -f /etc/gentoo-release ]]; then
        DISTRO="gentoo"
    else
        DISTRO="unknown"
    fi
    
    echo -e "${GREEN}   ✅ Detected distribution: $DISTRO${RESET}"
}

# Package manager detection
detect_package_manager() {
    echo -e "${BLUE}🔍 Detecting package manager...${RESET}"
    
    # Check for package managers in order of preference
    local managers=(
        "apt:apt-get"
        "dnf:dnf"
        "yum:yum"
        "pacman:pacman"
        "zypper:zypper"
        "apk:apk"
        "emerge:emerge"
        "brew:brew"
        "pkg:pkg"
    )
    
    for manager in "${managers[@]}"; do
        local cmd="${manager#*:}"
        if command -v "$cmd" &> /dev/null; then
            PACKAGE_MANAGER="$cmd"
            echo -e "${GREEN}   ✅ Found package manager: $PACKAGE_MANAGER${RESET}"
            return 0
        fi
    done
    
    echo -e "${RED}   ❌ No supported package manager found${RESET}"
    return 1
}

# Python detection
detect_python() {
    echo -e "${BLUE}🔍 Detecting Python installation...${RESET}"
    
    local python_commands=("python3" "python3.11" "python3.10" "python3.9" "python3.8" "python")
    
    for cmd in "${python_commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            local version
            version=$($cmd --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
            
            if [[ -n "$version" ]]; then
                local major minor
                major=$(echo "$version" | cut -d. -f1)
                minor=$(echo "$version" | cut -d. -f2)
                
                if [[ "$major" -eq 3 ]] && [[ "$minor" -ge 7 ]]; then
                    PYTHON_CMD="$cmd"
                    echo -e "${GREEN}   ✅ Found Python: $cmd (version $version)${RESET}"
                    return 0
                fi
            fi
        fi
    done
    
    echo -e "${RED}   ❌ Python 3.7+ not found${RESET}"
    return 1
}

# Sudo detection
detect_sudo() {
    if [[ $EUID -eq 0 ]]; then
        SUDO_CMD=""
        echo -e "${GREEN}   ✅ Running as root${RESET}"
    elif command -v sudo &> /dev/null; then
        # Test if sudo works without password
        if sudo -n true 2>/dev/null; then
            SUDO_CMD="sudo"
            echo -e "${GREEN}   ✅ Sudo access available${RESET}"
        else
            SUDO_CMD="sudo"
            echo -e "${YELLOW}   ⚠️  Sudo available but may require password${RESET}"
        fi
    else
        SUDO_CMD=""
        echo -e "${YELLOW}   ⚠️  No sudo access (user installation only)${RESET}"
    fi
}

# Print system information header
print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║                    🛡️  ZehraSec Terminal Linux Installer v2.2.0  🛡️          ║"
    echo -e "║                     Enhanced Security Terminal Interface                     ║"
    echo -e "║                  Developed by Yashab Alam - CEO of ZehraSec                 ║"
    echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${GREEN}🖥️  System Information:${RESET}"
    echo -e "${YELLOW}   • Distribution: $DISTRO${RESET}"
    echo -e "${YELLOW}   • Package Manager: $PACKAGE_MANAGER${RESET}"
    echo -e "${YELLOW}   • Python Command: $PYTHON_CMD${RESET}"
    echo -e "${YELLOW}   • Sudo Access: ${SUDO_CMD:-None}${RESET}"
    echo -e "${YELLOW}   • Architecture: $(uname -m)${RESET}"
    echo -e "${YELLOW}   • Kernel: $(uname -r)${RESET}"
    echo
}

# Update package repositories
update_repositories() {
    echo -e "${BLUE}📦 Updating package repositories...${RESET}"
    
    local update_cmd=""
    case "$PACKAGE_MANAGER" in
        "apt"|"apt-get")
            update_cmd="$SUDO_CMD $PACKAGE_MANAGER update"
            ;;
        "dnf")
            update_cmd="$SUDO_CMD dnf check-update"
            ;;
        "yum")
            update_cmd="$SUDO_CMD yum check-update"
            ;;
        "pacman")
            update_cmd="$SUDO_CMD pacman -Sy"
            ;;
        "zypper")
            update_cmd="$SUDO_CMD zypper refresh"
            ;;
        "apk")
            update_cmd="$SUDO_CMD apk update"
            ;;
        "brew")
            update_cmd="brew update"
            ;;
        *)
            echo -e "${YELLOW}   ⚠️  Unknown package manager, skipping update${RESET}"
            return 0
            ;;
    esac
    
    if [[ -n "$update_cmd" ]]; then
        if eval $update_cmd &> /dev/null; then
            echo -e "${GREEN}   ✅ Repositories updated successfully${RESET}"
        else
            echo -e "${YELLOW}   ⚠️  Repository update completed with warnings${RESET}"
        fi
    fi
}

# Install system packages
install_system_packages() {
    echo -e "${BLUE}📦 Installing system packages...${RESET}"
    
    # Define packages for different distributions
    local packages=""
    case "$DISTRO" in
        "ubuntu"|"debian"|"linuxmint"|"pop")
            packages="python3 python3-pip python3-venv python3-dev git curl figlet bc build-essential"
            ;;
        "fedora"|"rhel"|"centos"|"rocky"|"almalinux")
            packages="python3 python3-pip python3-devel git curl figlet bc gcc gcc-c++ make"
            ;;
        "arch"|"manjaro"|"endeavouros")
            packages="python python-pip git curl figlet bc base-devel"
            ;;
        "opensuse"|"sles")
            packages="python3 python3-pip python3-devel git curl figlet bc gcc gcc-c++ make"
            ;;
        "alpine")
            packages="python3 py3-pip python3-dev git curl figlet bc build-base"
            ;;
        "gentoo")
            packages="dev-lang/python dev-python/pip dev-vcs/git net-misc/curl app-misc/figlet sci-calculators/bc"
            ;;
        *)
            packages="python3 python3-pip git curl figlet bc"
            ;;
    esac
    
    # Install packages based on package manager
    local install_cmd=""
    case "$PACKAGE_MANAGER" in
        "apt"|"apt-get")
            install_cmd="$SUDO_CMD $PACKAGE_MANAGER install -y $packages"
            ;;
        "dnf")
            install_cmd="$SUDO_CMD dnf install -y $packages"
            ;;
        "yum")
            install_cmd="$SUDO_CMD yum install -y $packages"
            ;;
        "pacman")
            install_cmd="$SUDO_CMD pacman -S --noconfirm $packages"
            ;;
        "zypper")
            install_cmd="$SUDO_CMD zypper install -y $packages"
            ;;
        "apk")
            install_cmd="$SUDO_CMD apk add $packages"
            ;;
        "emerge")
            install_cmd="$SUDO_CMD emerge $packages"
            ;;
        "brew")
            install_cmd="brew install $packages"
            ;;
        *)
            echo -e "${RED}   ❌ Unsupported package manager: $PACKAGE_MANAGER${RESET}"
            return 1
            ;;
    esac
    
    echo -e "${YELLOW}   Installing: $packages${RESET}"
    
    if eval $install_cmd; then
        echo -e "${GREEN}   ✅ System packages installed successfully${RESET}"
    else
        echo -e "${YELLOW}   ⚠️  Some packages may have failed to install${RESET}"
        echo -e "${CYAN}   💡 Continuing with installation...${RESET}"
    fi
}

# Install Python packages
install_python_packages() {
    echo -e "${BLUE}🐍 Installing Python packages...${RESET}"
    
    # Create requirements.txt if it doesn't exist
    local requirements_file="$SCRIPT_DIR/requirements.txt"
    if [[ ! -f "$requirements_file" ]]; then
        echo -e "${YELLOW}   Creating requirements.txt...${RESET}"
        cat > "$requirements_file" << 'EOF'
colorama>=0.4.6
pyfiglet>=0.8.post1
bcrypt>=4.0.1
cryptography>=41.0.0
psutil>=5.9.0
rich>=13.7.0
click>=8.1.7
EOF
    fi
    
    # Upgrade pip
    echo -e "${YELLOW}   Upgrading pip...${RESET}"
    $PYTHON_CMD -m pip install --upgrade pip --user &> /dev/null || true
    
    # Install packages
    echo -e "${YELLOW}   Installing Python dependencies...${RESET}"
    if $PYTHON_CMD -m pip install -r "$requirements_file" --user; then
        echo -e "${GREEN}   ✅ Python packages installed successfully${RESET}"
    else
        echo -e "${RED}   ❌ Python package installation failed${RESET}"
        return 1
    fi
}

# Setup directories
setup_directories() {
    echo -e "${BLUE}📁 Setting up directories...${RESET}"
    
    local directories=(
        "$INSTALL_DIR"
        "$BIN_DIR"
        "$CONFIG_DIR"
        "$INSTALL_DIR/ascii_art"
        "$HOME/.local"
        "$HOME/.local/share"
    )
    
    for dir in "${directories[@]}"; do
        if mkdir -p "$dir" 2>/dev/null; then
            echo -e "${GREEN}   ✅ Created: $dir${RESET}"
        else
            echo -e "${RED}   ❌ Failed to create: $dir${RESET}"
            return 1
        fi
    done
}

# Copy application files
copy_files() {
    echo -e "${BLUE}📄 Copying ZehraSec Terminal files...${RESET}"
    
    local files=(
        "zehrasec_terminal.py"
        "launch.py"
        "demo.py"
        "test.py"
        "requirements.txt"
        "README_PYTHON.md"
        "INSTALL.md"
        "COMPLETION_STATUS.md"
    )
    
    # Copy main files
    for file in "${files[@]}"; do
        if [[ -f "$SCRIPT_DIR/$file" ]]; then
            if cp "$SCRIPT_DIR/$file" "$INSTALL_DIR/"; then
                echo -e "${GREEN}   ✅ Copied: $file${RESET}"
            else
                echo -e "${RED}   ❌ Failed to copy: $file${RESET}"
            fi
        else
            echo -e "${YELLOW}   ⚠️  File not found: $file${RESET}"
        fi
    done
    
    # Copy ASCII art directory
    if [[ -d "$SCRIPT_DIR/ascii_art" ]]; then
        if cp -r "$SCRIPT_DIR/ascii_art"/* "$INSTALL_DIR/ascii_art/" 2>/dev/null; then
            echo -e "${GREEN}   ✅ Copied ASCII art collection${RESET}"
        else
            echo -e "${YELLOW}   ⚠️  ASCII art copy completed with warnings${RESET}"
        fi
    else
        echo -e "${YELLOW}   ⚠️  ASCII art directory not found${RESET}"
    fi
}

# Create launcher script
create_launcher() {
    echo -e "${BLUE}🚀 Creating launcher script...${RESET}"
    
    local launcher_path="$BIN_DIR/zehrasec"
    
    cat > "$launcher_path" << EOF
#!/bin/bash
# ZehraSec Terminal Launcher
# Generated by Linux installer

INSTALL_DIR="$INSTALL_DIR"
PYTHON_CMD="$PYTHON_CMD"

cd "\$INSTALL_DIR"
exec "\$PYTHON_CMD" zehrasec_terminal.py "\$@"
EOF
    
    if chmod +x "$launcher_path"; then
        echo -e "${GREEN}   ✅ Created launcher: $launcher_path${RESET}"
    else
        echo -e "${RED}   ❌ Failed to make launcher executable${RESET}"
        return 1
    fi
}

# Setup shell integration
setup_shell_integration() {
    echo -e "${BLUE}🐚 Setting up shell integration...${RESET}"
    
    # Detect shell
    local shell_name
    shell_name=$(basename "$SHELL")
    
    # Determine config files to modify
    local config_files=()
    case "$shell_name" in
        "bash")
            config_files+=("$HOME/.bashrc")
            [[ -f "$HOME/.bash_profile" ]] && config_files+=("$HOME/.bash_profile")
            ;;
        "zsh")
            config_files+=("$HOME/.zshrc")
            ;;
        "fish")
            config_files+=("$HOME/.config/fish/config.fish")
            ;;
        *)
            config_files+=("$HOME/.bashrc")  # Fallback
            ;;
    esac
    
    # Shell configuration content
    local shell_config
    read -r -d '' shell_config << 'EOF' || true

# ZehraSec Terminal Configuration (added by installer)
export PATH="$PATH:$HOME/.local/bin"
alias zehrasec="$HOME/.local/bin/zehrasec"
alias zt="zehrasec"  # Short alias

# ZehraSec info function
zehrasec-info() {
    echo "🛡️  ZehraSec Terminal v2.2.0"
    echo "📍 Install: $HOME/.local/share/zehrasec"
    echo "🚀 Run: zehrasec"
}
EOF
    
    local updated=false
    for config_file in "${config_files[@]}"; do
        # Create config file if it doesn't exist
        if [[ ! -f "$config_file" ]]; then
            mkdir -p "$(dirname "$config_file")"
            touch "$config_file"
        fi
        
        # Check if ZehraSec config already exists
        if grep -q "ZehraSec Terminal Configuration" "$config_file" 2>/dev/null; then
            echo -e "${YELLOW}   ⚠️  Shell integration already present in $(basename "$config_file")${RESET}"
            updated=true
            continue
        fi
        
        # Add configuration
        if echo "$shell_config" >> "$config_file"; then
            echo -e "${GREEN}   ✅ Added shell integration to $(basename "$config_file")${RESET}"
            updated=true
        else
            echo -e "${YELLOW}   ⚠️  Failed to modify $(basename "$config_file")${RESET}"
        fi
    done
    
    if $updated; then
        echo -e "${CYAN}   💡 Run 'source ~/.bashrc' or restart your terminal${RESET}"
    fi
}

# Create desktop entry
create_desktop_entry() {
    echo -e "${BLUE}🖥️  Creating desktop entry...${RESET}"
    
    local applications_dir="$HOME/.local/share/applications"
    mkdir -p "$applications_dir"
    
    local desktop_file="$applications_dir/zehrasec-terminal.desktop"
    
    cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ZehraSec Terminal
Comment=Enhanced Security Terminal Interface by Yashab Alam
Exec=$BIN_DIR/zehrasec
Icon=terminal
Terminal=true
Categories=System;TerminalEmulator;Security;
Keywords=terminal;security;zehrasec;cybersecurity;
StartupNotify=true
EOF
    
    if chmod 644 "$desktop_file"; then
        echo -e "${GREEN}   ✅ Created desktop entry${RESET}"
    else
        echo -e "${YELLOW}   ⚠️  Desktop entry creation failed${RESET}"
    fi
}

# Run installation tests
run_tests() {
    echo -e "${BLUE}🧪 Running installation tests...${RESET}"
    
    # Test Python installation
    if $PYTHON_CMD --version &> /dev/null; then
        echo -e "${GREEN}   ✅ Python installation verified${RESET}"
    else
        echo -e "${RED}   ❌ Python test failed${RESET}"
        return 1
    fi
    
    # Test package imports
    if cd "$INSTALL_DIR" && $PYTHON_CMD test.py 2>/dev/null | grep -q "ALL TESTS PASSED"; then
        echo -e "${GREEN}   ✅ All package imports successful${RESET}"
    else
        echo -e "${YELLOW}   ⚠️  Some package tests failed${RESET}"
    fi
    
    # Test launcher
    if [[ -x "$BIN_DIR/zehrasec" ]]; then
        echo -e "${GREEN}   ✅ Launcher script is executable${RESET}"
    else
        echo -e "${RED}   ❌ Launcher script test failed${RESET}"
        return 1
    fi
}

# Show completion message
show_completion() {
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║                    🎉 LINUX INSTALLATION COMPLETED! 🎉                       ║"
    echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${CYAN}🚀 ZehraSec Terminal v2.2.0 is now installed on $DISTRO!${RESET}"
    echo
    echo -e "${YELLOW}📍 Installation Details:${RESET}"
    echo -e "${WHITE}   • Distribution: $DISTRO${RESET}"
    echo -e "${WHITE}   • Install Directory: $INSTALL_DIR${RESET}"
    echo -e "${WHITE}   • Config Directory:  $CONFIG_DIR${RESET}"
    echo -e "${WHITE}   • Launcher Script:   $BIN_DIR/zehrasec${RESET}"
    echo
    echo -e "${YELLOW}🏃 How to Run:${RESET}"
    echo -e "${GREEN}   # Recommended method:
   zehrasec${RESET}"
    echo
    echo -e "${GREEN}   # Short alias:
   zt${RESET}"
    echo
    echo -e "${GREEN}   # Direct execution:
   cd $INSTALL_DIR
   $PYTHON_CMD zehrasec_terminal.py${RESET}"
    echo
    echo -e "${YELLOW}🔄 Apply Shell Changes:${RESET}"
    echo -e "${CYAN}   # Reload shell configuration:
   source ~/.bashrc
   
   # Or open a new terminal${RESET}"
    echo
    echo -e "${YELLOW}🖥️  Desktop Integration:${RESET}"
    echo -e "${WHITE}   • Desktop entry created for GUI launchers
   • Search for 'ZehraSec Terminal' in your applications${RESET}"
    echo
    echo -e "${YELLOW}🎨 First Run:${RESET}"
    echo -e "${WHITE}   1. Run 'zehrasec' to start
   2. Set up your secure password
   3. Explore 50+ themes with 'changebanner'
   4. Customize your prompt with 'changeprompt'
   5. Type 'help' for all available commands${RESET}"
    echo
    echo -e "${YELLOW}📚 Additional Commands:${RESET}"
    echo -e "${WHITE}   • zehrasec-info  - Show installation info
   • zt             - Short alias for zehrasec${RESET}"
    echo
    echo -e "${YELLOW}🔗 Links & Support:${RESET}"
    echo -e "${WHITE}   • GitHub Repository: https://github.com/yashab-cyber/terminal-edits
   • Support Email:     yashabalam707@gmail.com
   • Donations:         See DONATE.md or https://paypal.me/yashab07${RESET}"
    echo
    echo -e "${MAGENTA}🛡️ Developed by Yashab Alam - Founder & CEO of ZehraSec 🛡️${RESET}"
    echo -e "${CYAN}Thank you for using ZehraSec Terminal on Linux!${RESET}"
    echo
}

# Main installation function
main() {
    # System detection
    detect_distribution
    detect_package_manager || {
        echo -e "${RED}❌ No supported package manager found${RESET}"
        exit 1
    }
    detect_python || {
        echo -e "${RED}❌ Python 3.7+ is required${RESET}"
        exit 1
    }
    detect_sudo
    
    # Show system information
    print_header
    
    # Confirmation prompt
    echo -e "${YELLOW}⚠️  This will install ZehraSec Terminal on your $DISTRO system.${RESET}"
    echo -e "${CYAN}   Installation will modify your shell configuration${RESET}"
    echo
    read -p "$(echo -e "${BOLD}Continue with installation? [Y/n]: ${RESET}")" -r
    
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Installation cancelled by user${RESET}"
        exit 0
    fi
    
    echo
    echo -e "${BOLD}🔧 Starting ZehraSec Terminal installation...${RESET}"
    echo
    
    # Installation steps
    local steps=(
        "update_repositories:Updating package repositories"
        "install_system_packages:Installing system packages"
        "install_python_packages:Installing Python packages"
        "setup_directories:Setting up directories"
        "copy_files:Copying application files"
        "create_launcher:Creating launcher script"
        "setup_shell_integration:Setting up shell integration"
        "create_desktop_entry:Creating desktop entry"
        "run_tests:Running installation tests"
    )
    
    local completed=0
    for step in "${steps[@]}"; do
        local func_name="${step%:*}"
        local step_desc="${step#*:}"
        
        echo -e "${BOLD}🔧 $step_desc...${RESET}"
        
        if $func_name; then
            echo -e "${GREEN}✅ $step_desc completed${RESET}"
            ((completed++))
        else
            echo -e "${RED}❌ $step_desc failed${RESET}"
            if [[ $completed -lt 5 ]]; then  # Critical steps
                echo -e "${RED}💀 Installation aborted${RESET}"
                exit 1
            fi
        fi
        echo
    done
    
    # Show completion
    if [[ $completed -ge 7 ]]; then
        show_completion
    else
        echo -e "${YELLOW}⚠️  Installation completed with warnings${RESET}"
    fi
}

# Handle command line arguments
case "${1:-}" in
    --help|-h|help)
        echo -e "${CYAN}ZehraSec Terminal - Linux Installer v2.2.0${RESET}"
        echo -e "${YELLOW}Usage: bash install-linux.sh [options]${RESET}"
        echo
        echo -e "${GREEN}Options:${RESET}"
        echo "  --help, -h        Show this help message"
        echo "  --force, -f       Force installation without prompts"
        echo "  --test, -t        Run system tests only"
        echo "  --info, -i        Show system information only"
        echo
        echo -e "${GREEN}Examples:${RESET}"
        echo "  bash install-linux.sh              # Interactive installation"
        echo "  bash install-linux.sh --force      # Force install"
        echo "  bash install-linux.sh --test       # Test only"
        echo
        echo -e "${MAGENTA}🛡️ Developed by Yashab Alam - CEO of ZehraSec 🛡️${RESET}"
        exit 0
        ;;
    --test|-t|test)
        detect_distribution
        detect_package_manager
        detect_python
        detect_sudo
        print_header
        run_tests
        exit $?
        ;;
    --info|-i|info)
        detect_distribution
        detect_package_manager
        detect_python
        detect_sudo
        print_header
        exit 0
        ;;
    --force|-f|force)
        # Skip confirmation in main()
        export FORCE_INSTALL=1
        ;;
    *)
        if [[ -n "${1:-}" ]]; then
            echo -e "${RED}❌ Unknown option: $1${RESET}"
            echo -e "${CYAN}   Use --help for usage information${RESET}"
            exit 1
        fi
        ;;
esac

# Run main installation
main
