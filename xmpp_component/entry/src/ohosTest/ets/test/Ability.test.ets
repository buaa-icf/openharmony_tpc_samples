/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */


import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Component, component, jid, Options, xml } from "@ohos/xmpp_component";
import { Component as ComponentCore } from "@ohos/xmpp_component_core";
export default function abilityTest() {
  // test type exports
  type Opts = Options;
  type Cl = Component;

  const c:Component = component({}); // $ExpectType Component
  component({ password: "foo" }); // $ExpectType Component
  // $ExpectType Component
  component({
    password: async auth => {
      auth; // $ExpectType (password: string) => Promise<void>
      await auth("foo");
    },
  });
  component({ domain: "foo" }); // $ExpectType Component
  component({ service: "foo.bar" }); // $ExpectType Component
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('component_timeout', 0, () => {
      const cc: ComponentCore = c;
      expect(c.entity.timeout).assertEqual(2000)
    });

    it('component_NS',0,()=>{
      const cc: ComponentCore = c;
      expect(c.entity.NS).assertEqual("jabber:component:accept")
    });

    it("component_delay",0,()=>{
      const cc: ComponentCore = c;
      c.reconnect.delay; // $ExpectType Reconnect<Component>
      expect(c.reconnect.delay).assertEqual(1000)
    });

    it("component_middleware",0,()=>{
      const cc: ComponentCore = c;
      expect(c.middleware.use instanceof Function).assertTrue()
    });

    it("component_jid", 0, () => {
      const cc: ComponentCore = c;
      expect(jid("foo").toString()).assertEqual("foo");
      expect( jid(null, "foo", "bar").toString()).assertEqual("foo/bar");
    });

    it("component_xml",0,()=>{
      xml("foo");
      expect(xml("foo").toString()).assertEqual("<foo/>")
      expect(xml("foo", { foo: "bar" }, "bar").toString()).assertEqual('<foo foo="bar">bar</foo>')
    })


  })
}