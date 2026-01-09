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

import XMPMetaImpl from './XMPMetaImpl';
import XMPNode from './XMPNode';
import XMPError from '../XMPError';
import XMPException from '../XMPException';
import XMPNodeUtils from './XMPNodeUtils';
import XMPPathParser from './xpath/XMPPathParser';
import XMPUtils from '../XMPUtils';
import ParseOptions from '../options/ParseOptions';
import PropertyOptions from '../options/PropertyOptions';
import XMPConst from '../XMPConst';
import XMPMeta from '../XMPMeta';
import XMPMetaFactory from '../XMPMetaFactory';
import Utils from './Utils';
import XMPPath from './xpath/XMPPath';
import XMPDateTimeImpl from './XMPDateTimeImpl';
import XMPDateTime from '../XMPDateTime';

/**
 * The <code>XMPNormalizer</code> is a helper class that applies normalization operations to a XMP metadata object.
 * 
 * @since 12.01.2006
 */
export class XMPNormalizer {
  /** caches the correct dc-property array forms */
  private static dcArrayForms: ESObject | null = null;
  
  /**
   * Private constructor, the class should not be instantiated.
   */
  private constructor() {
    // EMPTY
  }

  /**
   * Initialize DC arrays if not already initialized
   */
  private static ensureDCArraysInitialized(): void {
    if (XMPNormalizer.dcArrayForms === null) {
      XMPNormalizer.dcArrayForms = {};
      
      // Properties supposed to be a "Bag".
      const bagForm = new PropertyOptions();
      bagForm.setArray(true);
      XMPNormalizer.dcArrayForms["dc:contributor"] = bagForm;
      XMPNormalizer.dcArrayForms["dc:language"] = bagForm;
      XMPNormalizer.dcArrayForms["dc:publisher"] = bagForm;
      XMPNormalizer.dcArrayForms["dc:relation"] = bagForm;
      XMPNormalizer.dcArrayForms["dc:subject"] = bagForm;
      XMPNormalizer.dcArrayForms["dc:type"] = bagForm;

      // Properties supposed to be a "Seq".
      const seqForm = new PropertyOptions();
      seqForm.setArray(true);
      seqForm.setArrayOrdered(true);
      XMPNormalizer.dcArrayForms["dc:creator"] = seqForm;
      XMPNormalizer.dcArrayForms["dc:date"] = seqForm;
      
      // Properties supposed to be an "Alt" in alternative-text form.
      const altTextForm = new PropertyOptions();
      altTextForm.setArray(true);
      altTextForm.setArrayOrdered(true);
      altTextForm.setArrayAlternate(true);
      altTextForm.setArrayAltText(true);
      XMPNormalizer.dcArrayForms["dc:description"] = altTextForm;
      XMPNormalizer.dcArrayForms["dc:rights"] = altTextForm;
      XMPNormalizer.dcArrayForms["dc:title"] = altTextForm;
    }
  }

  /**
   * Normalizes a raw parsed XMPMeta-Object
   * @param xmp the raw metadata object
   * @param options the parsing options
   * @return Returns the normalized metadata object
   * @throws XMPException Collects all severe processing errors. 
   */
  public static process(xmp: XMPMetaImpl, options: ParseOptions): XMPMeta {
    const tree = xmp.getRoot();

    XMPNormalizer.touchUpDataModel(xmp);
    XMPNormalizer.moveExplicitAliases(tree, options);
    
    XMPNormalizer.tweakOldXMP(tree);
    
    XMPNormalizer.deleteEmptySchemas(tree);
    
    return xmp;
  }

