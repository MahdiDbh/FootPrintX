#!/bin/bash

#################################################################
# FootPrintX Installation Script
# Description: Install FootPrintX globally on the system
# Author: MahdiDbh
#################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
INSTALL_DIR="/opt/footprintx"
BIN_PATH="/usr/local/bin/footprintx"
CURRENT_DIR="$(pwd)"

echo -e "${BLUE}===================================================${NC}"
echo -e "${BLUE}           FootPrintX Installation Script${NC}"
echo -e "${BLUE}===================================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[ERROR] This script must be run as root (use sudo)${NC}"
    echo "Usage: sudo ./install.sh"
    exit 1
fi

# Check if FootPrintX directory exists
if [ ! -d "$CURRENT_DIR/wordlists" ] || [ ! -f "$CURRENT_DIR/footprintx.sh" ]; then
    echo -e "${RED}[ERROR] Please run this script from the FootPrintX directory${NC}"
    echo "Make sure you have:"
    echo "  - footprintx.sh"
    echo "  - wordlists/ directory"
    exit 1
fi

echo -e "${YELLOW}[INFO] Installing FootPrintX...${NC}"

# Create installation directory
echo -e "${BLUE}[INFO] Creating installation directory: $INSTALL_DIR${NC}"
mkdir -p "$INSTALL_DIR"

# Copy files
echo -e "${BLUE}[INFO] Copying files...${NC}"
cp -r "$CURRENT_DIR"/* "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/footprintx.sh"

# Update the script to use the correct paths
echo -e "${BLUE}[INFO] Updating script paths...${NC}"
sed -i "s|SCRIPT_DIR=\".*\"|SCRIPT_DIR=\"$INSTALL_DIR\"|g" "$INSTALL_DIR/footprintx.sh"

# Create symlink in /usr/local/bin
echo -e "${BLUE}[INFO] Creating global command...${NC}"
ln -sf "$INSTALL_DIR/footprintx.sh" "$BIN_PATH"

# Verify installation
if command -v footprintx >/dev/null 2>&1; then
    echo ""
    echo -e "${GREEN}✅ FootPrintX installed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Installation Details:${NC}"
    echo -e "  📁 Installation directory: ${INSTALL_DIR}"
    echo -e "  🔗 Global command: ${BIN_PATH}"
    echo -e "  📝 Wordlists: ${INSTALL_DIR}/wordlists/"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  footprintx -d example.com"
    echo -e "  footprintx -h"
    echo ""
    echo -e "${YELLOW}Test installation:${NC}"
    echo -e "  footprintx -h"
    echo ""
else
    echo -e "${RED}[ERROR] Installation failed!${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Installation completed successfully!${NC}"