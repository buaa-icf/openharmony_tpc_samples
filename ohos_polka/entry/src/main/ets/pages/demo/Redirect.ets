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

import http from '@ohos.net.http';
import router from '@ohos.router';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import polka, { createFile } from 'polka';

@Entry
@Component
struct Redirect {
  @State msgHistory: string = '';
  @State loginUrl: string = "http://127.0.0.1:9990/test";
  scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    polka().listen().get("").post("");
  }

  build() {
    Row() {
      Column() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Button($r('app.string.back'))
            .onClick(() => {
              router.back();
            })
            .backgroundColor('#7ba54c')
            .width(100)
            .fontSize(14)
            .flexGrow(0)
        }

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.pleaseVisit'))
            .lineHeight(30)
        }

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.pleaseVisit2'))
            .lineHeight(30)
        }

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
          Button($r('app.string.generateFolder'))
            .onClick(() => {
              this.generateDir()
            })
            .width(150)
            .fontSize(14)
            .flexGrow(0)
            .margin({ top: 10 })
          Button($r('app.string.generateFile'))
            .onClick(() => {
              this.generateIndexHtml()
            })
            .width(150)
            .fontSize(14)
            .flexGrow(0)
            .margin({ top: 10, left: 10 })
          Button($r('app.string.showOperateMethod'))
            .onClick(() => {
              this.show()
            })
            .width(170)
            .fontSize(14)
            .flexGrow(0)
            .margin({ top: 10, left: 10 })
        }
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .padding(20)
  }

  generateDir() {
    try {
      let context = getContext(this) as common.UIAbilityContext;
      fs.stat(context.filesDir + '/test', (e, res) => {
        if (e) {
          fs.mkdirSync(context.filesDir + '/test');
        }
      });
    } catch (e) {
    }
  }

  generateIndexHtml() {
    try {
      let context = getContext(this) as common.UIAbilityContext;
      fs.stat(context.filesDir + '/test', (e, res) => {
        if (!e) {
          createFile(context.filesDir + '/test', 'index.html',
            `<!doctype html><html lang=""><head><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="/favicon.ico"><title>vue-project</title><script defer="defer" src="/js/chunk-vendors.8099839b.js"></script><script defer="defer" src="/js/app.ef57ad63.js"></script><link href="/css/app.b2d625b8.css" rel="stylesheet"></head><body><noscript><strong>We're sorry but vue-project doesn't work properly without JavaScript enabled. Please enable it to continue.</strong></noscript><div id="app">test html from public</div></body></html>`)
        }
      });
    } catch (e) {
    }
  }

  show() {
    let context = getContext(this) as common.UIAbilityContext;
    let wantInfo: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: 'http://127.0.0.1:9990/test'
    }
    context.startAbility(wantInfo).then(() => {
    }).catch((err: BusinessError) => {
    });
  }

  login() {
    const context = getContext(this) as common.UIAbilityContext;
    let httpRequest = http.createHttp();
    let opt: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
    }
    httpRequest.request(this.loginUrl, opt)
      .then((resp) => {
        this.msgHistory += context.resourceManager.getStringSync($r('app.string.respContent').id) + resp.result +
          "\r\n";
      })
      .catch((e: Error) => {
        this.msgHistory += context.resourceManager.getStringSync($r('app.string.reqFailed').id) + e.message + "\r\n";
      })
  }
}
