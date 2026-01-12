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
 * Options是所有选项类的基类
 */
import XMPException from '../XMPException';
import XMPError from '../XMPError';

/**
 * 选项基类
 */
export default abstract class Options {
  private options: number = 0;

  /**
   * 构造函数
   * @param options 初始选项值
   */
  constructor(options: number = 0) {
    this.setOptions(options);
  }

  /**
   * Is friendly to access it during the tests.
   * @return Returns the options.
   */
  getOptions(): number {
    return this.options;
  }

  /**
   * 设置所有选项值
   * @param options 选项值
   * @returns 自身实例
   * @throws XMPException 选项无效
   */
  setOptions(options: number): Options {
    this.assertConsistency(options);
    this.options = options;
    return this;
  }

  /**
   * 检查是否设置了指定的选项
   * @param optionBits 要检查的选项位
   * @returns 是否设置了该选项
   */
  containsAllOptions(optionBits: number): boolean {
    return (this.options & optionBits) == optionBits;
  }

  /**
   * 检查是否设置了任何指定的选项
   * @param optionBits 要检查的选项位
   * @returns 是否设置了任一选项
   */
  containsAnyOption(optionBits: number): boolean {
    return (this.options & optionBits) != 0;
  }

  /**
   * 设置单个选项
   * 注意：与 setOptions 不同，此方法不验证选项有效性（与 Java 版本一致）
   * @param optionBits 要设置的选项位
   * @param value 是否设置
   * @returns 自身实例
   */
  setOption(optionBits: number, value: boolean): Options {
    // Java 版本的 setOption 不调用 assertOptionsValid，直接设置选项位
    this.options = value ? (this.options | optionBits) : (this.options & ~optionBits);
    return this;
  }


  /**
   * 清除所有选项
   * @returns 自身实例
   */
  clearOptions(): Options {
    this.options = 0;
    return this;
  }

  /**
   * 获取有效选项的掩码
   * @returns 有效选项掩码
   */
  protected abstract getValidOptions(): number;

  /**
   * 验证选项的一致性
   * @param options 要验证的选项值
   * @throws XMPException 选项不一致
   */
  assertConsistency(options: number): void {
    // 检查是否有无效的选项位
    const invalidOptions = options & ~this.getValidOptions();
    if (invalidOptions != 0) {
      throw new XMPException('Invalid options: 0x' + invalidOptions.toString(16), XMPError.BADOPTIONS);
    }
  }

  /**
   * 获取选项的字符串表示
   * @returns 选项名称的逗号分隔列表
   */
  toString(): string {
    let result = '';
    let optionBits = this.options;
    let separator = '';

    // 从最低位开始，检查每一位
    let bit = 1;
    while (bit <= optionBits) {
      if ((optionBits & bit) != 0) {
        const optionName = this.defineOptionName(bit);
        if (optionName) {
          result += separator + optionName;
          separator = ', ';
        }
      }
      bit <<= 1;
    }

    return result;
  }

  /**
   * 定义选项名称（子类重写）
   * @param optionBits 选项位
   * @returns 选项名称
   */
  protected defineOptionName(optionBits: number): string | null {
    return null;
  }

  /**
   * 比较两个选项对象是否相等
   * @param other 另一个选项对象
   * @returns 是否相等
   */
  equals(other: ESObject): boolean {
    if (!(other instanceof Options)) {
      return false;
    }
    return this.options === other.options;
  }

  /**
   * 获取选项对象的哈希码
   * @returns 哈希码
   */
  hashCode(): number {
    return this.options;
  }

  /**
   * @param optionBits an option bitmask
   * @return Returns true, if this object contain at least one of the given options.
   */
  public containsOneOf(optionBits: number): boolean {
    return ((this.getOptions()) & optionBits) != 0;
  }


  /**
   * @param optionBit the binary bit or bits that are requested
   * @return Returns if <emp>all</emp> of the requested bits are set or not.
   */
  protected getOption(optionBit: number): boolean {
    return (this.options & optionBit) != 0;
  }
}