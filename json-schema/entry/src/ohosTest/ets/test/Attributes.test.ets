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

// @ts-ignore
var validator: Validator;
const BASE_COUNT = 1
var oneOfSchema = {
  oneOf: [
    { type: 'string' },
    { enum: [0, 1] },
    { type: 'object', required: ['type'] },
    { type: 'object', required: ['name'] },
  ],
};

export default function attributesTest() {
  describe('attributesTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
      validator = new Validator();
    })
    afterEach(function () {
    })
    afterAll(function () {
    })
    it('ShouldValidateAValidNumber', 0, function () {
      let result = validator.validate(0, {
        'type': 'number'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateAnInvalidNumber', 0, function () {
      let result = validator.validate('0', {
        'type': 'number'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateNaN', 0, function () {
      let result = validator.validate(NaN, {
        'type': 'number'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateInfinity1', 0, function () {
      let result = validator.validate(Infinity, {
        'type': 'number'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateInfinity2', 0, function () {
      let result = validator.validate(-Infinity, {
        'type': 'number'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance1', 0, function () {
      let result = validator.validate(undefined, {
        'type': 'number', 'required': true
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateNull', 0, function () {
      let result = validator.validate(null, {
        'type': 'null'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateNoNull1', 0, function () {
      let result = validator.validate("0", {
        type: "null"
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance2', 0, function () {
      let result = validator.validate(undefined, {
        'type': 'date', 'required': true
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateDate', 0, function () {
      let result = validator.validate(new Date(), {
        'type': 'date'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateNoNull2', 0, function () {
      let result = validator.validate('0', {
        'type': 'date'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance3', 0, function () {
      let result = validator.validate(undefined, {
        'type': 'date', 'required': true
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateInteger', 0, function () {
      let result = validator.validate(12, {
        'type': 'integer'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateNonInteger', 0, function () {
      let result = validator.validate(0.25, {
        'type': 'integer'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance4', 0, function () {
      let result = validator.validate(undefined, {
        'type': 'integer', 'required': true
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateTrue', 0, function () {
      let result = validator.validate(true, {
        'type': 'boolean'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateFalse', 0, function () {
      let result = validator.validate(false, {
        'type': 'boolean'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateNonBoolean', 0, function () {
      let result = validator.validate('true', {
        'type': 'boolean'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldNotValidateAnUndefinedInstance5', 0, function () {
      let result = validator.validate(undefined, {
        'type': 'boolean', 'required': true
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateTrueAsAny', 0, function () {
      let result = validator.validate(true, {
        'type': 'any'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidatetruestrAsAny', 0, function () {
      let result = validator.validate('true', {
        'type': 'any'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidate0AsAny', 0, function () {
      let result = validator.validate(0, {
        'type': 'any'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldValidateDateAsAny', 0, function () {
      let result = validator.validate(new Date(), {
        'type': 'any'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateAnUndefinedInstance6', 0, function () {
      let result = validator.validate(undefined, {
        'type': 'any', 'required': true
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldIgnoreUndefined', 0, function () {
      var schema = {
        type: [undefined, "string"],
      };
      let result1 = validator.validate(12, schema).valid;
      expect(result1).assertFalse();
      let result2 = validator.validate("foo", schema).valid;
      expect(result2).assertTrue();
    })
    it('ShouldErrorOnNull', 0, function () {
      var schema = {
        type: [null, "string"],
      };
      try {
        validator.validate("foo", schema);
      } catch (err) {
        let types = (err instanceof SchemaError)
        expect(types).assertTrue()
        expect(err.message).assertEqual('Unexpected null in "type" keyword')
      }
    })
    it('doesNotValidateZeroSuccesses', 0, function () {
      let result = validator.validate(true, oneOfSchema).valid
      expect(result).assertFalse();
    })
    it('validatesOneSuccess', 0, function () {
      let result = validator.validate({
        type: true
      }, oneOfSchema).valid;
      expect(result).assertTrue();
    })
    it('doesNotValidateTwoSuccesses', 0, function () {
      let result = validator.validate({
        type: true, name: true
      }, oneOfSchema).valid;
      expect(result).assertFalse();
    })
    it('ReportsInnerErrorsWithNestedErrorsFlag', 0, function () {
      let result = validator.validate({
        type: true, name: true
      }, oneOfSchema, {
        nestedErrors: true
      }).errors;
      expect(result.length).assertEqual(3);
    })

    it('FunctionsWithThrowErrorFlag', 0, function () {
      try {
        validator.validate({
          type: true, name: true
        }, oneOfSchema, {
          throwError: true
        });
      } catch (err) {
        expect(err.message).assertContain('exactly one')
      }
      var isThrow = false;
      try {
        validator.validate({
          type: true
        }, oneOfSchema, {
          throwError: true
        });
      } catch (err) {
        isThrow = true;
      }
      expect(isThrow).assertFalse()
    })

    it('ShouldValidateIfNumberMeetsMinimum', 0, function () {
      let result = validator.validate(1, {
        'type': 'number', 'minimum': '1'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsBelowMinimum', 0, function () {
      let result = validator.validate(0, {
        'type': 'number', 'minimum': '1'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfNumberIsAboveMinimumUsingExclusiveMinimum', 0, function () {
      let result = validator.validate(1, {
        'type': 'number', 'minimum': '0', 'exclusiveMinimum': true
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsTheMinimumUsingExclusiveMinimum', 0, function () {
      let result = validator.validate(1, {
        'type': 'number', 'minimum': '1', 'exclusiveMinimum': true
      }).valid;
      expect(result).assertFalse();
    })

    it('ShouldValidateIfNumberIsBelowTheMaximum', 0, function () {
      let result = validator.validate(1, {
        'type': 'number', 'maximum': '2'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsAboveMaximum', 0, function () {
      let result = validator.validate(3, {
        'type': 'number', 'maximum': '2'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfNumberIsBelowMaximumUsingExclusiveMinimum', 0, function () {
      let result = validator.validate(1, {
        'type': 'number', 'maximum': '2', 'exclusiveMaximum': true
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsTheMaximumUsingExclusiveMinimum', 0, function () {
      let result = validator.validate(2, {
        'type': 'number', 'maximum': '2', 'exclusiveMaximum': true
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIfNumberIsBelowThMaximum', 0, function () {
      let result = validator.validate(1, {
        'type': 'number', 'minimum': '1', 'maximum': '2'
      }).valid;
      expect(result).assertTrue();
    })
    it('ShouldNotValidateIfNumberIsAboveMinumum', 0, function () {
      let result = validator.validate(3, {
        'type': 'number', 'minimum': '1', 'maximum': '2'
      }).valid;
      expect(result).assertFalse();
    })
    it('ShouldValidateIf0IsEven1', 0, function () {
      let result = validator.validate(2, {
        'type': 'number', 'divisibleBy': 2
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIf2IsEven1', 0, function () {
      let result = validator.validate(-2, {
        'type': 'number', 'divisibleBy': 2
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidate1IsEven1', 0, function () {
      let result = validator.validate(1, {
        'type': 'number', 'divisibleBy': 2
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateDivisibleByWithDecimals', 0, function () {
      let result = validator.validate(2.4, {
        'type': 'number', 'divisibleBy': 0.1
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIf0IsEven2', 0, function () {
      let result = validator.validate(2, {
        'type': 'number', 'multipleOf': 2
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIf2IsEven2', 0, function () {
      let result = validator.validate(-2, {
        'type': 'number', 'multipleOf': 2
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidate1IsEven2', 0, function () {
      let result = validator.validate(1, {
        'type': 'number', 'multipleOf': 2
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateMutlipleOfWithDecimals', 0, function () {
      let result = validator.validate(2.4, {
        'type': 'number', 'multipleOf': 0.1
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIfStringMatchesTheStringPattern', 0, function () {
      let result = validator.validate('abbbc', {
        'type': 'string', 'pattern': 'ab+c'
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIfStringMatchesTheRegexpPattern', 0, function () {
      let result = validator.validate('abbbc', {
        'type': 'string', 'pattern': /ab+c/
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateIfStringDoesNotMatchTheStringPattern', 0, function () {
      let result = validator.validate('abac', {
        'type': 'string', 'pattern': 'ab+c'
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldReturnCorrectErrorMessageWhenParsingRegularExpression', 0, function () {
      let result = validator.validate('abac', {
        'type': 'string', 'pattern': /^a+$/
      }).errors[0].stack;
      expect(result).assertContain("/^a+$/");
    });
    it('SupportsInvalidNonUnicodePatternsDeprecated', 0, function () {
      let result1 = validator.validate('0{012}', {
        'type': 'string', 'pattern': /0{1.3}/
      }).valid;
      let result2 = validator.validate('0{123}', {
        'type': 'string', 'pattern': /0{1.3}/
      }).valid;
      let result3 = validator.validate('0{012}', {
        'type': 'string', 'pattern': "0{1.3}"
      }).valid;
      let result4 = validator.validate('0{123}', {
        'type': 'string', 'pattern': "0{1.3}"
      }).valid;
      expect(result1).assertFalse();
      expect(result2).assertTrue();
      expect(result3).assertFalse();
      expect(result4).assertTrue();
    });
    it('ShouldValidateIfStringHasALengthLargerThanMinLength', 0, function () {
      let result = validator.validate('abcde', {
        'type': 'string', 'minLength': 5
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfStringDoesHasALengthLessThanMinLength', 0, function () {
      let result = validator.validate('abcde', {
        'type': 'string', 'minLength': 6
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateIfStringHasALengthEqualToMaxLength', 0, function () {
      let result = validator.validate('abcde', {
        'type': 'string', 'maxLength': 5
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfStringDoesHasALengthLargerThanMaxLength', 0, function () {
      let result = validator.validate('abcde', {
        'type': 'string', 'maxLength': 4
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateIfStringIsOneOfTheEnumValues', 0, function () {
      let result = validator.validate('abcde', {
        'type': 'string', 'enum': ['abcdf', 'abcde']
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfStringIsNotOneOfTheEnumValues', 0, function () {
      let result = validator.validate('abcde', {
        'type': 'string', 'enum': ['abcdf', 'abcdd']
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateIfNumberIsOneOfTheEnumValues', 0, function () {
      let result = validator.validate(1, {
        'type': 'number', 'enum': [1, 2]
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfNumberIsNotOneOfTheEnumValues', 0, function () {
      let result = validator.validate(3, {
        'type': 'string', 'enum': [1, 2]
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateIfValueIsUndefinedButDefaultsToOneOfTheEnumValues', 0, function () {
      let result = validator.validate(undefined, {
        'enum': ['foo', 'bar', 'baz'], 'default': 'baz'
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateIfValueIsUndefinedAndRequiredEvenIfADefaultIsGiven', 0, function () {
      let result = validator.validate(undefined, {
        'enum': ['foo', 'bar', 'baz'], 'required': true, 'default': 'baz'
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldNotValidateIfARequiredFieldIsOmmited', 0, function () {
      let result = validator.validate({}, {
        'type': 'object', 'properties': {
          'the_field': {
            'enum': ['foo', 'bar', 'baz'], 'required': true
          }
        }
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldNotValidateIfARequiredFieldIsUndefined', 0, function () {
      let result = validator.validate({
        'the_field': undefined
      }, {
        'type': 'object', 'properties': {
          'the_field': {
            'enum': ['foo', 'bar', 'baz'], 'required': true
          }
        }
      }).valid;
      expect(result).assertFalse();
    });

    it('ShouldNotValidateIfAFieldInRequiredArrayIsUndefined', 0, function () {
      let result = validator.validate({
        'the_field': undefined
      }, {
        'type': 'object', 'properties': {
          'the_field': {
            'enum': ['foo', 'bar', 'baz']
          }
        }, required: ['the_field']
      }).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateIfARequiredFieldHasAValueOutOfEnum', 0, function () {
      let result = validator.validate({
        'the_field': 'bar'
      }, {
        'type': 'object', 'properties': {
          'the_field': {
            'enum': ['foo', 'bar', 'baz'], 'required': true
          }
        }
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldBeIgnored', 0, function () {
      let result = validator.validate(1, {
        'description': 'some text'
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldProhibitSpecifiedTypes', 0, function () {
      let result = validator.validate(1, {
        'type': 'any', 'disallow': 'array'
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotProhibitUnprohibitedTypes', 0, function () {
      let result = validator.validate(1, {
        'type': 'any', 'disallow': 'array'
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateWithMissingNonDependedProperties', 0, function () {
      let result = validator.validate({
        foo: 1
      }, {
        'dependencies': {
          'quux': ['foo', 'bar']
        }
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateWithMissingDependencies', 0, function () {
      let result = validator.validate({
        quux: 1, foo: 1
      }, {
        'dependencies': {
          'quux': ['foo', 'bar']
        }
      }).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateWithSatisfiedDependencies', 0, function () {
      let result = validator.validate({
        quux: 1, foo: 1, bar: 1
      }, {
        'dependencies': {
          'quux': ['foo', 'bar']
        }
      }).valid;
      expect(result).assertTrue();
    });

  })
}