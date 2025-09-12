/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import wifiManager from '@ohos.wifiManager';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Download {
  @State ip: string = '127.0.0.1';
  @State fileName: string = '';

  aboutToAppear(): void {
    wifiManager.getLinkedInfo((err, data) => {
      if (err) {
        console.error("get linked info error");
        return;
      }
      this.ip = this.resolveIP(data.ipAddress);
      console.info("get wifi linked info: " + JSON.stringify(data) + this.resolveIP(data.ipAddress));
    });
  }

  resolveIP(ip: number): string {
    if (ip < 0 || ip > 0xFFFFFFFF) {
      return "";
    }
    return (ip >>> 24) + '.' + (ip >> 16 & 0xFF) + '.' + (ip >> 8 & 0xFF) + '.' + (ip & 0xFF);
  }

  build() {
    Column({ space: 10 }) {
      Text($r('app.string.downloadTitle'))
      Row() {
        Text(`http://${this.ip}:9990/download?file=`)
          .font({ size: 14 })
        TextInput({ text: $$this.fileName, placeholder: $r('app.string.downloadPlaceholder') })
          .fontSize(14)
          .layoutWeight(1)
        Blank()
      }

      Row({ space: 10 }) {
        Button($r('app.string.localBtn'))
          .onClick(() => {
            if (!this.fileName) {
              promptAction.showToast({ message: $r('app.string.downloadPlaceholder') });
              return;
            }
            let context = getContext(this) as common.UIAbilityContext;
            let wantInfo: Want = {
              action: 'ohos.want.action.viewData',
              entities: ['entity.system.browsable'],
              uri: `http://${this.ip}:9990/download?file=${this.fileName}`
            }
            context.startAbility(wantInfo).then(() => {
              console.info('start browser success.');
            }).catch((err: BusinessError) => {
              console.error('start browser error.');
            })
          })
          .width(100)
          .fontSize(14)
        Button($r('app.string.back'))
          .onClick(() => {
            router.back();
          })
          .backgroundColor('#7ba54c')
          .width(100)
          .fontSize(14)
      }
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .justifyContent(FlexAlign.Center)
  }
}
