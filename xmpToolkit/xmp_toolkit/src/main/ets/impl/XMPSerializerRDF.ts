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

import XMPException from '../XMPException';
import XMPMeta from '../XMPMeta';
import XMPMetaImpl from './XMPMetaImpl';
import XMPConst from '../XMPConst';
import XMPError from '../XMPError';
import XMPNode from './XMPNode';
import Utils from './Utils';
import QName from './QName';
import XMPMetaFactory from '../XMPMetaFactory';
import XMPNodeUtils from './XMPNodeUtils';
import SerializeOptions from '../options/SerializeOptions';
import CountOutputStream from './CountOutputStream';

/**
 * Serializes the <code>XMPMeta</code>-object using the standard RDF serialization format. 
 * The output is written to an <code>OutputStream</code> 
 * according to the <code>SerializeOptions</code>. 
 * 
 * @since   11.07.2006
 */
export default class XMPSerializerRDF {
    /** default padding */
    private static readonly DEFAULT_PAD: number = 2048;
    /** */
    private static readonly PACKET_HEADER: string = 
        "<?xpacket begin=\"\uFEFF\" id=\"W5M0MpCehiHzreSzNTczkc9d\"?>";
    /** The w/r is missing inbetween */
    private static readonly PACKET_TRAILER: string = "<?xpacket end=\"";
    /** */
    private static readonly PACKET_TRAILER2: string = "\"?>";
    /** */
    private static readonly RDF_XMPMETA_START: string = 
        "<x:xmpmeta xmlns:x=\"adobe:ns:meta/\" x:xmptk=\"";
    /** */
    private static readonly RDF_XMPMETA_END: string = "</x:xmpmeta>";
    /** */
    private static readonly RDF_RDF_START: string = 
        "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\">";
    /** */
    private static readonly RDF_RDF_END: string = "</rdf:RDF>";
    
    /** */
    private static readonly RDF_SCHEMA_START: string = "<rdf:Description rdf:about=";
    /** */
    private static readonly RDF_SCHEMA_END: string = "</rdf:Description>";
    /** */
    private static readonly RDF_STRUCT_START: string = "<rdf:Description";
    /** */
    private static readonly RDF_STRUCT_END: string = "</rdf:Description>";
    /** */
    private static readonly RDF_EMPTY_STRUCT: string = "<rdf:Description/>";
    /** a set of all rdf attribute qualifier */
    static readonly RDF_ATTR_QUALIFIER: Set<string> = new Set([
        XMPConst.XML_LANG, "rdf:resource", "rdf:ID", "rdf:bagID", "rdf:nodeID" 
    ]);
    
    /** the metadata object to be serialized. */ 
    private xmp!: XMPMetaImpl;
    /** the output stream to serialize to */ 
    private outputStream!: CountOutputStream;
    /** this writer is used to do the actual serialization */
    private writer!: ESObject; // OutputStreamWriter equivalent
    /** the stored serialization options */
    private options!: SerializeOptions;
    /** the size of one unicode char, for UTF-8 set to 1 
     *  (Note: only valid for ASCII chars lower than 0x80),
     *  set to 2 in case of UTF-16 */
    private unicodeSize: number = 1; // UTF-8
    /** the padding in the XMP Packet, or the length of the complete packet in
     *  case of option <em>exactPacketLength</em>. */ 
    private padding!: number;

    /**
     * The actual serialization.
     * 
     * @param xmp the metadata object to be serialized
     * @param out outputStream the output stream to serialize to
     * @param options the serialization options
     * 
     * @throws XMPException If case of wrong options or any other serialization error.
     */
    public async serialize(xmp: XMPMeta, out: ESObject, options: SerializeOptions): Promise<void> {
        try {
            this.outputStream = new CountOutputStream(out);
            // ArkTS中需要适配的输出流写入器
            this.writer = out; // 简化处理，实际需要根据ArkTS的流处理进行适配
            
            this.xmp = xmp as ESObject as XMPMetaImpl;
            this.options = options;
            this.padding = options.getPadding();

            await this.checkOptionsConsistence();
            
            // serializes the whole packet, but don't write the tail yet 
            // and flush to make sure that the written bytes are calculated correctly
            const tailStr: string = await this.serializeAsRDF();
            
            // adds padding
            await this.addPadding(tailStr.length);

            // writes the tail
            await this.write(tailStr);
            
            // Note: CountOutputStream doesn't have a close method in ArkTS
            // The underlying stream should be closed by the caller if needed
        } catch (e) {
            throw new XMPException("Error writing to the OutputStream", XMPError.UNKNOWN);
        }
    }

    /**
     * Calculates the padding according to the options and write it to the stream.
     * @param tailLength the length of the tail string 
     * @throws XMPException thrown if packet size is to small to fit the padding
     * @throws IOException forwards writer errors
     */
    private async addPadding(tailLength: number): Promise<void> {
        if (this.options.getExactPacketLength()) {
            // the string length is equal to the length of the UTF-8 encoding
            const minSize: number = this.outputStream.getBytesWritten() + tailLength * this.unicodeSize;
            if (minSize > this.padding) {
                throw new XMPException("Can't fit into specified packet size",
                    XMPError.BADSERIALIZE);
            }
            this.padding -= minSize;  // Now the actual amount of padding to add.
        }

        // fix rest of the padding according to Unicode unit size.
        this.padding /= this.unicodeSize;
        
        const newlineLen: number = this.options.getNewline().length;
        if (this.padding >= newlineLen) {
            this.padding -= newlineLen;  // Write this newline last.
            while (this.padding >= (100 + newlineLen)) {
                await this.writeChars(100, ' ');
                await this.writeNewline();
                this.padding -= (100 + newlineLen);
            }
            await this.writeChars(this.padding, ' ');
            await this.writeNewline();
        } else {
            await this.writeChars(this.padding, ' ');
        }
    }

