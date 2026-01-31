# Android APK 自动构建

本项目使用 GitHub Actions 自动构建 Android APK。

## 🚀 如何触发构建

### 方式 1：推送代码（自动触发）

每次推送到 `main` 分支时，如果 `app/` 目录下的文件有变化，会自动触发构建：

```bash
git add .
git commit -m "Update app"
git push origin main
```

### 方式 2：手动触发

1. 访问 GitHub 仓库页面
2. 点击 **Actions** 标签
3. 选择 **Build Android APK** 工作流
4. 点击 **Run workflow** 按钮
5. 选择分支（通常是 `main`）
6. 点击 **Run workflow** 确认

### 方式 3：Pull Request

创建 Pull Request 到 `main` 分支时也会自动构建，用于测试。

## 📦 下载构建的 APK

构建完成后：

1. 进入 **Actions** 标签
2. 点击最新的工作流运行记录
3. 在页面底部的 **Artifacts** 部分找到 APK 文件
4. 点击下载（格式：`AppName-vX.X.X-debug.zip`）
5. 解压 ZIP 文件获取 APK

## 📱 安装 APK

### 在 Android 设备上安装

1. 将 APK 文件传输到 Android 设备
2. 在设备上打开文件管理器
3. 点击 APK 文件
4. 允许"从未知来源安装"（如果需要）
5. 点击"安装"

### 使用 ADB 安装

```bash
adb install path/to/app-debug.apk
```

## 🔧 构建配置

工作流配置文件：`.github/workflows/build-android.yml`

**构建环境：**
- Ubuntu Latest
- Node.js 18
- Java 17 (Temurin)
- Cordova CLI (最新版本)

**构建类型：**
- Debug APK（用于测试，无需签名）

## 📊 构建状态

查看构建状态：
- 访问仓库的 **Actions** 标签
- 绿色 ✓ = 构建成功
- 红色 ✗ = 构建失败（点击查看日志）

## 🛠 本地构建

如果需要在本地构建，使用我们创建的 skill：

```bash
cd app

# 检查环境
bash ../cordova-apk-builder/scripts/check_env.sh

# 构建 APK
bash ../cordova-apk-builder/scripts/build_apk.sh --debug
```

## 📝 发布版本构建

要构建发布版本（需要签名），需要：

1. 生成签名密钥
2. 在 GitHub Secrets 中配置密钥信息
3. 修改工作流以支持 release 构建

详见：`cordova-apk-builder/references/troubleshooting.md`

## 🔍 故障排除

如果构建失败：

1. 查看 Actions 日志中的错误信息
2. 检查 `app/config.xml` 配置
3. 确保 `app/` 目录结构正确
4. 参考 `cordova-apk-builder/references/troubleshooting.md`

## 📚 相关文档

- [Cordova Android Platform Guide](https://cordova.apache.org/docs/en/latest/guide/platforms/android/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- 本地构建 Skill: `cordova-apk-builder/`
