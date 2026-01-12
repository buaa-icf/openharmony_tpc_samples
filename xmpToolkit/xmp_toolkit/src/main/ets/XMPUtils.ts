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

// eslint-disable-next-line @typescript-eslint/consistent-type-imports
import XMPMeta from './XMPMeta';
import XMPException from './XMPException';
import XMPError from './XMPError';
import XMPDateTime from './XMPDateTime';
import XMPConst from './XMPConst';
import { util } from '@kit.ArkTS';
import { XMPUtilsImpl } from './impl/XMPUtilsImpl';
import ISO8601Converter from './impl/ISO8601Converter';
import PropertyOptions from './options/PropertyOptions';
import Utils from './impl/Utils';

/**
 * XMP工具类，提供各种XMP处理相关的静态方法
 */
export default class XMPUtils {
  /** Private constructor */
  private constructor() {
    // EMPTY
  }


  /**
   * Create a single edit string from an array of strings.
   *
   * @param xmp
  *            The XMP object containing the array to be catenated.
   * @param schemaNS
  *            The schema namespace URI for the array. Must not be null or
   *            the empty string.
   * @param arrayName
  *            The name of the array. May be a general path expression, must
   *            not be null or the empty string. Each item in the array must
   *            be a simple string value.
   * @param separator
  *            The string to be used to separate the items in the catenated
   *            string. Defaults to &quot;; &quot;, ASCII semicolon and space
   *            (U+003B, U+0020).
   * @param quotes
  *            The characters to be used as quotes around array items that
   *            contain a separator. Defaults to &apos;&quot;&apos;
   * @param allowCommas
  *            Option flag to control the catenation.
   * @return Returns the string containing the catenated array items.
   * @throws XMPException Forwards the Exceptions from the metadata processing
   */
  public static catenateArrayItems(xmp: XMPMeta, schemaNS: string, arrayName: string,
    separator: string, quotes: string, allowCommas: boolean): string {
    return XMPUtilsImpl
      .catenateArrayItems(xmp, schemaNS, arrayName, separator, quotes, allowCommas);
  }

  /**
   * Separate a single edit string into an array of strings.
   *
   * @param xmp
  *            The XMP object containing the array to be updated.
   * @param schemaNS
  *            The schema namespace URI for the array. Must not be null or
   *            the empty string.
   * @param arrayName
  *            The name of the array. May be a general path expression, must
   *            not be null or the empty string. Each item in the array must
   *            be a simple string value.
   * @param catedStr
  *            The string to be separated into the array items.
   * @param arrayOptions Option flags to control the separation.
   * @param preserveCommas Flag if commas shall be preserved
   * @throws XMPException Forwards the Exceptions from the metadata processing
   */
  public static separateArrayItems(
    xmp: XMPMeta,
    schemaNS: string,
    arrayName: string,
    catedStr: string,
    arrayOptions: PropertyOptions,
    preserveCommas: boolean
  ): void {
    XMPUtilsImpl.separateArrayItems(xmp, schemaNS, arrayName, catedStr, arrayOptions, preserveCommas);
  }

