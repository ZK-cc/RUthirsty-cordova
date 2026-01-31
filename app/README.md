# RUthirsty - 喝水打卡应用 💧

一个炫酷的喝水提醒打卡应用，采用科技感十足的界面设计，帮助你养成良好的喝水习惯。

## ✨ 功能特点

- 🎯 **一键打卡**: 点击炫酷的打卡按钮记录喝水时间
- 📊 **数据统计**: 实时显示今日打卡次数和总计次数
- 📝 **记录列表**: 完整的打卡历史记录，包含时间和日期
- 🎨 **科技感界面**: 深色主题配合蓝色渐变，打造未来科技感
- 💫 **流畅动画**: 
  - 背景波浪动画
  - 打卡按钮涟漪效果
  - 喝水倒水动画
  - 记录滑入动画
- 💾 **本地存储**: 使用 localStorage 持久化保存数据

## 🚀 快速开始

### 环境要求

- Node.js (推荐 v14+)
- Cordova CLI
- Android SDK (用于Android构建)

### 安装依赖

```bash
# 安装 Cordova CLI
npm install -g cordova

# 进入项目目录
cd app

# 安装项目依赖
npm install
```

### 浏览器预览

```bash
# 启动开发服务器
cordova serve

# 在浏览器中访问
# http://localhost:8000
```

### 构建 Android 应用

```bash
# 添加 Android 平台（如果还没添加）
cordova platform add android

# 构建应用
cordova build android

# 构建并运行到连接的设备
cordova run android
```

或者使用提供的构建脚本：

```bash
# 在项目根目录执行
./build.sh
```

### APK 位置

构建完成后，APK 文件位于：
```
app/platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

## 📱 使用说明

1. **打卡**: 点击中央的蓝色圆形按钮进行打卡
2. **查看统计**: 顶部卡片显示今日打卡次数和总计次数
3. **查看记录**: 下方列表显示所有打卡记录
4. **清空记录**: 点击"清空"按钮可以清除所有记录

## 🎨 界面特色

- **深色科技主题**: 深蓝色渐变背景，营造科技氛围
- **玻璃态效果**: 使用 backdrop-filter 实现毛玻璃效果
- **发光效果**: 文字和按钮带有霓虹发光效果
- **流畅动画**: 所有交互都配有流畅的过渡动画

## 🔧 技术栈

- **框架**: Apache Cordova
- **前端**: HTML5 + CSS3 + JavaScript (原生)
- **存储**: localStorage
- **平台**: Android (可扩展到 iOS)

## 📂 项目结构

```
app/
├── www/                    # Web 资源目录
│   ├── css/
│   │   └── index.css      # 样式文件
│   ├── js/
│   │   └── index.js       # 应用逻辑
│   ├── img/               # 图片资源
│   └── index.html         # 主页面
├── platforms/             # 平台特定代码
├── plugins/               # Cordova 插件
├── config.xml            # Cordova 配置
└── package.json          # 项目配置
```

## 🎯 功能实现

### 数据存储

使用 localStorage 存储打卡记录：
- 每条记录包含：ID、时间戳、日期、时间
- 自动持久化，关闭应用后数据不丢失

### 动画效果

1. **背景波浪**: CSS 动画实现的流动波浪效果
2. **打卡按钮**: 
   - 悬浮动画（水滴图标上下浮动）
   - 点击涟漪效果
3. **喝水动画**: 
   - 玻璃杯出现动画
   - 水位上升动画
   - 成功提示淡入
4. **记录列表**: 新记录滑入动画

## 🔮 未来计划

- [ ] 添加每日喝水目标设置
- [ ] 添加定时提醒功能
- [ ] 添加喝水量记录（毫升）
- [ ] 添加数据统计图表
- [ ] 添加成就系统
- [ ] 支持数据导出

## 📄 许可证

MIT License

## 👨‍💻 开发者

RUthirsty Team

---

💧 记得多喝水，保持健康！
