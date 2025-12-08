# spine-c

#### 介绍
是一套用C语言编写的程序库，负责在你的C/C++程序（如游戏引擎、应用）中加载、操控和渲染由Spine编辑器制作的骨骼动画数据。

#### 安装教程

```shell
ohpm install @ohos/spinec
```

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

#### 使用说明

 ``` 
 import { Spine} from '@ohos/spinec';
 ```

## 使用示例
### 完整示例
 ``` 
// 导入所需的HarmonyOS模块：Spine骨骼动画库和日志工具
import { Spine} from '@ohos/spinec';
import { hilog } from '@kit.PerformanceAnalysisKit';

// 定义常量：渲染组件的唯一ID和日志标签
const XCOMPONENT_ID = 'spineXComponent';  // 用于XComponent绑定的标识符
const LOG_TAG = 'SpineDemo';              // 日志过滤标签

// @Entry装饰器标记此组件为页面入口组件
// @Component声明这是一个自定义组件
@Entry
@Component
struct Index {
  // 私有属性：存储XComponent的Native渲染上下文对象
  private xComponentContext: object | undefined = undefined;
  
  // @State装饰的响应式数据：
  @State currentAnimation: string = '';          // 当前播放的动画名称
  @State animationList: string[] = [];          // 动画名称列表
  @State isLoaded: boolean = false;             // 骨骼数据是否已加载
  @State isXComponentReady: boolean = false;    // XComponent是否准备就绪
  @State message: string = '等待 XComponent 初始化...';  // 页面状态提示信息

  // XComponent控制器，用于管理XComponent生命周期
  private xComponentController: XComponentController = new XComponentController();
  // 动画渲染定时器ID，-1表示未启动
  private renderTimer: number = -1;

  // 生命周期：组件即将显示时调用
  aboutToAppear(): void {
    hilog.info(0, LOG_TAG, 'aboutToAppear - initializing resource manager');
    // 获取当前组件上下文
    const context = getContext(this);
    // 初始化Spine资源管理器，传入应用的resourceManager用于访问rawfile资源
    const result : boolean = Spine.initResourceManager(context.resourceManager);
    hilog.info(0, LOG_TAG, 'initResourceManager result: %{public}s', String(result));
  }

  // 生命周期：组件即将消失时调用（清理资源）
  aboutToDisappear(): void {
    hilog.info(0, LOG_TAG, 'aboutToDisappear - cleanup');
    // 1. 停止渲染循环定时器
    if (this.renderTimer !== -1) {
      clearInterval(this.renderTimer);  // 清除定时器
      this.renderTimer = -1;           // 重置定时器ID
    }

    // 2. 移除Spine实例（如果已加载）
    if (this.isLoaded) {
      try {
        // 根据XComponent ID和实例名移除Spine实例
        Spine.removeInstance(XCOMPONENT_ID, 'spineboy');
        hilog.info(0, LOG_TAG, 'Spine instance removed');
      } catch (error) {
        hilog.error(0, LOG_TAG, 'Error removing Spine instance: %{public}s', String(error));
      }
      this.isLoaded = false;  // 更新加载状态
    }
  }

  // 加载Spine骨骼动画的主入口函数
  loadSpineSkeleton(): void {
    hilog.info(0, LOG_TAG, 'loadSpineSkeleton called');
    hilog.info(0, LOG_TAG, 'isXComponentReady: %{public}s', String(this.isXComponentReady));
    hilog.info(0, LOG_TAG, 'isLoaded: %{public}s', String(this.isLoaded));

    // 检查1：确保XComponent已准备就绪（Native层渲染上下文可用）
    if (!this.isXComponentReady) {
      this.message = 'XComponent 尚未就绪，请稍候...';
      hilog.warn(0, LOG_TAG, 'XComponent not ready yet');
      return;  // 提前返回
    }

    // 检查2：避免重复加载
    if (this.isLoaded) {
      this.message = '已加载';
      return;
    }

    this.message = '正在加载...';

    // 延迟100ms执行，确保EGL渲染上下文完全初始化
    setTimeout(() => {
      this.doLoadSkeleton();  // 实际加载逻辑
    }, 100);
  }

  // 实际执行骨骼加载的私有方法
  doLoadSkeleton(): void {
    try {
      hilog.info(0, LOG_TAG, 'Calling Spine.loadSkeleton...');
      hilog.info(0, LOG_TAG, 'XCOMPONENT_ID: %{public}s', XCOMPONENT_ID);

      // 关键调用：加载Spine骨骼动画数据
      const success : boolean = Spine.loadSkeleton(
        XCOMPONENT_ID,           // 绑定的XComponent ID（用于渲染目标）
        'spineboy',              // 实例名称（一个XComponent可包含多个Spine实例）
        'spine/spineboy.atlas',  // 图集文件路径（位于rawfile/spine/目录）
        'spine/spineboy.json',   // 骨骼定义文件路径（位于rawfile/spine/目录）
        0.5                      // 缩放比例（调整动画显示大小）
      );

      hilog.info(0, LOG_TAG, 'loadSkeleton result: %{public}s', String(success));

      if (success) {
        this.isLoaded = true;  // 更新加载状态
        this.message = '加载成功！';

        // 获取当前骨骼实例的所有动画名称列表
        this.animationList = Spine.getAnimations(XCOMPONENT_ID, 'spineboy') as string[];
        hilog.info(0, LOG_TAG, 'Animations count: %{public}d', this.animationList.length);

        // 设置骨骼在屏幕上的位置（坐标系原点通常为屏幕中心）
        Spine.setPosition(XCOMPONENT_ID, 'spineboy', 540, 200);  // 坐标(540, 200)

        // 默认播放第一个动画
        if (this.animationList.length > 0) {
          this.playAnimation(this.animationList[0]);
        }

        // 启动渲染循环（连续帧更新）
        this.startRenderLoop();
      } else {
        this.message = '加载失败，请查看日志';
        hilog.error(0, LOG_TAG, 'loadSkeleton returned false');
      }
    } catch (error) {
      this.message = `加载错误: ${error}`;
      hilog.error(0, LOG_TAG, 'loadSkeleton exception: %{public}s', String(error));
    }
  }

  // 播放指定名称的动画
  playAnimation(animName: string): void {
    if (!this.isLoaded) { return; }  // 安全检查

    // 参数说明：轨道索引0、动画名称、是否循环播放（true）
    Spine.setAnimation(XCOMPONENT_ID, 'spineboy', 0, animName, true);
    this.currentAnimation = animName;  // 更新当前动画状态
  }

  // 启动渲染循环（模拟游戏循环）
  startRenderLoop(): void {
    if (this.renderTimer !== -1) { return; }  // 防止重复启动

    // 设置定时器，每16ms执行一次（约60fps）
    this.renderTimer = setInterval(() => {
      Spine.renderFrame(XCOMPONENT_ID);  // 通知Spine渲染当前帧
    }, 16);
  }
  
  // 组件UI构建函数（声明式UI描述）
  build() {
    // 垂直布局容器
    Column() {
      // 标题文本
      Text('Spine 鸿蒙示例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      // 状态提示文本
      Text(this.message)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 10 })

      // XComponent就绪状态指示器
      Text(`XComponent: ${this.isXComponentReady ? '就绪' : '等待中'}`)
        .fontSize(12)
        .fontColor(this.isXComponentReady ? '#00AA00' : '#FF6600')
        .margin({ bottom: 5 })

      // 核心：XComponent渲染组件
      XComponent({
        id: XCOMPONENT_ID,  // 必须与上面定义的常量一致
        type: XComponentType.SURFACE,  // 渲染表面类型
        libraryname: 'Spine',  // 关键：指定Native动态库名称（libSpine.so）
        controller: this.xComponentController  // 传入控制器
      })
        .width('100%')
        .height('60%')
        .backgroundColor('#333333')  // 深灰色背景
        .onLoad((context) => {  // XComponent加载完成回调
          hilog.info(0, LOG_TAG, 'XComponent onLoad called');
          this.xComponentContext = context;  // 保存Native上下文
          
          // 注册XComponent到Spine运行时
          const regResult : boolean = Spine.registerXComponent(XCOMPONENT_ID);
          hilog.info(0, LOG_TAG, 'registerXComponent result: %{public}s', String(regResult));
          
          // 延迟设置就绪状态，确保Native层初始化完成
          setTimeout(() => {
            this.isXComponentReady = true;
            this.message = '点击"加载骨骼"按钮';
            hilog.info(0, LOG_TAG, 'XComponent is ready');
          }, 500);  // 500ms延迟
        })

      // 按钮控制行
      Row() {
        // 加载骨骼按钮
        Button('加载骨骼')
          .onClick(() => {
            this.loadSpineSkeleton();  // 点击触发加载
          })
          .margin(5)

        // 手动刷新按钮
        Button('刷新')
          .onClick(() => {
            if (this.isLoaded) {
              Spine.renderFrame(XCOMPONENT_ID);  // 单次渲染
            }
          })
          .margin(5)
      }
      .margin({ top: 10 })

      // 当前动画显示区域
      if (this.currentAnimation) {
        Text(`当前动画: ${this.currentAnimation}`)
          .fontSize(14)
          .margin({ top: 10 })
      }

      // 动画列表选择区域
      if (this.animationList.length > 0) {
        Text('可用动画:')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 15, bottom: 5 })

        // 可滚动容器
        Scroll() {
          // 弹性布局（自动换行）
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
            // 循环渲染每个动画按钮
            ForEach(this.animationList, (anim: string) => {
              Button(anim)
                .fontSize(12)
                .height(32)
                // 条件样式：当前播放的动画按钮高亮
                .backgroundColor(this.currentAnimation === anim ? '#007AFF' : '#E0E0E0')
                .fontColor(this.currentAnimation === anim ? '#FFFFFF' : '#333333')
                .margin(3)
                .onClick(() => {
                  this.playAnimation(anim);  // 点击播放动画
                })
            })
          }
          .width('100%')
        }
        .height(100)  // 固定高度区域
        .scrollBar(BarState.Auto)  // 自动显示滚动条
      }
    }
    .width('100%')
    .height('100%')
    .padding(10)
  }
}
 ```

