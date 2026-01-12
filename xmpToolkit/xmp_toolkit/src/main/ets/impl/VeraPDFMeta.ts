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
import XMPNode from './XMPNode';
import VeraPDFXMPNode from './VeraPDFXMPNode';
import XMPException from '../XMPException';
import XMPError from '../XMPError';
import XMPDateTime from '../XMPDateTime';
import XMPDateTimeFactory from '../XMPDateTimeFactory';
import PropertyOptions from '../options/PropertyOptions';
import ParseOptions from '../options/ParseOptions';
import SerializeOptions from '../options/SerializeOptions';
import XMPSchemaRegistry from '../XMPSchemaRegistry';
import XMPMetaFactory from '../XMPMetaFactory';
import XMPConst from '../XMPConst';
import XMPProperty from '../properties/XMPProperty';
import { XMPSchemaRegistryImpl } from './XMPSchemaRegistryImpl';

/**
 * VeraPDF元数据类的实现
 */
export default class VeraPDFMeta {
  // 实例变量
  private meta: XMPMetaImpl | null = null;
  private extensionSchemasNode: VeraPDFXMPNode | null = null;
  private properties: VeraPDFXMPNode[] = [];
  private packetHeader: string | null = null;

  /**
   * 私有构造函数
   * @param meta XMPMetaImpl实例
   */
  private constructor(meta: XMPMetaImpl | null = null) {
    this.meta = meta;
  }

  /**
   * 更新内部状态
   */
  private update(): void {
    if (!this.meta) {
      return;
    }
    this.packetHeader = this.meta.getPacketHeader();
    this.extensionSchemasNode = null;
    this.properties = [];
    const root: XMPNode | null = this.meta.getRoot();
    if (root !== null) {
      const rootChildren: XMPNode[] = root.getUnmodifiableChildren();
      if (rootChildren !== null) {
        for (let i: number = 0; i < rootChildren.length; i++) {
          const xmpSchema: XMPNode = rootChildren[i];
          this.addSchema(xmpSchema);
        }
      }
    }
  }

  /**
   * 添加schema节点
   * @param xmpSchema XMPNode schema节点
   */
  private addSchema(xmpSchema: XMPNode): void {
    const children: XMPNode[] = xmpSchema.getUnmodifiableChildren();
    if (children !== null) {
      const registry: XMPSchemaRegistry = XMPMetaFactory.getSchemaRegistry();
      for (let i: number = 0; i < children.length; i++) {
        const xmpChild: XMPNode = children[i];
        const originalName: string | null = xmpChild.getName();
        if (originalName === null) {
          continue;
        }
        const prefixEndIndex: number = originalName.indexOf(":");
        const name: string = originalName.substring(prefixEndIndex + 1, originalName.length);
        const prefix: string = originalName.substring(0, Math.max(prefixEndIndex, 0));
        const namespaceURI: string | null = registry.getNamespaceURI(prefix);
        const veraNode: VeraPDFXMPNode | null = VeraPDFXMPNode.fromXMPNode(xmpChild);
        if (veraNode !== null) {
          if (XMPConst.NS_PDFA_EXTENSION === namespaceURI && "schemas" === name) {
            this.extensionSchemasNode = veraNode;
          } else {
            this.properties.push(veraNode);
          }
        }
      }
    }
  }

  /**
   * 创建新的VeraPDF元数据对象
   * @return 新的VeraPDF元数据实例
   */
  public static create(): VeraPDFMeta {
    const xmpMeta: XMPMetaImpl = XMPMetaFactory.create() as ESObject as XMPMetaImpl;
    const node: VeraPDFMeta = new VeraPDFMeta(xmpMeta);
    node.update();
    return node;
  }

