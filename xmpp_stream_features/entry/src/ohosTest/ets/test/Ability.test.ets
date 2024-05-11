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
import xml,{Element} from "@ohos/xmpp_xml"
import streamFeatures from "@ohos/xmpp_stream_features"
import Connection from "@ohos/xmpp_connection"
import middleware  from "@ohos/xmpp_middleware"
import {route} from "@ohos/xmpp_stream_features/route"

export default function abilityTest() {
  type StreamFeatures<TEntity extends middleware.Entity> = streamFeatures.StreamFeatures<TEntity>;
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
    it('selectFeature_not_null', 0, () => {
      const mw = middleware({ entity: new Foo({ service: "foo", domain: "foo.bar" }) });
      const sf = streamFeatures({ middleware: mw }); // $ExpectType StreamFeatures<Foo>
      // $ExpectType Middleware<IncomingContext<Foo>>
      sf.use("foo", "ns", (ctx, next, features) => {
        ctx; // $ExpectType IncomingContext<Foo>
        next; // $ExpectType Next
        features; // $ExpectType Element
        return Promise.resolve();
      });
      sf.use("foo", undefined, (ctx, next, features) => {
        ctx; // $ExpectType IncomingContext<Foo>
        next; // $ExpectType Next
        features; // $ExpectType Element
        return Promise.resolve();
      });
      expect(sf != null || undefined).assertTrue()
      route(); // $ExpectType (context: IncomingContext<Entity>, next: Next) => Promise<any>
      route()(null as ESObject as middleware.IncomingContext<Foo>, async () => {}); // $ExpectType Promise<any>
    });

    it('selectFeature_not_undefined', 0, () => {
      const mw = middleware({ entity: new Foo({ service: "foo", domain: "foo.bar" }) });
      const sf = streamFeatures({ middleware: mw }); // $ExpectType StreamFeatures<Foo>
      // $ExpectType Middleware<IncomingContext<Foo>>
      sf.use("foo", "ns", (ctx, next, features) => {
        ctx; // $ExpectType IncomingContext<Foo>
        next; // $ExpectType Next
        features; // $ExpectType Element
        return Promise.resolve();
      });
      sf.use("foo", undefined, (ctx, next, features) => {
        ctx; // $ExpectType IncomingContext<Foo>
        next; // $ExpectType Next
        features; // $ExpectType Element
        return Promise.resolve();
      });
      expect(mw != null || undefined).assertTrue()
      route(); // $ExpectType (context: IncomingContext<Entity>, next: Next) => Promise<any>
      route()(null as ESObject as middleware.IncomingContext<Foo>, async () => {}); // $ExpectType Promise<any>
    })
  })
}