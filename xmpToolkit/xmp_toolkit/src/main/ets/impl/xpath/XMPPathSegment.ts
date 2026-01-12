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
 * 解析后的XMPPath的一个段
 *
 * @since 23.06.2006
 */
export default class XMPPathSegment {
  /** 路径段的名称 */
  private name: string;
  /** 路径段的类型 */
  private kind?: number = 0;
  /** 段是否是别名的标志 */
  private alias: boolean = false;
  /** 适用时的别名形式 */
  private aliasForm: number = 0;

  /**
   * 使用初始值构造
   *
   * @param name 段的名称
   * @param kind 段的类型
   */
  public constructor(name: string, kind?: number) {
    this.name = name;
    this.kind = kind;
  }

  /**
   * @return 返回段类型
   */
  public getKind(): number | undefined {
    return this.kind;
  }

  /**
   * @param kind 要设置的类型
   */
  public setKind(kind: number): void {
    this.kind = kind;
  }

  /**
   * @return 返回段名称
   */
  public getName(): string {
    return this.name;
  }

  /**
   * @param name 要设置的名称
   */
  public setName(name: string): void {
    this.name = name;
  }

  /**
   * @param alias 设置别名标志
   */
  public setAlias(alias: boolean): void {
    this.alias = alias;
  }

  /**
   * @return 返回是否是别名
   */
  public isAlias(): boolean {
    return this.alias;
  }

  /**
   * @param aliasForm 设置别名形式
   */
  public setAliasForm(aliasForm: number): void {
    this.aliasForm = aliasForm;
  }

  /**
   * @return 返回别名形式
   */
  public getAliasForm(): number {
    return this.aliasForm;
  }

  /**
   * 序列化路径段
   * @return 路径段的字符串表示
   */
  public toString(): string {
    return this.name;
  }
}