/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Weight } from './FontHelpers';
import rive from 'libohos_rive.so';

/**
 * 字体字节数组类型别名
 */
export type FontBytes = Uint8Array;

/**
 * 定义一种策略，用于在 Rive 文件中找不到字符或未提供字体时，
 * 提供具有特定字重的回退字体。
 *
 * 此接口允许基于指定的字重提供不同回退字体集的自定义实现。
 *
 * ## 实现策略：
 * - **在给定作用域内**：可以在组件中实现策略
 * - **在全局级别**：可以在加载需要回退字体的 Rive 文件之前全局设置回退策略
 *
 * `stylePicker` 使用弱引用管理，允许垃圾回收器自动清理未使用的 `FontFallbackStrategy` 引用。
 * 一旦引用的对象被垃圾回收，弱引用将返回 `null`，确保内存得到有效管理和释放。
 *
 * ## 用法
 * - 实现 `getFont()` 以返回指定字重的 `FontBytes` 列表。
 * - 使用静态属性 `stylePicker` 管理回退策略。
 * - `pickFont()` 从原生 C++ 代码静态调用，当检测到缺失字符时提供回退字体。
 */
export abstract class FontFallbackStrategy {
  /**
   * 返回一个 `FontBytes`（即 `Uint8Array`）列表，表示运行时将用于尝试匹配
   * Rive 文件中缺失字符的字体。
   *
   * 运行时按先进先出（FIFO）顺序尝试匹配字符，从索引 0 的字体开始，然后继续到索引 1，依此类推，
   * 直到找到包含所需字符的字体或列表耗尽。
   *
   * **缓存行为：** 此函数仅在运行时的内部原生缓存不包含请求的 `weight` 的回退字体数据时
   * 由 Rive 运行时调用。返回的 `FontBytes` 列表会立即解码为原生字体表示并缓存在内部，
   * 以 `weight` 为键。对*相同字重*的后续请求将使用此缓存，并且此函数**不会再次为该字重调用**。
   * 与特定 [FontFallbackStrategy] 实例关联的原生缓存仅在为 Rive 运行时配置*新*策略实例时清除
   * （即通过设置新的 [stylePicker] 或等效配置）。您的实现应在初始调用期间返回请求的 `weight`
   * 的完整有序回退字体列表，因为它代表该字重类别在该策略实例处于活动状态时的确定集合。
   *
   * @param weight 需要回退的字体的字重。
   * @return 用于字符回退的字体字节数组列表，按优先级排序。
   */
  public abstract getFont(weight: Weight): FontBytes[];

  private static stylePickerRef: WeakRef<FontFallbackStrategy> | null = null;

  /**
   * 获取或设置当前的字体回退策略
   */
  public static get stylePicker(): FontFallbackStrategy | null {
    return this.stylePickerRef?.deref() ?? null;
  }

  public static set stylePicker(value: FontFallbackStrategy | null) {
    if (this.stylePicker !== value) {
      this.stylePickerRef = value ? new WeakRef(value) : null;
      this.cppResetFontCache();
    }
  }

  /**
   * 重置字体缓存（从原生代码调用）
   */
  private static cppResetFontCache(): void {
    rive.Napi_Font_cppResetFontCache();
  }

  /**
   * 从原生 C++ 代码静态调用以获取字体
   * @param uWeight 字重的整数值
   * @return 字体字节数组列表
   */
  public static pickFont(uWeight: number): FontBytes[] {
    const sp = FontFallbackStrategy.stylePicker;
    if (!sp) {
      return [];
    }
    const weight = Weight.fromInt(uWeight);
    return sp.getFont(weight);
  }
}