  /**
   * Tweak old XMP: Move an instance ID from rdf:about to the
   * <em>xmpMM:InstanceID</em> property. An old instance ID usually looks
   * like &quot;uuid:bac965c4-9d87-11d9-9a30-000d936b79c4&quot;, plus InDesign
   * 3.0 wrote them like &quot;bac965c4-9d87-11d9-9a30-000d936b79c4&quot;. If
   * the name looks like a UUID simply move it to <em>xmpMM:InstanceID</em>,
   * don't worry about any existing <em>xmpMM:InstanceID</em>. Both will
   * only be present when a newer file with the <em>xmpMM:InstanceID</em>
   * property is updated by an old app that uses <em>rdf:about</em>.
   * 
   * @param tree the root of the metadata tree
   * @throws XMPException Thrown if tweaking fails. 
   */
  private static tweakOldXMP(tree: XMPNode): void {
    const name = tree.getName();
    if (name !== null && name.length >= Utils.UUID_LENGTH) {
      let nameStr = name.toLowerCase();
      if (nameStr.startsWith("uuid:")) {
        nameStr = nameStr.substring(5);
      }
      
      if (Utils.checkUUIDFormat(nameStr)) {
        // move UUID to xmpMM:InstanceID and remove it from the root node
        const path = XMPPathParser.expandXPath(XMPConst.NS_XMP_MM, "InstanceID");
        const idNode = XMPNodeUtils.findNode(tree, path, true, null);
        if (idNode !== null) {
          // Clobber any existing xmpMM:InstanceID by clearing options and setting new ones
          idNode.getOptions().clearOptions();
          idNode.setValue("uuid:" + nameStr);
          idNode.removeChildren();
          idNode.removeQualifiers();
          // Clear the root node name (set to empty string instead of null for type safety)
          tree.setName("");
              } else {
          throw new XMPException("Failure creating xmpMM:InstanceID",
            XMPError.INTERNALFAILURE);
        }
      }
    }
  }

  /**
   * Visit all schemas to do general fixes and handle special cases.
   * 
   * @param xmp the metadata object implementation
   * @throws XMPException Thrown if the normalisation fails.
   */
  private static touchUpDataModel(xmp: XMPMetaImpl): void {
    // make sure the DC schema is existing, because it might be needed within the normalization
    // if not touched it will be removed by removeEmptySchemas
    XMPNodeUtils.findSchemaNode(xmp.getRoot(), XMPConst.NS_DC, true);
    
    // Do the special case fixes within each schema.
    const rootIterator: Iterator<XMPNode> = xmp.getRoot().iterateChildren();
    let schemaResult: IteratorResult<XMPNode, undefined> = rootIterator.next();
    while (!schemaResult.done) {
      const currSchema: XMPNode = schemaResult.value;
      const schemaName = currSchema.getName();
      if (schemaName !== null && XMPConst.NS_DC === schemaName) {
        XMPNormalizer.normalizeDCArrays(currSchema);
      } else if (schemaName !== null && XMPConst.NS_EXIF === schemaName) {
        // Do a special case fix for exif:GPSTimeStamp.
        XMPNormalizer.fixGPSTimeStamp(currSchema);
        const arrayNode = XMPNodeUtils.findChildNode(currSchema, "exif:UserComment", false);
        if (arrayNode !== null) {
          XMPNormalizer.repairAltText(arrayNode);
        }
      } else if (schemaName !== null && XMPConst.NS_DM === schemaName) {
        // Do a special case migration of xmpDM:copyright to
        // dc:rights['x-default'].
        const dmCopyright = XMPNodeUtils.findChildNode(currSchema, "xmpDM:copyright", false);
        if (dmCopyright !== null) {
          XMPNormalizer.migrateAudioCopyright(xmp, dmCopyright);
        }
      } else if (schemaName !== null && XMPConst.NS_XMP_RIGHTS === schemaName) {
        const arrayNode = XMPNodeUtils.findChildNode(currSchema, "xmpRights:UsageTerms", false);
        if (arrayNode !== null) {
          XMPNormalizer.repairAltText(arrayNode);
        }
      }
      schemaResult = rootIterator.next();
    }
  }