  /**
   * Remove multiple properties from an XMP object.
   *
   * RemoveProperties was created to support the File Info dialog's Delete
   * button, and has been been generalized somewhat from those specific needs.
   * It operates in one of three main modes depending on the schemaNS and
   * propName parameters:
   *
   * <ul>
   * <li> Non-empty <code>schemaNS</code> and <code>propName</code> - The named property is
   * removed if it is an external property, or if the
   * flag <code>doAllProperties</code> option is true. It does not matter whether the
   * named property is an actual property or an alias.
   *
   * <li> Non-empty <code>schemaNS</code> and empty <code>propName</code> - The all external
   * properties in the named schema are removed. Internal properties are also
   * removed if the flag <code>doAllProperties</code> option is set. In addition,
   * aliases from the named schema will be removed if the flag <code>includeAliases</code>
   * option is set.
   *
   * <li> Empty <code>schemaNS</code> and empty <code>propName</code> - All external properties in
   * all schema are removed. Internal properties are also removed if the
   * flag <code>doAllProperties</code> option is passed. Aliases are implicitly handled
   * because the associated actuals are internal if the alias is.
   * </ul>
   *
   * It is an error to pass an empty <code>schemaNS</code> and non-empty <code>propName</code>.
   *
   * @param xmp
  *            The XMP object containing the properties to be removed.
   *
   * @param schemaNS
  *            Optional schema namespace URI for the properties to be
   *            removed.
   *
   * @param propName
  *            Optional path expression for the property to be removed.
   *
   * @param doAllProperties Option flag to control the deletion: do internal properties in
   *          addition to external properties.
   *
   * @param includeAliases Option flag to control the deletion:
   * 			Include aliases in the "named schema" case above.
   * 			<em>Note:</em> Currently not supported.
   * @throws XMPException Forwards the Exceptions from the metadata processing
   */
  public static removeProperties(
    source: XMPMeta,
    schemaNS: string,
    propName: string,
    doAllProperties: boolean,
    includeAliases: boolean
  ): void {
    XMPUtilsImpl.removeProperties(source, schemaNS, propName, doAllProperties, includeAliases);
  }

  /**
   * 将源XMP对象的属性追加到目标XMP对象（不包含 deleteEmptyValues 参数的重载版本）
   * @param source 源XMP对象
   * @param dest 目标XMP对象
   * @param doAllProperties 是否处理所有属性
   * @param replaceOldValues 是否替换旧值
   * @throws XMPException 处理过程中的异常
   */
  public static appendProperties(
    source: XMPMeta,
    dest: XMPMeta,
    doAllProperties: boolean,
    replaceOldValues: boolean
  ): void;
  /**
   * 将源XMP对象的属性追加到目标XMP对象
   * @param source 源XMP对象
   * @param dest 目标XMP对象
   * @param doAllProperties 是否处理所有属性
   * @param replaceOldValues 是否替换旧值
   * @param deleteEmptyValues 源属性为空时是否删除目标值
   * @throws XMPException 处理过程中的异常
   */
  public static appendProperties(
    source: XMPMeta,
    dest: XMPMeta,
    doAllProperties: boolean,
    replaceOldValues: boolean,
    deleteEmptyValues: boolean
  ): void;
  public static appendProperties(
    source: XMPMeta,
    dest: XMPMeta,
    doAllProperties: boolean,
    replaceOldValues: boolean,
    deleteEmptyValues?: boolean
  ): void {
    const deleteEmpty: boolean = deleteEmptyValues !== undefined ? deleteEmptyValues : false;
    XMPUtilsImpl.appendProperties(source, dest, doAllProperties, replaceOldValues, deleteEmpty);
  }

  /**
   * 将字符串转换为布尔值
   * @param value 字符串值
   * @returns 转换后的布尔值
   * @throws XMPException 空字符串异常
   */
  public static convertToBoolean(value: string | null): boolean {
    if (value == null || value.length === 0) {
      throw new XMPException('Empty convert-string', XMPError.BADVALUE);
    }
    value = value.toLowerCase();
    
    try {
      // 尝试作为整数解析
      const intValue = parseInt(value, 10);
      if (!isNaN(intValue)) {
        return intValue !== 0;
      }
    } catch (e) {
      console.error('Convert to boolean error', e);
    }
    
    return (
      value === 'true' ||
      value === 't' ||
      value === 'on' ||
      value === 'yes'
    );
  }

  /**
   * 将布尔值转换为字符串
   * @param value 布尔值
   * @returns 字符串表示
   */
  public static convertFromBoolean(value: boolean): string {
    return value ? XMPConst.TRUESTR : XMPConst.FALSESTR;
  }

