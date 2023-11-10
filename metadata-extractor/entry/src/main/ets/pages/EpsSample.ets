/*
* Copyright (c) 2022 Huawei Device Co., Ltd.

* Permission to use, copy, modify, and/or distribute this software for any purpose
* with or without fee is hereby granted, provided that the above copyright notice
* and this permission notice appear in all copies.

* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
* REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
* INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
* OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
* TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
* THIS SOFTWARE.
*/


import {Metadata} from '@ohos/metadata-extractor';
import {ImageMetadataReader} from '@ohos/metadata-extractor'
@Entry
@Component
struct BmpSample {
  @State isVisibility: Visibility = Visibility.Hidden
  @State data: Array<string> = [""]

  private getMetaData() {
    this.data.splice(0,this.data.length)
    let pathAvi = globalThis.fileDir.concat("/adobeJpeg1.eps")
    let metadata: Metadata  = ImageMetadataReader.readMetadata(pathAvi)
    // iterate over the metadata and print to System.out
    for (let directory of metadata.getDirectories()) {
      for (let tag of directory.getTags()) {
        let tagName = tag.getTagName()
        let description = tag.getDescription()
        this.data.push("\n" + "[" + tagName + "] " + tagName + " = " + description)
      }
    }
  }
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {

        Text("提取Eps元数据").fontSize(25).fontColor(Color.Gray)
          .padding(20).height("10%")
          .textAlign(TextAlign.Center)

        Text("资源路径:/resource/adobeJpeg1.eps" ).fontSize(22).width('100%')
          .textAlign(TextAlign.Start)

        Column() {
          Text("元数据:" ).fontSize(20).width('100%')
            .textAlign(TextAlign.Start)
          Text("" + this.data).fontSize(20).width('100%')
            .textAlign(TextAlign.Start)
            .visibility(this.isVisibility)
        }.height("80%").padding({ bottom: 10 })

        Button("显示Eps文件的元数据", { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8).width("70%").height("8%")
          .onClick(() => {
            this.getMetaData()
            this.isVisibility = Visibility.Visible
          })

      }.height("100%")
    }.padding(16)
    .width('100%')
    .height("100%")
  }

}