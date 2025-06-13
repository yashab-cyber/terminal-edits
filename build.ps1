# ZehraSec Terminal - Enhanced PowerShell Build Script v2.2.0
# Developed by: Yashab Alam - Founder & CEO of ZehraSec
# GitHub Repository: https://github.com/yashab-cyber/terminal-edits
# Support Email: yashabalam707@gmail.com
# Donation Support: See DONATE.md for donation options
# Windows-native installation and management system

param(
    [switch]$Install,
    [switch]$Test,
    [switch]$TestFeatures,
    [switch]$TestDependencies,
    [switch]$SetupDependencies,
    [switch]$InstallQuiet,
    [switch]$Clean,
    [switch]$CleanAll,
    [switch]$Backup,
    [switch]$Force,
    [switch]$Verbose,
    [switch]$Debug,
    [switch]$Help,
    [switch]$DetectPackageManagers,
    [switch]$UseChocolatey,
    [switch]$UseScoop,
    [switch]$UseWinget
)

# Color definitions for Windows
$Colors = @{
    Red = [ConsoleColor]::Red
    Green = [ConsoleColor]::Green  
    Yellow = [ConsoleColor]::Yellow
    Blue = [ConsoleColor]::Blue
    Magenta = [ConsoleColor]::Magenta
    Cyan = [ConsoleColor]::Cyan
    White = [ConsoleColor]::White
}

# Configuration
$ScriptDir = $PSScriptRoot
$InstallDir = "$env:USERPROFILE\.local\share\zehrasec"
$ConfigDir = "$env:USERPROFILE\.zehrasec"
$BinDir = "$env:USERPROFILE\.local\bin"

# Required packages
$RequiredPackages = @{
    'git' = 'Version control system'
    'python3' = 'Python 3.7+ interpreter'
    'curl' = 'Data transfer tool'
}

$OptionalPackages = @{
    'figlet' = 'ASCII art generator'
    'nodejs' = 'JavaScript runtime'
}

function Write-ColoredOutput {
    param(
        [string]$Message,
        [ConsoleColor]$Color = [ConsoleColor]::White,
        [switch]$NoNewline
    )
    
    $originalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    
    if ($NoNewline) {
        Write-Host $Message -NoNewline
    } else {
        Write-Host $Message
    }
    
    $Host.UI.RawUI.ForegroundColor = $originalColor
}

