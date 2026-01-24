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
/******************************************************************************
 * Spine Harmony Runtime - NAPI 接口实现
 * 提供 ArkTS 调用 Native 的桥接
 *****************************************************************************/

#include <napi/native_api.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <rawfile/raw_file_manager.h>
#include <EGL/egl.h>
#include <hilog/log.h>
#include <unordered_map>
#include <string>
#include <chrono>

#include "spine_harmony.h"

#define LOG_TAG "SpineNapi"
#define LOGI(...) OH_LOG_INFO(LOG_APP, __VA_ARGS__)
#define LOGE(...) OH_LOG_ERROR(LOG_APP, __VA_ARGS__)

// ============================================================================
// 全局状态
// ============================================================================

static std::unordered_map<std::string, SpineContext*> g_contexts;
static std::unordered_map<std::string, OH_NativeXComponent*> g_xcomponents;  // 存储 XComponent 引用
static std::unordered_map<std::string, void*> g_windows;  // 存储 window 引用
static std::chrono::steady_clock::time_point g_lastTime;
static bool g_initialized = false;

// ============================================================================
// XComponent 回调
// ============================================================================

static void OnSurfaceCreatedCB(OH_NativeXComponent* component, void* window) {
    LOGI("OnSurfaceCreated");
    
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {0};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        LOGE("Failed to get XComponent ID");
        return;
    }
    LOGI("OnSurfaceCreated for XComponent: %s", idStr);
    // 保存 XComponent 和 window 引用，供后续延迟创建 context 使用
    g_xcomponents[idStr] = component;
    g_windows[idStr] = window;
    uint64_t width;
    uint64_t height;
    OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    // 立即创建 context
    SpineContext* ctx = SpineContextCreate(window, static_cast<int>(width), static_cast<int>(height));
    if (ctx) {
        g_contexts[idStr] = ctx;
        LOGI("Context created for XComponent: %s, size: %llu x %llu", idStr, width, height);
    } else {
        LOGE("Failed to create context for XComponent: %s", idStr);
    }
    g_lastTime = std::chrono::steady_clock::now();
}

static void OnSurfaceChangedCB(OH_NativeXComponent* component, void* window) {
    LOGI("OnSurfaceChanged");
    
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {0};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    auto it = g_contexts.find(idStr);
    if (it != g_contexts.end()) {
        uint64_t height;
        uint64_t width;
        OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
        SpineContextResize(it->second, (int)width, (int)height);
    }
}

static void OnSurfaceDestroyedCB(OH_NativeXComponent* component, void* window) {
    LOGI("OnSurfaceDestroyed");
    
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {0};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    auto it = g_contexts.find(idStr);
    if (it != g_contexts.end()) {
        SpineContextDispose(it->second);
        g_contexts.erase(it);
        LOGI("Context destroyed for XComponent: %s", idStr);
    }
    // 清理保存的引用
    g_xcomponents.erase(idStr);
    g_windows.erase(idStr);
}

static void DispatchTouchEventCB(OH_NativeXComponent* component, void* window) {
    // 可以在这里处理触摸事件
}

// ============================================================================
// NAPI 函数
// ============================================================================

// 初始化资源管理器
static napi_value InitResourceManager(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    if (argc < 1) {
        LOGE("InitResourceManager: missing argument");
        return nullptr;
    }
    NativeResourceManager* resMgr = OH_ResourceManager_InitNativeResourceManager(env, args[0]);
    SpineSetResourceManager(resMgr);
    LOGI("Resource manager initialized");
    napi_value result;
    napi_get_boolean(env, true, &result);
    return result;
}

// 注册 XComponent 回调
static napi_value RegisterXComponent(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    if (argc < 1) {
        LOGE("RegisterXComponent: missing argument");
        return nullptr;
    }
    // 获取 XComponent ID
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {0};
    size_t idSize = 0;
    napi_get_value_string_utf8(env, args[0], idStr, OH_XCOMPONENT_ID_LEN_MAX, &idSize);
    
    LOGI("Registering XComponent: %s", idStr);
    // 注册回调 - 需要在 XComponent 初始化后调用
    // 实际的回调注册在 Export 中完成
    napi_value result;
    napi_get_boolean(env, true, &result);
    return result;
}

