/*
Copyright (c) 2022 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import { Metadata } from '@ohos/metadata-extractor';
import { ImageMetadataReader } from '@ohos/metadata-extractor'
import { GlobalContext } from './GlobalContext'
import fileIo from '@ohos.file.fs';

let fileDir: string;

@Entry
@Component
struct GifSample {
  @State isVisibility: Visibility = Visibility.Hidden
  @State data: Array<string> = []

  private getMetaData() {
    this.data.splice(0, this.data.length)
    const imageData = getContext().resourceManager.getRawFileContentSync('metadata.gif')
    const targetDir = getContext().filesDir + 'webResources/'
    if (!fileIo.accessSync(targetDir)) {
      fileIo.mkdirSync(targetDir)
    }
    const filePath = targetDir + 'metadata.gif'
    const fd = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    fileIo.writeSync(fd.fd, imageData!.buffer)
    fileIo.closeSync(fd)
    try {
      let metadata: Metadata = ImageMetadataReader.readMetadata(filePath)
      metadata.getDirectories().forEach((value: ESObject, vlue2: ESObject, mataSet: ESObject) => {
        let directoryName: string = value.getName()
        value.getTags().forEach((tag: ESObject, vlue2: ESObject, mataSet: ESObject) => {
          let tagName: string = tag.getTagName()
          let description: string = tag.getDescription()
          this.data.push('[' + directoryName + '] ' + tagName + ' = ' + description)
        })
      })
      console.info('gif metadata data:' + this.data)
    } catch (err) {
      console.error('metadata error..')
    }

  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {

        Text($r('app.string.Extract_gif_metadata'))
          .fontSize(25)
          .fontColor(Color.Gray)
          .padding(20)
          .height('10%')
          .textAlign(TextAlign.Center)

        Text($r('app.string.Extract_gif_metadata')).fontSize(22).width('100%')
          .textAlign(TextAlign.Start)

        Column() {
          Text($r('app.string.Resource_path6')).fontSize(20).width('100%')
            .textAlign(TextAlign.Start)
          Text('' + JSON.stringify(this.data)).fontSize(20).width('100%')
            .textAlign(TextAlign.Start)
            .visibility(this.isVisibility)

        }.height('80%').padding({ bottom: 10 })

        Button($r('app.string.Display_metadata3'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8).width('70%').height('8%')
          .onClick(() => {
            this.getMetaData()
            this.isVisibility = Visibility.Visible
          })

      }.height('100%')
    }.padding(16)
    .width('100%')
    .height('100%')
  }
}
