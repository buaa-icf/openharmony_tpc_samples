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
import { encode } from "@msgpack/msgpack";
import { decode,decodeMulti } from "@msgpack/msgpack";
@Entry
@Component
struct MultiDecodePage {

  @State message:string = "展示原数据"
  @State message2:string = "decodeMulti解码后的数据展示"

  encodedUint8?: Uint8Array = undefined;
  bn: ButtonName = {name: "bar"};

  build() {
    Row() {
      Column() {
        Button('对象展示').onClick(()=>{
          console.log('dodo click on!')
          this.message = JSON.stringify([
            "foo",
            10,
            this.bn,
            [1, 2, 3],
          ])
        })
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('点击MultiDecode').onClick(() => {
          let items = [
            "foo",
            10,
          this.bn,
            [1, 2, 3],
          ];

          let encodedItems = items.map((item) => encode<string>(item));
          let encoded = new Uint8Array(encodedItems.reduce((p, c) => p + c.byteLength, 0));
          let offset = 0;
          for (let encodedItem of encodedItems) {
            encoded.set(encodedItem, offset);
            offset += encodedItem.byteLength;
          }

          let result: Array<Object> = [];

          // for (let item of decodeMulti<number[]>(encoded)) {
          //   result.push(item);
          // }
          let numbers: Array<Object> = Array<Object>(decodeMulti<number[]>(encoded))
          for (let item = 0; item < numbers.length; item++) {
            result.push(numbers[item]);
          }

          let retStr1 = JSON.stringify(result);
          this.message2 = retStr1;

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

class ButtonName {
  name:string = "";
}