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
import { fluentProvide } from "inversify-binding-decorators/es/index";
import "reflect-metadata";

export default function fluentProvideTest() {
    describe("fluentProvide", function() {
        _it("Should throw if @provideFluent is applied more than once without force flag", () => {

            const provideSingleton = (identifier: any) => {
                return fluentProvide(identifier)
                    .inSingletonScope()
                    .done();
            };

            function shouldThrow() {
                @provideSingleton("Ninja")
                @provideSingleton("SilentNinja")
                class Ninja {
                }
                return Ninja;
            }

            expect(shouldThrow).to.throw(
                "Cannot apply @provideFluent decorator multiple times but is has been used " +
                "multiple times in Ninja " +
                "Please use done(true) if you are trying to declare multiple bindings!"
            );

        });

        _it("Should work if @provide is applied more than once with force flag", () => {

            const provideSingleton = (identifier: any) => {
                return fluentProvide(identifier)
                    .inSingletonScope()
                    .done(true); // IMPORTANT!
            };

            function shouldThrow() {
                @provideSingleton("Ninja")
                @provideSingleton("SilentNinja")
                class Ninja {
                }
                return Ninja;
            }

            expect(shouldThrow).not.to.throw();

        });

    });

}
