# OHOS Rive Project

本项目包含两个部分：
1. **后端编译包** - 用于编译 引擎的原生库
2. **Rive 集成指南** - Rive 在 HarmonyOS ArkTS 应用中的集成指南

## 第一部分: 后端编译指南

## 下载代码

```bash
git clone git@gitcode.com:openharmony-tpc/openharmony_tpc_samples.git
git submodule update --init --recursive ohos_rive/submodules/rive-runtime
```

### 编译前准备

#### 1. 配置 OHOS_NDK 环境变量

- 确保已安装 OpenHarmony SDK
- 找到 SDK 中的 native 目录，通常路径类似于 `D:\OpenHarmonySDK\api_version\native`

- 配置环境变量：
  1. 在「系统变量」中点击「新建」
  2. 变量名输入 `OHOS_NDK`
  3. 变量值输入 OpenHarmony SDK 中 native 目录的完整路径
  4. 点击「确定」保存设置
- 验证环境变量：
  1. 打开新的命令提示符窗口
  2. 输入 `echo %OHOS_NDK%` 验证环境变量是否正确设置

> 注意：如果您的 OpenHarmony SDK 安装在非默认路径，请确保使用正确的路径。

完成以上步骤后，您就可以开始编译 OHOS Rive 项目了。

#### 2. 安装 MSYS2 并配置环境
- 下载并安装 MSYS2（推荐安装到默认路径 `C:\msys64`）
  - 下载地址：https://www.msys2.org/
  - 安装完成后，运行 MSYS2 终端

- 在 MSYS2 终端中执行以下命令安装所需工具：
  ```bash
  pacman -S mingw-w64-x86_64-ninja mingw-w64-x86_64-premake mingw-w64-x86_64-python-ply make --noconfirm
  ```

- 配置环境变量：
  1. 找到系统变量中的 `Path` 变量并点击「编辑」
  2. 添加以下两个路径（假设 MSYS2 安装在默认路径）：
   - `C:\msys64\mingw64\bin`
   - `C:\msys64\usr\bin`
  3. 点击「确定」保存设置

- 验证环境变量：
  1. 打开提示符窗口
  2. 输入 `premake5 --version` , `python3 --version`, `sh --version`, `ninja --version`和 `make --version` 验证工具是否可用

## 第二部分: 前端 Rive 动画库 HarmonyOS 版本

### 简介

本项目HarmonyOS适配的Rive引擎版本，旨在为HarmonyOS应用提供Rive矢量动画的使用能力。利用此库，开发者能够在HarmonyOS应用中交互式矢量动画的集成与控制，保证与Android及iOS版本具有相同的功能表现和用户体验。

### 什么是Rive?

Rive是现代矢量动画和引擎，帮助设计师与开发者创建并发布交互式动画。相较于传统动画方式，Rive提供了如下改进：

- 文件体积小（通常比GIF和Lottie小很多）
- 运行时渲染，保持高清晰度
- 持复杂的交互式动画
- 支持运行时状态控制和参数调整
- 支持多种主流平台（Web, iOS, Android, HMS）

### 安集成

#### 前提条件

- DevEco Studio 5.1.1 Release 或更高版本
- HarmonyOS SDK API 12 及更高版本

#### 集成方法

1. 下载安装

   ```bash
   ohpm install @ohos/rive
   ```

2. 在入口能力的`onCreate`中调用初始化函数

   ```typescript
   // EntryAbility.ets
   import { initializeRive } from '@ohos/rive';

   onCreate() {
     // 初始化Rive
     try {
       initializeRive();
     } catch (error) {
       console.error("Failed to initialize Rive library:", error);
     }
   }
   ```

### 基本用法

#### 在页面中使用Rive动画

```typescript
import { RiveAnimationView } from 'library';

@Entry
@Component
struct AnimationPage {
  build() {
    Column() {
      // 简单展示一个Rive动画
      RiveAnimationView({
        riveResource: '@rawfile/example_animation.riv', // 位于rawfile目录下的Rive文件
        riveFit: 'cover',                              // 适配方式
        riveAutoPlay: false                            // 自动播放，默认true
      })
      .width('100%')
      .height('30%')
    }
  }
}
```

### 高级用法

#### Artboard切换

```typescript
RiveAnimationView({
  riveResource: '@rawfile/multi_artboard.riv',
  riveArtboard: 'Circle',  // 指定要显示的Artboard
})
```

#### 动画事件控制

