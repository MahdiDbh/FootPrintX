#!/bin/bash

#################################################################
# FootPrintX Uninstallation Script
# Description: Remove FootPrintX from the system
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

echo -e "${BLUE}===================================================${NC}"
echo -e "${BLUE}          FootPrintX Uninstallation Script${NC}"
echo -e "${BLUE}===================================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[ERROR] This script must be run as root (use sudo)${NC}"
    echo "Usage: sudo ./uninstall.sh"
    exit 1
fi

# Check if FootPrintX is installed
if [ ! -d "$INSTALL_DIR" ] && [ ! -f "$BIN_PATH" ]; then
    echo -e "${YELLOW}[INFO] FootPrintX is not installed on this system.${NC}"
    exit 0
fi

echo -e "${YELLOW}[INFO] Uninstalling FootPrintX...${NC}"

# Remove installation directory
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${BLUE}[INFO] Removing installation directory: $INSTALL_DIR${NC}"
    rm -rf "$INSTALL_DIR"
fi

# Remove global command
if [ -f "$BIN_PATH" ] || [ -L "$BIN_PATH" ]; then
    echo -e "${BLUE}[INFO] Removing global command: $BIN_PATH${NC}"
    rm -f "$BIN_PATH"
fi

# Verify uninstallation
if [ ! -d "$INSTALL_DIR" ] && [ ! -f "$BIN_PATH" ]; then
    echo ""
    echo -e "${GREEN}✅ FootPrintX uninstalled successfully!${NC}"
    echo ""
    echo -e "${YELLOW}What was removed:${NC}"
    echo -e "  📁 Installation directory: ${INSTALL_DIR}"
    echo -e "  🔗 Global command: ${BIN_PATH}"
    echo -e "  📝 All associated files and wordlists"
    echo ""
    echo -e "${BLUE}[INFO] User-generated reports in ~/reports/ were preserved${NC}"
    echo ""
else
    echo -e "${RED}[ERROR] Uninstallation failed!${NC}"
    echo "Some files may still exist. Please check manually:"
    echo "  - $INSTALL_DIR"
    echo "  - $BIN_PATH"
    exit 1
fi

echo -e "${GREEN}👋 FootPrintX has been completely removed from your system!${NC}"