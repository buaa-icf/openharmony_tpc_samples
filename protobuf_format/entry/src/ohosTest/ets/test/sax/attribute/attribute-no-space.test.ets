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

export default function attributeNoSpace() {

  describe('AttributeNoSpace', function () {

    it('attribute_no_space_1', 0, function () {
      let data = {
        xml: '<root attr1="first"attr2="second"/>',
        expect: [
          ['opentagstart', {
            name: 'root', attributes: {}
          }],
          ['attribute', {
            name: 'attr1', value: 'first'
          }],
          ['attribute', {
            name: 'attr2', value: 'second'
          }],
          ['opentag', {
            name: 'root', attributes: {
              attr1: 'first', attr2: 'second'
            }, isSelfClosing: true
          }],
          ['closetag', 'root']
        ],
        strict: false,
        opt: {
          lowercase: true
        }
      }
      test(data, expect);
    })

    it('attribute_no_space_2', 0, function () {
      let data = {
        xml: '<root attr1="first"attr2="second"/>',
        expect: [
          ['opentagstart', {
            name: 'root', attributes: {}
          }],
          ['attribute', {
            name: 'attr1', value: 'first'
          }],
          ['error', 'No whitespace between attributes\nLine: 0\nColumn: 20\nChar: a'],
          ['attribute', {
            name: 'attr2', value: 'second'
          }],
          ['opentag', {
            name: 'root', attributes: {
              attr1: 'first', attr2: 'second'
            }, isSelfClosing: true
          }],
          ['closetag', 'root']
        ],
        strict: true,
        opt: {}
      }
      test(data, expect);

    })

    it('attribute_no_space_3', 0, function () {
      let data = {
        xml: '<root attr1="first" attr2="second"/>',
        expect: [
          ['opentagstart', {
            name: 'root', attributes: {}
          }],
          ['attribute', {
            name: 'attr1', value: 'first'
          }],
          ['attribute', {
            name: 'attr2', value: 'second'
          }],
          ['opentag', {
            name: 'root', attributes: {
              attr1: 'first', attr2: 'second'
            }, isSelfClosing: true
          }],
          ['closetag', 'root']
        ],
        strict: true,
        opt: {}
      }
      test(data, expect);

    })

    it('attribute_no_space_4', 0, function () {
      let data = {
        xml: '<root attr1="first"\nattr2="second"/>',
        expect: [
          ['opentagstart', {
            name: 'root', attributes: {}
          }],
          ['attribute', {
            name: 'attr1', value: 'first'
          }],
          ['attribute', {
            name: 'attr2', value: 'second'
          }],
          ['opentag', {
            name: 'root', attributes: {
              attr1: 'first', attr2: 'second'
            }, isSelfClosing: true
          }],
          ['closetag', 'root']
        ],
        strict: true,
        opt: {}
      }
      test(data, expect);

    })

    it('attribute_no_space_5', 0, function () {
      let data = {
        xml: '<root attr1="first"  attr2="second"/>',
        expect: [
          ['opentagstart', {
            name: 'root', attributes: {}
          }],
          ['attribute', {
            name: 'attr1', value: 'first'
          }],
          ['attribute', {
            name: 'attr2', value: 'second'
          }],
          ['opentag', {
            name: 'root', attributes: {
              attr1: 'first', attr2: 'second'
            }, isSelfClosing: true
          }],
          ['closetag', 'root']
        ],
        strict: true,
        opt: {}
      }
      test(data, expect);

    })
  })
}