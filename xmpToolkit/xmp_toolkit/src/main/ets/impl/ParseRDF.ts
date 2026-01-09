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
import XMPMetaFactory from '../XMPMetaFactory';
import PropertyOptions from '../options/PropertyOptions';
import XMPNode from './XMPNode';
import XMPNodeUtils from './XMPNodeUtils';
import XMPSchemaRegistry from '../XMPSchemaRegistry';
import Utils from './Utils';

/**
 * Parser for "normal" XML serialisation of RDF.
 * 将Java的ParseRDF类转换为ArkTS格式
 */

export interface XmlNode {
  getAttributes(): XmlNode[];
  getChildNodes(): XmlNode[];
  getNodeType(): number;
  getNodeName(): string;
  getNodeValue(): string;
  getLocalName(): string;
  getNamespaceURI(): string | null;
  getPrefix(): string | null;
  hasAttributes(): boolean;
  hasChildNodes(): boolean;
  item(index: number): XmlNode | null;
  getOwnerElement?(): XmlNode | null;
}

// XML节点类型常量
export const TEXT_NODE = 3;
export const ELEMENT_NODE = 1;

export default class ParseRDF {
  /** RDF术语类型常量 */
  public static readonly RDFTERM_OTHER = 0;
  public static readonly RDFTERM_RDF = 1;
  public static readonly RDFTERM_ID = 2;
  public static readonly RDFTERM_ABOUT = 3;
  public static readonly RDFTERM_PARSE_TYPE = 4;
  public static readonly RDFTERM_RESOURCE = 5;
  public static readonly RDFTERM_NODE_ID = 6;
  public static readonly RDFTERM_DATATYPE = 7;
  public static readonly RDFTERM_DESCRIPTION = 8;
  public static readonly RDFTERM_LI = 9;
  public static readonly RDFTERM_ABOUT_EACH = 10;
  public static readonly RDFTERM_ABOUT_EACH_PREFIX = 11;
  public static readonly RDFTERM_BAG_ID = 12;
  public static readonly RDFTERM_FIRST_CORE = ParseRDF.RDFTERM_RDF;
  public static readonly RDFTERM_LAST_CORE = ParseRDF.RDFTERM_DATATYPE;
  public static readonly RDFTERM_FIRST_SYNTAX = ParseRDF.RDFTERM_FIRST_CORE;
  public static readonly RDFTERM_LAST_SYNTAX = ParseRDF.RDFTERM_LI;
  public static readonly RDFTERM_FIRST_OLD = ParseRDF.RDFTERM_ABOUT_EACH;
  public static readonly RDFTERM_LAST_OLD = ParseRDF.RDFTERM_BAG_ID;

  /** 用于默认命名空间的前缀 */
  public static readonly DEFAULT_PREFIX = '_dflt';

  /**
   * 主要解析方法。从根节点遍历XML树并创建XMP树。
   * 这是一个原始解析，XMP树的规范化在外部进行。
   * 
   * @param xmlRoot XML根节点
   * @return 返回一个XMP元数据对象（未规范化）
   * @throws XMPException 如果解析因任何原因失败
   */
  public static parse(xmlRoot: XmlNode): XMPMeta {
    const xmp = XMPMetaFactory.create();
    ParseRDF.rdf_RDF(xmp as ESObject, xmlRoot);
    return xmp;
  }

