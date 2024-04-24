/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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
import { client, xml, Options } from '@xmpp/client';

@Entry
@Component
struct Index {
  @State status: string = "offline";
  @State message: string = 'Hello World';
  @State sendMessage: string = ""
  @State contact: string = ""
  private options: Options = {
    service: 'xmpp://10.50.80.51:5222/',
    // service: 'wss://minint-5b5r6sm:7443/ws/',
    // domain: '10.50.80.51',
    resource: 'minint-5b5r6sm',
    username: "cq",
    password: "123456"
  }
  private xmpp = client(this.options); //连接服务

  aboutToAppear(): void {
    this.xmpp.on('error', (err) => {
      console.info('xmpp-❌', JSON.stringify(err.message));
    });
    this.xmpp.on('offline', () => {
      console.info('xmpp--', 'offline');
    });
    this.xmpp.on('status', (status, value) => {
      this.status = status
    });
    this.xmpp.on('online', async (address: ESObject) => {
      console.log('🗸', 'online as', address);
      const presence = xml(
        'presence',
        {},
        xml('show', {}, 'chat'),
        xml('status', {}, 'presence!')
      );
      this.xmpp.send(presence);
    });
    this.xmpp.on('stanza', (stanza) => {
      this.contact = stanza.attrs.from
      if (stanza.is('presence') && stanza.attrs.type === 'subscribe') {
        this.contact = stanza.attrs.from
        this.xmpp.send(xml('presence', { to: stanza.attrs.from, type: 'subscribed' }));
      }
      if (stanza.is('message') && stanza.attrs.from !== this.xmpp.jid) {
        stanza.children.forEach((child: ESObject) => {
          if (child.name === 'body') {
            console.log("xmpp---message" + child.text())
            this.message = child.text()
          }
        });
      }
    });
  }

  build() {
    Row() {
      Column() {
        Text("当前状态：" + this.status)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Text("收到消息：" + this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })
        Button("TCP连接").fontSize(30)
          .width("60%")
          .onClick(() => {
            this.xmpp.start();
          }).margin({ top: 30 })
        TextInput({ placeholder: "请输入消息" })
          .margin({ top: 30 })
          .fontSize(30)
          .width("60%")
          .height(100)
          .onChange((value: string) => {
            this.sendMessage = value;
          })


        Button("发送").fontSize(30)
          .width("60%")
          .onClick(() => {
            const message = xml("message", { type: "chat", to: this.contact }, xml("body", {}, this.sendMessage));
            this.xmpp.send(message)


          }).margin({ top: 30 })

        Button("TCP断开").fontSize(30)
          .width("60%")
          .onClick(() => {
            try {
              this.xmpp.stop();
            } catch (e) {
              console.info("cq ---- error -" + e.toString())
            }
          }).margin({ top: 30 })
      }
      .width('100%')
    }
    .height('100%')
  }
}
