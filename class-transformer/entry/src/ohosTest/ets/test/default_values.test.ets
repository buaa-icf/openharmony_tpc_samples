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
  plainToInstance,
} from 'class_transformer';
import { Expose, Transform } from 'class_transformer';
import { describe,it as _it,expect } from "../utils/utils";
export default function default_valuesTest() {
  describe('default_valuesTest', function () {
    class User {
      @Expose({ name: 'AGE' })
      @Transform(({ value }) => parseInt(value, 10))
      age: number;

      @Expose({ name: 'AGE_WITH_DEFAULT' })
      @Transform(({ value }) => parseInt(value, 10))
      ageWithDefault?: number = 18;

      @Expose({ name: 'FIRST_NAME' })
      firstName: string;

      @Expose({ name: 'FIRST_NAME_WITH_DEFAULT' })
      firstNameWithDefault?: string = 'default first name';

      @Transform(({ value }) => !!value)
      admin: boolean;

      @Transform(({ value }) => !!value)
      adminWithDefault?: boolean = false;

      lastName: string;

      lastNameWithDefault?: string = 'default last name';
    }

    _it('should set default value if nothing provided', () => {
      const fromPlainUser = {};
      const transformedUser = plainToInstance(User, fromPlainUser, { exposeDefaultValues: true });

      expect(transformedUser).toBeInstanceOf(User);

    });

    _it('should take exposed values and ignore defaults', () => {
      const fromPlainUser = {};
      const transformedUser = plainToInstance(User, fromPlainUser);

      expect(transformedUser).toBeInstanceOf(User);

    });
  })
}