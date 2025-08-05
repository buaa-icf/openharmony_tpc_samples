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

import fileio from '@ohos.fileio';
import FileSystemDirectory from './FileSystemDirectory';
import Metadata from '../Metadata';
import LogUtil from '../../tools/LogUtils';

const TAG: string = "FileSystemMetadataReader";

class FileSystemMetadataReader {
  public read(filePath: string, metadata: Metadata): void
  {
    LogUtil.debug(TAG, `read start, filePath: ${filePath}`);
    let directory = metadata.getFirstDirectoryOfType(new FileSystemDirectory());
    if (directory == null) {
      LogUtil.debug(TAG, `directory is null, create new directory`);
      directory = new FileSystemDirectory();
      metadata.addDirectory(directory);
    }
    let fd = fileio.openSync(filePath);
    let stat = fileio.statSync(filePath);

    directory.setString(FileSystemDirectory.TAG_FILE_NAME, filePath.substr(filePath.lastIndexOf('/') + 1, filePath.length));
    directory.setLong(FileSystemDirectory.TAG_FILE_SIZE, stat.size);
    directory.setDate(FileSystemDirectory.TAG_FILE_MODIFIED_DATE, new Date(stat.mtime * 1000));
    LogUtil.debug(TAG, `read end`);
  }
}

export default FileSystemMetadataReader
