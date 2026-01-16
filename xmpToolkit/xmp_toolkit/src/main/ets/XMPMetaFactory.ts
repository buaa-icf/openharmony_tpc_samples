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

import XMPMeta from './XMPMeta';
import XMPSchemaRegistry from './XMPSchemaRegistry';
import XMPException from './XMPException';
import XMPError from './XMPError';
import XMPVersionInfo from './XMPVersionInfo';
import ParseOptions from './options/ParseOptions';
import SerializeOptions from './options/SerializeOptions';
import XMPMetaParser from './impl/XMPMetaParser';
import XMPSerializerHelper from './impl/XMPSerializerHelper';
import XMPMetaImpl from './impl/XMPMetaImpl';
import { XMPSchemaRegistryImpl } from './impl/XMPSchemaRegistryImpl';
import versionData from '../resources/base/profile/version.json';

/**
 * Creates XMPMeta-instances from an InputStream or other sources
 */
export default class XMPMetaFactory {
  /** The singleton instance of the XMPSchemaRegistry. */
  private static schema: XMPSchemaRegistry | null = null;
  /** cache for version info */
  private static versionInfo: XMPVersionInfo | null = null;

  /**
   * Hides public constructor
   */
  private constructor() {
    // EMPTY
  }

  /**
   * @return Returns the singleton instance of the XMPSchemaRegistry.
   */
  public static getSchemaRegistry(): XMPSchemaRegistry {
    if (XMPMetaFactory.schema === null) {
      XMPMetaFactory.schema = new XMPSchemaRegistryImpl();
    }
    return XMPMetaFactory.schema;
  }

  /**
   * @return Returns an empty XMPMeta-object.
   */
  public static create(): XMPMeta {
    return new XMPMetaImpl() as ESObject as XMPMeta;
  }

  /**
   * These functions support parsing serialized RDF into an XMP object, and serailizing an XMP
   * object into RDF. The input for parsing may be any valid Unicode
   * encoding. ISO Latin-1 is also recognized, but its use is strongly discouraged. Serialization
   * is always as UTF-8.
   * <p>
   * parseFromBuffer() parses RDF from an InputStream. The encoding
   * is recognized automatically.
   *
   * @param input an ArrayBuffer
   * @param options Options controlling the parsing.
   * @return Returns the XMPMeta-object created from the input.
   * @throws XMPException If the file is not well-formed XML or if the parsing fails.
   */
  public static parse(input: ArrayBuffer, options?: ParseOptions): XMPMeta {
    if (options) {
      return XMPMetaParser.parse(input, options);
    } else {
      return XMPMetaParser.parse(input, null);
    }
  }

  /**
   * Creates an XMPMeta-object from a string.
   * @param packet a String contain an XMP-file.
   * @param options Options controlling the parsing.
   * @return Returns the XMPMeta-object created from the input.
   * @throws XMPException If the file is not well-formed XML or if the parsing fails.
   */
  public static parseFromString(packet: string, options?: ParseOptions): XMPMeta {
    if (options) {

      return XMPMetaParser.parse(packet, options);
    } else {
      return XMPMetaParser.parse(packet, null);

    }
  }

  /**
   * Creates an XMPMeta-object from a byte-buffer.
   * @param buffer a byte array contain an XMP-file.
   * @param options Options controlling the parsing.
   * @return Returns the XMPMeta-object created from the input.
   * @throws XMPException If the file is not well-formed XML or if the parsing fails.
   */
  public static parseFromBuffer(buffer: Uint8Array, options?: ParseOptions): XMPMeta {
    if (options) {
      return XMPMetaParser.parse(buffer, options);
    } else {
      return XMPMetaParser.parse(buffer, null);
    }
  }

  /**
   * Serializes an XMPMeta-object as RDF into an OutputStream.
   *
   * @param xmp a metadata object 
   * @param out an ArrayBuffer to write the serialized RDF to.
   * @param options Options to control the serialization (see SerializeOptions).
   * @throws XMPException on serializsation errors.
   */
  public static async serialize(xmp: XMPMeta, out: ESObject, options?: SerializeOptions): Promise<void> {
    XMPMetaFactory.assertImplementation(xmp);
    await XMPSerializerHelper.serialize(xmp as ESObject as XMPMetaImpl, out as ESObject, options || null);
  }

