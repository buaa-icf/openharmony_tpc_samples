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
import { Container, injectable, interfaces } from "inversify";

export default function resolve_unbindedTest() {
  describe('resolve_unbindedTest', function () {
    _it("Should_be_able_to_resolve_a_class_that_has_not_binded", () => {

      @injectable()
      class Katana {
        public h_it() {
          return "cut!";
        }
      }

      @injectable()
      @Reflect.metadata("design:paramtypes",[Katana])
      class Ninja implements Ninja {
        public katana: Katana;
        public constructor(katana: Katana) {
          this.katana = katana;
        }
        public fight() { return this.katana.h_it(); }
      }

      const container = new Container();
      container.bind(Katana).toSelf();

      const tryGet = () => container.get(Ninja);
      expect(tryGet).to.throw("No matching bindings found for serviceIdentifier: Ninja");

      const ninja = container.resolve(Ninja);
      expect(ninja.fight()).to.eql("cut!");
      expect(container.isBound(Ninja)).to.equal(false);

    });

    _it("Should_be_able_to_resolve_a_class_that_has_already_been_bound", () => {
      @injectable()
      class Katana {
        public h_it() {
          return "cut!";
        }
      }

      @injectable()
      @Reflect.metadata("design:paramtypes",[Katana])
      class Ninja implements Ninja {
        public katana: Katana;
        public constructor(katana: Katana) {
          this.katana = katana;
        }
        public fight() { return this.katana.h_it(); }
      }

      const container = new Container();
      container.bind(Katana).toSelf();
      container.bind(Ninja).toSelf();

      const ninja = container.resolve(Ninja);
      expect(ninja.fight()).to.eql("cut!");
    })


  })
}