    /**
     * Checks if the supplied options are consistent.
     * @throws XMPException Thrown if options are conflicting
     */
    protected async checkOptionsConsistence(): Promise<void> {
        if (this.options.getEncodeUTF16BE() || this.options.getEncodeUTF16LE()) {
            this.unicodeSize = 2;
        }

        if (this.options.getExactPacketLength()) {
            if (this.options.getOmitPacketWrapper() || this.options.getIncludeThumbnailPad()) {
                throw new XMPException("Inconsistent options for exact size serialize",
                        XMPError.BADOPTIONS);
            }
            if ((this.options.getPadding() & (this.unicodeSize - 1)) !== 0) {
                throw new XMPException("Exact size must be a multiple of the Unicode element",
                        XMPError.BADOPTIONS);
            }
        } else if (this.options.getReadOnlyPacket()) {
            if (this.options.getOmitPacketWrapper() || this.options.getIncludeThumbnailPad()) {
                throw new XMPException("Inconsistent options for read-only packet",
                        XMPError.BADOPTIONS);
            }
            this.padding = 0;
        } else if (this.options.getOmitPacketWrapper()) {
            if (this.options.getIncludeThumbnailPad()) {
                throw new XMPException("Inconsistent options for non-packet serialize",
                        XMPError.BADOPTIONS);
            }
            this.padding = 0;
        } else {
            if (this.padding === 0) {
                this.padding = XMPSerializerRDF.DEFAULT_PAD * this.unicodeSize;
            }
            
            if (this.options.getIncludeThumbnailPad()) {
                if (!this.xmp.doesPropertyExist(XMPConst.NS_XMP, "Thumbnails")) {
                    this.padding += 10000 * this.unicodeSize;
                }
            }
        }
    }

    /**
     * Writes the (optional) packet header and the outer rdf-tags. 
     * @return Returns the packet end processing instraction to be written after the padding. 
     * @throws IOException Forwarded writer exceptions.
     * @throws XMPException 
     */
    private async serializeAsRDF(): Promise<string> {
        let level: number = 0;
        
        // Write the packet header PI.
        if (!this.options.getOmitPacketWrapper()) {
            await this.writeIndent(level);
            await this.write(XMPSerializerRDF.PACKET_HEADER);
            await this.writeNewline();
        }
    
        // Write the x:xmpmeta element's start tag.
        if (!this.options.getOmitXmpMetaElement()) {
            await this.writeIndent(level);
            await this.write(XMPSerializerRDF.RDF_XMPMETA_START);
            // Note: this flag can only be set by unit tests
            if (!this.options.getOmitVersionAttribute()) {
                await this.write(XMPMetaFactory.getVersionInfo().getMessage());
            }
            await this.write('\">');
            await this.writeNewline();
            level++;
        }
    
        // Write the rdf:RDF start tag.
        await this.writeIndent(level);
        await this.write(XMPSerializerRDF.RDF_RDF_START);
        await this.writeNewline();
        
        // Write all of the properties.
        if (this.options.getUseCanonicalFormat()) {
            await this.serializeCanonicalRDFSchemas(level);
        } else {
            await this.serializeCompactRDFSchemas(level);
        }
    
        // Write the rdf:RDF end tag.
        await this.writeIndent(level);
        await this.write(XMPSerializerRDF.RDF_RDF_END);
        await this.writeNewline();
    
        // Write the xmpmeta end tag.
        if (!this.options.getOmitXmpMetaElement()) {
            level--;
            await this.writeIndent(level);        
            await this.write(XMPSerializerRDF.RDF_XMPMETA_END);
            await this.writeNewline();
        }
        // Write the packet trailer PI into the tail string as UTF-8.
        let tailStr: string = "";
        if (!this.options.getOmitPacketWrapper()) {
            for (level = this.options.getBaseIndent(); level > 0; level--) {
                tailStr += this.options.getIndent();
            }

            tailStr += XMPSerializerRDF.PACKET_TRAILER;
            tailStr += this.options.getReadOnlyPacket() ? 'r' : 'w';
            tailStr += XMPSerializerRDF.PACKET_TRAILER2;
        }
        
        return tailStr;
    }

    /**
     * Serializes the metadata in pretty-printed manner.
     * @param level indent level
     * @throws IOException Forwarded writer exceptions
     * @throws XMPException 
     */
    private async serializeCanonicalRDFSchemas(level: number): Promise<void> {
        if (this.xmp.getRoot().getChildrenLength() > 0) {
            await this.startOuterRDFDescription(this.xmp.getRoot(), level);

            const childrenIterator: Iterator<XMPNode> = this.xmp.getRoot().iterateChildren();
            let schemaResult: IteratorResult<XMPNode, undefined> = childrenIterator.next();
            while (!schemaResult.done) {
                const currSchema: XMPNode = schemaResult.value;
                await this.serializeCanonicalRDFSchema(currSchema, level);
                schemaResult = childrenIterator.next();
            }
            
            await this.endOuterRDFDescription(level);
        } else {
            await this.writeIndent(level + 1);
            await this.write(XMPSerializerRDF.RDF_SCHEMA_START); // Special case an empty XMP object.
            await this.writeTreeName();
            await this.write("/>");
            await this.writeNewline();
        }
    }