  /**
   * Undo the denormalization performed by the XMP used in Acrobat 5.<br> 
   * If a Dublin Core array had only one item, it was serialized as a simple
   * property. <br>
   * The <code>xml:lang</code> attribute was dropped from an
   * <code>alt-text</code> item if the language was <code>x-default</code>.
   * 
   * @param dcSchema the DC schema node
   * @throws XMPException Thrown if normalization fails
   */
  private static normalizeDCArrays(dcSchema: XMPNode): void {
    XMPNormalizer.ensureDCArraysInitialized();
    
    for (let i = 1; i <= dcSchema.getChildrenLength(); i++) {
      const currProp = dcSchema.getChild(i);
      const propName = currProp.getName();
      
      if (propName === null) {
        continue;
      }
      
      const arrayForm = XMPNormalizer.dcArrayForms![propName] as PropertyOptions | undefined;
      if (arrayForm === undefined) {
        continue;
      } else if (currProp.getOptions().isSimple()) {
        // create a new array and add the current property as child, 
        // if it was formerly simple 
        const newArray = new XMPNode(currProp.getName(), null, arrayForm, currProp.getOriginalPrefix());
        currProp.setName(XMPConst.ARRAY_ITEM_NAME);
        newArray.addChild(currProp);
        dcSchema.replaceChild(i, newArray);

        // fix language alternatives
        if (arrayForm.isArrayAltText() && !currProp.getOptions().getHasLanguage()) {
          const newLang = new XMPNode(XMPConst.XML_LANG, XMPConst.X_DEFAULT, null, null);
          currProp.addQualifier(newLang);
        }
    } else {
        // clear array options and add corrected array form if it has been an array before
        currProp.getOptions().setOption(
          PropertyOptions.ARRAY |
          PropertyOptions.ARRAY_ORDERED |
          PropertyOptions.ARRAY_ALTERNATE |
          PropertyOptions.ARRAY_ALT_TEXT,
          false);
        currProp.getOptions().mergeWith(arrayForm);
        
        if (arrayForm.isArrayAltText()) {
          // applying for "dc:description", "dc:rights", "dc:title"
          XMPNormalizer.repairAltText(currProp);
        }
      }
    }
  }

  /**
   * Make sure that the array is well-formed AltText. Each item must be simple
   * and have an "xml:lang" qualifier. If repairs are needed, keep simple
   * non-empty items by adding the "xml:lang" with value "x-repair".
   * @param arrayNode the property node of the array to repair.
   * @throws XMPException Forwards unexpected exceptions.
   */
  private static repairAltText(arrayNode: XMPNode): void {
    if (arrayNode === null ||
      !arrayNode.getOptions().isArray()) {
      // Already OK or not even an array.
      return;
    }
    
    // fix options
    arrayNode.getOptions().setArrayOrdered(true).setArrayAlternate(true).setArrayAltText(true);
    
    const childrenIterator: Iterator<XMPNode> = arrayNode.iterateChildren();
    const childrenToRemove: XMPNode[] = [];
    let childResult: IteratorResult<XMPNode, undefined> = childrenIterator.next();
    while (!childResult.done) {
      const currChild: XMPNode = childResult.value;
      if (currChild.getOptions().isCompositeProperty()) {
        // Delete non-simple children.
        childrenToRemove.push(currChild);
      } else if (!currChild.getOptions().getHasLanguage()) {
        const childValue = currChild.getValue();
        if (childValue === null || childValue.length === 0) {
          // Delete empty valued children that have no xml:lang.
          childrenToRemove.push(currChild);
        } else {
          // Add an xml:lang qualifier with the value "x-repair".
          const repairLang = new XMPNode(XMPConst.XML_LANG, "x-repair", null, null);
          currChild.addQualifier(repairLang);
        }
      }
      childResult = childrenIterator.next();
    }
    
    // Remove children that need to be deleted
    for (const childToRemove of childrenToRemove) {
      arrayNode.removeChild(childToRemove);
    }
  }

