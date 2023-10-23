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
import { defaultMetadataStorage } from 'class_transformer';
import {  Type, Transform } from 'class_transformer';
import { describe,it as _it,expect } from "../utils/utils";

export default function inheritenceTest() {
  describe('inheritenceTest', function () {
    _it('decorators should work inside a base class', () => {
      defaultMetadataStorage.clear();

      class Contact {
        @Transform(({ value }) => value.toUpperCase())
        name: string;
        @Type(() => Date)
        birthDate: Date;
      }

      class User extends Contact {
        @Type(() => Number)
        id: number;
        email: string;
      }

      class Student extends User {
        @Transform(({ value }) => value.toUpperCase())
        university: string;
      }

      const plainStudent = {
        name: 'Johny Cage',
        university: 'mit',
        birthDate: new Date(1967, 2, 1).toDateString(),
        id: 100,
        email: 'johnny.cage@gmail.com',
      };

      const classedStudent = plainToInstance(Student, plainStudent);
      expect(classedStudent.name).toEqual('JOHNY CAGE');
      expect(classedStudent.university).toEqual('MIT');
      expect(classedStudent.birthDate.getTime()).toEqual(new Date(1967, 2, 1).getTime());
      expect(classedStudent.id).toEqual(plainStudent.id);
      expect(classedStudent.email).toEqual(plainStudent.email);
    });
  })
}