function Show-Header {
    Clear-Host
    Write-ColoredOutput "╔══════════════════════════════════════════════════════════════════════════════╗" -Color Cyan
    Write-ColoredOutput "║                    🛡️  ZehraSec Terminal Builder v2.2.0  🛡️                ║" -Color Cyan
    Write-ColoredOutput "║                     Enhanced Security Terminal Interface                     ║" -Color Cyan
    Write-ColoredOutput "║                  Developed by Yashab Alam - CEO of ZehraSec                 ║" -Color Cyan
    Write-ColoredOutput "╚══════════════════════════════════════════════════════════════════════════════╝" -Color Cyan
    Write-Host ""
    
    Write-ColoredOutput "🖥️  Windows Environment Information:" -Color Green
    Write-ColoredOutput "   • Windows Version: $((Get-WmiObject Win32_OperatingSystem).Caption)" -Color Yellow
    Write-ColoredOutput "   • PowerShell Version: $($PSVersionTable.PSVersion)" -Color Yellow
    Write-ColoredOutput "   • Architecture: $env:PROCESSOR_ARCHITECTURE" -Color Yellow
    Write-ColoredOutput "   • User: $env:USERNAME" -Color Yellow
    Write-ColoredOutput "   • Install Directory: $InstallDir" -Color Yellow
    Write-Host ""
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Command {
    param([string]$Command)
    
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Test-PackageManager {
    param([string]$Manager)
    
    switch ($Manager) {
        'chocolatey' { return Test-Command 'choco' }
        'scoop' { return Test-Command 'scoop' }
        'winget' { return Test-Command 'winget' }
        default { return $false }
    }
}

function Get-AvailablePackageManagers {
    $managers = @()
    
    if (Test-PackageManager 'chocolatey') { $managers += 'chocolatey' }
    if (Test-PackageManager 'scoop') { $managers += 'scoop' }
    if (Test-PackageManager 'winget') { $managers += 'winget' }
    
    return $managers
}

function Install-PackageManager {
    param([string]$Manager)
    
    Write-ColoredOutput "📦 Installing $Manager package manager..." -Color Blue
    
    switch ($Manager) {
        'chocolatey' {
            try {
                Set-ExecutionPolicy Bypass -Scope Process -Force
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                Write-ColoredOutput "   ✅ Chocolatey installed successfully" -Color Green
                return $true
            } catch {
                Write-ColoredOutput "   ❌ Failed to install Chocolatey: $_" -Color Red
                return $false
            }
        }
        'scoop' {
            try {
                Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
                Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
                Write-ColoredOutput "   ✅ Scoop installed successfully" -Color Green
                return $true
            } catch {
                Write-ColoredOutput "   ❌ Failed to install Scoop: $_" -Color Red
                return $false
            }
        }
        'winget' {
            Write-ColoredOutput "   ℹ️  winget comes with Windows 10 1909+. Please update Windows." -Color Yellow
            return $false
        }
    }
    
    return $false
}

function Install-Package {
    param(
        [string]$Package,
        [string]$Manager
    )
    
    Write-ColoredOutput "   Installing $Package via $Manager..." -Color Yellow
    
    try {
        switch ($Manager) {
            'chocolatey' {
                & choco install $Package -y --no-progress 2>&1 | Out-Null
            }
            'scoop' {
                & scoop install $Package 2>&1 | Out-Null
            }
            'winget' {
                & winget install $Package --silent 2>&1 | Out-Null
            }
        }
        
        Write-ColoredOutput "   ✅ $Package installed successfully" -Color Green
        return $true
    } catch {
        Write-ColoredOutput "   ⚠️  $Package installation warning (may already be installed)" -Color Yellow
        return $true
    }
}

function Test-SystemCompatibility {
    Write-ColoredOutput "🧪 Testing System Compatibility..." -Color Blue
    Write-Host ""
    
    $issues = @()
    $warnings = @()
    
    # PowerShell version check
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        $issues += "PowerShell version too old (5.0+ required)"
    } elseif ($PSVersionTable.PSVersion.Major -eq 5) {
        $warnings += "PowerShell 5.x detected. PowerShell 7+ recommended for best experience."
    }
    
    # Windows version check
    $winVersion = [System.Environment]::OSVersion.Version
    if ($winVersion.Major -lt 10) {
        $issues += "Windows version too old (Windows 10+ required)"
    }
    
    # Execution policy check
    $policy = Get-ExecutionPolicy
    if ($policy -eq 'Restricted') {
        $warnings += "PowerShell execution policy is Restricted. Some features may not work."
    }
    
    # Python check
    if (-not (Test-Command 'python')) {
        $issues += "Python not found in PATH"
    } else {
        try {
            $pythonVersion = & python --version 2>&1
            Write-ColoredOutput "   ✅ Python: $pythonVersion" -Color Green
        } catch {
            $warnings += "Python version check failed"
        }
    }
    
    # Git check
    if (-not (Test-Command 'git')) {
        $warnings += "Git not found in PATH"
    } else {
        $gitVersion = & git --version 2>&1
        Write-ColoredOutput "   ✅ Git: $gitVersion" -Color Green
    }
    
    # Package managers
    $packageManagers = Get-AvailablePackageManagers
    if ($packageManagers.Count -eq 0) {
        $warnings += "No package managers detected. Manual installation may be required."
    } else {
        Write-ColoredOutput "   ✅ Package Managers: $($packageManagers -join ', ')" -Color Green
    }
    
    # Terminal capabilities
    try {
        $consoleWidth = $Host.UI.RawUI.WindowSize.Width
        $consoleHeight = $Host.UI.RawUI.WindowSize.Height
        Write-ColoredOutput "   ✅ Terminal Size: ${consoleWidth}x${consoleHeight}" -Color Green
    } catch {
        $warnings += "Terminal size detection failed"
    }
    
    # Display results
    Write-Host ""
    if ($issues.Count -eq 0) {
        Write-ColoredOutput "✅ System Compatibility: PASSED" -Color Green
    } else {
        Write-ColoredOutput "❌ System Compatibility: FAILED" -Color Red
        foreach ($issue in $issues) {
            Write-ColoredOutput "   • $issue" -Color Red
        }
    }
    
    if ($warnings.Count -gt 0) {
        Write-ColoredOutput "⚠️  Warnings:" -Color Yellow
        foreach ($warning in $warnings) {
            Write-ColoredOutput "   • $warning" -Color Yellow
        }
    }
    
    return ($issues.Count -eq 0)
}

function Test-Features {
    Write-ColoredOutput "🔧 Testing ZehraSec Terminal Features..." -Color Blue
    Write-Host ""
    
    $testResults = @{}
    
    # Test Python ZehraSec Terminal
    if (Test-Path "$ScriptDir\zehrasec_terminal.py") {
        try {
            $testOutput = & python "$ScriptDir\test.py" 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-ColoredOutput "   ✅ Python ZehraSec Terminal: Working" -Color Green
                $testResults['PythonTerminal'] = $true
            } else {
                Write-ColoredOutput "   ❌ Python ZehraSec Terminal: Failed" -Color Red
                $testResults['PythonTerminal'] = $false
            }
        } catch {
            Write-ColoredOutput "   ❌ Python ZehraSec Terminal: Error - $_" -Color Red
            $testResults['PythonTerminal'] = $false
        }
    } else {
        Write-ColoredOutput "   ⚠️  Python ZehraSec Terminal: File not found" -Color Yellow
        $testResults['PythonTerminal'] = $false
    }
    
    # Test Bash Terminal (if available)
    if (Test-Path "$ScriptDir\.terminal.sh") {
        if (Test-Command 'bash') {
            Write-ColoredOutput "   ✅ Bash Terminal: Available" -Color Green
            $testResults['BashTerminal'] = $true
        } else {
            Write-ColoredOutput "   ⚠️  Bash Terminal: bash not available" -Color Yellow
            $testResults['BashTerminal'] = $false
        }
    } else {
        Write-ColoredOutput "   ⚠️  Bash Terminal: File not found" -Color Yellow
        $testResults['BashTerminal'] = $false
    }
    
    # Test ASCII Art
    $asciiCount = 0
    if (Test-Path "$ScriptDir\ascii_art") {
        $asciiFiles = Get-ChildItem "$ScriptDir\ascii_art" -Filter "*.txt" -Recurse
        $asciiCount = $asciiFiles.Count
    }
    
    if ($asciiCount -gt 0) {
        Write-ColoredOutput "   ✅ ASCII Art Collection: $asciiCount files" -Color Green
        $testResults['ASCIIArt'] = $true
    } else {
        Write-ColoredOutput "   ⚠️  ASCII Art Collection: No files found" -Color Yellow
        $testResults['ASCIIArt'] = $false
    }
    
    # Test Installation Scripts
    $installerCount = 0
    $installers = @('install.py', 'install-linux.sh', 'install-termux.sh')
    foreach ($installer in $installers) {
        if (Test-Path "$ScriptDir\$installer") {
            $installerCount++
        }
    }
    
    Write-ColoredOutput "   ✅ Installation Scripts: $installerCount/$($installers.Count)" -Color Green
    $testResults['Installers'] = ($installerCount -eq $installers.Count)
    
    # Summary
    $passedTests = ($testResults.Values | Where-Object { $_ -eq $true }).Count
    $totalTests = $testResults.Count
    
    Write-Host ""
    if ($passedTests -eq $totalTests) {
        Write-ColoredOutput "✅ Feature Tests: PASSED ($passedTests/$totalTests)" -Color Green
    } else {
        Write-ColoredOutput "⚠️  Feature Tests: PARTIAL ($passedTests/$totalTests)" -Color Yellow
    }
    
    return ($passedTests -ge ($totalTests * 0.75))
}