  /**
   * Visit all of the top level nodes looking for aliases. If there is
   * no base, transplant the alias subtree. If there is a base and strict
   * aliasing is on, make sure the alias and base subtrees match.
   * 
   * @param tree the root of the metadata tree
   * @param options the parsing options
   * @throws XMPException Forwards XMP errors
   */
  private static moveExplicitAliases(tree: XMPNode, options: ParseOptions): void {
    if (!tree.getHasAliases()) {
      return;
    }
    tree.setHasAliases(false);
    
    const strictAliasing: boolean = options.getStrictParsing();

    const schemaChildren = tree.getUnmodifiableChildren();
    const schemaIterator: Iterator<XMPNode> = schemaChildren[Symbol.iterator]();
    let schemaResult: IteratorResult<XMPNode, undefined> = schemaIterator.next();
    while (!schemaResult.done) {
      const currSchema: XMPNode = schemaResult.value;
      if (!currSchema.getHasAliases()) {
        schemaResult = schemaIterator.next();
        continue;
      }
      
      const propertyIterator: Iterator<XMPNode> = currSchema.iterateChildren();
      const propertiesToRemove: XMPNode[] = [];
      let propertyResult: IteratorResult<XMPNode, undefined> = propertyIterator.next();
      while (!propertyResult.done) {
        const currProp: XMPNode = propertyResult.value;
        
        if (!currProp.isAlias()) {
          propertyResult = propertyIterator.next();
          continue;
        }
        
        currProp.setAlias(false);

        // Find the base path, look for the base schema and root node.
        const propName = currProp.getName();
        if (propName === null) {
          propertyResult = propertyIterator.next();
          continue;
        }
        
        const info = XMPMetaFactory.getSchemaRegistry().findAlias(propName);
        if (info !== null) {
          // find or create schema
          const baseSchema = XMPNodeUtils.findSchemaNodeWithPrefix(tree, info.getNamespace(), null, true);
          if (baseSchema !== null) {
            baseSchema.setImplicit(false);
            
            const prefix = info.getPrefix();
            const propName = (prefix || "") + info.getPropName();
            const baseNode = XMPNodeUtils.findChildNode(baseSchema, propName, false);
            if (baseNode === null) {
              if (info.getAliasForm().isSimple()) {
                // A top-to-top alias, transplant the property.
                // change the alias property name to the base name
                currProp.setName(propName);
                baseSchema.addChild(currProp);
                // remove the alias property
                propertiesToRemove.push(currProp);
              } else {
                // An alias to an array item, 
                // create the array and transplant the property.
                const originalPrefix = prefix === null ? null : prefix.substring(0, Math.max(prefix.indexOf(":"), 0));
                const newBaseNode = new XMPNode(propName, null, info.getAliasForm().toPropertyOptions(), originalPrefix);
                baseSchema.addChild(newBaseNode);
                XMPNormalizer.transplantArrayItemAlias(propertiesToRemove, currProp, newBaseNode);
              }
            } else if (info.getAliasForm().isSimple()) {
              // The base node does exist and this is a top-to-top alias.
              // Check for conflicts if strict aliasing is on. 
              // Remove and delete the alias subtree.
              if (strictAliasing) {
                XMPNormalizer.compareAliasedSubtrees(currProp, baseNode, true);
              }
              
              propertiesToRemove.push(currProp);
            } else {
              // This is an alias to an array item and the array exists.
              // Look for the aliased item.
              // Then transplant or check & delete as appropriate.
              
              let itemNode: XMPNode | null = null;
              if (info.getAliasForm().isArrayAltText()) {
                const xdIndex = XMPNodeUtils.lookupLanguageItem(baseNode, XMPConst.X_DEFAULT);
                if (xdIndex !== -1) {
                  itemNode = baseNode.getChild(xdIndex);
                }
              } else if (baseNode.hasChildren()) {
                itemNode = baseNode.getChild(1);
              }
              
              if (itemNode === null) {
                XMPNormalizer.transplantArrayItemAlias(propertiesToRemove, currProp, baseNode);
              } else {
                if (strictAliasing) {
                  XMPNormalizer.compareAliasedSubtrees(currProp, itemNode, true);
                }
                
                propertiesToRemove.push(currProp);
              }
            }
          }
        }
        propertyResult = propertyIterator.next();
      }
      
      // Remove properties that need to be deleted
      for (const propToRemove of propertiesToRemove) {
        currSchema.removeChild(propToRemove);
      }
      
      currSchema.setHasAliases(false);
      schemaResult = schemaIterator.next();
    }
  }

