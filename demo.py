#!/usr/bin/env python3
"""
ZehraSec Terminal - Demo Script
Demonstrates the main features without requiring full installation
"""

import os
import sys
import time
import random
from pathlib import Path

# Simple color codes for basic terminals
class Colors:
    GREEN = '\033[1;32m'
    RED = '\033[1;31m'
    BLUE = '\033[1;34m'
    CYAN = '\033[1;36m'
    YELLOW = '\033[1;33m'
    MAGENTA = '\033[1;35m'
    WHITE = '\033[1;37m'
    RESET = '\033[0m'

def clear_screen():
    """Clear the terminal screen"""
    os.system('cls' if os.name == 'nt' else 'clear')

def typing_effect(text, delay=0.03):
    """Create typing effect"""
    for char in text:
        print(char, end='', flush=True)
        time.sleep(delay)
    print()

def display_banner():
    """Display the ZehraSec banner"""
    banner = f"""
{Colors.CYAN} ███████╗███████╗██╗  ██╗██████╗  █████╗ ███████╗███████╗ ██████╗
 ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝
   ███╔╝ █████╗  ███████║██████╔╝███████║███████╗█████╗  ██║     
  ███╔╝  ██╔══╝  ██╔══██║██╔══██╗██╔══██║╚════██║██╔══╝  ██║     
 ███████╗███████╗██║  ██║██║  ██║██║  ██║███████║███████╗╚██████╗
 ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝{Colors.RESET}
                                                                   
    {Colors.YELLOW}🛡️  ENHANCED SECURITY TERMINAL INTERFACE  🛡️{Colors.RESET}
        {Colors.GREEN}Developed by Yashab Alam - CEO of ZehraSec{Colors.RESET}
"""
    print(banner)

def simple_matrix_effect(duration=3):
    """Simple matrix effect demonstration"""
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%^&*"
    
    print(f"{Colors.GREEN}Running Matrix Effect...{Colors.RESET}")
    
    end_time = time.time() + duration
    while time.time() < end_time:
        line = ""
        for _ in range(80):
            if random.random() < 0.1:
                char = random.choice(chars)
                line += f"{Colors.GREEN}{char}{Colors.RESET}"
            else:
                line += " "
        print(line)
        time.sleep(0.05)

