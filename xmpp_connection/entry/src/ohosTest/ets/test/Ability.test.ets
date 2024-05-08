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
import Connection from "@ohos/xmpp_connection"
import { EventEmitter } from "@xmpp/events";
import xml from "@ohos/xmpp_xml"
class testClass extends Connection{
  write(str: string):ESObject {
    return null;
  }
  socketParameters(service: string): ESObject {
    throw new Error('Method not implemented.');
  }
  headerElement():ESObject{};

  footerElement(): ESObject {
    return xml("hello")
  }
  close(timeout?: number | undefined): Promise<ESObject> {
    return Promise.resolve();
  }
  disconnect(timeout?: number | undefined): Promise<void> {
    return Promise.resolve()
  }

}

class testClassTwo extends  Connection{
  socketParameters(service: string): ESObject {
    throw new Error('Method not implemented.');
  }
  headerElement():ESObject{};

  footerElement(): ESObject {
    return xml("foo")
  }
  close(timeout?: number | undefined): Promise<ESObject> {
    return Promise.resolve();
  }
  disconnect(timeout?: number | undefined): Promise<void> {
    return Promise.reject()
  }
}

class testClassThree extends  Connection{
  socketParameters(service: string): ESObject {
    throw new Error('Method not implemented.');
  }
  headerElement():ESObject{};

  footerElement(): ESObject {
    return xml("hello")
  }
  close(timeout?: number | undefined): Promise<ESObject> {
    return Promise.reject();
  }
  disconnect(timeout?: number | undefined): Promise<void> {
    return Promise.reject()
  }
}

class testClassFour extends  Connection{
  socketParameters(service: string): ESObject {
    throw new Error('Method not implemented.');
  }
  headerElement():ESObject{};

  footerElement(): ESObject {
    return xml("hello")
  }
  close(timeout?: number | undefined): Promise<ESObject> {
    return Promise.resolve();
  }
  disconnect(timeout?: number | undefined): Promise<void> {
    return Promise.reject()
  }
  _end(): Promise<ESObject> {
    return  Promise.resolve();
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


    it("rejects_if_connection_is_not_offline",0, () => {
      const conn = new testClass({} as ESObject);
      conn.status = "online";
      try {
        conn.start();
      } catch (err) {
        expect(err instanceof Error).assertTrue();
        expect(err.message).assertEqual("Connection is not offline");
      }
    });

    it("_end",0, () => {
      const conn = new testClass({} as ESObject);
      conn.close();
      conn.disconnect();
      conn._end()
    });

    it("resets_properties_on_socket_close_event", 0,() => {
      const conn = new testClass({} as ESObject);
      conn._attachSocket(new EventEmitter());
      conn.jid = {} as ESObject;
      conn.status = "online";
      conn.socket?.emit("connect")
      conn.socket?.emit("close")
      expect(conn.jid).assertNull()
    });

    it("resets_properties_on_socket_disconnect_event", 0,() => {
      const conn = new testClass({} as ESObject);
      conn._attachSocket(new EventEmitter());
      conn.jid = {} as ESObject;
      conn.status = "online";
      conn.socket?.emit("connect")
      conn.socket?.emit("close")
      expect(conn.status).assertEqual("disconnect")
    });

    it("_end_with_disconnect_rejection", 0,() => {
      const conn = new testClassTwo({} as ESObject);
      conn.close();
      conn.disconnect()
      conn._end()
    });

    it("end_with_close_and_disconnect_rejection",0, () => {
      const conn = new testClassThree({} as ESObject);
      conn.close();
      conn.disconnect()
      conn._end()
    });

    it("emit_error_on_socket_error",0, () => {
      const conn = new testClassThree({} as ESObject);
      conn._attachSocket(new EventEmitter());
      const error = new Error("foobar");
      conn.on("error", (err) => {
        expect(err).assertEqual(error)
      });
      conn.socket?.emit("error", error);
    });

    it("_onElement",0, () => {
      const foo = xml("foo");
      const conn = new testClass({} as ESObject);
      conn.on("element", (el) => {
        expect(el).assertEqual(foo)
      });

      conn._onElement(foo);
    });

    it("calls_detachParser_sends_a_bad_format_stream_error_and_emit_an_error",0, () => {
      const conn = new testClass({} as ESObject);
      const parser:ESObject = new EventEmitter();
      conn._attachParser(parser);
      conn._streamError((condition:ESObject)=>{
        expect(condition.toString()).assertEqual("bad-format")
      })
      const error:ESObject = {};
      conn.on("error", (err) => {
        expect(err).assertEqual(error)
      });
      parser.emit("error", error);
    });

    it("send", 0,() => {
      const conn = new testClass({} as ESObject);
      conn.root = xml("root");

      const foo = xml("foo");
      expect(foo.attrs.parent).assertEqual(undefined)
      conn.send(foo);
      expect(foo.parent).assertEqual(conn.root)
      conn.on("send", (element) => {
        expect(element).assertEqual(foo)
      });
    });

    it("resolves_if_socket_property_is_undefined", 0,async () => {
      const conn = new testClassTwo({} as ESObject);
      conn.footerElement();
      conn.socket = undefined;
      await conn.stop();
    });

    it("resolves_if_disconnect_rejects", 0,async () => {
      const conn = new testClassFour({} as ESObject);

      conn.disconnect()
      conn.close()
      await conn.stop();
    });

    it("new_Connection_one",0,() => {
      const conn = new testClassFour({} as ESObject);
      expect(conn.jid).assertNull()
    });

    it("new_Connection_two",0,() => {
      const conn = new testClassFour({} as ESObject);
      expect(conn.timeout).assertEqual(2000)
    });

    it("new_Connection_three",0,() => {
      const conn = new testClassFour({} as ESObject);
      expect(conn instanceof EventEmitter).assertTrue()
    });

    it("isStanza_one",0,() => {
      const conn = new testClassFour({} as ESObject);
      expect(conn.isStanza(xml("foo"))).assertFalse()
      expect(conn.isStanza(xml("presence"))).assertTrue()
    });

    it("isStanza_two",0,() => {
      const conn = new testClassFour({} as ESObject);
      expect(conn.isStanza(xml("iq"))).assertTrue()
      expect(conn.isStanza(xml("message"))).assertTrue()
    });

    it("isNonza",0,() => {
      const conn = new testClassFour({} as ESObject);
      expect(conn.isNonza(xml("foo"))).assertTrue()
      expect(conn.isNonza(xml("presence"))).assertFalse()
      expect(conn.isNonza(xml("iq"))).assertFalse()
      expect(conn.isNonza(xml("message"))).assertFalse()
    });

  })
}