  /**
   * Moves an alias node of array form to another schema into an array
   * @param propertiesToRemove the list to track properties to remove
   * @param childNode the node to be moved
   * @param baseArray the base array for the array item 
   * @throws XMPException Forwards XMP errors
   */
  private static transplantArrayItemAlias(propertiesToRemove: XMPNode[], childNode: XMPNode,
    baseArray: XMPNode): void {
    if (baseArray.getOptions().isArrayAltText()) {
      if (childNode.getOptions().getHasLanguage()) {
        throw new XMPException("Alias to x-default already has a language qualifier",
          XMPError.BADXMP);
      }
      
      const langQual = new XMPNode(XMPConst.XML_LANG, XMPConst.X_DEFAULT, null, null);
      childNode.addQualifier(langQual);
    }

    propertiesToRemove.push(childNode);
    childNode.setName(XMPConst.ARRAY_ITEM_NAME);
    baseArray.addChild(childNode);
  }

  /**
   * Fixes the GPS Timestamp in EXIF.
   * @param exifSchema the EXIF schema node
   * @throws XMPException Thrown if the date conversion fails.
   */
  private static fixGPSTimeStamp(exifSchema: XMPNode): void {
    // Note: if dates are not found the convert-methods throws an exceptions,
    // 		 and this methods returns.
    const gpsDateTime = XMPNodeUtils.findChildNode(exifSchema, "exif:GPSTimeStamp", false);
    if (gpsDateTime === null) {
      return;
    }
    
    try {
      let binGPSStamp: XMPDateTime;
      let binOtherDate: XMPDateTime;
      
      const gpsValue = gpsDateTime.getValue();
      if (gpsValue === null) {
        return;
      }
      
      binGPSStamp = XMPUtils.convertToDate(gpsValue);
      if (binGPSStamp.getYear() !== 0 ||
        binGPSStamp.getMonth() !== 0 ||
        binGPSStamp.getDay() !== 0) {
        return;
      }
      
      let otherDate = XMPNodeUtils.findChildNode(exifSchema, "exif:DateTimeOriginal", false);
      if (otherDate === null) {
        otherDate = XMPNodeUtils.findChildNode(exifSchema, "exif:DateTimeDigitized", false);
      }

      if (otherDate === null) {
        return;
      }
      
      const otherDateValue = otherDate.getValue();
      if (otherDateValue === null) {
        return;
      }
      
      binOtherDate = XMPUtils.convertToDate(otherDateValue);
      const cal: ESObject = binGPSStamp.getCalendar();
      const year = binOtherDate.getYear();
      const month = binOtherDate.getMonth();
      const day = binOtherDate.getDay();
      
      // Create a new date with the year, month, day from otherDate and time from GPS
      const newDate = new Date();
      newDate.setFullYear(year, month - 1, day); // month is 1-based in XMPDateTime but 0-based in Date
      newDate.setHours(binGPSStamp.getHour(), binGPSStamp.getMinute(), binGPSStamp.getSecond(), 
        Math.floor(binGPSStamp.getNanoSecond() / 1000000));
      
      binGPSStamp = new XMPDateTimeImpl(newDate);
      gpsDateTime.setValue(XMPUtils.convertFromDate(binGPSStamp));
    } catch (e) {
      console.error('Delete find node error', e);
      return;
    }
  }

