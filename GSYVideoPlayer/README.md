# GSYVideoPlayer

## Introduction

GSYVideoPlayer is a video player library that supports switching between core players (IJKPlayer and AVPlayer). It also provides capabilities such as video screenshot, video to GIF conversion, caching while playing, and full-screen video playback.

## Effect
![gif](screenshot/gsyvideoplayer.gif)

## How to Install

```
ohpm install @ohos/gsyvideoplayer
```

OpenHarmony ohpm

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Specifications

This library uses the AVPlayer or IJKPlayer at the bottom layer for audio and video playback. Therefore, the supported audio and video specifications are the same as those of the two libraries. For details, see the following:

- [AVPlayer Specifications](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-media-kit/js-apis-media.md#avplayer9)
- [ijkplayer Specifications](https://gitee.com/openharmony-sig/ohos_ijkplayer/blob/master/README.md)


### Using the Standard Player

1. Set the core player.

   You can select the AVPlayer or IJKPlayer.
   
   
      ```typescript
      import { GlobalContext } from '@ohos/gsyvideoplayer'
   
      aboutToAppear() {
        GlobalContext.getContext().setObject("playType", PlayerType.SYSTEM_AVPLAYER);
      }
      ```
   
2. Construct a **StandardGSYVideoModel** object.

   ```typescript
     videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();
     aboutToAppear() {
     // Set the playback URL and configure not to cache data while playing.
     this.videoModel.setUrl(this.videoUrl, false);
     this.videoModel.setTitle("This is the title of the test video.");
     this.videoModel.setBackClickListener(this.backClickListener);
     this.videoModel.setFullClickListener(this.fullClickListener);
     this.videoModel.setCoverImage($r('app.media.app_icon'));
   }
   ```

3. Use **StandardGSYVideoPlayer** in **build()** and pass the **StandardGSYVideoModel** object to the API.

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

4. Control the player state in the lifecycle of the page with the @Entry tag.

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


### Video Screenshot

```typescript
Button("Click to take a screenshot").onClick (() => {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    let path = getContext(this).cacheDir + "/test.jpeg";
    player.saveFrame(path, {
      shotResult(code: number) {
        promptAction.showToast({
          message: code = = 0? "Screenshot taken successfully": "Failed to take a screenshot."
        });
      }
    })
  }
})
```

### Video to GIF Conversion

```typescript
Button("startGif").onClick(() => {
  let player = GlobalContext.getContext().getObject("currentPlayer") as BaseVideoPlayer;
  if (player) {
    let path = getContext(this).cacheDir + "/tempGif";
    player.startGif(path);
    promptAction.showToast({
      message: "Start to take a GIF screenshot."
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
          message: code = = 0? "GIF screenshot taken successfully": "Failed to take a GIF screenshot."
        });
      }
    })
  }
})
```

### Caching While Playing
When constructing the **StandardGSYVideoModel** object, you can determine whether to cache data while playing.
```typescript
  videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();
  aboutToAppear() {
  // Set the playback URL and configure not to cache data while playing.
  this.videoModel.setUrl(this.videoUrl, false);
}
```

### Full-Screen Video Playback
When constructing the **StandardGSYVideoModel** object, you can set the full-screen callback. The full-screen logic is controlled by the end user.
```typescript
    fullClickListener: () => void = () => {
      
    }
  videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();
  aboutToAppear() {
  // Set the playback URL and configure not to cache data while playing.
  this.videoModel.setUrl(this.videoUrl, false);
  this.videoModel.setFullClickListener(this.fullClickListener);
}
```

## Available APIs

### StandardGSYVideoModel
| API                                             | Parameter                                     | Description                        |
| --------------------------------------------------- | ----------------------------------------- | -------------------------------- |
| setUrl(videoUrl: string, cacheWithPlay?: boolean)   | videoUrl: string, cacheWithPlay?: boolean | Sets the playback URL and configures whether to cache data while playing.  |
| setTitle(title: string)                             | title: string                             | Sets the title of a full-screen video.            |
| setBackClickListener(backClickListener: () => void) | backClickListener: () => void             | Sets a callback for the touch event on the back button of the player.|
| setFullClickListener(fullClickListener: () => void) | fullClickListener: () => void             | Sets a callback for the touch event on the full-screen button of the player.|
| setCoverImage(coverImage:Resource)                  | coverImage:Resource                       | Sets the cover.                    |
### IVideoPlayer
| API                                                      | Parameter                                                        | Description             |
| ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------- |
| play();                                                      | N/A                                                          | Starts video playback.         |
| resumePlay()                                                 | N/A                                                          | Resumes video playback.         |
| pause()                                                      | N/A                                                          | Pauses video playback.         |
| stop()                                                       | N/A                                                          | Stops video playback.         |
| saveFrame(fileSavePath: string, gsyVideoShotSaveListener: GSYVideoShotSaveListener) | fileSavePath: string, gsyVideoShotSaveListener: GSYVideoShotSaveListener | Takes a video screenshot.             |
| startGif(tmpPicPath?: string)                                | tmpPicPath?: string                                          | Starts to convert the video to a GIF image.          |
| stopGif(saveGifPath: string, gsyVideoGifSaveListener: GSYVideoGifSaveListener) | N/A                                                          | Ends the video to GIF conversion and generates a GIF image.|
## Constraints

This project has been verified in the following version:

DevEco Studio: NEXT Developer Beta1 (5.0.3.326), SDK: API 12 (5.0.0.25)

## Directory Structure

```typescript
|---- GSYVideoPlayer  
|     |---- entry  # Sample code
            |---- pages
                |---- BiliDanmukuParser.ets  # Bullet comment parsing class
                |---- DanmakuData.ets  # Bullet comment data
                |---- DanmakuVideoDemo.ets  # Bullet comment demo
                |---- DanmakuVideoPlayer.ets  # Bullet comment player
                |---- Index.ets  # Homepage
                |---- PlayNetWithCacheDemo.ets  # Demo of caching while playing
                |---- PlayNetWithNoCacheDemo.ets  # Demo of no caching while playing
                |---- PlayWithCacheDemo.ets  # Playback cache entry
                |---- SimpleDemo.ets  # Demo of simple playback test
                |---- SimpleList.ets  # Demo of simple video list
|     |---- library  # GSYVideoPlayer core code
            |---- listener  # Callback class
                |---- GSYVideoGifSaveListener.ets  # Callback class of the stopGif API
                |---- GSYVideoShotSaveListener.ets  # Callback class of the screenshot APIs
            |---- mainpage  # Core implementation
                |---- AvPlayerControl.ets  # AVPlayer logic control class
                |---- AvVideoPlayer.ets  # AVPlayer
                |---- BaseVideoPlayer.ets  # Player control base class
                |---- CommonConstants.ets # Constant class
                |---- GlobalContext.ts  # Global configuration class
                |---- IjkPlayerControl.ets  # IJKPlayer logic control class
                |---- IjkVideoPlayer.ets  # IJKPlayer player
                |---- StandardForListGSYVideoPlayer.ets  # Player used by the list page
                |---- StandardGSYVideoModel.ets  # Standard player
                |---- StandardGSYVideoPlayer.ets  # Player data configuration class
            |---- utils  # Utility class
                |---- OrientationUtil.ets # Screen orientation control class
                |---- LogUtils.ets # Log utility class
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
```

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [Apache License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/GSYVideoPlayer/LICENSE).
