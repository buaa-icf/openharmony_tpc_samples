/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import { RiveAnimationView } from '@ohos/rive';
import http from '@ohos.net.http';


@Entry
@Component
struct HttpPage {
  private context: Context = getContext() as Context;
  @State riveView: RiveAnimationView | null = null

  private riveUrlJuice(): string {
    return this.context.resourceManager.getStringSync($r('app.string.rive_url_juice'));
  }

  build() {
    Column() {
      RiveAnimationView({
        riveFit: 'cover',
        onReady: (view) => {
          this.riveView = view
        }
      })
        .id('http_view')
        .width('100%')
        .height('100%')

    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    this.setRiveBytesTest()
  }

  setRiveBytesTest() {
    try {
      const url = this.riveUrlJuice();
      const httpRequest = http.createHttp();
      httpRequest.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000
      }).then((response) => {
        if (response.responseCode === 200) {
          console.info(`HttpPage: Network request successful`);
          const arrayBuffer = response.result as ArrayBuffer;
          this.riveView?.setRiveBytes(arrayBuffer)
        } else {
          console.error(`HttpPage: Network request failed: ${response.responseCode}`);
        }
      }).catch((error: Error) => {
        console.error(`HttpPage: Network request error: ${error}`);
      }).finally(() => {
        httpRequest.destroy();
      });
    } catch (error) {
      console.error(`HttpPage: Error loading file from network: ${error}`);
    }
  }
}