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
import { ErrorFlag, initSchema, name, namedata, nametest, oneOfSchema } from './IntertfaceData';

let validator: Validator;
const BASE_COUNT = 1

export default function combinatorsTest() {
  describe('combinatorsTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      validator = new Validator();
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('ShouldValidateIfMatchesAnyOf', 0, () => {
      let result:boolean  = validator.validate(name, initSchema).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfNotMatchAnyOf', 0, () => {
      let result:boolean  = validator.validate(namedata, initSchema).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotThrowIfValidWhenThrowErrorIsSet1', 0, () => {
      let isThrow = false;
      try {
        validator.validate(name, initSchema, ErrorFlag);
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertFalse();
    });

    it('ShouldThrowIfInvalidWhenThrowErrorIsSet1', 0, () => {
      let isThrow = false;
      try {
        validator.validate(namedata, initSchema, ErrorFlag);
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertTrue();
    });


    it('ShouldValidateIfMatchesExactlyOneOf', 0, () => {
      let result :boolean = validator.validate(name, oneOfSchema).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNotMatchExactlyOneOf', 0, () => {
      let result:boolean  = validator.validate(nametest, oneOfSchema).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotThrowIfValidWhenThrowErrorIsSet2', 0, () => {
      let isThrow = false;
      try {
        validator.validate(name, oneOfSchema, ErrorFlag);
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertFalse();
    });

    it('ShouldThrowIfInvalidWhenThrowErrorIsSet2', 0, () => {
      let isThrow = false;
      try {
        validator.validate(nametest, oneOfSchema, ErrorFlag);
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertTrue();
    });
  })
}