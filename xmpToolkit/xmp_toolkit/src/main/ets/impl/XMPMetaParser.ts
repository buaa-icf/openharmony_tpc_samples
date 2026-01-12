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
import XMPError from '../XMPError';
import XMPException from '../XMPException';
import XMPNode  from './XMPNode';
import XMPNodeUtils from './XMPNodeUtils';
import ParseOptions from '../options/ParseOptions';
import XMPConst from '../XMPConst';
import ParseRDF, { XmlNode } from './ParseRDF';
import InputSource from './InputSource';
import XmlDocument from './XmlDocument';
import { xml, util } from '@kit.ArkTS';

/**
 * The <code>XMPMetaParser</code> is used to parse the XMP data packet and create an <code>XMPMeta</code>-object.
 * 
 * @since   11.02.2006
 */
export default class XMPMetaParser {
  /**
   * Parses the input which can be an <code>InputStream</code>, a <code>byte[]</code> or a <code>String</code>
   * and returns an <code>XMPMeta</code>-object.
   * 
   * @param input the input can be an <code>InputStream</code>, a <code>byte[]</code> or a <code>String</code>
   * @param options the parse options
   * @return Returns the <code>XMPMeta</code>-object created from the input.
   * @throws XMPException If the input is not valid XMP.
   */
  public static parse(input: ESObject, options: ParseOptions | null): XMPMeta {
    if (options == null) {
      options = new ParseOptions();
    }

    const document: XmlDocument = XMPMetaParser.parseXml(input, options);
    const rootNode: XmlNode | null = XMPMetaParser.findRootNode(document.getDocumentElement());

    // Check if the root node is a valid rdf:RDF element
    if (rootNode == null) {
      throw new XMPException('Root node is not an RDF element', XMPError.BADXMP);
    }

    // Process the RDF element and build the XMP tree
    const xmp = ParseRDF.parse(rootNode as XmlNode) as XMPMetaImpl;
    
    // Set packet header if available
    // Note: In Java version, packet header is extracted from processing instructions
    // For now, we'll skip this as it requires more complex XML parsing

    // After parsing, normalize the XMP object
    xmp.normalize(options);

    return xmp;
  }

  /**
   * Parses XML from different input sources to a <code>Node</code>
   * @param input an <code>InputStream</code>, a <code>byte[]</code> or a <code>String</code>
   * @param options the parse options
   * @return Returns the parsed XML document
   * @throws XMPException If the document can't be parsed
   */
  private static parseXml(input: ESObject, options: ParseOptions): ESObject {
    if (input == null) {
      throw new XMPException('Parameter must not be null', XMPError.BADPARAM);
    }

    try {
      if (typeof input === 'string') {
        return XMPMetaParser.parseXmlFromString(input, options);
      } else if (input instanceof Uint8Array || input instanceof Int8Array) {
        // Handle TypedArray input (Uint8Array, Int8Array)
        return XMPMetaParser.parseXmlFromTypedArray(input, options);
      } else if (input instanceof ArrayBuffer || Array.isArray(input)) {
        // Handle byte array input
        return XMPMetaParser.parseXmlFromByteBuffer(input, options);
      } else if (input.read && typeof input.read === 'function') {
        // Handle stream input
        return XMPMetaParser.parseXmlFromInputStream(input, options);
      } else {
        throw new XMPException('Unsupported input type: ' + typeof input, XMPError.BADPARAM);
      }
    } catch (e) {
      if (e instanceof XMPException) {
        throw e;
      }
      throw new XMPException('XML parsing failure', XMPError.BADXMP, e as Error);
    }
  }

  /**
   * Parses XML from a TypedArray (Uint8Array or Int8Array)
   * @param buffer a TypedArray
   * @param options the parse options
   * @return Returns the parsed XML document
   * @throws XMPException If the document can't be parsed
   */
  private static parseXmlFromTypedArray(buffer: Uint8Array | Int8Array, options: ParseOptions): ESObject {
    // Convert TypedArray to string
    let xmlString = '';
    for (let i = 0; i < buffer.length; i++) {
      xmlString += String.fromCharCode(buffer[i] & 0xFF);
    }
    return XMPMetaParser.parseXmlFromString(xmlString, options);
  }

