import Example1Test from './Example1.test'
import Example2Test from './Example2.test'
import Example3Test from './Example3.test'
import Example4Test from './Example4.test'
import NetworkExampleTest from './NetworkExample.test'
import SingleExampleTest from './SingleExample.test'
/**
 * Apache License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import abilityTest from './Ability.test';

export default function testsuite() {
  abilityTest();
  SingleExampleTest()
  NetworkExampleTest()
  Example4Test()
  Example3Test()
  Example2Test()
  Example1Test()
}