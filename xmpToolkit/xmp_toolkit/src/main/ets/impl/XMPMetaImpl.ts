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
import XMPConst from '../XMPConst';
import XMPNode from './XMPNode';
import XMPPath from './xpath/XMPPath';
import XMPPathParser from './xpath/XMPPathParser';
import IteratorOptions from '../options/IteratorOptions';
import ParseOptions from '../options/ParseOptions';
import PropertyOptions from '../options/PropertyOptions';
import XMPProperty from '../properties/XMPProperty';
import XMPError from '../XMPError';
import XMPException from '../XMPException';
import  XMPNodeUtils  from './XMPNodeUtils';
import XMPPathFactory from '../XMPPathFactory';
import XMPUtils from '../XMPUtils';
import XMPDateTime from '../XMPDateTime';
import { XMPNormalizer } from './XMPNormalizer';
import ParameterAsserts from './ParameterAsserts';
import Utils from './Utils';
import XMPIterator from '../XMPIterator';
import XMPIteratorImpl from './XMPIteratorImpl';
import XMPPropertyImpl from './XMPPropertyImpl';

/**
 * Implementation for {@link XMPMeta}.
 * 
 * @since 17.02.2006
 */
export default class XMPMetaImpl implements XMPMeta {
  /** Property values are Strings by default */
  private static readonly VALUE_STRING = 0;
  /** */
  private static readonly VALUE_BOOLEAN = 1;
  /** */
  private static readonly VALUE_INTEGER = 2;
  /** */
  private static readonly VALUE_LONG = 3;
  /** */
  private static readonly VALUE_DOUBLE = 4;
  /** */
  private static readonly VALUE_DATE = 5;
  /** */
  private static readonly VALUE_CALENDAR = 6;
  /** */
  private static readonly VALUE_BASE64 = 7;

  /** root of the metadata tree */
  private tree: XMPNode;
  /** the xpacket processing instructions content */ 
  private packetHeader: string | null = null;

  /**
   * Constructor for an empty metadata object.
   */
  constructor();
  /**
   * Constructor for a cloned metadata tree.
   * 
   * @param tree an prefilled metadata tree which fulfills all
   *            <code>XMPNode</code> contracts.
   */
  constructor(tree: XMPNode);
  constructor(tree?: XMPNode) {
    if (tree !== undefined) {
      this.tree = tree;
    } else {
      // create root node
      this.tree = new XMPNode(null, null, null, null);
    }
  }

  /**
   * @see XMPMeta#appendArrayItem(String, String, PropertyOptions, String, PropertyOptions)
   */
  public appendArrayItem(schemaNS: string, arrayName: string, arrayOptions: PropertyOptions | null,
                         itemValue: string, itemOptions: PropertyOptions | null): void;
  /**
   * @see XMPMeta#appendArrayItem(String, String, String)
   */
  public appendArrayItem(schemaNS: string, arrayName: string, itemValue: string): void;
  public appendArrayItem(schemaNS: string, arrayName: string,
                         arrayOptionsOrItemValue: PropertyOptions | null | string,
                         itemValueOrItemOptions?: string | PropertyOptions | null, 
                         itemOptions?: PropertyOptions | null): void {
    // 判断是3参数还是5参数调用
    let arrayOptions: PropertyOptions | null;
    let finalItemValue: string;
    let finalItemOptions: PropertyOptions | null;
    
    if (typeof arrayOptionsOrItemValue === 'string') {
      // 3参数调用: appendArrayItem(schemaNS, arrayName, itemValue)
      finalItemValue = arrayOptionsOrItemValue;
      arrayOptions = null;
      finalItemOptions = null;
    } else {
      // 5参数调用: appendArrayItem(schemaNS, arrayName, arrayOptions, itemValue, itemOptions)
      arrayOptions = arrayOptionsOrItemValue;
      finalItemValue = itemValueOrItemOptions as string;
      finalItemOptions = itemOptions || null;
    }

    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertArrayName(arrayName);

    if (arrayOptions === null) {
      arrayOptions = new PropertyOptions();
    }
    if (!arrayOptions.isOnlyArrayOptions()) {
      throw new XMPException("Only array form flags allowed for arrayOptions",
                            XMPError.BADOPTIONS);
    }

    // Check if array options are set correctly.
    arrayOptions = XMPNodeUtils.verifySetOptions(arrayOptions, null);

    // Locate or create the array. If it already exists, make sure the array
    // form from the options parameter is compatible with the current state.
    const arrayPath = XMPPathParser.expandXPath(schemaNS, arrayName);

    // Just lookup, don't try to create.
    let arrayNode = XMPNodeUtils.findNode(this.tree, arrayPath, false, null);

    if (arrayNode) {
      // The array exists, make sure the form is compatible.
      if (!arrayNode.getOptions().isArray()) {
        throw new XMPException("The named property is not an array", XMPError.BADXPATH);
      }
    } else {
      // The array does not exist, try to create it.
      if (arrayOptions.isArray()) {
        arrayNode = XMPNodeUtils.findNode(this.tree, arrayPath, true, arrayOptions);
        if (!arrayNode) {
          throw new XMPException("Failure creating array node", XMPError.BADXPATH);
        }
      } else {
        // array options missing
        throw new XMPException("Explicit arrayOptions required to create new array",
                              XMPError.BADOPTIONS);
      }
    }

    this.doSetArrayItem(arrayNode, XMPConst.ARRAY_LAST_ITEM, finalItemValue, finalItemOptions || new PropertyOptions(), true);
  }

