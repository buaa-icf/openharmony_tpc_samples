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
import { plainToClass, classToPlain } from 'class-transformer';
import { Photo } from './Photo';

// check deserialization

let photoJson = {
  id: '1',
  filename: 'myphoto.jpg',
  description: 'about my photo',
  tags: ['me', 'iam'],
  author: {
    id: '2',
    firstName: 'Johny',
    lastName: 'Cage',
  },
  albums: [
    {
      id: '1',
      name: 'My life',
    },
    {
      id: '2',
      name: 'My young years',
    },
  ],
};

let photo = plainToClass(Photo, photoJson);
console.log('deserialized object: ', photo);

// now check serialization

let newPhotoJson = classToPlain(photo);
console.log('serialized object: ', newPhotoJson);

// try to deserialize an array
console.log('-------------------------------');

let photosJson = [
  {
    id: '1',
    filename: 'myphoto.jpg',
    description: 'about my photo',
    author: {
      id: '2',
      firstName: 'Johny',
      lastName: 'Cage',
      registrationDate: '1995-12-17T03:24:00',
    },
    albums: [
      {
        id: '1',
        name: 'My life',
      },
      {
        id: '2',
        name: 'My young years',
      },
    ],
  },
  {
    id: '2',
    filename: 'hisphoto.jpg',
    description: 'about his photo',
    author: {
      id: '2',
      firstName: 'Johny',
      lastName: 'Cage',
    },
    albums: [
      {
        id: '1',
        name: 'My life',
      },
      {
        id: '2',
        name: 'My young years',
      },
    ],
  },
];

let photos = plainToClass(Photo, photosJson);
console.log('deserialized array: ', photos);

// now check array serialization

let newPhotosJson = classToPlain(photos);
console.log('serialized array: ', newPhotosJson);
