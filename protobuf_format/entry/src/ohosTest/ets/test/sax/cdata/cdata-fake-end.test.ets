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

export default function cdataFakeEndTest() {

  describe('CDataFakeEndTest', function () {

    it('cdataFakeEndTest_1', 0, function () {
      let data = {
        expect: [
          ['opentagstart', {
            'name': 'R', 'attributes': {}
          }],
          ['opentag', {
            'name': 'R', 'attributes': {}, 'isSelfClosing': false
          }],
          ['opencdata', undefined],
          ['cdata', '[[[[[[[[]]]]]]]]'],
          ['closecdata', undefined],
          ['closetag', 'R']
        ]
      }

      var parser = test(data, expect);
      var x = '<r><![CDATA[[[[[[[[[]]]]]]]]]]></r>'
      for (var i = 0; i < x.length; i++) {
        parser.write(x.charAt(i))
      }
      parser.close()

    })

    it('cdataFakeEndTest_2', 0, function () {
      let data = {
        expect: [
          ['opentagstart', {
            'name': 'R', 'attributes': {}
          }],
          ['opentag', {
            'name': 'R', 'attributes': {}, 'isSelfClosing': false
          }],
          ['opencdata', undefined],
          ['cdata', '[[[[[[[[]]]]]]]]'],
          ['closecdata', undefined],
          ['closetag', 'R']
        ]
      }

      var parser = test(data, expect);
      var x = '<r><![CDATA[[[[[[[[[]]]]]]]]]]></r>'
      parser.write(x).close()
    })
  })
}
