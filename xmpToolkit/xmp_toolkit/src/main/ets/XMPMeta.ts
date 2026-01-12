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

import XMPProperty from './properties/XMPProperty';
import PropertyOptions from './options/PropertyOptions';
import XMPException from './XMPException';
import XMPDateTime from './XMPDateTime';
import XMPIterator from './XMPIterator';
import IteratorOptions from './options/IteratorOptions';
import ParseOptions from './options/ParseOptions';

/**
 * This interface defines the XMP metadata DOM representation.
 */
interface XMPMeta {
  // 基本属性操作方法
  /**
   * Retrieves a property.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns the property, null if the property is not existing.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getProperty(schemaNS: string, propName: string): XMPProperty | null;

  /**
   * Retrieves a property with options.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param options Options for property retrieval.
   * @return Returns the property, null if the property is not existing.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getProperty(schemaNS: string, propName: string, options: number): XMPProperty | null;

  /**
   * Retrieves an array item.
   * @param schemaNS The namespace URI for the array.
   * @param arrayName The name of the array.
   * @param itemIndex The index of the item to retrieve.
   * @return Returns the array item, null if the array item is not existing.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getArrayItem(schemaNS: string, arrayName: string, itemIndex: number): XMPProperty | null;

  /**
   * Retrieves an array item with options.
   * @param schemaNS The namespace URI for the array.
   * @param arrayName The name of the array.
   * @param itemIndex The index of the item to retrieve.
   * @param options Options for array item retrieval.
   * @return Returns the array item, null if the array item is not existing.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getArrayItem(schemaNS: string, arrayName: string, itemIndex: number, options: number): XMPProperty | null;

  /**
   * Counts the items in an array.
   * @param schemaNS The namespace URI for the array.
   * @param arrayName The name of the array.
   * @return Returns the number of items in the array.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  countArrayItems(schemaNS: string, arrayName: string): number;

  /**
   * Retrieves a struct field.
   * @param schemaNS The namespace URI for the struct.
   * @param structName The name of the struct.
   * @param fieldNS The namespace URI for the field.
   * @param fieldName The name of the field.
   * @return Returns the struct field, null if the struct field is not existing.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getStructField(schemaNS: string, structName: string, fieldNS: string, fieldName: string): XMPProperty | null;

  /**
   * Retrieves a struct field with options.
   * @param schemaNS The namespace URI for the struct.
   * @param structName The name of the struct.
   * @param fieldNS The namespace URI for the field.
   * @param fieldName The name of the field.
   * @param options Options for struct field retrieval.
   * @return Returns the struct field, null if the struct field is not existing.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getStructField(schemaNS: string, structName: string, fieldNS: string, fieldName: string,
                 options: number): XMPProperty | null;

  /**
   * Retrieves a qualifier.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param qualNS The namespace URI for the qualifier.
   * @param qualName The name of the qualifier.
   * @return Returns the qualifier, null if the qualifier is not existing.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getQualifier(schemaNS: string, propName: string, qualNS: string, qualName: string): XMPProperty | null;

  // 属性值设置方法
  /**
   * Sets a property.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param propValue The value of the property.
   * @param options Options of the property to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setProperty(schemaNS: string, propName: string, propValue: string, options?: PropertyOptions): void;

  /**
   * Sets an array item.
   * @param schemaNS The namespace URI for the array.
   * @param arrayName The name of the array.
   * @param itemIndex The index of the item to set.
   * @param propValue The value of the array item.
   * @param options Options of the array item to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setArrayItem(schemaNS: string, arrayName: string, itemIndex: number, propValue: string,
               options?: PropertyOptions): void;

  /**
   * Inserts an array item.
   * @param schemaNS The namespace URI for the array.
   * @param arrayName The name of the array.
   * @param itemIndex The index at which to insert the item.
   * @param propValue The value of the array item.
   * @param options Options of the array item to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  insertArrayItem(schemaNS: string, arrayName: string, itemIndex: number, propValue: string,
                  options?: PropertyOptions): void;

  /**
   * Appends an array item.
   * @param schemaNS The namespace URI for the array.
   * @param arrayName The name of the array.
   * @param propValue The value of the array item.
   * @param options Options of the array item to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  appendArrayItem(schemaNS: string, arrayName: string, arrayOptions: PropertyOptions | null,
                  itemValue: string, itemOptions: PropertyOptions | null): void;
  appendArrayItem(schemaNS: string, arrayName: string, itemValue: string): void;

  /**
   * Sets a struct field.
   * @param schemaNS The namespace URI for the struct.
   * @param structName The name of the struct.
   * @param fieldNS The namespace URI for the field.
   * @param fieldName The name of the field.
   * @param propValue The value of the struct field.
   * @param options Options of the struct field to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setStructField(schemaNS: string, structName: string, fieldNS: string, fieldName: string,
                 propValue: string, options?: PropertyOptions): void;

  // 设置限定符方法
  /**
   * Sets a qualifier.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param qualNS The namespace URI for the qualifier.
   * @param qualName The name of the qualifier.
   * @param qualValue The value of the qualifier.
   * @param options Options of the qualifier to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setQualifier(schemaNS: string, propName: string, qualNS: string, qualName: string,
               qualValue: string, options?: PropertyOptions): void;

  // 删除操作方法
  /**
   * Deletes a property.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @throws XMPException Wraps all exceptions that may occur.
   */
  deleteProperty(schemaNS: string, propName: string): void;

