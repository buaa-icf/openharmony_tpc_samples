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
import { dateInval, objectdata, typeresult, va } from './IntertfaceData';


let validator: Validator;

let validator1: Validator;

let validator2: Validator;
let format;

const BASE_COUNT = 1
let stringSchema = va
let objectSchema =objectdata

export default function formatsTest() {
  describe('formatsTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      validator = new Validator();
      validator1 = new Validator();
      validator2 = new Validator();
      validator1.customFormats.foo =  (input:string) =>{
        if (input === 'foo') {
          return true;
        }
        return false;
      };

      validator1.customFormats.float =  (input:string) =>{
        //console.log(input);
        return /^\d+(?:\.\d+)?$/.test(input);
      };

      format = () => {
      };
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('ShouldValidateAValidDateTime', 0, () => {
      let result :boolean = validator.validate("2012-07-08T16:41:41.532Z", typeresult('string','date-time')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateAValidDateTimeWithoutMilliseconds', 0, () => {
      let result:boolean  = validator.validate("2012-07-08T16:41:41Z", typeresult('string','date-time')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateADateTimeWithATimezoneOffsetInsteadOfZ', 0, () => {
      let result1:boolean  = validator.validate("2012-07-08T16:41:41.532+00:00", typeresult('string','date-time')).valid;
      expect(result1).assertTrue();
      let result2 :boolean = validator.validate("2012-07-08T16:41:41.532+05:30", typeresult('string','date-time')).valid;
      expect(result2).assertTrue();
      let result3 :boolean = validator.validate("2012-07-08T16:41:41.532+04:00", typeresult('string','date-time')).valid;
      expect(result3).assertTrue();
    });

    it('ShouldValidateADateTimeWithAZInsteadOfAZ', 0, () => {
      let result:boolean  = validator.validate("2012-07-08T16:41:41.532z", typeresult('string','date-time')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateADateTimeWithASpaceInsteadOfAT', 0, () => {
      let result:boolean  = validator.validate("2012-07-08 16:41:41.532Z", typeresult('string','date-time')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateADateTimeWithATInsteadOfAT', 0, () => {
      let result :boolean = validator.validate("2012-07-08t16:41:41.532Z", typeresult('string','date-time')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateADateTimeWithTheTimeMissing', 0, () => {
      let result:boolean  = validator.validate("2012-07-08", typeresult('string','date-time')).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotValidateAnInvalidDateTime', 0, () => {
      let result:boolean  = validator.validate("TEST2012-07-08T16:41:41.532Z", typeresult('string','date-time')).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotValidateADateTimeWithATimezoneOffsetANDAZ', 0, () => {
      let result1:boolean  = validator.validate("2012-07-08T16:41:41.532+00:00Z", typeresult('string','date-time')).valid;
      expect(result1).assertFalse();
      let result2 :boolean = validator.validate("2012-07-08T16:41:41.532+Z00:00", typeresult('string','date-time')).valid;
      expect(result2).assertFalse();
    });

    it('ShouldValidateAValidDate', 0, () => {
      let result :boolean = validator.validate("2012-07-08", typeresult('string','date')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateAnInvalidDate', 0, () => {
      let result:boolean  = validator.validate("TEST2012-07-08", typeresult('string','date')).valid;
      expect(result).assertFalse();
    });


    it('ShouldValidateAValidTime', 0, () => {
      let result:boolean  = validator.validate("16:41:41", typeresult('string','time')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateAnInvalidTime', 0, () => {
      let result:boolean  = validator.validate("16:41:41.532Z", typeresult('string','time')).valid;
      expect(result).assertFalse();
    });


    it('ShouldValidateAValidUtcMillisec', 0, () => {
      let result:boolean  = validator.validate("-1234567890", typeresult('string','utc-millisec')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateAnInvalidUtcMillisec', 0, () => {
      let result :boolean = validator.validate("16:41:41.532Z", typeresult('string','utc-millisec')).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateAValidRegex', 0, () => {
      let result:boolean  = validator.validate("/a/", typeresult('string','regex')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateAnInvalidRegex', 0, () => {
      let result:boolean  = validator.validate("/^(abc]/", typeresult('string','regex')).valid;
      expect(result).assertFalse();
    });


    it('ShouldValidateTheColorRed', 0, () => {
      let result:boolean  = validator.validate("red", typeresult('string','color')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateTheColorF00', 0, () => {
      let result:boolean  = validator.validate("#f00", typeresult('string','color')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateTheColorFf0000', 0, () => {
      let result:boolean  = validator.validate("#ff0000", typeresult('string','color')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateTheColorRgb', 0, () => {
      let result :boolean = validator.validate("rgb(255,0,0)", typeresult('string','color')).valid
      expect(result).assertTrue();
    });

    it('ShouldNotValidateAnInvalidColorJson', 0, () => {
      let result :boolean = validator.validate("json", typeresult('string','color')).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateAValidStyle', 0, () => {
      let result :boolean = validator.validate("color: red;", typeresult('string','color')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateAValidComplexStyle1', 0, () => {
      let result :boolean = validator.validate("color: red; position: absolute; background-color: rgb(204, 204, 204); max-width: 150px;", typeresult('string','style')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateAValidComplexStyle2', 0, () => {
      let result:boolean  = validator.validate("color:red;position:absolute; background-color:     rgb(204, 204, 204); max-width: 150px;", typeresult('string','style')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateAnInvalidStyle', 0, () => {
      let result :boolean = validator.validate("0", typeresult('string','style')).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateAValidStyleIfCalledTwiceWithTheSameInstance', 0, () => {
      let result1:boolean  = validator.validate("color: red;", typeresult('string','style')).valid;
      expect(result1).assertTrue();
      let result2 :boolean = validator.validate("color: red;", typeresult('string','style')).valid;
      expect(result2).assertTrue();
    });

    it('ShouldValidateAValidPhoneNumber', 0, () => {
      let result:boolean  = validator.validate("+31 42 123 4567", typeresult('string','phone')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateAnInvalidPhoneNumber', 0, () => {
      let result:boolean  = validator.validate("31 42 123 4567", typeresult('string','phone')).valid;
      expect(result).assertFalse();
    });


    it('ShouldValidateGoogle', 0, () => {
      let result:boolean  = validator.validate("http://www.google.com/", typeresult('string','uri')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateGoogleSearch', 0, () => {
      let result :boolean = validator.validate("http://www.google.com/search",  typeresult('string','uri')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateRelativeURIs', 0, () => {
      let result:boolean  = validator.validate("tdegrunt",  typeresult('string','uri')).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotValidateWithWhitespace', 0, () => {
      let result :boolean = validator.validate("The dog jumped",  typeresult('string','uri')).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateObamaWhitehouseGov', 0, () => {
      let result:boolean  = validator.validate("obama@whitehouse.gov",  typeresult('string','email')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateBarackObamaWhitehouseGov', 0, () => {
      let result :boolean = validator.validate("barack+obama@whitehouse.gov", typeresult('string','email')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateObama', 0, () => {
      let result :boolean = validator.validate("obama@", typeresult('string','email')).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidate19216801', 0, () => {
      let result:boolean  = validator.validate("192.168.0.1", typeresult('string','ip-address')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidate127001', 0, () => {
      let result:boolean  = validator.validate("127.0.0.1", typeresult('string','ip-address')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidate1921680', 0, () => {
      let result :boolean = validator.validate("192.168.0", typeresult('string','ip-address')).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotValidate2561680', 0, () => {
      let result :boolean = validator.validate("256.168.0", typeresult('string','ip-address')).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateFe801lo0', 0, () => {
      let result :boolean = validator.validate("fe80::1%lo0", typeresult('string','ipv6')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidate1', 0, () => {
      let result :boolean = validator.validate("::1", typeresult('string','ipv6')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidate127001', 0, () => {
      let result:boolean  = validator.validate("127.0.0.1", typeresult('string','ipv6')).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotValidateLocalhost', 0, () => {
      let result:boolean  = validator.validate("localhost",typeresult('string','ipv6')).valid;
      expect(result).assertFalse();
    });


    it('ShouldValidateLocalhost', 0, () => {
      let result:boolean  = validator.validate("localhost", typeresult('string','host-name')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateWwwGoogleCom', 0, () => {
      let result:boolean  = validator.validate("www.google.com", typeresult('string','host-name')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateWwwHiCom', 0, () => {
      let result:boolean  = validator.validate("www.-hi-.com", typeresult('string','host-name')).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateAlpha', 0, () => {
      let result:boolean  = validator.validate("alpha", typeresult('string','alpha')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateAbracadabra', 0, () => {
      let result:boolean  = validator.validate("abracadabra",  typeresult('string','alpha')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidate1test1', 0, () => {
      let result:boolean  = validator.validate("www.-hi-.com",  typeresult('string','alpha')).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateAlphanumeric', 0, () => {
      let result:boolean  = validator.validate("alpha",  typeresult('string','alphanumeric')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidate123', 0, () => {
      let result:boolean  = validator.validate("123", typeresult('string','alphanumeric')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateAbracadabra123', 0, () => {
      let result:boolean  = validator.validate("abracadabra123", typeresult('string','alphanumeric')).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidate1test2', 0, () => {
      let result:boolean  = validator.validate("1test!", typeresult('string','alphanumeric')).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateInput', 0, () => {
      let result :boolean = validator1.validate("foo", typeresult('string','foo')).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateNumericInput', 0, () => {
      let result:boolean  = validator1.validate(32.45, typeresult('string','float')).valid;
      expect(result).assertTrue();
    });

    it('ShouldFailInputThatFailsValidation', 0, () => {
      let result:boolean  = validator1.validate("boo", typeresult('string','foo')).valid;
      expect(result).assertFalse();
    });

    it('ShouldFailNumericInputThatFailsValidation', 0, () => {
      let result:boolean  = validator1.validate(NaN, typeresult('string','float')).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotBeAssignedToTheValidatorPrototype', 0, () => {
      validator.customFormats.boo = format;
      validator1.customFormats.boo = format;
      validator2.customFormats.boo = format;
      let types = typeof Validator.prototype.customFormats.boo
      expect(types).assertEqual('undefined');
    });
    it('ShouldBeAssignedToTheInstances', 0, () => {
      format = () => {
      };
      Validator.prototype.customFormats.boo = format;
      let types = typeof ((new Validator()).customFormats.boo)
      expect(types).assertEqual('function')
       Validator.prototype.customFormats.boo;
    });

    it('ShouldValidateInvalidFormats', 0, () => {
      let result :boolean = validator.validate("2012-07-08", typeresult('string','date-time'),dateInval ).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidate', 0, () => {
      let result :boolean = validator.validate("url", typeresult('string','url')).valid;
      expect(result).assertTrue();
    });
  })
}