  /**
   * 处理rdf:RDF节点
   * 
   * @param xmp 生成的xmp元数据对象
   * @param rdfRdfNode 顶级xml节点
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_RDF(xmp: ESObject, rdfRdfNode: XmlNode): void {
    // rdf:RDF element should have child nodes (rdf:Description elements)
    // Attributes are optional (namespace declarations may or may not be counted as attributes)
    // Check if it has child nodes OR attributes
    if (rdfRdfNode.hasChildNodes() || rdfRdfNode.hasAttributes()) {
      ParseRDF.rdf_NodeElementList(xmp, xmp.getRoot(), rdfRdfNode);
    } else {
      throw new XMPException('Invalid rdf:RDF element: must have child nodes or attributes', XMPError.BADRDF);
    }
  }

  /**
   * 处理节点元素列表
   * 7.2.10 nodeElementList<br>
   * ws* ( nodeElement ws* )*
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param rdfRdfNode 顶级xml节点
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_NodeElementList(xmp: ESObject, xmpParent: XMPNode,
                                     rdfRdfNode: XmlNode): void {
    const childNodes = rdfRdfNode.getChildNodes();
    for (let i = 0; i < childNodes.length; i++) {
      const child = childNodes[i];
      // 过滤空白（和所有文本节点）
      if (!ParseRDF.isWhitespaceNode(child)) {
        ParseRDF.rdf_NodeElement(xmp, xmpParent, child, true);
      }
    }
  }

  /**
   * 处理节点元素
   * 7.2.5 nodeElementURIs
   * anyURI - ( coreSyntaxTerms | rdf:li | oldTerms )
   * 
   * 7.2.11 nodeElement
   * start-element ( URI == nodeElementURIs,
   * attributes == set ( ( idAttr | nodeIdAttr | aboutAttr )?, propertyAttr* ) )
   * propertyEltList
   * end-element()
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param xmlNode 当前处理的XML节点
   * @param isTopLevel 节点是否为顶级节点的标志
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_NodeElement(xmp: ESObject, xmpParent: XMPNode, xmlNode: XmlNode,
                                 isTopLevel: boolean): void {
    const nodeTerm = ParseRDF.getRDFTermKind(xmlNode);
    if (nodeTerm !== ParseRDF.RDFTERM_DESCRIPTION && nodeTerm !== ParseRDF.RDFTERM_OTHER) {
      throw new XMPException('Node element must be rdf:Description or typed node', XMPError.BADRDF);
    } else if (isTopLevel && nodeTerm === ParseRDF.RDFTERM_OTHER) {
      throw new XMPException('Top level typed node not allowed', XMPError.BADXMP);
    } else {
      ParseRDF.rdf_NodeElementAttrs(xmp, xmpParent, xmlNode, isTopLevel);
      ParseRDF.rdf_PropertyElementList(xmp, xmpParent, xmlNode, isTopLevel);
    }
  }

  /**
   * 处理节点元素属性
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param xmlNode 当前处理的XML节点
   * @param isTopLevel 节点是否为顶级节点的标志
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_NodeElementAttrs(xmp: ESObject, xmpParent: XMPNode, xmlNode: XmlNode,
                                      isTopLevel: boolean): void {
    // 用于检测互斥的属性
    let exclusiveAttrs = 0;

    const attributes = xmlNode.getAttributes();
    for (let i = 0; i < attributes.length; i++) {
      const attribute = attributes[i];

      // 快速处理，命名空间声明在C++中不会出现
      // 忽略没有命名空间的"ID"
      const prefix = attribute.getPrefix();
      const nodeName = attribute.getNodeName();
      if ((prefix === 'xmlns') || (prefix === null && nodeName === 'xmlns')) {
        continue;
      }

      const attrTerm = ParseRDF.getRDFTermKind(attribute);

      switch (attrTerm) {
        case ParseRDF.RDFTERM_ID:
        case ParseRDF.RDFTERM_NODE_ID:
        case ParseRDF.RDFTERM_ABOUT:
          if (exclusiveAttrs > 0) {
            throw new XMPException('Mutally exclusive about, ID, nodeID attributes', XMPError.BADRDF);
          }

          exclusiveAttrs++;

          if (isTopLevel && (attrTerm === ParseRDF.RDFTERM_ABOUT)) {
            // 这是顶级节点上的rdf:about属性。设置XMP树名称（如果尚未设置）
            if (xmpParent.getName() && xmpParent.getName()!.length > 0) {
              // veraPDF修改：移除了不同rdf:about元素的异常检查
            } else {
              xmpParent.setName(attribute.getNodeValue());
            }
          }
          break;

        case ParseRDF.RDFTERM_OTHER:
          ParseRDF.addChildNode(xmp, xmpParent, attribute, attribute.getNodeValue(), isTopLevel);
          break;

        default:
          throw new XMPException('Invalid nodeElement attribute', XMPError.BADRDF);
      }
    }
  }

  /**
   * 处理属性元素列表
   * 7.2.13 propertyEltList
   * ws* ( propertyElt ws* )*
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param xmlParent 当前处理的XML节点
   * @param isTopLevel 节点是否为顶级节点的标志
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_PropertyElementList(xmp: ESObject, xmpParent: XMPNode, xmlParent: XmlNode,
                                         isTopLevel: boolean): void {
    const childNodes = xmlParent.getChildNodes();
    for (let i = 0; i < childNodes.length; i++) {
      const currChild = childNodes[i];
      if (ParseRDF.isWhitespaceNode(currChild)) {
        continue;
      } else if (currChild.getNodeType() !== ELEMENT_NODE) {
        throw new XMPException('Expected property element node not found', XMPError.BADRDF);
      } else {
        ParseRDF.rdf_PropertyElement(xmp, xmpParent, currChild, isTopLevel);
      }
    }
  }

  /**
   * 处理属性元素
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param xmlNode 当前处理的XML节点
   * @param isTopLevel 节点是否为顶级节点的标志
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_PropertyElement(xmp: ESObject, xmpParent: XMPNode, xmlNode: XmlNode,
                                     isTopLevel: boolean): void {
    const nodeTerm = ParseRDF.getRDFTermKind(xmlNode);
    if (!ParseRDF.isPropertyElementName(nodeTerm)) {
      throw new XMPException('Invalid property element name', XMPError.BADRDF);
    }

    // 从列表中移除命名空间定义
    let attributes = xmlNode.getAttributes();
    const nsAttrs: string[] = [];
    for (let i = 0; i < attributes.length; i++) {
      const attribute = attributes[i];
      const prefix = attribute.getPrefix();
      const nodeName = attribute.getNodeName();
      if ((prefix === 'xmlns') || (prefix === null && nodeName === 'xmlns')) {
        nsAttrs.push(nodeName);
      }
    }

    // 在实际实现中，这里应该从attributes中移除nsAttrs中的属性

    if (attributes.length > 3) {
      // 只有emptyPropertyElt可以有超过3个属性
      ParseRDF.rdf_EmptyPropertyElement(xmp, xmpParent, xmlNode, isTopLevel);
    } else {
      // 查找不是rdf:ID或xml:lang的属性，它通常会告诉我们应该处理什么
      for (let i = 0; i < attributes.length; i++) {
        const attribute = attributes[i];
        const attrLocal = attribute.getLocalName();
        const attrNS = attribute.getNamespaceURI();
        const attrValue = attribute.getNodeValue();
        const attrNodeName = attribute.getNodeName();
        const attrPrefix = attribute.getPrefix();

        // 跳过命名空间声明
        if (attrPrefix === 'xmlns' || attrNodeName === 'xmlns') {
          continue;
        }

        if (!(XMPConst.XML_LANG === attrNodeName) && !(attrLocal === 'ID' && XMPConst.NS_RDF === attrNS)) {
          if (attrLocal === 'datatype' && XMPConst.NS_RDF === attrNS) {
            ParseRDF.rdf_LiteralPropertyElement(xmp, xmpParent, xmlNode, isTopLevel);
          } else if (!(attrLocal === 'parseType' && XMPConst.NS_RDF === attrNS)) {
            ParseRDF.rdf_EmptyPropertyElement(xmp, xmpParent, xmlNode, isTopLevel);
          } else if (attrValue === 'Literal') {
            ParseRDF.rdf_ParseTypeLiteralPropertyElement();
          } else if (attrValue === 'Resource') {
            ParseRDF.rdf_ParseTypeResourcePropertyElement(xmp, xmpParent, xmlNode, isTopLevel);
          } else if (attrValue === 'Collection') {
            ParseRDF.rdf_ParseTypeCollectionPropertyElement();
          } else {
            ParseRDF.rdf_ParseTypeOtherPropertyElement();
          }
          return;
        }
      }

      // 只有rdf:ID和xml:lang，可能是resourcePropertyElt、literalPropertyElt或emptyPropertyElt
      // 查看XML子节点来决定是哪一个
      if (xmlNode.hasChildNodes()) {
        const childNodes = xmlNode.getChildNodes();
        for (let i = 0; i < childNodes.length; i++) {
          const currChild = childNodes[i];
          if (currChild.getNodeType() !== TEXT_NODE) {
            ParseRDF.rdf_ResourcePropertyElement(xmp, xmpParent, xmlNode, isTopLevel);
            return;
          }
        }
        ParseRDF.rdf_LiteralPropertyElement(xmp, xmpParent, xmlNode, isTopLevel);
      } else {
        ParseRDF.rdf_EmptyPropertyElement(xmp, xmpParent, xmlNode, isTopLevel);
      }
    }
  }

  /**
   * 处理资源属性元素
   * 7.2.15 resourcePropertyElt
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param xmlNode 当前处理的XML节点
   * @param isTopLevel 节点是否为顶级节点的标志
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_ResourcePropertyElement(xmp: ESObject, xmpParent: XMPNode, xmlNode: XmlNode,
                                             isTopLevel: boolean): void {
    if (isTopLevel && xmlNode.getNodeName() === 'iX:changes') {
      // 移除带有前缀"iX:"的旧"punchcard"碎片
      return;
    }

    const newCompound = ParseRDF.addChildNode(xmp, xmpParent, xmlNode, '', isTopLevel);

    // 遍历属性
    const attributes = xmlNode.getAttributes();
    for (let i = 0; i < attributes.length; i++) {
      const attribute = attributes[i];
      const prefix = attribute.getPrefix();
      const nodeName = attribute.getNodeName();
      if ((prefix === 'xmlns') || (prefix === null && nodeName === 'xmlns')) {
        continue;
      }

      const attrLocal = attribute.getLocalName();
      const attrNS = attribute.getNamespaceURI();
      if (XMPConst.XML_LANG === attribute.getNodeName()) {
        ParseRDF.addQualifierNode(newCompound, XMPConst.XML_LANG, attribute.getNodeValue());
      } else if (attrLocal === 'ID' && XMPConst.NS_RDF === attrNS) {
        continue; // 忽略所有rdf:ID属性
      } else {
        throw new XMPException('Invalid attribute for resource property element', XMPError.BADRDF);
      }
    }

    // 遍历子节点
    let currChild: XmlNode | null = null;
    let found = false;
    const childNodes = xmlNode.getChildNodes();
    for (let i = 0; i < childNodes.length; i++) {
      currChild = childNodes[i];
      if (!ParseRDF.isWhitespaceNode(currChild)) {
        if (currChild.getNodeType() === ELEMENT_NODE && !found) {
          const isRDF = XMPConst.NS_RDF === currChild.getNamespaceURI();
          const childLocal = currChild.getLocalName();

          if (isRDF && childLocal === 'Bag') {
            newCompound.getOptions().setArray(true);
          } else if (isRDF && childLocal === 'Seq') {
            newCompound.getOptions().setArray(true).setArrayOrdered(true);
          } else if (isRDF && childLocal === 'Alt') {
            newCompound.getOptions().setArray(true).setArrayOrdered(true).setArrayAlternate(true);
          } else {
            newCompound.getOptions().setStruct(true);
            if (!isRDF && childLocal !== 'Description') {
              let typeName = currChild.getNamespaceURI();
              if (typeName === null) {
                throw new XMPException('All XML elements must be in a namespace', XMPError.BADXMP);
              }
              typeName += ':' + childLocal;
              ParseRDF.addQualifierNode(newCompound, 'rdf:type', typeName);
            }
          }

          ParseRDF.rdf_NodeElement(xmp, newCompound, currChild, false);

          if (newCompound.getHasValueChild()) {
            ParseRDF.fixupQualifiedNode(newCompound);
          } else if (newCompound.getOptions().isArrayAlternate()) {
            XMPNodeUtils.detectAltText(newCompound);
          }

          found = true;
        } else if (found) {
          // 找到第二个子元素
          throw new XMPException('Invalid child of resource property element', XMPError.BADRDF);
        } else {
          throw new XMPException('Children of resource property element must be XML elements', XMPError.BADRDF);
        }
      }
    }

    if (!found) {
      // 没有找到任何子元素
      throw new XMPException('Missing child of resource property element', XMPError.BADRDF);
    }
  }

  /**
   * 处理文本属性元素
   * 7.2.16 literalPropertyElt
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param xmlNode 当前处理的XML节点
   * @param isTopLevel 节点是否为顶级节点的标志
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_LiteralPropertyElement(xmp: ESObject, xmpParent: XMPNode, xmlNode: XmlNode,
                                            isTopLevel: boolean): void {
    const newChild = ParseRDF.addChildNode(xmp, xmpParent, xmlNode, null, isTopLevel);

    const attributes = xmlNode.getAttributes();
    for (let i = 0; i < attributes.length; i++) {
      const attribute = attributes[i];
      const prefix = attribute.getPrefix();
      const nodeName = attribute.getNodeName();
      if ((prefix === 'xmlns') || (prefix === null && nodeName === 'xmlns')) {
        continue;
      }

      const attrNS = attribute.getNamespaceURI();
      const attrLocal = attribute.getLocalName();
      if (XMPConst.XML_LANG === attribute.getNodeName()) {
        ParseRDF.addQualifierNode(newChild, XMPConst.XML_LANG, attribute.getNodeValue());
      } else if (attrNS === XMPConst.NS_RDF && (attrLocal === 'ID' || attrLocal === 'datatype')) {
        continue; // 忽略所有rdf:ID和rdf:datatype属性
      } else {
        throw new XMPException('Invalid attribute for literal property element', XMPError.BADRDF);
      }
    }

    let textValue = '';
    const childNodes = xmlNode.getChildNodes();
    for (let i = 0; i < childNodes.length; i++) {
      const child = childNodes[i];
      if (child.getNodeType() === TEXT_NODE) {
        textValue += child.getNodeValue();
      } else {
        throw new XMPException('Invalid child of literal property element', XMPError.BADRDF);
      }
    }
    newChild.setValue(textValue);
  }

  /**
   * 处理parseTypeLiteral属性元素
   * 7.2.17 parseTypeLiteralPropertyElt
   * 
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_ParseTypeLiteralPropertyElement(): void {
    throw new XMPException('ParseTypeLiteral property element not allowed', XMPError.BADXMP);
  }

  /**
   * 处理parseTypeResource属性元素
   * 7.2.18 parseTypeResourcePropertyElt
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param xmlNode 当前处理的XML节点
   * @param isTopLevel 节点是否为顶级节点的标志
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_ParseTypeResourcePropertyElement(xmp: ESObject, xmpParent: XMPNode, xmlNode: XmlNode,
                                                      isTopLevel: boolean): void {
    const newStruct = ParseRDF.addChildNode(xmp, xmpParent, xmlNode, '', isTopLevel);
    newStruct.getOptions().setStruct(true);

    const attributes = xmlNode.getAttributes();
    for (let i = 0; i < attributes.length; i++) {
      const attribute = attributes[i];
      const prefix = attribute.getPrefix();
      const nodeName = attribute.getNodeName();
      if ((prefix === 'xmlns') || (prefix === null && nodeName === 'xmlns')) {
        continue;
      }

      const attrLocal = attribute.getLocalName();
      const attrNS = attribute.getNamespaceURI();
      if (XMPConst.XML_LANG === attribute.getNodeName()) {
        ParseRDF.addQualifierNode(newStruct, XMPConst.XML_LANG, attribute.getNodeValue());
      } else if (attrNS === XMPConst.NS_RDF && (attrLocal === 'ID' || attrLocal === 'parseType')) {
        continue; // 调用者确保值为"Resource"，忽略所有rdf:ID属性
      } else {
        throw new XMPException('Invalid attribute for ParseTypeResource property element', XMPError.BADRDF);
      }
    }

    ParseRDF.rdf_PropertyElementList(xmp, newStruct, xmlNode, false);

    if (newStruct.getHasValueChild()) {
      ParseRDF.fixupQualifiedNode(newStruct);
    }
  }

  /**
   * 处理parseTypeCollection属性元素
   * 7.2.19 parseTypeCollectionPropertyElt
   * 
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_ParseTypeCollectionPropertyElement(): void {
    throw new XMPException('ParseTypeCollection property element not allowed', XMPError.BADXMP);
  }

  /**
   * 处理parseTypeOther属性元素
   * 7.2.20 parseTypeOtherPropertyElt
   * 
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_ParseTypeOtherPropertyElement(): void {
    throw new XMPException('ParseTypeOther property element not allowed', XMPError.BADXMP);
  }

  /**
   * 处理空属性元素
   * 7.2.21 emptyPropertyElt
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param xmlNode 当前处理的XML节点
   * @param isTopLevel 节点是否为顶级节点的标志
   * @throws XMPException 解析错误时抛出
   */
  private static rdf_EmptyPropertyElement(xmp: ESObject, xmpParent: XMPNode, xmlNode: XmlNode,
                                          isTopLevel: boolean): void {
    let hasPropertyAttrs = false;
    let hasResourceAttr = false;
    let hasNodeIDAttr = false;
    let hasValueAttr = false;
    let valueNode: XmlNode | null = null; // 可以来自rdf:value或rdf:resource

    if (xmlNode.hasChildNodes()) {
      throw new XMPException('Nested content not allowed with rdf:resource or property attributes', XMPError.BADRDF);
    }

    // 首先确定这映射到什么XMP，并记住XML节点作为简单值
    const attributes = xmlNode.getAttributes();
    for (let i = 0; i < attributes.length; i++) {
      const attribute = attributes[i];
      const prefix = attribute.getPrefix();
      const nodeName = attribute.getNodeName();
      if ((prefix === 'xmlns') || (prefix === null && nodeName === 'xmlns')) {
        continue;
      }

      const attrTerm = ParseRDF.getRDFTermKind(attribute);

      switch (attrTerm) {
        case ParseRDF.RDFTERM_ID:
          // 无需操作
          break;

        case ParseRDF.RDFTERM_RESOURCE:
          if (hasNodeIDAttr) {
            throw new XMPException('Empty property element can\'t have both rdf:resource and rdf:nodeID', XMPError.BADRDF);
          } else if (hasValueAttr) {
            throw new XMPException('Empty property element can\'t have both rdf:value and rdf:resource', XMPError.BADXMP);
          }

          hasResourceAttr = true;
          if (!hasValueAttr) {
            valueNode = attribute;
          }
          break;

        case ParseRDF.RDFTERM_NODE_ID:
          if (hasResourceAttr) {
            throw new XMPException('Empty property element can\'t have both rdf:resource and rdf:nodeID', XMPError.BADRDF);
          }
          hasNodeIDAttr = true;
          break;

        case ParseRDF.RDFTERM_OTHER:
          if (attribute.getLocalName() === 'value' && XMPConst.NS_RDF === attribute.getNamespaceURI()) {
            if (hasResourceAttr) {
              throw new XMPException('Empty property element can\'t have both rdf:value and rdf:resource', XMPError.BADXMP);
            }
            hasValueAttr = true;
            valueNode = attribute;
          } else if (attribute.getNodeName() !== XMPConst.XML_LANG) {
            hasPropertyAttrs = true;
          }
          break;

        default:
          throw new XMPException('Unrecognized attribute of empty property element', XMPError.BADRDF);
      }
    }

    // 创建正确类型的子节点并再次访问属性以添加字段或限定符
    const childNode = ParseRDF.addChildNode(xmp, xmpParent, xmlNode, '', isTopLevel);
    let childIsStruct = false;

    if (hasValueAttr || hasResourceAttr) {
      childNode.setValue(valueNode?.getNodeValue() || '');
      if (!hasValueAttr) {
        childNode.getOptions().setURI(true);
      }
    } else if (hasPropertyAttrs) {
      childNode.getOptions().setStruct(true);
      childIsStruct = true;
    }

    for (let i = 0; i < attributes.length; i++) {
      const attribute = attributes[i];
      const prefix = attribute.getPrefix();
      const nodeName = attribute.getNodeName();
      if (attribute === valueNode || (prefix === 'xmlns') || (prefix === null && nodeName === 'xmlns')) {
        continue; // 跳过保存值的rdf:value或rdf:resource属性
      }

      const attrTerm = ParseRDF.getRDFTermKind(attribute);

      switch (attrTerm) {
        case ParseRDF.RDFTERM_ID:
        case ParseRDF.RDFTERM_NODE_ID:
          break; // 忽略所有rdf:ID和rdf:nodeID属性

        case ParseRDF.RDFTERM_RESOURCE:
          ParseRDF.addQualifierNode(childNode, 'rdf:resource', attribute.getNodeValue());
          break;

        case ParseRDF.RDFTERM_OTHER:
          if (!childIsStruct) {
            ParseRDF.addQualifierNode(childNode, attribute.getNodeName(), attribute.getNodeValue());
          } else if (attribute.getNodeName() === XMPConst.XML_LANG) {
            ParseRDF.addQualifierNode(childNode, XMPConst.XML_LANG, attribute.getNodeValue());
          } else {
            ParseRDF.addChildNode(xmp, childNode, attribute, attribute.getNodeValue(), false);
          }
          break;

        default:
          throw new XMPException('Unrecognized attribute of empty property element', XMPError.BADRDF);
      }
    }
  }

