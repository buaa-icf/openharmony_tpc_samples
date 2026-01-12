/*
Copyright (c) 2026 Huawei Device Co., Ltd.
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

import XMPMeta from '../XMPMeta';
import XMPMetaImpl from './XMPMetaImpl';
import XMPSerializerRDF from './XMPSerializerRDF';
import SerializeOptions from '../options/SerializeOptions';
import XMPError from '../XMPError';
import XMPException from '../XMPException';
import { util } from '@kit.ArkTS';

/**
 * The <code>XMPSerializerHelper</code> provides utility methods to serialize XMP metadata.
 * 
 * @since 12.01.2006
 */
export default class XMPSerializerHelper {
  /**
   * Private constructor, the class should not be instantiated.
   */
  private constructor() {
    // EMPTY
  }

  /**
   * Static method to serialize the metadata object. For each serialisation, a new XMPSerializer
   * instance is created, either XMPSerializerRDF or XMPSerializerPlain so thats its possible to 
   * serialialize the same XMPMeta objects in two threads.
   * 
   * @param xmp a metadata implementation object
   * @param out the output stream to serialize to
   * @param options serialization options, can be <code>null</code> for default.
   * @throws XMPException
   */
  public static async serialize(xmp: XMPMetaImpl, out: ESObject,
                                options: SerializeOptions | null): Promise<void> {
    const finalOptions: SerializeOptions = options !== null ? options : new SerializeOptions();
    
    // sort the internal data model on demand
    if (finalOptions.getSort()) {
      xmp.sort();
    }
    await new XMPSerializerRDF().serialize(xmp, out, finalOptions);
  }

  /**
   * Serializes an <code>XMPMeta</code>-object as RDF into a string.
   * <em>Note:</em> Encoding is forced to UTF-16 when serializing to a
   * string to ensure the correctness of &quot;exact packet size&quot;.
   * 
   * @param xmp a metadata implementation object
   * @param options Options to control the serialization (see
   *            {@link SerializeOptions}).
   * @return Returns a string containing the serialized RDF.
   * @throws XMPException on serializsation errors.
   */
  public static async serializeToString(xmp: XMPMetaImpl, options: SerializeOptions | null): Promise<string> {
    // forces the encoding to be UTF-16 to get the correct string length
    const finalOptions: SerializeOptions = options !== null ? options : new SerializeOptions();
    finalOptions.setEncodeUTF16BE(true);

    // Use array for better performance (avoid string concatenation)
    const chunks: string[] = [];
    const outputStream: ESObject = {
      write: (data: string | Uint8Array | number[]): void => {
        if (typeof data === 'string') {
          chunks.push(data);
        } else if (Array.isArray(data)) {
          chunks.push(String.fromCharCode(...data));
        } else {
          chunks.push(String.fromCharCode(...Array.from(data)));
        }
      }
    };

    await XMPSerializerHelper.serialize(xmp, outputStream, finalOptions);

    // Join all chunks at the end
    return chunks.join('');
  }

  /**
   * Serializes an <code>XMPMeta</code>-object as RDF into a byte buffer.
   * 
   * @param xmp a metadata implementation object
   * @param options Options to control the serialization (see {@link SerializeOptions}).
   * @return Returns a byte buffer containing the serialized RDF.
   * @throws XMPException on serializsation errors.
   */
  public static async serializeToBuffer(xmp: XMPMetaImpl, options: SerializeOptions | null): Promise<Uint8Array> {
    // Use array for better performance
    const chunks: string[] = [];
    const outputStream: ESObject = {
      write: (data: string | Uint8Array | number[]): void => {
        if (typeof data === 'string') {
          chunks.push(data);
        } else if (Array.isArray(data)) {
          chunks.push(String.fromCharCode(...data));
        } else {
          chunks.push(String.fromCharCode(...Array.from(data)));
        }
      }
    };
    
    await XMPSerializerHelper.serialize(xmp, outputStream, options);
    
    // Convert string to UTF-8 byte array
    // 根据 HarmonyOS API: encodeInto(src) 直接返回 Uint8Array
    const encoder = new util.TextEncoder();
    const str = chunks.join('');
    return encoder.encodeInto(str);
  }
  
  /**
   * Converts a byte array to a string using the specified encoding.
   * @param bytes The byte array to convert
   * @param encoding The encoding to use (UTF-8, UTF-16BE, UTF-16LE)
   * @return The string representation
   */
  private static bytesToString(bytes: number[], encoding: string): string {
    if (encoding === "UTF-16BE" || encoding === "UTF-16LE") {
      // UTF-16 encoding
      let result = "";
      const isBE = encoding === "UTF-16BE";
      for (let i = 0; i < bytes.length; i += 2) {
        if (i + 1 < bytes.length) {
          const charCode = isBE ? (bytes[i] << 8) | bytes[i + 1] : bytes[i] | (bytes[i + 1] << 8);
          result += String.fromCharCode(charCode);
        }
      }
      return result;
    } else {
      // UTF-8 encoding
      let result = "";
      let i = 0;
      while (i < bytes.length) {
        let charCode = bytes[i++];
        if (charCode < 0x80) {
          result += String.fromCharCode(charCode);
        } else if ((charCode & 0xE0) === 0xC0) {
          // 2-byte character
          if (i < bytes.length) {
            charCode = ((charCode & 0x1F) << 6) | (bytes[i++] & 0x3F);
            result += String.fromCharCode(charCode);
          }
        } else if ((charCode & 0xF0) === 0xE0) {
          // 3-byte character
          if (i + 1 < bytes.length) {
            charCode = ((charCode & 0x0F) << 12) | ((bytes[i++] & 0x3F) << 6) | (bytes[i++] & 0x3F);
            result += String.fromCharCode(charCode);
          }
        } else if ((charCode & 0xF8) === 0xF0) {
          // 4-byte character (surrogate pair)
          if (i + 2 < bytes.length) {
            const codePoint = ((charCode & 0x07) << 18) | ((bytes[i++] & 0x3F) << 12) | 
                             ((bytes[i++] & 0x3F) << 6) | (bytes[i++] & 0x3F);
            if (codePoint > 0xFFFF) {
              const surrogate1 = 0xD800 + ((codePoint - 0x10000) >> 10);
              const surrogate2 = 0xDC00 + ((codePoint - 0x10000) & 0x3FF);
              result += String.fromCharCode(surrogate1, surrogate2);
            } else {
              result += String.fromCharCode(codePoint);
            }
          }
        }
      }
      return result;
    }
  }
}