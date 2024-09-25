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

  @State message:string = "Hello World"
  @State message2:string = "Hello World"
  @State message3:string = "Hello World"

  encodedUint8?: Uint8Array = undefined;

  build() {
    Row() {
      Column() {
        Button('Encode').onClick(()=>{
          console.log("dodo click on!")
          let encodeletructor = new Encoder<Encoder>();
          this.encodedUint8 = encodeletructor.encode(data)
          this.message = "Result="+this.encodedUint8;
        })
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('Encode').onClick(()=>{
          if(this.encodedUint8) {
            let decodeletructor = new Decoder<Decoder>();
            //let decodeObj = decodeletructor.decode(this.encodedUint8)
            this.message2 = "Result=" + JSON.stringify(decodeletructor.decode(this.encodedUint8));
          }else{
            this.message3 = 'Result is undefined, please encode first'
          }
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

class Data{
  foo: string = ""
}

let data: Data = { foo: "bar" }