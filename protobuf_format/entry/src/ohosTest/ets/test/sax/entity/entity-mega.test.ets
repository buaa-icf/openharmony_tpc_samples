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
import test from '../../../sax_util/TestUtil'
import { describe, expect, it } from '@ohos/hypium'

export default function entityMegaTest() {

  describe('EntityMegaTest', function () {

    it('entityMegaTest', 0, function () {
      var xml = '<r>'
      var text = ''
      for (var i in sax.ENTITIES) {
        xml += '&' + i + ';'
        text += sax.ENTITIES[i]
      }
      xml += '</r>'

      let data = {
        xml: xml,
        expect: [
          ['opentagstart', {
            'name': 'R', attributes: {}
          }],
          ['opentag', {
            'name': 'R', attributes: {}, isSelfClosing: false
          }],
          ['text', text],
          ['closetag', 'R']
        ]
      }
      test(data, expect)
    })
  })
}

