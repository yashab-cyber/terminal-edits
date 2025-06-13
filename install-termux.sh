#!/data/data/com.termux/files/usr/bin/bash
# ZehraSec Terminal - Termux Optimized Installation Script
# Enhanced installer specifically designed for Termux environment
# Version: 2.2.0
#
# Developed by: Yashab Alam - Founder & CEO of ZehraSec
# GitHub Repository: https://github.com/yashab-cyber/terminal-edits
# Support Email: yashabalam707@gmail.com
# Donation Support: See DONATE.md for donation options

# Color definitions
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'

# Termux specific paths
TERMUX_PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
TERMUX_HOME="${HOME:-/data/data/com.termux/files/home}"
INSTALL_DIR="$TERMUX_HOME/.local/share/zehrasec"
BIN_DIR="$TERMUX_PREFIX/bin"
CONFIG_DIR="$TERMUX_HOME/.zehrasec"

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║                    🛡️  ZehraSec Terminal for Termux v2.2.0  🛡️              ║"
    echo -e "║                     Enhanced Security Terminal Interface                     ║"
    echo -e "║                  Developed by Yashab Alam - CEO of ZehraSec                 ║"
    echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${GREEN}📱 Termux Environment Detected:${RESET}"
    echo -e "${YELLOW}   • Termux Version: ${TERMUX_VERSION:-Unknown}${RESET}"
    echo -e "${YELLOW}   • Prefix: $TERMUX_PREFIX${RESET}"
    echo -e "${YELLOW}   • Home: $TERMUX_HOME${RESET}"
    echo -e "${YELLOW}   • Install Directory: $INSTALL_DIR${RESET}"
    echo
}

check_termux() {
    if [[ -z "$TERMUX_VERSION" ]] && [[ ! -d "/data/data/com.termux" ]]; then
        echo -e "${RED}❌ This script is designed for Termux environment${RESET}"
        echo -e "${CYAN}   For regular Linux, use: python3 install.py${RESET}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Termux environment confirmed${RESET}"
}

update_packages() {
    echo -e "${BLUE}📦 Updating Termux packages...${RESET}"
    
    pkg update -y
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✅ Package repositories updated${RESET}"
    else
        echo -e "${YELLOW}⚠️  Package update completed with warnings${RESET}"
    fi
}

install_dependencies() {
    echo -e "${BLUE}📦 Installing required packages...${RESET}"
    
    # Essential packages for Termux
    PACKAGES=(
        "python"           # Python 3
        "python-pip"       # Python package installer
        "git"              # Version control
        "curl"             # Data transfer
        "figlet"           # ASCII art generator
        "bc"               # Calculator
        "termux-api"       # Termux API access
        "openssh"          # SSH client
        "nano"             # Text editor
        "which"            # Command finder
    )
    
    echo -e "${YELLOW}Installing essential packages...${RESET}"
    
    for package in "${PACKAGES[@]}"; do
        echo -e "${YELLOW}   Installing $package...${RESET}"
        pkg install -y "$package" 2>/dev/null
        
        if pkg list-installed | grep -q "^$package"; then
            echo -e "${GREEN}   ✅ $package installed${RESET}"
        else
            echo -e "${YELLOW}   ⚠️  $package installation warning (may already exist)${RESET}"
        fi
    done
    
    echo -e "${GREEN}✅ Package installation completed${RESET}"
}

setup_storage() {
    echo -e "${BLUE}📱 Setting up Termux storage access...${RESET}"
    
    # Setup storage access for Termux
    if [[ ! -d "$TERMUX_HOME/storage" ]]; then
        echo -e "${YELLOW}   Requesting storage permission...${RESET}"
        termux-setup-storage
        
        if [[ -d "$TERMUX_HOME/storage" ]]; then
            echo -e "${GREEN}   ✅ Storage access granted${RESET}"
        else
            echo -e "${YELLOW}   ⚠️  Storage access not configured (optional)${RESET}"
        fi
    else
        echo -e "${GREEN}   ✅ Storage access already configured${RESET}"
    fi
}

