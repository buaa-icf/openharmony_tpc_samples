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

import Options from './Options';
import XMPException from '../XMPException';
import XMPError from '../XMPError';

/**
 * 序列化选项类
 */
export default class SerializeOptions extends Options {
  /** Omit the XML packet wrapper. */
  public static readonly OMIT_PACKET_WRAPPER: number = 0x0010;
  /** Mark packet as read-only. Default is a writeable packet. */
  public static readonly READONLY_PACKET: number = 0x0020;
  /**
   * Use a compact form of RDF.
   * The compact form is the default serialization format (this flag is technically ignored).
   * To serialize to the canonical form, set the flag USE_CANONICAL_FORMAT.
   * If both flags &quot;compact&quot; and &quot;canonical&quot; are set, canonical is used.
   */
  public static readonly USE_COMPACT_FORMAT: number = 0x0040;
  /** Use the canonical form of RDF if set. By default the compact form is used */
  public static readonly USE_CANONICAL_FORMAT: number = 0x0080;
  /**
   * Include a padding allowance for a thumbnail image. If no <tt>xmp:Thumbnails</tt> property
   * is present, the typical space for a JPEG thumbnail is used.
   */
  public static readonly INCLUDE_THUMBNAIL_PAD: number = 0x0100;
  /**
   * The padding parameter provides the overall packet length. The actual amount of padding is
   * computed. An exception is thrown if the packet exceeds this length with no padding.
   */
  public static readonly EXACT_PACKET_LENGTH: number = 0x0200;
  /** Omit the &lt;x:xmpmeta&bt;-tag */
  public static readonly OMIT_XMPMETA_ELEMENT: number = 0x1000;
  /** Sort the struct properties and qualifier before serializing */
  public static readonly SORT: number = 0x2000;

  // ---------------------------------------------------------------------------------------------
  // encoding bit constants

  /** Bit indicating little endian encoding, unset is big endian */
  private static readonly LITTLEENDIAN_BIT: number = 0x0001;
  /** Bit indication UTF16 encoding. */
  private static readonly UTF16_BIT: number = 0x0002;
  /** UTF8 encoding; this is the default */
  public static readonly ENCODE_UTF8: number = 0;
  /** UTF16BE encoding */
  public static readonly ENCODE_UTF16BE: number = SerializeOptions.UTF16_BIT;
  /** UTF16LE encoding */
  public static readonly ENCODE_UTF16LE: number = SerializeOptions.UTF16_BIT | SerializeOptions.LITTLEENDIAN_BIT;
  /** */
  private static readonly ENCODING_MASK: number = SerializeOptions.UTF16_BIT | SerializeOptions.LITTLEENDIAN_BIT;

  /**
   * The amount of padding to be added if a writeable XML packet is created. If zero is passed
   * (the default) an appropriate amount of padding is computed.
   */
  private padding: number = 2048;
  /**
   * The string to be used as a line terminator. If empty it defaults to; linefeed, U+000A, the
   * standard XML newline.
   */
  private newline: string = "\n";
  /**
   * The string to be used for each level of indentation in the serialized
   * RDF. If empty it defaults to two ASCII spaces, U+0020.
   */
  private indent: string = "  ";
  /**
   * The number of levels of indentation to be used for the outermost XML element in the
   * serialized RDF. This is convenient when embedding the RDF in other text, defaults to 0.
   */
  private baseIndent: number = 0;
  /** Omits the Toolkit version attribute, not published, only used for Unit tests. */
  private omitVersionAttribute: boolean = false;

  /**
   * Default constructor.
   */
  constructor(options?: number) {
    super(options);
  }

