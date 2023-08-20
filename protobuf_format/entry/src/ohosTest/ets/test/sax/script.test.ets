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

export default function scriptTest() {

  describe('ScriptTest', function () {

    it('scriptTest', 0, function () {
      let data = {
        xml: "<html><head><script>if (1 < 0) { console.log('elo there'); }</script></head></html>",
        expect: [
          [
            'opentagstart',
            {
              'name': 'HTML',
              'attributes': {}
            }
          ],
          [
            'opentag',
            {
              'name': 'HTML',
              'attributes': {},
              'isSelfClosing': false
            }
          ],
          [
            'opentagstart',
            {
              'name': 'HEAD',
              'attributes': {}
            }
          ],
          [
            'opentag',
            {
              'name': 'HEAD',
              'attributes': {},
              'isSelfClosing': false
            }
          ],
          [
            'opentagstart',
            {
              'name': 'SCRIPT',
              'attributes': {}
            }
          ],
          [
            'opentag',
            {
              'name': 'SCRIPT',
              'attributes': {},
              'isSelfClosing': false
            }
          ],
          [
            'script',
            "if (1 < 0) { console.log('elo there'); }"
          ],
          [
            'closetag',
            'SCRIPT'
          ],
          [
            'closetag',
            'HEAD'
          ],
          [
            'closetag',
            'HTML'
          ]
        ]
      }
      test(data, expect);

    })
  })
}
