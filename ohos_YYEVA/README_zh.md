# ohos_YYEVA


## 简介

YY-EVA HarmonyOS 版提供端侧 MP4 合成能力，适用于礼物动画、动态贴纸等播放场景，兼容 Android 版资源格式，具备以下特点：

- 支持透明通道与遮罩混合渲染，可叠加 UI 图层。
- 覆盖播放、暂停、静音、循环、逐帧等全量控制。
- 提供 JSON/脚本驱动的动态元素替换时、文本、轨道等。
- 支持软硬解码切换与 GPU 加速，可在真机与模拟器上保持一致体验。

## 案例演示

HarmonyOS 版示例可展示礼物动画、动态资源替换、循环播放等功能

![yyeva.gif](screenshot/yyeva.gif)


## 下载安装

```bash
ohpm install @ohos/yyevac
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)


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
		Button('Stop').onClick(() => this.player.stop());
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
| `stop()` | 停止播放并释放底层解码器。|
| `setMute(isMute: boolean)` | 控制播放器静音状态。|
| `setLoop(loop: boolean)` | 设置是否循环播放。|
| `setSpeed(speed: number)` | 调整播放速度（倍率）。|
| `seekTo(timestampMs: number)` | 精准跳转到指定毫秒位置。|
| `setFetchResource(fetcher: IEvaFetchResource)` | 注册动态资源替换回调。|
| `setOnClickListener(listener: OnEvaResourceClickListener)` | 监听动画节点点击事件。|
| `setLog(enable: boolean)` | 打开/关闭调试日志输出。|


## 接口图标速览

| 图标 | 功能名称 | 方法 | 说明                                                                                                                                                                                        |
| :-: | --- | --- |-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `[🔗]` | 设置资源 | `setFetchResource(fetcher)` | 绑定 `IEvaFetchResource` 动态替换图片、文本等。                                                                                                                                                        |
| `[▶]` | 播放视频 | `startPlayByRawFile(context, fileName, rawFd)` | 从应用资源启动播放。                                                                                                                                                                                |
| `[⏸]` | 暂停视频 | `pausePlay()` | 暂停当前播放进度。                                                                                                                                                                                 |
| `[⏹]` | 停止视频 | `stop()` | 停止播放并释放底层资源。                                                                                                                                                                              |
| `[⏯]` | 继续视频 | `resumePlay()` | 从暂停位置继续播放。                                                                                                                                                                                |
| `[🔇]` | 静音控制 | `setMute(isMute)` | 切换播放静音状态。                                                                                                                                                                                 |
| `[🔁]` | 重播视频 | `restart()` | 重新从头播放当前动画。                                                                                                                                                                               |
| `[🚀]` | 动画开始回调 | `emitter.on(EvaConstant.EVENT_ID_ON_VIDEO_START, handler)` | 订阅动画启动等事件（`EVENT_ID_ON_VIDEO_CONFIG_READY`, `EVENT_ID_ON_VIDEO_START`, `EVENT_ID_ON_VIDEO_RESTART`, `EVENT_ID_ON_VIDEO_RENDER`, `EVENT_ID_ON_VIDEO_COMPLETE`, `EVENT_ID_ON_VIDEO_DESTROY`）。 |
| `[🛑]` | 关闭回调监听 | `emitter.off(EvaConstant.EVENT_ID_ON_VIDEO_START)` | 取消动画播放状态监听等事件（`EVENT_ID_ON_VIDEO_CONFIG_READY`, `EVENT_ID_ON_VIDEO_START`, `EVENT_ID_ON_VIDEO_RESTART`, `EVENT_ID_ON_VIDEO_RENDER`, `EVENT_ID_ON_VIDEO_COMPLETE`, `EVENT_ID_ON_VIDEO_DESTROY`）。 |                                                                                                                                                                           |

> 图标使用 ASCII 包裹的提示符号，方便在纯文本环境中阅读。


## 约束与限制

在下述版本验证通过：
- DevEco Studio版本: 6.0.0.868, SDK: API18 Release(5.1.0)


## 目录结构

```
ohos_YYEVA/
├── entry/                 # Stage Ability 示例，演示播放、下载等场景
├── library/                # YYEVA ArkTS 引擎库，导出播放器能力
│      └── src/
│           └── main/
│                 └── ets/  
│                      └── EvaAnimConfig.ets            # 解析动画配置
│                          EvaAnimConfigManager.ets     # YYEVA 配置管理器，负责解析和管理动画配置
│                          EvaAnimPlayer.ets            # 播放器
│                          decoder                      # 编解码
│                          file                         # 文件管理
│                          inter                        # 定义动态资源获取和替换功能、设置资源监听
│                          mix                          # 混合动画插件，负责处理混合渲染功能
│                          plugin                       # 动画插件管理器，负责管理所有动画插件
│                          util                         # 各种工具类
│                          view                         #视图类，设置回调
├── AppScope/              # 应用范围配置
├── hvigorfile.ts          # 根级 Hvigor 构建配置
├── oh-package.json5       # ohpm 依赖与项目信息
└── README_zh.md           # 本说明文档
```

`entry` 模块包含两个示例页面：`Eva Demo` 展示播放/暂停/静音/重播等控制，`Eva Download Demo` 演示下载后播放流程。


## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望yyevac库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：

```
-keep
./oh_modules/@ohos/yyevac
```

## 开源协议

本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_YYEVA/LICENSE ) ，请自由地享受和参与开源。

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建。