  /**
   * Remove all empty schemas from the metadata tree that were generated during the rdf parsing.
   * @param tree the root of the metadata tree
   */
  private static deleteEmptySchemas(tree: XMPNode): void {
    // Delete empty schema nodes. Do this last, other cleanup can make empty
    // schema.

    const childrenIterator: Iterator<XMPNode> = tree.iterateChildren();
    const schemasToRemove: XMPNode[] = [];
    let schemaResult: IteratorResult<XMPNode, undefined> = childrenIterator.next();
    while (!schemaResult.done) {
      const schema: XMPNode = schemaResult.value;
      if (!schema.hasChildren()) {
        schemasToRemove.push(schema);
      }
      schemaResult = childrenIterator.next();
    }
    
    // Remove schemas that need to be deleted
    for (const schemaToRemove of schemasToRemove) {
      tree.removeChild(schemaToRemove);
    }
  }

  /**
   * The outermost call is special. The names almost certainly differ. The
   * qualifiers (and hence options) will differ for an alias to the x-default
   * item of a langAlt array.
   * 
   * @param aliasNode the alias node
   * @param baseNode the base node of the alias
   * @param outerCall marks the outer call of the recursion
   * @throws XMPException Forwards XMP errors 
   */
  private static compareAliasedSubtrees(aliasNode: XMPNode, baseNode: XMPNode,
    outerCall: boolean): void {
    const aliasValue = aliasNode.getValue();
    const baseValue = baseNode.getValue();
    
    if ((aliasValue === null ? "" : aliasValue) !== (baseValue === null ? "" : baseValue) ||
      aliasNode.getChildrenLength() !== baseNode.getChildrenLength()) {
      throw new XMPException("Mismatch between alias and base nodes", XMPError.BADXMP);
    }
    
    if (
      !outerCall &&
      (aliasNode.getName() !== baseNode.getName() ||
        !aliasNode.getOptions().equals(baseNode.getOptions()) ||
        aliasNode.getQualifierLength() !== baseNode.getQualifierLength())
    ) {
      throw new XMPException("Mismatch between alias and base nodes",
        XMPError.BADXMP);
    }
    
    const aliasChildrenIterator: Iterator<XMPNode> = aliasNode.iterateChildren();
    const baseChildrenIterator: Iterator<XMPNode> = baseNode.iterateChildren();
    let aliasChildResult: IteratorResult<XMPNode, undefined> = aliasChildrenIterator.next();
    let baseChildResult: IteratorResult<XMPNode, undefined> = baseChildrenIterator.next();
    while (!aliasChildResult.done && !baseChildResult.done) {
      const aliasChild: XMPNode = aliasChildResult.value;
      const baseChild: XMPNode = baseChildResult.value;
      XMPNormalizer.compareAliasedSubtrees(aliasChild, baseChild, false);
      aliasChildResult = aliasChildrenIterator.next();
      baseChildResult = baseChildrenIterator.next();
    }

    const aliasQualIterator: Iterator<XMPNode> = aliasNode.iterateQualifier();
    const baseQualIterator: Iterator<XMPNode> = baseNode.iterateQualifier();
    let aliasQualResult: IteratorResult<XMPNode, undefined> = aliasQualIterator.next();
    let baseQualResult: IteratorResult<XMPNode, undefined> = baseQualIterator.next();
    while (!aliasQualResult.done && !baseQualResult.done) {
      const aliasQual: XMPNode = aliasQualResult.value;
      const baseQual: XMPNode = baseQualResult.value;
      XMPNormalizer.compareAliasedSubtrees(aliasQual, baseQual, false);
      aliasQualResult = aliasQualIterator.next();
      baseQualResult = baseQualIterator.next();
    }
  }

