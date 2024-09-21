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
  @State message: string = this.getResourceString($r('app.string.The_copy_result_is'))
  getResourceString(res:Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }
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
            Text($r('app.string.Basic_data_type_copy'))
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

            Text($r('app.string.Ordinary_deep_copy'))
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
            Text($r('app.string.function_deep_copy'))
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
            Text($r('app.string.Dark_and_light_copy_comparison'))
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
            Text($r('app.string.Cycle_copy_comparison'))
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

            Text($r('app.string.multilayer_attributes'))
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
    this.message = this.getResourceString($r('app.string.The_copy_result_is'))
    let a = 12
    let b: ESObject = cloneDeep(a)
    this.message = this.message + '\n' + '\n' + this.getResourceString($r('app.string.Before_copying')) +'12，'+this.getResourceString($r('app.string.After_copying')) + b + '\n'

    let c = -123456789.654123
    let d: ESObject = cloneDeep(c)

    this.message = this.message + '\n' + '\n' + this.getResourceString($r('app.string.Before_copying')) +"-123456789.654123，"+this.getResourceString($r('app.string.After_copying')) + d + '\n'

    let e = '0055'
    let f: ESObject = cloneDeep(e)
    this.message = this.message + '\n' + '\n' + this.getResourceString($r('app.string.Before_copying')) +"0055，"+this.getResourceString($r('app.string.After_copying')) + f + '\n'

    let g = [1, 2, 3, 4, ['a', 'b']]
    let h: ESObject = cloneDeep(g)
    this.message = this.message + '\n' + '\n' + this.getResourceString($r('app.string.Before_copying')) +" [1, 2, 3, 4, ['a', 'b']]，"+this.getResourceString($r('app.string.After_copying')) + JSON.stringify(h) + '\n'

  }

  commonCopy() {
    this.message = this.getResourceString($r('app.string.The_copy_result_is'))
    let outObj: ESObject = {
      inObj: { a: 1, b: 2 } as ESObject
    }
    let newObj: ESObject = (Object as ESObject).assign({}, outObj);
    newObj.inObj.a = 2;

    this.message = this.getResourceString($r('app.string.The_copy_result_is'))+'\n' + this.getResourceString($r('app.string.Shallow_outObj_Object_assign'))+"= {inObj:{a:1,b:2}}，"+this.getResourceString($r('app.string.Get_newObj')) + JSON.stringify(outObj)

    let outObj1: ESObject = { inObj: { a: 1, b: 2 } as ESObject }
    let deep: ESObject = cloneDeep(outObj1);
    deep.inObj.a = 2;
    this.message = this.message + '\n' + '\n'
      + this.getResourceString($r('app.string.Deep_cloneDeep'))+" = { inObj: { a: 1, b: 2 } }，"+this.getResourceString($r('app.string.Get_deep')) + JSON.stringify(outObj1)
  }

  functionCopy() {
    this.message = this.getResourceString($r('app.string.The_copy_result_is'))
    let obj: ESObject = { id: 1, name: { a: 'xx' } as ESObject, c: {
      fn: (a: number, b: number) => {
        return a + b
      }
    } as ESObject };

    let newObj: ESObject = (Object as ESObject).assign({}, obj);
    newObj.id = 999;
    newObj.name.a = this.getResourceString($r('app.string.LiXiaoyao'));
    newObj.c.fn = (a: number, b: number) => {
      return a + b * 2
    };
    let addResult: number = obj.c.fn(2, 3);

    this.message = this.message + "\n"
      + "obj = { id: 1, name: { a: 'xx' }, c:{fn: function add(a, b) {return a + b}} }"+this.getResourceString($r('app.string.After_shallow'))+
    `obj.id：${obj.id}, obj.name.a：${obj.name.a}, obj.fn：${addResult},  `


    let obj1: ESObject = { id: 1, name: { a: 'xx' } as ESObject, c: { fn: (a: number, b: number) => {
      return a + b
    } } as ESObject };

    let newObj1: ESObject = cloneDeep(obj1);
    newObj1.id = 777;
    newObj1.name.a = $r('app.string.WangFugui');
    newObj1.c.fn = (a: number, b: number) => {
      return a * 2 + b
    };
    let addResult1: number = obj1.c.fn(2, 3);

    this.message = this.message + "\n" + "\n"
      + " obj1 = { id: 1, name: { a: 'xx' }, fn: function add(a, b) {return a + b} } "+this.getResourceString($r('app.string.After_deep_copying'))+
    `obj1.id：${obj1.id}, obj1.name.a：${obj1.name.a}, obj1.fn：${addResult1},  `

  }

  copyCompare() {
    this.message = this.getResourceString($r('app.string.The_copy_result_is'))

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
      + '\n'+this.getResourceString($r('app.string.Add_Vue'))
      + '\n obj1.age:  ' + JSON.stringify(obj1.age)
      + '\n obj1.skills:  ' + JSON.stringify(obj1.skills)
      + '\n obj1.others:  ' + JSON.stringify(obj1.others)
      + '\n'+this.getResourceString($r('app.string.object_obtained'))+' obj2.age:  ' + JSON.stringify(obj2.age)
      + '\n'+this.getResourceString($r('app.string.object_obtained'))+' obj2.skills:  ' + JSON.stringify(obj2.skills)
      + '\n'+this.getResourceString($r('app.string.object_obtained'))+' obj2.others:  ' + JSON.stringify(obj2.others)

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

    this.message = this.message + "\n" + "\n" + this.getResourceString($r('app.string.Add_React'))
      + '\n obj1.skills:  ' + JSON.stringify(obj11.skills)
      + '\n obj1.others:  ' + JSON.stringify(obj11.others)
      + '\n '+this.getResourceString($r('app.string.object_obtained'))+' obj3.skills:  ' + JSON.stringify(obj3.skills)
      + '\n  '+this.getResourceString($r('app.string.object_obtained'))+' obj3.others:  ' + JSON.stringify(obj3.others)

  }

  circularReference() {
    this.message = 'const objb = { b: null };\n const obja = { a: objb }; \nobjb.b = obja;\n'+this.getResourceString($r('app.string.The_copy_result_is'))+'\n'
    try {
      const objb: ESObject = { b: (null as ESObject) };
      const obja: ESObject = { a: objb };
      objb.b = obja;
      let origin = JSON.stringify(objb)
      console.log('ZDY---不使用拷贝--->' + origin);
      this.message = this.message + this.getResourceString($r('app.string.Without_copying')) + origin
    } catch (err) {
      console.log('ZDY---不使用拷贝--->' + err);
      this.message = this.message + "\n"+this.getResourceString($r('app.string.circular_reference_error')) + err
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
      this.message = this.message + "\n"+this.getResourceString($r('app.string.Using_deep_copy')) + cloneObj
    } catch (err) {
      console.log('ZDY---使用拷贝--->' + err);
      this.message = this.message + "\n"+this.getResourceString($r('app.string.circular_reference')) + err
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
    newObj.b.d.f.h.j.name = $r('app.string.ZhangSan');


    this.message = this.getResourceString($r('app.string.The_copy_result_is'))+'\n' + this.getResourceString($r('app.string.Shallow_Object_assign'))+`= ${originStr}，`+this.getResourceString($r('app.string.Get_newObj')) + JSON.stringify(origin)

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
    deep.b.d.f.h.j.name = this.getResourceString($r('app.string.LiSi'));
    deep.b.c = 11;
    deep.a = '8520';
    this.message = this.message + '\n' + '\n'
      +this.getResourceString($r('app.string.Deep_copy_cloneDeep'))+`= ${originStr}，`+this.getResourceString($r('app.string.Get_deep')) + JSON.stringify(outObj1)

  }
}