    /**
     * @throws IOException
     */
    private async writeTreeName(): Promise<void> {
        await this.write('"');
        const name: string | null = this.xmp.getRoot().getName();
        if (name !== null) {
            await this.appendNodeValue(name, true);
        }
        await this.write('"');
    }

    /**
     * Serializes the metadata in compact manner.
     * @param level indent level to start with
     * @throws IOException Forwarded writer exceptions
     * @throws XMPException 
     */
    private async serializeCompactRDFSchemas(level: number): Promise<void> {
        // Begin the rdf:Description start tag.
        await this.writeIndent(level + 1);
        await this.write(XMPSerializerRDF.RDF_SCHEMA_START);
        await this.writeTreeName();
        
        // Write all necessary xmlns attributes.
        const usedPrefixes: Set<string> = new Set();
        usedPrefixes.add("xml");
        usedPrefixes.add("rdf");

        const schemaIterator1: Iterator<XMPNode> = this.xmp.getRoot().iterateChildren();
        let schemaResult1: IteratorResult<XMPNode, undefined> = schemaIterator1.next();
        while (!schemaResult1.done) {
            const schema: XMPNode = schemaResult1.value;
            await this.declareUsedNamespaces(schema, usedPrefixes, level + 3);
            schemaResult1 = schemaIterator1.next();
        }
    
        // Write the top level "attrProps" and close the rdf:Description start tag.
        let allAreAttrs: boolean = true;
        const schemaIterator2: Iterator<XMPNode> = this.xmp.getRoot().iterateChildren();
        let schemaResult2: IteratorResult<XMPNode, undefined> = schemaIterator2.next();
        while (!schemaResult2.done) {
            const schema: XMPNode = schemaResult2.value;
            allAreAttrs = allAreAttrs && await this.serializeCompactRDFAttrProps(schema, level + 2);
            schemaResult2 = schemaIterator2.next();
        }

        if (!allAreAttrs) {
            await this.write('>');
            await this.writeNewline();
        } else {
            await this.write("/>");
            await this.writeNewline();
            return;  // ! Done if all properties in all schema are written as attributes.
        }
    
        // Write the remaining properties for each schema.
        const schemaIterator3: Iterator<XMPNode> = this.xmp.getRoot().iterateChildren();
        let schemaResult3: IteratorResult<XMPNode, undefined> = schemaIterator3.next();
        while (!schemaResult3.done) {
            const schema: XMPNode = schemaResult3.value;
            await this.serializeCompactRDFElementProps(schema, level + 2);
            schemaResult3 = schemaIterator3.next();
        }

        // Write the rdf:Description end tag.
        await this.writeIndent(level + 1);
        await this.write(XMPSerializerRDF.RDF_SCHEMA_END);
        await this.writeNewline();
    }

    /**
     * Write each of the parent's simple unqualified properties as an attribute. Returns true if all
     * of the properties are written as attributes.
     * 
     * @param parentNode the parent property node
     * @param indent the current indent level
     * @return Returns true if all properties can be rendered as RDF attribute.
     * @throws IOException
     */
    private async serializeCompactRDFAttrProps(parentNode: XMPNode, indent: number): Promise<boolean> {
        let allAreAttrs: boolean = true;
    
        const propIterator: Iterator<XMPNode> = parentNode.iterateChildren();
        let propResult: IteratorResult<XMPNode, undefined> = propIterator.next();
        while (!propResult.done) {
            const xmpProp: XMPNode = propResult.value;
            if (this.canBeRDFAttrProp(xmpProp)) {
                await this.writeNewline();
                await this.writeIndent(indent);
                const propName = xmpProp.getName();
                if (propName !== null) {
                    await this.write(propName);
                    await this.write('="');
                    const propValue = xmpProp.getValue();
                    if (propValue !== null) {
                        await this.appendNodeValue(propValue, true);
                    }
                    await this.write('"');
                }
            } else {
                allAreAttrs = false;
            }
            propResult = propIterator.next();
        }
        return allAreAttrs;
    }

