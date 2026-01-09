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

import XMPError from '../../XMPError';
import XMPException from '../../XMPException';
import XMPMetaFactory from '../../XMPMetaFactory';
import  Utils from '../Utils';
import XMPAliasInfo from '../../properties/XMPAliasInfo';
import XMPPath from './XMPPath';
import XMPPathSegment from './XMPPathSegment';

/**
 * XPath位置信息类
 */
class PathPosition {
    /** 完整路径 */
    public customPath: string = '';
    /** 段名开始位置 */
    public nameStart: number = 0;
    /** 段名结束位置 */
    public nameEnd: number = 0;
    /** 步骤开始位置 */
    public stepBegin: number = 0;
    /** 步骤结束位置 */
    public stepEnd: number = 0;
}

/**
 * XMP XPath解析器
 * 
 * @since 01.03.2006
 */
export default class XMPPathParser {
    /**
     * 私有构造函数
     */
    private constructor() {
        // 空构造函数
    }

    /**
     * 将XPath表达式拆分为概念步骤，将根命名空间前缀添加到第一个属性组件。
     * 模式URI被放入展开的XMPPath的第一个（第0个）位置。
     * 检查顶级组件是否是别名，但不解析它。
     * 
     * @param schemaNS 模式命名空间
     * @param path 属性名称
     * @return 返回展开的XMPPath
     * @throws XMPException 如果格式不正确
     */
    public static expandXPath(schemaNS: string, path: string): XMPPath {
        if (schemaNS == null || path == null) {
            throw new XMPException("Parameter must not be null", XMPError.BADPARAM);
        }

        const expandedXPath: XMPPath = new XMPPath();
        const pos: PathPosition = new PathPosition();
        pos.customPath = path;
        
        // 提取第一个组件并对其进行特殊处理：添加模式命名空间前缀并查看它是否是别名
        XMPPathParser.parseRootNode(schemaNS, pos, expandedXPath);

        // 继续处理XMPPath字符串的其余部分
        while (pos.stepEnd < path.length) {
            pos.stepBegin = pos.stepEnd;
            
            XMPPathParser.skipPathDelimiter(path, pos);

            pos.stepEnd = pos.stepBegin;
            
            let segment: XMPPathSegment;
            if (path.charAt(pos.stepBegin) !== '[') {
                // 结构体字段或限定符
                segment = XMPPathParser.parseStructSegment(pos);
            } else {
                // 数组形式之一
                segment = XMPPathParser.parseIndexSegment(pos);
            }
            
            if (segment.getKind() === XMPPath.STRUCT_FIELD_STEP) {
                if (segment.getName().charAt(0) === '@') {
                    segment.setName("?" + segment.getName().substring(1));
                    if ("?xml:lang" !== segment.getName()) {
                        throw new XMPException("Only xml:lang allowed with '@'", XMPError.BADXPATH);
                    }
                }
                if (segment.getName().charAt(0) === '?') {
                    pos.nameStart++;
                    segment.setKind(XMPPath.QUALIFIER_STEP);
                }

                XMPPathParser.verifyQualName(pos.customPath.substring(pos.nameStart, pos.nameEnd));
            } else if (segment.getKind() === XMPPath.FIELD_SELECTOR_STEP) {
                if (segment.getName().charAt(1) === '@') {
                    segment.setName("[?" + segment.getName().substring(2));
                    if (!segment.getName().startsWith("[?xml:lang=")) {
                        throw new XMPException("Only xml:lang allowed with '@'", XMPError.BADXPATH);
                    }
                }

                if (segment.getName().charAt(1) === '?') {
                    pos.nameStart++;
                    segment.setKind(XMPPath.QUAL_SELECTOR_STEP);
                    XMPPathParser.verifyQualName(pos.customPath.substring(pos.nameStart, pos.nameEnd));
                }
            }
            
            expandedXPath.add(segment);
        }
        return expandedXPath;
    }

