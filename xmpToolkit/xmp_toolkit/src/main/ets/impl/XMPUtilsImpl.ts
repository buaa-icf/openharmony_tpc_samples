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

import XMPNodeUtils from './XMPNodeUtils';
import Utils from './Utils';
import ParameterAsserts from './ParameterAsserts';
import XMPPathParser from './xpath/XMPPathParser';
import XMPPath from './xpath/XMPPath';
import XMPMetaImpl from './XMPMetaImpl';
import XMPConst from '../XMPConst';
import XMPMeta from '../XMPMeta';
import XMPException from '../XMPException';
import XMPError from '../XMPError';
import XMPNode from './XMPNode';
import PropertyOptions from '../options/PropertyOptions';
import XMPMetaFactory from '../XMPMetaFactory';

/**
 * Implementation of <code>XMPUtils</code>. For documentation see the interface.
 */
export class XMPUtilsImpl extends  XMPConst {
    // 字符分类常量
    private static readonly UCK_NORMAL = 0;
    private static readonly UCK_SPACE = 1;
    private static readonly UCK_COMMA = 2;
    private static readonly UCK_SEMICOLON = 3;
    private static readonly UCK_QUOTE = 4;
    private static readonly UCK_CONTROL = 5;

    /**
     * @see XMPUtils#catenateArrayItems(XMPMeta, String, String, String, String, boolean)
     * @param xmp The XMP object containing the array to be catenated.
     * @param schemaNS The schema namespace URI for the array.
     * @param arrayName The name of the array.
     * @param separator The string to be used to separate the items in the catenated string.
     * @param quotes The characters to be used as quotes around array items that contain a separator.
     * @param allowCommas Option flag to control the catenation.
     * @return Returns the string containing the catenated array items.
     * @throws XMPException Forwards the Exceptions from the metadata processing
     */
    public static catenateArrayItems(xmp: XMPMeta, schemaNS: string, arrayName: string,
            separator: string, quotes: string, allowCommas: boolean): string {
        ParameterAsserts.assertSchemaNS(schemaNS);
        ParameterAsserts.assertArrayName(arrayName);
        ParameterAsserts.assertImplementation(xmp);
        
        if (separator == null || separator.length === 0) {
            separator = "; ";
        }
        if (quotes == null || quotes.length === 0) {
            quotes = '"';
        }
        
        const xmpImpl = xmp as ESObject as XMPMetaImpl;
        const arrayNode = XMPNodeUtils.findNode(xmpImpl.getRoot(),
                                       XMPPathParser.expandXPath(schemaNS, arrayName), false, null);

        if (arrayNode == null) {
            return '';
        } else if (!arrayNode.getOptions().isArray() || arrayNode.getOptions().isArrayAlternate()) {
            throw new XMPException('Named property must be non-alternate array', XMPError.BADPARAM);
        }

        // 检查分隔符
        XMPUtilsImpl.checkSeparator(separator);
        
        // 确保引号对有效
        const openQuote = quotes.charAt(0);
        const closeQuote = XMPUtilsImpl.checkQuotes(quotes, openQuote);

        // 构建结果，为数组项添加引号，添加分隔符
        const catinatedString = new Array<string>();
        let currItem: XMPNode;

        for (let i = 1; i <= arrayNode.getChildrenLength(); i++) {
            currItem = arrayNode.getChild(i);
            if (currItem.getOptions().isCompositeProperty()) {
                throw new XMPException('Array items must be simple', XMPError.BADPARAM);
            }
            
            const str = XMPUtilsImpl.applyQuotes(currItem.getValue(), openQuote, closeQuote, allowCommas);
            catinatedString.push(str);
            if (i < arrayNode.getChildrenLength()) {
                catinatedString.push(separator);
            }
        }

        return catinatedString.join('');
    }