  /**
   * 从输入流解析VeraPDF元数据
   * @param input 输入流（在ArkTS中可以是ArrayBuffer或string）
   * @return 解析后的VeraPDF元数据实例
   * @throws XMPException 如果解析失败
   */
  public static parse(input: ArrayBuffer | string): VeraPDFMeta {
    if (input === null || input === undefined) {
      throw new Error("Metadata InputStream can not be null");
    }
    const parseOptions: ParseOptions = new ParseOptions();
    // 注意：ArkTS版本的ParseOptions可能没有setOmitNormalization方法
    // 如果不存在，可以忽略此设置或使用其他选项
    let xmpMeta: XMPMetaImpl;
    if (typeof input === 'string') {
      xmpMeta = XMPMetaFactory.parseFromString(input, parseOptions) as ESObject as XMPMetaImpl;
    } else {
      xmpMeta = XMPMetaFactory.parse(input, parseOptions) as ESObject as XMPMetaImpl;
    }
    const node: VeraPDFMeta = new VeraPDFMeta(xmpMeta);
    node.update();
    return node;
  }

  /**
   * 序列化VeraPDF元数据
   * @param veraPDFMeta VeraPDF元数据实例
   * @param out 输出流（在ArkTS中可以是ArrayBuffer）
   * @throws XMPException 如果序列化失败
   */
  public static serialize(veraPDFMeta: VeraPDFMeta, out: ArrayBuffer): void {
    if (!veraPDFMeta.meta) {
      throw new XMPException('Meta is null', XMPError.INTERNALFAILURE);
    }
    const serializeOptions: SerializeOptions = new SerializeOptions();
    serializeOptions.setUseCanonicalFormat(true);
    XMPMetaFactory.serialize(veraPDFMeta.meta as ESObject as XMPMeta, out, serializeOptions);
  }

  /**
   * 获取所有属性
   * @return 属性列表（不可修改）
   */
  public getProperties(): VeraPDFXMPNode[] {
    return [...this.properties]; // 返回副本以模拟不可修改列表
  }

  /**
   * 获取包头部
   * @return 包头部字符串
   */
  public getPacketHeader(): string | null {
    return this.packetHeader;
  }

  /**
   * 获取扩展架构节点
   * @return 扩展架构节点
   */
  public getExtensionSchemasNode(): VeraPDFXMPNode | null {
    return this.extensionSchemasNode;
  }

  /**
   * 根据命名空间URI和名称获取属性
   * @param namespaceURI 命名空间URI
   * @param name 属性名称
   * @return 属性节点，如果不存在则返回null
   */
  public getProperty(namespaceURI: string | null, name: string | null): VeraPDFXMPNode | null {
    for (let i: number = 0; i < this.properties.length; i++) {
      const node: VeraPDFXMPNode = this.properties[i];
      const nodeNamespaceURI: string | null = node.getNamespaceURI();
      const isNamespaceURIEquals: boolean = namespaceURI === null ? nodeNamespaceURI ===
                                null : namespaceURI === nodeNamespaceURI;
      const nodeName: string | null = node.getName();
      const isNameEquals: boolean = name === null ? nodeName === null : name === nodeName;
      if (isNamespaceURIEquals && isNameEquals) {
        return node;
      }
    }
    return null;
  }

  /**
   * 删除标识架构
   * @return 如果删除了标识架构则返回true
   */
  public deleteIdentificationSchema(): boolean {
    if (!this.meta) {
      return false;
    }
    let isDeleted: boolean = false;
    let identificationRoot: XMPNode | null = null;
    const root: XMPNode | null = this.meta.getRoot();
    if (!root) {
      return false;
    }
    const rootChildren: XMPNode[] = root.getUnmodifiableChildren();
    for (let i: number = 0; i < rootChildren.length; i++) {
      const xmpNode: XMPNode = rootChildren[i];
      if (XMPConst.NS_PDFA_ID === xmpNode.getName()) {
        identificationRoot = xmpNode;
        break;
      }
    }
    if (identificationRoot !== null) {
      const children: XMPNode[] = identificationRoot.getUnmodifiableChildren();
      for (let i: number = 0; i < children.length; i++) {
        const xmpNode: XMPNode = children[i];
        const nodeName: string | null = xmpNode.getName();
        if (nodeName !== null) {
          this.meta.deleteProperty(XMPConst.NS_PDFA_ID, nodeName);
          isDeleted = true;
        }
      }
      this.update();
    }
    return isDeleted;
  }

