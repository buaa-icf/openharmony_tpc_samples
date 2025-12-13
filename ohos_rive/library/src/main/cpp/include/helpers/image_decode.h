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
#pragma once

#include "rive/refcnt.hpp"
#include "rive/renderer.hpp"
#include "rive/span.hpp"
#include <napi/native_api.h>

#include <multimedia/image_framework/image/pixelmap_native.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <native_drawing/drawing_types.h>

#include <cstdint>
#include <vector>

namespace ohos_rive {
/** Decode path: Use Ohos BitmapFactory (unimplement) through NAPI to decode into RGBA bytes
 */
rive::rcp<rive::RenderImage> renderImageFromNapiDecode(napi_env env,
                                                       rive::Span<const uint8_t> encodedBytes,
                                                       bool isPremultiplied);

/** Rive (GL) path: From RGBA bytes -> OhosImage */
rive::rcp<rive::RenderImage> renderImageFromRGBABytesRive(uint32_t width,
                                                          uint32_t height,
                                                          const uint8_t *pixelBytes,
                                                          bool isPremultiplied);

/** Canvas path: from RGBA bytes -> ARGB ints -> CreatePixelMapWithData ->
 * CanvasRenderImage */
rive::rcp<rive::RenderImage> renderImageFromRGBABytesCanvas(uint32_t width,
                                                            uint32_t height,
                                                            const uint8_t *pixelBytes,
                                                            bool isPremultiplied);

/** Rive (GL) path: from ARGB ints -> RGBA bytes -> OhosImage */
rive::rcp<rive::RenderImage> renderImageFromARGBIntsRive(uint32_t width,
                                                         uint32_t height,
                                                         const uint32_t *pixels,
                                                         bool isPremultiplied);

/** Canvas path: from ARGB ints -> CreatePixelMapWithData -> CanvasRenderImage */
rive::rcp<rive::RenderImage> renderImageFromARGBIntsCanvas(uint32_t width,
                                                           uint32_t height,
                                                           const uint32_t *pixels,
                                                           bool isPremultiplied);

/** Rive (GL) path: PixelMapNapi -> internal buffer -> RGBA bytes ->
 * OhosImage */
rive::rcp<rive::RenderImage> renderImageFromPixelMapRive(napi_env env, napi_value pixelMap, bool isPremultiplied);

/** Canvas path: PixelMapNapi -> wrap -> CanvasRenderImage */
rive::rcp<rive::RenderImage> renderImageFromPixelmapCanvas(napi_env env, napi_value pixelMap);

} // namespace ohos_rive

