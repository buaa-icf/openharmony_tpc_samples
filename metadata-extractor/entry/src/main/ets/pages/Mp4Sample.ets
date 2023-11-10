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
struct Mp4Sample {
  @State isVisibility: Visibility = Visibility.Hidden
  @State data: Array<string> = []

  private getMetaData() {
    this.data.splice(0,this.data.length)
    let argList: Set<string> = new Set<string>()
    let pathMp4 = globalThis.fileDir.concat("/test.mp4")
    argList.add(pathMp4)
    for (let arg of argList) {
      var metadata: Metadata = null
      try{
        metadata = ImageMetadataReader.readMetadata(arg)
      }catch(error){
        console.info("mp4 error:"+error)
      }

      // iterate over the metadata and print to System.out
      for (let directory of metadata.getDirectories()) {
        let directoryName = directory.getName()
        for (let tag of directory.getTags()) {
          let tagName = tag.getTagName()
          let description = tag.getDescription()

          // truncate the description if it's too longzg zg
          if (description != null && description.length > 1024) {
            description = description.substring(0, 1024) + "..."
          }
          this.data.push("\n" + "[" + directoryName + "] " + tagName + " = " + description)
        }
      }
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {

        Text("提取mp4元数据").fontSize(25).fontColor(Color.Gray)
          .padding(20).height("10%")
          .textAlign(TextAlign.Center)

        Text("资源路径:/resource/test.mp4" ).fontSize(22).width('100%')
          .textAlign(TextAlign.Start)

        Column() {
          Text("元数据:" ).fontSize(20).width('100%')
            .textAlign(TextAlign.Start)
          Text("" + this.data).fontSize(20).width('100%')
            .textAlign(TextAlign.Start)
            .visibility(this.isVisibility)
        }.height("80%").padding({ bottom: 10 })

        Button("显示mp4文件的元数据", { type: ButtonType.Normal, stateEffect: true })
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
