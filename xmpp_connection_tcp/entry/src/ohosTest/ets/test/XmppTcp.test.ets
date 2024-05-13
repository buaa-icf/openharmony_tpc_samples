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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import ConnectionTCP from "@ohos/xmpp_connection_tcp"
import Connection from "@ohos/xmpp_connection"
export default function XmppTcpTest() {
  const NS_STREAM = "http://etherx.jabber.org/streams";

  describe('ohos_xmpp_connect_tcp_test', () => {
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
    it('new_Connection', 0, () => {
      const conn = new ConnectionTCP({} as ESObject);
      expect(conn instanceof Connection).assertTrue()
    });

    it('new_Connection_NS', 0, () => {
      const conn = new ConnectionTCP({} as ESObject);
      expect(conn.NS).assertEqual(NS_STREAM)
    });

    it("Socket",0,() => {
      expect(ConnectionTCP.prototype.NS).assertEqual(NS_STREAM)
    });

    it("header",0,() => {
      const conn = new ConnectionTCP({} as ESObject);
      conn.NS = "foobar";
      expect(conn.header(conn.headerElement())).assertEqual( `<?xml version='1.0'?><stream:stream version="1.0" xmlns="foobar" xmlns:stream="${NS_STREAM}">`,)
    });

    it("socketParameters",0,() => {
     expect(ConnectionTCP.prototype.socketParameters("xmpp://foo")).assertDeepEquals({
       port: 0,
       host: "foo",
     });

     expect(ConnectionTCP.prototype.socketParameters("xmpp://foo:1234")).assertDeepEquals({
       port: 1234,
       host: "foo",
      });

      expect(ConnectionTCP.prototype.socketParameters("xmpps://foo:1234")).assertDeepEquals(undefined)
    });


  })
}