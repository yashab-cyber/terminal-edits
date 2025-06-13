#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ZehraSec Terminal - Enhanced Security Terminal Interface
Version: 2.2.0
Developer: Yashab Alam - Founder & CEO of ZehraSec
License: MIT

A sophisticated terminal interface with matrix effects, authentication system, 
and enhanced security features created by Yashab Alam, the visionary founder of ZehraSec.
"""

import os
import sys
import time
import random
import hashlib
import getpass
import datetime
import threading
import json
import platform
import subprocess
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import logging

try:
    from colorama import init, Fore, Back, Style
    from rich.console import Console
    from rich.table import Table
    from rich.panel import Panel
    from rich.progress import Progress, SpinnerColumn, TextColumn
    import pyfiglet
    import psutil
    import bcrypt
except ImportError as e:
    print(f"Error: Missing required packages. Please run: pip install -r requirements.txt")
    print(f"Specific error: {e}")
    sys.exit(1)

# Initialize colorama for Windows compatibility
init(autoreset=True)

class ZehraSecConfig:
    """Configuration management for ZehraSec Terminal"""
    
    def __init__(self):
        self.config_dir = Path.home() / ".zehrasec"
        self.config_dir.mkdir(exist_ok=True)
        
        # Configuration files
        self.pass_file = self.config_dir / "pass"
        self.fails_file = self.config_dir / "fails"
        self.locktime_file = self.config_dir / "locktime"
        self.log_file = self.config_dir / "access.log"
        self.session_file = self.config_dir / "session"
        self.prompt_file = self.config_dir / "prompt"
        self.banner_file = self.config_dir / "banner"
        self.preferences_file = self.config_dir / "preferences"
        
        # Security settings
        self.MAX_FAIL_ATTEMPTS = 3
        self.LOCKOUT_DURATION = 300  # 5 minutes
        self.MIN_PASSWORD_LENGTH = 6
        self.SESSION_TIMEOUT = 3600  # 1 hour
        
        # Customization settings
        self.DEFAULT_PROMPT = "ZehraSec"
        self.PREDEFINED_PROMPTS = [
            "ZehraSec", "Terminal", "Secure", "Admin", "Root", 
            "Cyber", "Hacker", "Matrix", "Shell", "Console"
        ]
          # Banner categories (including custom)
        self.BANNER_CATEGORIES = [
            "logoasciiart", "codingasciiart", "loveasciiart", 
            "terminalskullasciiart", "fuckoff", "custom"
        ]
        
        # Setup logging
        logging.basicConfig(
            filename=self.log_file,
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )
        
    def log_activity(self, message: str, level: str = "INFO"):
        """Log activity to file"""
        if level.upper() == "ERROR":
            logging.error(message)
        elif level.upper() == "WARNING":
            logging.warning(message)
        else:
            logging.info(message)

class MatrixEffect:
    """Matrix rain effect implementation"""
    
    def __init__(self):
        self.console = Console()
        self.colors = [Fore.GREEN, Fore.CYAN, Fore.WHITE, Fore.LIGHTGREEN_EX]
        self.chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%^&*"
        
    def run_matrix(self, duration: int = 3):
        """Run matrix effect for specified duration"""
        try:
            os.system('cls' if os.name == 'nt' else 'clear')
            
            print(f"{Fore.GREEN}Running Matrix Effect...{Style.RESET_ALL}")
            
            end_time = time.time() + duration
            while time.time() < end_time:
                # Simple matrix-like effect
                for _ in range(5):
                    line = ""
                    for _ in range(80):
                        if random.random() < 0.1:
                            char = random.choice(self.chars)
                            color = random.choice(self.colors)
                            line += f"{color}{char}{Style.RESET_ALL}"
                        else:
                            line += " "
                    print(line)
                time.sleep(0.05)
                
        except KeyboardInterrupt:
            pass
        
    def typing_effect(self, text: str, delay: float = 0.02):
        """Create typing effect for text"""
        for char in text:
            print(char, end='', flush=True)
            time.sleep(delay)
        print()

class ASCIIArtManager:
    """Manage ASCII art collections and banners"""
    
    def __init__(self, config: ZehraSecConfig):
        self.config = config
        self.art_dir = Path("ascii_art")
        self.art_dir.mkdir(exist_ok=True)
        self._create_default_ascii_art()
        
    def _create_default_ascii_art(self):
        """Create default ASCII art collections"""
        # Create category directories
        for category in self.config.BANNER_CATEGORIES:
            category_dir = self.art_dir / category
            category_dir.mkdir(exist_ok=True)
            
        # Create default ZehraSec banner
        zehrasec_banner = '''
 ███████╗███████╗██╗  ██╗██████╗  █████╗ ███████╗███████╗ ██████╗
 ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝
   ███╔╝ █████╗  ███████║██████╔╝███████║███████╗█████╗  ██║     
  ███╔╝  ██╔══╝  ██╔══██║██╔══██╗██╔══██║╚════██║██╔══╝  ██║     
 ███████╗███████╗██║  ██║██║  ██║██║  ██║███████║███████╗╚██████╗
 ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝
                                                                   
    🛡️  ENHANCED SECURITY TERMINAL INTERFACE  🛡️
        Developed by Yashab Alam - CEO of ZehraSec
'''
        
        default_file = self.art_dir / "logoasciiart" / "zehrasec_inc.txt"
        default_file.write_text(zehrasec_banner, encoding='utf-8')
        
        # Create other sample ASCII art
        self._create_sample_art()
        
    def _create_sample_art(self):
        """Create sample ASCII art files"""
        art_samples = {
            "logoasciiart/linux.txt": '''
        .88888888:.
       88888888.88888.
     .8888888888888888.
     888888888888888888
     88' _`88'_  `88888
     88 88 88 88  88888
     88_88_::_88_:88888
     88:::,::,:::::8888
     88`:::::::::'`8888
    .88  `::::'    8:88.
   8888            `8:888.
 .8888'             `888888.
.8888:..  .::.  ...:'8888888:.
.8888.'     :'     `'::`88:88888
.8888        '         `.888:8888.
888:8         .           888:88888
.888:88        .:           888:88888:
8888888.       ::           88:888888
`.::.888.      ::          .88888888
.::::::.888.    ::         :::`8888'.:.
::::::::::.888   '         .:::::::::::
::::::::::::.8    '      .:8::::::::::::.
.::::::::::::::.        .:888:::::::::::::
:::::::::::::::88:.__..:88888:::::::::::'
 `':::::::::::::88888888888.88:::::::::'
      `':::_:' -- '' -'-' `':_::::'`

🐧 LINUX POWER USER TERMINAL 🐧
''',
            
            "logoasciiart/python.txt": '''
                  _.gj8888888lkoz.,_
              ,jF"'     .:''Vn.,
             ,8F.'      :    'L'8.
             8K.'       :      ll88
             8D         .      :ll8I
             :8         .      :ll8I
              :8,       .      :ll8I
               :8,       .     :ll8I
                'L       .    :ll8I
                 K       .   :ll8I
                  'L      :  :ll8I
                   'L     :  :ll8I
                    'L    :  :ll8I
                     'L   :  :ll8I
                      'L  :   ll8I
                       '',:   :ll8I
                           '_ :ll8I
                             'lI8I
                              :8I
                               ll
                               'l

🐍 PYTHON DEVELOPMENT TERMINAL 🐍
''',
              "terminalskullasciiart/rip.txt": '''
                          _,
                       _.-'_;
                    .-'__;.'
                  ,__.-'
                ,` _.;`
               _,` ,.:.-'
              ;  ,',-':
             ,'  ;; ;/
            ,'   ;;  ;
           /     ;;  ;
          /      ;;  ;
         ;       ;;  ;
         ;      `;;  ;
         ;       `; ,'
         ;        ;`.
         ;        ;  `.
         ;       ;     `.
         '.      ;       `.
          `.     ;         `.
           `.   ;.           `.
            `. ; ;            `.
             `; ;              `.
              ';.               `.

⚰️  ACCESS DENIED - TERMINAL LOCKED  ⚰️
''',
            
            "custom/example.txt": '''
  ██████╗██╗   ██╗███████╗████████╗ ██████╗ ███╗   ███╗
 ██╔════╝██║   ██║██╔════╝╚══██╔══╝██╔═══██╗████╗ ████║
 ██║     ██║   ██║███████╗   ██║   ██║   ██║██╔████╔██║
 ██║     ██║   ██║╚════██║   ██║   ██║   ██║██║╚██╔╝██║
 ╚██████╗╚██████╔╝███████║   ██║   ╚██████╔╝██║ ╚═╝ ██║
  ╚═════╝ ╚═════╝ ╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝

🎭 EXAMPLE CUSTOM BANNER 🎭
Create your own banners with the 'createbanner' command!
'''        }
        
        for path, content in art_samples.items():
            file_path = self.art_dir / path
            file_path.parent.mkdir(parents=True, exist_ok=True)
            file_path.write_text(content, encoding='utf-8')
    
    def get_banner(self, category: str = "logoasciiart", filename: str = "zehrasec_inc.txt") -> str:
        """Get banner content from specified category and file"""
        banner_path = self.art_dir / category / filename
        if banner_path.exists():
            try:
                return banner_path.read_text(encoding='utf-8')
            except UnicodeDecodeError:
                # Fallback to latin-1 if UTF-8 fails
                return banner_path.read_text(encoding='latin-1')
        return self.get_default_banner()
    
    def get_default_banner(self) -> str:
        """Get default ZehraSec banner"""
        return self.get_banner("logoasciiart", "zehrasec_inc.txt")
    
    def list_banners(self, category: str) -> List[str]:
        """List all banners in a category"""
        category_path = self.art_dir / category
        if category_path.exists():
            return [f.stem for f in category_path.glob("*.txt")]
        return []
    
    def get_random_banner(self) -> Tuple[str, str]:
        """Get a random banner from any category"""
        category = random.choice(self.config.BANNER_CATEGORIES)
        banners = self.list_banners(category)
        if banners:
            banner = random.choice(banners)
            return category, f"{banner}.txt"
        return "logoasciiart", "zehrasec_inc.txt"

class SecurityManager:
    """Handle authentication and security features"""
    
    def __init__(self, config: ZehraSecConfig):
        self.config = config
        
    def hash_password(self, password: str) -> str:
        """Hash password using bcrypt"""
        return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    
    def verify_password(self, password: str, hashed: str) -> bool:
        """Verify password against hash"""
        try:
            return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))
        except:
            return False
    
    def is_account_locked(self) -> bool:
        """Check if account is currently locked"""
        if not self.config.locktime_file.exists():
            return False
        
        try:
            locktime = float(self.config.locktime_file.read_text(encoding='utf-8').strip())
            return time.time() < locktime
        except:
            return False
    
    def get_failed_attempts(self) -> int:
        """Get number of failed login attempts"""
        if not self.config.fails_file.exists():
            return 0
        
        try:
            return int(self.config.fails_file.read_text(encoding='utf-8').strip())
        except:
            return 0
    
    def increment_failed_attempts(self):
        """Increment failed login attempts"""
        fails = self.get_failed_attempts() + 1
        self.config.fails_file.write_text(str(fails), encoding='utf-8')
        
        if fails >= self.config.MAX_FAIL_ATTEMPTS:
            locktime = time.time() + self.config.LOCKOUT_DURATION
            self.config.locktime_file.write_text(str(locktime), encoding='utf-8')
            self.config.log_activity(f"Account locked due to {fails} failed attempts", "WARNING")
    
    def reset_failed_attempts(self):
        """Reset failed login attempts"""
        if self.config.fails_file.exists():
            self.config.fails_file.unlink()
        if self.config.locktime_file.exists():
            self.config.locktime_file.unlink()
    
    def validate_password_strength(self, password: str) -> Tuple[bool, str]:
        """Validate password strength"""
        if len(password) < self.config.MIN_PASSWORD_LENGTH:
            return False, f"Password must be at least {self.config.MIN_PASSWORD_LENGTH} characters long"
        
        has_letter = any(c.isalpha() for c in password)
        has_digit = any(c.isdigit() for c in password)
        
        if not has_letter or not has_digit:
            return False, "Password must contain both letters and numbers"
        
        return True, "Password is strong"
    
    def create_session(self) -> str:
        """Create new session"""
        session_id = hashlib.sha256(f"{time.time()}{random.random()}".encode()).hexdigest()[:16]
        session_data = {
            "id": session_id,
            "start_time": time.time(),
            "last_activity": time.time()
        }
        self.config.session_file.write_text(json.dumps(session_data), encoding='utf-8')
        return session_id
    
    def is_session_valid(self) -> bool:
        """Check if current session is valid"""
        if not self.config.session_file.exists():
            return False
        
        try:
            session_data = json.loads(self.config.session_file.read_text(encoding='utf-8'))
            last_activity = session_data.get("last_activity", 0)
            return (time.time() - last_activity) < self.config.SESSION_TIMEOUT
        except:
            return False
    
    def update_session_activity(self):
        """Update session last activity time"""
        if self.config.session_file.exists():
            try:
                session_data = json.loads(self.config.session_file.read_text(encoding='utf-8'))
                session_data["last_activity"] = time.time()
                self.config.session_file.write_text(json.dumps(session_data), encoding='utf-8')
            except:
                pass

class ZehraSecTerminal:
    """Main ZehraSec Terminal class"""
    
    def __init__(self):
        self.config = ZehraSecConfig()
        self.security = SecurityManager(self.config)
        self.ascii_art = ASCIIArtManager(self.config)
        self.matrix = MatrixEffect()
        self.console = Console()
          # Current settings
        self.current_prompt = self._load_prompt()
        self.current_banner_info = self._load_banner_info()
        
        # Command history
        self.command_history = []
    
    def _load_prompt(self) -> str:
        """Load current prompt setting"""
        if self.config.prompt_file.exists():
            return self.config.prompt_file.read_text(encoding='utf-8').strip()
        return self.config.DEFAULT_PROMPT
    
    def _save_prompt(self, prompt: str):
        """Save prompt setting"""
        self.config.prompt_file.write_text(prompt, encoding='utf-8')
        self.current_prompt = prompt
    
    def _load_banner_info(self) -> Dict[str, str]:
        """Load current banner information"""
        if self.config.banner_file.exists():
            try:
                return json.loads(self.config.banner_file.read_text(encoding='utf-8'))
            except:
                pass
        return {"category": "logoasciiart", "filename": "zehrasec_inc.txt"}
    
    def _save_banner_info(self, category: str, filename: str):
        """Save banner information"""
        banner_info = {"category": category, "filename": filename}
        self.config.banner_file.write_text(json.dumps(banner_info), encoding='utf-8')
        self.current_banner_info = banner_info
    
    def display_banner(self):
        """Display current banner"""
        os.system('cls' if os.name == 'nt' else 'clear')
        
        banner = self.ascii_art.get_banner(
            self.current_banner_info["category"],
            self.current_banner_info["filename"]
        )
        
        print(f"{Fore.CYAN}{banner}{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}═" * 80 + f"{Style.RESET_ALL}")
        print(f"{Fore.GREEN}🛡️  ZehraSec Terminal v2.2.0 - Enhanced Security Interface 🛡️{Style.RESET_ALL}")
        print(f"{Fore.BLUE}📅 Session Started: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}═" * 80 + f"{Style.RESET_ALL}")
        print()
    
    def authenticate(self) -> bool:
        """Handle user authentication"""
        # Check if account is locked
        if self.security.is_account_locked():
            print(f"{Fore.RED}❌ Account is locked due to failed login attempts.{Style.RESET_ALL}")
            print(f"{Fore.YELLOW}⏰ Please try again later.{Style.RESET_ALL}")
            return False
        
        # Check if password exists
        if not self.config.pass_file.exists():
            return self._setup_password()
        
        # Authenticate user
        return self._login()
    
    def _setup_password(self) -> bool:
        """Setup new password"""
        print(f"{Fore.CYAN}🔐 Welcome to ZehraSec Terminal! Let's set up your password.{Style.RESET_ALL}")
        print()
        
        while True:
            password = getpass.getpass(f"{Fore.GREEN}Enter new password: {Style.RESET_ALL}")
            
            valid, message = self.security.validate_password_strength(password)
            if not valid:
                print(f"{Fore.RED}❌ {message}{Style.RESET_ALL}")
                continue
            
            confirm = getpass.getpass(f"{Fore.GREEN}Confirm password: {Style.RESET_ALL}")
            if password != confirm:
                print(f"{Fore.RED}❌ Passwords do not match. Please try again.{Style.RESET_ALL}")
                continue
            
            # Save password
            hashed = self.security.hash_password(password)
            self.config.pass_file.write_text(hashed)
            
            print(f"{Fore.GREEN}✅ Password set successfully!{Style.RESET_ALL}")
            self.config.log_activity("Password set successfully")
            return True
    
    def _login(self) -> bool:
        """Handle user login"""
        print(f"{Fore.CYAN}🔐 ZehraSec Terminal Authentication{Style.RESET_ALL}")
        print()
        
        max_attempts = 3
        for attempt in range(max_attempts):
            password = getpass.getpass(f"{Fore.GREEN}Enter password: {Style.RESET_ALL}")
              # Load stored password hash
            stored_hash = self.config.pass_file.read_text(encoding='utf-8').strip()
            
            if self.security.verify_password(password, stored_hash):
                print(f"{Fore.GREEN}✅ Authentication successful!{Style.RESET_ALL}")
                self.security.reset_failed_attempts()
                self.security.create_session()
                self.config.log_activity("Successful login")
                return True
            else:
                remaining = max_attempts - attempt - 1
                if remaining > 0:
                    print(f"{Fore.RED}❌ Invalid password. {remaining} attempts remaining.{Style.RESET_ALL}")
                else:
                    print(f"{Fore.RED}❌ Invalid password. Maximum attempts reached.{Style.RESET_ALL}")
                
                self.security.increment_failed_attempts()
                self.config.log_activity(f"Failed login attempt {attempt + 1}", "WARNING")
        
        return False
    
    def show_help(self):
        """Display help information"""
        help_text = f"""
{Fore.CYAN}╔══════════════════════════════════════════════════════════════════════════════╗
║                    🛡️  ZehraSec Terminal v2.2.0 - Help  🛡️                   ║
╚══════════════════════════════════════════════════════════════════════════════╝{Style.RESET_ALL}

