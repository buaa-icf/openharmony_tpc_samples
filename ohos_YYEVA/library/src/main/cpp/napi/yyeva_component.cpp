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
 
#include <string>
#include <ohos/ohos_log.h>
#include <ohos/ohos_window.h>
#include <map>
#include <mutex>
#include "yyeva_component.h"
#include <cstdint>
#include <cstdlib>
#include <multimedia/image_framework/image_pixel_map_napi.h>

struct Surface_t {
    OHNativeWindow *nativeWindow;
    OHNativeWindowBuffer *winBuffer;
    BufferHandle *bufferHandler;
    int32_t releaseFenceFd;
};

void onSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    LOGI("napi-->OnSurfaceCreatedCB");
    OHNativeWindow *nativeWindow = static_cast<OHNativeWindow *>(window);
    // YYEVAComponent::instance().AddWindow(YYEVAComponent::instance().GetComponentId(component), nativeWindow);
}

void onSurfaceChangedCB(OH_NativeXComponent *component, void *window)
{
    LOGI("napi-->OnSurfaceChangedCB");
    std::string componentId = YYEVAComponent::GetComponentId(component);
    uint64_t width = 0;
    uint64_t height = 0;
    int ret = OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    ret = OH_NativeWindow_NativeWindowHandleOpt((OHNativeWindow *)window, SET_BUFFER_GEOMETRY, width, height);
    LOGI("napi-->OnSurfaceChangedCB window %p width %d height %d ret %d", window, width, height, ret);
}

void onSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    LOGI("napi-->OnSurfaceDestroyedCB");
    OHNativeWindow *nativeWindow = static_cast<OHNativeWindow *>(window);
    YYEVAComponent::Instance().RemoveWindow(YYEVAComponent::Instance().GetComponentId(component));
}

void dispatchTouchEventCB(OH_NativeXComponent *component, void *window)
{
    LOGI("napi-->DispatchTouchEventCB");
}

YYEVAComponent::YYEVAComponent()
{
    callback_.OnSurfaceCreated = onSurfaceCreatedCB;
    callback_.OnSurfaceChanged = onSurfaceChangedCB;
    callback_.OnSurfaceDestroyed = onSurfaceDestroyedCB;
    callback_.DispatchTouchEvent = dispatchTouchEventCB;
}

YYEVAComponent::~YYEVAComponent() {}

bool YYEVAComponent::initComponent(napi_env env, napi_value exports)
{
    napi_status status;
    napi_value exportInstance = nullptr;

    status = napi_get_named_property(env, exports, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    if (status != napi_ok) {
        return false;
    }
    LOGI("napi-->initXComponent napi_get_named_property");
    status = napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent_));
    if (status != napi_ok) {
        LOGE("napi-->initXComponent napi_unwrap failed, %d", status);
        return false;
    }
    LOGI("napi-->initXComponent napi_unwrap");

    OH_NativeXComponent_RegisterCallback(nativeXComponent_, &callback_);
    return true;
}

std::string YYEVAComponent::GetComponentId(OH_NativeXComponent *component)
{
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    int ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return "";
    }
    return std::string(idStr);
}

std::shared_ptr<RenderController> YYEVAComponent::GetRenderController(int controllerId)
{
    if (renderMap_.find(controllerId) == renderMap_.end()) {
        return nullptr;
    }
    return renderMap_[controllerId];
}

std::shared_ptr<RenderController> YYEVAComponent::AddRenderController(int &rendId)
{
    std::shared_ptr<RenderController> renderController = std::make_shared<RenderController>();
    rendId = ++renderId_;
    renderMap_.insert(std::make_pair(rendId, renderController));
    return renderController;
}

void YYEVAComponent::RemoveRenderController(int controllerId)
{
    if (renderMap_.find(controllerId) == renderMap_.end()) {
        return;
    }
    renderMap_.erase(controllerId);
}

void YYEVAComponent::AddWindow(const std::string &surfaceId, Surface_t *surface)
{
    nativeWindowMap_[surfaceId] = surface;
}

