#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
DOMAIN=""
OUTPUT_DIR="reports"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORDLIST="${SCRIPT_DIR}/wordlists/subdomains.txt"
REPORT_FILE=""
VERBOSE=false
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
print_banner() {
    echo -e "${PURPLE}"
    cat << "EOF"
    ______            _       _____       _         _    __
   |  ____|          | |     |  __ \     (_)       | |  / /
   | |__ ___   ___   | |_    | |__) |_ __ _ _ __ __ | |_/ / 
   |  __/ _ \ / _ \  | __|   |  ___/| '__| | '_ \/ _| __/ /  
   | | | (_) | (_) | | |_    | |    | |  | | | | |_| |_/ /   
   |_|  \___/ \___/   \__|   |_|    |_|  |_|_| |\__|___/    
                                             _/ |           
                                            |__/            
                    Passive Reconnaissance Tool
EOF
    echo -e "${NC}"
    echo -e "${CYAN}[*] Version: 1.0${NC}"
    echo -e "${CYAN}[*] Description: Automated passive reconnaissance tool${NC}"
    echo ""
}


show_help() {
    print_banner
    echo -e "${YELLOW}Usage: footprintx -d <domain> [options]${NC}"
    echo ""
    echo -e "${GREEN}Required options:${NC}"
    echo "  -d <domain>     Target domain to analyze"
    echo ""
    echo -e "${GREEN}Optional parameters:${NC}"
    echo "  -o <directory>  Output directory (default: reports/)"
    echo "  -w <wordlist>   Wordlist for subdomain enumeration"
    echo "  -v              Verbose mode"
    echo "  -h              Show this help"
    echo ""
    echo -e "${GREEN}Examples:${NC}"
    echo "  footprintx -d example.com"
    echo "  footprintx -d example.com -o /tmp/reports -v"
    echo "  footprintx -d example.com -w custom_wordlist.txt"
    echo ""
}


log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "INFO")
            echo -e "${GREEN}[INFO]${NC} ${message}"
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} ${message}"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} ${message}"
            ;;
        "DEBUG")
            if [ "$VERBOSE" = true ]; then
                echo -e "${BLUE}[DEBUG]${NC} ${message}"
            fi
            ;;
    esac

    if [ ! -z "$REPORT_FILE" ]; then
        echo "[$timestamp] [$level] $message" >> "${OUTPUT_DIR}/footprintx.log"
    fi
}

check_dependencies() {
    log "INFO" "Checking dependencies..."
    local deps=("dig" "whois" "curl" "host" "nslookup")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        log "ERROR" "Missing dependencies: ${missing[*]}"
        log "INFO" "Suggested installation (Ubuntu/Debian): sudo apt-get install dnsutils whois curl"
        exit 1
    fi

    if ! command -v "whatweb" &> /dev/null; then
        log "WARN" "whatweb not found - technology detection will be disabled"
        log "INFO" "Installation: sudo apt-get install whatweb"
    fi
    
    log "INFO" "All dependencies are satisfied"
}


