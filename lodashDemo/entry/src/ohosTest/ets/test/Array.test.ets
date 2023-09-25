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
  describe('ArrayTest', function () {
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
    it('chunkTest01',0, function () {
      let chunkArray = chunk(['a', 'b', 'c', 'd'], 2);
      expect(JSON.stringify(chunkArray)).assertEqual('[["a","b"],["c","d"]]')
    })

    it('chunkTest02',0, function () {
      let chunkArray = chunk(['a', 'b', 'c', 'd'], 3);
      expect(JSON.stringify(chunkArray)).assertEqual('[["a","b","c"],["d"]]')
    })

    it('compactTest01',0, function () {
      let compactArray = compact([0, 1, false, 2, '', 3]);
      expect(JSON.stringify(compactArray)).assertEqual('[1,2,3]')
    })

    it('compactTest02',0, function () {
      let compactArray = compact([0, 1, false, 2, '', null, NaN]);
      expect(JSON.stringify(compactArray)).assertEqual('[1,2]')
    })

    it('concatTest01',0, function () {
      let array = [1];
      let concatArray = concat(array, 2, [3], [[4]]);
      expect(JSON.stringify(concatArray)).assertEqual('[1,2,3,[4]]')
    })

    it('concatTest02',0, function () {
      let array = ['a'];
      let concatArray = concat(array, 'd', [3], [[4], [6]]);
      expect(JSON.stringify(concatArray)).assertEqual('["a","d",3,[4],[6]]')
    })

    it('differenceTest01',0, function () {
      let differenceArray = difference([3, 2, 1], [4, 2]);
      expect(JSON.stringify(differenceArray)).assertEqual('[3,1]')
    })

    it('differenceTest02',0, function () {
      let differenceArray = difference([3, 2, 1, 9, 3], [3, 2]);
      expect(JSON.stringify(differenceArray)).assertEqual('[1,9]')
    })

    it('differenceByTest01',0, function () {
      let differenceByArray = differenceBy([3.1, 2.2, 1.3], [4.4, 2.5], Math.floor);
      expect(JSON.stringify(differenceByArray)).assertEqual('[3.1,1.3]')
    })
    it('differenceByTest02',0, function () {
      let differenceByArray = differenceBy([{ 'x': 2 }, { 'x': 1 }], [{ 'x': 1 }], 'x');
      expect(JSON.stringify(differenceByArray)).assertEqual('[{"x":2}]')
    })

    it('differenceWithTest01',0, function () {
      let objects = [{ 'x': 1, 'y': 2 }, { 'x': 2, 'y': 1 }];
      let differenceWithArray = differenceWith(objects, [{ 'x': 1, 'y': 2 }], isEqual);
      expect(JSON.stringify(differenceWithArray)).assertEqual('[{"x":2,"y":1}]')
    })

    it('differenceWithTest02',0, function () {
      let objects = [{ 'x': 1, 'y': 2 }, { 'c': 2, 'd': 1 }, { 'a': 6, 'b': 7 }];
      let differenceWithArray = differenceWith(objects, [{ 'x': 1, 'y': 2 }], isEqual);
      expect(JSON.stringify(differenceWithArray)).assertEqual('[{"c":2,"d":1},{"a":6,"b":7}]')
    })

    it('dropTest01',0, function () {
      let dropArray = drop([1, 2, 3]);
      expect(JSON.stringify(dropArray)).assertEqual('[2,3]')
    })

    it('dropTest02',0, function () {
      let dropArray = drop([1, 2, 3], 5);
      expect(JSON.stringify(dropArray)).assertEqual('[]')
    })

    it('dropRightTest01',0, function () {
      let dropRightArray = drop([1, 2, 3]);
      expect(JSON.stringify(dropRightArray)).assertEqual('[2,3]')
    })

    it('dropRightTest02',0, function () {
      let dropRightArray = drop([0, 1, 2, 3, 9, 10], 2);
      expect(JSON.stringify(dropRightArray)).assertEqual('[2,3,9,10]')
    })

    it('dropRightWhileTest01',0, function () {
      let users = [
        { 'user': 'barney',  'active': true },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': false }
      ];
      let dropRightWhileArray = dropRightWhile(users, function(o) { return !o.active; });
      expect(JSON.stringify(dropRightWhileArray)).assertEqual('[{"user":"barney","active":true}]')
    })

    it('dropRightWhileTest02',0, function () {
      let users = [
        { 'user': 'barney',  'active': true },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': false }
      ];
      let dropRightWhileArray = dropRightWhile(users, { 'user': 'pebbles', 'active': false });
      expect(JSON.stringify(dropRightWhileArray)).assertEqual('[{"user":"barney","active":true},{"user":"fred","active":false}]')
    })

    it('dropWhileTest01',0, function () {
      let users = [
        { 'user': 'barney',  'active': false },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': true }
      ];
      let dropWhileArray = dropWhile(users, function(o) { return !o.active; });
      expect(JSON.stringify(dropWhileArray)).assertEqual('[{"user":"pebbles","active":true}]')
    })

    it('dropWhileTest02',0, function () {
      let users = [
        { 'user': 'barney',  'active': false },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': true }
      ];
      let dropWhileArray = dropWhile(users, 'active');
      expect(JSON.stringify(dropWhileArray)).assertEqual('[{"user":"barney","active":false},{"user":"fred","active":false},{"user":"pebbles","active":true}]')
    })

    it('fillTest01',0, function () {
      let array = [1, 2, 3];
      let fillArray = fill(array, 'a');
      expect(JSON.stringify(fillArray)).assertEqual('["a","a","a"]')
    })

    it('fillTest02',0, function () {
      let fillArray = fill([4, 6, 8, 10], '*', 1, 3);
      expect(JSON.stringify(fillArray)).assertEqual('[4,"*","*",10]')
    })

    it('findIndexTest01',0, function () {
      let users = [
        { 'user': 'barney',  'active': false },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': true }
      ];
      let findIndexArray = findIndex(users, function(o) { return o.user == 'barney'; });
      expect(JSON.stringify(findIndexArray)).assertEqual('0')
    })

    it('findIndexTest02',0, function () {
      let users = [
        { 'user': 'barney',  'active': false },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': true }
      ];
      let findIndexArray = findIndex(users, 'active');
      expect(JSON.stringify(findIndexArray)).assertEqual('2')
    })

    it('findLastIndexTest01',0, function () {
      let users = [
        { 'user': 'barney',  'active': true },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': false }
      ];
      let findLastIndexArray = findLastIndex(users, function(o) { return o.user == 'pebbles'; });
      expect(JSON.stringify(findLastIndexArray)).assertEqual('2')
    })

    it('findLastIndexTest02',0, function () {
      let users = [
        { 'user': 'barney',  'active': true },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': false }
      ];
      let findLastIndexArray = findLastIndex(users, { 'user': 'barney', 'active': true });
      expect(JSON.stringify(findLastIndexArray)).assertEqual('0')
    })

    it('headTest01',0, function () {
      let headArray = head([1, 2, 3]);
      expect(headArray).assertEqual(1);
    })

    it('headTest02',0, function () {
      let headArray = head([]);
      expect(JSON.stringify(headArray)).assertUndefined();
    })

    it('indexOfTest01',0, function () {
      let indexOfArray = indexOf([1, 2, 1, 2], 2);
      expect(indexOfArray).assertEqual(1);
    })

    it('indexOfTest02',0, function () {
      let indexOfArray = indexOf([1, 2, 1, 2], 2, 2);
      expect(indexOfArray).assertEqual(3);
    })

    it('initialTest01',0, function () {
      let initialArray = initial([1, 2, 3]);
      expect(JSON.stringify(initialArray)).assertEqual('[1,2]');
    })

    it('initialTest02',0, function () {
      let initialArray = initial(['a', 'b', 1, 2, 3, 's']);
      expect(JSON.stringify(initialArray)).assertEqual('["a","b",1,2,3]');
    })

    it('intersectionTest01',0, function () {
      let intersectionArray = intersection([2, 1], [4, 2], [1, 2]);
      expect(JSON.stringify(intersectionArray)).assertEqual('[2]');
    })

    it('intersectionTest02',0, function () {
      let intersectionArray = intersection(['a', 1], ['a', 2], [1, 'a']);
      expect(JSON.stringify(intersectionArray)).assertEqual('["a"]');
    })

    it('intersectionByTest01',0, function () {
      let intersectionByArray = intersectionBy([2.1, 1.2], [4.3, 2.4], Math.floor);
      expect(JSON.stringify(intersectionByArray)).assertEqual('[2.1]');
    })

    it('intersectionByTest02',0, function () {
      let intersectionByArray = intersectionBy([{ 'x': 1 }], [{ 'x': 2 }, { 'x': 1 }], 'x');
      expect(JSON.stringify(intersectionByArray)).assertEqual('[{"x":1}]');
    })

    it('intersectionWithTest01',0, function () {
      let objects = [{ 'x': 1, 'y': 2 }, { 'x': 2, 'y': 1 }];
      let others = [{ 'x': 1, 'y': 1 }, { 'x': 1, 'y': 2 }];
      let intersectionWithArray = intersectionWith(objects, others, isEqual);
      expect(JSON.stringify(intersectionWithArray)).assertEqual('[{"x":1,"y":2}]');
    })

    it('intersectionWithTest02',0, function () {
      let objects = [{ 'x': 1, 'y': 2 }, { 'x': 2, 'y': 1 }, { 'a': 5, 'b': 6 }];
      let others = [{ 'x': 1, 'y': 1 }, { 'x': 1, 'y': 2 }, { 'a': 5, 'b': 6 }];
      let intersectionWithArray = intersectionWith(objects, others, isEqual);
      expect(JSON.stringify(intersectionWithArray)).assertEqual('[{"x":1,"y":2},{"a":5,"b":6}]');
    })

    it('joinTest01',0, function () {
      let joinArray = join(['a', 'b', 'c'], '~');
      expect(joinArray).assertEqual('a~b~c');
    })

    it('joinTest02',0, function () {
      let joinArray = join(['hello', 'world', 'join'], '#~#');
      expect(joinArray).assertEqual('hello#~#world#~#join');
    })

    it('lastTest01',0, function () {
      let lastArray = last([1, 2, 3]);
      expect(lastArray).assertEqual(3);
    })

    it('lastTest02',0, function () {
      let lastArray = last(['a', 'b', 1, 7, 'c']);
      expect(lastArray).assertEqual('c');
    })

    it('lastIndexOfTest01',0, function () {
      let lastIndexOfArray = lastIndexOf([1, 2, 1, 2], 2);
      expect(lastIndexOfArray).assertEqual(3);
    })

    it('lastIndexOfTest02',0, function () {
      let lastIndexOfArray = lastIndexOf([1, 2, 1, 2], 2, 2);
      expect(lastIndexOfArray).assertEqual(1);
    })

    it('nthTest01',0, function () {
      let array = ['a', 'b', 'c', 'd'];
      let nthArray = nth(array, 1);
      expect(nthArray).assertEqual('b');
    })

    it('nthTest02',0, function () {
      let array = ['a', 'b', 'c', 'd'];
      let nthArray = nth(array, -2);
      expect(nthArray).assertEqual('c');
    })

    it('pullTest01',0, function () {
      let array = [1, 2, 3, 1, 2, 3];
      let pullArray = pull(array, 2, 3);
      expect(JSON.stringify(pullArray)).assertEqual('[1,1]');
    })

    it('pullTest02',0, function () {
      let array = ['a', 'b',  3, 1, 2, 3, 'c'];
      let pullArray = pull(array, 'a', 3);
      expect(JSON.stringify(pullArray)).assertEqual('["b",1,2,"c"]');
    })

    it('pullAllTest01',0, function () {
      let array = ['a', 'b',  3, 1, 2, 3, 'c'];
      let pullAllArray = pullAll(array, ['a', 3]);
      expect(JSON.stringify(pullAllArray)).assertEqual('["b",1,2,"c"]');
    })

    it('pullAllTest02',0, function () {
      let array = [1, 2, 3, 1, 2, 3];
      let pullAllArray = pullAll(array, [2, 3]);
      expect(JSON.stringify(pullAllArray)).assertEqual('[1,1]');
    })

    it('pullAllByTest01',0, function () {
      let array = [{ 'x': 1 }, { 'x': 2 }, { 'x': 3 }, { 'x': 1 }];
      let pullAllByArray = pullAllBy(array, [{ 'x': 1 }, { 'x': 3 }], 'x');
      expect(JSON.stringify(pullAllByArray)).assertEqual('[{"x":2}]');
    })

    it('pullAllByTest02',0, function () {
      let array = [{ 'x': 1 }, { 'x': 2 }, { 'y': 3 }, { 'b': 1 }, {'c': 5}];
      let pullAllByArray = pullAllBy(array, [{ 'x': 1 }, { 'c': 5 }], 'y');
      expect(JSON.stringify(pullAllByArray)).assertEqual('[{"y":3}]');
    })

    it('pullAllWithTest01',0, function () {
      let array = [{ 'x': 1, 'y': 2 }, { 'x': 3, 'y': 4 }, { 'x': 5, 'y': 6 }];
      let pullAllWithArray = pullAllWith(array, [{ 'x': 3, 'y': 4 }], isEqual);
      expect(JSON.stringify(pullAllWithArray)).assertEqual('[{"x":1,"y":2},{"x":5,"y":6}]');
    })

    it('pullAllWithTest02',0, function () {
      let array = [{ 'x': 1, 'y': 2 }, { 'a': 7, 'b': 7 }, { 'x': 5, 'y': 6 }, { 'c': 9, 'd': 0 }];
      let pullAllWithArray = pullAllWith(array, [{ 'x': 1, 'y': 2 },{ 'x': 5, 'y': 6 }], isEqual);
      expect(JSON.stringify(pullAllWithArray)).assertEqual('[{"a":7,"b":7},{"c":9,"d":0}]');
    })

    it('pullAtTest01',0, function () {
      let array = [5, 10, 15, 20];
      let evens = pullAt(array, 1, 3);
      expect(JSON.stringify(evens)).assertEqual('[10,20]');
    })

    it('pullAtTest02',0, function () {
      let array = [12, 34, 'a', 'b', 'c', 20];
      let evens = pullAt(array, 2, 4);
      expect(JSON.stringify(evens)).assertEqual('["a","c"]');
    })

    it('removeTest01',0, function () {
      let array = [1, 2, 3, 4];
      let evens = remove(array, function(n) {
        return n % 2 == 0;
      });
      expect(JSON.stringify(evens)).assertEqual('[2,4]');
    })

    it('removeTest02',0, function () {
      let array = [8, 3, 4, 6, 9, 12, 14, 24];
      let evens = remove(array, function(n) {
        return n % 2 == 0;
      });
      expect(JSON.stringify(evens)).assertEqual('[8,4,6,12,14,24]');
    })

    it('reverseTest01',0, function () {
      let array = [1, 2, 3];
      let reverseArray = reverse(array);
      expect(JSON.stringify(reverseArray)).assertEqual('[3,2,1]');
    })

    it('reverseTest02',0, function () {
      let array = ['a', 'b', 'c'];
      let reverseArray = reverse(array);
      expect(JSON.stringify(reverseArray)).assertEqual('["c","b","a"]');
    })

    it('sliceTest01',0, function () {
      let array = [[1, 12], [12, 8], 7, 8]
      let sliceArray = slice(array, 1, 3);
      expect(JSON.stringify(sliceArray)).assertEqual('[[12,8],7]');
    })

    it('sliceTest02',0, function () {
      let array = [[1, 12], [12, 8], 'a', 'as', 'b', 'g']
      let sliceArray = slice(array, 2, 5);
      expect(JSON.stringify(sliceArray)).assertEqual('["a","as","b"]');
    })

    it('sortedIndexTest01',0, function () {
      let sortedIndexArray = sortedIndex([30, 50], 40);
      expect(sortedIndexArray).assertEqual(1);
    })

    it('sortedIndexTest02',0, function () {
      let sortedIndexArray = sortedIndex([30, 35, 50, 70, 100,190], 110);
      expect(sortedIndexArray).assertEqual(5);
    })

    it('sortedIndexByTest01',0, function () {
      let objects = [{ 'x': 4 }, { 'x': 5 }];
      let sortedIndexByArray = sortedIndexBy(objects, { 'x': 4 }, function(o) { return o.x; });
      expect(sortedIndexByArray).assertEqual(0);
    })

    it('sortedIndexByTest02',0, function () {
      let objects = [{ 'x': 4 }, { 'x': 5 }];
      let sortedIndexByArray = sortedIndexBy(objects, { 'x': 4 }, 'x');
      expect(sortedIndexByArray).assertEqual(0);
    })

    it('sortedIndexOfTest01',0, function () {
      let sortedIndexByArray = sortedIndexOf([4, 5, 5, 5, 6], 5);
      expect(sortedIndexByArray).assertEqual(1);
    })

    it('sortedIndexOfTest02',0, function () {
      let sortedIndexByArray = sortedIndexOf([1, 5, 7, 0, 9, 5, 6], 0);
      expect(sortedIndexByArray).assertEqual(-1);
    })

    it('sortedLastIndexTest01',0, function () {
      let sortedLastIndexArray = sortedLastIndex([4, 5, 5, 5, 6], 5);
      expect(sortedLastIndexArray).assertEqual(4);
    })

    it('sortedLastIndexTest02',0, function () {
      let sortedLastIndexArray = sortedLastIndex([4, 5, 9, 4, 20, ,34, 0, 11], 7);
      expect(sortedLastIndexArray).assertEqual(2);
    })

    it('sortedLastIndexByTest01',0, function () {
      let objects = [{ 'x': 4 }, { 'x': 5 }];
      let sortedLastIndexByArray = sortedLastIndexBy(objects, { 'x': 4 }, function(o) { return o.x; });
      expect(sortedLastIndexByArray).assertEqual(1);
    })

    it('sortedLastIndexByTest02',0, function () {
      let objects = [{ 'x': 4 }, { 'x': 5 }];
      let sortedLastIndexByArray = sortedLastIndexBy(objects, { 'x': 4 }, 'x');
      expect(sortedLastIndexByArray).assertEqual(1);
    })

    it('sortedLastIndexOfTest01',0, function () {
      let sortedLastIndexOfArray = sortedLastIndexOf([4, 5, 5, 5, 6], 5);
      expect(sortedLastIndexOfArray).assertEqual(3);
    })

    it('sortedLastIndexOfTest02',0, function () {
      let sortedLastIndexOfArray = sortedLastIndexOf([4, 5, 5, 5, 6], 5);
      expect(sortedLastIndexOfArray).assertEqual(3);
    })

    it('sortedUniqTest01',0, function () {
      let sortedUniqArray = sortedUniq([1, 1, 2]);
      expect(JSON.stringify(sortedUniqArray)).assertEqual('[1,2]');
    })

    it('sortedUniqTest02',0, function () {
      let sortedUniqArray = sortedUniq([1, 1, 2, 3, 5, 6, 7, 10, 3, 5, 5]);
      expect(JSON.stringify(sortedUniqArray)).assertEqual('[1,2,3,5,6,7,10,3,5]');
    })

    it('sortedUniqByTest01',0, function () {
      let sortedUniqByArray = sortedUniqBy([1.1, 1.2, 2.3, 2.4], Math.floor);
      expect(JSON.stringify(sortedUniqByArray)).assertEqual('[1.1,2.3]');
    })

    it('sortedUniqByTest02',0, function () {
      let sortedUniqByArray = sortedUniqBy([0.1, 0.3, 1.1, 1.2, 2.3, 2.4, 7.1, 7.7], Math.floor);
      expect(JSON.stringify(sortedUniqByArray)).assertEqual('[0.1,1.1,2.3,7.1]');
    })

    it('tailTest01',0, function () {
      let tailArray = tail([1, 2, 3]);
      expect(JSON.stringify(tailArray)).assertEqual('[2,3]');
    })

    it('tailTest02',0, function () {
      let tailArray = tail(['A', 'b', 3, 56, 5]);
      expect(JSON.stringify(tailArray)).assertEqual('["b",3,56,5]');
    })

    it('takeTest01',0, function () {
      let takeArray = take([1, 2, 3]);
      expect(JSON.stringify(takeArray)).assertEqual('[1]');
    })

    it('takeTest02',0, function () {
      let takeArray = take([1, 2, 3], 5);
      expect(JSON.stringify(takeArray)).assertEqual('[1,2,3]');
    })

    it('takeRightTest01',0, function () {
      let takeRightArray = takeRight([1, 2, 3]);
      expect(JSON.stringify(takeRightArray)).assertEqual('[3]');
    })

    it('takeRightTest02',0, function () {
      let takeRightArray = takeRight([1, 2, 3], 0);
      expect(JSON.stringify(takeRightArray)).assertEqual('[]');
    })

    it('takeRightWhileTest01',0, function () {
      let users = [
        { 'user': 'barney',  'active': true },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': false }
      ];
      let takeRightWhileArray = takeRightWhile(users, function(o) { return !o.active; });
      expect(JSON.stringify(takeRightWhileArray)).assertEqual('[{"user":"fred","active":false},{"user":"pebbles","active":false}]');
    })

    it('takeRightWhileTest02',0, function () {
      let users = [
        { 'user': 'barney',  'active': true },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': false }
      ];
      let takeRightWhileArray = takeRightWhile(users, ['active', false]);
      expect(JSON.stringify(takeRightWhileArray)).assertEqual('[{"user":"fred","active":false},{"user":"pebbles","active":false}]');
    })

    it('takeWhileTest01',0, function () {
      let users = [
        { 'user': 'barney',  'active': true },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': false }
      ];
      let takeWhileArray = takeWhile(users, { 'user': 'barney', 'active': false });
      expect(JSON.stringify(takeWhileArray)).assertEqual('[]');
    })

    it('takeWhileTest02',0, function () {
      let users = [
        { 'user': 'barney',  'active': true },
        { 'user': 'fred',    'active': false },
        { 'user': 'pebbles', 'active': false }
      ];
      let takeWhileArray = takeWhile(users, ['active', false]);
      expect(JSON.stringify(takeWhileArray)).assertEqual('[]');
    })

    it('unionTest01',0, function () {
      let unionArray = union([2], [1, 2]);
      expect(JSON.stringify(unionArray)).assertEqual('[2,1]');
    })

    it('unionTest02',0, function () {
      let unionArray = union([2], [1, 2], ['a'], ['56']);
      expect(JSON.stringify(unionArray)).assertEqual('[2,1,"a","56"]');
    })

    it('unionWithTest01',0, function () {
      let objects = [{ 'x': 1, 'y': 2 }, { 'x': 2, 'y': 1 }];
      let others = [{ 'x': 1, 'y': 1 }, { 'x': 1, 'y': 2 }];
      let unionWithArray = unionWith(objects, others, isEqual);
      expect(JSON.stringify(unionWithArray)).assertEqual('[{"x":1,"y":2},{"x":2,"y":1},{"x":1,"y":1}]');
    })

    it('unionWithTest02',0, function () {
      let objects = [{ 'a': 12, 'b': 23 }, { 'c': 2, 'd': 11 }];
      let others = [{ 'x': 1, 'y': 1 }, { 'a': 12, 'b': 23 }];
      let unionWithArray = unionWith(objects, others, isEqual);
      expect(JSON.stringify(unionWithArray)).assertEqual('[{"a":12,"b":23},{"c":2,"d":11},{"x":1,"y":1}]');
    })

    it('uniqTest01',0, function () {
      let uniqArray = uniq([2, 1, 2]);
      expect(JSON.stringify(uniqArray)).assertEqual('[2,1]');
    })

    it('uniqTest02',0, function () {
      let uniqArray = uniq([1,,3,3,2,4,5,6,76,6,3,2,22,1,2]);
      expect(JSON.stringify(uniqArray)).assertEqual('[1,null,3,2,4,5,6,76,22]');
    })

    it('unzipTest01',0, function () {
      let zipped = zip(['fred', 'barney'], [30, 40], [true, false]);
      let unzipArray = unzip(zipped);
      expect(JSON.stringify(unzipArray)).assertEqual('[["fred","barney"],[30,40],[true,false]]');
    })

    it('unzipTest02',0, function () {
      let zipped = zip(['fred', 'world'], [2, 11], [null]);
      let unzipArray = unzip(zipped);
      expect(JSON.stringify(unzipArray)).assertEqual('[["fred","world"],[2,11],[null,null]]');
    })

    it('withoutTest01',0, function () {
      let withoutArray = without([2, 1, 2, 3], 1, 2);
      expect(JSON.stringify(withoutArray)).assertEqual('[3]');
    })

    it('withoutTest02',0, function () {
      let withoutArray = without([5, 7, 7, 9, 4, 1, 2, 3], 7, 3);
      expect(JSON.stringify(withoutArray)).assertEqual('[5,9,4,1,2]');
    })

    it("xorTest01", 0, function () {
      let xorArray = xor([2, 1], [2, 3]);
      expect(JSON.stringify(xorArray)).assertEqual('[1,3]');
    })

    it("xorTest02", 0, function () {
      let xorArray = xor([5, 3, 1, 6, 9], [1, 5, 2, 3, 7]);
      expect(JSON.stringify(xorArray)).assertEqual('[6,9,2,7]');
    })

    it("xorByTest01", 0, function () {
      let xorByArray = xorBy([2.1, 1.2], [2.3, 3.4], Math.floor);
      expect(JSON.stringify(xorByArray)).assertEqual('[1.2,3.4]');
    })

    it("xorByTest02", 0, function () {
      let xorByArray = xorBy([{ 'x': 1 }], [{ 'x': 2 }, { 'x': 1 }], 'x');
      expect(JSON.stringify(xorByArray)).assertEqual('[{"x":2}]');
    })

    it("xorWithTest01", 0, function () {
      let objects = [{ 'x': 1, 'y': 2 }, { 'x': 2, 'y': 1 }];
      let others = [{ 'x': 1, 'y': 1 }, { 'x': 1, 'y': 2 }];

      let xorWithArray = xorWith(objects, others, isEqual);
      expect(JSON.stringify(xorWithArray)).assertEqual('[{"x":2,"y":1},{"x":1,"y":1}]');
    })

    it("xorWithTest02", 0, function () {
      let objects = [{ 'a': 12, 'b': 23 }, { 'c': 2, 'd': 11 }];
      let others = [{ 'x': 1, 'y': 1 }, { 'a': 12, 'b': 23 }];

      let xorWithArray = xorWith(objects, others, isEqual);
      expect(JSON.stringify(xorWithArray)).assertEqual('[{"c":2,"d":11},{"x":1,"y":1}]');
    })

    it("zipObjectTest01", 0, function () {
      let zipObjectArray = zipObject(['a', 'b'], [1, 2]);
      expect(JSON.stringify(zipObjectArray)).assertEqual('{"a":1,"b":2}');
    })

    it("zipObjectTest02", 0, function () {
      let zipObjectArray = zipObject(['a', 'b', 'c', 'd'], [5,3,6,4]);
      expect(JSON.stringify(zipObjectArray)).assertEqual('{"a":5,"b":3,"c":6,"d":4}');
    })

    it("zipObjectDeepTest01", 0, function () {
      let zipObjectDeepArray = zipObjectDeep(['a.b[0].c', 'a.b[1].d'], [1, 2]);
      expect(JSON.stringify(zipObjectDeepArray)).assertEqual('{"a":{"b":[{"c":1},{"d":2}]}}');
    })

    it("zipObjectDeepTest02", 0, function () {
      let zipObjectDeepArray = zipObjectDeep(['a.b[0].c', 'a.b[1].d'], [7, 8]);
      expect(JSON.stringify(zipObjectDeepArray)).assertEqual('{"a":{"b":[{"c":7},{"d":8}]}}');
    })

    it("zipWithTest01", 0, function () {
      let zipWithArray = zipWith([1, 2], [10, 20], [100, 200], function(a, b, c) {
        return a + b + c;
      });
      expect(JSON.stringify(zipWithArray)).assertEqual('[111,222]');
    })

    it("zipWithTest02", 0, function () {
      let zipWithArray = zipWith([4, 6], [65, 86], [324, 246], function(a, b, c) {
        return a + b + c;
      });
      expect(JSON.stringify(zipWithArray)).assertEqual('[393,338]');
    })
  })
}