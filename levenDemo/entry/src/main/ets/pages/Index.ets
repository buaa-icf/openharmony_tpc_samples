/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import leven from 'leven'
@Entry
@Component
struct Index {
  @State message: Resource = $r('app.string.different_strings')
  getResourceString(res:Resource){
    return getContext().resourceManager.getStringSync(res.id)
  }
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(25)
        Button($r('app.string.Different_numbers_of_strings')).fontSize(25).width(300).margin(20).onClick(() => {
          let data1:string = "ABCDEF";
          let data2:string = "ABCDGH";
          let s:number = leven(data1,data2);
          AlertDialog.show({
            title:'',
            message: this.getResourceString($r('app.string.What_are_the_different_numbers'))+s,
            confirm:{
                value:'OK',
                action:() => {
                }
            }
          })
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}