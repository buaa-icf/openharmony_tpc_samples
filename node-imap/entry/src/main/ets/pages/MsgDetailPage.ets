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
 
import promptAction from '@ohos.promptAction'
import Imap, { inspect } from '@ohos/node_imap'
import router from '@ohos.router'

@Entry
@Component
struct MsgDetailPage {
  @State message: string = 'Hello World'
  @State clickIndex: number = -1

  showToast(text: string, name = '测试') {
    console.log(`zdy---${name}--->${text}`)
    promptAction.showToast({
      message: text,
      duration: 2000,
      bottom: 50
    })
  }

  aboutToAppear() {
    const ctx = this;
    if (!globalThis.client) {
      this.showToast('账号未登录，请登录后再试', 'MsgDetail-imap')
      router.back()
      return
    }
    if (router.getParams() && router.getParams()['clickIndex']) {
      ctx.clickIndex = router.getParams()['clickIndex']
    } else {
      this.showToast('未获取到邮箱文件夹参数', 'MsgDetail-imap')
      router.back()
      return
    }
    var f = globalThis.client.seq.fetch(`${ctx.clickIndex}`, {
      bodies: 'TEXT',
      struct: true
    });
    f.on('message', function (msg, seqno) {
      console.log('Message #%d', seqno);
      var prefix = '(#' + seqno + ') ';

      msg.on('body', function (stream, info) {
        var buffer = '';
        stream.on('data', function (chunk) {
          buffer += chunk.toString('utf8');
        });
        stream.once('end', function () {
          try {
            ctx.showToast(`获取整个邮件体成功：${'\r\n'}${buffer}`, 'MsgDetail-imap');
            if (buffer.length > 65535) {
              ctx.message = `获取整个邮件体成功,文本长度超过65535，text，取65535长度用于显示：${'\r\n'}${buffer.substring(0, 65535)}`
            } else {
              ctx.message = `获取整个邮件体成功：${'\r\n'}${buffer}`
            }

          } catch (err) {
            throw err
          }
        });
      });
      msg.once('attributes', function (attrs) {
        // console.log(prefix + 'Attributes: %s', inspect(attrs, false, 8));
      });
      msg.once('end', function () {
        console.log(prefix + 'Finished');
      });
    });
    f.once('error', function (err) {
      console.log('Fetch error: ' + err);
    });
    f.once('end', function () {
      console.log('Done fetching all messages!');
      globalThis.client.end();
    });
  }

  build() {
    Row() {
      Column() {
        Scroll() {
          Text(this.message)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .padding(20)
            .width('100%')
            .height(2256)
        }
      }
      .width('100%')
    }
    .height('100%')
  }

}