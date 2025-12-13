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
import { FileAsset, FileAssetLoader } from '@ohos/rive';


export class WalleAssetLoader extends FileAssetLoader {

  public  readonly context: Context;
  public  constructor(context: Context) {
    super();
    this.context = context;
  }

  loadContents(asset: FileAsset, inBandBytes: Uint8Array): boolean {
    try {
      const resourceName = asset.uniqueFilename.includes('eve') ? 'walle_img_eve.png' : 'walle_img_walle.png';
      const context = this.context;
      const resourceMgr = context.resourceManager;
      const bytes = resourceMgr.getRawFileContentSync(resourceName);
      console.error('WalleAssetLoader bytes ===', bytes)
      asset.decode(bytes);
    } catch (error) {
      console.error('WalleAssetLoader error===', error)
    }
    return true;
  }
}