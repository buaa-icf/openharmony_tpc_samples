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
import PropertyOptions from './PropertyOptions';

/**
 * AliasOptions定义了XMP别名的选项
 */
export default class AliasOptions extends Options {
  /** This is a direct mapping. The actual data type does not matter. */
  public static readonly PROP_DIRECT: number = 0;
  /** The actual is an unordered array, the alias is to the first element of the array. */
  public static readonly PROP_ARRAY: number = PropertyOptions.ARRAY;
  /** The actual is an ordered array, the alias is to the first element of the array. */
  public static readonly PROP_ARRAY_ORDERED: number = PropertyOptions.ARRAY_ORDERED;
  /** The actual is an alternate array, the alias is to the first element of the array. */
  public static readonly PROP_ARRAY_ALTERNATE: number = PropertyOptions.ARRAY_ALTERNATE;
  /**
   * The actual is an alternate text array, the alias is to the 'x-default' element of the array.
   */
  public static readonly PROP_ARRAY_ALT_TEXT: number = PropertyOptions.ARRAY_ALT_TEXT;

  /**
   * 构造函数
   * @param options 初始选项值
   */
  constructor(options: number = 0) {
    super(options);
  }

  /**
   * @return Returns if the alias is of the simple form.
   */
  public isSimple(): boolean {
    return this.getOptions() == AliasOptions.PROP_DIRECT;
  }


  /**
   * @return Returns the option.
   */
  public isArray(): boolean {
    return this.getOption(AliasOptions.PROP_ARRAY);
  }


  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setArray(value: boolean): AliasOptions {
    this.setOption(AliasOptions.PROP_ARRAY, value);
    return this;
  }


  /**
   * @return Returns the option.
   */
  public isArrayOrdered(): boolean {
    return this.getOption(AliasOptions.PROP_ARRAY_ORDERED);
  }


  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setArrayOrdered(value: boolean): AliasOptions {
    this.setOption(AliasOptions.PROP_ARRAY | AliasOptions.PROP_ARRAY_ORDERED, value);
    return this;
  }


  /**
   * @return Returns the option.
   */
  public isArrayAlternate(): boolean {
    return this.getOption(AliasOptions.PROP_ARRAY_ALTERNATE);
  }


  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setArrayAlternate(value: boolean): AliasOptions {
    this.setOption(AliasOptions.PROP_ARRAY | AliasOptions.PROP_ARRAY_ORDERED | AliasOptions.PROP_ARRAY_ALTERNATE,
      value);
    return this;
  }


  /**
   * @return Returns the option.
   */
  public isArrayAltText(): boolean {
    return this.getOption(AliasOptions.PROP_ARRAY_ALT_TEXT);
  }


  /**
   * @param value the value to set
   * @return Returns the instance to call more set-methods.
   */
  public setArrayAltText(value: boolean): AliasOptions {
    this.setOption(AliasOptions.PROP_ARRAY | AliasOptions.PROP_ARRAY_ORDERED |
    AliasOptions.PROP_ARRAY_ALTERNATE | AliasOptions.PROP_ARRAY_ALT_TEXT, value);
    return this;
  }


  /**
   * @return returns a {@link PropertyOptions}s object
   * @throws XMPException If the options are not consistant.
   */
  public toPropertyOptions(): PropertyOptions {
    return new PropertyOptions(this.getOptions());
  }


  /**
   * @see Options#defineOptionName(int)
   */
  protected defineOptionName(option: number): string | null {
    switch (option) {
      case AliasOptions.PROP_DIRECT:
        return "PROP_DIRECT";
      case AliasOptions.PROP_ARRAY:
        return "ARRAY";
      case AliasOptions.PROP_ARRAY_ORDERED:
        return "ARRAY_ORDERED";
      case AliasOptions.PROP_ARRAY_ALTERNATE:
        return "ARRAY_ALTERNATE";
      case AliasOptions.PROP_ARRAY_ALT_TEXT:
        return "ARRAY_ALT_TEXT";
      default:
        return null;
    }
  }


  /**
   * @see Options#getValidOptions()
   */
  protected getValidOptions(): number {
    return AliasOptions.PROP_DIRECT |
    AliasOptions.PROP_ARRAY |
    AliasOptions.PROP_ARRAY_ORDERED |
    AliasOptions.PROP_ARRAY_ALTERNATE |
    AliasOptions.PROP_ARRAY_ALT_TEXT;
  }
}