install_python_packages() {
    echo -e "${BLUE}🐍 Installing Python packages...${RESET}"
    
    # Upgrade pip first
    echo -e "${YELLOW}   Upgrading pip...${RESET}"
    python -m pip install --upgrade pip --user
    
    # Create requirements.txt if it doesn't exist
    if [[ ! -f "$SCRIPT_DIR/requirements.txt" ]]; then
        echo -e "${YELLOW}   Creating requirements.txt...${RESET}"
        cat > "$SCRIPT_DIR/requirements.txt" << 'EOF'
colorama>=0.4.6
pyfiglet>=0.8.post1
bcrypt>=4.0.1
cryptography>=41.0.0
psutil>=5.9.0
rich>=13.7.0
click>=8.1.7
EOF
    fi
    
    # Install Python packages
    echo -e "${YELLOW}   Installing Python dependencies...${RESET}"
    python -m pip install -r "$SCRIPT_DIR/requirements.txt" --user
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✅ Python packages installed successfully${RESET}"
    else
        echo -e "${RED}❌ Python package installation failed${RESET}"
        return 1
    fi
}

setup_directories() {
    echo -e "${BLUE}📁 Setting up directories...${RESET}"
    
    # Create necessary directories
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$INSTALL_DIR/ascii_art"
    mkdir -p "$TERMUX_HOME/.local/bin"
    
    echo -e "${GREEN}   ✅ Created: $INSTALL_DIR${RESET}"
    echo -e "${GREEN}   ✅ Created: $CONFIG_DIR${RESET}"
    echo -e "${GREEN}   ✅ Created: $INSTALL_DIR/ascii_art${RESET}"
    
    echo -e "${GREEN}✅ Directory setup completed${RESET}"
}

