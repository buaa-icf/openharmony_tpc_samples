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

import  XMPConst  from '../XMPConst';
import  XMPError from '../XMPError';
import XMPException from '../XMPException';
import PropertyOptions from '../options/PropertyOptions';

/**
 * XMP树中的内部节点，可以是schema节点、属性节点、数组节点、数组项、结构体节点或限定符节点
 * 
 * @since 21.02.2006
 */
export default class XMPNode {
    // veraPDF: 额外的原始前缀字段
    /** 节点的原始前缀 */
    private originalPrefix: string | null = null;

    /** 节点名称，根据节点类型包含不同信息 */
    private name: string | null = null;
    /** 节点值，根据节点类型包含不同信息 */
    private value: string | null = null;
    /** 父节点链接 */
    private parent: XMPNode | null;
    /** 子节点列表，延迟初始化 */
    private children: XMPNode[] | null = null;
    /** 节点限定符列表，延迟初始化 */
    private qualifier: XMPNode[] | null = null;
    /** 描述节点类型的选项 */
    private options: PropertyOptions | null;
    
    // 内部处理选项
    
    /** 节点是否隐式创建的标志 */
    private implicit: boolean = false;
    /** 节点是否有别名的标志 */
    private hasAliases: boolean = false;
    /** 节点是否是别名的标志 */
    private alias: boolean = false;
    /** 节点是否有"rdf:value"子节点的标志 */
    private hasValueChild: boolean = false;

    /**
     * 创建具有初始值的XMPNode
     * 
     * @param name 节点名称
     * @param value 节点值
     * @param options 节点选项（可以为null）
     * @param originalPrefix 原始前缀
     */
    public constructor(name: string | null, value: string | null, options: PropertyOptions | null,
                       originalPrefix: string | null) {
        this.name = name;
        this.value = value;
        this.options = options;
        this.originalPrefix = originalPrefix;
        this.parent = null;
    }

    /**
     * 获取原始前缀
     */
    public getOriginalPrefix(): string | null{
        return this.originalPrefix;
    }

    /**
     * 重置节点
     */
    public clear(): void {
        this.options = null;
        this.name = null;
        this.value = null;
        this.children = null;
        this.qualifier = null;
    }

    /**
     * @return 返回父节点
     */
    public getParent(): XMPNode | null {
        return this.parent;
    }

    /**
     * 设置父节点，这仅由addChild(...)和addQualifier()方法调用
     * 
     * @param parent 要设置的父节点
     */
    protected setParent(parent: XMPNode): void {
        this.parent = parent;
    }

    /**
     * @param index 索引 [1..size]
     * @return 返回请求索引的子节点
     */
    public getChild(index: number): XMPNode {
        return this.getChildren()[index - 1];
    }

    /**
     * 在指定位置添加子节点
     * @param index 插入位置前的索引
     * <em>注意:</em> 子节点索引从[1..size]开始！
     * 索引为size + 1时追加节点。
     * @param node 要添加的XMPNode
     * @throws XMPException 如果子节点已存在
     */
    public addChild(indexOrNode: number | XMPNode, node?: XMPNode): void {
        if(typeof indexOrNode === 'number' && node !== undefined){
            const nodeName: string | null = node.getName();
            if (nodeName !== null) {
                this.assertChildNotExisting(nodeName);
            }
            node.setParent(this);
            this.getChildren().splice(indexOrNode - 1, 0, node);
        } else if(indexOrNode instanceof XMPNode){
            // 检查重复属性
            const nodeName: string | null = indexOrNode.getName();
            if (nodeName !== null) {
                this.assertChildNotExisting(nodeName);
            }
            indexOrNode.setParent(this);
            this.getChildren().push(indexOrNode);
        }
    }

    /**
     * 替换节点
     * @param index 要替换的节点索引
     * <em>注意:</em> 子节点索引从[1..size]开始！
     * @param node 替换的XMPNode
     */
    public replaceChild(index: number, node: XMPNode): void {
        node.setParent(this);
        this.getChildren()[index - 1] = node;
    }

    /**
     * 移除子节点
     * @param node 要删除的子节点
     */
    public removeChild(nodeOrItemIndex: XMPNode | number): void {
        if (nodeOrItemIndex instanceof XMPNode) {
            const children = this.getChildren();
            const index = children.indexOf(nodeOrItemIndex);
            if (index >= 0) {
                children.splice(index, 1);
                this.cleanupChildren();
            }
        } else {
            this.getChildren().splice(nodeOrItemIndex - 1, 1);
            this.cleanupChildren();
        }
    }

    /**
     * 如果节点没有子节点，则移除子节点列表
     */
    protected cleanupChildren(): void {
        if (this.children && this.children.length === 0) {
            this.children = null;
        }
    }