  /**
   * Deletes an array item.
   * @param schemaNS The namespace URI for the array.
   * @param arrayName The name of the array.
   * @param itemIndex The index of the item to delete.
   * @throws XMPException Wraps all exceptions that may occur.
   */
  deleteArrayItem(schemaNS: string, arrayName: string, itemIndex: number): void;

  /**
   * Deletes a struct field.
   * @param schemaNS The namespace URI for the struct.
   * @param structName The name of the struct.
   * @param fieldNS The namespace URI for the field.
   * @param fieldName The name of the field.
   * @throws XMPException Wraps all exceptions that may occur.
   */
  deleteStructField(schemaNS: string, structName: string, fieldNS: string, fieldName: string): void;

  /**
   * Deletes a qualifier.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param qualNS The namespace URI for the qualifier.
   * @param qualName The name of the qualifier.
   * @throws XMPException Wraps all exceptions that may occur.
   */
  deleteQualifier(schemaNS: string, propName: string, qualNS: string, qualName: string): void;

  // 存在性检查方法
  /**
   * Checks if a property exists.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns true if the property exists.
   */
  doesPropertyExist(schemaNS: string, propName: string): boolean;

  /**
   * Checks if an array item exists.
   * @param schemaNS The namespace URI for the array.
   * @param arrayName The name of the array.
   * @param itemIndex The index of the item to check.
   * @return Returns true if the array item exists.
   */
  doesArrayItemExist(schemaNS: string, arrayName: string, itemIndex: number): boolean;

  /**
   * Checks if a struct field exists.
   * @param schemaNS The namespace URI for the struct.
   * @param structName The name of the struct.
   * @param fieldNS The namespace URI for the field.
   * @param fieldName The name of the field.
   * @return Returns true if the struct field exists.
   */
  doesStructFieldExist(schemaNS: string, structName: string, fieldNS: string, fieldName: string): boolean;

  /**
   * Checks if a qualifier exists.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param qualNS The namespace URI for the qualifier.
   * @param qualName The name of the qualifier.
   * @return Returns true if the qualifier exists.
   */
  doesQualifierExist(schemaNS: string, propName: string, qualNS: string, qualName: string): boolean;

