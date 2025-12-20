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

import { RendererType } from '../renderers/RendererType';
import { Alignment } from './Alignment';
import { Fit } from './Fit';
import rive from 'libohos_rive.so';
import { FontOpts, NativeFontHelper } from '../fonts/FontHelpers';
interface FallbackSig {
  len: number;
  head: number;
  tail: number;
}

interface Bounds {
  left: number;
  top: number;
  right: number;
  bottom: number;
}

class RectF {
  public left: number = 0;
  public top: number = 0;
  public right: number = 0;
  public bottom: number = 0;

  constructor(left?: number, top?: number, right?: number, bottom?: number) {
    if (left !== undefined) {
      this.left = left;
    }
    if (top !== undefined) {
      this.top = top;
    }
    if (right !== undefined) {
      this.right = right;
    }
    if (bottom !== undefined) {
      this.bottom = bottom;
    }
  }

  get width(): number {
    return this.right - this.left;
  }

  get height(): number {
    return this.bottom - this.top;
  }

  set(width: number, height: number): void {
    this.right = this.left + width;
    this.bottom = this.top + height;
  }
}

export class RiveManager {
  private static instance: RiveManager | null = null;
  private static _defaultRendererType: RendererType = RendererType.Rive;
  private static isInitialized: boolean = false;
  private static fallbackSigCache: FallbackSig[] = [];
  private static readonly fallbackSigLimit: number = 5;

  private constructor() {}

  public static getInstance(): RiveManager {
    if (!RiveManager.instance) {
      RiveManager.instance = new RiveManager();
    }
    return RiveManager.instance;
  }

  private defaultRendererType: RendererType = RendererType.Rive

  init(context: Context, defaultRenderer: RendererType = RendererType.Rive) {
    this.defaultRendererType = defaultRenderer;
    this.initializeCppEnvironment();
  }

  initializeCppEnvironment(): void {
    console.log(`[ohos_rive_ui] Rive.ets: initializeCppEnvironment C++ Napi_Rive_cppInitialize`);
    rive.Napi_Rive_cppInitialize();
  }

  /**
   * Calculate the required bounding rectangle
   *
   * This function calls the underlying C++ interface to compute the actual required bounding rectangle
   * based on fit mode, alignment, available bounds, and artboard bounds.
   *
   * @param fit The fit mode that determines how to scale content to fit the available space
   * @param alignment The alignment method that determines where content is positioned within the available space
   * @param availableBounds The available bounds that define the usable display area
   * @param artboardBounds The artboard bounds that define the original content boundaries
   * @param scaleFactor The scaling factor used to adjust the final scale ratio
   * @returns The computed required bounding rectangle
   */
  calculateRequiredBounds1(fit: Fit, alignment: Alignment, availableBounds: Bounds, artboardBounds: Bounds,
    scaleFactor: number
  ): RectF {
    console.log(`[ohos_rive_ui] Rive.ets: calculateRequiredBounds1 C++ Napi_Rive_cppCalculateRequiredBounds`);
    let requiredBounds = new RectF();
    rive.Napi_Rive_cppCalculateRequiredBounds(
      fit,
      alignment,
      availableBounds,
      artboardBounds,
      requiredBounds,
      scaleFactor
    )
    return requiredBounds
  }

  /**
   * Set a fallback font for the Rive runtime.
   *
   * @param byteArray The [Uint8Array] bytes for a font file.
   * @param opts The [FontOpts] specifying the desired font characteristics. If not
   *    provided, default options are used.
   * @return Whether the font was successfully registered.
   */

  setFallbackFont(context: Context, byteArray?: Uint8Array, opts?: FontOpts): boolean {
    if (!(byteArray && byteArray instanceof Uint8Array)) {
      return false;
    }

    const sig = this.computeSig(byteArray);
    const hit = RiveManager.fallbackSigCache.find(
      item => item.len === sig.len && item.head === sig.head && item.tail === sig.tail
    );
    if (hit) {
      return true;
    }
    const ok = NativeFontHelper.cppRegisterFallbackFont(byteArray);
    if (ok) {
      RiveManager.fallbackSigCache.push(sig);
      if (RiveManager.fallbackSigCache.length > RiveManager.fallbackSigLimit) {
        RiveManager.fallbackSigCache.shift();
      }
    }
    return ok;
  }

  private computeSig(bytes: Uint8Array): FallbackSig {
    const len = bytes.length;
    if (len < 4) {
      const head = this.pack4(bytes, 0);
      return { len, head, tail: head };
    }
    const head = this.pack4(bytes, 0);
    const tail = this.pack4(bytes, len - 4);
    return { len, head, tail };
  }

  private pack4(bytes: Uint8Array, offset: number): number {
    return (
      ((bytes[offset] ?? 0) << 24) |
      ((bytes[offset + 1] ?? 0) << 16) |
      ((bytes[offset + 2] ?? 0) << 8) |
      ((bytes[offset + 3] ?? 0) << 0)
    ) >>> 0;
  }
}