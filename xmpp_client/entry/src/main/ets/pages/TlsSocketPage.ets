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

import { client,Client, xml, Options } from '@ohos/xmpp_client';
import { Element } from '@ohos/xmpp_xml';

@Entry
@Component
struct TlsSocketPage {
  @State status: string = "offline";
  @State message: string = 'Hello World';
  @State sendMessage: string = ""
  @State contact: string = ""
  @State TAG: string = 'NETSTACK'
  private options: Options = {
    service: 'xmpps://xxxxxxxx:xxxx', //tcp connection
    domain: 'xxxxxxx',
    resource: 'xxxxxxx',
    username: "xxx",
    password: "xxx",
    caPath:"",// The certificate address is the sandbox path
  }
  private xmpp:Client = client(this.options); // Connect service

  private onError = (err: Error) => {
    console.error('xmpp-❌', JSON.stringify(err.message));
    console.error('xmpp-❌', JSON.stringify(err.stack));
  }

  private onOffline = () => {
    console.info('xmpp--', 'offline');
  }

  private onStanza = (stanza: ESObject) => {
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
  }

  private onStatus = (status: string, value: string) => {
    this.status = status
    console.info("xmpp-response --" + "status--" + status + "---value---" + value)
  }

  private onLine = async (address: ESObject) => {
    console.log('🗸', 'online as', address);
    const presence:Element = xml(
      'presence',
      {},
      xml('show', {}, 'chat'),
      xml('status', {}, 'presence!')
    );
    this.xmpp.send(presence);
  }

  aboutToAppear() {
    this.xmpp.on('error', this.onError);
    this.xmpp.on('offline',this.onOffline);
    this.xmpp.on('status', this.onStatus);
    this.xmpp.on('online', this.onLine);
    this.xmpp.on('stanza',this.onStanza);
  }

  aboutToDisappear(){
    this.xmpp.stop();
    this.xmpp.off('error',this.onError)
    this.xmpp.off('offline',this.onOffline)
    this.xmpp.off('status',this.onStatus)
    this.xmpp.off('online',this.onLine)
    this.xmpp.off('stanza',this.onStanza)
  }

  build() {
    Row() {
      Column() {
        Text("Current state：" + this.status)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Text("Receive a message：" + this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })
        Button("connect").fontSize(30)
          .width("60%")
          .onClick(() => {
            this.xmpp.start();
          }).margin({ top: 30 })
        TextInput({ placeholder: "Please enter a message" })
          .margin({ top: 30 })
          .fontSize(30)
          .width("60%")
          .height(100)
          .onChange((value: string) => {
            this.sendMessage = value;
          })
        Button("sending").fontSize(30)
          .width("60%")
          .onClick(() => {
            const message:Element  = xml("message", { type: "chat", to: this.contact }, xml("body", {}, this.sendMessage));
            this.xmpp.send(message)
          }).margin({ top: 30 })
        Button("disconnect").fontSize(30)
          .width("60%")
          .onClick(() => {
            try {
              this.xmpp.stop();
            } catch (e) {
              console.error("stop ---- error -" + e.toString())
            }
          }).margin({ top: 30 })
      }
      .width('100%')
    }
    .height('100%')
  }
}