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

import JpegSegmentMetadataReader from '../../imaging/jpeg/JpegSegmentMetadataReader';
import JpegSegmentType from '../../imaging/jpeg/JpegSegmentType';
import Metadata from '../Metadata';
import XmpDirectory from './XmpDirectory';
import Directory from '../Directory';
import SequentialReader from '../../lang/SequentialReader';
import SequentialByteArrayReader from '../../lang/SequentialByteArrayReader';
import LogUtil from '../../tools/LogUtils';
import { XMPMeta } from '@ohos/xmptool';
import { XMPMetaFactory } from '@ohos/xmptool';
import { ParseOptions } from '@ohos/xmptool';
import { IteratorOptions } from '@ohos/xmptool';
import { XMPIterator } from '@ohos/xmptool';
import { XMPPropertyInfo } from '@ohos/xmptool';

const TAG: string = "[XMP] XmpReader";

class XmpReader implements JpegSegmentMetadataReader {
  private static readonly XMP_JPEG_PREAMBLE: string = "http://ns.adobe.com/xap/1.0/\0";
  private static readonly XMP_EXTENSION_JPEG_PREAMBLE: string = "http://ns.adobe.com/xmp/extension/\0";
  private static readonly SCHEMA_XMP_NOTES: string = "http://ns.adobe.com/xmp/note/";
  private static readonly ATTRIBUTE_EXTENDED_XMP: string = "xmpNote:HasExtendedXMP";

  /**
   * Extended XMP constants
   */
  private static readonly EXTENDED_XMP_GUID_LENGTH: number = 32;
  private static readonly EXTENDED_XMP_INT_LENGTH: number = 4;

  public getSegmentTypes(): Set<JpegSegmentType> {
    let segmentTypes: Set<JpegSegmentType> = new Set<JpegSegmentType>();
    segmentTypes.add(JpegSegmentType.APP1);
    return segmentTypes;
  }

  public readJpegSegments(segments: Iterable<Int8Array>, metadata: Metadata, segmentType: JpegSegmentType): void {
    LogUtil.debug(TAG, `readJpegSegments start, segmentType: ${segmentType}`);
    let preambleLength: number = XmpReader.XMP_JPEG_PREAMBLE.length;
    let extensionPreambleLength: number = XmpReader.XMP_EXTENSION_JPEG_PREAMBLE.length;
    let extendedXMPGUID: string | null = null;
    let extendedXMPBuffer: Int8Array | null = null;
    let segmentCount: number = 0;

    for (let segmentBytes of segments) {
      segmentCount++;
      LogUtil.debug(TAG, `Processing segment #${segmentCount}, length: ${segmentBytes.length}`);
      
      // XMP in a JPEG file has an identifying preamble which is not valid XML
      if (segmentBytes.length >= preambleLength) {
        // NOTE we expect the full preamble here, but some images (such as that reported on GitHub #102)
        // start with "XMP\0://ns.adobe.com/xap/1.0/" which appears to be an error but is easily recovered
        // from. In such cases, the actual XMP data begins at the same offset.
        let segmentString: string = XmpReader.int8ArrayToString(segmentBytes);
        let preambleCheck: string = segmentString.substring(0, preambleLength);
        let xmpCheck: string = segmentString.substring(0, 3);
        
        LogUtil.debug(TAG, `Preamble check: '${preambleCheck.substring(0, 30)}...'`);
        LogUtil.debug(TAG, `Expected preamble: '${XmpReader.XMP_JPEG_PREAMBLE.substring(0, 30)}...'`);

        if (XmpReader.XMP_JPEG_PREAMBLE.toLowerCase() === preambleCheck.toLowerCase()
          || "XMP".toLowerCase() === xmpCheck.toLowerCase()) {
          LogUtil.debug(TAG, `Found XMP preamble! Extracting XMP data...`);
          let xmlBytes: Uint8Array = new Uint8Array(segmentBytes.length - preambleLength);
          for (let i = 0; i < xmlBytes.length; i++) {
            xmlBytes[i] = segmentBytes[preambleLength + i];
          }
          LogUtil.debug(TAG, `XMP data length: ${xmlBytes.length}`);
          this.extract(xmlBytes, 0, xmlBytes.length, metadata, null);
          // Check in the Standard XMP if there should be a Extended XMP part in other chunks.
          extendedXMPGUID = XmpReader.getExtendedXMPGUID(metadata);
          continue;
        }

        // If we know that there's Extended XMP chunks, look for them.
        if (extendedXMPGUID != null
          && segmentBytes.length >= extensionPreambleLength) {
          let extensionPreambleCheck: string = segmentString.substring(0, extensionPreambleLength);
          if (XmpReader.XMP_EXTENSION_JPEG_PREAMBLE.toLowerCase() === extensionPreambleCheck.toLowerCase()) {
            extendedXMPBuffer = XmpReader.processExtendedXMPChunk(metadata, segmentBytes, extendedXMPGUID, extendedXMPBuffer);
          }
        }
      }
    }

    // Now that the Extended XMP chunks have been concatenated, let's parse and merge with the Standard XMP.
    if (extendedXMPBuffer != null) {
      let uint8Buffer: Uint8Array = new Uint8Array(extendedXMPBuffer.length);
      for (let i = 0; i < extendedXMPBuffer.length; i++) {
        uint8Buffer[i] = extendedXMPBuffer[i];
      }
      this.extract(uint8Buffer, 0, uint8Buffer.length, metadata, null);
    }
    LogUtil.debug(TAG, `readJpegSegments end, processed ${segmentCount} segments`);
  }

