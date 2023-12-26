/**
 *  MIT License
 *
 *  Copyright (c) 2023 Huawei Device Co., Ltd.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
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
  describe('UtilTest', () => {
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
    class ABC{
      a: number[] | number = []
      b: number[] | number = []
      c: number[] | number = []
    }

    class B{
      b: number = 0
    }

    class AB{
      a: B | ESObject
    }

    class Const{
      b: ESObject
    }

    class Constant{
      a: Const | ESObject
    }

    class Source {
      a: (array: number[]) => number = () => 0;
      b: string = '';
    }

    class User{
      java: number = 0
      python: number = 0
      js: number = 0
    }

    class Age{
      user: string = ''
      age: number = 0
      active: boolean = true
    }
    class A{
      a: number = 0
    }

    class Ident{
      a: number = 0
      b: number = 0
    }

    class Conforms{
      gfg: number = 0
      GFG: number = 0
    }
    class View{
      label: string = ''
      click: ()=>void = Object
    }
    it('attemptTest01',0, () => {
      let actual: number[] = attempt((): number=> { return slice.call(arguments); }, 1, 2);
      expect(JSON.stringify(actual)).assertEqual('[]');
    })

    it('attemptTest02',0, () => {
      let elements: number = map(new Error, (error: ESObject)=> {
        return attempt(()=> { throw new Error(); }) === error;
      });
      expect(JSON.stringify(elements)).assertEqual('[]');
    })

    it('bindAllTest',0, () => {
      let view: View = {
        label: 'docs',
        click: ()=> {
          console.log('clicked ' + view.label);
        }
      };
      expect(JSON.stringify(bindAll(view, ['click']))).assertEqual('{"label":"docs"}');
    })

    it('condTest01',0, () => {
      let func: (a: Ident)=> string = cond([
        [matches({ 'a': 1 }),           constant('matches A')],
        [conforms({ 'b': isNumber }), constant('matches B')],
        [stubTrue,                      constant('no match')]
      ]);
      let string: string = func({ a: 1, b: 2 });
      expect(string).assertEqual('matches A');
    })

    it('condTest02',0, () => {
      let func: (a: Ident)=> string = cond([
        [matches({ 'a': 1 }),           constant('matches A')],
        [conforms({ 'b': isNumber }), constant('matches B')],
        [stubTrue,                      constant('no match')]
      ]);
      let string: string = func({ a: 1, b: 2 });
      expect(string).assertEqual('matches A');
    })

    it('conformsTest01',0, () => {
      let objects: Ident[] = [
        { a: 2, b: 1 },
        { a: 1, b: 2 }
      ];
      let string: object = filter(objects, conforms({ 'b': (n: number)=> { return n > 1; } }));
      expect(JSON.stringify(string)).assertEqual('[{"a":1,"b":2}]');
    })

    it('conformsTest02',0, () => {
      let objects: Conforms = { gfg:5, GFG:10 };
      let string: boolean = conformsTo(objects,
        { 'GFG':(n: number)=>
        { return n > 12; }
        }
        );
      expect(string).assertFalse();
    })

    it('constantTest01',0, () => {
      let objects: object = times(2, constant({ 'a': 1 }));
      expect(JSON.stringify(objects)).assertEqual('[{"a":1},{"a":1}]');
    })

    it('constantTest02',0, () => {
      let objects: object = times(3, constant({ 'geeks':3 }));
      expect(JSON.stringify(objects)).assertEqual('[{"geeks":3},{"geeks":3},{"geeks":3}]');
    })

    it('defaultToTest01',0, () => {
      expect(defaultTo(1, 10)).assertEqual(1);
    })

    it('defaultToTest02',0, () => {
      expect(defaultTo(undefined, 10)).assertEqual(10);
    })

    it('flowTest01',0, () => {
      let square: (n: number) => void = (n: number): number => {
        return n * n;
      }
      let addSquare: (a: number, b: number)=> number = flow([add, square]);
      expect(addSquare(1, 2)).assertEqual(9);
    })

    it('flowTest02',0, () => {
      let cube: (number: number) => void = (number: number): number => {
        return number * number * number;
      }
      let multiplycube: (a: number, b: number)=> number = flow([multiply, cube]);
      expect(multiplycube(2, 3)).assertEqual(216);
    })

    it('flowRightTest01',0, () => {
      let square: (n: number) => void = (n: number): number => {
        return n * n;
      }
      let addSquare: (a: number, b: number)=> number = flowRight([square, add]);
      expect(addSquare(1, 2)).assertEqual(9);
    })

    it('flowRightTest02',0, () => {
      let cube: (number: number) => void = (number: number): number => {
        return number * number * number;
      }
      let multiplycube: (a: number, b: number)=> number = flowRight([multiply, cube]);
      expect(multiplycube(2, 3)).assertEqual(8);
    })

    it('identityTest01',0, () => {
      let object: A = { a: 1 };
      expect(JSON.stringify(identity(object))).assertEqual('{"a":1}');
    })

    it('identityTest02',0, () => {
      let object: Ident = { a: 9, b: 3 };
      expect(JSON.stringify(identity(object))).assertEqual('{"a":9,"b":3}');
    })

    it('iterateeTest01',0, () => {
      let users: Age[] = [
        { user: 'barney', age: 36, active: true },
        { user: 'fred',   age: 40, active: false }
      ];
      let iterateeObject: object = filter(users, iteratee({ 'user': 'barney', 'active': true }));
      expect(JSON.stringify(identity(iterateeObject))).assertEqual('[{"user":"barney","age":36,"active":true}]');
    })

    it('iterateeTest02',0, () => {
      let users: Age[] = [
        { user: 'barney', age: 36, active: true },
        { user: 'fred',   age: 40, active: false }
      ];
      let iterateeObject: string[] = map(users, iteratee('user'));
      expect(JSON.stringify(identity(iterateeObject))).assertEqual('["barney","fred"]');
    })

    it('matchesTest01',0, () => {
      let objects: ABC[] = [
        { a: 1, b: 2, c: 3 },
        { a: 4, b: 5, c: 6 }
      ];
      let matchesObject: object = filter(objects, matches({ 'a': 4, 'c': 6 }));
      expect(JSON.stringify(identity(matchesObject))).assertEqual('[{"a":4,"b":5,"c":6}]');
    })

    it('matchesTest02',0, () => {
      let users: User[] = [ {java :3, python :5, js :7},
        {java :4, python :2, js :6}
      ];
      let matchesObject: object = filter(users, matches({'java' :3, 'js' :7 }));
      expect(JSON.stringify(identity(matchesObject))).assertEqual('[{"java":3,"python":5,"js":7}]');
    })

    it('matchesPropertyTest01',0, () => {
      let objects: ABC[] = [
        { a: 1, b: 2, c: 3 },
        { a: 4, b: 5, c: 6 }
      ];
      let matchesObject: object = filter(objects, matchesProperty('a', 4));
      expect(JSON.stringify(identity(matchesObject))).assertEqual('[{"a":4,"b":5,"c":6}]');
    })

    it('matchesPropertyTest02',0, () => {
      let users: User[] = [
        {java :3, python :5, js :7},
        {java :4, python :2, js :6}
      ];
      let matchesObject: object = filter(users, matchesProperty('java' ,3));
      expect(JSON.stringify(identity(matchesObject))).assertEqual('[{"java":3,"python":5,"js":7}]');
    })

    it('methodTest01',0, () => {
      let objects: Constant[] = [
        { a: { b: constant(2) } },
        { a: { b: constant(1) } }
      ];
      let methodObject: number[] = map(objects, method('a.b'));
      expect(JSON.stringify(identity(methodObject))).assertEqual('[2,1]');
    })

    it('methodTest02',0, () => {
      let objects: Constant[] = [
        { a: { b: constant(2) } },
        { a: { b: constant(1) } }
      ];
      let methodObject: number[] = map(objects, method(['a', 'b']));
      expect(JSON.stringify(identity(methodObject))).assertEqual('[2,1]');
    })

    it('methodOfTest01',0, () => {
      let array: number[] = times(3, constant),
        object: ABC = { a: array, b: array, c: array };
      let methodOfObject: number[] = map(['a[2]', 'c[0]'], methodOf(object));
      expect(JSON.stringify(identity(methodOfObject))).assertEqual('[2,0]');
    })

    it('methodOfTest02',0, () => {
      let array: number[] = times(3, constant),
        object: ABC = { a: array, b: array, c: array };
      let methodObject: number[] = map([['a', '2'], ['c', '0']], methodOf(object));
      expect(JSON.stringify(identity(methodObject))).assertEqual('[2,0]');
    })

    it('mixinTest01',0, () => {
      let source: Source = { a: (array: number[])=> { return array[1]; }, b: 'ffff' }
      expect(JSON.stringify(mixin({}, source))).assertEqual('{}');
    })

    it('mixinTest02',0, () => {
      let source: Source = { a: (array: number[])=> { return array[0]; }, b: 'B' }
      expect(JSON.stringify(mixin({}, source))).assertEqual('{}');
    })

    it('noopTest',0, () => {
      expect(JSON.stringify(times(2, noop))).assertEqual('[null,null]');
    })

    it('nthArgTest01',0, () => {
      let func: (a: string, b: string, c: string, d: string)=> string = nthArg(1)
      expect(func('a', 'b', 'c', 'd')).assertEqual('b');
    })

    it('nthArgTest02',0, () => {
      let func: (a: string, b: string, c: string, d: string)=> string = nthArg(-2);
      expect(func('a', 'b', 'c', 'd')).assertEqual('c');
    })

    it('overTest01',0, () => {
      let func: (a: number, b: number, c: number, d: number)=> number[] = over([Math.max, Math.min]);
      expect(JSON.stringify(func(1, 2, 3, 4))).assertEqual('[4,1]');
    })

    it('overTest02',0, () => {
      let func: (a: string, b: string)=> boolean[] = over([Boolean, isFinite]);
      expect(JSON.stringify(func('10', 'null'))).assertEqual('[true,true]');
    })

    it('overEveryTest01',0, () => {
      let func: (a: string)=> boolean = overEvery([Boolean, isFinite]);
      expect(func('1')).assertTrue();
    })

    it('overEveryTest02',0, () => {
      let func: (a: string)=> boolean = overEvery([Boolean, isFinite]);
      expect(func('b')).assertFalse();
    })

    it('overSomeTest01',0, () => {
      let func: (a: string)=> boolean = overSome([Boolean, isFinite]);
      expect(func('1')).assertTrue();
    })

    it('overSomeTest02',0, () => {
      let func: (a: string)=> boolean = overSome([Boolean, isFinite]);
      expect(func('a')).assertTrue();
    })

    it('propertyTest01',0, () => {
      let objects: AB[] = [
        { a: { b: 2 } },
        { a: { b: 1 } }
      ];
      let propertyArray: number[] = map(objects, property('a.b'));
      expect(JSON.stringify(propertyArray)).assertEqual('[2,1]');
    })

    it('propertyTest02',0, () => {
      let objects: AB[] = [
        { a: { b: 2 }},
        { a: { b: 1 }}
      ];
      let propertyArray: number[] = map(sortBy(objects, property(['a', 'b'])), 'a.b');
      expect(JSON.stringify(propertyArray)).assertEqual('[1,2]');
    })

    it('propertyOfTest01',0, () => {
      let array: number[] = [0, 1, 2],
        object: ABC = { a: array, b: array, c: array };
      let propertyOfArray: number[] = map(['a[2]', 'c[0]'], propertyOf(object));
      expect(JSON.stringify(propertyOfArray)).assertEqual('[2,0]');
    })

    it('propertyOfTest02',0, () => {
      let array: number[] = [0, 1, 2],
        object: ABC = { a: array, b: array, c: array };
      let propertyOfArray: number[] = map([['a', '2'], ['c', '0']], propertyOf(object));
      expect(JSON.stringify(propertyOfArray)).assertEqual('[2,0]');
    })

    it('rangeTest01',0, () => {
      expect(JSON.stringify(range(4))).assertEqual('[0,1,2,3]');
    })

    it('rangeTest02',0, () => {
      expect(JSON.stringify(range(0, 20, 5))).assertEqual('[0,5,10,15]');
    })

    it('rangeRightTest01',0, () => {
      expect(JSON.stringify(rangeRight(4))).assertEqual('[3,2,1,0]');
    })

    it('rangeRightTest02',0, () => {
      expect(JSON.stringify(rangeRight(0, 20, 5))).assertEqual('[15,10,5,0]');
    })

    it('stubArrayTest01',0, () => {
      let arrays: number[] = times(2, stubArray);
      expect(JSON.stringify(arrays)).assertEqual('[[],[]]');
    })

    it('stubArrayTest02',0, () => {
      let arrays: number[] = times(3, stubArray);
      expect(JSON.stringify(arrays)).assertEqual('[[],[],[]]');
    })

    it('stubFalseTest01',0, () => {
      let arrays: number[] = times(2, stubFalse);
      expect(JSON.stringify(arrays)).assertEqual('[false,false]');
    })

    it('stubFalseTest02',0, () => {
      let arrays: number[] = times(3, stubFalse);
      expect(JSON.stringify(arrays)).assertEqual('[false,false,false]');
    })

    it('stubObjectTest01',0, () => {
      let arrays: number[] = times(2, stubObject);
      expect(JSON.stringify(arrays)).assertEqual('[{},{}]');
    })

    it('stubObjectTest02',0, () => {
      let arrays: number[] = times(3, stubObject);
      expect(JSON.stringify(arrays)).assertEqual('[{},{},{}]');
    })

    it('stubStringTest01',0, () => {
      let arrays: number[] = times(2, stubString);
      expect(JSON.stringify(arrays)).assertEqual('["",""]');
    })

    it('stubStringTest02',0, () => {
      let arrays: number[] = times(3, stubString);
      expect(JSON.stringify(arrays)).assertEqual('["","",""]');
    })

    it('stubTrueTest01',0, () => {
      let arrays: number[] = times(2, stubTrue);
      expect(JSON.stringify(arrays)).assertEqual('[true,true]');
    })

    it('stubTrueTest02',0, () => {
      let arrays: number[] = times(3, stubTrue);
      expect(JSON.stringify(arrays)).assertEqual('[true,true,true]');
    })

    it('timesTest01',0, () => {
      let arrays: number[] = times(3, String);
      expect(JSON.stringify(arrays)).assertEqual('["0","1","2"]');
    })

    it('timesTest02',0, () => {
      let arrays: number[] = times(4, constant(0));
      expect(JSON.stringify(arrays)).assertEqual('[0,0,0,0]');
    })

    it('toPathTest01',0, () => {
      let arrays: number[] = toPath('a.b.c');
      expect(JSON.stringify(arrays)).assertEqual('["a","b","c"]');
    })

    it('toPathTest02',0, () => {
      let arrays: number = toPath('a[0].b.c');
      expect(JSON.stringify(arrays)).assertEqual('["a","0","b","c"]');
    })

    it('uniqueIdTest01',0, () => {
      let arrays: string = uniqueId('contact_');
      expect(arrays).assertEqual('contact_1');
    })

    it('uniqueIdTest02',0, () => {
      expect(uniqueId()).assertEqual('2');
    })
  })
}