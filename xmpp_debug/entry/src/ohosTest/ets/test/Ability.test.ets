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
import { hideSensitive } from "@ohos/xmpp_debug"
import xml,{ Element } from "@ohos/xmpp_xml"

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

    it("sasl_auth_test", 0, () => {
      let auth: Element =  xml("auth",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml("body", {}, "foo"))
      let auth2: Element =  xml("auth",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml('hidden',{ xmlns: "xmpp.js" }))
      expect(hideSensitive(auth) + "")
        .assertEqual(auth2 + "");
    })

    it("sasl_challenge_test", 0, () => {
      let challenge: Element =  xml("challenge",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml("body", {}, "foo"))
      let challenge2: Element =  xml("challenge",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml('hidden',{ xmlns: "xmpp.js" }))
      expect(hideSensitive(challenge) + "")
        .assertEqual(challenge2 + "");
    })

    it("sasl_response_test", 0, () => {
      let response: Element =  xml("response",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml("body", {}, "foo"))
      let response2: Element =  xml("response",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml('hidden',{ xmlns: "xmpp.js" }))
      expect(hideSensitive(response) + "")
        .assertEqual(response2 + "");
    })

    it("sasl_success_test", 0, () => {
      let success: Element =  xml("success",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml("body", {}, "foo"))
      let success2: Element =  xml("success",{ xmlns: "urn:ietf:params:xml:ns:xmpp-sasl" },xml('hidden',{ xmlns: "xmpp.js" }))
      expect(hideSensitive(success) + "")
        .assertEqual(success2 + "");
    })

    it("component_handshake", 0, () => {
      let handshake: Element =  xml("handshake",{ xmlns: "jabber:component:accept" },xml("body", {}, "foo"))
      let handshake2: Element =  xml("handshake",{ xmlns: "jabber:component:accept" },xml('hidden',{ xmlns: "xmpp.js" }))
      expect(hideSensitive(handshake) + "")
        .assertEqual(handshake2 + "");
    })
  })
}