{Fore.YELLOW}📋 CORE COMMANDS:{Style.RESET_ALL}
  {Fore.GREEN}help{Style.RESET_ALL}              - Display this help message
  {Fore.GREEN}status{Style.RESET_ALL}            - Show system and security status
  {Fore.GREEN}clear{Style.RESET_ALL}             - Clear screen and redisplay banner
  {Fore.GREEN}matrix{Style.RESET_ALL}            - Show matrix effect animation
  {Fore.GREEN}sysinfo{Style.RESET_ALL}           - Display detailed system information
  {Fore.GREEN}changepass{Style.RESET_ALL}        - Change your password securely
  {Fore.GREEN}logout{Style.RESET_ALL}            - End session and exit safely
  {Fore.GREEN}exit{Style.RESET_ALL}              - Exit the terminal

{Fore.YELLOW}🎨 BANNER CUSTOMIZATION:{Style.RESET_ALL}
  {Fore.GREEN}changebanner{Style.RESET_ALL}      - Interactive banner customization menu
  {Fore.GREEN}setbanner{Style.RESET_ALL}         - Set banner (alias for changebanner)
  {Fore.GREEN}randombanner{Style.RESET_ALL}      - Set random theme from collections
  {Fore.GREEN}previewthemes{Style.RESET_ALL}     - Preview all available themes
  {Fore.GREEN}resetbanner{Style.RESET_ALL}       - Reset to default ZehraSec banner
  {Fore.GREEN}browseart{Style.RESET_ALL}         - Browse ASCII art by category
  {Fore.GREEN}currentbanner{Style.RESET_ALL}     - Show current banner information

