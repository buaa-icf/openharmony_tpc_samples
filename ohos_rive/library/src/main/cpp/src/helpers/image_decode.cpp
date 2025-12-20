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

#include "helpers/image_decode.h"

#include "helpers/canvas_render_objects.h"
#include "helpers/exception_handler.h"
#include "helpers/factories.h"
#include "helpers/general.h"
#include "helpers/resource.h"
#include "refs.h"

using namespace rive;

namespace ohos_rive {
constexpr size_t INDEX_ONE = 1;
constexpr size_t INDEX_TWO = 2;
constexpr size_t INDEX_THREE = 3;
constexpr size_t INDEX_FOUR = 4;
constexpr size_t OFFSET_FOUR_BYTE = 4;
constexpr size_t OFFSET_ONE_BITS = 8;
constexpr size_t OFFSET_TWO_BITS = 16;
constexpr size_t OFFSET_THREE_BITS = 24;
constexpr size_t ADD_NUM = 128;
constexpr size_t MULTI_NUM = 257;
constexpr size_t MULTI_INDEX = 255;
constexpr size_t C_COEFF = 255u;
constexpr size_t A_COEFF = 2u;

const uint32_t LSB_MASK = 0xFFu;
const uint32_t NUMBER_ZERO = 0;
static uint32_t premultiply(uint8_t c, uint8_t a)
{
    switch (a) {
        case 0:
            return 0;
        case MULTI_INDEX:
            return c;
        default:
            // Slightly faster than (c * a + 127) / 255
            return ((c * a + ADD_NUM) * MULTI_NUM) >> OFFSET_TWO_BITS;
    }
}

static uint32_t unpremultiply(uint8_t c, uint8_t a)
{
    if (a == 0) {
        return 0;
    }
    auto out = (c * C_COEFF + (a / A_COEFF)) / a;
    return out > C_COEFF ? C_COEFF : out;
}

static bool lockBitmapRGBA8888(NativePixelMap *nativePixelMap, OhosPixelMapInfos *info, const uint32_t **pixels)
{
    if (OH_PixelMap_GetImageInfo(nativePixelMap, info) != IMAGE_RESULT_SUCCESS) {
        LOGE("lockBitmapRGBA8888() - OH_GetImageInfo failed.");
        return false;
    }
    if (info->pixelFormat != PIXEL_FORMAT_RGBA_8888) {
        LOGE("lockBitmapRGBA8888() - Unexpected bitmap format.");
        return false;
    }
    if (info->width == 0 || info->height == 0) {
        LOGE("lockBitmapRGBA8888() - Invalid dimensions.");
        return false;
    }
    void *lockedPixelsPtr = nullptr;
    auto lockResult = OH_PixelMap_AccessPixels(nativePixelMap, &lockedPixelsPtr);
    if (lockedPixelsPtr == nullptr || lockResult != IMAGE_RESULT_SUCCESS) {
        if (lockResult == IMAGE_RESULT_BAD_PARAMETER) {
            LOGE(
                "lockBitmapRGBA8888() - Failed to lock pixels: bad "
                "parameter.");
        } else if (lockResult == IMAGE_RESULT_JNI_ENV_ABNORMAL) {
            LOGE(
                "lockBitmapRGBA8888() - Failed to lock pixels: JNI env "
                "abnormal.");
        } else if (lockResult == IMAGE_RESULT_MALLOC_ABNORMAL) {
            LOGE(
                "lockBitmapRGBA8888() - Failed to lock pixels: malloc "
                "abnormal.");
        } else {
            LOGE(
                "lockBitmapRGBA8888() - Failed to lock pixels: unknown "
                "error: %d",
                lockResult);
        }

        return false;
    }
    *pixels = reinterpret_cast<uint32_t *>(lockedPixelsPtr);
    return true;
}

static int *PixelsConvert(napi_env env, napi_value pixelArray, size_t pixelSize)
{
    if (pixelSize == NUMBER_ZERO) {
        LOGE("Memory allocation size is zero.");
        return nullptr;
    }

    if (pixelSize > (SIZE_MAX / sizeof(int))) {
        LOGE("Memory allocation size large.");
        return nullptr;
    }

    int *pixels = (int *)malloc(sizeof(int) * pixelSize);
    for (uint32_t i = 0; i < pixelSize; i++) {
        napi_value element;
        if (napi_get_element(env, pixelArray, i, &element) != napi_ok) {
            LOGE("Get pixelArray element error.");
            free(pixels);
            return nullptr;
        }

        int value;
        if (napi_get_value_int32(env, element, &value) != napi_ok) {
            LOGE("Get element value error.");
            free(pixels);
            return nullptr;
        }
        pixels[i] = value;
    }

    return pixels;
}

static napi_value CreateEncodedTypedArray(napi_env env, Span<const uint8_t> encodedBytes)
{
    napi_value arrayBuffer;
    void *bufferAddr;
    napi_value encoded;
    auto size = encodedBytes.size();
    napi_status status = napi_create_arraybuffer(env, SizeTToInt(size), &bufferAddr, &arrayBuffer);
    if (status != napi_ok) {
        return nullptr;
    }
    std::copy(encodedBytes.data(), encodedBytes.data() + encodedBytes.size(), static_cast<uint8_t *>(bufferAddr));
    status = napi_create_typedarray(env, napi_uint8_array, size, arrayBuffer, 0, &encoded);
    if (status != napi_ok) {
        return nullptr;
    }
    return encoded;
}

static napi_value DecodeImageToBitmap(napi_env env, napi_value encoded)
{
    napi_value imageDecoder = GetClass(env, "ImageDecoder");
    auto decodeToBitmap = GetStaticMethodId(env, imageDecoder, "decodeToBitmap");
    if (decodeToBitmap == nullptr) {
        LOGE("Get ImageDecoder.decodeToBitmap error.");
        return nullptr;
    }

    napi_value pixelArray;
    napi_status status = napi_call_function(env, nullptr, decodeToBitmap, 1, &encoded, &pixelArray);
    if (status != napi_ok) {
        LOGE("ImageDecoder.decodeToBitmap executed error.");
        return nullptr;
    }
    return pixelArray;
}

static rive::rcp<rive::RenderImage> ProcessPixelData(napi_env env, napi_value pixelArray, bool isPremultiplied)
{
    uint32_t pixelSize = 0;
    napi_status status = napi_get_array_length(env, pixelArray, &pixelSize);
    if (status != napi_ok || pixelSize < INDEX_TWO) {
        LOGE("Bad array length (unexpected)");
        return nullptr;
    }

    auto pixels = PixelsConvert(env, pixelArray, pixelSize);
    if (pixels == nullptr) {
        return nullptr;
    }

    const auto rawWidth = static_cast<uint32_t>(pixels[0]);
    const auto rawHeight = static_cast<uint32_t>(pixels[1]);
    const size_t pixelCount = static_cast<size_t>(rawWidth) * rawHeight;
    if (pixelCount == 0) {
        LOGE("Unsupported empty image (zero dimension)");
        free(pixels);
        return nullptr;
    }
    if (static_cast<size_t>(pixelSize) < 2u + pixelCount) {
        LOGE("Not enough elements in pixel array");
        free(pixels);
        return nullptr;
    }

    std::unique_ptr<uint8_t[]> out = std::make_unique<uint8_t[]>(pixelCount * 4);
    auto *bytes = out.get();
    for (size_t i = 0; i < pixelCount; ++i) {
        auto p = static_cast<uint32_t>(pixels[INDEX_TWO + i]);
        uint32_t a = (p >> OFFSET_THREE_BITS) & LSB_MASK;
        uint32_t r = (p >> OFFSET_TWO_BITS) & LSB_MASK;
        uint32_t g = (p >> OFFSET_ONE_BITS) & LSB_MASK;
        uint32_t b = (p >> 0) & LSB_MASK;
        if (!isPremultiplied) {
            r = premultiply(r, a);
            g = premultiply(g, a);
            b = premultiply(b, a);
        }
        bytes[0] = static_cast<uint8_t>(r);
        bytes[INDEX_ONE] = static_cast<uint8_t>(g);
        bytes[INDEX_TWO] = static_cast<uint8_t>(b);
        bytes[INDEX_THREE] = static_cast<uint8_t>(a);
        bytes += OFFSET_FOUR_BYTE;
    }
    free(pixels);
    return make_rcp<OhosImage>(static_cast<int>(rawWidth), static_cast<int>(rawHeight), std::move(out));
}

rive::rcp<rive::RenderImage> renderImageFromNapiDecode(napi_env env,
                                                       Span<const uint8_t> encodedBytes,
                                                       bool isPremultiplied)
{
    napi_value encoded = CreateEncodedTypedArray(env, encodedBytes);
    if (encoded == nullptr) {
        return nullptr;
    }

    napi_value pixelArray = DecodeImageToBitmap(env, encoded);
    if (pixelArray == nullptr) {
        return nullptr;
    }

    return ProcessPixelData(env, pixelArray, isPremultiplied);
}

rive::rcp<rive::RenderImage> renderImageFromRGBABytesRive(uint32_t width,
                                                          uint32_t height,
                                                          const uint8_t *pixelBytes,
                                                          bool isPremultiplied)
{
    if (width == 0 || height == 0 || pixelBytes == nullptr) {
        LOGE("renderImageFromRGBABytesRive() - Invalid args.");
        return nullptr;
    }

    const auto pixelCount = static_cast<size_t>(width) * height;
    std::unique_ptr<uint8_t[]> out = std::make_unique<uint8_t[]>(pixelCount * 4);
    const auto *src = pixelBytes;
    auto *dst = out.get();
    for (auto i = 0; i < pixelCount; ++i) {
        uint32_t r = src[0];
        uint32_t g = src[INDEX_ONE];
        uint32_t b = src[INDEX_TWO];
        uint32_t a = src[INDEX_THREE];
        if (!isPremultiplied) {
            r = premultiply(r, a);
            g = premultiply(g, a);
            b = premultiply(b, a);
        }
        dst[0] = static_cast<uint8_t>(r);
        dst[INDEX_ONE] = static_cast<uint8_t>(g);
        dst[INDEX_TWO] = static_cast<uint8_t>(b);
        dst[INDEX_THREE] = static_cast<uint8_t>(a);
        src += OFFSET_FOUR_BYTE;
        dst += OFFSET_FOUR_BYTE;
    }
    return make_rcp<OhosImage>(static_cast<int>(width), static_cast<int>(height), std::move(out));
}

OH_Pixelmap_InitializationOptions *CreatePixelMapOptions(uint32_t width,
                                                         uint32_t height,
                                                         int32_t format,
                                                         int32_t rowStride)
{
    OH_Pixelmap_InitializationOptions *options;
    auto result = OH_PixelmapInitializationOptions_Create(&options);
    if (result != IMAGE_SUCCESS) {
        LOGE("CreatePixelMapOptions() - Create Pixelmap initializetion options failed, ret=%d.", result);
        return nullptr;
    }
    result = OH_PixelmapInitializationOptions_SetWidth(options, width);
    if (result != IMAGE_SUCCESS) {
        LOGE("CreatePixelMapOptions() - Pixelmap initializetion options set width failed, ret=%d.", result);
        OH_PixelmapInitializationOptions_Release(options);
        return nullptr;
    }
    result = OH_PixelmapInitializationOptions_SetHeight(options, height);
    if (result != IMAGE_SUCCESS) {
        LOGE("CreatePixelMapOptions() - Pixelmap initializetion options set height failed, ret=%d.", result);
        OH_PixelmapInitializationOptions_Release(options);
        return nullptr;
    }
    result = OH_PixelmapInitializationOptions_SetPixelFormat(options, format);
    if (result != IMAGE_SUCCESS) {
        LOGE("CreatePixelMapOptions() - Pixelmap initializetion options set format failed, ret=%d.", result);
        OH_PixelmapInitializationOptions_Release(options);
        return nullptr;
    }
    result = OH_PixelmapInitializationOptions_SetRowStride(options, rowStride);
    if (result != IMAGE_SUCCESS) {
        LOGE("CreatePixelMapOptions() - Pixelmap initializetion options set row stride failed, ret=%d.", result);
        OH_PixelmapInitializationOptions_Release(options);
        return nullptr;
    }
    return options;
}

rive::rcp<rive::RenderImage> renderImageFromRGBABytesCanvas(uint32_t width,
                                                            uint32_t height,
                                                            const uint8_t *pixelBytes,
                                                            bool isPremultiplied)
{
    if (width == 0 || height == 0 || pixelBytes == nullptr) {
        LOGE("renderImageFromRGBABytesCanvas() - Invalid args.");
        return nullptr;
    }
    const auto pixelCount = static_cast<size_t>(width) * height;

    std::unique_ptr<uint8_t[]> pixelBuffer = std::make_unique<uint8_t[]>(pixelCount * INDEX_FOUR);
    uint32_t *dstPixels = reinterpret_cast<uint32_t *>(pixelBuffer.get());
    const auto *src = pixelBytes;

    if (!isPremultiplied) {
        for (size_t i = 0; i < pixelCount; ++i) {
            uint32_t r = src[0];
            uint32_t g = src[INDEX_ONE];
            uint32_t b = src[INDEX_TWO];
            uint32_t a = src[INDEX_THREE];

            dstPixels[i] = (a << OFFSET_THREE_BITS) | (r << OFFSET_TWO_BITS) | (g << OFFSET_ONE_BITS) | b;
            src += OFFSET_FOUR_BYTE;
        }
    } else {
        for (size_t i = 0; i < pixelCount; ++i) {
            uint32_t r = src[0];
            uint32_t g = src[INDEX_ONE];
            uint32_t b = src[INDEX_TWO];
            uint32_t a = src[INDEX_THREE];
            if (a != MULTI_INDEX) {
                r = unpremultiply(r, a);
                g = unpremultiply(g, a);
                b = unpremultiply(b, a);
            }
            dstPixels[i] = (a << OFFSET_THREE_BITS) | (r << OFFSET_TWO_BITS) | (g << OFFSET_ONE_BITS) | b;
            src += OFFSET_FOUR_BYTE;
        }
    }

    // 创建PixelMap描述信息
    OH_Pixelmap_InitializationOptions *options =
        CreatePixelMapOptions(width, height, PIXEL_FORMAT_RGBA_8888, width * 4);
    if (options == nullptr) {
        return nullptr;
    }
    OH_PixelmapNative *pixelMap = nullptr;
    auto result = OH_PixelmapNative_CreatePixelmap(pixelBuffer.get(), pixelCount, options, &pixelMap);
    if (result != IMAGE_SUCCESS || pixelMap == nullptr) {
        LOGE("renderImageFromRGBABytesCanvas() - CreatePixelmap failed, ret=%d.", result);
        return nullptr;
    }

    OH_PixelmapInitializationOptions_Release(options);
    auto renderImage = make_rcp<CanvasRenderImage>(pixelMap);
    return renderImage;
}

rive::rcp<rive::RenderImage> renderImageFromARGBIntsRive(uint32_t width,
                                                         uint32_t height,
                                                         const uint32_t *pixels,
                                                         bool isPremultiplied)
{
    if (width == 0 || height == 0 || pixels == nullptr) {
        LOGE("renderImageFromARGBIntsRive() - Invalid args.");
        return nullptr;
    }
    const auto pixelCount = static_cast<size_t>(width) * height;
    std::unique_ptr<uint8_t[]> out = std::make_unique<uint8_t[]>(pixelCount * INDEX_FOUR);
    for (size_t i = 0; i < pixelCount; ++i) {
        uint32_t c = pixels[i];
        uint32_t a = (c >> OFFSET_THREE_BITS) & LSB_MASK;
        uint32_t r = (c >> OFFSET_TWO_BITS) & LSB_MASK;
        uint32_t g = (c >> OFFSET_ONE_BITS) & LSB_MASK;
        uint32_t b = (c >> 0) & LSB_MASK;
        if (!isPremultiplied) {
            r = premultiply(r, a);
            g = premultiply(g, a);
            b = premultiply(b, a);
        }
        out[i * OFFSET_FOUR_BYTE + 0] = static_cast<uint8_t>(r);
        out[i * OFFSET_FOUR_BYTE + INDEX_ONE] = static_cast<uint8_t>(g);
        out[i * OFFSET_FOUR_BYTE + INDEX_TWO] = static_cast<uint8_t>(b);
        out[i * OFFSET_FOUR_BYTE + INDEX_THREE] = static_cast<uint8_t>(a);
    }
    return make_rcp<OhosImage>(static_cast<int>(width), static_cast<int>(height), std::move(out));
}

rive::rcp<rive::RenderImage> renderImageFromARGBIntsCanvas(uint32_t width,
                                                           uint32_t height,
                                                           const uint32_t *pixels,
                                                           bool isPremultiplied)
{
    if (width == 0 || height == 0 || pixels == nullptr) {
        LOGE("renderImageFromARGBIntsCanvas() - Invalid args.");
        return nullptr;
    }
    const auto pixelCount = static_cast<size_t>(width) * height;

    // 准备像素数据缓冲�?
    std::unique_ptr<uint8_t[]> pixelBuffer = std::make_unique<uint8_t[]>(pixelCount * INDEX_FOUR);
    uint32_t *dstPixels = reinterpret_cast<uint32_t *>(pixelBuffer.get());

    // 处理像素数据
    for (size_t i = 0; i < pixelCount; ++i) {
        uint32_t c = pixels[i];
        uint32_t a = (c >> OFFSET_THREE_BITS) & LSB_MASK;
        uint32_t r = (c >> OFFSET_TWO_BITS) & LSB_MASK;
        uint32_t g = (c >> OFFSET_ONE_BITS) & LSB_MASK;
        uint32_t b = (c >> 0) & LSB_MASK;
        if (isPremultiplied && a != MULTI_INDEX) {
            r = unpremultiply(r, a);
            g = unpremultiply(g, a);
            b = unpremultiply(b, a);
        }
        dstPixels[i] = (a << OFFSET_THREE_BITS) | (r << OFFSET_TWO_BITS) | (g << OFFSET_ONE_BITS) | b;
    }

    // 创建PixelMap描述信息
    OH_Pixelmap_InitializationOptions *options =
        CreatePixelMapOptions(width, height, PIXEL_FORMAT_RGBA_8888, width * 4);
    if (options == nullptr) {
        return nullptr;
    }
    OH_PixelmapNative *pixelMap = nullptr;
    auto result = OH_PixelmapNative_CreatePixelmap(pixelBuffer.get(), pixelCount, options, &pixelMap);
    if (result != IMAGE_SUCCESS || pixelMap == nullptr) {
        LOGE("renderImageFromARGBIntsCanvas() - CreatePixelmap failed, ret=%d.", result);
        return nullptr;
    }

    OH_PixelmapInitializationOptions_Release(options);

    auto renderImage = make_rcp<CanvasRenderImage>(pixelMap);
    return renderImage;
}

rive::rcp<rive::RenderImage> renderImageFromPixelMapRive(napi_env env, napi_value pixelMap, bool isPremultiplied)
{
    if (pixelMap == nullptr) {
        LOGE("renderImageFromPixelMapRive() - pixelMap was null.");
        return nullptr;
    }
    NativePixelMap *nativePixelMap = OH_PixelMap_InitNativePixelMap(env, pixelMap);
    if (nativePixelMap == nullptr) {
        LOGE("renderImageFromPixelMapRive() - Failed to init native pixel map.");
        return nullptr;
    }
    OhosPixelMapInfos info;
    const uint32_t *srcPixels = nullptr;
    if (!lockBitmapRGBA8888(nativePixelMap, &info, &srcPixels)) {
        LOGE("renderImageFromPixelMapRive() - Failed to lock srcPixels.");
        return nullptr;
    }

    const auto width = info.width;
    const auto height = info.height;

    // Pack bitmap data in RGBA8888 format into a contiguous RGBA buffer
    const size_t byteCount = static_cast<size_t>(width) * height * 4;
    std::unique_ptr<uint8_t[]> dstBytes = std::make_unique<uint8_t[]>(byteCount);

    const auto srcStrideBytes = static_cast<size_t>(info.rowSize);
    const auto rowBytes = static_cast<size_t>(width) * 4;

    // Reinterpret RGBA ints as bytes
    const auto *srcBytes = reinterpret_cast<const uint8_t *>(srcPixels);

    // Contiguous case: direct copy
    if (srcStrideBytes == rowBytes) {
        std::copy(srcBytes, srcBytes + rowBytes * height, dstBytes.get());
    } else {
        // Strided case: copy row by row
        for (uint32_t y = 0; y < height; ++y) {
            const uint8_t *srcRow = srcBytes + y * srcStrideBytes;
            uint8_t *dstRow = dstBytes.get() + static_cast<size_t>(y) * rowBytes;
            std::copy(srcRow, srcRow + rowBytes, dstRow);
        }
    }

    // Always unlock srcPixels
    OH_PixelMap_UnAccessPixels(nativePixelMap);

    // The packed buffer is RGBA. Route through the RGBA path that handles
    // isPremultiplied/straight alpha
    return renderImageFromRGBABytesRive(width, height, dstBytes.get(), isPremultiplied);
}

rive::rcp<rive::RenderImage> renderImageFromPixelmapCanvas(napi_env env, napi_value pixelMap)
{
    OH_PixelmapNative *pixelMapNative = nullptr;
    auto result = OH_PixelmapNative_ConvertPixelmapNativeFromNapi(env, pixelMap, &pixelMapNative);
    if (result != IMAGE_SUCCESS || pixelMapNative == nullptr) {
        LOGE("renderImageFromPixelmapCanvas() - pixelMap convert failed, ret = %{public}d.", result);
        return nullptr;
    }

    return make_rcp<CanvasRenderImage>(pixelMapNative);
}

} // namespace ohos_rive

