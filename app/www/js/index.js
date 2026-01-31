// RUthirsty - 喝水打卡应用

// 数据存储键名
const STORAGE_KEY = 'ruthirsty_records';

// 应用状态
let records = [];

// 等待Cordova设备就绪
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);
    initApp();
}

// 初始化应用
function initApp() {
    // 加载数据
    loadRecords();
    
    // 更新统计
    updateStats();
    
    // 渲染记录列表
    renderRecords();
    
    // 绑定事件
    bindEvents();
}

// 绑定事件监听
function bindEvents() {
    const checkInBtn = document.getElementById('checkInBtn');
    const clearBtn = document.getElementById('clearBtn');
    
    checkInBtn.addEventListener('click', handleCheckIn);
    clearBtn.addEventListener('click', handleClear);
}

// 处理打卡
function handleCheckIn() {
    const btn = document.getElementById('checkInBtn');
    
    // 添加点击动画
    btn.classList.add('clicked');
    setTimeout(() => {
        btn.classList.remove('clicked');
    }, 600);
    
    // 显示喝水动画
    showWaterAnimation();
    
    // 添加记录
    setTimeout(() => {
        addRecord();
    }, 1500);
}

// 显示喝水动画
function showWaterAnimation() {
    const animation = document.getElementById('waterAnimation');
    animation.classList.remove('hidden');
    
    // 2秒后隐藏动画
    setTimeout(() => {
        animation.classList.add('hidden');
    }, 2000);
}

// 添加打卡记录
function addRecord() {
    const now = new Date();
    const record = {
        id: Date.now(),
        timestamp: now.getTime(),
        date: formatDate(now),
        time: formatTime(now)
    };
    
    records.unshift(record);
    saveRecords();
    updateStats();
    renderRecords();
}

// 处理清空记录
function handleClear() {
    if (records.length === 0) {
        return;
    }
    
    if (confirm('确定要清空所有打卡记录吗？')) {
        records = [];
        saveRecords();
        updateStats();
        renderRecords();
    }
}

// 加载记录
function loadRecords() {
    try {
        const data = localStorage.getItem(STORAGE_KEY);
        if (data) {
            records = JSON.parse(data);
        }
    } catch (error) {
        console.error('加载记录失败:', error);
        records = [];
    }
}

// 保存记录
function saveRecords() {
    try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(records));
    } catch (error) {
        console.error('保存记录失败:', error);
    }
}

// 更新统计数据
function updateStats() {
    const todayCount = getTodayCount();
    const totalCount = records.length;
    
    document.getElementById('todayCount').textContent = todayCount;
    document.getElementById('totalCount').textContent = totalCount;
}

// 获取今日打卡次数
function getTodayCount() {
    const today = new Date();
    const todayStr = formatDate(today);
    
    return records.filter(record => record.date === todayStr).length;
}

// 渲染记录列表
function renderRecords() {
    const recordsList = document.getElementById('recordsList');
    
    if (records.length === 0) {
        recordsList.innerHTML = `
            <div class="empty-state">
                <div class="empty-shield">
                    <svg viewBox="0 0 100 120">
                        <path d="M50 5 L90 20 L90 60 Q90 90 50 115 Q10 90 10 60 L10 20 Z" class="empty-shield-path"/>
                    </svg>
                </div>
                <p class="empty-text">No Quests Completed</p>
                <p class="empty-hint">Begin your sacred vigil above</p>
            </div>
        `;
        return;
    }
    
    const html = records.map((record, index) => `
        <div class="record-item">
            <div class="record-info">
                <div class="record-icon"></div>
                <div class="record-details">
                    <div class="record-time">${record.time}</div>
                    <div class="record-date">${record.date}</div>
                </div>
            </div>
            <div class="record-number">#${records.length - index}</div>
        </div>
    `).join('');
    
    recordsList.innerHTML = html;
}

// 格式化日期
function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// 格式化时间
function formatTime(date) {
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${hours}:${minutes}:${seconds}`;
}

// 如果不在Cordova环境中，直接初始化（用于浏览器测试）
if (typeof cordova === 'undefined') {
    console.log('Running in browser mode');
    document.addEventListener('DOMContentLoaded', initApp);
}
