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
var xmlnsAttr = {
  name: 'xmlns',
  value: 'http://foo',
  prefix: 'xmlns',
  local: '',
  uri: 'http://www.w3.org/2000/xmlns/'
}

var attrAttr =
  {
    name: 'attr',
    value: 'bar',
    prefix: '',
    local: 'attr',
    uri: ''
  }
import test from '../../../sax_util/TestUtil'
import { describe, expect, it } from '@ohos/hypium'

export default function xmlnsXmlDefaultNsTest() {

  describe('xmlnsXmlDefaultNsTest', function () {

    it('xmlns_xml_default_ns', 0, function () {
      let data = {
        xml: "<elm xmlns='http://foo' attr='bar'/>",
        expect: [
          [
            'opentagstart',
            {
              name: 'elm',
              attributes: {},
              ns: {}
            }
          ],
          [
            'opennamespace',
            {
              prefix: '', uri: 'http://foo'
            }
          ],
          [
            'attribute',
            xmlnsAttr
          ],
          [
            'attribute',
            attrAttr
          ],
          [
            'opentag',
            {
              name: 'elm',
              prefix: '',
              local: 'elm',
              uri: 'http://foo',
              ns: {
                '': 'http://foo'
              },
              attributes: {
                xmlns: xmlnsAttr,
                attr: attrAttr
              },
              isSelfClosing: true
            }
          ],
          [
            'closetag',
            'elm'
          ],
          [
            'closenamespace',
            {
              prefix: '',
              uri: 'http://foo'
            }
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


