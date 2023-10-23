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
import transformer_orderTest from './transformer_order.test'
import transformation_optionSpecTest from './transformation_option.spec.test'
import specify_mapsTest from './specify_maps.test'
import sen_deserializationTest from './sen_deserialization.test'
import promise_fieldTest from './promise_field.test'
import prevent_array_bombTest from './prevent_array_bomb.test'
import inheritenceTest from './inheritence.test'
import implicit_type_declarationsTest from './implicit_type_declarations.test'
import ignore_decoratorsTest from './ignore_decorators.test'
import es6_data_typesTest from './es6_data_types.test'
import default_valuesTest from './default_values.test'
import custom_transformTest from './custom_transform.test'
import circular_reference_problemTest from './circular_reference_problem.test'
import basic_functionalityTest from './basic_functionality.test'
import abilityTest from './Ability.test'

export default function testsuite() {
  abilityTest()
  basic_functionalityTest()
  circular_reference_problemTest()
  custom_transformTest()
  default_valuesTest()
  es6_data_typesTest()
  ignore_decoratorsTest()
  implicit_type_declarationsTest()
  inheritenceTest()
  prevent_array_bombTest()
  promise_fieldTest()
  sen_deserializationTest()
  specify_mapsTest()
  transformation_optionSpecTest()
  transformer_orderTest()
}