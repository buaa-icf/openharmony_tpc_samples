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

  build() {
    Row() {
      Column() {
        Button("构建XML1")
          .fontSize(30)
          .margin(10)
          .onClick(() => {
            this.xmlBuilder()
          })
        Button("构建XML2")
          .fontSize(30)
          .margin(10)
          .onClick(() => {
            this.xmlBuilder2()
          })
        Button("构建XML3")
          .fontSize(30)
          .margin(10)
          .onClick(() => {
            this.xmlBuilder3()
          })
        Button("构建XML4")
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
    var obj = { name: "Super", Surname: "Man", age: 23 };
    var builder = new xml2js.Builder();
    this.message = builder.buildObject(obj);
  }

  private xmlBuilder2() {
    var obj = { root: { $: { id: "my id" }, _: "my inner text" } };
    var builder = new xml2js.Builder();
    this.message = builder.buildObject(obj);
  }

  private xmlBuilder3() {
    // 在根元素上声明默认命名空间的示例
    var obj = {
      Foo: {
        $: {
          "xmlns": "http://foo.com"
        }
      }
    };
    var builder = new xml2js.Builder();
    this.message = builder.buildObject(obj);
  }

  private xmlBuilder4() {
    // 在非根元素上声明默认命名空间的示例
    var obj = {
      'foo:Foo': {
        $: {
          'xmlns:foo': 'http://foo.com'
        },
        'bar:Bar': {
          $: {
            'xmlns:bar': 'http://bar.com'
          }
        }
      }
    }
    var builder = new xml2js.Builder();
    this.message = builder.buildObject(obj);
  }
}