    /**
     * @see XMPUtils#separateArrayItems(XMPMeta, String, String, String, PropertyOptions, boolean)
     * @param xmp The XMP object containing the array to be updated.
     * @param schemaNS The schema namespace URI for the array.
     * @param arrayName The name of the array.
     * @param catedStr The string to be separated into the array items.
     * @param arrayOptions Option flags to control the separation.
     * @param preserveCommas Flag if commas shall be preserved
     * @throws XMPException Forwards the Exceptions from the metadata processing
     */
    public static separateArrayItems(xmp: XMPMeta, schemaNS: string, arrayName: string,
            catedStr: string, arrayOptions: PropertyOptions, preserveCommas: boolean): void {
        ParameterAsserts.assertSchemaNS(schemaNS);
        ParameterAsserts.assertArrayName(arrayName);
        if (catedStr == null) {
            throw new XMPException('Parameter must not be null', XMPError.BADPARAM);
        }
        ParameterAsserts.assertImplementation(xmp);
        
        const xmpImpl = xmp as ESObject as XMPMetaImpl;
        
        // Keep a zero value, has special meaning below.
        const arrayNode = XMPUtilsImpl.separateFindCreateArray(schemaNS, arrayName, arrayOptions, xmpImpl);

        if (catedStr.length === 0) {
            return;
        }

        // 提取项值，直到处理完整个输入字符串
        let itemValue: string;
        let itemStart: number, itemEnd: number;
        let nextKind: number, charKind: number = 0;
        let ch: string = '', nextChar: string = '';
        
        itemEnd = 0;
        const endPos = catedStr.length;
        
        while (itemEnd < endPos) {
            // 跳过前导空格和分隔字符
            for (itemStart = itemEnd; itemStart < endPos; itemStart++) {
                ch = catedStr.charAt(itemStart);
                charKind = XMPUtilsImpl.classifyCharacter(ch);
                if (charKind === XMPUtilsImpl.UCK_NORMAL || charKind === XMPUtilsImpl.UCK_QUOTE) {
                    break;
                }
            }
            
            if (itemStart >= endPos) {
                break;
            }
            
            if (charKind !== XMPUtilsImpl.UCK_QUOTE) {
                // 非引用值，扫描到结尾
                for (itemEnd = itemStart; itemEnd < endPos; itemEnd++) {
                    ch = catedStr.charAt(itemEnd);
                    charKind = XMPUtilsImpl.classifyCharacter(ch);
                    
                    if (charKind === XMPUtilsImpl.UCK_NORMAL || charKind === XMPUtilsImpl.UCK_QUOTE ||
                        (charKind === XMPUtilsImpl.UCK_COMMA && preserveCommas)) {
                        continue;
                    } else if (charKind !== XMPUtilsImpl.UCK_SPACE) {
                        break;
                    } else if ((itemEnd + 1) < endPos) {
                        ch = catedStr.charAt(itemEnd + 1);
                        nextKind = XMPUtilsImpl.classifyCharacter(ch);
                        if (nextKind === XMPUtilsImpl.UCK_NORMAL || nextKind === XMPUtilsImpl.UCK_QUOTE ||
                            (nextKind === XMPUtilsImpl.UCK_COMMA && preserveCommas)) {
                            continue;
                        }
                    }
                    
                    // 多重空格或空格后跟分隔符
                    break;
                }
                itemValue = catedStr.substring(itemStart, itemEnd);
            } else {
                // 处理引用值
                const openQuote = ch;
                const closeQuote = XMPUtilsImpl.getClosingQuote(openQuote);
                
                itemStart++;
                itemValue = '';
                
                for (itemEnd = itemStart; itemEnd < endPos; itemEnd++) {
                    ch = catedStr.charAt(itemEnd);
                    charKind = XMPUtilsImpl.classifyCharacter(ch);
                    
                    if (charKind !== XMPUtilsImpl.UCK_QUOTE ||
                                 !XMPUtilsImpl.isSurroundingQuote(ch, openQuote, closeQuote)) {
                        // 非匹配引号，直接添加
                        itemValue += ch;
                    } else {
                        // 匹配引号，检查是否为双引号
                        if ((itemEnd + 1) < endPos) {
                            nextChar = catedStr.charAt(itemEnd + 1);
                            nextKind = XMPUtilsImpl.classifyCharacter(nextChar);
                        } else {
                            nextKind = XMPUtilsImpl.UCK_SEMICOLON;
                            nextChar = String.fromCharCode(0x3B);
                        }
                        
                        if (ch === nextChar) {
                            // 双引号，复制一个并跳过第二个
                            itemValue += ch;
                            itemEnd++;
                        } else if (!XMPUtilsImpl.isClosingingQuote(ch, openQuote, closeQuote)) {
                            // 非闭合引号，复制
                            itemValue += ch;
                        } else {
                            // 闭合引号，跳过并退出循环
                            itemEnd++;
                            break;
                        }
                    }
                }
            }

            // Add the separated item to the array. 
            // Keep a matching old value in case it had separators.
            let foundIndex = -1;
            for (let oldChild = 1; oldChild <= arrayNode.getChildrenLength(); oldChild++) {
                const oldChildValue = arrayNode.getChild(oldChild).getValue();
                if (itemValue === oldChildValue) {
                    foundIndex = oldChild;
                    break;
                }
            }

            if (foundIndex < 0) {
                const newItem = new XMPNode(XMPConst.ARRAY_ITEM_NAME, itemValue, null, null);
                arrayNode.addChild(newItem);
            }
        }
    }

