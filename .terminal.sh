#!/bin/bash
# ZehraSec Terminal - Enhanced Security Terminal Interface
# Version: 2.2.0
# Developed by: Yashab Alam - Founder & CEO of ZehraSec
# License: MIT

# Color definitions
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
BOLD="\033[1m"
RESET="\033[0m"

# Extended color palette (v2.2.0)
LIGHT_GREEN="\033[92m"
LIGHT_BLUE="\033[94m"
LIGHT_CYAN="\033[96m"
ORANGE="\033[38;5;208m"
PURPLE="\033[38;5;129m"

# Configuration
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CONFIG_DIR="$HOME/.zehrasec"
PASS_FILE="$CONFIG_DIR/pass"
FAILS_FILE="$CONFIG_DIR/fails"
LOCK_FILE="$CONFIG_DIR/locktime"
LOG_FILE="$CONFIG_DIR/access.log"
SESSION_FILE="$CONFIG_DIR/session"
PROMPT_FILE="$CONFIG_DIR/prompt"
BANNER_FILE="$CONFIG_DIR/banner"
PREFS_FILE="$CONFIG_DIR/preferences"

# Security settings
MAX_FAIL_ATTEMPTS=3
LOCKOUT_DURATION=300
MIN_PASSWORD_LENGTH=6
SESSION_TIMEOUT=3600

# Performance settings
TYPING_SPEED=0.02
MATRIX_DURATION=3
ENABLE_ANIMATIONS=true
CACHE_ASCII_ART=true

# Banner categories
BANNER_CATEGORIES=("logoasciiart" "codingasciiart" "loveasciiart" "terminalskullasciiart" "fuckoff")
DEFAULT_BANNER_CATEGORY="logoasciiart"
DEFAULT_BANNER_FILE="zehrasec_inc.txt"

# Predefined prompts
PREDEFINED_PROMPTS=("ZehraSec" "Terminal" "Secure" "Admin" "Root" "Cyber" "Hacker" "Matrix" "Shell" "Console")
DEFAULT_PROMPT="ZehraSec"

# Initialize configuration directory
init_config() {
    if [[ ! -d "$CONFIG_DIR" ]]; then
        mkdir -p "$CONFIG_DIR"
        chmod 700 "$CONFIG_DIR"
    fi
}

# Logging function
log_activity() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$LOG_FILE"
}

