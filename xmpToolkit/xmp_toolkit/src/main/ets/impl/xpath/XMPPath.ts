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

import XMPPathSegment from './XMPPathSegment';

/**
 * 表示XMP路径，提供段访问方法
 * 
 * @since 28.02.2006
 */
export default class XMPPath {
    // XPathStepInfo选项的位标记
    
    /** 标记结构体字段步骤，也适用于顶级节点（模式"字段"） */
    public static readonly  STRUCT_FIELD_STEP: number = 0x01;
    /** 标记限定符步骤
     * 注意：顺序对于区分结构体/限定符和数组类型很重要！ */
    public static readonly QUALIFIER_STEP: number = 0x02;
    /** 标记数组索引步骤 */
    public static readonly ARRAY_INDEX_STEP: number = 0x03;
    /** 数组最后一项步骤 */
    public static readonly ARRAY_LAST_STEP: number = 0x04;
    /** 限定符选择器步骤 */
    public static readonly QUAL_SELECTOR_STEP: number = 0x05;
    /** 字段选择器步骤 */
    public static readonly FIELD_SELECTOR_STEP: number = 0x06;
    /** 模式节点 */
    public static readonly SCHEMA_NODE: number = 0x80000000;
    /** 模式步骤 */
    public static readonly STEP_SCHEMA: number = 0;
    /** 根属性步骤 */
    public static readonly STEP_ROOT_PROP: number = 1;
    
    /** 存储XMPPath的段 */
    private segments: XMPPathSegment[] = [];
    
    /**
     * 添加路径段
     * 
     * @param segment 要添加的段
     */
    public add(segment: XMPPathSegment): void {
        this.segments.push(segment);
    }

    /**
     * @param index 要返回的段的索引
     * @return 返回路径段
     */
    public getSegment(index: number): XMPPathSegment {
        return this.segments[index];
    }
    
    /**
     * @return 返回xmp路径的大小
     */
    public size(): number {
        return this.segments.length;
    }
    
    /**
     * 序列化标准化的XMP路径
     */
    public toString(): string {
        let result: string = '';
        let index: number = 1;
        while (index < this.size()) {
            result += this.getSegment(index);
            if (index < this.size() - 1) {
                const kind: number | undefined = this.getSegment(index + 1).getKind();
                if (kind === XMPPath.STRUCT_FIELD_STEP || kind === XMPPath.QUALIFIER_STEP) {
                    // 除了最后一个和数组索引外的所有情况
                    result += '/';
                }
            }
            index++;
        }
        
        return result;
    }
}