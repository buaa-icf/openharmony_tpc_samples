/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import cloneDeep from 'lodash.clonedeep';

export default function DiyTest() {

  let diff = (obj1: ESObject, obj2: ESObject) => {
    let o1 = obj1 instanceof Object;
    let o2 = obj2 instanceof Object;
    // 判断是不是对象
    if (!o1 || !o2) {
      return obj1 === obj2;
    }
    //Object.keys() 返回一个由对象的自身可枚举属性(key值)组成的数组,
    //例如：数组返回下表：let arr = ["a", "b", "c"];console.log(Object.keys(arr))->0,1,2;
    if (Object.keys(obj1).length !== Object.keys(obj2).length) {
      return false;
    }
    let keys: string[] = Object.keys(obj1)
    for (let o = 0; o < keys.length; o++) {
      let key = keys[o]
      let t1 = obj1[key] instanceof Object;
      let t2 = obj2[key] instanceof Object;
      if (t1 && t2) {
        if (!diff(obj1[key], obj2[key])) {
          return false
        }
      } else if (obj1[key] !== obj2[key]) {
        return false;
      }
    }
    return true;
  }

  describe('DiyTest', ()=> {

    it('baseDataTypeTest', 0, ()=> {
      let a :ESObject= {
        a: 23,
        b: {
          c: 45,
          d: {
            e: 78
          }as ESObject
        }as ESObject
      }
      let obj:ESObject = cloneDeep(a)
      expect(diff(a, obj)).assertTrue()
      expect(a.a === obj.a).assertTrue()
      obj.a = 8520
      expect(a.a === obj.a).assertFalse()
      expect(a.b.c === obj.b.c).assertTrue()
      obj.b.d.e = 999
      expect(a.b.d.e === obj.b.d.e).assertFalse()


      let c = -123456789.654123
      let d :ESObject= cloneDeep(c)
      expect(c === d).assertTrue()

      let g = [1, 2, 3, 4, ['a', 'b']]
      let h :ESObject= cloneDeep(g)
      expect(diff(g, h)).assertTrue()
    });

    it('DeepCopyShallowCopyTest', 0, ()=> {
      let outObj:ESObject = {
        inObj: {
          a: 1, b: 2
        }as ESObject
      }
      let newObj:ESObject = (Object as ESObject).assign({}, outObj);
      newObj.inObj.a = 2;

      expect(outObj.inObj.a === 1).assertFalse()
      expect(newObj.inObj.a === 2).assertTrue()

      let outObj1:ESObject = {
        inObj: {
          a: 1, b: 2
        }as ESObject
      }
      let deep:ESObject = cloneDeep(outObj1);
      deep.inObj.a = 2;
      expect(outObj1.inObj.a === 1).assertTrue()
      expect(deep.inObj.a === 2).assertTrue()

    });

    it('functionCopyTest', 0, ()=> {
      let obj:ESObject = {
        id: 1, name: {
          a: 'xx'
        }as ESObject, c: {
          fn: (a:number, b:number)=> {
            return a + b
          }
        }as ESObject
      };
      let addResult0:number = obj.c.fn(2, 3);
      expect(addResult0 === 5).assertTrue()

      let newObj:ESObject = (Object as ESObject).assign({}, obj);
      newObj.id = 999;
      newObj.name.a = '李逍遥';
      newObj.c.fn = (a:number, b:number)=> {
        return a + b * 2
      };
      let addResult1:number = obj.c.fn(2, 3);
      let addResult2:number = newObj.c.fn(2, 3);

      expect(addResult1 === 5).assertFalse()
      expect(addResult1 === 8).assertTrue()
      expect(addResult2 === 8).assertTrue()

      let obj1:ESObject = {
        id: 1, name: {
          a: 'xx'
        } as ESObject, c: {
          fn: (a:number, b:number)=> {
            return a + b
          }
        }as ESObject
      };
      let addResult3:number = obj1.c.fn(2, 3);
      expect(addResult3 === 5).assertTrue()

      let newObj1:ESObject = cloneDeep(obj1);
      newObj1.id = 777;
      newObj1.name.a = '王富贵';
      newObj1.c.fn = (a:number, b:number)=> {
        return a + b * 2
      };
      let addResult4:number = obj1.c.fn(2, 3);
      let addResult5:number = newObj1.c.fn(2, 3);

      expect(addResult4 === 8).assertFalse()
      expect(addResult4 === 5).assertTrue()
      expect(addResult5 === 8).assertTrue()

    });

    it('circularReferenceTest_not_copy', 0, ()=> {
      try {
        const objb:ESObject = {
          b: null as ESObject
        };
        const obja:ESObject = {
          a: objb
        };
        objb.b = obja;
        let origin = JSON.stringify(objb)
      } catch (err) {
        expect(err).not().assertNull()
      }

    });
    it('circularReferenceTest_copy', 0, ()=> {
      try {
        const objb:ESObject = {
          b: null as ESObject
        };
        const obja:ESObject = {
          a: objb
        };
        objb.b = cloneDeep(obja);
        let cloneObj = JSON.stringify(objb)
        expect(cloneObj).not().assertNull()
      } catch (err) {
        expect(1).assertEqual(2)
      }
    });

    it('multiChildTest', 0, ()=> {
      let origin: ESObject = {
        a: "123",
        b: {
          c: 56,
          d: {
            e: false,
            f: {
              g: [7, 8, 9],
              h: {
                i: "hello",
                j: {
                  name: "test",
                  age: 25,
                  sex: "man"
                } as ESObject
              }as ESObject
            }as ESObject
          }as ESObject
        }as ESObject
      }
      let deep:ESObject = cloneDeep(origin);

      expect((origin.a === '123') && (deep.a === "123") && (origin.a === deep.a)).assertTrue()
      expect((origin.b.c === 56) && (deep.b.c === 56) && (origin.b.c === deep.b.c)).assertTrue()
      expect((origin.b.d.e === false) && (deep.b.d.e === false) && (origin.b.d.e === deep.b.d.e)).assertTrue()
      expect(diff(origin.b.d.f.g, [7, 8, 9]) && diff(deep.b.d.f.g, [7, 8, 9]) && diff(origin.b.d.f.g, deep.b.d.f.g))
        .assertTrue()
      expect((origin.b.d.f.h.i === 'hello') && (deep.b.d.f.h.i === 'hello') && (origin.b.d.f.h.i === deep.b.d.f.h.i))
        .assertTrue()
      expect((origin.b.d.f.h.j.name === 'test') && (deep.b.d.f.h.j.name === 'test') && (origin.b.d.f.h.j.name === deep.b.d.f.h.j.name))
        .assertTrue()
      expect((origin.b.d.f.h.j.age === 25) && (deep.b.d.f.h.j.age === 25) && (origin.b.d.f.h.j.age === deep.b.d.f.h.j.age))
        .assertTrue()
      expect((origin.b.d.f.h.j.sex === 'man') && (deep.b.d.f.h.j.sex === 'man') && (origin.b.d.f.h.j.sex === deep.b.d.f.h.j.sex))
        .assertTrue()

      expect(diff(origin, deep)).assertTrue()

      deep.a = '8520';
      deep.b.c = 11;
      deep.b.d.e = true
      deep.b.d.f.g = [123, 456, 789]
      deep.b.d.f.h.i = 'world';
      deep.b.d.f.h.j.name = 'unit';
      deep.b.d.f.h.j.age = 52;
      deep.b.d.f.h.j.sex = 'woman';

      expect((origin.a === '123') && (deep.a === "8520") && (origin.a !== deep.a)).assertTrue()
      expect((origin.b.c === 56) && (deep.b.c === 11) && (origin.b.c !== deep.b.c)).assertTrue()
      expect((origin.b.d.e === false) && (deep.b.d.e === true) && (origin.b.d.e !== deep.b.d.e)).assertTrue()
      expect(diff(origin.b.d.f.g, [7, 8, 9]) && diff(deep.b.d.f.g, [123, 456, 789]) && diff(origin.b.d.f.g, deep.b.d.f.g) === false)
        .assertTrue()
      expect((origin.b.d.f.h.i === 'hello') && (deep.b.d.f.h.i === 'world') && (origin.b.d.f.h.i !== deep.b.d.f.h.i))
        .assertTrue()
      expect((origin.b.d.f.h.j.name === 'test') && (deep.b.d.f.h.j.name === 'unit') && (origin.b.d.f.h.j.name !== deep.b.d.f.h.j.name))
        .assertTrue()
      expect((origin.b.d.f.h.j.age === 25) && (deep.b.d.f.h.j.age === 52) && (origin.b.d.f.h.j.age !== deep.b.d.f.h.j.age))
        .assertTrue()
      expect((origin.b.d.f.h.j.sex === 'man') && (deep.b.d.f.h.j.sex === 'woman') && (origin.b.d.f.h.j.sex !== deep.b.d.f.h.j.sex))
        .assertTrue()

      expect(diff(origin, deep)).assertFalse()
    });
  })
}
