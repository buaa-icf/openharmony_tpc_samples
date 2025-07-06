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

const METADATA_KEY = 'demo-metadata';

@Entry
@Component
struct Index {
  @State result1: string = '';
  @State result2: string = '';
  @State result3: string = '';
  @State result4: string = '';
  @State result5: string = '';
  @State result6: string = '';
  @State result7: string = '';

  private getResourceString(res:Resource){
    return this.getUIContext()?.getHostContext()?.resourceManager.getStringSync(res.id);
  }

  build() {
    Column () {
      Button('Click', { type: ButtonType.Capsule, stateEffect: true })
        .backgroundColor(0x317aff)
        .width('50%')
        .height(60)
        .margin({ bottom: 30, top: 50 })
        .onClick(() => {
          import("reflect-metadata").then((reflectMetadata) => {
            @Reflect.metadata(METADATA_KEY, 'John Doe')
            class Person {
              name: string = 'John Doe';
            }
            this.result1 = Reflect.hasMetadata(METADATA_KEY, Person).toString();
            this.result2 = Reflect.hasOwnMetadata(METADATA_KEY, Person).toString();
            this.result3 = Reflect.getMetadata(METADATA_KEY, Person);
            this.result4 = Reflect.getOwnMetadata(METADATA_KEY, Person);
            this.result5 = Reflect.getMetadataKeys(Person).toString();
            this.result6 = Reflect.getOwnMetadataKeys(Person).toString();
            this.result7 = Reflect.deleteMetadata(METADATA_KEY, Person).toString();
          })
        })

      Column() {
        Text(`${this.getResourceString($r("app.string.Classes_with_metadata"))} demo-metadata {name: John Doe; age: 30}`)
          .fontSize(20)
          .margin({ bottom: 20 })

        Text(`${this.getResourceString($r("app.string.Classes_with_metadata"))} ${this.result1}`)
          .fontSize(20)
          .margin({ bottom: 20 })

        Text(`${this.getResourceString($r("app.string.Check_you_have_your_own_metadata_key"))} ${this.result2}`)
          .fontSize(20)
          .margin({ bottom: 20 })

        Text(`${this.getResourceString($r("app.string.Get_metadata_value_the_metadata_key_on_prototype_chain"))} ${this.result3}`)
          .fontSize(20)
          .margin({ bottom: 20 })

        Text(`${this.getResourceString($r("app.string.Gets_metadata_value_our_own_metadata_key"))} ${this.result4}`)
          .fontSize(20)
          .margin({ bottom: 20 })

        Text(`${this.getResourceString($r("app.string.Get_all_metadata_keys_on_prototype_chain"))} ${this.result5}`)
          .fontSize(20)
          .margin({ bottom: 20 })

        Text(`${this.getResourceString($r("app.string.Get_all_your_own_metadata_keys"))} ${this.result6}`)
          .fontSize(20)
          .margin({ bottom: 20 })

        Text(`${this.getResourceString($r("app.string.Delete_metadata"))} ${this.result7}`)
          .fontSize(20)
          .margin({ bottom: 20 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
  }
}