  /**
   * @throws XMPException
   * @see XMPMeta#countArrayItems(String, String)
   */
  public countArrayItems(schemaNS: string, arrayName: string): number {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertArrayName(arrayName);

    const arrayPath = XMPPathParser.expandXPath(schemaNS, arrayName);
    const arrayNode = XMPNodeUtils.findNode(this.tree, arrayPath, false, null);

    if (!arrayNode) {
      return 0;
    }

    if (arrayNode.getOptions().isArray()) {
      return arrayNode.getChildrenLength();
    } else {
      throw new XMPException("The named property is not an array", XMPError.BADXPATH);
    }
  }

  /**
   * @see XMPMeta#deleteArrayItem(String, String, int)
   */
  public deleteArrayItem(schemaNS: string, arrayName: string, itemIndex: number): void {
    try {
      ParameterAsserts.assertSchemaNS(schemaNS);
      ParameterAsserts.assertArrayName(arrayName);

      const itemPath = XMPPathFactory.composeArrayItemPath(arrayName, itemIndex);
      this.deleteProperty(schemaNS, itemPath);
    } catch (e) {
      console.error('Delete array item error', e);
    }
  }

  /**
   * @see XMPMeta#deleteProperty(String, String)
   */
  public deleteProperty(schemaNS: string, propName: string): void {
    try {
      ParameterAsserts.assertSchemaNS(schemaNS);
      ParameterAsserts.assertPropName(propName);

      const expPath = XMPPathParser.expandXPath(schemaNS, propName);

      const propNode = XMPNodeUtils.findNode(this.tree, expPath, false, null);
      if (propNode) {
        XMPNodeUtils.deleteNode(propNode);
      }
    } catch (e) {
      console.error('Delete property error', e);
    }
  }

  /**
   * @see XMPMeta#deleteQualifier(String, String, String, String)
   */
  public deleteQualifier(schemaNS: string, propName: string, qualNS: string, qualName: string): void {
    try {
      // Note: qualNS and qualName are checked inside composeQualfierPath
      ParameterAsserts.assertSchemaNS(schemaNS);
      ParameterAsserts.assertPropName(propName);

      const qualPath = propName + XMPPathFactory.composeQualifierPath(qualNS, qualName);
      this.deleteProperty(schemaNS, qualPath);
    } catch (e) {
      console.error('Delete qualifier error', e);
    }
  }

  /**
   * @see XMPMeta#deleteStructField(String, String, String, String)
   */
  public deleteStructField(schemaNS: string, structName: string, fieldNS: string, fieldName: string): void {
    try {
      // fieldNS and fieldName are checked inside composeStructFieldPath
      ParameterAsserts.assertSchemaNS(schemaNS);
      ParameterAsserts.assertStructName(structName);

      const fieldPath = structName + XMPPathFactory.composeStructFieldPath(fieldNS, fieldName);
      this.deleteProperty(schemaNS, fieldPath);
    } catch (e) {
      console.error('Delete struct field error', e);
    }
  }

  /**
   * @see XMPMeta#doesPropertyExist(String, String)
   */
  public doesPropertyExist(schemaNS: string, propName: string): boolean {
    try {
      ParameterAsserts.assertSchemaNS(schemaNS);
      ParameterAsserts.assertPropName(propName);

      const expPath = XMPPathParser.expandXPath(schemaNS, propName);
      const propNode = XMPNodeUtils.findNode(this.tree, expPath, false, null);
      return propNode !== null;
    } catch (e) {
      return false;
    }
  }

  /**
   * @see XMPMeta#doesArrayItemExist(String, String, int)
   */
  public doesArrayItemExist(schemaNS: string, arrayName: string, itemIndex: number): boolean {
    try {
      ParameterAsserts.assertSchemaNS(schemaNS);
      ParameterAsserts.assertArrayName(arrayName);

      const path = XMPPathFactory.composeArrayItemPath(arrayName, itemIndex);
      return this.doesPropertyExist(schemaNS, path);
    } catch (e) {
      return false;
    }
  }

