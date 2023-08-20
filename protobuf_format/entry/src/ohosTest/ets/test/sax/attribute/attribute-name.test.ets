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

export default function attributeNameTest() {

  describe('AttributeNameTest', function () {

    it('attributeNameTest', 0, function () {
      let data = {
        xml: "<root length='12345'></root>",
        expect: [
          ['opentagstart', {
            name: 'root', attributes: {}, ns: {}
          }],
          [
            'attribute',
            {
              name: 'length',
              value: '12345',
              prefix: '',
              local: 'length',
              uri: ''
            }
          ],
          [
            'opentag',
            {
              name: 'root',
              attributes: {
                length: {
                  name: 'length',
                  value: '12345',
                  prefix: '',
                  local: 'length',
                  uri: ''
                }
              },
              ns: {},
              prefix: '',
              local: 'root',
              uri: '',
              isSelfClosing: false
            }
          ],
          [
            'closetag',
            'root'
          ]
        ],
        strict: true,
        opt: {
          xmlns: true
        }
      }
      test(data, expect);

    })
  })
}
