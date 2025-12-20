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

#ifndef OHOS_RIVE_FILE_ASSET_LOADER_H
#define OHOS_RIVE_FILE_ASSET_LOADER_H

#include "../../include/helpers/render_type.h"
#include "rive/assets/audio_asset.hpp"
#include "rive/assets/font_asset.hpp"
#include "rive/assets/image_asset.hpp"
#include "rive/factory.hpp"
#include "rive/file_asset_loader.hpp"
#include <napi/native_api.h>

namespace ohos_rive {
class FileAssetLoader : public rive::FileAssetLoader {
public:
    FileAssetLoader(napi_env env, napi_value jsObject);
    ~FileAssetLoader() override;

    bool loadContents(rive::FileAsset &asset, rive::Span<const uint8_t> inBandBytes, rive::Factory *factory) override;

    void setRendererType(RendererType rendererType);
    RendererType getRendererType() const;
    napi_env GetEnv() const;

private:
    static napi_value MakeJsAsset(napi_env env, rive::FileAsset &asset, RendererType rendererType);
    static napi_value CreateByteArray(napi_env env, rive::Span<const uint8_t> data);

    napi_env m_env;
    napi_ref m_jsFileAssetLoaderRef = nullptr;
    napi_ref m_jsLoadContentsMethodRef = nullptr;
    RendererType m_rendererType = RendererType::NONE;
};
} // namespace ohos_rive

#endif // OHOS_RIVE_FILE_ASSET_LOADER_H

