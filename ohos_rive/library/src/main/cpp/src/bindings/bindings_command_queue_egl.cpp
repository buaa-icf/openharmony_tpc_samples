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

#include "bindings/bindings_command_queue_egl.h"
#include "helpers/general.h"
#include "models/renderer.h"
#include "rive/renderer/gl/render_buffer_gl_impl.hpp"
#include "rive/renderer/gl/render_context_gl_impl.hpp"
#include "rive/renderer/gl/render_target_gl.hpp"
#include "rive/renderer/rive_render_image.hpp"
#include <cstdint>
#include <EGL/egl.h>

#include <future>
#include <iomanip>
#include <js_native_api.h>
#include <sstream>
#include <string>

constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;

namespace ohos_rive {

/** Convert a JVM long handle to a typed C++ handle */
template <typename HandleT>
static HandleT handleFromLong(uint64_t handle)
{
    return reinterpret_cast<HandleT>(static_cast<uint64_t>(handle));
}

/** Convert a typed C++ handle to a JVM long handle */
template <typename HandleT>
static uint64_t longFromHandle(HandleT handle)
{
    return static_cast<uint64_t>(reinterpret_cast<uint64_t>(handle));
}

EGLSurface createPBufferSurface(EGLDisplay eglDisplay, EGLContext eglContext)
{
    EGLint configID = 0;
    eglQueryContext(eglDisplay, eglContext, EGL_CONFIG_ID, &configID);

    EGLConfig config;
    EGLint configCount = 0;
    EGLint configAttributes[] = {EGL_CONFIG_ID, configID, EGL_NONE};
    eglChooseConfig(eglDisplay, configAttributes, &config, 1, &configCount);

    // We expect only one config.
    if (configCount == 1) {
        EGLint pBufferAttributes[] = {EGL_WIDTH, 1, EGL_HEIGHT, 1, EGL_NONE};
        return eglCreatePbufferSurface(eglDisplay, config, pBufferAttributes);
    } else {
        LOGE("Failed to choose EGL config for PBuffer surface");
        return EGL_NO_SURFACE;
    }
}

napi_value CommandQueueGetEglDisplay(napi_env env, napi_callback_info info)
{
    EGLDisplay display;
    EGLint majorVersion;
    EGLint minorVersion;
    display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    eglInitialize(display, &majorVersion, &minorVersion);

    auto displayPtr = reinterpret_cast<int64_t>(display);
    napi_value result;
    auto status = napi_create_bigint_uint64(env, displayPtr, &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for EGLDisplay");
        return nullptr;
    }
    return result;
}

napi_value CommandQueueCreateEglContext(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments in CommandQueueCreateEglContext");
        return nullptr;
    }
    uint64_t display = 0;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &display, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get EGLDisplay from bigint");
        return nullptr;
    }

    auto eglDisplay = reinterpret_cast<EGLDisplay>(display);
    EGLConfig config;
    EGLContext context;
    EGLint attribs[] = {
        EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT, EGL_BLUE_SIZE, 8, EGL_GREEN_SIZE, 8, EGL_RED_SIZE, 8, EGL_NONE};
    EGLint numConfigs = 0;
    eglChooseConfig(eglDisplay, attribs, &config, 1, &numConfigs);
    context = eglCreateContext(eglDisplay, config, EGL_NO_CONTEXT, NULL);

    auto contextPtr = reinterpret_cast<uint64_t>(context);
    napi_value result;
    status = napi_create_bigint_uint64(env, contextPtr, &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for EGLContext");
        return nullptr;
    }
    return result;
}

napi_value CommandQueueDeleteEglContext(napi_env env, napi_callback_info info)
{
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueDeleteEglContext");
        return undefined;
    }
    uint64_t display = 0;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &display, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get EGLDisplay from bigint");
        return undefined;
    }
    uint64_t context = 0;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &context, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get EGLContext from bigint");
        return undefined;
    }

    auto eglDisplay = reinterpret_cast<EGLDisplay>(display);
    auto eglContext = reinterpret_cast<EGLContext>(context);
    eglDestroyContext(eglDisplay, eglContext);
    return undefined;
}