    /**
     * 跳过路径分隔符
     * 
     * @param path 路径字符串
     * @param pos 当前位置
     * @throws XMPException 如果遇到错误
     */
    private static skipPathDelimiter(path: string, pos: PathPosition): void {
        if (path.charAt(pos.stepBegin) === '/') {
            // 跳过斜杠
            pos.stepBegin++;

            // 检查边界
            if (pos.stepBegin >= path.length) {
                throw new XMPException("Empty XMPPath segment", XMPError.BADXPATH);
            }
        }

        if (path.charAt(pos.stepBegin) === '*') {
            // 跳过星号
            pos.stepBegin++;
            if (pos.stepBegin >= path.length || path.charAt(pos.stepBegin) !== '[') {
                throw new XMPException("Missing '[' after '*'", XMPError.BADXPATH);
            }
        }
    }

    /**
     * 解析结构体段
     * 
     * @param pos 当前路径位置
     * @return 返回段或错误
     * @throws XMPException 如果段为空
     */
    private static parseStructSegment(pos: PathPosition): XMPPathSegment {
        pos.nameStart = pos.stepBegin;
        while (pos.stepEnd < pos.customPath.length && "/[*".indexOf(pos.customPath.charAt(pos.stepEnd)) < 0) {
            pos.stepEnd++;
        }
        pos.nameEnd = pos.stepEnd;

        if (pos.stepEnd === pos.stepBegin) {
            throw new XMPException("Empty XMPPath segment", XMPError.BADXPATH);
        }

        // 稍后处理，同时将'@'更改为'?'
        const segment: XMPPathSegment = new XMPPathSegment(
            pos.customPath.substring(pos.stepBegin, pos.stepEnd),
            XMPPath.STRUCT_FIELD_STEP
        );
        return segment;
    }

    /**
     * 解析数组索引段
     * 
     * @param pos 路径位置
     * @return 返回段或错误
     * @throws XMPException 路径错误时抛出
     */
    private static parseIndexSegment(pos: PathPosition): XMPPathSegment {
        let segment: XMPPathSegment;
        pos.stepEnd++; // 查看'['后面的字符

        if ('0' <= pos.customPath.charAt(pos.stepEnd) && pos.customPath.charAt(pos.stepEnd) <= '9') {
            // 数字（十进制整数）数组索引
            while (pos.stepEnd < pos.customPath.length &&
                   '0' <= pos.customPath.charAt(pos.stepEnd) &&
                   pos.customPath.charAt(pos.stepEnd) <= '9') {
                pos.stepEnd++;
            }

            segment = new XMPPathSegment('', XMPPath.ARRAY_INDEX_STEP);
        } else {
            // 可能是"[last()]"或选择器形式之一。找到']'或'='
            while (pos.stepEnd < pos.customPath.length &&
                   pos.customPath.charAt(pos.stepEnd) !== ']' &&
                   pos.customPath.charAt(pos.stepEnd) !== '=') {
                pos.stepEnd++;
            }
            
            if (pos.stepEnd >= pos.customPath.length) {
                throw new XMPException("Missing ']' or '=' for array index", XMPError.BADXPATH);
            }

            if (pos.customPath.charAt(pos.stepEnd) === ']') {
                if ("[last()" !== pos.customPath.substring(pos.stepBegin, pos.stepEnd)) {
                    throw new XMPException("Invalid non-numeric array index", XMPError.BADXPATH);
                }
                segment = new XMPPathSegment('', XMPPath.ARRAY_LAST_STEP);
            } else {
                pos.nameStart = pos.stepBegin + 1;
                pos.nameEnd = pos.stepEnd;
                pos.stepEnd++; // 吸收'='，记住引号
                const quote: string = pos.customPath.charAt(pos.stepEnd);
                if (quote !== "'" && quote !== '"') {
                    throw new XMPException("Invalid quote in array selector", XMPError.BADXPATH);
                }

                pos.stepEnd++; // 吸收前引号
                while (pos.stepEnd < pos.customPath.length) {
                    if (pos.customPath.charAt(pos.stepEnd) === quote) {
                        // 检查转义引号
                        if (pos.stepEnd + 1 >= pos.customPath.length ||
                            pos.customPath.charAt(pos.stepEnd + 1) !== quote) {
                            break;
                        }
                        pos.stepEnd++;
                    }
                    pos.stepEnd++;
                }

                if (pos.stepEnd >= pos.customPath.length) {
                    throw new XMPException("No terminating quote for array selector", XMPError.BADXPATH);
                }
                pos.stepEnd++; // 吸收后引号

                // 稍后处理，同时将'@'更改为'?'
                segment = new XMPPathSegment('', XMPPath.FIELD_SELECTOR_STEP);
            }
        }
        
        if (pos.stepEnd >= pos.customPath.length || pos.customPath.charAt(pos.stepEnd) !== ']') {
            throw new XMPException("Missing ']' for array index", XMPError.BADXPATH);
        }
        pos.stepEnd++;
        segment.setName(pos.customPath.substring(pos.stepBegin, pos.stepEnd));
        
        return segment;
    }

