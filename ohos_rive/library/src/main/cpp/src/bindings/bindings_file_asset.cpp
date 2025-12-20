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

#include "bindings/bindings_file_asset.h"
#include "helpers/canvas_render_objects.h"
#include "helpers/factories.h"
#include "helpers/image_decode.h"
#include <js_native_api.h>
#include <vector>
namespace ohos_rive {
using namespace rive;
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;
constexpr size_t ARG_NUM_FIVE = 5;

bool OhosFileAsset::GetBytesFromArray(napi_env env,
                                      napi_value array,
                                      rive::SimpleArray<uint8_t> &bytes,
                                      bool useRawData)
{
    bool isTypedArray;
    napi_is_typedarray(env, array, &isTypedArray);

    if (isTypedArray) {
        napi_typedarray_type type;
        size_t length;
        void *data;
        napi_value buffer;
        size_t byteOffset;

        napi_status status = napi_get_typedarray_info(env, array, &type, &length, &data, &buffer, &byteOffset);
        if (status != napi_ok || type != napi_uint8_array) {
            return false;
        }

        if (useRawData) {
            bytes = rive::SimpleArray<uint8_t>(reinterpret_cast<uint8_t *>(data), length);
        } else {
            std::vector<uint8_t> tempBytes(length);
            std::copy(reinterpret_cast<uint8_t *>(data), reinterpret_cast<uint8_t *>(data) + length, tempBytes.begin());
            bytes = rive::SimpleArray<uint8_t>(tempBytes.data(), length);
        }
        return true;
    } else {
        uint32_t length;
        napi_get_array_length(env, array, &length);

        std::vector<uint8_t> tempBytes(length);
        for (uint32_t i = 0; i < length; i++) {
            napi_value element;
            int32_t value;
            napi_get_element(env, array, i, &element);
            napi_get_value_int32(env, element, &value);
            tempBytes[i] = static_cast<uint8_t>(value);
        }

        bytes = rive::SimpleArray<uint8_t>(tempBytes.data(), length);
        return true;
    }
}

// FileAsset
napi_value OhosFileAsset::GetName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *fileAsset = GetNativePtr<rive::FileAsset>(env, argv[ARG_NUM_ZERO]);
    if (!fileAsset) {
        LOGE("Invalid FileAsset pointer");
        return nullptr;
    }

    napi_value result;
    napi_create_string_utf8(env, fileAsset->name().c_str(), NAPI_AUTO_LENGTH, &result);
    return result;
}

napi_value OhosFileAsset::GetUniqueFilename(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *fileAsset = GetNativePtr<rive::FileAsset>(env, argv[ARG_NUM_ZERO]);
    if (!fileAsset) {
        LOGE("Invalid FileAsset pointer");
        return nullptr;
    }

    napi_value result;
    napi_create_string_utf8(env, fileAsset->uniqueFilename().c_str(), NAPI_AUTO_LENGTH, &result);
    return result;
}

napi_value OhosFileAsset::Decode(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value argv[ARG_NUM_THREE];
    napi_value thisArg;

    napi_status status = napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE("Failed to get callback info or wrong number of arguments");
        return nullptr;
    }

    auto *fileAsset = GetNativePtr<rive::FileAsset>(env, argv[ARG_NUM_ZERO]);
    if (!fileAsset) {
        LOGE("Invalid FileAsset pointer");
        return nullptr;
    }

    int32_t rendererTypeIndex;
    napi_get_value_int32(env, argv[ARG_NUM_TWO], &rendererTypeIndex);
    auto rendererType = static_cast<RendererType>(rendererTypeIndex);

    rive::SimpleArray<uint8_t> bytes;
    if (!GetBytesFromArray(env, argv[ARG_NUM_ONE], bytes, true)) {
        LOGE("Failed to get byte array");
        return nullptr;
    }

    auto *fileFactory = GetFactory(rendererType);
    bool result = fileAsset->decode(bytes, fileFactory);

    napi_value jsResult;
    napi_get_boolean(env, result, &jsResult);
    return jsResult;
}

