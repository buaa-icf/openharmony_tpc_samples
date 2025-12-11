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
#include <napi/native_api.h>
#include <string>
#include <ohos/ohos_log.h>
#include <ohos/ohos_window.h>
#include <engine/rendercontroller.h>
#include <record/recordercontroller.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <native_window/external_window.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include <map>
#include <mutex>
#include "ohos/napi_handler.h"
#include "yyeva_napi.h"
#include "yyeva_component.h"
#include "ohos/threadtask.h"
#include "ohos/napi_safe_wrapper.h"

#define LOG_TAG    "YYEVANAPI"
#define ELOGE(...) OhosLogPrint(IL_ERROR, LOG_TAG, __VA_ARGS__)
#define ELOGD(...) OhosLogPrint(IL_DEBUG, LOG_TAG, __VA_ARGS__)
#define ELOGV(...) OhosLogPrint(IL_INFO, LOG_TAG, __VA_ARGS__)

using namespace std;
using namespace yyeva;
map<int, std::shared_ptr<RenderController>> renderMap;
map<int, std::shared_ptr<RecorderController>> recordMap;
std::map<int, std::shared_ptr<ThreadTask>> threadMap;
static int g_renderId = 0;
static mutex g_mtx;
static napi_ref g_thread_ref = nullptr;

static void JsThreadTaskDestructor(napi_env env, void *nativeObject, void *finalizeHint)
{
    LOGD("destructor SurfaceTexture");
    NapiSafeWrappable<ThreadTask> *threadTask = static_cast<NapiSafeWrappable<ThreadTask> *>(nativeObject);
    if (threadTask == nullptr) {
        return;
    }
    delete threadTask;
}

static napi_value JsThreadTaskConstructor(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);

    LOGD("constructor ThreadTask");
    NapiSafeWrappable<ThreadTask> *threadWrapper;
    if (napiHandler.GetArgType(INDEX_0) == napi_number) {
        ELOGE("by id ThreadTask env: %p", env);
        int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
        if (threadMap.find(controllerId) == threadMap.end()) {
            ELOGE("getExternalTexture controller %d not found", controllerId);
            return nullptr;
        }
        auto thread = threadMap[controllerId];
        if (thread == nullptr) {
            ELOGE("thread is nullptr");
            return nullptr;
        }
        threadWrapper = new NapiSafeWrappable<ThreadTask>(thread);
        if (threadWrapper == nullptr) {
            ELOGE("wrapper calloc failed");
            return nullptr;
        }
    } else {
        ELOGE("by name");
        std::string name = napiHandler.ParseArgAs<std::string>(INDEX_0);
        threadWrapper = new NapiSafeWrappable<ThreadTask>(env, name);

        threadWrapper->ExecuteSafely([](const std::shared_ptr<ThreadTask> &obj) {
            obj->OnWork([](napi_env env, const Task &task) {
                task();
            });
            obj->Start();
        });
    }

    return napiHandler.BindObject(threadWrapper, JsThreadTaskDestructor);
}

static napi_value thread_stop(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_0);
    NapiSafeWrappable<ThreadTask> *threadWrapper = napiHandler.UnbindObject<NapiSafeWrappable<ThreadTask>>();

    if (threadWrapper == nullptr) {
        LOGE("Unbind threadtask nullptr");
        return nullptr;
    }
    auto threadTask = threadWrapper->GetSafeObject();
    NapiAsyncHandler *asyncHandler = new NapiAsyncHandler(env, "stop");
    asyncHandler->OnWork([threadTask](napi_env env, void *d) -> napi_status {
        threadTask->Stop();
        return napi_ok;
    });
    return napiHandler.Promise(asyncHandler);
}

static napi_value InitThreadTask(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        DECLARE_NAPI_FUNCTION("stop", thread_stop),
    };

    napi_value thread = nullptr;
    std::string className = "ThreadTask";
    napi_define_class(
        env, className.c_str(), className.length(), JsThreadTaskConstructor, nullptr, sizeof(desc) / sizeof(desc[0]),
        desc, &thread);
    napi_status status = napi_create_reference(env, thread, 1, &g_thread_ref);
    if (status != napi_ok) {
        LOGE("Failed to create MediaFormat constructor reference");
        return nullptr;
    }
    ELOGE("ThreadTask env: %p", env);
    napi_set_named_property(env, exports, "ThreadTask", thread);
    return exports;
}

