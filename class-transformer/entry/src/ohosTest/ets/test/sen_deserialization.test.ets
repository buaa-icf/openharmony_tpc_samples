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

  serialize,
  deserialize,
  deserializeArray
} from 'class_transformer';
import { defaultMetadataStorage } from 'class_transformer';
import { Exclude, Expose, Type, Transform } from 'class_transformer';
import { describe,it as _it,expect } from "../utils/utils";

export default function sen_deserializationTest() {
  describe('sen_deserializationTest', function () {
    _it('should perform serialization and deserialization properly', () => {
      defaultMetadataStorage.clear();

      class User {
        firstName: string;
        lastName: string;
        @Exclude()
        password: string;
      }

      const user = new User();
      user.firstName = 'Umed';
      user.lastName = 'Khudoiberdiev';
      user.password = 'imnosuperman';

      const user1 = new User();
      user1.firstName = 'Dima';
      user1.lastName = 'Zotov';
      user1.password = 'imnosuperman';

      const user2 = new User();
      user2.firstName = 'Bakhrom';
      user2.lastName = 'Baubekov';
      user2.password = 'imnosuperman';

      const users = [user1, user2];
      const plainUser = {
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
        password: 'imnosuperman',
      };

      const plainUsers = [
        {
          firstName: 'Dima',
          lastName: 'Zotov',
          password: 'imnobatman',
        },
        {
          firstName: 'Bakhrom',
          lastName: 'Baubekov',
          password: 'imnosuperman',
        },
      ];

      const plainedUser = serialize(user);
      expect(plainedUser).toEqual(
        JSON.stringify({
          firstName: 'Umed',
          lastName: 'Khudoiberdiev',
        })
      );

      const plainedUsers = serialize(users);
      expect(plainedUsers).toEqual(
        JSON.stringify([
          {
            firstName: 'Dima',
            lastName: 'Zotov',
          },
          {
            firstName: 'Bakhrom',
            lastName: 'Baubekov',
          },
        ])
      );

      const classedUser = deserialize(User, JSON.stringify(plainUser));
      expect(classedUser).toBeInstanceOf(User);
      expect(classedUser).toEqual({
        firstName: 'Umed',
        lastName: 'Khudoiberdiev',
      });

      const classedUsers = deserializeArray(User, JSON.stringify(plainUsers));
      expect(classedUsers[0]).toBeInstanceOf(User);
      expect(classedUsers[1]).toBeInstanceOf(User);

      const userLike1 = new User();
      userLike1.firstName = 'Dima';
      userLike1.lastName = 'Zotov';

      const userLike2 = new User();
      userLike2.firstName = 'Bakhrom';
      userLike2.lastName = 'Baubekov';

      expect(classedUsers).toEqual([userLike1, userLike2]);
    });

    _it('should successfully deserialize object with unknown nested properties ', () => {
      defaultMetadataStorage.clear();

      class TestObject {
        prop: string;
      }

      const payload = {
        prop: 'Hi',
        extra: {
          anotherProp: "let's see how this works out!",
        },
      };

      const result = deserialize(TestObject, JSON.stringify(payload));
      expect(result).toBeInstanceOf(TestObject);
      expect(result.prop).toEqual('Hi');
      // TODO: We should strip, but it's a breaking change
      // (<any>result).extra.should.be.undefined;
    });

    _it('should not overwrite non writable properties on deserialize', () => {
      class TestObject {
        get getterOnlyProp(): string {
          return 'I cannot write!';
        }

        normalProp: string = 'Hello!';
      }

      const payload = {
        getterOnlyProp: 'I CAN write!',
        normalProp: 'Goodbye!',
      };

      const result = deserialize(TestObject, JSON.stringify(payload));
      expect(result.getterOnlyProp).toEqual('I cannot write!');
      expect(result.normalProp).toEqual('Goodbye!');
    });
  })
}