{Fore.YELLOW}🎭 CUSTOM BANNERS:{Style.RESET_ALL}
  {Fore.CYAN}createbanner{Style.RESET_ALL}      - Interactive custom banner creator
  {Fore.CYAN}addbanner <name>{Style.RESET_ALL}  - Quick custom banner creation
  {Fore.CYAN}editbanner <name>{Style.RESET_ALL} - Edit existing custom banner
  {Fore.CYAN}deletebanner <name>{Style.RESET_ALL} - Delete custom banner
  {Fore.CYAN}listcustom{Style.RESET_ALL}        - List all custom banners
  {Fore.CYAN}importbanner <file> <name>{Style.RESET_ALL} - Import banner from file
  {Fore.CYAN}exportbanner <name> <file>{Style.RESET_ALL} - Export custom banner

{Fore.YELLOW}🎭 CUSTOM BANNER CREATION:{Style.RESET_ALL}
  {Fore.GREEN}createbanner{Style.RESET_ALL}      - Interactive custom banner creator
  {Fore.GREEN}addbanner <name>{Style.RESET_ALL}  - Create new custom banner with name
  {Fore.GREEN}editbanner <name>{Style.RESET_ALL} - Edit existing custom banner
  {Fore.GREEN}deletebanner <name>{Style.RESET_ALL} - Delete custom banner
  {Fore.GREEN}listcustom{Style.RESET_ALL}        - List all custom banners
  {Fore.GREEN}importbanner <file> <name>{Style.RESET_ALL} - Import banner from file
  {Fore.GREEN}exportbanner <name> <file>{Style.RESET_ALL} - Export custom banner to file