    /**
     * Recursively handles the "value" for a node that must be written as an RDF
     * property element. It does not matter if it is a top level property, a
     * field of a struct, or an item of an array. The indent is that for the
     * property element. The patterns bwlow ignore attribute qualifiers such as
     * xml:lang, they don't affect the output form.
     * 
     * @param parentNode the parent node
     * @param indent the current indent level
     * @throws IOException Forwards writer exceptions
     * @throws XMPException If qualifier and element fields are mixed.
     */
    private async serializeCompactRDFElementProps(parentNode: XMPNode, indent: number): Promise<void> {
        const nodeIterator: Iterator<XMPNode> = parentNode.iterateChildren();
        let nodeResult: IteratorResult<XMPNode, undefined> = nodeIterator.next();
        while (!nodeResult.done) {
            const xmpNode: XMPNode = nodeResult.value;
            if (this.canBeRDFAttrProp(xmpNode)) {
                nodeResult = nodeIterator.next();
                continue;
            }
    
            let emitEndTag: boolean = true;
            let indentEndTag: boolean = true;
    
            // Determine the XML element name, write the name part of the start tag. Look over the
            // qualifiers to decide on "normal" versus "rdf:value" form. Emit the attribute
            // qualifiers at the same time.
            let elemName: string | null = xmpNode.getName();
            if (elemName === null) {
                elemName = "";
            }
            if (XMPConst.ARRAY_ITEM_NAME === elemName) {
                elemName = "rdf:li";
            }
    
            await this.writeIndent(indent);
            await this.write('<');
            await this.write(elemName);
    
            let hasGeneralQualifiers: boolean = false;
            let hasRDFResourceQual: boolean = false;
    
            const qualifierIterator: Iterator<XMPNode> = xmpNode.iterateQualifier();
            let qualifierResult: IteratorResult<XMPNode, undefined> = qualifierIterator.next();
            while (!qualifierResult.done) {
                const xmpQualifier: XMPNode = qualifierResult.value;
                const qualifierName = xmpQualifier.getName();
                if (qualifierName === null || !XMPSerializerRDF.RDF_ATTR_QUALIFIER.has(qualifierName)) {
                    hasGeneralQualifiers = true;
                } else {
                    hasRDFResourceQual = "rdf:resource" === qualifierName;
                    await this.write(' ');
                    await this.write(qualifierName);
                    await this.write('="');
                    const qualifierValue = xmpQualifier.getValue();
                    if (qualifierValue !== null) {
                        await this.appendNodeValue(qualifierValue, true);
                    }
                    await this.write('"');
                }
                qualifierResult = qualifierIterator.next();
            }
    
            // Process the property according to the standard patterns.
            if (hasGeneralQualifiers) {
                await this.serializeCompactRDFGeneralQualifier(indent, xmpNode);
            } else {
                // This node has only attribute qualifiers. Emit as a property element.
                if (!xmpNode.getOptions().isCompositeProperty()) {
                    const result: ESObject[] = await this.serializeCompactRDFSimpleProp(xmpNode);
                    emitEndTag = result[0];
                    indentEndTag = result[1];
                } else if (xmpNode.getOptions().isArray()) {
                    await this.serializeCompactRDFArrayProp(xmpNode, indent);
                } else {
                    emitEndTag = await this.serializeCompactRDFStructProp(
                        xmpNode, indent, hasRDFResourceQual);
                }
            }

            // Emit the property element end tag.
            if (emitEndTag) {
                if (indentEndTag) {
                    await this.writeIndent(indent);
                }
                await this.write("</");
                await this.write(elemName);
                await this.write('>');
                await this.writeNewline();
            }
            
            // Move to next node
            nodeResult = nodeIterator.next();
        }
    }

    /**
     * Serializes a simple property.
     * 
     * @param node an XMPNode 
     * @return Returns an array containing the flags emitEndTag and indentEndTag.
     * @throws IOException Forwards the writer exceptions.
     */
    private async serializeCompactRDFSimpleProp(node: XMPNode): Promise<ESObject[]> {
        // This is a simple property.
        let emitEndTag: boolean = true;
        let indentEndTag: boolean = true;

        if (node.getOptions().isURI()) {
            await this.write(" rdf:resource=\"");
            const uriValue = node.getValue();
            if (uriValue !== null) {
                await this.appendNodeValue(uriValue, true);
            }
            await this.write('"/>');
            await this.writeNewline();
            emitEndTag = false;
        } else {
            const nodeValue = node.getValue();
            if (nodeValue == null || nodeValue.length === 0) {
                await this.write("/>");
                await this.writeNewline();
                emitEndTag = false;
            } else {
                await this.write('>');
                await this.appendNodeValue(nodeValue, false);
                indentEndTag = false;
            }
        }
        
        return [emitEndTag, indentEndTag];
    }

    /**
     * Serializes an array property.
     * 
     * @param node an XMPNode 
     * @param indent the current indent level 
     * @throws IOException Forwards the writer exceptions.
     * @throws XMPException If qualifier and element fields are mixed.
     */
    private async serializeCompactRDFArrayProp(node: XMPNode, indent: number): Promise<void> {
        // This is an array.
        await this.write('>');
        await this.writeNewline();
        await this.emitRDFArrayTag(node, true, indent + 1);
        
        if (node.getOptions().isArrayAltText()) {
            XMPNodeUtils.normalizeLangArray(node);
        }
        
        await this.serializeCompactRDFElementProps(node, indent + 2);
        
        await this.emitRDFArrayTag(node, false, indent + 1);
    }

