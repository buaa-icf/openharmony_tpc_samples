
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
struct WavSample {
  @State isVisibility: Visibility = Visibility.Hidden
  @State data: Array<string> = []

  private getMetaData() {
    this.data.splice(0,this.data.length)
    let path = globalThis.fileDir.concat("/test.wav")

      var metadata: Metadata = null
      try{
        metadata = ImageMetadataReader.readMetadata(path)
      }catch(error){
        console.info("WavSample error:"+error)
      }
      console.info("wav sample meta:"+metadata.getDirectories().size)
      // iterate over the metadata and print to System.out
      for (let directory of metadata.getDirectories()) {

        console.info("wav sample meta:"+directory.getName())
        console.info("wav sample meta:"+directory.getName())
        directory.getTags().forEach((value,value2,SET)=>{
          if(value != undefined && value != null){
            console.info("wav sample getTagName:"+value.getTagName())
            console.info("wav sample getDescription:"+value.getTagType())
            let description = value.getDescription()
//            console.info("wav sample getDescription:"+value.getDescription())
//            this.data.push("\n" + "[" + directory.getName() + "] " + value.getTagName() + " = " + value)
            this.data.push("\n" + "[" + directory.getName() + "] " + value.getTagName() + " = " + description)
          }
        })
      }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {

        Text("提取wav元数据").fontSize(25).fontColor(Color.Gray)
          .padding(20).height("10%")
          .textAlign(TextAlign.Center)

        Text("资源路径:/resource/test.wav" ).fontSize(22).width('100%')
          .textAlign(TextAlign.Start)

        Column() {
          Text("元数据:" ).fontSize(20).width('100%')
            .textAlign(TextAlign.Start)
          Text("" + this.data).fontSize(20).width('100%')
            .textAlign(TextAlign.Start)
            .visibility(this.isVisibility)
        }.height("80%").padding({ bottom: 10 })

        Button("显示wav文件的元数据", { type: ButtonType.Normal, stateEffect: true })
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