## 接口说明

| 接口名         | 参数                               | 返回值          | 说明        |
| -------------- | ---------------------------------- | --------------- | ----------- |
| initResourceManager| resourceManager: object | boolean | 初始化资源管理器 |
| registerXComponent| xComponentId: string | boolean | 注册 XComponent |
| loadSkeleton| xComponentId: string,instanceName: string,atlasPath: string,skeletonPath: string,scale: number | boolean | 加载 Spine 骨骼 |
| setAnimation| xComponentId: string,instanceName: string,trackIndex: number,animationName: string,loop: boolean | boolean | 设置动画 |
| setPosition| xComponentId: string,instanceName: string,x: number,y: number | void| 设置位置 |
| setScale| xComponentId: string,instanceName: string,scaleX: number,scaleY: number | void| 设置缩放 |
| renderFrame| xComponentId?: string | void| 渲染一帧 |
| getAnimations| xComponentId: string, instanceName: string | string[]| 获取动画列表 |
| removeInstance| xComponentId: string, instanceName: string | void| 移除实例 |

在下述版本验证通过：
- DevEco Studio: NEXT Release(6.0.1.251), SDK: API12 (5.0.0.71)
- DevEco Studio: NEXT Developer Beta(6.0.1), SDK: API12 (5.0.0.25)

````
|---- spinec
|     |---- entry  # 示例代码文件夹
|     |---- spinec  # spinec库文件夹
|         |---- src
|             |---- main
|                  |---- ets
|                       |---- index.ts  #spinec
|         |---- index.ts  # 对外接口
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提交 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)，当然，也非常欢迎提交 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目遵循 [Spine Runtimes License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/spinec/LICENSE)。
