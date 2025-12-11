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
#include "surface_texture.h"
#include <unordered_map>
#include <ohos/ohos_log.h>
#include <native_window/external_window.h>
#include <EGL/egl.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>
#include <GLES2/gl2ext.h>
#include <thread>

SurfaceTexture::SurfaceTexture(const napi_env &env, int64_t textureId) : NapiObject(env), textureId_(textureId)
{
    image_ = OH_NativeImage_Create(textureId_, GL_TEXTURE_EXTERNAL_OES);
    if (image_ == nullptr) {
        LOGE("create native image failed, surfaceId: %d", textureId_);
        return;
    }
    window_ = OH_NativeImage_AcquireNativeWindow(image_);
    if (window_ == nullptr) {
        LOGE("acquire native window failed, surfaceId: %d", textureId_);
        return;
    }

    OH_OnFrameAvailableListener listener = {this, [](void *context) {
                                                SurfaceTexture *surface = static_cast<SurfaceTexture *>(context);
                                                if (surface == nullptr) {
                                                    return;
                                                }
                                                surface->OnFrameAvailable();
                                            }};
    int ret = OH_NativeImage_SetOnFrameAvailableListener(image_, listener);
    if (ret != 0) {
        LOGE("set onFrame listener failed, %d", ret);
    }
}

SurfaceTexture::~SurfaceTexture()
{
    Release();
}

void SurfaceTexture::UpdateTexImage()
{
    if (threadTask_ == nullptr) {
        return;
    }
    threadTask_->Send([this]() {
        if (image_ != nullptr) {
            OH_NativeImage_UpdateSurfaceImage(image_);
        }
    });
}

void SurfaceTexture::SetOnFrameAvailableListener(const std::function<void()> &onFrameAvailable)
{
    onFrameAvailable_ = onFrameAvailable;
}

void SurfaceTexture::SetDefaultBufferSize(int32_t width, int32_t height)
{
    if (window_ == nullptr) {
        LOGE("window acquire failed");
        return;
    }
    int code = SET_BUFFER_GEOMETRY;
    int32_t ret = OH_NativeWindow_NativeWindowHandleOpt(window_, code, width, height);
}

void SurfaceTexture::Release()
{
    if (image_) {
        LOGE("release native image");
        OH_NativeImage_DetachContext(image_);
        OH_NativeImage_Destroy(&image_);
        image_ = nullptr;
    }
    window_ = nullptr;
}

void SurfaceTexture::OnFrameAvailable()
{
    if (onFrameAvailable_ == nullptr) {
        LOGE("onFrameAvailable is nullptr");
        return;
    }
    onFrameAvailable_();
}

OHNativeWindow *SurfaceTexture::GetWindow()
{
    return window_;
}

void SurfaceTexture::AttachWindow()
{
    if (image_) {
        OH_NativeImage_AttachContext(image_, textureId_);
    }
}

void SurfaceTexture::DetachWindow()
{
    if (image_) {
        OH_NativeImage_DetachContext(image_);
    }
}

void SurfaceTexture::AttachThread(const std::shared_ptr<ThreadTask> &threadTask)
{
    threadTask_ = threadTask;
}
