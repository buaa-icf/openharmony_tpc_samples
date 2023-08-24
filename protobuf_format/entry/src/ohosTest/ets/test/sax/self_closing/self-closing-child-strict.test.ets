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

export default function selfClosingChildStrictTest() {

  describe('SelfClosingChildStrictTest', function () {

    it('selfClosingChildStrictTest', 0, function () {
      let data = {
        xml: '<root>' +
        '<child>' +
        '<haha />' +
        '</child>' +
        '<monkey>' +
        '=(|)' +
        '</monkey>' +
        '</root>',
        expect: [
          ['opentagstart', {
            'name': 'root',
            'attributes': {}
          }],
          ['opentag', {
            'name': 'root',
            'attributes': {},
            'isSelfClosing': false
          }],
          ['opentagstart', {
            'name': 'child',
            'attributes': {}
          }],
          ['opentag', {
            'name': 'child',
            'attributes': {},
            'isSelfClosing': false
          }],
          ['opentagstart', {
            'name': 'haha',
            'attributes': {}
          }],
          ['opentag', {
            'name': 'haha',
            'attributes': {},
            'isSelfClosing': true
          }],
          ['closetag', 'haha'],
          ['closetag', 'child'],
          ['opentagstart', {
            'name': 'monkey',
            'attributes': {}
          }],
          ['opentag', {
            'name': 'monkey',
            'attributes': {},
            'isSelfClosing': false
          }],
          ['text', '=(|)'],
          ['closetag', 'monkey'],
          ['closetag', 'root'],
          ['end'],
          ['ready']
        ],
        strict: true,
        opt: {}
      }
      test(data, expect);

    })
  })
}
