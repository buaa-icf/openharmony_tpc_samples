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

import Options from './Options';

/**
 * IteratorOptions定义了XMP迭代器的选项
 */
export default class IteratorOptions extends Options {
  /** 只迭代直接子级 */
  static readonly JUST_CHILDREN: number = 0x0100;
  /** 只迭代叶节点 */
  static readonly JUST_LEAFNODES: number = 0x0200;
  /** 只返回路径的叶部分，默认是完整路径 */
  static readonly JUST_LEAFNAME: number = 0x0400;
  /** 包含别名 */
  static readonly INCLUDE_ALIASES: number = 0x0800;
  /** 只迭代自身 */
  static readonly JUST_SELF: number = 0x0800;
  /** 只迭代属性 */
  static readonly JUST_ATTRIBUTES: number = 0x1000;
  /** 省略限定符 */
  static readonly OMIT_QUALIFIERS: number = 0x2000;
  /** 包含隐式属性 */
  static readonly INCLUDE_IMPLICIT: number = 0x4000;
  /** 跳转到架构 */
  static readonly JUMP_TO_SCHEMA: number = 0x8000;
  /** 跳转到属性 */
  static readonly JUMP_TO_PROPERTY: number = 0x10000;

  /**
   * 构造函数
   * @param options 初始选项值
   */
  constructor(options: number = 0) {
    super(options);
  }

