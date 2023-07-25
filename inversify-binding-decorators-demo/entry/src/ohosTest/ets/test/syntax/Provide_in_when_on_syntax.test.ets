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

import ProvideInWhenOnSyntax from 'inversify-binding-decorators/es/syntax/provide_in_when_on_syntax';
import ProvideInSyntax from 'inversify-binding-decorators/es/syntax/provide_in_syntax';
import ProvideWhenSyntax from 'inversify-binding-decorators/es/syntax/provide_when_syntax';
import ProvideOnSyntax from 'inversify-binding-decorators/es/syntax/provide_on_syntax';
import ProvideDoneSyntax from 'inversify-binding-decorators/es/syntax/provide_done_syntax';
import { METADATA_KEY } from 'inversify-binding-decorators/es/constants';
import { interfaces as inversifyInterfaces } from 'inversify';
import { it as _it, afterAll, afterEach, beforeAll, beforeEach, describe, expect } from '../util'
import "reflect-metadata";


export default function provideInWhenOnSyntaxTest() {

    describe("ProvideInWhenOnSyntax", function () {


        beforeEach(() => {
            Reflect.deleteMetadata(METADATA_KEY.provide, Reflect);
        });

        afterEach(() => {
        });

        class Ninja {
        }

        class Game {
        }

        let bindingInSyntaxFunction =
            (bind: inversifyInterfaces.Bind, target: any) => bind<Ninja>("Ninja").to(<any> null);
        let provideDoneSyntax = new ProvideDoneSyntax(bindingInSyntaxFunction);
        let provideInSyntax = new ProvideInSyntax(bindingInSyntaxFunction, provideDoneSyntax);
        let provideWhenSyntax = new ProvideWhenSyntax(bindingInSyntaxFunction, provideDoneSyntax);
        let provideOnSyntax = new ProvideOnSyntax(bindingInSyntaxFunction, provideDoneSyntax);
        let provideInWhenOnSyntax = new ProvideInWhenOnSyntax(provideInSyntax, provideWhenSyntax, provideOnSyntax);

        _it("Should set its on properties correctly", () => {

            expect((<any> provideInWhenOnSyntax)._provideInSyntax).eql(provideInSyntax);
            expect((<any> provideInWhenOnSyntax)._provideWhenSyntax).eql(provideWhenSyntax);
            expect((<any> provideInWhenOnSyntax)._provideOnSyntax).eql(provideOnSyntax);

        });

    });

}
