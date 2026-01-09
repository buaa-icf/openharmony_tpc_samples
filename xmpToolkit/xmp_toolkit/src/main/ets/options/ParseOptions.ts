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
 * ParseOptions定义了XMP解析时的选项
 */
export default class ParseOptions extends Options {
  /** 宽松解析，忽略某些XML错误 */
  static readonly RELAXED_PARSING: number = 0x0001;
  /** 接受UTF-8以外的编码 */
  static readonly ACCEPT_LATIN_1: number = 0x0002;
  /** 不协调别名差异，抛出异常 */
  static readonly STRICT_ALIASING: number = 0x0004;
  /** 省略RDF解析 */
  static readonly OMIT_RDF: number = 0x0008;
  /** 要求XMP元数据包头 */
  static readonly REQUIRE_XMP_META: number = 0x0010;
  /** 严格解析 */
  static readonly STRICT_PARSING: number = 0x0020;
  /** 保留空白字符 */
  static readonly PRESERVE_WHITESPACE: number = 0x0040;

  /**
   * 构造函数
   * @param options 初始选项值
   */
  constructor(options: number = 0) {
    super(options);
  }

  /**
   * 设置是否使用宽松解析
   * @param value 是否使用宽松解析
   * @returns 自身实例
   */
  setRelaxedParsing(value: boolean): ParseOptions {
    return this.setOption(ParseOptions.RELAXED_PARSING, value) as ParseOptions;
  }

  /**
   * 检查是否使用宽松解析
   * @returns 是否使用宽松解析
   */
  getRelaxedParsing(): boolean {
    return this.containsOption(ParseOptions.RELAXED_PARSING);
  }

  /**
   * 设置是否接受Latin-1编码
   * @param value 是否接受Latin-1编码
   * @returns 自身实例
   */
  setAcceptLatin1(value: boolean): ParseOptions {
    return this.setOption(ParseOptions.ACCEPT_LATIN_1, value) as ParseOptions;
  }

  /**
   * 检查是否接受Latin-1编码
   * @returns 是否接受Latin-1编码
   */
  getAcceptLatin1(): boolean {
    return this.containsOption(ParseOptions.ACCEPT_LATIN_1);
  }

  /**
   * 设置是否省略RDF解析
   * @param value 是否省略RDF解析
   * @returns 自身实例
   */
  setOmitRDF(value: boolean): ParseOptions {
    return this.setOption(ParseOptions.OMIT_RDF, value) as ParseOptions;
  }

  /**
   * 检查是否省略RDF解析
   * @returns 是否省略RDF解析
   */
  getOmitRDF(): boolean {
    return this.containsOption(ParseOptions.OMIT_RDF);
  }

  /**
   * 设置是否要求XMP元数据包头
   * @param value 是否要求XMP元数据包头
   * @returns 自身实例
   */
  setRequireXMPMeta(value: boolean): ParseOptions {
    return this.setOption(ParseOptions.REQUIRE_XMP_META, value) as ParseOptions;
  }

  /**
   * 检查是否要求XMP元数据包头
   * @returns 是否要求XMP元数据包头
   */
  getRequireXMPMeta(): boolean {
    return this.containsOption(ParseOptions.REQUIRE_XMP_META);
  }

  /**
   * 设置是否使用严格别名处理
   * @param value 是否使用严格别名处理
   * @returns 自身实例
   */
  setStrictAliasing(value: boolean): ParseOptions {
    return this.setOption(ParseOptions.STRICT_ALIASING, value) as ParseOptions;
  }

  /**
   * 检查是否使用严格别名处理
   * @returns 是否使用严格别名处理
   */
  getStrictAliasing(): boolean {
    return this.containsOption(ParseOptions.STRICT_ALIASING);
  }

  /**
   * 设置是否使用严格解析
   * @param value 是否使用严格解析
   * @returns 自身实例
   */
  setStrictParsing(value: boolean): ParseOptions {
    return this.setOption(ParseOptions.STRICT_PARSING, value) as ParseOptions;
  }

  /**
   * 检查是否使用严格解析
   * @returns 是否使用严格解析
   */
  getStrictParsing(): boolean {
    return this.containsOption(ParseOptions.STRICT_PARSING);
  }

  /**
   * 设置是否保留空白字符
   * @param value 是否保留空白字符
   * @returns 自身实例
   */
  setPreserveWhitespace(value: boolean): ParseOptions {
    return this.setOption(ParseOptions.PRESERVE_WHITESPACE, value) as ParseOptions;
  }

  /**
   * 检查是否保留空白字符
   * @returns 是否保留空白字符
   */
  getPreserveWhitespace(): boolean {
    return this.containsOption(ParseOptions.PRESERVE_WHITESPACE);
  }

  /**
   * 获取有效选项的掩码
   * @returns 有效选项掩码
   */
  getValidOptions(): number {
    return (
      ParseOptions.RELAXED_PARSING |
      ParseOptions.ACCEPT_LATIN_1 |
      ParseOptions.STRICT_ALIASING |
      ParseOptions.OMIT_RDF |
      ParseOptions.REQUIRE_XMP_META |
      ParseOptions.STRICT_PARSING |
      ParseOptions.PRESERVE_WHITESPACE
    );
  }

  /**
   * 定义选项名称
   * @param optionBits 选项位
   * @returns 选项名称
   */
  protected defineOptionName(optionBits: number): string | null {
    switch (optionBits) {
      case ParseOptions.RELAXED_PARSING:
        return "RELAXED_PARSING";
      case ParseOptions.ACCEPT_LATIN_1:
        return "ACCEPT_LATIN_1";
      case ParseOptions.STRICT_ALIASING:
        return "STRICT_ALIASING";
      case ParseOptions.OMIT_RDF:
        return "OMIT_RDF";
      case ParseOptions.REQUIRE_XMP_META:
        return "REQUIRE_XMP_META";
      case ParseOptions.STRICT_PARSING:
        return "STRICT_PARSING";
      case ParseOptions.PRESERVE_WHITESPACE:
        return "PRESERVE_WHITESPACE";
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