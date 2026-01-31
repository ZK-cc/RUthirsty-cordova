---
name: cordova-apk-builder
description: Automate Cordova Android APK builds with environment validation, debug/release options, and comprehensive error handling. Use when users request building Android APKs, packaging Cordova apps, creating debug/release builds, or when they say "build APK", "package Android app", "create APK", "generate Android build", or similar build-related requests for Cordova projects.
---

# Cordova APK Builder

Automates the complete workflow for building Cordova Android APKs, from environment validation to final APK generation.

## Quick Start

For most builds, use the build script directly:

```bash
# Debug build (default)
bash scripts/build_apk.sh --debug

# Release build
bash scripts/build_apk.sh --release

# Clean build
bash scripts/build_apk.sh --debug --clean
```

## Workflow

### 1. Environment Check

Always start by validating the build environment:

```bash
bash scripts/check_env.sh
```

The script checks:
- Cordova CLI installation
- Node.js and npm
- Java JDK
- ANDROID_HOME environment variable
- Android SDK tools
- Gradle (optional)
- Cordova project structure
- Android platform

**If checks fail:** Follow the installation instructions provided by the script.

### 2. Build APK

Use the build script with appropriate options:

**Debug Build** (for testing):
```bash
bash scripts/build_apk.sh --debug
```

**Release Build** (for distribution):
```bash
bash scripts/build_apk.sh --release
```

**Clean Build** (removes previous build artifacts):
```bash
bash scripts/build_apk.sh --clean --debug
```

**Architecture-specific Build**:
```bash
bash scripts/build_apk.sh --debug --arch arm64-v8a
```

### 3. Locate APK

The build script automatically displays:
- APK file path
- File size
- Build time
- App version from config.xml

**Default locations:**
- Debug: `platforms/android/app/build/outputs/apk/debug/`
- Release: `platforms/android/app/build/outputs/apk/release/`

## Build Options

| Option | Description |
|--------|-------------|
| `--debug` | Build debug APK (default) |
| `--release` | Build release APK (requires signing) |
| `--clean` | Clean previous build before building |
| `--arch <arch>` | Build for specific architecture |

**Supported architectures:**
- `arm64-v8a` (64-bit ARM, most modern devices)
- `armeabi-v7a` (32-bit ARM, older devices)
- `x86` (32-bit Intel, emulators)
- `x86_64` (64-bit Intel, emulators)

## Common Scenarios

### First-time build

```bash
# Check environment
bash scripts/check_env.sh

# If Android platform missing, add it
cordova platform add android

# Build debug APK
bash scripts/build_apk.sh --debug
```

### Quick rebuild

```bash
bash scripts/build_apk.sh --debug
```

### Production release

```bash
# Clean build for release
bash scripts/build_apk.sh --release --clean
```

### Troubleshooting build issues

```bash
# Check environment
bash scripts/check_env.sh

# Clean and rebuild
bash scripts/build_apk.sh --clean --debug

# If still failing, see references/troubleshooting.md
```

## Error Handling

When builds fail:

1. **Check environment first:**
   ```bash
   bash scripts/check_env.sh
   ```

2. **Review error messages** - The build script provides detailed output

3. **Consult troubleshooting guide:**
   ```bash
   # Read the troubleshooting reference
   cat references/troubleshooting.md
   ```

4. **Common fixes:**
   - Missing ANDROID_HOME: Set environment variable
   - Gradle errors: Clean build with `--clean`
   - Plugin issues: Update plugins to latest versions
   - Platform issues: Remove and re-add Android platform

## Reading App Information

Before building, the script reads from `config.xml`:
- App name
- Version number
- Package ID

Use the Read tool to inspect config.xml if you need to verify or modify these values.

## Output Information

After successful build, the script displays:
- ✓ Build completion status
- ⏱ Build time in seconds
- 📦 APK file paths
- 📊 APK file sizes
- 📱 App version and package ID

## Integration with Cordova Workflow

This skill integrates with standard Cordova commands:

```bash
# Add platform (if needed)
cordova platform add android

# Build using this skill
bash scripts/build_apk.sh --debug

# Run on device (after build)
cordova run android

# Or install manually
adb install path/to/app-debug.apk
```

## Release Build Requirements

For release builds, you need a signing keystore:

```bash
# Generate keystore (one-time setup)
keytool -genkey -v -keystore my-release-key.keystore \
  -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000

# Create build.json in project root
{
  "android": {
    "release": {
      "keystore": "my-release-key.keystore",
      "storePassword": "your-password",
      "alias": "my-key-alias",
      "password": "your-password"
    }
  }
}
```

See `references/troubleshooting.md` for detailed signing setup.

## Tips

- **Always check environment first** on new machines or after updates
- **Use clean builds** when switching between debug/release or after plugin changes
- **Debug builds** are faster and don't require signing
- **Release builds** are optimized and smaller but require keystore setup
- **Check APK size** - Large APKs may indicate missing optimizations

## Troubleshooting Reference

For detailed troubleshooting, see `references/troubleshooting.md` which covers:
- Environment setup issues
- Build failures
- Signing problems
- Plugin compatibility
- Performance optimization
- Common error messages and solutions
