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
import 'reflect-metadata';
import {
  instanceToInstance,
  instanceToPlain,
} from 'class_transformer';
import { defaultMetadataStorage } from 'class_transformer';
import { describe,it as _it,expect } from "../utils/utils";

export default function circular_reference_problemTest() {
  describe('circular_reference_problemTest', function () {

    _it('should skip circular reference objects in instanceToPlain operation', () => {
      defaultMetadataStorage.clear();

      class Caption {
        text: string;
      }

      class Photo {
        id: number;
        filename: string;
        user: User;
        users: User[];
        caption: Caption;
      }

      class User {
        id: number;
        firstName: string;
        caption: Caption;
        photos: Photo[];
      }

      const photo1 = new Photo();
      photo1.id = 1;
      photo1.filename = 'me.jpg';

      const photo2 = new Photo();
      photo2.id = 2;
      photo2.filename = 'she.jpg';

      const caption = new Caption();
      caption.text = 'cool photo';

      const user = new User();
      user.caption = caption;
      user.firstName = 'Umed Khudoiberdiev';
      user.photos = [photo1, photo2];

      photo1.user = user;
      photo2.user = user;
      photo1.users = [user];
      photo2.users = [user];

      photo1.caption = caption;
      photo2.caption = caption;

      const plainUser = instanceToPlain(user, { enableCircularCheck: true });
      expect(plainUser).toEqual({
        firstName: 'Umed Khudoiberdiev',
        caption: { text: 'cool photo' },
        photos: [
          {
            id: 1,
            filename: 'me.jpg',
            users: [],
            caption: { text: 'cool photo' },
          },
          {
            id: 2,
            filename: 'she.jpg',
            users: [],
            caption: { text: 'cool photo' },
          },
        ],
      });
    });
  })
}