  /**
   * @see XMPMeta#doesStructFieldExist(String, String, String, String)
   */
  public doesStructFieldExist(schemaNS: string, structName: string, fieldNS: string, fieldName: string): boolean {
    try {
      // fieldNS and fieldName are checked inside composeStructFieldPath()
      ParameterAsserts.assertSchemaNS(schemaNS);
      ParameterAsserts.assertStructName(structName);

      const path = XMPPathFactory.composeStructFieldPath(fieldNS, fieldName);
      return this.doesPropertyExist(schemaNS, structName + path);
    } catch (e) {
      return false;
    }
  }

  /**
   * @see XMPMeta#doesQualifierExist(String, String, String, String)
   */
  public doesQualifierExist(schemaNS: string, propName: string, qualNS: string, qualName: string): boolean {
    try {
      // qualNS and qualName are checked inside composeQualifierPath()
      ParameterAsserts.assertSchemaNS(schemaNS);
      ParameterAsserts.assertPropName(propName);

      const path = XMPPathFactory.composeQualifierPath(qualNS, qualName);
      return this.doesPropertyExist(schemaNS, propName + path);
    } catch (e) {
      return false;
    }
  }

  /**
   * @see XMPMeta#getArrayItem(String, String, int)
   */
  public getArrayItem(schemaNS: string, arrayName: string, itemIndex: number): XMPProperty | null {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertArrayName(arrayName);

    const itemPath = XMPPathFactory.composeArrayItemPath(arrayName, itemIndex);
    return this.getProperty(schemaNS, itemPath);
  }

  /**
   * @throws XMPException
   * @see XMPMeta#getLocalizedText(String, String, String, String)
   */
  public getLocalizedText(schemaNS: string, altTextName: string, genericLang: string,
                          specificLang: string): XMPProperty | null {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertArrayName(altTextName);
    ParameterAsserts.assertSpecificLang(specificLang);

    const normalizedGenericLang: string | null = genericLang ? Utils.normalizeLangValue(genericLang) : null;
    const normalizedSpecificLang: string | null = Utils.normalizeLangValue(specificLang);

    const arrayPath = XMPPathParser.expandXPath(schemaNS, altTextName);
    const arrayNode = XMPNodeUtils.findNode(this.tree, arrayPath, false, null);
    if (!arrayNode) {
      return null;
    }

    const result = XMPNodeUtils.chooseLocalizedText(arrayNode, normalizedGenericLang, normalizedSpecificLang || "");
    const match = (result[0] as number);
    const itemNode = result[1] as XMPNode;

    if (match !== XMPNodeUtils.CLT_NO_VALUES) {
      const nodeValue: string | null = itemNode.getValue();
      const qualifierNode: XMPNode | null = itemNode.getQualifier(1);
      const langValue: string | null = qualifierNode ? qualifierNode.getValue() : null;
      return new XMPPropertyImpl(
        nodeValue || "",
        itemNode.getOptions(),
        langValue || ""
      );
    } else {
      return null;
    }
  }