// 1. 验证参数数量
static napi_value ValidateArgumentCount(napi_env env, size_t argc, int required) {
    if (argc < required) {
        napi_value result;
        napi_get_boolean(env, false, &result);
        return result;
    }
    return nullptr;  // 返回nullptr表示验证通过
}

// 2. 解析字符串参数
static bool ParseStringArg(napi_env env, napi_value arg, char* buffer, size_t bufferSize) {
    size_t len;
    napi_status status = napi_get_value_string_utf8(env, arg, buffer, bufferSize, &len);
    return status == napi_ok;
}

// 3. 解析数值参数
static bool ParseDoubleArg(napi_env env, napi_value arg, double* value) {
    napi_status status = napi_get_value_double(env, arg, value);
    return status == napi_ok;
}

// 定义参数结构体
typedef struct {
    char xcompId[256];
    char instanceName[256];
    char atlasPath[512];
    char skeletonPath[512];
    double scale;
} SpineCreateArgs;

// 4. 解析所有参数
static bool ParseAllArgs(napi_env env, const napi_value args[5], SpineCreateArgs* createArgs) {
    int index256 = 256;
    int index512 = 512;
    int index0 = 0;
    int index1 = 1;
    int index2 = 2;
    int index3 = 3;
    int index4 = 4;
    // 解析 xcompId
    if (!ParseStringArg(env, args[index0], createArgs->xcompId, index256)) {
        return false;
    }
    // 解析 instanceName
    if (!ParseStringArg(env, args[index1], createArgs->instanceName, index256)) {
        return false;
    }
    // 解析 atlasPath
    if (!ParseStringArg(env, args[index2], createArgs->atlasPath, index512)) {
        return false;
    }
    // 解析 skeletonPath
    if (!ParseStringArg(env, args[index3], createArgs->skeletonPath, index512)) {
        return false;
    }
    // 解析 scale
    return ParseDoubleArg(env, args[index4], &createArgs->scale);
}

// 5. 创建新的Spine上下文
static SpineContext* CreateNewContext(const char* xcompId) {
    auto winIt = g_windows.find(xcompId);
    auto xcompIt = g_xcomponents.find(xcompId);
    if (winIt == g_windows.end() || xcompIt == g_xcomponents.end()) {
        return nullptr;
    }
    void* window = winIt->second;
    OH_NativeXComponent* component = xcompIt->second;
    uint64_t width;
    uint64_t height;
    OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    return SpineContextCreate(window, static_cast<int>(width), static_cast<int>(height));
}

// 6. 查找或创建上下文
static SpineContext* GetOrCreateContext(const char* xcompId) {
    auto it = g_contexts.find(xcompId);
    if (it != g_contexts.end()) {
        return it->second;
    }
    
    SpineContext* ctx = CreateNewContext(xcompId);
    if (!ctx) {
        return nullptr;
    }
    
    g_contexts[xcompId] = ctx;
    return ctx;
}

// 7. 设置EGL上下文
static void SetEglContext(SpineContext* ctx) {
    if (ctx->display != EGL_NO_DISPLAY && ctx->context != EGL_NO_CONTEXT) {
        eglMakeCurrent(ctx->display, ctx->surface, ctx->surface, ctx->context);
    }
}

// 8. 加载Spine骨架
static bool LoadSpineInstance(const char* atlasPath, const char* skeletonPath,
                              float scale, const char* instanceName, SpineContext* ctx) {
    SpineInstance* instance = SpineInstanceCreate(atlasPath, skeletonPath, scale);
    if (!instance) {
        return false;
    }
    
    SpineContextAddInstance(ctx, instanceName, instance);
    return true;
}

// 9. 记录上下文信息（调试用）
static void LogContexts() {
    for (auto& pair : g_contexts) {
        LOGI("  Context: %s -> %p", pair.first.c_str(), pair.second);
    }
}

// 10. 创建返回结果
static napi_value CreateBooleanResult(napi_env env, bool value) {
    napi_value result;
    napi_get_boolean(env, value, &result);
    return result;
}

