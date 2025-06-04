# SpineArkTS

## 简介

SpineArkTS是一个 Spine 2D 骨骼动画运行时库，其核心目标是提供轻量、高性能且开发者友好的 API，满足游戏开发、动态内容展示等场景对骨骼动画的需求。

![showlottie](./screenshot/spine.gif)


## 下载安裝

```
 ohpm install @ohos/spine
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用示例
### 完整示例
```
import {
  AssetManager,
  AtlasAttachmentLoader,
  AnimationState,
  AnimationStateData,
  SkeletonRenderer,
  SkeletonJson,
  Skeleton,
  TextureAtlas,
  Physics,
  Delay,
  Bound
} from '@ohos/spine'

@Entry
@Component
struct Index {
  // 构建上下文
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings)
  private _animator: AnimatorResult | undefined; 
  private animationState: AnimationState | undefined;
  private animations: Array<string> = ['death', 'aim', 'idle', 'jump', 'run', 'shoot', 'walk']; 
  private currentIndex: number = 0;
  private animationName: string = "walk";

  // 页面销毁时停止动画清空画布
  aboutToDisappear(): void {
    this._animator?.finish();
    this.canvasRenderingContext.clearRect(0, 0, this.canvasRenderingContext.width, this.canvasRenderingContext.height);
  }

  build() {
    Row() {
      // 关联画布
      Canvas(this.canvasRenderingContext)
        .width(200)
        .height(200)
        .backgroundColor(Color.Gray)
        .onReady(() => {
          // 加载动画
          this.loadAnimation();
        })
    }
  }

 async loadAnimation() {  // json格式资源文件加载
    // 1. 初始化 SkeletonRenderer
    let skeletonRenderer = new SkeletonRenderer(this.canvasRenderingContext); // 创建一个 SkeletonRenderer 实例，用于在画布上渲染骨骼动画 传入当前类的 canvasRenderingContext 作为渲染上下文

    // 2. 创建资源管理器并加载资源
    let assetManager = new AssetManager("animation/"); // 创建 AssetManager 实例，设置资源基础路径为 "animation/"
    assetManager.loadText("spineboy-ess.json"); // 加载 Spine 动画所需的 JSON 数据文件 ("spineboy-ess.json")
    assetManager.loadTextureAtlas("spineboy.atlas"); // 加载纹理图集文件 ("spineboy.atlas")
    await assetManager.loadAll(); // 等待所有资源加载完成

    // 3. 创建纹理图集和骨骼数据
    let atlas: TextureAtlas = assetManager.require("spineboy.atlas"); // 从资源管理器获取纹理图集
    let atlasLoader = new AtlasAttachmentLoader(atlas); // 创建 AtlasAttachmentLoader 用于加载附件
    let skeletonJson = new SkeletonJson(atlasLoader); // 创建 SkeletonJson 解析器
    let skeletonData = skeletonJson.readSkeletonData(assetManager.require("spineboy-ess.json")); // 读取并解析骨骼动画数据文件，生成 skeletonData

    // 4. 创建骨骼实例
    let skeleton = new Skeleton(skeletonData); // 基于骨骼数据创建新的骨骼实例
    skeleton.setToSetupPose(); // 将骨骼设置为初始姿势
    skeleton.updateWorldTransform(Physics.update); // 更新骨骼的世界变换
    let bounds = skeleton.getBoundsRect(); // 获取骨骼的边界矩形

    // 5. 设置动画状态
    let animationStateData = new AnimationStateData(skeleton.data); // 创建动画状态数据，传入骨骼数据
    animationStateData.defaultMix = 0.2; // 设置默认动画混合时间为 0.2 秒
    this.animationState = new AnimationState(animationStateData); // 创建动画状态实例并存储在类的 animationState 属性中

    let lastFrameTime = Date.now() / 1000; // 初始化动画计时器

    // 清理现有动画器
    if (this._animator) {
      this._animator.finish();
    }

    // 设置动画选项
    let options: AnimatorOptions = {
      duration: 20000,       // 动画持续时间 20 秒
      easing: 'linear',      // 线性缓动
      delay: 0,              // 无延迟
      fill: 'forwards',      // 动画完成后保持最后一帧状态
      direction: 'normal',   // 正常方向播放
      iterations: -1,        // 无限循环
      begin: 0,              // 从第 0 帧开始
      end: 1                 // 到第 1 帧结束
    };

    // 设置预期帧率  定义动画的预期帧率范围：最小 0，最大 120，期望 60
    let expectedFrameRate: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 60
    }

    // 创建动画器
    this._animator = animator.create(options);
    this._animator.setExpectedFrameRateRange(expectedFrameRate);

    // 初始化渲染结果对象 创建延迟对象，包含初始时间和完成状态标志
    let result: Delay = { time: lastFrameTime, isFinish: true };

    // 设置动画器的每帧回调
    this._animator.onFrame = (value: number) => {
      if (result.isFinish) {
        result.isFinish = false;
        result = this.render(this.canvasRenderingContext, result.time, skeleton, this.animationState!, skeletonRenderer,
          bounds);
      }
    }
    // 播放动画
    this._animator.play();
  }
  
  async loadAnimation() {  //skel格式资源文件加载
    // 1. 初始化 SkeletonRenderer
    let skeletonRenderer = new SkeletonRenderer(this.canvasRenderingContext); // 创建一个 SkeletonRenderer 实例，用于在画布上渲染骨骼动画 传入当前类的 canvasRenderingContext 作为渲染上下文
    skeletonRenderer.triangleRendering = true; // true是使用drawTriangle方式渲染 false是使用drawImages方式渲染

    // 2. 创建资源管理器并加载资源
    let assetManager = new AssetManager("animation5/"); // 创建 AssetManager 实例，设置资源基础路径为 "animation/"
    assetManager.loadBinary("dragon-ess.skel");; // 加载 Spine 动画所需的 skel 数据文件
    assetManager.loadTextureAtlas("dragon-pma.atlas"); // 加载纹理图集文件 ("spineboy.atlas")
    await assetManager.loadAll(); // 等待所有资源加载完成

    // 3. 创建纹理图集和骨骼数据
    let atlas: TextureAtlas = assetManager.require("dragon-pma.atlas"); // 从资源管理器获取纹理图集
    let atlasLoader = new AtlasAttachmentLoader(atlas); // 创建 AtlasAttachmentLoader 用于加载附件
    let skeletonBinary = new SkeletonBinary(atlasLoader);; // 创建 SkeletonBinary 解析器
    let skeletonData = skeletonBinary.readSkeletonData(assetManager.require("dragon-ess.skel")); // 读取并解析骨骼动画数据文件，生成 skeletonData

    // 4. 创建骨骼实例
    let skeleton = new Skeleton(skeletonData); // 基于骨骼数据创建新的骨骼实例
    skeleton.setToSetupPose(); // 将骨骼设置为初始姿势
    skeleton.updateWorldTransform(Physics.update); // 更新骨骼的世界变换
    let bounds = skeleton.getBoundsRect(); // 获取骨骼的边界矩形

    // 5. 设置动画状态
    let animationStateData = new AnimationStateData(skeleton.data); // 创建动画状态数据，传入骨骼数据
    animationStateData.defaultMix = 0.2; // 设置默认动画混合时间为 0.2 秒
    this.animationState = new AnimationState(animationStateData); // 创建动画状态实例并存储在类的 animationState 属性中

    let lastFrameTime = Date.now() / 1000; // 初始化动画计时器

    // 清理现有动画器
    if (this._animator) {
      this._animator.finish();
    }

    // 设置动画选项
    let options: AnimatorOptions = {
      duration: 20000,       // 动画持续时间 20 秒
      easing: 'linear',      // 线性缓动
      delay: 0,              // 无延迟
      fill: 'forwards',      // 动画完成后保持最后一帧状态
      direction: 'normal',   // 正常方向播放
      iterations: -1,        // 无限循环
      begin: 0,              // 从第 0 帧开始
      end: 1                 // 到第 1 帧结束
    };

    // 设置预期帧率  定义动画的预期帧率范围：最小 0，最大 120，期望 60
    let expectedFrameRate: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 60
    }

    // 创建动画器
    this._animator = animator.create(options);
    this._animator.setExpectedFrameRateRange(expectedFrameRate);

    // 初始化渲染结果对象 创建延迟对象，包含初始时间和完成状态标志
    let result: Delay = { time: lastFrameTime, isFinish: true };

    // 设置动画器的每帧回调
    this._animator.onFrame = (value: number) => {
      if (result.isFinish) {
        result.isFinish = false;
        result = this.render(this.canvasRenderingContext, result.time, skeleton, this.animationState!, skeletonRenderer,
          bounds);
      }
    }
    // 播放动画
    this._animator.play();
  }

   render(
     context: CanvasRenderingContext2D,  // Canvas 2D 渲染上下文
     lastFrameTime: number,             // 上一帧的时间戳（秒）
     skeleton: Skeleton,                // Spine 骨骼对象
     animationState: AnimationState,    // 动画状态机
     skeletonRenderer: SkeletonRenderer, // 骨骼渲染器
     bounds: Bound                      // 动画的边界框（用于缩放计算）
     ): Delay {
    // Calculate the delta time between this and the last frame in seconds.
    let now = Date.now() / 1000; // 获取当前时间（秒）
    let delta = now - lastFrameTime; // 计算与上一帧的时间差（秒）
    lastFrameTime = now;   // 更新上一帧时间为当前时间

    // 清空画布.

    context.clearRect(0, 0, context.width, context.height);

    // Center the skeleton and resize it so it fits inside the canvas.
    skeleton.x = context.width / 2;  // 将骨骼水平居中（Canvas 宽度的一半）
    skeleton.y = context.height - context.height * 0.1; // 垂直位置：靠近 Canvas 底部（留 10% 边距）
    let scale = context.height / bounds.height * 0.8; // 计算缩放比例（基于 Canvas 高度和动画边界框高度）
    skeleton.scaleX = scale; // 水平缩放
    skeleton.scaleY = -scale; // 垂直缩放（负值表示 Y 轴翻转，使动画朝上）

    // Update and apply the animation state, update the skeleton's
    // world transforms and render the skeleton.
    animationState.update(delta);  // 更新动画状态（根据时间差推进动画）
    animationState.apply(skeleton);  // 将动画状态应用到骨骼（更新骨骼的骨骼变换）
    skeleton.updateWorldTransform(Physics.update);  // 更新骨骼的全局变换
    skeletonRenderer.draw(skeleton); //渲染骨骼到 Canvas

    let result: Delay = { time: lastFrameTime, isFinish: true };
    return result;
  }
}