  /**
   * Parses XML from an <code>InputStream</code>
   * @param stream an <code>InputStream</code>
   * @param options the parse options
   * @return Returns the parsed XML document
   * @throws XMPException If the document can't be parsed
   */
  private static parseXmlFromInputStream(stream: ESObject, options: ParseOptions): ESObject {
    // In ArkTS, we would need to implement this based on the available stream APIs
    // For now, we'll read the stream into a byte array and parse from there
    const buffer: number[] = [];
    let byteValue: number;
    while ((byteValue = stream.read()) !== -1) {
      buffer.push(byteValue);
    }
    return XMPMetaParser.parseXmlFromByteBuffer(buffer, options);
  }

  /**
   * Parses XML from a <code>byte[]</code>
   * @param buffer a <code>byte[]</code>
   * @param options the parse options
   * @return Returns the parsed XML document
   * @throws XMPException If the document can't be parsed
   */
  private static parseXmlFromByteBuffer(buffer: ArrayBuffer | number[], options: ParseOptions): ESObject {
    // Convert byte array to string and parse
    let xmlString = '';
    if (buffer instanceof ArrayBuffer) {
      const view = new Uint8Array(buffer);
      for (let i = 0; i < view.length; i++) {
        xmlString += String.fromCharCode(view[i]);
      }
    } else {
      for (let i = 0; i < buffer.length; i++) {
        xmlString += String.fromCharCode(buffer[i]);
      }
    }
    return XMPMetaParser.parseXmlFromString(xmlString, options);
  }

  /**
   * Parses XML from a <code>String</code>
   * @param xml a XML-String
   * @param options the parse options
   * @return Returns the parsed XML document
   * @throws XMPException If the document can't be parsed
   */
  private static parseXmlFromString(xmlInput: string, options: ParseOptions): ESObject {
    // Remove illegal control characters (x00 - x08, x0B, x0C, x0E - x1F, x7F)
    let cleanedXml = '';
    for (let i = 0; i < xmlInput.length; i++) {
      const c = xmlInput.charCodeAt(i);
      if (!((c >= 0x00 && c <= 0x08) || c === 0x0B || c === 0x0C || (c >= 0x0E && c <= 0x1F) || c === 0x7F)) {
        cleanedXml += xmlInput.charAt(i);
      }
    }
    
    // HarmonyOS 的 XmlPullParser 不支持 xml: 前缀
    // 解决方案：将 xml:xxx 属性替换为 __xml_xxx__ 格式（无冒号，避免命名空间问题）
    // 解析后在属性回调中转换回 xml:xxx
    const hasXmlPrefix = /\sxml:[a-zA-Z]+\s*=/.test(cleanedXml);
    
    if (hasXmlPrefix) {
      console.log('[XMP] Detected xml: prefix, replacing with __xml_xxx__ format');
      
      // 将所有 xml:xxx= 属性替换为 __xml_xxx__=（无冒号）
      cleanedXml = cleanedXml.replace(/(\s)xml:([a-zA-Z]+)(\s*=)/g, '$1__xml_$2__$3');
      
      console.log('[XMP] Modified XML sample: ' + cleanedXml.substring(0, 300));
    }

    // Create an InputSource for parsing
    class InputSourceImpl implements InputSource {
      getCharacterStream(): ESObject {
        return { read: (): ESObject => null };
      }
      getByteStream(): ESObject | null {
        return null;
      }
      getSystemId(): string | null {
        return null;
      }
      getPublicId(): string | null {
        return null;
      }
      setPublicId(publicId: string): void {}
      setSystemId(systemId: string): void {}
      setByteStream(byteStream: ESObject): void {}
      setCharacterStream(charStream: ESObject): void {}
    }
    const inputSource: InputSource = new InputSourceImpl();

    return XMPMetaParser.parseInputSource(inputSource, cleanedXml, options);
  }