static napi_value getRenderThread(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    napi_value constructor;
    napi_status status = napi_get_reference_value(env, g_thread_ref, &constructor);
    if (status != napi_ok) {
        ELOGE("Failed to get thread constructor reference");
        return nullptr;
    }

    napi_value instance;
    napi_value args[] = {napiHandler.GetArg(INDEX_0)};
    status = napi_new_instance(env, constructor, 1, args, &instance);
    if (status != napi_ok) {
        ELOGE("Failed to create new instance");
        return nullptr;
    }
    // NAPI_CALL(env, napi_wrap(env, instance, threadWrapper, JsThreadTaskDestructor, nullptr, nullptr));
    return instance;
}

static void ThreadCall(napi_env env, int id, const Task &task)
{
    if (id <= 0) {
        return;
    }
    if (threadMap.find(id) == threadMap.end()) {
        LOGE("threadMap not find %d", id);
        auto threadTask = std::make_shared<ThreadTask>(env, "rendertask_" + std::to_string(id));
        threadTask->OnWork([&](napi_env env, const Task &task) {
            task();
        });
        threadTask->Start();
        threadMap.insert(std::make_pair(id, threadTask));
    }
    threadMap[id]->Send(task);
}

static napi_value nativeProcessPixelMap(napi_env env, napi_callback_info info)
{
    YYEVAComponent::PixelMap nativePixelMap;
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);

    NAPI_CALL(env, napiHandler.ParseArgs(INDEX_0, [&](const napi_value &arg) -> napi_status {
        NativePixelMap *pixMap = OH_PixelMap_InitNativePixelMap(env, arg);
        nativePixelMap.SetPixelMap(pixMap);
        return !nativePixelMap.IsNull() ? napi_ok : napi_generic_failure;
    }));

    OH_NativeBuffer_Config nativeConfig;
    void *pixels = nullptr;
    bool ret = nativePixelMap.Lock(&pixels, nativeConfig);
    if (ret == false) {
        ELOGE("Failed to access pixels");
        return nullptr;
    }

    nativePixelMap.Unlock();
    return napiHandler.GetVoidValue();
}

static napi_value getExternalTexture(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("getExternalTexture controller %d not found", controllerId);
        return napiHandler.GetNapiValue<int32_t>(-1);
    }
    int texture = renderMap[controllerId]->getExternalTexture();
    return napiHandler.GetNapiValue<int32_t>(texture);
}

static napi_value updateViewPoint(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_3);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    int width = static_cast<int32_t>(napiHandler.ParseArgAs<double>(INDEX_1));
    int height = static_cast<int32_t>(napiHandler.ParseArgAs<double>(INDEX_2));

    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("updateViewPoint controller %d not found", controllerId);
        return nullptr;
    }
    if (width > 0 && height > 0) {
        renderMap[controllerId]->updateViewPoint(width, height);
    }
    return nullptr;
}

static napi_value videoSizeChange(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_3);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    int newWidth = napiHandler.ParseArgAs<int>(INDEX_1);
    int newHeight = napiHandler.ParseArgAs<int>(INDEX_2);

    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("videoSizeChange controller %d not found", controllerId);
        return nullptr;
    }
    renderMap[controllerId]->videoSizeChange(newWidth, newHeight);
    return nullptr;
}

