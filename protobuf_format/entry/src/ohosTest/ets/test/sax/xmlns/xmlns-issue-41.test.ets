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

export default function xmlnsIssue41Test() {

  describe('xmlnsIssue41Test', function () {

    it('xmlns_issue_41_test', 0, function () {
      // should be the same both ways.
      var xmls = [
        '<parent xmlns:a="http://ATTRIBUTE" a:attr="value" />',
        '<parent a:attr="value" xmlns:a="http://ATTRIBUTE" />'
      ]

      var ex1 = [
        ['opentagstart', {
          name: 'parent', attributes: {}, ns: {}
        }],
        [
          'opennamespace',
          {
            prefix: 'a',
            uri: 'http://ATTRIBUTE'
          }
        ],
        [
          'attribute',
          {
            name: 'xmlns:a',
            value: 'http://ATTRIBUTE',
            prefix: 'xmlns',
            local: 'a',
            uri: 'http://www.w3.org/2000/xmlns/'
          }
        ],
        [
          'attribute',
          {
            name: 'a:attr',
            value: 'value',
            prefix: 'a',
            local: 'attr',
            uri: 'http://ATTRIBUTE'
          }
        ],
        [
          'opentag',
          {
            name: 'parent',
            attributes: {
              'a:attr': {
                name: 'a:attr',
                prefix: 'a',
                local: 'attr',
                uri: 'http://ATTRIBUTE',
                value: 'value'
              },
              'xmlns:a': {
                name: 'xmlns:a',
                prefix: 'xmlns',
                local: 'a',
                uri: 'http://www.w3.org/2000/xmlns/',
                value: 'http://ATTRIBUTE'
              }
            },
            ns: {
              a: 'http://ATTRIBUTE'
            },
            prefix: '',
            local: 'parent',
            uri: '',
            isSelfClosing: true
          }
        ],
        [
          'closetag',
          'parent'
        ],
        [
          'closenamespace',
          {
            prefix: 'a',
            uri: 'http://ATTRIBUTE'
          }
        ]
      ]

      // swap the order of elements 2 and 3
      var ex2 = [ex1[0], ex1[1], ex1[3], ex1[2]].concat(ex1.slice(4))
      var expected = [ex1, ex2]

      xmls.forEach(function (x, i) {
        var data = {
          xml: x,
          expect: expected[i],
          strict: true,
          opt: {
            xmlns: true
          }
        }
        test(data, expect);
      })
    })
  })
}