```
### 渲染流程
- 1.animationState.update(delta)：推进动画时间线。
- 2.animationState.apply(skeleton)：将动画数据应用到骨骼。
- 3.skeleton.updateWorldTransform：计算骨骼的全局变换矩阵（如位置、旋转、缩放）。
- 4.skeletonRenderer.draw：最终将骨骼绘制到 Canvas 上。

## 使用说明

### 前提：数据准备



### 1.在相应的类中引入组件：

```
import {
  AssetManager,
  AtlasAttachmentLoader,
  AnimationState,
  AnimationStateData,
  SkeletonRenderer,
  SkeletonJson,
  Skeleton,
  TextureAtlas,
  Physics,
  Delay,
  Bound
} from '@ohos/spine'
```

### 2.构建渲染上下文

```
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private mainCanvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings)
```


### 3.关联画布

```
       Canvas(this.mainCanvasRenderingContext)
        .width('100%')
        .height(200)
        .backgroundColor(Color.Gray)
        .onReady(()=>{
       
        })
```

### 5.加载数据

#### 1. 初始化骨骼渲染器
```
      let skeletonRenderer = new SkeletonRenderer(this.canvasRenderingContext);

```

- 作用：创建一个 SkeletonRenderer 实例，用于将 Spine 骨骼动画渲染到 Canvas 上。
- 参数：this.canvasRenderingContext 是 Canvas 的 2D 渲染上下文。

#### 2. 加载动画资源

```
      let assetManager = new AssetManager("animation/");
      assetManager.loadText("spineboy-ess.json");
      assetManager.loadTextureAtlas("spineboy.atlas");
      await assetManager.loadAll();

