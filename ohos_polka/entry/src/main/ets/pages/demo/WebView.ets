/*
 * The MIT License (MIT)
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 */

import web_webview from '@ohos.web.webview';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import wifiManager from '@ohos.wifiManager';
import router from '@ohos.router';
import { createFile } from '@ohos/polka';
import promptAction from '@ohos.promptAction';

let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct WebView {
  controller: web_webview.WebviewController = new web_webview.WebviewController();
  @State msgHistory: string = '';
  @State loadUrl: string = "http://127.0.0.1:9990/";
  @State ip: string = '127.0.0.1';
  scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    wifiManager.getLinkedInfo((err, data) => {
      if (err) {
        console.error("get linked info error");
        return;
      }
      this.ip = this.resolveIP(data.ipAddress);
      this.loadUrl = `http://${this.ip}:9990/`
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

        Flex({
          direction: FlexDirection.Row,
          alignItems: ItemAlign.Start,
          justifyContent: FlexAlign.Start,
          wrap: FlexWrap.Wrap
        }) {
          Text($r('app.string.address'))
            .fontSize(14)
            .flexGrow(0)
          TextInput({ text: this.loadUrl })
            .onChange((value) => {
              this.loadUrl = value
            })
            .fontSize(11)
            .flexGrow(0)
          Button($r('app.string.generateIndexHtml'))
            .onClick(async () => {
              const targetPath: string = `${context.filesDir}/index.html`;
              try {
                await createFile(context.filesDir, 'index.html', `<!doctype html><html lang=""><head>
                  <meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge">
                  <meta name="viewport" content="width=device-width,initial-scale=1">
                  <link rel="icon" href="/favicon.ico"><title>vue-project</title>
                  <script defer="defer" src="/js/chunk-vendors.8099839b.js"></script>
                  <script defer="defer" src="/js/app.ef57ad63.js"></script>
                  <link href="/css/app.b2d625b8.css" rel="stylesheet"></head>
                  <body>
                  <noscript>
                  <strong>We're sorry but vue-project doesn't work properly without JavaScript enabled.
                  Please enable it to continue.</strong>
                  </noscript><div id="app">index.html file exists</div></body></html>`);
                promptAction.showToast({ message: `生成成功：${targetPath}`, duration: 1000 });
              } catch (error) {
                const message: string = error && (error as Error).message ? (error as Error).message : 'unknown error';
                console.error(`generate index.html failed: ${message}`);
                promptAction.showToast({ message: `生成失败：${message}`, duration: 1000 });
              }
            })
            .fontSize(14)
            .flexGrow(0)
            .margin({ right: 10, left: 10 })
          Button($r('app.string.load'))
            .onClick(() => {
              try {
                const contentHint: string = this.loadUrl.endsWith('/') ? `${this.loadUrl}index.html` : this.loadUrl;
                promptAction.showToast({
                  message: `加载地址：${this.loadUrl}\n加载内容：${contentHint}`,
                  duration: 1000
                });
                this.controller.loadUrl(this.loadUrl);
              } catch (error) {
                console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
              }
            })
            .fontSize(14)
            .flexGrow(0)
            .margin({ left: 10 })
          Button($r('app.string.local'))
            .onClick(() => {
              let wantInfo: Want = {
                action: 'ohos.want.action.viewData',
                entities: ['entity.system.browsable'],
                uri: this.loadUrl
              }
              context.startAbility(wantInfo).then(() => {
              }).catch((err: BusinessError) => {
              })
            })
            .width(70)
            .fontSize(14)
            .flexGrow(0)
            .margin({ left: 10 })
        }
        .width('100%')
        .padding(10)

        Scroll(this.scroller) {
          Web({ src: '127.0.0.1:9990/index', controller: this.controller }).width('100%')
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
}
