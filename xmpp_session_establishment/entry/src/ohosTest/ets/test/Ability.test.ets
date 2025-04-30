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
import Connection from "@ohos/xmpp_connection";
import iqCaller from "@ohos/xmpp_iq/src/main/lib/caller";
import middleware from "@ohos/xmpp_middleware";
import sessionEstablishment from "@ohos/xmpp_session_establishment";
import streamFeatures from "@ohos/xmpp_stream_features";
import { Element } from "@ohos/xmpp_xml";


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
export default function abilityTest() {
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
    it('session_establishment', 0, () => {
      const ent = new Foo({ service: "foo", domain: "foo.bar" });
      const mw = middleware({ entity: ent });
      const sf = streamFeatures({ middleware: mw }); // $ExpectType StreamFeatures<Foo>
      expect(typeof sf).assertEqual('object')
      const caller:ESObject = iqCaller({ middleware: mw, entity: ent }); // $ExpectType IQCaller<Foo>
      expect(typeof caller).assertEqual('object')
      sessionEstablishment({ streamFeatures: sf, iqCaller: caller }); // $ExpectType void
    })
  })
}