  /**
   * 设置简单文本属性
   * @param namespaceURI 命名空间URI
   * @param propertyName 属性名称
   * @param value 属性值
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  private setSimpleTextProperty(namespaceURI: string, propertyName: string, value: string): VeraPDFMeta {
    if (value === null || value === undefined) {
      throw new Error("Argument value can not be null");
    }
    if (!this.meta) {
      throw new XMPException('Meta is null', XMPError.INTERNALFAILURE);
    }
    const property: XMPProperty | null = this.meta.getProperty(namespaceURI, propertyName);
    if (property !== null && !property.getOptions().isSimple()) {
      throw new XMPException("Can not set text value to not simple property", XMPError.BADVALUE);
    }
    this.meta.setProperty(namespaceURI, propertyName, value, null);
    this.update();
    return this;
  }

  /**
   * 获取简单文本属性
   * @param namespaceURI 命名空间URI
   * @param propertyName 属性名称
   * @return 属性值，如果不存在则返回null
   * @throws XMPException 如果获取失败
   */
  private getSimpleTextProperty(namespaceURI: string, propertyName: string): string | null {
    if (!this.meta) {
      throw new XMPException('Meta is null', XMPError.INTERNALFAILURE);
    }
    const property: XMPProperty | null = this.meta.getProperty(namespaceURI, propertyName);
    if (property !== null && !property.getOptions().isSimple()) {
      throw new XMPException("Requared property is not simple", XMPError.BADVALUE);
    }
    return property === null ? null : property.getValue();
  }

  /**
   * 为DC schema设置默认Alt文本属性
   * @param propertyName 属性名称
   * @param defaultValue 默认值
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  private setDefaultAltTextPropertyForDCSchema(propertyName: string, defaultValue: string): VeraPDFMeta {
    if (defaultValue === null || defaultValue === undefined) {
      throw new Error("Argument defaultValue can not be null");
    }
    if (!this.meta) {
      throw new XMPException('Meta is null', XMPError.INTERNALFAILURE);
    }
    this.meta.setLocalizedText(XMPConst.NS_DC, propertyName, "x", XMPConst.X_DEFAULT, defaultValue, null);
    this.update();
    return this;
  }

  /**
   * 获取DC schema的默认Alt文本属性
   * @param propertyName 属性名称
   * @return 属性值，如果不存在则返回null
   * @throws XMPException 如果获取失败
   */
  private getDefaultAltTextPropertyForDCSchema(propertyName: string): string | null {
    if (!this.meta) {
      throw new XMPException('Meta is null', XMPError.INTERNALFAILURE);
    }
    const title: XMPProperty | null = this.meta.getLocalizedText(XMPConst.NS_DC, propertyName, "x", XMPConst.X_DEFAULT);
    return title === null ? null : title.getValue();
  }

  /**
   * 获取标题
   * @return 标题字符串
   * @throws XMPException 如果获取失败
   */
  public getTitle(): string | null {
    return this.getDefaultAltTextPropertyForDCSchema("title");
  }

