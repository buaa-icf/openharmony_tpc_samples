/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 * */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {compare} from "@ohos/xmpp_resolve/src/main/lib/alt-connections"
import {sortSrv} from "@ohos/xmpp_resolve/src/main/lib/dns"
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
    it('by_security', 0, () => {
     let object:ESObject={
        uri: "http://web.example.org:5280/bosh", method: "xbosh"
      }
     let object2:ESObject={
        uri: "https://web.example.org:5280/bosh", method: "xbosh" ,
     }
     let test2:ESObject=[
       { uri: "https://web.example.org:5280/bosh", method: "xbosh" },
       { uri: "http://web.example.org:5280/bosh", method: "xbosh" },
     ]
     let test1:ESObject= [object,object2].sort(compare)
      expect(test1).assertDeepEquals(test2)
    });

    it('by_security_1', 0, () => {
      let object:ESObject={
        uri: "ws://web.example.com:80/ws", method: "websocket"
      }
      let object2:ESObject={
        uri: "https://web.example.org:5280/bosh", method: "xbosh" ,
      }
      let test2:ESObject=[
        { uri: "https://web.example.org:5280/bosh", method: "xbosh" },
        { uri: "ws://web.example.com:80/ws", method: "websocket" },
      ]
      let test1:ESObject= [object,object2].sort(compare)
      expect(test1).assertDeepEquals(test2)
    });

    it('by_method', 0, () => {
      let object:ESObject={
        uri: "https://web.example.org:5280/http-poll", method: "httppoll"
      }
      let object2:ESObject={
        uri: "wss://web.example.com:443/ws", method: "websocket" ,
      }
      let object3:ESObject={
        uri: "https://web.example.org:5280/bosh", method: "xbosh" ,
      }
      let test2:ESObject=[
        { uri: "wss://web.example.com:443/ws", method: "websocket" },
        { uri: "https://web.example.org:5280/bosh", method: "xbosh" },
        { uri: "https://web.example.org:5280/http-poll", method: "httppoll" },
      ]
      let test1:ESObject= [object,object2,object3].sort(compare)
      expect(test1).assertDeepEquals(test2)
    });

    it("by_priority",0,() => {
      expect(sortSrv([
        { priority: 2, weight: 0 },
        { priority: 1, weight: 0 },
      ])).assertDeepEquals([
        { priority: 1, weight: 0 },
        { priority: 2, weight: 0 },
      ])
      expect(sortSrv([
        { priority: 2, weight: 1 },
        { priority: 1, weight: 0 },
      ])).assertDeepEquals([
        { priority: 1, weight: 0 },
        { priority: 2, weight: 1 },
      ])
    });

    it("by_weight",0,() => {
      expect(sortSrv([
        { weight: 1, priority: 0 },
        { weight: 2, priority: 0 },
      ])).assertDeepEquals([
        { weight: 2, priority: 0 },
        { weight: 1, priority: 0 },
      ])
      expect(sortSrv([
        { weight: 2, priority: 0 },
        { weight: 1, priority: 0 },
      ])).assertDeepEquals([
        { weight: 2, priority: 0 },
        { weight: 1, priority: 0 },
      ])
    });
  })
}