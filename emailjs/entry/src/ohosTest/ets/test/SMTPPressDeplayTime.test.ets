import hilog from '@ohos.hilog';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { AUTH_METHODS, Message, MessageAttachment, MessageHeaders, SMTPClient } from '@ohos/emailjs'
import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import socket from '@ohos.net.socket'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import fs from '@ohos.file.fs';

export default function SMTPPressTest() {

  let from: string = ''
  let accountName: string = ''
  let to: string = ''
  let cc: string = '1'
  let bcc: string = '2'
  let subject: string = 'test'
  let content: string = 'test'
  //总的次数
  const BASE_COUNT = 10000
  //每个用例延迟时间执行毫秒单位
  const deplayTime=500
  describe('SMTPPressTest', function () {

    for(let i=1;i<=BASE_COUNT;i++){
      it('new_SMTPClient', 0, function (done) {
        setTimeout(()=>{
          let client = new SMTPClient({
            user: '',
            password: '',
            host: 'smtp.qq.com',
            port: 25,
            timeout: 30000,
            authentication: [AUTH_METHODS.LOGIN],
            ssl: false,
            tls: undefined
          });
          console.log("new_SMTPClient count:"+i)
          done()
        },deplayTime)
      })

      it('sendAsync', 0, function (done) {
        setTimeout(()=>{
          let client = new SMTPClient({
            user: '',
            password: '',
            host: 'smtp.qq.com',
            port: 25,
            timeout: 30000,
            authentication: [AUTH_METHODS.LOGIN],
            ssl: false,
            tls: undefined
          });

          let msg: Message | MessageHeaders = {
            text: content,
            from: `${accountName} <${from}>`,
            to: to,
            cc: cc,
            bcc: cc,
            subject: subject,
            attachment: null
          }
          client.sendAsync(msg)
          console.log("sendAsync count:"+i)
          done()
        },deplayTime)
      })
    }
  })
}