  /**
   * @return Returns the option.
   */
  public getOmitPacketWrapper(): boolean {
    return this.getOption(SerializeOptions.OMIT_PACKET_WRAPPER);
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setOmitPacketWrapper(value: boolean): SerializeOptions {
    this.setOption(SerializeOptions.OMIT_PACKET_WRAPPER, value);
    return this;
  }

  /**
   * @return Returns the option.
   */
  public getOmitXmpMetaElement(): boolean {
    return this.getOption(SerializeOptions.OMIT_XMPMETA_ELEMENT);
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setOmitXmpMetaElement(value: boolean): SerializeOptions {
    this.setOption(SerializeOptions.OMIT_XMPMETA_ELEMENT, value);
    return this;
  }

  /**
   * @return Returns the option.
   */
  public getReadOnlyPacket(): boolean {
    return this.getOption(SerializeOptions.READONLY_PACKET);
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setReadOnlyPacket(value: boolean): SerializeOptions {
    this.setOption(SerializeOptions.READONLY_PACKET, value);
    return this;
  }

  /**
   * @return Returns the option.
   */
  public getUseCompactFormat(): boolean {
    return this.getOption(SerializeOptions.USE_COMPACT_FORMAT);
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setUseCompactFormat(value: boolean): SerializeOptions {
    this.setOption(SerializeOptions.USE_COMPACT_FORMAT, value);
    return this;
  }

  /**
   * @return Returns the option.
   */
  public getUseCanonicalFormat(): boolean {
    return this.getOption(SerializeOptions.USE_CANONICAL_FORMAT);
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setUseCanonicalFormat(value: boolean): SerializeOptions {
    this.setOption(SerializeOptions.USE_CANONICAL_FORMAT, value);
    return this;
  }

  /**
   * @return Returns the option.
   */
  public getIncludeThumbnailPad(): boolean {
    return this.getOption(SerializeOptions.INCLUDE_THUMBNAIL_PAD);
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setIncludeThumbnailPad(value: boolean): SerializeOptions {
    this.setOption(SerializeOptions.INCLUDE_THUMBNAIL_PAD, value);
    return this;
  }

  /**
   * @return Returns the option.
   */
  public getExactPacketLength(): boolean {
    return this.getOption(SerializeOptions.EXACT_PACKET_LENGTH);
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setExactPacketLength(value: boolean): SerializeOptions {
    this.setOption(SerializeOptions.EXACT_PACKET_LENGTH, value);
    return this;
  }

  /**
   * @return Returns the option.
   */
  public getSort(): boolean {
    return this.getOption(SerializeOptions.SORT);
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setSort(value: boolean): SerializeOptions {
    this.setOption(SerializeOptions.SORT, value);
    return this;
  }

  /**
   * @return Returns the option.
   */
  public getEncodeUTF16BE(): boolean {
    return (this.getOptions() & SerializeOptions.ENCODING_MASK) === SerializeOptions.ENCODE_UTF16BE;
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setEncodeUTF16BE(value: boolean): SerializeOptions {
    // clear unicode bits
    this.setOption(SerializeOptions.UTF16_BIT | SerializeOptions.LITTLEENDIAN_BIT, false);
    this.setOption(SerializeOptions.ENCODE_UTF16BE, value);
    return this;
  }

  /**
   * @return Returns the option.
   */
  public getEncodeUTF16LE(): boolean {
    return (this.getOptions() & SerializeOptions.ENCODING_MASK) === SerializeOptions.ENCODE_UTF16LE;
  }

  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setEncodeUTF16LE(value: boolean): SerializeOptions {
    // clear unicode bits
    this.setOption(SerializeOptions.UTF16_BIT | SerializeOptions.LITTLEENDIAN_BIT, false);
    this.setOption(SerializeOptions.ENCODE_UTF16LE, value);
    return this;
  }

  /**
   * @return Returns the baseIndent.
   */
  public getBaseIndent(): number {
    return this.baseIndent;
  }

  /**
   * @param baseIndent
  *            The baseIndent to set.
   * @return Returns the instance to call more set-methods.
   */
  public setBaseIndent(baseIndent: number): SerializeOptions {
    this.baseIndent = baseIndent;
    return this;
  }

  /**
   * @return Returns the indent.
   */
  public getIndent(): string {
    return this.indent;
  }

  /**
   * @param indent
  *            The indent to set.
   * @return Returns the instance to call more set-methods.
   */
  public setIndent(indent: string): SerializeOptions {
    this.indent = indent;
    return this;
  }

  /**
   * @return Returns the newline.
   */
  public getNewline(): string {
    return this.newline;
  }

  /**
   * @param newline
  *            The newline to set.
   * @return Returns the instance to call more set-methods.
   */
  public setNewline(newline: string): SerializeOptions {
    this.newline = newline;
    return this;
  }

  /**
   * @return Returns the padding.
   */
  public getPadding(): number {
    return this.padding;
  }

  /**
   * @param padding
  *            The padding to set.
   * @return Returns the instance to call more set-methods.
   */
  public setPadding(padding: number): SerializeOptions {
    this.padding = padding;
    return this;
  }

  /**
   * @return Returns whether the Toolkit version attribute shall be omitted.
   * <em>Note:</em> This options can only be set by unit tests.
   */
  public getOmitVersionAttribute(): boolean {
    return this.omitVersionAttribute;
  }

  /**
   * @return Returns the encoding as Java encoding String.
   */
  public getEncoding(): string {
    if (this.getEncodeUTF16BE()) {
      return "UTF-16BE";
    } else if (this.getEncodeUTF16LE()) {
      return "UTF-16LE";
    } else {
      return "UTF-8";
    }
  }

  /**
   *
   * @return Returns clone of this SerializeOptions-object with the same options set.
   * @throws CloneNotSupportedException Cannot happen in this place.
   */
  public clone(): SerializeOptions | null {
    let clone: SerializeOptions;
    try {
      clone = new SerializeOptions(this.getOptions());
      clone.setBaseIndent(this.baseIndent);
      clone.setIndent(this.indent);
      clone.setNewline(this.newline);
      clone.setPadding(this.padding);
      return clone;
    } catch (e) {
      // This cannot happen, the options are already checked in "this" object.
      return null;
    }
  }

  /**
   * @see Options#defineOptionName(int)
   */
  protected defineOptionName(option: number): string| null {
    switch (option) {
      case SerializeOptions.OMIT_PACKET_WRAPPER: return "OMIT_PACKET_WRAPPER";
      case SerializeOptions.READONLY_PACKET: return "READONLY_PACKET";
      case SerializeOptions.USE_COMPACT_FORMAT: return "USE_COMPACT_FORMAT";
      // case SerializeOptions.USE_CANONICAL_FORMAT: return "USE_CANONICAL_FORMAT";
      case SerializeOptions.INCLUDE_THUMBNAIL_PAD: return "INCLUDE_THUMBNAIL_PAD";
      case SerializeOptions.EXACT_PACKET_LENGTH: return "EXACT_PACKET_LENGTH";
      case SerializeOptions.OMIT_XMPMETA_ELEMENT: return "OMIT_XMPMETA_ELEMENT";
      case SerializeOptions.SORT: return "NORMALIZED";
      default: return null;
    }
  }

  /**
   * @see Options#getValidOptions()
   */
  protected getValidOptions(): number {
    return SerializeOptions.OMIT_PACKET_WRAPPER |
    SerializeOptions.READONLY_PACKET |
    SerializeOptions.USE_COMPACT_FORMAT |
      // SerializeOptions.USE_CANONICAL_FORMAT |
    SerializeOptions.INCLUDE_THUMBNAIL_PAD |
    SerializeOptions.OMIT_XMPMETA_ELEMENT |
    SerializeOptions.EXACT_PACKET_LENGTH |
    SerializeOptions.SORT;
  }
}