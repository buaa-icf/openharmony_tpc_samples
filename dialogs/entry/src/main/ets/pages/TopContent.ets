/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import  {TopDialog,BaseCenterMode} from '@ohos/dialogs'
import { animation } from '../utils/animation'

@Entry
@Component
struct TopContent {
  scroller: Scroller = new Scroller()
  @State model:BaseCenterMode = new BaseCenterMode()
  @State isAnimation:boolean = false
  aboutToAppear() {
    this.model.dialogBgColor = '#008577'
    this.model.dialogHeight = 400
    this.model.dialogWidth = '100%'
    this.model.popupAnimation = animation('translateFromTop')
  }
  topController: CustomDialogController = new CustomDialogController({
    builder: TopDialog({
      slotContent: () => {
        this.componentBuilder()
      },
      model:this.model,
      isAnimation:this.isAnimation
    }),
    customStyle: true,
    alignment: DialogAlignment.Top
    })

  @Builder componentBuilder() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll(this.scroller){
        Column(){
          Text(getContext().resourceManager.getStringByNameSync('TopContent_String1') )
            .fontColor(Color.White)
            .fontSize(20)
          Text( getContext().resourceManager.getStringByNameSync('TopContent_String2') )
            .fontColor(Color.White)
            .fontSize(20)
          Column().height(200).width('100%').backgroundColor('#f6f6f6').margin({top: 20})
          Button(getContext().resourceManager.getStringByNameSync('TopContent_String3')).backgroundColor(Color.White).margin({top: 20}).fontColor(Color.Black)
            .onClick(()=>{
              this.topController.close()
              this.isAnimation = false
            })
        }.padding(20)
      }
    }.height('100%').padding(10)

  }
  build(){
      Button(getContext().resourceManager.getStringByNameSync('TopContent_String4')).onClick(() => {
        this.topController.open()
      })
  }
}
