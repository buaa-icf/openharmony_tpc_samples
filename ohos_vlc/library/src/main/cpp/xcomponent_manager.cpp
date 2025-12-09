/*
# Copyright (c) 2025 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/

#include "xcomponent_manager.h"
#include "ohos_log.h"

XcomponentManager &XcomponentManager::GetInstance()
{
    static XcomponentManager instance;
    return instance;
}

int32_t XcomponentManager::RegisterCallback(OH_NativeXComponent *nativeXComponent)
{
    callback_.OnSurfaceCreated = Callbacks::OnSurfaceCreatedCB;
    callback_.OnSurfaceChanged = Callbacks::OnSurfaceChangedCB;
    callback_.OnSurfaceDestroyed = Callbacks::OnSurfaceDestroyedCB;
    callback_.DispatchTouchEvent = Callbacks::OnDispatchTouchEventCB;
    return OH_NativeXComponent_RegisterCallback(nativeXComponent, &callback_);
}

int32_t XcomponentManager::RegisterCallback(const std::string& id)
{
    std::unique_lock<std::mutex> lock(mtx_);
    auto it = nativeXcomponentMap_.find(id);
    if (it == nativeXcomponentMap_.end()) {
        return -1;
    }
    OH_NativeXComponent *nativeXComponent = nativeXcomponentMap_[id];
    return RegisterCallback(nativeXComponent);
}

void XcomponentManager::Callbacks::OnDispatchTouchEventCB(OH_NativeXComponent *component, void *window) {}

void XcomponentManager::Callbacks::OnSurfaceChangedCB(OH_NativeXComponent *component, void *window) {}

void XcomponentManager::Callbacks::OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    char id[OH_XCOMPONENT_ID_LEN_MAX + 1] = {0};
    uint64_t len = OH_XCOMPONENT_ID_LEN_MAX;
    int32_t ret = OH_NativeXComponent_GetXComponentId(component, id, &len);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    LOGD("id: %s", id);
    xMgr.AddNativeWindow(id, (OHNativeWindow*)window);
}

void XcomponentManager::Callbacks::OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    char id[OH_XCOMPONENT_ID_LEN_MAX + 1] = {0};
    uint64_t len = OH_XCOMPONENT_ID_LEN_MAX;
    int32_t ret = OH_NativeXComponent_GetXComponentId(component, id, &len);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    LOGD("id: %s", id);
    xMgr.Release(id);
}

int32_t XcomponentManager::AddNativeXcomponent(const std::string& id, OH_NativeXComponent* nativeXComponent)
{
    std::unique_lock<std::mutex> lock(mtx_);
    LOGD("id: %s", id.c_str());
    nativeXcomponentMap_[id] = nativeXComponent;
    return 0;
}

int32_t XcomponentManager::AddNativeWindow(const std::string& id, OHNativeWindow* win)
{
    std::unique_lock<std::mutex> lock(mtx_);
    LOGD("id: %s", id.c_str());
    OHNativeWindowMap_[id] = win;
    return 0;
}

OH_NativeXComponent* XcomponentManager::GetNativeXcomponent(const std::string& id)
{
    std::unique_lock<std::mutex> lock(mtx_);
    auto item = nativeXcomponentMap_.find(id);
    if (item == nativeXcomponentMap_.end()) {
        LOGE("GetNativeXcomponent failed, id: %s", id.c_str());
        return nullptr;
    }
    return item->second;
}

OHNativeWindow* XcomponentManager::GetNativeWindow(const std::string& id)
{
    std::unique_lock<std::mutex> lock(mtx_);
    auto item = OHNativeWindowMap_.find(id);
    if (item == OHNativeWindowMap_.end()) {
        LOGE("GetNativeWindow failed, id: %s", id.c_str());
        return nullptr;
    }
    return item->second;
}

void XcomponentManager::Release(const std::string& id)
{
    std::unique_lock<std::mutex> lock(mtx_);
    nativeXcomponentMap_.erase(id);
    OHNativeWindowMap_.erase(id);
}