static napi_value initRender(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_5);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    std::string surfaceId = napiHandler.ParseArgAs<std::string>(INDEX_1);
    bool isNeedYUV = napiHandler.ParseArgAs<bool>(INDEX_2);
    bool isNormalMp4 = napiHandler.ParseArgAs<bool>(INDEX_3);
    bool isVideoRecord = napiHandler.ParseArgAs<bool>(INDEX_4);

    int id = controllerId;
    lock_guard<mutex> auto_lock(g_mtx);
    std::shared_ptr<RenderController> controller = nullptr;
    if (controllerId == -1) {
        g_renderId += 1;
        id = g_renderId;
        controller = std::make_shared<RenderController>();
        renderMap.insert(make_pair(id, controller));
    } else if (renderMap.find(controllerId) != renderMap.end()) {
        controller = renderMap[controllerId];
    } else {
        ELOGE("initRender controller %d not found", controllerId);
    }
    if (controller == nullptr) {
        return nullptr;
    }
    ThreadCall(env, id, [controller, isNeedYUV, surfaceId, isVideoRecord, isNormalMp4]() {
        if (controller->getExternalTexture() == -1) { // 防止重复初始化
            OHNativeWindow *window = nullptr;
            uint64_t sid = atoll(surfaceId.c_str());
            LOGD("Create Window, surfaceId: %s -> %llu", surfaceId.c_str(), sid);
            OH_NativeWindow_CreateNativeWindowFromSurfaceId(sid, &window);
            controller->initRender(window, isNeedYUV, isNormalMp4);
            controller->setVideoRecord(isVideoRecord);
        } else {
            ELOGE("initRender init repeat");
        }
    });

    return napiHandler.GetNapiValue<int32_t>(id);
}

static napi_value setRenderConfig(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    std::string json = napiHandler.ParseArgAs<std::string>(INDEX_1);

    if (controllerId == -1) {
        ELOGE("setRenderConfig controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("setRenderConfig controller %d not found", controllerId);
        return nullptr;
    }
    auto config = EvaAnimeConfig::parse(json.c_str());
    if (config != nullptr) {
        renderMap[controllerId]->setRenderConfig(config);
    }
    return napiHandler.GetVoidValue();
}

static napi_value defaultConfig(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_4);
    int32_t controllerId = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    int32_t videoWidth = napiHandler.ParseArgAs<int32_t>(INDEX_1);
    int32_t videoHeight = napiHandler.ParseArgAs<int32_t>(INDEX_2);
    int32_t defaultVideoMode = napiHandler.ParseArgAs<int32_t>(INDEX_3);

    if (controllerId == -1) {
        ELOGE("defaultConfig controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("defaultConfig controller %d not found", controllerId);
        return nullptr;
    }
    shared_ptr<EvaAnimeConfig> config =
        EvaAnimeConfig::defaultConfig((int)videoWidth, (int)videoHeight, (int)defaultVideoMode);

    if (config != nullptr) {
        renderMap[controllerId]->setRenderConfig(config);
    }
    return napiHandler.GetVoidValue();
}

static napi_value renderFrame(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);

    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("renderFrame controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("renderFrame controller %d not found", controllerId);
        return nullptr;
    }
    auto controller = renderMap[controllerId];

    ThreadCall(env, controllerId, [controller]() {
        controller->renderFrame();
    });
    return napiHandler.GetVoidValue();
}

static napi_value renderSwapBuffers(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);

    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("renderSwapBuffers controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("renderSwapBuffers controller %d not found", controllerId);
        return nullptr;
    }
    auto controller = renderMap[controllerId];

    ThreadCall(env, controllerId, [controller]() {
        controller->renderSwapBuffers();
    });

    return napiHandler.GetVoidValue();
}

static napi_value renderClearFrame(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);

    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("renderClearFrame controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("renderClearFrame controller %d not found", controllerId);
        return nullptr;
    }
    auto controller = renderMap[controllerId];
    ThreadCall(env, controllerId, [controller]() {
        controller->renderClearFrame();
    });
    return napiHandler.GetVoidValue();
}

static napi_value releaseTexture(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);

    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("releaseTexture controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("releaseTexture controller %d not found", controllerId);
        return nullptr;
    }
    if (renderMap[controllerId] == nullptr) {
        ELOGE("render controller is nullptr, %d", controllerId);
        return nullptr;
    }
    auto controller = renderMap[controllerId];

    ThreadCall(env, controllerId, [controller]() {
        controller->releaseTexture();
    });
    return napiHandler.GetVoidValue();
}