  /**
   * @see XMPMeta#setLocalizedText(String, String, String, String, String, PropertyOptions)
   */
  public setLocalizedText(schemaNS: string, altTextName: string, genericLang: string, specificLang: string, 
                         itemValue: string, options?: PropertyOptions | null): void {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertArrayName(altTextName);
    ParameterAsserts.assertSpecificLang(specificLang);

    const normalizedGenericLang: string | null = genericLang ? Utils.normalizeLangValue(genericLang) : null;
    const normalizedSpecificLang: string | null = Utils.normalizeLangValue(specificLang);
    const finalGenericLang: string | null = normalizedGenericLang;
    const finalSpecificLang: string = normalizedSpecificLang || "";

    const arrayPath = XMPPathParser.expandXPath(schemaNS, altTextName);

    // Find the array node and set the options if it was just created.
    const arrayNode = XMPNodeUtils.findNode(this.tree, arrayPath, true, 
      new PropertyOptions(PropertyOptions.ARRAY | PropertyOptions.ARRAY_ORDERED | 
                          PropertyOptions.ARRAY_ALTERNATE | PropertyOptions.ARRAY_ALT_TEXT));

    if (!arrayNode) {
      throw new XMPException("Failed to find or create array node", XMPError.BADXPATH);
    } else if (!arrayNode.getOptions().isArrayAltText()) {
      if (!arrayNode.hasChildren() && arrayNode.getOptions().isArrayAlternate()) {
        arrayNode.getOptions().setArrayAltText(true);
      } else {
        throw new XMPException("Specified property is no alt-text array", XMPError.BADXPATH);
      }
    }

    // Make sure the x-default item, if any, is first.
    let haveXDefault = false;
    let xdItem: XMPNode | null = null;

    const childrenIterator: Iterator<XMPNode> = arrayNode.iterateChildren();
    let next: IteratorResult<XMPNode> = childrenIterator.next();
    while (!next.done) {
      const currItem: XMPNode = next.value;
      const qualifier1: XMPNode | undefined = currItem.getQualifier(1);
      if (!currItem.hasQualifier() || !qualifier1 ||
          XMPConst.XML_LANG !== qualifier1.getName()) {
        throw new XMPException("Language qualifier must be first", XMPError.BADXPATH);
      }
      const qualifierValue: string | null = qualifier1.getValue();
      if (XMPConst.X_DEFAULT === qualifierValue) {
        xdItem = currItem;
        haveXDefault = true;
        break;
      }
      next = childrenIterator.next();
    }

    // Moves x-default to the beginning of the array
    if (xdItem && arrayNode.getChildrenLength() > 1) {
      arrayNode.removeChild(xdItem);
      arrayNode.addChild(1, xdItem);
    }

    // Find the appropriate item.
    const result = XMPNodeUtils.chooseLocalizedText(arrayNode, finalGenericLang, finalSpecificLang);
    const match = (result[0] as number);
    let itemNode = result[1] as XMPNode;

    const specificXDefault = XMPConst.X_DEFAULT === finalSpecificLang;

    switch (match) {
      case XMPNodeUtils.CLT_NO_VALUES:
        // Create the array items for the specificLang and x-default, with x-default first.
        XMPNodeUtils.appendLangItem(arrayNode, XMPConst.X_DEFAULT, itemValue);
        haveXDefault = true;
        if (!specificXDefault) {
          XMPNodeUtils.appendLangItem(arrayNode, finalSpecificLang, itemValue);
        }
        break;

      case XMPNodeUtils.CLT_SPECIFIC_MATCH:
        if (!specificXDefault) {
          // Update the specific item, update x-default if it matches the old value.
          if (haveXDefault && xdItem && xdItem !== itemNode && 
              xdItem.getValue() === itemNode.getValue()) {
            xdItem.setValue(itemValue);
          }
          // ! Do this after the x-default check!
          itemNode.setValue(itemValue);
        } else {
          // Update all items whose values match the old x-default value.
          if (haveXDefault && xdItem === itemNode) {
            const childrenIterator2: Iterator<XMPNode> = arrayNode.iterateChildren();
            let next2: IteratorResult<XMPNode> = childrenIterator2.next();
            while (!next2.done) {
              const currItem: XMPNode = next2.value;
              if (currItem === xdItem || 
                  currItem.getValue() !== (xdItem ? xdItem.getValue() : null)) {
                next2 = childrenIterator2.next();
                continue;
              }
              currItem.setValue(itemValue);
              next2 = childrenIterator2.next();
            }
            // And finally do the x-default item.
            if (xdItem) {
              xdItem.setValue(itemValue);
            }
          }
        }
        break;

      case XMPNodeUtils.CLT_SINGLE_GENERIC:
        // Update the generic item, update x-default if it matches the old value.
        if (haveXDefault && xdItem && xdItem !== itemNode && 
            xdItem.getValue() === itemNode.getValue()) {
          xdItem.setValue(itemValue);
        }
        itemNode.setValue(itemValue); // ! Do this after the x-default check!
        break;

      case XMPNodeUtils.CLT_MULTIPLE_GENERIC:
        // Create the specific language, ignore x-default.
        XMPNodeUtils.appendLangItem(arrayNode, finalSpecificLang, itemValue);
        if (specificXDefault) {
          haveXDefault = true;
        }
        break;

      case XMPNodeUtils.CLT_XDEFAULT:
        // Create the specific language, update x-default if it was the only item.
        if (xdItem && arrayNode.getChildrenLength() === 1) {
          xdItem.setValue(itemValue);
        }
        XMPNodeUtils.appendLangItem(arrayNode, finalSpecificLang, itemValue);
        break;

      case XMPNodeUtils.CLT_FIRST_ITEM:
        // Create the specific language, don't add an x-default item.
        XMPNodeUtils.appendLangItem(arrayNode, finalSpecificLang, itemValue);
        if (specificXDefault) {
          haveXDefault = true;
        }
        break;

      default:
        // does not happen under normal circumstances
        throw new XMPException("Unexpected result from ChooseLocalizedText",
                              XMPError.INTERNALFAILURE);
    }

    // Add an x-default at the front if needed.
    if (!haveXDefault && arrayNode.getChildrenLength() === 1) {
      XMPNodeUtils.appendLangItem(arrayNode, XMPConst.X_DEFAULT, itemValue);
    }
  }


  /**
   * @throws XMPException
   * @see XMPMeta#getProperty(String, String)
   */
  public getProperty(schemaNS: string, propName: string): XMPProperty | null {
    return this.getPropertyInternal(schemaNS, propName, XMPMetaImpl.VALUE_STRING);
  }