    /**
     * @see XMPUtils#removeProperties(XMPMeta, String, String, boolean, boolean)
     * 
     * @param xmp
     *            The XMP object containing the properties to be removed.
     * 
     * @param schemaNS
     *            Optional schema namespace URI for the properties to be
     *            removed.
     * 
     * @param propName
     *            Optional path expression for the property to be removed.
     * 
     * @param doAllProperties
     *            Option flag to control the deletion: do internal properties in
     *            addition to external properties.
     * @param includeAliases
     *            Option flag to control the deletion: Include aliases in the
     *            "named schema" case above.
     * @throws XMPException If metadata processing fails
     */
    public static removeProperties(xmp: XMPMeta, schemaNS: string | null, propName: string | null,
                                    doAllProperties: boolean, includeAliases: boolean): void {
        ParameterAsserts.assertImplementation(xmp);
        const xmpImpl = xmp as ESObject as XMPMetaImpl;

        if (propName !== null && propName.length > 0) {
            // Remove just the one indicated property. This might be an alias,
            // the named schema might not actually exist. So don't lookup the
            // schema node.

            if (schemaNS === null || schemaNS.length === 0) {
                throw new XMPException("Property name requires schema namespace", 
                    XMPError.BADPARAM);
            }

            const expPath = XMPPathParser.expandXPath(schemaNS, propName);

            const propNode = XMPNodeUtils.findNode(xmpImpl.getRoot(), expPath, false, null);
            if (propNode !== null) {
                const schemaName = expPath.getSegment(XMPPath.STEP_SCHEMA).getName();
                const rootPropName = expPath.getSegment(XMPPath.STEP_ROOT_PROP).getName();
                if (doAllProperties || !Utils.isInternalProperty(schemaName, rootPropName)) {
                    const parent = propNode.getParent();
                    if (parent !== null) {
                        parent.removeChild(propNode);
                        if (parent.getOptions().isSchemaNode() && !parent.hasChildren()) {
                            // remove empty schema node
                            const grandParent = parent.getParent();
                            if (grandParent !== null) {
                                grandParent.removeChild(parent);
                            }
                        }
                    }
                }
            }
        } else if (schemaNS !== null && schemaNS.length > 0) {
            // Remove all properties from the named schema. Optionally include
            // aliases, in which case
            // there might not be an actual schema node.

            const schemaNode = XMPNodeUtils.findSchemaNode(xmpImpl.getRoot(), schemaNS, false);
            if (schemaNode !== null) {
                if (XMPUtilsImpl.removeSchemaChildren(schemaNode, doAllProperties)) {
                    xmpImpl.getRoot().removeChild(schemaNode);
                }
            }

            if (includeAliases) {
                // We're removing the aliases also. Look them up by their
                // namespace prefix.
                // But that takes more code and the extra speed isn't worth it.
                // Lookup the XMP node
                // from the alias, to make sure the actual exists.

                const aliases = XMPMetaFactory.getSchemaRegistry().findAliases(schemaNS);
                for (let i = 0; i < aliases.length; i++) {
                    const info = aliases[i];
                    const path = XMPPathParser.expandXPath(info.getNamespace(), info.getPropName());
                    const actualProp = XMPNodeUtils.findNode(xmpImpl.getRoot(), path, false, null);
                    if (actualProp !== null) {
                        const parent = actualProp.getParent();
                        if (parent !== null) {
                            parent.removeChild(actualProp);
                        }
                    }
                }
            }
        } else {
            // Remove all appropriate properties from all schema. In this case
            // we don't have to be
            // concerned with aliases, they are handled implicitly from the
            // actual properties.
            const rootIterator: Iterator<XMPNode> = xmpImpl.getRoot().iterateChildren();
            const schemasToRemove: XMPNode[] = [];
            let schemaResult: IteratorResult<XMPNode, undefined> = rootIterator.next();
            while (!schemaResult.done) {
                const schema: XMPNode = schemaResult.value;
                if (XMPUtilsImpl.removeSchemaChildren(schema, doAllProperties)) {
                    schemasToRemove.push(schema);
                }
                schemaResult = rootIterator.next();
            }
            
            for (const schemaToRemove of schemasToRemove) {
                xmpImpl.getRoot().removeChild(schemaToRemove);
            }
        }
    }

    /**
 * @see XMPUtils#appendProperties(XMPMeta, XMPMeta, String, boolean)
 * @param sourceXMP The source XMP object to append properties from.
 * @param destXMP The destination XMP object to append properties to.
 * @param schemaNS The schema namespace URI to append properties from.
 * @param doAllProperties Flag to append all properties or just external ones.
 * @throws XMPException Forwards exceptions from the metadata processing.
 */
    public static appendProperties(source: XMPMeta, destination: XMPMeta, doAllProperties: boolean,
                                   replaceOldValues: boolean,
        deleteEmptyValues: boolean): void {
        ParameterAsserts.assertImplementation(source);
        ParameterAsserts.assertImplementation(destination);
        const sourceImpl = source as ESObject as XMPMetaImpl;
        const destImpl = destination as ESObject as XMPMetaImpl;
        
        const sourceRoot = sourceImpl.getRoot();
        const destRoot = destImpl.getRoot();
        
        const sourceSchemaIterator: Iterator<XMPNode> = sourceRoot.iterateChildren();
        let sourceSchemaResult: IteratorResult<XMPNode, undefined> = sourceSchemaIterator.next();
        while (!sourceSchemaResult.done) {
            const sourceSchema: XMPNode = sourceSchemaResult.value;
            
            // Make sure we have a destination schema node
            let destSchema = XMPNodeUtils.findSchemaNode(destRoot, sourceSchema.getName()!, false);
            let createdSchema = false;
            if (destSchema === null) {
                destSchema = new XMPNode(sourceSchema.getName(), sourceSchema.getValue(),
                    new PropertyOptions().setSchemaNode(true), sourceSchema.getOriginalPrefix());
                destRoot.addChild(destSchema);
                createdSchema = true;
            }
            
            // Process the source schema's children.
            const sourcePropIterator: Iterator<XMPNode> = sourceSchema.iterateChildren();
            let sourcePropResult: IteratorResult<XMPNode, undefined> = sourcePropIterator.next();
            while (!sourcePropResult.done) {
                const sourceProp: XMPNode = sourcePropResult.value;
                const schemaName = sourceSchema.getName();
                const propName = sourceProp.getName();
                if (doAllProperties || (schemaName !== null && propName !== null &&
                    !Utils.isInternalProperty(schemaName, propName))) {
                    XMPUtilsImpl.appendSubtree(destImpl, sourceProp, destSchema, replaceOldValues, deleteEmptyValues);
                }
                sourcePropResult = sourcePropIterator.next();
            }
            
            if (!destSchema.hasChildren() && (createdSchema || deleteEmptyValues)) {
                // Don't create an empty schema / remove empty schema.
                destRoot.removeChild(destSchema);
            }
            
            sourceSchemaResult = sourceSchemaIterator.next();
        }
    }