    /**
     * Serializes a struct property.
     * 
     * @param node an XMPNode 
     * @param indent the current indent level 
     * @param hasRDFResourceQual Flag if the element has resource qualifier
     * @return Returns true if an end flag shall be emitted.
     * @throws IOException Forwards the writer exceptions.
     * @throws XMPException If qualifier and element fields are mixed.
     */
    private async serializeCompactRDFStructProp(node: XMPNode, indent: number,
                                                hasRDFResourceQual: boolean): Promise<boolean> {
        // This must be a struct.
        let hasAttrFields: boolean = false;
        let hasElemFields: boolean = false;
        let emitEndTag: boolean = true;
        
        const fieldIterator: Iterator<XMPNode> = node.iterateChildren();
        let fieldResult: IteratorResult<XMPNode, undefined> = fieldIterator.next();
        while (!fieldResult.done) {
            const xmpField: XMPNode = fieldResult.value;
            if (this.canBeRDFAttrProp(xmpField)) {
                hasAttrFields = true;
            } else {
                hasElemFields = true;
            }

            if (hasAttrFields && hasElemFields) {
                break;  // No sense looking further.
            }
            fieldResult = fieldIterator.next();
        }
        
        if (hasRDFResourceQual && hasElemFields) {
            throw new XMPException(
                    "Can't mix rdf:resource qualifier and element fields",
                    XMPError.BADRDF);
        }

        if (!node.hasChildren()) {
            // Catch an empty struct as a special case. The case
            // below would emit an empty
            // XML element, which gets reparsed as a simple property
            // with an empty value.
            await this.write(" rdf:parseType=\"Resource\"/>");
            await this.writeNewline();
            emitEndTag = false;
        } else if (!hasElemFields) {
            // All fields can be attributes, use the
            // emptyPropertyElt form.
            await this.serializeCompactRDFAttrProps(node, indent + 1);
            await this.write("/>");
            await this.writeNewline();
            emitEndTag = false;
        } else if (!hasAttrFields) {
            // All fields must be elements, use the
            // parseTypeResourcePropertyElt form.
            await this.write(" rdf:parseType=\"Resource\">");
            await this.writeNewline();
            await this.serializeCompactRDFElementProps(node, indent + 1);
        } else {
            // Have a mix of attributes and elements, use an inner rdf:Description.
            await this.write('>');
            await this.writeNewline();
            await this.writeIndent(indent + 1);
            await this.write(XMPSerializerRDF.RDF_STRUCT_START);
            await this.serializeCompactRDFAttrProps(node, indent + 2);
            await this.write(">");
            await this.writeNewline();
            await this.serializeCompactRDFElementProps(node, indent + 1);
            await this.writeIndent(indent + 1);
            await this.write(XMPSerializerRDF.RDF_STRUCT_END);
            await this.writeNewline();
        }
        return emitEndTag;
    }

    /**
     * Serializes the general qualifier.  
     * @param node the root node of the subtree
     * @param indent the current indent level
     * @throws IOException Forwards all writer exceptions.
     * @throws XMPException If qualifier and element fields are mixed.
     */
    private async serializeCompactRDFGeneralQualifier(indent: number, node: XMPNode): Promise<void> {
        // The node has general qualifiers, ones that can't be
        // attributes on a property element.
        // Emit using the qualified property pseudo-struct form. The
        // value is output by a call
        // to SerializePrettyRDFProperty with emitAsRDFValue set.
        await this.write(" rdf:parseType=\"Resource\">");
        await this.writeNewline();

        await this.serializeCanonicalRDFProperty(node, false, true, indent + 1);

        const qualifierIterator: Iterator<XMPNode> = node.iterateQualifier();
        let qualifierResult: IteratorResult<XMPNode, undefined> = qualifierIterator.next();
        while (!qualifierResult.done) {
            const xmpQualifier: XMPNode = qualifierResult.value;
            await this.serializeCanonicalRDFProperty(xmpQualifier, false, false, indent + 1);
            qualifierResult = qualifierIterator.next();
        }
    }

    /**
     * Serializes one schema with all contained properties in pretty-printed
     * manner.<br> 
     * Each schema's properties are written to a single
     * rdf:Description element. All of the necessary namespaces are declared in
     * the rdf:Description element. The baseIndent is the base level for the
     * entire serialization, that of the x:xmpmeta element. An xml:lang
     * qualifier is written as an attribute of the property start tag, not by
     * itself forcing the qualified property form.
     * 
     * @param schemaNode a schema node
     * @param level 
     * @throws IOException Forwarded writer exceptions
     * @throws XMPException 
     */
    private async serializeCanonicalRDFSchema(schemaNode: XMPNode, level: number): Promise<void> {
        // Write each of the schema's actual properties.
        const propIterator: Iterator<XMPNode> = schemaNode.iterateChildren();
        let propResult: IteratorResult<XMPNode, undefined> = propIterator.next();
        while (!propResult.done) {
            const propNode: XMPNode = propResult.value;
            await this.serializeCanonicalRDFProperty(propNode, this.options.getUseCanonicalFormat(), false, level + 2);
            propResult = propIterator.next();
        }
    }