static napi_value destroyRender(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);

    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("destroyRender controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("destroyRender controller %d not found", controllerId);
        return nullptr;
    }
    renderMap.erase(controllerId);
    if (threadMap.find(controllerId) == threadMap.end()) {
        ELOGE("threadMap not found");
        return nullptr;
    }
    ELOGE("threadMap erase %d", controllerId);
    auto thread = threadMap[controllerId];
    threadMap.erase(controllerId);
    return napiHandler.GetVoidValue();
}

static napi_value mixConfigCreate(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    std::string json = napiHandler.ParseArgAs<std::string>(INDEX_1);

    int id = controllerId;

    shared_ptr<EvaAnimeConfig> config = EvaAnimeConfig::parse(json.c_str());
    std::shared_ptr<RenderController> controller = nullptr;

    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGV("mixConfigCreate controller not init");
        g_renderId += 1;
        id = g_renderId;
        controller = make_shared<RenderController>();
        renderMap.insert(make_pair(id, controller));
    } else if (renderMap.find(controllerId) != renderMap.end()) {
        controller = renderMap[controllerId];
    } else {
        ELOGE("mixConfigCreate controller %d not found", controllerId);
    }

    if (controller == nullptr) {
        return napiHandler.GetNapiValue<int32_t>(id);
    }
    ThreadCall(env, controllerId, [controller, config]() {
        controller->mixConfigCreate(config);
    });
    return napiHandler.GetNapiValue<int32_t>(id);
}

static napi_value setBgBitmap(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    YYEVAComponent::PixelMap bitmap;

    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("setBgBitmap controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("setBgBitmap controller %d not found", controllerId);
        return nullptr;
    }

    NAPI_CALL(env, napiHandler.ParseArgs(INDEX_1, [&](const napi_value &arg) -> napi_status {
        NativePixelMap *pixMap = OH_PixelMap_InitNativePixelMap(env, arg);
        bitmap.SetPixelMap(pixMap);
        return !bitmap.IsNull() ? napi_ok : napi_generic_failure;
    }));

    OH_NativeBuffer_Config nativeConfig;
    void *pixels = nullptr;
    bool ret = bitmap.Lock(&pixels, nativeConfig);
    if (ret == false) {
        ELOGE("Failed to access pixels");
        return nullptr;
    }

    renderMap[controllerId]->setBgImage(reinterpret_cast<unsigned char *>(pixels), &nativeConfig);
    bitmap.Unlock();

    return napiHandler.GetVoidValue();
}

static napi_value setSrcBitmap(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_4);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    YYEVAComponent::PixelMap bitmap;

    lock_guard<mutex> auto_lock(g_mtx);
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("setBgBitmap controller %d not found", controllerId);
        return nullptr;
    }
    std::string srcId = napiHandler.ParseArgAs<std::string>(INDEX_1);

    NAPI_CALL(env, napiHandler.ParseArgs(INDEX_2, [&](const napi_value &arg) -> napi_status {
        NativePixelMap *pixMap = OH_PixelMap_InitNativePixelMap(env, arg);
        bitmap.SetPixelMap(pixMap);
        return !bitmap.IsNull() ? napi_ok : napi_generic_failure;
    }));
    string scaleMode = napiHandler.ParseArgAs<std::string>(INDEX_3);

    OH_NativeBuffer_Config nativeConfig;
    void *pixels = nullptr;
    bool ret = bitmap.Lock(&pixels, nativeConfig);
    if (ret == false) {
        ELOGE("Failed to access pixels");
        return nullptr;
    }
    renderMap[controllerId]->setSrcBitmap(
        srcId.c_str(), reinterpret_cast<unsigned char *>(pixels), &nativeConfig, scaleMode);
    bitmap.Unlock();
    return napiHandler.GetVoidValue();
}

static napi_value setSrcTxt(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_3);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);

    lock_guard<mutex> auto_lock(g_mtx);
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("setSrcTxt controller %d not found", controllerId);
        return nullptr;
    }
    std::string srcId = napiHandler.ParseArgAs<std::string>(INDEX_1);
    std::string txt = napiHandler.ParseArgAs<std::string>(INDEX_2);

    renderMap[controllerId]->setSrcTxt(srcId.c_str(), txt.c_str());
    return napiHandler.GetVoidValue();
}

