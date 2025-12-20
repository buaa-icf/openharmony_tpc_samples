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

import http from '@ohos.net.http';
import { FileAsset, FileAssetLoader } from '@ohos/rive';

export class RandomNetworkLoader extends FileAssetLoader {
  public readonly context: Context;

  public constructor(context: Context) {
    super();
    this.context = context;
  }

  private loremImageBase(): string {
    return this.context.resourceManager.getStringSync($r('app.string.lorem_image_base'));
  }

  loadContents(asset: FileAsset, inBandBytes: Uint8Array): boolean {
    try {
      let minSize = 150
      let maxSize = 500
      let maxId = 1084
      const randomWidth = Math.floor(Math.random() * (maxSize - minSize + 1)) + minSize;
      const randomHeight = Math.floor(Math.random() * (maxSize - minSize + 1)) + minSize;
      const imgId = Math.floor(Math.random() * maxId);
      const loremImage = this.loremImageBase().trim();
      const url = `${loremImage}/id/${imgId}/${randomWidth}/${randomHeight}`
      this.downloadImg(url, asset);
    } catch (error) {
      console.error('RandomNetworkLoader error===', error)
    }
    return true;
  }

  downloadImg(url: string, asset: FileAsset) {
    try {
      console.info(`RandomNetworkLoader download img from network: ${url}`);
      const httpRequest = http.createHttp();
      httpRequest.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000
      }).then((response) => {
        if (response.responseCode === 200) {
          console.info(`RandomNetworkLoader download img: Network request successful`);
          const arrayBuffer = response.result as ArrayBuffer;
          const bytes = new Uint8Array(arrayBuffer);
          asset.decode(bytes);
        } else {
          console.error(`RandomNetworkLoader download img: Network request failed: ${response.responseCode}`);
        }
      }).catch((error: Error) => {
        console.error(`RandomNetworkLoader download img: Network request error: ${error}`);
      }).finally(() => {
        httpRequest.destroy();
      });
    } catch (error) {
      console.error(`RandomNetworkLoader download img: Error loading file from network: ${error}`);
    }
  }
}