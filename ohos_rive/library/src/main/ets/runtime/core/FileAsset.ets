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
import image from '@ohos.multimedia.image';
import { RendererType } from '../renderers/RendererType';
import { NativeObject } from './NativeObject';

export abstract class FileAsset extends NativeObject {
  private readonly rendererType: RendererType;
  private cachedName: string | null = null;
  private cachedUniqueFilename: string | null = null;
  private cachedCdnUrl: string | null = null;

  protected constructor(address: BigInt, rendererTypeIdx: number) {
    super(address);
    this.rendererType = RendererType.fromIndex(rendererTypeIdx);
  }

  private cppName(pointer: BigInt): string {
    return rive.Napi_FileAsset_cppName(pointer);
  }

  private cppUniqueFilename(pointer: BigInt): string {
    return rive.Napi_FileAsset_cppUniqueFilename(pointer);
  }

  private cppDecode(pointer: BigInt, bytes: Uint8Array, rendererType: RendererType): boolean {
    return rive.Napi_FileAsset_cppDecode(pointer, bytes, rendererType);
  }

  private cppCDNUrl(pointer: BigInt): string {
    return rive.Napi_FileAsset_cppCDNUrl(pointer);
  }

  /** Lazily fetched asset name. */
  get name(): string {
    if (this.cachedName === null) {
      this.cachedName = this.cppName(this.cppPointer);
    }
    return this.cachedName;
  }

  /** Lazily fetched unique filename used for caching/loading. */
  get uniqueFilename(): string {
    if (this.cachedUniqueFilename === null) {
      this.cachedUniqueFilename = this.cppUniqueFilename(this.cppPointer);
    }
    return this.cachedUniqueFilename;
  }

  /** Hosted asset CDN URL (empty when not hosted). */
  get cdnUrl(): string {
    if (this.cachedCdnUrl === null) {
      this.cachedCdnUrl = this.cppCDNUrl(this.cppPointer);
    }
    return this.cachedCdnUrl;
  }

  /** Decode provided bytes into this asset using the configured renderer. */
  decode(bytes: Uint8Array): boolean {
    return this.cppDecode(this.cppPointer, bytes, this.rendererType);
  }
}

/**
 * A thin Kotlin wrapper for the underlying C++ image asset. Helpful to distinguish between various
 * [FileAsset] subclasses.
 */
export class ImageAsset extends FileAsset {
  constructor(address: BigInt, rendererTypeIdx: number) {
    super(address, rendererTypeIdx);
    console.info('ImageAsset constructor:', { address, rendererTypeIdx });
  }

  private cppSetRenderImage(assetpointer: BigInt, imagepointer: BigInt): void {
    rive.Napi_ImageAsset_cppSetRenderImage(assetpointer, imagepointer);
  }

  private cppGetRenderImage(assetpointer: BigInt): BigInt {
    return rive.Napi_ImageAsset_cppGetRenderImage(assetpointer);
  }

  private cppWidth(assetpointer: BigInt): number {
    return rive.Napi_ImageAsset_cppImageAssetWidth(assetpointer);
  }

  private cppHeight(assetpointer: BigInt): number {
    return rive.Napi_ImageAsset_cppImageAssetHeight(assetpointer);
  }

  /** The [RiveRenderImage] object associated with this [ImageAsset]. */
  set image(value: RiveRenderImage) {
    this.cppSetRenderImage(this.cppPointer, value.cppPointer);
  }

  /**
   * This isn't safe to use outside tests.
   *
   * @return A light wrapper around a C++ address.
   */
  get image(): RiveRenderImage {
    const pointer = this.cppGetRenderImage(this.cppPointer);
    return new RiveRenderImage(pointer);
  }

  /** @return The width of the image in pixels. */
  get width(): number {
    return this.cppWidth(this.cppPointer);
  }

  /** @return The height of the image in pixels. */
  get height(): number {
    return this.cppHeight(this.cppPointer);
  }
}

/**
 * A thin Kotlin wrapper for the underlying C++ font asset. Helpful to distinguish between various
 * [FileAsset] subclasses.
 */
export class FontAsset extends FileAsset {
  constructor(address: BigInt, rendererTypeIdx: number) {
    super(address, rendererTypeIdx);
    console.info('FontAsset constructor:', { address, rendererTypeIdx });
  }

  private cppSetFont(assetPointer: BigInt, fontPointer: BigInt): void {
    rive.Napi_FontAsset_cppSetFont(assetPointer, fontPointer);
  }

  private cppGetFont(assetpointer: BigInt): BigInt {
    return rive.Napi_FontAsset_cppGetFont(assetpointer);
  }

  /** The [RiveFont] object associated with this [FontAsset]. */
  set font(value: RiveFont) {
    this.cppSetFont(this.cppPointer, value.cppPointer);
  }

  /**
   * This isn't safe to use outside tests.
   *
   * @return A light wrapper around a C++ address.
   */
  get font(): RiveFont {
    const pointer = this.cppGetFont(this.cppPointer);
    return new RiveFont(pointer);
  }
}