napi_value CommandQueueCreateEglSurface(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueCreateEglSurface");
        return nullptr;
    }
    uint64_t display = 0;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &display, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get EGLDisplay from bigint");
        return nullptr;
    }
    uint64_t context = 0;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &context, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get EGLContext from bigint");
        return nullptr;
    }

    auto eglDisplay = reinterpret_cast<EGLDisplay>(display);
    auto eglContext = reinterpret_cast<EGLContext>(context);

    EGLSurface surface = createPBufferSurface(eglDisplay, eglContext);

    napi_value result;
    status = napi_create_bigint_uint64(env, longFromHandle(surface), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint for EGLSurface");
        return nullptr;
    }
    return result;
}

struct StartupResult {
    bool success;
    EGLint eglError;
    std::string message;
};

static bool ParseCommandQueueArgs(napi_env env, napi_value args[], uint64_t &display, uint64_t &context)
{
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &display, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get EGLDisplay from bigint");
        return false;
    }

    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &context, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get EGLContext from bigint");
        return false;
    }

    return true;
}

static void RunCommandServerThread(EGLDisplay eglDisplay,
                                   EGLContext eglContext,
                                   rive::rcp<rive::CommandQueue> commandQueue,
                                   std::promise<StartupResult> promise)
{
    auto pBuffer = createPBufferSurface(eglDisplay, eglContext);
    if (pBuffer == EGL_NO_SURFACE) {
        auto error = eglGetError();
        LOGE("Failed to create PBuffer surface. Error: (0x%{punlic}04x)", error);
        promise.set_value({false, error, "Failed to create PBuffer surface"});
        return;
    }

    auto contextCurrentSuccess = eglMakeCurrent(eglDisplay, pBuffer, pBuffer, eglContext);
    if (!contextCurrentSuccess) {
        auto error = eglGetError();
        LOGE("Failed to make EGL context current. Error: (0x%{punlic}04x)", error);
        promise.set_value({false, error, "Failed to make EGL context current"});
        eglDestroySurface(eglDisplay, pBuffer);
        return;
    }

    auto riveContext = rive::gpu::RenderContextGLImpl::MakeContext();
    if (!riveContext) {
        auto error = eglGetError();
        LOGE("Failed to create Rive RenderContextGL. Error: (0x%{punlic}04x)", error);
        promise.set_value({false, error, "Failed to create Rive RenderContextGL"});
        eglDestroySurface(eglDisplay, pBuffer);
        return;
    }

    auto commandServer = std::make_unique<rive::CommandServer>(commandQueue, riveContext.get());
    // Signal success and unblock the main thread
    promise.set_value({true, EGL_SUCCESS, "Command Server started successfully"});

    // Begin the serving loop. This will "block" the thread until the
    // server receives the disconnect command.
    commandServer->serveUntilDisconnect();
    // Matching unref from constructor since we release()'d.
    // Ensures the command queue outlives the command server's run.
    commandQueue->unref();

    // Cleanup the EGL context and surface
    eglMakeCurrent(eglDisplay, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    eglDestroySurface(eglDisplay, pBuffer);
}

napi_value CommandQueueConstructor(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueConstructor");
        return nullptr;
    }

    uint64_t display = 0;
    uint64_t context = 0;
    if (!ParseCommandQueueArgs(env, args, display, context)) {
        return nullptr;
    }

    auto eglDisplay = reinterpret_cast<EGLDisplay>(display);
    auto eglContext = reinterpret_cast<EGLContext>(context);

    auto commandQueue = rive::rcp<rive::CommandQueue>(new rive::CommandQueue());

    // Used by the CommandServer thread to signal startup success or failure
    std::promise<StartupResult> promise;
    // Blocks the main thread until the CommandServer is ready
    std::future<StartupResult> f = promise.get_future();

    // Setup the C++ thread that drives the CommandServer
    std::thread(RunCommandServerThread, eglDisplay, eglContext, commandQueue, std::move(promise)).detach();

    // Wait for the command server to start and return the result
    auto result = f.get();
    if (!result.success) {
        std::ostringstream oss;
        oss << "CommandQueue startup failed (EGL 0x" << std::hex << std::setw(ARG_NUM_FOUR) << std::setfill('0')
            << result.eglError << "): " << result.message;
        LOGE("%{public}s", oss.str().c_str());
        return nullptr;
    }

    napi_value resultValue;
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(commandQueue.release()), &resultValue);
    return resultValue;
}

