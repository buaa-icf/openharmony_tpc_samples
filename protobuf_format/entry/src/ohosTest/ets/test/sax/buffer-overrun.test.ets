/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import sax from '@ohos/sax'
import test from '../../sax_util/TestUtil'
import { describe, expect, it } from '@ohos/hypium'

export default function bufferOverrunTest() {

  describe('BufferOverrunTest', function () {

    it('bufferOverrunTest', 0, function () {
      var bl = sax.MAX_BUFFER_LENGTH
      sax.MAX_BUFFER_LENGTH = 5
      let data = {
        expect: [
          ['error', 'Max buffer length exceeded: tagName\nLine: 0\nColumn: 15\nChar: '],
          ['error', 'Max buffer length exceeded: tagName\nLine: 0\nColumn: 30\nChar: '],
          ['error', 'Max buffer length exceeded: tagName\nLine: 0\nColumn: 45\nChar: '],
          ['opentagstart', {
            'name': 'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ',
            'attributes': {}
          }],
          ['opentag', {
            'name': 'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ',
            'attributes': {},
            'isSelfClosing': false
          }],
          ['text', 'yo'],
          ['closetag', 'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ']
        ]
      }
      test(data, expect)
        .write('<abcdefghijklmn')
        .write('opqrstuvwxyzABC')
        .write('DEFGHIJKLMNOPQR')
        .write('STUVWXYZ>')
        .write('yo')
        .write('</abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ>')
        .close()
      sax.MAX_BUFFER_LENGTH = bl;
    })
  })
}

