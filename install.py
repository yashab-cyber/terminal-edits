#!/usr/bin/env python3
"""
ZehraSec Terminal - Advanced Installation Script
Universal installer for Linux, Termux, and Unix-like systems
Version: 2.2.0

Developed by: Yashab Alam - Founder & CEO of ZehraSec
GitHub Repository: https://github.com/yashab-cyber/terminal-edits
Support Email: yashabalam707@gmail.com
Donation Support: See DONATE.md for donation options

License: MIT
"""

import os
import sys
import subprocess
import platform
import shutil
import json
import time
import urllib.request
from pathlib import Path
from typing import Dict, List, Optional, Tuple

class Colors:
    """Color codes for terminal output"""
    RED = '\033[1;31m'
    GREEN = '\033[1;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[1;34m'
    MAGENTA = '\033[1;35m'
    CYAN = '\033[1;36m'
    WHITE = '\033[1;37m'
    BOLD = '\033[1m'
    RESET = '\033[0m'

class SystemDetector:
    """Detect system type and package manager"""
    
    def __init__(self):
        self.system = platform.system().lower()
        self.machine = platform.machine().lower()
        self.is_termux = self._detect_termux()
        self.is_android = self._detect_android()
        self.package_manager = self._detect_package_manager()
        self.python_cmd = self._detect_python()
        
    def _detect_termux(self) -> bool:
        """Detect if running in Termux"""
        return (
            os.environ.get('TERMUX_VERSION') is not None or
            os.path.exists('/data/data/com.termux') or
            'termux' in os.environ.get('HOME', '').lower() or
            'com.termux' in os.environ.get('PREFIX', '')
        )
    
    def _detect_android(self) -> bool:
        """Detect if running on Android"""
        return (
            self.is_termux or
            os.path.exists('/system/build.prop') or
            'android' in self.system
        )
    
    def _detect_package_manager(self) -> Optional[str]:
        """Detect available package manager"""
        managers = {
            'pkg': 'pkg',           # Termux
            'apt': 'apt-get',       # Debian/Ubuntu
            'apt-get': 'apt-get',   # Debian/Ubuntu
            'yum': 'yum',           # RedHat/CentOS
            'dnf': 'dnf',           # Fedora
            'pacman': 'pacman',     # Arch Linux
            'zypper': 'zypper',     # openSUSE
            'apk': 'apk',           # Alpine Linux
            'emerge': 'emerge',     # Gentoo
            'brew': 'brew',         # macOS/Linux Homebrew
        }
        
        for manager in managers:
            if shutil.which(manager):
                return manager
        
        return None
    
    def _detect_python(self) -> str:
        """Detect Python command"""
        for cmd in ['python3', 'python', 'python3.11', 'python3.10', 'python3.9']:
            if shutil.which(cmd):
                try:
                    result = subprocess.run([cmd, '--version'], 
                                         capture_output=True, text=True)
                    if result.returncode == 0 and 'Python 3.' in result.stdout:
                        return cmd
                except:
                    continue
        return 'python3'