  /**
   * Returns a property, but the result value can be requested. It can be one
   * of {@link XMPMetaImpl#VALUE_STRING}, {@link XMPMetaImpl#VALUE_BOOLEAN},
   * {@link XMPMetaImpl#VALUE_INTEGER}, {@link XMPMetaImpl#VALUE_LONG},
   * {@link XMPMetaImpl#VALUE_DOUBLE}, {@link XMPMetaImpl#VALUE_DATE},
   * {@link XMPMetaImpl#VALUE_CALENDAR}, {@link XMPMetaImpl#VALUE_BASE64}.
   * 
   * @see XMPMeta#getProperty(String, String)
   * @param schemaNS a schema namespace
   * @param propName a property name or path
   * @param valueType the type of the value, see VALUE_...
   * @return Returns an <code>XMPProperty</code>
   * @throws XMPException Collects any exception that occurs.
   */
  protected getPropertyInternal(schemaNS: string, propName: string, valueType: number): XMPProperty | null {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertPropName(propName);

    const expPath = XMPPathParser.expandXPath(schemaNS, propName);
    const propNode = XMPNodeUtils.findNode(this.tree, expPath, false, null);

    if (propNode) {
      if (valueType !== XMPMetaImpl.VALUE_STRING && propNode.getOptions().isCompositeProperty()) {
        throw new XMPException("Property must be simple when a value type is requested",
                              XMPError.BADXPATH);
      }

      const value: ESObject = this.evaluateNodeValue(valueType, propNode);

      return new XMPPropertyImpl(
        value != null ? value.toString() : "",
        propNode.getOptions(),
        ""
      );
    } else {
      return null;
    }
  }

  /**
   * Returns a property, but the result value can be requested.
   * 
   * @see XMPMeta#getProperty(String, String)
   * @param schemaNS a schema namespace
   * @param propName a property name or path
   * @param valueType the type of the value, see VALUE_...
   * @return Returns the node value as an object according to the <code>valueType</code>.
   * @throws XMPException Collects any exception that occurs.
   */
  protected getPropertyObject(schemaNS: string, propName: string, valueType: number): ESObject {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertPropName(propName);

    const expPath = XMPPathParser.expandXPath(schemaNS, propName);
    const propNode = XMPNodeUtils.findNode(this.tree, expPath, false, null);

    if (propNode) {
      if (valueType !== XMPMetaImpl.VALUE_STRING && propNode.getOptions().isCompositeProperty()) {
        throw new XMPException("Property must be simple when a value type is requested",
                              XMPError.BADXPATH);
      }

      return this.evaluateNodeValue(valueType, propNode);
    } else {
      return null;
    }
  }

  /**
   * @see XMPMeta#getPropertyBoolean(String, String)
   */
  public getPropertyBoolean(schemaNS: string, propName: string): boolean {
    return this.getPropertyObject(schemaNS, propName, XMPMetaImpl.VALUE_BOOLEAN) as boolean;
  }

  /**
   * @throws XMPException
   * @see XMPMeta#setPropertyBoolean(String, String, boolean, PropertyOptions)
   */
  public setPropertyBoolean(schemaNS: string, propName: string, propValue: boolean, options?: PropertyOptions): void {
    this.setProperty(schemaNS, propName, propValue ? 'true' : 'false', options || null);
  }

  /**
   * @see XMPMeta#getPropertyInteger(String, String)
   */
  public getPropertyInteger(schemaNS: string, propName: string): number {
    return this.getPropertyObject(schemaNS, propName, XMPMetaImpl.VALUE_INTEGER) as number;
  }

  /**
   * @see XMPMeta#setPropertyInteger(String, String, number, PropertyOptions)
   */
  public setPropertyInteger(schemaNS: string, propName: string, propValue: number, options?: PropertyOptions): void {
    this.setProperty(schemaNS, propName, propValue.toString(), options || null);
  }

  /**
   * @see XMPMeta#getPropertyLong(String, String)
   */
  public getPropertyLong(schemaNS: string, propName: string): number {
    return this.getPropertyObject(schemaNS, propName, XMPMetaImpl.VALUE_LONG) as number;
  }

  /**
   * @see XMPMeta#setPropertyLong(String, String, number, PropertyOptions)
   */
  public setPropertyLong(schemaNS: string, propName: string, propValue: number, options?: PropertyOptions): void {
    this.setProperty(schemaNS, propName, propValue.toString(), options || null);
  }

  /**
   * @see XMPMeta#getPropertyDouble(String, String)
   */
  public getPropertyDouble(schemaNS: string, propName: string): number {
    return this.getPropertyObject(schemaNS, propName, XMPMetaImpl.VALUE_DOUBLE) as number;
  }

  /**
   * @see XMPMeta#setPropertyDouble(String, String, number, PropertyOptions)
   */
  public setPropertyDouble(schemaNS: string, propName: string, propValue: number, options?: PropertyOptions): void {
    this.setProperty(schemaNS, propName, propValue.toString(), options || null);
  }

