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

import FileType from '../FileType'
import StringValue from '../../metadata/StringValue'
import TypeChecker from '../TypeChecker'
import LogUtil from '../../tools/LogUtils';

const TAG: string = "RiffTypeChecker";

class RiffTypeChecker implements TypeChecker {
  public getByteCount(): number {
    return 12;
  }

  public checkType(bytes: Int8Array): FileType {
    LogUtil.debug(TAG, `checkType start, bytes length: ${bytes.length}`);
    let firstFour: string = StringValue.Int8Array2String(bytes, 'utf-8', 0, 4);
    if (firstFour != "RIFF") {
      LogUtil.debug(TAG, `checkType end, firstFour not RIFF: ${firstFour}`);
      return FileType.Unknown;
    }

    let fourCC: string = StringValue.Int8Array2String(bytes, 'utf-8', 8, 12);
    if (fourCC == "WAVE") {
      LogUtil.debug(TAG, `checkType end, found WAVE FourCC: ${fourCC}`);
      return FileType.Wav;
    }
    if (fourCC == "AVI ") {
      LogUtil.debug(TAG, `checkType end, found AVI FourCC: ${fourCC}`);
      return FileType.Avi;
    }
    if (fourCC == "WEBP") {
      LogUtil.debug(TAG, `checkType end, found WEBP FourCC: ${fourCC}`);
      return FileType.WebP;
    }

    LogUtil.debug(TAG, `checkType end, found RIFF FourCC: ${fourCC}`);
    return FileType.Riff;
  }
}

export default RiffTypeChecker