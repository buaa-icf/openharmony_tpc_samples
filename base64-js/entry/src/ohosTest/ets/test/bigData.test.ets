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
import { describe, it, expect } from '@ohos/hypium'

function equal(a: ESObject, b: ESObject) {
  let i: number
  const length: number = a.length
  if (length !== b.length) return false
  for (i = 0; i < length; ++i) {
    if (a[i] !== b[i]) return false
  }
  return true
}
export default function bigDataTest() {
  describe('bag_data_test', ()=> {
    it('convert_big_data_to_base64',0, ()=> {
      let big = new Uint8Array(64)
      for (let i: number = 0, length: number = big.length; i < length; ++i) {
        big[i] = i % 2
      }
      let b64str = base64.fromByteArray(big)
      let arr = base64.toByteArray(b64str)
      expect(equal(arr, big)).assertTrue()
      expect(base64.byteLength(b64str)).assertDeepEquals(arr.length)
    })
  })
}