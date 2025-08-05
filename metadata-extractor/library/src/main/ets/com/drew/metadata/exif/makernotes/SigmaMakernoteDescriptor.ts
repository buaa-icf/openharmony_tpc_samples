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

import { SigmaMakernoteDirectory } from './SigmaMakernoteDirectory';
import TagDescriptor from '../../TagDescriptor';
import  LogUtil  from '../../../tools/LogUtils';

const TAG: string = "SigmaMakernoteDescriptor";

export class SigmaMakernoteDescriptor extends TagDescriptor<SigmaMakernoteDirectory> {
  constructor(directory: SigmaMakernoteDirectory) {
    super(directory)
  }

  public getDescription(tagType: number): string{
    LogUtil.debug(TAG, `getDescription enter, tagType: ${tagType}`);
    switch (tagType) {
      case SigmaMakernoteDirectory.TAG_EXPOSURE_MODE:
        return this.getExposureModeDescription();
      case SigmaMakernoteDirectory.TAG_METERING_MODE:
        return this.getMeteringModeDescription();
    }
    return super.getDescription(tagType);
  }

  private getMeteringModeDescription(): string{
    LogUtil.debug(TAG, `getMeteringModeDescription enter`);
    let value = this._directory.getString(SigmaMakernoteDirectory.TAG_METERING_MODE);
    if (value == null || value.length == 0) {
      LogUtil.error(TAG, `getMeteringModeDescription end, value is null or empty`);
      return null;
    }
    LogUtil.debug(TAG, `getMeteringModeDescription end, value: ${value}`);
    switch (value.charAt(0)) {
      case '8':
        return "Multi Segment";
      case 'A':
        return "Average";
      case 'C':
        return "Center Weighted Average";
      default:
        return value;
    }
  }

  private getExposureModeDescription(): string{
    LogUtil.debug(TAG, `getExposureModeDescription enter`);
    let value = this._directory.getString(SigmaMakernoteDirectory.TAG_EXPOSURE_MODE);
    if (value == null || value.length == 0) {
      LogUtil.error(TAG, `getExposureModeDescription end, value is null or empty`);
      return null;
    }
    LogUtil.debug(TAG, `getExposureModeDescription end, value: ${value}`);
    switch (value.charAt(0)) {
      case 'A':
        return "Aperture Priority AE";
      case 'M':
        return "Manual";
      case 'P':
        return "Program AE";
      case 'S':
        return "Shutter Speed Priority AE";
      default:
        return value;
    }
  }
}