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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '../utils/util'
import { decorate, injectable } from 'inversify';

export default function injectableTest() {
  describe('injectableTest',  ()=> {
    _it('Should_throw_when_applied_multiple_times', () => {
      @injectable()
      class Test {}

      const useDecoratorMoreThanOnce: () => void = () => {
        decorate([injectable(), injectable()], Test);
      };
      expect(useDecoratorMoreThanOnce).to.throw(
        'Cannot apply @injectable decorator multiple times',
      );
    });
  })
}