// 11. 主函数 - LoadSkeleton
static napi_value LoadSkeleton(napi_env env, napi_callback_info info) {
    const int requiredArgs = 5;
    size_t argc = requiredArgs;
    napi_value args[requiredArgs];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_value validationResult = ValidateArgumentCount(env, argc, requiredArgs);
    if (validationResult != nullptr) {
        return validationResult;
    }
    SpineCreateArgs createArgs = {0};  // 初始化结构体
    createArgs.scale = 1.0;  // 设置默认缩放值
    // 使用结构体解析参数
    if (!ParseAllArgs(env, args, &createArgs)) {
        return CreateBooleanResult(env, false);
    }
    LogContexts();
    // 获取或创建上下文
    SpineContext* ctx = GetOrCreateContext(createArgs.xcompId);
    if (!ctx) {
        return CreateBooleanResult(env, false);
    }
    SetEglContext(ctx);
    // 加载Spine实例
    bool success = LoadSpineInstance(createArgs.atlasPath, createArgs.skeletonPath,
        static_cast<float>(createArgs.scale), createArgs.instanceName, ctx);
    return CreateBooleanResult(env, success);
}

// 设置动画
static napi_value SetAnimation(napi_env env, napi_callback_info info) {
    size_t argc = 5;
    napi_value args[5];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int argcnumber = 5;
    if (argc < argcnumber) {
        napi_value result;
        napi_get_boolean(env, false, &result);
        return result;
    }
    // 参数: xcomponentId, instanceName, trackIndex, animationName, loop
    char xcompId[256] = {0};
    char instanceName[256] = {0};
    char animationName[256] = {0};
    int32_t trackIndex = 0;
    bool loop = true;
    size_t len;
    napi_get_value_string_utf8(env, args[0], xcompId, sizeof(xcompId), &len);
    napi_get_value_string_utf8(env, args[1], instanceName, sizeof(instanceName), &len);
    int args2 = 2;
    int args3 = 3;
    int args4 = 4;
    napi_get_value_int32(env, args[args2], &trackIndex);
    napi_get_value_string_utf8(env, args[args3], animationName, sizeof(animationName), &len);
    napi_get_value_bool(env, args[args4], &loop);
    
    auto it = g_contexts.find(xcompId);
    if (it == g_contexts.end()) {
        napi_value result;
        napi_get_boolean(env, false, &result);
        return result;
    }
    SpineInstance* instance = SpineContextGetInstance(it->second, instanceName);
    if (!instance) {
        LOGE("Instance not found: %s", instanceName);
        napi_value result;
        napi_get_boolean(env, false, &result);
        return result;
    }
    SpineInstanceSetAnimation(instance, trackIndex, animationName, loop ? 1 : 0);
    napi_value result;
    napi_get_boolean(env, true, &result);
    return result;
}

// 设置位置
static napi_value SetPosition(napi_env env, napi_callback_info info) {
    size_t argc = 4;
    napi_value args[4];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int argcnumber = 4;
    if (argc < argcnumber) {
        return nullptr;
    }
    char xcompId[256] = {0};
    char instanceName[256] = {0};
    double x = 0;
    double y = 0;
    size_t len;
    napi_get_value_string_utf8(env, args[0], xcompId, sizeof(xcompId), &len);
    napi_get_value_string_utf8(env, args[1], instanceName, sizeof(instanceName), &len);
    int args3 = 3;
    int args2 = 2;
    napi_get_value_double(env, args[args2], &x);
    napi_get_value_double(env, args[args3], &y);
    auto it = g_contexts.find(xcompId);
    if (it == g_contexts.end()) { return nullptr; }
    
    SpineInstance* instance = SpineContextGetInstance(it->second, instanceName);
    if (instance) {
        SpineInstanceSetPosition(instance, static_cast<float>(x), static_cast<float>(y));
    }
    return nullptr;
}

