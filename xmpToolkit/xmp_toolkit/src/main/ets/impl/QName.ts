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

/**
 * 表示XML限定名(QName)，包含前缀和本地名两部分
 */
export default class QName {
    /** XML命名空间前缀 */
    private prefix: string;
    /** XML本地名 */
    private localName: string;
    
    /**
     * 从限定名中分离出前缀和本地名
     * @param qname 限定名
     */
    constructor(qname: string);
    
    /**
     * 构造函数，直接初始化前缀和本地名
     * @param prefix 前缀
     * @param localName 本地名
     */
    constructor(prefix: string, localName: string);
    
    /**
     * 构造函数实现
     */
    constructor(param1: string, param2?: string) {
        if (param2 === undefined) {
            // 单参数构造函数，从限定名中分离
            const qname: string = param1;
            const colon: number = qname.indexOf(':');
            
            if (colon >= 0) {
                this.prefix = qname.substring(0, colon);
                this.localName = qname.substring(colon + 1);
            } else {
                this.prefix = '';
                this.localName = qname;
            }
        } else {
            // 双参数构造函数，直接设置
            this.prefix = param1;
            this.localName = param2;
        }
    }
    
    /**
     * 检查QName是否有前缀
     * @return 如果有前缀返回true，否则返回false
     */
    public hasPrefix(): boolean {
        return this.prefix !== null && this.prefix.length > 0;
    }
    
    /**
     * 获取本地名
     * @return 本地名
     */
    public getLocalName(): string {
        return this.localName;
    }
    
    /**
     * 获取前缀
     * @return 前缀
     */
    public getPrefix(): string {
        return this.prefix;
    }
    
    /**
     * 获取完整的限定名表示
     * @return 完整的限定名，格式为"prefix:localName"或"localName"
     */
    public toString(): string {
        return this.hasPrefix() ? `${this.prefix}:${this.localName}` : this.localName;
    }
}