def demonstrate_features():
    """Demonstrate key features"""
    clear_screen()
    display_banner()
    
    print(f"{Colors.YELLOW}═" * 80 + f"{Colors.RESET}")
    print(f"{Colors.BLUE}🎉 Welcome to ZehraSec Terminal Demo! 🎉{Colors.RESET}")
    print(f"{Colors.YELLOW}═" * 80 + f"{Colors.RESET}")
    print()
    
    # Feature demonstration
    features = [
        "🔒 Multi-layer Authentication System",
        "🎨 Interactive Banner Customization (50+ themes)",
        "💻 Advanced Prompt Customization",
        "🎭 Matrix Rain Effects & Animations",
        "📊 Real-time System Information",
        "🛡️ Session Management & Security Logging",
        "🎯 30+ Built-in Commands",
        "🌈 Rich UI with Colors & Tables",
        "💾 Persistent Settings & Backup System",
        "🔧 Cross-platform Compatibility"
    ]
    
    typing_effect(f"{Colors.CYAN}✨ Key Features Demonstrated:{Colors.RESET}")
    print()
    
    for i, feature in enumerate(features, 1):
        typing_effect(f"{i:2d}. {feature}", 0.05)
        time.sleep(0.3)
    
    print()
    print(f"{Colors.MAGENTA}🎭 Matrix Effect Demo:{Colors.RESET}")
    input(f"{Colors.YELLOW}Press Enter to start matrix effect...{Colors.RESET}")
    
    simple_matrix_effect(3)
    
    clear_screen()
    display_banner()
    
    # ASCII Art Demo
    print(f"{Colors.CYAN}🎨 ASCII Art Collection Demo:{Colors.RESET}")
    print()
    
    ascii_samples = {
        "Python Development": '''
                  _.gj8888888lkoz.,_
              ,jF"'     .:''Vn.,
             ,8F.'      :    'L'8.
             8K.'       :      ll88
             8D         .      :ll8I
             :8         .      :ll8I
🐍 PYTHON DEVELOPMENT TERMINAL 🐍
''',
        "Linux Terminal": '''
     .8888888888888888.
     888888888888888888
     88' _`88'_  `88888
     88 88 88 88  88888
     88_88_::_88_:88888
🐧 LINUX POWER USER TERMINAL 🐧
''',
        "Love Theme": '''
       ♥♥♥♥♥           ♥♥♥♥♥
     ♥♥♥♥♥♥♥         ♥♥♥♥♥♥♥
   ♥♥♥♥♥♥♥♥♥       ♥♥♥♥♥♥♥♥♥
    ♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥
     ♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥
💖 LOVE & PEACE TERMINAL 💖
'''
    }
    
    for theme, art in ascii_samples.items():
        print(f"{Colors.YELLOW}Theme: {theme}{Colors.RESET}")
        print(f"{Colors.GREEN}{art}{Colors.RESET}")
        time.sleep(2)
    
    # Command Demo
    print(f"{Colors.CYAN}💻 Available Commands (Sample):{Colors.RESET}")
    print(f"{Colors.YELLOW}═" * 50 + f"{Colors.RESET}")
    
    commands = [
        ("help", "Display comprehensive command reference"),
        ("status", "Show system and security status"),
        ("changebanner", "Interactive banner customization"),
        ("changeprompt", "Interactive prompt customization"),
        ("matrix", "Matrix rain effect animation"),
        ("sysinfo", "Detailed system information"),
        ("backup", "Backup current settings"),
        ("clean", "Clean temporary files")
    ]
    
    for cmd, desc in commands:
        print(f"{Colors.GREEN}{cmd:<15}{Colors.RESET} - {desc}")
    
    print()
    print(f"{Colors.MAGENTA}🛡️ Security Features:{Colors.RESET}")
    print(f"{Colors.YELLOW}═" * 40 + f"{Colors.RESET}")
    
    security_features = [
        "✅ bcrypt Password Hashing",
        "✅ Account Lockout Protection",
        "✅ Session Timeout Management",
        "✅ Comprehensive Audit Logging",
        "✅ Input Validation & Sanitization",
        "✅ Secure Configuration Storage"
    ]
    
    for feature in security_features:
        print(f"  {feature}")
    
    print()
    print(f"{Colors.CYAN}📁 Project Structure:{Colors.RESET}")
    print(f"{Colors.YELLOW}═" * 35 + f"{Colors.RESET}")
    
    structure = [
        "zehrasec_terminal.py    - Main application (1,200+ lines)",
        "ascii_art/             - 15+ ASCII art files",
        "launch.py              - Python launcher",
        "launch.bat             - Windows launcher",
        "test.py                - System test script",
        "requirements.txt       - Dependencies",
        "INSTALL.md            - Installation guide",
        "PROJECT_SUMMARY.md    - This summary"
    ]
    
    for item in structure:
        print(f"  📄 {item}")
    
    print()
    print(f"{Colors.GREEN}🎉 Demo Complete!{Colors.RESET}")
    print(f"{Colors.CYAN}To run the full application:{Colors.RESET}")
    print(f"{Colors.YELLOW}  1. Install dependencies: pip install -r requirements.txt{Colors.RESET}")
    print(f"{Colors.YELLOW}  2. Run: python zehrasec_terminal.py{Colors.RESET}")
    print()
    print(f"{Colors.MAGENTA}🛡️ Developed by Yashab Alam - Founder & CEO of ZehraSec 🛡️{Colors.RESET}")

def main():
    """Main demo function"""
    try:
        demonstrate_features()
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}Demo interrupted. Thank you for trying ZehraSec Terminal!{Colors.RESET}")
    except Exception as e:
        print(f"{Colors.RED}Demo error: {e}{Colors.RESET}")

if __name__ == "__main__":
    main()
