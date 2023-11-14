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
import { countBy, every, filter, find, findLast, flatMap, flatMapDeep, flatMapDepth, groupBy, includes,
  invokeMap,
  keyBy,
  map,
  orderBy,
  partition,
  reduce,
  reduceRight,
  reject,
  size,
  some,
  sortBy
} from 'lodash';

export default function collectionTest() {
  describe('CollectionTestTest', () => {
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
    class User{
      user: string = ''
      active: boolean = true
      age: number = 0
    }

    class Active{
      user: string = ''
      active: boolean = true
    }

    class Users{
      user: string = ''
    }

    class Age{
      user: string = ''
      age: number = 0
    }

    class Array{
      dir: string = ''
      code: number = 0
    }

    class Emp{
      employee: string = ''
      salary: number = 0
    }
    it('countByTest01',0, () => {
      let countByObject: object = countBy([6.1, 4.2, 6.3], Math.floor);
      expect(JSON.stringify(countByObject)).assertEqual('{"4":1,"6":2}')
    })

    it('countByTest02',0, () => {
      let countByObject: object = countBy(['one', 'two', 'three'], 'length');
      expect(JSON.stringify(countByObject)).assertEqual('{"3":2,"5":1}')
    })

    it('everyTest01',0, () => {
      let everyObject: boolean = every([true, 1, null, 'yes'], Boolean);
      expect(everyObject).assertFalse()
    })

    it('everyTest02',0, () => {
      let users: User[] = [
        { user: 'barney', age: 36, active: false },
        { user: 'fred',   age: 40, active: false }
      ];
      let everyObject: boolean = every(users, ['active', false]);
      expect(everyObject).assertTrue()
    })

    it('filterTest01',0, () => {
      let users: User[] = [
        { user: 'barney', age: 36, active: true },
        { user: 'fred',   age: 40, active: false }
      ];
      let filterObject: object = filter(users, (o: User)=> { return !o.active; });
      expect(JSON.stringify(filterObject)).assertEqual('[{"user":"fred","age":40,"active":false}]')
    })

    it('filterTest02',0, () => {
      let users: User[] = [
        { user: 'barney', age: 36, active: true },
        { user: 'fred',   age: 40, active: false }
      ];
      let filterObject: object = filter(users, { 'age': 36, 'active': true });
      expect(JSON.stringify(filterObject)).assertEqual('[{"user":"barney","age":36,"active":true}]')
    })

    it('findTest01',0, () => {
      let users: User[] = [
        { user: 'barney',  age: 36, active: true },
        { user: 'fred',    age: 40, active: false },
        { user: 'pebbles', age: 1,  active: true }
      ];
      let findObject: object = find(users, (o: User)=> { return o.age < 40; });
      expect(JSON.stringify(findObject)).assertEqual('{"user":"barney","age":36,"active":true}')
    })

    it('findTest02',0, () => {
      let users: User[] = [
        { user: 'barney',  age: 36, active: true },
        { user: 'fred',    age: 40, active: false },
        { user: 'pebbles', age: 1,  active: true }
      ];
      let findObject: object = find(users, ['active', false]);
      expect(JSON.stringify(findObject)).assertEqual('{"user":"fred","age":40,"active":false}')
    })

    it('findLastTest01',0, () => {
      let findLastObject: number = findLast([1, 2, 3, 4], (n: number)=> {
        return n % 2 == 1;
      });
      expect(findLastObject).assertEqual(3)
    })

    it('findLastTest02',0, () => {
      let findLastObject: number = findLast([6, 5, 6, 8, 4, 88, 23, 25, 48], (n: number)=> {
        return n % 2 == 0;
      });
      expect(findLastObject).assertEqual(48)
    })

    it('flatMapTest01',0, () => {
      let duplicate: (n: number) => void = (n: number): number[] => {
        return [n, n];
      }
      let flatMapObject: number[] = flatMap([1, 2], duplicate);
      expect(JSON.stringify(flatMapObject)).assertEqual('[1,1,2,2]')
    })

    it('flatMapTest02',0, () => {
      let duplicate: (n: number) => void = (n: number): number[] => {
        return [n, n];
      }
      let flatMapObject: number[] = flatMap([43, 62], duplicate);
      expect(JSON.stringify(flatMapObject)).assertEqual('[43,43,62,62]')
    })

    it('flatMapDeepTest01',0, () => {
      let duplicate: (n: number) => void = (n: number): [[number, number]][] => {
        return [[[n, n]]];
      }
      let flatMapDeepObject: number[] = flatMapDeep([1, 2], duplicate);
      expect(JSON.stringify(flatMapDeepObject)).assertEqual('[1,1,2,2]')
    })

    it('flatMapDeepTest02',0, () => {
      let duplicate: (n: number) => void = (n: number): [[number, number]][] => {
        return [[[n, n]]];
      }
      let flatMapDeepObject: number[] = flatMapDeep([87, 72], duplicate);
      expect(JSON.stringify(flatMapDeepObject)).assertEqual('[87,87,72,72]')
    })

    it('flatMapDepthTest01',0, () => {
      let duplicate: (n: number) => void = (n: number): [[number, number]][] => {
        return [[[n, n]]];
      }
      let flatMapDepthObject: number[] = flatMapDepth([1, 2], duplicate, 2);
      expect(JSON.stringify(flatMapDepthObject)).assertEqual('[[1,1],[2,2]]')
    })

    it('flatMapDepthTest02',0, () => {
      let duplicate: (n: number) => void = (n: number): [[number, number]][] => {
        return [[[n, n]]];
      }
      let flatMapDepthObject: number[] = flatMapDepth([23, 8], duplicate, 3);
      expect(JSON.stringify(flatMapDepthObject)).assertEqual('[23,23,8,8]')
    })

    it('groupByTest01',0, () => {
      let groupByObject: object = groupBy([6.1, 4.2, 6.3], Math.floor);
      expect(JSON.stringify(groupByObject)).assertEqual('{"4":[4.2],"6":[6.1,6.3]}')
    })

    it('groupByTest02',0, () => {
      let groupByObject: object = groupBy(['one', 'two', 'three'], 'length');
      expect(JSON.stringify(groupByObject)).assertEqual('{"3":["one","two"],"5":["three"]}')
    })

    it('includesTest01',0, () => {
      let includesObject: boolean = includes([1, 2, 3], 1);
      expect(includesObject).assertTrue();
    })

    it('includesTest02',0, () => {
      let includesObject: boolean = includes([1, 2, 3], 1, 2);
      expect(includesObject).assertFalse();
    })

    it('invokeMapTest01',0, () => {
      let invokeMapObject: number[][] = invokeMap([123, 456], '');
      expect(JSON.stringify(invokeMapObject)).assertEqual('[null,null]');
    })

    it('invokeMapTest02',0, () => {
      let invokeMapObject: number[][] = invokeMap([[5, 1, 7], [3, 2, 1]], 'sort');
      expect(JSON.stringify(invokeMapObject)).assertEqual('[[1,5,7],[1,2,3]]');
    })

    it('keyByTest01',0, () => {
      let array: Array[] = [
        { dir: 'left', code: 97 },
        { dir: 'right', code: 100 }
      ];
      let keyByObject: object = keyBy(array, (o: Array)=> {
        return String.fromCharCode(o.code);
      });
      expect(JSON.stringify(keyByObject)).assertEqual('{"a":{"dir":"left","code":97},"d":{"dir":"right","code":100}}');
    })

    it('keyByTest02',0, () => {
      let array: Array[] = [
        { dir: 'left', code: 97 },
        { dir: 'right', code: 100 }
      ];
      let keyByObject: object = keyBy(array, 'dir');
      expect(JSON.stringify(keyByObject)).assertEqual('{"left":{"dir":"left","code":97},"right":{"dir":"right","code":100}}');
    })

    it('mapTest01',0, () => {
      let square: (n: number) => void = (n: number): number => {
        return n * n;
      }
      let mapObject: number[] = map([4, 8], square);
      expect(JSON.stringify(mapObject)).assertEqual('[16,64]');
    })

    it('mapTest02',0, () => {
      let users: Users[] = [
        { user: 'barney' },
        { user: 'fred' }
      ];
      let mapObject: string[] = map(users, 'user');
      expect(JSON.stringify(mapObject)).assertEqual('["barney","fred"]');
    })

    it('orderByTest01',0, () => {
      let users: Age[] = [
        { user: 'fred', age: 48 },
        { user: 'barney', age: 34 },
        { user: 'fred', age: 40 },
        { user: 'barney', age: 36 }
      ];
      let orderByObject: object = orderBy(users, ['user', 'age'], ['asc', 'desc']);
      expect(JSON.stringify(orderByObject)).assertEqual('[{"user":"barney","age":36},{"user":"barney","age":34},{"user":"fred","age":48},{"user":"fred","age":40}]');
    })

    it('orderByTest02',0, () => {
      let users: Emp[] = [
        { employee:'hunny', salary:60000 },
        { employee:'munny', salary:40000 },
        { employee:'hunny', salary:55000 },
        { employee:'munny', salary:36000 }
      ];
      let orderByObject: object = orderBy(users, ['employee',
        'salary'], ['asc', 'desc']);
      expect(JSON.stringify(orderByObject)).assertEqual('[{"employee":"hunny","salary":60000},{"employee":"hunny","salary":55000},{"employee":"munny","salary":40000},{"employee":"munny","salary":36000}]');
    })

    it('partitionTest01',0, () => {
      let users: User[] = [
        { user: 'barney', age: 36, active: false },
        { user: 'fred', age: 40, active: true },
        { user: 'pebbles', age: 1,  active: false }
      ];
      let partitionObject: object = partition(users, (o: User)=> { return o.active; });
      expect(JSON.stringify(partitionObject)).assertEqual('[[{"user":"fred","age":40,"active":true}],[{"user":"barney","age":36,"active":false},{"user":"pebbles","age":1,"active":false}]]');
    })

    it('partitionTest02',0, () => {
      let users: User[] = [
        { user: 'barney', age: 36, active: false },
        { user: 'fred', age: 40, active: true },
        { user: 'pebbles', age: 1, active: false }
      ];
      let partitionObject: object = partition(users, ['active', false]);
      expect(JSON.stringify(partitionObject)).assertEqual('[[{"user":"barney","age":36,"active":false},{"user":"pebbles","age":1,"active":false}],[{"user":"fred","age":40,"active":true}]]');
    })

    it('reduceTest01',0, () => {
      let reduceObject: number = reduce([1, 2], (sum: number, n: number)=> {
        return sum + n;
      }, 0);
      expect(reduceObject).assertEqual(3);
    })

    it('reduceTest02',0, () => {
      let reduceObject: object = reduce({ 'a': 1, 'b': 2, 'c': 1 }, (result: object, value: string, key: number)=> {
        (result[value] || (result[value] = [])).push(key);
        return result;
      }, {});
      expect(JSON.stringify(reduceObject)).assertEqual('{"1":["a","c"],"2":["b"]}');
    })

    it('reduceRightTest01',0, () => {
      let array = [[0, 1], [2, 3], [4, 5]];
      let reduceRightObject: number[][] = reduceRight(array, (flattened: number[], other: number[])=> {
        return flattened.concat(other);
      }, []);
      expect(JSON.stringify(reduceRightObject)).assertEqual('[4,5,2,3,0,1]');
    })

    it('reduceRightTest02',0, () => {
      let array = [[54,45,1], [12, 33, 8], [4, 35, 7]];
      let reduceRightObject: number[] = reduceRight(array, (flattened: number[], other: number[])=> {
        return flattened.concat(other);
      }, []);
      expect(JSON.stringify(reduceRightObject)).assertEqual('[4,35,7,12,33,8,54,45,1]');
    })

    it('rejectTest01',0, () => {
      let users: User[] = [
        { user: 'barney', age: 36, active: false },
        { user: 'fred', age: 40, active: true }
      ];
      let rejectObject: object = reject(users, (o: User)=> { return !o.active; });
      expect(JSON.stringify(rejectObject)).assertEqual('[{"user":"fred","age":40,"active":true}]');
    })

    it('rejectTest02',0, () => {
      let users: User[] = [
        { user: 'barney', age: 36, active: false },
        { user: 'fred',   age: 40, active: true }
      ];
      let rejectObject: object = reject(users, 'active');
      expect(JSON.stringify(rejectObject)).assertEqual('[{"user":"barney","age":36,"active":false}]');
    })

    it('sizeTest01',0, () => {
      let sizeObject: number = size([1, 2, 3]);
      expect(sizeObject).assertEqual(3);
    })

    it('sizeTest02',0, () => {
      let sizeObject: number = size({ 'a': 1, 'b': 2 });
      expect(sizeObject).assertEqual(2);
    })

    it('someTest01',0, () => {
      let someObject: boolean = some([null, 0, 'yes', false], Boolean);
      expect(someObject).assertTrue();
    })

    it('someTest02',0, () => {
      let users: Active[] = [
        { user: 'barney', active: true },
        { user: 'fred',   active: false }
      ];
      let someObject: boolean = some(users, { 'user': 'barney', 'active': false });
      expect(someObject).assertFalse();
    })

    it('sortByTest01',0, () => {
      let users: Age[] = [
        { user: 'fred', age: 48 },
        { user: 'barney', age: 36 },
        { user: 'fred', age: 40 },
        { user: 'barney', age: 34 }
      ];
      let sortByObject: object = sortBy(users, (o: Age)=> { return o.user; });
      expect(JSON.stringify(sortByObject)).assertEqual('[{"user":"barney","age":36},{"user":"barney","age":34},{"user":"fred","age":48},{"user":"fred","age":40}]');
    })

    it('sortByTest02',0, () => {
      let users: Age[] = [
        { user: 'fred', age: 48 },
        { user: 'barney', age: 36 },
        { user: 'fred', age: 40 },
        { user: 'barney', age: 34 }
      ];
      let sortByObject: object = sortBy(users, 'user', (o: Age)=> {
        return Math.floor(o.age / 10);
      });
      expect(JSON.stringify(sortByObject)).assertEqual('[{"user":"barney","age":36},{"user":"barney","age":34},{"user":"fred","age":48},{"user":"fred","age":40}]');
    })
  })
}