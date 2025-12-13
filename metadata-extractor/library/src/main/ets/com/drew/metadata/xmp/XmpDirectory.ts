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

import Directory from '../Directory';
import XmpDescriptor from './XmpDescriptor';
import LogUtil from '../../tools/LogUtils';
import { XMPMeta } from 'xmptool';
import { XMPMetaImpl } from 'xmptool';
import { IteratorOptions } from 'xmptool';
import { XMPIterator } from 'xmptool';
import { XMPPropertyInfo } from 'xmptool';

const TAG: string = "[XMP] XmpDirectory";

class XmpDirectory extends Directory {
  public static readonly TAG_XMP_VALUE_COUNT: number = 0xFFFF;
  private static readonly _tagNameMap: Map<number, string> = new Map<number, string>()
    .set(XmpDirectory.TAG_XMP_VALUE_COUNT, "XMP Value Count");

  private _xmpMeta: XMPMeta | null = null;

  public constructor() {
    super();
    this.setDescriptor(new XmpDescriptor(this));
  }

  public getName(): string {
    return "XMP";
  }

  protected getTagNameMap(): Map<number, string> {
    return XmpDirectory._tagNameMap;
  }

  /**
   * Gets a map of all XMP properties in this directory.
   * <p>
   * This is required because XMP properties are represented as strings, whereas the rest of this library
   * uses integers for keys.
   */
  public getXmpProperties(): Map<string, string> {
    LogUtil.debug(TAG, `getXmpProperties start`);
    let propertyValueByPath: Map<string, string> = new Map<string, string>();

    if (this._xmpMeta != null) {
      try {
        let options: IteratorOptions = new IteratorOptions().setJustLeafnodes(true);
        let iterator: XMPIterator = this._xmpMeta.iterator(options);
        while (iterator.hasNext()) {
          let prop: XMPPropertyInfo = iterator.next();
          let path: string = prop.getPath();
          let value: string = prop.getValue();
          if (path != null && value != null) {
            propertyValueByPath.set(path, value);
          }
        }
      } catch (error) {
        LogUtil.error(TAG, `getXmpProperties error: ${JSON.stringify(error)}`);
        // Fail silently, return empty map
      }
    }
    LogUtil.debug(TAG, `getXmpProperties end`);
    return propertyValueByPath;
  }

  public setXMPMeta(xmpMeta: XMPMeta): void {
    LogUtil.debug(TAG, `setXMPMeta start`);
    this._xmpMeta = xmpMeta;

    let valueCount: number = 0;
    try {
      let options: IteratorOptions = new IteratorOptions().setJustLeafnodes(true);
      let iterator: XMPIterator = this._xmpMeta.iterator(options);
      while (iterator.hasNext()) {
        let prop: XMPPropertyInfo = iterator.next();
        if (prop.getPath() != null) {
          valueCount++;
        }
      }
    } catch (error) {
      LogUtil.error(TAG, `setXMPMeta error: ${JSON.stringify(error)}`);
      // Continue - we still want to set the count even if iteration fails
    }
    // Always set the tag to ensure directory is not empty
    this.setInt(XmpDirectory.TAG_XMP_VALUE_COUNT, valueCount);
    LogUtil.debug(TAG, `setXMPMeta end, valueCount: ${valueCount}`);
  }

  /**
   * Gets the XMPMeta object used to populate this directory. It can be used for more XMP-oriented operations.
   * If one does not exist it will be created.
   */
  public getXMPMeta(): XMPMeta {
    LogUtil.debug(TAG, `getXMPMeta start`);
    if (this._xmpMeta == null) {
      this._xmpMeta = new XMPMetaImpl() as ESObject as XMPMeta;
    }
    LogUtil.debug(TAG, `getXMPMeta end`);
    return this._xmpMeta;
  }
}

export default XmpDirectory;