function Install-Dependencies {
    Write-ColoredOutput "📦 Installing Dependencies..." -Color Blue
    
    $managers = Get-AvailablePackageManagers
    
    if ($managers.Count -eq 0) {
        Write-ColoredOutput "⚠️  No package managers found. Installing Chocolatey..." -Color Yellow
        if (Install-PackageManager 'chocolatey') {
            $managers += 'chocolatey'
        } else {
            Write-ColoredOutput "❌ Failed to install package manager. Manual installation required." -Color Red
            return $false
        }
    }
    
    $primaryManager = $managers[0]
    Write-ColoredOutput "📦 Using $primaryManager for package installation..." -Color Blue
    
    # Install required packages
    $successCount = 0
    foreach ($package in $RequiredPackages.Keys) {
        $description = $RequiredPackages[$package]
        Write-ColoredOutput "Installing $package ($description)..." -Color Yellow
        
        if (Install-Package $package $primaryManager) {
            $successCount++
        }
    }
    
    # Install optional packages
    foreach ($package in $OptionalPackages.Keys) {
        $description = $OptionalPackages[$package]
        Write-ColoredOutput "Installing $package ($description)..." -Color Yellow
        Install-Package $package $primaryManager | Out-Null
    }
    
    Write-Host ""
    if ($successCount -ge $RequiredPackages.Count) {
        Write-ColoredOutput "✅ Dependencies installed successfully" -Color Green
        return $true
    } else {
        Write-ColoredOutput "❌ Some dependencies failed to install" -Color Red
        return $false
    }
}