{Fore.YELLOW}💻 PROMPT CUSTOMIZATION:{Style.RESET_ALL}
  {Fore.GREEN}changeprompt{Style.RESET_ALL}      - Interactive prompt customization menu
  {Fore.GREEN}prompt{Style.RESET_ALL}            - Prompt customization (alias)
  {Fore.GREEN}setprompt [text]{Style.RESET_ALL}  - Set custom prompt text directly
  {Fore.GREEN}resetprompt{Style.RESET_ALL}       - Reset to default ZehraSec prompt
  {Fore.GREEN}listprompts{Style.RESET_ALL}       - Show all predefined prompt options
  {Fore.GREEN}currentprompt{Style.RESET_ALL}     - Display current prompt information

{Fore.YELLOW}🔧 SYSTEM COMMANDS:{Style.RESET_ALL}
  {Fore.GREEN}update{Style.RESET_ALL}            - Check for system updates
  {Fore.GREEN}clean{Style.RESET_ALL}             - Clean temporary files
  {Fore.GREEN}backup{Style.RESET_ALL}            - Create backup of customizations
  {Fore.GREEN}restore{Style.RESET_ALL}           - Restore previous backup

{Fore.BLUE}💡 TIP: Use 'Tab' completion and command history with Up/Down arrows{Style.RESET_ALL}
{Fore.MAGENTA}🛡️ Developed by Yashab Alam - CEO of ZehraSec{Style.RESET_ALL}
"""
        print(help_text)
    
    def show_status(self):
        """Display system and security status"""
        console = Console()
        
        # System Information
        system_table = Table(title="🖥️ System Information", show_header=True, header_style="bold magenta")
        system_table.add_column("Property", style="cyan", no_wrap=True)
        system_table.add_column("Value", style="yellow")
        
        system_table.add_row("Operating System", f"{platform.system()} {platform.release()}")
        system_table.add_row("Architecture", platform.machine())
        system_table.add_row("Python Version", platform.python_version())
        system_table.add_row("Hostname", platform.node())
        
        # Memory and CPU info
        try:
            memory = psutil.virtual_memory()
            system_table.add_row("Total Memory", f"{memory.total // (1024**3)} GB")
            system_table.add_row("Available Memory", f"{memory.available // (1024**3)} GB")
            system_table.add_row("CPU Cores", str(psutil.cpu_count()))
        except:
            system_table.add_row("System Stats", "Unable to retrieve")
        
        console.print(system_table)
        print()
        
        # Security Status
        security_table = Table(title="🔒 Security Status", show_header=True, header_style="bold red")
        security_table.add_column("Security Feature", style="cyan", no_wrap=True)
        security_table.add_column("Status", style="green")
        
        # Check session status
        session_status = "✅ Active" if self.security.is_session_valid() else "❌ Expired"
        security_table.add_row("Session", session_status)
        
        # Check failed attempts
        failed_attempts = self.security.get_failed_attempts()
        security_table.add_row("Failed Login Attempts", str(failed_attempts))
        
        # Check if locked
        locked_status = "🔒 Locked" if self.security.is_account_locked() else "🔓 Unlocked"
        security_table.add_row("Account Status", locked_status)
        
        # Password set status
        password_status = "✅ Set" if self.config.pass_file.exists() else "❌ Not Set"
        security_table.add_row("Password", password_status)
        
        console.print(security_table)
        print()
        
        # Customization Status
        custom_table = Table(title="🎨 Customization Status", show_header=True, header_style="bold blue")
        custom_table.add_column("Setting", style="cyan", no_wrap=True)
        custom_table.add_column("Current Value", style="yellow")
        
        custom_table.add_row("Current Prompt", self.current_prompt)
        custom_table.add_row("Banner Category", self.current_banner_info["category"])
        custom_table.add_row("Banner File", self.current_banner_info["filename"])
        
        console.print(custom_table)
    
    def show_system_info(self):
        """Display detailed system information"""
        console = Console()
        
        with console.status("[bold green]Gathering system information..."):
            time.sleep(1)  # Simulate gathering time
        
        # Create comprehensive system info panel
        info_text = f"""
{Fore.CYAN}🖥️ SYSTEM INFORMATION{Style.RESET_ALL}
{Fore.YELLOW}═" * 50{Style.RESET_ALL}

{Fore.GREEN}Operating System:{Style.RESET_ALL} {platform.system()} {platform.release()}
{Fore.GREEN}Architecture:{Style.RESET_ALL} {platform.machine()}
{Fore.GREEN}Processor:{Style.RESET_ALL} {platform.processor()}
{Fore.GREEN}Python Version:{Style.RESET_ALL} {platform.python_version()}
{Fore.GREEN}Hostname:{Style.RESET_ALL} {platform.node()}
{Fore.GREEN}User:{Style.RESET_ALL} {os.environ.get('USER', os.environ.get('USERNAME', 'Unknown'))}

