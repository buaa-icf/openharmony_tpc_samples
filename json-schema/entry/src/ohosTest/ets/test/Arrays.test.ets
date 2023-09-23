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
import { ANonArray, DuplicateItem, DuplicateObjects, EqualToMinItems, NotAnArray, Validate } from './IntertfaceData';

let validator: Validator;
const BASE_COUNT = 1

export default function arrayTest() {
  describe('arrayTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      validator = new Validator();
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('ShouldValidateAnEmptyArray', 0, () => {
      let result:boolean  = validator.validate([], Validate).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateAnUndefinedArray', 0, () => {
      let result:boolean  = validator.validate(undefined, Validate).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateAnArrayWithStrings', 0, () => {
      let result:boolean  = validator.validate(['1', '2', '3'], Validate).valid;
      expect(result).assertTrue();
    })
    it('shouldNotValidateAnArrayNotAllStrings', 0, () => {
      expect(validate(['1', '2', '3', 4], Validate).valid).assertFalse();
      expect(validate(['1', '2', '3', 4], Validate).errors.length).assertEqual(1);
      expect(validate(['1', '2', '3', 4], Validate).errors[0].property).assertEqual('instance[3]');
      expect(validate(['1', '2', '3', 4], Validate).errors[0].path.length).assertEqual(1);
      expect(validate(['1', '2', '3', 4], Validate).errors[0].path[0]).assertEqual(3);
    })
    it('shouldNotValidateANonArray', 0, () => {
      let result:boolean  = validator.validate(0, ANonArray).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfArrayHasALengthEqualToMinItems1', 0, () => {
      let result:boolean  = validator.validate([1, 2, 3], EqualToMinItems).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateIfArrayHasALengthEqualToMinItems2', 0, () => {
      let result:boolean  = validator.validate([1, 2], EqualToMinItems).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfArrayHasALengthLessThanMinItems', 0, () => {
      expect(validator.validate([1], EqualToMinItems).valid).assertFalse();
      expect(validator.validate([1], EqualToMinItems).errors[0].name).assertEqual('minItems');
      expect(validator.validate([1], EqualToMinItems).errors[0].property).assertEqual('instance');
      expect(validator.validate([1], EqualToMinItems).errors[0].path.length).assertEqual(0);
    })
    it('ShouldValidateIfArrayHasALengthLessThanMaxItems', 0, () => {
      let result:boolean  = validator.validate([1], EqualToMinItems).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateIfArrayHasALengthEqualToMaxItems', 0, () => {
      let result:boolean  = validator.validate([1], EqualToMinItems).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateIfArrayHasALengthLargerThanMaxItems', 0, () => {
      let result:boolean  = validator.validate([1, 2, 3], EqualToMinItems).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfArrayHasNoDuplicateItems', 0, () => {
      let result :boolean = validator.validate([1],DuplicateItem ).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateIfArrayHasNoDuplicateObjects', 0, () => {
      let result:boolean = validator.validate([1, 2, "1", "2", DuplicateObjects,DuplicateObjects,NotAnArray]).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfArrayHasDuplicateNumbers', 0, () => {
      let result:boolean = validator.validate([1, 2, 4, 1, 3, 5], DuplicateItem).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateIfArrayHasDuplicateObjects', 0, () => {
      let result :boolean= validator.validate([DuplicateObjects,DuplicateObjects], NotAnArray).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfNotAnArray', 0, () => {
      let result:boolean = validator.validate(null,NotAnArray ).valid;
      expect(result).assertTrue();
    })
  })
}