    // 私有辅助方法

    /**
     * Remove all schema children according to the flag
     * <code>doAllProperties</code>. Empty schemas are automatically remove
     * by <code>XMPNode</code>
     * 
     * @param schemaNode
     *            a schema node
     * @param doAllProperties
     *            flag if all properties or only externals shall be removed.
     * @return Returns true if the schema is empty after the operation.
     */
    private static removeSchemaChildren(schemaNode: XMPNode, doAllProperties: boolean): boolean {
        const childrenToRemove: XMPNode[] = [];
        const childrenIterator: Iterator<XMPNode> = schemaNode.iterateChildren();
        let childResult: IteratorResult<XMPNode, undefined> = childrenIterator.next();
        while (!childResult.done) {
            const currProp: XMPNode = childResult.value;
            const schemaName = schemaNode.getName();
            const propName = currProp.getName();
            if (doAllProperties || (schemaName !== null && propName !== null &&
                 !Utils.isInternalProperty(schemaName, propName))) {
                childrenToRemove.push(currProp);
            }
            childResult = childrenIterator.next();
        }
        
        for (const propToRemove of childrenToRemove) {
            schemaNode.removeChild(propToRemove);
        }
        
        return !schemaNode.hasChildren();
    }

    /**
     * @see XMPUtilsImpl#appendProperties(XMPMeta, XMPMeta, boolean, boolean, boolean)
     * @param destXMP The destination XMP object.
     * @param sourceNode the source node
     * @param destParent the parent of the destination node
     * @param replaceOldValues Replace the values of existing properties.
     * @param deleteEmptyValues flag if properties with empty values should be deleted 
     * 		   in the destination object.
     * @throws XMPException
     */
    private static appendSubtree(destXMP: XMPMetaImpl, sourceNode: XMPNode, destParent: XMPNode,
            replaceOldValues: boolean, deleteEmptyValues: boolean): void {
        const destNode = XMPNodeUtils.findChildNode(destParent, sourceNode.getName()!, false);

        let valueIsEmpty = false;
        if (deleteEmptyValues) {
            valueIsEmpty = sourceNode.getOptions().isSimple() ?
                sourceNode.getValue() === null || sourceNode.getValue()!.length === 0 :
                !sourceNode.hasChildren();
        }
        
        if (deleteEmptyValues && valueIsEmpty) {
            if (destNode !== null) {
                destParent.removeChild(destNode);
            }
        } else if (destNode === null) {
            // The one easy case, the destination does not exist.
            destParent.addChild(sourceNode.clone());
        } else if (replaceOldValues) {
            // The destination exists and should be replaced.
            destXMP.setNode(destNode, sourceNode.getValue(), sourceNode.getOptions(), true);
            destParent.removeChild(destNode);
            const clonedNode = sourceNode.clone();
            destParent.addChild(clonedNode);
        } else {
            // The destination exists and is not totally replaced. Structs and
            // arrays are merged.

            const sourceForm = sourceNode.getOptions();
            const destForm = destNode.getOptions();
            if (sourceForm.getOptions() !== destForm.getOptions()) {
                return;
            }
            if (sourceForm.isStruct()) {
                // To merge a struct process the fields recursively. E.g. add simple missing fields.
                // The recursive call to AppendSubtree will handle deletion for fields with empty 
                // values.
                const sourceFieldIterator: Iterator<XMPNode> = sourceNode.iterateChildren();
                let sourceFieldResult: IteratorResult<XMPNode, undefined> = sourceFieldIterator.next();
                while (!sourceFieldResult.done) {
                    const sourceField: XMPNode = sourceFieldResult.value;
                    XMPUtilsImpl.appendSubtree(destXMP, sourceField, destNode, 
                        replaceOldValues, deleteEmptyValues);
                    if (deleteEmptyValues && !destNode.hasChildren()) {
                        destParent.removeChild(destNode);
                    }
                    sourceFieldResult = sourceFieldIterator.next();
                }
            } else if (sourceForm.isArrayAltText()) {
                // Merge AltText arrays by the "xml:lang" qualifiers. Make sure x-default is first. 
                // Make a special check for deletion of empty values. Meaningful in AltText arrays 
                // because the "xml:lang" qualifier provides unambiguous source/dest correspondence.
                const sourceItemIterator: Iterator<XMPNode> = sourceNode.iterateChildren();
                let sourceItemResult: IteratorResult<XMPNode, undefined> = sourceItemIterator.next();
                while (!sourceItemResult.done) {
                    const sourceItem: XMPNode = sourceItemResult.value;
                    if (!sourceItem.hasQualifier() ||
                            XMPConst.XML_LANG !== sourceItem.getQualifier(1).getName()) {
                        sourceItemResult = sourceItemIterator.next();
                        continue;
                    }
                    
                    const langValue = sourceItem.getQualifier(1).getValue();
                    let destIndex = -1;
                    if (langValue !== null) {
                        destIndex = XMPNodeUtils.lookupLanguageItem(destNode, langValue);
                    }
                    if (deleteEmptyValues &&
                            (sourceItem.getValue() === null ||
                             sourceItem.getValue()!.length === 0)) {
                        if (destIndex !== -1) {
                            destNode.removeChild(destIndex);
                            if (!destNode.hasChildren()) {
                                destParent.removeChild(destNode);
                            }
                        }
                    } else if (destIndex === -1) {
                        // Not replacing, keep the existing item.
                        const qualValue = sourceItem.getQualifier(1).getValue();
                        if (qualValue === null || XMPConst.X_DEFAULT !== qualValue ||
                                !destNode.hasChildren()) {
                            sourceItem.cloneSubtree(destNode);
                        } else {
                            const destItem = new XMPNode(
                                sourceItem.getName(),
                                sourceItem.getValue(),
                                sourceItem.getOptions(),
                                sourceItem.getOriginalPrefix());
                            sourceItem.cloneSubtree(destItem);
                            destNode.addChild(1, destItem);
                        }
                    }
                    sourceItemResult = sourceItemIterator.next();
                }
            } else if (sourceForm.isArray()) {
                // Merge other arrays by item values. Don't worry about order or duplicates. Source 
                // items with empty values do not cause deletion, that conflicts horribly with 
                // merging.

                const sourceItemIterator2: Iterator<XMPNode> = sourceNode.iterateChildren();
                let sourceItemResult2: IteratorResult<XMPNode, undefined> = sourceItemIterator2.next();
                while (!sourceItemResult2.done) {
                    const sourceItem: XMPNode = sourceItemResult2.value;

                    let match = false;
                    const destItemIterator: Iterator<XMPNode> = destNode.iterateChildren();
                    let destItemResult: IteratorResult<XMPNode, undefined> = destItemIterator.next();
                    while (!destItemResult.done) {
                        const destItem: XMPNode = destItemResult.value;
                        if (XMPUtilsImpl.itemValuesMatch(sourceItem, destItem)) {
                            match = true;
                            break;
                        }
                        destItemResult = destItemIterator.next();
                    }
                    if (!match) {
                        const clonedSourceItem = sourceItem.clone();
                        destParent.addChild(clonedSourceItem);
                    }
                    sourceItemResult2 = sourceItemIterator2.next();
                }
            }
        }
    }

