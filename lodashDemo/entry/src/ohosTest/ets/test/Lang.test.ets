/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  assign,
  castArray, clone, cloneDeep, conformsTo, eq, gt, gte,
  isArguments,
  isArray,
  isArrayBuffer,
  isArrayLike,
  isArrayLikeObject,
  isBoolean,
  isBuffer,
  isDate,
  isEmpty,
  isEqual,
  isEqualWith,
  isError,
  isFunction,
  isInteger,
  isLength,
  isMap,
  isMatch,
  isMatchWith,
  isNative,
  isNil,
  isNull,
  isNumber,
  isObject,
  isObjectLike,
  isPlainObject,
  isRegExp,
  isSafeInteger,
  isSet,
  isString,
  isSymbol,
  isTypedArray,
  isUndefined,
  isWeakMap,
  isWeakSet,
  lt,
  lte,
  noop,
  toArray,
  toFinite,
  toInteger,
  toLength,
  toNumber,
  toPlainObject,
  toSafeInteger,
  toString,
} from 'lodash';

export default function langTest() {
  describe('LangTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('castArrayTest01',0, function () {
      let castArrays = castArray({ 'a': 1 })
      expect(JSON.stringify(castArrays)).assertEqual('[{"a":1}]');
    })

    it('castArrayTest02',0, function () {
      let castArrays = castArray('abc');
      expect(JSON.stringify(castArrays)).assertEqual('["abc"]');
    })

    it('cloneTest01',0, function () {
      let objects = [{ 'a': 1 }, { 'b': 2 }];
      let shallow = clone(objects);
      expect(JSON.stringify(shallow)).assertEqual('[{"a":1},{"b":2}]');
    })

    it('cloneTest02',0, function () {
      let obj = [{ x:1 }, { y:2 }];
      let shallowCopy = clone(obj);
      expect(JSON.stringify(shallowCopy)).assertEqual('[{"x":1},{"y":2}]');
    })

    it('cloneDeepTest01',0, function () {
      let objects = [{ 'a': 1 }, { 'b': 2 }];
      let shallow = cloneDeep(objects);
      expect(JSON.stringify(shallow)).assertEqual('[{"a":1},{"b":2}]');
    })

    it('cloneDeepTest02',0, function () {
      let obj = [{ x:1 }, { y:2 }];
      let shallowCopy = cloneDeep(obj);
      expect(JSON.stringify(shallowCopy)).assertEqual('[{"x":1},{"y":2}]');
    })

    it('conformsToTest01',0, function () {
      var object = { 'a': 1, 'b': 2 };
      let isConformsTo = conformsTo(object, { 'b': function(n) { return n > 1; } });
      expect(isConformsTo).assertTrue();
    })

    it('conformsToTest02',0, function () {
      var object = { 'a': 1, 'b': 2 };
      let isConformsTo = conformsTo(object, { 'b': function(n) { return n > 2; } });
      expect(isConformsTo).assertFalse();
    })

    it('eqTest01',0, function () {
      var object = { 'a': 1 };
      let isEq = eq(object, object);
      expect(isEq).assertTrue();
    })

    it('eqTest02',0, function () {
      var object = { 'a': 1 };
      let other = { 'a': 1 };
      let isEq = eq(object, other);
      expect(isEq).assertFalse();
    })

    it('gtTest01',0, function () {
      let isGt = gt(3, 1);
      expect(isGt).assertTrue();
    })

    it('gtTest02',0, function () {
      let isGt = gt(3, 3);
      expect(isGt).assertFalse();
    })

    it('gteTest01',0, function () {
      let isGte = gte(3, 1);
      expect(isGte).assertTrue();
    })

    it('gteTest02',0, function () {
      let isGte = gte(3, 3);
      expect(isGte).assertTrue()
    })

    it('isArgumentsTest01',0, function () {
      let isArgument = isArguments(function() { return arguments; }());
      expect(isArgument).assertTrue();
    })

    it('isArgumentsTest02',0, function () {
      let isArgument = isArguments([1, 2, 3]);
      expect(isArgument).assertFalse();
    })

    it('isArrayTest01',0, function () {
      let isTrue = isArray([1, 2, 3]);
      expect(isTrue).assertTrue();
    })

    it('isArrayTest02',0, function () {
      let isTrue = isArray(noop);
      expect(isTrue).assertFalse();
    })

    it('isArrayBufferTest01',0, function () {
      let isTrue = isArrayBuffer(new ArrayBuffer(2));
      expect(isTrue).assertTrue();
    })

    it('isArrayBufferTest02',0, function () {
      let isTrue = isArrayBuffer(new Array(2));
      expect(isTrue).assertFalse();
    })

    it('isArrayLikeTest01',0, function () {
      let isTrue = isArrayLike([1, 2, 3]);
      expect(isTrue).assertTrue();
    })

    it('isArrayLikeTest02',0, function () {
      let isTrue = isArrayLike(noop);
      expect(isTrue).assertFalse();
    })

    it('isArrayLikeObjectTest01',0, function () {
      let isTrue = isArrayLikeObject([1, 2, 3]);
      expect(isTrue).assertTrue();
    })

    it('isArrayLikeObjectTest02',0, function () {
      let isTrue = isArrayLikeObject(noop);
      expect(isTrue).assertFalse();
    })

    it('isBooleanTest01',0, function () {
      let isTrue = isBoolean(false);
      expect(isTrue).assertTrue();
    })

    it('isBooleanTest02',0, function () {
      let isTrue = isBoolean(null);
      expect(isTrue).assertFalse();
    })

    it('isBufferTest',0, function () {
      let isTrue = isBuffer(new Uint8Array(2));
      expect(isTrue).assertFalse();
    })

    it('isDateTest01',0, function () {
      let isTrue = isDate(new Date);
      expect(isTrue).assertTrue();
    })

    it('isDateTest02',0, function () {
      let isTrue = isDate('Mon April 23 2012');
      expect(isTrue).assertFalse();
    })

    it('isEmptyTest01',0, function () {
      let isTrue = isEmpty(null);
      expect(isTrue).assertTrue();
    })

    it('isEmptyTest02',0, function () {
      let isTrue = isEmpty([1, 2, 3]);
      expect(isTrue).assertFalse();
    })

    it('isEqualTest',0, function () {
      var object = { 'a': 1 };
      var other = { 'a': 1 };
      let isTrue = isEqual(object, other);
      expect(isTrue).assertTrue();
    })

    it('isEqualWithTest01',0, function () {
      function isGreeting(value) {
        return /^h(?:i|ello)$/.test(value);
      }
      function customizer(objValue, othValue) {
        if (isGreeting(objValue) && isGreeting(othValue)) {
          return true;
        }
      }
      let array = ['hello', 'goodbye'];
      let other = ['hi', 'goodbye'];
      let isTrue = isEqualWith(array, other, customizer);
      expect(isTrue).assertTrue();
    })

    it('isEqualWithTest02',0, function () {
      var customizer = function(value) {
        return isString(value) ? false : undefined;
      };
      expect(isEqualWith('a', 'a', customizer)).assertFalse();
    })

    it('isErrorTest01',0, function () {
      let isTrue = isError(new Error);
      expect(isTrue).assertTrue();
    })

    it('isErrorTest02',0, function () {
      let isTrue = isError(Error);
      expect(isTrue).assertFalse();
    })

    it('isFiniteTest01',0, function () {
      expect(isFinite(3)).assertTrue();
    })

    it('isFiniteTest02',0, function () {
      expect(isFinite(Infinity)).assertFalse();
    })

    it('isFunctionTest01',0, function () {
      expect(isFunction(function() {})).assertTrue();
    })

    it('isFunctionTest02',0, function () {
      expect(isFunction(/abc/)).assertFalse();
    })

    it('isIntegerTest01',0, function () {
      expect(isInteger(3)).assertTrue();
    })

    it('isIntegerTest02',0, function () {
      expect(isInteger(Infinity)).assertFalse();
    })

    it('isLengthTest01',0, function () {
      expect(isLength(3)).assertTrue();
    })

    it('isLengthTest02',0, function () {
      expect(isLength(Infinity)).assertFalse();
    })

    it('isMapTest01',0, function () {
      expect(isMap(new Map)).assertTrue();
    })

    it('isMapTest02',0, function () {
      expect(isMap(new WeakMap)).assertFalse();
    })

    it('isMatchTest01',0, function () {
      let object = { 'a': 1, 'b': 2 };
      let match = isMatch(object, { 'b': 2 });
      expect(match).assertTrue();
    })

    it('isMatchTest02',0, function () {
      let object = { 'a': 1, 'b': 2 };
      let match = isMatch(object, { 'b': 1 });
      expect(match).assertFalse();
    })

    it('isMatchWithTest01',0, function () {
      function isGreeting(value) {
        return /^h(?:i|ello)$/.test(value);
      }
      function customizer(objValue, srcValue) {
        if (isGreeting(objValue) && isGreeting(srcValue)) {
          return true;
        }
      }
      let object = { 'greeting': 'hello' };
      let source = { 'greeting': 'hi' };
      let matchWith = isMatchWith(object, source, customizer);
      expect(matchWith).assertTrue();
    })

    it('isMatchWithTest02',0, function () {
      let customizer = function(value) {
        return isString(value) || undefined;
      };
      expect(isMatchWith(['a'], ['b'], customizer)).assertTrue();
    })

    it('isNaNTest01',0, function () {
      expect(isNaN(NaN)).assertTrue();
    })

    it('isNaNTest02',0, function () {
      expect(isNaN(undefined)).assertTrue();
    })

    it('isNativeTest01',0, function () {
      expect(isNative(Array.prototype.push)).assertTrue();
    })

    it('isNativeTest02',0, function () {
      expect(isNative(undefined)).assertFalse();
    })

    it('isNilTest01',0, function () {
      expect(isNil(null)).assertTrue();
    })

    it('isNilTest02',0, function () {
      expect(isNil(NaN)).assertFalse();
    })

    it('isNullTest01',0, function () {
      expect(isNull(null)).assertTrue();
    })

    it('isNullTest02',0, function () {
      expect(isNull(void 0)).assertFalse();
    })

    it('isNumberTest01',0, function () {
      expect(isNumber(3)).assertTrue();
    })

    it('isNumberTest02',0, function () {
      expect(isNumber('3')).assertFalse();
    })

    it('isObjectTest01',0, function () {
      expect(isObject({})).assertTrue();
    })

    it('isObjectTest02',0, function () {
      expect(isObject(null)).assertFalse();
    })

    it('isObjectLikeTest01',0, function () {
      expect(isObjectLike([1, 2, 3])).assertTrue();
    })

    it('isObjectLikeTest02',0, function () {
      expect(isObjectLike(null)).assertFalse();
    })

    it('isPlainObjectTest01',0, function () {
      function Foo() {
        this.a = 1;
      }
      expect(isPlainObject(new Foo)).assertFalse();
    })

    it('isPlainObjectTest02',0, function () {
      expect(isPlainObject({ 'x': 0, 'y': 0 })).assertTrue();
    })

    it('isRegExpTest01',0, function () {
      expect(isRegExp('/abc/')).assertFalse();
    })

    it('isRegExpTest02',0, function () {
      expect(isRegExp(/abc/)).assertTrue();
    })

    it('isSafeIntegerTest01',0, function () {
      expect(isSafeInteger(Infinity)).assertFalse();
    })

    it('isSafeIntegerTest02',0, function () {
      expect(isSafeInteger(3)).assertTrue();
    })

    it('isSetTest01',0, function () {
      expect(isSet(new Set)).assertTrue();
    })

    it('isSetTest02',0, function () {
      expect(isSet(new WeakSet)).assertFalse();
    })

    it('isStringTest01',0, function () {
      expect(isString('abc')).assertTrue();
    })

    it('isStringTest02',0, function () {
      expect(isString(1)).assertFalse();
    })

    it('isSymbolTest01',0, function () {
      expect(isSymbol(Symbol.iterator)).assertTrue();
    })

    it('isSymbolTest02',0, function () {
      expect(isSymbol('abc')).assertFalse();
    })

    it('isTypedArrayTest01',0, function () {
      expect(isTypedArray(new Uint8Array)).assertTrue();
    })

    it('isTypedArrayTest02',0, function () {
      expect(isTypedArray([])).assertFalse();
    })

    it('isUndefinedTest01',0, function () {
      expect(isUndefined(void 0)).assertTrue();
    })

    it('isUndefinedTest02',0, function () {
      expect(isUndefined(null)).assertFalse();
    })

    it('isWeakMapTest01',0, function () {
      expect(isWeakMap(new WeakMap)).assertTrue();
    })

    it('isWeakMapTest02',0, function () {
      expect(isWeakMap(new Map)).assertFalse();
    })

    it('isWeakSetTest01',0, function () {
      expect(isWeakSet(new WeakSet)).assertTrue();
    })

    it('isWeakSetTest02',0, function () {
      expect(isWeakSet(new Set)).assertFalse();
    })

    it('ltTest01',0, function () {
      expect(lt(1, 3)).assertTrue();
    })

    it('ltTest02',0, function () {
      expect(lt(3, 1)).assertFalse();
    })

    it('lteTest01',0, function () {
      expect(lte(1, 3)).assertTrue();
    })

    it('lteTest02',0, function () {
      expect(lte(3, 1)).assertFalse();
    })

    it('toArrayTest01',0, function () {
      expect(JSON.stringify(toArray({ 'a': 1, 'b': 2 }))).assertEqual('[1,2]');
    })

    it('toArrayTest02',0, function () {
      expect(JSON.stringify(toArray('abc'))).assertEqual('["a","b","c"]');
    })

    it('toFiniteTest01',0, function () {
      expect(toFinite(Number.MIN_VALUE)).assertEqual(5e-324);
    })

    it('toFiniteTest02',0, function () {
      expect(toFinite(Infinity)).assertEqual(1.7976931348623157e+308);
    })

    it('toIntegerTest01',0, function () {
      expect(toInteger(Number.MIN_VALUE)).assertEqual(0);
    })

    it('toIntegerTest02',0, function () {
      expect(toInteger(Infinity)).assertEqual(1.7976931348623157e+308);
    })

    it('toLengthTest01',0, function () {
      expect(toLength(Number.MIN_VALUE)).assertEqual(0);
    })

    it('toLengthTest02',0, function () {
      expect(toLength(Infinity)).assertEqual(4294967295);
    })

    it('toNumberTest01',0, function () {
      expect(toNumber(Number.MIN_VALUE)).assertEqual(5e-324);
    })

    it('toNumberTest02',0, function () {
      expect(toNumber(Infinity)).assertEqual(Infinity);
    })

    it('toPlainObjectTest01',0, function () {
      function Foo() {
        this.b = 2;
      }
      Foo.prototype.c = 3;
      let plainObject = assign({ 'a': 1 }, toPlainObject(new Foo));
      expect(JSON.stringify(plainObject)).assertEqual('{"a":1,"b":2,"c":3}');
    })

    it('toPlainObjectTest02',0, function () {
      let actual = toPlainObject(['a', 'b', 'c'])
      expect(JSON.stringify(actual)).assertEqual('{"0":"a","1":"b","2":"c"}');
    })

    it('toSafeIntegerTest01',0, function () {
      expect(toSafeInteger(3.2)).assertEqual(3);
    })

    it('toSafeIntegerTest02',0, function () {
      expect(toSafeInteger(Infinity)).assertEqual(9007199254740991);
    })

    it('toStringTest01',0, function () {
      expect(toString(null)).assertEqual('');
    })

    it('toStringTest02',0, function () {
      expect(toString([1, 2, 3])).assertEqual('1,2,3');
    })
  })
}