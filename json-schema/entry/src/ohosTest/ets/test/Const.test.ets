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
var stringSchema = { 'const': 'value' };
var objectSchema = { 'const': { "some key": [null, "1", 2, true] } };

export default function constTest() {
  describe('constTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
      validator = new Validator();
    })
    afterEach(function () {
    })
    afterAll(function () {
    })
    it('StringValid', 0, function () {
      let result = validator.validate("value", stringSchema).valid;
      expect(result).assertTrue();
    });
    it('StringInvalid1', 0, function () {
      let result = validator.validate("invalid 1", stringSchema).valid;
      expect(result).assertFalse();
    });
    it('StringInvalid2', 0, function () {
      let result = validator.validate("", stringSchema).valid;
      expect(result).assertFalse();
    });

    it('ObjectValid', 0, function () {
      let result = validator.validate({
        "some key": [null, "1", 2, true]
      }, objectSchema).valid;
      expect(result).assertTrue();
    });
    it('ObjectInvalid1', 0, function () {
      let result = validator.validate([null], objectSchema).valid;
      expect(result).assertFalse();
    });
    it('ObjectInvalid2', 0, function () {
      let result = validator.validate({
        "some key": [false, "1", 2, true]
      }, objectSchema).valid;
      expect(result).assertFalse();
    });
    it('ObjectInvalid3', 0, function () {
      let result = validator.validate(true, objectSchema).valid;
      expect(result).assertFalse();
    });
  })
}