本系统为报修系统的鸿蒙端页面基于OpenHarmony编写HarmonyOSNEXT移动端app



## 目录结构

```




src
├── entryability
│   └── EntryAbility.ets
├── common // 公共封装
│   ├── builders       // 自定义 builder
│   ├── components     // 自定义组件
│   ├── constants      // 自定义常量
│   ├── dialog         // 自定义对话框
│   ├── images         // 图像资源
│   ├── uploads        // 测试的图像资源
│   └── utils          // 通用工具函数
├── manager                     // 管理器模块
│   ├── PermissionManager.ets   // 用户权限管理器
│   ├── ThemeManager.ets        // 主题管理器
│   └── index.ets               // 管理器模块入口
└── pages // 项目页面
    ├── Index.ets                   // 应用主页
    ├── Tabs
    │   ├── HomeTabsComp.ets        // 首页
    │   ├── GuardTabsComp.ets       // 报修
    │   └── MyTabsComp.ets          // 我的

    ├── Settings
    │   ├── SettingsIndexPage.ets         // 设置主页
    │   └── SettingsPermissionPage.ets    // 权限管理
    └── User
        └── UserLoginPage.ets       // 用户登录页
```
