# cameraview

## 简介

一款支持相机拍照、录像功能的组件。

## 使用说明

目前该项目无法通过IDE上自带SDK运行，有需要运行，请参考配置[fullSdk](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/quick-start/full-sdk-switch-guide.md])
进行项目运行

### 相册

```
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import router from '@ohos.router'
import { Logger, MediaUtils } from '@ohos/cameraview'
import { MediaItem } from '../view/MediaItem'
import { RenameDialog } from '../view/RenameDialog'
import TitleBar from '../view/TitleBar'

@Entry
@Component
struct AlbumPage {
  private tag: string = 'AlbumPage'
  private albumName: string = <string> router.getParams()['albumName']
  private mediaType: number = <number> router.getParams()['mediaType']
  private mediaUtils: MediaUtils = MediaUtils.getInstance()
  private renameDialogController: CustomDialogController = null
  @State mediaList: Array<mediaLibrary.FileAsset> = []
  @State selectMedia: mediaLibrary.FileAsset = undefined

  btnAction(operate, index) {
    this.selectMedia = this.mediaList[index]
    if (operate === 'delete') {
      this.deleteMedia(() => {
        let deleteResult = this.mediaUtils.deleteFile(this.selectMedia)
        deleteResult.then(() => {
          this.mediaList.splice(index, 1)
        }).catch(err => {

        })
      })
    }
    else {
      if (this.renameDialogController == null) {
        this.renameDialogController = new CustomDialogController({
          builder: RenameDialog({ title: this.selectMedia.title, action: this.renameMedia.bind(this) }),
          autoCancel: true
        })
      }
      this.renameDialogController.open()
    }
  }

  renameMedia(title) {
    this.selectMedia.title = title
    this.selectMedia.commitModify(err => {
      if (err !== undefined) {
        return
      }
      this.renameDialogController.close()
      this.refreshData()
    })
  }

  deleteMedia(deleteAction) {
    AlertDialog.show({
      message: "Delete this file?",
      primaryButton: {
        value: "OK",
        fontColor: Color.Red,
        action: () => {
          deleteAction()
        }
      },
      secondaryButton: {
        value: "Cancel",
        fontColor: Color.Blue
      }
    })
  }

  refreshData() {
    this.mediaList = []
    let fileAsset = this.mediaUtils.getFileAssetsFromType(this.mediaType)
    fileAsset.then(fileList => {
      this.mediaList = fileList
    }).catch(err => {

    })
  }

  aboutToAppear() {
    this.refreshData()
  }

  build() {
    Column() {
      TitleBar({ title: this.albumName })
      List() {
        ForEach(this.mediaList, (item, index) => {
          ListItem() {
            MediaItem({ media: item, index: index, btnAction: this.btnAction.bind(this) })
          }.onClick(() => {
            if (item.mediaType === mediaLibrary.MediaType.VIDEO) {
              globalThis.abilityContext.startAbility({
                bundleName: 'ohos.samples.videoplayer',
                abilityName: 'PlayAbility',
                deviceId: "",
                parameters: {
                  fileId: item.id
                }
              }, (error) => {
              }
              )
            }
          })
        }, item => item.title)
      }.layoutWeight(1)
    }.width('100%')
    .height('100%')
    .backgroundColor("#F5F5F5")
  }
}

```

### 相机