    /** 
     * Writes all used namespaces of the subtree in node to the output. 
     * The subtree is recursivly traversed.
     * @param node the root node of the subtree
     * @param usedPrefixes a set containing currently used prefixes
     * @param indent the current indent level
     * @throws IOException Forwards all writer exceptions.
     */
    private async declareUsedNamespaces(node: XMPNode, usedPrefixes: Set<string>,
                                        indent: number): Promise<void> {
        if (node.getOptions().isSchemaNode()) {
            // The schema node name is the URI, the value is the prefix.
            const prefix: string = node.getValue()!.substring(0, node.getValue()!.length - 1);
            await this.declareNamespace(prefix, node.getName()!, usedPrefixes, indent);
        } else if (node.getOptions().isStruct()) {
            const fieldIterator: Iterator<XMPNode> = node.iterateChildren();
            let fieldResult: IteratorResult<XMPNode, undefined> = fieldIterator.next();
            while (!fieldResult.done) {
                const field: XMPNode = fieldResult.value;
                const fieldName = field.getName();
                if (fieldName !== null) {
                    await this.declareNamespace(fieldName, null, usedPrefixes, indent);
                }
                fieldResult = fieldIterator.next();
            }
        }
    
        const childIterator: Iterator<XMPNode> = node.iterateChildren();
        let childResult: IteratorResult<XMPNode, undefined> = childIterator.next();
        while (!childResult.done) {
            const child: XMPNode = childResult.value;
            await this.declareUsedNamespaces(child, usedPrefixes, indent);
            childResult = childIterator.next();
        }

        const qualifierIterator: Iterator<XMPNode> = node.iterateQualifier();
        let qualifierResult: IteratorResult<XMPNode, undefined> = qualifierIterator.next();
        while (!qualifierResult.done) {
            const qualifier: XMPNode = qualifierResult.value;
            const qualifierName = qualifier.getName();
            if (qualifierName !== null) {
                await this.declareNamespace(qualifierName, null, usedPrefixes, indent);
            }
            await this.declareUsedNamespaces(qualifier, usedPrefixes, indent);
            qualifierResult = qualifierIterator.next();
        }
    }

    /**
     * Writes one namespace declaration to the output.
     * @param prefix a namespace prefix (without colon) or a complete qname (when namespace == null)
     * @param namespace the a namespace
     * @param usedPrefixes a set containing currently used prefixes
     * @param indent the current indent level
     * @throws IOException Forwards all writer exceptions.
     */
    private async declareNamespace(prefix: string, namespace: string | null, usedPrefixes: Set<string>,
                                   indent: number): Promise<void> {
        if (namespace === null) {
            // prefix contains qname, extract prefix and lookup namespace with prefix
            const qname: QName = new QName(prefix);
            if (qname.hasPrefix()) {
                prefix = qname.getPrefix();
                // add colon for lookup
                const foundNamespace: string | null = XMPMetaFactory.getSchemaRegistry().getNamespaceURI(prefix + ":");
                // prefix w/o colon
                if (foundNamespace !== null) {
                    await this.declareNamespace(prefix, foundNamespace, usedPrefixes, indent);
                }
            }
            return;
        }
        
        if (!usedPrefixes.has(prefix)) {
            await this.writeNewline();
            await this.writeIndent(indent);
            await this.write("xmlns:");
            await this.write(prefix);
            await this.write("=\"");
            await this.write(namespace);
            await this.write('"');
            usedPrefixes.add(prefix);
        }
    }

    /**
     * Start the outer rdf:Description element, including all needed xmlns attributes.
     * Leave the element open so that the compact form can add property attributes.
     * 
     * @throws IOException If the writing to  
     */
    private async startOuterRDFDescription(schemaNode: XMPNode, level: number): Promise<void> {
        await this.writeIndent(level + 1);
        await this.write(XMPSerializerRDF.RDF_SCHEMA_START);
        await this.writeTreeName();
        
        const usedPrefixes: Set<string> = new Set();
        usedPrefixes.add("xml");
        usedPrefixes.add("rdf");

        await this.declareUsedNamespaces(schemaNode, usedPrefixes, level + 3);
    
        await this.write('>');
        await this.writeNewline();
    }

    /**
     *  Write the </rdf:Description> end tag.
     */
    private async endOuterRDFDescription(level: number): Promise<void> {
        await this.writeIndent(level + 1);
        await this.write(XMPSerializerRDF.RDF_SCHEMA_END);
        await this.writeNewline();
    }