    /**
     * 移除所有子节点
     */
    public removeChildren(): void {
        this.children = null;
    }

    /**
     * @return 返回子节点数量，无需创建列表
     */
    public getChildrenLength(): number {
        return this.children != null ? this.children.length : 0;
    }

    /**
     * @param expr 要查找的子节点名称
     * @return 如果找到节点则返回XMPNode，否则返回null
     */
    public findChildByName(expr: string): XMPNode | null {
        return this.find(this.getChildren(), expr);
    }

    /**
     * @param index 索引 [1..size]
     * @return 返回请求索引的限定符
     */
    public getQualifier(index: number): XMPNode {
        return this.getQualifierList()[index - 1];
    }

    /**
     * @return 返回限定符数量，无需创建列表
     */
    public getQualifierLength(): number {
        return this.qualifier != null ? this.qualifier.length : 0;
    }

    /**
     * 向限定符列表追加限定符并设置相应选项
     * @param qualNode 限定符节点
     * @throws XMPException 如果限定符已存在
     */
    public addQualifier(qualNode: XMPNode): void {
        const qualName: string | null = qualNode.getName();
        if (qualName !== null) {
            this.assertQualifierNotExisting(qualName);
        }
        qualNode.setParent(this);
        qualNode.getOptions().setQualifier(true);
        this.getOptions().setHasQualifiers(true);
        
        // 约束
        if (qualNode.isLanguageNode()) {
            // "xml:lang"始终是第一个，并设置"hasLanguage"选项
            this.options!.setHasLanguage(true);
            this.getQualifierList().unshift(qualNode);
        } else if (qualNode.isTypeNode()) {
            // "rdf:type"必须是第一个或在"xml:lang"之后第二个，并设置"hasType"选项
            this.options!.setHasType(true);
            this.getQualifierList().splice(
                !this.options!.getHasLanguage() ? 0 : 1,
                0,
                qualNode
            );
        } else {
            // 其他限定符追加到末尾
            this.getQualifierList().push(qualNode);
        }
    }

    /**
     * 移除限定符节点并修复选项
     * @param qualNode 要移除的限定符
     */
    public removeQualifier(qualNode: XMPNode): void {
        const opts = this.getOptions();
        if (qualNode.isLanguageNode()) {
            // 如果移除"xml:lang"，也移除hasLanguage标志
            opts.setHasLanguage(false);
        } else if (qualNode.isTypeNode()) {
            // 如果移除"rdf:type"，也移除hasType标志
            opts.setHasType(false);
        }
        
        const qualifierList = this.getQualifierList();
        const index = qualifierList.indexOf(qualNode);
        if (index !== -1) {
            qualifierList.splice(index, 1);
        }
        
        if (this.qualifier && this.qualifier.length === 0) {
            opts.setHasQualifiers(false);
            this.qualifier = null;
        }
    }

    /**
     * 移除所有限定符并适当设置选项
     */
    public removeQualifiers(): void {
        const opts = this.getOptions();
        // 清除限定符相关选项
        opts.setHasQualifiers(false);
        opts.setHasLanguage(false);
        opts.setHasType(false);
        this.qualifier = null;
    }

    /**
     * @param expr 要查找的限定符节点名称
     * @return 如果找到限定符则返回XMPNode，否则返回null
     */
    public findQualifierByName(expr: string): XMPNode | null {
        return this.find(this.getQualifierList(), expr);
    }

    /**
     * @return 节点是否有子节点
     */
    public hasChildren(): boolean {
        return this.children != null && this.children.length > 0;
    }

    /**
     * @return 返回子节点的迭代器
     */
    public iterateChildren(): Iterator<XMPNode> {
        if (this.children != null) {
            return this.children[Symbol.iterator]();
        } else {
            return ([] as XMPNode[])[Symbol.iterator]();
        }
    }
    
    /**
     * @return 返回限定符的迭代器
     */
    public iterateQualifier(): Iterator<XMPNode> {
        if (this.qualifier != null) {
            return this.qualifier[Symbol.iterator]();
        } else {
            return ([] as XMPNode[])[Symbol.iterator]();
        }
    }
    
    /**
     * 获取子节点数组
     */
    private getChildren(): XMPNode[] {
        if (this.children === null) {
            this.children = [];
        }
        return this.children;
    }

    /**
     * @return 返回子节点列表的只读副本
     */
    public getUnmodifiableChildren(): XMPNode[] {
        return [...this.getChildren()];
    }

    /**
     * 获取限定符数组
     */
    private getQualifierList(): XMPNode[] {
        if (this.qualifier === null) {
            this.qualifier = [];
        }
        return this.qualifier;
    }

