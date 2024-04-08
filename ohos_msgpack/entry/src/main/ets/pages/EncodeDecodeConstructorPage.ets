/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission to use, copy, modify, and/or distribute this software for any purpose
 * with or without fee is hereby granted, provided that the above copyright notice
 * and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
 * WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
 * THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
 * FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
 * CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
import { encode,Encoder } from "@ohos/msgpack";
import { decode,Decoder } from "@ohos/msgpack";
@Entry
@Component
struct EncodeDecodeConstructorPage {

  @State message:string = "编码后的数据展示"
  @State message2:string = "解码后的数据展示"
  @State message3:string = "错误提示"

  encodedUint8?: Uint8Array = undefined;

  build() {
    Row() {
      Column() {
        Button('点击构造器编码').onClick(()=>{
          console.log("dodo click on!")
          let encodeletructor: Encoder<Encoder> = new Encoder<Encoder>();
          this.encodedUint8 = encodeletructor.encode(data)
          this.message = "编码后的数据="+this.encodedUint8;
        })
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('点击构造器解码').onClick(()=>{
          if(this.encodedUint8) {
            let decodeletructor: Decoder<Decoder> = new Decoder<Decoder>();
            //let decodeObj = decodeletructor.decode(this.encodedUint8)
            this.message2 = "解码后的数据=" + JSON.stringify(decodeletructor.decode(this.encodedUint8));
          }else{
            this.message3 = '解码数据为undefined, 请先点击编码'
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