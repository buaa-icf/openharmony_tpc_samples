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

import { Exam } from '../../../ohosTest/ets/test/test/msgpacksuit/exam'
import { MsgTimestamp } from "../../../ohosTest/ets/test/test/msg/msg-timestamp";
import {
  encode,
  decode,
  ExtensionCodec,
  EXT_TIMESTAMP,
  encodeTimeSpecToTimestamp
} from "@msgpack/msgpack";
import ohBuffer from '@ohos.buffer';

@Entry
@Component
struct Index {
  @State message: string = '点击查看log编码输入和解码输出'

  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            this.testSpecString();
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  testSpecString() {
    // 补齐XTS中未通过用例
    let inputs = [
      {
        "string": "Кириллица",
        "msgpack": [
          [0xb2, 0xd0, 0x9a, 0xd0, 0xb8, 0xd1, 0x80, 0xd0, 0xb8, 0xd0, 0xbb, 0xd0, 0xbb, 0xd0, 0xb8, 0xd1, 0x86, 0xd0, 0xb0],
          [0xd9, 0x12, 0xd0, 0x9a, 0xd0, 0xb8, 0xd1, 0x80, 0xd0, 0xb8, 0xd0, 0xbb, 0xd0, 0xbb, 0xd0, 0xb8, 0xd1, 0x86, 0xd0, 0xb0]
        ]
      },
      {
        "string": "ひらがな",
        "msgpack": [
          [0xac, 0xe3, 0x81, 0xb2, 0xe3, 0x82, 0x89, 0xe3, 0x81, 0x8c, 0xe3, 0x81, 0xaa],
          [0xd9, 0x0c, 0xe3, 0x81, 0xb2, 0xe3, 0x82, 0x89, 0xe3, 0x81, 0x8c, 0xe3, 0x81, 0xaa]
        ]
      },
      {
        "string": "한글",
        "msgpack": [
          [0xa6, 0xed, 0x95, 0x9c, 0xea, 0xb8, 0x80],
          [0xd9, 0x06, 0xed, 0x95, 0x9c, 0xea, 0xb8, 0x80]
        ]
      },
      {
        "string": "汉字",
        "msgpack": [
          [0xa6, 0xe6, 0xb1, 0x89, 0xe5, 0xad, 0x97],
          [0xd9, 0x06, 0xe6, 0xb1, 0x89, 0xe5, 0xad, 0x97]
        ]
      },
      {
        "string": "漢字",
        "msgpack": [
          [0xa6, 0xe6, 0xbc, 0xa2, 0xe5, 0xad, 0x97],
          [0xd9, 0x06, 0xe6, 0xbc, 0xa2, 0xe5, 0xad, 0x97]
        ]
      },
      {
        "string": "❤",
        "msgpack": [
          [0xa3, 0xe2, 0x9d, 0xa4],
          [0xd9, 0x03, 0xe2, 0x9d, 0xa4]
        ]
      },
      {
        "string": "🍺",
        "msgpack": [
          [0xa4, 0xf0, 0x9f, 0x8d, 0xba],
          [0xd9, 0x04, 0xf0, 0x9f, 0x8d, 0xba]
        ]
      }

    ]
    for (let i = 0; i < inputs.length; i++) {
      let input = inputs[i];
      this.checkEncodeAndDecode(input.string, input.msgpack[0], input.msgpack[1])
    }


  }
  checkEncodeAndDecode(value: string, array1, array2) {
    console.log("dodo 输入value=" + value);
    let extensionCodec = new ExtensionCodec();
    extensionCodec.register({
      type: EXT_TIMESTAMP,
      encode: (input) => {
        if (input instanceof MsgTimestamp) {
          return encodeTimeSpecToTimestamp({
            sec: input.getTime(),
            nsec: input.getNano(),
          });
        } else {
          return null;
        }
      },
      decode: (data: Uint8Array) => {
        return MsgTimestamp.parse(ohBuffer.from(data));
      },
    });
    let b1 = encode(value, { extensionCodec });
    let u8 = b1;
    for (let i = 0; i < u8.length; i++) {
      console.log(`dodo 编码后buffer[${i}]=${u8[i]}`)
    }
    let encode1 = ohBuffer.from(array1);
    let encode2 = ohBuffer.from(array2);

    let decode1 = decode(encode1.buffer, { extensionCodec });
    let decode2 = decode(encode2.buffer, { extensionCodec });

    console.log("dodo 解码后 array1 对应 decode1=" + decode1 + " array2 对应 decode2=" + decode2);
  }

}