  /**
   * Internal parsing function that uses SAX to parse the XML document.
   * @param inputSource an <code>InputSource</code>
   * @param xmlString the XML string to parse
   * @param options the parse options
   * @return Returns the parsed XML document
   * @throws XMPException If the document can't be parsed
   */
  private static parseInputSource(inputSource: InputSource, xmlString: string, options: ParseOptions): XmlDocument {
    try {
      // 使用 HarmonyOS 官方 XML 解析 API
      // 参考: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-xml
      
      // 将字符串转换为 ArrayBuffer
      // 将字符串转换为 ArrayBuffer
      const textEncoder = new util.TextEncoder();
      const encodedResult = textEncoder.encodeInto(xmlString);
      const arrBuffer = encodedResult.buffer as ArrayBuffer;

      // 创建 XmlPullParser，传入 ArrayBuffer 和编码格式
      const xmlPullParser = new xml.XmlPullParser(arrBuffer, 'UTF-8');
      
      // 解析 XML 并构建 XmlNode 树
      const rootNode: XmlNode = XMPMetaParser.parseXmlToNode(xmlPullParser);
      
      class XmlDocumentImpl implements XmlDocument {
        private root: XmlNode;
        
        constructor(root: XmlNode) {
          this.root = root;
        }
        
        getDocumentElement(): XmlNode {
          return this.root;
        }
        
        getElementsByTagNameNS(namespace: string, localName: string): XmlNode[] {
          const results: XmlNode[] = [];
          this.collectElementsByTagNameNS(this.root, namespace, localName, results);
          return results;
        }
        
        private collectElementsByTagNameNS(node: XmlNode, namespace: string, localName: string,
                                           results: XmlNode[]): void {
          if (node.getNamespaceURI() === namespace && node.getLocalName() === localName) {
            results.push(node);
          }
          
          const children = node.getChildNodes();
          for (let i = 0; i < children.length; i++) {
            this.collectElementsByTagNameNS(children[i], namespace, localName, results);
          }
        }
      }

      return new XmlDocumentImpl(rootNode);
    } catch (e) {
      throw new XMPException('XML parsing failure: ' + (e as Error).message, XMPError.BADXML, e as Error);
    }
  }
  