  /**
   * @see XMPMeta#getPropertyDate(String, String)
   */
  public getPropertyDate(schemaNS: string, propName: string): XMPDateTime {
    return this.getPropertyObject(schemaNS, propName, XMPMetaImpl.VALUE_DATE) as XMPDateTime;
  }

  /**
   * @see XMPMeta#setPropertyDate(String, String, XMPDateTime, PropertyOptions)
   */
  public setPropertyDate(schemaNS: string, propName: string, propValue: XMPDateTime, options?: PropertyOptions): void {
    this.setProperty(schemaNS, propName, propValue, options || null);
  }

  /**
   * @see XMPMeta#getPropertyCalendar(String, String)
   */
  public getPropertyCalendar(schemaNS: string, propName: string): ESObject {
    return this.getPropertyObject(schemaNS, propName, XMPMetaImpl.VALUE_CALENDAR);
  }

  /**
   * @see XMPMeta#setPropertyCalendar(String, String, any, PropertyOptions)
   */
  public setPropertyCalendar(schemaNS: string, propName: string, propValue: ESObject,
                             options?: PropertyOptions): void {
    this.setProperty(schemaNS, propName, propValue, options || null);
  }

  /**
   * @see XMPMeta#getPropertyBase64(String, String)
   */
  public getPropertyBase64(schemaNS: string, propName: string): Uint8Array | null {
    const result: ESObject = this.getPropertyObject(schemaNS, propName, XMPMetaImpl.VALUE_BASE64);
    if (result === null) {
      return null;
    }
    const bytes = result as number[];
    return new Uint8Array(bytes);
  }

  /**
   * @see XMPMeta#getPropertyString(String, String)
   */
  public getPropertyString(schemaNS: string, propName: string): string {
    return this.getPropertyObject(schemaNS, propName, XMPMetaImpl.VALUE_STRING) as string;
  }

  /**
   * @see XMPMeta#setPropertyBase64(String, String, Uint8Array, PropertyOptions)
   */
  public setPropertyBase64(schemaNS: string, propName: string, propValue: Uint8Array,
                           options?: PropertyOptions): void {
    const bytes: number[] = Array.from(propValue);
    this.setProperty(schemaNS, propName, bytes, options || null);
  }

  /**
   * @throws XMPException
   * @see XMPMeta#getQualifier(String, String, String, String)
   */
  public getQualifier(schemaNS: string, propName: string, qualNS: string,
                      qualName: string): XMPProperty | null {
    // qualNS and qualName are checked inside composeQualfierPath
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertPropName(propName);

    const qualPath = propName + XMPPathFactory.composeQualifierPath(qualNS, qualName);
    return this.getProperty(schemaNS, qualPath);
  }

  /**
   * @see XMPMeta#getStructField(String, String, String, String)
   */
  public getStructField(schemaNS: string, structName: string, fieldNS: string,
                        fieldName: string): XMPProperty | null {
    // fieldNS and fieldName are checked inside composeStructFieldPath
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertStructName(structName);

    const fieldPath = structName + XMPPathFactory.composeStructFieldPath(fieldNS, fieldName);
    return this.getProperty(schemaNS, fieldPath);
  }

  /**
   * @throws XMPException
   * @see XMPMeta#iterator()
   */
  public iterator(): XMPIterator;
  /**
   * @see XMPMeta#iterator(IteratorOptions)
   */
  public iterator(options: IteratorOptions): XMPIterator;
  /**
   * @see XMPMeta#iterator(String, String, IteratorOptions)
   */
  public iterator(schemaNS: string, propName: string, options: IteratorOptions): XMPIterator;
  public iterator(schemaNSOrOptions?: string | IteratorOptions, propNameOrOptions?: string | IteratorOptions,
                  options?: IteratorOptions): XMPIterator {
    // 判断是哪种调用方式
    // 1. 当调用 iterator() 无参数时：
    //    - finalSchemaNS = null, finalPropName = null, finalOptions = null
    //
    // 2. 当调用 iterator(options) 1个参数时：
    //    - finalSchemaNS = null, finalPropName = null, finalOptions = options
    //
    // 3. 当调用 iterator(schemaNS, propName, options) 3个参数时：
    //    - finalSchemaNS = schemaNS, finalPropName = propName, finalOptions = options
    let finalSchemaNS: string | null = null;
    let finalPropName: string | null = null;
    let finalOptions: IteratorOptions | null = null;

    if (schemaNSOrOptions === undefined) {
      // 0参数调用: iterator()
      finalOptions = null;
    } else if (typeof schemaNSOrOptions === 'string') {
      // 3参数调用: iterator(schemaNS, propName, options)
      finalSchemaNS = schemaNSOrOptions;
      finalPropName = propNameOrOptions as string;
      finalOptions = options || null;
    } else {
      // 1参数调用: iterator(options)
      finalOptions = schemaNSOrOptions as IteratorOptions;
    }

    return this.iteratorInternal(finalSchemaNS, finalPropName, finalOptions);
  }

