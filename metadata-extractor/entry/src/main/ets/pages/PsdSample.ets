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

import {Metadata} from '@ohos/metadata-extractor';
import {ImageMetadataReader} from '@ohos/metadata-extractor'

@Entry
@Component
struct PsdSample{
  @State isVisibility: Visibility = Visibility.Hidden
  @State data: string[]= []
  scroller: Scroller = new Scroller()

  private getMetaData() {
    let path = globalThis.fileDir.concat("/8x4x8bit-Grayscale.psd")
      this.data.splice(0,this.data.length)
      let metadata: Metadata = ImageMetadataReader.readMetadata(path)
     console.info("psd sample meta:"+JSON.stringify(metadata))
      // iterate over the metadata and print to System.out
      for (let directory of metadata.getDirectories()) {
        console.info("psd sample meta directory:"+directory.getName())
        for (let tag of directory.getTags()) {
          console.info("psd sample meta tag:"+tag.getTagName()+",descrp:"+tag.getDescription())

          this.data.push("\n" + "[" + directory.getName()+ "] " + tag.getTagName() + " = " + tag.getDescription())
        }
      }
    console.info("psd sample meta all:"+JSON.stringify(this.data))

  }

  build() {

    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Text("提取Psd元数据").fontSize(25).fontColor(Color.Gray)
        .padding({ left:10,right:10,top:10,bottom:10 })
        .textAlign(TextAlign.Center)

      Text("资源路径:/resource/8x4x8bit-Grayscale.psd" ).fontSize(22).width('100%')
        .textAlign(TextAlign.Start)
      Text("元数据:" ).fontSize(20).width('100%')
        .textAlign(TextAlign.Start)
      Scroll(this.scroller) {
        Column() {
          Text("" + this.data).fontSize(20).width('100%')
            .textAlign(TextAlign.Start)
            .visibility(this.isVisibility)
        }
      }.scrollable(ScrollDirection.Vertical).scrollBar(BarState.On)
      .scrollBarColor(Color.Gray).scrollBarWidth(1).height('80%')


      Button("显示Psd文件的元数据", { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8).width("100%").height(60)
        .onClick(() => {
          this.getMetaData()
          this.isVisibility = Visibility.Visible
        })
    }.padding(16)
    .width('100%')
    .height("100%")
  }
}