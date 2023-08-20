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

export default function issue_23Test() {

  describe('Issue_23Test', function () {

    it('issue_23Test', 0, function () {
      let data = {
        xml: '<compileClassesResponse>' +
        '<result>' +
        '<bodyCrc>653724009</bodyCrc>' +
        '<column>-1</column>' +
        '<id>01pG0000002KoSUIA0</id>' +
        '<line>-1</line>' +
        '<name>CalendarController</name>' +
        '<success>true</success>' +
        '</result>' +
        '</compileClassesResponse>',
        expect: [
          ['opentagstart', {
            name: 'COMPILECLASSESRESPONSE', attributes: {}
          }],
          ['opentag', {
            name: 'COMPILECLASSESRESPONSE', attributes: {}, isSelfClosing: false
          }],
          ['opentagstart', {
            name: 'RESULT', attributes: {}
          }],
          ['opentag', {
            name: 'RESULT', attributes: {}, isSelfClosing: false
          }],
          ['opentagstart', {
            name: 'BODYCRC', attributes: {}
          }],
          ['opentag', {
            name: 'BODYCRC', attributes: {}, isSelfClosing: false
          }],
          ['text', '653724009'],
          ['closetag', 'BODYCRC'],
          ['opentagstart', {
            name: 'COLUMN', attributes: {}
          }],
          ['opentag', {
            name: 'COLUMN', attributes: {}, isSelfClosing: false
          }],
          ['text', '-1'],
          ['closetag', 'COLUMN'],
          ['opentagstart', {
            name: 'ID', attributes: {}
          }],
          ['opentag', {
            name: 'ID', attributes: {}, isSelfClosing: false
          }],
          ['text', '01pG0000002KoSUIA0'],
          ['closetag', 'ID'],
          ['opentagstart', {
            name: 'LINE', attributes: {}
          }],
          ['opentag', {
            name: 'LINE', attributes: {}, isSelfClosing: false
          }],
          ['text', '-1'],
          ['closetag', 'LINE'],
          ['opentagstart', {
            name: 'NAME', attributes: {}
          }],
          ['opentag', {
            name: 'NAME', attributes: {}, isSelfClosing: false
          }],
          ['text', 'CalendarController'],
          ['closetag', 'NAME'],
          ['opentagstart', {
            name: 'SUCCESS', attributes: {}
          }],
          ['opentag', {
            name: 'SUCCESS', attributes: {}, isSelfClosing: false
          }],
          ['text', 'true'],
          ['closetag', 'SUCCESS'],
          ['closetag', 'RESULT'],
          ['closetag', 'COMPILECLASSESRESPONSE']
        ],
        strict: false,
        opt: {}
      }
      test(data, expect);
    })
  })
}
