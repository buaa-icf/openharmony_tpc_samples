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
import router from '@ohos.router';
import { start, stop } from './test';

@Entry
@Component
struct Index {
  @State message: string = '';
  public context = getContext(this) as common.UIAbilityContext;
  scroller: Scroller = new Scroller();

  build() {
    Row() {
      Scroll(this.scroller) {
        Column() {
          Text(this.message)
          Button($r('app.string.startLocalServer'))
            .commonStyle()
            .onClick(() => {
              const context = getContext(this) as common.UIAbilityContext;
              const time1 = new Date().getTime();
              start(this.context).then(() => {
                const time2 = new Date().getTime();
                const time = time2 - time1
                this.message = context.resourceManager.getStringSync($r('app.string.serverStarted').id) +
                context.resourceManager.getStringSync($r('app.string.costed').id) + time + 'ms';
              })
            })
          Button($r('app.string.basicHttpRequest'))
            .commonStyle()
            .onClick(() => {
              router.pushUrl({ url: 'pages/demo/Client' })
            })
          Button($r('app.string.staticFileServer'))
            .commonStyle()
            .onClick(() => {
              router.pushUrl({ url: 'pages/demo/WebView' })
            })
          Button($r('app.string.uploadFile'))
            .commonStyle()
            .onClick(() => {
              router.pushUrl({ url: 'pages/demo/Upload' })
            })
          Button($r('app.string.downloadFile'))
            .commonStyle()
            .onClick(() => {
              router.pushUrl({ url: 'pages/demo/Download' })
            })
          Button($r('app.string.foldrRedirect'))
            .commonStyle()
            .onClick(() => {
              router.pushUrl({ url: 'pages/demo/Redirect' })
            })
          Button($r('app.string.testETagsAndGzip'))
            .commonStyle()
            .onClick(() => {
              router.pushUrl({ url: 'pages/demo/FileServerTest' })
            })
          Button($r('app.string.testGzip'))
            .commonStyle()
            .onClick(() => {
              router.pushUrl({ url: 'pages/demo/Gzip' })
            })
          Button($r('app.string.closeLocalServer'))
            .commonStyle()
            .onClick(() => {
              stop(this.context).then(() => {
                const context = getContext(this) as common.UIAbilityContext;
                this.message = context.resourceManager.getStringSync($r('app.string.serverClosed').id)
              })
            })
        }
        .width('100%')
      }.height('100%')
    }
    .height('100%')
  }
}

@Extend(Button)
function commonStyle() {
  .fontSize(16)
  .width('60%')
  .margin(8)
  .type(ButtonType.Normal)
  .stateEffect(true)
}