napi_value OhosFileAsset::GetCDNUrl(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *fileAsset = GetNativePtr<rive::FileAsset>(env, argv[ARG_NUM_ZERO]);
    if (!fileAsset) {
        LOGE("Invalid FileAsset pointer");
        return nullptr;
    }

    napi_value result;
    auto uuid = fileAsset->cdnUuidStr();
    if (uuid.empty()) {
        napi_create_string_utf8(env, "", NAPI_AUTO_LENGTH, &result);
        return result;
    }

    auto cdnUrl = fileAsset->cdnBaseUrl();
    auto lastChar = cdnUrl.back();
    if (lastChar != '/') {
        cdnUrl += '/';
    }
    cdnUrl += uuid;

    napi_create_string_utf8(env, cdnUrl.c_str(), NAPI_AUTO_LENGTH, &result);
    return result;
}

// ImageAsset
napi_value OhosFileAsset::SetRenderImage(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value argv[ARG_NUM_TWO];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *imageAsset = GetNativePtr<rive::ImageAsset>(env, argv[ARG_NUM_ZERO]);
    auto *renderImage = GetNativePtr<rive::RenderImage>(env, argv[ARG_NUM_ONE]);

    if (!imageAsset || !renderImage) {
        LOGE("Invalid pointer");
        return nullptr;
    }

    imageAsset->renderImage(rive::ref_rcp(renderImage));

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value OhosFileAsset::GetRenderImage(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *imageAsset = GetNativePtr<rive::ImageAsset>(env, argv[ARG_NUM_ZERO]);
    if (!imageAsset) {
        LOGE("Invalid ImageAsset pointer");
        return nullptr;
    }

    auto renderImage = imageAsset->renderImage();
    napi_value result;
    auto status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(renderImage), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint");
        return nullptr;
    }
    return result;
}

napi_value OhosFileAsset::GetImageWidth(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *imageAsset = GetNativePtr<rive::ImageAsset>(env, argv[ARG_NUM_ZERO]);
    if (!imageAsset) {
        LOGE("Invalid ImageAsset pointer");
        return nullptr;
    }

    napi_value result;
    napi_create_double(env, imageAsset->width(), &result);
    return result;
}

napi_value OhosFileAsset::GetImageHeight(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *imageAsset = GetNativePtr<rive::ImageAsset>(env, argv[ARG_NUM_ZERO]);
    if (!imageAsset) {
        LOGE("Invalid ImageAsset pointer");
        return nullptr;
    }

    napi_value result;
    napi_create_double(env, imageAsset->height(), &result);
    return result;
}

// RenderImage
napi_value OhosFileAsset::CreateFromRGBABytes(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FIVE;
    napi_value argv[ARG_NUM_FIVE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_FIVE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    rive::SimpleArray<uint8_t> bytes;
    if (!GetBytesFromArray(env, argv[ARG_NUM_ZERO], bytes, false)) {
        LOGE("Failed to get byte array");
        return nullptr;
    }

    int32_t width;
    int32_t height;
    int32_t rendererTypeIdx;
    bool premultiplied;
    napi_get_value_int32(env, argv[ARG_NUM_ONE], &width);
    napi_get_value_int32(env, argv[ARG_NUM_TWO], &height);
    napi_get_value_int32(env, argv[ARG_NUM_THREE], &rendererTypeIdx);
    napi_get_value_bool(env, argv[ARG_NUM_FOUR], &premultiplied);

    size_t expected = static_cast<size_t>(width) * static_cast<size_t>(height) * 4u;
    if (width <= 0 || height <= 0 || bytes.size() != expected) {
        LOGE("Invalid arguments for RGBABytes");
        return nullptr;
    }

    auto rendererType = static_cast<RendererType>(rendererTypeIdx);
    rive::rcp<rive::RenderImage> renderImage;

    if (rendererType == RendererType::RIVE) {
        renderImage = renderImageFromRGBABytesRive(static_cast<uint32_t>(width), static_cast<uint32_t>(height),
                                                   bytes.data(), premultiplied);
    } else {
        renderImage = renderImageFromRGBABytesCanvas(static_cast<uint32_t>(width), static_cast<uint32_t>(height),
                                                     bytes.data(), premultiplied);
    }

    if (!renderImage) {
        LOGE("Failed to create render image");
        return nullptr;
    }

    napi_value result;
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(renderImage.release()), &result);
    return result;
}

