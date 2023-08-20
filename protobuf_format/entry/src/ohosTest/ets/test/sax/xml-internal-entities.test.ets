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

export default function xmlInternalEntitiesTest() {

  describe('XmlInternalEntitiesTest', function () {

    it('xmlInternalEntitiesTest', 0, function () {
      var iExpect = []
      var myAttributes = {}
      var ENTITIES = {}

      // generates xml like test0="&control;"
      var entitiesToTest = {
        // 'ENTITY_NAME': IS_VALID || [invalidCharPos, invalidChar],
        'control0': true, // This is a vanilla control.
        // entityStart
        '_uscore': true,
        '#hash': true,
        ':colon': true,
        '-bad': [0, '-'],
        '.bad': [0, '.'],
        // general entity
        'u_score': true,
        'd-ash': true,
        'd.ot': true,
        'all:_#-.': true
      }

      var xmlStart = '<a test="&amp;" '
      var xmlEnd = '/>'

      iExpect.push([
        'opentagstart',
        {
          name: 'a',
          attributes: {}
        }
      ])

      iExpect.push([
        'attribute',
        {
          name: 'test',
          value: '&'
        }
      ])
      myAttributes['test'] = '&'

      var entI = 0

      for (var entity in entitiesToTest) {
        var attribName = 'test' + entI
        var attribValue = 'Testing ' + entity

        // add the first part to use in calculation below
        xmlStart += attribName + '="' + '&'

        if (typeof entitiesToTest[entity] === 'object') {
          iExpect.push([
            'error',
            'Invalid character in entity name\nLine: 0\nColumn: ' +
            (xmlStart.length + entitiesToTest[entity][0] + 1) +
            '\nChar: ' + entitiesToTest[entity][1]
          ])
          iExpect.push([
            'attribute',
            {
              name: attribName, value: '&' + entity + ';'
            }
          ])
          myAttributes[attribName] = '&' + entity + ';'
        } else {
          ENTITIES[entity] = attribValue
          iExpect.push(['attribute', {
            name: attribName, value: attribValue
          }])
          myAttributes[attribName] = attribValue
        }

        xmlStart += entity + ';" '
        entI++
      }

      iExpect.push([
        'opentag',
        {
          name: 'a',
          attributes: myAttributes,
          isSelfClosing: true
        }
      ])
      iExpect.push(['closetag', 'a'])
      var data = {
        strict: true,
        expect: iExpect
      }
      var parser = test(data, expect);

      for (entity in entitiesToTest) {
        parser.ENTITIES[entity] = ENTITIES[entity]
      }

      parser.write(xmlStart + xmlEnd).close()

    })
  })
}