whois_lookup() {
    log "INFO" "Executing WHOIS lookup for $DOMAIN..."
    
    cat >> "$REPORT_FILE" << EOF

## 🔍 WHOIS Information

EOF
    
    local whois_output
    whois_output=$(whois "$DOMAIN" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ ! -z "$whois_output" ]; then
        local registrar=$(echo "$whois_output" | grep -i "registrar:" | head -1 | cut -d: -f2 | sed 's/^ *//')
        local creation_date=$(echo "$whois_output" | grep -i -E "(creat|regist)" | grep -i "date" | head -1 | cut -d: -f2 | sed 's/^ *//')
        local expiry_date=$(echo "$whois_output" | grep -i -E "(expir|expires)" | head -1 | cut -d: -f2 | sed 's/^ *//')
        local name_servers=$(echo "$whois_output" | grep -i "name server" | cut -d: -f2 | sed 's/^ *//' | sort -u)
        
        cat >> "$REPORT_FILE" << EOF
| Information | Value |
|-------------|-------|
| Domain | $DOMAIN |
| Registrar | ${registrar:-"N/A"} |
| Creation Date | ${creation_date:-"N/A"} |
| Expiry Date | ${expiry_date:-"N/A"} |

### Name Servers
\`\`\`
${name_servers:-"None found"}
\`\`\`

### Complete WHOIS
<details>
<summary>Click to view complete WHOIS</summary>

\`\`\`
$whois_output
\`\`\`
</details>

EOF
        log "INFO" "WHOIS information retrieved successfully"
    else
        cat >> "$REPORT_FILE" << EOF
❌ **Error:** Unable to retrieve WHOIS information for $DOMAIN

EOF
        log "ERROR" "WHOIS retrieval failed"
    fi
}


dns_enumeration() {
    log "INFO" "DNS enumeration in progress for $DOMAIN..."
    
    cat >> "$REPORT_FILE" << EOF

## 🌐 DNS Enumeration

EOF

    local record_types=("A" "AAAA" "MX" "NS" "TXT" "CNAME" "SOA")
    
    for record_type in "${record_types[@]}"; do
        log "DEBUG" "Retrieving $record_type records"
        local dns_result
        dns_result=$(dig +short "$DOMAIN" "$record_type" 2>/dev/null)
        
        if [ ! -z "$dns_result" ]; then
            cat >> "$REPORT_FILE" << EOF

### $record_type Records
\`\`\`
$dns_result
\`\`\`
EOF
        fi
    done
    
    subdomain_enumeration
    subdomain_enumeration
}

subdomain_enumeration() {
    log "INFO" "Subdomain enumeration..."
    
    cat >> "$REPORT_FILE" << EOF

### 🔍 Discovered Subdomains

EOF
    
    local found_subdomains=()
    
    if [ -f "$WORDLIST" ]; then
        log "DEBUG" "Using wordlist: $WORDLIST"
        
        while IFS= read -r subdomain; do
            [[ -z "$subdomain" || "$subdomain" =~ ^#.*$ ]] && continue
            
            local full_subdomain="${subdomain}.${DOMAIN}"
            if host "$full_subdomain" >/dev/null 2>&1; then
                local ip=$(dig +short "$full_subdomain" A 2>/dev/null | head -1)
                found_subdomains+=("$full_subdomain ($ip)")
                log "DEBUG" "Subdomain found: $full_subdomain -> $ip"
            fi
        done < "$WORDLIST"
    else
        log "WARN" "Wordlist not found: $WORDLIST"
    fi
    local common_subs=("www" "mail" "ftp" "admin" "test" "dev" "staging" "api" "blog")
    for sub in "${common_subs[@]}"; do
        local full_sub="${sub}.${DOMAIN}"
        if host "$full_sub" >/dev/null 2>&1; then
            local ip=$(dig +short "$full_sub" A 2>/dev/null | head -1)
            found_subdomains+=("$full_sub ($ip)")
        fi
    done
    
    if [ ${#found_subdomains[@]} -gt 0 ]; then
        cat >> "$REPORT_FILE" << EOF
| Subdomain | IP |
|-----------|-----|
EOF
        for subdomain in "${found_subdomains[@]}"; do
            local sub=$(echo "$subdomain" | cut -d'(' -f1 | xargs)
            local ip=$(echo "$subdomain" | grep -o '([^)]*)' | tr -d '()')
            echo "| $sub | $ip |" >> "$REPORT_FILE"
        done
        
        log "INFO" "Found ${#found_subdomains[@]} subdomain(s)"
    else
        echo "❌ **No subdomains found**" >> "$REPORT_FILE"
        log "INFO" "No subdomains discovered"
    fi
    
    cat >> "$REPORT_FILE" << EOF

EOF
}


web_search() {
    log "INFO" "Passive web search for $DOMAIN..."
    
    cat >> "$REPORT_FILE" << EOF

## 🔎 Passive Web Search

EOF

    local google_results
    google_results=$(curl -s -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
        "https://www.google.com/search?q=site:${DOMAIN}" 2>/dev/null | \
        grep -oP '(?<=href="/url\?q=)[^&]*' | \
        grep -E "^https?://" | \
        head -10 | \
        sort -u)
    
    if [ ! -z "$google_results" ]; then
        cat >> "$REPORT_FILE" << EOF
### 🔗 URLs discovered via Google
\`\`\`
$google_results
\`\`\`

EOF
        log "INFO" "URLs discovered via Google search"
    else
        cat >> "$REPORT_FILE" << EOF
❌ **No URLs found via Google search**

EOF
        log "WARN" "No URLs found via web search"
    fi
}


ssl_analysis() {
    log "INFO" "SSL analysis via crt.sh for $DOMAIN..."
    
    cat >> "$REPORT_FILE" << EOF

## 🔒 SSL Analysis (crt.sh)

EOF
    
    local ssl_domains
    ssl_domains=$(curl -s "https://crt.sh/?q=%25.${DOMAIN}&output=json" 2>/dev/null | \
        grep -Po '"name_value":"[^"]*"' | \
        cut -d'"' -f4 | \
        sort -u | \
        head -20)
    
    if [ ! -z "$ssl_domains" ]; then
        cat >> "$REPORT_FILE" << EOF
### 📋 Domains found in SSL certificates
\`\`\`
$ssl_domains
\`\`\`

EOF
        log "INFO" "SSL domains retrieved from crt.sh"
    else
        cat >> "$REPORT_FILE" << EOF
❌ **No SSL certificates found**

EOF
        log "WARN" "No SSL certificates found on crt.sh"
    fi
}


tech_detection() {
    log "INFO" "Technology detection for $DOMAIN..."
    
    cat >> "$REPORT_FILE" << EOF

## ⚙️ Technologies Detected

EOF

    if command -v whatweb >/dev/null 2>&1; then
        local whatweb_output
        whatweb_output=$(whatweb --quiet --no-errors "$DOMAIN" 2>/dev/null)
        
        if [ ! -z "$whatweb_output" ]; then
            cat >> "$REPORT_FILE" << EOF
### WhatWeb Analysis
\`\`\`
$whatweb_output
\`\`\`

EOF
        fi
    fi
    local headers
    headers=$(curl -s -I "http://$DOMAIN" 2>/dev/null)
    
    if [ ! -z "$headers" ]; then
        local server=$(echo "$headers" | grep -i "server:" | cut -d: -f2 | sed 's/^ *//')
        local powered_by=$(echo "$headers" | grep -i "x-powered-by:" | cut -d: -f2 | sed 's/^ *//')
        
        cat >> "$REPORT_FILE" << EOF
### 🌐 HTTP Headers
| Header | Value |
|--------|-------|
EOF
        
        [ ! -z "$server" ] && echo "| Server | $server |" >> "$REPORT_FILE"
        [ ! -z "$powered_by" ] && echo "| X-Powered-By | $powered_by |" >> "$REPORT_FILE"
        
        cat >> "$REPORT_FILE" << EOF

### Complete Headers
<details>
<summary>Click to view all headers</summary>

\`\`\`
$headers
\`\`\`
</details>

EOF
        log "INFO" "Technology analysis completed"
    else
        cat >> "$REPORT_FILE" << EOF
❌ **Unable to retrieve technical information**

EOF
        log "WARN" "Unable to retrieve HTTP headers"
    fi
}

init_report() {
    REPORT_FILE="${OUTPUT_DIR}/${DOMAIN}_${TIMESTAMP}.md"
    mkdir -p "$OUTPUT_DIR"
    
    cat > "$REPORT_FILE" << EOF
# 🎯 Passive Reconnaissance Report - $DOMAIN

**Generation Date:** $(date '+%Y-%m-%d %H:%M:%S')  
**Tool:** FootPrintX v1.0  
**Target Domain:** $DOMAIN  

---

EOF
    
    log "INFO" "Report initialized: $REPORT_FILE"
}


finalize_report() {
    cat >> "$REPORT_FILE" << EOF

---

## 📊 Summary

**Report generated by FootPrintX** - $(date '+%Y-%m-%d %H:%M:%S')

### 🛠️ Tools used
- WHOIS lookup
- DNS enumeration (dig, host, nslookup)
- Passive web search
- SSL analysis (crt.sh)
- Technology detection (whatweb, curl)

### ⚠️ Disclaimer
This report was generated for passive reconnaissance purposes only. 
All information comes from publicly available sources.

---
*Made with ❤️ by MahdiDbh*
EOF
    
    log "INFO" "Report finalized: $REPORT_FILE"
    if command -v pandoc >/dev/null 2>&1; then
        local html_file="${OUTPUT_DIR}/${DOMAIN}_${TIMESTAMP}.html"
        pandoc "$REPORT_FILE" -o "$html_file" 2>/dev/null && \
        log "INFO" "HTML report generated: $html_file"
    fi
}


main() {
    print_banner
    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi
    while getopts "d:o:w:vh" opt; do
        case $opt in
            d)
                DOMAIN="$OPTARG"
                ;;
            o)
                OUTPUT_DIR="$OPTARG"
                ;;
            w)
                WORDLIST="$OPTARG"
                ;;
            v)
                VERBOSE=true
                ;;
            h)
                show_help
                exit 0
                ;;
            \?)
                log "ERROR" "Invalid option: -$OPTARG"
                show_help
                exit 1
                ;;
        esac
    done
    if [ -z "$DOMAIN" ]; then
        log "ERROR" "Domain is required. Use -d <domain>"
        show_help
        exit 1
    fi
    if ! echo "$DOMAIN" | grep -qE '^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.[a-zA-Z]{2,}$'; then
        log "ERROR" "Invalid domain format: $DOMAIN"
        exit 1
    fi
    
    log "INFO" "Starting passive reconnaissance for: $DOMAIN"
    log "INFO" "Output directory: $OUTPUT_DIR"
    check_dependencies
    init_report
    log "INFO" "=== RECONNAISSANCE STARTED ==="
    
    whois_lookup
    dns_enumeration
    web_search
    ssl_analysis
    tech_detection
    finalize_report
    
    log "INFO" "=== RECONNAISSANCE COMPLETED ==="
    echo ""
    echo -e "${GREEN}✅ Reconnaissance completed successfully!${NC}"
    echo -e "${CYAN}📄 Report generated: ${REPORT_FILE}${NC}"
    echo -e "${CYAN}📁 Directory: ${OUTPUT_DIR}/${NC}"
    echo ""
}

trap 'echo -e "\n${RED}[!] Interruption detected. Cleaning up...${NC}"; exit 1' INT TERM
main "$@"