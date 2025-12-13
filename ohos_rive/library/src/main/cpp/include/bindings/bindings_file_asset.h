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

#ifndef OHOS_RIVE_BINDINGS_FILE_ASSET_H
#define OHOS_RIVE_BINDINGS_FILE_ASSET_H

#include "napi/native_api.h"
#include "rive/assets/audio_asset.hpp"
#include "rive/assets/file_asset.hpp"
#include "rive/assets/font_asset.hpp"
#include "rive/assets/image_asset.hpp"
#include "rive/simple_array.hpp"

namespace ohos_rive {

// 辅助函数：从 napi_value 获取 native 指针
template <typename T>
T *GetNativePtr(napi_env env, napi_value value)
{
    uint64_t ptr;
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, value, &ptr, &lossless);
    if (status != napi_ok || !lossless) {
        return nullptr;
    }
    if (ptr == 0) {
        return nullptr;
    }
    return reinterpret_cast<T *>(ptr);
}

class OhosFileAsset {
public:
    // FileAsset 基础方法
    static napi_value GetName(napi_env env, napi_callback_info info);
    static napi_value GetUniqueFilename(napi_env env, napi_callback_info info);
    static napi_value Decode(napi_env env, napi_callback_info info);
    static napi_value GetCDNUrl(napi_env env, napi_callback_info info);

    // ImageAsset 方法
    static napi_value SetRenderImage(napi_env env, napi_callback_info info);
    static napi_value GetRenderImage(napi_env env, napi_callback_info info);
    static napi_value GetImageWidth(napi_env env, napi_callback_info info);
    static napi_value GetImageHeight(napi_env env, napi_callback_info info);

    // RenderImage 创建方法
    static napi_value CreateFromRGBABytes(napi_env env, napi_callback_info info);
    static napi_value CreateFromARGBInts(napi_env env, napi_callback_info info);
    static napi_value CreateFromBitmap(napi_env env, napi_callback_info info);
    static napi_value ReleaseRenderImage(napi_env env, napi_callback_info info);

    // FontAsset 方法
    static napi_value SetFont(napi_env env, napi_callback_info info);
    static napi_value GetFont(napi_env env, napi_callback_info info);
    static napi_value CreateFont(napi_env env, napi_callback_info info);
    static napi_value ReleaseFont(napi_env env, napi_callback_info info);

    // AudioAsset 方法
    static napi_value SetAudio(napi_env env, napi_callback_info info);
    static napi_value GetAudio(napi_env env, napi_callback_info info);
    static napi_value CreateAudio(napi_env env, napi_callback_info info);
    static napi_value ReleaseAudio(napi_env env, napi_callback_info info);

private:
    static rive::FileAsset *GetFileAssetPtr(napi_env env, napi_callback_info info);
    static rive::ImageAsset *GetImageAssetPtr(napi_env env, napi_callback_info info);
    static rive::FontAsset *GetFontAssetPtr(napi_env env, napi_callback_info info);
    static rive::AudioAsset *GetAudioAssetPtr(napi_env env, napi_callback_info info);

    static bool GetBytesFromArray(napi_env env,
                                  napi_value array,
                                  rive::SimpleArray<uint8_t> &bytes,
                                  bool useRawData = false);
};
} // namespace ohos_rive

#endif // OHOS_RIVE_BINDINGS_FILE_ASSET_H

