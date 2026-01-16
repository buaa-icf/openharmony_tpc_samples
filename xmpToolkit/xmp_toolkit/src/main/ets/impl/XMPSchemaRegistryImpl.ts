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
import XMPSchemaRegistry from '../XMPSchemaRegistry';
import  AliasOptions from '../options/AliasOptions';
import XMPAliasInfo from '../properties/XMPAliasInfo';
import ParameterAsserts from './ParameterAsserts';
import Utils from './Utils';
import XMPNodeUtile from './XMPNodeUtils';
import XMPNodeUtils from './XMPNodeUtils';

/**
 * Schema注册表处理XMP工具包的命名空间、别名和全局选项。
 * 工具包中只使用一个单一实例。
 */
export class XMPSchemaRegistryImpl extends XMPConst implements XMPSchemaRegistry {
    /** 从命名空间URI到已注册前缀的映射 */
    private namespaceToPrefixMap: Map<string, string> = new Map();

    /** 从前缀到关联命名空间URI的映射 */
    private prefixToNamespaceMap: Map<string, string> = new Map();

    /** 所有已注册别名的映射。
     * 该映射是从qname到XMPAliasInfo对象的关系。 */
    private aliasMap: Map<string, XMPAliasInfo> = new Map();
    
    /** 简单属性中不能包含的模式 */
    private p: RegExp = /[/*?\[\]]/;

    /**
     * 初始化注册表，添加默认命名空间、别名和全局选项
     */
    constructor() {
        super();
        try {
            this.registerStandardNamespaces();
            this.registerStandardAliases();
        } catch (e) {
            throw new Error("The XMPSchemaRegistry cannot be initialized!");
        }
    }

    // ---------------------------------------------------------------------------------------------  
    // 命名空间函数

    /**
     * 注册命名空间
     * @param namespaceURI 命名空间URI
     * @param suggestedPrefix 建议的前缀
     * @return 返回实际注册的前缀
     * @throws XMPException 参数无效时抛出
     */
    public registerNamespace(namespaceURI: string, suggestedPrefix: string): string {
        ParameterAsserts.assertSchemaNS(namespaceURI);
        ParameterAsserts.assertPrefix(suggestedPrefix);

        if (suggestedPrefix.charAt(suggestedPrefix.length - 1) !== ':') {
            suggestedPrefix += ':';
        }

        if (!Utils.isXMLNameNS(suggestedPrefix.substring(0, suggestedPrefix.length - 1))) {
            throw new XMPException("The prefix is a bad XML name", XMPError.BADXML);
        }

        const registeredPrefix: string | null = this.namespaceToPrefixMap.get(namespaceURI) ?? null;
        const registeredNS: string | null = this.prefixToNamespaceMap.get(suggestedPrefix) ?? null;
        
        if (registeredPrefix !== null) {
            // 返回实际的前缀
            return registeredPrefix;
        } else {
            if (registeredNS !== null) {
                // 命名空间是新的，但前缀已被占用，
                // 我们从建议的前缀生成一个新前缀
                let generatedPrefix: string = suggestedPrefix;
                for (let i: number = 1; this.prefixToNamespaceMap.has(generatedPrefix); i++) {
                    generatedPrefix = suggestedPrefix
                            .substring(0, suggestedPrefix.length - 1)
                            + "_" + i + ":";
                }
                suggestedPrefix = generatedPrefix;
            }
            
            this.prefixToNamespaceMap.set(suggestedPrefix, namespaceURI);
            this.namespaceToPrefixMap.set(namespaceURI, suggestedPrefix);

            // 返回建议的前缀
            return suggestedPrefix;
        }
    }

    /**
     * 根据命名空间URI删除所有相关的别名
     * @param namespaceURI 要删除的命名空间URI
     */
    private deleteAliasesByNamespace(namespaceURI: string): void {
        // 创建一个数组来存储需要删除的键
        const keysToDelete: string[] = [];

        // 遍历aliasMap，找出所有属于该命名空间的别名
        for (const [key, aliasInfo] of this.aliasMap.entries()) {
            if (aliasInfo.getNamespace() === namespaceURI) {
                keysToDelete.push(key);
            }
        }

        // 删除所有找到的别名
        for (const key of keysToDelete) {
            this.aliasMap.delete(key);
        }
    }

    /**
     * 删除命名空间
     * @param namespaceURI 要删除的命名空间URI
     */
    public deleteNamespace(namespaceURI: string): void {
        const prefixToDelete: string | null = this.getNamespacePrefix(namespaceURI);
        if (prefixToDelete !== null) {
            this.namespaceToPrefixMap.delete(namespaceURI);
            this.prefixToNamespaceMap.delete(prefixToDelete);
            this.deleteAliasesByNamespace(namespaceURI);
        }
    }

    /**
     * 获取命名空间前缀
     * @param namespaceURI 命名空间URI
     * @return 返回前缀，如果未注册则返回null
     */
    public getNamespacePrefix(namespaceURI: string): string | null {
        return this.namespaceToPrefixMap.get(namespaceURI) ?? null;
    }

    /**
     * 获取命名空间URI
     * @param namespacePrefix 命名空间前缀
     * @return 返回URI，如果未注册则返回null
     */
    public getNamespaceURI(namespacePrefix: string): string | null {
        if (namespacePrefix !== undefined && namespacePrefix !== null && !namespacePrefix.endsWith(":")) {
            namespacePrefix += ":";
        }
        return this.prefixToNamespaceMap.get(namespacePrefix) ?? null;
    }

    /**
     * 获取所有注册的命名空间
     * @return 返回命名空间映射
     */
    public getNamespaces(): Map<string, string> {
        // 创建一个排序后的映射
        const sortedMap: Map<string, string> = new Map();
        const entries = Array.from(this.namespaceToPrefixMap.entries());
        entries.sort((entry1, entry2) => {
            const a = entry1[0];
            const b = entry2[0];
            return a.localeCompare(b);
        });
        entries.forEach((entry) => {
            const key = entry[0];
            const value = entry[1];
            sortedMap.set(key, value);
        });
        return sortedMap;
    }

    /**
     * 获取所有注册的前缀
     * @return 返回前缀映射
     */
    public getPrefixes(): Map<string, string> {
        // 创建一个排序后的映射
        const sortedMap: Map<string, string> = new Map();
        const entries = Array.from(this.prefixToNamespaceMap.entries());
        entries.sort((entry1, entry2) => {
            const a = entry1[0];
            const b = entry2[0];
            return a.localeCompare(b);
        });
        entries.forEach((entry) => {
            const key = entry[0];
            const value = entry[1];
            sortedMap.set(key, value);
        });
        return sortedMap;
    }

    /**
     * 注册包含在XMP规范中的标准命名空间和一些其他Adobe私有命名空间
     * @throws XMPException 处理异常时抛出
     */
    private registerStandardNamespaces(): void {
        // 注册标准命名空间
        this.registerNamespace(XMPConst.NS_XML, "xml");
        this.registerNamespace(XMPConst.NS_RDF, "rdf");
        this.registerNamespace(XMPConst.NS_DC, "dc");
        this.registerNamespace(XMPConst.NS_IPTCCORE, "Iptc4xmpCore");
        this.registerNamespace(XMPConst.NS_IPTCEXT, "Iptc4xmpExt");
        this.registerNamespace(XMPConst.NS_DICOM, "DICOM");
        this.registerNamespace(XMPConst.NS_PLUS, "plus");

        // 注册Adobe标准命名空间
        this.registerNamespace(XMPConst.NS_X, "x");
        this.registerNamespace(XMPConst.NS_IX, "iX");

        this.registerNamespace(XMPConst.NS_XMP, "xmp");
        this.registerNamespace(XMPConst.NS_XMP_RIGHTS, "xmpRights");
        this.registerNamespace(XMPConst.NS_XMP_MM, "xmpMM");
        this.registerNamespace(XMPConst.NS_XMP_BJ, "xmpBJ");
        this.registerNamespace(XMPConst.NS_XMP_NOTE, "xmpNote");

        this.registerNamespace(XMPConst.NS_PDF, "pdf");
        this.registerNamespace(XMPConst.NS_PDFX, "pdfx");
        this.registerNamespace(XMPConst.NS_PDFX_ID, "pdfxid");
        this.registerNamespace(XMPConst.NS_PDFA_SCHEMA, "pdfaSchema");
        this.registerNamespace(XMPConst.NS_PDFA_PROPERTY, "pdfaProperty");
        this.registerNamespace(XMPConst.NS_PDFA_TYPE, "pdfaType");
        this.registerNamespace(XMPConst.NS_PDFA_FIELD, "pdfaField");
        this.registerNamespace(XMPConst.NS_PDFA_ID, "pdfaid");
        this.registerNamespace(XMPConst.NS_PDFA_EXTENSION, "pdfaExtension");
        this.registerNamespace(XMPConst.NS_PHOTOSHOP, "photoshop");
        this.registerNamespace(XMPConst.NS_PSALBUM, "album");
        this.registerNamespace(XMPConst.NS_EXIF, "exif");
        this.registerNamespace(XMPConst.NS_EXIFX, "exifEX");
        this.registerNamespace(XMPConst.NS_EXIF_AUX, "aux");
        this.registerNamespace(XMPConst.NS_TIFF, "tiff");
        this.registerNamespace(XMPConst.NS_PNG, "png");
        this.registerNamespace(XMPConst.NS_JPEG, "jpeg");
        this.registerNamespace(XMPConst.NS_JP2K, "jp2k");
        this.registerNamespace(XMPConst.NS_CAMERARAW, "crs");
        this.registerNamespace(XMPConst.NS_ADOBESTOCKPHOTO, "bmsp");
        this.registerNamespace(XMPConst.NS_CREATOR_ATOM, "creatorAtom");
        this.registerNamespace(XMPConst.NS_ASF, "asf");
        this.registerNamespace(XMPConst.NS_WAV, "wav");
        this.registerNamespace(XMPConst.NS_BWF, "bext");
        this.registerNamespace(XMPConst.NS_RIFFINFO, "riffinfo");
        this.registerNamespace(XMPConst.NS_SCRIPT, "xmpScript");
        this.registerNamespace(XMPConst.NS_TXMP, "txmp");
        this.registerNamespace(XMPConst.NS_SWF, "swf");

        // 注册Adobe私有命名空间
        this.registerNamespace(XMPConst.NS_DM, "xmpDM");
        this.registerNamespace(XMPConst.NS_TRANSIENT, "xmpx");

        // 注册Adobe标准类型命名空间
        this.registerNamespace(XMPConst.TYPE_TEXT, "xmpT");
        this.registerNamespace(XMPConst.TYPE_PAGEDFILE, "xmpTPg");
        this.registerNamespace(XMPConst.TYPE_GRAPHICS, "xmpG");
        this.registerNamespace(XMPConst.TYPE_IMAGE, "xmpGImg");
        this.registerNamespace(XMPConst.TYPE_FONT, "stFnt");
        this.registerNamespace(XMPConst.TYPE_DIMENSIONS, "stDim");
        this.registerNamespace(XMPConst.TYPE_RESOURCEEVENT, "stEvt");
        this.registerNamespace(XMPConst.TYPE_RESOURCEREF, "stRef");
        this.registerNamespace(XMPConst.TYPE_ST_VERSION, "stVer");
        this.registerNamespace(XMPConst.TYPE_ST_JOB, "stJob");
        this.registerNamespace(XMPConst.TYPE_MANIFESTITEM, "stMfs");
        this.registerNamespace(XMPConst.TYPE_IDENTIFIERQUAL, "xmpidq");
    }

    // ---------------------------------------------------------------------------------------------  
    // 别名函数

    /**
     * 解析别名
     * @param aliasNS 别名命名空间
     * @param aliasProp 别名属性
     * @return 返回XMPAliasInfo对象，如果没有找到则返回null
     */
    public resolveAlias(aliasNS: string, aliasProp: string): XMPAliasInfo | null {
        const aliasPrefix: string | null = this.getNamespacePrefix(aliasNS);
        if (aliasPrefix === null) {
            return null;
        }

        return this.aliasMap.get(aliasPrefix + aliasProp) ?? null;
    }

    /**
     * 查找别名
     * @param qname 限定名称
     * @return 返回XMPAliasInfo对象，如果没有找到则返回null
     */
    public findAlias(qname: string): XMPAliasInfo | null {
        return this.aliasMap.get(qname) ?? null;
    }

    /**
     * 查找特定命名空间中的所有别名
     * @param aliasNS 别名命名空间
     * @return 返回XMPAliasInfo对象数组
     */
    public findAliases(aliasNS: string): XMPAliasInfo[] {
        const prefix: string | null = this.getNamespacePrefix(aliasNS);
        const result: XMPAliasInfo[] = [];
        
        if (prefix !== null) {
            for (const qname of this.aliasMap.keys()) {
                if (qname.startsWith(prefix)) {
                    const aliasInfo: XMPAliasInfo | null = this.findAlias(qname);
                    if (aliasInfo !== null) {
                        result.push(aliasInfo);
                    }
                }
            }
        }
        return result;
    }

    /**
     * 关联别名和实际名称
     * 
     * @param aliasNS 别名的命名空间URI
     * @param aliasProp 别名的名称
     * @param actualNS 实际属性的命名空间URI
     * @param actualProp 实际属性的名称
     * @param aliasForm 别名选项
     * @throws XMPException 不一致的别名时抛出
     */
    registerAlias(aliasNS: string, aliasProp: string, actualNS: string, 
            actualProp: string, aliasForm: AliasOptions | null): void {
        ParameterAsserts.assertSchemaNS(aliasNS);
        ParameterAsserts.assertPropName(aliasProp);
        ParameterAsserts.assertSchemaNS(actualNS);
        ParameterAsserts.assertPropName(actualProp);

        // 修复别名选项
        const aliasOpts: AliasOptions = aliasForm !== null ?
            new AliasOptions(XMPNodeUtils.verifySetOptions(
                aliasForm.toPropertyOptions(), null).getOptions()) :
            new AliasOptions();

        if (this.p.test(aliasProp) || this.p.test(actualProp)) {
            throw new XMPException("Alias and actual property names must be simple",
                    XMPError.BADXPATH);
        }

        // 检查两个命名空间是否都已注册
        const aliasPrefix: string | null = this.getNamespacePrefix(aliasNS);
        const actualPrefix: string | null = this.getNamespacePrefix(actualNS);
        
        if (aliasPrefix === null) {
            throw new XMPException("Alias namespace is not registered", XMPError.BADSCHEMA);
        } else if (actualPrefix === null) {
            throw new XMPException("Actual namespace is not registered", XMPError.BADSCHEMA);
        }

        const key: string = aliasPrefix + aliasProp;

        // 检查别名是否已存在
        if (this.aliasMap.has(key)) {
            throw new XMPException("Alias is already existing", XMPError.BADPARAM);
        } else if (this.aliasMap.has(actualPrefix + actualProp)) {
            throw new XMPException(
                    "Actual property is already an alias, use the base property",
                    XMPError.BADPARAM);
        }

        // 创建XMPAliasInfo实现
        class AliasInfoImpl implements XMPAliasInfo {
            private actualNS: string;
            private actualPrefix: string;
            private actualProp: string;
            private aliasOpts: AliasOptions;

            constructor(ns: string, prefix: string, prop: string, opts: AliasOptions) {
                this.actualNS = ns;
                this.actualPrefix = prefix;
                this.actualProp = prop;
                this.aliasOpts = opts;
            }

            getNamespace(): string {
                return this.actualNS;
            }
            
            getPrefix(): string {
                return this.actualPrefix;
            }
            
            getPropName(): string {
                return this.actualProp;
            }
            
            getAliasForm(): AliasOptions {
                return this.aliasOpts;
            }
            
            toString(): string {
                return this.actualPrefix + this.actualProp + " NS(" + this.actualNS + "), FORM (" 
                        + this.aliasOpts + ")";
            }
        }
        const aliasInfo: XMPAliasInfo = new AliasInfoImpl(actualNS, actualPrefix!, actualProp, aliasOpts);

        this.aliasMap.set(key, aliasInfo);
    }

    /**
     * 获取所有别名
     * @return 返回别名映射
     */
    public getAliases(): Map<string, XMPAliasInfo> {
        // 创建一个排序后的映射
        const sortedMap: Map<string, XMPAliasInfo> = new Map();
        const entries = Array.from(this.aliasMap.entries());
        entries.sort((entry1, entry2) => {
            const a = entry1[0];
            const b = entry2[0];
            return a.localeCompare(b);
        });
        entries.forEach((entry) => {
            const key = entry[0];
            const value = entry[1];
            sortedMap.set(key, value);
        });
        return sortedMap;
    }

    /**
     * 注册标准别名
     * @throws XMPException 如果至少一个别名注册失败
     */
    private registerStandardAliases(): void {
        const aliasToArrayOrdered: AliasOptions = new AliasOptions().setArrayOrdered(true);
        const aliasToArrayAltText: AliasOptions = new AliasOptions().setArrayAltText(true);

        // XMP到DC的别名
        this.registerAlias(XMPConst.NS_XMP, "Author", XMPConst.NS_DC, "creator", aliasToArrayOrdered);
        this.registerAlias(XMPConst.NS_XMP, "Authors", XMPConst.NS_DC, "creator", null);
        this.registerAlias(XMPConst.NS_XMP, "Description", XMPConst.NS_DC, "description", null);
        this.registerAlias(XMPConst.NS_XMP, "Format", XMPConst.NS_DC, "format", null);
        this.registerAlias(XMPConst.NS_XMP, "Keywords", XMPConst.NS_DC, "subject", null);
        this.registerAlias(XMPConst.NS_XMP, "Locale", XMPConst.NS_DC, "language", null);
        this.registerAlias(XMPConst.NS_XMP, "Title", XMPConst.NS_DC, "title", null);
        this.registerAlias(XMPConst.NS_XMP_RIGHTS, "Copyright", XMPConst.NS_DC, "rights", null);

        // PDF到DC和XMP的别名
        this.registerAlias(XMPConst.NS_PDF, "Author", XMPConst.NS_DC, "creator", aliasToArrayOrdered);
        this.registerAlias(XMPConst.NS_PDF, "BaseURL", XMPConst.NS_XMP, "BaseURL", null);
        this.registerAlias(XMPConst.NS_PDF, "CreationDate", XMPConst.NS_XMP, "CreateDate", null);
        this.registerAlias(XMPConst.NS_PDF, "Creator", XMPConst.NS_XMP, "CreatorTool", null);
        this.registerAlias(XMPConst.NS_PDF, "ModDate", XMPConst.NS_XMP, "ModifyDate", null);
        this.registerAlias(XMPConst.NS_PDF, "Subject", XMPConst.NS_DC, "description", aliasToArrayAltText);
        this.registerAlias(XMPConst.NS_PDF, "Title", XMPConst.NS_DC, "title", aliasToArrayAltText);

        // PHOTOSHOP到DC和XMP的别名
        this.registerAlias(XMPConst.NS_PHOTOSHOP, "Author", XMPConst.NS_DC, "creator", aliasToArrayOrdered);
        this.registerAlias(XMPConst.NS_PHOTOSHOP, "Caption", XMPConst.NS_DC, "description", aliasToArrayAltText);
        this.registerAlias(XMPConst.NS_PHOTOSHOP, "Copyright", XMPConst.NS_DC, "rights", aliasToArrayAltText);
        this.registerAlias(XMPConst.NS_PHOTOSHOP, "Keywords", XMPConst.NS_DC, "subject", null);
        this.registerAlias(XMPConst.NS_PHOTOSHOP, "Marked", XMPConst.NS_XMP_RIGHTS, "Marked", null);
        this.registerAlias(XMPConst.NS_PHOTOSHOP, "Title", XMPConst.NS_DC, "title", aliasToArrayAltText);
        this.registerAlias(XMPConst.NS_PHOTOSHOP, "WebStatement", XMPConst.NS_XMP_RIGHTS, "WebStatement", null);

        // TIFF和EXIF到DC和XMP的别名
        this.registerAlias(XMPConst.NS_TIFF, "Artist", XMPConst.NS_DC, "creator", aliasToArrayOrdered);
        this.registerAlias(XMPConst.NS_TIFF, "Copyright", XMPConst.NS_DC, "rights", null);
        this.registerAlias(XMPConst.NS_TIFF, "DateTime", XMPConst.NS_XMP, "ModifyDate", null);
        this.registerAlias(XMPConst.NS_TIFF, "ImageDescription", XMPConst.NS_DC, "description", null);
        this.registerAlias(XMPConst.NS_TIFF, "Software", XMPConst.NS_XMP, "CreatorTool", null);

        // PNG到DC和XMP的别名
        this.registerAlias(XMPConst.NS_PNG, "Author", XMPConst.NS_DC, "creator", aliasToArrayOrdered);
        this.registerAlias(XMPConst.NS_PNG, "Copyright", XMPConst.NS_DC, "rights", aliasToArrayAltText);
        this.registerAlias(XMPConst.NS_PNG, "CreationTime", XMPConst.NS_XMP, "CreateDate", null);
        this.registerAlias(XMPConst.NS_PNG, "Description", XMPConst.NS_DC, "description", aliasToArrayAltText);
        this.registerAlias(XMPConst.NS_PNG, "ModificationTime", XMPConst.NS_XMP, "ModifyDate", null);
        this.registerAlias(XMPConst.NS_PNG, "Software", XMPConst.NS_XMP, "CreatorTool", null);
        this.registerAlias(XMPConst.NS_PNG, "Title", XMPConst.NS_DC, "title", aliasToArrayAltText);
    }
}