// 设置缩放
static napi_value SetScale(napi_env env, napi_callback_info info) {
    size_t argc = 4;
    napi_value args[4];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int argcnumber = 4;
    if (argc < argcnumber) {
        return nullptr;
    }
    char xcompId[256] = {0};
    char instanceName[256] = {0};
    double scaleX = 1;
    double scaleY = 1;
    size_t len;
    napi_get_value_string_utf8(env, args[0], xcompId, sizeof(xcompId), &len);
    napi_get_value_string_utf8(env, args[1], instanceName, sizeof(instanceName), &len);
    int args2 = 2;
    int args3 = 3;
    napi_get_value_double(env, args[args2], &scaleX);
    napi_get_value_double(env, args[args3], &scaleY);
    auto it = g_contexts.find(xcompId);
    if (it == g_contexts.end()) { return nullptr; }
    SpineInstance* instance = SpineContextGetInstance(it->second, instanceName);
    if (instance) {
        SpineInstanceSetScale(instance, static_cast<float>(scaleX), static_cast<float>(scaleY));
    }
    return nullptr;
}

// 渲染一帧
static napi_value RenderFrame(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    char xcompId[256] = {0};
    if (argc >= 1) {
        size_t len;
        napi_get_value_string_utf8(env, args[0], xcompId, sizeof(xcompId), &len);
    }
    // 计算 delta time
    auto now = std::chrono::steady_clock::now();
    float deltaTime = std::chrono::duration<float>(now - g_lastTime).count();
    g_lastTime = now;
    // 限制 delta time
    if (deltaTime > 0.1f) { deltaTime = 0.1f; }
    if (strlen(xcompId) > 0) {
        // 渲染指定 XComponent
        auto it = g_contexts.find(xcompId);
        if (it != g_contexts.end()) {
            SpineContextRender(it->second, deltaTime);
        }
    } else {
        // 渲染所有
        for (auto& pair : g_contexts) {
            SpineContextRender(pair.second, deltaTime);
        }
    }
    return nullptr;
}

// 获取动画列表
static napi_value GetAnimations(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int argcnumber = 2;
    if (argc < argcnumber) {
        napi_value result;
        napi_create_array(env, &result);
        return result;
    }
    
    char xcompId[256] = {0};
    char instanceName[256] = {0};
    size_t len;
    napi_get_value_string_utf8(env, args[0], xcompId, sizeof(xcompId), &len);
    napi_get_value_string_utf8(env, args[1], instanceName, sizeof(instanceName), &len);
    
    napi_value result;
    napi_create_array(env, &result);
    
    auto it = g_contexts.find(xcompId);
    if (it == g_contexts.end()) { return result; }
    
    SpineInstance* instance = SpineContextGetInstance(it->second, instanceName);
    if (!instance || !instance->skeletonData) return result;
    
    for (int i = 0; i < instance->skeletonData->animationsCount; i++) {
        spAnimation* anim = instance->skeletonData->animations[i];
        napi_value name;
        napi_create_string_utf8(env, anim->name, NAPI_AUTO_LENGTH, &name);
        napi_set_element(env, result, i, name);
    }
    return result;
}

// 移除实例
static napi_value RemoveInstance(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int argcnumber = 2;
    if (argc < argcnumber) {
        return nullptr;
    }
    
    char xcompId[256] = {0};
    char instanceName[256] = {0};
    size_t len;
    napi_get_value_string_utf8(env, args[0], xcompId, sizeof(xcompId), &len);
    napi_get_value_string_utf8(env, args[1], instanceName, sizeof(instanceName), &len);
    
    auto it = g_contexts.find(xcompId);
    if (it != g_contexts.end()) {
        SpineContextRemoveInstance(it->second, instanceName);
    }
    return nullptr;
}

