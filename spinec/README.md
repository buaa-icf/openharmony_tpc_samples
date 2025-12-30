# spine-c

#### 介绍
spinec是一套用C语言编写的程序库，负责在C/C++程序（如游戏引擎、应用）中加载、操控和渲染由Spine编辑器制作的骨骼动画数据。

#### 安装教程

```shell
ohpm install @ohos/spinec
```

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

#### 使用说明

 ``` 
 import { Spine } from '@ohos/spinec';
 ```

## 渲染流程
- 应用启动 → 页面初始化 → XComponent初始化 → 资源加载 → 动画控制 → 资源清理

### 1.组件初始化阶段：
应用启动时初始化Spine运行环境和后台监控
```
aboutToAppear(): void {
  Spine.initResourceManager(context.resourceManager);
  this.startIdleDetection();
}
```
### 2.XComponent初始化阶段：
创建动画渲染画布，等待用户操作
```
.onLoad((context) => {
  Spine.registerXComponent(XCOMPONENT_ID);
  setTimeout(() => {
    this.isXComponentReady = true;
    this.message = '点击"加载骨骼"按钮';
  }, 500);
})
```
### 3.加载骨骼按钮点击：
处理用户点击，防止重复加载，管理加载状态
```
loadSpineSkeleton(): void {
  if (this.isLoading) {
    this.message = '正在加载中，请稍候...';
    return;
  }
  
  if (this.isLoaded) {
    this.cleanupBeforeReload();
  }
  
  this.isLoading = true;
  this.doLoadSkeleton();
}
```
### 4.实际加载骨骼数据：
从文件系统加载Spine动画资源，配置初始参数
```
doLoadSkeleton(): void {
  const success: boolean = Spine.loadSkeleton(
    XCOMPONENT_ID,
    'spineboy',
    'spine/spineboy.atlas',
    'spine/spineboy.json',
    1
  );
  
  if (success) {
    this.isLoaded = true;
    this.animationList = Spine.getAnimations(XCOMPONENT_ID, 'spineboy');
    Spine.setPosition(XCOMPONENT_ID, 'spineboy', 540, 200);
    Spine.setScale(XCOMPONENT_ID, 'spineboy', 0.5, 0.5);
    this.playAnimation(this.animationList[0]);
  }
}
```
### 5.播放动画流程：
切换并播放指定动画，启动渲染循环
```
playAnimation(animName: string): void {
  Spine.setAnimation(XCOMPONENT_ID, 'spineboy', 0, animName, true);
  this.currentAnimation = animName;
  this.startRenderLoop();
}
```
### 6.渲染循环：
以60fps刷新画面，确保动画流畅播放
```
startRenderLoop(): void {
  this.renderTimer = setInterval(() => {
    Spine.renderFrame(XCOMPONENT_ID);
  }, 16);
}
```
### 7.释放资源：
清理动画实例，重置界面，节约内存
```
autoReleaseResources(): void {
  this.stopRenderLoop();
  Spine.removeInstance(XCOMPONENT_ID, 'spineboy');
  this.isLoaded = false;
  this.animationList = [];
  this.loadedInstanceName = null;
}
```
### 8.错误处理：
安全清理资源，防止异常情况下的内存泄漏
```
private safeCleanupSpineResources(): void {
  try {
    Spine.removeInstance(XCOMPONENT_ID, this.loadedInstanceName);
  } catch (error) {
  }
}

private setTimeoutSafe(callback: () => void, delay: number): number {
  const timerId = setTimeout(() => {
    if (this.isDestroyed) { return; }
    callback();
  }, delay);
  return timerId;
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

## 注意

- spinec库有严格的版本检查，使用该库请使用4.2版本的资源。
- 建议使用 .json 格式的动画资源，不推荐使用 .skel 格式，因其在播放时可能存在兼容性或稳定性问题。

## 约束与限制

在下述版本验证通过：
- DevEco Studio: NEXT Release(6.0.1.251), SDK: API12 (5.0.0.71)
- DevEco Studio: NEXT Developer Beta(6.0.1), SDK: API12 (5.0.0.25)

## 目录结构

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