  /**
   * 将字符串转换为整数
   * @param rawValue 字符串值
   * @returns 转换后的整数
   * @throws XMPException 空字符串或转换失败
   */
  public static convertToInteger(rawValue: string | null): number {
    try {
      if (rawValue === null || rawValue.length === 0) {
        throw new XMPException('Empty convert-string', XMPError.BADVALUE);
      }

      let result: number;
      if (rawValue.startsWith('0x')) {
        result = parseInt(rawValue.substring(2), 16);
      } else {
        result = parseInt(rawValue, 10);
      }

      if (Number.isNaN(result)) {
        throw new XMPException('The input string is invalid', XMPError.BADVALUE);
      }

      return result;
    } catch (e) {
      throw new XMPException('Invalid integer string', XMPError.BADVALUE);
    }
  }

  /**
   * 将整数转换为字符串
   * @param value 整数值
   * @returns 字符串表示
   */
  public static convertFromInteger(value: number): string {
    return value.toString();
  }

  /**
   * 将字符串转换为长整数
   * @param rawValue 字符串值
   * @returns 转换后的长整数
   * @throws XMPException 空字符串或转换失败
   */
  public static convertToLong(rawValue: string | null): number {
    try {
      if (rawValue == null || rawValue.length === 0) {
        throw new XMPException('Empty convert-string', XMPError.BADVALUE);
      }
      if (rawValue.startsWith('0x')) {
        return parseInt(rawValue.substring(2), 16);
      } else {
        return parseInt(rawValue, 10);
      }
    } catch (e) {
      throw new XMPException('Invalid long string', XMPError.BADVALUE);
    }
  }

  /**
   * 将长整数转换为字符串
   * @param value 长整数值
   * @returns 字符串表示
   */
  public static convertFromLong(value: number): string {
    return value.toString();
  }

  /**
   * 将字符串转换为浮点数
   * @param rawValue 字符串值
   * @returns 转换后的浮点数
   * @throws XMPException 空字符串或转换失败
   */
  public static convertToDouble(rawValue: string | null): number {
    try {
      if (rawValue == null || rawValue.length === 0) {
        throw new XMPException('Empty convert-string', XMPError.BADVALUE);
      } else {
        return parseFloat(rawValue);
      }
    } catch (e) {
      throw new XMPException('Invalid double string', XMPError.BADVALUE);
    }
  }

  /**
   * 将浮点数转换为字符串
   * @param value 浮点数值
   * @returns 字符串表示
   */
  public static convertFromDouble(value: number): string {
    return value.toString();
  }

  /**
   * 将字符串转换为XMPDateTime
   * @param rawValue 字符串值
   * @returns 转换后的XMPDateTime对象
   * @throws XMPException 空字符串或转换失败
   */
  public static convertToDate(rawValue: string | null): XMPDateTime {
    if (rawValue == null || rawValue.length === 0) {
      throw new XMPException('Empty convert-string', XMPError.BADVALUE);
    } else {
      return ISO8601Converter.parse(rawValue);
    }
  }

  /**
   * 将XMPDateTime转换为字符串
   * @param value XMPDateTime对象
   * @returns 字符串表示
   */
  public static convertFromDate(value: XMPDateTime): string {
    return ISO8601Converter.render(value);
  }

  /**
   * 将字节数组编码为Base64字符串
   * @param buffer 字节数组
   * @returns Base64编码的字符串
   */
  public static encodeBase64(buffer: Uint8Array): string {
    // 空缓冲区返回空字符串
    if (buffer.length === 0) {
      return '';
    }
    let base64 = new util.Base64Helper();
    return base64.encodeToStringSync(buffer);
  }

  /**
   * Decode from Base64 encoded string to raw data.
   *
   * @param base64String
  *            a base64 encoded string
   * @return Returns a byte array containg the decoded string.
   * @throws XMPException Thrown if the given string is not property base64 encoded
   */
  public static decodeBase64(base64String: string | null): Uint8Array {
    // 空字符串或 null 返回空缓冲区
    if (base64String === null || base64String.length === 0) {
      return new Uint8Array(0);
    }
    try {
      let base64 = new util.Base64Helper();
      return base64.decodeSync(base64String);
    } catch (e) {
      throw new XMPException('Invalid base64 string', XMPError.BADVALUE, e);
    }
  }