  /**
   * 使用 XmlPullParser 解析 XML 并转换为 XmlNode 树
   * 参考: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-xml
   * @param parser HarmonyOS XML 解析器
   * @return 返回根节点
   */
  private static parseXmlToNode(parser: xml.XmlPullParser): XmlNode {
    const nodeStack: XmlNodeImpl[] = [];
    let rootNode: XmlNodeImpl | null = null;
    
    // 命名空间前缀到 URI 的映射（用于解析属性的命名空间）
    // 需要在类定义之前声明，以便类可以访问
    const namespaceMap = new Map<string, string>();
    // 预定义的命名空间
    namespaceMap.set('xml', 'http://www.w3.org/XML/1998/namespace');
    namespaceMap.set('xmlns', 'http://www.w3.org/2000/xmlns/');
    namespaceMap.set('rdf', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#');
    
    // 定义内部类用于可变的子节点列表
    class XmlNodeImpl implements XmlNode {
      private nodeName: string;
      private localNameValue: string;
      private prefixValue: string | null;
      private namespaceURIValue: string | null;
      private attributesList: XmlNode[];
      private childrenList: XmlNode[];
      private nodeValue: string;
      private nodeTypeValue: number;
      
      constructor(
        nodeName: string,
        localName: string,
        prefix: string | null,
        namespaceURI: string | null,
        attributes: XmlNode[],
        nodeType: number,
        nodeValue: string = ''
      ) {
        this.nodeName = nodeName;
        this.localNameValue = localName;
        this.prefixValue = prefix;
        this.namespaceURIValue = namespaceURI;
        this.attributesList = attributes;
        this.childrenList = [];
        this.nodeTypeValue = nodeType;
        this.nodeValue = nodeValue;
      }
      
      getAttributes(): XmlNode[] { return this.attributesList; }
      getChildNodes(): XmlNode[] { return this.childrenList; }
      getNodeType(): number { return this.nodeTypeValue; }
      getNodeName(): string { return this.nodeName; }
      getNodeValue(): string { return this.nodeValue; }
      getLocalName(): string { return this.localNameValue; }
      // 动态查找命名空间 URI（因为属性回调在 START_TAG 之后调用）
      getNamespaceURI(): string | null {
        if (this.namespaceURIValue !== null) {
          return this.namespaceURIValue;
        }
        // 如果命名空间 URI 还没设置，从 namespaceMap 查找
        if (this.prefixValue !== null) {
          return namespaceMap.get(this.prefixValue) ?? null;
        }
        return null;
      }
      getPrefix(): string | null { return this.prefixValue; }
      hasAttributes(): boolean { return this.attributesList.length > 0; }
      hasChildNodes(): boolean { return this.childrenList.length > 0; }
      item(index: number): XmlNode | null {
        return index >= 0 && index < this.childrenList.length ? this.childrenList[index] : null;
      }
      
      addChild(child: XmlNode): void {
        this.childrenList.push(child);
      }
      
      addAttribute(attr: XmlNode): void {
        this.attributesList.push(attr);
      }
      
      // 更新命名空间 URI
      setNamespaceURI(uri: string): void {
        this.namespaceURIValue = uri;
      }
    }
    
    try {
      // 使用 parse 方法解析 XML
      // 参考: https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-xml
      // 设置 ignoreNameSpace: true 以获取完整的属性名（包括前缀）
      const parseOptions: xml.ParseOptions = {
        supportDoctype: true,
        ignoreNameSpace: true,  // 禁用命名空间处理，以获取完整的属性名
        
        // 属性回调函数 - 将属性直接添加到栈顶元素
        // 注意：属性回调在 START_TAG 事件之后被调用
        attributeValueCallbackFunction: (
          name: string,
          value: string
        ): boolean => {
          console.log('[XMP] ATTR callback: ' + name + '=' + value);
          // 将 __xml_xxx__ 格式转换回 xml:xxx 格式
          let attrName = name;
          const xmlAttrMatch = /^__xml_([a-zA-Z]+)__$/.exec(name);
          if (xmlAttrMatch) {
            attrName = 'xml:' + xmlAttrMatch[1];
          }
          
          // 收集命名空间声明
          if (attrName.startsWith('xmlns:')) {
            const nsPrefix = attrName.substring(6);
            namespaceMap.set(nsPrefix, value);
          }
          
          // 解析属性的前缀和本地名称
          let attrPrefix: string | null = null;
          let attrLocalName = attrName;
          const colonIdx = attrName.indexOf(':');
          if (colonIdx > 0) {
            attrPrefix = attrName.substring(0, colonIdx);
            attrLocalName = attrName.substring(colonIdx + 1);
          }
          
          // 根据前缀查找命名空间 URI
          let attrNamespace: string | null = null;
          if (attrName.startsWith('xmlns:') || attrName === 'xmlns') {
            attrNamespace = 'http://www.w3.org/2000/xmlns/';
          } else if (attrPrefix !== null) {
            attrNamespace = namespaceMap.get(attrPrefix) ?? null;
          }
          
          // 直接添加到栈顶元素（属性回调在 START_TAG 之后调用）
          if (nodeStack.length > 0) {
            const currentElement = nodeStack[nodeStack.length - 1];
            const attrNode = new XmlNodeImpl(
              attrName, attrLocalName, attrPrefix, attrNamespace, [], 2, value
            );
            currentElement.addAttribute(attrNode);
          }
          return true;
        },
        
        // 标签值回调函数 - 用于处理元素和文本
        tokenValueCallbackFunction: (
          eventType: xml.EventType,
          value: xml.ParseInfo
        ): boolean => {
          console.log('[XMP] TOKEN callback: eventType=' + eventType);
          switch (eventType) {
            case xml.EventType.START_TAG: {
              const name = value.getName();
              console.log('[XMP] START_TAG: ' + name);
              
              // 自己解析前缀和命名空间（因为 ignoreNameSpace: true）
              let prefix: string | null = null;
              let localName = name;
              const colonIdx = name.indexOf(':');
              if (colonIdx > 0) {
                prefix = name.substring(0, colonIdx);
                localName = name.substring(colonIdx + 1);
              }
              
              // 查找元素的命名空间 URI
              const namespace = prefix !== null ? (namespaceMap.get(prefix) ?? null) : null;
              
              // 创建元素节点（属性会在后续的属性回调中添加）
              const elementNode = new XmlNodeImpl(
                name, localName, prefix, namespace, [], 1
              );
              
              if (rootNode === null) {
                rootNode = elementNode;
              } else if (nodeStack.length > 0) {
                const parent = nodeStack[nodeStack.length - 1];
                parent.addChild(elementNode);
              }
              
              nodeStack.push(elementNode);
              break;
            }
            
            case xml.EventType.END_TAG: {
              if (nodeStack.length > 0) {
                nodeStack.pop();
              }
              break;
            }
            
            case xml.EventType.TEXT: {
              const text = value.getText();
              if (text && text.trim().length > 0 && nodeStack.length > 0) {
                const parent = nodeStack[nodeStack.length - 1];
                const textNode = new XmlNodeImpl(
                  '#text', '#text', null, null, [], 3, text.trim()
                );
                parent.addChild(textNode);
              }
              break;
            }
          }
          return true; // 继续解析
        }
      };
      
      console.log('[XMP] Calling parser.parse()...');
      console.log('[XMP] nodeStack length before parse: ' + nodeStack.length);
      console.log('[XMP] rootNode before parse: ' + (rootNode ? 'exists' : 'null'));
      try {
        parser.parse(parseOptions);
        console.log('[XMP] parser.parse() completed successfully');
        console.log('[XMP] nodeStack length after parse: ' + nodeStack.length);
        console.log('[XMP] rootNode after parse: ' + (rootNode ? rootNode.getNodeName() : 'null'));
      } catch (parseError) {
        console.log('[XMP] parser.parse() failed: ' + (parseError as Error).message);
        console.log('[XMP] Error details: ' + JSON.stringify(parseError));
        throw parseError;
      }
      
      if (rootNode === null) {
        console.log('[XMP] ERROR: No root element found!');
        throw new XMPException('No root element found in XML', XMPError.BADXML);
      }
      
      return rootNode;
    } catch (e) {
      if (e instanceof XMPException) {
        throw e;
      }
      throw new XMPException('XML parsing error: ' + (e as Error).message, XMPError.BADXML, e as Error);
    }
  }

  /**
   * Creates a new DocumentBuilderFactory. If available with the current JAXP implementation,
   * <code>SecureProcessing</code> and <code>XIncludeAware</code> are disabled.
   * @return Returns a document builder factory
   */
  private static createDocumentBuilderFactory(): ESObject {
    // In ArkTS, we would use the available XML APIs
    // This is a placeholder implementation
    return {
      setNamespaceAware: (awareness: boolean): void => {},
      setIgnoringComments: (ignore: boolean): void => {},
      setIgnoringElementContentWhitespace: (ignore: boolean): void => {},
      newDocumentBuilder: (): ESObject => ({
        parse: (inputSource: ESObject): ESObject => ({
          getDocumentElement: (): ESObject => null
        })
      })
    };
  }

  /**
   * Finds the XML node containing the XMP data.
   * The node is searched recursively, normally the XMP data is in one of the child nodes.
   * @param node the starting node
   * @return Returns the XMP root node or <code>null</code>
   * @throws XMPException Thrown if the XMP root node is not found
   */
  private static findRootNode(node: ESObject | null): XmlNode | null {
    // Check if the current node is a root node
    if (node != null) {
      const xmlNode = node as XmlNode;
      const nodeName: string = xmlNode.getNodeName();
      const namespaceURI: string | null = xmlNode.getNamespaceURI();

      // Check for xmpmeta wrapper element
      if (nodeName === 'x:xmpmeta' || nodeName === 'xmpmeta') {
        // Look for the RDF element inside the xmpmeta
        const children: XmlNode[] = xmlNode.getChildNodes();
        for (let i: number = 0; i < children.length; i++) {
          const child: XmlNode = children[i];
          const root: XmlNode | null = XMPMetaParser.findRootNode(child);
          if (root != null) {
            return root;
          }
        }
      }
      // Check for old xapmeta wrapper element
      else if (nodeName === 'rdf:xapmeta' || nodeName === 'xapmeta') {
        // Look for the RDF element inside the xapmeta
        const children: XmlNode[] = xmlNode.getChildNodes();
        for (let i: number = 0; i < children.length; i++) {
          const child: XmlNode = children[i];
          const root: XmlNode | null = XMPMetaParser.findRootNode(child);
          if (root != null) {
            return root;
          }
        }
      }
      // Check for the RDF element
      else if ((nodeName === 'rdf:RDF' || nodeName === 'RDF') &&
               namespaceURI === 'http://www.w3.org/1999/02/22-rdf-syntax-ns#') {
        return xmlNode;
      }
      // Recursively check child nodes
      else {
        const children: XmlNode[] = xmlNode.getChildNodes();
        for (let i: number = 0; children != null && i < children.length; i++) {
          const child: XmlNode = children[i];
          const root: XmlNode | null = XMPMetaParser.findRootNode(child);
          if (root != null) {
            return root;
          }
        }
      }
    }
    return null;
  }
}