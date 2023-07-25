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
import { interfaces, Container, ContainerModule, injectable, named, tagged } from 'inversify';
import "reflect-metadata"
export default function injectssue730Test() {



  describe("when_bindingunbinding", function(){

    _it("Should resolve from container directly", () => {

      const container = new Container();
      const {
        lazyInject,
        lazyInjectNamed,
        lazyInjectTagged,
        lazyMultiInject
      } = getDecorators(container, false);

      const FOO = "FOO";
      const BAR = "BAR";

      @injectable()
      class Foo {
      }

      @injectable()
      class NamedFoo {
      }

      @injectable()
      class TaggedFoo {
      }

      container.bind<Foo>(FOO).to(Foo);
      container.bind<NamedFoo>(BAR).to(NamedFoo).whenTargetNamed("bar");
      container.bind<TaggedFoo>(BAR).to(TaggedFoo).whenTargetTagged("bar", true);

      @injectable()
      class Test {
        @lazyInject(FOO) public foo: Foo;
        @lazyMultiInject(FOO) public foos: Foo[];
        @lazyInjectNamed(BAR, "bar") @named("bar") public namedFoo: Foo;
        @lazyInjectTagged(BAR, "bar", true) @tagged("bar", true) public taggedFoo: Foo;
      }

      const sut: any = new Test();

      function actual(key: string): any {
        return sut[key];
      }

      expect(actual("foo")).to.be.instanceof(Foo);
      expect(actual("foos")[0]).to.be.instanceof(Foo);
      expect(actual("namedFoo")).to.be.instanceof(NamedFoo);
      expect(actual("taggedFoo")).to.be.instanceof(TaggedFoo);

      function throws(key: string): () => any {
        return () => {
          return sut[key];
        };
      }

      container.unbind(FOO);
      container.unbind(BAR);

      expect(throws("foo")).to.throw(
        "No matching bindings found for serviceIdentifier: FOO"
      );
      expect(throws("foos")).to.throw(
        "No matching bindings found for serviceIdentifier: FOO"
      );
      expect(throws("namedFoo")).to.throw(
        "No matching bindings found for serviceIdentifier: BAR"
      );
      expect(throws("taggedFoo")).to.throw(
        "No matching bindings found for serviceIdentifier: BAR"
      );
    });

  // });

  // describe("when_loadingunloading_container_modules", () => {

    _it("Should resolve from container directly", () => {

      const container = new Container();
      const {
        lazyInject,
        lazyInjectNamed,
        lazyInjectTagged,
        lazyMultiInject
      } = getDecorators(container, false);

      const SINGLETON_FOO = "SINGLETON_FOO";
      const FOO = "FOO";
      const BAR = "BAR";

      @injectable()
      class FooBarBase {
      }

      @injectable()
      class SingletonFoo extends FooBarBase {
      }

      @injectable()
      class Foo extends FooBarBase {
      }

      @injectable()
      class Bar extends FooBarBase {
      }

      @injectable()
      class NamedBar extends FooBarBase {
      }

      @injectable()
      class TaggedBar extends FooBarBase {
      }

      const mFoo = new ContainerModule((bind: interfaces.Bind) => {
        bind<FooBarBase>(SINGLETON_FOO).to(SingletonFoo);
        bind<FooBarBase>(FOO).to(Foo);
      });
      const mBar = new ContainerModule((bind: interfaces.Bind) => {
        bind<FooBarBase>(FOO).to(Bar);
        bind<FooBarBase>(BAR).to(NamedBar).whenTargetNamed("bar");
        bind<FooBarBase>(BAR).to(TaggedBar).whenTargetTagged("bar", true);
      });

      container.load(mFoo, mBar);

      @injectable()
      class Test {
        @lazyInject(SINGLETON_FOO) public singletonFoo: FooBarBase;
        @lazyMultiInject(FOO) public foos: FooBarBase[];
        @lazyInjectNamed(BAR, "bar") @named("bar") public namedFoo: FooBarBase;
        @lazyInjectTagged(BAR, "bar", true) @tagged("bar", true) public taggedFoo: FooBarBase;
      }

      const sut: any = new Test();

      function actual(key: string): any {
        return sut[key];
      }

      expect(actual("singletonFoo")).to.be.instanceof(SingletonFoo);
      let foos: FooBarBase[] = actual("foos");
      expect(foos.length).to.equal(2);
      expect(foos[0]).to.be.instanceof(Foo);
      expect(foos[1]).to.be.instanceof(Bar);

      container.unload(mBar);

      expect(actual("singletonFoo")).to.be.instanceof(SingletonFoo);
      foos = actual("foos");
      expect(foos.length).to.equal(1);
      expect(foos[0]).to.be.instanceof(Foo);

      function throws(key: string): () => any {
        return () => {
          return sut[key];
        };
      }

      expect(throws("namedFoo")).to.throw(
        "No matching bindings found for serviceIdentifier: BAR"
      );
      expect(throws("taggedFoo")).to.throw(
        "No matching bindings found for serviceIdentifier: BAR"
      );

      container.unload(mFoo);

      expect(throws("singletonFoo")).to.throw(
        "No matching bindings found for serviceIdentifier: SINGLETON_FOO"
      );
      expect(throws("foos")).to.throw(
        "No matching bindings found for serviceIdentifier: FOO"
      );
    });

  });

}
