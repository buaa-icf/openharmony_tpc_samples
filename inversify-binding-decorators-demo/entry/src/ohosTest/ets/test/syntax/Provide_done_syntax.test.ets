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

import { METADATA_KEY } from "inversify-binding-decorators/es/constants";
import ProvideDoneSyntax from "inversify-binding-decorators/es/syntax/provide_done_syntax";
import interfaces from "inversify-binding-decorators/dts/interfaces/interfaces";
import { interfaces as inversifyInterfaces } from "inversify";
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '../util'
import "reflect-metadata";

export default function provideDoneSyntaxTest() {

    describe("ProvideDoneSyntax",function() {

        _it("Should be able to apply a fluent decorator", () => {

            class Ninja {
            }

            let bindingInSyntax = (bind: inversifyInterfaces.Bind, target: any) => bind<Ninja>("Ninja").to(target);
            let binding: interfaces.BindConstraint = (bind: inversifyInterfaces.Bind, target: any) =>
            (<any> bindingInSyntax(bind, target))._binding;
            let provideDoneSyntax = new ProvideDoneSyntax(binding);

            let decorator = provideDoneSyntax.done();
            expect(typeof decorator).eql("function");

            decorator(Ninja);
            expect(Reflect.getMetadata(METADATA_KEY.provide, Reflect)[0].implementationType).eql(Ninja);

        });

    });

}
