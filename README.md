# 🎯 FootPrintX

<div align="center">

```
    ______            _       _____       _         _    __
   |  ____|          | |     |  __ \     (_)       | |  / /
   | |__ ___   ___   | |_    | |__) |_ __ _ _ __ __ | |_/ / 
   |  __/ _ \ / _ \  | __|   |  ___/| '__| | '_ \/ _| __/ /  
   | | | (_) | (_) | | |_    | |    | |  | | | | |_| |_/ /   
   |_|  \___/ \___/   \__|   |_|    |_|  |_|_| |\__|___/    
                                             _/ |           
                                            |__/            
```

**Automated Passive Reconnaissance Tool**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Language-Bash-green.svg)](https://www.gnu.org/bash/)
[![Version](https://img.shields.io/badge/Version-1.0-blue.svg)](https://github.com/MahdiDbh/FootPrintX)

*Gather comprehensive information about your target domain without active scanning*

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Installation](#-installation)
- [Usage](#-usage)
- [Dependencies](#-dependencies)
- [Report Output](#-report-output)
- [Examples](#-examples)
- [Uninstallation](#-uninstallation)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**FootPrintX** is a powerful passive reconnaissance tool designed for security researchers, penetration testers, and IT professionals. It performs comprehensive information gathering on target domains using publicly available data sources without generating suspicious network traffic.

### Why FootPrintX?

- 🔇 **100% Passive** - No active scanning or intrusive probes
- 📊 **Comprehensive Reports** - Markdown formatted reports with all findings
- 🎯 **Targeted Enumeration** - DNS, WHOIS, SSL certificates, subdomains, and more
- 🚀 **Easy to Use** - Simple command-line interface
- 🔍 **Detailed Logging** - Track all operations with verbose mode

---

## ✨ Features

### Information Gathering Modules

| Module | Description | Professional Level |
|--------|-------------|-------------------|
| 🔍 **WHOIS Lookup** | Domain registration details, registrar, dates, and nameservers | Basic |
| 🌐 **DNS Enumeration** | A, AAAA, MX, NS, TXT, CNAME, and SOA records | Basic |
| 🔓 **DNS Zone Transfer** | Test for AXFR vulnerability on nameservers | ⭐ Advanced |
| 🔎 **Subdomain Discovery** | Dictionary-based subdomain enumeration with IP resolution | Basic |
| 🌐 **Advanced Subdomain Enum** | Certificate Transparency logs and comprehensive brute-force | ⭐⭐ Advanced |
| 🔒 **SSL Certificate Analysis** | Certificate transparency logs via crt.sh | Basic |
| 📧 **Email Harvesting** | Discover email addresses from public sources | ⭐ Advanced |
| 🔗 **Web Search** | Passive URL discovery through search engines | Basic |
| ⚙️ **Technology Detection** | Server identification and technology stack analysis | Basic |
| 🛡️ **Security Headers Analysis** | Comprehensive security posture assessment (HSTS, CSP, etc.) | ⭐⭐ Advanced |
| 🔌 **Port Detection** | Common ports detection (HTTP, HTTPS, SSH, FTP, etc.) | ⭐ Advanced |
| ☁️ **Cloud Infrastructure** | Identify cloud providers (AWS, Azure, GCP, Cloudflare, etc.) | ⭐⭐ Advanced |
| 📝 **Automated Reporting** | Markdown reports with complete findings and timestamps | Basic |

### Professional Security Features

#### 🔓 DNS Security Testing
- **AXFR Zone Transfer Detection**: Automatically tests all nameservers for misconfigured zone transfers
- **Vulnerability Assessment**: Identifies insecure DNS configurations
- **Security Recommendations**: Provides actionable insights

#### 🛡️ Security Headers Audit
Comprehensive analysis of HTTP security headers:
- `Strict-Transport-Security` (HSTS)
- `Content-Security-Policy` (CSP)
- `X-Frame-Options` (Clickjacking protection)
- `X-Content-Type-Options`
- `X-XSS-Protection`
- `Referrer-Policy`
- `Permissions-Policy`

#### 📧 OSINT Email Intelligence
- Passive email harvesting from public sources
- Common email pattern generation
- DNS TXT record mining
- Search engine discovery

#### ☁️ Cloud Infrastructure Intelligence
- **Provider Detection**: AWS, Azure, Google Cloud, DigitalOcean, Cloudflare
- **IP Geolocation**: Identify hosting regions
- **CDN Detection**: Cloudflare, Akamai, AWS CloudFront
- **Reverse IP Analysis**: WHOIS-based provider identification

#### 🌐 Advanced Subdomain Enumeration
- **Certificate Transparency**: Query crt.sh for historical subdomains
- **Active Status Checking**: Verify if discovered subdomains are live
- **Comprehensive Wordlist**: Extended common subdomain patterns
- **IP Resolution**: Map all subdomains to their IP addresses

### Key Capabilities

- ✅ Automatic dependency checking
- ✅ Custom wordlist support
- ✅ Configurable output directory
- ✅ Verbose logging mode
- ✅ Color-coded terminal output
- ✅ Timestamped reports
- ✅ Professional-grade reconnaissance
- ✅ Vulnerability detection
- ✅ Security posture assessment

---

## 🚀 Installation

### Prerequisites

- Linux-based operating system (Kali Linux, Ubuntu, Debian, etc.)
- Root/sudo access for installation
- Internet connection

### Quick Install

```bash
# Clone the repository
git clone https://github.com/MahdiDbh/FootPrintX.git
cd FootPrintX

# Make scripts executable
chmod +x install.sh footprintx.sh

# Install globally (requires sudo)
sudo ./install.sh
```

The installation script will:
1. Copy files to `/opt/footprintx/`
2. Create a global command symlink in `/usr/local/bin/footprintx`
3. Set up proper permissions
4. Make the tool available system-wide

### Verify Installation

After installation, verify that FootPrintX is properly installed:

```bash
# Check if the command is available
which footprintx

# Should output: /usr/local/bin/footprintx

# Test the installation
footprintx -h

# Check installation directory
ls -la /opt/footprintx/
```

### Manual Installation

If you prefer not to install globally, you can run the tool directly:

```bash
chmod +x footprintx.sh
./footprintx.sh -d example.com
```

---

## 📦 Dependencies

FootPrintX requires the following tools to function properly. The tool will automatically check for missing dependencies on startup.

### Required Dependencies

#### 1. **dnsutils** (dig, host, nslookup)
DNS lookup utilities for domain enumeration.

```bash
# Ubuntu/Debian/Kali Linux
sudo apt-get update
sudo apt-get install dnsutils

# Red Hat/CentOS/Fedora
sudo yum install bind-utils

# Arch Linux
sudo pacman -S bind-tools

# macOS (using Homebrew)
brew install bind
```

#### 2. **whois**
WHOIS client for domain registration information.

```bash
# Ubuntu/Debian/Kali Linux
sudo apt-get update
sudo apt-get install whois

# Red Hat/CentOS/Fedora
sudo yum install whois

# Arch Linux
sudo pacman -S whois

# macOS (usually pre-installed, or use Homebrew)
brew install whois
```

#### 3. **curl**
Command-line tool for transferring data with URLs.

```bash
# Ubuntu/Debian/Kali Linux
sudo apt-get update
sudo apt-get install curl

# Red Hat/CentOS/Fedora
sudo yum install curl

# Arch Linux
sudo pacman -S curl

# macOS (usually pre-installed, or use Homebrew)
brew install curl
```

### Optional Dependencies

#### 4. **whatweb** (Recommended)
Web scanner for technology detection and fingerprinting.

```bash
# Ubuntu/Debian/Kali Linux
sudo apt-get update
sudo apt-get install whatweb

# Alternative: Install from source
git clone https://github.com/urbanadventurer/WhatWeb.git
cd WhatWeb
sudo make install

# Kali Linux (usually pre-installed)
# If not installed:
sudo apt-get install whatweb
```

### Quick Install (All Dependencies)

```bash
# For Ubuntu/Debian/Kali Linux (Recommended)
sudo apt-get update && sudo apt-get install -y dnsutils whois curl whatweb

# For Red Hat/CentOS/Fedora
sudo yum install -y bind-utils whois curl

# For Arch Linux
sudo pacman -Sy bind-tools whois curl
```

### Verify Installation

Check if all dependencies are installed:

```bash
# Check required tools
dig -v
whois --version
curl --version

# Check optional tools
whatweb --version
```

**Note**: FootPrintX will automatically detect missing dependencies and provide specific installation instructions when you run it.

---

## 🎯 Usage

### Basic Usage

```bash
footprintx -d <domain>
```

### Command-Line Options

```
Required:
  -d <domain>     Target domain to analyze

Optional:
  -o <directory>  Output directory (default: reports/)
  -w <wordlist>   Custom wordlist for subdomain enumeration
  -v              Enable verbose mode for detailed logging
  -h              Display help message
```

### Examples

#### Basic Scan
```bash
footprintx -d example.com
```

#### Custom Output Directory
```bash
footprintx -d example.com -o /tmp/my-reports
```

#### Verbose Mode
```bash
footprintx -d example.com -v
```

#### Custom Wordlist
```bash
footprintx -d example.com -w /path/to/custom-wordlist.txt
```

#### Combined Options
```bash
footprintx -d example.com -o /tmp/reports -w custom-subdomains.txt -v
```

---

## 📊 Report Output

FootPrintX generates comprehensive Markdown reports in the specified output directory.

### Report Structure

```
reports/
└── example.com_20251215_143022.md
```

### Report Contents

Each report includes:

1. **Report Header**
   - Generation date and time
   - Tool version
   - Target domain

2. **WHOIS Information**
   - Domain registrar
   - Registration and expiry dates
   - Nameservers
   - Complete WHOIS data

3. **DNS Enumeration**
   - All DNS record types (A, AAAA, MX, NS, TXT, CNAME, SOA)
   - Discovered subdomains with IP addresses

4. **DNS Zone Transfer Test** ⭐
   - AXFR vulnerability testing on all nameservers
   - Security assessment of DNS configuration
   - Detailed zone transfer results if vulnerable

5. **Advanced Subdomain Enumeration** ⭐⭐
   - Certificate Transparency logs
   - Active/inactive subdomain status
   - Extended brute-force results

6. **Email Harvesting** ⭐
   - Discovered email addresses
   - Common email patterns
   - Source attribution

7. **SSL Analysis**
   - Domains found in SSL certificates
   - Certificate transparency logs

8. **Passive Web Search**
   - URLs discovered via search engines

9. **Technology Detection**
   - Web server information
   - HTTP headers analysis
   - Technology stack identification

10. **Security Headers Analysis** ⭐⭐
    - Complete security headers audit
    - Vulnerability assessment
    - Missing security controls
    - Clickjacking and XSS protection status

11. **Port Detection** ⭐
    - Common ports scan (80, 443, 22, 21, etc.)
    - Service identification
    - Open/closed status

12. **Cloud Infrastructure Detection** ⭐⭐
    - Cloud provider identification
    - CDN detection
    - IP geolocation
    - Hosting provider details

### Sample Report Snippet

```markdown
# 🎯 Passive Reconnaissance Report - example.com

**Generation Date:** 2025-12-15 14:30:22
**Tool:** FootPrintX v1.0
**Target Domain:** example.com

---

## 🔍 WHOIS Information

| Information | Value |
|-------------|-------|
| Domain | example.com |
| Registrar | Example Registrar Inc. |
| Creation Date | 1995-08-14 |
| Expiry Date | 2026-08-13 |

### Name Servers
```
ns1.example.com
ns2.example.com
```

---

## 🔓 DNS Zone Transfer Test

✅ **ns1.example.com** - Zone transfer denied (secure)
✅ **ns2.example.com** - Zone transfer denied (secure)

**Result:** All nameservers properly configured against zone transfer attacks.

---

## 🛡️ Security Headers Analysis

| Header | Status | Value |
|--------|--------|-------|
| Strict-Transport-Security | ✅ Present | `max-age=31536000` |
| Content-Security-Policy | ❌ Missing | - |
| X-Frame-Options | ✅ Present | `DENY` |
| X-Content-Type-Options | ✅ Present | `nosniff` |

### 🔍 Security Assessment
- ⚠️ **No CSP detected** - Potential XSS vulnerability

---

## ☁️ Cloud Infrastructure Detection

| IP Address | Cloud Provider | Region |
|------------|----------------|--------|
| 93.184.216.34 | AWS (Amazon) | Amazon Data Services |

**CDN Detected:** Cloudflare
```
```

---

## 🔧 Advanced Configuration

### Custom Wordlist

Create your own subdomain wordlist:

```bash
# Create a custom wordlist
cat > my-subdomains.txt << EOF
www
mail
ftp
admin
test
dev
staging
api
blog
portal
EOF

# Use it with FootPrintX
footprintx -d example.com -w my-subdomains.txt
```

### Default Wordlist

The tool includes a default wordlist located at:
```
/opt/footprintx/wordlists/subdomains.txt
```

---

## 🗑️ Uninstallation

To remove FootPrintX from your system:

```bash
cd FootPrintX
sudo ./uninstall.sh
```

This will:
- Remove all files from `/opt/footprintx/`
- Remove the global command from `/usr/local/bin/footprintx`
- Clean up all installation artifacts

---

## 🛡️ Legal Disclaimer

⚠️ **IMPORTANT**: This tool is for educational and authorized testing purposes only.

- Always obtain proper authorization before scanning any domain
- Unauthorized reconnaissance may be illegal in your jurisdiction
- The authors are not responsible for misuse or damage caused by this tool
- Use responsibly and ethically

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Areas for Improvement

- Additional reconnaissance modules (Shodan integration, VirusTotal API)
- Enhanced reporting formats (HTML, JSON, PDF, XML)
- Integration with other OSINT tools (theHarvester, Maltego)
- Performance optimizations and parallel processing
- Additional subdomain enumeration techniques (DNS brute-force, permutations)
- WAF detection and bypass techniques
- GraphQL endpoint discovery
- API endpoint enumeration
- Directory brute-forcing integration
- Social media OSINT
- Dark web monitoring
- Real-time threat intelligence feeds

---

## 📝 Changelog

### Version 1.0 (Current)
- Initial release
- WHOIS lookup functionality
- DNS enumeration (A, AAAA, MX, NS, TXT, CNAME, SOA records)
- Subdomain discovery with wordlist support
- **Advanced Features:**
  - 🔓 DNS Zone Transfer (AXFR) vulnerability testing
  - 📧 Email harvesting from public sources
  - 🛡️ Security headers analysis (HSTS, CSP, X-Frame-Options, etc.)
  - 🔌 Common port detection and service identification
  - ☁️ Cloud infrastructure detection (AWS, Azure, GCP, Cloudflare)
  - 🌐 Advanced subdomain enumeration via Certificate Transparency
  - ⚙️ Enhanced technology stack detection
- SSL certificate analysis via crt.sh
- Web search integration
- Markdown report generation with timestamps
- Verbose logging and color-coded output
- Professional-grade security assessment

---

## 🙏 Acknowledgments

- Inspired by various OSINT and reconnaissance tools in the security community
- Thanks to all contributors and testers

---

## 📧 Contact

- **Author**: MahdiDbh
- **GitHub**: [@MahdiDbh](https://github.com/MahdiDbh)
- **Repository**: [FootPrintX](https://github.com/MahdiDbh/FootPrintX)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ for the security community**

⭐ If you find this tool useful, please consider giving it a star!

</div>
