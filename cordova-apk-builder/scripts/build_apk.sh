#!/bin/bash
# APK build script for Cordova Android applications

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
BUILD_TYPE="debug"
CLEAN_BUILD=false
ARCHITECTURE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --release)
            BUILD_TYPE="release"
            shift
            ;;
        --debug)
            BUILD_TYPE="debug"
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --arch)
            ARCHITECTURE="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Cordova APK Builder${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get app info from config.xml
if [ -f "config.xml" ]; then
    APP_NAME=$(grep -oP '(?<=<name>)[^<]+' config.xml | head -1)
    APP_VERSION=$(grep -oP '(?<=version=")[^"]+' config.xml | head -1)
    APP_ID=$(grep -oP '(?<=id=")[^"]+' config.xml | head -1)

    echo -e "${GREEN}App Name:${NC} $APP_NAME"
    echo -e "${GREEN}Version:${NC} $APP_VERSION"
    echo -e "${GREEN}Package ID:${NC} $APP_ID"
    echo -e "${GREEN}Build Type:${NC} $BUILD_TYPE"
    [ -n "$ARCHITECTURE" ] && echo -e "${GREEN}Architecture:${NC} $ARCHITECTURE"
    echo ""
else
    echo -e "${RED}✗ config.xml not found${NC}"
    exit 1
fi

# Clean build if requested
if [ "$CLEAN_BUILD" = true ]; then
    echo -e "${YELLOW}🧹 Cleaning previous build...${NC}"
    cordova clean android
    echo ""
fi

# Check if Android platform exists
if [ ! -d "platforms/android" ]; then
    echo -e "${YELLOW}⚠ Android platform not found. Adding...${NC}"
    cordova platform add android
    echo ""
fi

# Build command
BUILD_CMD="cordova build android"

if [ "$BUILD_TYPE" = "release" ]; then
    BUILD_CMD="$BUILD_CMD --release"
else
    BUILD_CMD="$BUILD_CMD --debug"
fi

if [ -n "$ARCHITECTURE" ]; then
    BUILD_CMD="$BUILD_CMD -- --gradleArg=-PcdvBuildMultipleApks=true --gradleArg=-PcdvVersionCode=$ARCHITECTURE"
fi

# Start build
echo -e "${BLUE}🔨 Building APK...${NC}"
START_TIME=$(date +%s)

if $BUILD_CMD; then
    END_TIME=$(date +%s)
    BUILD_TIME=$((END_TIME - START_TIME))

    echo ""
    echo -e "${GREEN}✓ Build completed successfully!${NC}"
    echo -e "${GREEN}Build time:${NC} ${BUILD_TIME}s"
    echo ""

    # Find and display APK files
    echo -e "${BLUE}📦 Generated APK files:${NC}"
    echo ""

    if [ "$BUILD_TYPE" = "release" ]; then
        APK_DIR="platforms/android/app/build/outputs/apk/release"
    else
        APK_DIR="platforms/android/app/build/outputs/apk/debug"
    fi

    if [ -d "$APK_DIR" ]; then
        find "$APK_DIR" -name "*.apk" | while read -r apk; do
            SIZE=$(du -h "$apk" | cut -f1)
            echo -e "${GREEN}✓${NC} $(basename "$apk")"
            echo -e "  Path: $apk"
            echo -e "  Size: $SIZE"
            echo ""
        done
    else
        echo -e "${YELLOW}⚠ APK directory not found: $APK_DIR${NC}"
    fi

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ Build process completed${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

else
    echo ""
    echo -e "${RED}✗ Build failed${NC}"
    echo -e "${YELLOW}Check the error messages above for details${NC}"
    exit 1
fi