  /**
   * 添加子节点
   * 
   * @param xmp 生成的xmp元数据对象
   * @param xmpParent 父xmp节点
   * @param xmlNode 当前处理的XML节点
   * @param value 节点值
   * @param isTopLevel 节点是否为顶级节点的标志
   * @return 返回新创建的子节点
   * @throws XMPException 解析错误时抛出
   */
  private static addChildNode(xmp: ESObject, xmpParent: XMPNode, xmlNode: XmlNode,
                              value: string | null, isTopLevel: boolean): XMPNode {
    const registry: XMPSchemaRegistry = XMPMetaFactory.getSchemaRegistry();
    let namespace = xmlNode.getNamespaceURI();
    let childName: string;

    if (namespace) {
      if (XMPConst.NS_DC_DEPRECATED === namespace) {
        // 修复旧版DC命名空间
        namespace = XMPConst.NS_DC;
      }

      let prefix = registry.getNamespacePrefix(namespace);
      if (prefix === null) {
        prefix = xmlNode.getPrefix() || ParseRDF.DEFAULT_PREFIX;
        prefix = registry.registerNamespace(namespace, prefix);
      }
      childName = prefix + xmlNode.getLocalName();
    } else {
      throw new XMPException('XML namespace required for all elements and attributes', XMPError.BADRDF);
    }

    // 创建schema节点（如果不存在）
    const childOptions = new PropertyOptions();
    let isAlias = false;
    if (isTopLevel) {
      // 查找schema节点，调整XMP父指针
      const schemaNode = XMPNodeUtils.findSchemaNodeWithPrefix(xmp.getRoot(), namespace, ParseRDF.DEFAULT_PREFIX, true);
      if (schemaNode === null) {
        throw new XMPException('Failed to find or create schema node', XMPError.INTERNALFAILURE);
      }
      schemaNode.setImplicit(false); // 清除隐式节点位
      xmpParent = schemaNode;

      // 如果这是别名，在节点中设置别名标志，并在树中设置hasAliases标志
      if (registry.findAlias(childName)) {
        isAlias = true;
        xmp.getRoot().setHasAliases(true);
        schemaNode.setHasAliases(true);
      }
    }

    // 确保这不是命名节点的重复
    const isArrayItem = childName === 'rdf:li';
    const isValueNode = childName === 'rdf:value';

    // 创建XMP节点并进行一些检查
    const newChild = new XMPNode(childName, value || '', childOptions, xmlNode.getPrefix());
    newChild.setAlias(isAlias);

    // 将新子节点添加到XMP父节点，值节点优先
    if (!isValueNode) {
      xmpParent.addChild(newChild);
    } else {
      xmpParent.addChild(1, newChild);
    }

    if (isValueNode) {
      if (isTopLevel || !xmpParent.getOptions().isStruct()) {
        throw new XMPException('Misplaced rdf:value element', XMPError.BADRDF);
      }
      xmpParent.setHasValueChild(true);
    }

    if (isArrayItem) {
      if (!xmpParent.getOptions().isArray()) {
        throw new XMPException('Misplaced rdf:li element', XMPError.BADRDF);
      }
      newChild.setName(XMPConst.ARRAY_ITEM_NAME);
    }

    return newChild;
  }