  /**
   * Helper function to convert Int8Array to string
   */
  private static int8ArrayToString(arr: Int8Array): string {
    let result = '';
    for (let i = 0; i < arr.length; i++) {
      result += String.fromCharCode(arr[i] & 0xFF);
    }
    return result;
  }

  /**
   * Performs the XMP data extraction, adding found values to the specified instance of {@link Metadata}.
   * <p>
   * The extraction is done with xmptool library.
   */
  public extract(xmpBytes: Int8Array | Uint8Array, offset: number | null, length: number | null, metadata: Metadata, parentDirectory?: Directory | null): void {
    LogUtil.debug(TAG, `extract start`);
    let directory: XmpDirectory = new XmpDirectory();
    if (parentDirectory != null) {
      LogUtil.debug(TAG, `parentDirectory is not null, calling setParent`);
      directory.setParent(parentDirectory);
    }

    try {
      // Convert Int8Array to Uint8Array if necessary
      let bytes: Uint8Array;
      if (xmpBytes instanceof Int8Array) {
        bytes = new Uint8Array(xmpBytes.buffer, xmpBytes.byteOffset, xmpBytes.byteLength);
      } else {
        bytes = xmpBytes;
      }

      // Handle null offset/length - default to full array
      let actualOffset: number = offset ?? 0;
      let actualLength: number = length ?? bytes.length;

      let xmpMeta: XMPMeta;

      // If all bytes are requested, no need to make a new buffer
      if (actualOffset === 0 && actualLength === bytes.length) {
        LogUtil.debug(TAG, `Calling XMPMetaFactory.parseFromBuffer with ${bytes.length} bytes`);
        xmpMeta = XMPMetaFactory.parseFromBuffer(bytes);
      } else {
        let buffer: Uint8Array = bytes.slice(actualOffset, actualOffset + actualLength);
        LogUtil.debug(TAG, `Calling XMPMetaFactory.parseFromBuffer with sliced ${buffer.length} bytes`);
        xmpMeta = XMPMetaFactory.parseFromBuffer(buffer);
      }
      LogUtil.debug(TAG, `parseFromBuffer completed, xmpMeta: ${xmpMeta != null}`);
      LogUtil.debug(TAG, `Calling directory.setXMPMeta...`);
      directory.setXMPMeta(xmpMeta);
      LogUtil.debug(TAG, `directory.setXMPMeta completed`);
    } catch (error) {
      LogUtil.error(TAG, `Error processing XMP data: ${JSON.stringify(error)}`);
      LogUtil.error(TAG, `Error stack: ${(error as Error).stack}`);
      directory.addError("Error processing XMP data: " + error);
    }
    LogUtil.debug(TAG, `directory.isEmpty(): ${directory.isEmpty()}`);
    if (!directory.isEmpty()) {
      LogUtil.debug(TAG, `Adding XmpDirectory to metadata`);
      metadata.addDirectory(directory);
    } else {
      LogUtil.debug(TAG, `XmpDirectory is empty, not adding to metadata`);
    }
    LogUtil.debug(TAG, `extract end`);
  }

  /**
   * Performs the XMP data extraction from a string.
   */
  public extractString(xmpString: string, metadata: Metadata, parentDirectory: Directory | null): void {
    LogUtil.debug(TAG, `extractString start`);
    let directory: XmpDirectory = new XmpDirectory();
    if (parentDirectory != null) {
      LogUtil.debug(TAG, `parentDirectory is not null, calling setParent`);
      directory.setParent(parentDirectory);
    }

    try {
      let xmpMeta: XMPMeta = XMPMetaFactory.parseFromString(xmpString);
      directory.setXMPMeta(xmpMeta);
    } catch (error) {
      LogUtil.error(TAG, `Error processing XMP data: ${JSON.stringify(error)}`);
      directory.addError("Error processing XMP data: " + error);
    }
    if (!directory.isEmpty()) {
      metadata.addDirectory(directory);
    }
    LogUtil.debug(TAG, `extractString end`);
  }

