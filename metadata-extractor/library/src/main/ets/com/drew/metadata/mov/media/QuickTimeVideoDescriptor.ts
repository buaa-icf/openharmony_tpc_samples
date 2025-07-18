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

import QuickTimeDescriptor from '../QuickTimeDescriptor'
import QuickTimeVideoDirectory from './QuickTimeVideoDirectory'
import LogUtil from '../../../tools/LogUtils';

const TAG: string = "QuickTimeVideoDescriptor"

class QuickTimeVideoDescriptor extends QuickTimeDescriptor {
  public constructor(directory: QuickTimeVideoDirectory) {
    super(directory);
  }

  public getDescription(tagType: number): string {
    LogUtil.debug(TAG, `getDescription start, tagType: ${tagType}`);
    switch (tagType) {
      case QuickTimeVideoDirectory.TAG_HEIGHT:
      case QuickTimeVideoDirectory.TAG_WIDTH:
        return this.getPixelDescription(tagType);
      case QuickTimeVideoDirectory.TAG_DEPTH:
        return this.getDepthDescription(tagType);
      case QuickTimeVideoDirectory.TAG_COLOR_TABLE:
        return this.getColorTableDescription(tagType);
      case QuickTimeVideoDirectory.TAG_GRAPHICS_MODE:
        return this.getGraphicsModeDescription();
      default:
        return super.getDescription(tagType);
    }
  }

  private getPixelDescription(tagType: number): string {
    let value: string = this._directory.getString(tagType);
    return value == null ? null : value + " pixels";
  }

  private getDepthDescription(tagType: number): string {
    LogUtil.debug(TAG, `getDepthDescription start`);
    let value: number = this._directory.getInteger(tagType);
    if (value == null) {
      LogUtil.debug(TAG, `getDepthDescription end, value is null`);
      return null;
    }

    LogUtil.debug(TAG, `getDepthDescription end, value: ${value}`);
    switch (value) {
      case (1):
      case (2):
      case (4):
      case (8):
      case (16):
      case (24):
      case (32):
        return value + "-bit color";
      case (40):
      case (36):
      case (34):
        return (value - 32) + "-bit grayscale";
      default:
        return "Unknown (" + value + ")";
    }
  }

  private getColorTableDescription(tagType: number): string {
    LogUtil.debug(TAG, `getColorTableDescription start`);
    let value: number = this._directory.getInteger(tagType);
    if (value == null) {
      LogUtil.debug(TAG, `getColorTableDescription end, value is null`);
      return null;
    }

    LogUtil.debug(TAG, `getColorTableDescription end, value: ${value}`);
    switch (value) {
      case (-1):
        if (this._directory.getInteger(QuickTimeVideoDirectory.TAG_DEPTH) < 16) {
          return "Default";
        } else {
          return "None";
        }
      case (0):
        return "Color table within file";
      default:
        return "Unknown (" + value + ")";
    }
  }

  private getGraphicsModeDescription(): string {
    LogUtil.debug(TAG, `getGraphicsModeDescription start`);
    let value: number = this._directory.getInteger(QuickTimeVideoDirectory.TAG_GRAPHICS_MODE);
    if (value == null) {
      LogUtil.debug(TAG, `getGraphicsModeDescription end, value is null`);
      return null;
    }

    LogUtil.debug(TAG, `getGraphicsModeDescription end, value: ${value}`);
    switch (value) {
      case (0x00):
        return "Copy";
      case (0x40):
        return "Dither copy";
      case (0x20):
        return "Blend";
      case (0x24):
        return "Transparent";
      case (0x100):
        return "Straight alpha";
      case (0x101):
        return "Premul white alpha";
      case (0x102):
        return "Premul black alpha";
      case (0x104):
        return "Straight alpha blend";
      case (0x103):
        return "Composition (dither copy)";
      default:
        return "Unknown (" + value + ")";
    }
  }
}

export default QuickTimeVideoDescriptor