  /**
   * 添加限定符节点
   * 
   * @param xmpParent 父xmp节点
   * @param name 限定符名称（包括默认前缀的QName）
   * @param value 限定符的值
   * @return 返回新创建的子节点
   * @throws XMPException 解析错误时抛出
   */
  private static addQualifierNode(xmpParent: XMPNode, name: string, value: string): XMPNode {
    const isLang = XMPConst.XML_LANG === name;
    const newQual = new XMPNode(name, isLang ? Utils.normalizeLangValue(value) : value, null, null);
    xmpParent.addQualifier(newQual);
    return newQual;
  }

  /**
   * 修复包含rdf:value字段的RDF伪结构
   * 
   * @param xmpParent 父xmp节点
   * @throws XMPException 解析错误时抛出
   */
  private static fixupQualifiedNode(xmpParent: XMPNode): void {
    if (!(xmpParent.getOptions().isStruct() && xmpParent.hasChildren())) {
      throw new Error('Invalid qualified node');
    }

    const valueNode = xmpParent.getChild(1);
    if (valueNode?.getName() !== 'rdf:value') {
      throw new Error('Invalid value node');
    }

    // 将值节点上的限定符移动到父节点
    if (valueNode.getOptions().getHasLanguage()) {
      if (xmpParent.getOptions().getHasLanguage()) {
        throw new XMPException('Redundant xml:lang for rdf:value element', XMPError.BADXMP);
      }
      const langQual = valueNode.getQualifier(1);
      valueNode.removeQualifier(langQual);
      xmpParent.addQualifier(langQual);
    }

    // 在xml:lang限定符后开始剩余的复制
    const qualifierLength = valueNode.getQualifierLength();
    for (let i = 1; i <= qualifierLength; i++) {
      const qualifier = valueNode.getQualifier(i);
      xmpParent.addQualifier(qualifier);
    }

    // 将父节点的其他子节点更改为限定符
    const childrenLength = xmpParent.getChildrenLength();
    for (let i = 2; i <= childrenLength; i++) {
      const qualifier = xmpParent.getChild(i);
      xmpParent.addQualifier(qualifier);
    }

    // 最后移动选项和值，其他检查需要父节点的原始选项
    xmpParent.setHasValueChild(false);
    xmpParent.getOptions().setStruct(false);
    xmpParent.getOptions().mergeWith(valueNode.getOptions());
    xmpParent.setValue(valueNode.getValue());

    // 移动值节点的子节点作为父节点的子节点
    xmpParent.removeChildren();
    const children: XMPNode[] = valueNode.getUnmodifiableChildren();
    for (let i: number = 0; i < children.length; i++) {
      const child: XMPNode = children[i];
      xmpParent.addChild(child);
    }
  }