  /**
   * @see XMPMeta#iterator(String, String, IteratorOptions)
   */
  private iteratorInternal(schemaNS: string | null, propName: string | null,
                           options: IteratorOptions | null): XMPIterator {
    return new XMPIteratorImpl(this, schemaNS, propName, options);
  }

  /**
   * @throws XMPException
   * @see XMPMeta#setArrayItem(String, String, number, String, PropertyOptions)
   */
  public setArrayItem(schemaNS: string, arrayName: string, itemIndex: number,
                      itemValue: string, options?: PropertyOptions): void {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertArrayName(arrayName);

    // Just lookup, don't try to create.
    const arrayPath = XMPPathParser.expandXPath(schemaNS, arrayName);
    const arrayNode = XMPNodeUtils.findNode(this.tree, arrayPath, false, null);

    if (arrayNode) {
      this.doSetArrayItem(arrayNode, itemIndex, itemValue, options || new PropertyOptions(), false);
    } else {
      throw new XMPException("Specified array does not exist", XMPError.BADXPATH);
    }
  }

  /**
   * @throws XMPException
   * @see XMPMeta#insertArrayItem(String, String, number, String, PropertyOptions)
   */
  public insertArrayItem(schemaNS: string, arrayName: string, itemIndex: number,
                         itemValue: string, options?: PropertyOptions): void {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertArrayName(arrayName);

    // Just lookup, don't try to create.
    const arrayPath = XMPPathParser.expandXPath(schemaNS, arrayName);
    const arrayNode = XMPNodeUtils.findNode(this.tree, arrayPath, false, null);

    if (arrayNode) {
      this.doSetArrayItem(arrayNode, itemIndex, itemValue, options || new PropertyOptions(), true);
    } else {
      throw new XMPException("Specified array does not exist", XMPError.BADXPATH);
    }
  }

  /**
   * @throws XMPException
   * @see XMPMeta#setProperty(String, String, any, PropertyOptions)
   */
  public setProperty(schemaNS: string, propName: string, propValue: ESObject, options?: PropertyOptions | null): void {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertPropName(propName);

    const finalOptions = XMPNodeUtils.verifySetOptions(options || null, propValue);

    const expPath = XMPPathParser.expandXPath(schemaNS, propName);

    const propNode = XMPNodeUtils.findNode(this.tree, expPath, true, finalOptions);
    if (propNode) {
      this.setNode(propNode, propValue, finalOptions, false);
    } else {
      throw new XMPException("Specified property does not exist", XMPError.BADXPATH);
    }
  }

  /**
   * @throws XMPException
   * @see XMPMeta#setQualifier(String, String, String, String, String, PropertyOptions)
   */
  public setQualifier(schemaNS: string, propName: string, qualNS: string, qualName: string,
                      qualValue: string, options?: PropertyOptions): void {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertPropName(propName);

    if (!this.doesPropertyExist(schemaNS, propName)) {
      throw new XMPException("Specified property does not exist!", XMPError.BADXPATH);
    }

    const qualPath = propName + XMPPathFactory.composeQualifierPath(qualNS, qualName);
    this.setProperty(schemaNS, qualPath, qualValue, options || null);
  }

  /**
   * @see XMPMeta#setStructField(String, String, String, String, String, PropertyOptions)
   */
  public setStructField(schemaNS: string, structName: string, fieldNS: string, fieldName: string,
                        fieldValue: string, options?: PropertyOptions): void {
    ParameterAsserts.assertSchemaNS(schemaNS);
    ParameterAsserts.assertStructName(structName);

    const fieldPath = structName + XMPPathFactory.composeStructFieldPath(fieldNS, fieldName);
    this.setProperty(schemaNS, fieldPath, fieldValue, options || null);
  }

  /**
   * @see XMPMeta#getObjectName()
   */
  public getObjectName(): string {
    const name: string | null = this.tree.getName();
    return name != null ? name : "";
  }

  /**
   * @see XMPMeta#setObjectName(String)
   */
  public setObjectName(name: string): void {
    this.tree.setName(name);
  }

  /**
   * @see XMPMeta#getPacketHeader()
   */
  public getPacketHeader(): string | null {
    return this.packetHeader;
  }

  /**
   * Sets the packetHeader attributes, only used by the parser.
   * @param packetHeader the processing instruction content
   */
  public setPacketHeader(packetHeader: string): void {
    this.packetHeader = packetHeader;
  }

  /**
   * Performs a deep clone of the XMPMeta-object
   * 
   * @see Object#clone()
   */
  public clone(): XMPMetaImpl {
    const clonedTree = this.tree.clone() as XMPNode;
    return new XMPMetaImpl(clonedTree);
  }

  /**
   * @see XMPMeta#dumpObject()
   */
  public dumpObject(): string {
    // renders tree recursively
    return this.getRoot().dumpNode(true);
  }