    /**
     * Compares two nodes including its children and qualifier.
     * @param leftNode an <code>XMPNode</code>
     * @param rightNode an <code>XMPNode</code>
     * @return Returns true if the nodes are equal, false otherwise.
     * @throws XMPException Forwards exceptions to the calling method.
     */
    private static itemValuesMatch(leftNode: XMPNode, rightNode: XMPNode): boolean {
        const leftForm = leftNode.getOptions();
        const rightForm = rightNode.getOptions();

        if (leftForm.getOptions() !== rightForm.getOptions()) {
            return false;
        }

        if (leftForm.getOptions() === 0) {
            // Simple nodes, check the values and xml:lang qualifiers.
            const leftValue = leftNode.getValue();
            const rightValue = rightNode.getValue();
            if (leftValue === null || rightValue === null || leftValue !== rightValue) {
                return false;
            }
            if (leftNode.getOptions().getHasLanguage() !== rightNode.getOptions().getHasLanguage()) {
                return false;
            }
            if (leftNode.getOptions().getHasLanguage()) {
                const leftQualValue = leftNode.getQualifier(1).getValue();
                const rightQualValue = rightNode.getQualifier(1).getValue();
                if (leftQualValue === null || rightQualValue === null || leftQualValue !== rightQualValue) {
                    return false;
                }
            }
        } else if (leftForm.isStruct()) {
            // Struct nodes, see if all fields match, ignoring order.

            if (leftNode.getChildrenLength() !== rightNode.getChildrenLength()) {
                return false;
            }

            const leftFieldIterator: Iterator<XMPNode> = leftNode.iterateChildren();
            let leftFieldResult: IteratorResult<XMPNode, undefined> = leftFieldIterator.next();
            while (!leftFieldResult.done) {
                const leftField: XMPNode = leftFieldResult.value;
                const rightField = XMPNodeUtils.findChildNode(rightNode, leftField.getName()!, false);
                if (rightField === null || !XMPUtilsImpl.itemValuesMatch(leftField, rightField)) {
                    return false;
                }
                leftFieldResult = leftFieldIterator.next();
            }
        } else {
            // Array nodes, see if the "leftNode" values are present in the
            // "rightNode", ignoring order, duplicates,
            // and extra values in the rightNode-> The rightNode is the
            // destination for AppendProperties.

            // assert leftForm.isArray();

            const leftItemIterator: Iterator<XMPNode> = leftNode.iterateChildren();
            let leftItemResult: IteratorResult<XMPNode, undefined> = leftItemIterator.next();
            while (!leftItemResult.done) {
                const leftItem: XMPNode = leftItemResult.value;

                let match = false;
                const rightItemIterator: Iterator<XMPNode> = rightNode.iterateChildren();
                let rightItemResult: IteratorResult<XMPNode, undefined> = rightItemIterator.next();
                while (!rightItemResult.done) {
                    const rightItem: XMPNode = rightItemResult.value;
                    if (XMPUtilsImpl.itemValuesMatch(leftItem, rightItem)) {
                        match = true;
                        break;
                    }
                    rightItemResult = rightItemIterator.next();
                }
                if (!match) {
                    return false;
                }
                leftItemResult = leftItemIterator.next();
            }
        }
        return true; // All of the checks passed.
    }