static napi_value mixRenderCreate(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);

    lock_guard<mutex> auto_lock(g_mtx);
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("mixRenderCreate controller %d not found", controllerId);
        return nullptr;
    }
    auto controller = renderMap[controllerId];

    ThreadCall(env, controllerId, [controller]() {
        controller->mixRenderCreate();
    });
    return napiHandler.GetVoidValue();
}

static napi_value mixRendering(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    int frameIndex = napiHandler.ParseArgAs<int>(INDEX_1);

    lock_guard<mutex> auto_lock(g_mtx);
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("mixRendering controller %d not found", controllerId);
        return nullptr;
    }
    auto controller = renderMap[controllerId];
    ThreadCall(env, controllerId, [controller, frameIndex]() {
        controller->mixRendering(frameIndex);
    });
    return napiHandler.GetVoidValue();
}

static napi_value mixRenderDestroy(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);

    lock_guard<mutex> auto_lock(g_mtx);
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("mixRenderDestroy controller %d not found", controllerId);
        return nullptr;
    }
    if (renderMap[controllerId] == nullptr) {
        ELOGE("render controller is nullptr, %d", controllerId);
        return nullptr;
    }
    auto controller = renderMap[controllerId];
    ThreadCall(env, controllerId, [controller]() {
        controller->mixRenderDestroy();
    });
    return napiHandler.GetVoidValue();
}

static napi_value setVideoRecord(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int32_t controllerId = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    bool isVideoRecord = napiHandler.ParseArgAs<bool>(INDEX_1);

    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("setVideoRecord controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("setVideoRecord controller %d not found", controllerId);
        return nullptr;
    }
    renderMap[controllerId]->setVideoRecord(isVideoRecord);
    return napiHandler.GetVoidValue();
}

static napi_value initVideoRecord(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int32_t controllerId = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    std::string surfaceId = napiHandler.ParseArgAs<std::string>(INDEX_1);

    lock_guard<mutex> auto_lock(g_mtx);
    OHNativeWindow *window = nullptr;
    uint64_t id = atoll(surfaceId.c_str());
    LOGD("Create Window, surfaceId: %s -> %llu", surfaceId.c_str(), id);
    OH_NativeWindow_CreateNativeWindowFromSurfaceId(id, &window);
    if (window == nullptr) {
        ELOGE("window is nullptr");
        return napiHandler.GetNapiValue<int32_t>(-1);
    }

    if (renderMap.find(controllerId) != renderMap.end()) {
        auto record = make_shared<RecorderController>();
        recordMap.insert(make_pair(controllerId, record));
        recordMap[controllerId]->init(
            renderMap[controllerId]->getEglContext(), window, renderMap[controllerId]->getRecordFramebufferId());
    } else {
        ELOGE("initVideoRecord controller %d not found", controllerId);
    }

    return napiHandler.GetNapiValue<int32_t>(-1);
}

static napi_value setRecordRenderConfig(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int32_t controllerId = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    std::string json = napiHandler.ParseArgAs<std::string>(INDEX_1);

    if (controllerId == -1) {
        ELOGE("setRecordRenderConfig controller not init");
        return nullptr;
    }
    if (recordMap.find(controllerId) == recordMap.end()) {
        ELOGE("setRecordRenderConfig controller %d not found", controllerId);
        return nullptr;
    }
    std::shared_ptr<EvaAnimeConfig> config = EvaAnimeConfig::parse(json.c_str());
    if (config != nullptr) {
        recordMap[controllerId]->setRenderConfig(config);
    }
    return napiHandler.GetVoidValue();
}

static napi_value recordRender(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int32_t controllerId = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    int64_t time = napiHandler.ParseArgAs<int64_t>(INDEX_1);

    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("recordRender controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("recordRender renderMap controller %d not found", controllerId);
        return nullptr;
    }
    if (recordMap.find(controllerId) == recordMap.end()) {
        ELOGE("recordRender recordRender controller %d not found", controllerId);
        return nullptr;
    }

    recordMap[controllerId]->renderFrame(
        renderMap[controllerId]->getRecordFramebufferId(), static_cast<uint64_t>(time));
    return nullptr;
}

