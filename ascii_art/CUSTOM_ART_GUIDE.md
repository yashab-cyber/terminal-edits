# Custom ASCII Art Guide for ZehraSec Terminal

Welcome to the custom ASCII art system! This guide will help you create, manage, and use your own custom banners in ZehraSec Terminal.

## 🎭 Overview

The custom banner system allows you to:
- Create your own ASCII art banners from scratch
- Import ASCII art from external files
- Edit existing custom banners
- Generate ASCII art from text using built-in fonts
- Export your banners for sharing
- Manage all your custom creations

## 📁 File Structure

Custom banners are stored in:
```
ascii_art/custom/
├── example.txt          # Sample custom banner
├── your_banner1.txt     # Your custom banners
├── your_banner2.txt
└── ...
```

## 🛠️ Creating Custom Banners

### Method 1: Interactive Creator (`createbanner`)
```bash
createbanner
```
This opens an interactive menu with multiple creation options:

1. **Manual Text Input**: Type your ASCII art line by line
2. **ASCII Text Generator**: Convert text to ASCII art using built-in fonts
3. **Import from File**: Load ASCII art from an external text file
4. **Copy from Existing**: Duplicate and modify existing banners

### Method 2: Quick Creation (`addbanner <name>`)
```bash
addbanner my_banner
```
Quick method to create a banner with either text-to-ASCII conversion or manual input.

### Method 3: Import from File (`importbanner <file> <name>`)
```bash
importbanner /path/to/ascii_art.txt my_imported_banner
```

## ✏️ Editing Custom Banners

### Edit Existing Banner
```bash
editbanner my_banner
```

Options available:
- Replace all content
- Add lines to the end
- Preview before saving

## 🗂️ Managing Custom Banners

### List All Custom Banners
```bash
listcustom
```
Shows all custom banners with file sizes and creation dates.

### Delete Custom Banner
```bash
deletebanner my_banner
```
Safely removes a custom banner with confirmation.

### Export Custom Banner
```bash
exportbanner my_banner /path/to/export.txt
```
Export your custom banner to share with others.

## 🎨 Using Custom Banners

### Set as Current Banner
1. Use the banner customization menu: `changebanner`
2. Select "Change theme" → "custom" category → choose your banner
3. Or use: `setbanner` and navigate to custom category

### Preview Custom Banner
- In the custom banner management menu: `changebanner` → "Manage custom banners" → "Preview banner"
- Or directly preview in the change banner menu

### Random Banner (includes custom)
```bash
randombanner
```
This will randomly select from ALL categories including your custom banners.

## 🎯 Available ASCII Fonts

When using the ASCII text generator, these fonts are available:
- `slant` - Slanted text (default)
- `big` - Large block letters
- `block` - Solid block letters
- `bubble` - Bubble-style letters
- `digital` - Digital/LCD style
- `lean` - Lean slanted text
- `mini` - Minimalist style
- `script` - Script/cursive style
- `shadow` - Text with shadow effect
- `small` - Compact text

## 📋 Banner Format Guidelines

### File Requirements
- **File extension**: Must be `.txt`
- **Encoding**: UTF-8 recommended
- **Line endings**: Any (Unix/Windows/Mac)

### Content Guidelines
- **Width**: Recommended max 80 characters per line
- **Height**: No strict limit, but 20-30 lines work best
- **Characters**: Any printable ASCII or Unicode characters
- **Colors**: Terminal will apply color schemes automatically

### Example Custom Banner Structure
```
  ███╗   ███╗██╗   ██╗    ██████╗  █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ 
  ████╗ ████║╚██╗ ██╔╝    ██╔══██╗██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗
  ██╔████╔██║ ╚████╔╝     ██████╔╝███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
  ██║╚██╔╝██║  ╚██╔╝      ██╔══██╗██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
  ██║ ╚═╝ ██║   ██║       ██████╔╝██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║
  ╚═╝     ╚═╝   ╚═╝       ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
                                                                               
🎭 MY CUSTOM BANNER 🎭
Created with love for ZehraSec Terminal!
```

## 🚀 Advanced Tips

### 1. Create Theme Sets
Group related banners with consistent naming:
```
my_project_logo.txt
my_project_ascii.txt
my_project_title.txt
```

### 2. Use Unicode Art
Incorporate Unicode box-drawing characters for professional looks:
```
╔══════════════════════════════════════╗
║          MY CUSTOM BANNER            ║
╚══════════════════════════════════════╝
```

### 3. Multi-line Designs
Create banners with multiple sections:
```
[ASCII Art Logo]

[Project Name]

[Tagline or Description]
```