  /**
   * @see XMPMeta#sort()
   */
  public sort(): void {
    this.tree.sort();
  }

  /**
   * @see XMPMeta#normalize(ParseOptions)
   */
  public normalize(options: ParseOptions): void {
    if (!options) {
      options = new ParseOptions();
    }
    XMPNormalizer.process(this, options);
  }

  /**
   * @return Returns the root node of the XMP tree.
   */
  public getRoot(): XMPNode {
    return this.tree;
  }

  // -------------------------------------------------------------------------------------  
  // private

  /**
   * Locate or create the item node and set the value. Note the index
   * parameter is one-based! The index can be in the range [1..size + 1] or
   * "last()", normalize it and check the insert flags. The order of the
   * normalization checks is important. If the array is empty we end up with
   * an index and location to set item size + 1.
   * 
   * @param arrayNode an array node
   * @param itemIndex the index where to insert the item
   * @param itemValue the item value
   * @param itemOptions the options for the new item
   * @param insert insert oder overwrite at index position?
   * @throws XMPException
   */
  private doSetArrayItem(arrayNode: XMPNode, itemIndex: number, itemValue: string, 
                         itemOptions: PropertyOptions, insert: boolean): void {
    const itemNode = new XMPNode(XMPConst.ARRAY_ITEM_NAME, null, null, null);
    itemOptions = XMPNodeUtils.verifySetOptions(itemOptions, itemValue);

    // in insert mode the index after the last is allowed,
    // even ARRAY_LAST_ITEM points to the index *after* the last.
    const maxIndex = insert ? arrayNode.getChildrenLength() + 1 : arrayNode.getChildrenLength();
    if (itemIndex === XMPConst.ARRAY_LAST_ITEM) {
      itemIndex = maxIndex;
    }

    if (1 <= itemIndex && itemIndex <= maxIndex) {
      if (!insert) {
        arrayNode.removeChild(itemIndex);
      }
      arrayNode.addChild(itemIndex, itemNode);
      this.setNode(itemNode, itemValue, itemOptions, false);
    } else {
      throw new XMPException("Array index out of bounds", XMPError.BADINDEX);
    }
  }

  /**
   * The internals for setProperty() and related calls, used after the node is
   * found or created.
   * 
   * @param node the newly created node
   * @param value the node value, can be <code>null</code>
   * @param newOptions options for the new node, must not be <code>null</code>.
   * @param deleteExisting flag if the existing value is to be overwritten 
   * @throws XMPException thrown if options and value do not correspond
   */
  setNode(node: XMPNode, value: ESObject, newOptions: PropertyOptions, deleteExisting: boolean): void {
    if (deleteExisting) {
      node.clear();
    }

    // its checked by setOptions(), if the merged result is a valid options set
    node.getOptions().mergeWith(newOptions);

    if (!node.getOptions().isCompositeProperty()) {
      // This is setting the value of a leaf node.
      XMPNodeUtils.setNodeValue(node, value);
    } else {
      if (value != null && value.toString().length > 0) {
        throw new XMPException("Composite nodes can't have values", XMPError.BADXPATH);
      }

      node.removeChildren();
    }
  }

  /**
   * Evaluates a raw node value to the given value type, apply special
   * conversions for defined types in XMP.
   * 
   * @param valueType an int indicating the value type
   * @param propNode the node containing the value
   * @return Returns a literal value for the node.
   * @throws XMPException
   */
  private evaluateNodeValue(valueType: number, propNode: XMPNode): ESObject {
    let value: ESObject;
    const rawValue: string | null = propNode.getValue();
    switch (valueType) {
      case XMPMetaImpl.VALUE_BOOLEAN:
        value = XMPUtils.convertToBoolean(rawValue);
        break;
      case XMPMetaImpl.VALUE_INTEGER:
        value = XMPUtils.convertToInteger(rawValue);
        break;
      case XMPMetaImpl.VALUE_LONG:
        value = XMPUtils.convertToLong(rawValue);
        break;
      case XMPMetaImpl.VALUE_DOUBLE:
        value = XMPUtils.convertToDouble(rawValue);
        break;
      case XMPMetaImpl.VALUE_DATE:
        value = XMPUtils.convertToDate(rawValue);
        break;
      case XMPMetaImpl.VALUE_CALENDAR:
        const dt = XMPUtils.convertToDate(rawValue);
        value = dt.getCalendar();
        break;
      case XMPMetaImpl.VALUE_BASE64:
        value = XMPUtils.decodeBase64(rawValue);
        break;
      case XMPMetaImpl.VALUE_STRING:
      default:
        // leaf values return empty string instead of null
        // for the other cases the converter methods provides a "null"
        // value.
        // a default value can only occur if this method is made public.
        value = rawValue != null || propNode.getOptions().isCompositeProperty() ? (rawValue || "") : "";
        break;
    }
    return value;
  }
}