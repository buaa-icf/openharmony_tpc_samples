/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import Pop3Command from '@ohos/node_pop3'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import MsgBean from '../../../../../entry/src/main/ets/MsgBean'

export default function POP3PressTest() {

  let message = 'Hello World'
  let account = ''
  let password = ''
  let mailType = '@qq.com'
  let textValue = ''
  let inputValue = 'click me'
  let secure = false
  let listData: Array<string> = []
  let client: Pop3Command = undefined
  let selectMsgNum: number = -1
  let isListShow: boolean = false
  const BASE_COUNT = 10000
  describe('POP3PressTest', function () {
    for (let i = 1;i <= BASE_COUNT; i++) {
      it('LIST', 0, function () {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.LIST();
      })

      it('STAT', 0, function () {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.STAT()
      })

      it('NOOP', 0, function () {
        let option = {
          host: 'pop.xxxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.NOOP()
      })

      it('UIDL', 0, function () {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.UIDL("1")
      })

      it('RSET', 0, function () {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.RSET()
      })

      it('RETR', 0, function () {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.RETR("1")
      })

      it('DELE', 0, function () {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.DELE("1")
      })

      it('QUIT', 0, function () {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.QUIT()
      })

      it('connect', 0, function () {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.connect()
      })

      it('TOP', 0, function () {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.TOP("1")

      })

      it('command', 0, function (done) {
        let option = {
          host: 'pop.xxx.com',
          port: 110,
          user: account + mailType,
          password: password,
          timeout: 30000,
          servername: 'pop.xxx.com',
          tls: false,
          tlsOptions: undefined
        }
        client = new Pop3Command(option);
        let result = client.command("NOOP")
        console.log("command count:"+i)
      })
    }
  })
}