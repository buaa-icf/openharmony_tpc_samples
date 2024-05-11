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
import  iqCallee from  '@ohos/xmpp_iq/src/main/lib/callee'
import iqCaller from  '@ohos/xmpp_iq/src/main/lib/caller'
import middleware from "@ohos/xmpp_middleware"
import Connection from "@ohos/xmpp_connection"
import {Element} from "@ohos/xmpp_xml"
export default function abilityTest() {
  class Foo extends Connection implements middleware.Entity {
    domain?: string;
    hookOutgoing?: (stanza: Element) => Promise<void>;

    headerElement() {
      return new Element("foo");
    }

    socketParameters(service: string) {
      return null;
    }
  }

  const ent = new Foo({ service: "foo", domain: "foo.bar" });
  const mw = middleware({ entity: ent });

  const callee:ESObject = iqCallee({ middleware: mw, entity: ent }); // $ExpectType IQCallee<Foo>
  callee.get("foo", "bar", (ctx:ESObject, next:ESObject):ESObject => {
    ctx; // $ExpectType IncomingContext<Foo>
    next; // $ExpectType Next
    return next();
  });
  callee.set("foo", "bar", (ctx:ESObject, next:ESObject):ESObject => {
    ctx; // $ExpectType IncomingContext<Foo>
    next; // $ExpectType Next
    return next();
  });

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
    it('iq_test_iqCallee', 0, () => {
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      expect(caller.entity instanceof Foo).assertTrue()
    });

    it('iq_test_iqCallee_handlers', 0, () => {
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      caller.handlers; // $ExpectType Map<string, Deferred<Element>>
      expect(caller.handlers instanceof Map).assertTrue()
    });

    it('iq_test_iqCallee_middleware', 0, () => {
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      caller.middleware; // $ExpectType Middleware<Foo>
      expect(caller.middleware ).assertEqual(mw)
    });

    it('iq_test_iqCallee_get_1', 0, () => {
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      caller.get(new Element("foo"));
      expect(caller.get(new Element("foo")) ==null ).assertFalse()
    });

    it('iq_test_iqCallee_get_2', 0, () => {
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      caller.get(new Element("foo"), "bar");
      expect(caller.get(new Element("foo"), "bar") ==null ).assertFalse()
    });

    it('iq_test_iqCallee_get_3', 0, () => {
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      caller.get(new Element("foo"), "bar", 10);
      expect(caller.get(new Element("foo"), "bar", 10) ==null ).assertFalse()
    });

    it('iq_test_iqCallee_set_1', 0, () => {
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      caller.set(new Element("foo"));
      expect(caller.set(new Element("foo")) ==null ).assertFalse()
      expect(caller.set(new Element("foo"), "bar") ==null ).assertFalse()
      expect(caller.set(new Element("foo"), "bar", 10) ==null ).assertFalse()
    });

    it('iq_test_iqCallee_request', 0, () => {
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      caller.request(new Element("foo"));
      caller.request(new Element("foo"), 10);
      expect(caller.request(new Element("foo")) ==null ).assertFalse()
      expect(caller.request(new Element("foo"), 10) ==null ).assertFalse()
    });

    it('iq_test_iqCallee_start', 0, () => {
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      caller.request(new Element("foo"), 10); // $ExpectType Promise<Element>
      caller.start();
      expect(caller.start()).assertEqual(undefined)
    });





  })
}