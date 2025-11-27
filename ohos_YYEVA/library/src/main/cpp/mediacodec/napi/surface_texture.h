/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef VIDEO_CODEC_SURFACETEXTURE_H
#define VIDEO_CODEC_SURFACETEXTURE_H
#include <string>
#include <memory>
#include <functional>
#include <multimedia/image_framework/image_mdk_common.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <native_image/native_image.h>
#include <thread>
#include <atomic>
#include <mutex>
#include <condition_variable>
#include <ohos/napi_object.h>

class SurfaceTexture : public NapiObject {
public:
    SurfaceTexture(const napi_env &env, int64_t textureId);
    virtual ~SurfaceTexture();
    void UpdateTexImage();
    void SetOnFrameAvailableListener(const std::function<void()> &onFrameAvailable);
    void SetDefaultBufferSize(int32_t width, int32_t height);
    void Release();
    void OnFrameAvailable();
    OHNativeWindow *GetWindow();

private:
    int64_t textureId_;
    OH_NativeImage *image_ = nullptr;
    OHNativeWindow *window_;
    std::function<void()> onFrameAvailable_;
};
#endif