    /**
     * Recursively handles the "value" for a node. It does not matter if it is a
     * top level property, a field of a struct, or an item of an array. The
     * indent is that for the property element. An xml:lang qualifier is written
     * as an attribute of the property start tag, not by itself forcing the
     * qualified property form. The patterns below mostly ignore attribute
     * qualifiers like xml:lang. Except for the one struct case, attribute
     * qualifiers don't affect the output form.
     * 
     * @param node the property node
     * @param emitAsRDFValue property shall be rendered as attribute rather than tag
     * @param useCanonicalRDF use canonical form with inner description tag or 
     * 		  the compact form with rdf:ParseType=\"resource\" attribute.
     * @param indent the current indent level
     * @throws IOException Forwards all writer exceptions.
     * @throws XMPException If \"rdf:resource\" and general qualifiers are mixed.
     */
    private async serializeCanonicalRDFProperty(
        node: XMPNode, 
        useCanonicalRDF: boolean, 
        emitAsRDFValue: boolean, 
        indent: number
    ): Promise<void> {
        let emitEndTag: boolean = true;
        let indentEndTag: boolean = true;
    
        // Determine the XML element name. Open the start tag with the name and
        // attribute qualifiers.
        
        let elemName: string | null = node.getName();
        if (elemName === null) {
            elemName = "";
        }
        if (emitAsRDFValue) {
            elemName = "rdf:value";
        } else if (XMPConst.ARRAY_ITEM_NAME === elemName) {
            elemName = "rdf:li";
        }
    
        await this.writeIndent(indent);
        await this.write('<');
        await this.write(elemName);
        
        let hasGeneralQualifiers: boolean = false;
        let hasRDFResourceQual: boolean = false;
        
        const qualifierIterator3: Iterator<XMPNode> = node.iterateQualifier();
        let qualifierResult3: IteratorResult<XMPNode, undefined> = qualifierIterator3.next();
        while (!qualifierResult3.done) {
            const xmpQualifier: XMPNode = qualifierResult3.value;
            if (!XMPSerializerRDF.RDF_ATTR_QUALIFIER.has(xmpQualifier.getName()!)) {
                hasGeneralQualifiers = true;
            } else {
                hasRDFResourceQual = "rdf:resource" === xmpQualifier.getName();
                if (!emitAsRDFValue) {
                    const qualifierName2 = xmpQualifier.getName();
                    if (qualifierName2 !== null) {
                        await this.write(' ');
                        await this.write(qualifierName2);
                        await this.write('="');
                        const qualifierValue2 = xmpQualifier.getValue();
                        if (qualifierValue2 !== null) {
                            await this.appendNodeValue(qualifierValue2, true);
                        }
                        await this.write('"');
                    }
                }
            }
            qualifierResult3 = qualifierIterator3.next();
        }
        
        // Process the property according to the standard patterns.
        
        if (hasGeneralQualifiers && !emitAsRDFValue) {
            // This node has general, non-attribute, qualifiers. Emit using the
            // qualified property form.
            // ! The value is output by a recursive call ON THE SAME NODE with
            // emitAsRDFValue set.

            if (hasRDFResourceQual) {
                throw new XMPException("Can't mix rdf:resource and general qualifiers",
                        XMPError.BADRDF);
            }
            
            // Change serialization to canonical format with inner rdf:Description-tag
            // depending on option
            if (useCanonicalRDF) {
                await this.write(">");
                await this.writeNewline();
        
                indent++;
                await this.writeIndent(indent);
                await this.write(XMPSerializerRDF.RDF_STRUCT_START);
                await this.write(">");
            } else {
                await this.write(" rdf:parseType=\"Resource\">");
            }
            await this.writeNewline();
            
            await this.serializeCanonicalRDFProperty(node, useCanonicalRDF, true, indent + 1);

            const qualifierIterator2: Iterator<XMPNode> = node.iterateQualifier();
            let qualifierResult2: IteratorResult<XMPNode, undefined> = qualifierIterator2.next();
            while (!qualifierResult2.done) {
                const xmpQualifier: XMPNode = qualifierResult2.value;
                if (!XMPSerializerRDF.RDF_ATTR_QUALIFIER.has(xmpQualifier.getName()!)) {
                    await this.serializeCanonicalRDFProperty(xmpQualifier, useCanonicalRDF, false, indent + 1);
                }
                qualifierResult2 = qualifierIterator2.next();
            }

            if (useCanonicalRDF) {
                await this.writeIndent(indent);
                await this.write(XMPSerializerRDF.RDF_STRUCT_END);
                await this.writeNewline();
                indent--;
            }
        } else {
            // This node has no general qualifiers. Emit using an unqualified form.
            
            if (!node.getOptions().isCompositeProperty()) {
                // This is a simple property.
                
                if (node.getOptions().isURI()) {
                    await this.write(" rdf:resource=\"");
                    const uriValue2 = node.getValue();
                    if (uriValue2 !== null) {
                        await this.appendNodeValue(uriValue2, true);
                    }
                    await this.write('"/>');
                    await this.writeNewline();
                    emitEndTag = false;
                } else {
                    const nodeValue2 = node.getValue();
                    if (nodeValue2 === null || "" === nodeValue2) {
                        await this.write("/>");
                        await this.writeNewline();
                        emitEndTag = false;
                    } else {
                        await this.write('>');
                        await this.appendNodeValue(nodeValue2, false);
                        indentEndTag = false;
                    }
                }
            } else if (node.getOptions().isArray()) {
                // This is an array.
                await this.write('>');
                await this.writeNewline();
                await this.emitRDFArrayTag(node, true, indent + 1);
                if (node.getOptions().isArrayAltText()) {
                    XMPNodeUtils.normalizeLangArray(node);
                }
                const childIterator1: Iterator<XMPNode> = node.iterateChildren();
                let childResult1: IteratorResult<XMPNode, undefined> = childIterator1.next();
                while (!childResult1.done) {
                    const child: XMPNode = childResult1.value;
                    await this.serializeCanonicalRDFProperty(child, useCanonicalRDF, false, indent + 2);
                    childResult1 = childIterator1.next();
                }
                await this.emitRDFArrayTag(node, false, indent + 1);
            } else if (!hasRDFResourceQual) {
                // This is a "normal" struct, use the rdf:parseType="Resource" form.
                if (!node.hasChildren()) {
                    // Change serialization to canonical format with inner rdf:Description-tag
                    // if option is set
                    if (useCanonicalRDF) {
                        await this.write(">");
                        await this.writeNewline();
                        await this.writeIndent(indent + 1);
                        await this.write(XMPSerializerRDF.RDF_EMPTY_STRUCT);
                    } else {
                        await this.write(" rdf:parseType=\"Resource\"/>");
                        emitEndTag = false;
                    }
                    await this.writeNewline();
                } else {
                    // Change serialization to canonical format with inner rdf:Description-tag
                    // if option is set
                    if (useCanonicalRDF) {
                        await this.write(">");
                        await this.writeNewline();
                        indent++;
                        await this.writeIndent(indent);
                        await this.write(XMPSerializerRDF.RDF_STRUCT_START);
                        await this.write(">");
                    } else {
                        await this.write(" rdf:parseType=\"Resource\">");
                    }
                    await this.writeNewline();
                    
                    const childIterator2: Iterator<XMPNode> = node.iterateChildren();
                    let childResult2: IteratorResult<XMPNode, undefined> = childIterator2.next();
                    while (!childResult2.done) {
                        const child: XMPNode = childResult2.value;
                        await this.serializeCanonicalRDFProperty(child, useCanonicalRDF, false, indent + 1);
                        childResult2 = childIterator2.next();
                    }
                    
                    if (useCanonicalRDF) {
                        await this.writeIndent(indent);
                        await this.write(XMPSerializerRDF.RDF_STRUCT_END);
                        await this.writeNewline();
                        indent--;
                    }
                }
            } else {
                // This is a struct with an rdf:resource attribute, use the
                // "empty property element" form.
                const childIterator3: Iterator<XMPNode> = node.iterateChildren();
                let childResult3: IteratorResult<XMPNode, undefined> = childIterator3.next();
                while (!childResult3.done) {
                    const xmpChild: XMPNode = childResult3.value;
                    if (!this.canBeRDFAttrProp(xmpChild)) {
                        throw new XMPException("Can't mix rdf:resource and complex fields",
                                XMPError.BADRDF);
                    }
                    const childName = xmpChild.getName();
                    if (childName !== null) {
                        await this.writeNewline();
                        await this.writeIndent(indent + 1);
                        await this.write(' ');
                        await this.write(childName);
                        await this.write('="');
                        const childValue = xmpChild.getValue();
                        if (childValue !== null) {
                            await this.appendNodeValue(childValue, true);
                        }
                        await this.write('"');
                    }
                    childResult3 = childIterator3.next();
                }
                await this.write("/>");
                await this.writeNewline();
                emitEndTag = false;
            }
        }
        
        // Emit the property element end tag.
        if (emitEndTag) {
            if (indentEndTag) {
                await this.writeIndent(indent);
            }
            await this.write("</");
            await this.write(elemName);
            await this.write('>');
            await this.writeNewline();
        }
    }