class ZehraSecInstaller:
    """Main installer class"""
    
    def __init__(self):
        self.detector = SystemDetector()
        self.script_dir = Path(__file__).parent.absolute()
        self.home_dir = Path.home()
        self.config_dir = self.home_dir / '.zehrasec'
        self.install_dir = self.home_dir / '.local' / 'share' / 'zehrasec'
        self.bin_dir = self.home_dir / '.local' / 'bin'
        
        # Termux specific paths
        if self.detector.is_termux:
            self.install_dir = Path(os.environ.get('PREFIX', '/data/data/com.termux/files/usr')) / 'share' / 'zehrasec'
            self.bin_dir = Path(os.environ.get('PREFIX', '/data/data/com.termux/files/usr')) / 'bin'
        
        self.required_packages = {
            'python3': 'Python 3.7+',
            'python3-pip': 'Python package installer',
            'git': 'Version control system',
            'curl': 'Data transfer tool',
            'figlet': 'ASCII art generator (optional)',
            'bc': 'Calculator (optional)',
        }
        
        # Termux package names are different
        if self.detector.is_termux:
            self.required_packages = {
                'python': 'Python 3.7+',
                'python-pip': 'Python package installer', 
                'git': 'Version control system',
                'curl': 'Data transfer tool',
                'figlet': 'ASCII art generator (optional)',
                'bc': 'Calculator (optional)',
            }
    
    def print_header(self):
        """Print installation header"""
        header = f"""
{Colors.CYAN}╔══════════════════════════════════════════════════════════════════════════════╗
║                    🛡️  ZehraSec Terminal Installer v2.2.0  🛡️                ║
║                     Enhanced Security Terminal Interface                     ║
║                  Developed by Yashab Alam - CEO of ZehraSec                 ║
╚══════════════════════════════════════════════════════════════════════════════╝{Colors.RESET}

{Colors.GREEN}🖥️  System Information:{Colors.RESET}
{Colors.YELLOW}   • System: {self.detector.system.title()}{Colors.RESET}
{Colors.YELLOW}   • Architecture: {self.detector.machine}{Colors.RESET}
{Colors.YELLOW}   • Termux: {'✅ Yes' if self.detector.is_termux else '❌ No'}{Colors.RESET}
{Colors.YELLOW}   • Android: {'✅ Yes' if self.detector.is_android else '❌ No'}{Colors.RESET}
{Colors.YELLOW}   • Package Manager: {self.detector.package_manager or 'Not detected'}{Colors.RESET}
{Colors.YELLOW}   • Python Command: {self.detector.python_cmd}{Colors.RESET}

"""
        print(header)
    
    def check_root_permissions(self) -> bool:
        """Check if running with appropriate permissions"""
        if self.detector.is_termux:
            # Termux doesn't need root
            return True
        
        # For system-wide installation, check if we have sudo access
        if os.geteuid() == 0:
            return True
        
        # Check if sudo is available
        if shutil.which('sudo'):
            try:
                result = subprocess.run(['sudo', '-n', 'true'], 
                                      capture_output=True, timeout=5)
                return result.returncode == 0
            except:
                return False
        
        return False
    
    def update_package_manager(self) -> bool:
        """Update package manager repositories"""
        print(f"{Colors.BLUE}📦 Updating package repositories...{Colors.RESET}")
        
        update_commands = {
            'pkg': ['pkg', 'update', '-y'],
            'apt': ['sudo', 'apt', 'update'],
            'apt-get': ['sudo', 'apt-get', 'update'],
            'yum': ['sudo', 'yum', 'check-update'],
            'dnf': ['sudo', 'dnf', 'check-update'],
            'pacman': ['sudo', 'pacman', '-Sy'],
            'zypper': ['sudo', 'zypper', 'refresh'],
            'apk': ['sudo', 'apk', 'update'],
            'brew': ['brew', 'update'],
        }
        
        manager = self.detector.package_manager
        if not manager or manager not in update_commands:
            print(f"{Colors.YELLOW}⚠️  Unknown package manager, skipping update{Colors.RESET}")
            return True
        
        cmd = update_commands[manager]
        
        # Remove sudo for Termux
        if self.detector.is_termux and 'sudo' in cmd:
            cmd = [c for c in cmd if c != 'sudo']
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
            if result.returncode == 0:
                print(f"{Colors.GREEN}✅ Package repositories updated{Colors.RESET}")
                return True
            else:
                print(f"{Colors.YELLOW}⚠️  Package update warning: {result.stderr[:100]}{Colors.RESET}")
                return True  # Continue even if update fails
        except subprocess.TimeoutExpired:
            print(f"{Colors.YELLOW}⚠️  Package update timed out, continuing...{Colors.RESET}")
            return True
        except Exception as e:
            print(f"{Colors.YELLOW}⚠️  Package update failed: {e}{Colors.RESET}")
            return True
    
    def install_system_packages(self) -> bool:
        """Install required system packages"""
        print(f"{Colors.BLUE}📦 Installing system packages...{Colors.RESET}")
        
        install_commands = {
            'pkg': ['pkg', 'install', '-y'],
            'apt': ['sudo', 'apt', 'install', '-y'],
            'apt-get': ['sudo', 'apt-get', 'install', '-y'],
            'yum': ['sudo', 'yum', 'install', '-y'],
            'dnf': ['sudo', 'dnf', 'install', '-y'],
            'pacman': ['sudo', 'pacman', '-S', '--noconfirm'],
            'zypper': ['sudo', 'zypper', 'install', '-y'],
            'apk': ['sudo', 'apk', 'add'],
            'brew': ['brew', 'install'],
        }
        
        manager = self.detector.package_manager
        if not manager:
            print(f"{Colors.RED}❌ No package manager detected{Colors.RESET}")
            return False
        
        if manager not in install_commands:
            print(f"{Colors.YELLOW}⚠️  Unsupported package manager: {manager}{Colors.RESET}")
            return False
        
        base_cmd = install_commands[manager]
        
        # Remove sudo for Termux
        if self.detector.is_termux and 'sudo' in base_cmd:
            base_cmd = [c for c in base_cmd if c != 'sudo']
        
        # Install packages one by one
        success_count = 0
        for package, description in self.required_packages.items():
            print(f"{Colors.YELLOW}   Installing {package} ({description})...{Colors.RESET}")
            
            cmd = base_cmd + [package]
            
            try:
                result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
                if result.returncode == 0:
                    print(f"{Colors.GREEN}   ✅ {package} installed successfully{Colors.RESET}")
                    success_count += 1
                else:
                    print(f"{Colors.YELLOW}   ⚠️  {package} installation warning (may already be installed){Colors.RESET}")
                    success_count += 1  # Continue anyway
            except subprocess.TimeoutExpired:
                print(f"{Colors.RED}   ❌ {package} installation timed out{Colors.RESET}")
            except Exception as e:
                print(f"{Colors.RED}   ❌ {package} installation failed: {e}{Colors.RESET}")
        
        if success_count >= 3:  # At least python, pip, and git
            print(f"{Colors.GREEN}✅ Essential packages installed ({success_count}/{len(self.required_packages)}){Colors.RESET}")
            return True
        else:
            print(f"{Colors.RED}❌ Failed to install essential packages{Colors.RESET}")
            return False
    
    def install_python_packages(self) -> bool:
        """Install Python packages"""
        print(f"{Colors.BLUE}🐍 Installing Python packages...{Colors.RESET}")
        
        # Check if requirements.txt exists
        requirements_file = self.script_dir / 'requirements.txt'
        if not requirements_file.exists():
            print(f"{Colors.YELLOW}⚠️  requirements.txt not found, creating minimal requirements{Colors.RESET}")
            self.create_requirements_file()
        
        # Upgrade pip first
        pip_upgrade_cmd = [self.detector.python_cmd, '-m', 'pip', 'install', '--upgrade', 'pip']
        if self.detector.is_termux:
            pip_upgrade_cmd.append('--user')
        
        try:
            print(f"{Colors.YELLOW}   Upgrading pip...{Colors.RESET}")
            subprocess.run(pip_upgrade_cmd, capture_output=True, timeout=120)
            print(f"{Colors.GREEN}   ✅ pip upgraded{Colors.RESET}")
        except:
            print(f"{Colors.YELLOW}   ⚠️  pip upgrade failed, continuing...{Colors.RESET}")
        
        # Install packages
        install_cmd = [self.detector.python_cmd, '-m', 'pip', 'install', '-r', str(requirements_file)]
        if self.detector.is_termux:
            install_cmd.append('--user')
        
        try:
            result = subprocess.run(install_cmd, capture_output=True, text=True, timeout=600)
            if result.returncode == 0:
                print(f"{Colors.GREEN}✅ Python packages installed successfully{Colors.RESET}")
                return True
            else:
                print(f"{Colors.RED}❌ Python package installation failed:{Colors.RESET}")
                print(f"{Colors.RED}{result.stderr}{Colors.RESET}")
                return False
        except subprocess.TimeoutExpired:
            print(f"{Colors.RED}❌ Python package installation timed out{Colors.RESET}")
            return False
        except Exception as e:
            print(f"{Colors.RED}❌ Python package installation error: {e}{Colors.RESET}")
            return False
    
    def create_requirements_file(self):
        """Create requirements.txt if it doesn't exist"""
        requirements_content = """colorama>=0.4.6
pyfiglet>=0.8.post1
bcrypt>=4.0.1
cryptography>=41.0.0
psutil>=5.9.0
rich>=13.7.0
click>=8.1.7
"""
        requirements_file = self.script_dir / 'requirements.txt'
        requirements_file.write_text(requirements_content)
        print(f"{Colors.GREEN}   ✅ Created requirements.txt{Colors.RESET}")
    
    def setup_directories(self) -> bool:
        """Create necessary directories"""
        print(f"{Colors.BLUE}📁 Setting up directories...{Colors.RESET}")
        
        directories = [
            self.config_dir,
            self.install_dir,
            self.bin_dir,
            self.install_dir / 'ascii_art',
        ]
        
        for directory in directories:
            try:
                directory.mkdir(parents=True, exist_ok=True)
                print(f"{Colors.GREEN}   ✅ Created: {directory}{Colors.RESET}")
            except Exception as e:
                print(f"{Colors.RED}   ❌ Failed to create {directory}: {e}{Colors.RESET}")
                return False
        
        return True
    
    def copy_files(self) -> bool:
        """Copy ZehraSec Terminal files"""
        print(f"{Colors.BLUE}📄 Copying ZehraSec Terminal files...{Colors.RESET}")
        
        files_to_copy = [
            'zehrasec_terminal.py',
            'launch.py',
            'demo.py',
            'test.py',
            'requirements.txt',
        ]
        
        # Copy main files
        for file_name in files_to_copy:
            src = self.script_dir / file_name
            dst = self.install_dir / file_name
            
            if src.exists():
                try:
                    shutil.copy2(src, dst)
                    print(f"{Colors.GREEN}   ✅ Copied: {file_name}{Colors.RESET}")
                except Exception as e:
                    print(f"{Colors.RED}   ❌ Failed to copy {file_name}: {e}{Colors.RESET}")
                    return False
            else:
                print(f"{Colors.YELLOW}   ⚠️  File not found: {file_name}{Colors.RESET}")
        
        # Copy ASCII art directory
        src_ascii = self.script_dir / 'ascii_art'
        dst_ascii = self.install_dir / 'ascii_art'
        
        if src_ascii.exists():
            try:
                if dst_ascii.exists():
                    shutil.rmtree(dst_ascii)
                shutil.copytree(src_ascii, dst_ascii)
                print(f"{Colors.GREEN}   ✅ Copied ASCII art collection{Colors.RESET}")
            except Exception as e:
                print(f"{Colors.RED}   ❌ Failed to copy ASCII art: {e}{Colors.RESET}")
                return False
        
        return True
    
    def create_launcher_script(self) -> bool:
        """Create launcher script"""
        print(f"{Colors.BLUE}🚀 Creating launcher script...{Colors.RESET}")
        
        launcher_content = f"""#!/usr/bin/env bash
# ZehraSec Terminal Launcher
# Generated by installer

INSTALL_DIR="{self.install_dir}"
PYTHON_CMD="{self.detector.python_cmd}"

cd "$INSTALL_DIR"
exec "$PYTHON_CMD" zehrasec_terminal.py "$@"
"""
        
        launcher_path = self.bin_dir / 'zehrasec'
        
        try:
            launcher_path.write_text(launcher_content)
            launcher_path.chmod(0o755)
            print(f"{Colors.GREEN}   ✅ Created launcher: {launcher_path}{Colors.RESET}")
            return True
        except Exception as e:
            print(f"{Colors.RED}   ❌ Failed to create launcher: {e}{Colors.RESET}")
            return False
    
    def setup_shell_integration(self) -> bool:
        """Setup shell integration"""
        print(f"{Colors.BLUE}🐚 Setting up shell integration...{Colors.RESET}")
        
        # Detect shell
        shell = os.environ.get('SHELL', '/bin/bash')
        shell_name = Path(shell).name
        
        # Determine shell config file
        shell_configs = {
            'bash': ['.bashrc', '.bash_profile'],
            'zsh': ['.zshrc'],
            'fish': ['.config/fish/config.fish'],
            'tcsh': ['.tcshrc'],
            'csh': ['.cshrc'],
        }
        
        config_files = shell_configs.get(shell_name, ['.bashrc'])
        
        # PATH addition
        path_line = f'export PATH="$PATH:{self.bin_dir}"'
        alias_line = f'alias zehrasec="{self.bin_dir}/zehrasec"'
        
        success = False
        for config_file in config_files:
            config_path = self.home_dir / config_file
            
            try:
                # Read existing content
                if config_path.exists():
                    content = config_path.read_text()
                else:
                    content = ""
                
                # Check if already added
                if 'zehrasec' in content and str(self.bin_dir) in content:
                    print(f"{Colors.YELLOW}   ⚠️  Shell integration already present in {config_file}{Colors.RESET}")
                    success = True
                    continue
                
                # Add ZehraSec configuration
                zehrasec_config = f"""

# ZehraSec Terminal Configuration (added by installer)
{path_line}
{alias_line}

"""
                
                # Append to config file
                with open(config_path, 'a') as f:
                    f.write(zehrasec_config)
                
                print(f"{Colors.GREEN}   ✅ Added shell integration to {config_file}{Colors.RESET}")
                success = True
                break
                
            except Exception as e:
                print(f"{Colors.YELLOW}   ⚠️  Failed to modify {config_file}: {e}{Colors.RESET}")
                continue
        
        if success:
            print(f"{Colors.GREEN}✅ Shell integration completed{Colors.RESET}")
            print(f"{Colors.CYAN}   💡 Run 'source ~/.bashrc' or restart your terminal{Colors.RESET}")
        else:
            print(f"{Colors.YELLOW}⚠️  Manual shell setup required{Colors.RESET}")
            print(f"{Colors.CYAN}   💡 Add to your shell config: {path_line}{Colors.RESET}")
        
        return True
    
    def create_desktop_entry(self) -> bool:
        """Create desktop entry (for GUI environments)"""
        if self.detector.is_termux:
            return True  # Skip desktop entry for Termux
        
        print(f"{Colors.BLUE}🖥️  Creating desktop entry...{Colors.RESET}")
        
        applications_dir = self.home_dir / '.local' / 'share' / 'applications'
        applications_dir.mkdir(parents=True, exist_ok=True)
        
        desktop_content = f"""[Desktop Entry]
Version=1.0
Type=Application
Name=ZehraSec Terminal
Comment=Enhanced Security Terminal Interface
Exec={self.bin_dir}/zehrasec
Icon=terminal
Terminal=true
Categories=System;TerminalEmulator;Security;
Keywords=terminal;security;zehrasec;
StartupNotify=true
"""
        
        desktop_file = applications_dir / 'zehrasec-terminal.desktop'
        
        try:
            desktop_file.write_text(desktop_content)
            desktop_file.chmod(0o644)
            print(f"{Colors.GREEN}   ✅ Created desktop entry{Colors.RESET}")
            return True
        except Exception as e:
            print(f"{Colors.YELLOW}   ⚠️  Failed to create desktop entry: {e}{Colors.RESET}")
            return True  # Not critical
    
    def run_tests(self) -> bool:
        """Run installation tests"""
        print(f"{Colors.BLUE}🧪 Running installation tests...{Colors.RESET}")
        
        # Test Python imports
        test_cmd = [self.detector.python_cmd, str(self.install_dir / 'test.py')]
        
        try:
            result = subprocess.run(test_cmd, capture_output=True, text=True, timeout=60)
            if result.returncode == 0 and 'ALL TESTS PASSED' in result.stdout:
                print(f"{Colors.GREEN}✅ All tests passed{Colors.RESET}")
                return True
            else:
                print(f"{Colors.YELLOW}⚠️  Some tests failed:{Colors.RESET}")
                print(f"{Colors.YELLOW}{result.stdout}{Colors.RESET}")
                return False
        except Exception as e:
            print(f"{Colors.YELLOW}⚠️  Test execution failed: {e}{Colors.RESET}")
            return False
    
    def show_completion_message(self):
        """Show installation completion message"""
        completion_msg = f"""
{Colors.GREEN}╔══════════════════════════════════════════════════════════════════════════════╗
║                    🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉                ║
╚══════════════════════════════════════════════════════════════════════════════╝{Colors.RESET}

{Colors.CYAN}🚀 ZehraSec Terminal v2.2.0 is now installed!{Colors.RESET}

{Colors.YELLOW}📍 Installation Details:{Colors.RESET}
{Colors.WHITE}   • Install Directory: {self.install_dir}{Colors.RESET}
{Colors.WHITE}   • Config Directory:  {self.config_dir}{Colors.RESET}
{Colors.WHITE}   • Launcher Script:   {self.bin_dir}/zehrasec{Colors.RESET}

{Colors.YELLOW}🏃 How to Run:{Colors.RESET}
{Colors.GREEN}   # Method 1: Direct command (after shell restart)
   zehrasec{Colors.RESET}

{Colors.GREEN}   # Method 2: Full path
   {self.bin_dir}/zehrasec{Colors.RESET}

{Colors.GREEN}   # Method 3: Direct Python execution
   cd {self.install_dir}
   {self.detector.python_cmd} zehrasec_terminal.py{Colors.RESET}

{Colors.YELLOW}🔄 Shell Integration:{Colors.RESET}
{Colors.CYAN}   # Reload your shell configuration:
   source ~/.bashrc
   
   # Or restart your terminal{Colors.RESET}

{Colors.YELLOW}🎨 First Run:{Colors.RESET}
{Colors.WHITE}   1. Set up your secure password
   2. Explore 50+ ASCII art themes with 'changebanner'
   3. Customize your prompt with 'changeprompt'
   4. Type 'help' to see all available commands{Colors.RESET}

{Colors.YELLOW}🛠️  Useful Commands:{Colors.RESET}
{Colors.WHITE}   • help        - Show all commands
   • status      - System and security status
   • demo        - Feature demonstration
   • test        - Run system tests{Colors.RESET}

{Colors.YELLOW}🔗 Links & Support:{Colors.RESET}
{Colors.WHITE}   • GitHub Repository: https://github.com/yashab-cyber/terminal-edits
   • Support Email:     yashabalam707@gmail.com
   • Donations:         See DONATE.md or https://paypal.me/yashab07{Colors.RESET}

{Colors.MAGENTA}🛡️ Developed by Yashab Alam - Founder & CEO of ZehraSec 🛡️{Colors.RESET}
{Colors.CYAN}Thank you for using ZehraSec Terminal!{Colors.RESET}
"""
        print(completion_msg)
    
    def install(self) -> bool:
        """Main installation process"""
        self.print_header()
        
        print(f"{Colors.BOLD}🔍 Starting ZehraSec Terminal Installation...{Colors.RESET}\n")
        
        # Installation steps
        steps = [
            ("Updating package repositories", self.update_package_manager),
            ("Installing system packages", self.install_system_packages),
            ("Installing Python packages", self.install_python_packages),
            ("Setting up directories", self.setup_directories),
            ("Copying application files", self.copy_files),
            ("Creating launcher script", self.create_launcher_script),
            ("Setting up shell integration", self.setup_shell_integration),
            ("Creating desktop entry", self.create_desktop_entry),
            ("Running installation tests", self.run_tests),
        ]
        
        completed_steps = 0
        for step_name, step_func in steps:
            print(f"{Colors.BOLD}🔧 {step_name}...{Colors.RESET}")
            
            try:
                if step_func():
                    completed_steps += 1
                    print(f"{Colors.GREEN}✅ {step_name} completed\n{Colors.RESET}")
                else:
                    print(f"{Colors.RED}❌ {step_name} failed\n{Colors.RESET}")
                    if completed_steps < 5:  # Critical steps
                        print(f"{Colors.RED}💀 Installation aborted due to critical failure{Colors.RESET}")
                        return False
            except KeyboardInterrupt:
                print(f"\n{Colors.YELLOW}⚠️  Installation interrupted by user{Colors.RESET}")
                return False
            except Exception as e:
                print(f"{Colors.RED}❌ {step_name} failed with error: {e}\n{Colors.RESET}")
                if completed_steps < 5:  # Critical steps
                    print(f"{Colors.RED}💀 Installation aborted due to critical failure{Colors.RESET}")
                    return False
        
        # Show completion message
        if completed_steps >= 7:
            self.show_completion_message()
            return True
        else:
            print(f"{Colors.YELLOW}⚠️  Installation completed with warnings{Colors.RESET}")
            print(f"{Colors.YELLOW}   Some optional features may not be available{Colors.RESET}")
            return True

