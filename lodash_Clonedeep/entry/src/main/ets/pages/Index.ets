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

import cloneDeep from 'lodash.clonedeep';

@Entry
@Component
struct Index {
  @State message: string = '拷贝结果是：'

  build() {
    Row() {
      Scroll() {
        Column() {
          Flex({
            alignItems: ItemAlign.Start,
            justifyContent: FlexAlign.Start,
            alignContent: FlexAlign.Start,
            direction: FlexDirection.Column
          }) {
            Text(this.message)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .padding(10)
              .backgroundColor(Color.Red)
              .fontColor(Color.White)
            Text('基础数据类型拷贝')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .height(50)
              .margin({
                top: 20
              })
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .onClick(() => {
                this.baseDataTypeCopy()
              })

            Text('普通深拷贝')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .height(50)
              .margin({
                top: 20
              })
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .onClick(() => {
                this.commonCopy()
              })
            Text('function深拷贝')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .height(50)
              .margin({
                top: 20
              })
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .onClick(() => {
                this.functionCopy()
              })
            Text('深浅拷贝对比')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .height(50)
              .margin({
                top: 20
              })
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .onClick(() => {
                this.copyCompare()
              })
            Text('循环拷贝对比')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .height(50)
              .margin({
                top: 20
              })
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .onClick(() => {
                this.circularReference()
              })

            Text('多层属性深浅拷贝对比')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .height(50)
              .margin({
                top: 20
              })
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .onClick(() => {
                this.multiChildCopy()
              })
          }

        }
        .width('100%')
      }.width('100%')
      .height('100%')
    }
    .height('100%')
  }

  baseDataTypeCopy() {
    this.message = '拷贝结果是：'
    let a = 12
    let b: ESObject = cloneDeep(a)
    this.message = this.message + '\n' + '\n' + '拷贝前 12，拷贝后 ' + b + '\n'

    let c = -123456789.654123
    let d: ESObject = cloneDeep(c)

    this.message = this.message + '\n' + '\n' + '拷贝前 -123456789.654123，拷贝后 ' + d + '\n'

    let e = '0055'
    let f: ESObject = cloneDeep(e)
    this.message = this.message + '\n' + '\n' + '拷贝前 0055，拷贝后 ' + f + '\n'

    let g = [1, 2, 3, 4, ['a', 'b']]
    let h: ESObject = cloneDeep(g)
    this.message = this.message + '\n' + '\n' + `拷贝前 [1, 2, 3, 4, ['a', 'b']]，拷贝后  ` + JSON.stringify(h) + '\n'

  }

  commonCopy() {
    this.message = '拷贝结果是：'
    let outObj: ESObject = {
      inObj: { a: 1, b: 2 } as ESObject
    }
    let newObj: ESObject = (Object as ESObject).assign({}, outObj);
    newObj.inObj.a = 2;

    this.message = '拷贝结果是：\n' + "通过Object.assign浅拷贝outObj= {inObj:{a:1,b:2}}，得到newObj，改变newObj的属性，观察源对象outObj的属性是否改变：" + JSON.stringify(outObj)

    let outObj1: ESObject = { inObj: { a: 1, b: 2 } as ESObject }
    let deep: ESObject = cloneDeep(outObj1);
    deep.inObj.a = 2;
    this.message = this.message + '\n' + '\n'
      + "通过cloneDeep深拷贝outObj1 = { inObj: { a: 1, b: 2 } }，得到deep，改变deep的属性，观察源对象outObj1的属性是否改变：" + JSON.stringify(outObj1)
  }

  functionCopy() {
    this.message = '拷贝结果是：'
    let obj: ESObject = { id: 1, name: { a: 'xx' } as ESObject, c: {
      fn: (a: number, b: number) => {
        return a + b
      }
    } as ESObject };

    let newObj: ESObject = (Object as ESObject).assign({}, obj);
    newObj.id = 999;
    newObj.name.a = '李逍遥';
    newObj.c.fn = (a: number, b: number) => {
      return a + b * 2
    };
    let addResult: number = obj.c.fn(2, 3);

    this.message = this.message + "\n"
      + ` obj = { id: 1, name: { a: 'xx' }, c:{fn: function add(a, b) {return a + b}} } 浅拷贝之后得到newObj，改变newObj的属性，观察源对象obj的属性
    obj.id：${obj.id}, obj.name.a：${obj.name.a}, obj.fn：${addResult},  `


    let obj1: ESObject = { id: 1, name: { a: 'xx' } as ESObject, c: { fn: (a: number, b: number) => {
      return a + b
    } } as ESObject };

    let newObj1: ESObject = cloneDeep(obj1);
    newObj1.id = 777;
    newObj1.name.a = '王富贵';
    newObj1.c.fn = (a: number, b: number) => {
      return a * 2 + b
    };
    let addResult1: number = obj1.c.fn(2, 3);

    this.message = this.message + "\n" + "\n"
      + ` obj1 = { id: 1, name: { a: 'xx' }, fn: function add(a, b) {return a + b} } 深拷贝之后得到newObj1，改变newObj1的属性，观察源对象obj1的属性
    obj1.id：${obj1.id}, obj1.name.a：${obj1.name.a}, obj1.fn：${addResult1},  `

  }

