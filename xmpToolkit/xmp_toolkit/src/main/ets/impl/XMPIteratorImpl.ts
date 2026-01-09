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

import XMPError from '../XMPError';
import XMPException from '../XMPException';
import XMPIterator from '../XMPIterator';
import XMPMetaFactory from '../XMPMetaFactory';
import XMPPath from './xpath/XMPPath';
import XMPPathParser from './xpath/XMPPathParser';
import IteratorOptions from '../options/IteratorOptions';
import PropertyOptions from '../options/PropertyOptions';
import XMPPropertyInfo from '../properties/XMPPropertyInfo';
import XMPMetaImpl from './XMPMetaImpl';
import XMPNode from './XMPNode';
import XMPNodeUtils from './XMPNodeUtils';
import QName from './QName';

/**
 * Empty iterator implementation (defined first to avoid forward reference)
 */
class EmptyIterator implements NodeIterator {
  hasNext(): boolean {
    return false;
  }

  next(): XMPPropertyInfo {
    throw new XMPException("No more elements", XMPError.BADPARAM);
  }
}

/**
 * XMPPropertyInfo implementation for iterator
 */
class XMPPropertyInfoImpl implements XMPPropertyInfo {
  private namespaceValue: string;
  private pathValue: string;
  private valueData: string;
  private optionsValue: number;

  constructor(namespace: string | null, path: string | null, value: string | null, options: PropertyOptions) {
    this.namespaceValue = namespace ?? "";
    this.pathValue = path ?? "";
    this.valueData = value ?? "";
    this.optionsValue = options.getOptions();
  }

  getNamespace(): string {
    return this.namespaceValue;
  }

  getPath(): string {
    return this.pathValue;
  }

  getValue(): string {
    return this.valueData;
  }

  getOptions(): number {
    return this.optionsValue;
  }
}

/**
 * Base interface for node iterators
 */
interface NodeIterator {
  hasNext(): boolean;
  next(): XMPPropertyInfo;
}

/**
 * The XMPIterator implementation.
 * Iterates the XMP Tree according to a set of options.
 * During the iteration the XMPMeta-object must not be changed.
 * Calls to skipSubtree() / skipSiblings() will affect the iteration.
 */
export default class XMPIteratorImpl implements XMPIterator {
  /** stores the iterator options */
  private options: IteratorOptions;
  /** the base namespace of the property path, will be changed during the iteration */
  private baseNS: string | null = null;
  /** flag to indicate that skipSiblings() has been called. */
  public skipSiblingsFlag: boolean = false;
  /** flag to indicate that skipSubtree() has been called. */
  public skipSubtreeFlag: boolean = false;
  /** the node iterator doing the work */
  private nodeIterator: NodeIterator | null = null;
  /** empty iterator for null cases */
  private static readonly EMPTY_ITERATOR: NodeIterator = new EmptyIterator();

  /**
   * Constructor with optional initial values.
   */
  constructor(xmp: XMPMetaImpl, schemaNS: string | null, propPath: string | null,
              options: IteratorOptions | null) {
    // make sure that options is defined at least with defaults
    this.options = options !== null ? options : new IteratorOptions();

    // the start node of the iteration depending on the schema and property filter
    let startNode: XMPNode | null = null;
    let initialPath: string | null = null;
    const baseSchema: boolean = schemaNS !== null && schemaNS.length > 0;
    const baseProperty: boolean = propPath !== null && propPath.length > 0;

    if (!baseSchema && !baseProperty) {
      // complete tree will be iterated
      startNode = xmp.getRoot();
    } else if (baseSchema && baseProperty) {
      // Schema and property node provided
      const path: XMPPath = XMPPathParser.expandXPath(schemaNS!, propPath!);

      // base path is the prop path without the property leaf
      const basePath: XMPPath = new XMPPath();
      for (let i = 0; i < path.size() - 1; i++) {
        basePath.add(path.getSegment(i));
      }

      startNode = XMPNodeUtils.findNode(xmp.getRoot(), path, false, null);
      this.baseNS = schemaNS;
      initialPath = basePath.toString();
    } else if (baseSchema && !baseProperty) {
      // Only Schema provided
      startNode = XMPNodeUtils.findSchemaNode(xmp.getRoot(), schemaNS!, false);
    } else {
      // No schema but property provided -> error
      throw new XMPException("Schema namespace URI is required", XMPError.BADSCHEMA);
    }

    // create iterator
    if (startNode !== null) {
      if (!this.options.isJustChildren()) {
        this.nodeIterator = new NodeIteratorFull(this, startNode, initialPath, 1);
      } else {
        this.nodeIterator = new NodeIteratorChildren(this, startNode, initialPath);
      }
    } else {
      // create null iterator
      this.nodeIterator = XMPIteratorImpl.EMPTY_ITERATOR;
    }
  }