    /**
     * 解析XMP路径的根节点，检查命名空间和前缀是否匹配，并在属性是别名时解析为基本属性
     * 
     * @param schemaNS 根命名空间
     * @param pos 解析位置助手
     * @param expandedXPath 要贡献的路径
     * @throws XMPException 如果路径无效
     */
    private static parseRootNode(schemaNS: string, pos: PathPosition, expandedXPath: XMPPath): void {
        while (pos.stepEnd < pos.customPath.length && "/[*?".indexOf(pos.customPath.charAt(pos.stepEnd)) < 0) {
            pos.stepEnd++;
        }

        if (pos.stepEnd === pos.stepBegin) {
            throw new XMPException("Empty initial XMPPath step", XMPError.BADXPATH);
        }
        
        const rootProp: string = XMPPathParser.verifyXPathRoot(schemaNS, pos.customPath.substring(pos.stepBegin, pos.stepEnd));
        const aliasInfo: XMPAliasInfo | null = XMPMetaFactory.getSchemaRegistry().findAlias(rootProp);
        if (aliasInfo == null) {
            // 添加模式xpath步骤
            expandedXPath.add(new XMPPathSegment(schemaNS, XMPPath.SCHEMA_NODE));
            const rootStep: XMPPathSegment = new XMPPathSegment(rootProp, XMPPath.STRUCT_FIELD_STEP);
            expandedXPath.add(rootStep);
        } else {
            // 添加模式xpath步骤和别名的基本步骤
            expandedXPath.add(new XMPPathSegment(aliasInfo.getNamespace(), XMPPath.SCHEMA_NODE));
            const rootStep: XMPPathSegment = new XMPPathSegment(
                XMPPathParser.verifyXPathRoot(aliasInfo.getNamespace(), aliasInfo.getPropName()),
                XMPPath.STRUCT_FIELD_STEP
            );
            rootStep.setAlias(true);
            rootStep.setAliasForm(aliasInfo.getAliasForm().getOptions());
            expandedXPath.add(rootStep);
            
            if (aliasInfo.getAliasForm().isArrayAltText()) {
                const qualSelectorStep: XMPPathSegment = new XMPPathSegment(
                    "[?xml:lang='x-default']",
                    XMPPath.QUAL_SELECTOR_STEP
                );
                qualSelectorStep.setAlias(true);
                qualSelectorStep.setAliasForm(aliasInfo.getAliasForm().getOptions());
                expandedXPath.add(qualSelectorStep);
            } else if (aliasInfo.getAliasForm().isArray()) {
                const indexStep: XMPPathSegment = new XMPPathSegment(
                    "[1]",
                    XMPPath.ARRAY_INDEX_STEP
                );
                indexStep.setAlias(true);
                indexStep.setAliasForm(aliasInfo.getAliasForm().getOptions());
                expandedXPath.add(indexStep);
            }
        }
    }

