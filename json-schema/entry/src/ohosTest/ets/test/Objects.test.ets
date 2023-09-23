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
import {
  additionalschema,
  baz,
  constru, construdata,
  extra,
  extradata,
  nameobject,
  nest,
  nestobj,
  nesttext,
  objectaddition,
  objectaddress,
  objectneste,
  objectproper,
  objectrequ,
  objectschema,
  objectschemanull,
  onstructor, proobject,
  ternProperschema,
  typeFn } from './IntertfaceData';

let validator: Validator;
const BASE_COUNT = 1
let initSchema =onstructor

export default function objectsTest() {
  describe('objectsTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      validator = new Validator();
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    _it('should validate a valid object', 0, () => {
      let result :boolean = validator.validate(new Object, typeFn('object')).valid;
      expect(result).assertTrue();
    });

    _it('should validate an undefined object', 0, () => {
      let result:boolean  = validator.validate(undefined, typeFn('object')).valid;
      expect(result).assertTrue();
    });

    _it('should not validate a number', 0, () => {
      let result:boolean  = validator.validate(0,typeFn('object')).valid;
      expect(result).assertFalse();
    });

    _it('should not validate an array', 0, () => {
      let result:boolean  = validator.validate([0], typeFn('object')).valid;
      expect(result).assertFalse();
    });
    _it('should validate a valid object', 0, () => {
      let result:boolean  = validator.validate(nameobject, proobject).valid;
      expect(result).assertTrue();
    });

    _it('should not validate an invalid object', 0, () => {
      let result :boolean = validator.validate(0,typeFn('object')).valid;
      expect(result).assertFalse();
    });

    _it('should validate a valid property', 0, () => {
      expect(validator.validate(Object.create(constru), initSchema).valid).assertDeepEquals(true)
    });
    _it('should not validate an invalid property', 0, () => {
      expect(validator.validate(Object.create(construdata), initSchema).valid).assertDeepEquals(false)
      expect(validator.validate(Object.create(construdata), initSchema).errors[0].name).assertEqual('type')
    });
    _it('should not validate a missing property', 0, () => {
      expect(validator.validate(Object.create(new Object), initSchema).valid).assertDeepEquals(false)
      expect(validator.validate(Object.create(new Object), initSchema).errors[0].name).assertEqual('required')
    });
    _it('should validate a valid object with multiple properties', 0, () => {
      let result :boolean = validator.validate(objectaddress, objectproper).valid;
      expect(result).assertTrue();
    });

    _it('should validate a valid object with undefined property', 0, () => {
      let result :boolean = validator.validate(nameobject, objectproper).valid;
      expect(result).assertTrue();
    });

    _it('should not throw when checking properties on a non-object', 0, () => {
      let result :boolean = validator.validate(null, proobject).valid;
      expect(result).assertFalse();
    });
    _it('should NOT validate a valid object', 0, () => {
      let result:boolean  = validator.validate(nest, nesttext).valid;
      expect(result).assertFalse();
    });

    _it('should validate a valid object', 0, () => {
      let result:boolean  = validator.validate(nest, nesttext).valid;
      expect(result).assertTrue();
    });
    _it('should NOT validate an undefined object', 0, () => {
      let ret :boolean = validator.validate(baz, objectrequ).valid;
      expect(ret).assertFalse();
    });

    _it('should validate if there are no additionalProperties', 0, () => {
      let result:boolean  = validator.validate(nest, objectneste).valid;
      expect(result).assertTrue();
    });

    _it('should not validate if there are additionalProperties', 0, () => {
      let result:boolean  = validator.validate(extra, objectneste).valid;
      expect(result).assertFalse();
    });

    _it('should validate if the additionalProperties are compliant with additionalProperties', 0, () => {
      let result:boolean  = validator.validate(extra, objectaddition).valid;
      expect(result).assertTrue();
    });

    _it('should not validate if the additionalProperties are not compliant with additionalProperties', 0, () => {
      let result:boolean  = validator.validate(
        extradata,
        objectaddition
      ).valid;
      expect(result).assertFalse();
    });
    _it('should treat undefined property schema as not existing', 0, () => {

      let result1:boolean  = validator.validate(nestobj, objectschema).valid;
      expect(result1).assertTrue();
      let result2 :boolean = validator.validate(nest, objectschema).valid;
      expect(result2).assertFalse();
    });

    _it('should not permit null as a schema', 0, () => {

      try {
        validator.validate(nestobj, additionalschema);
      } catch (err) {
        let types = (err instanceof SchemaError)
        expect(types).assertTrue();
        expect(err.message).assertDeepEquals('Unexpected null, expected schema in "properties"');
      }
    });


    _it('should treat undefined property schema as not existing', 0, () => {

      let result1:boolean  = validator.validate(
        nestobj,
        ternProperschema
      ).valid;
      expect(result1).assertTrue()

      let result2 :boolean = validator.validate(
        nest,
        ternProperschema
      ).valid;
      expect(result2).assertFalse()
    });

    _it('should not permit null as a schema', 0, () => {
      try {
        validator.validate(
          nest,
          objectschemanull
        );
      } catch (err) {
        let types = (err instanceof SchemaError)
        expect(types).assertTrue();
        expect(err.message).assertDeepEquals('Unexpected null, expected schema in "patternProperties"');
      }
    });
  });
}