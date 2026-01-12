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
 * XMP错误代码定义
 */
export default  class XMPError {
  /** 未知错误 */
  static readonly UNKNOWN: number = 0;
  
  /** 参数错误 */
  static readonly BADPARAM: number = 4;
  
  /** 值错误 */
  static readonly BADVALUE: number = 5;
  
  /** 内部失败 */
  static readonly INTERNALFAILURE: number = 9;
  
  /** 模式错误 */
  static readonly BADSCHEMA: number = 101;
  
  /** XPath错误 */
  static readonly BADXPATH: number = 102;
  
  /** 选项错误 */
  static readonly BADOPTIONS: number = 103;
  
  /** 索引错误 */
  static readonly BADINDEX: number = 104;
  
  /** 序列化错误 */
  static readonly BADSERIALIZE: number = 107;
  
  /** XML错误 */
  static readonly BADXML: number = 201;
  
  /** RDF错误 */
  static readonly BADRDF: number = 202;
  
  /** XMP错误 */
  static readonly BADXMP: number = 203;
  
  /** 流错误（Java引入的错误代码） */
  static readonly BADSTREAM: number = 204;

  static readonly UNIMPLEMENTED: number = 999;
}