  /**
   * @see XMPIterator#skipSubtree()
   */
  public skipSubtree(): void {
    this.skipSubtreeFlag = true;
  }

  /**
   * @see XMPIterator#skipSiblings()
   */
  public skipSiblings(): void {
    this.skipSubtree();
    this.skipSiblingsFlag = true;
  }

  /**
   * @see Iterator#hasNext()
   */
  public hasNext(): boolean {
    return this.nodeIterator !== null && this.nodeIterator.hasNext();
  }

  /**
   * @see Iterator#next()
   */
  public next(): XMPPropertyInfo {
    if (this.nodeIterator !== null) {
      return this.nodeIterator.next();
    }
    throw new XMPException("No more elements", XMPError.BADPARAM);
  }

  /**
   * @see Iterator#remove()
   */
  public remove(): void {
    throw new XMPException("The XMPIterator does not support remove()", XMPError.UNIMPLEMENTED);
  }

  /**
   * @return Exposes the options for inner class.
   */
  public getOptions(): IteratorOptions {
    return this.options;
  }

  /**
   * @return Exposes the baseNS for inner class.
   */
  public getBaseNS(): string | null {
    return this.baseNS;
  }

  /**
   * @param baseNS sets the baseNS from the inner class.
   */
  public setBaseNS(baseNS: string | null): void {
    this.baseNS = baseNS;
  }
}

/** iteration state */
const ITERATE_NODE = 0;
/** iteration state */
const ITERATE_CHILDREN = 1;
/** iteration state */
const ITERATE_QUALIFIER = 2;

/**
 * The XMPIterator implementation.
 * It first returns the node itself, then recursively the children and qualifier of the node.
 */
class NodeIteratorFull implements NodeIterator {
  /** reference to parent iterator */
  protected parentIterator: XMPIteratorImpl;
  /** the state of the iteration */
  private state: number = ITERATE_NODE;
  /** the currently visited node */
  private visitedNode: XMPNode;
  /** the recursively accumulated path */
  private path: string | null;
  /** the iterator that goes through the children and qualifier list */
  private childrenIterator: Iterator<XMPNode> | null = null;
  /** index of node with parent, only interesting for arrays */
  private index: number = 0;
  /** the iterator for each child */
  private subIterator: NodeIterator | null = null;
  /** the cached PropertyInfo to return */
  protected returnProperty: XMPPropertyInfo | null = null;

  /**
   * Constructor for the node iterator.
   */
  constructor(parentIterator: XMPIteratorImpl, visitedNode: XMPNode, parentPath: string | null, index: number) {
    this.parentIterator = parentIterator;
    this.visitedNode = visitedNode;
    this.state = ITERATE_NODE;
    if (visitedNode.getOptions().isSchemaNode()) {
      parentIterator.setBaseNS(visitedNode.getName());
    }

    // for all but the root node and schema nodes
    this.path = this.accumulatePath(visitedNode, parentPath, index);
  }