  /**
   * 检查节点是否为空白节点
   * 
   * @param node XML节点
   * @return 如果节点是空白节点（仅包含空白的文本节点），则返回true
   */
  private static isWhitespaceNode(node: XmlNode): boolean {
    if (node.getNodeType() !== TEXT_NODE) {
      return false;
    }

    const value = node.getNodeValue();
    for (let i = 0; i < value.length; i++) {
      if (!(/\s/.test(value.charAt(i)))) {
        return false;
      }
    }

    return true;
  }

  /**
   * 检查术语是否为属性元素名称
   * 7.2.6 propertyElementURIs
   * anyURI - ( coreSyntaxTerms | rdf:Description | oldTerms )
   * 
   * @param term 术语ID
   * @return 如果术语是属性元素名称，则返回true
   */
  private static isPropertyElementName(term: number): boolean {
    if (term === ParseRDF.RDFTERM_DESCRIPTION || ParseRDF.isOldTerm(term)) {
      return false;
    } else {
      return !ParseRDF.isCoreSyntaxTerm(term);
    }
  }

  /**
   * 检查术语是否为旧术语
   * 7.2.4 oldTerms<br>
   * rdf:aboutEach | rdf:aboutEachPrefix | rdf:bagID
   * 
   * @param term 术语ID
   * @return 如果术语是旧术语，则返回true
   */
  private static isOldTerm(term: number): boolean {
    return ParseRDF.RDFTERM_FIRST_OLD <= term && term <= ParseRDF.RDFTERM_LAST_OLD;
  }

