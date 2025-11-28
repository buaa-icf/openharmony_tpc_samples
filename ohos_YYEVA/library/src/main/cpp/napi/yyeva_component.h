/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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
#ifndef YYEVA_OHOS_COMPONENT_H
#define YYEVA_OHOS_COMPONENT_H
#include <string>
#include <cstdint>
#include <ohos/ohos_window.h>
#include <engine/rendercontroller.h>
#include <engine/recordrender.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <native_window/external_window.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include <map>
#include <atomic>
#include <mutex>
#include <memory>

class YYEVAComponent {
public:
    YYEVAComponent();
    ~YYEVAComponent();
    bool initComponent(napi_env env, napi_value exports);
    static std::string GetComponentId(OH_NativeXComponent *component);

    typedef struct Surface_t Surface_t;

    std::shared_ptr<RenderController> GetRenderController(int controllerId);
    std::shared_ptr<RenderController> AddRenderController(int &renderId);
    void RemoveRenderController(int controllerId);

    void PixelLock(NativePixelMap *pixelMap, OH_NativeBuffer_Config &pixelConfig);
    void PixelUnlock(NativePixelMap *pixelMap);

    void AddWindow(const std::string &surfaceId, Surface_t *surface);
    void RemoveWindow(const std::string &surfaceId);
    void *FindWindowBySurfaceId(const std::string &surfaceId);
    void *CreateWindowBySurfaceId(const std::string &surfaceId);
    static YYEVAComponent &Instance();

    class PixelMap {
    public:
        PixelMap();
        ~PixelMap();
        bool Lock(void **pixels, OH_NativeBuffer_Config &pixelConfig);
        void Unlock();
        NativePixelMap *GetPixelMap();
        void SetPixelMap(NativePixelMap *pixelMap);
        bool IsNull();

    private:
        NativePixelMap *nativePixelMap_ = nullptr;
        std::atomic<bool> lock_ {false};
    };

private:
    std::map<int, std::shared_ptr<RenderController>> renderMap_;
    int renderId_ = 0;
    std::mutex mutex_;

    OH_NativeXComponent *nativeXComponent_ = nullptr;
    OH_NativeXComponent_Callback callback_;
    std::map<std::string, Surface_t *> nativeWindowMap_;
};
#endif // YYEVA_OHOS_COMPONENT_H