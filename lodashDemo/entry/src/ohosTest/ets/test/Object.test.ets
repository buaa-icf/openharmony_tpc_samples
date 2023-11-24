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
  describe('ObjectTest', () => {
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
    class java{
      python: number | ESObject = 0
    }

    class Update{
      cpp: java | ESObject = []
    }

    class A{
      a: B | ESObject = []
    }

    class B{
      b: C | ESObject
    }

    class C{
      c: number = 0
    }

    class XY{
      x: number = 0
      y: string = ''
      z: number = 0
    }

    class ABC{
      a: number = 0
      b: number | string = ''
      c: number = 0
    }

    class Info{
      Name: string = ''
      password: string = ''
      username: string = ''
    }
    class Age{
      age: number = 0
      active: boolean = true
    }
    class User{
      barney: Age | ESObject
      fred: Age | ESObject
      pebbles: Age | ESObject
    }

    class Array{
      a: number[] = []
      b: number[] = []
    }
    class Ages{
      user: string = ''
      age: number = 0
    }

    class Users{
      fred: Ages | ESObject
      pebbles: Ages | ESObject
    }

    let x: number = 0;
    let y: number = 0;
    let a: ESObject;
    let b: ESObject;
    let c: ESObject;
    it('assignTest01',0, () => {
      let assigns: object = assign({ age: 100, name: 'aa' }, { age:0 })
      expect(JSON.stringify(assigns)).assertEqual('{"age":0,"name":"aa"}');
    })

    it('assignTest02',0, () => {
      expect(JSON.stringify(assign({ a:1, c:3 }, { a:0 }))).assertEqual('{"a":0,"c":3}');
    })

    it('assignInTest01',0, () => {
      let assignIns: object = assignIn( { a:4 }, {b: 1}, {c: 3});
      expect(JSON.stringify(assignIns)).assertEqual('{"a":4,"b":1,"c":3}');
    })

    it('assignInTest02',0, () => {
      expect(JSON.stringify(assignIn({ a:1, c:3 }, { a:0 }))).assertEqual('{"a":0,"c":3}');
    })

    it('assignInWithTest01',0, () => {
      let customizer: (objValue: ESObject, srcValue: ESObject) => void = (objValue: ESObject, srcValue: ESObject): boolean => {
        return isUndefined(objValue) ? srcValue : objValue;
      }
      let defaults: ESObject = partialRight(assignInWith, customizer);
      expect(JSON.stringify(defaults({ a: 1 }, { b: 2 }, { a: 3 }))).assertEqual('{"a":1,"b":2}');
    })

    it('assignInWithTest02',0, () => {
      let customizer: (objectVal: ESObject, sourceVal: ESObject) => void = (objectVal: ESObject, sourceVal: ESObject): boolean => {
        return isUndefined(objectVal) ? sourceVal:objectVal;
      }

      let obj: object = assignInWith({ 'gfg':1 }, { 'geek':3 }, customizer);
      expect(JSON.stringify(obj)).assertEqual('{"gfg":1,"geek":3}');
    })

    it('assignWithTest01',0, () => {
      let customizer: (objValue: ESObject, srcValue: ESObject) => void = (objValue: ESObject, srcValue: ESObject): boolean => {
        return isUndefined(objValue) ? srcValue : objValue;
      }
      let defaults: ESObject = partialRight(assignWith, customizer);
      expect(JSON.stringify(defaults({ 'a': 1 }, { 'b': 2 }, { 'a': 3 }))).assertEqual('{"a":1,"b":2}');
    })

    it('assignWithTest02',0, () => {
      let customizer: (objectVal: ESObject, sourceVal: ESObject) => void = (objectVal: ESObject, sourceVal: ESObject): boolean => {
        return isUndefined(objectVal) ? sourceVal:objectVal;
      }

      let obj: object = assignWith({ 'hi':13 }, { 'GFG':4 }, customizer);
      expect(JSON.stringify(obj)).assertEqual('{"hi":13,"GFG":4}');
    })

    it('atTest01',0, () => {
      expect(JSON.stringify(at({ a: [{ b: { c: 3 } }, 4] }, ['a[0].b.c', 'a[1]']))).assertEqual('[3,4]');
    })

    it('atTest02',0, () => {
      let at_elem: number = at({ oppo:[{ vivo:{ moto:1900 } }, 2400] }, ['oppo[0].vivo.moto', 'oppo[1]']);
      expect(JSON.stringify(at_elem)).assertEqual('[1900,2400]');
    })

    it('createTest01',0, () => {
      let Geeks: () => void = () => {
        return true;
      }

      let GFG: object = create(Geeks, {
        'GeeksforGeeks':"Computer Science Portal"
      });
      expect(JSON.stringify(GFG)).assertEqual('{"GeeksforGeeks":"Computer Science Portal"}');
    })

    it('createTest02',0, () => {
      let protoFunc: () => void = () => {
        return 'Geek';
      }

      let GFG: object = create(protoFunc, {
        'a':"b"
      });
      expect(JSON.stringify(GFG)).assertEqual('{"a":"b"}');
    })

    it('defaultsTest01',0, () => {
      let defaultsObject: object = defaults({ 'a': 1 }, { 'b': 2 }, { 'a': 3 })
      expect(JSON.stringify(defaultsObject)).assertEqual('{"a":1,"b":2}');
    })

    it('defaultsTest02',0, () => {
      let defaultsObject: object = defaults({ 'gfg':3 }, { 'geek':1 }, { 'gfg':6 });
      expect(JSON.stringify(defaultsObject)).assertEqual('{"gfg":3,"geek":1}');
    })

    it('defaultsDeepTest01',0, () => {
      let defaultsObject: object = defaultsDeep({ 'a': { 'b': 2 } }, { 'a': { 'b': 1, 'c': 3 } });
      expect(JSON.stringify(defaultsObject)).assertEqual('{"a":{"b":2,"c":3}}');
    })

    it('defaultsDeepTest02',0, () => {
      let info: Info = {
        Name:"GeeksforGeeks",
        password:"@1234",
        username:"your_geeks"
      }
      expect(JSON.stringify(defaultsDeep(info, defaults(info, { id:'Id97' })))).assertEqual('{"Name":"GeeksforGeeks","password":"@1234","username":"your_geeks","id":"Id97"}');
    })

    it('findKeyTest01',0, () => {
      let users: User = {
        barney:  { age: 36, active: true },
        fred:    { age: 40, active: false},
        pebbles: { age: 1,  active: true }
      };
      let key: string = findKey(users, (o: Age)=> { return o.age < 40; });
      expect(key).assertEqual('barney');
    })

    it('findKeyTest02',0, () => {
      let users: User = {
        barney:  { age: 36, active: true },
        fred:    { age: 40, active: false},
        pebbles: { age: 1,  active: true }
      };
      let key: string = findKey(users, ['active', false]);
      expect(key).assertEqual('fred');
    })

    it('findLastKeyTest01',0, () => {
      let users: User = {
        barney:  { age: 36, active: true },
        fred:    { age: 40, active: false},
        pebbles: { age: 1,  active: true }
      };
      let key: string = findLastKey(users, (o: Age)=> { return o.age < 40; });
      expect(key).assertEqual('pebbles');
    })

    it('findLastKeyTest02',0, () => {
      let users: User = {
        barney:  { age: 36, active: true },
        fred:    { age: 40, active: false},
        pebbles: { age: 1,  active: true }
      };
      let key: string = findLastKey(users, { 'age': 36, 'active': true });
      expect(key).assertEqual('barney');
    })

    it('functionsTest',0, () => {
      expect(JSON.stringify(functions({ a: 1, b: 2, c: 1 }))).assertEqual('[]');
    })

    it('functionsInTest',0, () => {
      let Foo: () => void = () => {
        a = constant('a');
        b = constant('b');
        c = constant('c');
      }
      expect(JSON.stringify(functionsIn(Foo()))).assertEqual('[]');
    })

    it('getTest01',0, () => {
      expect(get({ 'a': [{ 'b': { 'c': 3 } }] }, 'a[0].b.c')).assertEqual(3);
    })

    it('getTest02',0, () => {
      expect(get({ 'a': [{ 'b': { 'c': 3 } }] }, 'a.b.c', 'default')).assertEqual('default');
    })

    it('hasTest01',0, () => {
      expect(has({ 'a': { 'b': 2 } }, 'a')).assertTrue();
    })

    it('hasTest02',0, () => {
      let other: boolean = create({ 'a': create({ 'b': 2 }) });
      expect(has(other, 'a')).assertFalse();
    })

    it('hasInTest01',0, () => {
      let object: boolean = create({ 'a': create({ 'b': 2 }) });
      expect(hasIn(object, 'a')).assertTrue();
    })

    it('hasInTest02',0, () => {
      let object: boolean = create({ 'a': create({ 'b': 2 }) });
      expect(hasIn(object, ['a', 'b'])).assertTrue();
    })

    it('invertTest01',0, () => {
      let object: ABC = { a: 1, b: 2, c: 1 };
      expect(JSON.stringify(invert(object))).assertEqual('{"1":"c","2":"b"}');
    })

    it('invertTest02',0, () => {
      expect(JSON.stringify(invert({ 'hello': 1, 'world': 2, '!': 3 }))).assertEqual('{"1":"hello","2":"world","3":"!"}');
    })

    it('invertByTest01',0, () => {
      let object: ABC = { a: 1, b: 2, c: 1 };
      expect(JSON.stringify(invertBy(object))).assertEqual('{"1":["a","c"],"2":["b"]}');
    })

    it('invertByTest02',0, () => {
      let invertByObject: object = invertBy({ 'hello': 1, 'world': 2, '!': 3 }, (value: string)=> {
        return 'group' + value;
      });
      expect(JSON.stringify(invertBy(invertByObject))).assertEqual('{"hello":["group1"],"world":["group2"],"!":["group3"]}');
    })

    it('invokeTest01',0, () => {
      expect(JSON.stringify(invoke({ 'a': [{ 'b': { 'c': [1, 2, 3, 4] } }] }, 'a[0].b.c.slice', 1, 3))).assertEqual('[2,3]');
    })

    it('invokeTest02',0, () => {
      let invokeObject: object = invoke({'p':[{ 'q':{ 'r':{ 's':[ 2, 4, 6, 8, 10 ]} } }]}, 'p[0].q.r.s.slice', 2, 5);
      expect(JSON.stringify(invertBy(invokeObject))).assertEqual('{"6":["0"],"8":["1"],"10":["2"]}');
    })

    it('keysTest01',0, () => {
      expect(JSON.stringify(keys('100'))).assertEqual('["0","1","2"]');
    })

    it('keysTest02',0, () => {
      expect(JSON.stringify(keys('hi'))).assertEqual('["0","1"]');
    })

    it('keysInTest01',0, () => {
      expect(JSON.stringify(keysIn({'a': 1, 'b': 2}))).assertEqual('["a","b"]');
    })

    it('keysInTest02',0, () => {
      let obj: Info = {
        Name:"GeeksforGeeks",
        password:"@1234",
        username:"your_geeks"
      }
      expect(JSON.stringify(keys(obj))).assertEqual('["Name","password","username"]');
    })

    it('mapKeysTest01',0, () => {
      let mapKeysObject: object = mapKeys({ 'a': 1, 'b': 2 }, (value: number, key: number): number => {
        return key + value;
      });
      expect(JSON.stringify(mapKeysObject)).assertEqual('{"a1":1,"b2":2}');
    })

    it('mapKeysTest02',0, () => {
      let mapKeysObject: object = mapKeys({ 'cpp':15, 'java':40, 'python':63 },
        (value: number, key: number): number => {
          return  key + value ;
        }
      )
      expect(JSON.stringify(mapKeysObject)).assertEqual('{"cpp15":15,"java40":40,"python63":63}');
    })

    it('mapValuesTest01',0, () => {
      let users: Users = {
        fred: { user: 'fred', age: 40 },
        pebbles: { user: 'pebbles', age: 1 }
      };
      let mapValuesObject: object = mapValues(users, 'age');
      expect(JSON.stringify(mapValuesObject)).assertEqual('{"fred":40,"pebbles":1}');
    })

    it('mapValuesTest02',0, () => {
      let users: Users = {
        fred: { user: 'fred', age: 40 },
        pebbles: { user: 'pebbles', age: 1 }
      };
      let mapValuesObject: object = mapValues(users, (o: Ages)=> { return o.age; });
      expect(JSON.stringify(mapValuesObject)).assertEqual('{"fred":40,"pebbles":1}');
    })

    it('mergeTest01',0, () => {
      expect(JSON.stringify(merge({a: [{b: 2}, {d: 4 }]}, {a: [{c: 3}, {e: 5 }]}))).assertEqual('{"a":[{"b":2,"c":3},{"d":4,"e":5}]}');
    })

    it('mergeTest02',0, () => {
      let object: object = merge({ cpp:"12" }, { cpp:"12" }, { java:"23" }, { python:"35" });
      expect(JSON.stringify(object)).assertEqual('{"cpp":"12","java":"23","python":"35"}');
    })

    it('mergeWithTest01',0,  ()=> {
      let customizer: (objValue: ESObject, srcValue: ESObject) => void = (objValue: ESObject, srcValue: ESObject): ESObject => {
        if (isArray(objValue)) {
          return objValue.concat(srcValue);
        }
      }
      let object: Array = { a: [1], b: [2] };
      let other: Array = { a: [3], b: [4] };
      expect(JSON.stringify(mergeWith(object, other, customizer))).assertEqual('{"a":[1,3],"b":[2,4]}');
    })

    it('mergeWithTest02',0, () => {
      expect(JSON.stringify(mergeWith({amit:[{ susanta:20 }, { durgam:40 }]}, {amit:[{ chinmoy:30 }, { kripamoy:50 }]}))
      ).assertEqual('{"amit":[{"susanta":20,"chinmoy":30},{"durgam":40,"kripamoy":50}]}');
    })

    it('omitTest01',0, () => {
      let object: ABC = { a: 1, b: '2', c: 3 };
      expect(JSON.stringify(omit(object, ['a', 'c']))).assertEqual('{"b":"2"}');
    })

    it('omitTest02',0, () => {
      let obj: XY = { x:1, y:'2', z:3 };
      expect(JSON.stringify(omit(obj, ['x', 'y']))).assertEqual('{"z":3}');
    })

    it('omitByTest01',0, () => {
      let object: ABC = { a: 1, b: '2', c: 3 };
      expect(JSON.stringify(omitBy(object, isNumber))).assertEqual('{"b":"2"}');
    })

    it('omitByTest02',0, () => {
      let obj: XY = { x:1, y:'2', z:3 };
      expect(JSON.stringify(omitBy(obj, ['x', 'y']))).assertEqual('{"x":1,"y":"2","z":3}');
    })

    it('pickTest01',0, () => {
      let object: ABC = { a: 1, b: '2', c: 3 };
      expect(JSON.stringify(pick(object, ['a', 'c']))).assertEqual('{"a":1,"c":3}');
    })

    it('pickTest02',0, () => {
      let obj: XY = { x:1, y:'2', z:3 };
      expect(JSON.stringify(pick(obj, ['x', 'y']))).assertEqual('{"x":1,"y":"2"}');
    })

    it('pickByTest01',0, () => {
      let object: ABC = { a: 1, b: '2', c: 3 };
      expect(JSON.stringify(pickBy(object, isNumber))).assertEqual('{"a":1,"c":3}');
    })

    it('pickByTest02',0, () => {
      let obj: XY = { x:1, y:'2', z:3 };
      expect(JSON.stringify(pickBy(obj, ['x', 'y']))).assertEqual('{}');
    })

    it('resultTest01',0, () => {
      expect(result({ a: [{ b: { c1: 3, c2: constant(4) } }] }, 'a[0].b.c1')).assertEqual(3);
    })

    it('resultTest02',0, () => {
      expect(result({ a: [{ b: { c1: 3, c2: constant(4) } }] }, 'a[0].b.c3', 'default')).assertEqual('default');
    })

    it('setTest01',0, () => {
      let object: A = { a: [{ b: { c: 3 }as C }] };
      let setObject: object = set(object, 'a[0].b.c', 4);
      expect(JSON.stringify(setObject)).assertEqual('{"a":[{"b":{"c":4}}]}');
    })

    it('setTest02',0, () => {
      let object: A = { a: [{ b: { c: 3 }as C }] };
      let setObject: object = set(object, ['x', '0', 'y', 'z'], 5);
      expect(JSON.stringify(setObject)).assertEqual('{"a":[{"b":{"c":3}}],"x":[{"y":{"z":5}}]}');
    })

    it('setWithTest01',0, () => {
      let setObject: object = setWith({}, '[0][1]', 'a', Object);
      expect(JSON.stringify(setObject)).assertEqual('{"0":{"1":"a"}}');
    })

    it('setWithTest02',0, () => {
      let setObject: object = setWith({}, '[0][1][2]', 'a', Object);
      expect(JSON.stringify(setObject)).assertEqual('{"0":{"1":{"2":"a"}}}');
    })

    it('transformTest01',0, () => {
      let transformObject: number[] = transform([2, 3, 4], (result: number[], n: number)=> {
        result.push(n *= n);
        return n % 2 == 0;
      }, []);
      expect(JSON.stringify(transformObject)).assertEqual('[4,9]');
    })

    it('transformTest02',0, () => {
      let transformObject: object = transform({ 'a': 1, 'b': 2, 'c': 1 },(result: string[], value: string, key: number[])=> {
        (result[value] || (result[value] = [])).push(key);
      }, {});
      expect(JSON.stringify(transformObject)).assertEqual('{"1":["a","c"],"2":["b"]}');
    })

    it('unsetTest01',0, () => {
      let object: A = { a: [{ b: { c: 7 }as C }] };
      unset(object, 'a[0].b.c');
      expect(JSON.stringify(object)).assertEqual('{"a":[{"b":{}}]}');
    })

    it('unsetTest02',0, () => {
      let object: A = { a: [{ b: { c: 7 }as C }] };
      unset(object, ['a', '0', 'b', 'c']);
      expect(JSON.stringify(object)).assertEqual('{"a":[{"b":{}}]}');
    })

    it('updateTest01',0, () => {
      let object: A = { a: [{ b: { c: 3 }as C }] };
      update(object, 'a[0].b.c',(n: number)=> { return n * n; });
      expect(object.a[0].b.c).assertEqual(9);
    })

    it('updateTest02',0, () => {
      let obj: Update = { cpp:[{ java:{ python:3 }as java }] };
      update(obj, 'cpp[0].java.python',(n: number)=> { return n * n; });
      expect(obj.cpp[0].java.python).assertEqual(9);
    })

    it('updateWithTest01',0, () => {
      let updateWithObject: object = updateWith({}, '[0][1]', constant('a'), Object);
      expect(JSON.stringify(updateWithObject)).assertEqual('{"0":{"1":"a"}}');
    })

    it('updateWithTest02',0, () => {
      let obj: Update = { cpp:[{ java:{ python:3 }as java }] };
      updateWith(obj, 'cpp[0].java.python',(n: number)=> { return n * n; });
      expect(obj.cpp[0].java.python).assertEqual(9);
    })

    it('valuesTest01',0, () => {
      expect(JSON.stringify(values({ a: [{ b: { c: 7 } }] }))).assertEqual('[[{"b":{"c":7}}]]');
    })

    it('valuesTest02',0, () => {
      expect(JSON.stringify(values('hi'))).assertEqual('["h","i"]');
    })

    it('valuesInTest01',0, () => {
      expect(JSON.stringify(valuesIn({ x:1, y:'2', z:3 }))).assertEqual('[1,"2",3]');
    })

    it('valuesInTest02',0, () => {
      expect(JSON.stringify(valuesIn('hi'))).assertEqual('["h","i"]');
    })
  })
}