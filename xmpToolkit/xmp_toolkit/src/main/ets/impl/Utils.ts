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

/**
 * XMP工具包实现的实用功能
 * 
 * @since 06.06.2006
 */
export default class Utils extends XMPConst {
    /** UUID的段数 */
    public static readonly  UUID_SEGMENT_COUNT: number = 4;
    /** UUID的长度 */
    public static readonly UUID_LENGTH: number = 32 + Utils.UUID_SEGMENT_COUNT;
    /** XML名称起始字符表（<= 0xFF） */
    private static xmlNameStartChars: boolean[];
    /** XML名称字符表（<= 0xFF） */
    private static xmlNameChars: boolean[];
    
    /** 初始化字符表 */
    static {
        Utils.initCharTables();
    }
    
    /**
     * 私有构造函数
     */
    private constructor() {
        super();
    }

    /**
     * 规范化xml:lang值，以便比较有效地不区分大小写，如RFC 3066（替代RFC 1766）所要求的。
     * 规范化规则：
     * <ul>
     * <li>主要子标签为小写，ISO 639的建议做法。</li>
     * <li>所有2字母的次要子标签为大写，ISO 3166的建议做法。</li>
     * <li>所有其他子标签为小写。</li>
     * </ul>
     * 
     * @param value 原始值
     * @return 返回规范化的值
     */
    public static normalizeLangValue(value: string | null): string | null {
        if (value === null) {
            return null;
        }
        // 不规范化x-default
        if (XMPConst.X_DEFAULT === value) {
            return value;
        }
        
        let subTag: number = 1;
        let buffer: string = '';

        for (let i: number = 0; i < value.length; i++) {
            const c: string = value.charAt(i);
            switch (c) {
                case '-':
                case '_':
                case ' ':
                    // 移动到下一个子标签，将下划线和空格转换为连字符
                    buffer += '-';
                    subTag++;
                    break;
                default:
                    // 第二个子标签转换为大写，所有其他转换为小写
                    if (subTag !== 2) {
                        buffer += c.toLowerCase();
                    } else {
                        buffer += c.toUpperCase();
                    }
            }
        }
        return buffer;
    }

    /**
     * 拆分字段和限定符选择器的名称和值部分：
     * <ul>
     * <li>[qualName="value"] - 结构体数组中的元素，按字段值选择。</li>
     * <li>[?qualName="value"] - 数组中的元素，按限定符值选择。</li>
     * </ul>
     * 值部分是由'''或'"'引用的字符串。值可以包含任何字符，包括双引号字符。值可以为空。
     * <em>注意：</em> 假设表达式在形式上是正确的
     * 
     * @param selector 选择器
     * @return 返回一个数组，第一个条目包含名称，第二个包含值
     */
    public static splitNameAndValue(selector: string): string[] {
        // 获取名称
        const eq: number = selector.indexOf('=');
        let pos: number = 1;
        if (selector.charAt(pos) === '?') {
            pos++;
        }
        const name: string = selector.substring(pos, eq);

        // 获取值
        pos = eq + 1;
        const quote: string = selector.charAt(pos);
        pos++;
        const end: number = selector.length - 2; // 引号和]
        let value: string = '';
        while (pos < end) {
            value += selector.charAt(pos);
            pos++;
            if (selector.charAt(pos) === quote) {
                // 跳过值中的一个引号
                pos++;
            }
        }
        return [name, value];
    }

    /**
     * @param schema 模式命名空间
     * @param prop XMP属性
     * @return 如果属性被定义为"内部属性"，返回true，参见XMP规范
     */
    public static isInternalProperty(schema: string, prop: string): boolean {
        let isInternal: boolean = false;

        if (XMPConst.NS_DC === schema) {
            if ("dc:format" === prop || "dc:language" === prop) {
                isInternal = true;
            }
        } else if (XMPConst.NS_XMP === schema) {
            if ("xmp:BaseURL" === prop || "xmp:CreatorTool" === prop ||
                "xmp:Format" === prop || "xmp:Locale" === prop ||
                "xmp:MetadataDate" === prop || "xmp:ModifyDate" === prop) {
                isInternal = true;
            }
        } else if (XMPConst.NS_PDF === schema) {
            if ("pdf:BaseURL" === prop || "pdf:Creator" === prop ||
                "pdf:ModDate" === prop || "pdf:PDFVersion" === prop ||
                "pdf:Producer" === prop) {
                isInternal = true;
            }
        } else if (XMPConst.NS_TIFF === schema) {
            isInternal = true;
            if ("tiff:ImageDescription" === prop || "tiff:Artist" === prop ||
                "tiff:Copyright" === prop) {
                isInternal = false;
            }
        } else if (XMPConst.NS_EXIF === schema) {
            isInternal = true;
            if ("exif:UserComment" === prop) {
                isInternal = false;
            }
        } else if (XMPConst.NS_EXIF_AUX === schema) {
            isInternal = true;
        } else if (XMPConst.NS_PHOTOSHOP === schema) {
            if ("photoshop:ICCProfile" === prop) {
                isInternal = true;
            }
        } else if (XMPConst.NS_CAMERARAW === schema) {
            if ("crs:Version" === prop || "crs:RawFileName" === prop ||
                "crs:ToneCurveName" === prop) {
                isInternal = true;
            }
        } else if (XMPConst.NS_ADOBESTOCKPHOTO === schema) {
            isInternal = true;
        } else if (XMPConst.NS_XMP_MM === schema) {
            isInternal = true;
        } else if (XMPConst.TYPE_TEXT === schema) {
            isInternal = true;
        } else if (XMPConst.TYPE_PAGEDFILE === schema) {
            isInternal = true;
        } else if (XMPConst.TYPE_GRAPHICS === schema) {
            isInternal = true;
        } else if (XMPConst.TYPE_IMAGE === schema) {
            isInternal = true;
        } else if (XMPConst.TYPE_FONT === schema) {
            isInternal = true;
        }

        return isInternal;
    }

