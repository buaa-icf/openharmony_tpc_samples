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
import { plainToClassDemo } from "../methods/plainToClass";
import { plainToClassFromExistDemo } from "../methods/plainToClassFromExist"
import { classToPlainDemo } from "../methods/classToPlain"
import { classToPlainFromExistDemo } from "../methods/classToPlainFromExist"
import { instanceToPlainDemo } from "../methods/instanceToPlain"
import { plainToInstanceDemo } from "../methods/plainToInstance"
import { instanceToInstanceDemo } from "../methods/instanceToInstance"
import { classToClassFromExistDemo } from "../methods/classToClassFromExist"
import { serializeDemo } from "../methods/serialize"
import { deserializeDemo } from "../methods/deserialize"

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  @Builder
  BuildButton(text: string, callback: () => void, remake?: string | Resource) {
    Button(text).onClick(callback).width("90%")
    Text(remake).margin({ top: 4, bottom: 10 }).width("90%")
  }

  build() {
    Scroll() {
      Column() {
        this.BuildButton("plainToClassDemo", plainToClassDemo,
          $r("app.string.This_method_converts_normal_JavaScript_object_into_instance_specific_class"))
        this.BuildButton("plainToInstanceDemo", plainToInstanceDemo,
          $r("app.string.This_method_converts_normal_JavaScript_object_into_instance_specific_class"))

        this.BuildButton("classToPlainDemo", classToPlainDemo,
          $r("app.string.This_method_converts_class_object_back_normal_JavaScript_object"))
        this.BuildButton("instanceToPlainDemo", instanceToPlainDemo,
          $r("app.string.This_method_converts_class_object_back_normal_JavaScript_object"))

        this.BuildButton("classToPlainFromExistDemo", classToPlainFromExistDemo,
          $r("app.string.Merge_class_instance_with_normal_JavaScript_object"))
        this.BuildButton("plainToClassFromExistDemo", plainToClassFromExistDemo,
          $r("app.string.This_method_converts_normal_object_instance_using_populated_object"))
        this.BuildButton("instanceToInstanceDemo", instanceToInstanceDemo,
          $r("app.string.Converts_class_object_to_new_class"))
        this.BuildButton("classToClassFromExistDemo", classToClassFromExistDemo,
          $r("app.string.Converts_a_class_object_to_plain_object"))
        this.BuildButton("serializeDemo", serializeDemo, $r("app.string.Serialize_given_object_as_JSON_string"))
        this.BuildButton("deserializeDemo", deserializeDemo,
          $r("app.string.Converts_object_string_to_instance_of_class"))
      }
      .width('100%')
      .padding({ top: 10 })
    }
    .width("100%")
    .height("100%")
  }
}