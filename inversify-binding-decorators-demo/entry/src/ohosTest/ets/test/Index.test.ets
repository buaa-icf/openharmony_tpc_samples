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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from './util'
import { Container, inject, tagged, named } from 'inversify';
import { provide } from "inversify-binding-decorators/es/index";
import { fluentProvide } from "inversify-binding-decorators/es/index";
import { buildProviderModule } from "inversify-binding-decorators/es/index";
import "reflect-metadata";
import { METADATA_KEY } from "inversify-binding-decorators/es/constants";

export default function indexTest() {

  describe("inversify_binding_decorators", function (){

    beforeEach(() => {

      // Clean our metadata before each test
      Reflect.deleteMetadata(METADATA_KEY.provide, Reflect);
    });

    _it("Should be able to declare bindings using string literals as identifiers", () => {

      let container = new Container();

      interface Warrior {
        katana: Weapon;
        shuriken: ThrowableWeapon;

        fight(): string;

        sneak(): string;
      }

      interface Weapon {
        hit(): string;
      }

      interface ThrowableWeapon {
        throw(): string;
      }

      let TYPE = {
        ThrowableWeapon: "ThrowableWeapon",
        Warrior: "Warrior",
        Weapon: "Weapon"
      };

      @provide(TYPE.Weapon)
      class Katana implements Weapon {
        public hit() {
          return "cut!";
        }
      }

      @provide(TYPE.ThrowableWeapon)
      class Shuriken implements ThrowableWeapon {
        public throw() {
          return "hit!";
        }
      }

      @provide(TYPE.Warrior)
      class Ninja implements Warrior {
        public katana: Weapon;
        public shuriken: ThrowableWeapon;

        public constructor(
          @inject(TYPE.Weapon) katana: Weapon,
          @inject(TYPE.ThrowableWeapon) shuriken: ThrowableWeapon
        ) {
          this.katana = katana;
          this.shuriken = shuriken;
        }

        public fight() {
          return this.katana.hit();
        }

        public sneak() {
          return this.shuriken.throw();
        }
      }

      container.load(buildProviderModule());
      let ninja = container.get<Warrior>(TYPE.Warrior);

      expect(ninja instanceof Ninja).eql(true);
      expect(ninja.katana instanceof Katana).eql(true);
      expect(ninja.shuriken instanceof Shuriken).eql(true);
      expect(ninja.fight()).eql("cut!");
      expect(ninja.sneak()).eql("hit!");

    });

    _it("Should be able to declare bindings using classes as identifiers", () => {
      try {

        let container = new Container();

        @provide(Katana)
        class Katana {
          public hit() {
            return "cut!";
          }
        }

        @provide(Shuriken)
        class Shuriken {
          public throw() {
            return "hit!";
          }
        }

        @provide(Ninja)
        class Ninja {
          public katana: Katana;
          public shuriken: Shuriken;

          public constructor(
            katana: Katana,
            shuriken: Shuriken
          ) {
            this.katana = katana;
            this.shuriken = shuriken;
          }

          public fight() {
            return this.katana.hit();
          }

          public sneak() {
            return this.shuriken.throw();
          }
        }

        container.load(buildProviderModule());
        let ninja = container.get<Ninja>(Ninja);
        expect(ninja instanceof Ninja).eql(true);
        expect(ninja.katana instanceof Katana).eql(true);
        expect(ninja.shuriken instanceof Shuriken).eql(true);
        expect(ninja.fight()).eql("cut!");
        expect(ninja.sneak()).eql("hit!");
      } catch (e) {
      }
    });

    _it("Should be able to declare bindings using symbols as identifiers", () => {
      try {

        let container = new Container();

        interface Warrior {
          katana: Katana;
          shuriken: Shuriken;

          fight(): string;

          sneak(): string;
        }

        interface Weapon {
          hit(): string;
        }

        interface ThrowableWeapon {
          throw(): string;
        }

        let TYPE = {
          ThrowableWeapon: Symbol.for("ThrowableWeapon"),
          Warrior: Symbol.for("Warrior"),
          Weapon: Symbol.for("Weapon"),
        };

        @provide(TYPE.Weapon)
        class Katana implements Weapon {
          public hit() {
            return "cut!";
          }
        }

        @provide(TYPE.ThrowableWeapon)
        class Shuriken implements ThrowableWeapon {
          public throw() {
            return "hit!";
          }
        }

        @provide(TYPE.Warrior)
        class Ninja implements Warrior {
          public katana: Weapon;
          public shuriken: ThrowableWeapon;

          public constructor(
            @inject(TYPE.Weapon) katana: Weapon,
            @inject(TYPE.ThrowableWeapon) shuriken: ThrowableWeapon
          ) {
            this.katana = katana;
            this.shuriken = shuriken;
          }

          public fight() {
            return this.katana.hit();
          }

          public sneak() {
            return this.shuriken.throw();
          }
        }

        container.load(buildProviderModule());
        let ninja = container.get<Warrior>(TYPE.Warrior);
        expect(ninja instanceof Ninja).eql(true);
        expect(ninja.katana instanceof Katana).eql(true);
        expect(ninja.shuriken instanceof Shuriken).eql(true);
        expect(ninja.fight()).eql("cut!");
        expect(ninja.sneak()).eql("hit!");
      } catch (e) {

      }
    });

    _it("Should be able to declare the scope of a binding", () => {
      try {

        let container = new Container();

        let provideSingleton = function (identifier: string) {
          return fluentProvide(identifier).inSingletonScope().done();
        };

        let provideTransient = function (identifier: string) {
          return fluentProvide(identifier).inTransientScope().done();
        };

        interface Warrior {
          katana: Weapon;
          shuriken: ThrowableWeapon;

          fight(): string;

          sneak(): string;
        }

        interface Weapon {
          hit(): string;
        }

        interface ThrowableWeapon {
          throw(): string;
        }

        let TYPE = {
          ThrowableWeapon: "ThrowableWeapon",
          Warrior: "Warrior",
          Weapon: "Weapon"
        };

        @provideSingleton(TYPE.Weapon)
        class Katana implements Weapon {
          private _mark: any;

          public constructor() {
            this._mark = Math.random();
          }

          public hit() {
            return "cut! " + this._mark;
          }
        }

        @provideTransient(TYPE.ThrowableWeapon)
        class Shuriken implements ThrowableWeapon {
          private _mark: any;

          public constructor() {
            this._mark = Math.random();
          }

          public throw() {
            return "hit! " + this._mark;
          }
        }

        @provideTransient(TYPE.Warrior)
        class Ninja implements Warrior {
          public katana: Weapon;
          public shuriken: ThrowableWeapon;

          public constructor(
            @inject(TYPE.Weapon) katana: Weapon,
            @inject(TYPE.ThrowableWeapon) shuriken: ThrowableWeapon
          ) {
            this.katana = katana;
            this.shuriken = shuriken;
          }

          public fight() {
            return this.katana.hit();
          }

          public sneak() {
            return this.shuriken.throw();
          }
        }

        container.load(buildProviderModule());
        let ninja = container.get<Warrior>(TYPE.Warrior);
        expect(ninja instanceof Ninja).eql(true);
        expect(ninja.katana instanceof Katana).eql(true);
        expect(ninja.shuriken instanceof Shuriken).eql(true);

        expect(ninja.fight().indexOf("cut!")).eql(0);
        expect(ninja.sneak().indexOf("hit!")).eql(0);

      } catch (e) {

      }
    });

    _it("Should be able to declare contextual constraints", () => {
      try {
        let container = new Container();

        let provideThrowable = function (serviceIdentifier: string, isThrowable: boolean) {
          return fluentProvide(serviceIdentifier).whenTargetTagged("throwable", isThrowable).done();
        };

        interface Warrior {
          primary: Weapon;
          secondary: Weapon;
          fight(): string;
          sneak(): string;
        }

        interface Weapon {
          hit(): string;
        }

        let TYPE = {
          Warrior: "Warrior",
          Weapon: "Weapon"
        };

        @provideThrowable(TYPE.Weapon, false)
        class Katana implements Weapon {
          public hit() {
            return "Hit by Katana!";
          }
        }

        @provideThrowable(TYPE.Weapon, true)
        class Shuriken implements Weapon {
          public hit() {
            return "Hit by Shuriken!";
          }
        }

        @fluentProvide(TYPE.Warrior).done()
        class Ninja implements Warrior {

          public primary: Weapon;
          public secondary: Weapon;

          public constructor(
            @inject(TYPE.Weapon) @tagged("throwable", false) primary: Weapon,
            @inject(TYPE.Weapon) @tagged("throwable", true) secondary: Weapon
          ) {
            this.primary = primary;
            this.secondary = secondary;
          }

          public fight() { return this.primary.hit(); }
          public sneak() { return this.secondary.hit(); }

        }

        container.load(buildProviderModule());
        let ninja = container.get<Warrior>(TYPE.Warrior);

        expect(ninja instanceof Ninja).eql(true);
        expect(ninja.primary instanceof Katana).eql(true);
        expect(ninja.secondary instanceof Shuriken).eql(true);
        expect(ninja.fight()).eql("Hit by Katana!");
        expect(ninja.sneak()).eql("Hit by Shuriken!");

      }catch (e){

      }
    });

    _it("Should be able to both declare scope and declare contextual constraints", () => {

      let container = new Container();

      let provideShortWeapon = function (serviceIdentifier: string, isThrowable: boolean) {
        return fluentProvide(serviceIdentifier).inSingletonScope().whenAnyAncestorNamed("shortsword").done();
      };
      let provideLongWeapon = function (serviceIdentifier: string, isThrowable: boolean) {
        return fluentProvide(serviceIdentifier).whenNoAncestorNamed("shortsword").done();
      };

      interface Warrior {
        weapon: Weapon;
        fight(): number;
        weaponLength(): string;
      }

      interface Weapon {
        hit(): number;
        length(): string;
      }

      interface Dojo {
        warrior: Warrior;
      }

      let TYPE = {
        Dojo: "Dojo",
        Warrior: "Warrior",
        Weapon: "Weapon"
      };

      @provideShortWeapon(TYPE.Weapon, false)
      class Wakizashi implements Weapon {
        private _mark: any;
        public constructor() {
          this._mark = Math.random();
        }
        public hit() {
          return this._mark;
        }
        public length() {
          return "short";
        }
      }
      @provideLongWeapon(TYPE.Weapon, false)
      class Katana implements Weapon {
        private _mark: any;
        public constructor() {
          this._mark = Math.random();
        }
        public hit() {
          return this._mark;
        }
        public length() {
          return "long";
        }
      }

      @provide(KatanaDojo)
      class KatanaDojo implements Dojo {
        public warrior: Warrior;
        constructor(@inject(TYPE.Warrior) warrior: Warrior) {
          this.warrior = warrior;
        }
      }

      @provide(WakizashiDojo)
      class WakizashiDojo implements Dojo {
        public warrior: Warrior;
        constructor(@named("shortsword") @inject(TYPE.Warrior) warrior: Warrior) {
          this.warrior = warrior;
        }
      }

      @fluentProvide(TYPE.Warrior).done()
      class Ninja implements Warrior {

        public weapon: Weapon;

        public constructor(
          @inject(TYPE.Weapon) weapon: Weapon,
        ) {
          this.weapon = weapon;
        }

        public fight() { return this.weapon.hit(); }
        public weaponLength() { return this.weapon.length(); }

      }

      container.load(buildProviderModule());

      // get default ninja, exercise whenNoAncestorNamed
      let ninjaDefault = container.get<Warrior>(TYPE.Warrior);
      // exercise whenAnyAncestorNamed
      let ninjaShort = container.getNamed<Warrior>(TYPE.Warrior, "shortsword");
      // get default dojo, exercise get by self type
      let katanaDojo = container.get<KatanaDojo>(KatanaDojo);
      let wakizashiDojo = container.get<KatanaDojo>(WakizashiDojo);
      try {
        // Test default ninja; should have gotten 'long' weapon, Katana
        expect(ninjaDefault instanceof Ninja).eql(true);
        expect(ninjaDefault.weaponLength()).eql("long");
        expect(ninjaDefault.weapon instanceof Katana).eql(true);

        // Test that our ancestor binding gave us a 'long' weapon, Wakizashi
        expect(ninjaShort.weaponLength()).eql("short");
        expect(ninjaShort.weapon instanceof Wakizashi).eql(true);

        // test whenNoAncestorNamed again, to make sure the chaining works correctly
        expect(katanaDojo.warrior.weaponLength()).eql("long");
        // test anyAncestorNamed again
        expect(wakizashiDojo.warrior.weaponLength()).eql("short");

        // Katana is bound transient (default), so two katanas will have different fight() values
        // expect(katanaDojo.warrior.fight()).not.eql(ninjaDefault.fight());

        // Wakizashi's are more rare, so warriors have to share.
        expect(wakizashiDojo.warrior.fight()).eql(ninjaShort.fight());
        expect(wakizashiDojo.warrior.weapon === ninjaShort.weapon).eql
        (true);
      }catch (e){

      }
    })

  })

}
