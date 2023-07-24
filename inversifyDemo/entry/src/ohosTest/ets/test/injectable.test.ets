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
import "reflect-metadata"
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '../utils/util'
import * as ERRORS_MSGS from 'inversify/lib/constants/error_msgs';
import * as METADATA_KEY from 'inversify/lib/constants/metadata_keys';
import { decorate, injectable } from 'inversify';
export default function injectableTest() {
  describe('injectableTest', function () {
    _it('Should_generate_metadata_if_declared_injections', () => {

      class Katana { }

      interface Weapon { }

      @injectable()
      @Reflect.metadata("design:paramtypes",[Katana,Object])
      class Warrior {

        private _primaryWeapon: Katana;
        private _secondaryWeapon: Weapon;

        public constructor(primaryWeapon: Katana, secondaryWeapon: Weapon) {
          this._primaryWeapon = primaryWeapon;
          this._secondaryWeapon = secondaryWeapon;
        }

        public debug() {
          return {
            primaryWeapon: this._primaryWeapon,
            secondaryWeapon: this._secondaryWeapon
          };
        }

      }

      const metadata = Reflect.getMetadata(METADATA_KEY.PARAM_TYPES, Warrior);
      expect(metadata).to.be.instanceof(Array);
      expect(metadata.length).to.be.eql(2)
      expect(metadata[0]).to.be.eql(Katana);
      expect(metadata[1]).to.be.eql(Object);
      expect(metadata[2]).to.eq(undefined);
    });

    _it('Should_throw_when_applied_multiple_times', () => {

      @injectable()
      class Test { }

      const useDecoratorMoreThanOnce = function () {
        decorate(injectable(), Test);
        decorate(injectable(), Test);
      };

      expect(useDecoratorMoreThanOnce).to.throw(ERRORS_MSGS.DUPLICATED_INJECTABLE_DECORATOR);
    });

    _it('Should_be_usable_in_VanillaJS_applications', () => {

      interface Katana { }
      interface Shuriken { }

      const VanillaJSWarrior = function (primary: Katana, secondary: Shuriken) {
        // ...
      };

      decorate(injectable(), VanillaJSWarrior);

      const metadata = Reflect.getMetadata(METADATA_KEY.PARAM_TYPES, VanillaJSWarrior);
      expect(metadata).to.be.instanceof(Array);
      expect(metadata.length).to.eql(0);

    });
  })
}