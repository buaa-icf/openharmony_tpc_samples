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

export default function issue_49Test() {

  describe('Issue_49Test', function () {

    it('issue_49Test_1', 0, function () {
      let data = {
        xml: '<xml><script>hello world</script></xml>',
        expect: [
          ['opentagstart', {
            name: 'xml', attributes: {}
          }],
          ['opentag', {
            name: 'xml', attributes: {}, isSelfClosing: false
          }],
          ['opentagstart', {
            name: 'script', attributes: {}
          }],
          ['opentag', {
            name: 'script', attributes: {}, isSelfClosing: false
          }],
          ['text', 'hello world'],
          ['closetag', 'script'],
          ['closetag', 'xml']
        ],
        strict: false,
        opt: {
          lowercasetags: true, noscript: true
        }
      }
      test(data, expect);
    })

    it('issue_49Test_2', 0, function () {
      let data = {
        xml: '<xml><script><![CDATA[hello world]]></script></xml>',
        expect: [
          ['opentagstart', {
            name: 'xml', attributes: {}
          }],
          ['opentag', {
            name: 'xml', attributes: {}, isSelfClosing: false
          }],
          ['opentagstart', {
            name: 'script', attributes: {}
          }],
          ['opentag', {
            name: 'script', attributes: {}, isSelfClosing: false
          }],
          ['opencdata', undefined],
          ['cdata', 'hello world'],
          ['closecdata', undefined],
          ['closetag', 'script'],
          ['closetag', 'xml']
        ],
        strict: false,
        opt: {
          lowercasetags: true, noscript: true
        }
      }
      test(data, expect);
    })
  })
}