  /**
   * 设置是否只迭代直接子级
   * @param value 是否只迭代直接子级
   * @returns 自身实例
   */
  setJustChildren(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.JUST_CHILDREN, value) as IteratorOptions;
  }

  /**
   * 检查是否只迭代直接子级
   * @returns 是否只迭代直接子级
   */
  isJustChildren(): boolean {
    return this.containsOption(IteratorOptions.JUST_CHILDREN);
  }

  /**
   * 设置是否只迭代叶节点
   * @param value 是否只迭代叶节点
   * @returns 自身实例
   */
  setJustLeafnodes(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.JUST_LEAFNODES, value) as IteratorOptions;
  }

  /**
   * 检查是否只迭代叶节点
   * @returns 是否只迭代叶节点
   */
  isJustLeafnodes(): boolean {
    return this.containsOption(IteratorOptions.JUST_LEAFNODES);
  }

  /**
   * 设置是否只返回路径的叶部分
   * @param value 是否只返回路径的叶部分
   * @returns 自身实例
   */
  setJustLeafname(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.JUST_LEAFNAME, value) as IteratorOptions;
  }

  /**
   * 检查是否只返回路径的叶部分
   * @returns 是否只返回路径的叶部分
   */
  isJustLeafname(): boolean {
    return this.containsOption(IteratorOptions.JUST_LEAFNAME);
  }

  /**
   * 设置是否包含别名
   * @param value 是否包含别名
   * @returns 自身实例
   */
  setIncludeAliases(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.INCLUDE_ALIASES, value) as IteratorOptions;
  }

  /**
   * 检查是否包含别名
   * @returns 是否包含别名
   */
  isIncludeAliases(): boolean {
    return this.containsOption(IteratorOptions.INCLUDE_ALIASES);
  }

  /**
   * 设置是否只迭代自身
   * @param value 是否只迭代自身
   * @returns 自身实例
   */
  setJustSelf(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.JUST_SELF, value) as IteratorOptions;
  }

  /**
   * 检查是否只迭代自身
   * @returns 是否只迭代自身
   */
  isJustSelf(): boolean {
    return this.containsOption(IteratorOptions.JUST_SELF);
  }

  /**
   * 设置是否只迭代属性
   * @param value 是否只迭代属性
   * @returns 自身实例
   */
  setJustAttributes(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.JUST_ATTRIBUTES, value) as IteratorOptions;
  }

  /**
   * 检查是否只迭代属性
   * @returns 是否只迭代属性
   */
  isJustAttributes(): boolean {
    return this.containsOption(IteratorOptions.JUST_ATTRIBUTES);
  }

  /**
   * 设置是否省略限定符
   * @param value 是否省略限定符
   * @returns 自身实例
   */
  setOmitQualifiers(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.OMIT_QUALIFIERS, value) as IteratorOptions;
  }

  /**
   * 检查是否省略限定符
   * @returns 是否省略限定符
   */
  isOmitQualifiers(): boolean {
    return this.containsOption(IteratorOptions.OMIT_QUALIFIERS);
  }

  /**
   * 设置是否包含隐式属性
   * @param value 是否包含隐式属性
   * @returns 自身实例
   */
  setIncludeImplicit(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.INCLUDE_IMPLICIT, value) as IteratorOptions;
  }

  /**
   * 检查是否包含隐式属性
   * @returns 是否包含隐式属性
   */
  isIncludeImplicit(): boolean {
    return this.containsOption(IteratorOptions.INCLUDE_IMPLICIT);
  }

  /**
   * 设置是否跳转到架构
   * @param value 是否跳转到架构
   * @returns 自身实例
   */
  setJumpToSchema(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.JUMP_TO_SCHEMA, value) as IteratorOptions;
  }

  /**
   * 检查是否跳转到架构
   * @returns 是否跳转到架构
   */
  isJumpToSchema(): boolean {
    return this.containsOption(IteratorOptions.JUMP_TO_SCHEMA);
  }

  /**
   * 设置是否跳转到属性
   * @param value 是否跳转到属性
   * @returns 自身实例
   */
  setJumpToProperty(value: boolean): IteratorOptions {
    return this.setOption(IteratorOptions.JUMP_TO_PROPERTY, value) as IteratorOptions;
  }

  /**
   * 检查是否跳转到属性
   * @returns 是否跳转到属性
   */
  isJumpToProperty(): boolean {
    return this.containsOption(IteratorOptions.JUMP_TO_PROPERTY);
  }

  /**
   * 获取有效选项的掩码
   * @returns 有效选项掩码
   */
  getValidOptions(): number {
    return (
      IteratorOptions.JUST_CHILDREN |
      IteratorOptions.JUST_LEAFNODES |
      IteratorOptions.JUST_LEAFNAME |
      IteratorOptions.INCLUDE_ALIASES |
      IteratorOptions.JUST_SELF |
      IteratorOptions.JUST_ATTRIBUTES |
      IteratorOptions.OMIT_QUALIFIERS |
      IteratorOptions.INCLUDE_IMPLICIT |
      IteratorOptions.JUMP_TO_SCHEMA |
      IteratorOptions.JUMP_TO_PROPERTY
    );
  }

  /**
   * 定义选项名称
   * @param optionBits 选项位
   * @returns 选项名称
   */
  protected defineOptionName(optionBits: number): string | null {
    switch (optionBits) {
      case IteratorOptions.JUST_CHILDREN:
        return "JUST_CHILDREN";
      case IteratorOptions.JUST_LEAFNODES:
        return "JUST_LEAFNODES";
      case IteratorOptions.JUST_LEAFNAME:
        return "JUST_LEAFNAME";
      case IteratorOptions.INCLUDE_ALIASES:
        return "INCLUDE_ALIASES";
      case IteratorOptions.JUST_SELF:
        return "JUST_SELF";
      case IteratorOptions.JUST_ATTRIBUTES:
        return "JUST_ATTRIBUTES";
      case IteratorOptions.OMIT_QUALIFIERS:
        return "OMIT_QUALIFIERS";
      case IteratorOptions.INCLUDE_IMPLICIT:
        return "INCLUDE_IMPLICIT";
      case IteratorOptions.JUMP_TO_SCHEMA:
        return "JUMP_TO_SCHEMA";
      case IteratorOptions.JUMP_TO_PROPERTY:
        return "JUMP_TO_PROPERTY";
      default:
        return null;
    }
  }

  /**
   * 检查是否包含指定选项
   * @param optionBits 要检查的选项位
   * @returns 是否包含该选项
   */
  private containsOption(optionBits: number): boolean {
    return (this.getOptions() & optionBits) != 0;
  }
}