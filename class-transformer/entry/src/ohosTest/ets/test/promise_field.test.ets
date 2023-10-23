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
  instanceToPlain,
  plainToInstance,
} from 'class_transformer';
import { defaultMetadataStorage } from 'class_transformer';
import { Type } from 'class_transformer';
import { describe,it as _it,expect } from "../utils/utils";

export default function promise_fieldTest() {
  describe('promise_fieldTest', function () {
    _it('should transform plan to class with promise field', async () => {
      defaultMetadataStorage.clear();

      class PromiseClass {
        promise: Promise<string>;
      }

      const plain = {
        promise: Promise.resolve('hi'),
      };

      const instance = plainToInstance(PromiseClass, plain);
      expect(instance.promise).toBeInstanceOf(Promise);
      const value = await instance.promise;
      expect(value).toBe('hi');
    });

    _it('should transform class with promise field to plain', async () => {
      class PromiseClass {
        promise: Promise<string>;

        constructor(promise: Promise<any>) {
          this.promise = promise;
        }
      }

      const instance = new PromiseClass(Promise.resolve('hi'));
      const plain = instanceToPlain(instance) as any;
      expect(plain).toHaveProperty('promise');
      const value = await plain.promise;
      expect(value).toBe('hi');
    });

    _it('should clone promise result', async () => {
      defaultMetadataStorage.clear();

      class PromiseClass {
        promise: Promise<string[]>;
      }

      const array = ['hi', 'my', 'name'];
      const plain = {
        promise: Promise.resolve(array),
      };

      const instance = plainToInstance(PromiseClass, plain);
      const value = await instance.promise;
      expect(value).toEqual(array);

      // modify transformed array to prove it's not referencing original array
      value.push('is');
      expect(value).not.toEqual(array);
    });

    _it('should support Type decorator', async () => {
      class PromiseClass {
        @Type(() => InnerClass)
        promise: Promise<InnerClass>;
      }

      class InnerClass {
        position: string;

        constructor(position: string) {
          this.position = position;
        }
      }

      const plain = {
        promise: Promise.resolve(new InnerClass('developer')),
      };

      const instance = plainToInstance(PromiseClass, plain);
      const value = await instance.promise;
      expect(value).toBeInstanceOf(InnerClass);
      expect(value.position).toBe('developer');
    });
  })
}