    /**
     * 验证限定符名称是否符合XML规范或命名空间前缀是否已注册
     * 
     * @param qualName 限定符名称
     * @throws XMPException 如果名称不符合规范
     */
    private static verifyQualName(qualName: string): void {
        const colonPos: number = qualName.indexOf(':');
        if (colonPos > 0) {
            // 有冒号，验证为限定名称
            const prefix: string = qualName.substring(0, colonPos);
            if (Utils.isXMLNameNS(prefix)) {
                const regURI: string | null = XMPMetaFactory.getSchemaRegistry().getNamespaceURI(prefix);
                if (regURI != null) {
                    return;
                }

                throw new XMPException("Unknown namespace prefix for qualified name", XMPError.BADXPATH);
            }
        } else {
            // 没有冒号，验证为简单 XML 名称
            if (Utils.isXMLName(qualName)) {
                return;
            }
        }
        
        throw new XMPException("Ill-formed qualified name", XMPError.BADXPATH);
    }

    /**
     * 验证XML名称是否符合规范
     * 
     * @param name XML名称
     * @throws XMPException 当名称不符合XML规范时抛出
     */
    private static verifySimpleXMLName(name: string): void {
        if (!Utils.isXMLName(name)) {
            throw new XMPException("Bad XML name", XMPError.BADXPATH);
        }
    }

    /**
     * 设置展开的XMPPath的前两个组件。规范化使用完整模式URI和/或限定根属性名称的各种情况。
     * 对正常处理返回true。如果allowUnknownSchemaNS为true且模式命名空间未注册，则返回false。
     * 如果allowUnknownSchemaNS为false且模式命名空间未注册，则抛出异常。
     * 
     * @param schemaNS 模式命名空间
     * @param rootProp 根xpath段
     * @return 返回根QName
     * @throws XMPException 如果格式不正确
     */
    private static verifyXPathRoot(schemaNS: string, rootProp: string): string {
        // 对URI和名称进行基本检查。尝试查找URI。查看名称是否已限定。

        if (schemaNS == null || schemaNS.length === 0) {
            throw new XMPException("Schema namespace URI is required", XMPError.BADSCHEMA);
        }

        if (rootProp.charAt(0) === '?' || rootProp.charAt(0) === '@') {
            throw new XMPException("Top level name must not be a qualifier", XMPError.BADXPATH);
        }

        if (rootProp.indexOf('/') >= 0 || rootProp.indexOf('[') >= 0) {
            throw new XMPException("Top level name must be simple", XMPError.BADXPATH);
        }

        const prefix: string | null = XMPMetaFactory.getSchemaRegistry().getNamespacePrefix(schemaNS);
        if (prefix == null) {
            throw new XMPException("Unregistered schema namespace URI", XMPError.BADSCHEMA);
        }

        // 验证各种URI和前缀组合。初始化展开的XMPPath。
        const colonPos: number = rootProp.indexOf(':');
        if (colonPos < 0) {
            // propName未限定，使用schemaURI和关联的前缀
            XMPPathParser.verifySimpleXMLName(rootProp); // 验证冒号前的部分
            return prefix + rootProp;
        } else {
            // propName已限定。确保前缀合法。使用关联的URI和限定名称。

            // 验证冒号前的部分
            XMPPathParser.verifySimpleXMLName(rootProp.substring(0, colonPos));
            XMPPathParser.verifySimpleXMLName(rootProp.substring(colonPos + 1));
            
            const propPrefix: string = rootProp.substring(0, colonPos + 1);

            const regPrefix: string | null = XMPMetaFactory.getSchemaRegistry().getNamespacePrefix(schemaNS);
            if (regPrefix == null) {
                throw new XMPException("Unknown schema namespace prefix", XMPError.BADSCHEMA);
            }
            if (propPrefix !== regPrefix) {
                throw new XMPException("Schema namespace URI and prefix mismatch", XMPError.BADSCHEMA);
            }

            return rootProp;
        }
    }
}