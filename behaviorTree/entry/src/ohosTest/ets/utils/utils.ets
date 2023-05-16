/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import {
  describe as _describe,
  beforeAll as _beforeAll,
  beforeEach as _beforeEach,
  afterEach as _afterEach,
  afterAll as _afterAll,
  it as _it,
  expect as _expect,
  TestType,
  Size,
  Level

} from '@ohos/hypium'

export const beforeAll = _beforeAll;
export const beforeEach = _beforeEach;
export const afterEach = _afterEach;
export const afterAll = _afterAll;

export function describe(testSuiteName: string, callback: Function){
  return _describe(testSuiteName,callback)
}

export  function it(testCaseName: string, callback: Function){
  testCaseName = testCaseName.split("_").join("__")
  return _it(testCaseName,TestType.FUNCTION,callback)
}

export function expect (actualValue?: any){
  const temp = _expect(actualValue);
  return {
    toBe:(value:any,tValue?:any) => temp.assertEqual(value),
    toBeInstanceOf:temp.assertInstanceOf,
    toEqual:(value:any,tValue?:any) => temp.assertEqual(value),
    toThrowError:temp.assertThrowError
  }
}

export function diff(obj1, obj2) {
  var o1 = obj1 instanceof Object;
  var o2 = obj2 instanceof Object;
  // 判断是不是对象
  if (!o1 || !o2) {
    return obj1 === obj2;
  }
  //Object.keys() 返回一个由对象的自身可枚举属性(key值)组成的数组,
  //例如：数组返回下表：let arr = ["a", "b", "c"];console.log(Object.keys(arr))->0,1,2;
  if (Object.keys(obj1).length !== Object.keys(obj2).length) {
    return false;
  }
  for (var o in obj1) {
    var t1 = obj1[o] instanceof Object;
    var t2 = obj2[o] instanceof Object;
    if (t1 && t2) {
      if (!diff(obj1[o], obj2[o])) {
        return false
      }
    } else if (obj1[o] !== obj2[o]) {
      return false;
    }
  }
  return true;
}