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
import { SimpleCollection } from './SimpleCollection';
import { User } from './User';
import { classToPlain, plainToClass, plainToClassFromExist } from '../../src/index';
import { SuperCollection } from './SuperCollection';

let collection = new SimpleCollection<User>();
collection.items = [new User(1, 'Johny', 'Cage', '*******'), new User(2, 'Dima', 'Cage', '*******')];
collection.count = 2;

// using generics works only for classToPlain operations, since in runtime we can
// "guess" type without type provided only we have a constructor, not plain object.

// console.log(classToPlain(collection));

// alternatively you can use factory method

let collectionJson = {
  items: [
    {
      id: 1,
      firstName: 'Johny',
      lastName: 'Cage',
      password: '*******',
    },
    {
      id: 2,
      firstName: 'Dima',
      lastName: 'Cage',
      password: '*******',
    },
  ],
};

console.log(plainToClassFromExist(new SuperCollection<User>(User), collectionJson));