```
- 流程：
- 1. 创建 AssetManager 实例，指定资源根路径为 "animation/"。
- 2. 加载 Spine 动画数据文件（spineboy-ess.json）和纹理图集（spineboy.atlas）。
- 3. await assetManager.loadAll() 等待所有资源异步加载完成。


#### 3. 创建纹理图集和骨骼数据
```
      let atlas: TextureAtlas = assetManager.require("spineboy.atlas");
      let atlasLoader = new AtlasAttachmentLoader(atlas);
      let skeletonJson = new SkeletonJson(atlasLoader);
      let skeletonData = skeletonJson.readSkeletonData(assetManager.require("spineboy-ess.json"));

```

- 流程：
- 1. 从 AssetManager 获取已加载的纹理图集（TextureAtlas）。
- 2. 创建 AtlasAttachmentLoader，用于从图集中加载附件（如纹理、区域）。
- 3. 创建 SkeletonJson 解析器，用于读取 Spine JSON 数据。
- 4. 解析 spineboy-ess.json 文件，生成 skeletonData（骨骼动画数据）。


#### 4. 初始化骨骼实例
```
      let skeleton = new Skeleton(skeletonData);
      skeleton.setToSetupPose();
      skeleton.updateWorldTransform(Physics.update);
      let bounds = skeleton.getBoundsRect();