function Install-PythonPackages {
    Write-ColoredOutput "🐍 Installing Python packages..." -Color Blue
    
    if (-not (Test-Path "$ScriptDir\requirements.txt")) {
        Write-ColoredOutput "⚠️  requirements.txt not found, creating minimal requirements..." -Color Yellow
        
        $requirements = @(
            "colorama>=0.4.6",
            "pyfiglet>=0.8.post1", 
            "bcrypt>=4.0.1",
            "cryptography>=41.0.0",
            "psutil>=5.9.0",
            "rich>=13.7.0",
            "click>=8.1.7"
        )
        
        $requirements | Out-File "$ScriptDir\requirements.txt" -Encoding UTF8
    }
    
    try {
        Write-ColoredOutput "   Upgrading pip..." -Color Yellow
        & python -m pip install --upgrade pip --quiet
        
        Write-ColoredOutput "   Installing requirements..." -Color Yellow
        & python -m pip install -r "$ScriptDir\requirements.txt" --quiet
        
        Write-ColoredOutput "✅ Python packages installed successfully" -Color Green
        return $true
    } catch {
        Write-ColoredOutput "❌ Python package installation failed: $_" -Color Red
        return $false
    }
}

function Setup-Directories {
    Write-ColoredOutput "📁 Setting up directories..." -Color Blue
    
    $directories = @($InstallDir, $ConfigDir, $BinDir, "$InstallDir\ascii_art")
    
    foreach ($dir in $directories) {
        try {
            if (-not (Test-Path $dir)) {
                New-Item -ItemType Directory -Path $dir -Force | Out-Null
                Write-ColoredOutput "   ✅ Created: $dir" -Color Green
            } else {
                Write-ColoredOutput "   ✅ Exists: $dir" -Color Green
            }
        } catch {
            Write-ColoredOutput "   ❌ Failed to create $dir" -Color Red
            return $false
        }
    }
    
    return $true
}

function Copy-Files {
    Write-ColoredOutput "📄 Copying ZehraSec Terminal files..." -Color Blue
    
    $filesToCopy = @(
        'zehrasec_terminal.py',
        'launch.py', 
        'demo.py',
        'test.py',
        'requirements.txt',
        '.terminal.sh'
    )
    
    foreach ($file in $filesToCopy) {
        $src = Join-Path $ScriptDir $file
        $dst = Join-Path $InstallDir $file
        
        if (Test-Path $src) {
            try {
                Copy-Item $src $dst -Force
                Write-ColoredOutput "   ✅ Copied: $file" -Color Green
            } catch {
                Write-ColoredOutput "   ❌ Failed to copy $file" -Color Red
                return $false
            }
        } else {
            Write-ColoredOutput "   ⚠️  File not found: $file" -Color Yellow
        }
    }
    
    # Copy ASCII art directory
    $srcAscii = Join-Path $ScriptDir "ascii_art"
    $dstAscii = Join-Path $InstallDir "ascii_art"
    
    if (Test-Path $srcAscii) {
        try {
            if (Test-Path $dstAscii) {
                Remove-Item $dstAscii -Recurse -Force
            }
            Copy-Item $srcAscii $dstAscii -Recurse -Force
            Write-ColoredOutput "   ✅ Copied ASCII art collection" -Color Green
        } catch {
            Write-ColoredOutput "   ❌ Failed to copy ASCII art" -Color Red
            return $false
        }
    }
    
    return $true
}

