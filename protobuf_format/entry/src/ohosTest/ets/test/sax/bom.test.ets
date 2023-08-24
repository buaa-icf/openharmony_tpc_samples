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

export default function bomTest() {

  describe('BomTest', function () {

    it('bomTest_1', 0, function () {
      let data = {
        xml: '\uFEFF<P></P>',
        expect: [
          ['opentagstart', {
            'name': 'P', attributes: {}
          }],
          ['opentag', {
            'name': 'P', attributes: {}, isSelfClosing: false
          }],
          ['closetag', 'P']
        ]
      }
      test(data, expect);

    })

    it('bomTest_2', 0, function () {
      let data = {
        xml: '\uFEFF<P BOM="\uFEFF">\uFEFFStarts and ends with BOM\uFEFF</P>',
        expect: [
          ['opentagstart', {
            'name': 'P', attributes: {}
          }],
          ['attribute', {
            'name': 'BOM', 'value': '\uFEFF'
          }],
          ['opentag', {
            'name': 'P', attributes: {
              'BOM': '\uFEFF'
            }, isSelfClosing: false
          }],
          ['text', '\uFEFFStarts and ends with BOM\uFEFF'],
          ['closetag', 'P']
        ]
      }
      test(data, expect);

    })

    it('bomTest_3', 0, function () {
      let data = {
        xml: ' \uFEFF<P></P>',
        expect: [
          ['error', 'Non-whitespace before first tag.\nLine: 0\nColumn: 2\nChar: \uFEFF'],
          ['text', '\uFEFF'],
          ['opentagstart', {
            'name': 'P', attributes: {}
          }],
          ['opentag', {
            'name': 'P', attributes: {}, isSelfClosing: false
          }],
          ['closetag', 'P']
        ],
        strict: true
      }
      test(data, expect);

    })

    it('bomTest_4', 0, function () {
      let data = {
        xml: '\uFEFF\uFEFF<P></P>',
        expect: [
          ['error', 'Non-whitespace before first tag.\nLine: 0\nColumn: 2\nChar: \uFEFF'],
          ['text', '\uFEFF'],
          ['opentagstart', {
            'name': 'P', attributes: {}
          }],
          ['opentag', {
            'name': 'P', attributes: {}, isSelfClosing: false
          }],
          ['closetag', 'P']
        ],
        strict: true
      }
      test(data, expect);

    })
  })
}

