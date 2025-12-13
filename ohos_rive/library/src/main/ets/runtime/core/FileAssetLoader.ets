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

import rive from 'libohos_rive.so';
import http from '@ohos.net.http';
import { RendererType } from '../renderers/RendererType';
import { FileAsset } from './FileAsset';
import { NativeObject } from './NativeObject';

/**
 * Base class for asset loading. Overload loadContents to customize the loading process.
 *
 *  - Allows choosing how assets (images, fonts, audio) are loaded when referenced by a Rive file.
 *  - Asset loaders are typed to a specific {@link RendererType} because images are renderer specific.
 *  - The loader creates {@link FileAsset}s, so it must share renderer details with C++.
 */
export abstract class FileAssetLoader extends NativeObject {
  protected rendererType: RendererType | null = null;

  protected constructor() {
    super(NativeObject.NULL_POINTER);
    const pointer = this.constructorCpp();
    if (pointer === NativeObject.NULL_POINTER) {
      throw new Error('Failed to create FileAssetLoader native instance.');
    }
    this.cppPointer = pointer;
    this.refs.incrementAndGet();
  }

  /* C++ constructor */
  protected constructorCpp(): BigInt {
    return rive.Napi_FileAssetLoader_constructor(this);
  }

  /* Destructor invoked when refs drop to zero */
  protected override cppDelete(pointer: BigInt): void {
    rive.Napi_FileAssetLoader_cppDelete(pointer);
  }

  protected cppRef(pointer: BigInt): void {
    rive.Napi_FileAssetLoader_cppRef(pointer);
  }

  private cppSetRendererType(pointer: BigInt, rendererTypeValue: number): void {
    rive.Napi_FileAssetLoader_cppSetRendererType(pointer, rendererTypeValue);
  }

  /**
   * Override this to customize how assets are loaded.
   * @param asset The {@link FileAsset} being loaded.
   * @param inBandBytes Bytes embedded inside the Rive file (empty when asset is referenced/hosted).
   * @returns true if the asset was loaded, false if the loader refused the asset.
   */
  abstract loadContents(asset: FileAsset, inBandBytes: Uint8Array): boolean;

  setRendererType(rendererType: RendererType): void {
    this.checkPointer();
    this.cppSetRendererType(this.cppPointer, rendererType);
    this.rendererType = rendererType;
  }

  getRendererType(): RendererType | null {
    return this.rendererType;
  }

  override acquire(): number {
    this.cppRef(this.cppPointer);
    return super.acquire();
  }

  getNativePtr(): BigInt {
    return this.cppPointer;
  }
}

/**
 * Asset loader with access to a Context-like object (for reflection-style instantiation).
 */
export abstract class ContextAssetLoader extends FileAssetLoader {
  protected readonly context: Context;

  protected constructor(context:Context) {
    super();
    this.context = context;
  }
}

/**
 * Default loader used when cascading multiple loaders (memory cache, local storage, network, etc.).
 */
export class FallbackAssetLoader extends FileAssetLoader {
  protected readonly loaders: FileAssetLoader[] = [];
  private readonly context: Context | null;

  constructor(
    context: Context | null,
    loadCDNAssets: boolean = true,
    loader: FileAssetLoader | null = null
  ) {
    super();
    this.context = context;
    if (loader) {
      this.appendLoader(loader);
    }
    if (loadCDNAssets && context) {
      this.appendLoader(new CDNAssetLoader(context));
    }
  }

  appendLoader(loader: FileAssetLoader): void {
    this.loaders.push(loader);
    this.addDependency(loader);
  }

  prependLoader(loader: FileAssetLoader): void {
    this.loaders.unshift(loader);
    this.addDependency(loader);
  }

  loadContents(asset: FileAsset, inBandBytes: Uint8Array): boolean {
    console.info('Number of loaders:', this.loaders.length);
    console.info('Asset cdnUrl:', asset.cdnUrl);
    console.info('In-band bytes length:', inBandBytes.length);

    for (let i = 0; i < this.loaders.length; i++) {
      const loader = this.loaders[i];
      console.info(`Trying loader ${i}:`, loader.constructor.name);
      const result = loader.loadContents(asset, inBandBytes);
      console.info(`Loader ${i} result:`, result);
      if (result) {
        console.info(`Loader ${i} accepted the asset`);
        return true;
      }
    }

    console.info('All loaders refused the asset');
    return false;
  }

  private resetCDNLoader(needsCDNLoader: boolean): void {
    const cdnIndex = this.loaders.findIndex(loader => loader instanceof CDNAssetLoader);
    if (needsCDNLoader && cdnIndex === -1 && this.context) {
      this.appendLoader(new CDNAssetLoader(this.context));
      return;
    }
    if (!needsCDNLoader && cdnIndex >= 0) {
      const removed = this.loaders.splice(cdnIndex, 1)[0];
      this.removeDependency(removed);
      removed.release();
    }
  }
 /**TODO ohos_rive 需要RiveAnimationView 实现
  resetWith(builder: RiveAnimationView.Builder): void {
    // First, try setting up a custom loader.
    builder.assetLoader?.let {
      // Prepend loader to make sure custom always executes first.
      prependLoader(it)
    }
    resetCDNLoader(builder.shouldLoadCDNAssets, builder.context.applicationContext)
  }
*/
  override setRendererType(rendererType: RendererType): void {
    super.setRendererType(rendererType);
    for (const loader of this.loaders) {
      loader.setRendererType(rendererType);
    }
  }

  override acquire(): number {
    const count = super.acquire();
    this.loaders.forEach(loader => loader.acquire());
    return count;
  }

  override release(): number {
    const count = super.release();
    this.loaders.forEach(loader => loader.release());
    return count;
  }
}

/**
 * Loads assets from Rive's CDN when marked as "Hosted" in the editor.
 */
export class CDNAssetLoader extends ContextAssetLoader {
  private readonly tag = 'CDNAssetLoader';

  constructor(context: Context ) {
    super(context);
  }

  loadContents(asset: FileAsset, inBandBytes: Uint8Array): boolean {
    const url = asset.cdnUrl;
    if (!url || url.trim() === '') {
      return false;
    }

    const httpRequest = http.createHttp();
    httpRequest
      .request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 30000,
        readTimeout: 30000,
        expectDataType: http.HttpDataType.ARRAY_BUFFER
      })
      .then(response => {
        if (response.responseCode !== 200) {
          console.error(`${this.tag}: HTTP ${response.responseCode} for ${url}`);
          return;
        }
        
        const result = response.result;
        if (!(result instanceof ArrayBuffer)) {
          console.error(
            `${this.tag}:Expected ArrayBuffer but got ${typeof result}. This may indicate a configuration issue.`
          );
          return;
        }
        const arrayBuffer = result;
        if (arrayBuffer.byteLength === 0) {
          console.error(`${this.tag}: Empty response data from ${url}`);
          return;
        }
        
        const uint8Array = new Uint8Array(arrayBuffer);
        if (!asset.decode(uint8Array)) {
          console.error(`${this.tag}: Failed to decode asset from ${url}`);
        }
      })
      .catch((error: Error) => {
        console.error(`${this.tag}: Error loading asset ${url}: ${error}`);
      })
      .finally(() => {
        httpRequest.destroy();
      });

    return true; // Request dispatched; treat as handled.
  }
}