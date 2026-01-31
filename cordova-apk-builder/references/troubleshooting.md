# Cordova Android Build Troubleshooting

Common issues and solutions when building Cordova Android APKs.

## Environment Issues

### ANDROID_HOME not set

**Error:** `ANDROID_HOME is not set`

**Solution:**
```bash
# Add to ~/.bashrc or ~/.zshrc
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Reload shell configuration
source ~/.bashrc  # or source ~/.zshrc
```

### Java not found

**Error:** `java: command not found`

**Solution:**
```bash
# Install OpenJDK 11 (recommended for Cordova)
sudo apt-get update
sudo apt-get install openjdk-11-jdk

# Verify installation
java -version
```

### Gradle build failed

**Error:** `Gradle build failed with exit code 1`

**Common causes:**
1. **Incompatible Gradle version** - Update Cordova Android platform
2. **Missing dependencies** - Run `cordova requirements android`
3. **Corrupted Gradle cache** - Delete `~/.gradle/caches` and rebuild

**Solution:**
```bash
# Update Cordova Android platform
cordova platform rm android
cordova platform add android@latest

# Check requirements
cordova requirements android

# Clean and rebuild
cordova clean android
cordova build android
```

## Build Issues

### Android platform not added

**Error:** `Platform android not found`

**Solution:**
```bash
cordova platform add android
```

### Build tools version mismatch

**Error:** `Failed to find Build Tools revision X.X.X`

**Solution:**
```bash
# Install Android SDK Build Tools via Android Studio SDK Manager
# Or update build.gradle to use available version

# Check available versions
ls $ANDROID_HOME/build-tools/
```

### Out of memory during build

**Error:** `java.lang.OutOfMemoryError: Java heap space`

**Solution:**
```bash
# Increase Gradle memory in platforms/android/gradle.properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m
```

## Signing Issues (Release Builds)

### Keystore not found

**Error:** `Keystore file not found`

**Solution:**
```bash
# Generate a keystore
keytool -genkey -v -keystore my-release-key.keystore \
  -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000

# Configure in build.json
{
  "android": {
    "release": {
      "keystore": "path/to/my-release-key.keystore",
      "storePassword": "password",
      "alias": "my-key-alias",
      "password": "password"
    }
  }
}
```

### Wrong keystore password

**Error:** `Keystore was tampered with, or password was incorrect`

**Solution:**
- Verify keystore password in build.json
- Ensure alias name matches the keystore

## Plugin Issues

### Plugin compatibility

**Error:** `Plugin X is not compatible with cordova-android Y`

**Solution:**
```bash
# Update plugin to latest version
cordova plugin rm <plugin-id>
cordova plugin add <plugin-id>@latest

# Or specify compatible version
cordova plugin add <plugin-id>@X.X.X
```

### Native code compilation errors

**Error:** `Execution failed for task ':app:compileDebugJavaWithJavac'`

**Solution:**
1. Check plugin documentation for required dependencies
2. Update Android platform: `cordova platform update android`
3. Clean build: `cordova clean android`

## Performance Tips

### Faster builds

```bash
# Use Gradle daemon (add to gradle.properties)
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.configureondemand=true

# Skip unnecessary tasks
cordova build android -- --gradleArg=--no-daemon
```

### Reduce APK size

```bash
# Enable ProGuard for release builds
# Add to platforms/android/app/build.gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}

# Build with specific architecture
cordova build android --release -- --gradleArg=-PcdvBuildMultipleApks=true
```

## Debugging Tips

### View detailed build logs

```bash
# Verbose output
cordova build android --verbose

# Gradle stacktrace
cordova build android -- --stacktrace
```

### Check Android requirements

```bash
cordova requirements android
```

### Verify APK

```bash
# Check APK contents
unzip -l path/to/app.apk

# Verify signing
jarsigner -verify -verbose -certs path/to/app.apk
```

## Common Cordova Commands

```bash
# Add Android platform
cordova platform add android

# Remove Android platform
cordova platform rm android

# Update Android platform
cordova platform update android

# List installed platforms
cordova platform ls

# Clean build
cordova clean android

# Build debug APK
cordova build android --debug

# Build release APK
cordova build android --release

# Run on device
cordova run android

# Run on emulator
cordova emulate android
```