static napi_value stopRecord(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    int32_t controllerId = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("stopRecord controller not init");
        return nullptr;
    }
    if (recordMap.find(controllerId) == recordMap.end()) {
        ELOGE("stopRecord controller %d not found", controllerId);
        return nullptr;
    }
    recordMap[controllerId]->destroy();
    return nullptr;
}

static napi_value setLog(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);
    napi_value elog = napiHandler.GetArg(INDEX_0);
    ELOGV("nativeSetListener");

    ELog::get()->setNapiVM(env);
    return nullptr;
}

static napi_value setBlendMode(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int32_t controllerId = napiHandler.ParseArgAs<int32_t>(INDEX_0);
    int32_t blendMode = napiHandler.ParseArgAs<int32_t>(INDEX_1);
    ELOGV("setBlendMode");
    lock_guard<mutex> auto_lock(g_mtx);
    if (controllerId == -1) {
        ELOGE("setBlendMode controller not init");
        return nullptr;
    }
    if (renderMap.find(controllerId) == renderMap.end()) {
        ELOGE("setBlendMode controller %d not found", controllerId);
        return nullptr;
    }
    renderMap[controllerId]->setBlendMode(blendMode);
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // YYEVAComponent::instance().initComponent(env, exports);
    napi_property_descriptor desc[] = {
        DECLARE_NAPI_FUNCTION("nativeProcessPixelMap", nativeProcessPixelMap),
        DECLARE_NAPI_FUNCTION("getExternalTexture", getExternalTexture),
        DECLARE_NAPI_FUNCTION("updateViewPoint", updateViewPoint),
        DECLARE_NAPI_FUNCTION("videoSizeChange", videoSizeChange),
        DECLARE_NAPI_FUNCTION("initRender", initRender),
        DECLARE_NAPI_FUNCTION("setRenderConfig", setRenderConfig),
        DECLARE_NAPI_FUNCTION("defaultConfig", defaultConfig),
        DECLARE_NAPI_FUNCTION("setSrcTxt", setSrcTxt),
        DECLARE_NAPI_FUNCTION("setBgBitmap", setBgBitmap),
        DECLARE_NAPI_FUNCTION("setSrcBitmap", setSrcBitmap),
        DECLARE_NAPI_FUNCTION("renderFrame", renderFrame),
        DECLARE_NAPI_FUNCTION("renderClearFrame", renderClearFrame),
        DECLARE_NAPI_FUNCTION("releaseTexture", releaseTexture),
        DECLARE_NAPI_FUNCTION("renderSwapBuffers", renderSwapBuffers),
        DECLARE_NAPI_FUNCTION("destroyRender", destroyRender),
        DECLARE_NAPI_FUNCTION("mixConfigCreate", mixConfigCreate),
        DECLARE_NAPI_FUNCTION("mixRenderCreate", mixRenderCreate),
        DECLARE_NAPI_FUNCTION("mixRendering", mixRendering),
        DECLARE_NAPI_FUNCTION("mixRenderDestroy", mixRenderDestroy),
        DECLARE_NAPI_FUNCTION("setVideoRecord", setVideoRecord),
        DECLARE_NAPI_FUNCTION("initVideoRecord", initVideoRecord),
        DECLARE_NAPI_FUNCTION("setRecordRenderConfig", setRecordRenderConfig),
        DECLARE_NAPI_FUNCTION("recordRender", recordRender),
        DECLARE_NAPI_FUNCTION("stopRecord", stopRecord),
        DECLARE_NAPI_FUNCTION("setLog", setLog),
        DECLARE_NAPI_FUNCTION("setBlendMode", setBlendMode),
        DECLARE_NAPI_FUNCTION("getRenderThread", getRenderThread),
    };
    NAPI_CALL(env, napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc));

    InitThreadTask(env, exports);
    return exports;
}
EXTERN_C_END

static napi_module yyevaModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "yyeva_napi",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterModule(void)
{
    napi_module_register(&yyevaModule);
}