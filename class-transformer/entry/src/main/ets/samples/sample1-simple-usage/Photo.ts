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
import { Type } from '../../src/decorators';
import { Album } from './Album';
import { User } from './User';

export class Photo {
  id: string;

  filename: string;

  description: string;

  tags: string[];

  @Type(() => User)
  author: User;

  @Type(() => Album)
  albums: Album[];

  get name() {
    return this.id + '_' + this.filename;
  }

  getAlbums() {
    console.log('this is not serialized/deserialized');
    return this.albums;
  }
}
