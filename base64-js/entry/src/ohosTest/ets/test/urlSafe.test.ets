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

import b64 from 'base64-js'
import { describe, it, expect } from '@ohos/hypium'

export default function urlSafeTest() {
  describe('urlSafeTest', ()=> {
    it('decode_url_safe_style_base64_strings',0, ()=> {
      const expected = [0xff, 0xff, 0xbe, 0xff, 0xef, 0xbf, 0xfb, 0xef, 0xff]

      let str = '//++/++/++//'
      let actual = b64.toByteArray(str)
      for (let i = 0; i < actual.length; i++) {
        expect(actual[i]).assertEqual(expected[i])
      }
      expect(b64.byteLength(str)).assertEqual(actual.length)
      str = '__--_--_--__'
      actual = b64.toByteArray(str)
      for (let i = 0; i < actual.length; i++) {
        expect(actual[i]).assertEqual(expected[i])
      }
      expect(b64.byteLength(str)).assertEqual(actual.length)
    })
  })
}