    /**
     * Make sure the separator is OK. It must be one semicolon surrounded by
     * zero or more spaces. Any of the recognized semicolons or spaces are
     * allowed.
     * 
     * @param separator
     * @throws XMPException
     */
    private static checkSeparator(separator: string): void {
        let haveSemicolon = false;
        for (let i = 0; i < separator.length; i++) {
            const charKind = XMPUtilsImpl.classifyCharacter(separator.charAt(i));
            if (charKind === XMPUtilsImpl.UCK_SEMICOLON) {
                if (haveSemicolon) {
                    throw new XMPException("Separator can have only one semicolon", 
                        XMPError.BADPARAM);
                }
                haveSemicolon = true;
            } else if (charKind !== XMPUtilsImpl.UCK_SPACE) {
                throw new XMPException("Separator can have only spaces and one semicolon",
                        XMPError.BADPARAM);
            }
        }
        if (!haveSemicolon) {
            throw new XMPException("Separator must have one semicolon", XMPError.BADPARAM);
        }
    }
    
    /**
     * Make sure the open and close quotes are a legitimate pair and return the
     * correct closing quote or an exception.
     * 
     * @param quotes
     *            opened and closing quote in a string
     * @param openQuote
     *            the open quote
     * @return Returns a corresponding closing quote.
     * @throws XMPException
     */
    private static checkQuotes(quotes: string, openQuote: string): string {
        let closeQuote: string;

        let charKind = XMPUtilsImpl.classifyCharacter(openQuote);
        if (charKind !== XMPUtilsImpl.UCK_QUOTE) {
            throw new XMPException("Invalid quoting character", XMPError.BADPARAM);
        }

        if (quotes.length === 1) {
            closeQuote = openQuote;
        } else {
            closeQuote = quotes.charAt(1);
            charKind = XMPUtilsImpl.classifyCharacter(closeQuote);
            if (charKind !== XMPUtilsImpl.UCK_QUOTE) {
                throw new XMPException("Invalid quoting character", XMPError.BADPARAM);
            }
        }

        const expectedCloseQuote = XMPUtilsImpl.getClosingQuote(openQuote);
        if (closeQuote !== expectedCloseQuote) {
            throw new XMPException("Mismatched quote pair", XMPError.BADPARAM);
        }
        return closeQuote;
    }
    
    /**
     * Classifies the character into normal chars, spaces, semicola, quotes,
     * control chars.
     * 
     * @param ch
     *            a char
     * @return Return the character kind.
     */
    private static classifyCharacter(ch: string): number {
        const code = ch.charCodeAt(0);
        if (XMPUtilsImpl.SPACES.indexOf(ch) >= 0 || (0x2000 <= code && code <= 0x200B)) {
            return XMPUtilsImpl.UCK_SPACE;
        } else if (XMPUtilsImpl.COMMAS.indexOf(ch) >= 0) {
            return XMPUtilsImpl.UCK_COMMA;
        } else if (XMPUtilsImpl.SEMICOLA.indexOf(ch) >= 0) {
            return XMPUtilsImpl.UCK_SEMICOLON;
        } else if (XMPUtilsImpl.QUOTES.indexOf(ch) >= 0 || (0x3008 <= code && code <= 0x300F) ||
                (0x2018 <= code && code <= 0x201F)) {
            return XMPUtilsImpl.UCK_QUOTE;
        } else if (code < 0x0020 || XMPUtilsImpl.CONTROLS.indexOf(ch) >= 0) {
            return XMPUtilsImpl.UCK_CONTROL;
        } else {
            // Assume typical case.
            return XMPUtilsImpl.UCK_NORMAL;
        }
    }
    
