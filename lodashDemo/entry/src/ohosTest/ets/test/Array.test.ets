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
  chunk, compact, concat, difference, differenceBy, differenceWith, drop,
  dropRightWhile,
  dropWhile,
  fill,
  findIndex,
  findLastIndex,
  head,
  indexOf,
  initial,
  intersection,
  intersectionBy,
  intersectionWith,
  isEqual,
  join,
  last,
  lastIndexOf,
  nth,
  pull,
  pullAll,
  pullAllBy,
  pullAllWith,
  pullAt,
  remove,
  reverse,
  slice,
  sortedIndex,
  sortedIndexBy,
  sortedIndexOf,
  sortedLastIndex,
  sortedLastIndexBy,
  sortedLastIndexOf,
  sortedUniq,
  sortedUniqBy,
  tail,
  take,
  takeRight,
  takeRightWhile,
  takeWhile,
  union,
  unionWith,
  uniq,
  unzip,
  without,
  xor,
  xorBy,
  xorWith,
  zip,
  zipObject,
  zipObjectDeep,
  zipWith
} from 'lodash';

export default function arrayTest() {
  describe('ArrayTest', () => {
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
    class XY {
      x: number = 0
      y: number = 0
    }

    class AB {
      a: number = 0
      b: number = 0
    }

    class CD {
      c: number = 0
      d: number = 0
    }

    class X {
      x: number = 0
    }
    class Y {
      y: number = 0
    }

    class B {
      b: number = 0
    }

    class C {
      c: number = 0
    }

    class User{
      user: string = ''
      active: boolean = true
    }

    it('chunkTest01',0, () => {
      let chunkArray: number[] = chunk(['a', 'b', 'c', 'd'], 2);
      expect(JSON.stringify(chunkArray)).assertEqual('[["a","b"],["c","d"]]')
    })

    it('chunkTest02',0, () => {
      let chunkArray: number[] = chunk(['a', 'b', 'c', 'd'], 3);
      expect(JSON.stringify(chunkArray)).assertEqual('[["a","b","c"],["d"]]')
    })

    it('compactTest01',0, () => {
      let compactArray: number[] = compact([0, 1, false, 2, '', 3]);
      expect(JSON.stringify(compactArray)).assertEqual('[1,2,3]')
    })

    it('compactTest02',0, () => {
      let compactArray: number[] = compact([0, 1, false, 2, '', null, 0]);
      expect(JSON.stringify(compactArray)).assertEqual('[1,2]')
    })

    it('concatTest01',0, () => {
      let array: number[] = [1];
      let concatArray: number[] = concat(array, 2, [3], [[4]]);
      expect(JSON.stringify(concatArray)).assertEqual('[1,2,3,[4]]')
    })

    it('concatTest02',0, () => {
      let array = ['a'];
      let concatArray: number[] = concat(array, 'd', [3], [[4], [6]]);
      expect(JSON.stringify(concatArray)).assertEqual('["a","d",3,[4],[6]]')
    })

    it('differenceTest01',0, () => {
      let differenceArray: number[] = difference([3, 2, 1], [4, 2]);
      expect(JSON.stringify(differenceArray)).assertEqual('[3,1]')
    })

    it('differenceTest02',0, () => {
      let differenceArray: number[] = difference([3, 2, 1, 9, 3], [3, 2]);
      expect(JSON.stringify(differenceArray)).assertEqual('[1,9]')
    })

    it('differenceByTest01',0, () => {
      let differenceByArray: number[] = differenceBy([3.1, 2.2, 1.3], [4.4, 2.5], Math.floor);
      expect(JSON.stringify(differenceByArray)).assertEqual('[3.1,1.3]')
    })
    it('differenceByTest02',0, () => {
      let differenceByArray: number[] = differenceBy([{ 'x': 2 }, { 'x': 1 }], [{ 'x': 1 }], 'x');
      expect(JSON.stringify(differenceByArray)).assertEqual('[{"x":2}]')
    })

    it('differenceWithTest01',0, () => {
      let objects = [{ x: 1, y: 2 }as XY, { x: 2, y: 1 }as XY];
      let differenceWithArray: object = differenceWith(objects, [{ 'x': 1, 'y': 2 }], isEqual);
      expect(JSON.stringify(differenceWithArray)).assertEqual('[{"x":2,"y":1}]')
    })

    it('differenceWithTest02',0, () => {
      let objects = [{ x: 1, y: 2 }as XY, { c: 2, d: 1 }as CD, { a: 6, b: 7 }as AB];
      let differenceWithArray: object = differenceWith(objects, [{ 'x': 1, 'y': 2 }], isEqual);
      expect(JSON.stringify(differenceWithArray)).assertEqual('[{"c":2,"d":1},{"a":6,"b":7}]')
    })

    it('dropTest01',0, () => {
      let dropArray: number[] = drop([1, 2, 3]);
      expect(JSON.stringify(dropArray)).assertEqual('[2,3]')
    })

    it('dropTest02',0, () => {
      let dropArray: number[] = drop([1, 2, 3], 5);
      expect(JSON.stringify(dropArray)).assertEqual('[]')
    })

    it('dropRightTest01',0, () => {
      let dropRightArray: number[] = drop([1, 2, 3]);
      expect(JSON.stringify(dropRightArray)).assertEqual('[2,3]')
    })

    it('dropRightTest02',0, () => {
      let dropRightArray: number[] = drop([0, 1, 2, 3, 9, 10], 2);
      expect(JSON.stringify(dropRightArray)).assertEqual('[2,3,9,10]')
    })

    it('dropRightWhileTest01',0, () => {
      let users: User[] = [
        { user: 'barney',  active: true },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: false }
      ];
      let dropRightWhileArray: number[] = dropRightWhile(users, (o: User)=> { return !o.active; });
      expect(JSON.stringify(dropRightWhileArray)).assertEqual('[{"user":"barney","active":true}]')
    })

    it('dropRightWhileTest02',0, () => {
      let users: User[] = [
        { user: 'barney',  active: true },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: false }
      ];
      let dropRightWhileArray: number[] = dropRightWhile(users, { 'user': 'pebbles', 'active': false });
      expect(JSON.stringify(dropRightWhileArray)).assertEqual('[{"user":"barney","active":true},{"user":"fred","active":false}]')
    })

    it('dropWhileTest01',0, () => {
      let users: User[] = [
        { user: 'barney',  active: false },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: true }
      ];
      let dropWhileArray: number[] = dropWhile(users, (o: User)=> { return !o.active; });
      expect(JSON.stringify(dropWhileArray)).assertEqual('[{"user":"pebbles","active":true}]')
    })

    it('dropWhileTest02',0, () => {
      let users: User[] = [
        { user: 'barney',  active: false },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: true }
      ];
      let dropWhileArray: number[] = dropWhile(users, 'active');
      expect(JSON.stringify(dropWhileArray)).assertEqual('[{"user":"barney","active":false},{"user":"fred","active":false},{"user":"pebbles","active":true}]')
    })

    it('fillTest01',0, () => {
      let array = [1, 2, 3];
      let fillArray: number[] = fill(array, 'a');
      expect(JSON.stringify(fillArray)).assertEqual('["a","a","a"]')
    })

    it('fillTest02',0, () => {
      let fillArray: number[] = fill([4, 6, 8, 10], '*', 1, 3);
      expect(JSON.stringify(fillArray)).assertEqual('[4,"*","*",10]')
    })

    it('findIndexTest01',0, () => {
      let users: User[] = [
        { user: 'barney',  active: false },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: true }
      ];
      let findIndexArray: number[] = findIndex(users, (o: User)=> { return o.user == 'barney'; });
      expect(JSON.stringify(findIndexArray)).assertEqual('0')
    })

    it('findIndexTest02',0, () => {
      let users: User[] = [
        { user: 'barney',  active: false },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: true }
      ];
      let findIndexArray: number[] = findIndex(users, 'active');
      expect(JSON.stringify(findIndexArray)).assertEqual('2')
    })

    it('findLastIndexTest01',0, () => {
      let users: User[] = [
        { user: 'barney',  active: true },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: false }
      ];
      let findLastIndexArray: number[] = findLastIndex(users, (o: User)=> { return o.user == 'pebbles'; });
      expect(JSON.stringify(findLastIndexArray)).assertEqual('2')
    })

    it('findLastIndexTest02',0, () => {
      let users: User[] = [
        { user: 'barney',  active: true },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: false }
      ];
      let findLastIndexArray: number[] = findLastIndex(users, { 'user': 'barney', 'active': true });
      expect(JSON.stringify(findLastIndexArray)).assertEqual('0')
    })

    it('headTest01',0, () => {
      let headArray: number[] = head([1, 2, 3]);
      expect(headArray).assertEqual(1);
    })

    it('headTest02',0, () => {
      let headArray: number[] = head([]);
      expect(JSON.stringify(headArray)).assertUndefined();
    })

    it('indexOfTest01',0, () => {
      let indexOfArray: number[] = indexOf([1, 2, 1, 2], 2);
      expect(indexOfArray).assertEqual(1);
    })

    it('indexOfTest02',0, () => {
      let indexOfArray: number[] = indexOf([1, 2, 1, 2], 2, 2);
      expect(indexOfArray).assertEqual(3);
    })

    it('initialTest01',0, () => {
      let initialArray: number[] = initial([1, 2, 3]);
      expect(JSON.stringify(initialArray)).assertEqual('[1,2]');
    })

    it('initialTest02',0, () => {
      let initialArray: number[] = initial(['a', 'b', 1, 2, 3, 's']);
      expect(JSON.stringify(initialArray)).assertEqual('["a","b",1,2,3]');
    })

    it('intersectionTest01',0, () => {
      let intersectionArray: number[] = intersection([2, 1], [4, 2], [1, 2]);
      expect(JSON.stringify(intersectionArray)).assertEqual('[2]');
    })

    it('intersectionTest02',0, () => {
      let intersectionArray: number[] = intersection(['a', 1], ['a', 2], [1, 'a']);
      expect(JSON.stringify(intersectionArray)).assertEqual('["a"]');
    })

    it('intersectionByTest01',0, () => {
      let intersectionByArray: number[] = intersectionBy([2.1, 1.2], [4.3, 2.4], Math.floor);
      expect(JSON.stringify(intersectionByArray)).assertEqual('[2.1]');
    })

    it('intersectionByTest02',0, () => {
      let intersectionByArray: number[] = intersectionBy([{ 'x': 1 }], [{ 'x': 2 }, { 'x': 1 }], 'x');
      expect(JSON.stringify(intersectionByArray)).assertEqual('[{"x":1}]');
    })

    it('intersectionWithTest01',0, () => {
      let objects = [{ x: 1, y: 2 }as XY, { x: 2, y: 1 }as XY];
      let others = [{ x: 1, y: 1 }as XY, { x: 1, y: 2 }as XY];
      let intersectionWithArray: number[] = intersectionWith(objects, others, isEqual);
      expect(JSON.stringify(intersectionWithArray)).assertEqual('[{"x":1,"y":2}]');
    })

    it('intersectionWithTest02',0, () => {
      let objects = [{ x: 1, y: 2 }as XY, { x: 2, y: 1 }as XY, { a: 5, b: 6 }as AB];
      let others = [{ x: 1, y: 1 }as XY, { x: 1, y: 2 }as XY, { a: 5, b: 6 }as AB];
      let intersectionWithArray: number[] = intersectionWith(objects, others, isEqual);
      expect(JSON.stringify(intersectionWithArray)).assertEqual('[{"x":1,"y":2},{"a":5,"b":6}]');
    })

    it('joinTest01',0, () => {
      let joinArray: number[] = join(['a', 'b', 'c'], '~');
      expect(joinArray).assertEqual('a~b~c');
    })

    it('joinTest02',0, () => {
      let joinArray: number[] = join(['hello', 'world', 'join'], '#~#');
      expect(joinArray).assertEqual('hello#~#world#~#join');
    })

    it('lastTest01',0, () => {
      let lastArray: number[] = last([1, 2, 3]);
      expect(lastArray).assertEqual(3);
    })

    it('lastTest02',0, () => {
      let lastArray: number[] = last(['a', 'b', 1, 7, 'c']);
      expect(lastArray).assertEqual('c');
    })

    it('lastIndexOfTest01',0, () => {
      let lastIndexOfArray: number[] = lastIndexOf([1, 2, 1, 2], 2);
      expect(lastIndexOfArray).assertEqual(3);
    })

    it('lastIndexOfTest02',0, () => {
      let lastIndexOfArray: number[] = lastIndexOf([1, 2, 1, 2], 2, 2);
      expect(lastIndexOfArray).assertEqual(1);
    })

    it('nthTest01',0, () => {
      let array = ['a', 'b', 'c', 'd'];
      let nthArray: number[] = nth(array, 1);
      expect(nthArray).assertEqual('b');
    })

    it('nthTest02',0, () => {
      let array = ['a', 'b', 'c', 'd'];
      let nthArray: number[] = nth(array, -2);
      expect(nthArray).assertEqual('c');
    })

    it('pullTest01',0, () => {
      let array = [1, 2, 3, 1, 2, 3];
      let pullArray: number[] = pull(array, 2, 3);
      expect(JSON.stringify(pullArray)).assertEqual('[1,1]');
    })

    it('pullTest02',0, () => {
      let array = ['a', 'b',  3, 1, 2, 3, 'c'];
      let pullArray: number[] = pull(array, 'a', 3);
      expect(JSON.stringify(pullArray)).assertEqual('["b",1,2,"c"]');
    })

    it('pullAllTest01',0, () => {
      let array = ['a', 'b',  3, 1, 2, 3, 'c'];
      let pullAllArray: number[] = pullAll(array, ['a', 3]);
      expect(JSON.stringify(pullAllArray)).assertEqual('["b",1,2,"c"]');
    })

    it('pullAllTest02',0, () => {
      let array = [1, 2, 3, 1, 2, 3];
      let pullAllArray: number[] = pullAll(array, [2, 3]);
      expect(JSON.stringify(pullAllArray)).assertEqual('[1,1]');
    })

    it('pullAllByTest01',0, () => {
      let array = [{ x: 1 }, { x: 2 }, { x: 3 }, { x: 1 }]as XY[];
      let pullAllByArray: object = pullAllBy(array, [{ 'x': 1 }, { 'x': 3 }], 'x');
      expect(JSON.stringify(pullAllByArray)).assertEqual('[{"x":2}]');
    })

    it('pullAllByTest02',0, () => {
      let array = [{ x: 1 }as X, { x: 2 }as X, { y: 3 }as Y, { b: 1 }as B, {c: 5}as C];
      let pullAllByArray: object = pullAllBy(array, [{ 'x': 1 }, { 'c': 5 }], 'y');
      expect(JSON.stringify(pullAllByArray)).assertEqual('[{"y":3}]');
    })

    it('pullAllWithTest01',0, () => {
      let array = [{ x: 1, y: 2 }, { x: 3, y: 4 }, { x: 5, y: 6 }]as XY[];
      let pullAllWithArray: object = pullAllWith(array, [{ 'x': 3, 'y': 4 }], isEqual);
      expect(JSON.stringify(pullAllWithArray)).assertEqual('[{"x":1,"y":2},{"x":5,"y":6}]');
    })

    it('pullAllWithTest02',0, () => {
      let array = [{ x: 1, y: 2 }as XY, { a: 7, b: 7 }as AB, { x: 5, y: 6 }as XY, { c: 9, d: 0 }as CD];
      let pullAllWithArray: object = pullAllWith(array, [{ 'x': 1, 'y': 2 },{ 'x': 5, 'y': 6 }], isEqual);
      expect(JSON.stringify(pullAllWithArray)).assertEqual('[{"a":7,"b":7},{"c":9,"d":0}]');
    })

    it('pullAtTest01',0, () => {
      let array = [5, 10, 15, 20];
      let evens: number[] = pullAt(array, 1, 3);
      expect(JSON.stringify(evens)).assertEqual('[10,20]');
    })

    it('pullAtTest02',0, () => {
      let array = [12, 34, 'a', 'b', 'c', 20];
      let evens: number[] = pullAt(array, 2, 4);
      expect(JSON.stringify(evens)).assertEqual('["a","c"]');
    })

    it('removeTest01',0, () => {
      let array = [1, 2, 3, 4];
      let evens: number[] = remove(array, (n: number)=> {
        return n % 2 == 0;
      });
      expect(JSON.stringify(evens)).assertEqual('[2,4]');
    })

    it('removeTest02',0, () => {
      let array = [8, 3, 4, 6, 9, 12, 14, 24];
      let evens: number[] = remove(array, (n: number)=> {
        return n % 2 == 0;
      });
      expect(JSON.stringify(evens)).assertEqual('[8,4,6,12,14,24]');
    })

    it('reverseTest01',0, () => {
      let array = [1, 2, 3];
      let reverseArray: number[] = reverse(array);
      expect(JSON.stringify(reverseArray)).assertEqual('[3,2,1]');
    })

    it('reverseTest02',0, () => {
      let array = ['a', 'b', 'c'];
      let reverseArray: string[] = reverse(array);
      expect(JSON.stringify(reverseArray)).assertEqual('["c","b","a"]');
    })

    it('sliceTest01',0, () => {
      let array = [[1, 12], [12, 8], 7, 8]
      let sliceArray: number[][] = slice(array, 1, 3);
      expect(JSON.stringify(sliceArray)).assertEqual('[[12,8],7]');
    })

    it('sliceTest02',0, () => {
      let array = [[1, 12], [12, 8], 'a', 'as', 'b', 'g']
      let sliceArray: string[] = slice(array, 2, 5);
      expect(JSON.stringify(sliceArray)).assertEqual('["a","as","b"]');
    })

    it('sortedIndexTest01',0, () => {
      let sortedIndexArray: number = sortedIndex([30, 50], 40);
      expect(sortedIndexArray).assertEqual(1);
    })

    it('sortedIndexTest02',0, () => {
      let sortedIndexArray: number = sortedIndex([30, 35, 50, 70, 100,190], 110);
      expect(sortedIndexArray).assertEqual(5);
    })

    it('sortedIndexByTest01',0, () => {
      let objects = [{ x: 4 }, { x: 5 }]as X[];
      let sortedIndexByArray: number = sortedIndexBy(objects, { 'x': 4 }, (o: X)=> { return o.x; });
      expect(sortedIndexByArray).assertEqual(0);
    })

    it('sortedIndexByTest02',0, () => {
      let objects = [{ x: 4 }, { x: 5 }]as X[];
      let sortedIndexByArray: number = sortedIndexBy(objects, { 'x': 4 }, 'x');
      expect(sortedIndexByArray).assertEqual(0);
    })

    it('sortedIndexOfTest01',0, () => {
      let sortedIndexByArray: number = sortedIndexOf([4, 5, 5, 5, 6], 5);
      expect(sortedIndexByArray).assertEqual(1);
    })

    it('sortedIndexOfTest02',0, () => {
      let sortedIndexByArray: number = sortedIndexOf([1, 5, 7, 0, 9, 5, 6], 0);
      expect(sortedIndexByArray).assertEqual(-1);
    })

    it('sortedLastIndexTest01',0, () => {
      let sortedLastIndexArray: number = sortedLastIndex([4, 5, 5, 5, 6], 5);
      expect(sortedLastIndexArray).assertEqual(4);
    })

    it('sortedLastIndexTest02',0, () => {
      let sortedLastIndexArray: number = sortedLastIndex([4, 5, 9, 4, 20, ,34, 0, 11], 7);
      expect(sortedLastIndexArray).assertEqual(2);
    })

    it('sortedLastIndexByTest01',0, () => {
      let objects = [{ x: 4 }, { x: 5 }]as X[];
      let sortedLastIndexByArray: number = sortedLastIndexBy(objects, { 'x': 4 }, (o: X)=> { return o.x; });
      expect(sortedLastIndexByArray).assertEqual(1);
    })

    it('sortedLastIndexByTest02',0, () => {
      let objects = [{ x: 4 }, { x: 5 }]as X[];
      let sortedLastIndexByArray: number = sortedLastIndexBy(objects, { 'x': 4 }, 'x');
      expect(sortedLastIndexByArray).assertEqual(1);
    })

    it('sortedLastIndexOfTest01',0, () => {
      let sortedLastIndexOfArray: number = sortedLastIndexOf([4, 5, 5, 5, 6], 5);
      expect(sortedLastIndexOfArray).assertEqual(3);
    })

    it('sortedLastIndexOfTest02',0, () => {
      let sortedLastIndexOfArray: number = sortedLastIndexOf([4, 5, 5, 5, 6], 5);
      expect(sortedLastIndexOfArray).assertEqual(3);
    })

    it('sortedUniqTest01',0, () => {
      let sortedUniqArray: number[] = sortedUniq([1, 1, 2]);
      expect(JSON.stringify(sortedUniqArray)).assertEqual('[1,2]');
    })

    it('sortedUniqTest02',0, () => {
      let sortedUniqArray: number[] = sortedUniq([1, 1, 2, 3, 5, 6, 7, 10, 3, 5, 5]);
      expect(JSON.stringify(sortedUniqArray)).assertEqual('[1,2,3,5,6,7,10,3,5]');
    })

    it('sortedUniqByTest01',0, () => {
      let sortedUniqByArray: number[] = sortedUniqBy([1.1, 1.2, 2.3, 2.4], Math.floor);
      expect(JSON.stringify(sortedUniqByArray)).assertEqual('[1.1,2.3]');
    })

    it('sortedUniqByTest02',0, () => {
      let sortedUniqByArray: number[] = sortedUniqBy([0.1, 0.3, 1.1, 1.2, 2.3, 2.4, 7.1, 7.7], Math.floor);
      expect(JSON.stringify(sortedUniqByArray)).assertEqual('[0.1,1.1,2.3,7.1]');
    })

    it('tailTest01',0, () => {
      let tailArray: number[] = tail([1, 2, 3]);
      expect(JSON.stringify(tailArray)).assertEqual('[2,3]');
    })

    it('tailTest02',0, () => {
      let tailArray: Array<ESObject> = tail(['A', 'b', 3, 56, 5]);
      expect(JSON.stringify(tailArray)).assertEqual('["b",3,56,5]');
    })

    it('takeTest01',0, () => {
      let takeArray: number[] = take([1, 2, 3]);
      expect(JSON.stringify(takeArray)).assertEqual('[1]');
    })

    it('takeTest02',0, () => {
      let takeArray: number[] = take([1, 2, 3], 5);
      expect(JSON.stringify(takeArray)).assertEqual('[1,2,3]');
    })

    it('takeRightTest01',0, () => {
      let takeRightArray: number[] = takeRight([1, 2, 3]);
      expect(JSON.stringify(takeRightArray)).assertEqual('[3]');
    })

    it('takeRightTest02',0, () => {
      let takeRightArray: number[] = takeRight([1, 2, 3], 0);
      expect(JSON.stringify(takeRightArray)).assertEqual('[]');
    })

    it('takeRightWhileTest01',0, () => {
      let users: User[] = [
        { user: 'barney',  active: true },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: false }
      ];
      let takeRightWhileArray: object = takeRightWhile(users, (o: User)=> { return !o.active; });
      expect(JSON.stringify(takeRightWhileArray)).assertEqual('[{"user":"fred","active":false},{"user":"pebbles","active":false}]');
    })

    it('takeRightWhileTest02',0, () => {
      let users: User[] = [
        { user: 'barney',  active: true },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: false }
      ];
      let takeRightWhileArray: object = takeRightWhile(users, ['active', false]);
      expect(JSON.stringify(takeRightWhileArray)).assertEqual('[{"user":"fred","active":false},{"user":"pebbles","active":false}]');
    })

    it('takeWhileTest01',0, () => {
      let users: User[] = [
        { user: 'barney',  active: true },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: false }
      ];
      let takeWhileArray: number[] = takeWhile(users, { 'user': 'barney', 'active': false });
      expect(JSON.stringify(takeWhileArray)).assertEqual('[]');
    })

    it('takeWhileTest02',0, () => {
      let users: User[] = [
        { user: 'barney',  active: true },
        { user: 'fred',    active: false },
        { user: 'pebbles', active: false }
      ];
      let takeWhileArray: number[] = takeWhile(users, ['active', false]);
      expect(JSON.stringify(takeWhileArray)).assertEqual('[]');
    })

    it('unionTest01',0, () => {
      let unionArray: number[] = union([2], [1, 2]);
      expect(JSON.stringify(unionArray)).assertEqual('[2,1]');
    })

    it('unionTest02',0, () => {
      let unionArray: Array<ESObject> = union([2], [1, 2], ['a'], ['56']);
      expect(JSON.stringify(unionArray)).assertEqual('[2,1,"a","56"]');
    })

    it('unionWithTest01',0, () => {
      let objects = [{ x: 1, y: 2 }, { x: 2, y: 1 }]as XY[];
      let others = [{ x: 1, y: 1 }, { x: 1, y: 2 }]as XY[];
      let unionWithArray: object = unionWith(objects, others, isEqual);
      expect(JSON.stringify(unionWithArray)).assertEqual('[{"x":1,"y":2},{"x":2,"y":1},{"x":1,"y":1}]');
    })

    it('unionWithTest02',0, () => {
      let objects = [{ a: 12, b: 23 }as AB, { c: 2, d: 11 }as CD];
      let others = [{ x: 1, y: 1 }as XY, { a: 12, b: 23 }as AB];
      let unionWithArray: object = unionWith(objects, others, isEqual);
      expect(JSON.stringify(unionWithArray)).assertEqual('[{"a":12,"b":23},{"c":2,"d":11},{"x":1,"y":1}]');
    })

    it('uniqTest01',0, () => {
      let uniqArray: number = uniq([2, 1, 2]);
      expect(JSON.stringify(uniqArray)).assertEqual('[2,1]');
    })

    it('uniqTest02',0, () => {
      let uniqArray: Array<ESObject> = uniq([1,,3,3,2,4,5,6,76,6,3,2,22,1,2]);
      expect(JSON.stringify(uniqArray)).assertEqual('[1,null,3,2,4,5,6,76,22]');
    })

    it('unzipTest01',0, () => {
      let zipped: number[] = zip(['fred', 'barney'], [30, 40], [true, false]);
      let unzipArray: ESObject = unzip(zipped);
      expect(JSON.stringify(unzipArray)).assertEqual('[["fred","barney"],[30,40],[true,false]]');
    })

    it('unzipTest02',0, () => {
      let zipped: number[] = zip(['fred', 'world'], [2, 11], [null]);
      let unzipArray: number[] = unzip(zipped);
      expect(JSON.stringify(unzipArray)).assertEqual('[["fred","world"],[2,11],[null,null]]');
    })

    it('withoutTest01',0, () => {
      let withoutArray: number[] = without([2, 1, 2, 3], 1, 2);
      expect(JSON.stringify(withoutArray)).assertEqual('[3]');
    })

    it('withoutTest02',0, () => {
      let withoutArray: number[] = without([5, 7, 7, 9, 4, 1, 2, 3], 7, 3);
      expect(JSON.stringify(withoutArray)).assertEqual('[5,9,4,1,2]');
    })

    it("xorTest01", 0, () => {
      let xorArray: number[] = xor([2, 1], [2, 3]);
      expect(JSON.stringify(xorArray)).assertEqual('[1,3]');
    })

    it("xorTest02", 0, () => {
      let xorArray: number[] = xor([5, 3, 1, 6, 9], [1, 5, 2, 3, 7]);
      expect(JSON.stringify(xorArray)).assertEqual('[6,9,2,7]');
    })

    it("xorByTest01", 0, () => {
      let xorByArray: number[] = xorBy([2.1, 1.2], [2.3, 3.4], Math.floor);
      expect(JSON.stringify(xorByArray)).assertEqual('[1.2,3.4]');
    })

    it("xorByTest02", 0, () => {
      let xorByArray: object = xorBy([{ 'x': 1 }], [{ 'x': 2 }, { 'x': 1 }], 'x');
      expect(JSON.stringify(xorByArray)).assertEqual('[{"x":2}]');
    })

    it("xorWithTest01", 0, () => {
      let objects = [{ x: 1, y: 2 }, { x: 2, y: 1 }]as XY[];
      let others = [{ x: 1, y: 1 }, { x: 1, y: 2 }]as XY[];

      let xorWithArray: object = xorWith(objects, others, isEqual);
      expect(JSON.stringify(xorWithArray)).assertEqual('[{"x":2,"y":1},{"x":1,"y":1}]');
    })

    it("xorWithTest02", 0, () => {
      let objects = [{ a: 12, b: 23 }as AB, { c: 2, d: 11 }as CD];
      let others = [{ x: 1, y: 1 }as XY, { a: 12, b: 23 }as AB];

      let xorWithArray: object = xorWith(objects, others, isEqual);
      expect(JSON.stringify(xorWithArray)).assertEqual('[{"c":2,"d":11},{"x":1,"y":1}]');
    })

    it("zipObjectTest01", 0, () => {
      let zipObjectArray: object = zipObject(['a', 'b'], [1, 2]);
      expect(JSON.stringify(zipObjectArray)).assertEqual('{"a":1,"b":2}');
    })

    it("zipObjectTest02", 0, () => {
      let zipObjectArray: object = zipObject(['a', 'b', 'c', 'd'], [5,3,6,4]);
      expect(JSON.stringify(zipObjectArray)).assertEqual('{"a":5,"b":3,"c":6,"d":4}');
    })

    it("zipObjectDeepTest01", 0, () => {
      let zipObjectDeepArray: object = zipObjectDeep(['a.b[0].c', 'a.b[1].d'], [1, 2]);
      expect(JSON.stringify(zipObjectDeepArray)).assertEqual('{"a":{"b":[{"c":1},{"d":2}]}}');
    })

    it("zipObjectDeepTest02", 0, () => {
      let zipObjectDeepArray: object = zipObjectDeep(['a.b[0].c', 'a.b[1].d'], [7, 8]);
      expect(JSON.stringify(zipObjectDeepArray)).assertEqual('{"a":{"b":[{"c":7},{"d":8}]}}');
    })

    it("zipWithTest01", 0, () => {
      let zipWithArray: number[] = zipWith([1, 2], [10, 20], [100, 200], (a: number, b: number, c: number)=> {
        return a + b + c;
      });
      expect(JSON.stringify(zipWithArray)).assertEqual('[111,222]');
    })

    it("zipWithTest02", 0, () => {
      let zipWithArray: number[] = zipWith([4, 6], [65, 86], [324, 246], (a: number, b: number, c: number)=> {
        return a + b + c;
      });
      expect(JSON.stringify(zipWithArray)).assertEqual('[393,338]');
    })
  })
}