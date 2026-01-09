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


import AliasOptions from '../options/AliasOptions';
import Util from './Utils';
import XMPUtils from '../XMPUtils';
import XMPDateTimeFactory from '../XMPDateTimeFactory';
import XMPMetaFactory from '../XMPMetaFactory';
import XMPConst from '../XMPConst';
import XMPNode from './XMPNode';
import XMPException from '../XMPException';
import XMPError from '../XMPError';
import PropertyOptions from '../options/PropertyOptions';
import XMPPath from './xpath/XMPPath';
import XMPPathSegment from './xpath/XMPPathSegment';
import Utils from './Utils';
import XMPDateTime from '../XMPDateTime';
import XMPDateTimeImpl from './XMPDateTimeImpl';

/**
 * Utilities for <code>XMPNode</code>.
 */
export default class XMPNodeUtils extends XMPConst {
  // 常量定义
  static readonly CLT_NO_VALUES = 0;
  static readonly CLT_SPECIFIC_MATCH = 1;
  static readonly CLT_SINGLE_GENERIC = 2;
  static readonly CLT_MULTIPLE_GENERIC = 3;
  static readonly CLT_XDEFAULT = 4;
  static readonly CLT_FIRST_ITEM = 5;

  /**
   * 私有构造函数
   */
  private constructor() {
    super();
  }

  /**
   * 查找或创建模式节点
   * @param tree XMP树的根节点
   * @param namespaceURI 命名空间
   * @param createNodes 是否创建节点标志
   * @return 找到的模式节点，如果未找到则返回null
   * @throws XMPException
   */
  static findSchemaNode(tree: XMPNode, namespaceURI: string, createNodes: boolean): XMPNode | null {
    return XMPNodeUtils.findSchemaNodeWithPrefix(tree, namespaceURI, null, createNodes);
  }

  /**
   * 查找或创建模式节点，支持指定前缀
   * @param tree XMP树的根节点
   * @param namespaceURI 命名空间
   * @param suggestedPrefix 建议的前缀
   * @param createNodes 是否创建节点标志
   * @return 找到的模式节点，如果未找到则返回null
   * @throws XMPException
   */
  static findSchemaNodeWithPrefix(tree: XMPNode, namespaceURI: string, suggestedPrefix: string | null,
    createNodes: boolean): XMPNode | null {
    // 确保是根节点
    if (tree.getParent() !== null) {
      throw new XMPException('Not a root node', XMPError.INTERNALFAILURE);
    }

    let schemaNode = tree.findChildByName(namespaceURI);

    if (schemaNode === null && createNodes) {
      schemaNode = new XMPNode(namespaceURI, null,
        new PropertyOptions().setSchemaNode(true), null);
      schemaNode.setImplicit(true);

      // 只允许已注册的模式命名空间
      let prefix = XMPMetaFactory.getSchemaRegistry().getNamespacePrefix(namespaceURI);
      if (prefix === null) {
        if (suggestedPrefix !== null && suggestedPrefix.length !== 0) {
          prefix = XMPMetaFactory.getSchemaRegistry().registerNamespace(namespaceURI, suggestedPrefix);
        } else {
          throw new XMPException('Unregistered schema namespace URI', XMPError.BADSCHEMA);
        }
      }

      schemaNode.setValue(prefix);
      tree.addChild(schemaNode);
    }

    return schemaNode;
  }

  /**
   * 查找或创建子节点
   * @param parent 父节点
   * @param childName 子节点名称
   * @param createNodes 是否创建节点标志
   * @return 找到的子节点，如果未找到则返回null
   * @throws XMPException
   */
  static findChildNode(parent: XMPNode, childName: string, createNodes: boolean): XMPNode | null {
    if (!parent.getOptions().isSchemaNode() && !parent.getOptions().isStruct()) {
      if (!parent.isImplicit()) {
        throw new XMPException('Named children only allowed for schemas and structs', XMPError.BADXPATH);
      } else if (parent.getOptions().isArray()) {
        throw new XMPException('Named children not allowed for arrays', XMPError.BADXPATH);
      } else if (createNodes) {
        parent.getOptions().setStruct(true);
      }
    }

    let childNode = parent.findChildByName(childName);

    if (childNode === null && createNodes) {
      const options = new PropertyOptions();
      const prefix = childName === null ? null : childName.substring(0, Math.max(childName.indexOf(':'), 0));
      childNode = new XMPNode(childName, null, options, prefix);
      childNode.setImplicit(true);
      parent.addChild(childNode);
    }

    return childNode;
  }

