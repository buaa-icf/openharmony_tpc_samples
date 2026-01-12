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

import XMPConst from '../XMPConst';
import XMPError from '../XMPError';
import XMPException from '../XMPException';
import XMPMeta from '../XMPMeta';
import XMPMetaImpl from './XMPMetaImpl';

/**
 * 参数验证工具类
 * @since 11.08.2006
 */
export default class ParameterAsserts extends XMPConst {
  /**
   * 私有构造函数
   */
  private constructor() {
    super();
  }

  /**
   * 验证数组名称是否已设置
   * @param arrayName 数组名称
   * @throws XMPException 数组名称为null或空
   */
  public static assertArrayName(arrayName: string): void {
    if (arrayName == null || arrayName.length === 0) {
      throw new XMPException('Empty array name', XMPError.BADPARAM);
    }
  }

  /**
   * 验证属性名称是否已设置
   * @param propName 属性名称或路径
   * @throws XMPException 属性名称为null或空
   */
  public static assertPropName(propName: string): void {
    if (propName == null || propName.length === 0) {
      throw new XMPException('Empty property name', XMPError.BADPARAM);
    }
  }

  /**
   * 验证架构命名空间是否已设置
   * @param schemaNS 架构命名空间
   * @throws XMPException 架构为null或空
   */
  public static assertSchemaNS(schemaNS: string): void {
    if (schemaNS == null || schemaNS.length === 0) {
      throw new XMPException('Empty schema namespace URI', XMPError.BADPARAM);
    }
  }

  /**
   * 验证前缀是否已设置
   * @param prefix 前缀
   * @throws XMPException 前缀为null或空
   */
  public static assertPrefix(prefix: string): void {
    if (prefix == null || prefix.length === 0) {
      throw new XMPException('Empty prefix', XMPError.BADPARAM);
    }
  }

  /**
   * 验证特定语言是否已设置
   * @param specificLang 特定语言
   * @throws XMPException 特定语言为null或空
   */
  public static assertSpecificLang(specificLang: string): void {
    if (specificLang == null || specificLang.length === 0) {
      throw new XMPException('Empty specific language', XMPError.BADPARAM);
    }
  }

  /**
   * 验证结构体名称是否已设置
   * @param structName 结构体名称
   * @throws XMPException 结构体名称为null或空
   */
  public static assertStructName(structName: string): void {
    if (structName == null || structName.length === 0) {
      throw new XMPException('Empty struct name', XMPError.BADPARAM);
    }
  }

  /**
   * 验证限定符名称是否已设置
   * @param qualName 限定符名称
   * @throws XMPException 限定符名称为null或空
   */
  public static assertQualName(qualName: string): void {
    if (qualName == null || qualName.length === 0) {
      throw new XMPException('Empty qualifier name', XMPError.BADPARAM);
    }
  }

  /**
   * 验证限定符命名空间是否已设置
   * @param qualNS 限定符命名空间
   * @throws XMPException 限定符命名空间为null或空
   */
  public static assertQualNS(qualNS: string): void {
    if (qualNS == null || qualNS.length === 0) {
      throw new XMPException('Empty qualifier namespace', XMPError.BADPARAM);
    }
  }

  /**
   * 验证字段名称是否已设置
   * @param fieldName 字段名称
   * @throws XMPException 字段名称为null或空
   */
  public static assertFieldName(fieldName: string): void {
    if (fieldName == null || fieldName.length === 0) {
      throw new XMPException('Empty field name', XMPError.BADPARAM);
    }
  }

  /**
   * 验证字段命名空间是否已设置
   * @param fieldNS 字段命名空间
   * @throws XMPException 字段命名空间为null或空
   */
  public static assertFieldNS(fieldNS: string): void {
    if (fieldNS == null || fieldNS.length === 0) {
      throw new XMPException('Empty field namespace', XMPError.BADPARAM);
    }
  }

  /**
   * Asserts that the xmp object is of this implemention
   * ({@link XMPMetaImpl}).
   * @param xmp the XMP object
   * @throws XMPException A wrong implentaion is used.
   */
  public static assertImplementation(xmp: XMPMeta): void {
    if (xmp == null) {
      throw new XMPException("Parameter must not be null",
        XMPError.BADPARAM);
    } else if (!(xmp instanceof XMPMetaImpl)) {
      throw new XMPException("The XMPMeta-object is not compatible with this implementation",
        XMPError.BADPARAM);
    }
  }
}