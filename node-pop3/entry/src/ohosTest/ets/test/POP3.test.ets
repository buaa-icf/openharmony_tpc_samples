/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import socket from '@ohos.net.socket'
import Pop3Command from '@ohos/node-pop3'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import MsgBean from '../../../../../entry/src/main/ets/MsgBean'

export default function POP3Test() {

  let message = 'Hello World'
  let account = 'xxxx'
  let password = 'xxxxx'
  let mailType = '@qq.com'
  let textValue = ''
  let inputValue = 'click me'
  let secure = false
  let listData: Array<string> = []
  let client: Pop3Command = undefined
  let selectMsgNum: string = ''
  let isListShow: boolean = false
  const BASE_COUNT = 1

  describe('POP3Test', function () {

    async function login(done) {
      globalThis.client = undefined;
      let jumpOption = undefined;
      try {
        if (secure) {
          let option: socket.TLSConnectOptions = {
            ALPNProtocols: ["spdy/1", "http/1.1"],
            address: {
              address: 'smtp.qq.com',
              port: 465,
              family: 1
            },
            secureOptions: {
              key: '',
              cert: '',
              ca: [''],
              useRemoteCipherPrefer: true,
            }
          }
          let context = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext()
          let ca0Data = await context.resourceManager.getRawFileContent('QQMailMiddle.pem')
          let ca0 = '';
          for (let i = 0; i < ca0Data.length; i++) {
            let todo = ca0Data[i]
            let item = String.fromCharCode(todo);
            ca0 += item;
          }
          // @ts-ignore
          option.secureOptions.ca[0] = ca0;

          let ca1Data = await context.resourceManager.getRawFileContent('QQMailRoot.pem')
          let ca1 = '';
          for (let i = 0; i < ca1Data.length; i++) {
            let todo = ca1Data[i]
            let item = String.fromCharCode(todo);
            ca1 += item;
          }
          // @ts-ignore
          option.secureOptions.ca[1] = ca1;
          jumpOption = {
            host: 'pop.xxx.com',
            port: 995,
            user: account + mailType,
            password: password,
            timeout: 30000,
            servername: 'pop.xxx.com',
            tls: true,
            tlsOptions: option
          }
        } else {
          jumpOption = {
            host: 'pop.xxx.com',
            port: 110,
            user: account + mailType,
            password: password,
            timeout: 30000,
            servername: 'pop.xxx.com',
            tls: false,
            tlsOptions: undefined
          }
        }
        client = new Pop3Command(jumpOption);
        done()
      } catch (err) {
        expect(0).assertEqual(1)
        done()
      }
    }

    beforeAll(function (done) {
      login(done)
    })

    it('sendList', 0, async function (done) {
      try {
        if (client) {
          let startTime1 = new Date().getTime();
          let result = await client.LIST()
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("POP3Test : sendList averageTime : " + averageTime1 + "us")
          if (result && result.toString() && result.toString().length > 0) {
            listData = result.toString().split(',')
            if (listData && listData.length > 0 && listData[0]) {
              selectMsgNum = listData[0]
            }
          }
          expect(0).assertEqual(0)
          done()
        } else {
          expect(0).assertEqual(1)
          done()
        }
      } catch (err) {
        expect(0).assertEqual(1)
        done()
      }
    })

    it('sendSTAT', 0, async function (done) {
      try {
        if (client) {
          let startTime1 = new Date().getTime();
          let result = await client.STAT()
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("POP3Test : sendSTAT averageTime : " + averageTime1 + "us")
          done()
        } else {
          expect(0).assertEqual(1)
          done()
        }
      } catch (err) {
        expect(0).assertEqual(1)
        done()
      }
    })

    it('sendNOOP', 0, async function (done) {
      try {
        if (client) {
          let startTime1 = new Date().getTime();
          let result = await client.NOOP()
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("POP3Test : sendNOOP averageTime : " + averageTime1 + "us")
          done()
        } else {
          expect(0).assertEqual(1)
          done()
        }
      } catch (err) {
        expect(0).assertEqual(1)
        done()
      }
    })

    it('sendUIDL', 0, async function (done) {
      try {
        if (!selectMsgNum || selectMsgNum.length < 1) {
          expect(0).assertEqual(1)
          done()
        }
        if (client) {
          let startTime1 = new Date().getTime();
          let result = await client.UIDL(selectMsgNum)
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("POP3Test : sendUIDL averageTime : " + averageTime1 + "us")
          done()
        } else {
          expect(0).assertEqual(1)
          done()
        }

      } catch (err) {
        expect(0).assertEqual(1)
        done()
      }
    })



    it('sendRETR', 0, async function (done) {
      try {
        if (!selectMsgNum || selectMsgNum.length < 1) {
          expect(0).assertEqual(1)
          done()
        }
        if (client) {
          let startTime1 = new Date().getTime();
          let result = await client.RETR(selectMsgNum)
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("POP3Test : sendRETR averageTime : " + averageTime1 + "us")
          expect(0).assertEqual(0)
          done()
        } else {
          expect(0).assertEqual(1)
          done()
        }
      } catch (err) {
        expect(0).assertEqual(1)
        done()
      }
    })


    it('sendDELE', 0, async function (done) {
      try {
        if (!selectMsgNum || selectMsgNum.length < 1) {
          expect(0).assertEqual(1)
          done()
        }
        if (client) {
          let startTime1 = new Date().getTime();
          let result = await client.DELE(selectMsgNum)
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("POP3Test : sendDELE averageTime : " + averageTime1 + "us")
          expect(0).assertEqual(0)
          done()
        } else {
          expect(0).assertEqual(1)
          done()
        }

      } catch (err) {
        expect(0).assertEqual(1)
        done()
      }
    })
    it('sendRSET', 0, async function (done) {
      try {
        if (!selectMsgNum || selectMsgNum.length < 1) {
          expect(0).assertEqual(1)
          done()
        }
        if (client) {
          let startTime1 = new Date().getTime();
          let result = await client.RSET() // 用于撤销DELE命令 所以不需要等DELE命令返回
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("POP3Test : sendRSET averageTime : " + averageTime1 + "us")
          done()
        } else {
          expect(0).assertEqual(1)
          done()
        }

      } catch (err) {
        expect(0).assertEqual(1)
        done()
      }
    })

    it('sendQUIT', 0, async function (done) {
      try {
        if (client) {
          let startTime1 = new Date().getTime();
          const [quitInfo] = await client.QUIT();
          let endTime1 = new Date().getTime();
          let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
          console.log("POP3Test : sendQUIT averageTime : " + averageTime1 + "us")
          done()
        } else {
          expect(0).assertEqual(1)
          done()
        }
      } catch (err) {
        expect(0).assertEqual(1)
        done()
      }
    })

  })
}