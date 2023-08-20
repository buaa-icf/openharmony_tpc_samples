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
import test from '../../sax_util/TestUtil'
import { describe, expect, it } from '@ohos/hypium'

export default function unquotedTest() {

  describe('UnquotedTest', function () {

    it('unquotedTest', 0, function () {
      let data = {
        xml: '<span class=test hello=world></span>',
        expect: [
          [
            'opentagstart',
            {
              name: 'SPAN',
              attributes: {}
            }
          ],
          [
            'attribute',
            {
              name: 'CLASS',
              value: 'test'
            }
          ],
          [
            'attribute',
            {
              name: 'HELLO',
              value: 'world'
            }
          ],
          [
            'opentag',
            {
              name: 'SPAN',
              attributes: {
                CLASS: 'test',
                HELLO: 'world'
              },
              isSelfClosing: false
            }
          ],
          [
            'closetag',
            'SPAN'
          ]
        ],
        strict: false,
        opt: {}
      }
      test(data, expect);
    })
  })
}


