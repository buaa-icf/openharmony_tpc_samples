/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from './util'
import getDecorators from "inversify-inject-decorators/es/index";
import { Container, injectable, tagged, named } from 'inversify';
import "reflect-metadata"
export default function injectTest() {

  let TYPES = {
    Weapon: Symbol.for("Weapon")
  };

  interface Weapon {
    name: string;
    durability: number;
    use(): void;
  }

  @injectable()
  class Sword implements Weapon {
    public name: string;
    public durability: number;
    public constructor() {
      this.durability = 100;
      this.name = "Sword";
    }
    public use() {
      this.durability = this.durability - 10;
    }
  }

  @injectable()
  class Shuriken implements Weapon {
    public name: string;
    public durability: number;
    public constructor() {
      this.durability = 100;
      this.name = "Shuriken";
    }
    public use() {
      this.durability = this.durability - 10;
    }
  }

  describe('InjectTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    _it("Should support named constraints", () => {


      let container = new Container();

      let {
        lazyInjectNamed,
      } = getDecorators(container);

      class Warrior {

        @lazyInjectNamed(TYPES.Weapon, "not-throwwable")
        @named("not-throwwable")
        public primaryWeapon: Weapon;

        @lazyInjectNamed(TYPES.Weapon, "throwwable")
        @named("throwwable")
        public secondaryWeapon: Weapon;

      }

      container.bind<Weapon>(TYPES.Weapon).to(Sword).whenTargetNamed("not-throwwable");
      container.bind<Weapon>(TYPES.Weapon).to(Shuriken).whenTargetNamed("throwwable");

      let warrior1 = new Warrior();

      expect(warrior1.primaryWeapon).to.be.instanceof(Sword);
      expect(warrior1.secondaryWeapon).to.be.instanceof(Shuriken);

    });


    _it("Should support tagged constraints", () => {

      let container = new Container();

      let {
        lazyInjectTagged
      } = getDecorators(container);

      class Warrior {

        @lazyInjectTagged(TYPES.Weapon, "throwwable", false)
        @tagged("throwwable", false)
        public primaryWeapon: Weapon;

        @lazyInjectTagged(TYPES.Weapon, "throwwable", true)
        @tagged("throwwable", true)
        public secondaryWeapon: Weapon;

      }

      container.bind<Weapon>(TYPES.Weapon).to(Sword).whenTargetTagged("throwwable", false);
      container.bind<Weapon>(TYPES.Weapon).to(Shuriken).whenTargetTagged("throwwable", true);

      let warrior1 = new Warrior();
      expect(warrior1.primaryWeapon).to.be.instanceof(Sword);
      expect(warrior1.secondaryWeapon).to.be.instanceof(Shuriken);

    });

    _it("Should support multi injections", () => {

      let container = new Container();

      let {
        lazyMultiInject
      } = getDecorators(container);

      class Warrior {

        @lazyMultiInject(TYPES.Weapon)
        public weapons: Weapon[];

      }

      container.bind<Weapon>(TYPES.Weapon).to(Sword).whenTargetTagged("throwwable", false);
      container.bind<Weapon>(TYPES.Weapon).to(Shuriken).whenTargetTagged("throwwable", true);

      let warrior1 = new Warrior();
      expect(warrior1.weapons[0]).to.be.instanceof(Sword);
      expect(warrior1.weapons[1]).to.be.instanceof(Shuriken);

    });

    _it("Should NOT break the property setter", () => {

      let container = new Container();

      let {
        lazyInject
      } = getDecorators(container);

      class Warrior {
        @lazyInject(TYPES.Weapon)
        public weapon: Weapon;
      }

      container.bind<Weapon>(TYPES.Weapon).to(Sword);

      let warrior1 = new Warrior();
      expect(warrior1.weapon).to.be.instanceof(Sword);
      warrior1.weapon = new Shuriken();
      expect(warrior1.weapon).to.be.instanceof(Shuriken);

      let warrior2 = new Warrior();
      warrior2.weapon = new Shuriken();
      expect(warrior2.weapon).to.be.instanceof(Shuriken);

    });


  })
}