/*
Copyright (c) 2022 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import TagDescriptor from '../TagDescriptor';
import PanasonicRawWbInfo2Directory from './PanasonicRawWbInfo2Directory';
import ExifDescriptorBase from './ExifDescriptorBase';
import LogUtil from '../../tools/LogUtils';

const TAG: string = "PanasonicRawWbInfo2Descriptor";

export default class PanasonicRawWbInfo2Descriptor extends TagDescriptor<PanasonicRawWbInfo2Directory> {
  public constructor(directory: PanasonicRawWbInfo2Directory) {
    super(directory);
  }

  public getDescription(tagType: number): string
  {
    LogUtil.debug(TAG, `getDescription start, tagType = ${tagType}`);
    switch (tagType) {
      case PanasonicRawWbInfo2Directory.TagWbType1:
      case PanasonicRawWbInfo2Directory.TagWbType2:
      case PanasonicRawWbInfo2Directory.TagWbType3:
      case PanasonicRawWbInfo2Directory.TagWbType4:
      case PanasonicRawWbInfo2Directory.TagWbType5:
      case PanasonicRawWbInfo2Directory.TagWbType6:
      case PanasonicRawWbInfo2Directory.TagWbType7:
        return this.getWbTypeDescription(tagType);
      default:
        return super.getDescription(tagType);
    }
  }

  public getWbTypeDescription(tagType: number): string
  {
    LogUtil.debug(TAG, `getWbTypeDescription start, tagType = ${tagType}`);
    let value = this._directory.getInteger(tagType);
    if (value == null) {
      LogUtil.error(TAG, `getWbTypeDescription end, value is null`);
      return null;
    }
    LogUtil.debug(TAG, `getWbTypeDescription end`);
    return ExifDescriptorBase.getWhiteBalanceDescription(value);
  }
}