# YY-EVA <sup>HarmonyOS</sup>

简体中文 | [English](./README_en.md) *(敬请期待)*

> 面向 HarmonyOS NEXT 的轻量级、高性能、跨平台 MP4 动画播放器实现。

## 项目简介

YY-EVA HarmonyOS 版为礼物动画、动态贴纸等实时播放场景提供端侧 MP4 混合渲染能力，兼容 Android 版资源格式，具备以下特点：

- 支持透明通道与遮罩混合渲染，可叠加在任意 UI 图层。
- 覆盖播放、暂停、静音、循环、逐帧 等全量控制。
- 提供 JSON/脚本驱动的动态元素替换，运行时更新头像、文案、音轨等。
- 支持软硬解码切换与 GPU 加速，可在真机与模拟器上保持一致体验。
- 统一 ArkTS API，适配 Stage Ability 生命周期与后台恢复策略。

## 下载安装

### 环境要求

- DevEco Studio NEXT Beta / HarmonyOS SDK NEXT Beta 及以上
- Node.js ≥ 16.20（供 hvigor / ohpm 使用）
- HarmonyOS 设备或模拟器（建议 HarmonyOS NEXT API 18 及以上）
- 构建链：ArkTS + Hvigor（Stage 模式）

### 获取工程

```bash
git clone https://github.com/yylive/YYEVA_Ohos.git
cd YYEVA_Ohos
```

Clone 官方仓库或将子模块添加到现有工程均可。

### 安装依赖

```bash
ohpm install
```

确保 `oh_modules/` 下三方依赖（例如 `@ohos/hypium`, `@ohos/hamock`）完整无缺。

### 编译与运行

**DevEco Studio**

1. 打开项目根目录 `YYEVA_Ohos`。
2. 等待 IDE 自动同步 hvigor 构建脚本与 ohpm 依赖。
3. 在 *Module* 面板选择 `entry`，点击 **Run** 完成安装运行。

**命令行**

```bash
# 构建调试 HAP
hvigorw assembleDebug

# 构建发布 HAP
hvigorw assembleRelease
```

生成产物位于 `entry/build/default/outputs/hap/`。

## 使用说明

### 1. 引入组件与常量

```ts
import {
	EvaAnimComponent,
	EvaAnimPlayer,
	IEvaFetchResource,
	OnEvaResourceClickListener,
	EvaConstant
} from '@ohos/yyevac';
```

### 2. 创建与挂载播放器

```ts
private abilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
@State player: EvaAnimPlayer = new EvaAnimPlayer(this.getUIContext(), 'DemoPlayer');

build() {
	Column() {
		EvaAnimComponent({ playerEva: this.player })
			.width('100%')
			.height('80%');
		Button('Play').onClick(async () => {
			const rawFd = await this.abilityContext.resourceManager.getRawFd('effect.mp4');
			this.player.startPlayByRawFile(this.abilityContext, 'effect.mp4', rawFd);
		});
		Button('Stop').onClick(() => this.player.stopPlay());
	}
}
```

### 3. 动态资源替换

```ts
class EvaFetchResource implements IEvaFetchResource {
	constructor(private ability: common.UIAbilityContext) {}

	async setImage(resource: EvaResource,
			done: (pixelMap: image.PixelMap | null, fit: EvaSrc.FitType | null) => void) {
		if (resource.tag === 'anchor_avatar1') {
			const buffer = await this.ability.resourceManager.getMediaContent($r('app.media.avatar').id, 0);
			const img = await image.createImageSource(buffer.buffer).createPixelMap();
			done(img, null);
			img.release();
		} else {
			done(null, null);
		}
	}

	setText(resource: EvaResource, done: (res: EvaResource) => void): void {
		if (resource.tag === 'anchor_nick') {
			resource.text = 'YYEVA USER';
		}
		done(resource);
	}

	releaseSrc(): void {}
}

this.player.setFetchResource(new EvaFetchResource(this.context));
```

### 4. 监听播放事件

```ts
import { emitter } from '@kit.BasicServicesKit';

emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_START, data => {
	console.info('YYEVA start', JSON.stringify(data));
});

// 页面销毁时清理
emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_START);
```

更多事件常量可查阅 `EvaConstant`。

## 核心类与接口

### 核心类
| 名称 | 类型 | 作用 |
| --- | --- | --- |
| `EvaAnimPlayer` | 类 | 播放控制器，负责加载、播放、暂停、释放资源等完整生命周期管理。|
| `EvaAnimComponent` | 组件 | ArkTS UI 组件，承载播放器渲染画布并和 `EvaAnimPlayer` 绑定。|
| `IEvaFetchResource` | 接口 | 提供动态资源回调，在渲染前替换图片、文本、音频等。|
| `OnEvaResourceClickListener` | 接口 | 捕获动画内元素点击事件，便于实现交互。|
| `EvaConstant` | 常量集 | 定义播放器事件 ID、默认配置、日志开关等常量。|
| `EvaResource` | 数据结构 | 描述动画中可替换资源的 meta 信息（tag、文本、尺寸等）。|

