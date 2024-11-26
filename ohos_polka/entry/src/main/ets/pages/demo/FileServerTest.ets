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
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import buffer from '@ohos.buffer';
import router from '@ohos.router';

@Entry
@Component
struct FileServerTest {
  @State msgHistory: string = '';
  @State loginUrl: string = "http://127.0.0.1:9990/file.txt";
  @State fileExtension: string = "";
  @State buf1flag: boolean = false;
  @State buf2flag: boolean = false;
  @State text: string = "GET";
  @State index: number = 0;
  @State space: number = 8;
  @State arrowPosition: ArrowPosition = ArrowPosition.END;
  scroller: Scroller = new Scroller();
  buf1: buffer.Buffer = buffer.from('');
  buf2: buffer.Buffer = buffer.from('');

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
          Text($r('app.string.reqMethod'))
            .fontSize(14)
            .width(80)
            .flexGrow(0)
          Select(
            [
              { value: 'GET' }
            ]
          )
            .selected(this.index)
            .value(this.text)
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .space(this.space)
            .arrowPosition(this.arrowPosition)
            .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
            .optionWidth(200)
            .optionHeight(100)
            .onSelect((index: number, text?: string | undefined) => {
              this.index = index;
              if (text) {
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
          TextInput({ text: this.loginUrl })
            .onChange((value) => {
              this.loginUrl = value
            })
            .width(100)
            .fontSize(11)
            .flexGrow(1)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
          Text(`${getContext(this).resourceManager.getStringSync($r('app.string.testEtagResp').id)}${getContext(this)
            .resourceManager
            .getStringSync($r('app.string.observeRespEtag').id)}`)
            .fontSize(14)
            .flexGrow(0)

          Button($r('app.string.testEtagResp'))
            .onClick(() => {
              this.testEtags()
            })
            .width(200)
            .fontSize(14)
            .flexGrow(0)
            .margin({ left: 10 })
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
          Text(`${getContext(this).resourceManager.getStringSync($r('app.string.testGzipResp').id)}${getContext(this)
            .resourceManager
            .getStringSync($r('app.string.observeRespContent').id)}`)
            .fontSize(14)
            .flexGrow(0)

          Button($r('app.string.testGzipResp'))
            .onClick(() => {
              this.testGzip()
            })
            .width(200)
            .fontSize(14)
            .flexGrow(0)
            .margin({ left: 10 })
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text($r('app.string.testFluidTransfer'))
            .fontSize(14)
            .flexGrow(0)
            .padding(10)
        }
        .width('100%')

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
          Text($r('app.string.newFileSuffiexName'))
            .fontSize(16)
            .fontWeight('blonder')
            .width(150)

          TextInput({ text: this.fileExtension })
            .onChange((value) => {
              this.fileExtension = value
            })
            .width(150)
            .fontSize(11)

          Button($r('app.string.one'))
            .onClick(() => {
              this.post1()
            })
            .width(100)
            .fontSize(14)
            .flexGrow(0)
            .margin({ left: 10, top: 10 })
          Button($r('app.string.two'))
            .onClick(() => {
              this.post2()
            })
            .width(100)
            .fontSize(14)
            .flexGrow(0)
            .margin({ left: 10, top: 10 })
          Button($r('app.string.genNewFile'))
            .onClick(() => {
              this.createNewFile()
            })
            .width(150)
            .fontSize(14)
            .flexGrow(0)
            .margin({ left: 10, top: 10 })
        }
        .width('100%')
        .padding(10)


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

  testEtags() {
    const context: Context = getContext(this);
    const colon: string = context.resourceManager.getStringSync($r('app.string.colon').id);
    let httpRequest = http.createHttp();
    let opt: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
    }
    httpRequest.request(this.loginUrl, opt)
      .then((resp) => {
        const responseStatus: string =
          context.resourceManager.getStringSync($r('app.string.responseStatus').id) + colon;
        const responseHeader: string =
          context.resourceManager.getStringSync($r('app.string.responseHeader').id) + colon;
        this.msgHistory = `${responseStatus}${JSON.stringify(resp.responseCode)} \r\n`;
        this.msgHistory += `${responseHeader}${JSON.stringify(resp.header)} \r\n`;
        this.buf1 = buffer.from(resp.result as ArrayBuffer);
      })
      .catch((e: Error) => {
        const reqFailed: string = context.resourceManager.getStringSync($r('app.string.reqFailed').id);
        this.msgHistory += reqFailed + e.message + "\r\n";
      })
  }