  copyCompare() {
    this.message = '拷贝结果是：'

    class Obj {
      name: string
      age: number
      skills: string[]
      others: ESObject

      constructor(name: string, age: number, skills: string[], others: ESObject) {
        this.name = name
        this.age = age
        this.skills = skills
        this.others = others
      }
    }

    // 浅拷贝
    let obj1 = new Obj('Tom', 20, ['JavaScript', 'CSS', 'HTML'], { gender: 'male',
      city: 'New York'
    } as ESObject)

    let obj2 = new Obj(obj1.name, obj1.age, obj1.skills, obj1.others);
    obj2.age = 666
    obj2.skills.push('Vue');
    // obj1.skins 得到新数组 ['JavaScript', 'CSS', 'HTML', 'Vue']
    // obj1.others 将会被修改，和 obj2.others 指向同一引用地址
    this.message = ` let obj1 = {name: 'Tom',age: 20,skills: ['JavaScript', 'CSS', 'HTML'],others: {gender: 'male',city: 'New York'}}`
      + '\n浅拷贝之后得到的对象obj2在skills里面添加Vue，查看obj1的属性结果是：'
      + '\n obj1.age:  ' + JSON.stringify(obj1.age)
      + '\n obj1.skills:  ' + JSON.stringify(obj1.skills)
      + '\n obj1.others:  ' + JSON.stringify(obj1.others)
      + '\n 得到的新对象的属性 obj2.age:  ' + JSON.stringify(obj2.age)
      + '\n 得到的新对象的属性 obj2.skills:  ' + JSON.stringify(obj2.skills)
      + '\n  得到的新对象的属性 obj2.others:  ' + JSON.stringify(obj2.others)

    let obj11: ESObject = {
      name: 'Tom',
      age: 20,
      skills: ['JavaScript', 'CSS', 'HTML'],
      others: {
        gender: 'male',
        city: 'New York'
      } as ESObject
    };

    // 深拷贝
    let obj3: ESObject = cloneDeep(obj11);
    obj3.skills.push('React');
    // obj1.skins 仍然是原来的 ['JavaScript', 'CSS', 'HTML']
    // obj1.others 没有被修改
    // obj3.skins 得到新数组 ['JavaScript', 'CSS', 'HTML', 'React']
    // obj3.others 和 obj1.others 是两个不同的引用地址

    this.message = this.message + "\n" + "\n" + '深拷贝之后得到的对象obj2在skills里面添加React，查看obj1的属性结果是：'
      + '\n obj1.skills:  ' + JSON.stringify(obj11.skills)
      + '\n obj1.others:  ' + JSON.stringify(obj11.others)
      + '\n 得到的新对象的属性 obj3.skills:  ' + JSON.stringify(obj3.skills)
      + '\n  得到的新对象的属性 obj3.others:  ' + JSON.stringify(obj3.others)

  }

  circularReference() {
    this.message = 'const objb = { b: null };\n const obja = { a: objb }; \nobjb.b = obja;\n拷贝结果是：\n'
    try {
      const objb: ESObject = { b: (null as ESObject) };
      const obja: ESObject = { a: objb };
      objb.b = obja;
      let origin = JSON.stringify(objb)
      console.log('ZDY---不使用拷贝--->' + origin);
      this.message = this.message + "不使用拷贝，直接打印循环引用的结果是：" + origin
    } catch (err) {
      console.log('ZDY---不使用拷贝--->' + err);
      this.message = this.message + "\n不使用拷贝，循环引用出错：" + err
    }
    try {
      const objb: ESObject = {
        b: (null as ESObject)
      };
      const obja: ESObject = {
        a: objb
      };
      objb.b = cloneDeep(obja);
      let cloneObj = JSON.stringify(objb)
      console.log('ZDY---使用拷贝--->' + cloneObj);
      this.message = this.message + "\n使用深拷贝，循环引用的结果是：" + cloneObj
    } catch (err) {
      console.log('ZDY---使用拷贝--->' + err);
      this.message = this.message + "\n使用深拷贝，循环引用出错：" + err
    }
  }

  multiChildCopy() {
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
            } as ESObject
          } as ESObject
        } as ESObject
      } as ESObject
    }
    let originStr: string = `{a: "123",b: {c: 56,d: {e: false,f: {g: [7, 8, 9],h: {i: "hello",j: {name: "test",age: 25,sex: "man"}}}}}}`
    let newObj: ESObject = (Object as ESObject).assign({} as ESObject, origin);
    newObj.a = '9527';
    newObj.b.c = 99;
    newObj.b.d.f.h.j.name = '张三';


    this.message = '拷贝结果是：\n' + `通过Object.assign浅拷贝origin= ${originStr}，得到newObj，改变newObj的属性，观察源对象outObj的属性是否改变：` + JSON.stringify(origin)

    let outObj1: ESObject = {
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
            } as ESObject
          } as ESObject
        } as ESObject
      } as ESObject
    }
    let deep: ESObject = cloneDeep(outObj1);
    deep.b.d.f.h.j.name = '李四';
    deep.b.c = 11;
    deep.a = '8520';
    this.message = this.message + '\n' + '\n'
      + `通过cloneDeep深拷贝outObj1 = ${originStr}，得到deep，改变deep的属性，观察源对象outObj1的属性是否改变：` + JSON.stringify(outObj1)

  }
}