  // 本地化文本属性操作方法
  /**
   * Retrieves a localized text property.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param genericLang The generic language code.
   * @param specificLang The specific language code.
   * @return Returns the localized text property, null if not found.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getLocalizedText(schemaNS: string, propName: string, genericLang: string,
                   specificLang: string): XMPProperty | null;

  /**
   * Sets a localized text property.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param genericLang The generic language code.
   * @param specificLang The specific language code.
   * @param itemValue The value of the localized text.
   * @param options Options of the property to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setLocalizedText(schemaNS: string, propName: string, genericLang: string, specificLang: string,
                   itemValue: string, options: PropertyOptions | null): void;

  // 多种属性值获取方法
  /**
   * Retrieves a boolean property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns the boolean value of the property.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getPropertyBoolean(schemaNS: string, propName: string): boolean;

  /**
   * Retrieves an integer property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns the integer value of the property.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getPropertyInteger(schemaNS: string, propName: string): number;

  /**
   * Retrieves a long property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns the long value of the property.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getPropertyLong(schemaNS: string, propName: string): number;

  /**
   * Retrieves a double property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns the double value of the property.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getPropertyDouble(schemaNS: string, propName: string): number;

  /**
   * Retrieves a date property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns the date value of the property.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getPropertyDate(schemaNS: string, propName: string): XMPDateTime | null;

  /**
   * Retrieves a Calendar property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns the Calendar value of the property.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getPropertyCalendar(schemaNS: string, propName: string): ESObject; // Calendar在ArkTS中对应Date或其他日期类型

  /**
   * Retrieves a base64 property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns the base64 value of the property as byte array.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getPropertyBase64(schemaNS: string, propName: string): Uint8Array | null;

  /**
   * Retrieves a string property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @return Returns the string value of the property.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  getPropertyString(schemaNS: string, propName: string): string;

  // 多种属性值设置方法
  /**
   * Sets a boolean property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param propValue The boolean value to set.
   * @param options Options of the property to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setPropertyBoolean(schemaNS: string, propName: string, propValue: boolean,
                     options?: PropertyOptions): void;

  /**
   * Sets an integer property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param propValue The integer value to set.
   * @param options Options of the property to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setPropertyInteger(schemaNS: string, propName: string, propValue: number,
                     options?: PropertyOptions): void;

  /**
   * Sets a long property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param propValue The long value to set.
   * @param options Options of the property to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setPropertyLong(schemaNS: string, propName: string, propValue: number,
                  options?: PropertyOptions): void;

  /**
   * Sets a double property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param propValue The double value to set.
   * @param options Options of the property to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setPropertyDouble(schemaNS: string, propName: string, propValue: number,
                    options?: PropertyOptions): void;

  /**
   * Sets a date property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param propValue The date value to set.
   * @param options Options of the property to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setPropertyDate(schemaNS: string, propName: string, propValue: XMPDateTime,
                  options?: PropertyOptions): void;

  /**
   * Sets a Calendar property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param propValue The Calendar value to set.
   * @param options Options of the property to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setPropertyCalendar(schemaNS: string, propName: string, propValue: ESObject,
                      options?: PropertyOptions): void;

  /**
   * Sets a base64 property value.
   * @param schemaNS The namespace URI for the property.
   * @param propName The name of the property.
   * @param propValue The base64 value to set as byte array.
   * @param options Options of the property to set (optional).
   * @throws XMPException Wraps all exceptions that may occur.
   */
  setPropertyBase64(schemaNS: string, propName: string, propValue: Uint8Array,
                     options?: PropertyOptions): void;

  // 迭代器方法
  /**
   * Constructs an iterator for the properties within this XMP object.
   * @return Returns an XMPIterator.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  iterator(): XMPIterator;

  /**
   * Constructs an iterator for the properties within this XMP object using some options.
   * @param options Option flags to control the iteration.
   * @return Returns an XMPIterator.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  iterator(options: IteratorOptions): XMPIterator;

  /**
   * Construct an iterator for the properties within an XMP object.
   * @param schemaNS Optional schema namespace URI to restrict the iteration.
   * @param propName Optional property name to restrict the iteration.
   * @param options Option flags to control the iteration.
   * @return Returns an XMPIterator for this XMPMeta-object considering the given options.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  iterator(schemaNS: string, propName: string, options: IteratorOptions): XMPIterator;

  // 对象名称方法
  /**
   * This correlates to the about-attribute, returns the empty String if no name is set.
   * @return Returns the name of the XMP object.
   */
  getObjectName(): string;

  /**
   * Sets the name of the XMP object.
   * @param name Sets the name of the XMP object.
   */
  setObjectName(name: string): void;

  // 数据包头部方法
  /**
   * Returns the unparsed content of the <?xpacket> processing instruction.
   * @return Returns the unparsed content of the <?xpacket> processing instruction.
   */
  getPacketHeader(): string | null;

  // 克隆方法
  /**
   * Clones the complete metadata tree.
   * @return Returns a deep copy of this instance.
   */
  clone(): Object;

  // 排序方法
  /**
   * Sorts the complete datamodel according to specific rules.
   */
  sort(): void;

  // 规范化方法
  /**
   * Perform the normalization as a separate parsing step.
   * @param options optional parsing options.
   * @throws XMPException Wraps all errors and exceptions that may occur.
   */
  normalize(options: ParseOptions): void;

  // 转储对象方法
  /**
   * Renders this node and the tree unter this node in a human readable form.
   * @return Returns a multiline string containing the dump.
   */
  dumpObject(): string;
}

export default XMPMeta;