    /**
     * 检查UUID的一些要求：
     * <ul>
     * <li>UUID的长度为32</li>
     * <li>分隔符数量为4，且所有4个分隔符都在正确的位置（8,13,18,23）</li>
     * </ul>
     * 
     * @param uuid 要测试的uuid
     * @return true - 这是一个格式良好的UUID，false - UUID格式不符合预期
     */
    public static checkUUIDFormat(uuid: string): boolean {
        let result: boolean = true;
        let delimCnt: number = 0;
        let delimPos: number = 0;

        if (uuid == null) {
            return false;
        }
        
        for (delimPos = 0; delimPos < uuid.length; delimPos++) {
            if (uuid.charAt(delimPos) === '-') {
                delimCnt++;
                result = result && 
                    (delimPos === 8 || delimPos === 13 || delimPos === 18 || delimPos === 23);
            }
        }

        return result && Utils.UUID_SEGMENT_COUNT === delimCnt && Utils.UUID_LENGTH === delimPos;
    }

    /**
     * 简单检查有效的XML名称。在ASCII范围内<br>
     * ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6]<br>
     * 被接受，高于所有字符（根据XML规范，这并不完全正确）
     * 
     * @param name XML名称
     * @return 如果名称正确，返回<code>true</code>
     */
    public static isXMLName(name: string): boolean {
        // 空字符串不是有效的 XML 名称
        if (name.length === 0) {
            return false;
        }
        if (!Utils.isNameStartChar(name.charAt(0))) {
            return false;
        }
        for (let i: number = 1; i < name.length; i++) {
            if (!Utils.isNameChar(name.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    /**
     * 检查值是否为合法的"非限定"XML名称，如XML命名空间建议的推荐中所定义。
     * 这些是XML名称，但不能包含冒号。
     * @param name 要检查的值
     * @return 如果名称是有效的"非限定"XML名称，返回true
     */
    public static isXMLNameNS(name: string): boolean {
        if (name.length > 0 && (!Utils.isNameStartChar(name.charAt(0)) || name.charAt(0) === ':')) {
            return false;
        }
        for (let i: number = 1; i < name.length; i++) {
            if (!Utils.isNameChar(name.charAt(i)) || name.charAt(i) === ':') {
                return false;
            }
        }
        return true;
    }

    /**
     * @param c 字符
     * @return 如果字符是ASCII控制字符，返回true
     */
    public static isControlChar(c: string): boolean {
        const code: number = c.charCodeAt(0);
        return (code <= 0x1F || code === 0x7F) &&
               code !== 0x09 && code !== 0x0A && code !== 0x0D;
    }

    /**
     * 以XML编码序列化节点值。用于标签体和属性。<br>
     * <em>注意：</em> 属性总是由引号限制，这就是为什么<code>&amp;apos;</code>从不被序列化。<br>
     * <em>注意：</em> 控制字符未经转义写入，但如果用户使用制表符、LF和CR以外的字符，生成的XML将变得无效。
     * 
     * @param value 字符串
     * @param forAttribute 标志字符串是否为属性值（需要额外转义引号）
     * @param escapeWhitespaces 决定是否转义LF、CR和TAB
     * @return 返回准备好用于XML输出的值
     */
    public static escapeXML(value: string, forAttribute: boolean, escapeWhitespaces: boolean): string {
        // 快速检查是否包含需要特殊处理的字符
        let needsEscaping: boolean = false;
        for (let i: number = 0; i < value.length; i++) {
            const c: string = value.charAt(i);
            if (
                c === '<' || c === '>' || c === '&' ||
                (escapeWhitespaces && (c === '\t' || c === '\n' || c === '\r')) ||
                (forAttribute && c === '"')
            ) {
                needsEscaping = true;
                break;
            }
        }
        
        if (!needsEscaping) {
            // 快速路径
            return value;
        } else {
            // 带转义的慢速路径
            let buffer: string = '';
            for (let i: number = 0; i < value.length; i++) {
                const c: string = value.charAt(i);
                if (!(escapeWhitespaces && (c === '\t' || c === '\n' || c === '\r'))) {
                    switch (c) {
                        // 我们做"规范XML"期望的事情
                        // 审计：&apos;不会被序列化，因为只使用外部引号
                        case '<':
                            buffer += "&lt;";
                            continue;
                        case '>':
                            buffer += "&gt;";
                            continue;
                        case '&':
                            buffer += "&amp;";
                            continue;
                        case '"':
                            buffer += forAttribute ? "&quot;" : '\"';
                            continue;
                        default:
                            buffer += c; continue;
                    }
                } else {
                    // 转义写入控制字符，
                    // 如果存在制表符、LF和CR以外的字符，xml将变得无效。
                    buffer += "&#x";
                    buffer += c.charCodeAt(0).toString(16).toUpperCase();
                    buffer += ';';
                }
            }
            return buffer;
        }
    }

    /**
     * 用空格替换ASCII控制字符
     * 
     * @param value 节点值
     * @return 返回清理后的值
     */
    public static removeControlChars(value: string): string {
        let buffer: string = '';
        for (let i: number = 0; i < value.length; i++) {
            const c: string = value.charAt(i);
            if (Utils.isControlChar(c)) {
                buffer += ' ';
            } else {
                buffer += c;
            }
        }
        return buffer;
    }

    /**
     * 简单检查字符是否为有效的XML起始名称字符。
     * 根据XML规范1.1接受所有字符：
     * http://www.w3.org/TR/xml11/#NT-NameStartChar
     * 
     * @param ch 字符
     * @return 如果字符是XML名称的有效首字符，返回true
     */
    private static isNameStartChar(ch: string): boolean {
        const code: number = ch.charCodeAt(0);
        return (code <= 0xFF && Utils.xmlNameStartChars[code]) ||
            (code >= 0x100 && code <= 0x2FF) ||
            (code >= 0x370 && code <= 0x37D) ||
            (code >= 0x37F && code <= 0x1FFF) ||
            (code >= 0x200C && code <= 0x200D) ||
            (code >= 0x2070 && code <= 0x218F) ||
            (code >= 0x2C00 && code <= 0x2FEF) ||
            (code >= 0x3001 && code <= 0xD7FF) ||
            (code >= 0xF900 && code <= 0xFDCF) ||
            (code >= 0xFDF0 && code <= 0xFFFD) ||
            (code >= 0x10000 && code <= 0xEFFFF);
    }

    /**
     * 简单检查字符是否为有效的XML名称字符
     * （除第一个字符外的每个字符），根据XML规范1.1：
     * http://www.w3.org/TR/xml11/#NT-NameChar
     * 
     * @param ch 字符
     * @return 如果字符是XML名称的有效字符，返回true
     */
    private static isNameChar(ch: string): boolean {
        const code: number = ch.charCodeAt(0);
        return (code <= 0xFF && Utils.xmlNameChars[code]) ||
            Utils.isNameStartChar(ch) ||
            (code >= 0x300 && code <= 0x36F) ||
            (code >= 0x203F && code <= 0x2040);
    }

    /**
     * 初始化0x00-0xFF字符的字符表以供以后使用，
     * 根据XML 1.1规范
     * http://www.w3.org/TR/xml11
     */
    private static initCharTables(): void {
        Utils.xmlNameChars = new Array<boolean>(0x0100);
        Utils.xmlNameStartChars = new Array<boolean>(0x0100);
        
        for (let ch: number = 0; ch < Utils.xmlNameChars.length; ch++) {
            Utils.xmlNameStartChars[ch] = 
                ch === 0x3A || // ':'
                (0x41 <= ch && ch <= 0x5A) || // [A-Z]
                ch === 0x5F || // '_'
                (0x61 <= ch && ch <= 0x7A) || // [a-z]
                (0xC0 <= ch && ch <= 0xD6) ||
                (0xD8 <= ch && ch <= 0xF6) ||
                (0xF8 <= ch && ch <= 0xFF);
            
            Utils.xmlNameChars[ch] = 
                Utils.xmlNameStartChars[ch] ||
                ch === 0x2D || // '-'
                ch === 0x2E || // '.'
                (0x30 <= ch && ch <= 0x39) || // [0-9]
                ch === 0xB7;
        }
    }
}