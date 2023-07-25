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

import { provide } from 'inversify-binding-decorators/es/index';
import { it as _it, afterAll, afterEach, beforeAll, beforeEach, describe, expect } from '../util'
import "reflect-metadata";

export default function provideTest() {

    describe("provide", function() {


        beforeEach(() => {
        });

        afterEach(() => {
        });
        _it("Should return target type", () => {

            class Ninja {
            }
            const provided = provide(Ninja);
            expect(typeof provided).eqls("function");

        });


        _it("Should throw if @provide is applied more than once without force flag", () => {

            function shouldThrow() {
                @provide("Ninja")
                @provide("SilentNinja")
                class Ninja {
                }
                return Ninja;
            }

            expect(shouldThrow).to.throw(
                "Cannot apply @provide decorator multiple times but is has been used " +
                "multiple times in Ninja " +
                "Please use @provide(ID, true) if you are trying to declare multiple bindings!"
            );

        });

        _it("Should work if @provide is applied more than once with force flag", () => {

            function shouldThrow() {
                @provide("Ninja", true)
                @provide("SilentWarrior", true)
                class Ninja {
                }
                return Ninja;
            }

            expect(shouldThrow).not.to.throws();

        });

    });

}
