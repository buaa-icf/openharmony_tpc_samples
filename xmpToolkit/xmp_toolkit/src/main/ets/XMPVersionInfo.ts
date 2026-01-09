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
 * XMP工具包版本信息接口
 * 版本信息存储在库中，可通过XMPMetaFactory.getVersionInfo()获取
 */
export default interface XMPVersionInfo {
  /**
   * 获取主版本号，如版本"1.2.3"中的"1"
   * @returns 主版本号
   */
  getMajor(): number;

  /**
   * 获取次版本号，如版本"1.2.3"中的"2"
   * @returns 次版本号
   */
  getMinor(): number;

  /**
   * 获取第三版本号，如版本"1.2.3"中的"3"
   * @returns 第三版本号
   */
  getMicro(): number;

  /**
   * 获取构建号，在一个版本中单调递增
   * @returns 构建号
   */
  getBuild(): number;

  /**
   * 检查是否为调试构建
   * @returns 是否为调试构建
   */
  isDebug(): boolean;
  
  /**
   * 获取完整的版本信息字符串
   * @returns 版本信息字符串
   */
  getMessage(): string;
}