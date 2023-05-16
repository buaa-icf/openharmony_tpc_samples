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
import { encode,Encoder } from "@msgpack/msgpack";
import { decode,Decoder } from "@msgpack/msgpack";
@Entry
@Component
struct EncodeDecodeConstructorPage {

  @State message:string = "编码后的数据展示"
  @State message2:string = "解码后的数据展示"

  encodedUint8: Uint8Array = undefined;

  build() {
    Row() {
      Column() {
        Button('点击构造器编码').onClick(()=>{
          console.log("dodo click on!")
          let encodeletructor = new Encoder();
          this.encodedUint8 = encodeletructor.encode({
            foo: "bar"
          })
          this.message = "编码后的数据="+this.encodedUint8;
        })
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('点击构造器解码').onClick(()=>{
          let decodeletructor = new Decoder();
          let decodeObj = decodeletructor.decode(this.encodedUint8)
          this.message2 = "解码后的数据="+JSON.stringify(decodeObj);
        })
        Text(this.message2)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
  aboutToAppear(){

  }


}