// 设置皮肤
static napi_value SetSkin(napi_env env, napi_callback_info info) {
    size_t argc = 3;
    napi_value args[3];
    const int maxXcompLength = 256;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    const size_t minArgCount = 3;
    if (argc < minArgCount) {
        napi_value result;
        napi_get_boolean(env, false, &result);
        return result;
    }
    
    char xcompId[maxXcompLength] = {0};
    char instanceName[maxXcompLength] = {0};
    char skinName[maxXcompLength] = {0};
    size_t len;
    const size_t xcompIdSize = sizeof(xcompId);
    const size_t instanceNameSize = sizeof(instanceName);
    const size_t skinNameSize = sizeof(skinName);
    const int argXcompIdIndex = 0;
    const int argInstanceNameIndex = 1;
    const int argSkinNameIndex = 2;
    
    napi_get_value_string_utf8(env, args[argXcompIdIndex], xcompId, xcompIdSize, &len);
    napi_get_value_string_utf8(env, args[argInstanceNameIndex], instanceName, instanceNameSize, &len);
    napi_get_value_string_utf8(env, args[argSkinNameIndex], skinName, skinNameSize, &len);
    
    auto it = g_contexts.find(xcompId);
    if (it == g_contexts.end()) {
        napi_value result;
        napi_get_boolean(env, false, &result);
        return result;
    }
    
    SpineInstance* instance = SpineContextGetInstance(it->second, instanceName);
    if (!instance) {
        LOGE("SetSkin: Instance not found: %s", instanceName);
        napi_value result;
        napi_get_boolean(env, false, &result);
        return result;
    }
    
    int success = SpineInstanceSetSkinByName(instance, skinName);
    
    napi_value result;
    napi_get_boolean(env, success != 0, &result);
    return result;
}

// 获取皮肤列表
static napi_value GetSkins(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    napi_value result;
    napi_create_array(env, &result);
    
    const size_t minArgc = 2;
    if (argc < minArgc) {
        return result;
    }
    
    char xcompId[256] = {0};
    char instanceName[256] = {0};
    size_t len;
    
    napi_get_value_string_utf8(env, args[0], xcompId, sizeof(xcompId), &len);
    napi_get_value_string_utf8(env, args[1], instanceName, sizeof(instanceName), &len);
    
    auto it = g_contexts.find(xcompId);
    if (it == g_contexts.end()) {
        return result;
    }
    
    SpineInstance* instance = SpineContextGetInstance(it->second, instanceName);
    if (!instance) {
        return result;
    }
    
    int skinCount = SpineInstanceGetSkinCount(instance);
    for (int i = 0; i < skinCount; i++) {
        const char* skinName = SpineInstanceGetSkinName(instance, i);
        if (skinName) {
            napi_value name;
            napi_create_string_utf8(env, skinName, NAPI_AUTO_LENGTH, &name);
            napi_set_element(env, result, i, name);
        }
    }
    
    return result;
}

// ============================================================================
// XComponent 导出
// ============================================================================

static OH_NativeXComponent_Callback g_callback = {
    .OnSurfaceCreated = OnSurfaceCreatedCB,
    .OnSurfaceChanged = OnSurfaceChangedCB,
    .OnSurfaceDestroyed = OnSurfaceDestroyedCB,
    .DispatchTouchEvent = DispatchTouchEventCB,
};

static napi_value Export(napi_env env, napi_value exports) {
    // 注册 XComponent 回调
    napi_value exportInstance = nullptr;
    if (napi_get_named_property(env, exports, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) == napi_ok) {
        OH_NativeXComponent* nativeXComponent = nullptr;
        if (napi_unwrap(env, exportInstance, reinterpret_cast<void**>(&nativeXComponent)) == napi_ok) {
            OH_NativeXComponent_RegisterCallback(nativeXComponent, &g_callback);
            LOGI("XComponent callback registered");
        }
    }
    
    // 注册 NAPI 函数
    napi_property_descriptor desc[] = {
        {"initResourceManager", nullptr, InitResourceManager, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registerXComponent", nullptr, RegisterXComponent, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"loadSkeleton", nullptr, LoadSkeleton, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setAnimation", nullptr, SetAnimation, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPosition", nullptr, SetPosition, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setScale", nullptr, SetScale, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"renderFrame", nullptr, RenderFrame, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getAnimations", nullptr, GetAnimations, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"removeInstance", nullptr, RemoveInstance, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSkin", nullptr, SetSkin, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSkins", nullptr, GetSkins, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    
    int argDescIndex = 0;
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[argDescIndex]), desc);
    
    LOGI("Spine NAPI module exported");
    return exports;
}

// ============================================================================
// 模块注册
// ============================================================================

static napi_module spineModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Export,
    .nm_modname = "spine",
    .nm_priv = nullptr,
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterSpineModule(void) {
    napi_module_register(&spineModule);
}