    /**
     * Writes the array start and end tags.
     *  
     * @param arrayNode an array node
     * @param isStartTag flag if its the start or end tag
     * @param indent the current indent level
     * @throws IOException forwards writer exceptions
     */
    private async emitRDFArrayTag(arrayNode: XMPNode, isStartTag: boolean, indent: number): Promise<void> {
        if (isStartTag || arrayNode.hasChildren()) {
            await this.writeIndent(indent);
            await this.write(isStartTag ? "<rdf:" : "</rdf:");
        
            if (arrayNode.getOptions().isArrayAlternate()) {
                await this.write("Alt");
            } else if (arrayNode.getOptions().isArrayOrdered()) {
                await this.write("Seq");
            } else {
                await this.write("Bag");
            }
        
            if (isStartTag && !arrayNode.hasChildren()) {
                await this.write("/>");
            } else {
                await this.write('>');
            }
            
            await this.writeNewline();
        }
    }

    /**
     * Serializes the node value in XML encoding. Its used for tag bodies and
     * attributes. <em>Note:</em> The attribute is always limited by quotes,
     * thats why <code>&amp;apos;</code> is never serialized. <em>Note:</em>
     * Control chars are written unescaped, but if the user uses others than tab, LF
     * and CR the resulting XML will become invalid.
     * 
     * @param value the value of the node
     * @param forAttribute flag if value is an attribute value
     * @throws IOException
     */
    private async appendNodeValue(value: string, forAttribute: boolean): Promise<void> {
        if (value == null) {
            value = "";
        }
        await this.write(Utils.escapeXML(value, forAttribute, true));
    }

    /**
     * A node can be serialized as RDF-Attribute, if it meets the following conditions:
     * <ul>
     *  	<li>is not array item
     * 		<li>don't has qualifier
     * 		<li>is no URI
     * 		<li>is no composite property
     * </ul> 
     * 
     * @param node an XMPNode
     * @return Returns true if the node serialized as RDF-Attribute
     */
    private canBeRDFAttrProp(node: XMPNode): boolean {
        return !node.hasQualifier() &&
               !node.getOptions().isURI() &&
               !node.getOptions().isCompositeProperty() &&
               XMPConst.ARRAY_ITEM_NAME !== node.getName();
    }

    /**
     * Writes indents and automatically includes the baseindend from the options. 
     * @param times number of indents to write
     * @throws IOException forwards exception
     */
    private async writeIndent(times: number): Promise<void> {
        const totalIndents = this.options.getBaseIndent() + times;
        if (totalIndents > 0) {
            // Write all indents at once for better performance
            await this.writer.write(this.options.getIndent().repeat(totalIndents));
        }
    }

    /**
     * Writes a char to the output.
     * @param c a char
     * @throws IOException forwards writer exceptions
     */
    private async write(c: string | number): Promise<void> {
        await this.writer.write(c.toString());
    }

    /**
     * Writes an amount of chars, mostly spaces
     * @param number number of chars
     * @param c a char
     * @throws IOException
     */
    private async writeChars(count: number, c: string): Promise<void> {
        // Write all chars at once instead of one by one for better performance
        if (count > 0) {
            await this.writer.write(c.repeat(count));
        }
    }

    /**
     * Writes a newline according to the options.
     * @throws IOException Forwards exception
     */
    private async writeNewline(): Promise<void> {
        await this.writer.write(this.options.getNewline());
    }
}