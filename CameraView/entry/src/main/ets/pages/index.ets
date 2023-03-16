/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import { MediaUtils } from '@ohos/cameraview'
import TitleBar from '../view/TitleBar'

import MediaView from '../view/MediaView'

export default interface Album {
  albumName: string,
  count: string
}

const PERMISSIONS: Array<string> = [
  'ohos.permission.CAMERA',
  'ohos.permission.MICROPHONE',
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA',
  'ohos.permission.MEDIA_LOCATION'
]


@Entry
@Component
struct Index {
  private mediaUtils: MediaUtils = MediaUtils.getInstance()
  @State albums: Array<Album> = []
  @State selectIndex: number = 0
  @State operateVisible: boolean = false
  getAlbums = async () => {
    this.albums = await this.mediaUtils.getAlbums()
  }

  async aboutToAppear() {
    await globalThis.abilityContext.requestPermissionsFromUser(PERMISSIONS)
  }

  onPageShow() {
    if (this.albums.length === 0) {
      this.getAlbums()
      this.mediaUtils.onDateChange(this.getAlbums)
    }
  }

  @Builder OperateBtn(src, zIndex, translate, handleClick) {
    Button() {
      Image(src).size({ width: '70%', height: '70%' })
    }
    .type(ButtonType.Circle)
    .size({ width: '40%', height: '40%' })
    .backgroundColor('#0D9FFB')
    .zIndex(zIndex)
    .translate({ x: translate.x, y: translate.y })
    .transition({ type: TransitionType.Insert, translate: { x: 0, y: 0 } })
    .transition({ type: TransitionType.Delete, opacity: 0 })
    .onClick(handleClick)
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        TitleBar()
        MediaView({ albums: $albums })
      }
      .width('100%')
      .height('100%')

      Stack({ alignContent: Alignment.Center }) {
        this.OperateBtn($r('app.media.icon'), 0, { x: 0, y: 0 }, () => {
          animateTo({ duration: 100, curve: Curve.Ease }, () => {
            this.operateVisible = !this.operateVisible
          })
        })

        if (this.operateVisible) {
          this.OperateBtn($r('app.media.icon'), 0, { x: '-540%', y: 0 }, () => {
            this.operateVisible = !this.operateVisible
            router.push({ url: 'pages/CameraPage' })
          })
        }
      }
      .size({ width: '30%', height: '30%' })
      .translate({ x: 10 })
    }
    .height('100%')
    .width('100%')
  }

  aboutToDisappear() {
    this.mediaUtils.offDateChange()
  }
}