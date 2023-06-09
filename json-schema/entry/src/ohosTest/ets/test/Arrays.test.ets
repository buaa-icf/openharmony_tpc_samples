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

export default function arrayTest() {
  describe('arrayTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
      validator = new Validator();
    })
    afterEach(function () {
    })
    afterAll(function () {
    })
    it('ShouldValidateAnEmptyArray', 0, function () {
      let result = validator.validate([], {
        'type': 'array', 'items': {
          'type': 'string'
        }
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateAnUndefinedArray', 0, function () {
      let result = validator.validate(undefined, {
        'type': 'array', 'items': {
          'type': 'string'
        }
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateAnArrayWithStrings', 0, function () {
      let result = validator.validate(['1', '2', '3'], {
        'type': 'array', 'items': {
          'type': 'string'
        }
      }).valid;
      expect(result).assertTrue();
    })
    it('shouldNotValidateAnArrayNotAllStrings', 0, function () {
      let result = validate(['1', '2', '3', 4], {
        'type': 'array', 'items': {
          'type': 'string'
        }
      });
      expect(result.valid).assertFalse();
      expect(result.errors.length).assertEqual(1);
      expect(result.errors[0].property).assertEqual('instance[3]');
      expect(result.errors[0].path.length).assertEqual(1);
      expect(result.errors[0].path[0]).assertEqual(3);
    })
    it('shouldNotValidateANonArray', 0, function () {
      let result = validator.validate(0, {
        'type': 'array'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfArrayHasALengthEqualToMinItems', 0, function () {
      let result = validator.validate([1, 2, 3], {
        'type': 'array', 'items': {
          'type': 'number'
        }, 'minItems': 2
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateIfArrayHasALengthEqualToMinItems', 0, function () {
      let result = validator.validate([1, 2], {
        'type': 'array', 'items': {
          'type': 'number'
        }, 'minItems': 2
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfArrayHasALengthLessThanMinItems', 0, function () {
      let result = validator.validate([1], {
        'type': 'array', 'items': {
          'type': 'number'
        }, 'minItems': 2
      });
      expect(result.valid).assertFalse();
      expect(result.errors[0].name).assertEqual('minItems');
      expect(result.errors[0].property).assertEqual('instance');
      expect(result.errors[0].path.length).assertEqual(0);
    })
    it('ShouldValidateIfArrayHasALengthLessThanMaxItems', 0, function () {
      let result = validator.validate([1], {
        'type': 'array', 'items': {
          'type': 'number'
        }, 'maxItems': 2
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateIfArrayHasALengthEqualToMaxItems', 0, function () {
      let result = validator.validate([1], {
        'type': 'array', 'items': {
          'type': 'number'
        }, 'maxItems': 2
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateIfArrayHasALengthLargerThanMaxItems', 0, function () {
      let result = validator.validate([1, 2, 3], {
        'type': 'array', 'items': {
          'type': 'number'
        }, 'maxItems': 2
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfArrayHasNoDuplicateItems', 0, function () {
      let result = validator.validate([1], {
        'type': 'array', 'uniqueItems': true
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateIfArrayHasNoDuplicateObjects', 0, function () {
      let result = validator.validate([1, 2, "1", "2", {
        a: 1
      }, {
        a: 1, b: 1
      }], {
        'type': 'array', 'uniqueItems': true
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfArrayHasDuplicateNumbers', 0, function () {
      let result = validator.validate([1, 2, 4, 1, 3, 5], {
        'type': 'array', 'uniqueItems': true
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateIfArrayHasDuplicateObjects', 0, function () {
      let result = validator.validate([{
        a: 1
      }, {
        a: 1
      }], {
        'type': 'array', 'uniqueItems': true
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfNotAnArray', 0, function () {
      let result = validator.validate(null, {
        'type': 'any', 'uniqueItems': true
      }).valid;
      expect(result).assertTrue();
    })
  })
}