  /**
   * Prepares the next node to return if not already done.
   */
  public hasNext(): boolean {
    if (this.returnProperty !== null) {
      // hasNext has been called before
      return true;
    }

    // find next node
    if (this.state === ITERATE_NODE) {
      return this.reportNode();
    } else if (this.state === ITERATE_CHILDREN) {
      if (this.childrenIterator === null) {
        this.childrenIterator = this.visitedNode.iterateChildren();
      }

      let hasNextResult = this.iterateChildrenMethod(this.childrenIterator);

      if (!hasNextResult && this.visitedNode.hasQualifier() && !this.parentIterator.getOptions().isOmitQualifiers()) {
        this.state = ITERATE_QUALIFIER;
        this.childrenIterator = null;
        hasNextResult = this.hasNext();
      }
      return hasNextResult;
    } else {
      if (this.childrenIterator === null) {
        this.childrenIterator = this.visitedNode.iterateQualifier();
      }

      return this.iterateChildrenMethod(this.childrenIterator);
    }
  }

  /**
   * Sets the returnProperty as next item or recurses into hasNext().
   */
  protected reportNode(): boolean {
    this.state = ITERATE_CHILDREN;
    if (this.visitedNode.getParent() !== null &&
        (!this.parentIterator.getOptions().isJustLeafnodes() || !this.visitedNode.hasChildren())) {
      this.returnProperty = this.createPropertyInfo(this.visitedNode, this.parentIterator.getBaseNS(), this.path);
      return true;
    } else {
      return this.hasNext();
    }
  }

  /**
   * Handles the iteration of the children or qualifier
   */
  private iterateChildrenMethod(iterator: Iterator<XMPNode>): boolean {
    if (this.parentIterator.skipSiblingsFlag) {
      this.parentIterator.skipSiblingsFlag = false;
      this.subIterator = null;
    }

    // create sub iterator for every child,
    // if it's the first child visited or the former child is finished
    if ((this.subIterator === null || !this.subIterator.hasNext())) {
      const result = iterator.next();
      if (!result.done) {
        const child: XMPNode = result.value;
        this.index++;
        this.subIterator = new NodeIteratorFull(this.parentIterator, child, this.path, this.index);
      }
    }

    if (this.subIterator !== null && this.subIterator.hasNext()) {
      this.returnProperty = this.subIterator.next();
      return true;
    } else {
      return false;
    }
  }

  /**
   * Calls hasNext() and returns the prepared node.
   */
  public next(): XMPPropertyInfo {
    if (this.hasNext()) {
      const result = this.returnProperty!;
      this.returnProperty = null;
      return result;
    } else {
      throw new XMPException("There are no more nodes to return", XMPError.BADPARAM);
    }
  }

  /**
   * @param currNode the node that will be added to the path.
   * @param parentPath the path up to this node.
   * @param currentIndex the current array index if an array is traversed
   * @return Returns the updated path.
   */
  protected accumulatePath(currNode: XMPNode, parentPath: string | null, currentIndex: number): string | null {
    let separator: string;
    let segmentName: string;
    if (currNode.getParent() === null || currNode.getOptions().isSchemaNode()) {
      return null;
    } else if (currNode.getParent()!.getOptions().isArray()) {
      separator = "";
      segmentName = "[" + String(currentIndex) + "]";
    } else {
      separator = "/";
      segmentName = currNode.getName() || "";
    }

    if (parentPath === null || parentPath.length === 0) {
      return segmentName;
    } else if (this.parentIterator.getOptions().isJustLeafname()) {
      return !segmentName.startsWith("?") ?
        segmentName :
        segmentName.substring(1); // qualifier
    } else {
      return parentPath + separator + segmentName;
    }
  }

  /**
   * Creates a property info object from an XMPNode.
   */
  protected createPropertyInfo(node: XMPNode, baseNS: string | null, path: string | null): XMPPropertyInfo {
    const value: string | null = node.getOptions().isSchemaNode() ? null : node.getValue();

    let namespace: string | null;
    if (!node.getOptions().isSchemaNode()) {
      // determine namespace of leaf node
      const qname = new QName(node.getName() || "");
      namespace = XMPMetaFactory.getSchemaRegistry().getNamespaceURI(qname.getPrefix() + ":");
    } else {
      namespace = baseNS;
    }

    return new XMPPropertyInfoImpl(namespace, path, value, node.getOptions());
  }
}