### 核心方法

| 方法 | 说明 |
| --- | --- |
| `startPlayByRawFile(context, fileName, rawFd)` | 播放应用资源目录中的混合 MP4。|
| `startPlayByPath(context, filePath)` | 播放沙箱或外部路径下的 MP4 资源。|
| `pausePlay()` / `resumePlay()` | 暂停与恢复播放。|
| `stopPlay()` | 停止播放并释放底层解码器。|
| `setMute(isMute: boolean)` | 控制播放器静音状态。|
| `setLoop(loop: boolean)` | 设置是否循环播放。|
| `setSpeed(speed: number)` | 调整播放速度（倍率）。|
| `seekTo(timestampMs: number)` | 精准跳转到指定毫秒位置。|
| `setFetchResource(fetcher: IEvaFetchResource)` | 注册动态资源替换回调。|
| `setOnClickListener(listener: OnEvaResourceClickListener)` | 监听动画节点点击事件。|
| `setLog(enable: boolean)` | 打开/关闭调试日志输出。|

更多接口可参考 `yyevac/src/main/ets/EvaAnimPlayer.ets` 与相关模块。

## 接口图标速览

| 图标 | 功能名称 | 方法 | 说明 |
| :-: | --- | --- | --- |
| `[🔗]` | 设置资源 | `setFetchResource(fetcher)` | 绑定 `IEvaFetchResource` 动态替换图片、文本等。|
| `[▶]` | 播放视频 | `startPlayByRawFile(context, fileName, rawFd)` | 从应用资源启动播放。|
| `[⏸]` | 暂停视频 | `pausePlay()` | 暂停当前播放进度。|
| `[⏹]` | 停止视频 | `stopPlay()` | 停止播放并释放底层资源。|
| `[⏯]` | 继续视频 | `resumePlay()` | 从暂停位置继续播放。|
| `[🔇]` | 静音控制 | `setMute(isMute)` | 切换播放静音状态。|
| `[🔁]` | 重播视频 | `restart()` | 重新从头播放当前动画。|
| `[🚀]` | 动画开始回调 | `emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_START, handler)` | 订阅动画启动等事件（`EVENT_ID_ON_VIDEO_CONFIG_READY`, `EVENT_ID_ON_VIDEO_START`, `EVENT_ID_ON_VIDEO_RESTART`, `EVENT_ID_ON_VIDEO_RENDER`, `EVENT_ID_ON_VIDEO_COMPLETE`, `EVENT_ID_ON_VIDEO_DESTROY`）。|
| `[🛑]` | 关闭回调监听 | `emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_START)` | 取消动画播放状态监听。|

> 图标使用 ASCII 包裹的提示符号，方便在纯文本环境中阅读。

## 目录结构

```
YYEVA_Ohos/
├── entry/                 # Stage Ability 示例，演示播放、下载等场景
├── yyevac/                # YYEVA ArkTS 引擎库，导出播放器能力
├── AVCodec/               # 媒体能力演示组件（可选）
├── AppScope/              # 应用范围配置
├── hvigorfile.ts          # 根级 Hvigor 构建配置
├── oh-package.json5       # ohpm 依赖与项目信息
└── README.md              # 本说明文档
```

`entry` 模块包含两个示例页面：`Eva Demo` 展示播放/暂停/静音/重播等控制，`Eva Download Demo` 演示下载后播放流程。

## 案例演示

HarmonyOS 版 Demo 可实时预览礼物动画、动态资源替换、循环播放等效果：

<img src="https://github.com/yylive/YYEVA-Android/raw/main/resource/out_3.gif" width="399" height="428" alt="YYEVA Demo" />

## 常见问题

### 如何加载自定义 MP4 资源？

1. 将混合 MP4 放入 `entry/src/main/resources/rawfile/`。
2. 调用 `player.startPlayByRawFile(context, fileName, rawFd)` 播放。
3. 若为网络资源，可参考 `EvaDownloadDemo.ets` 下载至沙箱再调用 `startPlayByPath`。

### 是否支持循环播放 / 静音？

支持，通过 `setMute(true)` 实现。

## 支持本项目

如果 YYEVA 对你有帮助，请在 [⭐ GitHub 主仓库](https://github.com/yylive/YYEVA) 点亮星标，让更多开发者看到我们。

## 相关链接

- [YYEVA 设计规范](https://github.com/yylive/YYEVA/blob/main/YYEVA%E8%AE%BE%E8%AE%A1%E8%A7%84%E8%8C%83.md)
- [Android 版本仓库](https://github.com/yylive/YYEVA-Android)
- [YYEVA Web 版本](https://github.com/yylive/YYEVA-Web)

## License

本项目遵循 [Apache License 2.0](./LICENSE)。

---

如有问题或期望新能力，欢迎在 Issue 中留言，或者加入 QQ 交流群（详见主仓库 README），与我们一起完善 YYEVA HarmonyOS 版本。
