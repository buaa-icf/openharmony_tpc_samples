/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you mayNot use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed onAn "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OFAnY KIND, either express or implied.
 * See the License for the specific language governing permissionsAnd
 * limitations under the License.
 */

import { SchemaError, validate, ValidationError, Validator, ValidatorResult } from '@ohos/jsonschema'
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { AnUndefined,
  AnUndefineddata,
  arsing,
  asOmmite,
  chesThe,
  clusiveMinimum,
  clusiveMinimumdata,
  dateIf0Is,
  dateTrue,
  datetruedata,
  defalut,
  disallow,
  ength,
  engthad,
  engthed,
  engthfour,
  eprecated,
  ErrorFlag,
  fild,
  filed,
  finedInstance,
  foobar,
  foodata,
  footest,
  IsBelow,
  IsEven,
  MeetsMinimum,
  nestedErrorstext,
  NonInteger,
  NonIntegerdata,
  oneofdad,
  oneOfSchemadata,
  OneOfThe,
  Pattern,
  proper,
  quux,
  schemaErrorOnNull,
  schemaIgnore,
  scrison,
  Success,
  Successdata,
  TheMaximum,
  TheMaximumdata,
  TrueAsAny,
  TrueAsAnydata,
  ValidateIf,
  ValidateIfNum,
  ValidateNull, ValidNumber,
  WithDecimals } from './IntertfaceData';


let validator: Validator;
const BASE_COUNT = 1

