/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { SchemaError, validate, ValidationError, Validator, ValidatorResult } from 'jsonschema'
import { it as _it, afterAll, afterEach, beforeAll, beforeEach, describe, expect } from '@ohos/hypium'

// @ts-ignore
var validator: Validator;
const BASE_COUNT = 1

export default function mixedTest() {
  describe('mixedTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
      validator = new Validator();
    })
    afterEach(function () {
    })
    afterAll(function () {
    })
    _it('should validate', 0, function () {
      let result = validator.validate(
        {
          'name': 'test', 'lines': ['1']
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'lines': {
              'type': 'array',
              'items': {
                'type': 'string'
              },
            },
          },
        }
      ).valid;
      expect(result).assertTrue()
    });

    _it('should not validate', 0, function () {
      var result = validator.validate(
        {
          'name': 'test', 'lines': [1]
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'lines': {
              'type': 'array',
              'items': {
                'type': 'string'
              },
            },
          },
        }
      );
      expect(result.errors.length).assertEqual(1)
      let msgProperty = result.errors[0]['message']
      expect(msgProperty).assertEqual('is not of a type(s) string')
      let instanceProperty = result.errors[0]['property']
      expect(instanceProperty).assertEqual('instance.lines[0]')
    });
  })
}