/**
 * A thin Kotlin wrapper for the underlying C++ audio asset. Helpful to distinguish between various
 * [FileAsset] subclasses.
 */
export class AudioAsset extends FileAsset {
  constructor(address: BigInt, rendererTypeIdx: number) {
    super(address, rendererTypeIdx);
    console.info('AudioAsset constructor:', { address, rendererTypeIdx });
  }
  private cppSetAudio(assetpointer: BigInt, audiopointer: BigInt): void {
    rive.Napi_AudioAsset_cppSetAudio(assetpointer, audiopointer);
  }

  private cppGetAudio(assetpointer: BigInt): BigInt {
    return rive.Napi_AudioAsset_cppGetAudio(assetpointer);
  }
  /** The [RiveAudio] object associated with this [AudioAsset]. */
  set audio(value: RiveAudio) {
    this.cppSetAudio(this.cppPointer, value.cppPointer);
  }

  /**
   * This isn't safe to use outside tests.
   *
   * @return A light wrapper around a C++ address.
   */
  get audio(): RiveAudio {
    const pointer = this.cppGetAudio(this.cppPointer);
    return new RiveAudio(pointer);
  }
}

/**
 * A wrapper around a native C++ object representing a raster image that can be rendered in Rive.
 *
 * Use the companion object methods to create one from encoded bytes, pixel bytes, ARGB integers, or
 * an [Android Bitmap][Bitmap].
 */
export class RiveRenderImage extends NativeObject {
  constructor(address: BigInt) {
    super(address);
  }

  protected override cppDelete(pointer: BigInt): void {
    rive.Napi_RiveRenderImage_cppDelete(pointer);
  }

  /**
   * @deprecated Kept for parity with Android. Use {@link fromEncoded}.
   */
  static make(
    bytes: Uint8Array,
    rendererType: RendererType = RendererType.Rive
  ): RiveRenderImage {
    console.warn('RiveRenderImage.make is deprecated. Use fromEncoded instead.');
    return RiveRenderImage.fromEncoded(bytes, rendererType);
  }

  /**
   * Creates a {@link RiveRenderImage} by decoding the {@link encodedBytes}.
   *
   * The caller is in charge of the ownership of this {@link NativeObject}. It must be freed by
   * calling {@link release}.
   *
   * @param encodedBytes Encoded bytes for the image.
   * @param rendererType The renderer for this image. This must match the renderer for the
   *    RiveAnimationView using this.
   * @param premultiplied Whether the decoded image is premultiplied.
   * @return The constructed {@link RiveRenderImage}.
   */
  static fromEncoded(
    encodedBytes: Uint8Array,
    rendererType: RendererType = RendererType.Rive,
    premultiplied: boolean = true
  ): RiveRenderImage {
    const buffer = RiveRenderImage.cloneArrayBuffer(encodedBytes);
    const imageSource = image.createImageSource(buffer);
    const decodingOptions: image.DecodingOptions = {
      editable: false,
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888
    };
    const pixelMap = imageSource.createPixelMapSync(decodingOptions);
    try {
      return RiveRenderImage.fromPixelMap(pixelMap, rendererType, premultiplied);
    } finally {
      pixelMap.release?.();
    }
  }

  /**
   * Creates a {@link RiveRenderImage} from RGBA8888 pixel bytes.
   *
   * The byte array must be exactly width * height * 4 bytes.
   *
   * The caller is in charge of the ownership of this {@link NativeObject}. It must be freed by
   * calling {@link release}.
   *
   * @param pixelBytes RGBA8888 pixel bytes.
   * @param width The width of the image in pixels.
   * @param height The height of the image in pixels.
   * @param rendererType The renderer for this image. This must match the renderer for the
   *    RiveAnimationView using this.
   * @param premultiplied Whether your RGB pixels are already multiplied by alpha. If false,
   *    the native layer will premultiply RGB by alpha for you. Defaults to true as Rive
   *    expects premultiplied input.
   * @return The constructed {@link RiveRenderImage}.
   */
  static fromRGBABytes(
    pixelBytes: Uint8Array,
    width: number,
    height: number,
    rendererType: RendererType = RendererType.Rive,
    premultiplied: boolean = true
  ): RiveRenderImage {
    if (width <= 0 || height <= 0) {
      throw new RangeError('Width and height must be > 0');
    }
    if (pixelBytes.byteLength !== width * height * 4) {
      throw new RangeError('Bytes must have size = width * height * 4');
    }
    const pointer = rive.Napi_RiveRenderImage_cppCreateFromRGBABytes(
      pixelBytes,
      width,
      height,
      rendererType,
      premultiplied
    );
    return new RiveRenderImage(pointer);
  }

