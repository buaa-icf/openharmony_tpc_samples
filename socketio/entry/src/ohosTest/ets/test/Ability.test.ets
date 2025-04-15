/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { client_socket ,buffer_util} from '@ohos/socketio';
import hilog from '@ohos.hilog';

export default function abilityTest() {
  describe('client_socket_test', () => {
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
    it('client_socket_test_connect_open', 0, async (done: Function) => {
      let connect_finish: boolean = false;
      let client: client_socket = new client_socket();
      await new Promise<void>((resolve, reject) => {
        client.set_open_listener(() => {
          connect_finish = true;
          resolve();
        });
        let uri: string = "http://113.45.193.209:3100"
        client.connect(uri);
      });
      expect(connect_finish).assertEqual(true);
      done()
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_connect_open finished');
    })

    it('client_socket_test_connect_fail', 0, async (done:Function) => {
      let connect_finish: boolean = false;
      let client: client_socket = new client_socket();
      await new Promise<void>((resolve, reject) => {
        client.set_fail_listener(() => {
          connect_finish = false;
          resolve();
        });
        let uri: string = ""
        client.connect(uri);
      });
      expect(connect_finish).assertEqual(false);
      done()
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_connect_fail finished');
    })

    it('client_socket_test_login', 0, async (done:Function) => {
      let connect_finish: boolean = false;
      let login_finish: boolean = false;
      let client: client_socket = new client_socket();
      await new Promise<void>((resolve, reject) => {
        client.set_open_listener(() => {
          connect_finish = true;
          client.on("login", () => {
            login_finish = true;
            resolve();
          });
          client.emit("add user", "username");
        });
        let uri: string = "http://113.45.193.209:3100";
        client.connect(uri);
      });
      expect(connect_finish).assertEqual(true);
      expect(login_finish).assertEqual(true);
      done()
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_login finished');
    })

    it('client_socket_test_emit', 0, async (done: Function) => {
      let connect_finish: boolean = false;
      let login_finish: boolean = false;
      let message: string = "";
      let client: client_socket = new client_socket();
      await new Promise<void>((resolve, reject) => {
        client.set_open_listener(() => {
          connect_finish = true;
          client.on("new message", (event_json: string) => {
            message = event_json;
            resolve();
          });
          client.on("login", () => {
            login_finish = true;
            client.emit("new message", "message");
          });
          client.emit("add user", "username");
        });
        let uri: string = "http://113.45.193.209:3100";
        client.connect(uri);
      });
      expect(connect_finish).assertEqual(true);
      expect(login_finish).assertEqual(true);
      expect(message != null).assertEqual(true);
      expect(message != "").assertEqual(true);
      done()
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_emit finished');
    })

    it('client_socket_test_clear_listener', 0, async (done: Function) => {
      let is_call_open_listener: boolean = false;
      let client: client_socket = new client_socket();
      client.set_open_listener(() => {
        is_call_open_listener = true;
      });
      client.clear_con_listeners();
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      setTimeout(() => {
        expect(is_call_open_listener).assertEqual(false);
        done()
      }, 1000);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_clear_listener finished');
    })

    it('client_socket_test_socket_open_close', 0, async (done: Function) => {
      let client: client_socket = new client_socket();
      await new Promise<void>((resolve, reject) => {
        client.set_socket_open_listener((nsp: string) => {
          client.set_socket_close_listener((nsp: string) => {
            done()
            resolve()
          });
          client.socket_close();
        });
        let uri: string = "http://113.45.193.209:3100";
        client.connect(uri);
      });
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_socket_open_close finished');
    })

    it('client_socket_test_close', 0, async (done: Function) => {
      let connect_close: boolean = false;
      let client: client_socket = new client_socket();
      await new Promise<void>((resolve, reject) => {
        client.set_open_listener(() => {
          client.close();
        })
        client.set_close_listener((reason: string) => {
          connect_close = true;
          resolve();
        });
        let uri: string = "http://113.45.193.209:3100";
        client.connect(uri);
      });
      expect(connect_close).assertEqual(true);
      done()
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_close finished');
    })

    it('client_socket_test_sync_close', 0, (done: Function) => {
      let connect_sync_close: boolean = false;
      let is_open: boolean = false;
      let client: client_socket = new client_socket();
      client.set_open_listener(() => {
        is_open = true;
      })
      client.set_close_listener((reason: string) => {
        connect_sync_close = true;
      });
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      setTimeout(() => {
        client.sync_close();
        setTimeout(() => {
          expect(connect_sync_close).assertEqual(true);
          expect(is_open).assertEqual(true);
          done();
        }, 1000);
      }, 1000);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_sync_close finished');
    })

    it('client_socket_test_opened', 0, (done: Function) => {
      let client: client_socket = new client_socket();
      client.set_open_listener(() => {
        expect(client.opened()).assertEqual(true);
        done()
      })
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_opened finished');
    })

    it('client_socket_test_get_sessionid', 0, (done: Function) => {
      let client: client_socket = new client_socket();
      client.set_open_listener(() => {
        client.emit("add user", "username");
      })
      client.on("login", () => {
        expect(client.get_sessionid() != null && client.get_sessionid() != "").assertEqual(true);
        done()
      });
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_get_sessionid finished');
    })

    it('client_socket_test_off', 0, (done: Function) => {
      let is_call_login_listener: boolean = false;
      let is_open: boolean = false;
      let client: client_socket = new client_socket();
      client.set_open_listener(() => {
        is_open = true
      })
      client.on("login", () => {
        is_call_login_listener = true;
      });
      client.off("login");
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      client.emit("add user", "username");
      setTimeout(() => {
        expect(is_call_login_listener).assertEqual(false);
        expect(is_open).assertEqual(true);
        done();
      }, 2000);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_off finished');
    })

    it('client_socket_test_off_all', 0, (done: Function) => {
      let is_call_login_listener: boolean = false;
      let message :boolean = false;
      let client: client_socket = new client_socket();
      client.on("login", () => {
        is_call_login_listener = true;
      });
      client.on("new message", (event_json: string) => {
        message = true;
      });
      client.off_all();
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      client.emit("add user", "username");
      setTimeout(() => {
        expect(is_call_login_listener).assertEqual(false);
        expect(message).assertEqual(false);
        done();
      }, 2000);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_off_all finished');
    })

    it('client_socket_test_reconnect_attempts', 0, (done: Function) => {
      let reconnect_num: number = 0;
      let connect_fail: boolean = false;
      let client: client_socket = new client_socket();
      client.set_reconnect_delay(1000);
      client.set_reconnect_attempts(1);
      client.set_reconnect_listener(() => {
        reconnect_num++;
        client.set_fail_listener(() => {
          connect_fail = true;
          expect(reconnect_num == 1 && connect_fail).assertEqual(true);
          done();
        });
      });
      let uri: string = "http://113.45.193.209:3102"
      client.connect(uri);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_reconnect_attempts finished');
    })

    it('client_socket_test_reconnect', 0, (done: Function) => {
      let reconnect_num: number = 0;
      let client: client_socket = new client_socket();
      client.set_reconnect_delay(1000);
      client.set_reconnect_delay_max(1000);
      client.set_reconnect_listener(() => {
        reconnect_num++;
        expect(reconnect_num > 0).assertEqual(true);
        done();
      });
      let uri: string = "http://113.45.193.209:3102"
      client.connect(uri);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_reconnecting finished');
    })

    it('client_socket_test_reconnecting', 0, (done: Function) => {
      let reconnecting_num: number = 0;
      let client: client_socket = new client_socket();
      client.set_reconnect_delay(1000);
      client.set_reconnect_delay_max(1000);
      client.set_reconnecting_listener(() => {
        reconnecting_num++;
        expect(reconnecting_num > 0).assertEqual(true);
        done();
      });
      let uri: string = "http://113.45.193.209:3102"
      client.connect(uri);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_reconnecting finished');
    })

    it('client_socket_test_clear_socket_listeners', 0, (done:Function) => {
      let is_call_open_listener: boolean = false;
      let client: client_socket = new client_socket();
      client.set_socket_open_listener((nsp: string) => {
        is_call_open_listener = true;
      });
      client.clear_socket_listeners();
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      setTimeout(() => {
        expect(is_call_open_listener).assertEqual(false);
        done()
      }, 1000);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_clear_socket_listeners finished');
    })

    it('client_socket_test_nsp', 0, (done: Function) => {
      let chat: string = '';
      let client: client_socket = new client_socket();
      client.set_nsp("chat")
      client.set_socket_open_listener((nsp: string) => {
        chat = nsp;
        expect(chat).not().assertEqual('');
        done()
      });
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_nsp finished');
    })

    it('client_socket_test_once', 0, (done: Function) => {
      let once: boolean = false;
      let client: client_socket = new client_socket();
      client.once("login",(event_json:string) => {
        once = true;
        expect(once).assertEqual(true);
        done();
      })
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      client.emit("add user", "username");
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_once finished');
    })

    it('test_buffer_util', 0, () => {
      let uArray =  Uint8Array.from([1234])
      let bufString = buffer_util.uint8ArrayToString(uArray)
      expect(bufString).not().assertEqual('')

      let buf = buffer_util.stringToUint8Array(bufString)
      expect(buf.length).not().assertEqual(0)
      hilog.info(0x0000, 'socketioTest', '%{public}s', 'test_buffer_util finished');
    })

    /**
     * 状态转换时序:
     * NOTCONNECTED(0) [同步]
     *   → CONNECTING(2) [异步等待]
     *   → CONNECTED(3) [异步回调]
     *   → DISCONNECTED(1) [同步]
     */
    it('client_socket_test_get_current_state', 0, async (done:Function) => {
      let client: client_socket = new client_socket();

      // 异步成功回调: 连接成功后执行状态验证
      client.set_open_listener(() => {
        let state = client.get_current_state();
        expect(state).assertEqual(3); // CONNECTED
        // 测试断开连接
        client.set_close_listener(() => {
          state = client.get_current_state();
          expect(state).assertEqual(1); // DISCONNECTED
          done();
        })
        client.close();
        hilog.info(0x0000, 'socketioTest', '%{public}s', 'client_socket_test_get_current_state finished');

      });

      client.set_fail_listener(() => {
        done();
      });

      // 初始状态测试
      let state: number = client.get_current_state();
      expect(state).assertEqual(0); // NOTCONNECTED

      // 触发异步连接
      let uri: string = "http://113.45.193.209:3100";
      client.connect(uri);
      state = client.get_current_state();
      expect(state).assertEqual(2); // CONNECTING
    })
  })
}