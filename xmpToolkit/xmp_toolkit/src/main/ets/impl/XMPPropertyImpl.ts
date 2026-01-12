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
 * XMPProperty implementation class.
 * This class implements the XMPProperty interface for use in XMPMetaImpl.
 */

import XMPProperty from '../properties/XMPProperty';
import PropertyOptions from '../options/PropertyOptions';

/**
 * Implementation of XMPProperty interface.
 */
export default class XMPPropertyImpl implements XMPProperty {
  private value: string;
  private options: PropertyOptions;
  private language: string;

  /**
   * Creates a new XMPPropertyImpl instance.
   * @param value The property value.
   * @param options The property options.
   * @param language The property language (optional, defaults to empty string).
   */
  constructor(value: string, options: PropertyOptions, language: string = "") {
    this.value = value;
    this.options = options;
    this.language = language;
  }

  /**
   * @return Returns the value of the property.
   */
  public getValue(): string {
    return this.value;
  }

  /**
   * @return Returns the options of the property.
   */
  public getOptions(): PropertyOptions {
    return this.options;
  }

  /**
   * @return Returns the language of the property.
   */
  public getLanguage(): string {
    return this.language;
  }
}

