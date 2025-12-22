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

import Metadata from '../Metadata';
import XmpDirectory from './XmpDirectory';
import { XMPMeta } from '@ohos/xmptool';
import { XMPMetaFactory } from '@ohos/xmptool';
import { SerializeOptions } from '@ohos/xmptool';

class XmpWriter {
  /**
   * Helper method to find the first XmpDirectory in metadata
   */
  private static getFirstXmpDirectory(data: Metadata): XmpDirectory | null {
    for (let directory of data.getDirectories()) {
      if (directory instanceof XmpDirectory) {
        return directory;
      }
    }
    return null;
  }

  /**
   * Serializes the XmpDirectory component of Metadata into a Uint8Array
   * @param data populated metadata
   * @return serialized XMP data as Uint8Array, or null if no XMP directory exists
   */
  public static async serializeToBuffer(data: Metadata): Promise<Uint8Array | null> {
    let dir: XmpDirectory | null = XmpWriter.getFirstXmpDirectory(data);
    if (dir == null) {
      return null;
    }

    let meta: XMPMeta = dir.getXMPMeta();
    let so: SerializeOptions = new SerializeOptions().setOmitPacketWrapper(true);
    return await XMPMetaFactory.serializeToBuffer(meta, so);
  }

  /**
   * Serializes the XmpDirectory component of Metadata into a string
   * @param data populated metadata
   * @return serialized XMP data as string, or null if no XMP directory exists
   */
  public static async serializeToString(data: Metadata): Promise<string | null> {
    let dir: XmpDirectory | null = XmpWriter.getFirstXmpDirectory(data);
    if (dir == null) {
      return null;
    }

    let meta: XMPMeta = dir.getXMPMeta();
    let so: SerializeOptions = new SerializeOptions().setOmitPacketWrapper(true);
    return await XMPMetaFactory.serializeToString(meta, so);
  }
}

export default XmpWriter;