def main():
    """Main installer entry point"""
    
    # Check Python version
    if sys.version_info < (3, 7):
        print(f"{Colors.RED}❌ Python 3.7 or higher is required{Colors.RESET}")
        print(f"{Colors.RED}   Current version: {sys.version}{Colors.RESET}")
        return 1
    
    # Create installer instance
    installer = ZehraSecInstaller()
    
    # Handle command line arguments
    if len(sys.argv) > 1:
        arg = sys.argv[1].lower()
        
        if arg in ['--help', '-h', 'help']:
            print(f"""
{Colors.CYAN}ZehraSec Terminal Installer v2.2.0{Colors.RESET}
{Colors.YELLOW}Usage: python3 install.py [options]{Colors.RESET}

{Colors.GREEN}Options:{Colors.RESET}
  --help, -h        Show this help message
  --test, -t        Run system compatibility test only
  --info, -i        Show system information only
  --uninstall, -u   Uninstall ZehraSec Terminal
  --force, -f       Force installation (skip confirmations)

{Colors.GREEN}Examples:{Colors.RESET}
  python3 install.py              # Interactive installation
  python3 install.py --test       # Test system compatibility
  python3 install.py --force      # Force install without prompts

{Colors.MAGENTA}🛡️ Developed by Yashab Alam - CEO of ZehraSec 🛡️{Colors.RESET}
""")
            return 0
        
        elif arg in ['--test', '-t', 'test']:
            print(f"{Colors.CYAN}🧪 Running system compatibility test...{Colors.RESET}")
            installer.print_header()
            return 0 if installer.run_tests() else 1
        
        elif arg in ['--info', '-i', 'info']:
            installer.print_header()
            return 0
        
        elif arg in ['--uninstall', '-u', 'uninstall']:
            print(f"{Colors.YELLOW}🗑️  Uninstall functionality not implemented yet{Colors.RESET}")
            print(f"{Colors.CYAN}   Manual removal: rm -rf {installer.install_dir} {installer.config_dir}{Colors.RESET}")
            return 0
        
        elif arg not in ['--force', '-f', 'force']:
            print(f"{Colors.RED}❌ Unknown option: {arg}{Colors.RESET}")
            print(f"{Colors.CYAN}   Use --help for usage information{Colors.RESET}")
            return 1
    
    # Interactive confirmation (unless --force)
    if '--force' not in sys.argv and '-f' not in sys.argv:
        installer.print_header()
        
        print(f"{Colors.YELLOW}⚠️  This will install ZehraSec Terminal on your system.{Colors.RESET}")
        print(f"{Colors.CYAN}   Installation directory: {installer.install_dir}{Colors.RESET}")
        print(f"{Colors.CYAN}   Shell integration will be added to your configuration{Colors.RESET}")
        
        try:
            confirm = input(f"\n{Colors.BOLD}Continue with installation? [Y/n]: {Colors.RESET}").strip().lower()
            if confirm and confirm not in ['y', 'yes']:
                print(f"{Colors.YELLOW}Installation cancelled by user{Colors.RESET}")
                return 0
        except KeyboardInterrupt:
            print(f"\n{Colors.YELLOW}Installation cancelled by user{Colors.RESET}")
            return 0
    
    # Run installation
    try:
        success = installer.install()
        return 0 if success else 1
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}⚠️  Installation interrupted{Colors.RESET}")
        return 1
    except Exception as e:
        print(f"{Colors.RED}💀 Installation failed with unexpected error: {e}{Colors.RESET}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