  /**
   * 规范化xml:lang值，以便比较有效地不区分大小写，如RFC 3066（替代RFC 1766）所要求的。
   * 这是 Utils.normalizeLangValue 的代理方法，以保持与 Java 版本的兼容性。
   * 
   * @param value 原始值
   * @return 返回规范化的值
   */
  public static normalizeLangValue(value: string | null): string | null {
    return Utils.normalizeLangValue(value);
  }

  /**
   * 拆分字段和限定符选择器的名称和值部分。
   * 这是 Utils.splitNameAndValue 的代理方法，以保持与 Java 版本的兼容性。
   * 
   * @param selector 选择器
   * @return 返回一个数组，第一个条目包含名称，第二个包含值
   */
  public static splitNameAndValue(selector: string): string[] {
    return Utils.splitNameAndValue(selector);
  }

  /**
   * 检查属性是否被定义为"内部属性"。
   * 这是 Utils.isInternalProperty 的代理方法，以保持与 Java 版本的兼容性。
   * 
   * @param schema 模式命名空间
   * @param prop XMP属性
   * @return 如果属性被定义为"内部属性"，返回true
   */
  public static isInternalProperty(schema: string, prop: string): boolean {
    return Utils.isInternalProperty(schema, prop);
  }

  /**
   * 检查UUID格式是否符合要求。
   * 这是 Utils.checkUUIDFormat 的代理方法，以保持与 Java 版本的兼容性。
   * 
   * @param uuid 要测试的uuid
   * @return true - 这是一个格式良好的UUID，false - UUID格式不符合预期
   */
  public static checkUUIDFormat(uuid: string): boolean {
    return Utils.checkUUIDFormat(uuid);
  }

  /**
   * 简单检查有效的XML名称。
   * 这是 Utils.isXMLName 的代理方法，以保持与 Java 版本的兼容性。
   * 
   * @param name XML名称
   * @return 如果名称正确，返回true
   */
  public static isXMLName(name: string): boolean {
    return Utils.isXMLName(name);
  }

  /**
   * 检查值是否为合法的"非限定"XML名称。
   * 这是 Utils.isXMLNameNS 的代理方法，以保持与 Java 版本的兼容性。
   * 
   * @param name 要检查的值
   * @return 如果名称是有效的"非限定"XML名称，返回true
   */
  public static isXMLNameNS(name: string): boolean {
    return Utils.isXMLNameNS(name);
  }

  /**
   * 检查字符是否为ASCII控制字符。
   * 这是 Utils.isControlChar 的代理方法，以保持与 Java 版本的兼容性。
   * 
   * @param c 字符
   * @return 如果字符是ASCII控制字符，返回true
   */
  public static isControlChar(c: string): boolean {
    return Utils.isControlChar(c);
  }

  /**
   * 以XML编码序列化节点值。
   * 这是 Utils.escapeXML 的代理方法，以保持与 Java 版本的兼容性。
   * 
   * @param value 字符串
   * @param forAttribute 标志字符串是否为属性值（需要额外转义引号）
   * @param escapeWhitespaces 决定是否转义LF、CR和TAB
   * @return 返回准备好用于XML输出的值
   */
  public static escapeXML(value: string, forAttribute: boolean, escapeWhitespaces: boolean): string {
    return Utils.escapeXML(value, forAttribute, escapeWhitespaces);
  }

  /**
   * 用空格替换ASCII控制字符。
   * 这是 Utils.removeControlChars 的代理方法，以保持与 Java 版本的兼容性。
   * 
   * @param value 节点值
   * @return 返回清理后的值
   */
  public static removeControlChars(value: string): string {
    return Utils.removeControlChars(value);
  }
}