  /**
   * Determine if there is an extended XMP section based on the standard XMP part.
   * The xmpNote:HasExtendedXMP attribute contains the GUID of the Extended XMP chunks.
   */
  private static getExtendedXMPGUID(metadata: Metadata): string | null {
    let directories = metadata.getDirectories();

    for (let directory of directories) {
      if (!(directory instanceof XmpDirectory)) {
        continue;
      }

      let xmpMeta: XMPMeta = directory.getXMPMeta();

      try {
        let itr: XMPIterator = xmpMeta.iterator(XmpReader.SCHEMA_XMP_NOTES, '', new IteratorOptions());
        if (itr == null) {
          continue;
        }

        while (itr.hasNext()) {
          let pi: XMPPropertyInfo = itr.next();
          if (XmpReader.ATTRIBUTE_EXTENDED_XMP === pi.getPath()) {
            return pi.getValue();
          }
        }
      } catch (error) {
        // Fail silently here: we had a reading issue, not a decoding issue.
        LogUtil.debug(TAG, `getExtendedXMPGUID error: ${JSON.stringify(error)}`);
      }
    }

    return null;
  }

  /**
   * Process an Extended XMP chunk. It will read the bytes from segmentBytes and validates that the GUID the requested one.
   * It will progressively fill the buffer with each chunk.
   * The format is specified in this document:
   * http://www.adobe.com/content/dam/Adobe/en/devnet/xmp/pdfs/XMPSpecificationPart3.pdf
   * at page 19
   */
  private static processExtendedXMPChunk(metadata: Metadata, segmentBytes: Int8Array,
                                         extendedXMPGUID: string, extendedXMPBuffer: Int8Array | null): Int8Array | null {
    LogUtil.debug(TAG, `processExtendedXMPChunk start`);
    let extensionPreambleLength: number = XmpReader.XMP_EXTENSION_JPEG_PREAMBLE.length;
    let segmentLength: number = segmentBytes.length;
    let totalOffset: number = extensionPreambleLength + XmpReader.EXTENDED_XMP_GUID_LENGTH
      + XmpReader.EXTENDED_XMP_INT_LENGTH + XmpReader.EXTENDED_XMP_INT_LENGTH;

    if (segmentLength >= totalOffset) {
      try {
        /*
         * The chunk contains:
         * - A null-terminated signature string of "http://ns.adobe.com/xmp/extension/".
         * - A 128-bit GUID stored as a 32-byte ASCII hex string, capital A-F, no null termination.
         *   The GUID is a 128-bit MD5 digest of the full ExtendedXMP serialization.
         * - The full length of the ExtendedXMP serialization as a 32-bit unsigned integer
         * - The offset of this portion as a 32-bit unsigned integer
         * - The portion of the ExtendedXMP
         */
        let reader: SequentialReader = new SequentialByteArrayReader(segmentBytes);
        reader.skip(extensionPreambleLength);
        let segmentGUID: string = reader.getString(XmpReader.EXTENDED_XMP_GUID_LENGTH);

        if (extendedXMPGUID === segmentGUID) {
          let fullLength: number = Number(reader.getUInt32());
          let chunkOffset: number = Number(reader.getUInt32());

          if (extendedXMPBuffer == null) {
            LogUtil.debug(TAG, `Creating new buffer of length ${fullLength}`);
            extendedXMPBuffer = new Int8Array(fullLength);
          }

          if (extendedXMPBuffer.length === fullLength) {
            // Copy segment data to the buffer at the correct offset
            let dataLength: number = segmentLength - totalOffset;
            for (let i = 0; i < dataLength; i++) {
              extendedXMPBuffer[chunkOffset + i] = segmentBytes[totalOffset + i];
            }
          } else {
            let directory: XmpDirectory = new XmpDirectory();
            LogUtil.error(TAG, `Inconsistent length for the Extended XMP buffer: ${fullLength} instead of ${extendedXMPBuffer.length}`);
            directory.addError("Inconsistent length for the Extended XMP buffer: " + fullLength + " instead of " + extendedXMPBuffer.length);
            metadata.addDirectory(directory);
          }
        }
      } catch (error) {
        let directory: XmpDirectory = new XmpDirectory();
        LogUtil.error(TAG, `Error processing Extended XMP chunk: ${JSON.stringify(error)}`);
        directory.addError(String(error));
        metadata.addDirectory(directory);
      }
    }
    LogUtil.debug(TAG, `processExtendedXMPChunk end`);
    return extendedXMPBuffer;
  }
}

export default XmpReader;