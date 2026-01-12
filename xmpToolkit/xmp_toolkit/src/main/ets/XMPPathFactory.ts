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

import XMPException from './XMPException';
import XMPError from './XMPError';
import XMPConst from './XMPConst';
import Utils from './impl/Utils';
import XMPPathParser from './impl/xpath/XMPPathParser';
import XMPPath from './impl/xpath/XMPPath';

/**
 * Utility services for the metadata object. It has only public static functions, you cannot create
 * an object. These are all functions that layer cleanly on top of the core XMP toolkit.
 * <p>
 * These functions provide support for composing path expressions to deeply nested properties.
 */
export default class XMPPathFactory {
  /** Private constructor */
  private constructor() {
    // EMPTY
  }

  /**
   * Compose the path expression for an item in an array.
   * 
   * @param arrayName The name of the array. May be a general path expression, must not be
   *        null or the empty string.
   * @param itemIndex The index of the desired item. Arrays in XMP are indexed from 1.
   *        0 and below means last array item and renders as [last()].
   * @return Returns the composed path basing on fullPath. This will be of the form
   *         ns:arrayName[i], where "ns" is the prefix for schemaNS and
   *         "i" is the decimal representation of itemIndex.
   * @throws XMPException Throws exeption if index zero is used.
   */
  public static composeArrayItemPath(arrayName: string, itemIndex: number): string {
    if (itemIndex > 0) {
      return arrayName + '[' + itemIndex + ']';
    } else if (itemIndex === XMPConst.ARRAY_LAST_ITEM) {
      return arrayName + "[last()]";
    } else {
      throw new XMPException("Array index must be larger than zero", XMPError.BADINDEX);
    }
  }

  /**
   * Compose the path expression for a field in a struct.
   * 
   * @param fieldNS The namespace URI for the field. Must not be null or the empty
   *        string.
   * @param fieldName The name of the field. Must be a simple XML name, must not be
   *        null or the empty string.
   * @return Returns the composed path. This will be of the form
   *         ns:structName/fNS:fieldName, where "ns" is the prefix for
   *         schemaNS and "fNS" is the prefix for fieldNS.
   * @throws XMPException Thrown if the path to create is not valid.
   */
  public static composeStructFieldPath(fieldNS: string, fieldName: string): string {
    XMPPathFactory.assertFieldNS(fieldNS);
    XMPPathFactory.assertFieldName(fieldName);

    const fieldPath = XMPPathParser.expandXPath(fieldNS, fieldName);
    if (fieldPath.size() !== 2) {
      throw new XMPException("The field name must be simple", XMPError.BADXPATH);
    }
    return '/' + fieldPath.getSegment(XMPPath.STEP_ROOT_PROP).getName();
  }

  /**
   * Compose the path expression for a qualifier.
   * 
   * @param qualNS The namespace URI for the qualifier. May be null or the empty
   *        string if the qualifier is in the XML empty namespace.
   * @param qualName The name of the qualifier. Must be a simple XML name, must not be
   *        null or the empty string.
   * @return Returns the composed path. This will be of the form
   *         ns:propName/?qNS:qualName, where "ns" is the prefix for
   *         schemaNS and "qNS" is the prefix for qualNS.
   * @throws XMPException Thrown if the path to create is not valid.
   */
  public static composeQualifierPath(qualNS: string, qualName: string): string {
    XMPPathFactory.assertQualNS(qualNS);
    XMPPathFactory.assertQualName(qualName);
    
    const qualPath = XMPPathParser.expandXPath(qualNS, qualName);
    if (qualPath.size() !== 2) {
      throw new XMPException("The qualifier name must be simple", XMPError.BADXPATH);
    }
    return "/?" + qualPath.getSegment(XMPPath.STEP_ROOT_PROP).getName();
  }

  /**
   * Compose the path expression to select an alternate item by language.
   * 
   * @param arrayName The name of the array. May be a general path expression, must
   *        not be null or the empty string.
   * @param langName The RFC 3066 code for the desired language.
   * @return Returns the composed path. This will be of the form
   *         ns:arrayName[@xml:lang='langName'], where
   *         "ns" is the prefix for schemaNS.
   */
  public static composeLangSelector(arrayName: string, langName: string): string {
    return arrayName + "[?xml:lang=\"" + Utils.normalizeLangValue(langName) + "\"]";
  }

  /**
   * Compose the path expression to select an alternate item by a field's value.
   * 
   * @param arrayName The name of the array. May be a general path expression, must not be
   *        null or the empty string.
   * @param fieldNS The namespace URI for the field used as the selector. Must not be
   *        null or the empty string.
   * @param fieldName The name of the field used as the selector. Must be a simple XML name, must
   *        not be null or the empty string. It must be the name of a field that is
   *        itself simple.
   * @param fieldValue The desired value of the field.
   * @return Returns the composed path. This will be of the form
   *         ns:arrayName[fNS:fieldName='fieldValue'], where "ns" is the
   *         prefix for schemaNS and "fNS" is the prefix for fieldNS.
   * @throws XMPException Thrown if the path to create is not valid.
   */
  public static composeFieldSelector(arrayName: string, fieldNS: string, fieldName: string,
                                     fieldValue: string): string {
    const fieldPath = XMPPathParser.expandXPath(fieldNS, fieldName);
    if (fieldPath.size() !== 2) {
      throw new XMPException("The fieldName name must be simple", XMPError.BADXPATH);
    }
    return arrayName + '[' + fieldPath.getSegment(XMPPath.STEP_ROOT_PROP).getName() +
      "=\"" + fieldValue + "\"]";
  }

  /**
   * ParameterAsserts that a qualifier namespace is set.
   * @param qualNS a qualifier namespace
   * @throws XMPException Qualifier schema is null or empty
   */
  private static assertQualNS(qualNS: string): void {
    if (qualNS == null || qualNS.length === 0) {
      throw new XMPException("Empty qualifier namespace URI", XMPError.BADSCHEMA);
    }
  }

  /**
   * ParameterAsserts that a qualifier name is set.
   * @param qualName a qualifier name or path
   * @throws XMPException Qualifier name is null or empty
   */
  private static assertQualName(qualName: string): void {
    if (qualName == null || qualName.length === 0) {
      throw new XMPException("Empty qualifier name", XMPError.BADXPATH);
    }
  }

  /**
   * ParameterAsserts that a struct field namespace is set.
   * @param fieldNS a struct field namespace
   * @throws XMPException Struct field schema is null or empty
   */
  private static assertFieldNS(fieldNS: string): void {
    if (fieldNS == null || fieldNS.length === 0) {
      throw new XMPException("Empty field namespace URI", XMPError.BADSCHEMA);
    }
  }

  /**
   * ParameterAsserts that a struct field name is set.
   * @param fieldName a struct field name or path
   * @throws XMPException Struct field name is null or empty
   */
  private static assertFieldName(fieldName: string): void {
    if (fieldName == null || fieldName.length === 0) {
      throw new XMPException("Empty field name", XMPError.BADXPATH);
    }
  }
}