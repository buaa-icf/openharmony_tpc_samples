# GSYVideoPlayer

## 简介

GSYVideoPlayer 是一个视频播放器库，支持切换内核播放器（IJKPlayer、avplayer），并且支持视频截图能力、视频生成 GIF 能力、边播边缓存能力、视频全屏能力等多种能力。

## 效果展示

![gif](screenshot/gsyvideoplayer.gif)

## 下载安装

```bash
ohpm install @ohos/gsyvideoplayer
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)。

## 使用说明

### 规格说明

目前支持音视频规格：
由于本库播放音视频能力底层是 avplayer 或者 ijkplayer 去播放视频，所以支持的音视频规格跟随这两个库音视频规格。

*   [avplayer规格说明](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-kit/js-apis-media.md#avplayer9)
*   [ijkplayer规格说明](https://gitcode.com/openharmony-sig/ohos_ijkplayer/blob/master/README.md)

### 使用标准播放器

#### 1. 设置内核播放器

可以在视频播放之前选择使用 avplayer 或者 ijkplayer 去播放视频。

```typescript
import { GlobalContext } from '@ohos/gsyvideoplayer';

aboutToAppear() {
  GlobalContext.getContext().setObject("playType", PlayerType.SYSTEM_AVPLAYER);
}
```

#### 2. 构建 StandardGSYVideoModel 对象

```typescript
videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();

aboutToAppear() {
  // 设置播放的url，设置播放不缓存
  this.videoModel.setUrl(this.videoUrl, false);
  this.videoModel.setTitle("这是测试视频的标题");
  this.videoModel.setBackClickListener(this.backClickListener);
  this.videoModel.setFullClickListener(this.fullClickListener);
  this.videoModel.setCoverImage($r('app.media.app_icon'));
}
```

#### 3. 在 UI 中使用 StandardGSYVideoPlayer 组件

在界面 `build()` 中使用 `StandardGSYVideoPlayer` 组件，并传入 `StandardGSYVideoModel` 对象。

```typescript
build() {
  Row() {
    Column() {
      StandardGSYVideoPlayer({
        videoModel: this.videoModel
      }).height(this.screenHeight)
    }.width('100%')
  }
}
```

#### 4. 在页面生命周期中控制播放器状态

在 `@Entry` 标签的界面生命周期中需要控制播放器的播放状态。

```typescript
aboutToDisappear() {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    player.stop();
  }
}

onPageShow() {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    player.resumePlay();
  }
}

onPageHide() {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    player.pause();
  }
}
```

### 视频截图能力

```typescript
Button("点击截图").onClick(() => {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    let path = getContext(this).cacheDir + "/test.jpeg";
    player.saveFrame(path, {
      shotResult(code: number) {
        promptAction.showToast({
          message: code == 0 ? "截图操作成功" : "截图操作失败"
        });
      }
    })
  }
})
```

### 视频生成 GIF 能力

```typescript
Button("startGif").onClick(() => {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    let path = getContext(this).cacheDir + "/tempGif";
    player.startGif(path);
    promptAction.showToast({
      message: "开始gif截图"
    });
  }
})

Button("stopGif").onClick(() => {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    this.dialogController.open();
    let path = getContext(this).cacheDir + "/gifTest.gif";
    let that = this;
    player.stopGif(path, {
      gifResult(code: number) {
        that.dialogController.close();
        promptAction.showToast({
          message: code == 0 ? "gif截图成功" : "gif截图失败"
        });
      }
    })
  }
})
```

### 边播边缓存能力

可以在构建 `StandardGSYVideoModel` 对象时，控制是否需要边播边缓存。

```typescript
videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();

aboutToAppear() {
  // 设置播放的url，设置播放不缓存
  this.videoModel.setUrl(this.videoUrl, false);
}
```

### 视频全屏能力

可以在构建 `StandardGSYVideoModel` 对象时，设置全屏回调接口，全屏逻辑由用户控制。

```typescript
fullClickListener: () => void = () => {

}

videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();

