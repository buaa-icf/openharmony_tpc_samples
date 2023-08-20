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
import test from '../../../sax_util/TestUtil'
import { describe, expect, it } from '@ohos/hypium'

export default function issue_86Test() {

  describe('Issue_86Test', function () {

    it('issue_86Test_1', 0, function () {
      let data = {
        xml: '<root>abc</root>de<f',
        expect: [
          [
            'opentagstart',
            {
              name: 'ROOT',
              attributes: {}
            }
          ],
          [
            'opentag',
            {
              name: 'ROOT',
              attributes: {},
              isSelfClosing: false
            }
          ],
          [
            'text',
            'abc'
          ],
          [
            'closetag',
            'ROOT'
          ],
          [
            'text',
            'de<f'
          ]
        ],
        strict: false,
        opt: {}
      }
      test(data, expect);
    })

    it('issue_86Test_2', 0, function () {
      let data = {
        xml: '<root>abc</root>de<f',
        expect: [
          [
            'opentagstart',
            {
              name: 'root',
              attributes: {}
            }
          ],
          [
            'opentag',
            {
              name: 'root',
              attributes: {},
              isSelfClosing: false
            }
          ],
          [
            'text',
            'abc'
          ],
          [
            'closetag',
            'root'
          ],
          [
            'error',
            'Text data outside of root node.\nLine: 0\nColumn: 17\nChar: d'
          ],
          [
            'text',
            'd'
          ],
          [
            'error',
            'Text data outside of root node.\nLine: 0\nColumn: 18\nChar: e'
          ],
          [
            'text',
            'e'
          ],
          [
            'error',
            'Unexpected end\nLine: 0\nColumn: 20\nChar: '
          ]
        ],
        strict: true,
        opt: {}
      }
      test(data, expect);
    })
  })
}