  /**
   * Creates a {@link RiveRenderImage} from ARGB8888 packed pixel integers.
   *
   * The int array must be exactly width * height elements.
   *
   * The caller is in charge of the ownership of this {@link NativeObject}. It must be freed by
   * calling {@link release}.
   *
   * @param pixels ARGB8888 packed pixel integers.
   * @param width The width of the image in pixels.
   * @param height The height of the image in pixels.
   * @param rendererType The renderer for this image. This must match the renderer for the
   *    RiveAnimationView using this.
   * @param premultiplied Whether your RGB pixels are already multiplied by alpha. If false
   *    (default), the native layer will premultiply RGB by alpha for you.
   * @return The constructed {@link RiveRenderImage}.
   */
  static fromARGBInts(
    pixels: Uint32Array,
    width: number,
    height: number,
    rendererType: RendererType = RendererType.Rive,
    premultiplied: boolean = false
  ): RiveRenderImage {
    if (width <= 0 || height <= 0) {
      throw new RangeError('Width and height must be > 0');
    }
    if (pixels.length !== width * height) {
      throw new RangeError('Colors must have size = width * height');
    }
    const pointer = rive.Napi_RiveRenderImage_cppCreateFromARGBInts(
      pixels,
      width,
      height,
      rendererType,
      premultiplied
    );
    return new RiveRenderImage(pointer);
  }

  /**
   * Creates a {@link RiveRenderImage} from a {@link image.PixelMap}.
   *
   * The caller is in charge of the ownership of this {@link NativeObject}. It must be freed by
   * calling {@link release}.
   *
   * @param pixelMap The source PixelMap.
   * @param rendererType The renderer for this image. This must match the renderer for the
   *    RiveAnimationView using this.
   * @param premultiplied Whether the pixel data is premultiplied.
   * @return The constructed {@link RiveRenderImage}.
   */
  static fromPixelMap(
    pixelMap: image.PixelMap,
    rendererType: RendererType = RendererType.Rive,
    premultiplied: boolean = true
  ): RiveRenderImage {
    const pointer = rive.Napi_RiveRenderImage_cppCreateFromBitmap(pixelMap, rendererType, premultiplied);
    return new RiveRenderImage(pointer);
  }

  private static cloneArrayBuffer(bytes: Uint8Array): ArrayBuffer {
    if (bytes.byteOffset === 0 && bytes.byteLength === bytes.buffer.byteLength) {
      return bytes.buffer;
    }
    return bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength);
  }
}

/**
 * Wrapper around native Rive fonts.
 */
export class RiveFont extends NativeObject {
  constructor(address: BigInt) {
    super(address);
  }

  protected override cppDelete(pointer: BigInt): void {
   console.log(`[ohos_rive_ui] FileAsset.ets: cppDelete C++ Napi_RiveFont_cppDelete`);
    rive.Napi_RiveFont_cppDelete(pointer);
  }

  /**
   * Creates a {@link RiveFont} by decoding {@link bytes}.
   *
   * The caller is in charge of the ownership of this {@link NativeObject}. It must be freed by
   * calling {@link release}.
   *
   * @param bytes Encoded bytes for a font.
   * @param rendererType The renderer decoding this font. This needs to match the renderer for
   *    the View using this.
   * @return The constructed {@link RiveFont} object.
   */
  static make(
    bytes: Uint8Array,
    rendererType: RendererType = RendererType.Rive
  ): RiveFont {
    console.log(`[ohos_rive_ui] FileAsset.ets: cppMakeFont C++ Napi_RiveFont_00024Companion_cppMakeFont`);
    const pointer = rive.Napi_RiveFont_00024Companion_cppMakeFont(bytes, rendererType);
    return new RiveFont(pointer);
  }
}

/**
 * A wrapper around a native C++ object representing an audio clip that can be played in Rive.
 *
 * Use the companion object method to create one from encoded bytes.
 */
export class RiveAudio extends NativeObject {
  constructor(address: BigInt) {
    super(address);
  }

  protected override cppDelete(pointer: BigInt): void {
    console.log(`[ohos_rive_ui] FileAsset.ets: cppDelete C++ Napi_RiveAudio_cppDelete`);
    rive.Napi_RiveAudio_cppDelete(pointer);
  }
  /**
   * Creates a [RiveAudio] by decoding [bytes].
   *
   * The caller is in charge of the ownership of this [NativeObject]. It must be freed by
   * calling [release].
   *
   * @param bytes Encoded bytes for an audio file.
   * @param rendererType The renderer decoding this object. This needs to match the renderer
   *    for the View using this.
   * @return The constructed [RiveAudio] object.
   */
  static make(
    bytes: Uint8Array,
    rendererType: RendererType = RendererType.Rive
  ): RiveAudio {
    console.log(`[ohos_rive_ui] FileAsset.ets: cppMakeAudio C++ Napi_RiveAudio_00024Companion_cppMakeAudio`);
    const pointer = rive.Napi_RiveAudio_00024Companion_cppMakeAudio(bytes, rendererType);
    return new RiveAudio(pointer);
  }
}
