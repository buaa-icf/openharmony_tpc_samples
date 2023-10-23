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

export default function transformation_optionSpecTest() {
  describe('transformation_optionSpecTest', function () {
    _it('@Exclude with toPlainOnly set to true then it should be excluded only during instanceToPlain and classToPlainFromExist operations', () => {
      defaultMetadataStorage.clear();

      class User {
        id: number;
        firstName: string;
        lastName: string;

        @Exclude({ toPlainOnly: true })
        password: string;
      }

      const user = new User();
      user.firstName = 'Umed';
      user.lastName = 'Khudoiberdiev';
      user.password = 'imnosuperman';

      const plainUser = {
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
        password: 'imnosuperman',
      };

      const plainedUser = instanceToPlain(user);
      expect(plainedUser).toEqual({
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
      });

      const classedUser = plainToInstance(User, plainUser);
      expect(classedUser).toBeInstanceOf(User);
      expect(classedUser).toEqual({
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
        password: 'imnosuperman',
      });
    });

    _it('@Exclude with toClassOnly set to true then it should be excluded only during plainToInstance and plainToClassFromExist operations', () => {
      defaultMetadataStorage.clear();

      class User {
        id: number;
        firstName: string;
        lastName: string;

        @Exclude({ toClassOnly: true })
        password: string;
      }

      const user = new User();
      user.firstName = 'Umed';
      user.lastName = 'Khudoiberdiev';
      user.password = 'imnosuperman';

      const plainUser = {
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
        password: 'imnosuperman',
      };

      const classedUser = plainToInstance(User, plainUser);
      expect(classedUser).toBeInstanceOf(User);
      expect(classedUser).toEqual({
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
      });

      const plainedUser = instanceToPlain(user);
      expect(plainedUser).toEqual({
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
        password: 'imnosuperman',
      });
    });

    _it('@Expose with toClassOnly set to true then it should be excluded only during instanceToPlain and classToPlainFromExist operations', () => {
      defaultMetadataStorage.clear();

      @Exclude()
      class User {
        @Expose()
        firstName: string;

        @Expose()
        lastName: string;

        @Expose({ toClassOnly: true })
        password: string;
      }

      const user = new User();
      user.firstName = 'Umed';
      user.lastName = 'Khudoiberdiev';
      user.password = 'imnosuperman';

      const plainUser = {
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
        password: 'imnosuperman',
      };

      const plainedUser = instanceToPlain(user);
      expect(plainedUser).toEqual({
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
      });

      const classedUser = plainToInstance(User, plainUser);
      expect(classedUser).toBeInstanceOf(User);
      expect(classedUser).toEqual({
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
        password: 'imnosuperman',
      });
    });

    _it('@Expose with toPlainOnly set to true then it should be excluded only during instanceToPlain and classToPlainFromExist operations', () => {
      defaultMetadataStorage.clear();

      @Exclude()
      class User {
        @Expose()
        firstName: string;

        @Expose()
        lastName: string;

        @Expose({ toPlainOnly: true })
        password: string;
      }

      const user = new User();
      user.firstName = 'Umed';
      user.lastName = 'Khudoiberdiev';
      user.password = 'imnosuperman';

      const plainUser = {
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
        password: 'imnosuperman',
      };

      const plainedUser = instanceToPlain(user);
      expect(plainedUser).toEqual({
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
        password: 'imnosuperman',
      });

      const classedUser = plainToInstance(User, plainUser);
      expect(classedUser).toBeInstanceOf(User);
      expect(classedUser).toEqual({
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
      });
    });

    _it('should ignore undefined properties when exposeUnsetFields is set to false during class to plain', () => {
      defaultMetadataStorage.clear();

      @Exclude()
      class User {
        @Expose()
        firstName: string;

        @Expose()
        lastName: string;
      }

      expect(instanceToPlain(new User(), { exposeUnsetFields: false })).toEqual({});
      expect(instanceToPlain(new User(), { exposeUnsetFields: true })).toEqual({
        firstName: undefined,
        lastName: undefined,
      });

      const classedUser = plainToInstance(User, { exposeUnsetFields: false });
      expect(classedUser).toBeInstanceOf(User);
      expect(classedUser).toEqual({
        firstName: undefined,
        lastName: undefined,
      });
    });
  })
}