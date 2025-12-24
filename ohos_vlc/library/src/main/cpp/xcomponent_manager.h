/*
# Copyright (c) 2024 Huawei Device Co., Ltd.
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

#pragma once
#include <mutex>
#include <string>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <native_window/external_window.h>

class XcomponentManager {
public:
    static XcomponentManager &GetInstance();

    int32_t RegisterCallback(const std::string& id);
    int32_t AddNativeXcomponent(const std::string& id, OH_NativeXComponent* nativeXComponent);
    int32_t AddNativeWindow(const std::string& id, OHNativeWindow* win);
    OH_NativeXComponent* GetNativeXcomponent(const std::string& id);
    OHNativeWindow* GetNativeWindow(const std::string& id);
    void Release(const std::string& id);
    
private:
    class Callbacks {
        public:
        static void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window);
        static void OnSurfaceChangedCB(OH_NativeXComponent *component, void *window);
        static void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window);
        static void OnDispatchTouchEventCB(OH_NativeXComponent *component, void *window);
    };
    int32_t RegisterCallback(OH_NativeXComponent *nativeXComponent);
    OH_NativeXComponent_Callback callback_;
    std::mutex mtx_;
    std::unordered_map<std::string, OH_NativeXComponent*> nativeXcomponentMap_;
    std::unordered_map<std::string, OHNativeWindow*> OHNativeWindowMap_;
};

#define xMgr XcomponentManager::GetInstance()