copy_files() {
    echo -e "${BLUE}📄 Copying ZehraSec Terminal files...${RESET}"
    
    # Files to copy
    FILES=(
        "zehrasec_terminal.py"
        "launch.py"
        "demo.py"
        "test.py"
        "requirements.txt"
        "README_PYTHON.md"
        "INSTALL.md"
    )
    
    # Copy main files
    for file in "${FILES[@]}"; do
        if [[ -f "$SCRIPT_DIR/$file" ]]; then
            cp "$SCRIPT_DIR/$file" "$INSTALL_DIR/"
            echo -e "${GREEN}   ✅ Copied: $file${RESET}"
        else
            echo -e "${YELLOW}   ⚠️  File not found: $file${RESET}"
        fi
    done
    
    # Copy ASCII art directory
    if [[ -d "$SCRIPT_DIR/ascii_art" ]]; then
        cp -r "$SCRIPT_DIR/ascii_art"/* "$INSTALL_DIR/ascii_art/"
        echo -e "${GREEN}   ✅ Copied ASCII art collection${RESET}"
    else
        echo -e "${YELLOW}   ⚠️  ASCII art directory not found${RESET}"
    fi
    
    echo -e "${GREEN}✅ File copying completed${RESET}"
}

create_launcher() {
    echo -e "${BLUE}🚀 Creating Termux launcher...${RESET}"
    
    # Create launcher script in Termux bin directory
    LAUNCHER_PATH="$BIN_DIR/zehrasec"
    
    cat > "$LAUNCHER_PATH" << EOF
#!/data/data/com.termux/files/usr/bin/bash
# ZehraSec Terminal Launcher for Termux
# Generated by Termux installer

cd "$INSTALL_DIR"
exec python zehrasec_terminal.py "\$@"
EOF
    
    chmod +x "$LAUNCHER_PATH"
    
    # Also create a launcher in user's local bin
    USER_LAUNCHER="$TERMUX_HOME/.local/bin/zehrasec"
    cp "$LAUNCHER_PATH" "$USER_LAUNCHER"
    chmod +x "$USER_LAUNCHER"
    
    echo -e "${GREEN}   ✅ Created system launcher: $LAUNCHER_PATH${RESET}"
    echo -e "${GREEN}   ✅ Created user launcher: $USER_LAUNCHER${RESET}"
    
    echo -e "${GREEN}✅ Launcher creation completed${RESET}"
}

setup_termux_integration() {
    echo -e "${BLUE}🐚 Setting up Termux shell integration...${RESET}"
    
    # Termux uses bash by default
    BASHRC="$TERMUX_HOME/.bashrc"
    
    # Create .bashrc if it doesn't exist
    if [[ ! -f "$BASHRC" ]]; then
        touch "$BASHRC"
    fi
    
    # Check if ZehraSec configuration already exists
    if grep -q "ZehraSec Terminal" "$BASHRC"; then
        echo -e "${YELLOW}   ⚠️  Shell integration already present${RESET}"
    else
        # Add ZehraSec configuration
        cat >> "$BASHRC" << 'EOF'

# ZehraSec Terminal Configuration (added by Termux installer)
export PATH="$PATH:$HOME/.local/bin"
alias zehrasec="$HOME/.local/bin/zehrasec"
alias zt="zehrasec"  # Short alias

# ZehraSec welcome message (optional)
if [[ -f "$HOME/.local/share/zehrasec/zehrasec_terminal.py" ]]; then
    echo "🛡️  ZehraSec Terminal installed. Type 'zehrasec' to start."
fi
EOF
        
        echo -e "${GREEN}   ✅ Added shell integration to .bashrc${RESET}"
    fi
    
    # Create Termux shortcut (if termux-api is available)
    if command -v termux-create-shortcut &> /dev/null; then
        echo -e "${YELLOW}   Creating Termux app shortcut...${RESET}"
        termux-create-shortcut -n "ZehraSec Terminal" -c "zehrasec" 2>/dev/null || true
        echo -e "${GREEN}   ✅ Termux shortcut created (check your launcher)${RESET}"
    fi
    
    echo -e "${GREEN}✅ Termux integration completed${RESET}"
}

setup_termux_styling() {
    echo -e "${BLUE}🎨 Setting up Termux styling...${RESET}"
    
    # Create .termux directory if it doesn't exist
    TERMUX_CONFIG_DIR="$TERMUX_HOME/.termux"
    mkdir -p "$TERMUX_CONFIG_DIR"
    
    # Create termux.properties for optimal ZehraSec experience
    TERMUX_PROPS="$TERMUX_CONFIG_DIR/termux.properties"
    
    if [[ ! -f "$TERMUX_PROPS" ]]; then
        cat > "$TERMUX_PROPS" << 'EOF'
# Termux properties for optimal ZehraSec Terminal experience
# Generated by ZehraSec installer

# Enable true color support
terminal-color=true

# Set default shell
default-working-directory=/data/data/com.termux/files/home

# Bell settings
bell-character=ignore

# Hardware keyboard shortcuts
shortcut.create-session=ctrl + t
shortcut.next-session=ctrl + 2
shortcut.previous-session=ctrl + 1
shortcut.rename-session=ctrl + n

# ZehraSec Terminal shortcut
shortcut.zehrasec=ctrl + z
EOF
        
        echo -e "${GREEN}   ✅ Created optimal Termux configuration${RESET}"
        echo -e "${CYAN}   💡 Restart Termux to apply configuration changes${RESET}"
    else
        echo -e "${YELLOW}   ⚠️  Termux configuration already exists${RESET}"
    fi
    
    # Suggest color scheme
    echo -e "${CYAN}   💡 For best experience, consider using a dark color scheme${RESET}"
    echo -e "${CYAN}   💡 Run 'termux-setup-storage' if you haven't already${RESET}"
    
    echo -e "${GREEN}✅ Termux styling setup completed${RESET}"
}

run_tests() {
    echo -e "${BLUE}🧪 Running installation tests...${RESET}"
    
    # Test Python installation
    if python -c "import sys; print(f'Python {sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}')" 2>/dev/null; then
        echo -e "${GREEN}   ✅ Python installation verified${RESET}"
    else
        echo -e "${RED}   ❌ Python installation failed${RESET}"
        return 1
    fi
    
    # Test package imports
    echo -e "${YELLOW}   Testing Python package imports...${RESET}"
    if cd "$INSTALL_DIR" && python test.py 2>/dev/null | grep -q "ALL TESTS PASSED"; then
        echo -e "${GREEN}   ✅ All package imports successful${RESET}"
    else
        echo -e "${YELLOW}   ⚠️  Some package tests failed (may still work)${RESET}"
    fi
    
    # Test launcher
    if [[ -x "$BIN_DIR/zehrasec" ]]; then
        echo -e "${GREEN}   ✅ Launcher script created and executable${RESET}"
    else
        echo -e "${RED}   ❌ Launcher script creation failed${RESET}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Installation tests completed${RESET}"
}

show_completion() {
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║                    🎉 TERMUX INSTALLATION COMPLETED! 🎉                      ║"
    echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${CYAN}🚀 ZehraSec Terminal v2.2.0 is now installed in Termux!${RESET}"
    echo
    echo -e "${YELLOW}📍 Installation Details:${RESET}"
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
   python zehrasec_terminal.py${RESET}"
    echo
    echo -e "${YELLOW}🔄 Apply Shell Changes:${RESET}"
    echo -e "${CYAN}   # Reload bash configuration:
   source ~/.bashrc
   
   # Or restart Termux${RESET}"
    echo
    echo -e "${YELLOW}📱 Termux Specific Features:${RESET}"
    echo -e "${WHITE}   • App shortcut created (check your launcher)
   • Optimized configuration for mobile
   • Storage access configured
   • True color support enabled${RESET}"
    echo
    echo -e "${YELLOW}🎨 First Run:${RESET}"
    echo -e "${WHITE}   1. Run 'zehrasec' to start
   2. Set up your secure password
   3. Explore themes with 'changebanner'
   4. Customize prompt with 'changeprompt'
   5. Type 'help' for all commands${RESET}"
    echo
    echo -e "${YELLOW}💡 Termux Tips:${RESET}"
    echo -e "${WHITE}   • Use volume down + specific keys for shortcuts
   • Swipe from left edge to access sessions
   • Long press terminal for context menu
   • Use 'pkg upgrade' to keep packages updated${RESET}"
    echo
    echo -e "${YELLOW}🔗 Links & Support:${RESET}"
    echo -e "${WHITE}   • GitHub Repository: https://github.com/yashab-cyber/terminal-edits
   • Support Email:     yashabalam707@gmail.com
   • Donations:         See DONATE.md or https://paypal.me/yashab07${RESET}"
    echo
    echo -e "${MAGENTA}🛡️ Developed by Yashab Alam - Founder & CEO of ZehraSec 🛡️${RESET}"
    echo -e "${CYAN}Thank you for using ZehraSec Terminal on Termux!${RESET}"
    echo
}

main() {
    # Check if running in Termux
    check_termux
    
    # Show header
    print_header
    
    # Confirmation prompt
    echo -e "${YELLOW}⚠️  This will install ZehraSec Terminal optimized for Termux.${RESET}"
    echo -e "${CYAN}   Installation will modify your .bashrc and create shortcuts${RESET}"
    echo
    read -p "$(echo -e ${BOLD}Continue with Termux installation? [Y/n]: ${RESET})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Installation cancelled by user${RESET}"
        exit 0
    fi
    
    echo
    echo -e "${BOLD}🔧 Starting ZehraSec Terminal installation for Termux...${RESET}"
    echo
    
    # Installation steps
    update_packages || { echo -e "${RED}Failed to update packages${RESET}"; exit 1; }
    echo
    
    install_dependencies || { echo -e "${RED}Failed to install dependencies${RESET}"; exit 1; }
    echo
    
    setup_storage
    echo
    
    install_python_packages || { echo -e "${RED}Failed to install Python packages${RESET}"; exit 1; }
    echo
    
    setup_directories || { echo -e "${RED}Failed to setup directories${RESET}"; exit 1; }
    echo
    
    copy_files || { echo -e "${RED}Failed to copy files${RESET}"; exit 1; }
    echo
    
    create_launcher || { echo -e "${RED}Failed to create launcher${RESET}"; exit 1; }
    echo
    
    setup_termux_integration || { echo -e "${RED}Failed to setup shell integration${RESET}"; exit 1; }
    echo
    
    setup_termux_styling
    echo
    
    run_tests
    echo
    
    # Show completion message
    show_completion
}

# Handle command line arguments
case "${1:-}" in
    --help|-h|help)
        echo -e "${CYAN}ZehraSec Terminal - Termux Installer v2.2.0${RESET}"
        echo -e "${YELLOW}Usage: bash install-termux.sh [options]${RESET}"
        echo
        echo -e "${GREEN}Options:${RESET}"
        echo "  --help, -h        Show this help message"
        echo "  --force, -f       Force installation without prompts"
        echo "  --test, -t        Run system tests only"
        echo
        echo -e "${GREEN}Examples:${RESET}"
        echo "  bash install-termux.sh              # Interactive installation"
        echo "  bash install-termux.sh --force      # Force install"
        echo "  bash install-termux.sh --test       # Test only"
        echo
        echo -e "${MAGENTA}🛡️ Developed by Yashab Alam - CEO of ZehraSec 🛡️${RESET}"
        exit 0
        ;;
    --test|-t|test)
        print_header
        run_tests
        exit $?
        ;;
    --force|-f|force)
        # Skip confirmation
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
