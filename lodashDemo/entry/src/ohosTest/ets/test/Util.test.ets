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
  add,
  attempt, bindAll, cond, conforms,
  conformsTo,
  constant,
  defaultTo,
  filter,
  flow,
  flowRight,
  identity,
  isNumber,
  iteratee,
  map, matches,
  matchesProperty,
  method,
  methodOf,
  mixin,
  multiply,
  noop,
  nthArg,
  over,
  overEvery,
  overSome,
  property,
  propertyOf,
  range,
  rangeRight,
  slice,
  sortBy,
  stubArray,
  stubFalse,
  stubObject,
  stubString,
  stubTrue,
  times,
  toPath,
  uniqueId
} from 'lodash'

export default function utilTest() {
  describe('UtilTest', function () {
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
    it('attemptTest01',0, function () {
      let actual = attempt(function() { return slice.call(arguments); }, 1, 2);
      expect(JSON.stringify(actual)).assertEqual('[]');
    })

    it('attemptTest02',0, function () {
      let elements = map(new Error, function(error) {
        return attempt(function() { throw error; }) === error;
      });
      expect(JSON.stringify(elements)).assertEqual('[]');
    })

    it('bindAllTest',0, function () {
      let view = {
        'label': 'docs',
        'click': function() {
          console.log('clicked ' + this.label);
        }
      };
      expect(JSON.stringify(bindAll(view, ['click']))).assertEqual('{"label":"docs"}');
    })

    it('condTest01',0, function () {
      let func = cond([
        [matches({ 'a': 1 }),           constant('matches A')],
        [conforms({ 'b': isNumber }), constant('matches B')],
        [stubTrue,                      constant('no match')]
      ]);
      let string = func({ 'a': 1, 'b': 2 });
      expect(string).assertEqual('matches A');
    })

    it('condTest02',0, function () {
      let func = cond([
        [matches({ 'a': 1 }),           constant('matches A')],
        [conforms({ 'b': isNumber }), constant('matches B')],
        [stubTrue,                      constant('no match')]
      ]);
      let string = func({ 'a': 1, 'b': 2 });
      expect(string).assertEqual('matches A');
    })

    it('conformsTest01',0, function () {
      let objects = [
        { 'a': 2, 'b': 1 },
        { 'a': 1, 'b': 2 }
      ];
      let string = filter(objects, conforms({ 'b': function(n) { return n > 1; } }));
      expect(JSON.stringify(string)).assertEqual('[{"a":1,"b":2}]');
    })

    it('conformsTest02',0, function () {
      let objects = { 'gfg':5, 'GFG':10 };
      let string = conformsTo(objects,
        { 'GFG':function(n)
        { return n > 12; }
        }
        );
      expect(string).assertFalse();
    })

    it('constantTest01',0, function () {
      let objects = times(2, constant({ 'a': 1 }));
      expect(JSON.stringify(objects)).assertEqual('[{"a":1},{"a":1}]');
    })

    it('constantTest02',0, function () {
      let objects = times(3, constant({ 'geeks':3 }));
      expect(JSON.stringify(objects)).assertEqual('[{"geeks":3},{"geeks":3},{"geeks":3}]');
    })

    it('defaultToTest01',0, function () {
      expect(defaultTo(1, 10)).assertEqual(1);
    })

    it('defaultToTest02',0, function () {
      expect(defaultTo(undefined, 10)).assertEqual(10);
    })

    it('flowTest01',0, function () {
      function square(n) {
        return n * n;
      }
      let addSquare = flow([add, square]);
      expect(addSquare(1, 2)).assertEqual(9);
    })

    it('flowTest02',0, function () {
      function cube(number) {
        return number * number * number;
      }
      let multiplycube = flow([multiply, cube]);
      expect(multiplycube(2, 3)).assertEqual(216);
    })

    it('flowRightTest01',0, function () {
      function square(n) {
        return n * n;
      }
      let addSquare = flowRight([square, add]);
      expect(addSquare(1, 2)).assertEqual(9);
    })

    it('flowRightTest02',0, function () {
      function cube(number) {
        return number * number * number;
      }
      let multiplycube = flowRight([multiply, cube]);
      expect(multiplycube(2, 3)).assertEqual(8);
    })

    it('identityTest01',0, function () {
      let object = { 'a': 1 };
      expect(JSON.stringify(identity(object))).assertEqual('{"a":1}');
    })

    it('identityTest02',0, function () {
      let object = { 'a': 9, 'b': 3 };
      expect(JSON.stringify(identity(object))).assertEqual('{"a":9,"b":3}');
    })

    it('iterateeTest01',0, function () {
      let users = [
        { 'user': 'barney', 'age': 36, 'active': true },
        { 'user': 'fred',   'age': 40, 'active': false }
      ];
      let iterateeObject = filter(users, iteratee({ 'user': 'barney', 'active': true }));
      expect(JSON.stringify(identity(iterateeObject))).assertEqual('[{"user":"barney","age":36,"active":true}]');
    })

    it('iterateeTest02',0, function () {
      let users = [
        { 'user': 'barney', 'age': 36, 'active': true },
        { 'user': 'fred',   'age': 40, 'active': false }
      ];
      let iterateeObject = map(users, iteratee('user'));
      expect(JSON.stringify(identity(iterateeObject))).assertEqual('["barney","fred"]');
    })

    it('matchesTest01',0, function () {
      let objects = [
        { 'a': 1, 'b': 2, 'c': 3 },
        { 'a': 4, 'b': 5, 'c': 6 }
      ];
      let matchesObject = filter(objects, matches({ 'a': 4, 'c': 6 }));
      expect(JSON.stringify(identity(matchesObject))).assertEqual('[{"a":4,"b":5,"c":6}]');
    })

    it('matchesTest02',0, function () {
      let users = [ {'java' :3, 'python' :5, 'js' :7},
        {'java' :4, 'python' :2, 'js' :6}
      ];
      let matchesObject = filter(users, matches({'java' :3, 'js' :7 }));
      expect(JSON.stringify(identity(matchesObject))).assertEqual('[{"java":3,"python":5,"js":7}]');
    })

    it('matchesPropertyTest01',0, function () {
      let objects = [
        { 'a': 1, 'b': 2, 'c': 3 },
        { 'a': 4, 'b': 5, 'c': 6 }
      ];
      let matchesObject = filter(objects, matchesProperty('a', 4));
      expect(JSON.stringify(identity(matchesObject))).assertEqual('[{"a":4,"b":5,"c":6}]');
    })

    it('matchesPropertyTest02',0, function () {
      let users = [ {'java' :3, 'python' :5, 'js' :7},
        {'java' :4, 'python' :2, 'js' :6}
      ];
      let matchesObject = filter(users, matchesProperty('java' ,3));
      expect(JSON.stringify(identity(matchesObject))).assertEqual('[{"java":3,"python":5,"js":7}]');
    })

    it('methodTest01',0, function () {
      let objects = [
        { 'a': { 'b': constant(2) } },
        { 'a': { 'b': constant(1) } }
      ];
      let methodObject = map(objects, method('a.b'));
      expect(JSON.stringify(identity(methodObject))).assertEqual('[2,1]');
    })

    it('methodTest02',0, function () {
      let objects = [
        { 'a': { 'b': constant(2) } },
        { 'a': { 'b': constant(1) } }
      ];
      let methodObject = map(objects, method(['a', 'b']));
      expect(JSON.stringify(identity(methodObject))).assertEqual('[2,1]');
    })

    it('methodOfTest01',0, function () {
      let array = times(3, constant),
        object = { 'a': array, 'b': array, 'c': array };
      let methodOfObject = map(['a[2]', 'c[0]'], methodOf(object));
      expect(JSON.stringify(identity(methodOfObject))).assertEqual('[2,0]');
    })

    it('methodOfTest02',0, function () {
      let array = times(3, constant),
        object = { 'a': array, 'b': array, 'c': array };
      let methodObject = map([['a', '2'], ['c', '0']], methodOf(object));
      expect(JSON.stringify(identity(methodObject))).assertEqual('[2,0]');
    })

    it('mixinTest01',0, function () {
      function vowels(string) {
        return filter(string, function(v) {
          return /[aeiou]/i.test(v);
        });
      }
      mixin({ 'vowels': vowels })
      expect(JSON.stringify(identity(vowels('fred')))).assertEqual('["e"]');
    })

    it('mixinTest02',0, function () {
      let object = {};
      let source = { 'a': function(array) { return array[0]; }, 'b': 'B' }
      expect(JSON.stringify(mixin(object, source))).assertEqual('{}');
    })

    it('noopTest',0, function () {
      expect(JSON.stringify(times(2, noop))).assertEqual('[null,null]');
    })

    it('nthArgTest01',0, function () {
      let func = nthArg(1)
      expect(func('a', 'b', 'c', 'd')).assertEqual('b');
    })

    it('nthArgTest02',0, function () {
      let func = nthArg(-2);
      expect(func('a', 'b', 'c', 'd')).assertEqual('c');
    })

    it('overTest01',0, function () {
      let func = over([Math.max, Math.min]);
      expect(JSON.stringify(func(1, 2, 3, 4))).assertEqual('[4,1]');
    })

    it('overTest02',0, function () {
      let func = over([Boolean, isFinite]);
      expect(JSON.stringify(func('10', 'null'))).assertEqual('[true,true]');
    })

    it('overEveryTest01',0, function () {
      let func = overEvery([Boolean, isFinite]);
      expect(func('1')).assertTrue();
    })

    it('overEveryTest02',0, function () {
      let func = overEvery([Boolean, isFinite]);
      expect(func(NaN)).assertFalse();
    })

    it('overSomeTest01',0, function () {
      let func = overSome([Boolean, isFinite]);
      expect(func('1')).assertTrue();
    })

    it('overSomeTest02',0, function () {
      let func = overSome([Boolean, isFinite]);
      expect(func(NaN)).assertFalse();
    })

    it('propertyTest01',0, function () {
      let objects = [
        { 'a': { 'b': 2 } },
        { 'a': { 'b': 1 } }
      ];
      let propertyArray = map(objects, property('a.b'));
      expect(JSON.stringify(propertyArray)).assertEqual('[2,1]');
    })

    it('propertyTest02',0, function () {
      let objects = [
        { 'a': { 'b': 2 } },
        { 'a': { 'b': 1 } }
      ];
      let propertyArray = map(sortBy(objects, property(['a', 'b'])), 'a.b');
      expect(JSON.stringify(propertyArray)).assertEqual('[1,2]');
    })

    it('propertyOfTest01',0, function () {
      let array = [0, 1, 2],
        object = { 'a': array, 'b': array, 'c': array };
      let propertyOfArray = map(['a[2]', 'c[0]'], propertyOf(object));
      expect(JSON.stringify(propertyOfArray)).assertEqual('[2,0]');
    })

    it('propertyOfTest02',0, function () {
      let array = [0, 1, 2],
        object = { 'a': array, 'b': array, 'c': array };
      let propertyOfArray = map([['a', '2'], ['c', '0']], propertyOf(object));
      expect(JSON.stringify(propertyOfArray)).assertEqual('[2,0]');
    })

    it('rangeTest01',0, function () {
      expect(JSON.stringify(range(4))).assertEqual('[0,1,2,3]');
    })

    it('rangeTest02',0, function () {
      expect(JSON.stringify(range(0, 20, 5))).assertEqual('[0,5,10,15]');
    })

    it('rangeRightTest01',0, function () {
      expect(JSON.stringify(rangeRight(4))).assertEqual('[3,2,1,0]');
    })

    it('rangeRightTest02',0, function () {
      expect(JSON.stringify(rangeRight(0, 20, 5))).assertEqual('[15,10,5,0]');
    })

    it('stubArrayTest01',0, function () {
      let arrays = times(2, stubArray);
      expect(JSON.stringify(arrays)).assertEqual('[[],[]]');
    })

    it('stubArrayTest02',0, function () {
      let arrays = times(3, stubArray);
      expect(JSON.stringify(arrays)).assertEqual('[[],[],[]]');
    })

    it('stubFalseTest01',0, function () {
      let arrays = times(2, stubFalse);
      expect(JSON.stringify(arrays)).assertEqual('[false,false]');
    })

    it('stubFalseTest02',0, function () {
      let arrays = times(3, stubFalse);
      expect(JSON.stringify(arrays)).assertEqual('[false,false,false]');
    })

    it('stubObjectTest01',0, function () {
      let arrays = times(2, stubObject);
      expect(JSON.stringify(arrays)).assertEqual('[{},{}]');
    })

    it('stubObjectTest02',0, function () {
      let arrays = times(3, stubObject);
      expect(JSON.stringify(arrays)).assertEqual('[{},{},{}]');
    })

    it('stubStringTest01',0, function () {
      let arrays = times(2, stubString);
      expect(JSON.stringify(arrays)).assertEqual('["",""]');
    })

    it('stubStringTest02',0, function () {
      let arrays = times(3, stubString);
      expect(JSON.stringify(arrays)).assertEqual('["","",""]');
    })

    it('stubTrueTest01',0, function () {
      let arrays = times(2, stubTrue);
      expect(JSON.stringify(arrays)).assertEqual('[true,true]');
    })

    it('stubTrueTest02',0, function () {
      let arrays = times(3, stubTrue);
      expect(JSON.stringify(arrays)).assertEqual('[true,true,true]');
    })

    it('timesTest01',0, function () {
      let arrays = times(3, String);
      expect(JSON.stringify(arrays)).assertEqual('["0","1","2"]');
    })

    it('timesTest02',0, function () {
      let arrays = times(4, constant(0));
      expect(JSON.stringify(arrays)).assertEqual('[0,0,0,0]');
    })

    it('toPathTest01',0, function () {
      let arrays = toPath('a.b.c');
      expect(JSON.stringify(arrays)).assertEqual('["a","b","c"]');
    })

    it('toPathTest02',0, function () {
      let arrays = toPath('a[0].b.c');
      expect(JSON.stringify(arrays)).assertEqual('["a","0","b","c"]');
    })

    it('uniqueIdTest01',0, function () {
      let arrays = uniqueId('contact_');
      expect(arrays).assertEqual('contact_1');
    })

    it('uniqueIdTest02',0, function () {
      expect(uniqueId()).assertEqual('2');
    })
  })
}