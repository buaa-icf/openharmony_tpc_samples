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

export default function xmlnsUnboundElementTest() {

  describe('xmlnsUnboundElementTest', function () {

    it('xmlns_unbound_element_test_1', 0, function () {
      let data = {
        strict: true,
        opt: {
          xmlns: true
        },
        expect: [
          [
            'opentagstart',
            {
              name: 'unbound:root',
              attributes: {},
              ns: {}
            }
          ],
          [
            'error',
            'Unbound namespace prefix: "unbound:root"\nLine: 0\nColumn: 15\nChar: >'
          ],
          [
            'opentag',
            {
              name: 'unbound:root',
              uri: 'unbound',
              prefix: 'unbound',
              local: 'root',
              attributes: {},
              ns: {},
              isSelfClosing: true
            }
          ],
          [
            'closetag',
            'unbound:root'
          ]
        ]
      }
      test(data, expect).write('<unbound:root/>');
    })

    it('xmlns_unbound_element_test_2', 0, function () {
      let data = {
        strict: true,
        opt: {
          xmlns: true
        },
        expect: [
          [
            'opentagstart',
            {
              name: 'unbound:root',
              attributes: {},
              ns: {}
            }
          ],
          [
            'opennamespace',
            {
              prefix: 'unbound',
              uri: 'someuri'
            }
          ],
          [
            'attribute',
            {
              name: 'xmlns:unbound',
              value: 'someuri',
              prefix: 'xmlns',
              local: 'unbound',
              uri: 'http://www.w3.org/2000/xmlns/'
            }
          ],
          [
            'opentag',
            {
              name: 'unbound:root',
              uri: 'someuri',
              prefix: 'unbound',
              local: 'root',
              attributes: {
                'xmlns:unbound': {
                  name: 'xmlns:unbound',
                  value: 'someuri',
                  prefix: 'xmlns',
                  local: 'unbound',
                  uri: 'http://www.w3.org/2000/xmlns/'
                }
              },
              ns: {
                'unbound': 'someuri'
              },
              isSelfClosing: true
            }
          ],
          [
            'closetag',
            'unbound:root'
          ],
          [
            'closenamespace',
            {
              prefix: 'unbound',
              uri: 'someuri'
            }
          ]
        ]
      }
      test(data, expect).write('<unbound:root xmlns:unbound="someuri"/>');
    })
  })
}


