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

import { SchemaError, validate, ValidationError, Validator, ValidatorResult } from '@ohos/jsonschema'
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'

// @ts-ignore
var validator: Validator;
const BASE_COUNT = 1
const initSchema = {
  'type': 'object',
  'anyOf': [{
    'properties': {
      'name': { 'type': 'string', 'enum': ['test1'] },
    },
  }, {
    'properties': {
      'name': { 'type': 'string', 'enum': ['test2'] },
    },
  }],
};
const oneOfSchema = {
  'type': 'object',
  'oneOf': [{
    'properties': {
      'name1': { 'type': 'string', 'enum': ['test1'] },
    },
    'additionalProperties': false,
  }, {
    'properties': {
      'name2': { 'type': 'string', 'enum': ['test2'] },
    },
    'additionalProperties': false,
  }],
};

export default function combinatorsTest() {
  describe('combinatorsTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
      validator = new Validator();
    })
    afterEach(function () {
    })
    afterAll(function () {
    })
    it('ShouldValidateIfMatchesAnyOf', 0, function () {
      let result = validator.validate({
        'name': 'test2'
      }, initSchema).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfNotMatchAnyOf', 0, function () {
      let result = validator.validate({
        'name': 'test3'
      }, initSchema).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotThrowIfValidWhenThrowErrorIsSet1', 0, function () {
      var isThrow = false;
      try {
        validator.validate({
          'name': 'test2'
        }, initSchema, {
          throwError: true
        });
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertFalse();
    });

    it('ShouldThrowIfInvalidWhenThrowErrorIsSet1', 0, function () {
      var isThrow = false;
      try {
        validator.validate({
          'name': 'test3'
        }, initSchema, {
          throwError: true
        });
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertTrue();
    });


    it('ShouldValidateIfMatchesExactlyOneOf', 0, function () {
      let result = validator.validate({
        'name2': 'test2'
      }, oneOfSchema).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNotMatchExactlyOneOf', 0, function () {
      let result = validator.validate({
        'name1': 'test1', 'name2': 'test2'
      }, oneOfSchema).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotThrowIfValidWhenThrowErrorIsSet2', 0, function () {
      var isThrow = false;
      try {
        validator.validate({
          'name2': 'test2'
        }, oneOfSchema, {
          throwError: true
        });
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertFalse();
    });

    it('ShouldThrowIfInvalidWhenThrowErrorIsSet2', 0, function () {
      var isThrow = false;
      try {
        validator.validate({
          'name1': 'test1', 'name2': 'test2'
        }, oneOfSchema, {
          throwError: true
        });
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertTrue();
    });
  })
}