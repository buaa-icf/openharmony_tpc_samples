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
import xml2js from 'xml2js';

@Entry
@Component
struct xmlBuilder {
  @State message: string = ""
  controller: TextAreaController = new TextAreaController()

  private getResourceStr(data: Resource): string {
    return getContext().resourceManager.getStringSync(data)
  }

  build() {
    Row() {
      Column() {
        Button(this.getResourceStr($r("app.string.Building_XML")) + "1")
          .fontSize(30)
          .margin(10)
          .onClick(() => {
            this.xmlBuilder()
          })
        Button(this.getResourceStr($r("app.string.Building_XML")) + "2")
          .fontSize(30)
          .margin(10)
          .onClick(() => {
            this.xmlBuilder2()
          })
        Button(this.getResourceStr($r("app.string.Building_XML")) + "3")
          .fontSize(30)
          .margin(10)
          .onClick(() => {
            this.xmlBuilder3()
          })
        Button(this.getResourceStr($r("app.string.Building_XML")) + "4")
          .fontSize(30)
          .margin(10)
          .onClick(() => {
            this.xmlBuilder4()
          })
        Text(this.message)
          .backgroundColor("#ffc4c1c1")
          .fontSize(18)
          .width("95%")
          .height("50%")
      }
      .width('100%')
    }
    .height('100%')
  }

  private xmlBuilder() {
    interface ObjType {
      name: string,
      Surname: string,
      age: number
    }

    let obj: ObjType = { name: "Super", Surname: "Man", age: 23 };
    let builder: xml2js.Builder = new xml2js.Builder();
    this.message = builder.buildObject(obj);
  }

  private xmlBuilder2() {
    interface ObjType {
      root: RootType
    }

    interface RootType {
      $: IdType,
      _: string
    }

    interface IdType {
      id: string
    }

    let obj: ObjType = { root: { $: { id: "my id" }, _: "my inner text" }};
    let builder: xml2js.Builder = new xml2js.Builder();
    this.message = builder.buildObject(obj);
  }

  private xmlBuilder3() {
    interface ObjType {
      Foo: FooType
    }

    interface FooType {
      $: XmlnsType
    }

    interface XmlnsType {
      xmlns: string
    }

    // 在根元素上声明默认命名空间的示例
    let obj: ObjType = {
      Foo: {
        $: {
          xmlns: "http://foo.com"
        }
      }
    };

    let builder: xml2js.Builder = new xml2js.Builder();
    this.message = builder.buildObject(obj);
  }

  private xmlBuilder4() {
    interface ObjType {
      foo: FooType,
    }

    interface FooType {
      $: FooInnerType,
      bar: BarType
    }

    interface FooInnerType {
      foo: string
    }

    interface BarType {
      $: BarInnerType
    }

    interface BarInnerType {
      bar: string
    }

    // 在非根元素上声明默认命名空间的示例
    let obj: ObjType = {
      foo: {
        $: {
          foo: 'http://foo.com'
        },
        bar: {
          $: {
            bar: 'http://bar.com'
          }
        }
      }
    }

    let builder: xml2js.Builder = new xml2js.Builder();
    this.message = builder.buildObject(obj);
  }
}