  /**
   * Serializes an XMPMeta-object as RDF into a byte buffer.
   *
   * @param xmp a metadata object 
   * @param options Options to control the serialization (see SerializeOptions).
   * @return Returns a byte buffer containing the serialized RDF.
   * @throws XMPException on serializsation errors.
   */
  public static async serializeToBuffer(xmp: XMPMeta, options?: SerializeOptions): Promise<Uint8Array> {
    XMPMetaFactory.assertImplementation(xmp);
    return await XMPSerializerHelper.serializeToBuffer(xmp as ESObject as XMPMetaImpl, options || null);
  }

  /**
   * Serializes an XMPMeta-object as RDF into a string. Note: Encoding
   * is ignored when serializing to a string.
   *
   * @param xmp a metadata object 
   * @param options Options to control the serialization (see SerializeOptions).
   * @return Returns a string containing the serialized RDF.
   * @throws XMPException on serializsation errors.
   */
  public static async serializeToString(xmp: XMPMeta, options?: SerializeOptions): Promise<string> {
    XMPMetaFactory.assertImplementation(xmp);
    return await XMPSerializerHelper.serializeToString(xmp as ESObject as XMPMetaImpl, options || null);
  }

  /**
   * @param xmp Asserts that xmp is compatible to XMPMetaImpl.
   */
  private static assertImplementation(xmp: XMPMeta): void {
    if (!(xmp instanceof XMPMetaImpl)) {
      throw new XMPException('The serializing service works only with the XMPMeta implementation of this library', 
        XMPError.UNKNOWN);
    }
  }

  /**
   * Resets the schema registry to its original state (creates a new one).
   * Be careful this might break all existing XMPMeta-objects and should be used
   * only for testing purpurses. 
   */
  public static reset(): void {
    XMPMetaFactory.schema = new XMPSchemaRegistryImpl();
  }

  /**
   * Obtain version information. The XMPVersionInfo singleton is created the first time
   * its requested.
   *
   * @return Returns the version information.
   */
  public static  getVersionInfo(): XMPVersionInfo {
    if (XMPMetaFactory.versionInfo == null) {
      try {
        const versionStr = versionData.version;
        let major: number = 1;
        let minor: number = 0;
        let micro: number = 0;
        let engBuild: number = 0;
        let debug: boolean = versionData.isDebug;
        const message = 'XMP Core' + versionStr;

        const dashIndex = versionStr.indexOf('-');
        const versionPart = dashIndex >= 0 ? versionStr.substring(0, dashIndex) : versionStr;
        const engBuildStr = dashIndex >= 0 ? versionStr.substring(dashIndex + 1) : "";
        const dotParts = versionPart.split('.');
        if (dotParts.length >= 1) {
          major = parseInt(dotParts[0]) || 0;
        }
        if (dotParts.length >= 2) {
          minor = parseInt(dotParts[1]) || 0;
        }
        if (dotParts.length >= 3) {
          micro = parseInt(dotParts[2]) || 0;
        }
        if (engBuildStr) {
          const match = engBuildStr.match(/\d+/);
          if (match) {
            engBuild = parseInt(match[0]) || 0;
          }
        }

        class VersionInfoImpl implements XMPVersionInfo {
          getMajor(): number {
            return major;
          }

          getMinor(): number {
            return minor;
          }

          getMicro(): number {
            return micro;
          }

          isDebug(): boolean {
            return debug;
          }

          getBuild(): number {
            return engBuild;
          }

          getMessage(): string {
            return message;
          }

          toString(): string {
            return message;
          }
        }

        XMPMetaFactory.versionInfo = new VersionInfoImpl();
      } catch (e) {
        // EMPTY, severe error would be detected during the tests
        console.error(e);
      }
    }
    return XMPMetaFactory.versionInfo!;
  }
}