  /**
   * 检查术语是否为核心语法术语
   * 7.2.2 coreSyntaxTerms<br>
   * rdf:RDF | rdf:ID | rdf:about | rdf:parseType | rdf:resource | rdf:nodeID | rdf:datatype
   * 
   * @param term 术语ID
   * @return 如果术语是核心语法术语，则返回true
   */
  private static isCoreSyntaxTerm(term: number): boolean {
    return ParseRDF.RDFTERM_FIRST_CORE <= term && term <= ParseRDF.RDFTERM_LAST_CORE;
  }

  /**
   * 确定特定RDF术语的ID
   * 安排以希望最小化大型XMP的解析时间
   * 
   * @param node XML节点
   * @return 返回术语ID
   */
  private static getRDFTermKind(node: XmlNode): number {
    const localName = node.getLocalName();
    let namespace = node.getNamespaceURI();

    // 处理没有命名空间但属于RDF元素的属性
    if (!namespace && (localName === 'about' || localName === 'ID') && node.getOwnerElement) {
      const ownerElement = node.getOwnerElement();
      if (ownerElement && XMPConst.NS_RDF === ownerElement.getNamespaceURI()) {
        namespace = XMPConst.NS_RDF;
      }
    }

    if (namespace === XMPConst.NS_RDF) {
      switch (localName) {
        case 'li': return ParseRDF.RDFTERM_LI;
        case 'parseType': return ParseRDF.RDFTERM_PARSE_TYPE;
        case 'Description': return ParseRDF.RDFTERM_DESCRIPTION;
        case 'about': return ParseRDF.RDFTERM_ABOUT;
        case 'resource': return ParseRDF.RDFTERM_RESOURCE;
        case 'RDF': return ParseRDF.RDFTERM_RDF;
        case 'ID': return ParseRDF.RDFTERM_ID;
        case 'nodeID': return ParseRDF.RDFTERM_NODE_ID;
        case 'datatype': return ParseRDF.RDFTERM_DATATYPE;
        case 'aboutEach': return ParseRDF.RDFTERM_ABOUT_EACH;
        case 'aboutEachPrefix': return ParseRDF.RDFTERM_ABOUT_EACH_PREFIX;
        case 'bagID': return ParseRDF.RDFTERM_BAG_ID;
      }
    }

    return ParseRDF.RDFTERM_OTHER;
  }
}