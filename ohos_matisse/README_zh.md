# Matisse

轻量、可配置的媒体选择器，支持图片/视频/GIF、拍摄、预览、原图选项，并提供选择/原图状态回调。

## 特性
- 多类型：图片 / 视频 / GIF，可配置是否互斥
- 多选：全局或分媒体类型的最大可选数
- 拍摄：可开启拍照入口
- 原图：可配置最大原图大小（MB），勾选时校验
- 预览：单击可隐藏/显示工具栏（autoHideToobar）
- 回调：选择列表、原图勾选状态回调

## 安装
### 通过 ohpm
```bash
ohpm install @ohos/matisse --save
```
### 本地依赖
`oh-package.json5` 中添加：
```json5
{
  "dependencies": {
    "@ohos/matisse": "file:../library"
  }
}
```

## 示例入口
- 入口页面：`entry/src/main/ets/pages/Index.ets`（按钮进入示例）
- 示例页面：`entry/src/main/ets/pages/SampleActivity.ets`
- 组件页面：`library/src/main/ets/pages/MatissePage.ets`

## 快速上手（示例调用）
`SampleActivity.ets` 在 Zhihu 场景配置示例：
```typescript
MatissePage({
  mimeType: MimeType.ofAll(),
  mediaTypeExclusive: true,      // 图片/视频互斥
  maxSelectable: 2,
  maxImageSelectable: 2,
  maxVideoSelectable: 3,
  capture: false,
  orientation: 2,                // 方向限制
  originalable: true,
  originalMaxSize: 10,           // 原图最大 MB
  autoHideToobar: true,          // 预览单击隐藏工具栏
  forResult: (uris, paths, originalChecked) => { ... },
  setOnSelectedListener: (uriList, pathList) => { ... },
  setOnCheckedListener: (isChecked) => { ... }
})
```

## 参数速览（MatissePage）
- `mimeType`: 媒体类型（`image/*`, `video/*`, `*/*`, `image/movingPhoto`）
- `mediaTypeExclusive`: 是否图片/视频互斥
- `maxSelectable`: 全局最大可选数
- `maxImageSelectable` / `maxVideoSelectable`: 分媒体类型可选数
- `capture`: 是否显示拍摄入口
- `orientation`: 方向限制
- `originalable`: 是否显示原图开关
- `originalMaxSize`: 原图勾选时允许的最大图片大小（MB）
- `autoHideToobar`: 预览单击是否自动隐藏工具栏
- `forResult(uris, paths, originalChecked)`: 结果回调
- `setOnSelectedListener(uris, paths)`: 选中变化回调
- `setOnCheckedListener(isChecked)`: 原图勾选状态回调

## 原图大小校验说明
- 仅在“原图已勾选”或“尝试勾选”时校验 `originalMaxSize`。
- 超限时提示并自动取消勾选。

## 常见配置示例
```typescript
// 只选图片，最多 5 张，允许原图 10MB
MatissePage({
  mimeType: MimeType.ofImage(),
  maxSelectable: 5,
  originalable: true,
  originalMaxSize: 10
})

// 同时选图片/视频且互斥，图片 3 张，视频 2 个
MatissePage({
  mimeType: MimeType.ofAll(),
  mediaTypeExclusive: true,
  maxImageSelectable: 3,
  maxVideoSelectable: 2
})

// 开启拍摄入口
MatissePage({
  mimeType: MimeType.ofImage(),
  capture: true
})
```

## 目录结构（简要）
```
Matisse_ohos/
├── entry/                   # 示例应用
│   └── src/main/ets/pages/  # Index.ets, SampleActivity.ets
├── library/                 # 组件库
│   ├── src/main/ets/pages/MatissePage.ets
│   ├── src/main/ets/internal/...
│   └── oh-package.json5
└── README_zh.md
```

## 系统要求
- DevEco Studio 5.1.1 Release，SDK：API12（5.0.0.66）

## 混淆
如需排除库被混淆，在 `obfuscation-rules.txt` 增加：
```
-keep
./oh_modules/@ohos/matisse
```

## 开源协议
本项目基于 [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)。

## 贡献
欢迎提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 或提交 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)。
