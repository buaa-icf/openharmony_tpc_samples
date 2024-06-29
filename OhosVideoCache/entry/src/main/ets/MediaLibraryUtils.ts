/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import media from '@ohos.multimedia.media';
import common from '@ohos.app.ability.common';
import Logger from './Logger';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';

const TAG = 'MediaDemo MediaLibraryUtils:';
const MS_TIME: number = 1000;
const MIN_TIME: number = 60;
const TEN_NUMBER: number = 10;

export default class MediaLibraryUtils {
  // @ts-ignore
  private context = getContext(this) as common.UIAbilityContext;
  private phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
  // 根据文件id查寻文件对象
  async findFile(uri: string, displayName: string): Promise<photoAccessHelper.PhotoAsset> {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.DISPLAY_NAME, displayName);

    const fetchOptions: photoAccessHelper.FetchOptions  = {
      fetchColumns: [],
      predicates: predicates
    };
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = await this.phAccessHelper.getAssets(fetchOptions);
    let fileAsset:photoAccessHelper.PhotoAsset;
    fileAsset = await fetchResult.getFirstObject();
    if (fetchResult.getCount() > 0) {
      fileAsset = await fetchResult.getFirstObject();
    }
    return fileAsset;
  }

  async openFileDescriptor(name: string): Promise<media.AVFileDescriptor> {
    let fileDescriptor: media.AVFileDescriptor;
    await this.context.resourceManager.getRawFd(name).then(value => {
      fileDescriptor = {
        fd: value.fd, offset: value.offset, length: value.length
      };
      Logger.info(TAG, 'getRawFileDescriptor success fileName: ' + name);
    }).catch(error => {
      Logger.info(TAG, 'getRawFileDescriptor err: ' + error);
    });
    return fileDescriptor;
  }

  async closeFileDescriptor(name: string): Promise<void> {
    await this.context.resourceManager.closeRawFileDescriptor(name).then(() => {
      Logger.info(TAG, 'case closeRawFileDescriptor ' + name);
    }).catch(error => {
      Logger.info(TAG, 'case closeRawFileDescriptor err: ' + error);
    });
  }

  getFilePath(name: string): string {
    return this.context.filesDir + '/' + name;
  }

  getShowTime(ms): string {
    let seconds: number = Math.round(ms / MS_TIME);
    let sec: number = (seconds % MIN_TIME);
    let min: number = (seconds - sec) / MIN_TIME;
    let secStr: string = sec.toString();
    let minStr: string = min.toString();
    if (sec < TEN_NUMBER) {
      secStr = '0' + sec;
    }
    if (min < TEN_NUMBER) {
      minStr = '0' + min;
    }
    return minStr + ':' + secStr;
  }
}