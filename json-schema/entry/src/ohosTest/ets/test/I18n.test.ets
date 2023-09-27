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
  ANonArray,
  AnUndefineddata,
  argument,
  dateTrue,
  disallow,
  DuplicateItem,
  engthed,
  engthfour,
  engthfourdata,
  EqualToMinItems,
  finedInstance,
  footest,
  IsEven,
  mixed, NonInteger,
  oneofdad,
  Pattern,
  provide,
  quux,
  TheMaximumda,
  TheMaximumtext,
  TheMinimum,
  TheMinimumdata,
  TrueAsAnydata,
  typeresult,
  Validate,
  ValidateNull, ValidNumber } from './IntertfaceData';


let validator: ESObject;
const BASE_COUNT = 1
const mixedSchema =mixed


export default function i18nTest() {
  describe('i18nTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      validator = new Validator();
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    _it('number should provide an error name', 0, () => {
      let result :string = validator.validate('not-number', ValidNumber).errors[0].name;
      expect(result).assertEqual('type')
    });

    _it('number should provide an error argument', 0, () => {
      expect(validator.validate('not-number', ValidNumber).errors[0].argument).not().assertNull()
    });

    _it('required should provide an error name', 0, () => {
      let result :string = validator.validate(undefined,finedInstance).errors[0].name
      expect(result).assertEqual('required')

    });
    _it('null should provide an error name', 0, () => {
      let result:string  = validator.validate('0', ValidateNull).errors[0].name
      expect(result).assertEqual('type')
    });

    _it('date should provide an error name', 0, () => {
      let result :string = validator.validate('0', AnUndefineddata).errors[0].name
      expect(result).assertEqual('type')
    });

    _it('should provide an error argument', 0, () => {
      expect(validator.validate('0', AnUndefineddata).errors[0].argument).not().assertNull()
    });
    _it('integer should provide an error name', 0, () => {
      let result :string = validator.validate(0.25, NonInteger).errors[0].name
      expect(result).assertEqual('type')
    });

    _it('integer should provide an error argument', 0, () => {
      expect(validator.validate(0.25, NonInteger).errors[0].argument).not().assertNull()
    });
    _it('boolean should provide an error name', 0, () => {
      let result :string = validator.validate('true', dateTrue).errors[0].name
      expect(result).assertEqual('type')
    });

    _it('boolean should provide an error argument', 0, () => {
      expect(validator.validate('true', dateTrue).errors[0].argument).not().assertNull()
    });
    _it('any should provide an error name', 0, () => {
      let result :string = validator.validate(undefined, TrueAsAnydata).errors[0].name
      expect(result).assertEqual('required')
    });
    _it('minimum should provide an error name', 0, () => {
      let result:string  = validator.validate(1, TheMinimum).errors[0].name
      expect(result).assertEqual('minimum')
    });

    _it('minimum should provide an error argument', 0, () => {
      expect(validator.validate(1, TheMinimum).errors[0].argument).not().assertNull()
    });
    _it('exclusiveMinimum should provide an error name', 0, () => {
      let result:string  = validator.validate(1, TheMinimumdata)
        .errors[0]
        .name
      expect(result).assertEqual('minimum')
    });

    _it('exclusiveMinimum should provide an error argument', 0, () => {
      expect(validator.validate(1,TheMinimumdata).errors[0].argument).not().assertNull()
    });

    _it('maximum should provide an error name', 0, () => {
      let result:string  = validator.validate(3, TheMaximumda).errors[0].name
      expect(result).assertEqual('maximum');
    });

    _it('maximum should provide an error argument', 0, () => {
      expect(validator.validate(3, TheMaximumda).errors[0].argument).not().assertNull()
    });

    _it('exclusiveMaximum should provide an error name', 0, () => {
      let result :string = validator.validate(2, TheMaximumtext).errors[0].name
      expect(result).assertEqual('maximum');
    });

    _it('exclusiveMaximum should provide an error argument', 0, () => {
      expect(validator.validate(2, TheMaximumtext).errors[0].argument).not().assertNull()
    });

    _it('divisibleBy should provide an error name', 0, () => {
      let result :string = validator.validate(1, IsEven).errors[0].name
      expect(result).assertEqual('divisibleBy');
    });

    _it('divisibleBy should provide an error argument', 0, () => {
      expect(validator.validate(1, IsEven).errors[0].argument).not().assertNull()
    });
    _it('pattern should provide an error name', 0, () => {
      let result:string  = validator.validate('abac', Pattern).errors[0].name;
      expect(result).assertEqual('pattern');
    });

    _it('pattern should provide an error argument', 0, () => {
      expect(validator.validate('abac', Pattern).errors[0].argument).not().assertNull()
    });

    _it('minLength should provide an error name', 0, () => {
      let result :string= validator.validate('abcde', engthed).errors[0].name
      expect(result).assertEqual('minLength');
    });

    _it('minLength should provide an error argument', 0, () => {
      expect(validator.validate('abcde', engthed).errors[0].argument).not().assertNull()
    });

    _it('maxLength should provide an error name', 0, () => {
      let result:string  = validator.validate('abcde', engthfour)
        .errors[0]
        .name
      expect(result).assertEqual('maxLength');
    });

    _it('maxLength should provide an error argument', 0, () => {
      expect(validator.validate('abcde', engthfourdata).errors[0].argument).not().assertNull()
    });

    _it('enum should provide an error name', 0, () => {
      let result:string  = validator.validate('abcde', oneofdad).errors[0].name
      expect(result).assertEqual('enum');
    });

    _it('enum should provide an error argument', 0, () => {

      expect(validator.validate('abcde', oneofdad).errors[0].argument).not().assertNull()
    });

    _it('not should provide an error name', 0, () => {
      let result:string  = validator.validate([1], disallow).errors[0].name
      expect(result).assertEqual('not');
    });

    _it('not should provide an error argument', 0, () => {
      expect(validator.validate([1], disallow).errors[0].argument).not().assertNull()
    });

    _it('not should prohibit specified types', 0, () => {
      let result:boolean  = validator.validate([1], disallow).valid;
      expect(result).assertFalse();
    });

    _it('disallow should provide an error name', 0, () => {
      let result:string  = validator.validate([1], disallow).errors[0].name
      expect(result).assertEqual('not');
      ;
    });

    _it('disallow should provide an error argument', 0, () => {

      expect(validator.validate([1], disallow).errors[0].argument).not().assertNull()
    });

    _it('disallow should prohibit specified types', 0, () => {
      let result:boolean  = validator.validate([1], disallow).valid
      expect(result).assertFalse();
    });
    _it('dependencies should provide an error name', 0, () => {
      let result:string  = validator.validate(footest, quux).errors[0].name
      expect(result).assertEqual('dependencies');
      ;
    });

    _it('dependencies should provide an error argument', 0, () => {
      expect(validator.validate(footest, quux).errors[0].argument).not().assertNull()
    });
    _it('DateTime should provide an error name', 0, () => {
      let result:string  = validator.validate("2012-07-08", typeresult('string','date-time'))
        .errors[0]
        .name
      expect(result).assertEqual('format');
    });

    _it('DateTime should provide an error argument', 0, () => {
      expect(validator.validate("2012-07-08", typeresult('string','date-time')).errors[0].argument).assertEqual('date-time');
    });
    _it('date should provide an error name', 0, () => {
      let result:string  = validator.validate("TEST2012-07-08", typeresult('string','date')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('date should provide an error argument', 0, () => {
      expect(validator.validate("TEST2012-07-08", typeresult('string','date')).errors[0].argument).assertEqual('date');
    });

    _it('time should provide an error name', 0, () => {
      let result:string  = validator.validate("16:41:41.532Z", typeresult('string','time')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('time should provide an error argument', 0, () => {
      expect(validator.validate("16:41:41.532Z", typeresult('string','time')).errors[0].argument).assertEqual('time');
    });
    _it('UtcMillisec should provide an error name', 0, () => {
      let result :string = validator.validate("16:41:41.532Z", typeresult('string','utc-millisec')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('UtcMillisec should provide an error argument', 0, () => {
      expect(validator.validate("16:41:41.532Z", typeresult('string','utc-millisec')).errors[0].argument).assertEqual('utc-millisec');
    });
    _it('regex should provide an error name', 0, () => {
      let result :string = validator.validate("/^(abc]/", typeresult('string','regex')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('regex should provide an error argument', 0, () => {
      expect(validator.validate("/^(abc]/", typeresult('string','regex')).errors[0].argument).assertEqual('regex');
    });
    _it('color should provide an error name', 0, () => {
      let result :string = validator.validate("json", typeresult('string','color')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('color should provide an error argument', 0, () => {
      expect(validator.validate("json", typeresult('string','color')).errors[0].argument).assertEqual('color');
    });
    _it('style should provide an error name', 0, () => {
      let result :string = validator.validate("0", typeresult('string','style')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('style should provide an error argument', 0, () => {
      expect(validator.validate("0",  typeresult('string','style')).errors[0].argument).assertEqual('style');
    });
    _it('phone should provide an error name', 0, () => {
      let result :string = validator.validate("31 42 123 4567",  typeresult('string','phone')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('phone should provide an error argument', 0, () => {
      expect(validator.validate("31 42 123 4567",  typeresult('string','phone')).errors[0].argument).assertEqual('phone');
    });
    _it('uri should provide an error name', 0, () => {
      let result :string = validator.validate("tdegrunt", typeresult('string','uri')).errors[0].name
      expect(result).assertEqual('format');

    });

    _it('uri should provide an error argument', 0, () => {
      expect(validator.validate("tdegrunt",  typeresult('string','uri')).errors[0].argument).assertEqual('uri');
    });

    _it('email should provide an error name', 0, () => {
      let result :string = validator.validate("obama@",  typeresult('string','email')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('email should provide an error argument', 0, () => {
      expect(validator.validate("obama@", typeresult('string','email')).errors[0].argument).assertEqual('email');
    });
    _it('IpAddress should provide an error name', 0, () => {
      let result :string = validator.validate("192.168.0", typeresult('string','ip-address')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('IpAddress should provide an error argument', 0, () => {
      expect(validator.validate("192.168.0", typeresult('string','ip-address')).errors[0].argument).assertEqual('ip-address');
    });
    _it('ipv6 should provide an error name', 0, () => {
      let result :string = validator.validate("127.0.0.1", typeresult('string','ipv6')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('ipv6 should provide an error argument', 0, () => {
      expect(validator.validate("127.0.0.1", typeresult('string','ipv6')).errors[0].argument).assertEqual('ipv6');
    });
    _it('HostName should provide an error name', 0, () => {
      let result :string = validator.validate("www.-hi-.com", typeresult('string','host-name')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('HostName should provide an error argument', 0, () => {
      expect(validator.validate("www.-hi-.com", typeresult('string','host-name')).errors[0].argument).assertEqual('host-name');
    });

    _it('alpha should provide an error name', 0, () => {
      let result :string = validator.validate("www.-hi-.com", typeresult('string','alpha')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('alpha should provide an error argument', 0, () => {
      expect(validator.validate("www.-hi-.com", typeresult('string','alpha')).errors[0].argument).assertEqual('alpha');
    });

    _it('alphanumeric should provide an error name', 0, () => {
      let result :string = validator.validate("1test!", typeresult('string','alphanumeric')).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('alphanumeric should provide an error argument', 0, () => {
      expect(validator.validate("1test!", typeresult('string','alphanumeric')).errors[0].argument).assertEqual('alphanumeric');
    });

    _it('simple array should provide an error name', 0, () => {
      let result :string = validator.validate(0, ANonArray).errors[0].name
      expect(result).assertEqual('type');
    });

    _it('simple array should provide an error argument', 0, () => {
      expect(validator.validate(0, ANonArray).errors[0].argument).not().assertNull()
    });
    _it('attribute on array items should provide an error name', 0, () => {
      let result:string  = validator.validate(['1', '2', '3', 4], Validate).errors[0].name
      expect(result).assertEqual('type');
      ;
    });

    _it('attribute on array items should provide an error argument', 0, () => {
      expect(validator.validate(['1', '2', '3', '4$'],argument ).errors[0].argument).assertEqual('alphanumeric');
    });
    _it('minItems should provide an error name', 0, () => {
      let result:string  = validator.validate([1], EqualToMinItems ).errors[0].name
      expect(result).assertEqual('minItems');
    });

    _it('minItems should provide an error argument', 0, () => {
      expect(validator.validate([1], EqualToMinItems ).errors[0].argument).not().assertNull()
    });
    _it('maxItems should provide an error name', 0, () => {
      let result :string = validator.validate([1, 2, 3], EqualToMinItems ).errors[0].name
      expect(result).assertEqual('maxItems');
    });

    _it('maxItems should provide an error argument', 0, () => {
      expect(validator.validate([1, 2, 3], EqualToMinItems ).errors[0].argument).not().assertNull()
    });

    _it('uniqueItems should provide an error name', 0, () => {
      let result:string  = validator.validate([1, 2, 4, 1, 3, 5], DuplicateItem).errors[0].name
      expect(result).assertEqual('uniqueItems');
    });
    _it('Mixed should provide an error name', 0, () => {
      let result:string  = validator.validate(provide, mixedSchema).errors[0].name
      expect(result).assertEqual('format');
    });

    _it('Mixed should provide an error argument', 0, () => {
      expect(validator.validate(provide, mixedSchema).errors[0].argument).assertEqual('alphanumeric');
    });
  })
}