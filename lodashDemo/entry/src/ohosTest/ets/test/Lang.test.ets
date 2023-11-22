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
  isNaN,
  isFinite
} from 'lodash';

export default function langTest() {
  describe('LangTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    class B {
      b: number = 0
    }

    class A {
      a: number = 0
    }

    class X {
      x: number = 0
    }

    class Y {
      y: number = 0
    }

    class AB {
      a: number = 0;
      b: number = 0
    }

    class Greet{
      greeting: string = ''
    }
    it('castArrayTest01',0, () => {
      let castArrays: object = castArray({ 'a': 1 })
      expect(JSON.stringify(castArrays)).assertEqual('[{"a":1}]');
    })

    it('castArrayTest02',0, () => {
      let castArrays: string[] = castArray('abc');
      expect(JSON.stringify(castArrays)).assertEqual('["abc"]');
    })

    it('cloneTest01',0, () => {
      let objects = [{ a: 1 }as A, { b: 2 }as B];
      let shallow: object = clone(objects);
      expect(JSON.stringify(shallow)).assertEqual('[{"a":1},{"b":2}]');
    })

    it('cloneTest02',0, () => {
      let obj = [{ x:1 }as X, { y:2 }as Y];
      let shallowCopy: object = clone(obj);
      expect(JSON.stringify(shallowCopy)).assertEqual('[{"x":1},{"y":2}]');
    })

    it('cloneDeepTest01',0, () => {
      let objects = [{ a: 1 }as A, { b: 2 }as B];
      let shallow: object = cloneDeep(objects);
      expect(JSON.stringify(shallow)).assertEqual('[{"a":1},{"b":2}]');
    })

    it('cloneDeepTest02',0, () => {
      let obj = [{ x:1 }as X, { y:2 }as Y];
      let shallowCopy: object = cloneDeep(obj);
      expect(JSON.stringify(shallowCopy)).assertEqual('[{"x":1},{"y":2}]');
    })

    it('conformsToTest01',0, () => {
      let object = { a: 1, b: 2 }as AB;
      let isConformsTo: boolean = conformsTo(object, { 'b': (n: number)=> { return n > 1; } });
      expect(isConformsTo).assertTrue();
    })

    it('conformsToTest02',0, () => {
      let object = { a: 1, b: 2 }as AB;
      let isConformsTo: boolean = conformsTo(object, { 'b': (n: number)=> { return n > 2; } });
      expect(isConformsTo).assertFalse();
    })

    it('eqTest01',0, () => {
      let object = { a: 1 }as A;
      let isEq: boolean = eq(object, object);
      expect(isEq).assertTrue();
    })

    it('eqTest02',0, () => {
      let object = { a: 1 }as A;
      let other = { a: 1 }as A;
      let isEq: boolean = eq(object, other);
      expect(isEq).assertFalse();
    })

    it('gtTest01',0, () => {
      let isGt: boolean = gt(3, 1);
      expect(isGt).assertTrue();
    })

    it('gtTest02',0, () => {
      let isGt: boolean = gt(3, 3);
      expect(isGt).assertFalse();
    })

    it('gteTest01',0, () => {
      let isGte: boolean = gte(3, 1);
      expect(isGte).assertTrue();
    })

    it('gteTest02',0, () => {
      let isGte: boolean = gte(3, 3);
      expect(isGte).assertTrue()
    })

    it('isArgumentsTest01',0, ()=> {
      let isArgument: boolean = isArguments(() => { return arguments; });
      expect(isArgument).assertFalse();
    })

    it('isArgumentsTest02',0, () => {
      let isArgument: boolean = isArguments([1, 2, 3]);
      expect(isArgument).assertFalse();
    })

    it('isArrayTest01',0, () => {
      let isTrue: boolean = isArray([1, 2, 3]);
      expect(isTrue).assertTrue();
    })

    it('isArrayTest02',0, () => {
      let isTrue: boolean = isArray(noop);
      expect(isTrue).assertFalse();
    })

    it('isArrayBufferTest01',0, () => {
      let isTrue: boolean = isArrayBuffer(new ArrayBuffer(2));
      expect(isTrue).assertTrue();
    })

    it('isArrayBufferTest02',0, () => {
      let isTrue: boolean = isArrayBuffer(new Array(2));
      expect(isTrue).assertFalse();
    })

    it('isArrayLikeTest01',0, () => {
      let isTrue: boolean = isArrayLike([1, 2, 3]);
      expect(isTrue).assertTrue();
    })

    it('isArrayLikeTest02',0, () => {
      let isTrue: boolean = isArrayLike(noop);
      expect(isTrue).assertFalse();
    })

    it('isArrayLikeObjectTest01',0, () => {
      let isTrue: boolean = isArrayLikeObject([1, 2, 3]);
      expect(isTrue).assertTrue();
    })

    it('isArrayLikeObjectTest02',0, () => {
      let isTrue: boolean = isArrayLikeObject(noop);
      expect(isTrue).assertFalse();
    })

    it('isBooleanTest01',0, () => {
      let isTrue: boolean = isBoolean(false);
      expect(isTrue).assertTrue();
    })

    it('isBooleanTest02',0, () => {
      let isTrue: boolean = isBoolean(null);
      expect(isTrue).assertFalse();
    })

    it('isBufferTest',0, () => {
      let isTrue: boolean = isBuffer(new Uint8Array(2));
      expect(isTrue).assertFalse();
    })

    it('isDateTest01',0, () => {
      let isTrue: boolean = isDate(new Date);
      expect(isTrue).assertTrue();
    })

    it('isDateTest02',0, () => {
      let isTrue: boolean = isDate('Mon April 23 2012');
      expect(isTrue).assertFalse();
    })

    it('isEmptyTest01',0, () => {
      let isTrue: boolean = isEmpty(null);
      expect(isTrue).assertTrue();
    })

    it('isEmptyTest02',0, () => {
      let isTrue: boolean = isEmpty([1, 2, 3]);
      expect(isTrue).assertFalse();
    })

    it('isEqualTest',0, () => {
      let object = { a: 1 }as A;
      let other = { a: 1 }as A;
      let isTrue: boolean= isEqual(object, other);
      expect(isTrue).assertTrue();
    })

    it('isEqualWithTest01',0,  ()=> {
      let isGreeting: (value: string) => boolean = (value: string): boolean => {
        let regex: RegExp = new RegExp('^h(?:i|ello)$')
        return regex.test(value);
      }
      let customizer: (objValue: string, othValue: string) => void = (objValue: string, othValue: string): ESObject => {
        if (isGreeting(objValue) && isGreeting(othValue)) {
          return true;
        }
      }
      let array = ['hello', 'goodbye'];
      let other = ['hi', 'goodbye'];
      let isTrue: boolean = isEqualWith(array, other, customizer);
      expect(isTrue).assertTrue();
    })

    it('isEqualWithTest02',0, () => {
      let customizer = (value: string)=> {
        return isString(value) ? false : undefined;
      };
      customizer('str')
      expect(isEqualWith('a', 'a', customizer)).assertFalse();
    })

    it('isErrorTest01',0, () => {
      let isTrue: boolean = isError(new Error);
      expect(isTrue).assertTrue();
    })

    it('isErrorTest02',0, () => {
      let isTrue: boolean = isError(Error);
      expect(isTrue).assertFalse();
    })

    it('isFiniteTest01',0, () => {
      expect(isFinite(3)).assertTrue();
    })

    it('isFiniteTest02',0, () => {
      expect(isFinite('22')).assertFalse();
    })

    it('isFunctionTest01',0, () => {
      expect(isFunction(()=> {})).assertTrue();
    })

    it('isFunctionTest02',0, () => {
      let regex: RegExp = new RegExp('/abc/')
      expect(isFunction(regex)).assertFalse();
    })

    it('isIntegerTest01',0, () => {
      expect(isInteger(3)).assertTrue();
    })

    it('isIntegerTest02',0, () => {
      expect(isInteger(Number.MIN_VALUE)).assertFalse();
    })

    it('isLengthTest01',0, () => {
      expect(isLength(3)).assertTrue();
    })

    it('isLengthTest02',0, () => {
      expect(isLength(Number.MIN_VALUE)).assertFalse();
    })

    it('isMapTest01',0, () => {
      expect(isMap(new Map)).assertTrue();
    })

    it('isMapTest02',0, () => {
      expect(isMap({})).assertFalse();
    })

    it('isMatchTest01',0, () => {
      let object = { a: 1, b: 2 }as AB;
      let match: boolean = isMatch(object, { b: 2 }as B);
      expect(match).assertTrue();
    })

    it('isMatchTest02',0, () => {
      let object = { a: 1, b: 2 }as AB;
      let match: boolean = isMatch(object, { b: 1 }as B);
      expect(match).assertFalse();
    })

    it('isMatchWithTest01',0, () => {
      let isGreeting: (value: string) => boolean = (value: string): boolean => {
        let regex: RegExp = new RegExp('^h(?:i|ello)$')
        return regex.test(value);
      }
      let customizer: (objValue: string, othValue: string) => void = (objValue: string, othValue: string): boolean => {
        if (isGreeting(objValue) && isGreeting(othValue)) {
          return true;
        } else {
          return false;
        }
      }
      let object: Greet = { greeting: 'hello' };
      let source: Greet = { greeting: 'hi' };
      let matchWith: boolean = isMatchWith(object, source, customizer);
      expect(matchWith).assertTrue();
    })

    it('isMatchWithTest02',0, () => {
      let customizer = (value: string): boolean | undefined=> {
        return isString(value) || undefined;
      };
      expect(isMatchWith(['a'], ['b'], customizer)).assertTrue();
    })

    // it('isNaNTest01',0, () => {
    //   expect(isNaN(NaN)).assertTrue();
    // })

    it('isNaNTest02',0, () => {
      expect(isNaN(undefined)).assertFalse();
    })

    it('isNativeTest01',0, () => {
      expect(isNative(String.toString)).assertTrue();
    })

    it('isNativeTest02',0, () => {
      expect(isNative(undefined)).assertFalse();
    })

    it('isNilTest01',0, () => {
      expect(isNil(null)).assertTrue();
    })

    it('isNilTest02',0, () => {
      expect(isNil(1)).assertFalse();
    })

    it('isNullTest01',0, () => {
      expect(isNull(null)).assertTrue();
    })

    it('isNullTest02',0, () => {
      expect(isNull(void 0)).assertFalse();
    })

    it('isNumberTest01',0, () => {
      expect(isNumber(3)).assertTrue();
    })

    it('isNumberTest02',0, () => {
      expect(isNumber('3')).assertFalse();
    })

    it('isObjectTest01',0, () => {
      expect(isObject({})).assertTrue();
    })

    it('isObjectTest02',0, () => {
      expect(isObject(null)).assertFalse();
    })

    it('isObjectLikeTest01',0, () => {
      expect(isObjectLike([1, 2, 3])).assertTrue();
    })

    it('isObjectLikeTest02',0, () => {
      expect(isObjectLike(null)).assertFalse();
    })

    it('isPlainObjectTest01',0, () => {
      expect(isPlainObject([1, 2, 3])).assertFalse();
    })

    it('isPlainObjectTest02',0, () => {
      expect(isPlainObject({ 'x': 0, 'y': 0 })).assertTrue();
    })

    it('isRegExpTest01',0, () => {
      let regex: ESObject = new RegExp('abc');
      expect(isRegExp(regex)).assertTrue();
    })

    it('isRegExpTest02',0, () => {
      expect(isRegExp('/abc/')).assertFalse();
    })

    it('isSafeIntegerTest01',0, () => {
      expect(isSafeInteger(Number.MIN_VALUE)).assertFalse();
    })

    it('isSafeIntegerTest02',0, () => {
      expect(isSafeInteger(3)).assertTrue();
    })

    it('isSetTest01',0, () => {
      expect(isSet(new Set([1, 2, 3, 4, 5]))).assertTrue();
    })

    it('isSetTest02',0, () => {
      expect(isSet(new WeakSet)).assertFalse();
    })

    it('isStringTest01',0, () => {
      expect(isString('abc')).assertTrue();
    })

    it('isStringTest02',0, () => {
      expect(isString(1)).assertFalse();
    })

    it('isSymbolTest01',0, () => {
      expect(isSymbol(Symbol.iterator)).assertTrue();
    })

    it('isSymbolTest02',0, () => {
      expect(isSymbol('abc')).assertFalse();
    })

    it('isTypedArrayTest01',0, () => {
      expect(isTypedArray(new Uint8Array)).assertTrue();
    })

    it('isTypedArrayTest02',0, () => {
      expect(isTypedArray([])).assertFalse();
    })

    it('isUndefinedTest01',0, () => {
      expect(isUndefined(void 0)).assertTrue();
    })

    it('isUndefinedTest02',0, () => {
      expect(isUndefined(null)).assertFalse();
    })

    it('isWeakMapTest01',0, () => {
      let obj: ESObject= new Array(2);
      obj.fill(5);
      expect(isWeakMap(obj)).assertFalse();
    })

    it('isWeakMapTest02',0, () => {
      expect(isWeakMap(new Map)).assertFalse();
    })

    it('isWeakSetTest01',0, () => {
      expect(isWeakSet(new WeakSet)).assertTrue();
    })

    it('isWeakSetTest02',0, () => {
      expect(isWeakSet(new Set([1,2,3]))).assertFalse();
    })

    it('ltTest01',0, () => {
      expect(lt(1, 3)).assertTrue();
    })

    it('ltTest02',0, () => {
      expect(lt(3, 1)).assertFalse();
    })

    it('lteTest01',0, () => {
      expect(lte(1, 3)).assertTrue();
    })

    it('lteTest02',0, () => {
      expect(lte(3, 1)).assertFalse();
    })

    it('toArrayTest01',0, () => {
      expect(JSON.stringify(toArray({ 'a': 1, 'b': 2 }))).assertEqual('[1,2]');
    })

    it('toArrayTest02',0, () => {
      expect(JSON.stringify(toArray('abc'))).assertEqual('["a","b","c"]');
    })

    it('toFiniteTest01',0, () => {
      expect(toFinite(Number.MIN_VALUE)).assertEqual(5e-324);
    })

    it('toFiniteTest02',0, () => {
      expect(toFinite(Math.PI)).assertEqual(3.141592653589793);
    })

    it('toIntegerTest01',0, () => {
      expect(toInteger(Number.MIN_VALUE)).assertEqual(0);
    })

    it('toIntegerTest02',0, () => {
      expect(toInteger(Math.PI)).assertEqual(3);
    })

    it('toLengthTest01',0, () => {
      expect(toLength(Number.MIN_VALUE)).assertEqual(0);
    })

    it('toLengthTest02',0, () => {
      expect(toLength(Math.PI)).assertEqual(3);
    })

    it('toNumberTest01',0, () => {
      expect(toNumber(Number.MIN_VALUE)).assertEqual(5e-324);
    })

    it('toNumberTest02',0, () => {
      expect(toNumber(Math.PI)).assertEqual(Math.PI);
    })

    it('toPlainObjectTest01',0, () => {
      let plainObject: object = assign({ 'b':2 }, toPlainObject(['c','d']))
      expect(JSON.stringify(plainObject)).assertEqual('{"0":"c","1":"d","b":2}');
    })

    it('toPlainObjectTest02',0, () => {
      let actual: object = toPlainObject(['a', 'b', 'c'])
      expect(JSON.stringify(actual)).assertEqual('{"0":"a","1":"b","2":"c"}');
    })

    it('toSafeIntegerTest01',0, () => {
      expect(toSafeInteger(3.2)).assertEqual(3);
    })

    it('toSafeIntegerTest02',0, () => {
      expect(toSafeInteger(Math.PI)).assertEqual(3);
    })

    it('toStringTest01',0, () => {
      expect(toString(null)).assertEqual('');
    })

    it('toStringTest02',0, () => {
      expect(toString([1, 2, 3])).assertEqual('1,2,3');
    })
  })
}