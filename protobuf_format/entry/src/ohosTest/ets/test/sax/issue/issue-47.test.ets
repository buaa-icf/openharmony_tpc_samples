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

export default function issue_47Test() {

  describe('Issue_47Test', function () {

    it('issue_47Test', 0, function () {
      let data = {
        xml: '<a href="query.svc?x=1&y=2&z=3"/>',
        expect: [
          ['opentagstart', {
            name: 'A', attributes: {}
          }],
          ['attribute', {
            name: 'HREF', value: 'query.svc?x=1&y=2&z=3'
          }],
          ['opentag', {
            name: 'A', attributes: {
              HREF: 'query.svc?x=1&y=2&z=3'
            }, isSelfClosing: true
          }],
          ['closetag', 'A']
        ],
        opt: {}
      }
      test(data, expect);
    })
  })
}

