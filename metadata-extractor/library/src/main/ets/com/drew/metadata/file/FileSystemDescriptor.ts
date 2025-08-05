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

import FileSystemDirectory from './FileSystemDirectory';
import TagDescriptor from '../TagDescriptor';
import LogUtil from '../../tools/LogUtils';

const TAG: string = "FileSystemDescriptor";

class FileSystemDescriptor extends TagDescriptor<FileSystemDirectory> {
  constructor(directory: FileSystemDirectory) {
    super(directory);
  }

  public getDescription(tagType: number): string
  {
    LogUtil.debug(TAG, `getDescription start, tagType = ${tagType}`);
    switch (tagType) {
      case FileSystemDirectory.TAG_FILE_SIZE:
        return this.getFileSizeDescription();
      default:
        return super.getDescription(tagType);
    }
  }

  private getFileSizeDescription(): string
  {
    LogUtil.debug(TAG, `getFileSizeDescription start`);
    let size = this._directory.getLongObject(FileSystemDirectory.TAG_FILE_SIZE);

    if (size == null) {
      LogUtil.error(TAG, `getFileSizeDescription end, size is null`);
      return null;
    }

    LogUtil.debug(TAG, `getFileSizeDescription end, size = ${size}`);
    return size + " bytes";
  }
}

export default FileSystemDescriptor

