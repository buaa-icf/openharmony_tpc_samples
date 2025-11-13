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
import HttpUtil from './http';

@Entry
@Component
struct Client {
  @State msgHistory: string = '';
  @State requestUrl: string = "http://127.0.0.1:9990/post-params";
  extraData: Object = new Object();
  options: http.HttpRequestOptions = {};
  scroller: Scroller = new Scroller();
  @State cookie: string = '';
  @State methods: Array<string> = ['POST', 'GET', 'HEAD', 'OPTIONS', 'TRACE', 'DELETE', 'PUT', 'CONNECT'];
  @State method: string = this.methods[0];
  @State headerKeys: string[] = ['cookie', 'Content-type'];
  @State headerValues: string[] = ['userId=12345;', 'application/x-www-form-urlencoded'];
  @State keys: string[] = ["test"];
  @State values: string[] = ["testValue"];
  @State text: string = "POST";
  @State index: number = 0;

  build() {
    Row() {
      Column() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Button($r('app.string.back'))
            .onClick(() => {
              router.back();
            })
            .backgroundColor('#7ba54c')
            .width(80)
            .fontSize(14)
            .flexGrow(0)
        }

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.reqMethod'))
            .fontSize(14)
            .width(80)
            .flexGrow(0)
          Select([
            { value: 'POST' },
            { value: 'GET' },
            { value: 'HEAD' },
            { value: 'OPTIONS' },
            { value: 'TRACE' },
            { value: 'DELETE' },
            { value: 'PUT' },
            { value: 'CONNECT' }
          ])
            .selected(this.index)
            .value(this.text)
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
            .optionWidth(200)
            .optionHeight(500)
            .onSelect((index: number, text?: string | undefined) => {
              this.index = index;
              if (text) {
                this.method = text;
                this.text = text;
              }
            })
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.reqAddress'))
            .fontSize(14)
            .width(80)
            .flexGrow(0)
          TextInput({ text: this.requestUrl })
            .onChange((value) => {
              this.requestUrl = value
            })
            .fontSize(14)
            .width(100)
            .flexGrow(1)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text("headers:")
            .fontSize(14)
            .width(80)
            .flexGrow(0)

          TextInput({ text: this.headerKeys[0], placeholder: $r('app.string.headerName') })
            .onChange((value: string) => {
              this.headerKeys[0] = value
            })
            .id(`cookie`).width(170)

          TextInput({ text: this.headerValues[0], placeholder: $r('app.string.headerValue') })
            .margin({ left: 4, right: 2 })
            .onChange((value: string) => {
              this.headerValues[0] = value
            })
            .id(`cookie`).width(500)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.params'))
            .fontSize(14)
            .width(80)
            .flexGrow(0)

          TextInput({ text: this.keys[0], placeholder: $r('app.string.paramsName') })
            .margin({ left: 4, right: 2 })
            .onChange((value: string) => {
              this.keys[0] = value
            })
            .id(`key0`)

          TextInput({ text: this.values[0], placeholder: $r('app.string.paramsValue') })
            .width('75%')
            .margin({ left: 4, right: 2 })
            .onChange((value: string) => {
              this.values[0] = value
            })
            .id(`value0`)
            .padding(10)
        }
        .width('100%')
        .padding(10)

        Row() {
          Button($r('app.string.send'))
            .onClick(() => {
              this.login()
            })
            .width("100%")
            .fontSize(14)
            .flexGrow(0)
        }

        Scroll(this.scroller) {
          Text(this.msgHistory)
            .textAlign(TextAlign.Start)
            .padding(10)
            .width('100%')
            .backgroundColor(0xeeeeee)
        }
        .align(Alignment.Top)
        .backgroundColor(0xeeeeee)
        .height(300)
        .flexGrow(1)
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarWidth(20)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height('100%')
    }
    .height('100%')
  }

  login() {
    const context: Context = getContext(this)
    const httpRequest: http.HttpRequest = http.createHttp();
    this.options = {
      extraData: HttpUtil.setParameter(this.keys, this.values),
      header: HttpUtil.setParameter(this.headerKeys, this.headerValues)
    };
    this.setMethod(this.method);
    httpRequest.request(this.requestUrl, this.options)
      .then((resp: http.HttpResponse) => {
        this.msgHistory = '';
        this.msgHistory += context.resourceManager.getStringSync($r('app.string.respCode').id) + resp.responseCode +
          "\r\n";
        this.msgHistory += "Cookie：" + resp.cookies + "\r\n";
        this.msgHistory += "header：" + JSON.stringify(resp.header) + "\r\n";
        this.msgHistory += "result：" + resp.result + "\r\n";
        this.msgHistory += "result-type：" + resp.resultType + "\r\n";
      })
      .catch((e: Error) => {
        this.msgHistory += context.resourceManager.getStringSync($r('app.string.respFailed').id) +
        context.resourceManager.getStringSync($r('app.string.colon').id) + e.message +
          "\r\n";
      });
  }

  setMethod(method: string) {
    switch (method) {
      case 'GET':
        this.options.method = http.RequestMethod.GET;
        break;
      case 'HEAD':
        this.options.method = http.RequestMethod.HEAD;
        break;
      case 'OPTIONS':
        this.options.method = http.RequestMethod.OPTIONS;
        break;
      case 'TRACE':
        this.options.method = http.RequestMethod.TRACE;
        break;
      case 'DELETE':
        this.options.method = http.RequestMethod.DELETE;
        break;
      case 'POST':
        this.options.method = http.RequestMethod.POST;
        break;
      case 'PUT':
        this.options.method = http.RequestMethod.PUT;
        break;
      case 'CONNECT':
        this.options.method = http.RequestMethod.CONNECT;
        break;
      default:
        this.options.method = http.RequestMethod.GET;
        break;
    }
  }
}