    /**
     * @return 节点是否有附加的限定符
     */
    public hasQualifier(): boolean {
        return this.qualifier != null && this.qualifier.length > 0;
    }

    /**
     * 执行节点及其完整子树的深拷贝
     * 
     * @return 克隆的节点
     */
    public clone(): XMPNode {
        let newOptions: PropertyOptions;
        try {
            newOptions = new PropertyOptions(this.getOptions().getOptions());
        } catch (e) {
            newOptions = new PropertyOptions();
        }
        
        const newNode = new XMPNode(this.name, this.value, newOptions, this.originalPrefix);
        this.cloneSubtree(newNode);
        
        return newNode;
    }

    /**
     * 执行完整子树（子节点和限定符）的深拷贝并添加到目标节点
     * 
     * @param destination 要添加克隆子树的节点
     */
    public cloneSubtree(destination: XMPNode): void {
        try {
            for (const child of this.getChildren()) {
                destination.addChild(child.clone());
            }
            
            for (const qualifier of this.getQualifierList()) {
                destination.addQualifier(qualifier.clone());
            }
        } catch (e) {
            // 不会发生（此节点中不存在重复子节点/限定符）
            console.error('Unexpected error during cloning:', e);
        }
    }

    /**
     * 以人类可读的形式渲染此节点及其下的树
     * @param recursive 是否渲染限定符和子节点
     * @return 包含转储信息的多行字符串
     */
    public dumpNode(recursive: boolean): string {
        const result: string[] = [];
        this.dumpNodeInternal(result, recursive, 0, 0);
        return result.join('');
    }

    /**
     * 内部转储方法
     */
    private dumpNodeInternal(result: string[], recursive: boolean, indent: number, index: number): void {
        // 写入缩进
        for (let i = 0; i < indent; i++) {
            result.push('\t');
        }
        
        // 渲染节点
        if (this.parent != null) {
            if (this.getOptions().isQualifier()) {
                result.push('?');
                result.push(this.name ?? '');
            } else if (this.parent.getOptions().isArray()) {
                result.push('[');
                result.push(index.toString());
                result.push(']');
            } else {
                result.push(this.name ?? '');
            }
        } else {
            // 仅适用于根节点
            result.push("ROOT NODE");
            if (this.name != null && this.name.length > 0) {
                // "about"属性
                result.push(" (");
                result.push(this.name);
                result.push(')');
            }
        }
        
        if (this.value != null && this.value.length > 0) {
            result.push(" = \"");
            result.push(this.value);
            result.push('"');
        }
        
        // 渲染选项（如果至少设置了一个）
        if (this.getOptions().getOptions() !== 0) {
            result.push("\t(");
            result.push(this.getOptions().toString());
            result.push(" : ");
            result.push(this.getOptions().getOptions().toString());
            result.push(')');
        }
        
        result.push('\n');
        
        // 渲染限定符
        if (recursive && this.hasQualifier()) {
            let quals = [...this.getQualifierList()];
            let i = 0;
            while (quals.length > i &&
                    (XMPConst.XML_LANG === quals[i].getName() ||
                     "rdf:type" === quals[i].getName())
                  ) {
                i++;
            }
            quals.sort((a, b) => a.compareTo(b));
            for (i = 0; i < quals.length; i++) {
                quals[i].dumpNodeInternal(result, recursive, indent + 2, i + 1);
            }
        }
        
        // 渲染子节点
        if (recursive && this.hasChildren()) {
            let children = [...this.getChildren()];
            if (!this.getOptions().isArray()) {
                children.sort((a, b) => a.compareTo(b));
            }
            for (let i = 0; i < children.length; i++) {
                children[i].dumpNodeInternal(result, recursive, indent + 1, i + 1);
            }
        }
    }

    /**
     * 比较节点
     * @param xmpNode 要比较的节点
     * @return 比较结果
     */
    public compareTo(xmpNode: XMPNode): number {
        if (this.getOptions().isSchemaNode()) {
            const thisValue = this.value ?? '';
            const otherValue = xmpNode.getValue() ?? '';
            return thisValue.localeCompare(otherValue);
        } else {
            const thisName = this.name ?? '';
            const otherName = xmpNode.getName() ?? '';
            return thisName.localeCompare(otherName);
        }
    }

    /**
     * @return 返回节点名称
     */
    public getName(): string | null {
        return this.name;
    }

    /**
     * 设置节点名称
     * @param name 要设置的名称
     */
    public setName(name: string): void {
        this.name = name;
    }

    /**
     * @return 返回节点值
     */
    public getValue(): string | null {
        return this.value;
    }

