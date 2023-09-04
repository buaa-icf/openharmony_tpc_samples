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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '../util'
import { Container } from 'inversify';
import { buildProviderModule } from "inversify-binding-decorators/es/index";
import "reflect-metadata";
import { autoProvide } from "inversify-binding-decorators/es/index";
import { METADATA_KEY } from "inversify-binding-decorators/es/constants";
import * as entites from "../stubs/entities";


export default function autoWireTest() {

  describe("autoProvide", function () {

    beforeEach(() => {
      Reflect.deleteMetadata(METADATA_KEY.provide, Reflect);
    });
    _it("Should be able to auto-wire binding declarations", () => {

      let container = new Container();
      // Note @inject annotations are required autoProvide
      // even when using classes are used as identifiers
      // See declaration of Warrior for more details
      autoProvide(container, entites);
      container.load(buildProviderModule());
      let warrior = container.get(entites.Warrior);
      expect(warrior.fight()).eql("Using Katana...");

    });

  })

}