void YYEVAComponent::RemoveWindow(const std::string &surfaceId)
{
    if (nativeWindowMap_.find(surfaceId) == nativeWindowMap_.end()) {
        return;
    }
    Surface_t *surface = nativeWindowMap_[surfaceId];
    nativeWindowMap_.erase(surfaceId);
    delete surface;
}

void *YYEVAComponent::FindWindowBySurfaceId(const std::string &surfaceId)
{
    if (nativeWindowMap_.find(surfaceId) == nativeWindowMap_.end()) {
        return nullptr;
    }
    return nativeWindowMap_[surfaceId]->nativeWindow;
}

void *YYEVAComponent::CreateWindowBySurfaceId(const std::string &surfaceId)
{
    uint64_t id = atoll(surfaceId.c_str());
    LOGD("Create Window, surfaceId: %s -> %llu", surfaceId.c_str(), id);
    Surface_t *surface = new Surface_t();
    OH_NativeWindow_CreateNativeWindowFromSurfaceId(id, &surface->nativeWindow);
    AddWindow(surfaceId, surface);
    return surface->nativeWindow;
}

YYEVAComponent &YYEVAComponent::Instance()
{
    static YYEVAComponent yyevaInstance;
    return yyevaInstance;
}

YYEVAComponent::PixelMap::PixelMap() {}

YYEVAComponent::PixelMap::~PixelMap()
{
    Unlock();
}

OH_NativeBuffer_Format EglFormatToNativeFormat(EGLint eglFormat)
{
    OH_NativeBuffer_Format format = NATIVEBUFFER_PIXEL_FMT_RGBA_8888;
    switch (eglFormat) {
        case OHOS::Media::OHOS_PIXEL_MAP_FORMAT_RGBA_8888:
            format = NATIVEBUFFER_PIXEL_FMT_RGBA_8888;
            break;
        case OHOS::Media::OHOS_PIXEL_MAP_FORMAT_RGB_565:
            format = NATIVEBUFFER_PIXEL_FMT_RGB_565;
            break;
    }
    return format;
}

bool YYEVAComponent::PixelMap::Lock(void **pixels, OH_NativeBuffer_Config &pixelConfig)
{
    OH_Pixelmap_ImageInfo *srcInfo = nullptr;
    OH_PixelmapImageInfo_Create(&srcInfo);
    OH_PixelmapNative_GetImageInfo(nativePixelMap_, srcInfo);
    OH_PixelmapImageInfo_GetWidth(srcInfo, (uint32_t *)&pixelConfig.width);
    OH_PixelmapImageInfo_GetHeight(srcInfo, (uint32_t *)&pixelConfig.height);
    OH_PixelmapImageInfo_GetRowStride(srcInfo, (uint32_t *)&pixelConfig.stride);
    int32_t format;
    OH_PixelmapImageInfo_GetPixelFormat(srcInfo, &format);
    pixelConfig.format = EglFormatToNativeFormat(format);
    OH_PixelmapImageInfo_Release(srcInfo);
    LOGD("pixmap format: %d -> %d", format, pixelConfig.format);

    Image_ErrorCode result = OH_PixelmapNative_AccessPixels(nativePixelMap_, pixels);
    if (result != IMAGE_SUCCESS || *pixels == nullptr) {
        LOGE("Failed to access pixels: %d", result);
        return false;
    }
    lock_ = true;
    return true;
}

void YYEVAComponent::PixelMap::Unlock()
{
    if (lock_ == false) {
        return;
    }
    Image_ErrorCode result = OH_PixelmapNative_UnaccessPixels(nativePixelMap_);
    if (result != IMAGE_SUCCESS) {
        ELOGE("Failed to unaccess pixels: %d", result);
        return;
    }
    lock_ = false;
}

OH_PixelmapNative *YYEVAComponent::PixelMap::GetPixelMap()
{
    return nativePixelMap_;
}

void YYEVAComponent::PixelMap::SetPixelMap(OH_PixelmapNative *pixelMap)
{
    nativePixelMap_ = pixelMap;
}

bool YYEVAComponent::PixelMap::IsNull()
{
    return nativePixelMap_ == nullptr;
}