napi_value CommandQueueDelete(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments in CommandQueueDelete");
        return nullptr;
    }

    uint64_t ref = 0;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (ref == 0) {
        LOGE("Invalid CommandQueue pointer (0)");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    commandQueue->disconnect();

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueLoadFile(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueLoadFile");
        return nullptr;
    }

    uint64_t ref = 0;
    bool lossless = false;
    auto status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (ref == 0) {
        LOGE("Invalid CommandQueue pointer (0)");
        return nullptr;
    }

    int64_t requestID = 0;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);

    void *arrayBufferData;
    size_t arrayBufferLength;
    napi_get_arraybuffer_info(env, args[ARG_NUM_TWO], &arrayBufferData, &arrayBufferLength);

    std::vector<uint8_t> byteVec(static_cast<uint8_t *>(arrayBufferData),
                                 static_cast<uint8_t *>(arrayBufferData) + arrayBufferLength);

    auto fileHandle = commandQueue->loadFile(byteVec, nullptr, requestID);
    auto fileHandlePtr = reinterpret_cast<uint64_t>(fileHandle);
    napi_value result;
    napi_create_bigint_uint64(env, fileHandlePtr, &result);
    return result;
}

napi_value CommandQueueDeleteFile(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueDeleteFile");
        return nullptr;
    }

    uint64_t ref;
    uint64_t fileHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &fileHandle, &lossless) != napi_ok || !lossless ||
        fileHandle == 0) {
        LOGE("Failed to get fileHandle from bigint");
        return nullptr;
    }
    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    commandQueue->deleteFile(handleFromLong<rive::FileHandle>(fileHandle), requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetArtboardNames(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueGetArtboardNames");
        return nullptr;
    }

    uint64_t ref;
    uint64_t fileHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &fileHandle, &lossless) != napi_ok || !lossless ||
        fileHandle == 0) {
        LOGE("Failed to get fileHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::FileHandle>(fileHandle);
    commandQueue->requestArtboardNames(handle, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetStateMachineNames(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueGetStateMachineNames");
        return nullptr;
    }

    uint64_t ref;
    uint64_t artboardHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &artboardHandle, &lossless) != napi_ok || !lossless ||
        artboardHandle == 0) {
        LOGE("Failed to get artboardHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::ArtboardHandle>(artboardHandle);
    commandQueue->requestStateMachineNames(handle, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetViewModelNames(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueGetViewModelNames");
        return nullptr;
    }

    uint64_t ref;
    uint64_t fileHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &fileHandle, &lossless) != napi_ok || !lossless ||
        fileHandle == 0) {
        LOGE("Failed to get fileHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::FileHandle>(fileHandle);
    commandQueue->requestViewModelNames(handle, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetViewModelInstanceNames(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueGetViewModelInstanceNames");
        return nullptr;
    }

    uint64_t ref;
    uint64_t fileHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &fileHandle, &lossless) != napi_ok || !lossless ||
        fileHandle == 0) {
        LOGE("Failed to get fileHandle from bigint");
        return nullptr;
    }

    size_t viewModelNameLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &viewModelNameLength);
    std::string viewModelName(viewModelNameLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &viewModelName[0], viewModelNameLength + 1,
                               &viewModelNameLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::FileHandle>(fileHandle);
    commandQueue->requestViewModelInstanceNames(handle, viewModelName, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}
} // namespace ohos_rive