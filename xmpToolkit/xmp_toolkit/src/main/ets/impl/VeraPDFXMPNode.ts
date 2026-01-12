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

import XMPNode from './XMPNode';
import PropertyOptions from '../options/PropertyOptions';
import XMPMetaFactory from '../XMPMetaFactory';

/**
 * VeraPDF XMPNode implementation.
 * 将Java的VeraPDFXMPNode类转换为ArkTS格式
 */
export default class VeraPDFXMPNode {
  /**
   * original <code>XMPNode</code> object from metadata
   */
  private originalNode: XMPNode | null;
  /**
   * namespace URI of the node
   */
  private namespaceURI: string | null;
  /**
   * prefix of the node
   */
  private prefix: string | null;
  /**
   * name of the node, contains different information depending of the node kind
   */
  private name: string | null;
  /**
   * value of the node, contains different information depending of the node kind
   */
  private value: string | null;
  /**
   * list of child nodes, lazy initialized
   */
  private children: VeraPDFXMPNode[];
  /**
   * options describing the kind of the node
   */
  private options: PropertyOptions | null;

  /**
   * Creates an <code>VeraPDFXMPNode</code> with initial values.
   *
   * @param prefix  the prefix of the node
   * @param namespaceURI the namespace URI of the node
   * @param name    the name of the node
   * @param value   the value of the node
   * @param children list of children for the node
   * @param options the options of the node
   * @param originalNode the original XMPNode
   */
  private constructor(prefix: string | null, namespaceURI: string | null, name: string | null, 
                     value: string | null, children: VeraPDFXMPNode[], options: PropertyOptions | null, 
                     originalNode: XMPNode | null) {
    this.prefix = prefix;
    this.namespaceURI = namespaceURI;
    this.name = name;
    this.value = value;
    this.children = children;
    this.options = options;
    this.originalNode = originalNode;
  }

  /**
   * 从XMPNode创建VeraPDFXMPNode实例
   * @param original XMPNode实例
   * @return VeraPDFXMPNode实例，如果original为null则返回null
   */
  public static fromXMPNode(original: XMPNode | null): VeraPDFXMPNode | null {
    if (original === null) {
      return null;
    }
    const prefix: string | null = original.getOriginalPrefix();
    const originalName: string | null = original.getName();
    if (originalName === null) {
      return null;
    }
    const prefixEndIndex: number = originalName.indexOf(":");
    const name: string = originalName.substring(prefixEndIndex + 1, originalName.length);
    const value: string | null = original.getValue();
    const options: PropertyOptions | null = original.getOptions();
    const originalChildren: XMPNode[] = original.getUnmodifiableChildren();
    const children: VeraPDFXMPNode[] = [];
    for (let i: number = 0; i < originalChildren.length; i++) {
      const child: VeraPDFXMPNode | null = VeraPDFXMPNode.fromXMPNode(originalChildren[i]);
      if (child !== null) {
        children.push(child);
      }
    }
    const prefixPart: string = originalName.substring(0, Math.max(prefixEndIndex, 0));
    const namespaceURI: string | null = XMPMetaFactory.getSchemaRegistry().getNamespaceURI(prefixPart);
    return new VeraPDFXMPNode(prefix, namespaceURI, name, value, children, options, original);
  }

  /**
   * 获取前缀
   * @return 前缀字符串
   */
  public getPrefix(): string | null {
    return this.prefix;
  }

  /**
   * 获取命名空间URI
   * @return 命名空间URI字符串
   */
  public getNamespaceURI(): string | null {
    return this.namespaceURI;
  }

  /**
   * 获取节点名称
   * @return 节点名称字符串
   */
  public getName(): string | null {
    return this.name;
  }

  /**
   * 获取节点值
   * @return 节点值字符串
   */
  public getValue(): string | null {
    return this.value;
  }

  /**
   * 获取子节点列表
   * @return 子节点数组
   */
  public getChildren(): VeraPDFXMPNode[] {
    return this.children;
  }

  /**
   * 获取节点选项
   * @return 节点选项对象
   */
  public getOptions(): PropertyOptions | null {
    return this.options;
  }
}