  testGzip() {
    const context: Context = getContext(this);
    const colon: string = context.resourceManager.getStringSync($r('app.string.colon').id);
    let httpRequest = http.createHttp();
    let opt: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: {
        'Accept-Encoding': 'gzip, deflate, br, zstd',
      }
    }
    httpRequest.request(this.loginUrl, opt)
      .then((resp) => {
        const responseStatus: string =
          context.resourceManager.getStringSync($r('app.string.responseStatus').id) + colon;
        const responseHeader: string =
          context.resourceManager.getStringSync($r('app.string.responseHeader').id) + colon;
        this.msgHistory = `${responseStatus}${JSON.stringify(resp.responseCode)} \r\n`;
        this.msgHistory += `${responseHeader}${JSON.stringify(resp.header)} \r\n`;
        this.buf1 = buffer.from(resp.result as ArrayBuffer);
      })
      .catch((e: Error) => {
        const reqFailed: string = context.resourceManager.getStringSync($r('app.string.reqFailed').id);
        this.msgHistory += reqFailed + e.message + "\r\n";
      })
  }

  post1() {
    const context: Context = getContext(this);
    const colon: string = context.resourceManager.getStringSync($r('app.string.colon').id);
    this.buf1flag = false;
    let httpRequest = http.createHttp();
    let opt: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: {
        'range': 'bytes=0-10',
      }
    }
    httpRequest.request(this.loginUrl, opt)
      .then((resp) => {
        const gainFileContent: string = context.resourceManager.getStringSync($r('app.string.gainFileContent').id);
        this.msgHistory = `${gainFileContent}${colon}${resp.result}\r\n`;
        if (resp.responseCode !== 404) {
          this.buf1flag = true
        }
        this.buf1 = buffer.from(resp.result as ArrayBuffer);
      })
      .catch((e: Error) => {
        const reqFailed: string = context.resourceManager.getStringSync($r('app.string.reqFailed').id);
        this.msgHistory += reqFailed + e.message + "\r\n";
      })
  }

  post2() {
    const context: Context = getContext(this);
    const colon: string = context.resourceManager.getStringSync($r('app.string.colon').id);
    this.buf2flag = false;
    let httpRequest = http.createHttp();
    let opt: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: {
        'range': 'bytes=11-',
      }
    }
    httpRequest.request(this.loginUrl, opt)
      .then((resp) => {
        // gainFileContent
        const gainFileContent: string = context.resourceManager.getStringSync($r('app.string.gainFileContent').id);
        this.msgHistory = `${gainFileContent}${colon}${resp.result}\r\n`;
        if (resp.responseCode !== 404) {
          this.buf2flag = true
        }
        this.buf2 = buffer.from(resp.result as ArrayBuffer);
      })
      .catch((e: Error) => {
        const reqFailed: string = context.resourceManager.getStringSync($r('app.string.reqFailed').id);
        this.msgHistory += reqFailed + e.message + "\r\n";
      })
  }

  createNewFile() {
    const context = getContext(this) as common.UIAbilityContext;
    const genNewFileSucceed: string = context.resourceManager.getStringSync($r('app.string.genNewFileSucceed').id);
    const pleaseCheckSandBoxPath: string =
      context.resourceManager.getStringSync($r('app.string.pleaseCheckSandBoxPath').id);
    const genNewFileFailed: string = context.resourceManager.getStringSync($r('app.string.genNewFileFailed').id);
    const originFileNotExisted: string =
      context.resourceManager.getStringSync($r('app.string.originFileNotExisted').id);
    try {
      if (this.buf1flag || this.buf2flag) {
        let data = context.filesDir
        const writer =
          fs.openSync(data + '/newFile.' + this.fileExtension, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.writeSync(writer.fd, buffer.concat([this.buf1, this.buf2]).buffer);
        fs.closeSync(writer);
        AlertDialog.show({
          title: genNewFileSucceed,
          message: pleaseCheckSandBoxPath + data + '/newFile.' + this.fileExtension,
          confirm: {
            value: 'OK', action: () => {
            }
          }
        })
      } else {
        AlertDialog.show({
          title: genNewFileFailed,
          message: originFileNotExisted,
          confirm: {
            value: 'OK', action: () => {
            }
          }
        })
      }
    } catch (error) {
      console.error('File to obtain the file directory. Cause: ' + error.message);
    }
  }
}