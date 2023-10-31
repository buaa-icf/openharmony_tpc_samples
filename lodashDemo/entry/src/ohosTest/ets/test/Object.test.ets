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
  assignIn,
  assignInWith,
  assignWith,
  at,
  constant,
  create,
  defaults,
  defaultsDeep,
  findKey,
  findLastKey,
  functions,
  functionsIn,
  get,
  has,
  hasIn,
  invert,
  invertBy,
  invoke,
  isArray,
  isNumber,
  isUndefined,
  keys,
  keysIn,
  mapKeys,
  mapValues,
  merge,
  mergeWith,
  omit,
  omitBy,
  partialRight,
  pick,
  pickBy,
  result,
  set,
  setWith,
  transform,
  unset,
  update,
  updateWith,
  values,
  valuesIn
} from 'lodash';

export default function objectTest() {
  describe('ObjectTest', function () {
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
    it('assignTest01',0, function () {
      function Foo() {
        this.a = 1;
      }
      function Bar() {
        this.c = 3;
      }
      Foo.prototype.b = 2;
      Bar.prototype.d = 4;
      let assigns = assign({ 'a': 0 }, new Foo, new Bar);
      expect(JSON.stringify(assigns)).assertEqual('{"a":1,"c":3}');
    })

    it('assignTest02',0, function () {
      expect(JSON.stringify(assign({ a:1, c:3 }, { a:0 }))).assertEqual('{"a":0,"c":3}');
    })

    it('assignInTest01',0, function () {
      function Foo() {
        this.a = 1;
      }
      function Bar() {
        this.c = 3;
      }
      Foo.prototype.b = 2;
      Bar.prototype.d = 4;
      let assignIns = assignIn({ 'a': 0 }, new Foo, new Bar);
      expect(JSON.stringify(assignIns)).assertEqual('{"a":1,"b":2,"c":3,"d":4}');
    })

    it('assignInTest02',0, function () {
      expect(JSON.stringify(assignIn({ a:1, c:3 }, { a:0 }))).assertEqual('{"a":0,"c":3}');
    })

    it('assignInWithTest01',0, function () {
      function customizer(objValue, srcValue) {
        return isUndefined(objValue) ? srcValue : objValue;
      }
      let defaults = partialRight(assignInWith, customizer);
      expect(JSON.stringify(defaults({ 'a': 1 }, { 'b': 2 }, { 'a': 3 }))).assertEqual('{"a":1,"b":2}');
    })

    it('assignInWithTest02',0, function () {
      function customizer(objectVal, sourceVal) {
        return isUndefined(objectVal) ? sourceVal:objectVal;
      }
      function GfG() {
        this.p = 7;
      }
      function Portal() {
        this.r = 9;
      }
      GfG.prototype.q = 8;
      Portal.prototype.s = 10;
      let obj = assignInWith({ 'p':6 }, new GfG, new Portal,customizer);
      expect(JSON.stringify(obj)).assertEqual('{"p":6,"q":8,"r":9,"s":10}');
    })

    it('assignWithTest01',0, function () {
      function customizer(objValue, srcValue) {
        return isUndefined(objValue) ? srcValue : objValue;
      }
      var defaults = partialRight(assignWith, customizer);
      expect(JSON.stringify(defaults({ 'a': 1 }, { 'b': 2 }, { 'a': 3 }))).assertEqual('{"a":1,"b":2}');
    })

    it('assignWithTest02',0, function () {
      function customizer(objectVal, sourceVal) {
        return isUndefined(objectVal) ? sourceVal:objectVal;
      }
      function Num1() {
        this.i = 11;
      }
      function Num2() {
        this.j = 12;
      }
      Num1.prototype.k = 13;
      Num2.prototype.l = 14;
      let obj = assignWith({ 'i':10 }, new Num1, new Num2,customizer);
      expect(JSON.stringify(obj)).assertEqual('{"i":10,"j":12}');
    })

    it('atTest01',0, function () {
      let object = { 'a': [{ 'b': { 'c': 3 } }, 4] };
      expect(JSON.stringify(at(object, ['a[0].b.c', 'a[1]']))).assertEqual('[3,4]');
    })

    it('atTest02',0, function () {
      let object = { 'oppo':[{ 'vivo':{ 'moto':1900 } }, 2400] };
      let at_elem = at(object, ['oppo[0].vivo.moto', 'oppo[1]']);
      expect(JSON.stringify(at_elem)).assertEqual('[1900,2400]');
    })

    it('createTest01',0, function () {
      function Shape() {
        this.x = 0;
        this.y = 0;
      }
      function Circle() {
        Shape.call(this);
      }
      Circle.prototype = create(Shape.prototype, {
        'constructor': Circle
      });
      let circle = new Circle;
      expect(circle instanceof Circle).assertTrue();
    })

    it('createTest02',0, function () {
      function Shape() {
        this.x = 0;
        this.y = 0;
      }
      function Circle() {
        Shape.call(this);
      }
      Circle.prototype = create(Shape.prototype, {
        'constructor': Circle
      });
      let circle = new Circle;
      expect(circle instanceof Shape).assertTrue();
    })

    it('defaultsTest01',0, function () {
      let defaultsObject = defaults({ 'a': 1 }, { 'b': 2 }, { 'a': 3 })
      expect(JSON.stringify(defaultsObject)).assertEqual('{"a":1,"b":2}');
    })

    it('defaultsTest02',0, function () {
      let defaultsObject = defaults({ 'gfg':3 }, { 'geek':1 }, { 'gfg':6 });
      expect(JSON.stringify(defaultsObject)).assertEqual('{"gfg":3,"geek":1}');
    })

    it('defaultsDeepTest01',0, function () {
      let defaultsObject = defaultsDeep({ 'a': { 'b': 2 } }, { 'a': { 'b': 1, 'c': 3 } });
      expect(JSON.stringify(defaultsObject)).assertEqual('{"a":{"b":2,"c":3}}');
    })

    it('defaultsDeepTest02',0, function () {
      let info = {
        Name:"GeeksforGeeks",
        password:"@1234",
        username:"your_geeks"
      }
      expect(JSON.stringify(defaultsDeep(info, defaults(info, { id:'Id97' })))).assertEqual('{"Name":"GeeksforGeeks","password":"@1234","username":"your_geeks","id":"Id97"}');
    })

    it('findKeyTest01',0, function () {
      let users = {
        'barney':  { 'age': 36, 'active': true },
        'fred':    { 'age': 40, 'active': false },
        'pebbles': { 'age': 1,  'active': true }
      };
      let key = findKey(users, function(o) { return o.age < 40; });
      expect(key).assertEqual('barney');
    })

    it('findKeyTest02',0, function () {
      let users = {
        'barney':  { 'age': 36, 'active': true },
        'fred':    { 'age': 40, 'active': false },
        'pebbles': { 'age': 1,  'active': true }
      };
      let key = findKey(users, ['active', false]);
      expect(key).assertEqual('fred');
    })

    it('findLastKeyTest01',0, function () {
      let users = {
        'barney':  { 'age': 36, 'active': true },
        'fred':    { 'age': 40, 'active': false },
        'pebbles': { 'age': 1,  'active': true }
      };
      let key = findLastKey(users, function(o) { return o.age < 40; });
      expect(key).assertEqual('pebbles');
    })

    it('findLastKeyTest02',0, function () {
      let users = {
        'barney':  { 'age': 36, 'active': true },
        'fred':    { 'age': 40, 'active': false },
        'pebbles': { 'age': 1,  'active': true }
      };
      let key = findLastKey(users, { 'age': 36, 'active': true });
      expect(key).assertEqual('barney');
    })

    it('functionsTest',0, function () {
      function Foo() {
        this.a = constant('a');
        this.b = constant('b');
      }
      Foo.prototype.c = constant('c');
      expect(JSON.stringify(functions(new Foo))).assertEqual('["a","b"]');
    })

    it('functionsInTest',0, function () {
      function Foo() {
        this.a = constant('a');
        this.b = constant('b');
      }
      Foo.prototype.c = constant('c');
      expect(JSON.stringify(functionsIn(new Foo))).assertEqual('["a","b","c"]');
    })

    it('getTest01',0, function () {
      let object = { 'a': [{ 'b': { 'c': 3 } }] };
      expect(get(object, 'a[0].b.c')).assertEqual(3);
    })

    it('getTest02',0, function () {
      let object = { 'a': [{ 'b': { 'c': 3 } }] };
      expect(get(object, 'a.b.c', 'default')).assertEqual('default');
    })

    it('hasTest01',0, function () {
      let object = { 'a': { 'b': 2 } };
      expect(has(object, 'a')).assertTrue();
    })

    it('hasTest02',0, function () {
      let other = create({ 'a': create({ 'b': 2 }) });
      expect(has(other, 'a')).assertFalse();
    })

    it('hasInTest01',0, function () {
      let object = create({ 'a': create({ 'b': 2 }) });
      expect(hasIn(object, 'a')).assertTrue();
    })

    it('hasInTest02',0, function () {
      let object = create({ 'a': create({ 'b': 2 }) });
      expect(hasIn(object, ['a', 'b'])).assertTrue();
    })

    it('invertTest01',0, function () {
      let object = { 'a': 1, 'b': 2, 'c': 1 };
      expect(JSON.stringify(invert(object))).assertEqual('{"1":"c","2":"b"}');
    })

    it('invertTest02',0, function () {
      let object = { 'hello': 1, 'world': 2, '!': 3 };
      expect(JSON.stringify(invert(object))).assertEqual('{"1":"hello","2":"world","3":"!"}');
    })

    it('invertByTest01',0, function () {
      let object = { 'a': 1, 'b': 2, 'c': 1 };
      expect(JSON.stringify(invertBy(object))).assertEqual('{"1":["a","c"],"2":["b"]}');
    })

    it('invertByTest02',0, function () {
      let object = { 'hello': 1, 'world': 2, '!': 3 };
      let invertByObject = invertBy(object, function(value) {
        return 'group' + value;
      });
      expect(JSON.stringify(invertBy(invertByObject))).assertEqual('{"hello":["group1"],"world":["group2"],"!":["group3"]}');
    })

    it('invokeTest01',0, function () {
      let object = { 'a': [{ 'b': { 'c': [1, 2, 3, 4] } }] };
      expect(JSON.stringify(invoke(object, 'a[0].b.c.slice', 1, 3))).assertEqual('[2,3]');
    })

    it('invokeTest02',0, function () {
      let object = { 'p':[{ 'q':{ 'r':{ 's':[ 2, 4, 6, 8, 10 ]} } }] };
      let invokeObject = invoke(object, 'p[0].q.r.s.slice', 2, 5);
      expect(JSON.stringify(invertBy(invokeObject))).assertEqual('{"6":["0"],"8":["1"],"10":["2"]}');
    })

    it('keysTest01',0, function () {
      function Foo() {
        this.a = 1;
        this.b = 2;
      }
      Foo.prototype.c = 3;
      expect(JSON.stringify(keys(new Foo))).assertEqual('["a","b"]');
    })

    it('keysTest02',0, function () {
      function Foo() {
        this.a = 1;
        this.b = 2;
      }
      Foo.prototype.c = 3;
      expect(JSON.stringify(keys('hi'))).assertEqual('["0","1"]');
    })

    it('keysInTest01',0, function () {
      function Foo() {
        this.a = 1;
        this.b = 2;
      }
      Foo.prototype.c = 3;
      expect(JSON.stringify(keysIn(new Foo))).assertEqual('["a","b","c"]');
    })

    it('keysInTest02',0, function () {
      let obj = {
        Name:"GeeksforGeeks",
        password:"@1234",
        username:"your_geeks"
      }
      expect(JSON.stringify(keys(obj))).assertEqual('["Name","password","username"]');
    })

    it('mapKeysTest01',0, function () {
      let mapKeysObject = mapKeys({ 'a': 1, 'b': 2 }, function(value, key) {
        return key + value;
      });
      expect(JSON.stringify(mapKeysObject)).assertEqual('{"a1":1,"b2":2}');
    })

    it('mapKeysTest02',0, function () {
      let mapKeysObject = mapKeys({ 'cpp':15, 'java':40, 'python':63 },
        function(value, key) {
          return  key + value ;
        }
      )
      expect(JSON.stringify(mapKeysObject)).assertEqual('{"cpp15":15,"java40":40,"python63":63}');
    })

    it('mapValuesTest01',0, function () {
      let users = {
        'fred':    { 'user': 'fred',    'age': 40 },
        'pebbles': { 'user': 'pebbles', 'age': 1 }
      };
      let mapValuesObject = mapValues(users, 'age');
      expect(JSON.stringify(mapValuesObject)).assertEqual('{"fred":40,"pebbles":1}');
    })

    it('mapValuesTest02',0, function () {
      let users = {
        'fred':    { 'user': 'fred',    'age': 40 },
        'pebbles': { 'user': 'pebbles', 'age': 1 }
      };
      let mapValuesObject = mapValues(users, function(o) { return o.age; });
      expect(JSON.stringify(mapValuesObject)).assertEqual('{"fred":40,"pebbles":1}');
    })

    it('mergeTest01',0, function () {
      let object = {
        'a': [{ 'b': 2 }, { 'd': 4 }]
      };
      let other = {
        'a': [{ 'c': 3 }, { 'e': 5 }]
      };
      expect(JSON.stringify(merge(object, other))).assertEqual('{"a":[{"b":2,"c":3},{"d":4,"e":5}]}');
    })

    it('mergeTest02',0, function () {
      let object = merge({ cpp:"12" }, { cpp:"12" }, { java:"23" }, { python:"35" });
      expect(JSON.stringify(object)).assertEqual('{"cpp":"12","java":"23","python":"35"}');
    })

    it('mergeWithTest01',0, function () {
      function customizer(objValue, srcValue) {
        if (isArray(objValue)) {
          return objValue.concat(srcValue);
        }
      }
      let object = { 'a': [1], 'b': [2] };
      let other = { 'a': [3], 'b': [4] };
      expect(JSON.stringify(mergeWith(object, other, customizer))).assertEqual('{"a":[1,3],"b":[2,4]}');
    })

    it('mergeWithTest02',0, function () {
      let object = {
        'amit':[{ 'susanta':20 }, { 'durgam':40 }]
      };
      let other = {
        'amit':[{ 'chinmoy':30 }, { 'kripamoy':50 }]
      };
      expect(JSON.stringify(mergeWith(object, other))).assertEqual('{"amit":[{"susanta":20,"chinmoy":30},{"durgam":40,"kripamoy":50}]}');
    })

    it('omitTest01',0, function () {
      let object = { 'a': 1, 'b': '2', 'c': 3 };
      expect(JSON.stringify(omit(object, ['a', 'c']))).assertEqual('{"b":"2"}');
    })

    it('omitTest02',0, function () {
      let obj = { 'x':1, 'y':'2', 'z':3 };
      expect(JSON.stringify(omit(obj, ['x', 'y']))).assertEqual('{"z":3}');
    })

    it('omitByTest01',0, function () {
      let object = { 'a': 1, 'b': '2', 'c': 3 };
      expect(JSON.stringify(omitBy(object, isNumber))).assertEqual('{"b":"2"}');
    })

    it('omitByTest02',0, function () {
      let obj = { 'x':1, 'y':'2', 'z':3 };
      expect(JSON.stringify(omitBy(obj, ['x', 'y']))).assertEqual('{"x":1,"y":"2","z":3}');
    })

    it('pickTest01',0, function () {
      let object = { 'a': 1, 'b': '2', 'c': 3 };
      expect(JSON.stringify(pick(object, ['a', 'c']))).assertEqual('{"a":1,"c":3}');
    })

    it('pickTest02',0, function () {
      let obj = { 'x':1, 'y':'2', 'z':3 };
      expect(JSON.stringify(pick(obj, ['x', 'y']))).assertEqual('{"x":1,"y":"2"}');
    })

    it('pickByTest01',0, function () {
      let object = { 'a': 1, 'b': '2', 'c': 3 };
      expect(JSON.stringify(pickBy(object, isNumber))).assertEqual('{"a":1,"c":3}');
    })

    it('pickByTest02',0, function () {
      let obj = { 'x':1, 'y':'2', 'z':3 };
      expect(JSON.stringify(pickBy(obj, ['x', 'y']))).assertEqual('{}');
    })

    it('resultTest01',0, function () {
      let object = { 'a': [{ 'b': { 'c1': 3, 'c2': constant(4) } }] };
      expect(result(object, 'a[0].b.c1')).assertEqual(3);
    })

    it('resultTest02',0, function () {
      let object = { 'a': [{ 'b': { 'c1': 3, 'c2': constant(4) } }] };
      expect(result(object, 'a[0].b.c3', 'default')).assertEqual('default');
    })

    it('setTest01',0, function () {
      let object = { 'a': [{ 'b': { 'c': 3 } }] };
      let setObject = set(object, 'a[0].b.c', 4);
      expect(JSON.stringify(setObject)).assertEqual('{"a":[{"b":{"c":4}}]}');
    })

    it('setTest02',0, function () {
      let object = { 'a': [{ 'b': { 'c': 3 } }] };
      let setObject = set(object, ['x', '0', 'y', 'z'], 5);
      expect(JSON.stringify(setObject)).assertEqual('{"a":[{"b":{"c":3}}],"x":[{"y":{"z":5}}]}');
    })

    it('setWithTest01',0, function () {
      let object = { };
      let setObject = setWith(object, '[0][1]', 'a', Object);
      expect(JSON.stringify(setObject)).assertEqual('{"0":{"1":"a"}}');
    })

    it('setWithTest02',0, function () {
      let object = { };
      let setObject = setWith(object, '[0][1][2]', 'a', Object);
      expect(JSON.stringify(setObject)).assertEqual('{"0":{"1":{"2":"a"}}}');
    })

    it('transformTest01',0, function () {
      let transformObject = transform([2, 3, 4], function(result, n) {
        result.push(n *= n);
        return n % 2 == 0;
      }, []);
      expect(JSON.stringify(transformObject)).assertEqual('[4,9]');
    })

    it('transformTest02',0, function () {
      let transformObject = transform({ 'a': 1, 'b': 2, 'c': 1 }, function(result, value, key) {
        (result[value] || (result[value] = [])).push(key);
      }, {});
      expect(JSON.stringify(transformObject)).assertEqual('{"1":["a","c"],"2":["b"]}');
    })

    it('unsetTest01',0, function () {
      let object = { 'a': [{ 'b': { 'c': 7 } }] };
      unset(object, 'a[0].b.c');
      expect(JSON.stringify(object)).assertEqual('{"a":[{"b":{}}]}');
    })

    it('unsetTest02',0, function () {
      let object = { 'a': [{ 'b': { 'c': 7 } }] };
      unset(object, ['a', '0', 'b', 'c']);
      expect(JSON.stringify(object)).assertEqual('{"a":[{"b":{}}]}');
    })

    it('updateTest01',0, function () {
      let object = { 'a': [{ 'b': { 'c': 3 } }] };
      update(object, 'a[0].b.c', function(n) { return n * n; });
      expect(object.a[0].b.c).assertEqual(9);
    })

    it('updateTest02',0, function () {
      let obj = { 'cpp':[{ 'java':{ 'python':3 } }] };
      update(obj, 'cpp[0].java.python', function(n) { return n * n; });
      expect(obj.cpp[0].java.python).assertEqual(9);
    })

    it('updateWithTest01',0, function () {
      let object = {};
      let updateWithObject = updateWith(object, '[0][1]', constant('a'), Object);
      expect(JSON.stringify(updateWithObject)).assertEqual('{"0":{"1":"a"}}');
    })

    it('updateWithTest02',0, function () {
      let obj = { 'cpp':[{ 'java':{ 'python':3 } }] };
      updateWith(obj, 'cpp[0].java.python', function(n) { return n * n; });
      expect(obj.cpp[0].java.python).assertEqual(9);
    })

    it('valuesTest01',0, function () {
      function Foo() {
        this.a = 1;
        this.b = 2;
      }
      Foo.prototype.c = 3;
      expect(JSON.stringify(values(new Foo))).assertEqual('[1,2]');
    })

    it('valuesTest02',0, function () {
      function Foo() {
        this.a = 1;
        this.b = 2;
      }
      Foo.prototype.c = 3;
      expect(JSON.stringify(values('hi'))).assertEqual('["h","i"]');
    })

    it('valuesInTest01',0, function () {
      function Foo() {
        this.a = 1;
        this.b = 2;
      }
      Foo.prototype.c = 3;
      expect(JSON.stringify(valuesIn(new Foo))).assertEqual('[1,2,3]');
    })

    it('valuesInTest02',0, function () {
      function Foo() {
        this.a = 1;
        this.b = 2;
      }
      Foo.prototype.c = 3;
      expect(JSON.stringify(valuesIn('hi'))).assertEqual('["h","i"]');
    })
  })
}