    /**
     * 设置节点值
     * @param value 要设置的值
     */
    public setValue(value: string | null): void {
        this.value = value;
    }

    /**
     * @return 返回节点选项
     */
    public getOptions(): PropertyOptions {
        if (this.options === null) {
            this.options = new PropertyOptions();
        }
        return this.options;
    }

    /**
     * 更新节点选项
     * @param options 要设置的选项
     */
    public setOptions(options: PropertyOptions): void {
        this.options = options;
    }

    /**
     * @return 返回implicit标志
     */
    public isImplicit(): boolean {
        return this.implicit;
    }

    /**
     * 设置implicit节点标志
     * @param implicit 标志值
     */
    public setImplicit(implicit: boolean): void {
        this.implicit = implicit;
    }

    /**
     * @return 节点是否包含别名（仅适用于schema节点）
     */
    public getHasAliases(): boolean {
        return this.hasAliases;
    }

    /**
     * 设置节点包含别名的标志
     * @param hasAliases 标志值
     */
    public setHasAliases(hasAliases: boolean): void {
        this.hasAliases = hasAliases;
    }

    /**
     * @return 节点是否是别名
     */
    public isAlias(): boolean {
        return this.alias;
    }

    /**
     * 设置节点是否是别名的标志
     * @param alias 标志值
     */
    public setAlias(alias: boolean): void {
        this.alias = alias;
    }

    /**
     * @return 节点是否有"rdf:value"子节点
     */
    public getHasValueChild(): boolean {
        return this.hasValueChild;
    }

    /**
     * 设置节点是否有"rdf:value"子节点的标志
     * @param hasValueChild 标志值
     */
    public setHasValueChild(hasValueChild: boolean): void {
        this.hasValueChild = hasValueChild;
    }

    /**
     * 检查节点是否是语言节点
     * @return 是否是语言节点
     */
    private isLanguageNode(): boolean {
        return this.name === XMPConst.XML_LANG;
    }

    /**
     * 检查节点是否是类型节点
     * @return 是否是类型节点
     */
    private isTypeNode(): boolean {
        return this.name === "rdf:type";
    }

    /**
     * 断言子节点不存在
     * @param name 要检查的名称
     * @throws XMPException 如果子节点已存在
     */
    private assertChildNotExisting(name: string): void {
        if (XMPConst.ARRAY_ITEM_NAME !== name &&
            this.findChildByName(name) != null) {
            throw new XMPException("Duplicate property or field node '" + name + "'",
                XMPError.BADXMP);
        }
    }

    /**
     * 断言限定符不存在
     * @param name 要检查的名称
     * @throws XMPException 如果限定符已存在
     */
    private assertQualifierNotExisting(name: string): void {
        if (XMPConst.ARRAY_ITEM_NAME !== name &&
            this.findQualifierByName(name) != null) {
            throw new XMPException("Duplicate '" + name + "' qualifier", XMPError.BADXMP);
        }
    }

    /**
     * 在节点数组中查找指定名称的节点
     * @param nodes 节点数组
     * @param name 要查找的名称
     * @return 找到的节点或null
     */
    private find(nodes: XMPNode[] | null, name: string): XMPNode | null {
        if (nodes != null) {
            for (const node of nodes) {
                if (node.getName() === name) {
                    return node;
                }
            }
        }
        return null;
    }
    
    /**
     * 排序完整的数据模型，按照以下规则：
     * <ul>
     * 		<li>同一级别的节点按名称排序，即前缀+本地名称
     * 		<li>从根节点开始递归排序子节点和限定符，以下是例外情况
     * 		<li>数组不进行排序
     * 		<li>在限定符中，"xml:lang"和/或"rdf:type"保持在顶部，顺序固定，其他限定符排序
     * </ul>
     */
    public sort(): void {
        // 排序限定符
        if (this.hasQualifier()) {
            const quals = [...this.getQualifierList()];
            let sortFrom = 0;
            while (
                quals.length > sortFrom &&
                (XMPConst.XML_LANG === quals[sortFrom].getName() ||
                 "rdf:type" === quals[sortFrom].getName())
            ) {
                quals[sortFrom].sort();
                sortFrom++;
            }

            quals.sort((a, b) => a.compareTo(b));
            
            const qualifierList = this.getQualifierList();
            for (let j = 0; j < quals.length; j++) {
                qualifierList[j] = quals[j];
                quals[j].sort();
            }
        }
        
        // 排序子节点
        if (this.hasChildren()) {
            if (!this.getOptions().isArray()) {
                this.getChildren().sort((a, b) => a.compareTo(b));
            }
            for (const child of this.getChildren()) {
                child.sort();
            }
        }
    }
}