function Create-LauncherScript {
    Write-ColoredOutput "🚀 Creating launcher script..." -Color Blue
    
    $launcherContent = @"
@echo off
cd /d "$InstallDir"
python zehrasec_terminal.py %*
"@
    
    $launcherPath = Join-Path $BinDir "zehrasec.bat"
    
    try {
        $launcherContent | Out-File $launcherPath -Encoding ASCII
        Write-ColoredOutput "   ✅ Created launcher: $launcherPath" -Color Green
        return $true
    } catch {
        Write-ColoredOutput "   ❌ Failed to create launcher" -Color Red
        return $false
    }
}

function Setup-PathIntegration {
    Write-ColoredOutput "🔗 Setting up PATH integration..." -Color Blue
    
    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
        
        if ($currentPath -notlike "*$BinDir*") {
            $newPath = "$currentPath;$BinDir"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
            Write-ColoredOutput "   ✅ Added to PATH: $BinDir" -Color Green
        } else {
            Write-ColoredOutput "   ✅ Already in PATH: $BinDir" -Color Green
        }
        
        # Refresh current session PATH
        $env:PATH = "$env:PATH;$BinDir"
        
        Write-ColoredOutput "   💡 Restart PowerShell or run 'refreshenv' to use 'zehrasec' command" -Color Cyan
        return $true
    } catch {
        Write-ColoredOutput "   ❌ Failed to update PATH" -Color Red
        return $false
    }
}

function Run-InstallationTests {
    Write-ColoredOutput "🧪 Running installation tests..." -Color Blue
    
    if (Test-Path "$InstallDir\test.py") {
        try {
            $testOutput = & python "$InstallDir\test.py" 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-ColoredOutput "✅ Installation tests passed" -Color Green
                return $true
            } else {
                Write-ColoredOutput "⚠️  Some tests failed" -Color Yellow
                Write-ColoredOutput $testOutput -Color Yellow
                return $false
            }
        } catch {
            Write-ColoredOutput "⚠️  Test execution failed: $_" -Color Yellow
            return $false
        }
    } else {
        Write-ColoredOutput "⚠️  Test file not found" -Color Yellow
        return $false
    }
}