export default function attributesTest() {
  describe('attributesTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      validator = new Validator();
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('ShouldValidateAValidNumber', 0, () => {
      let result:boolean  = validator.validate(0,ValidNumber ).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateAnInvalidNumber', 0, () => {
      let result:boolean  = validator.validate('0', ValidNumber).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateNaN', 0, () => {
      let result:boolean  = validator.validate(NaN, ValidNumber).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateInfinity1', 0, () => {
      let result :boolean = validator.validate(Infinity, ValidNumber).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateInfinity2', 0, () => {
      let result:boolean  = validator.validate(-Infinity,ValidNumber).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance1', 0, () => {
      let result:boolean  = validator.validate(undefined,finedInstance ).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateNull', 0, () => {
      let result:boolean  = validator.validate(null, ValidateNull).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateNoNull1', 0, () => {
      let result :boolean = validator.validate("0", ValidateNull).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance2', 0, () => {
      let result :boolean = validator.validate(undefined, AnUndefined).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateDate', 0, () => {
      let result :boolean = validator.validate(new Date(), AnUndefineddata).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateNoNull2', 0, () => {
      let result :boolean = validator.validate('0', AnUndefineddata).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance3', 0, () => {
      let result:boolean  = validator.validate(undefined, AnUndefined).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateInteger', 0, () => {
      let result:boolean  = validator.validate(12, NonInteger).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateNonInteger', 0, () => {
      let result:boolean  = validator.validate(0.25, NonInteger).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance4', 0, () => {
      let result :boolean = validator.validate(undefined, NonIntegerdata).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateTrue', 0, () => {
      let result:boolean  = validator.validate(true,dateTrue ).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateFalse', 0, () => {
      let result :boolean = validator.validate(false, dateTrue).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateNonBoolean', 0, () => {
      let result :boolean = validator.validate('true', dateTrue).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance5', 0, () => {
      let result:boolean  = validator.validate(undefined,datetruedata).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateTrueAsAny', 0, () => {
      let result:boolean  = validator.validate(true, TrueAsAny).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidatetruestrAsAny', 0, () => {
      let result:boolean  = validator.validate('true', TrueAsAny).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidate0AsAny', 0, () => {
      let result:boolean  = validator.validate(0, TrueAsAny).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateDateAsAny', 0, () => {
      let result :boolean = validator.validate(new Date(), TrueAsAny).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateAnUndefinedInstance6', 0, () => {
      let result :boolean = validator.validate(undefined, TrueAsAnydata).valid;
      expect(result).assertFalse();
    })
    it('ShouldIgnoreUndefined', 0, () => {

      let result1 :boolean = validator.validate(12, schemaIgnore).valid;
      expect(result1).assertFalse();
      let result2 :boolean = validator.validate("foo", schemaIgnore).valid;
      expect(result2).assertTrue();
    })
    it('ShouldErrorOnNull', 0, () => {
      try {
        validator.validate("foo", schemaErrorOnNull);
      } catch (err) {
        let types = (err instanceof SchemaError)
        expect(types).assertTrue()
        expect(err.message).assertEqual('Unexpected null in "type" keyword')
      }
    })
    it('doesNotValidateZeroSuccesses', 0, () => {
      let result:boolean  = validator.validate(true, oneOfSchemadata).valid
      expect(result).assertFalse();
    })
    it('validatesOneSuccess', 0, () => {
      let result:boolean  = validator.validate( Success,oneOfSchemadata).valid;
      expect(result).assertTrue();
    })
    it('doesNotValidateTwoSuccesses', 0, () => {
      let result:boolean  = validator.validate(Successdata, oneOfSchemadata).valid;
      expect(result).assertFalse();
    })
    it('ReportsInnerErrorsWithNestedErrorsFlag', 0, () => {
      expect(validator.validate(Successdata, oneOfSchemadata, nestedErrorstext(true)).errors.length).assertEqual(3);
    })

    it('FunctionsWithThrowErrorFlag', 0, () => {
      try {
        validator.validate(Successdata, oneOfSchemadata,ErrorFlag );
      } catch (err) {
        expect(err.message).assertContain('exactly one')
      }
      let isThrow = false;
      try {
        validator.validate(Success, oneOfSchemadata, ErrorFlag);
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertFalse()
    })

    it('ShouldValidateIfNumberMeetsMinimum', 0, () => {
      let result :boolean = validator.validate(1, MeetsMinimum).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsBelowMinimum', 0, () => {
      let result:boolean  = validator.validate(0, MeetsMinimum).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfNumberIsAboveMinimumUsingExclusiveMinimum', 0, () => {
      let result :boolean = validator.validate(1, clusiveMinimum).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsTheMinimumUsingExclusiveMinimum', 0, () => {
      let result:boolean  = validator.validate(1,clusiveMinimumdata).valid;
      expect(result).assertFalse();
    })

    it('ShouldValidateIfNumberIsBelowTheMaximum', 0, () => {
      let result:boolean  = validator.validate(1, TheMaximum).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsAboveMaximum', 0, () => {
      let result :boolean = validator.validate(3, TheMaximum).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfNumberIsBelowMaximumUsingExclusiveMinimum', 0, () => {
      let result:boolean  = validator.validate(1,TheMaximumdata).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsTheMaximumUsingExclusiveMinimum', 0, () => {
      let result :boolean = validator.validate(2, TheMaximumdata).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfNumberIsBelowThMaximum', 0, () => {
      let result :boolean = validator.validate(1,IsBelow ).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsAboveMinumum', 0, () => {
      let result :boolean = validator.validate(3, IsBelow).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIf0IsEven1', 0, () => {
      let result:boolean  = validator.validate(2,IsEven ).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIf2IsEven1', 0, () => {
      let result:boolean  = validator.validate(-2, IsEven).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidate1IsEven1', 0, () => {
      let result:boolean  = validator.validate(1, IsEven).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateDivisibleByWithDecimals', 0, () => {
      let result:boolean  = validator.validate(2.4,WithDecimals ).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIf0IsEven2', 0, () => {
      let result:boolean  = validator.validate(2,dateIf0Is ).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIf2IsEven2', 0, () => {
      let result :boolean = validator.validate(-2, dateIf0Is).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidate1IsEven2', 0, () => {
      let result:boolean  = validator.validate(1, dateIf0Is).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateMutlipleOfWithDecimals', 0, () => {
      let result :boolean = validator.validate(2.4, WithDecimals).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIfStringMatchesTheStringPattern', 0, () => {
      let result :boolean = validator.validate('abbbc',Pattern ).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIfStringMatchesTheRegexpPattern', 0, () => {
      let result :boolean = validator.validate('abbbc',chesThe ).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIfStringDoesNotMatchTheStringPattern', 0, () => {
      let result:boolean  = validator.validate('abac',Pattern).valid;
      expect(result).assertFalse();
    });
    it('ShouldReturnCorrectErrorMessageWhenParsingRegularExpression', 0, () => {
      let result:boolean  = validator.validate('abac',arsing ).errors[0].stack;
      expect(result).assertContain("/^a+$/");
    });
    it('SupportsInvalidNonUnicodePatternsDeprecated', 0, () => {
      let result1:boolean  = validator.validate('0{012}',eprecated ).valid;
      let result2:boolean  = validator.validate('0{123}', eprecated).valid;
      let result3:boolean  = validator.validate('0{012}', eprecated).valid;
      let result4:boolean  = validator.validate('0{123}', eprecated).valid;
      expect(result1).assertFalse();
      expect(result2).assertTrue();
      expect(result3).assertFalse();
      expect(result4).assertTrue();
    });
    it('ShouldValidateIfStringHasALengthLargerThanMinLength', 0, () => {
      let result :boolean = validator.validate('abcde',ength ).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfStringDoesHasALengthLessThanMinLength', 0, () => {
      let result :boolean = validator.validate('abcde', engthed).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateIfStringHasALengthEqualToMaxLength', 0, () => {
      let result:boolean  = validator.validate('abcde',engthad).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfStringDoesHasALengthLargerThanMaxLength', 0, () => {
      let result:boolean  = validator.validate('abcde', engthfour).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateIfStringIsOneOfTheEnumValues', 0, () => {
      let result :boolean = validator.validate('abcde',OneOfThe ).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfStringIsNotOneOfTheEnumValues', 0, () => {
      let result:boolean  = validator.validate('abcde', oneofdad).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateIfNumberIsOneOfTheEnumValues', 0, () => {
      let result :boolean = validator.validate(1, ValidateIfNum).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfNumberIsNotOneOfTheEnumValues', 0, () => {
      let result :boolean = validator.validate(3, ValidateIfNum).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateIfValueIsUndefinedButDefaultsToOneOfTheEnumValues', 0, () => {
      let result:boolean  = validator.validate(undefined, ValidateIf).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfValueIsUndefinedAndRequiredEvenIfADefaultIsGiven', 0, () => {
      let result :boolean = validator.validate(undefined, defalut).valid;
      expect(result).assertFalse();
    });
    it('ShouldNotValidateIfARequiredFieldIsOmmited', 0, () => {
      let result :boolean = validator.validate(new Object(),asOmmite ).valid;
      expect(result).assertFalse();
    });
    it('ShouldNotValidateIfARequiredFieldIsUndefined', 0, () => {
      let result:boolean  = validator.validate().valid;
      expect(result).assertFalse();
    });

    it('ShouldNotValidateIfAFieldInRequiredArrayIsUndefined', 0, () => {
      let result:boolean  = validator.validate(filed, proper).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateIfARequiredFieldHasAValueOutOfEnum', 0, () => {
      let result:boolean  = validator.validate(fild, asOmmite).valid;
      expect(result).assertTrue();
    });

    it('ShouldBeIgnored', 0, () => {
      let result:boolean  = validator.validate(1, scrison).valid;
      expect(result).assertTrue();
    });

    it('ShouldProhibitSpecifiedTypes', 0, () => {
      let result :boolean = validator.validate(1, disallow).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotProhibitUnprohibitedTypes', 0, () => {
      let result:boolean  = validator.validate(1, disallow).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateWithMissingNonDependedProperties', 0, () => {
      let result :boolean = validator.validate(foodata,quux).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateWithMissingDependencies', 0, () => {
      let result:boolean  = validator.validate(footest, quux).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateWithSatisfiedDependencies', 0, () => {
      let result:boolean  = validator.validate(foobar, quux).valid;
      expect(result).assertTrue();
    });

  })
}