  /**
   * 按照扩展路径表达式查找或创建节点
   * @param xmpTree 开始搜索的节点
   * @param xpath 完整的xpath
   * @param createNodes 是否创建节点标志
   * @param leafOptions 创建的叶节点的选项
   * @return 找到或创建的节点，如果未找到则返回null
   * @throws XMPException
   */
  static findNode(xmpTree: XMPNode, xpath: XMPPath, createNodes: boolean,
    leafOptions: PropertyOptions | null): XMPNode | null{
    // 检查xpath是否设置
    if (xpath === null || xpath.size() === 0) {
      throw new XMPException('Empty XMPPath', XMPError.BADXPATH);
    }

    // 隐式创建的子树的根，仅当叶节点是新节点时有效
    let rootImplicitNode: XMPNode | null = null;
    let currNode: XMPNode | null = null;

    // 解析模式步骤
    currNode = XMPNodeUtils.findSchemaNodeWithPrefix(xmpTree,
      xpath.getSegment(XMPPath.STEP_SCHEMA).getName(), null, createNodes);
    if (currNode === null) {
      return null;
    } else if (currNode.isImplicit()) {
      currNode.setImplicit(false); // 清除隐式节点位
      rootImplicitNode = currNode; // 保存最顶层的隐式节点
    }

    // 现在跟随原始XMPPath的剩余步骤
    try {
      for (let i = 1; i < xpath.size(); i++) {
        currNode = XMPNodeUtils.followXPathStep(currNode!, xpath.getSegment(i), createNodes);
        if (currNode === null) {
          if (createNodes) {
            // 删除隐式创建的节点
            if (rootImplicitNode !== null) {
              XMPNodeUtils.deleteNode(rootImplicitNode);
            }
          }
          return null;
        } else if (currNode.isImplicit()) {
          // 清除隐式节点标志
          currNode.setImplicit(false);

          // 如果节点是别名（只能在根步骤中），当路径已从非简单别名类型解析时自动创建数组
          if (i === 1 &&
          xpath.getSegment(i).isAlias() &&
            xpath.getSegment(i).getAliasForm() !== 0) {
            currNode.getOptions().setOption(xpath.getSegment(i).getAliasForm(), true);
          }
          // C++中的"CheckImplicitStruct"
          else if (i < xpath.size() - 1 &&
            xpath.getSegment(i).getKind() === XMPPath.STRUCT_FIELD_STEP &&
            !currNode.getOptions().isCompositeProperty()) {
            currNode.getOptions().setStruct(true);
          }

          if (rootImplicitNode === null) {
            rootImplicitNode = currNode; // 保存最顶层的隐式节点
          }
        }
      }
    } catch (e) {
      // 如果在错误之前已创建新节点，则删除它们
      if (rootImplicitNode !== null) {
        XMPNodeUtils.deleteNode(rootImplicitNode);
      }
      throw new Error(e);
    }

    if (rootImplicitNode !== null && leafOptions !== null) {
      // 仅当成功创建节点时才设置选项
      currNode!.getOptions().mergeWith(leafOptions);
      currNode!.setOptions(currNode!.getOptions());
    }

    return currNode!
  }

  /**
   * 从父节点中删除给定节点及其子节点
   * @param node 要删除的最顶层节点
   */
  static deleteNode(node: XMPNode): void {
    const parent = node.getParent();

    if (node.getOptions().isQualifier()) {
      // 根是限定符
      parent!.removeQualifier(node);
    } else {
      // 根不是限定符
      parent!.removeChild(node);
    }

    // 删除空模式节点
    if (!parent!.hasChildren() && parent!.getOptions().isSchemaNode()) {
      parent!.getParent()!.removeChild(parent!);
    }
  }

  /**
   * 设置叶节点的值
   * @param node XMPNode
   * @param value 值
   */
  static setNodeValue(node: XMPNode, value: ESObject): void {
    const strValue = XMPNodeUtils.serializeNodeValue(value);
    if (!(node.getOptions().isQualifier() && XMPConst.XML_LANG === node.getName())) {
      node.setValue(strValue);
    } else {
      node.setValue(Utils.normalizeLangValue(strValue));
    }
  }

