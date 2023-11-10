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

import base64 from 'base64-js'
import util from '@ohos.util';
import { Unit8ArrayUtils } from './Unit8ArrayUtils';


@Entry
@Component
struct Index {
  @State length: number = 0
  @State toByteArrayStr: string = ''
  @State fromByteArray: string = ''
  @State toByteArray: Uint8Array = new Uint8Array([0, 0, 0])

  encode(input: string) {
    if (input != '') {
      let inputValue = Unit8ArrayUtils.stringToUint8Array(input)
      let base = new util.Base64Helper()
      let encode_value = base.encodeSync(inputValue)
      this.fromByteArray = base64.fromByteArray(encode_value)
      this.length = base64.byteLength(this.fromByteArray)
      this.toByteArray = base.decodeSync(base64.toByteArray(this.fromByteArray))
    } else {
      this.length = 0
      this.toByteArray = new Uint8Array([0, 0, 0])
      this.fromByteArray = ''
    }
  }

  build() {
    Row() {
      Column() {
        TextInput({ placeholder: "请输入base64解码字符" })
          .onChange((v) => {
            this.encode(v)
          })
        Row() {
          Text('length:')
          Text(this.length + '')
        }.width('90%')

        Row() {
          Text('toByteArray:')
          Text(Unit8ArrayUtils.Uint8ArrayToString(this.toByteArray))
        }.width('90%')

        Row() {
          Text('fromByteArray:')
          Text(this.fromByteArray)
        }.width('90%')
      }.justifyContent(FlexAlign.Start)
      .width('100%')
      .height('85%')
    }
    .height('100%')
  }
}