/**
 * This iterator is derived from the default NodeIterator,
 * and is only used for the option JUST_CHILDREN.
 */
class NodeIteratorChildren implements NodeIterator {
  /** reference to parent iterator */
  private parentIterator: XMPIteratorImpl;
  /** */
  private parentPath: string | null;
  /** */
  private childrenIterator: Iterator<XMPNode>;
  /** */
  private index: number = 0;
  /** the cached PropertyInfo to return */
  private returnProperty: XMPPropertyInfo | null = null;

  /**
   * Constructor
   */
  constructor(parentIterator: XMPIteratorImpl, parentNode: XMPNode, parentPath: string | null) {
    this.parentIterator = parentIterator;
    if (parentNode.getOptions().isSchemaNode()) {
      parentIterator.setBaseNS(parentNode.getName());
    }
    this.parentPath = this.accumulatePath(parentNode, parentPath, 1);
    this.childrenIterator = parentNode.iterateChildren();
  }

  /**
   * Prepares the next node to return if not already done.
   */
  public hasNext(): boolean {
    if (this.returnProperty !== null) {
      // hasNext has been called before
      return true;
    } else if (this.parentIterator.skipSiblingsFlag) {
      return false;
    } else {
      const result = this.childrenIterator.next();
      if (!result.done) {
        const child: XMPNode = result.value;
        this.index++;

        let path: string | null = null;
        if (child.getOptions().isSchemaNode()) {
          this.parentIterator.setBaseNS(child.getName());
        } else if (child.getParent() !== null) {
          // for all but the root node and schema nodes
          path = this.accumulatePath(child, this.parentPath, this.index);
        }

        // report next property, skip not-leaf nodes in case options is set
        if (!this.parentIterator.getOptions().isJustLeafnodes() || !child.hasChildren()) {
          this.returnProperty = this.createPropertyInfo(child, this.parentIterator.getBaseNS(), path);
          return true;
        } else {
          return this.hasNext();
        }
      } else {
        return false;
      }
    }
  }

  /**
   * Returns the next property info
   */
  public next(): XMPPropertyInfo {
    if (this.hasNext()) {
      const result = this.returnProperty!;
      this.returnProperty = null;
      return result;
    } else {
      throw new XMPException("There are no more nodes to return", XMPError.BADPARAM);
    }
  }

  /**
   * Accumulates the path
   */
  private accumulatePath(currNode: XMPNode, parentPath: string | null, currentIndex: number): string | null {
    let separator: string;
    let segmentName: string;
    if (currNode.getParent() === null || currNode.getOptions().isSchemaNode()) {
      return null;
    } else if (currNode.getParent()!.getOptions().isArray()) {
      separator = "";
      segmentName = "[" + String(currentIndex) + "]";
    } else {
      separator = "/";
      segmentName = currNode.getName() || "";
    }

    if (parentPath === null || parentPath.length === 0) {
      return segmentName;
    } else if (this.parentIterator.getOptions().isJustLeafname()) {
      return !segmentName.startsWith("?") ?
        segmentName :
        segmentName.substring(1); // qualifier
    } else {
      return parentPath + separator + segmentName;
    }
  }

  /**
   * Creates a property info object from an XMPNode.
   */
  private createPropertyInfo(node: XMPNode, baseNS: string | null, path: string | null): XMPPropertyInfo {
    const value: string | null = node.getOptions().isSchemaNode() ? null : node.getValue();

    let namespace: string | null;
    if (!node.getOptions().isSchemaNode()) {
      const qname = new QName(node.getName() || "");
      namespace = XMPMetaFactory.getSchemaRegistry().getNamespaceURI(qname.getPrefix() + ":");
    } else {
      namespace = baseNS;
    }

    return new XMPPropertyInfoImpl(namespace, path, value, node.getOptions());
  }
}