```
- 流程：
- 1. 根据 skeletonData 创建 Skeleton 实例。
- 2. setToSetupPose() 将骨骼重置为初始姿势。
- 3. updateWorldTransform(Physics.update) 更新骨骼的全局变换。
- 4. getBoundsRect() 获取动画的边界框（用于后续缩放和居中）。

#### 5. 配置动画状态
```
      let animationStateData = new AnimationStateData(skeleton.data);
      animationStateData.defaultMix = 0.2;
      this.animationState = new AnimationState(animationStateData);
```
- 流程：
- 1. 创建 AnimationStateData，绑定骨骼数据。
- 2. 设置默认动画混合时间为 0.2 秒（用于动画过渡）。
- 3. 创建 AnimationState 实例，管理动画播放状态。

#### 6. 初始化动画控制器
```
      let lastFrameTime = Date.now() / 1000;
      if (this._animator) {
        this._animator.finish();
      }
      let options: AnimatorOptions = {
        duration: 20000,
        easing: 'linear',
        delay: 0,
        fill: 'forwards',
        direction: 'normal',
        iterations: -1,
        begin: 0,
        end: 1
      };
      let expectedFrameRate: ExpectedFrameRateRange = {
        min: 0,
        max: 120,
        expected: 60
      }
```
- 流程：
- 1. 记录当前时间戳（用于计算帧间隔）。
- 2. 如果已有动画控制器（this._animator），先停止它。
- 3. 定义动画控制器的配置选项（AnimatorOptions）：duration: 20000：动画总时长（20 秒）；iterations: -1：无限循环；其他选项（缓动、延迟、填充模式等）。
- 4. 定义期望的帧率范围（ExpectedFrameRateRange）。


#### 4. 创建并启动动画控制器
```
      this._animator = animator.create(options);
      this._animator.setExpectedFrameRateRange(expectedFrameRate);
      let result: Delay = { time: lastFrameTime, isFinish: true };
      this._animator.onFrame = (value: number) => {
        if (result.isFinish) {
          result.isFinish = false;
          result = this.render(this.canvasRenderingContext, result.time, skeleton, this.animationState!, skeletonRenderer, bounds);
        }
      }
      this._animator.play();

```
- 流程：
- 1. 创建动画控制器实例（animator.create），传入配置选项。
- 2. 设置期望的帧率范围。
- 3. 初始化 result 对象，记录时间戳和完成状态。
- 4. 绑定 onFrame 回调函数：当动画控制器触发新帧时，调用 this.render 方法渲染动画。 result.isFinish 防止重复渲染同一帧
- 5. this._animator.play() 启动动画控制器。

    

### 9.关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望spine库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/spine
```



## 接口说明
| class | Name             | Parameter  | Description             |
|-------|------------------|------------|-------------------------|
|  AssetManager     | loadText         | path       | 加载 Spine 动画所需的 文本 数据文件  |
|  AssetManager     | loadBinary       | path       | 加载 Spine 动画所需的 二进制 数据文件 |
|  AssetManager     | loadTextureAltas | path       | 加载纹理图集文件                |
|  AssetManager     | require          | path       | 从assets数组中获取数据          |
|  AnimationState   | update           | delta      | 更新动画状态                  |
|  AnimationState   | apply            | skeleton   | 将动画状态应用到骨骼              |
|  SkeletonRenderer | draw             | 无         | 动画渲染                    |
| Skeleton  | setToSetupPose            | 无         | 将骨骼、约束和插槽设置为其设置姿势值      |
| Skeleton  | updateWorldTransform      |  physics      | 更新每个骨骼的世界变换并应用所有约束      |
| Skeleton  | getBoundsRect             | clipper       | 将当前姿势的区域和网格附件的轴对齐边界框并返回 |
| SkeletonJson  | readSkeletonData      | json         | 读取并解析骨骼动画数据文件，生成 skeletonData     |

## 约束与限制

在下述版本验证通过：
- DevEco Studio: NEXT Developer Beta3(5.0.3.524), SDK: API12(5.0.0.25)
- DevEco Studio: NEXT Developer Beta1(5.0.3.122), SDK: API12(5.0.0.18)

## 目录结构

````
/SpineArkTS        # 项目根目录
├── entry      # 示例代码文件夹
├── library    # lottie库文件夹
│    └─ src/main/ets   # 核心代码，包含json解析，动画绘制，操作动画
│          └─ spine-canvas    #是 Spine 动画系统在 Canvas 2D 渲染环境下的实现库
│          └─ spine-core  # 负责处理 Spine 动画的基本数据结构和逻辑，包含了骨骼动画的核心算法、数据解析、状态管理等功能                 
├── README.md     # 安装使用方法    
                   
````

## 贡献代码

使用过程中发现任何问题都可以提交 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)，当然，也非常欢迎提交 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目遵循 [Apache-2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Spine/LICENSE)。
