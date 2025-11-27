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

#define LOG_TAG    "YYEVANAPI"
#define ELOGE(...) OhosLogPrint(IL_ERROR, LOG_TAG, __VA_ARGS__)
#define ELOGD(...) OhosLogPrint(IL_DEBUG, LOG_TAG, __VA_ARGS__)
#define ELOGV(...) OhosLogPrint(IL_INFO, LOG_TAG, __VA_ARGS__)

using namespace std;
using namespace yyeva;
map<int, std::shared_ptr<RenderController>> renderMap;
map<int, std::shared_ptr<RecorderController>> recordMap;
int g_renderId = 0;
mutex g_mtx;

static napi_value nativeProcessPixelMap(napi_env env, napi_callback_info info)
{
    YYEVAComponent::PixelMap nativePixelMap;
    NapiHandler napiHandler(env, info, PARAM_COUNT_1);

    NAPI_CALL(env, napiHandler.ParseArgs(INDEX_0, [&](const napi_value &arg) -> napi_status {
        OH_PixelmapNative *pixMap;
        OH_PixelmapNative_ConvertPixelmapNativeFromNapi(env, arg, &pixMap);
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
    int width = napiHandler.ParseArgAs<int>(INDEX_1);
    int height = napiHandler.ParseArgAs<int>(INDEX_2);

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
    OHNativeWindow *window = nullptr;
    bool isNeedYUV = napiHandler.ParseArgAs<bool>(INDEX_2);
    bool isNormalMp4 = napiHandler.ParseArgAs<bool>(INDEX_3);
    bool isVideoRecord = napiHandler.ParseArgAs<bool>(INDEX_4);

    lock_guard<mutex> auto_lock(g_mtx);
    window = (OHNativeWindow *)YYEVAComponent::Instance().CreateWindowBySurfaceId(surfaceId);
    int id = controllerId;
    if (controllerId == -1) {
        g_renderId += 1;
        id = g_renderId;
        auto *controller = new RenderController();
        controller->initRender(window, isNeedYUV, isNormalMp4);
        renderMap.insert(make_pair(id, controller));
        controller->setVideoRecord(isVideoRecord);
    } else if (renderMap.find(controllerId) != renderMap.end()) {
        if (renderMap[controllerId]->getExternalTexture() == -1) { // 防止重复初始化
            renderMap[controllerId]->initRender(window, isNeedYUV, isNormalMp4);
            renderMap[controllerId]->setVideoRecord(isVideoRecord);
        } else {
            ELOGE("initRender init repeat");
        }
    } else {
        ELOGE("initRender controller %d not found", controllerId);
    }
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
    renderMap[controllerId]->renderFrame();
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
    renderMap[controllerId]->renderSwapBuffers();
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
    renderMap[controllerId]->renderClearFrame();
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
    renderMap[controllerId]->releaseTexture();
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
    return napiHandler.GetVoidValue();
}

static napi_value mixConfigCreate(napi_env env, napi_callback_info info)
{
    NapiHandler napiHandler(env, info, PARAM_COUNT_2);
    int controllerId = napiHandler.ParseArgAs<int>(INDEX_0);
    std::string json = napiHandler.ParseArgAs<std::string>(INDEX_1);

    shared_ptr<EvaAnimeConfig> config = EvaAnimeConfig::parse(json.c_str());

    lock_guard<mutex> auto_lock(g_mtx);
    int id = controllerId;
    if (controllerId == -1) {
        ELOGV("mixConfigCreate controller not init");
        g_renderId += 1;
        id = g_renderId;
        auto controller = make_shared<RenderController>();
        renderMap.insert(make_pair(id, controller));
        renderMap[id]->mixConfigCreate(config);
    } else if (renderMap.find(controllerId) != renderMap.end()) {
        renderMap[controllerId]->mixConfigCreate(config);
    } else {
        ELOGE("mixConfigCreate controller %d not found", controllerId);
    }
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
        OH_PixelmapNative *pixMap;
        OH_PixelmapNative_ConvertPixelmapNativeFromNapi(env, arg, &pixMap);
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
        OH_PixelmapNative *pixMap;
        OH_PixelmapNative_ConvertPixelmapNativeFromNapi(env, arg, &pixMap);
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
    renderMap[controllerId]->mixRenderCreate();
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
    renderMap[controllerId]->mixRendering(frameIndex);
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
    renderMap[controllerId]->mixRenderDestroy();
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
    ANativeWindow *window = (OHNativeWindow *)YYEVAComponent::Instance().CreateWindowBySurfaceId(surfaceId);
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
    };
    NAPI_CALL(env, napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc));
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