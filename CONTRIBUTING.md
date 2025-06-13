# Contributing to ZehraSec Terminal

Thank you for your interest in contributing to ZehraSec Terminal! This document provides guidelines for contributing to this project.

## 🤝 How to Contribute

### 1. Fork the Repository
- Fork the project on GitHub
- Clone your fork locally
- Create a new branch for your feature/fix

### 2. Development Setup
```bash
git clone https://github.com/YOUR_USERNAME/terminal-edits.git
cd terminal-edits
./install.sh --check-deps  # Check dependencies
```

### 3. Making Changes
- Write clear, commented code
- Follow the existing code style
- Test your changes thoroughly
- Update documentation if needed

### 4. Testing
```bash
# Test core functionality
./.terminal.sh

# Test specific features
./test.sh  # If available

# Test on different platforms if possible
```

### 5. Submitting Changes
- Commit with clear, descriptive messages
- Push your branch to your fork
- Create a Pull Request with detailed description

## 📝 Coding Standards

### Bash Script Guidelines
- Use `#!/bin/bash` shebang
- Include function documentation
- Use proper error handling
- Follow consistent indentation (4 spaces)
- Use meaningful variable names

### Security Considerations
- Validate all user inputs
- Use secure file permissions (700 for directories, 600 for files)
- Avoid command injection vulnerabilities
- Log security-relevant events

## 🎨 ASCII Art Contributions

### Guidelines for ASCII Art
- Use only ASCII characters
- Test readability in various terminal sizes
- Include appropriate themes/categories
- Ensure no offensive content
- Maximum width: 80 characters recommended

### File Structure
```
ascii_art/
├── category_name/
│   ├── artwork1.txt
│   ├── artwork2.txt
│   └── ...
```

## 🐛 Bug Reports

When reporting bugs, please include:
- Operating system and version
- Terminal emulator used
- Steps to reproduce the issue
- Expected vs actual behavior
- Error messages (if any)

## 💡 Feature Requests

For new features:
- Describe the feature clearly
- Explain the use case
- Consider security implications
- Suggest implementation approach

## 📚 Documentation

- Update README.md for new features
- Add comments to complex code sections
- Update help system for new commands
- Include examples where appropriate

## 🛡️ Security

- Report security issues privately to the maintainers
- Do not include sensitive information in public issues
- Follow responsible disclosure practices

## 👥 Community Guidelines

- Be respectful and professional
- Help others learn and grow
- Focus on constructive feedback
- Welcome newcomers

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🏆 Recognition

Contributors will be acknowledged in:
- README.md
- CHANGELOG.md
- Release notes

## 📞 Contact

- **GitHub Issues**: For bugs and feature requests
- **Discussions**: For general questions and ideas
- **Email**: For security issues (contact maintainers)

---

**🛡️ Thank you for helping make ZehraSec Terminal better!**

**Developed by Yashab Alam - Founder & CEO of ZehraSec**
