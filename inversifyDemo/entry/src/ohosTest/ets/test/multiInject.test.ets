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
import { decorate, multiInject } from 'inversify';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '../utils/util'

export default function multiInjectTest() {
  interface Weapon { }

  class InvalidDecoratorUsageWarrior {

    private _primaryWeapon: Weapon;
    private _secondaryWeapon: Weapon;

    public constructor(
      weapons: Weapon[]
    ) {
      this._primaryWeapon = weapons[0] as Weapon;
      this._secondaryWeapon = weapons[1] as Weapon;
    }

    public test(a: string) { /*...*/ }

    public debug() {
      interface result1{
        primaryWeapon: Weapon;
        secondaryWeapon: Weapon;
      }
      let results1:result1= {
        primaryWeapon: this._primaryWeapon,
        secondaryWeapon: this._secondaryWeapon
      };
      return results1
    }

  }
  describe('multiInjectTest',  ()=> {
    _it('Should_throw_when_applied_multiple_times', () => {
      const useDecoratorMoreThanOnce: () => void = () => {
        decorate(
          [multiInject('Katana'), multiInject('Shuriken')],
          InvalidDecoratorUsageWarrior,
          0,
        );
      };

      const msg: string = `Unexpected injection error.

Cause:

Unexpected injection found. Multiple @inject, @multiInject or @unmanaged decorators found

Details

[class: "InvalidDecoratorUsageWarrior", index: "0"]`;
      expect(useDecoratorMoreThanOnce).to.throw(msg);
    });
  })
}