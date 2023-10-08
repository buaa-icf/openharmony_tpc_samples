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

import abilityTest from './Ability.test'
import arrayTest from './Array.test'
import collectionTest from './Collection.test'
import functionTest from './Function.test';
import langTest from './Lang.test';
import mathTest from './Math.test';
import numberTest from './Number.test';
import objectTest from './Object.test';
import stringTest from './String.test';
import utilTest from './Util.test';

export default function testsuite() {
  abilityTest();
  arrayTest();
  collectionTest();
  functionTest();
  langTest();
  mathTest();
  numberTest();
  objectTest();
  stringTest();
  utilTest();
}