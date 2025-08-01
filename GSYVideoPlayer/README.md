# GSYVideoPlayer

## Introduction

GSYVideoPlayer is a video player library that supports switching between kernel players (IJKPlayer, avplayer). It also provides capabilities such as video frame capturing, GIF generation from videos, playing with caching, and full-screen video playback.

## Demo

![gif](screenshot/gsyvideoplayer.gif)

## Download and Installation

```bash
ohpm install @ohos/gsyvideoplayer
```

For more information on OpenHarmony ohpm environment configuration, please refer to [How to install OpenHarmony ohpm packages](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md).

## Usage Guide

### Specification Description

Currently supported audio and video specifications:
Since the underlying audio and video playback capabilities of this library rely on avplayer or ijkplayer, the supported audio and video specifications follow those of these two libraries.

*   [avplayer specification](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-kit/js-apis-media.md#avplayer9)
*   [ijkplayer specification](https://gitcode.com/openharmony-sig/ohos_ijkplayer/blob/master/README.md)

### Using the Standard Player

#### 1. Set the Kernel Player

Before video playback, you can choose to use avplayer or ijkplayer as the video playback kernel.

```typescript
import { GlobalContext } from '@ohos/gsyvideoplayer';

aboutToAppear() {
  GlobalContext.getContext().setObject("playType", PlayerType.SYSTEM_AVPLAYER);
}
```

#### 2. Build StandardGSYVideoModel Object

```typescript
videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();

aboutToAppear() {
  // Set the playback URL, set not to cache during playback
  this.videoModel.setUrl(this.videoUrl, false);
  this.videoModel.setTitle("This is the title of the test video");
  this.videoModel.setBackClickListener(this.backClickListener);
  this.videoModel.setFullClickListener(this.fullClickListener);
  this.videoModel.setCoverImage($r('app.media.app_icon'));
}
```

#### 3. Use StandardGSYVideoPlayer Component in UI

In the UI's `build()` method, use the `StandardGSYVideoPlayer` component and pass the `StandardGSYVideoModel` object.

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

#### 4. Control Player State in Page Lifecycle

The playback state of the player needs to be controlled within the page lifecycle indicated by the `@Entry` tag.

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

### Video Screenshot Capability

```typescript
Button("Click to Screenshot").onClick(() => {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    let path = getContext(this).cacheDir + "/test.jpeg";
    player.saveFrame(path, {
      shotResult(code: number) {
        promptAction.showToast({
          message: code == 0 ? "Screenshot successful" : "Screenshot failed"
        });
      }
    })
  }
})
```

### Video to GIF Capability

```typescript
Button("startGif").onClick(() => {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    let path = getContext(this).cacheDir + "/tempGif";
    player.startGif(path);
    promptAction.showToast({
      message: "Starting GIF capture"
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
          message: code == 0 ? "GIF capture successful" : "GIF capture failed"
        });
      }
    })
  }
})
```

### Play-while-caching Capability

You can control whether to enable play-while-caching when building the `StandardGSYVideoModel` object.

```typescript
videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();

aboutToAppear() {
  // Set the playback URL, set not to cache during playback
  this.videoModel.setUrl(this.videoUrl, false);
}
```

### Video Full-screen Capability

When building the `StandardGSYVideoModel` object, you can set a full-screen callback interface, and the full-screen logic will be controlled by the user.

```typescript
fullClickListener: () => void = () => {

}

videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();

aboutToAppear() {
  // Set the playback URL, set not to cache during playback
  this.videoModel.setUrl(this.videoUrl, false);
  this.videoModel.setFullClickListener(this.fullClickListener);
}
```

## API Reference

### StandardGSYVideoModel

| Method Name | Parameters | Description |
| :--- | :--- | :--- |
| `setUrl(videoUrl: string, cacheWithPlay?: boolean)` | `videoUrl: string`, `cacheWithPlay?: boolean` | Sets the playback URL and whether to cache during playback |
| `setTitle(title: string)` | `title: string` | Sets the title when the video is full screen |
| `setBackClickListener(backClickListener: () => void)` | `backClickListener: () => void` | Sets the callback interface for the player's back button click |
| `setFullClickListener(fullClickListener: () => void)` | `fullClickListener: () => void` | Sets the callback interface for the player's full-screen button click |
| `setCoverImage(coverImage:Resource)` | `coverImage:Resource` | Sets the cover image interface |

### IVideoPlayer

| Method Name | Parameters | Description |
| :--- | :--- | :--- |
| `play()` | None | Starts video playback |
| `resumePlay()` | None | Resumes video playback |
| `pause()` | None | Pauses video playback |
| `stop()` | None | Stops video playback |
| `saveFrame(fileSavePath: string, listener: GSYVideoShotSaveListener)` | `fileSavePath: string`, `listener: GSYVideoShotSaveListener` | Captures a video frame |
| `startGif(tmpPicPath?: string)` | `tmpPicPath?: string` | Starts GIF capture |
| `stopGif(saveGifPath: string, listener: GSYVideoGifSaveListener)` | `saveGifPath: string`, `listener: GSYVideoGifSaveListener` | Stops GIF capture and generates GIF |

## About Obfuscation

-   For code obfuscation, please refer to [Code Obfuscation Introduction](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md).
-   If you want the gsyvideoplayer library to not be obfuscated during the code obfuscation process, you need to add the corresponding exclusion rule in the `obfuscation-rules.txt` configuration file:

```
-keep 
./oh_modules/@ohos/gsyvideoplayer
```

## Constraints and Limitations

Verified in the following versions:

*   DevEco Studio: NEXT Developer Beta1(5.0.3.326), SDK: API12 (5.0.0.25).
*   DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66).

## Directory Structure

```
|---- GSYVideoPlayer  
|     |---- entry  # Example code folder
            |---- pages
                |---- BiliDanmukuParser.ets  # Danmaku parsing class
                |---- DanmakuData.ets  # Danmaku data
                |---- DanmakuVideoDemo.ets  # Danmaku demo
                |---- DanmakuVideoPlayer.ets  # Danmaku player
                |---- Index.ets  # Home page
                |---- PlayNetWithCacheDemo.ets  # Play with cache demo
                |---- PlayNetWithNoCacheDemo.ets  # Play without cache demo
                |---- PlayWithCacheDemo.ets  # Play cache entry
                |---- SimpleDemo.ets  # Simple playback test demo
                |---- SimpleList.ets  # Simple video list demo
|     |---- library  # GSYVideoPlayer core code
            |---- listener  # Interface callback classes
                |---- GSYVideoGifSaveListener.ets  # stopGif interface callback class
                |---- GSYVideoShotSaveListener.ets  # Screenshot interface callback class
            |---- mainpage  # Core implementation
                |---- AvPlayerControl.ets  # avplayer logic control class
                |---- AvVideoPlayer.ets  # avplayer player
                |---- BaseVideoPlayer.ets  # Player control base class
                |---- CommonConstants.ets # Constant class
                |---- GlobalContext.ts  # Global configuration class
                |---- IjkPlayerControl.ets  # ijkplayer logic control class
                |---- IjkVideoPlayer.ets  # ijkplayer player
                |---- StandardForListGSYVideoPlayer.ets  # Player used for list pages
                |---- StandardGSYVideoModel.ets  # Player data configuration class
                |---- StandardGSYVideoPlayer.ets  # Standard player
            |---- utils  # Utility classes
                |---- OrientationUtil.ets  # Screen orientation control class
                |---- LogUtils.ets  # Log utility class
|     |---- README.md  # Installation and usage guide
|     |---- README_zh.md  # Installation and usage guide (Chinese)
```

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [Apache License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/GSYVideoPlayer/LICENSE).