  /**
   * 验证PropertyOptions的一致性并根据需要更新它们
   * @param options PropertyOptions
   * @param itemValue 要设置的节点值
   * @return 更新后的选项
   * @throws XMPException
   */
  static verifySetOptions(options: PropertyOptions | null, itemValue: ESObject): PropertyOptions {
    // 创建空选项并修复现有选项
    if (options === null) {
      // 设置默认选项
      options = new PropertyOptions();
    }

    if (options.isArrayAltText()) {
      options.setArrayAlternate(true);
    }

    if (options.isArrayAlternate()) {
      options.setArrayOrdered(true);
    }

    if (options.isArrayOrdered()) {
      options.setArray(true);
    }

    if (options.isCompositeProperty() && itemValue !== null && String(itemValue).length > 0) {
      throw new XMPException('Structs and arrays can\'t have values', XMPError.BADOPTIONS);
    }

    options.assertConsistency(options.getOptions());

    return options;
  }

  /**
   * 将节点值转换为String，为XMP中定义的类型应用特殊转换
   * @param value 要设置的节点值
   * @return 节点值的String表示
   */
  static serializeNodeValue(value: ESObject): string | null {
    let strValue: string | null;
    if (value === null) {
      strValue = null;
    } else if (typeof value === 'boolean') {
      strValue = XMPUtils.convertFromBoolean(value);
    } else if (typeof value === 'number') {
      if (Number.isInteger(value)) {
        if (value > Math.pow(2, 31) - 1 || value < Math.pow(-2, 31)) {
          strValue = XMPUtils.convertFromLong(value);
        } else {
          strValue = XMPUtils.convertFromInteger(value);
        }
      } else {
        strValue = XMPUtils.convertFromDouble(value);
      }
    } else if (value instanceof XMPDateTimeImpl) {
      strValue = XMPUtils.convertFromDate(value as XMPDateTime);
    } else if (value instanceof Date) {
      const dt: XMPDateTime = new XMPDateTimeImpl(value);
      strValue = XMPUtils.convertFromDate(dt);
    } else if (value instanceof ArrayBuffer) {
      const uint8Array = new Uint8Array(value);
      strValue = XMPUtils.encodeBase64(uint8Array);
    } else if (Array.isArray(value)) {
      const uint8Array = new Uint8Array(value as number[]);
      strValue = XMPUtils.encodeBase64(uint8Array);
    } else {
      strValue = String(value);
    }

    return strValue !== null ? Utils.removeControlChars(strValue) : null;
  }

  /**
   * 处理XPath步骤
   */
  private static followXPathStep(parentNode: XMPNode, nextStep: XMPPathSegment, createNodes: boolean): XMPNode | null {
    let nextNode: XMPNode | null = null;
    let index = 0;
    const stepKind = nextStep.getKind();

    if (stepKind === XMPPath.STRUCT_FIELD_STEP) {
      nextNode = XMPNodeUtils.findChildNode(parentNode, nextStep.getName(), createNodes);
    } else if (stepKind === XMPPath.QUALIFIER_STEP) {
      nextNode = XMPNodeUtils.findQualifierNode(
        parentNode, nextStep.getName().substring(1), createNodes);
    } else {
      // 这是一个数组索引步骤。首先获取索引，然后获取节点

      if (!parentNode.getOptions().isArray()) {
        throw new XMPException('Indexing applied to non-array', XMPError.BADXPATH);
      }

      if (stepKind === XMPPath.ARRAY_INDEX_STEP) {
        index = XMPNodeUtils.findIndexedItem(parentNode, nextStep.getName(), createNodes);
      } else if (stepKind === XMPPath.ARRAY_LAST_STEP) {
        index = parentNode.getChildrenLength();
      } else if (stepKind === XMPPath.FIELD_SELECTOR_STEP) {
        const result = Utils.splitNameAndValue(nextStep.getName());
        const fieldName = result[0];
        const fieldValue = result[1];
        index = XMPNodeUtils.lookupFieldSelector(parentNode, fieldName, fieldValue);
      } else if (stepKind === XMPPath.QUAL_SELECTOR_STEP) {
        const result = Utils.splitNameAndValue(nextStep.getName());
        const qualName = result[0];
        const qualValue = result[1];
        index = XMPNodeUtils.lookupQualSelector(
          parentNode, qualName, qualValue, nextStep.getAliasForm());
      } else {
        throw new XMPException('Unknown array indexing step in FollowXPathStep', XMPError.INTERNALFAILURE);
      }

      if (1 <= index && index <= parentNode.getChildrenLength()) {
        nextNode = parentNode.getChild(index);
      }
    }

    return nextNode;
  }