```typescript
@State riveView: RiveAnimationView | null = null;

RiveAnimationView({
  riveResource: '@rawfile/button.riv',
  riveAutoPlay: false,
  onReady: (view) => {
    this.riveView = view;
  }
})

// 控制动画的播放、暂停和重置  
this.riveView?.play()    // 播放动画
this.riveView?.pause()   // 暂停动画
this.riveView?.reset()   // 重置动画
```

#### 加载网络资源

##### 方案1：直接使用URL

```typescript
RiveAnimationView({
  riveUrl: 'https://cdn.rive.app/animations/vehicles.riv',
})
.width('100%')
.height('100%')
```

##### 方案2：使用HTTP请求加载

```typescript
// 在module.json5中添加网络权限
"requestPermissions": [{
  "name": "ohos.permission.INTERNET",
}],

// 页面代码
private riveUrl = "https://cdn.rive.app/animations/juice_v7.riv"
@State riveView: RiveAnimationView | null = null;        

RiveAnimationView({
  onReady: (view) => {
    this.riveView = view
  }
})
.width('100%')
.height('100%')

const httpRequest = http.createHttp();
httpRequest.request(this.riveUrl, {
  method: http.RequestMethod.GET,
  connectTimeout: 30000,
  readTimeout: 30000
}).then((response) => {
  if (response.responseCode === 200) {
    const arrayBuffer = response.result as ArrayBuffer;
    this.riveView?.setRiveBytes(arrayBuffer)
  } else {
    console.error(`HttpPage: Network request failed: ${response.responseCode}`);
  }
}).catch((error: Error) => {
  console.error(`HttpPage: Network request error: ${error}`);
}).finally(() => {
  httpRequest.destroy();
});
```

### 目录结构

```
ohos_rive/
├── entry/                     # 入口模块
│   ├── src/main/            # 主要源代码
│   │   ├── ets/          # ArkTS代码
│   │   │   ├── common/    # 公共组件
│   │   │   ├── entryability/ # 入口能力
│   │   │   └── pages/     # 样例页面
│   │   └── resources/   # 资源文件
│   │       └── rawfile/   # Rive动画文件(.riv)
├── library/                   # Rive库模块
│   ├── src/main/           
│   │   ├── ets/         # ArkTS文件
│   │   ├── cpp/         # C++原生代码
│   │   └── resources/   # 库资源文件
└── README_zh.md                  # 项目说明
```

### API接口说明

#### RiveAnimationView

`RiveAnimationView`是鸿蒙系统中用于展示和控制Rive动画的核心组件。

##### 属性

| 属性名 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `riveResource` | string | 否 | 本地Rive资源路径（与`riveUrl`二选一） |
| `riveUrl` | string | 否 | Rive资源的URL（与`riveResource`二选一） |
| `riveLoop` | number | 否 | 动画播放模式 |
| `rendererType` | RendererType | 否 | 渲染器类型 |
| `riveArtboard` | string | 否 | 指定Artboard名称，默认使用第一个 |
| `riveStateMachine` | string | 否 | 指定状态机名称 |
| `riveAnimation` | string | 否 | 指定动画名称 |
| `riveFit` | string | 否 | 适配方式，可选值: 'contain', 'cover', 'fill', 'fitWidth', 'fitHeight', 'none', 'scaleDown' |
| `alignmentIndex` | number | 否 | 对齐方式 |
| `riveAutoPlay` | boolean | 否 | 是否自动播放动画，默认为true |
| `onReady` | (view: RiveAnimationView) => void | 否 | 动画准备就绪后的回调 |

##### 方法