aboutToAppear() {
  // 设置播放的url，设置播放不缓存
  this.videoModel.setUrl(this.videoUrl, false);
  this.videoModel.setFullClickListener(this.fullClickListener);
}
```

## 接口说明

### StandardGSYVideoModel

| 方法名 | 入参 | 接口描述 |
| :--- | :--- | :--- |
| `setUrl(videoUrl: string, cacheWithPlay?: boolean)` | `videoUrl: string`, `cacheWithPlay?: boolean` | 设置播放 url,设置是否边播边缓存 |
| `setTitle(title: string)` | `title: string` | 设置视频全屏时的标题 |
| `setBackClickListener(backClickListener: () => void)` | `backClickListener: () => void` | 设置点击播放器返回按钮的回调接口 |
| `setFullClickListener(fullClickListener: () => void)` | `fullClickListener: () => void` | 设置点击播放器全屏按钮的回调接口 |
| `setCoverImage(coverImage:Resource)` | `coverImage:Resource` | 设置封面接口 |

### IVideoPlayer

| 方法名 | 入参 | 接口描述 |
| :--- | :--- | :--- |
| `play()` | 无 | 视频开始播放 |
| `resumePlay()` | 无 | 视频恢复播放 |
| `pause()` | 无 | 视频暂停播放 |
| `stop()` | 无 | 视频停止播放 |
| `saveFrame(fileSavePath: string, listener: GSYVideoShotSaveListener)` | `fileSavePath: string`, `listener: GSYVideoShotSaveListener` | 视频截图 |
| `startGif(tmpPicPath?: string)` | `tmpPicPath?: string` | 视频开始 gif |
| `stopGif(saveGifPath: string, listener: GSYVideoGifSaveListener)` | `saveGifPath: string`, `listener: GSYVideoGifSaveListener` | 视频结束 gif,并生成 gif |

## 关于混淆

-   代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)。
-   如果希望 gsyvideoplayer 库在代码混淆过程中不会被混淆，需要在混淆规则配置文件 `obfuscation-rules.txt` 中添加相应的排除规则：

```
-keep 
./oh_modules/@ohos/gsyvideoplayer
```

## 约束与限制

在下述版本验证通过：

*   DevEco Studio: NEXT Developer Beta1(5.0.3.326), SDK: API12 (5.0.0.25)。
*   DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)。

## 目录结构

```
|---- GSYVideoPlayer  
|     |---- entry  # 示例代码文件夹
            |---- pages
                |---- BiliDanmukuParser.ets  # 弹幕解析类
                |---- DanmakuData.ets  # 弹幕数据
                |---- DanmakuVideoDemo.ets  # 弹幕demo
                |---- DanmakuVideoPlayer.ets  # 弹幕播放器
                |---- Index.ets  # 首页
                |---- PlayNetWithCacheDemo.ets  # 边播放边缓存demo
                |---- PlayNetWithNoCacheDemo.ets  # 边播放不缓存demo
                |---- PlayWithCacheDemo.ets  # 播放缓存入口
                |---- SimpleDemo.ets  # 简单播放测试demo
                |---- SimpleList.ets  # 简单视频列表demo
|     |---- library  # GSYVideoPlayer核心代码
            |---- listener  # 接口回调类
                |---- GSYVideoGifSaveListener.ets  # stopGif接口回调类
                |---- GSYVideoShotSaveListener.ets  # 截图接口回调类
            |---- mainpage  # 核心实现
                |---- AvPlayerControl.ets  # avplayer逻辑控制类
                |---- AvVideoPlayer.ets  # avplayer播放器
                |---- BaseVideoPlayer.ets  # 播放器控制基类
                |---- CommonConstants.ets # 常量类
                |---- GlobalContext.ts  # 全局配置类
                |---- IjkPlayerControl.ets  # ijkplayer逻辑控制类
                |---- IjkVideoPlayer.ets  # ijkplayer播放器
                |---- StandardForListGSYVideoPlayer.ets  # 为list页面使用的播放器
                |---- StandardGSYVideoModel.ets  # 播放器数据配置类
                |---- StandardGSYVideoPlayer.ets  # 标准播放器
            |---- utils  # 工具类
                |---- OrientationUtil.ets  # 屏幕方向控制类
                |---- LogUtils.ets  # log工具类
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)给我们，当然，我们也非常欢迎你给我们提 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)。

## 开源协议

本项目基于 [Apache License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/GSYVideoPlayer/LICENSE)，请自由地享受和参与开源。