### 4. Backup Your Banners
Regularly export your custom banners:
```bash
exportbanner my_favorite ~/backups/my_favorite.txt
```

## 🔧 Command Reference

| Command | Description | Usage |
|---------|-------------|-------|
| `createbanner` | Interactive banner creator | `createbanner` |
| `addbanner` | Quick banner creation | `addbanner <name>` |
| `editbanner` | Edit existing banner | `editbanner <name>` |
| `deletebanner` | Delete custom banner | `deletebanner <name>` |
| `listcustom` | List all custom banners | `listcustom` |
| `importbanner` | Import from file | `importbanner <file> <name>` |
| `exportbanner` | Export to file | `exportbanner <name> <file>` |
| `changebanner` | Banner customization menu | `changebanner` |

## 💡 Troubleshooting

### Banner Not Displaying
1. Check if file exists: `listcustom`
2. Verify file has `.txt` extension
3. Ensure file is in `ascii_art/custom/` directory

### Special Characters Not Showing
1. Use UTF-8 encoding when saving files
2. Test with basic ASCII characters first
3. Some terminals may not support all Unicode characters

### Banner Too Wide
1. Keep lines under 80 characters
2. Use the preview function to test display
3. Consider creating a mobile-friendly version

## 🎉 Examples and Inspiration

Check out the included `example.txt` to see what's possible. Create banners for:
- Personal branding
- Project logos
- Motivational quotes
- System status indicators
- Seasonal themes
- Team/company branding

---

**Happy Banner Creating!** 🎨✨

*Created for ZehraSec Terminal v2.2.0*
*Developer: Yashab Alam - Founder & CEO of ZehraSec*
- Avoid extended Unicode unless specifically needed
- Test in different terminal sizes
- Ensure readability in monospace fonts

### File Naming Convention
- Use descriptive names: `my_logo.txt`, `company_banner.txt`
- Avoid spaces (use underscores or hyphens)
- Use `.txt` extension
- Keep names under 50 characters

## 🎨 ASCII Art Character Sets

### Box Drawing Characters
```
╔═╗ ╭─╮ ┌─┐ ┏━┓
║ ║ │ │ │ │ ┃ ┃
╚═╝ ╰─╯ └─┘ ┗━┛
```

### Common ASCII Characters
```
! " # $ % & ' ( ) * + , - . /
0 1 2 3 4 5 6 7 8 9 : ; < = > ?
@ A B C D E F G H I J K L M N O
P Q R S T U V W X Y Z [ \ ] ^ _
` a b c d e f g h i j k l m n o
p q r s t u v w x y z { | } ~
```

### Special Symbols
```
☆ ★ ♠ ♣ ♥ ♦ ♪ ♫ ☀ ☂ ☃ ❄ ⚡
⚠ ✓ ✗ ✉ ✈ ✂ ✎ ✏ ⚙ ⚡ ⚑ ⚐
```

## 📁 File Organization

Place your custom ASCII art files in:
```
ascii_art/custom/
├── my_logo.txt
├── company_banner.txt
├── personal_theme.txt
└── special_occasion.txt
```

## 🔧 Testing Your ASCII Art

1. **Terminal Test**: Open your file in different terminals
2. **Size Test**: Resize terminal window to test responsiveness
3. **Font Test**: Try different monospace fonts
4. **Color Test**: Ensure it looks good in light/dark themes

## 🎯 Best Practices

### Do's
- ✅ Keep it simple and readable
- ✅ Test in multiple terminal sizes
- ✅ Use consistent spacing
- ✅ Include meaningful content
- ✅ Document your designs

### Don'ts
- ❌ Don't make it too wide (>80 chars)
- ❌ Don't use too many special characters
- ❌ Don't make it too tall (>25 lines)
- ❌ Don't use offensive content
- ❌ Don't ignore readability

## 🛠️ ZehraSec Terminal Integration

Your custom ASCII art will automatically appear in:
- Banner customization menu (`changebanner`)
- Category browser (`browseart`)
- Preview system (`previewthemes`)
- Random banner selection (`randombanner`)

## 📚 Resources

### ASCII Art Galleries
- ASCII Art Archive (https://www.asciiart.eu/)
- Chris.com ASCII Art Collection
- ASCII Art Dictionary

### Learning Resources
- ASCII Art Tutorial
- Typography in ASCII
- ASCII Art History

---

**🎨 Start creating your unique ASCII art banners today!**
**🛡️ ZehraSec Terminal - Empowering your creativity**
