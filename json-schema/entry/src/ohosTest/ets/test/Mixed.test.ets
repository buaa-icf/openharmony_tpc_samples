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
import { it as _it, afterAll, afterEach, beforeAll, beforeEach, describe, expect } from '@ohos/hypium'
import { ouldva, ouldvadata } from './IntertfaceData';

let validator: Validator;
const BASE_COUNT = 1

export default function mixedTest() {
  describe('mixedTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      validator = new Validator();
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    _it('should validate', 0, () => {
      let result:boolean  = validator.validate(ouldva, ouldvadata).valid;
      expect(result).assertTrue()
    });

    _it('should not validate', 0, () => {

      expect( validator.validate(ouldva,ouldvadata).errors.length).assertEqual(1)
      expect(validator.validate(ouldva,ouldvadata).errors[0]['message']).assertEqual('is not of a type(s) string')
      expect(validator.validate(ouldva,ouldvadata).errors[0]['property']).assertEqual('instance.lines[0]')
    });
  })
}