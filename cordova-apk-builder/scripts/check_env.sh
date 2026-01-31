#!/bin/bash
# Environment check script for Cordova Android builds

set -e

echo "🔍 Checking Cordova build environment..."
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Check Cordova CLI
echo -n "Checking Cordova CLI... "
if command -v cordova &> /dev/null; then
    VERSION=$(cordova --version)
    echo -e "${GREEN}✓${NC} Found (v$VERSION)"
else
    echo -e "${RED}✗${NC} Not found"
    echo "  Install: npm install -g cordova"
    ERRORS=$((ERRORS + 1))
fi

# Check Node.js
echo -n "Checking Node.js... "
if command -v node &> /dev/null; then
    VERSION=$(node --version)
    echo -e "${GREEN}✓${NC} Found ($VERSION)"
else
    echo -e "${RED}✗${NC} Not found"
    ERRORS=$((ERRORS + 1))
fi

# Check npm
echo -n "Checking npm... "
if command -v npm &> /dev/null; then
    VERSION=$(npm --version)
    echo -e "${GREEN}✓${NC} Found (v$VERSION)"
else
    echo -e "${RED}✗${NC} Not found"
    ERRORS=$((ERRORS + 1))
fi

# Check Java
echo -n "Checking Java... "
if command -v java &> /dev/null; then
    VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    echo -e "${GREEN}✓${NC} Found ($VERSION)"
else
    echo -e "${RED}✗${NC} Not found"
    echo "  Install: sudo apt-get install openjdk-11-jdk"
    ERRORS=$((ERRORS + 1))
fi

# Check ANDROID_HOME
echo -n "Checking ANDROID_HOME... "
if [ -n "$ANDROID_HOME" ]; then
    echo -e "${GREEN}✓${NC} Set ($ANDROID_HOME)"

    # Check if directory exists
    if [ -d "$ANDROID_HOME" ]; then
        echo -e "  ${GREEN}✓${NC} Directory exists"
    else
        echo -e "  ${RED}✗${NC} Directory does not exist"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}✗${NC} Not set"
    echo "  Set in ~/.bashrc or ~/.zshrc:"
    echo "  export ANDROID_HOME=\$HOME/Android/Sdk"
    echo "  export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
    ERRORS=$((ERRORS + 1))
fi

# Check Android SDK tools
if [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ]; then
    echo -n "Checking Android SDK tools... "
    if [ -d "$ANDROID_HOME/tools" ] || [ -d "$ANDROID_HOME/cmdline-tools" ]; then
        echo -e "${GREEN}✓${NC} Found"
    else
        echo -e "${YELLOW}⚠${NC} Not found"
        WARNINGS=$((WARNINGS + 1))
    fi

    echo -n "Checking Android platform-tools... "
    if [ -d "$ANDROID_HOME/platform-tools" ]; then
        echo -e "${GREEN}✓${NC} Found"
    else
        echo -e "${YELLOW}⚠${NC} Not found"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# Check Gradle
echo -n "Checking Gradle... "
if command -v gradle &> /dev/null; then
    VERSION=$(gradle --version | grep "Gradle" | cut -d' ' -f2)
    echo -e "${GREEN}✓${NC} Found (v$VERSION)"
else
    echo -e "${YELLOW}⚠${NC} Not found (Cordova will use its own)"
    WARNINGS=$((WARNINGS + 1))
fi

# Check if in Cordova project
echo -n "Checking Cordova project... "
if [ -f "config.xml" ]; then
    echo -e "${GREEN}✓${NC} Found config.xml"
else
    echo -e "${RED}✗${NC} config.xml not found"
    echo "  Not in a Cordova project directory"
    ERRORS=$((ERRORS + 1))
fi

# Check Android platform
echo -n "Checking Android platform... "
if [ -d "platforms/android" ]; then
    echo -e "${GREEN}✓${NC} Android platform added"
else
    echo -e "${YELLOW}⚠${NC} Android platform not added"
    echo "  Run: cordova platform add android"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ Environment check passed!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Environment check passed with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}✗ Environment check failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    exit 1
fi
