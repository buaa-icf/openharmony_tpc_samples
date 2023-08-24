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

export default function xmlnsUnboundTest() {

  describe('xmlnsUnboundTest', function () {

    it('xmlns_unbound_test', 0, function () {
      let data = {
        strict: true,
        opt: {
          xmlns: true
        },
        expect: [
          [
            'opentagstart',
            {
              name: 'root',
              attributes: {},
              ns: {}
            }
          ],
          [
            'error',
            'Unbound namespace prefix: "unbound"\nLine: 0\nColumn: 28\nChar: >'
          ],
          [
            'attribute',
            {
              name: 'unbound:attr',
              value: 'value',
              uri: 'unbound',
              prefix: 'unbound',
              local: 'attr'
            }
          ],
          [
            'opentag',
            {
              name: 'root',
              uri: '',
              prefix: '',
              local: 'root',
              attributes: {
                'unbound:attr': {
                  name: 'unbound:attr',
                  value: 'value',
                  uri: 'unbound',
                  prefix: 'unbound',
                  local: 'attr'
                }
              },
              ns: {},
              isSelfClosing: true
            }
          ],
          [
            'closetag',
            'root'
          ]
        ]
      }
      test(data, expect).write("<root unbound:attr='value'/>");
    })
  })
}

