/**
 *  MIT License
 *
 *  Copyright (c) 2023 Huawei Device Co., Ltd.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import { describe, it, expect, TestType } from '@ohos/hypium'
import { StunServer, StunClient } from '@ohos/stun';
import { Utils } from '@ohos/stun/src/main/ets/common/node-stun/lib/Utils';
import { OnClientMessageListener } from '@ohos/stun/src/main/ets/common/node-stun/bin/StunClient';
import { OnServerMessageListener } from '@ohos/stun/src/main/ets/common/node-stun/bin/StunServer';

export default function InterfaceTime() {

  describe('interfaceTime', ()=> {

    const BASE_COUNT = 3000
    const BASELINE_CREATEHTTP = 3000

    it('assertinetAton', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        Utils.inetAton("2.2")
      }
      let endTime = new Date().getTime()
      console.log("Utils.inetAton endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("Utils.inetAton averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('assertBufferCompare', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        Utils.bufferCompare("CQ","CQ")
      }
      let endTime = new Date().getTime()
      console.log("Utils.bufferCompare endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("Utils.bufferCompare averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('asserteInetNtoa', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        Utils.inetNtoa(100)
      }
      let endTime = new Date().getTime()
      console.log("Utils.inetNtoa endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("Utils.inetNtoa averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('assertBuffer', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let Buffer=new ArrayBuffer(100)
      for (let index = 0; index < BASE_COUNT; index++) {
        Utils.buffer2String(Buffer)
      }
      let endTime = new Date().getTime()
      console.log("Utils.buffer2String endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("Utils.buffer2String averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('setServerMessageListener', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let stunServer = new StunServer();
      let onServerMessageListener: OnServerMessageListener | ESObject;
      for (let index = 0; index < BASE_COUNT; index++) {
        stunServer.setServerMessageListener(onServerMessageListener)
      }
      let endTime = new Date().getTime()
      console.log("StunServer.setServerMessageListener endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("StunServer.setServerMessageListener averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('createServer', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let stunServer = new StunServer();
      for (let index = 0; index < BASE_COUNT; index++) {
        stunServer.createServer()
      }
      let endTime = new Date().getTime()
      console.log("StunServer.createServer endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("StunServer.createServer averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('createClient', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let stunClient = new StunClient();
      for (let index = 0; index < BASE_COUNT; index++) {
        stunClient.createClient('199.23.43.77',{host:"123.0.0.1",port:"123"})
      }
      let endTime = new Date().getTime()
      console.log("StunClient.createClient endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("StunClient.createClient averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })

    it('setClientMessageListener', TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let stunClient = new StunClient();
      let onClientMessageListener: OnClientMessageListener | ESObject;
      for (let index = 0; index < BASE_COUNT; index++) {
        stunClient.setClientMessageListener(onClientMessageListener)
      }
      let endTime = new Date().getTime()
      console.log("StunClient.setClientMessageListener endTime:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("StunClient.setClientMessageListener averageTime:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    })
  })
}