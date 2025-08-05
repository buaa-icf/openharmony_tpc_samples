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

import Box from './Box';
import SequentialReader from '../../../lang/SequentialReader';
import HeifDirectory from '../HeifDirectory';
import LogUtil from '../../../tools/LogUtils';

const TAG: string = "FileTypeBox";

class FileTypeBox extends Box {
  public majorBrand: string;
  public minorVersion: number;
  public compatibleBrands: Set<string>;

  public constructor(reader: SequentialReader, box: Box) {
    super(null, box);
    LogUtil.debug(TAG, `constructor start, size: ${this.size}`);
    this.majorBrand = reader.getString(4);
    this.minorVersion = reader.getUInt32();
    this.compatibleBrands = new Set<string>();
    for (let i = 16; i < this.size; i += 4) {
      this.compatibleBrands.add(reader.getString(4));
    }
    LogUtil.debug(TAG, `constructor end`);
  }

  public addMetadata(directory: HeifDirectory): void {
    LogUtil.debug(TAG, `addMetadata start`);
    directory.setString(HeifDirectory.TAG_MAJOR_BRAND, this.majorBrand);
    directory.setLong(HeifDirectory.TAG_MINOR_VERSION, this.minorVersion);
    let brands:Array<string> =new Array()
    for(let item of this.compatibleBrands){
      brands.push(item)
    }
    directory.setStringArray(HeifDirectory.TAG_COMPATIBLE_BRANDS, brands);
    LogUtil.debug(TAG, `addMetadata end`);
  }

  public getCompatibleBrands(): Set<string> {
    return this.compatibleBrands;
  }
}

export default FileTypeBox;