    /**
     * @param openQuote
     *            the open quote char
     * @return Returns the matching closing quote for an open quote.
     */
    private static getClosingQuote(openQuote: string): string {
        const openQuoteCode = openQuote.charCodeAt(0);
        switch (openQuoteCode) {
            case 0x0022:
                return String.fromCharCode(0x0022); // ! U+0022 is both opening and closing.
            //		Not interpreted as brackets anymore
            //		case 0x005B: 
            //			return 0x005D;
            case 0x00AB:
                return String.fromCharCode(0x00BB); // ! U+00AB and U+00BB are reversible.
            case 0x00BB:
                return String.fromCharCode(0x00AB);
            case 0x2015:
                return String.fromCharCode(0x2015); // ! U+2015 is both opening and closing.
            case 0x2018:
                return String.fromCharCode(0x2019);
            case 0x201A:
                return String.fromCharCode(0x201B);
            case 0x201C:
                return String.fromCharCode(0x201D);
            case 0x201E:
                return String.fromCharCode(0x201F);
            case 0x2039:
                return String.fromCharCode(0x203A); // ! U+2039 and U+203A are reversible.
            case 0x203A:
                return String.fromCharCode(0x2039);
            case 0x3008:
                return String.fromCharCode(0x3009);
            case 0x300A:
                return String.fromCharCode(0x300B);
            case 0x300C:
                return String.fromCharCode(0x300D);
            case 0x300E:
                return String.fromCharCode(0x300F);
            case 0x301D:
                return String.fromCharCode(0x301F); // ! U+301E also closes U+301D.
            default:
                return String.fromCharCode(0);
        }
    }

    /**
     * Add quotes to the item.
     * 
     * @param item
     *            the array item
     * @param openQuote
     *            the open quote character
     * @param closeQuote
     *            the closing quote character
     * @param allowCommas
     *            flag if commas are allowed
     * @return Returns the value in quotes.
     */
    private static applyQuotes(item: string | null, openQuote: string, closeQuote: string,
            allowCommas: boolean): string {
        if (item === null) {
            item = "";
        }
        
        let prevSpace = false;
        let charOffset: number;
        let charKind: number;

        // See if there are any separators in the value. Stop at the first
        // occurrance. This is a bit
        // tricky in order to make typical typing work conveniently. The purpose
        // of applying quotes
        // is to preserve the values when splitting them back apart. That is
        // CatenateContainerItems
        // and SeparateContainerItems must round trip properly. For the most
        // part we only look for
        // separators here. Internal quotes, as in -- Irving "Bud" Jones --
        // won't cause problems in
        // the separation. An initial quote will though, it will make the value
        // look quoted.

        let i: number;
        for (i = 0; i < item.length; i++) {
            const ch = item.charAt(i);
            charKind = XMPUtilsImpl.classifyCharacter(ch);
            if (i === 0 && charKind === XMPUtilsImpl.UCK_QUOTE) {
                break;
            }

            if (charKind === XMPUtilsImpl.UCK_SPACE) {
                // Multiple spaces are a separator.
                if (prevSpace) {
                    break;
                }
                prevSpace = true;
            } else {
                prevSpace = false;
                if ((charKind === XMPUtilsImpl.UCK_SEMICOLON || charKind === XMPUtilsImpl.UCK_CONTROL) ||
                        (charKind === XMPUtilsImpl.UCK_COMMA && !allowCommas)) {
                    break;
                }
            }
        }

        if (i < item.length) {
            // Create a quoted copy, doubling any internal quotes that match the
            // outer ones. Internal quotes did not stop the "needs quoting"
            // search, but they do need
            // doubling. So we have to rescan the front of the string for
            // quotes. Handle the special
            // case of U+301D being closed by either U+301E or U+301F.

            const newItem: string[] = [];
            let splitPoint: number;
            for (splitPoint = 0; splitPoint <= i; splitPoint++) {
                if (XMPUtilsImpl.classifyCharacter(item.charAt(splitPoint)) === XMPUtilsImpl.UCK_QUOTE) {
                    break;
                }
            }

            // Copy the leading "normal" portion.
            newItem.push(openQuote);
            newItem.push(item.substring(0, splitPoint));

            for (charOffset = splitPoint; charOffset < item.length; charOffset++) {
                const ch = item.charAt(charOffset);
                newItem.push(ch);
                if (XMPUtilsImpl.classifyCharacter(ch) === XMPUtilsImpl.UCK_QUOTE &&
                        XMPUtilsImpl.isSurroundingQuote(ch, openQuote, closeQuote)) {
                    newItem.push(ch);
                }
            }

            newItem.push(closeQuote);

            item = newItem.join('');
        }

        return item;
    }