  /**
   * The initial support for WAV files mapped a legacy ID3 audio copyright
   * into a new xmpDM:copyright property. This is special case code to migrate
   * that into dc:rights['x-default']. The rules:
   * 
   * <pre>
   * 1. If there is no dc:rights array, or an empty array -
   *    Create one with dc:rights['x-default'] set from double linefeed and xmpDM:copyright.
   * 
   * 2. If there is a dc:rights array but it has no x-default item -
   *    Create an x-default item as a copy of the first item then apply rule #3.
   * 
   * 3. If there is a dc:rights array with an x-default item, 
   *    Look for a double linefeed in the value.
   *     A. If no double linefeed, compare the x-default value to the xmpDM:copyright value.
   *         A1. If they match then leave the x-default value alone.
   *         A2. Otherwise, append a double linefeed and 
   *             the xmpDM:copyright value to the x-default value.
   *     B. If there is a double linefeed, compare the trailing text to the xmpDM:copyright value.
   *         B1. If they match then leave the x-default value alone.
   *         B2. Otherwise, replace the trailing x-default text with the xmpDM:copyright value.
   * 
   * 4. In all cases, delete the xmpDM:copyright property.
   * </pre>
   * 
   * @param xmp the metadata object 
   * @param dmCopyright the "dm:copyright"-property
   */
  private static migrateAudioCopyright(xmp: XMPMeta, dmCopyright: XMPNode): void {
    try {
      const dcSchema = XMPNodeUtils.findSchemaNode(
        (xmp as ESObject as XMPMetaImpl).getRoot(), XMPConst.NS_DC, true);
      
      if (dcSchema === null) {
        return;
      }
      
      const dmValue = dmCopyright.getValue();
      if (dmValue === null) {
        return;
      }
      
      const doubleLF = "\n\n";
      
      const dcRightsArray = XMPNodeUtils.findChildNode(dcSchema, "dc:rights", false);
      
      if (dcRightsArray === null || !dcRightsArray.hasChildren()) {
        // 1. No dc:rights array, create from double linefeed and xmpDM:copyright.
        const newValue = doubleLF + dmValue;
        xmp.setLocalizedText(XMPConst.NS_DC, "rights", "", XMPConst.X_DEFAULT, newValue, null);
      } else {
        let xdIndex = XMPNodeUtils.lookupLanguageItem(dcRightsArray, XMPConst.X_DEFAULT);
        
        if (xdIndex < 0) {
          // 2. No x-default item, create from the first item.
          const firstValue = dcRightsArray.getChild(1).getValue();
          if (firstValue !== null) {
            xmp.setLocalizedText(XMPConst.NS_DC, "rights", "", XMPConst.X_DEFAULT,
              firstValue, null);
            xdIndex = XMPNodeUtils.lookupLanguageItem(dcRightsArray, XMPConst.X_DEFAULT);
          }
        }
        
        if (xdIndex > 0) {
          // 3. Look for a double linefeed in the x-default value.
          const defaultNode = dcRightsArray.getChild(xdIndex);
          const defaultValue = defaultNode.getValue();
          if (defaultValue !== null) {
            const lfPos = defaultValue.indexOf(doubleLF);
            
            if (lfPos < 0) {
              // 3A. No double LF, compare whole values.
              if (dmValue !== defaultValue) {
                // 3A2. Append the xmpDM:copyright to the x-default
                // item.
                defaultNode.setValue(defaultValue + doubleLF + dmValue);
              }
            } else {
              // 3B. Has double LF, compare the tail.
              if (defaultValue.substring(lfPos + 2) !== dmValue) {
                // 3B2. Replace the x-default tail.
                defaultNode.setValue(defaultValue.substring(0, lfPos + 2) + dmValue);
              }
            }
          }
        }
      }
      
      // 4. Get rid of the xmpDM:copyright.
      const parent = dmCopyright.getParent();
      if (parent !== null) {
        parent.removeChild(dmCopyright);
      }
    } catch (e) {
      console.error('Migrate audio copyright error', e);
    }
  }

}