// CreateFromARGBInts
static bool ParseCreateFromARGBArgs(napi_env env, napi_callback_info info, napi_value argv[ARG_NUM_FIVE])
{
    size_t argc = ARG_NUM_FIVE;
    napi_value thisArg;
    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_FIVE) {
        LOGE("Wrong number of arguments");
        return false;
    }
    return true;
}

static bool ExtractPixelData(napi_env env, napi_value arg, void **outPixelData, size_t *outPixelCount)
{
    napi_typedarray_type arrayType;
    size_t length;
    void *pixelData;
    napi_value buffer;
    size_t byteOffset;
    size_t elementSize = sizeof(uint32_t);

    napi_status status = napi_get_typedarray_info(env, arg, &arrayType, &length, &pixelData, &buffer, &byteOffset);
    if (status != napi_ok || arrayType != napi_uint32_array) {
        LOGE("Expected Uint32Array for pixel data");
        return false;
    }

    size_t pixelCount = length / elementSize;
    *outPixelData = pixelData;
    *outPixelCount = pixelCount;
    return true;
}

static rive::rcp<rive::RenderImage> CreateRenderImage(int32_t width,
                                                      int32_t height,
                                                      RendererType rendererType,
                                                      const uint32_t *pixels,
                                                      bool premultiplied)
{
    rive::rcp<rive::RenderImage> renderImage;
    if (rendererType == RendererType::RIVE) {
        renderImage = ohos_rive::renderImageFromARGBIntsRive(static_cast<uint32_t>(width),
                                                             static_cast<uint32_t>(height), pixels, premultiplied);
    } else {
        renderImage = ohos_rive::renderImageFromARGBIntsCanvas(static_cast<uint32_t>(width),
                                                               static_cast<uint32_t>(height), pixels, premultiplied);
    }
    return renderImage;
}

napi_value OhosFileAsset::CreateFromARGBInts(napi_env env, napi_callback_info info)
{
    napi_value argv[ARG_NUM_FIVE];
    if (!ParseCreateFromARGBArgs(env, info, argv)) {
        return nullptr;
    }

    void *pixelData = nullptr;
    size_t pixelCount = 0;
    if (!ExtractPixelData(env, argv[ARG_NUM_ZERO], &pixelData, &pixelCount)) {
        return nullptr;
    }

    int32_t width = 0;
    int32_t height = 0;
    int32_t rendererTypeIdx = 0;
    bool premultiplied;
    napi_get_value_int32(env, argv[ARG_NUM_ONE], &width);
    napi_get_value_int32(env, argv[ARG_NUM_TWO], &height);
    napi_get_value_int32(env, argv[ARG_NUM_THREE], &rendererTypeIdx);
    napi_get_value_bool(env, argv[ARG_NUM_FOUR], &premultiplied);

    size_t expectedPixels = static_cast<size_t>(width) * static_cast<size_t>(height);
    if (width <= 0 || height <= 0 || pixelCount != expectedPixels) {
        LOGE("Invalid arguments for ARGBInts");
        return nullptr;
    }

    auto rendererType = static_cast<RendererType>(rendererTypeIdx);
    const uint32_t *pixels = reinterpret_cast<const uint32_t *>(pixelData);

    auto renderImage = CreateRenderImage(width, height, rendererType, pixels, premultiplied);
    if (!renderImage) {
        LOGE("Failed to create render image from ARGB ints");
        return nullptr;
    }

    napi_value result;
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(renderImage.release()), &result);
    return result;
}

napi_value OhosFileAsset::CreateFromBitmap(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value argv[ARG_NUM_THREE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    napi_value pixelMapValue = argv[ARG_NUM_ZERO];
    int32_t rendererTypeIdx;
    bool premultiplied;
    napi_get_value_int32(env, argv[ARG_NUM_ONE], &rendererTypeIdx);
    napi_get_value_bool(env, argv[ARG_NUM_TWO], &premultiplied);

    auto rendererType = static_cast<RendererType>(rendererTypeIdx);
    rive::rcp<rive::RenderImage> renderImage;

    if (rendererType == RendererType::RIVE) {
        renderImage = ohos_rive::renderImageFromPixelMapRive(env, pixelMapValue, premultiplied);
    } else {
        renderImage = ohos_rive::renderImageFromPixelmapCanvas(env, pixelMapValue);
    }

    if (!renderImage) {
        LOGE("Failed to create render image from bitmap");
        return nullptr;
    }

    napi_value result;
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(renderImage.release()), &result);
    return result;
}