| 方法 | 说明                                                    |
| --- |-------------------------------------------------------|
| `play(animationName?: string, loop?: Loop, direction?: Direction, isStateMachine?: boolean, settleInitialState?: boolean)` | 播放动画，可选指定动画名称。                                        |
| `pause()` | 暂停动画。                                                 |
| `stop()` | 停止动画。                                                 |
| `reset()` | 重置动画到初始状态。                                            |
| `isPlaying()` | 检查动画是否正在播放。返回 boolean。                                |
| `setRiveFile(file: File,artboardName?: string, animationName?: string,stateMachineName?: string,autoplay?: boolean,autoBind?: boolean,fit?: Fit,alignment?: Alignment,loop?: Loop)` | 设置Rive文件对象。                                           |
| `setRiveBytes(bytes: ArrayBuffer, artboardName?: string, animationName?: string, stateMachineName?: string, autoplay?: boolean, autoBind?: boolean, fit?: Fit, alignment?: Alignment, loop?: Loop)` | 从字节数组加载Rive动画。                                        |
| `setNumberState(stateMachineName: string, inputName: string, value: number)` | 设置数字状态。                                               |
| `pauseAnimation(animationName: string, isStateMachine?: boolean)` | 暂停指定名称的动画。                                            |
| `stopAnimation(animationName: string, isStateMachine?: boolean)` | 停止指定名称的动画。                                            |
| `setBooleanState(stateMachineName: string, inputName: string, value: boolean)` | 设置布尔状态。                                               |
| `setBooleanStateAtPath(inputName: string, value: boolean, path: string)` | 在路径上设置布尔状态。                                           |
| `setTextRunValue(textRunName: string, textValue: string, path?: string)` | 设置文本运行值。                                              |
| `setRiveResource(resId: number\|string, artboardName?: string, animationName?: string, stateMachineName?: string, autoplay?: boolean, autoBind?: boolean, fit?: Fit, alignment?: Alignment, loop?: Loop)` | 设置Rive资源。                                             |
| `setArtboardName(name: string)` | 设置当前画板名称。                                             |
| `getFit()` | 获取Fit。返回 Fit。                                         |
| `setFit(value: Fit)` | 设置Fit。                                                |
| `setAlignment(value: Alignment)` | 设置Alignment。                                          |
| `getLayoutScaleFactor()` | 获取布局缩放因子。返回 number。                                   |
| `setLayoutScaleFactor(value: number)` | 设置布局缩放因子。                                             |
| `registerListener(listener: RiveFileControllerListener)` | 注册监听器。                                                |
| `unregisterListener(listener: RiveFileControllerListener)` | 取消注册监听器。                                              |
| `addEventListener(listener: RiveEventListener)` | 添加事件监听器。                                              |
| `removeEventListener(listener: RiveEventListener)` | 移除事件监听器。                                              |
| `getRenderer()` | 获取渲染器对象。返回 Renderer。                                  |
| `getArtboard()` | 获取当前活动的画板对象。返回 Artboard。                              |
| `Alignment.fromIndex(index: number)` | 根据输入得到Alignment枚举值。返回 Alignment。                      |
| `Fit.fromString(fitString: string)` | 根据输入得到Fit枚举值。返回 Fit。                                  |
| `RiveManager.getInstance()` | 获取RiveManager实例。返回 RiveManager。                       |
| `RiveManager.getInstance().init(context: Context, defaultRenderer?: RendererType)` | 初始化RiveManager。                                       |
| `RiveManager.getInstance().setFallbackFont(context: Context, byteArray?: Uint8Array, opts?: FontOpts)` | 为Rive runtime设置备用字体。返回 boolean。                       |
| `RiveRenderImage.fromEncoded(encodedBytes: Uint8Array, rendererType?: RendererType, premultiplied?: boolean)` | 通过解码encodedBytes创建RiveRenderImage。返回 RiveRenderImage。 |
| `RiveRenderImage.fromARGBInts(pixels: Uint32Array, width: number, height: number, rendererType?: RendererType, premultiplied?: boolean)` | 通过ARGB创建RiveRenderImage。返回 RiveRenderImage。           |
| `RiveRenderImage.fromRGBABytes(pixelBytes: Uint8Array, width: number, height: number, rendererType?: RendererType, premultiplied?: boolean)` | 通过RGBA创建RiveRenderImage。返回 RiveRenderImage。           |
| `artboardByName(name: string)` | 在File中获取名为name的画板。返回 Artboard。                        |
| `animationIndex(index: number)` | 在Artboard中根据index获取动画。返回 LinearAnimationInstance。    |
| `restoreControllerState(state: ControllerState)` | 恢复控制器状态。                                              |
| `saveControllerState()` | 保存控制器状态。返回 ControllerState。                          |
| `release()` | 减少引用计数。返回 number。                                     |
| `RiveFont.make(bytes: Uint8Array, rendererType?: RendererType)` | 创建RiveFont。返回 RiveFont。                                |


#### initializeRive

Rive库的初始化函数，应在应用启动时调用一次。

```typescript
import { initializeRive } from '@ohos/rive';

// 在应用启动时初始化
initializeRive();
```

### 注意事项

1. 确保将Rive动画文件(.riv)放在项目的`resources/rawfile`目录下
2. 大型动画文件可能会影响性能，建议优化动画大小
3. 动画状态机名称和参数名称必须与Rive文件中定义的完全一致（区分大小写）
4. 初始化Rive库只需在应用启动时执行一次

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望rive库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：

```
-keep
./oh_modules/@ohos/rive
```

## 开源协议

本项目基于 [MIT](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_rive/LICENSE) ，请自由地享受和参与开源。

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建。
