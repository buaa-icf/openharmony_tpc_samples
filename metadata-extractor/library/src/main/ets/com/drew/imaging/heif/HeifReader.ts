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

import Box from '../../metadata/heif/boxes/Box';
import HeifHandler from './HeifHandler';
import HeifBoxTypes from '../../metadata/heif/HeifBoxTypes';
import HeifContainerTypes from '../../metadata/heif/HeifContainerTypes';
import HeifDirectory from '../../metadata/heif/HeifDirectory';
import StreamReader from '../../lang/StreamReader';
import SequentialReader from '../../lang/SequentialReader';
import LogUtil from '../../tools/LogUtils';

const TAG: string = "HeifReader";

class HeifReader {
  private static readonly ACCEPTABLE_PRE_META_BOX_TYPES: Set<string> = new Set<string>()
    .add(HeifBoxTypes.BOX_FILE_TYPE)
    .add(HeifContainerTypes.BOX_METADATA);

  public extract(reader: SequentialReader, handler: HeifHandler): void {
    LogUtil.debug(TAG, `extract start`);
    // We need to read through the input stream to find the meta box which will tell us what handler to use

    // The meta box is not necessarily the first box, so we need to mark the input stream (if we can)
    // so we can re-read the stream with the proper handler if necessary
    try {
      /*let inputStream = fileio.createStreamSync(filePath, 'r+');

      let markSupported: boolean = false;
      if (inputStream.markSupported()) {
        markSupported = true;
        inputStream.mark(inputStream.available() + 1); // +1 since we're going to read past the end of the stream by 1 byte
      }*/

      reader.setMotorolaByteOrder(true);

      this.processTopLevelBoxes(reader, -1, handler);
    } catch (error) {
      // Any errors should have been added to the directory
      LogUtil.error(TAG, `Error processing HEIF metadata: ${JSON.stringify(error)}`);
    }
  }

  private processTopLevelBoxes(reader: SequentialReader,
                               atomEnd: number,
                               handler: HeifHandler): void {
    LogUtil.debug(TAG, `processTopLevelBoxes start, atomEnd: ${atomEnd}`);
    let foundMetaBox: boolean = false;
    let needToReset: boolean = false;
    try {
      while (atomEnd == -1 || reader.getPosition() < atomEnd) {
        let box: Box = new Box(reader);

        if (!foundMetaBox && !HeifReader.ACCEPTABLE_PRE_META_BOX_TYPES.has(box.type)) {
          // If we hit a box that needs a more specific handler (like mdat) without yet hitting the meta box,
          // we'll need to reset the stream and use the correct handler once we find it
          needToReset = true;
        }

        if (HeifContainerTypes.BOX_METADATA == box.type) {
          foundMetaBox = true;
        }

        handler = this.processBox(reader, box, handler);
      }
    } catch (error) {
      // Currently, reader relies on IOException to end
      LogUtil.error(TAG, `Error processing HEIF metadata: ${JSON.stringify(error)}`);
    }

    if (needToReset) {
      this.processBoxes(reader, -1, handler);
    } else if (needToReset) {
      //let heifDirectory: HeifDirectory = handler.metadata.getFirstDirectoryOfType(HeifDirectory.class);
      let heifDirectory: HeifDirectory;
      if (heifDirectory != null) {
        heifDirectory.addError("Unable to extract Exif data because inputStream was not resettable and 'meta' was not first box");
      }
    }
  }

  private processBoxes(reader: SequentialReader, atomEnd: number, handler: HeifHandler): HeifHandler {
    LogUtil.debug(TAG, `processBoxes start`);
    try {
      while (atomEnd == -1 || reader.getPosition() < atomEnd) {
        let box: Box = new Box(reader);
        handler = this.processBox(reader, box, handler);
      }
    } catch (Error) {
      // Currently, reader relies on IOException to end
      LogUtil.error(TAG, `Error processing HEIF metadata: ${JSON.stringify(Error)}`);
    }
    LogUtil.debug(TAG, `processBoxes end`);
    return handler;
  }

  private processBox(reader: SequentialReader, box: Box, handler: HeifHandler): HeifHandler {
    LogUtil.debug(TAG, `processBox start`);
    if (handler.shouldAcceptContainer(box)) {
      LogUtil.debug(TAG, `processBox: shouldAcceptContainer`);
      handler.processContainer(box, reader);
      handler = this.processBoxes(reader, box.size + reader.getPosition() - 8, handler);
    } else if (handler.shouldAcceptBox(box)) {
      LogUtil.debug(TAG, `processBox: shouldAcceptBox`);
      handler = handler.processBox(box, reader.getBytes(box.size - 8));
    } else if (box.size > 1) {
      LogUtil.debug(TAG, `processBox: skip box`);
      reader.skip(box.size - 8);
    }
    LogUtil.debug(TAG, `processBox end`);
    return handler;
  }
}

export default HeifReader;