napi_value OhosFileAsset::ReleaseRenderImage(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t ptrValue = 0;
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, argv[ARG_NUM_ZERO], &ptrValue, &lossless);
    if (status != napi_ok || !lossless || ptrValue == 0 || ptrValue == 0x9) {
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }

    ReleaseAsset<rive::RenderImage>(ptrValue);

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

// FontAsset
napi_value OhosFileAsset::SetFont(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value argv[ARG_NUM_TWO];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *fontAsset = GetNativePtr<rive::FontAsset>(env, argv[ARG_NUM_ZERO]);
    auto *font = GetNativePtr<rive::Font>(env, argv[ARG_NUM_ONE]);

    if (!fontAsset || !font) {
        LOGE("Invalid pointer");
        return nullptr;
    }

    fontAsset->font(rive::ref_rcp(font));

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value OhosFileAsset::GetFont(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *fontAsset = GetNativePtr<rive::FontAsset>(env, argv[ARG_NUM_ZERO]);
    if (!fontAsset) {
        LOGE("Invalid FontAsset pointer");
        return nullptr;
    }

    auto font = fontAsset->font();
    napi_value result;
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(font.get()), &result);
    return result;
}

napi_value OhosFileAsset::CreateFont(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value argv[ARG_NUM_TWO];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    int32_t rendererTypeIdx;
    napi_get_value_int32(env, argv[ARG_NUM_ONE], &rendererTypeIdx);

    // use the renderer type to decode the font asset
    auto font = decodeAsset<rive::Font>(env, argv[ARG_NUM_ZERO], rendererTypeIdx);

    if (!font) {
        LOGE("Failed to decode font asset");
        return nullptr;
    }

    napi_value result;
    napi_status status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(font.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result value");
        return nullptr;
    }

    return result;
}

napi_value OhosFileAsset::ReleaseFont(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t ptrValue = 0;
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, argv[ARG_NUM_ZERO], &ptrValue, &lossless);
    if (status != napi_ok || !lossless || ptrValue == 0 || ptrValue == 0x9) {
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }

    ReleaseAsset<rive::Font>(ptrValue);

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value OhosFileAsset::SetAudio(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value argv[ARG_NUM_TWO];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *audioAsset = GetNativePtr<rive::AudioAsset>(env, argv[ARG_NUM_ZERO]);
    auto *audioSource = GetNativePtr<rive::AudioSource>(env, argv[ARG_NUM_ONE]);

    if (!audioAsset || !audioSource) {
        LOGE("Invalid audio asset or audio source pointer");
        return nullptr;
    }

    audioAsset->audioSource(rive::ref_rcp(audioSource));

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value OhosFileAsset::GetAudio(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    auto *audioAsset = GetNativePtr<rive::AudioAsset>(env, argv[ARG_NUM_ZERO]);
    if (!audioAsset) {
        LOGE("Invalid AudioAsset pointer");
        return nullptr;
    }

    auto audioSource = audioAsset->audioSource();
    napi_value result;
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(audioSource.get()), &result);
    return result;
}

napi_value OhosFileAsset::CreateAudio(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value argv[ARG_NUM_TWO];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    int32_t rendererTypeIdx;
    napi_get_value_int32(env, argv[ARG_NUM_ONE], &rendererTypeIdx);

    auto audio = decodeAsset<rive::AudioSource>(env, argv[ARG_NUM_ZERO], rendererTypeIdx);

    if (!audio) {
        LOGE("Failed to decode audio asset");
        return nullptr;
    }

    napi_value result;
    napi_status status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(audio.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result value");
        return nullptr;
    }

    return result;
}

napi_value OhosFileAsset::ReleaseAudio(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value argv[ARG_NUM_ONE];
    napi_value thisArg;

    napi_get_cb_info(env, info, &argc, argv, &thisArg, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments");
        return nullptr;
    }

    uint64_t ptrValue = 0;
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, argv[ARG_NUM_ZERO], &ptrValue, &lossless);
    if (status != napi_ok || !lossless || ptrValue == 0 || ptrValue == 0x9) {
        napi_value result;
        napi_get_undefined(env, &result);
        return result;
    }

    ReleaseAsset<rive::AudioSource>(ptrValue);

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

} // namespace ohos_rive