```
import prompt from '@ohos.prompt';
import { Logger } from '@ohos/cameraview'
import TitleBar from '../view/TitleBar'
import { CameraView, CameraService } from '@ohos/cameraview'

const CameraMode = {
  MODE_PHOTO: 0,
  MODE_VIDEO: 1
}

@Entry
@Component
struct CameraPage {
  private tag: string = "CameraPage"
  private mXComponentController: XComponentController = new XComponentController()
  private surfaceId: number
  @State imgThumbnail: string = ''
  @State videoThumbnail: Resource | undefined = undefined
  @State curModel: number = CameraMode.MODE_PHOTO
  @State isRecording: boolean = false

  aboutToAppear() {
    this.surfaceId = this.mXComponentController.getXComponentSufraceId()
    CameraService.setTakePictureCallback(this.handleTakePicture.bind(this))
  }

  getCameraIcon() {
    if (this.curModel === CameraMode.MODE_PHOTO) {
      return $r('app.media.take_photo_normal')
    } else {
      if (this.isRecording) {
        return $r('app.media.take_video_stop')
      }
      else {
        return $r('app.media.take_video_normal')
      }
    }
  }

  refresVideoState() {
    if (this.isRecording) {
      CameraService.stopVideo()
      this.isRecording = false
      this.videoThumbnail = $r('app.media.video_poster')
    } else {
      CameraService.startVideo()
      this.isRecording = true
    }
  }

  handleTakePicture=(thumbnail:string)=>{
    this.imgThumbnail=thumbnail
  }

  @State yu: string = ""

  build() {

    Column() {
      TitleBar()
      Stack({ alignContent: Alignment.Bottom }) {
        CameraView()
        XComponent({
          id: 'xcomponetId',
          type: 'surface',
          controller: this.mXComponentController
        }).onLoad(() => {
          this.mXComponentController.setXComponentSurfaceSize({
            surfaceWidth: 1920, surfaceHeight: 1080
          })
          this.surfaceId = this.mXComponentController.getXComponentSufraceId()
          this.curModel = CameraMode.MODE_PHOTO
          CameraService.initCamera(this.surfaceId)
        }).height('100%').width('100%').margin({ bottom: 130 })
        Column() {
          Row() {
            Text($r('app.media.photo'))
              .onClick(() => {
                if (this.curModel === CameraMode.MODE_VIDEO) {
                  prompt.showToast({ message: '切换中', duration: 1000 })
                  if (this.isRecording) {
                    CameraService.stopVideo()
                    this.isRecording = false
                  }
                  this.curModel = CameraMode.MODE_PHOTO
                  this.videoThumbnail = undefined
                }
              })
            Text($r('app.media.video'))
              .onClick(() => {
                if (this.curModel === CameraMode.MODE_PHOTO) {
                  prompt.showToast({ message: '切换中', duration: 1000 })
                  this.curModel = CameraMode.MODE_VIDEO
                }
              })
          }.size({ height: 40, width: '100%' })
          .margin({ left: 50 })
          .justifyContent(FlexAlign.Center)

          Row() {
            if (this.curModel === CameraMode.MODE_VIDEO) {
              Image(this.videoThumbnail).size({ width: 70, height: 70 })
            }
            else {
              Image(this.imgThumbnail).size({ width: 70, height: 70 })
            }
          }

          Image(this.getCameraIcon()).size({ width: 70, height: 70 })
            .onClick(() => {
              CameraService.setCameraFocus()
              if (this.curModel === CameraMode.MODE_PHOTO) {
                prompt.showToast({ message: '拍照中', duration: 1000 })
                CameraService.takePicture()
                CameraService.setFlashMode()
              }
              else if (this.curModel === CameraMode.MODE_VIDEO) {
                this.refresVideoState()
              }
            })

        }
      }
    }

  }
}
```

### 接口说明

| 接口 | 功能描述 |
| :-------------------------| :--------------------------|
|   takePicture()           |           拍摄照片            |
|   startVideo()            |           开始录制            |
|   stopVideo()             |           停止录制            |
|   releaseCamera()         |           重置相机            |
|   setCameraFocus()         |          设置焦点            |
|   setFlashMode()         |            设置闪光            |

### 兼容性

- [DevEco Studio](https://developer.harmonyos.com/cn/develop/deveco-studio#download) 版本：DevEco Studio 3.1 Beta1及以上版本。
- OpenHarmony SDK版本：API version 9 及以上版本。

### 贡献代码

使用过程中发现任何问题，都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎给我们发[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)

### 开源协议

本项目基于[Apache License 2.0](),请自由的享受和参与开源