  /**
   * 查找或创建限定符节点
   */
  private static findQualifierNode(parent: XMPNode, qualName: string, createNodes: boolean): XMPNode | null {
    // 确保qualName不以?开头
    if (qualName.startsWith('?')) {
      throw new XMPException('Invalid qualifier name', XMPError.BADXPATH);
    }

    let qualNode = parent.findQualifierByName(qualName);

    if (qualNode === null && createNodes) {
      qualNode = new XMPNode(qualName, null, null, null);
      qualNode.setImplicit(true);

      parent.addQualifier(qualNode);
    }

    return qualNode;
  }

  /**
   * 查找索引项
   */
  private static findIndexedItem(arrayNode: XMPNode, segment: string, createNodes: boolean): number {
    let index = 0;

    try {
      segment = segment.substring(1, segment.length - 1);
      index = parseInt(segment);
      if (index < 1) {
        throw new XMPException('Array index must be larger than zero', XMPError.BADXPATH);
      }
    } catch (e) {
      throw new XMPException('Array index not digits.', XMPError.BADXPATH);
    }

    if (createNodes && index === arrayNode.getChildrenLength() + 1) {
      // 添加新的最后一个+1节点
      const newItem = new XMPNode(XMPConst.ARRAY_ITEM_NAME, null, null, null);
      newItem.setImplicit(true);
      arrayNode.addChild(newItem);
    }

    return index;
  }

  /**
   * 查找字段选择器
   */
  private static lookupFieldSelector(arrayNode: XMPNode, fieldName: string, fieldValue: string): number {
    let result = -1;

    for (let index = 1; index <= arrayNode.getChildrenLength() && result < 0; index++) {
      const currItem = arrayNode.getChild(index);

      if (!currItem.getOptions().isStruct()) {
        throw new XMPException('Field selector must be used on array of struct', XMPError.BADXPATH);
      }

      for (let f = 1; f <= currItem.getChildrenLength(); f++) {
        const currField = currItem.getChild(f);
        if (fieldName !== currField.getName()) {
          continue;
        }
        if (fieldValue === currField.getValue()) {
          result = index;
          break;
        }
      }
    }

    return result;
  }

  /**
   * 查找限定符选择器
   */
  private static lookupQualSelector(arrayNode: XMPNode, qualName: string,
    qualValue: string, aliasForm: number): number {
    if (XMPConst.XML_LANG === qualName) {
      const normalizedQualValue = Utils.normalizeLangValue(qualValue);
      if (normalizedQualValue === null) {
        return -1;
      }
      const index = XMPNodeUtils.lookupLanguageItem(arrayNode, normalizedQualValue);
      if (index < 0 && (aliasForm & AliasOptions.PROP_ARRAY_ALT_TEXT) > 0) {
        const langNode = new XMPNode(XMPConst.ARRAY_ITEM_NAME, null, null, null);
        const xdefault = new XMPNode(XMPConst.XML_LANG, XMPConst.X_DEFAULT, null, null);
        langNode.addQualifier(xdefault);
        arrayNode.addChild(1, langNode);
        return 1;
      } else {
        return index;
      }
    } else {
      for (let index = 1; index < arrayNode.getChildrenLength(); index++) {
        const currItem = arrayNode.getChild(index);
        
        const qualifierIterator: Iterator<XMPNode> = currItem.iterateQualifier();
        let qualifierResult: IteratorResult<XMPNode, undefined> = qualifierIterator.next();
        while (!qualifierResult.done) {
          const qualifier: XMPNode = qualifierResult.value;
          if (qualName === qualifier.getName() && qualValue === qualifier.getValue()) {
            return index;
          }
          qualifierResult = qualifierIterator.next();
        }
      }
      return -1;
    }
  }

  /**
   * 确保x-default项在首位
   */
  static normalizeLangArray(arrayNode: XMPNode): void {
    if (!arrayNode.getOptions().isArrayAltText()) {
      return;
    }

    // 检查带有x-default限定符的节点是否在首位
    for (let i = 2; i <= arrayNode.getChildrenLength(); i++) {
      const child = arrayNode.getChild(i);
      if (child.hasQualifier() && XMPConst.X_DEFAULT === child.getQualifier(1).getValue()) {
        // 将节点移到首位
        try {
          arrayNode.removeChild(i);
          arrayNode.addChild(1, child);
        } catch (e) {
          // 不可能发生，因为在添加前已移除相同的子节点
        }

        if (i === 2) {
          arrayNode.getChild(2).setValue(child.getValue());
        }
        break;
      }
    }
  }