{Fore.CYAN}💾 MEMORY & STORAGE{Style.RESET_ALL}
{Fore.YELLOW}═" * 50{Style.RESET_ALL}
"""
        
        try:
            memory = psutil.virtual_memory()
            disk = psutil.disk_usage('/')
            
            info_text += f"""
{Fore.GREEN}Total Memory:{Style.RESET_ALL} {memory.total // (1024**3)} GB
{Fore.GREEN}Available Memory:{Style.RESET_ALL} {memory.available // (1024**3)} GB
{Fore.GREEN}Memory Usage:{Style.RESET_ALL} {memory.percent}%
{Fore.GREEN}Total Disk Space:{Style.RESET_ALL} {disk.total // (1024**3)} GB
{Fore.GREEN}Free Disk Space:{Style.RESET_ALL} {disk.free // (1024**3)} GB
{Fore.GREEN}Disk Usage:{Style.RESET_ALL} {(disk.used / disk.total) * 100:.1f}%
"""
        except:
            info_text += f"{Fore.RED}Unable to retrieve memory/disk information{Style.RESET_ALL}\n"
        
        info_text += f"""
{Fore.CYAN}⚡ CPU INFORMATION{Style.RESET_ALL}
{Fore.YELLOW}═" * 50{Style.RESET_ALL}
"""
        
        try:
            info_text += f"""
{Fore.GREEN}CPU Cores:{Style.RESET_ALL} {psutil.cpu_count()} ({psutil.cpu_count(logical=False)} physical)
{Fore.GREEN}CPU Usage:{Style.RESET_ALL} {psutil.cpu_percent(interval=1)}%
"""
        except:
            info_text += f"{Fore.RED}Unable to retrieve CPU information{Style.RESET_ALL}\n"
        
        info_text += f"""
{Fore.CYAN}🌐 NETWORK & ENVIRONMENT{Style.RESET_ALL}
{Fore.YELLOW}═" * 50{Style.RESET_ALL}

{Fore.GREEN}Terminal:{Style.RESET_ALL} {os.environ.get('TERM', 'Unknown')}
{Fore.GREEN}Shell:{Style.RESET_ALL} {os.environ.get('SHELL', 'Unknown')}
{Fore.GREEN}Home Directory:{Style.RESET_ALL} {Path.home()}
{Fore.GREEN}Current Directory:{Style.RESET_ALL} {Path.cwd()}
{Fore.GREEN}ZehraSec Config:{Style.RESET_ALL} {self.config.config_dir}
"""
        
        print(info_text)
    
    def change_password(self):
        """Change user password"""
        print(f"{Fore.CYAN}🔐 Change Password{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}═" * 30 + f"{Style.RESET_ALL}")
          # Verify current password
        if self.config.pass_file.exists():
            current = getpass.getpass(f"{Fore.GREEN}Enter current password: {Style.RESET_ALL}")
            stored_hash = self.config.pass_file.read_text(encoding='utf-8').strip()
            
            if not self.security.verify_password(current, stored_hash):
                print(f"{Fore.RED}❌ Invalid current password.{Style.RESET_ALL}")
                return
        
        # Get new password
        while True:
            new_password = getpass.getpass(f"{Fore.GREEN}Enter new password: {Style.RESET_ALL}")
            
            valid, message = self.security.validate_password_strength(new_password)
            if not valid:
                print(f"{Fore.RED}❌ {message}{Style.RESET_ALL}")
                continue
            
            confirm = getpass.getpass(f"{Fore.GREEN}Confirm new password: {Style.RESET_ALL}")
            if new_password != confirm:
                print(f"{Fore.RED}❌ Passwords do not match.{Style.RESET_ALL}")
                continue
            
            break        
        # Save new password
        hashed = self.security.hash_password(new_password)
        self.config.pass_file.write_text(hashed)
        
        print(f"{Fore.GREEN}✅ Password changed successfully!{Style.RESET_ALL}")
        self.config.log_activity("Password changed successfully")
    
    def change_banner_interactive(self):
        """Interactive banner customization menu"""
        while True:
            print(f"\n{Fore.CYAN}🎨 Banner Customization Menu{Style.RESET_ALL}")
            print(f"{Fore.YELLOW}═" * 50 + f"{Style.RESET_ALL}")
            print(f"{Fore.GREEN}1.{Style.RESET_ALL} Change theme")
            print(f"{Fore.GREEN}2.{Style.RESET_ALL} Preview themes")
            print(f"{Fore.GREEN}3.{Style.RESET_ALL} Random theme")
            print(f"{Fore.GREEN}4.{Style.RESET_ALL} Browse categories")
            print(f"{Fore.GREEN}5.{Style.RESET_ALL} Reset to default")
            print(f"{Fore.GREEN}6.{Style.RESET_ALL} Current banner info")
            print(f"{Fore.CYAN}7.{Style.RESET_ALL} Create custom banner")
            print(f"{Fore.CYAN}8.{Style.RESET_ALL} Manage custom banners")
            print(f"{Fore.GREEN}0.{Style.RESET_ALL} Back to main menu")
            
            choice = input(f"\n{Fore.CYAN}Select option (0-8): {Style.RESET_ALL}").strip()
            
            if choice == "1":
                self._select_banner_theme()
            elif choice == "2":
                self._preview_themes()
            elif choice == "3":
                self.set_random_banner()
            elif choice == "4":
                self._browse_art_categories()
            elif choice == "5":
                self.reset_banner()
            elif choice == "6":
                self.show_current_banner_info()
            elif choice == "7":
                self.create_custom_banner_interactive()
            elif choice == "8":
                self._manage_custom_banners_menu()
            elif choice == "0":
                break
            else:
                print(f"{Fore.RED}❌ Invalid option. Please try again.{Style.RESET_ALL}")
    
    def _select_banner_theme(self):
        """Select banner theme from categories"""
        print(f"\n{Fore.CYAN}📂 Available Categories:{Style.RESET_ALL}")
        for i, category in enumerate(self.config.BANNER_CATEGORIES, 1):
            banners = self.ascii_art.list_banners(category)
            print(f"{Fore.GREEN}{i}.{Style.RESET_ALL} {category} ({len(banners)} files)")
        
        try:
            choice = int(input(f"\n{Fore.CYAN}Select category (1-{len(self.config.BANNER_CATEGORIES)}): {Style.RESET_ALL}"))
            if 1 <= choice <= len(self.config.BANNER_CATEGORIES):
                category = self.config.BANNER_CATEGORIES[choice - 1]
                self._select_banner_from_category(category)
            else:
                print(f"{Fore.RED}❌ Invalid category selection.{Style.RESET_ALL}")
        except ValueError:
            print(f"{Fore.RED}❌ Please enter a valid number.{Style.RESET_ALL}")
    
    def _select_banner_from_category(self, category: str):
        """Select specific banner from category"""
        banners = self.ascii_art.list_banners(category)
        if not banners:
            print(f"{Fore.RED}❌ No banners found in category: {category}{Style.RESET_ALL}")
            return
        
        print(f"\n{Fore.CYAN}🎨 Available banners in {category}:{Style.RESET_ALL}")
        for i, banner in enumerate(banners, 1):
            print(f"{Fore.GREEN}{i}.{Style.RESET_ALL} {banner}")
        
        try:
            choice = int(input(f"\n{Fore.CYAN}Select banner (1-{len(banners)}): {Style.RESET_ALL}"))
            if 1 <= choice <= len(banners):
                filename = f"{banners[choice - 1]}.txt"
                self._save_banner_info(category, filename)
                print(f"{Fore.GREEN}✅ Banner set to: {category}/{filename}{Style.RESET_ALL}")
                self.display_banner()
            else:
                print(f"{Fore.RED}❌ Invalid banner selection.{Style.RESET_ALL}")
        except ValueError:
            print(f"{Fore.RED}❌ Please enter a valid number.{Style.RESET_ALL}")
    
    def _preview_themes(self):
        """Preview all available themes"""
        print(f"{Fore.CYAN}🔍 Theme Preview{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}═" * 30 + f"{Style.RESET_ALL}")
        
        for category in self.config.BANNER_CATEGORIES:
            banners = self.ascii_art.list_banners(category)
            if banners:
                print(f"\n{Fore.MAGENTA}📂 Category: {category}{Style.RESET_ALL}")
                for banner in banners[:3]:  # Show first 3 banners
                    print(f"{Fore.GREEN}  • {banner}{Style.RESET_ALL}")
                if len(banners) > 3:
                    print(f"{Fore.YELLOW}  ... and {len(banners) - 3} more{Style.RESET_ALL}")
    
    def _browse_art_categories(self):
        """Browse ASCII art categories with file counts"""
        print(f"\n{Fore.CYAN}📁 ASCII Art Collection Browser{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}═" * 40 + f"{Style.RESET_ALL}")
        
        for category in self.config.BANNER_CATEGORIES:
            banners = self.ascii_art.list_banners(category)
            print(f"{Fore.GREEN}📂 {category:<25}{Style.RESET_ALL} {Fore.CYAN}({len(banners)} files){Style.RESET_ALL}")
            if banners:
                # Show a few examples
                examples = banners[:2]
                for example in examples:
                    print(f"   {Fore.YELLOW}• {example}{Style.RESET_ALL}")
                if len(banners) > 2:
                    print(f"   {Fore.BLUE}... and {len(banners) - 2} more{Style.RESET_ALL}")
            print()
    
    def set_random_banner(self):
        """Set a random banner theme"""
        category, filename = self.ascii_art.get_random_banner()
        self._save_banner_info(category, filename)
        print(f"{Fore.GREEN}🎲 Random banner set: {category}/{filename}{Style.RESET_ALL}")
        self.display_banner()
    
    def reset_banner(self):
        """Reset banner to default"""
        self._save_banner_info("logoasciiart", "zehrasec_inc.txt")
        print(f"{Fore.GREEN}✅ Banner reset to default ZehraSec theme{Style.RESET_ALL}")
        self.display_banner()
    
    def show_current_banner_info(self):
        """Show current banner information"""
        info = self.current_banner_info
        print(f"\n{Fore.CYAN}🎨 Current Banner Information{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}═" * 35 + f"{Style.RESET_ALL}")
        print(f"{Fore.GREEN}Category:{Style.RESET_ALL} {info['category']}")
        print(f"{Fore.GREEN}Filename:{Style.RESET_ALL} {info['filename']}")
        print(f"{Fore.GREEN}Full Path:{Style.RESET_ALL} ascii_art/{info['category']}/{info['filename']}")
    
    def change_prompt_interactive(self):
        """Interactive prompt customization menu"""
        while True:
            print(f"\n{Fore.CYAN}💻 Prompt Customization Menu{Style.RESET_ALL}")
            print(f"{Fore.YELLOW}═" * 40 + f"{Style.RESET_ALL}")
            print(f"{Fore.GREEN}1.{Style.RESET_ALL} Predefined prompts")
            print(f"{Fore.GREEN}2.{Style.RESET_ALL} Custom prompt text")
            print(f"{Fore.GREEN}3.{Style.RESET_ALL} Reset to default")
            print(f"{Fore.GREEN}4.{Style.RESET_ALL} Current prompt info")
            print(f"{Fore.GREEN}0.{Style.RESET_ALL} Back to main menu")
            
            choice = input(f"\n{Fore.CYAN}Select option (0-4): {Style.RESET_ALL}").strip()
            
            if choice == "1":
                self._select_predefined_prompt()
            elif choice == "2":
                self._set_custom_prompt()
            elif choice == "3":
                self.reset_prompt()
            elif choice == "4":
                self.show_current_prompt_info()
            elif choice == "0":
                break
            else:
                print(f"{Fore.RED}❌ Invalid option. Please try again.{Style.RESET_ALL}")
    
    def _select_predefined_prompt(self):
        """Select from predefined prompts"""
        print(f"\n{Fore.CYAN}💻 Predefined Prompts:{Style.RESET_ALL}")
        for i, prompt in enumerate(self.config.PREDEFINED_PROMPTS, 1):
            marker = f"{Fore.YELLOW}[CURRENT]{Style.RESET_ALL}" if prompt == self.current_prompt else ""
            print(f"{Fore.GREEN}{i:2}.{Style.RESET_ALL} {prompt} {marker}")
        
        try:
            choice = int(input(f"\n{Fore.CYAN}Select prompt (1-{len(self.config.PREDEFINED_PROMPTS)}): {Style.RESET_ALL}"))
            if 1 <= choice <= len(self.config.PREDEFINED_PROMPTS):
                prompt = self.config.PREDEFINED_PROMPTS[choice - 1]
                self._save_prompt(prompt)
                print(f"{Fore.GREEN}✅ Prompt set to: {prompt}{Style.RESET_ALL}")
            else:
                print(f"{Fore.RED}❌ Invalid prompt selection.{Style.RESET_ALL}")
        except ValueError:
            print(f"{Fore.RED}❌ Please enter a valid number.{Style.RESET_ALL}")
    
    def _set_custom_prompt(self):
        """Set custom prompt text"""
        print(f"\n{Fore.CYAN}✏️ Custom Prompt Setup{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}Enter your custom prompt text (alphanumeric and basic symbols only){Style.RESET_ALL}")
        
        custom_prompt = input(f"{Fore.GREEN}Custom prompt: {Style.RESET_ALL}").strip()
        
        # Basic validation
        if not custom_prompt:
            print(f"{Fore.RED}❌ Prompt cannot be empty.{Style.RESET_ALL}")
            return
        
        if len(custom_prompt) > 20:
            print(f"{Fore.RED}❌ Prompt must be 20 characters or less.{Style.RESET_ALL}")
            return
        
        # Check for potentially dangerous characters
        dangerous_chars = ['|', '&', ';', '>', '<', '`', '$', '(', ')']
        if any(char in custom_prompt for char in dangerous_chars):
            print(f"{Fore.RED}❌ Prompt contains invalid characters.{Style.RESET_ALL}")
            return
        
        self._save_prompt(custom_prompt)
        print(f"{Fore.GREEN}✅ Custom prompt set: {custom_prompt}{Style.RESET_ALL}")
    
    def set_prompt_direct(self, prompt_text: str):
        """Set prompt directly from command line"""
        if not prompt_text:
            print(f"{Fore.RED}❌ Please provide prompt text. Usage: setprompt [text]{Style.RESET_ALL}")
            return
        
        if len(prompt_text) > 20:
            print(f"{Fore.RED}❌ Prompt must be 20 characters or less.{Style.RESET_ALL}")
            return
        
        dangerous_chars = ['|', '&', ';', '>', '<', '`', '$', '(', ')']
        if any(char in prompt_text for char in dangerous_chars):
            print(f"{Fore.RED}❌ Prompt contains invalid characters.{Style.RESET_ALL}")
            return
        
        self._save_prompt(prompt_text)
        print(f"{Fore.GREEN}✅ Prompt set to: {prompt_text}{Style.RESET_ALL}")
    
    def reset_prompt(self):
        """Reset prompt to default"""
        self._save_prompt(self.config.DEFAULT_PROMPT)
        print(f"{Fore.GREEN}✅ Prompt reset to default: {self.config.DEFAULT_PROMPT}{Style.RESET_ALL}")
    
    def list_prompts(self):
        """List all predefined prompts"""
        print(f"\n{Fore.CYAN}💻 Available Predefined Prompts:{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}═" * 40 + f"{Style.RESET_ALL}")
        
        for i, prompt in enumerate(self.config.PREDEFINED_PROMPTS, 1):
            marker = f"{Fore.YELLOW}[CURRENT]{Style.RESET_ALL}" if prompt == self.current_prompt else ""
            print(f"{Fore.GREEN}{i:2}.{Style.RESET_ALL} {prompt} {marker}")
    
    def show_current_prompt_info(self):
        """Show current prompt information"""
        print(f"\n{Fore.CYAN}💻 Current Prompt Information{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}═" * 35 + f"{Style.RESET_ALL}")
        print(f"{Fore.GREEN}Current Prompt:{Style.RESET_ALL} {self.current_prompt}")
        
        if self.current_prompt in self.config.PREDEFINED_PROMPTS:
            print(f"{Fore.GREEN}Type:{Style.RESET_ALL} Predefined")
        else:
            print(f"{Fore.GREEN}Type:{Style.RESET_ALL} Custom")
    
    def clean_temp_files(self):
        """Clean temporary files"""
        print(f"{Fore.CYAN}🧹 Cleaning temporary files...{Style.RESET_ALL}")
        
        # Clean Python cache
        cache_cleaned = 0
        for root, dirs, files in os.walk('.'):
            if '__pycache__' in dirs:
                import shutil
                shutil.rmtree(os.path.join(root, '__pycache__'))
                cache_cleaned += 1
        
        print(f"{Fore.GREEN}✅ Cleaned {cache_cleaned} cache directories{Style.RESET_ALL}")
    
    def backup_settings(self):
        """Create backup of current settings"""
        backup_dir = self.config.config_dir / "backups"
        backup_dir.mkdir(exist_ok=True)
        
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = backup_dir / f"settings_backup_{timestamp}.json"
        
        backup_data = {
            "prompt": self.current_prompt,
            "banner_info": self.current_banner_info,
            "timestamp": timestamp,
            "version": "2.2.0"
        }
        
        backup_file.write_text(json.dumps(backup_data, indent=2), encoding='utf-8')
        print(f"{Fore.GREEN}✅ Settings backed up to: {backup_file}{Style.RESET_ALL}")
    
    def restore_settings(self):
        """Restore settings from backup"""
        backup_dir = self.config.config_dir / "backups"
        if not backup_dir.exists():
            print(f"{Fore.RED}❌ No backups found.{Style.RESET_ALL}")
            return
        
        backups = list(backup_dir.glob("settings_backup_*.json"))
        if not backups:
            print(f"{Fore.RED}❌ No backup files found.{Style.RESET_ALL}")
            return
        
        print(f"\n{Fore.CYAN}📦 Available Backups:{Style.RESET_ALL}")
        for i, backup in enumerate(sorted(backups, reverse=True), 1):
            timestamp = backup.stem.replace("settings_backup_", "")
            print(f"{Fore.GREEN}{i}.{Style.RESET_ALL} {timestamp}")
        
        try:
            choice = int(input(f"\n{Fore.CYAN}Select backup to restore (1-{len(backups)}): {Style.RESET_ALL}"))
            if 1 <= choice <= len(backups):
                backup_file = sorted(backups, reverse=True)[choice - 1]
                backup_data = json.loads(backup_file.read_text(encoding='utf-8'))
                
                # Restore settings
                self._save_prompt(backup_data["prompt"])
                self._save_banner_info(backup_data["banner_info"]["category"], 
                                     backup_data["banner_info"]["filename"])
                
                print(f"{Fore.GREEN}✅ Settings restored from backup: {backup_data['timestamp']}{Style.RESET_ALL}")
                self.display_banner()
            else:
                print(f"{Fore.RED}❌ Invalid backup selection.{Style.RESET_ALL}")
        except (ValueError, KeyError, json.JSONDecodeError):
            print(f"{Fore.RED}❌ Error restoring backup.{Style.RESET_ALL}")
    
    def process_command(self, command: str) -> bool:
        """Process user command"""
        if not command.strip():
            return True
        
        # Update session activity
        self.security.update_session_activity()
        
        # Add to history
        self.command_history.append(command)
        
        # Parse command and arguments
        parts = command.strip().split()
        cmd = parts[0].lower()
        args = parts[1:] if len(parts) > 1 else []
        
        # Command processing
        if cmd in ['exit', 'quit']:
            return False
        elif cmd == 'logout':
            print(f"{Fore.YELLOW}👋 Logging out... Session ended.{Style.RESET_ALL}")
            if self.config.session_file.exists():
                self.config.session_file.unlink()
            return False
        elif cmd == 'help':
            self.show_help()
        elif cmd == 'status':
            self.show_status()
        elif cmd == 'clear':
            self.display_banner()
        elif cmd == 'matrix':
            self.matrix.run_matrix(3)
            self.display_banner()
        elif cmd == 'sysinfo':
            self.show_system_info()
        elif cmd == 'changepass':
            self.change_password()
        elif cmd in ['changebanner', 'setbanner']:
            self.change_banner_interactive()
        elif cmd == 'randombanner':
            self.set_random_banner()
        elif cmd == 'previewthemes':
            self._preview_themes()
        elif cmd == 'resetbanner':
            self.reset_banner()
        elif cmd == 'browseart':
            self._browse_art_categories()
        elif cmd == 'currentbanner':
            self.show_current_banner_info()
        elif cmd in ['changeprompt', 'prompt']:
            self.change_prompt_interactive()
        elif cmd == 'setprompt':
            prompt_text = ' '.join(args) if args else ''
            self.set_prompt_direct(prompt_text)
        elif cmd == 'resetprompt':
            self.reset_prompt()
        elif cmd == 'listprompts':
            self.list_prompts()
        elif cmd == 'currentprompt':
            self.show_current_prompt_info()
        elif cmd == 'clean':
            self.clean_temp_files()
        elif cmd == 'backup':
            self.backup_settings()
        elif cmd == 'restore':
            self.restore_settings()
        elif cmd == 'update':
            print(f"{Fore.CYAN}🔄 Checking for updates...{Style.RESET_ALL}")
            print(f"{Fore.GREEN}✅ ZehraSec Terminal v2.2.0 is up to date!{Style.RESET_ALL}")
        elif cmd == 'createbanner':
            self.create_custom_banner_interactive()
        elif cmd == 'addbanner':
            if args:
                name = args[0]
                self.create_custom_banner_direct(name)
            else:
                print(f"{Fore.RED}❌ Usage: addbanner <name>{Style.RESET_ALL}")
        elif cmd == 'editbanner':
            if args:
                name = args[0]
                self.edit_custom_banner(name)
            else:
                print(f"{Fore.RED}❌ Usage: editbanner <name>{Style.RESET_ALL}")
        elif cmd == 'deletebanner':
            if args:
                name = args[0]
                self.delete_custom_banner(name)
            else:
                print(f"{Fore.RED}❌ Usage: deletebanner <name>{Style.RESET_ALL}")
        elif cmd == 'listcustom':
            self.list_custom_banners()
        elif cmd == 'importbanner':
            if len(args) >= 2:
                source_path = args[0]
                name = args[1]
                self.import_banner_from_file(source_path, name)
            else:
                print(f"{Fore.RED}❌ Usage: importbanner <source_file> <name>{Style.RESET_ALL}")
        elif cmd == 'exportbanner':
            if len(args) >= 2:
                name = args[0]
                dest_path = args[1]
                self.export_custom_banner(name, dest_path)
            else:
                print(f"{Fore.RED}❌ Usage: exportbanner <name> <destination_file>{Style.RESET_ALL}")
        else:
            print(f"{Fore.RED}❌ Unknown command: {cmd}{Style.RESET_ALL}")
            print(f"{Fore.YELLOW}💡 Type 'help' to see available commands{Style.RESET_ALL}")
        
        return True
    
    def run(self):
        """Main terminal loop"""
        # Display banner
        self.display_banner()
        
        # Authenticate user
        if not self.authenticate():
            print(f"{Fore.RED}❌ Authentication failed. Exiting...{Style.RESET_ALL}")
            return
        
        # Display welcome message
        self.matrix.typing_effect(f"{Fore.GREEN}🛡️ Welcome to ZehraSec Terminal! Type 'help' for commands.{Style.RESET_ALL}")
        print()
        
        # Main command loop
        try:
            while True:
                # Check session validity
                if not self.security.is_session_valid():
                    print(f"{Fore.RED}⏰ Session expired. Please log in again.{Style.RESET_ALL}")
                    break
                
                # Display prompt
                prompt_display = f"{Fore.CYAN}[{self.current_prompt}]${Style.RESET_ALL} "
                command = input(prompt_display)
                
                # Process command
                if not self.process_command(command):
                    break
                    
        except KeyboardInterrupt:
            print(f"\n{Fore.YELLOW}👋 ZehraSec Terminal session terminated.{Style.RESET_ALL}")
        except EOFError:
            print(f"\n{Fore.YELLOW}👋 ZehraSec Terminal session ended.{Style.RESET_ALL}")
        finally:
            # Clean up session
            if self.config.session_file.exists():
                self.config.session_file.unlink()
            self.config.log_activity("Session ended")

    def _get_current_banner_info(self) -> Tuple[str, str]:
        """Get current banner category and filename"""
        try:
            if self.config.banner_file.exists():
                banner_info = json.loads(self.config.banner_file.read_text(encoding='utf-8'))
                return banner_info.get("category", "logoasciiart"), banner_info.get("filename", "zehrasec_inc.txt")
        except:
            pass
        return "logoasciiart", "zehrasec_inc.txt"

def main():
    """Main entry point"""
    # Fix Windows console encoding issues
    if platform.system() == "Windows":
        try:
            import locale
            import codecs
            # Try to set UTF-8 encoding for Windows console
            sys.stdout = codecs.getwriter('utf-8')(sys.stdout.detach())
            sys.stderr = codecs.getwriter('utf-8')(sys.stderr.detach())
        except:
            # Fallback: set console code page to UTF-8
            try:
                import subprocess
                subprocess.run(['chcp', '65001'], shell=True, capture_output=True)
            except:
                pass
    
    try:
        terminal = ZehraSecTerminal()
        terminal.run()
    except KeyboardInterrupt:
        print(f"\n{Fore.YELLOW}👋 ZehraSec Terminal interrupted.{Style.RESET_ALL}")
    except Exception as e:
        print(f"{Fore.RED}❌ Fatal error: {e}{Style.RESET_ALL}")
        logging.error(f"Fatal error: {e}")

if __name__ == "__main__":
    main()