    /**
     * @param ch a character
     * @param openQuote the opening quote char
     * @param closeQuote the closing quote char 
     * @return Return it the character is a surrounding quote.
     */
    private static isSurroundingQuote(ch: string, openQuote: string, closeQuote: string): boolean {
        const chCode = ch.charCodeAt(0);
        const openQuoteCode = openQuote.charCodeAt(0);
        return chCode === openQuoteCode || XMPUtilsImpl.isClosingingQuote(ch, openQuote, closeQuote);
    }

    /**
     * @param ch a character
     * @param openQuote the opening quote char
     * @param closeQuote the closing quote char 
     * @return Returns true if the character is a closing quote.
     */
    private static isClosingingQuote(ch: string, openQuote: string, closeQuote: string): boolean {
        const chCode = ch.charCodeAt(0);
        const openQuoteCode = openQuote.charCodeAt(0);
        const closeQuoteCode = closeQuote.charCodeAt(0);
        return chCode === closeQuoteCode || (openQuoteCode === 0x301D && (chCode === 0x301E || chCode === 0x301F));
    }

    /**
     * Utility to find or create the array used by <code>separateArrayItems()</code>.
     * @param schemaNS a the namespace fo the array
     * @param arrayName the name of the array 
     * @param arrayOptions the options for the array if newly created
     * @param xmp the xmp object
     * @return Returns the array node.
     * @throws XMPException Forwards exceptions
     */
    private static separateFindCreateArray(schemaNS: string, arrayName: string,
            arrayOptions: PropertyOptions, xmp: XMPMetaImpl): XMPNode {
        arrayOptions = XMPNodeUtils.verifySetOptions(arrayOptions, null);
        if (!arrayOptions.isOnlyArrayOptions()) {
            throw new XMPException("Options can only provide array form", XMPError.BADOPTIONS);
        }

        // Find the array node, make sure it is OK. Move the current children
        // aside, to be readded later if kept.
        const arrayPath = XMPPathParser.expandXPath(schemaNS, arrayName);
        let arrayNode = XMPNodeUtils.findNode(xmp.getRoot(), arrayPath, false, null);
        if (arrayNode !== null) {
            // The array exists, make sure the form is compatible. Zero
            // arrayForm means take what exists.
            const arrayForm = arrayNode.getOptions();
            if (!arrayForm.isArray() || arrayForm.isArrayAlternate()) {
                throw new XMPException("Named property must be non-alternate array", 
                    XMPError.BADXPATH);
            }
            if (arrayOptions.equalArrayTypes(arrayForm)) {
                throw new XMPException("Mismatch of specified and existing array form",
                        XMPError.BADXPATH); // *** Right error?
            }
        } else {
            // The array does not exist, try to create it.
            // don't modify the options handed into the method
            const newOptions = new PropertyOptions(arrayOptions.getOptions());
            newOptions.setArray(true);
            arrayNode = XMPNodeUtils.findNode(xmp.getRoot(), arrayPath, true, newOptions);
            if (arrayNode === null) {
                throw new XMPException("Failed to create named array", XMPError.BADXPATH);
            }
        }
        return arrayNode;
    }

    /**
     * U+0022 ASCII space<br>
     * U+3000, ideographic space<br>
     * U+303F, ideographic half fill space<br>
     * U+2000..U+200B, en quad through zero width space
     */
    private static readonly SPACES = "\u0020\u3000\u303F";
    /**
     * U+002C, ASCII comma<br>
     * U+FF0C, full width comma<br>
     * U+FF64, half width ideographic comma<br>
     * U+FE50, small comma<br>
     * U+FE51, small ideographic comma<br>
     * U+3001, ideographic comma<br>
     * U+060C, Arabic comma<br>
     * U+055D, Armenian comma
     */
    private static readonly COMMAS = "\u002C\uFF0C\uFF64\uFE50\uFE51\u3001\u060C\u055D";
    /**
     * U+003B, ASCII semicolon<br>
     * U+FF1B, full width semicolon<br>
     * U+FE54, small semicolon<br>
     * U+061B, Arabic semicolon<br>
     * U+037E, Greek "semicolon" (really a question mark)
     */
    private static readonly SEMICOLA = "\u003B\uFF1B\uFE54\u061B\u037E";
    /**
     * U+0022 ASCII quote<br>
     * The square brackets are not interpreted as quotes anymore (bug #2674672)
     * (ASCII '[' (0x5B) and ']' (0x5D) are used as quotes in Chinese and
     * Korean.)<br>
     * U+00AB and U+00BB, guillemet quotes<br>
     * U+3008..U+300F, various quotes.<br>
     * U+301D..U+301F, double prime quotes.<br>
     * U+2015, dash quote.<br>
     * U+2018..U+201F, various quotes.<br>
     * U+2039 and U+203A, guillemet quotes.
     */
    private static readonly QUOTES = 
        "\"\u00AB\u00BB\u301D\u301E\u301F\u2015\u2039\u203A";
        // "\"\u005B\u005D\u00AB\u00BB\u301D\u301E\u301F\u2015\u2039\u203A";
    /**
     * U+0000..U+001F ASCII controls<br>
     * U+2028, line separator.<br>
     * U+2029, paragraph separator.
     */
    private static readonly CONTROLS = "\u2028\u2029";
}