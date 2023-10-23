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
import { classToPlain, plainToClass } from '../../src/index';
import { Photo } from './Photo';

// check deserialization

let photoJson = {
  id: '1',
  filename: 'myphoto.jpg',
  description: 'about my photo',
  tags: ['me', 'iam'],
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
console.log('-----------------------------');
console.log('Trying to find album: ', photo.albums.findByName('My life'));
console.log('-----------------------------');

// now check serialization

let newPhotoJson = classToPlain(photo);
console.log('serialized object: ', newPhotoJson);
console.log('-----------------------------');