  /**
   * 设置标题
   * @param title 标题字符串
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setTitle(title: string): VeraPDFMeta {
    return this.setDefaultAltTextPropertyForDCSchema("title", title);
  }

  /**
   * 获取创建者列表
   * @return 创建者列表，如果不存在则返回null
   * @throws XMPException 如果获取失败
   */
  public getCreator(): string[] | null {
    if (!this.meta) {
      throw new XMPException('Meta is null', XMPError.INTERNALFAILURE);
    }
    const creator: XMPProperty | null = this.meta.getProperty(XMPConst.NS_DC, "creator");
    if (creator === null) {
      return null;
    }
    if (!creator.getOptions().isArrayOrdered()) {
      throw new XMPException("Creator property of dublin core schema is not an ordered array", XMPError.BADVALUE);
    }

    const size: number = this.meta.countArrayItems(XMPConst.NS_DC, "creator");
    const res: string[] = [];
    for (let i: number = 1; i <= size; i++) {
      const item: XMPProperty | null = this.meta.getArrayItem(XMPConst.NS_DC, "creator", i);
      if (item === null) {
        continue;
      }
      if (item.getOptions().isSimple()) {
        const value: string | null = item.getValue();
        if (value !== null) {
          res.push(value);
        }
      } else {
        throw new XMPException("Some entry in creator property of dublin core schema is not simple text",
                                XMPError.BADVALUE);
      }
    }
    return res;
  }

  /**
   * 设置创建者列表
   * @param creator 创建者列表
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setCreator(creator: string[]): VeraPDFMeta {
    if (creator === null || creator === undefined) {
      throw new Error("Argument creator can not be null");
    }
    if (!this.meta) {
      throw new XMPException('Meta is null', XMPError.INTERNALFAILURE);
    }
    this.meta.deleteProperty(XMPConst.NS_DC, "creator");
    for (let i: number = 0; i < creator.length; i++) {
      const entry: string = creator[i];
      const arrayOptions: PropertyOptions = new PropertyOptions();
      arrayOptions.setArrayOrdered(true);
      this.meta.appendArrayItem(XMPConst.NS_DC, "creator", arrayOptions, entry, new PropertyOptions());
    }
    this.update();
    return this;
  }

  /**
   * 获取描述
   * @return 描述字符串
   * @throws XMPException 如果获取失败
   */
  public getDescription(): string | null {
    return this.getDefaultAltTextPropertyForDCSchema("description");
  }

  /**
   * 设置描述
   * @param description 描述字符串
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setDescription(description: string): VeraPDFMeta {
    return this.setDefaultAltTextPropertyForDCSchema("description", description);
  }

  /**
   * 获取关键词
   * @return 关键词字符串
   * @throws XMPException 如果获取失败
   */
  public getKeywords(): string | null {
    return this.getSimpleTextProperty(XMPConst.NS_PDF, "Keywords");
  }

  /**
   * 设置关键词
   * @param keywords 关键词字符串
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setKeywords(keywords: string): VeraPDFMeta {
    return this.setSimpleTextProperty(XMPConst.NS_PDF, "Keywords", keywords);
  }

  /**
   * 获取创建工具
   * @return 创建工具字符串
   * @throws XMPException 如果获取失败
   */
  public getCreatorTool(): string | null {
    return this.getSimpleTextProperty(XMPConst.NS_XMP, "CreatorTool");
  }

  /**
   * 设置创建工具
   * @param creatorTool 创建工具字符串
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setCreatorTool(creatorTool: string): VeraPDFMeta {
    return this.setSimpleTextProperty(XMPConst.NS_XMP, "CreatorTool", creatorTool);
  }

  /**
   * 获取生产者
   * @return 生产者字符串
   * @throws XMPException 如果获取失败
   */
  public getProducer(): string | null {
    return this.getSimpleTextProperty(XMPConst.NS_PDF, "Producer");
  }

  /**
   * 设置生产者
   * @param producer 生产者字符串
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setProducer(producer: string): VeraPDFMeta {
    return this.setSimpleTextProperty(XMPConst.NS_PDF, "Producer", producer);
  }

  /**
   * 获取创建日期
   * @return 创建日期（Date对象），如果不存在则返回null
   * @throws XMPException 如果获取失败
   */
  public getCreateDate(): Date | null {
    const value: string | null = this.getSimpleTextProperty(XMPConst.NS_XMP, "CreateDate");
    if (value === null) {
      return null;
    }
    const dateTime: XMPDateTime = XMPDateTimeFactory.createFromISO8601(value);
    return dateTime.getCalendar() as Date;
  }

