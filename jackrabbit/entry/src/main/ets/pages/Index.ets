/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import router from '@ohos.router';
import hilog from '@ohos.hilog';


class routeBean {
  name: string | Resource = ''
  path: string = ''
}

@Entry
@Component
struct Index {
  @State serverIp: string = '10.50.40.18';
  routes: routeBean[] = [
    {
      name: this.getResourceStr($r("app.string.HelloWorld")),
      path: 'pages/HelloWorld'
    },
    {
      name: this.getResourceStr($r("app.string.WorkQueues")),
      path: 'pages/WorkQueues'
    },
    {
      name: this.getResourceStr($r("app.string.PubSub")),
      path: 'pages/PubSub'
    } ,
    {
      name: this.getResourceStr($r("app.string.Routing")),
      path: 'pages/Routing'
    },
    {
      name: this.getResourceStr($r("app.string.Topics")),
      path: 'pages/Topics'
    },
    {
      name: this.getResourceStr($r("app.string.Rpc")),
      path: 'pages/Rpc'
    },
    {
      name: this.getResourceStr($r("app.string.TimeoutRpc")),
      path: 'pages/TimeoutRpc'
    }
  ]

  private getResourceStr(data:Resource):string{
    try {
      return this.getUIContext().getHostContext()?.resourceManager.getStringSync(data) || "";
    }catch (e){
      hilog.error(0x0001, "[lodash.isequal]", "getStringSync error, message %{private}d", JSON.stringify(e));
      return "";
    }
  }

  build() {

    Column({ space: 20 }) {
      Row() {
        Text('serverIp:')
        TextInput({ text: this.serverIp }).onChange((text) => {
          this.serverIp = text;
        }).focusable(false)
      }.width('100%').height('10%')

      ForEach(this.routes, (item: routeBean) => {
        Button(item.name)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: item.path, params: { serverIp: this.serverIp } } as router.RouterOptions);
          })
      })
    }
    .width('100%')
  }
}