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
  classToClassFromExist,
  instanceToPlain,
  classToPlainFromExist,
  plainToInstance,
  plainToClassFromExist,
} from 'class_transformer';
import { defaultMetadataStorage } from 'class_transformer';
import { Exclude, Expose, Type, Transform } from 'class_transformer';
import { describe,it as _it,expect } from "../utils/utils";
export default function es6_data_typesTest() {
  describe('es6_data_typesTest', function () {
    _it('using Map', () => {
      defaultMetadataStorage.clear();

      class User {
        id: number;
        name: string;
        @Type(() => String)
        weapons: Map<string, string>;
      }

      const plainUser = {
        id: 1,
        name: 'Max Pain',
        weapons: {
          firstWeapon: 'knife',
          secondWeapon: 'eagle',
          thirdWeapon: 'ak-47',
        },
      };

      const weapons = new Map<string, string>();
      weapons.set('firstWeapon', 'knife');
      weapons.set('secondWeapon', 'eagle');
      weapons.set('thirdWeapon', 'ak-47');

      const user = new User();
      user.id = 1;
      user.name = 'Max Pain';
      user.weapons = weapons;

      const classedUser = plainToInstance(User, plainUser);
      expect(classedUser).toBeInstanceOf(User);
      console.log(`aa---1`)
      expect(classedUser.id).toEqual(1);
      console.log(`aa---2`)

      expect(classedUser.name).toEqual('Max Pain');
      console.log(`aa---3  classedUser.weapons.size ${classedUser.weapons.size}`)
    });

    _it('using Set', () => {
      defaultMetadataStorage.clear();

      class User {
        id: number;
        name: string;
        @Type(() => Set)
        weapons: Set<string>;
      }

      const plainUser = {
        id: 1,
        name: 'Max Pain',
        weapons: ['knife', 'eagle', 'ak-47'],
      };

      const weapons = new Set<string>();
      weapons.add('knife');
      weapons.add('eagle');
      weapons.add('ak-47');

      const user = new User();
      user.id = 1;
      user.name = 'Max Pain';
      user.weapons = weapons;

      const classedUser = plainToInstance(User, plainUser);
      expect(classedUser).toBeInstanceOf(User);


    });

  })
}