  /**
   * 检测数组是否为alt-text数组
   */
  static detectAltText(arrayNode: XMPNode): void {
    if (arrayNode.getOptions().isArrayAlternate() && arrayNode.hasChildren()) {
      let isAltText = false;
      const childrenIterator: Iterator<XMPNode> = arrayNode.iterateChildren();
      let childResult: IteratorResult<XMPNode, undefined> = childrenIterator.next();
      while (!childResult.done) {
        const child: XMPNode = childResult.value;
        if (child.getOptions().getHasLanguage()) {
          isAltText = true;
          break;
        }
        childResult = childrenIterator.next();
      }

      if (isAltText) {
        arrayNode.getOptions().setArrayAltText(true);
        XMPNodeUtils.normalizeLangArray(arrayNode);
      }
    }
  }

  /**
   * 向alt text数组追加语言项
   */
  static appendLangItem(arrayNode: XMPNode, itemLang: string, itemValue: string): void {
    const newItem = new XMPNode(XMPConst.ARRAY_ITEM_NAME, itemValue, null, null);
    const langQual = new XMPNode(XMPConst.XML_LANG, itemLang, null, null);
    newItem.addQualifier(langQual);

    if (XMPConst.X_DEFAULT !== langQual.getValue()) {
      arrayNode.addChild(newItem);
    } else {
      arrayNode.addChild(1, newItem);
    }
  }

  /**
   * 选择本地化文本
   */
  static chooseLocalizedText(arrayNode: XMPNode, genericLang: string | null,
    specificLang: string): [number, XMPNode | null] {
    // 检查数组是否具有正确的形式。允许空的alt数组，这是解析返回的结果
    if (!arrayNode.getOptions().isArrayAltText()) {
      throw new XMPException('Localized text array is not alt-text', XMPError.BADXPATH);
    } else if (!arrayNode.hasChildren()) {
      return [XMPNodeUtils.CLT_NO_VALUES, null];
    }

    let foundGenericMatches = 0;
    let resultNode: XMPNode | null = null;
    let xDefault: XMPNode | null = null;

    // 查找与通用语言的第一个部分匹配
    const childrenIterator: Iterator<XMPNode> = arrayNode.iterateChildren();
    let itemResult: IteratorResult<XMPNode, undefined> = childrenIterator.next();
    while (!itemResult.done) {
      const currItem: XMPNode = itemResult.value;
      // 对当前项执行一些检查
      if (currItem.getOptions().isCompositeProperty()) {
        throw new XMPException('Alt-text array item is not simple', XMPError.BADXPATH);
      } else if (!currItem.hasQualifier() ||
        XMPConst.XML_LANG !== currItem.getQualifier(1).getName()) {
        throw new XMPException('Alt-text array item has no language qualifier', XMPError.BADXPATH);
      }

      const currLang = currItem.getQualifier(1).getValue();

      // 查找与特定语言的完全匹配
      if (currLang !== null && specificLang === currLang) {
        return [XMPNodeUtils.CLT_SPECIFIC_MATCH, currItem];
      } else if (currLang !== null && genericLang !== null && currLang.startsWith(genericLang)) {
        if (resultNode === null) {
          resultNode = currItem;
        }
        // 不要返回/中断，需要查找其他匹配项
        foundGenericMatches++;
      } else if (currLang !== null && XMPConst.X_DEFAULT === currLang) {
        xDefault = currItem;
      }
      itemResult = childrenIterator.next();
    }

    // 评估循环结果
    if (foundGenericMatches === 1) {
      return [XMPNodeUtils.CLT_SINGLE_GENERIC, resultNode];
    } else if (foundGenericMatches > 1) {
      return [XMPNodeUtils.CLT_MULTIPLE_GENERIC, resultNode];
    } else if (xDefault !== null) {
      return [XMPNodeUtils.CLT_XDEFAULT, xDefault];
    } else {
      // 所有都失败了，选择第一个项
      return [XMPNodeUtils.CLT_FIRST_ITEM, arrayNode.getChild(1)];
    }
  }

  /**
   * 查找文本替代数组中的适当语言项
   */
  static lookupLanguageItem(arrayNode: XMPNode, language: string): number {
    if (!arrayNode.getOptions().isArray()) {
      throw new XMPException('Language item must be used on array', XMPError.BADXPATH);
    }

    for (let index = 1; index <= arrayNode.getChildrenLength(); index++) {
      const child = arrayNode.getChild(index);
      if (!child.hasQualifier() || XMPConst.XML_LANG !== child.getQualifier(1).getName()) {
        continue;
      }
      const qualValue = child.getQualifier(1).getValue();
      if (qualValue !== null && language === qualValue) {
        return index;
      }
    }

    return -1;
  }
}