function Show-CompletionMessage {
    $completionMsg = @"

╔══════════════════════════════════════════════════════════════════════════════╗
║                    🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉                ║
╚══════════════════════════════════════════════════════════════════════════════╝

🚀 ZehraSec Terminal v2.2.0 is now installed on Windows!

📍 Installation Details:
   • Install Directory: $InstallDir
   • Config Directory:  $ConfigDir  
   • Launcher Script:   $BinDir\zehrasec.bat

🏃 How to Run:
   # Method 1: Direct command (after PATH refresh)
   zehrasec

   # Method 2: Full path
   $BinDir\zehrasec.bat

   # Method 3: Direct Python execution
   cd $InstallDir
   python zehrasec_terminal.py

🔄 PATH Integration:
   # Restart PowerShell or run:
   refreshenv
   
   # Or manually refresh:
   `$env:PATH = [System.Environment]::GetEnvironmentVariable("Path","User")

🎨 First Run:
   1. Set up your secure password
   2. Explore 50+ ASCII art themes with 'changebanner'
   3. Customize your prompt with 'changeprompt'
   4. Type 'help' to see all available commands

🛠️  Useful Commands:
   • help        - Show all commands
   • status      - System and security status
   • demo        - Feature demonstration
   • test        - Run system tests

� Links & Support:
   • GitHub Repository: https://github.com/yashab-cyber/terminal-edits
   • Support Email:     yashabalam707@gmail.com
   • Donations:         See DONATE.md or https://paypal.me/yashab07

�🛡️ Developed by Yashab Alam - Founder & CEO of ZehraSec 🛡️
Thank you for using ZehraSec Terminal!
"@

    Write-ColoredOutput $completionMsg -Color Cyan
}

function Invoke-Installation {
    Show-Header
    
    Write-ColoredOutput "🔧 Starting ZehraSec Terminal Installation..." -Color White
    Write-Host ""
    
    $steps = @(
        @{ Name = "Installing system dependencies"; Action = { Install-Dependencies } },
        @{ Name = "Installing Python packages"; Action = { Install-PythonPackages } },
        @{ Name = "Setting up directories"; Action = { Setup-Directories } },
        @{ Name = "Copying application files"; Action = { Copy-Files } },
        @{ Name = "Creating launcher script"; Action = { Create-LauncherScript } },
        @{ Name = "Setting up PATH integration"; Action = { Setup-PathIntegration } },
        @{ Name = "Running installation tests"; Action = { Run-InstallationTests } }
    )
    
    $completedSteps = 0
    
    foreach ($step in $steps) {
        Write-ColoredOutput "🔧 $($step.Name)..." -Color White
        
        try {
            if (& $step.Action) {
                $completedSteps++
                Write-ColoredOutput "✅ $($step.Name) completed" -Color Green
            } else {
                Write-ColoredOutput "❌ $($step.Name) failed" -Color Red
                if ($completedSteps -lt 4) { # Critical steps
                    Write-ColoredOutput "💀 Installation aborted due to critical failure" -Color Red
                    return $false
                }
            }
        } catch {
            Write-ColoredOutput "❌ $($step.Name) failed with error: $_" -Color Red
            if ($completedSteps -lt 4) { # Critical steps
                Write-ColoredOutput "💀 Installation aborted due to critical failure" -Color Red
                return $false
            }
        }
        
        Write-Host ""
    }
    
    if ($completedSteps -ge 6) {
        Show-CompletionMessage
        return $true
    } else {
        Write-ColoredOutput "⚠️  Installation completed with warnings" -Color Yellow
        Write-ColoredOutput "   Some optional features may not be available" -Color Yellow
        return $true
    }
}

function Show-Help {
    $helpText = @"
ZehraSec Terminal - PowerShell Build Script v2.2.0

USAGE:
    .\build.ps1 [OPTIONS]

OPTIONS:
    -Install                Complete ZehraSec Terminal installation
    -Test                   Run comprehensive system compatibility tests
    -TestFeatures          Test specific ZehraSec Terminal features
    -TestDependencies      Test dependency availability
    -SetupDependencies     Install only system dependencies
    -InstallQuiet          Silent installation without prompts
    
    -Clean                 Clean temporary files and caches
    -CleanAll              Complete cleanup including configurations
    -Backup                Backup current configurations
    
    -Force                 Force installation (skip confirmations)
    -Verbose              Enable detailed output
    -Debug                Enable debug mode
    -Help                 Show this help message
    
    -DetectPackageManagers List available package managers
    -UseChocolatey        Use Chocolatey for package installation
    -UseScoop             Use Scoop for package installation
    -UseWinget            Use winget for package installation

EXAMPLES:
    .\build.ps1 -Install                   # Complete installation
    .\build.ps1 -Test                      # Test system compatibility
    .\build.ps1 -SetupDependencies        # Install dependencies only
    .\build.ps1 -Install -Force            # Force install without prompts
    .\build.ps1 -TestFeatures -Verbose     # Test features with detailed output

REQUIREMENTS:
    • Windows 10+ (Windows 11 recommended)
    • PowerShell 5.1+ (PowerShell 7+ recommended)
    • Python 3.7+ (automatically installed if missing)
    • Git (automatically installed if missing)

PACKAGE MANAGERS:
    The script supports multiple Windows package managers:
    • Chocolatey (recommended)
    • Scoop (portable apps)
    • winget (Windows 10 1909+)

🛡️ Developed by Yashab Alam - Founder & CEO of ZehraSec
"@

    Write-ColoredOutput $helpText -Color Cyan
}

# Main execution logic
if ($Help) {
    Show-Help
    exit 0
}

if ($DetectPackageManagers) {
    Show-Header
    Write-ColoredOutput "🔍 Detecting Package Managers..." -Color Blue
    Write-Host ""
    
    $managers = Get-AvailablePackageManagers
    if ($managers.Count -gt 0) {
        Write-ColoredOutput "✅ Available Package Managers:" -Color Green
        foreach ($manager in $managers) {
            Write-ColoredOutput "   • $manager" -Color Yellow
        }
    } else {
        Write-ColoredOutput "❌ No package managers detected" -Color Red
        Write-ColoredOutput "   Consider installing Chocolatey, Scoop, or winget" -Color Yellow
    }
    exit 0
}

if ($Test) {
    Show-Header
    $compatible = Test-SystemCompatibility
    Write-Host ""
    
    if ($compatible) {
        Write-ColoredOutput "🎉 System is compatible with ZehraSec Terminal!" -Color Green
        exit 0
    } else {
        Write-ColoredOutput "💀 System compatibility issues detected" -Color Red
        exit 1
    }
}

if ($TestFeatures) {
    Show-Header
    $featuresWork = Test-Features
    Write-Host ""
    
    if ($featuresWork) {
        Write-ColoredOutput "🎉 All features are working correctly!" -Color Green
        exit 0
    } else {
        Write-ColoredOutput "⚠️  Some features may not be available" -Color Yellow
        exit 0
    }
}

if ($TestDependencies) {
    Show-Header
    Write-ColoredOutput "🔍 Testing Dependencies..." -Color Blue
    Write-Host ""
    
    foreach ($package in $RequiredPackages.Keys) {
        if (Test-Command $package) {
            Write-ColoredOutput "   ✅ $package: Available" -Color Green
        } else {
            Write-ColoredOutput "   ❌ $package: Not found" -Color Red
        }
    }
    
    Write-Host ""
    foreach ($package in $OptionalPackages.Keys) {
        if (Test-Command $package) {
            Write-ColoredOutput "   ✅ $package: Available (optional)" -Color Green
        } else {
            Write-ColoredOutput "   ⚠️  $package: Not found (optional)" -Color Yellow
        }
    }
    
    exit 0
}

if ($SetupDependencies) {
    Show-Header
    if (Install-Dependencies) {
        Write-ColoredOutput "🎉 Dependencies installed successfully!" -Color Green
        exit 0
    } else {
        Write-ColoredOutput "💀 Dependency installation failed" -Color Red
        exit 1
    }
}

if ($Install -or $InstallQuiet) {
    if (-not $InstallQuiet) {
        Show-Header
        Write-ColoredOutput "⚠️  This will install ZehraSec Terminal on your Windows system." -Color Yellow
        Write-ColoredOutput "   Installation directory: $InstallDir" -Color Cyan
        Write-ColoredOutput "   PATH integration will be added to your user environment" -Color Cyan
        Write-Host ""
        
        if (-not $Force) {
            $confirm = Read-Host "Continue with installation? [Y/n]"
            if ($confirm -and $confirm.ToLower() -ne 'y' -and $confirm.ToLower() -ne 'yes') {
                Write-ColoredOutput "Installation cancelled by user" -Color Yellow
                exit 0
            }
        }
    }
    
    if (Invoke-Installation) {
        exit 0
    } else {
        exit 1
    }
}

if ($Clean) {
    Show-Header
    Write-ColoredOutput "🧹 Cleaning temporary files..." -Color Blue
    
    $tempDirs = @("$env:TEMP\zehrasec*", "$InstallDir\__pycache__", "$InstallDir\*.pyc")
    
    foreach ($pattern in $tempDirs) {
        Get-ChildItem $pattern -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    Write-ColoredOutput "✅ Cleanup completed" -Color Green
    exit 0
}

if ($CleanAll) {
    Show-Header
    Write-ColoredOutput "🧹 Complete cleanup (WARNING: This will remove all configurations)..." -Color Red
    
    if (-not $Force) {
        $confirm = Read-Host "This will remove ALL ZehraSec Terminal files and configurations. Continue? [y/N]"
        if ($confirm.ToLower() -ne 'y' -and $confirm.ToLower() -ne 'yes') {
            Write-ColoredOutput "Cleanup cancelled by user" -Color Yellow
            exit 0
        }
    }
    
    $dirsToRemove = @($InstallDir, $ConfigDir)
    
    foreach ($dir in $dirsToRemove) {
        if (Test-Path $dir) {
            Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
            Write-ColoredOutput "   ✅ Removed: $dir" -Color Green
        }
    }
    
    Write-ColoredOutput "✅ Complete cleanup finished" -Color Green
    exit 0
}

if ($Backup) {
    Show-Header
    Write-ColoredOutput "💾 Creating backup..." -Color Blue
    
    $backupDir = "$env:USERPROFILE\.zehrasec_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    
    if (Test-Path $ConfigDir) {
        Copy-Item $ConfigDir $backupDir -Recurse -Force
        Write-ColoredOutput "✅ Backup created: $backupDir" -Color Green
    } else {
        Write-ColoredOutput "⚠️  No configuration directory found to backup" -Color Yellow
    }
    
    exit 0
}

# Default behavior - show help
Show-Help
