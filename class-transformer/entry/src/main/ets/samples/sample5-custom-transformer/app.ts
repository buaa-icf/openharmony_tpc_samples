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
import 'es6-shim';
import 'reflect-metadata';
import { plainToClass, classToPlain } from '../../src/index';
import { User } from './User';

let userJson = {
  id: 1,
  name: 'Johny Cage',
  date: new Date().valueOf(),
};

console.log(plainToClass(User, userJson));

const user = new User();
user.id = 1;
user.name = 'Johny Cage';
user.date = new Date();

console.log(classToPlain(user));
