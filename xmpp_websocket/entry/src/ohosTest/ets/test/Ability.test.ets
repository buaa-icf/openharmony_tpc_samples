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
import { FramedParser } from "@ohos/xmpp_websocket/src/main/lib/FramedParser"
import xml from "@ohos/xmpp_xml"
import {EventEmitter} from "@xmpp/events"
import {ConnectionWebSocket} from "@ohos/xmpp_websocket/src/main/lib/Connection"
import {Socket} from "@ohos/xmpp_websocket/src/main/lib/Socket"
export default function abilityTest() {
  describe('ohos_xmpp_websocket_test', () => {
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
    it('framedParser', 0, () => {
      const parser:ESObject = new FramedParser();
      parser.on("start", (el:ESObject) => {
        expect(el.toString()).assertEqual('<open xmlns="urn:ietf:params:xml:ns:xmpp-framing"/>')
      });
      parser.on("element", (el:ESObject) => {
        expect(el.parent).assertNull()
        expect(el.toString()).assertEqual('<bar>hello</bar>')
      });
      parser.on("end", (el:ESObject) => {
        expect(el.toString()).assertEqual('<close xmlns="urn:ietf:params:xml:ns:xmpp-framing"/>')
      });
      parser.write(
        '<open xmlns="urn:ietf:params:xml:ns:xmpp-framing"/><bar>hello</bar><close xmlns="urn:ietf:params:xml:ns:xmpp-framing"/>',
      );
    });

    it("send_adds_jabber_client_xmlns",0,() => {
      const connection:ConnectionWebSocket = new ConnectionWebSocket({} as ESObject);
      connection.write({} as ESObject);

      const element = xml("presence");
      expect(element.attrs.xmlns).assertEqual(undefined)
      connection.send(element);
      expect(element.attrs.xmlns).assertEqual("jabber:client")
    });

    it("socketParameters",0,() => {
      let params:ConnectionWebSocket;
      params = ConnectionWebSocket.prototype.socketParameters("ws://foo");
      expect(params).assertEqual("ws://foo")
      params = ConnectionWebSocket.prototype.socketParameters("wss://foo");
      expect(params).assertEqual("wss://foo")
      params = ConnectionWebSocket.prototype.socketParameters("http://foo");
      expect(params).assertEqual(undefined)
    });

    it("DOM_WebSocket_error",0,() => {
      const socket:ESObject = new Socket();
      const sock:ESObject = new EventEmitter();
      sock.addEventListener = sock.addListener;
      socket._attachSocket(sock);
      socket.url = "ws://foobar";
      const evt :ESObject = {};
      socket.on("error", (err:ESObject) => {
        expect(err.message).assertEqual("WebSocket ECONNERROR ws://foobar")
        expect(err.errno).assertEqual("ECONNERROR")
        expect(err.code).assertEqual("ECONNERROR")
        expect(err.url).assertEqual("ws://foobar")
        expect(err.event).assertEqual(evt)
      });
      socket.socket.emit("error", evt);
    });

    it("WS_WebSocket_error",0,() => {
      const socket:ESObject = new Socket();
      const sock:ESObject = new EventEmitter();
      sock.addEventListener = sock.addListener;
      socket._attachSocket(sock);
      socket.url = "ws://foobar";
      const error:ESObject = {};
      const evt :ESObject = {error};
      socket.on("error", (err:ESObject) => {
      expect(err).assertEqual(error);
      expect(err.event).assertEqual(evt);
      expect(err.url).assertEqual("ws://foobar")
      });
      socket.socket.emit("error", evt);
    });

    it("socket_close",0,() => {
      const socket:ESObject = new Socket();
      const sock:ESObject = new EventEmitter();
      sock.addEventListener = sock.addListener;
      sock.removeEventListener = sock.removeListener;
      socket._attachSocket(sock);
      socket.url = "ws://foobar";
      const evt :ESObject = {wasClean:false};
      socket.on("close", (clean:ESObject) => {
        expect(clean.wasClean).assertFalse()
      });
      socket._detachSocket()
      socket.emit("close", evt);
    });
  })
}