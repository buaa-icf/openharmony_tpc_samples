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

import CameraService from '../../model/CameraService'

@Component
export struct CameraView {
  private cameraWidth: number | string = "100%"
  private cameraHeight: number | string = "100%"
  private surfaceId: string
  opens: () => void
  abc: string

  build() {
    Row() {
      CameraView2({ cameraWidth: this.cameraWidth, cameraHeight: this.cameraHeight, surfaceId: this.surfaceId })
    }.height('100%')
  }
}


@Component
struct CameraView2 {
  private mXComponentController: XComponentController = new XComponentController()
  private cameraWidth: number | string = "100%"
  private cameraHeight: number | string = "100%"
  private surfaceId: string
  opens: () => void
  abc: string

  build() {
    Row() {
      Column() {
        XComponent({
          id: 'componentId',
          type: 'surface',
          controller: this.mXComponentController
        })
          .onLoad(() => {
            this.opens()
            CameraService.initCamera(this.surfaceId)
          }).height(this.cameraHeight)
          .width(this.cameraWidth)
          .margin({ bottom: 130 })
        Text('wraw').fontSize(16)
      }.width('100%')

    }.height('100%')
  }
}