# Typing effect
type_text() {
    local text="$1"
    local speed="${2:-$TYPING_SPEED}"
    
    if [[ "$ENABLE_ANIMATIONS" == "true" && "$speed" != "0" ]]; then
        for (( i=0; i<${#text}; i++ )); do
            echo -n "${text:$i:1}"
            sleep "$speed"
        done
        echo
    else
        echo "$text"
    fi
}

# Matrix rain effect
matrix_rain() {
    local duration="${1:-$MATRIX_DURATION}"
    local colors=("$GREEN" "$CYAN" "$WHITE" "$BLUE")
    local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%^&*"
    local width=$(tput cols 2>/dev/null || echo 80)
    local height=$(tput lines 2>/dev/null || echo 24)
    
    if [[ "$ENABLE_ANIMATIONS" != "true" ]]; then
        return
    fi
    
    local end_time=$(($(date +%s) + duration))
    
    clear
    tput civis 2>/dev/null # Hide cursor
    
    while [[ $(date +%s) -lt $end_time ]]; do
        for ((col=0; col<width; col++)); do
            if (( RANDOM % 20 == 0 )); then
                local row=$((RANDOM % height + 1))
                local char=${chars:$((RANDOM % ${#chars})):1}
                local color=${colors[$((RANDOM % ${#colors[@]}))]}
                tput cup $row $col 2>/dev/null
                echo -ne "${color}${char}${RESET}"
            fi
        done
        sleep 0.05
    done
    
    tput cnorm 2>/dev/null # Show cursor
    clear
}

# Load ASCII art
load_ascii_art() {
    local category="$1"
    local file="$2"
    local art_file="${SCRIPT_DIR}/${category}/${file}"
    
    if [[ -f "$art_file" ]]; then
        cat "$art_file" 2>/dev/null || echo "Failed to load ASCII art"
    else
        # Fallback banner
        echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗"
        echo -e "║                    🛡️  ZehraSec Terminal v2.2.0  🛡️                        ║"
        echo -e "║                     Enhanced Security Terminal Interface                     ║"
        echo -e "║                  Developed by Yashab Alam - CEO of ZehraSec                 ║"
        echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"
    fi
}

# Display banner
show_banner() {
    local banner_info=""
    if [[ -f "$BANNER_FILE" ]]; then
        banner_info=$(cat "$BANNER_FILE")
    else
        banner_info="$DEFAULT_BANNER_CATEGORY/$DEFAULT_BANNER_FILE"
        echo "$banner_info" > "$BANNER_FILE"
    fi
    
    local category=$(echo "$banner_info" | cut -d'/' -f1)
    local file=$(echo "$banner_info" | cut -d'/' -f2)
    
    echo -e "${GREEN}"
    load_ascii_art "$category" "$file"
    echo -e "${RESET}"
}

# Get current prompt
get_current_prompt() {
    if [[ -f "$PROMPT_FILE" ]]; then
        cat "$PROMPT_FILE"
    else
        echo "$DEFAULT_PROMPT"
    fi
}

# Password hashing
hash_password() {
    local password="$1"
    echo -n "$password" | sha256sum | cut -d' ' -f1
}

# Check password strength
check_password_strength() {
    local password="$1"
    
    if [[ ${#password} -lt $MIN_PASSWORD_LENGTH ]]; then
        echo "Password must be at least $MIN_PASSWORD_LENGTH characters long"
        return 1
    fi
    
    return 0
}

# Account lockout check
check_lockout() {
    if [[ -f "$LOCK_FILE" ]]; then
        local lock_time=$(cat "$LOCK_FILE")
        local current_time=$(date +%s)
        local time_diff=$((current_time - lock_time))
        
        if [[ $time_diff -lt $LOCKOUT_DURATION ]]; then
            local remaining=$((LOCKOUT_DURATION - time_diff))
            echo -e "${RED}Account locked. Try again in $remaining seconds.${RESET}"
            log_activity "Account locked - attempted access during lockout period"
            return 1
        else
            rm -f "$LOCK_FILE" "$FAILS_FILE"
        fi
    fi
    return 0
}

# Authentication
authenticate() {
    local attempts=0
    local max_attempts=$MAX_FAIL_ATTEMPTS
    
    if ! check_lockout; then
        return 1
    fi
    
    if [[ -f "$FAILS_FILE" ]]; then
        attempts=$(cat "$FAILS_FILE")
    fi
    
    while true; do
        echo -ne "${CYAN}Enter password: ${RESET}"
        read -s password
        echo
        
        local hashed_password=$(hash_password "$password")
        
        if [[ -f "$PASS_FILE" ]]; then
            local stored_hash=$(cat "$PASS_FILE")
            if [[ "$hashed_password" == "$stored_hash" ]]; then
                echo -e "${GREEN}✅ Authentication successful${RESET}"
                rm -f "$FAILS_FILE"
                echo "$(date +%s)" > "$SESSION_FILE"
                log_activity "Successful login"
                return 0
            fi
        else
            # First run - set password
            local strength_check=$(check_password_strength "$password")
            if [[ $? -ne 0 ]]; then
                echo -e "${RED}$strength_check${RESET}"
                continue
            fi
            
            echo -ne "${CYAN}Confirm password: ${RESET}"
            read -s confirm_password
            echo
            
            if [[ "$password" == "$confirm_password" ]]; then
                echo "$hashed_password" > "$PASS_FILE"
                chmod 600 "$PASS_FILE"
                echo -e "${GREEN}✅ Password set successfully${RESET}"
                echo "$(date +%s)" > "$SESSION_FILE"
                log_activity "Password set - first run"
                return 0
            else
                echo -e "${RED}❌ Passwords do not match${RESET}"
                continue
            fi
        fi
        
        # Failed attempt
        attempts=$((attempts + 1))
        echo "$attempts" > "$FAILS_FILE"
        echo -e "${RED}❌ Authentication failed ($attempts/$max_attempts)${RESET}"
        log_activity "Failed login attempt ($attempts/$max_attempts)"
        
        if [[ $attempts -ge $max_attempts ]]; then
            echo "$(date +%s)" > "$LOCK_FILE"
            echo -e "${RED}🔒 Account locked for $LOCKOUT_DURATION seconds${RESET}"
            log_activity "Account locked after $max_attempts failed attempts"
            return 1
        fi
        
        sleep 1
    done
}

# Session validation
validate_session() {
    if [[ -f "$SESSION_FILE" ]]; then
        local session_start=$(cat "$SESSION_FILE")
        local current_time=$(date +%s)
        local session_age=$((current_time - session_start))
        
        if [[ $session_age -gt $SESSION_TIMEOUT ]]; then
            echo -e "${YELLOW}⚠️ Session expired${RESET}"
            rm -f "$SESSION_FILE"
            log_activity "Session expired"
            return 1
        fi
    else
        return 1
    fi
    return 0
}

# Change password
change_password() {
    echo -e "${CYAN}🔐 Change Password${RESET}"
    echo -ne "${CYAN}Current password: ${RESET}"
    read -s current_password
    echo
    
    local current_hash=$(hash_password "$current_password")
    local stored_hash=$(cat "$PASS_FILE")
    
    if [[ "$current_hash" != "$stored_hash" ]]; then
        echo -e "${RED}❌ Current password incorrect${RESET}"
        log_activity "Failed password change - incorrect current password"
        return 1
    fi
    
    echo -ne "${CYAN}New password: ${RESET}"
    read -s new_password
    echo
    
    local strength_check=$(check_password_strength "$new_password")
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}$strength_check${RESET}"
        return 1
    fi
    
    echo -ne "${CYAN}Confirm new password: ${RESET}"
    read -s confirm_password
    echo
    
    if [[ "$new_password" == "$confirm_password" ]]; then
        local new_hash=$(hash_password "$new_password")
        echo "$new_hash" > "$PASS_FILE"
        echo -e "${GREEN}✅ Password changed successfully${RESET}"
        log_activity "Password changed successfully"
    else
        echo -e "${RED}❌ Passwords do not match${RESET}"
        return 1
    fi
}

# Browse ASCII art categories
browse_art_categories() {
    echo -e "${CYAN}🎨 ASCII Art Categories:${RESET}"
    echo
    
    for category in "${BANNER_CATEGORIES[@]}"; do
        local art_dir="${SCRIPT_DIR}/${category}"
        if [[ -d "$art_dir" ]]; then
            local file_count=$(find "$art_dir" -name "*.txt" | wc -l)
            echo -e "${YELLOW}📁 $category${RESET} (${file_count} files)"
            
            # Show first few files as preview
            local files=($(find "$art_dir" -name "*.txt" | head -3))
            for file in "${files[@]}"; do
                local filename=$(basename "$file" .txt)
                echo "   • $filename"
            done
            if [[ $file_count -gt 3 ]]; then
                echo "   • ... and $((file_count - 3)) more"
            fi
            echo
        fi
    done
}

# Interactive banner customization
interactive_banner_menu() {
    while true; do
        clear
        show_banner
        echo
        echo -e "${CYAN}🎨 Banner Customization Menu${RESET}"
        echo -e "${YELLOW}1.${RESET} Change theme"
        echo -e "${YELLOW}2.${RESET} Preview themes"
        echo -e "${YELLOW}3.${RESET} Random theme"
        echo -e "${YELLOW}4.${RESET} Browse categories"
        echo -e "${YELLOW}5.${RESET} Reset to default"
        echo -e "${YELLOW}6.${RESET} Current banner info"
        echo -e "${YELLOW}0.${RESET} Back to main menu"
        echo
        echo -ne "${CYAN}Choose option [0-6]: ${RESET}"
        read -r choice
        
        case $choice in
            1) change_banner_theme ;;
            2) preview_all_themes ;;
            3) set_random_banner ;;
            4) browse_art_categories; read -p "Press Enter to continue..." ;;
            5) reset_to_default_banner ;;
            6) show_current_banner_info ;;
            0) return ;;
            *) echo -e "${RED}Invalid option${RESET}"; sleep 1 ;;
        esac
    done
}

# Change banner theme
change_banner_theme() {
    echo -e "${CYAN}🎨 Available Categories:${RESET}"
    echo
    
    local i=1
    for category in "${BANNER_CATEGORIES[@]}"; do
        local art_dir="${SCRIPT_DIR}/${category}"
        if [[ -d "$art_dir" ]]; then
            local file_count=$(find "$art_dir" -name "*.txt" | wc -l)
            echo -e "${YELLOW}$i.${RESET} $category (${file_count} files)"
        fi
        ((i++))
    done
    
    echo
    echo -ne "${CYAN}Select category [1-${#BANNER_CATEGORIES[@]}]: ${RESET}"
    read -r cat_choice
    
    if [[ $cat_choice -ge 1 && $cat_choice -le ${#BANNER_CATEGORIES[@]} ]]; then
        local selected_category="${BANNER_CATEGORIES[$((cat_choice-1))]}"
        select_banner_from_category "$selected_category"
    else
        echo -e "${RED}Invalid selection${RESET}"
        sleep 1
    fi
}

# Select banner from category
select_banner_from_category() {
    local category="$1"
    local art_dir="${SCRIPT_DIR}/${category}"
    
    if [[ ! -d "$art_dir" ]]; then
        echo -e "${RED}Category directory not found: $category${RESET}"
        sleep 2
        return
    fi
    
    echo -e "${CYAN}🎨 Available themes in $category:${RESET}"
    echo
    
    local files=($(find "$art_dir" -name "*.txt"))
    if [[ ${#files[@]} -eq 0 ]]; then
        echo -e "${RED}No ASCII art files found in $category${RESET}"
        sleep 2
        return
    fi
    
    local i=1
    for file in "${files[@]}"; do
        local filename=$(basename "$file" .txt)
        echo -e "${YELLOW}$i.${RESET} $filename"
        ((i++))
    done
    
    echo
    echo -ne "${CYAN}Select theme [1-${#files[@]}]: ${RESET}"
    read -r theme_choice
    
    if [[ $theme_choice -ge 1 && $theme_choice -le ${#files[@]} ]]; then
        local selected_file=$(basename "${files[$((theme_choice-1))]}")
        echo "$category/$selected_file" > "$BANNER_FILE"
        echo -e "${GREEN}✅ Banner changed to: $selected_file${RESET}"
        log_activity "Banner changed to: $category/$selected_file"
    else
        echo -e "${RED}Invalid selection${RESET}"
    fi
    
    sleep 2
}

# Set random banner
set_random_banner() {
    local all_files=()
    
    for category in "${BANNER_CATEGORIES[@]}"; do
        local art_dir="${SCRIPT_DIR}/${category}"
        if [[ -d "$art_dir" ]]; then
            while IFS= read -r -d '' file; do
                all_files+=("$category/$(basename "$file")")
            done < <(find "$art_dir" -name "*.txt" -print0)
        fi
    done
    
    if [[ ${#all_files[@]} -gt 0 ]]; then
        local random_banner="${all_files[$RANDOM % ${#all_files[@]}]}"
        echo "$random_banner" > "$BANNER_FILE"
        echo -e "${GREEN}✅ Random banner set: $random_banner${RESET}"
        log_activity "Random banner set: $random_banner"
    else
        echo -e "${RED}No ASCII art files found${RESET}"
    fi
    
    sleep 2
}

# Preview all themes
preview_all_themes() {
    echo -e "${CYAN}🎨 Theme Preview Mode${RESET}"
    echo -e "${YELLOW}Use arrow keys or Enter to navigate, 'q' to quit${RESET}"
    sleep 2
    
    local all_files=()
    for category in "${BANNER_CATEGORIES[@]}"; do
        local art_dir="${SCRIPT_DIR}/${category}"
        if [[ -d "$art_dir" ]]; then
            while IFS= read -r -d '' file; do
                all_files+=("$category/$(basename "$file")")
            done < <(find "$art_dir" -name "*.txt" -print0)
        fi
    done
    
    local current_index=0
    
    while true; do
        clear
        local current_banner="${all_files[$current_index]}"
        local category=$(echo "$current_banner" | cut -d'/' -f1)
        local file=$(echo "$current_banner" | cut -d'/' -f2)
        
        echo -e "${GREEN}"
        load_ascii_art "$category" "$file"
        echo -e "${RESET}"
        
        echo
        echo -e "${CYAN}Preview: $current_banner ($((current_index + 1))/${#all_files[@]})${RESET}"
        echo -e "${YELLOW}Commands: [Enter] Next | [b] Back | [s] Set this theme | [q] Quit${RESET}"
        
        read -n1 key
        case $key in
            '' | 'n' | 'N') # Enter or n for next
                current_index=$(( (current_index + 1) % ${#all_files[@]} ))
                ;;
            'b' | 'B') # Back
                current_index=$(( (current_index - 1 + ${#all_files[@]}) % ${#all_files[@]} ))
                ;;
            's' | 'S') # Set this theme
                echo "$current_banner" > "$BANNER_FILE"
                echo -e "\n${GREEN}✅ Banner set to: $current_banner${RESET}"
                log_activity "Banner set via preview: $current_banner"
                sleep 2
                return
                ;;
            'q' | 'Q') # Quit
                return
                ;;
        esac
    done
}

# Reset to default banner
reset_to_default_banner() {
    echo "$DEFAULT_BANNER_CATEGORY/$DEFAULT_BANNER_FILE" > "$BANNER_FILE"
    echo -e "${GREEN}✅ Banner reset to default${RESET}"
    log_activity "Banner reset to default"
    sleep 2
}

# Show current banner info
show_current_banner_info() {
    local banner_info=""
    if [[ -f "$BANNER_FILE" ]]; then
        banner_info=$(cat "$BANNER_FILE")
    else
        banner_info="$DEFAULT_BANNER_CATEGORY/$DEFAULT_BANNER_FILE"
    fi
    
    local category=$(echo "$banner_info" | cut -d'/' -f1)
    local file=$(echo "$banner_info" | cut -d'/' -f2 | sed 's/\.txt$//')
    
    echo -e "${CYAN}📋 Current Banner Information:${RESET}"
    echo -e "${YELLOW}   Category: $category${RESET}"
    echo -e "${YELLOW}   Theme: $file${RESET}"
    echo -e "${YELLOW}   File: $banner_info${RESET}"
    
    read -p "Press Enter to continue..."
}

# Interactive prompt customization
interactive_prompt_menu() {
    while true; do
        clear
        show_banner
        local current_prompt=$(get_current_prompt)
        
        echo
        echo -e "${CYAN}💻 Prompt Customization Menu${RESET}"
        echo -e "${YELLOW}Current prompt: ${GREEN}$current_prompt${RESET}"
        echo
        echo -e "${YELLOW}1.${RESET} Predefined prompts"
        echo -e "${YELLOW}2.${RESET} Custom prompt text"
        echo -e "${YELLOW}3.${RESET} Reset to default"
        echo -e "${YELLOW}4.${RESET} Current prompt info"
        echo -e "${YELLOW}0.${RESET} Back to main menu"
        echo
        echo -ne "${CYAN}Choose option [0-4]: ${RESET}"
        read -r choice
        
        case $choice in
            1) select_predefined_prompt ;;
            2) set_custom_prompt ;;
            3) reset_prompt ;;
            4) show_current_prompt_info ;;
            0) return ;;
            *) echo -e "${RED}Invalid option${RESET}"; sleep 1 ;;
        esac
    done
}

# Select predefined prompt
select_predefined_prompt() {
    echo -e "${CYAN}💻 Predefined Prompts:${RESET}"
    echo
    
    local i=1
    for prompt in "${PREDEFINED_PROMPTS[@]}"; do
        echo -e "${YELLOW}$i.${RESET} $prompt"
        ((i++))
    done
    
    echo
    echo -ne "${CYAN}Select prompt [1-${#PREDEFINED_PROMPTS[@]}]: ${RESET}"
    read -r prompt_choice
    
    if [[ $prompt_choice -ge 1 && $prompt_choice -le ${#PREDEFINED_PROMPTS[@]} ]]; then
        local selected_prompt="${PREDEFINED_PROMPTS[$((prompt_choice-1))]}"
        echo "$selected_prompt" > "$PROMPT_FILE"
        echo -e "${GREEN}✅ Prompt changed to: $selected_prompt${RESET}"
        log_activity "Prompt changed to: $selected_prompt"
    else
        echo -e "${RED}Invalid selection${RESET}"
    fi
    
    sleep 2
}

# Set custom prompt
set_custom_prompt() {
    echo -e "${CYAN}💻 Custom Prompt Setup${RESET}"
    echo -e "${YELLOW}Enter your custom prompt text (max 20 characters):${RESET}"
    echo -ne "${CYAN}Prompt: ${RESET}"
    read -r custom_prompt
    
    # Input validation
    if [[ -z "$custom_prompt" ]]; then
        echo -e "${RED}Prompt cannot be empty${RESET}"
        sleep 2
        return
    fi
    
    if [[ ${#custom_prompt} -gt 20 ]]; then
        echo -e "${RED}Prompt too long (max 20 characters)${RESET}"
        sleep 2
        return
    fi
    
    # Security filtering
    if [[ "$custom_prompt" =~ [^a-zA-Z0-9_-] ]]; then
        echo -e "${RED}Only alphanumeric characters, underscores, and hyphens allowed${RESET}"
        sleep 2
        return
    fi
    
    echo "$custom_prompt" > "$PROMPT_FILE"
    echo -e "${GREEN}✅ Custom prompt set: $custom_prompt${RESET}"
    log_activity "Custom prompt set: $custom_prompt"
    sleep 2
}

# Reset prompt
reset_prompt() {
    echo "$DEFAULT_PROMPT" > "$PROMPT_FILE"
    echo -e "${GREEN}✅ Prompt reset to default: $DEFAULT_PROMPT${RESET}"
    log_activity "Prompt reset to default"
    sleep 2
}

# Show current prompt info
show_current_prompt_info() {
    local current_prompt=$(get_current_prompt)
    
    echo -e "${CYAN}📋 Current Prompt Information:${RESET}"
    echo -e "${YELLOW}   Current: $current_prompt${RESET}"
    echo -e "${YELLOW}   Default: $DEFAULT_PROMPT${RESET}"
    
    # Check if it's predefined or custom
    local is_predefined=false
    for prompt in "${PREDEFINED_PROMPTS[@]}"; do
        if [[ "$current_prompt" == "$prompt" ]]; then
            is_predefined=true
            break
        fi
    done
    
    if [[ $is_predefined == true ]]; then
        echo -e "${YELLOW}   Type: Predefined${RESET}"
    else
        echo -e "${YELLOW}   Type: Custom${RESET}"
    fi
    
    read -p "Press Enter to continue..."
}

# System information
show_system_info() {
    echo -e "${CYAN}💻 System Information${RESET}"
    echo -e "${YELLOW}Hostname:${RESET} $(hostname)"
    echo -e "${YELLOW}User:${RESET} $(whoami)"
    echo -e "${YELLOW}OS:${RESET} $(uname -s)"
    echo -e "${YELLOW}Kernel:${RESET} $(uname -r)"
    echo -e "${YELLOW}Architecture:${RESET} $(uname -m)"
    echo -e "${YELLOW}Uptime:${RESET} $(uptime | cut -d',' -f1 | sed 's/.*up //')"
    echo -e "${YELLOW}Shell:${RESET} $SHELL"
    echo -e "${YELLOW}Terminal:${RESET} $TERM"
    
    if command -v free &> /dev/null; then
        echo -e "${YELLOW}Memory:${RESET} $(free -h | grep '^Mem:' | awk '{print $3 "/" $2}')"
    fi
    
    if command -v df &> /dev/null; then
        echo -e "${YELLOW}Disk Usage:${RESET} $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')"
    fi
}

# Status display
show_status() {
    echo -e "${CYAN}🛡️ ZehraSec Terminal Status${RESET}"
    echo
    
    # Security status
    echo -e "${YELLOW}🔒 Security Status:${RESET}"
    if [[ -f "$PASS_FILE" ]]; then
        echo -e "   Password: ${GREEN}✅ Set${RESET}"
    else
        echo -e "   Password: ${RED}❌ Not set${RESET}"
    fi
    
    if [[ -f "$SESSION_FILE" ]]; then
        local session_start=$(cat "$SESSION_FILE")
        local current_time=$(date +%s)
        local session_age=$((current_time - session_start))
        local remaining=$((SESSION_TIMEOUT - session_age))
        echo -e "   Session: ${GREEN}✅ Active${RESET} (${remaining}s remaining)"
    else
        echo -e "   Session: ${RED}❌ Inactive${RESET}"
    fi
    
    if [[ -f "$FAILS_FILE" ]]; then
        local fails=$(cat "$FAILS_FILE")
        echo -e "   Failed attempts: ${YELLOW}$fails/$MAX_FAIL_ATTEMPTS${RESET}"
    else
        echo -e "   Failed attempts: ${GREEN}0/$MAX_FAIL_ATTEMPTS${RESET}"
    fi
    
    echo
    
    # Customization status
    echo -e "${YELLOW}🎨 Customization Status:${RESET}"
    local current_banner=$(cat "$BANNER_FILE" 2>/dev/null || echo "$DEFAULT_BANNER_CATEGORY/$DEFAULT_BANNER_FILE")
    local current_prompt=$(get_current_prompt)
    echo -e "   Banner: ${GREEN}$current_banner${RESET}"
    echo -e "   Prompt: ${GREEN}$current_prompt${RESET}"
    
    echo
    
    # System status
    echo -e "${YELLOW}💻 System Status:${RESET}"
    echo -e "   Terminal: ${GREEN}$(tput cols)x$(tput lines)${RESET}"
    echo -e "   Colors: ${GREEN}$(tput colors 2>/dev/null || echo 'Unknown')${RESET}"
    echo -e "   Config directory: ${GREEN}$CONFIG_DIR${RESET}"
    
    # Check ASCII art availability
    local art_count=0
    for category in "${BANNER_CATEGORIES[@]}"; do
        local art_dir="${SCRIPT_DIR}/${category}"
        if [[ -d "$art_dir" ]]; then
            art_count=$((art_count + $(find "$art_dir" -name "*.txt" | wc -l)))
        fi
    done
    echo -e "   ASCII art files: ${GREEN}$art_count${RESET}"
}

# Help system
show_help() {
    echo -e "${CYAN}🆘 ZehraSec Terminal Help${RESET}"
    echo
    echo -e "${YELLOW}📋 Core Commands:${RESET}"
    echo -e "   ${GREEN}help${RESET}         - Show this help menu"
    echo -e "   ${GREEN}status${RESET}       - Display system and security status"
    echo -e "   ${GREEN}clear${RESET}        - Clear screen and redisplay banner"
    echo -e "   ${GREEN}matrix${RESET}       - Show matrix rain effect"
    echo -e "   ${GREEN}sysinfo${RESET}      - Display detailed system information"
    echo -e "   ${GREEN}changepass${RESET}   - Change your password securely"
    echo -e "   ${GREEN}logout${RESET}       - End session and exit"
    echo -e "   ${GREEN}exit${RESET}         - Exit terminal"
    echo
    echo -e "${YELLOW}🎨 Banner Customization:${RESET}"
    echo -e "   ${GREEN}changebanner${RESET} - Interactive banner customization menu"
    echo -e "   ${GREEN}setbanner${RESET}    - Alias for changebanner"
    echo -e "   ${GREEN}randombanner${RESET} - Set random theme"
    echo -e "   ${GREEN}previewthemes${RESET}- Preview all available themes"
    echo -e "   ${GREEN}resetbanner${RESET}  - Reset to default banner"
    echo -e "   ${GREEN}browseart${RESET}    - Browse ASCII art by category"
    echo -e "   ${GREEN}currentbanner${RESET}- Show current banner information"
    echo
    echo -e "${YELLOW}💻 Prompt Customization:${RESET}"
    echo -e "   ${GREEN}changeprompt${RESET} - Interactive prompt customization menu"
    echo -e "   ${GREEN}prompt${RESET}       - Alias for changeprompt"
    echo -e "   ${GREEN}setprompt${RESET}    - Set custom prompt text directly"
    echo -e "   ${GREEN}resetprompt${RESET}  - Reset to default prompt"
    echo -e "   ${GREEN}listprompts${RESET}  - Show all predefined prompts"
    echo -e "   ${GREEN}currentprompt${RESET}- Display current prompt info"
    echo
    echo -e "${YELLOW}🛡️ About ZehraSec:${RESET}"
    echo -e "   ${CYAN}Developer:${RESET} Yashab Alam - Founder & CEO of ZehraSec"
    echo -e "   ${CYAN}Version:${RESET} 2.2.0 - Enhanced Security Terminal Interface"
    echo -e "   ${CYAN}License:${RESET} MIT License"
}

# Main command loop
main_loop() {
    local current_prompt=$(get_current_prompt)
    
    while true; do
        # Session validation
        if ! validate_session; then
            echo -e "${RED}Session expired. Please login again.${RESET}"
            break
        fi
        
        echo -ne "${GREEN}$current_prompt${RESET}${CYAN}@${RESET}${YELLOW}$(hostname)${RESET}${CYAN}:${RESET}${BLUE}\$${RESET} "
        read -r command args
        
        case $command in
            "help")
                show_help
                ;;
            "status")
                show_status
                ;;
            "clear")
                clear
                show_banner
                ;;
            "matrix")
                matrix_rain "${args:-3}"
                ;;
            "sysinfo")
                show_system_info
                ;;
            "changepass")
                change_password
                ;;
            "changebanner" | "setbanner")
                interactive_banner_menu
                clear
                show_banner
                ;;
            "randombanner")
                set_random_banner
                clear
                show_banner
                ;;
            "previewthemes")
                preview_all_themes
                clear
                show_banner
                ;;
            "resetbanner")
                reset_to_default_banner
                clear
                show_banner
                ;;
            "browseart")
                browse_art_categories
                read -p "Press Enter to continue..."
                ;;
            "currentbanner")
                show_current_banner_info
                ;;
            "changeprompt" | "prompt")
                interactive_prompt_menu
                current_prompt=$(get_current_prompt)
                clear
                show_banner
                ;;
            "setprompt")
                if [[ -n "$args" ]]; then
                    # Security validation
                    if [[ ${#args} -le 20 && "$args" =~ ^[a-zA-Z0-9_-]+$ ]]; then
                        echo "$args" > "$PROMPT_FILE"
                        current_prompt="$args"
                        echo -e "${GREEN}✅ Prompt set to: $args${RESET}"
                        log_activity "Direct prompt set: $args"
                    else
                        echo -e "${RED}Invalid prompt. Use only alphanumeric characters, max 20 chars${RESET}"
                    fi
                else
                    echo -e "${RED}Usage: setprompt <prompt_text>${RESET}"
                fi
                ;;
            "resetprompt")
                echo "$DEFAULT_PROMPT" > "$PROMPT_FILE"
                current_prompt="$DEFAULT_PROMPT"
                echo -e "${GREEN}✅ Prompt reset to default${RESET}"
                ;;
            "listprompts")
                echo -e "${CYAN}💻 Available Predefined Prompts:${RESET}"
                for prompt in "${PREDEFINED_PROMPTS[@]}"; do
                    echo -e "   • $prompt"
                done
                ;;
            "currentprompt")
                show_current_prompt_info
                ;;
            "logout" | "exit")
                echo -e "${YELLOW}Goodbye! Stay secure with ZehraSec! 🛡️${RESET}"
                rm -f "$SESSION_FILE"
                log_activity "User logout"
                exit 0
                ;;
            "")
                # Empty command, just continue
                ;;
            *)
                echo -e "${RED}Unknown command: $command${RESET}"
                echo -e "${CYAN}Type 'help' for available commands${RESET}"
                ;;
        esac
        
        echo
    done
}

# Main execution
main() {
    # Initialize
    init_config
    
    # Welcome screen
    clear
    show_banner
    
    echo -e "${CYAN}🛡️ Welcome to ZehraSec Terminal v2.2.0${RESET}"
    echo -e "${YELLOW}Enhanced Security Terminal Interface${RESET}"
    echo -e "${MAGENTA}Developed by Yashab Alam - Founder & CEO of ZehraSec${RESET}"
    echo
    
    # Authentication
    if ! authenticate; then
        exit 1
    fi
    
    echo
    matrix_rain 2
    
    clear
    show_banner
    
    echo -e "${GREEN}🎉 Welcome to your secure terminal environment!${RESET}"
    echo -e "${CYAN}Type 'help' to see all available commands${RESET}"
    echo -e "${YELLOW}Try 'changebanner' to customize your banner theme!${RESET}"
    echo
    
    # Main command loop
    main_loop
}

# Run main function
main "$@"
