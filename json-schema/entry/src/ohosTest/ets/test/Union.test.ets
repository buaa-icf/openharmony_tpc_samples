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
import {
  alidate,
  alidateFo,
  Emptyschema,
  excdata, ForNull, ForNumber,
  mptysc,
  nullinstance,
  objectIdSchemadata,
  orArra,
  schemaunion, typeFn, unionschema,
  unitonschema,
  wildcard,
  wildcarschema,
  worldinstance
} from './IntertfaceData';


let validator: ESObject;
const BASE_COUNT = 1
let testSchema = typeFn('string');

let numSchema = typeFn('number');




export default function unionTest() {
  describe('unionTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      validator = new Validator();
      validator.addSchema(testSchema, '/Test#Simple');
      validator.addSchema(numSchema, '/Test#Num');
      validator.addSchema(objectIdSchemadata, '/MongoDb#ObjectId');
    })
    afterEach(() => {
    })
    afterAll(() => {
    })


    it('ShouldValidateForNumber', 0, () => {
      let result:boolean  = validator.validate(1, ForNumber).valid
      expect(result).assertTrue();
    });
    it('ShouldValidateForString1', 0, () => {
      let result :boolean = validator.validate('1', ForNumber).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNoStringOrNumber1', 0, () => {
      let result:boolean  = validator.validate(true, ForNumber).valid;
      expect(result).assertFalse();
    });

    it('shouldValidateForNull1', 0, () => {
      let result :boolean = validator.validate(null,ForNull ).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateForString2', 0, () => {
      let result:boolean  = validator.validate('1', ForNull).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNoStringOrNumber2', 0, () => {
      let result :boolean = validator.validate(true, ForNull).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateForNull2', 0, () => {
      let result :boolean = validator.validate(null,ForNull).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateForString3', 0, () => {
      let result :boolean = validator.validate('1', ForNull).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNoStringOrNumber3', 0, () => {
      let result :boolean = validator.validate(true, ForNull).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateForNull3', 0, () => {
      let result:boolean  = validator.validate(null,alidateFo ).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateForString4', 0, () => {
      let result :boolean = validator.validate('test', alidateFo).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNoStringOrNumber4', 0, () => {
      let result :boolean = validator.validate(true, alidateFo).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateFor', 0, () => {
      let result :boolean = validator.validate('*', alidate).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateFor1', 0, () => {
      let result:boolean  = validator.validate(1, alidate).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateFor', 0, () => {
      let result:boolean  = validator.validate('-', alidate).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateForArrayOr', 0, () => {

      let result :boolean = validator.validate(orArra, unitonschema).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateFoEmptyArray', 0, () => {

      let result:boolean  = validator.validate(mptysc, Emptyschema ).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateForObjectId', 0, () => {
      let result :boolean = validator.validate(wildcard, wildcarschema).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateForObjectidAndIgnoreTitleAndDescription', 0, () => {
      let result :boolean = validator.validate(wildcard, schemaunion).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateForNulls', 0, () => {
      let result:boolean  = validator.validate(nullinstance, unionschema).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateForNullAndString', 0, () => {

      let result :boolean = validator.validate(nullinstance, unionschema).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateForStringAndString', 0, () => {

      let result :boolean = validator.validate(worldinstance, unionschema).valid;
      expect(result).assertFalse();
    });
  })
}