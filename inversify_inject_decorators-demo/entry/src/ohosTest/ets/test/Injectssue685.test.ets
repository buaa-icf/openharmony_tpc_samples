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
import { Container, injectable, inject } from 'inversify';
import "reflect-metadata"
export default function injectssue685Test() {



  describe('Injectssue685Test', function () {
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

    _it("Should throw exception if circular dependencies are declared in a single file", () => {

      const container = new Container();
      const { lazyInject } = getDecorators(container);

      @injectable()
      class Dom {
        public domUi: DomUi;
        constructor (
          domUi: DomUi
        ) {
          this.domUi = domUi;
        }
      }

      @injectable()
      class DomUi {
        @lazyInject(Dom) public dom: Dom;
      }

      @injectable()
      class Test {
        public dom: Dom;
        constructor(
          dom: Dom
        ) {
          this.dom = dom;
        }
      }

      container.bind<Dom>(Dom).toSelf().inSingletonScope();
      container.bind<DomUi>(DomUi).toSelf().inSingletonScope();

      function throws() {
        return container.resolve(Test);
      }

      // This error may seem a bit misleading because when using
      // classes as service indentifiers @inject anotations should
      // not be required and if we do add an annotation like
      // @inject(Dom) or @inject(DomUi) we will still get the same
      // exception. This happens because at point in time in which
      // the decorator is invoked, the class has not been declared
      // so the decorator is invoked as @inject(undefined). This
      // trigger inversify to think that the annotation was never
      // added. The solution is to use Symbols as service identifiers.
        expect(throws).to.throw(
          "Missing required @inject or @multiInject annotation in: argument 0 in class Dom."
        );
    });

    _it("Should be able to resolve lazy circular dependencies", () => {

      const container = new Container();
      const { lazyInject } = getDecorators(container);

      const TYPE = {
        Dom: Symbol.for("Dom"),
        DomUi: Symbol.for("DomUi")
      };

      @injectable()
      class DomUi {
        public dom: Dom;
        public name: string;
        constructor (
          @inject(TYPE.Dom) dom: Dom
        ) {
          this.dom = dom;
          this.name = "DomUi";
        }
      }

      @injectable()
      class Dom {
        public name: string;
        @lazyInject(TYPE.DomUi) public domUi: DomUi;
        public constructor() {
          this.name = "Dom";
        }
      }

      @injectable()
      class Test {
        public dom: Dom;
        constructor(
          @inject(TYPE.Dom) dom: Dom
        ) {
          this.dom = dom;
        }
      }

      container.bind<Dom>(TYPE.Dom).to(Dom).inSingletonScope();
      container.bind<DomUi>(TYPE.DomUi).to(DomUi).inSingletonScope();

      const test = container.resolve(Test);

      expect(test.dom.name).eq("Dom");
      expect(test.dom.domUi.name).eq("DomUi");
      expect(test.dom.domUi.dom.name).eq("Dom");
      expect(test.dom).eq(test.dom.domUi.dom);
      expect(test.dom.domUi).eq(test.dom.domUi.dom.domUi);

    });


  })
}