  /**
   * 设置创建日期
   * @param createDate 创建日期（Date对象）
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setCreateDate(createDate: Date): VeraPDFMeta {
    if (createDate === null || createDate === undefined) {
      throw new Error("Argument createDate can not be null");
    }
    const date: XMPDateTime = XMPDateTimeFactory.createFromCalendar(createDate as ESObject);
    return this.setSimpleTextProperty(XMPConst.NS_XMP, "CreateDate", date.getISO8601String());
  }

  /**
   * 获取修改日期
   * @return 修改日期（Date对象），如果不存在则返回null
   * @throws XMPException 如果获取失败
   */
  public getModifyDate(): Date | null {
    const value: string | null = this.getSimpleTextProperty(XMPConst.NS_XMP, "ModifyDate");
    if (value === null) {
      return null;
    }
    const dateTime: XMPDateTime = XMPDateTimeFactory.createFromISO8601(value);
    return dateTime.getCalendar() as Date;
  }

  /**
   * 设置修改日期
   * @param modifyDate 修改日期（Date对象）
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setModifyDate(modifyDate: Date): VeraPDFMeta {
    if (modifyDate === null || modifyDate === undefined) {
      throw new Error("Argument modifyDate can not be null");
    }
    const date: XMPDateTime = XMPDateTimeFactory.createFromCalendar(modifyDate as ESObject);
    return this.setSimpleTextProperty(XMPConst.NS_XMP, "ModifyDate", date.getISO8601String());
  }

  /**
   * 获取标识部分
   * @return 标识部分（整数），如果不存在则返回null
   * @throws XMPException 如果获取失败
   */
  public getIdentificationPart(): number | null {
    const stringValue: string | null = this.getSimpleTextProperty(XMPConst.NS_PDFA_ID, "part");
    if (stringValue === null) {
      return null;
    }
    try {
      return parseInt(stringValue, 10);
    } catch (e) {
      throw new XMPException("Property part of PDFA Identification schema contains not integer value", XMPError.BADVALUE);
    }
  }

  /**
   * 设置标识部分
   * @param identificationPart 标识部分（整数）
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setIdentificationPart(identificationPart: number | null): VeraPDFMeta {
    const value: string | null = identificationPart === null ? null : identificationPart.toString();
    // 注意：Java版本中，如果value为null，setSimpleTextProperty会抛出异常
    // 为了匹配Java行为，这里也抛出异常
    if (value === null) {
      throw new Error("Argument value can not be null");
    }
    return this.setSimpleTextProperty(XMPConst.NS_PDFA_ID, "part", value);
  }

  /**
   * 获取标识一致性
   * @return 标识一致性字符串
   * @throws XMPException 如果获取失败
   */
  public getIdentificationConformance(): string | null {
    return this.getSimpleTextProperty(XMPConst.NS_PDFA_ID, "conformance");
  }

  /**
   * 设置标识一致性
   * @param identificationConformance 标识一致性字符串
   * @return 自身实例（链式调用）
   * @throws XMPException 如果设置失败
   */
  public setIdentificationConformance(identificationConformance: string): VeraPDFMeta {
    return this.setSimpleTextProperty(XMPConst.NS_PDFA_ID, "conformance", identificationConformance);
  }

  /**
   * 获取初始元数据的克隆
   * @return 初始元数据的克隆（XMPMeta接口）
   */
  public async getCloneOfInitialMeta(): Promise<XMPMeta>  {
    if (!this.meta) {
      throw new XMPException('Meta is null', XMPError.INTERNALFAILURE);
    }
    // 在ArkTS中，通过序列化和反序列化来实现克隆
    const serialized: string = await XMPMetaFactory.serializeToString(this.meta as ESObject as XMPMeta);
    return XMPMetaFactory.parseFromString(serialized) as ESObject as XMPMeta;
  }
}
