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

#include "bindings/bindings_command_queue.h"
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

/** Typedef for the below setProperty function. */
template <typename T>
using PropertySetter = void (rive::CommandQueue::*)(rive::ViewModelInstanceHandle, std::string, T, uint64_t);

/** Typedef for the below getProperty function. */
using PropertyGetter = void (rive::CommandQueue::*)(rive::ViewModelInstanceHandle, std::string, uint64_t);
namespace ohos_rive {

struct Listeners {
    FileListener *fileListener;
    ArtboardListener *artboardListener;
    StateMachineListener *stateMachineListener;
    ViewModelInstanceListener *viewModelInstanceListener;
    ImageListener *imageListener;
    AudioListener *audioListener;
    FontListener *fontListener;
};

struct StartupResult {
    bool success;
    EGLint eglError;
    std::string message;
};

struct PropertyParameters {
    uint64_t ref = 0;
    uint64_t jViewModelInstanceHandle = 0;
    const char *propertyPath = nullptr;
};

/** A generic setter for all property types. */
template <typename T>
void setProperty(napi_env env, PropertyParameters &params, T value, PropertySetter<T> setter)
{
    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(params.ref);
    auto viewModelInstanceHandle = handleFromLong<rive::ViewModelInstanceHandle>(params.jViewModelInstanceHandle);

    (commandQueue->*setter)(viewModelInstanceHandle, params.propertyPath, value, 0); // Pass 0 for requestID
}

/** A generic getter for all property types. */
void getProperty(napi_env env, PropertyParameters &params, uint64_t requestID, PropertyGetter getter)
{
    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(params.ref);
    auto viewModelInstanceHandle = handleFromLong<rive::ViewModelInstanceHandle>(params.jViewModelInstanceHandle);

    (commandQueue->*getter)(viewModelInstanceHandle, params.propertyPath, requestID);
}

static void CreateAllListeners(napi_env env,
                               napi_value jsCommandQueue,
                               rive::CommandQueue *commandQueue,
                               Listeners &listeners)
{
    listeners.fileListener = new FileListener(env, jsCommandQueue);
    listeners.artboardListener = new ArtboardListener(env, jsCommandQueue);
    listeners.stateMachineListener = new StateMachineListener(env, jsCommandQueue);
    listeners.viewModelInstanceListener = new ViewModelInstanceListener(env, jsCommandQueue);
    listeners.imageListener = new ImageListener(env, jsCommandQueue);
    listeners.audioListener = new AudioListener(env, jsCommandQueue);
    listeners.fontListener = new FontListener(env, jsCommandQueue);

    commandQueue->setGlobalFileListener(listeners.fileListener);
    commandQueue->setGlobalArtboardListener(listeners.artboardListener);
    commandQueue->setGlobalStateMachineListener(listeners.stateMachineListener);
    commandQueue->setGlobalViewModelInstanceListener(listeners.viewModelInstanceListener);
    commandQueue->setGlobalRenderImageListener(listeners.imageListener);
    commandQueue->setGlobalAudioSourceListener(listeners.audioListener);
    commandQueue->setGlobalFontListener(listeners.fontListener);
}

napi_value CommandQueueCreateListeners(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueCreateListeners");
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
    napi_value jsCommandQueue = args[ARG_NUM_ONE];

    // 创建监听器
    Listeners listeners;
    CreateAllListeners(env, jsCommandQueue, commandQueue, listeners);

    // 创建返回对象
    napi_value result;
    napi_create_object(env, &result);

    napi_value fileListenerValue;
    napi_value artboardListenerValue;
    napi_value stateMachineListenerValue;
    napi_value viewModelInstanceListenerValue;
    napi_value imageListenerValue;
    napi_value audioListenerValue;
    napi_value fontListenerValue;

    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(listeners.fileListener), &fileListenerValue);
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(listeners.artboardListener), &artboardListenerValue);
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(listeners.stateMachineListener),
                              &stateMachineListenerValue);
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(listeners.viewModelInstanceListener),
                              &viewModelInstanceListenerValue);
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(listeners.imageListener), &imageListenerValue);
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(listeners.audioListener), &audioListenerValue);
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(listeners.fontListener), &fontListenerValue);

    napi_set_named_property(env, result, "fileListener", fileListenerValue);
    napi_set_named_property(env, result, "artboardListener", artboardListenerValue);
    napi_set_named_property(env, result, "stateMachineListener", stateMachineListenerValue);
    napi_set_named_property(env, result, "viewModelInstanceListener", viewModelInstanceListenerValue);
    napi_set_named_property(env, result, "imageListener", imageListenerValue);
    napi_set_named_property(env, result, "audioListener", audioListenerValue);
    napi_set_named_property(env, result, "fontListener", fontListenerValue);

    return result;
}

napi_value CommandQueueCreateRenderTarget(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueCreateRenderTarget");
        return nullptr;
    }

    int32_t width;
    int32_t height;
    napi_get_value_int32(env, args[ARG_NUM_ZERO], &width);
    napi_get_value_int32(env, args[ARG_NUM_ONE], &height);

    GLint sampleCount;
    glGetIntegerv(GL_SAMPLES, &sampleCount);

    auto renderTarget = new rive::gpu::FramebufferRenderTargetGL(width, height, 0, sampleCount);

    napi_value result;
    napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(renderTarget), &result);
    return result;
}

napi_value CommandQueueGetViewModelProperties(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueGetViewModelProperties");
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
    commandQueue->requestViewModelPropertyDefinitions(handle, viewModelName, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetEnums(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueGetEnums");
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
    commandQueue->requestViewModelEnums(handle, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueCreateDefaultArtboard(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueCreateDefaultArtboard");
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
    auto artboard =
        commandQueue->instantiateDefaultArtboard(handleFromLong<rive::FileHandle>(fileHandle), nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(artboard), &result);
    return result;
}

napi_value CommandQueueCreateArtboardByName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueCreateArtboardByName");
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

    size_t nameLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &nameLength);
    std::string name(nameLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &name[0], nameLength + 1, &nameLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto artboard =
        commandQueue->instantiateArtboardNamed(handleFromLong<rive::FileHandle>(fileHandle), name, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(artboard), &result);
    return result;
}

napi_value CommandQueueDeleteArtboard(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueDeleteArtboard");
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
    commandQueue->deleteArtboard(handleFromLong<rive::ArtboardHandle>(artboardHandle), requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueCreateDefaultStateMachine(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueCreateDefaultStateMachine");
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
    auto stateMachine = commandQueue->instantiateDefaultStateMachine(
        handleFromLong<rive::ArtboardHandle>(artboardHandle), nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(stateMachine), &result);
    return result;
}

napi_value CommandQueueCreateStateMachineByName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueCreateStateMachineByName");
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

    size_t nameLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &nameLength);
    std::string name(nameLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &name[0], nameLength + 1, &nameLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto stateMachine = commandQueue->instantiateStateMachineNamed(handleFromLong<rive::ArtboardHandle>(artboardHandle),
                                                                   name, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(stateMachine), &result);
    return result;
}

napi_value CommandQueueDeleteStateMachine(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueDeleteStateMachine");
        return nullptr;
    }

    uint64_t ref;
    uint64_t stateMachineHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &stateMachineHandle, &lossless) != napi_ok || !lossless ||
        stateMachineHandle == 0) {
        LOGE("Failed to get stateMachineHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    commandQueue->deleteStateMachine(handleFromLong<rive::StateMachineHandle>(stateMachineHandle), requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueAdvanceStateMachine(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueAdvanceStateMachine");
        return nullptr;
    }

    uint64_t ref;
    uint64_t stateMachineHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &stateMachineHandle, &lossless) != napi_ok || !lossless ||
        stateMachineHandle == 0) {
        LOGE("Failed to get stateMachineHandle from bigint");
        return nullptr;
    }

    int64_t deltaTimeNs;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &deltaTimeNs);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto deltaSeconds = static_cast<float_t>(deltaTimeNs) / 1e9f; // NS to S
    commandQueue->advanceStateMachine(handleFromLong<rive::StateMachineHandle>(stateMachineHandle), deltaSeconds);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueNamedVMCreateBlankVMI(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueNamedVMCreateBlankVMI");
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
    auto viewModelInstance = commandQueue->instantiateBlankViewModelInstance(handle, viewModelName, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(viewModelInstance), &result);
    return result;
}

napi_value CommandQueueDefaultVMCreateBlankVMI(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueDefaultVMCreateBlankVMI");
        return nullptr;
    }

    uint64_t ref;
    uint64_t fileHandle;
    uint64_t artboardHandle;
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

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_THREE], &artboardHandle, &lossless) != napi_ok || !lossless ||
        artboardHandle == 0) {
        LOGE("Failed to get artboardHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto longFileHandle = handleFromLong<rive::FileHandle>(fileHandle);
    auto longArtboardHandle = handleFromLong<rive::ArtboardHandle>(artboardHandle);
    auto viewModelInstance =
        commandQueue->instantiateBlankViewModelInstance(longFileHandle, longArtboardHandle, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(viewModelInstance), &result);
    return result;
}

napi_value CommandQueueNamedVMCreateDefaultVMI(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueNamedVMCreateDefaultVMI");
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
    auto viewModelInstance =
        commandQueue->instantiateDefaultViewModelInstance(handle, viewModelName, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(viewModelInstance), &result);
    return result;
}

napi_value CommandQueueDefaultVMCreateDefaultVMI(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueDefaultVMCreateDefaultVMI");
        return nullptr;
    }

    uint64_t ref;
    uint64_t fileHandle;
    uint64_t artboardHandle;
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

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_THREE], &artboardHandle, &lossless) != napi_ok || !lossless ||
        artboardHandle == 0) {
        LOGE("Failed to get artboardHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto longFileHandle = handleFromLong<rive::FileHandle>(fileHandle);
    auto longArtboardHandle = handleFromLong<rive::ArtboardHandle>(artboardHandle);
    auto viewModelInstance =
        commandQueue->instantiateDefaultViewModelInstance(longFileHandle, longArtboardHandle, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(viewModelInstance), &result);
    return result;
}

napi_value CommandQueueNamedVMCreateNamedVMI(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FIVE;
    napi_value args[ARG_NUM_FIVE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FIVE) {
        LOGE("Wrong number of arguments in CommandQueueNamedVMCreateNamedVMI");
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
    size_t instanceNameLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &viewModelNameLength);
    napi_get_value_string_utf8(env, args[ARG_NUM_FOUR], nullptr, 0, &instanceNameLength);

    std::string viewModelName(viewModelNameLength + 1, '\0');
    std::string instanceName(instanceNameLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &viewModelName[0], viewModelNameLength + 1,
                               &viewModelNameLength);
    napi_get_value_string_utf8(env, args[ARG_NUM_FOUR], &instanceName[0], instanceNameLength + 1, &instanceNameLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::FileHandle>(fileHandle);
    auto viewModelInstance =
        commandQueue->instantiateViewModelInstanceNamed(handle, viewModelName, instanceName, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(viewModelInstance), &result);
    return result;
}

napi_value CommandQueueDefaultVMCreateNamedVMI(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FIVE;
    napi_value args[ARG_NUM_FIVE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FIVE) {
        LOGE("Wrong number of arguments in CommandQueueDefaultVMCreateNamedVMI");
        return nullptr;
    }

    uint64_t ref;
    uint64_t fileHandle;
    uint64_t artboardHandle;
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

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_THREE], &artboardHandle, &lossless) != napi_ok || !lossless ||
        artboardHandle == 0) {
        LOGE("Failed to get artboardHandle from bigint");
        return nullptr;
    }

    size_t instanceNameLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_FOUR], nullptr, 0, &instanceNameLength);
    std::string instanceName(instanceNameLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_FOUR], &instanceName[0], instanceNameLength + 1, &instanceNameLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto longFileHandle = handleFromLong<rive::FileHandle>(fileHandle);
    auto longArtboardHandle = handleFromLong<rive::ArtboardHandle>(artboardHandle);
    auto viewModelInstance = commandQueue->instantiateViewModelInstanceNamed(longFileHandle, longArtboardHandle,
                                                                             instanceName, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(viewModelInstance), &result);
    return result;
}

napi_value CommandQueueReferenceNestedVMI(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueReferenceNestedVMI");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &pathLength);
    std::string path(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &path[0], pathLength + 1, &pathLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::ViewModelInstanceHandle>(viewModelInstanceHandle);
    auto nestedViewModelInstance = commandQueue->referenceNestedViewModelInstance(handle, path, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(nestedViewModelInstance), &result);
    return result;
}

napi_value CommandQueueDeleteViewModelInstance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueDeleteViewModelInstance");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::ViewModelInstanceHandle>(viewModelInstanceHandle);
    commandQueue->deleteViewModelInstance(handle, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueBindViewModelInstance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueBindViewModelInstance");
        return nullptr;
    }

    uint64_t ref;
    uint64_t stateMachineHandle;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &stateMachineHandle, &lossless) != napi_ok || !lossless ||
        stateMachineHandle == 0) {
        LOGE("Failed to get stateMachineHandle from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_THREE], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto StateMachineHandle = handleFromLong<rive::StateMachineHandle>(stateMachineHandle);
    auto ViewModelInstanceHandle = handleFromLong<rive::ViewModelInstanceHandle>(viewModelInstanceHandle);
    commandQueue->bindViewModelInstance(StateMachineHandle, ViewModelInstanceHandle, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueSetNumberProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueSetNumberProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], &propertyPath[0], pathLength + 1, &pathLength);

    double value;
    napi_get_value_double(env, args[ARG_NUM_THREE], &value);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    setProperty(env, params, static_cast<float>(value), &rive::CommandQueue::setViewModelInstanceNumber);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetNumberProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueGetNumberProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &propertyPath[0], pathLength + 1, &pathLength);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    getProperty(env, params, requestID, &rive::CommandQueue::requestViewModelInstanceNumber);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueSetStringProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueSetStringProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    size_t valueLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], nullptr, 0, &pathLength);
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &valueLength);
    std::string propertyPath(pathLength + 1, '\0');
    std::string value(valueLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], &propertyPath[0], pathLength + 1, &pathLength);
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &value[0], valueLength + 1, &valueLength);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    setProperty(env, params, value, &rive::CommandQueue::setViewModelInstanceString);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetStringProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueGetStringProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &propertyPath[0], pathLength + 1, &pathLength);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    getProperty(env, params, requestID, &rive::CommandQueue::requestViewModelInstanceString);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueSetBooleanProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueSetBooleanProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], &propertyPath[0], pathLength + 1, &pathLength);

    bool value;
    napi_get_value_bool(env, args[ARG_NUM_THREE], &value);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    setProperty(env, params, value, &rive::CommandQueue::setViewModelInstanceBool);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetBooleanProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueGetBooleanProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &propertyPath[0], pathLength + 1, &pathLength);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    getProperty(env, params, requestID, &rive::CommandQueue::requestViewModelInstanceBool);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueSetEnumProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueSetEnumProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    size_t valueLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], nullptr, 0, &pathLength);
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &valueLength);

    std::string propertyPath(pathLength + 1, '\0');
    std::string value(valueLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], &propertyPath[0], pathLength + 1, &pathLength);
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &value[0], valueLength + 1, &valueLength);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    setProperty(env, params, value, &rive::CommandQueue::setViewModelInstanceEnum);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetEnumProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueGetEnumProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &propertyPath[0], pathLength + 1, &pathLength);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    getProperty(env, params, requestID, &rive::CommandQueue::requestViewModelInstanceEnum);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueSetColorProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueSetColorProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], &propertyPath[0], pathLength + 1, &pathLength);

    int32_t colorValue;
    napi_get_value_int32(env, args[ARG_NUM_THREE], &colorValue);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    setProperty(env, params, static_cast<uint32_t>(colorValue), &rive::CommandQueue::setViewModelInstanceColor);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueGetColorProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueGetColorProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_THREE], &propertyPath[0], pathLength + 1, &pathLength);

    PropertyParameters params = {ref, viewModelInstanceHandle, propertyPath.c_str()};
    getProperty(env, params, requestID, &rive::CommandQueue::requestViewModelInstanceColor);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueFireTriggerProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueFireTriggerProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], &propertyPath[0], pathLength + 1, &pathLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::ViewModelInstanceHandle>(viewModelInstanceHandle);
    commandQueue->fireViewModelTrigger(handle, propertyPath);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueSubscribeToProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueSubscribeToProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], &propertyPath[0], pathLength + 1, &pathLength);

    int32_t propertyType;
    napi_get_value_int32(env, args[ARG_NUM_THREE], &propertyType);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::ViewModelInstanceHandle>(viewModelInstanceHandle);
    auto dataType = static_cast<rive::DataType>(propertyType);

    commandQueue->subscribeToViewModelProperty(handle, propertyPath, dataType);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueUnsubscribeFromProperty(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_FOUR) {
        LOGE("Wrong number of arguments in CommandQueueUnsubscribeFromProperty");
        return nullptr;
    }

    uint64_t ref;
    uint64_t viewModelInstanceHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &viewModelInstanceHandle, &lossless) != napi_ok ||
        !lossless || viewModelInstanceHandle == 0) {
        LOGE("Failed to get viewModelInstanceHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], nullptr, 0, &pathLength);
    std::string propertyPath(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_TWO], &propertyPath[0], pathLength + 1, &pathLength);

    int32_t propertyType;
    napi_get_value_int32(env, args[ARG_NUM_THREE], &propertyType);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::ViewModelInstanceHandle>(viewModelInstanceHandle);
    auto dataType = static_cast<rive::DataType>(propertyType);

    commandQueue->unsubscribeToViewModelProperty(handle, propertyPath, dataType);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueDecodeImage(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueDecodeImage");
        return nullptr;
    }

    uint64_t ref;
    uint64_t requestID;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &requestID, &lossless) != napi_ok || !lossless ||
        requestID == 0) {
        LOGE("Failed to get requestID from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);

    void *arrayBufferData;
    size_t arrayBufferLength;
    napi_get_arraybuffer_info(env, args[ARG_NUM_TWO], &arrayBufferData, &arrayBufferLength);

    std::vector<uint8_t> byteVec(static_cast<uint8_t *>(arrayBufferData),
                                 static_cast<uint8_t *>(arrayBufferData) + arrayBufferLength);

    commandQueue->decodeImage(byteVec, nullptr, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueDeleteImage(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueDeleteImage");
        return nullptr;
    }

    uint64_t ref;
    uint64_t imageHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &imageHandle, &lossless) != napi_ok || !lossless ||
        imageHandle == 0) {
        LOGE("Failed to get imageHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::RenderImageHandle>(imageHandle);
    commandQueue->deleteImage(handle);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueRegisterImage(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueRegisterImage");
        return nullptr;
    }

    uint64_t ref;
    uint64_t imageHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &imageHandle, &lossless) != napi_ok || !lossless ||
        imageHandle == 0) {
        LOGE("Failed to get imageHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], nullptr, 0, &pathLength);
    std::string path(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], &path[0], pathLength + 1, &pathLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::RenderImageHandle>(imageHandle);
    commandQueue->addGlobalImageAsset(path, handle);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueUnregisterImage(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueUnregisterImage");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], nullptr, 0, &pathLength);
    std::string path(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], &path[0], pathLength + 1, &pathLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    commandQueue->removeGlobalImageAsset(path);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueDecodeAudio(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueDecodeAudio");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);

    void *arrayBufferData;
    size_t arrayBufferLength;
    napi_get_arraybuffer_info(env, args[ARG_NUM_TWO], &arrayBufferData, &arrayBufferLength);

    std::vector<uint8_t> byteVec(static_cast<uint8_t *>(arrayBufferData),
                                 static_cast<uint8_t *>(arrayBufferData) + arrayBufferLength);

    commandQueue->decodeAudio(byteVec, nullptr, requestID);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueDeleteAudio(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueDeleteAudio");
        return nullptr;
    }

    uint64_t ref;
    uint64_t audioHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &audioHandle, &lossless) != napi_ok || !lossless ||
        audioHandle == 0) {
        LOGE("Failed to get audioHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::AudioSourceHandle>(audioHandle);
    commandQueue->deleteAudio(handle);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueRegisterAudio(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueRegisterAudio");
        return nullptr;
    }

    uint64_t ref;
    uint64_t audioHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &audioHandle, &lossless) != napi_ok || !lossless ||
        audioHandle == 0) {
        LOGE("Failed to get audioHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], nullptr, 0, &pathLength);
    std::string path(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], &path[0], pathLength + 1, &pathLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::AudioSourceHandle>(audioHandle);
    commandQueue->addGlobalAudioAsset(path, handle);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueUnregisterAudio(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueUnregisterAudio");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], nullptr, 0, &pathLength);
    std::string path(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], &path[0], pathLength + 1, &pathLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    commandQueue->removeGlobalAudioAsset(path);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueDecodeFont(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueDecodeFont");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    int64_t requestID;
    napi_get_value_int64(env, args[ARG_NUM_ONE], &requestID);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);

    void *arrayBufferData;
    size_t arrayBufferLength;
    napi_get_arraybuffer_info(env, args[ARG_NUM_TWO], &arrayBufferData, &arrayBufferLength);

    std::vector<uint8_t> byteVec(static_cast<uint8_t *>(arrayBufferData),
                                 static_cast<uint8_t *>(arrayBufferData) + arrayBufferLength);

    auto fontHandle = commandQueue->decodeFont(byteVec, nullptr, requestID);

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(fontHandle), &result);
    return result;
}

napi_value CommandQueueDeleteFont(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueDeleteFont");
        return nullptr;
    }

    uint64_t ref;
    uint64_t fontHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &fontHandle, &lossless) != napi_ok || !lossless ||
        fontHandle == 0) {
        LOGE("Failed to get fontHandle from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::FontHandle>(fontHandle);
    commandQueue->deleteFont(handle);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueRegisterFont(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_THREE) {
        LOGE("Wrong number of arguments in CommandQueueRegisterFont");
        return nullptr;
    }

    uint64_t ref;
    uint64_t fontHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_TWO], &fontHandle, &lossless) != napi_ok || !lossless ||
        fontHandle == 0) {
        LOGE("Failed to get fontHandle from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], nullptr, 0, &pathLength);
    std::string path(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], &path[0], pathLength + 1, &pathLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto handle = handleFromLong<rive::FontHandle>(fontHandle);
    commandQueue->addGlobalFontAsset(path, handle);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueUnregisterFont(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_TWO) {
        LOGE("Wrong number of arguments in CommandQueueUnregisterFont");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    size_t pathLength;
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], nullptr, 0, &pathLength);
    std::string path(pathLength + 1, '\0');
    napi_get_value_string_utf8(env, args[ARG_NUM_ONE], &path[0], pathLength + 1, &pathLength);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    commandQueue->removeGlobalFontAsset(path);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueuePointerMove(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_NINE;
    napi_value args[ARG_NUM_NINE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_NINE) {
        LOGE("Wrong number of arguments in CommandQueuePointerMove");
        return nullptr;
    }

    uint64_t ref = 0;
    uint64_t stateMachineHandle = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &stateMachineHandle, &lossless) != napi_ok || !lossless ||
        stateMachineHandle == 0) {
        LOGE("Failed to get stateMachineHandle from bigint");
        return nullptr;
    }

    int32_t fit = 0;
    int32_t align = 0;
    int32_t pointerID = 0;
    napi_get_value_int32(env, args[ARG_NUM_TWO], &fit);
    napi_get_value_int32(env, args[ARG_NUM_THREE], &align);
    napi_get_value_int32(env, args[ARG_NUM_SIX], &pointerID);

    double surfaceWidth = 0.0;
    double surfaceHeight = 0.0;
    double pointerX = 0.0;
    double pointerY = 0.0;
    napi_get_value_double(env, args[ARG_NUM_FOUR], &surfaceWidth);
    napi_get_value_double(env, args[ARG_NUM_FIVE], &surfaceHeight);
    napi_get_value_double(env, args[ARG_NUM_SEVEN], &pointerX);
    napi_get_value_double(env, args[ARG_NUM_EIGHT], &pointerY);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    rive::CommandQueue::PointerEvent event{
        .fit = GetFit(env, args[ARG_NUM_TWO]),
        .alignment = GetAlignment(env, args[ARG_NUM_THREE]),
        .screenBounds = rive::Vec2D(static_cast<float_t>(surfaceWidth), static_cast<float_t>(surfaceHeight)),
        .position = rive::Vec2D(static_cast<float_t>(pointerX), static_cast<float_t>(pointerY))};
    event.pointerId = pointerID;

    commandQueue->pointerMove(handleFromLong<rive::StateMachineHandle>(stateMachineHandle), event);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueuePointerDown(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_NINE;
    napi_value args[ARG_NUM_NINE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_NINE) {
        LOGE("Wrong number of arguments in CommandQueuePointerDown");
        return nullptr;
    }

    uint64_t ref = 0;
    uint64_t stateMachineHandle = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &stateMachineHandle, &lossless) != napi_ok || !lossless ||
        stateMachineHandle == 0) {
        LOGE("Failed to get stateMachineHandle from bigint");
        return nullptr;
    }

    int32_t fit = 0;
    int32_t alignment = 0;
    int32_t pointerID = 0;
    napi_get_value_int32(env, args[ARG_NUM_TWO], &fit);
    napi_get_value_int32(env, args[ARG_NUM_THREE], &alignment);
    napi_get_value_int32(env, args[ARG_NUM_SIX], &pointerID);

    double surfaceWidth = 0.0;
    double surfaceHeight = 0.0;
    double pointerX = 0.0;
    double pointerY = 0.0;
    napi_get_value_double(env, args[ARG_NUM_FOUR], &surfaceWidth);
    napi_get_value_double(env, args[ARG_NUM_FIVE], &surfaceHeight);
    napi_get_value_double(env, args[ARG_NUM_SEVEN], &pointerX);
    napi_get_value_double(env, args[ARG_NUM_EIGHT], &pointerY);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    rive::CommandQueue::PointerEvent event{
        .fit = GetFit(env, args[ARG_NUM_TWO]),
        .alignment = GetAlignment(env, args[ARG_NUM_THREE]),
        .screenBounds = rive::Vec2D(static_cast<float_t>(surfaceWidth), static_cast<float_t>(surfaceHeight)),
        .position = rive::Vec2D(static_cast<float_t>(pointerX), static_cast<float_t>(pointerY))};
    event.pointerId = pointerID;

    commandQueue->pointerDown(handleFromLong<rive::StateMachineHandle>(stateMachineHandle), event);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueuePointerUp(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_NINE;
    napi_value args[ARG_NUM_NINE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_NINE) {
        LOGE("Wrong number of arguments in CommandQueuePointerUp");
        return nullptr;
    }

    uint64_t ref = 0;
    uint64_t stateMachineHandle = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &stateMachineHandle, &lossless) != napi_ok || !lossless ||
        stateMachineHandle == 0) {
        LOGE("Failed to get stateMachineHandle from bigint");
        return nullptr;
    }

    int32_t fit = 0;
    int32_t alignment = 0;
    int32_t pointerID = 0;
    napi_get_value_int32(env, args[ARG_NUM_TWO], &fit);
    napi_get_value_int32(env, args[ARG_NUM_THREE], &alignment);
    napi_get_value_int32(env, args[ARG_NUM_SIX], &pointerID);

    double surfaceWidth = 0.0;
    double surfaceHeight = 0.0;
    double pointerX = 0.0;
    double pointerY = 0.0;
    napi_get_value_double(env, args[ARG_NUM_FOUR], &surfaceWidth);
    napi_get_value_double(env, args[ARG_NUM_FIVE], &surfaceHeight);
    napi_get_value_double(env, args[ARG_NUM_SEVEN], &pointerX);
    napi_get_value_double(env, args[ARG_NUM_EIGHT], &pointerY);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    rive::CommandQueue::PointerEvent event{
        .fit = GetFit(env, args[ARG_NUM_TWO]),
        .alignment = GetAlignment(env, args[ARG_NUM_THREE]),
        .screenBounds = rive::Vec2D(static_cast<float_t>(surfaceWidth), static_cast<float_t>(surfaceHeight)),
        .position = rive::Vec2D(static_cast<float_t>(pointerX), static_cast<float_t>(pointerY))};
    event.pointerId = pointerID;

    commandQueue->pointerUp(handleFromLong<rive::StateMachineHandle>(stateMachineHandle), event);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueuePointerExit(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_NINE;
    napi_value args[ARG_NUM_NINE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_NINE) {
        LOGE("Wrong number of arguments in CommandQueuePointerExit");
        return nullptr;
    }

    uint64_t ref;
    uint64_t stateMachineHandle;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &stateMachineHandle, &lossless) != napi_ok || !lossless ||
        stateMachineHandle == 0) {
        LOGE("Failed to get stateMachineHandle from bigint");
        return nullptr;
    }

    int32_t fit = 0;
    int32_t alignment = 0;
    int32_t pointerID = 0;
    napi_get_value_int32(env, args[ARG_NUM_TWO], &fit);
    napi_get_value_int32(env, args[ARG_NUM_THREE], &alignment);
    napi_get_value_int32(env, args[ARG_NUM_SIX], &pointerID);

    double surfaceWidth = 0.0;
    double surfaceHeight = 0.0;
    double pointerX = 0.0;
    double pointerY = 0.0;
    napi_get_value_double(env, args[ARG_NUM_FOUR], &surfaceWidth);
    napi_get_value_double(env, args[ARG_NUM_FIVE], &surfaceHeight);
    napi_get_value_double(env, args[ARG_NUM_SEVEN], &pointerX);
    napi_get_value_double(env, args[ARG_NUM_EIGHT], &pointerY);

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    rive::CommandQueue::PointerEvent event{
        .fit = GetFit(env, args[ARG_NUM_TWO]),
        .alignment = GetAlignment(env, args[ARG_NUM_THREE]),
        .screenBounds = rive::Vec2D(static_cast<float_t>(surfaceWidth), static_cast<float_t>(surfaceHeight)),
        .position = rive::Vec2D(static_cast<float_t>(pointerX), static_cast<float_t>(pointerY))};
    event.pointerId = pointerID;

    commandQueue->pointerExit(handleFromLong<rive::StateMachineHandle>(stateMachineHandle), event);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueCreateDrawKey(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments in CommandQueueCreateDrawKey");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    auto drawKey = commandQueue->createDrawKey();

    napi_value result;
    napi_create_bigint_uint64(env, longFromHandle(drawKey), &result);
    return result;
}

napi_value CommandQueuePollMessages(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments in CommandQueuePollMessages");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless) != napi_ok || !lossless || ref == 0) {
        LOGE("Failed to get CommandQueue pointer from bigint");
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(ref);
    commandQueue->processMessages();

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

static bool GetCommandQueueDrawParams(napi_env env, napi_callback_info info, CommandQueueDrawParams &params)
{
    size_t argc = ARG_NUM_THIRTEEN;
    napi_value args[ARG_NUM_THIRTEEN];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARG_NUM_THIRTEEN) {
        LOGE("Wrong number of arguments in CommandQueueDraw");
        return false;
    }
    struct ParamConfig {
        size_t argIndex;
        uint64_t *target;
        const char *errorMsg;
    };

    const ParamConfig bigintParams[] = {{ARG_NUM_ZERO, &params.ref, "CommandQueue pointer"},
                                        {ARG_NUM_ONE, &params.eglDisplayRef, "eglDisplayRef"},
                                        {ARG_NUM_TWO, &params.eglSurfaceRef, "eglSurfaceRef"},
                                        {ARG_NUM_THREE, &params.eglContextRef, "eglContextRef"},
                                        {ARG_NUM_FOUR, &params.drawKey, "drawKey"},
                                        {ARG_NUM_FIVE, &params.artboardHandleRef, "artboardHandleRef"},
                                        {ARG_NUM_SIX, &params.stateMachineHandleRef, "stateMachineHandleRef"},
                                        {ARG_NUM_SEVEN, &params.renderTargetRef, "renderTargetRef"}};

    for (const auto &config : bigintParams) {
        bool lossless = false;
        if (napi_get_value_bigint_uint64(env, args[config.argIndex], config.target, &lossless) != napi_ok ||
            !lossless || *config.target == 0) {
            LOGE("Failed to get %s from bigint", config.errorMsg);
            return false;
        }
    }

    napi_get_value_int32(env, args[ARG_NUM_EIGHT], &params.width);
    napi_get_value_int32(env, args[ARG_NUM_NINE], &params.height);
    napi_get_value_int32(env, args[ARG_NUM_TWELVE], &params.ohosClearColor);

    params.fit = GetFit(env, args[ARG_NUM_TEN]);
    params.alignment = GetAlignment(env, args[ARG_NUM_ELEVEN]);

    return true;
}

void RenderRiveFrame(rive::CommandServer *server,
                     rive::ArtboardInstance *artboard,
                     rive::gpu::RenderTargetGL *renderTarget,
                     const CommandQueueDrawParams &params)
{
    auto riveContext = static_cast<rive::gpu::RenderContext *>(server->factory());
    riveContext->beginFrame({
        .renderTargetWidth = static_cast<uint32_t>(params.width),
        .renderTargetHeight = static_cast<uint32_t>(params.height),
        .loadAction = rive::gpu::LoadAction::clear,
        .clearColor = static_cast<uint32_t>(params.ohosClearColor),
    });

    rive::RiveRenderer renderer(riveContext);
    renderer.align(params.fit, params.alignment,
                   rive::AABB(0.0f, 0.0f, static_cast<float_t>(params.width), static_cast<float_t>(params.height)),
                   artboard->bounds());
    artboard->draw(&renderer);

    riveContext->flush({.renderTarget = renderTarget});
}

bool MakeEGLContextCurrent(EGLDisplay display, EGLSurface surface, EGLContext context)
{
    eglMakeCurrent(display, surface, surface, context);
    auto error = eglGetError();
    if (error != EGL_SUCCESS) {
        LOGE("EGL error setting context: %{public}d", error);
        return false;
    }
    return true;
}

std::function<void(rive::DrawKey, rive::CommandServer *)> CreateDrawCallback(const CommandQueueDrawParams &params)
{
    auto eglDisplay = reinterpret_cast<EGLDisplay>(params.eglDisplayRef);
    auto eglSurface = reinterpret_cast<EGLSurface>(params.eglSurfaceRef);
    auto eglContext = reinterpret_cast<EGLContext>(params.eglContextRef);
    auto renderTarget = reinterpret_cast<rive::gpu::RenderTargetGL *>(params.renderTargetRef);

    // 提取需要捕获的参数为局部变量
    auto artboardHandleRef = params.artboardHandleRef;
    auto stateMachineHandleRef = params.stateMachineHandleRef;

    return [=](rive::DrawKey, rive::CommandServer *server) {
        auto artboard = server->getArtboardInstance(handleFromLong<rive::ArtboardHandle>(artboardHandleRef));
        auto stateMachine =
            server->getStateMachineInstance(handleFromLong<rive::StateMachineHandle>(stateMachineHandleRef));
        if (!artboard || !stateMachine) {
            return;
        }
        if (!MakeEGLContextCurrent(eglDisplay, eglSurface, eglContext)) {
            return;
        }

        RenderRiveFrame(server, artboard, renderTarget, params);

        eglSwapBuffers(eglDisplay, eglSurface);
    };
}

napi_value CommandQueueDraw(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THIRTEEN;
    napi_value args[ARG_NUM_THIRTEEN];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARG_NUM_THIRTEEN) {
        LOGE("Wrong number of arguments in CommandQueueDraw");
        return nullptr;
    }

    CommandQueueDrawParams params;
    if (!GetCommandQueueDrawParams(env, info, params)) {
        return nullptr;
    }

    auto commandQueue = reinterpret_cast<rive::CommandQueue *>(params.ref);
    commandQueue->draw(handleFromLong<rive::DrawKey>(params.drawKey), CreateDrawCallback(params));

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value CommandQueueDeleteRiveSurface(napi_env env, napi_callback_info info)
{
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc < ARG_NUM_ONE) {
        LOGE("Wrong number of arguments in CommandQueueDeleteRiveSurface");
        return undefined;
    }

    uint64_t renderTargetRef;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &renderTargetRef, &lossless) != napi_ok || !lossless ||
        renderTargetRef == 0) {
        LOGE("Failed to get renderTargetRef from bigint");
        return undefined;
    }

    auto renderTarget = reinterpret_cast<rive::gpu::RenderTargetGL *>(renderTargetRef);
    delete renderTarget;
    return undefined;
}

static bool ParseListenerRefs(napi_env env, napi_value args[], uint64_t refs[])
{
    bool lossless = false;
    for (int i = 0; i < ARG_NUM_SEVEN; i++) {
        if (napi_get_value_bigint_uint64(env, args[i], &refs[i], &lossless) != napi_ok || !lossless || refs[i] == 0) {
            LOGE("Failed to get listenerRef[%{public}d] from bigint", i);
            return false;
        }
    }
    return true;
}

static napi_value DeleteAllListeners(const uint64_t refs[])
{
    auto fileListener = reinterpret_cast<FileListener *>(refs[ARG_NUM_ZERO]);
    auto artboardListener = reinterpret_cast<ArtboardListener *>(refs[ARG_NUM_ONE]);
    auto stateMachineListener = reinterpret_cast<StateMachineListener *>(refs[ARG_NUM_TWO]);
    auto viewModelInstanceListener = reinterpret_cast<ViewModelInstanceListener *>(refs[ARG_NUM_THREE]);
    auto imageListener = reinterpret_cast<ImageListener *>(refs[ARG_NUM_FOUR]);
    auto audioListener = reinterpret_cast<AudioListener *>(refs[ARG_NUM_FIVE]);
    auto fontListener = reinterpret_cast<FontListener *>(refs[ARG_NUM_SIX]);

    delete fileListener;
    delete artboardListener;
    delete stateMachineListener;
    delete viewModelInstanceListener;
    delete imageListener;
    delete audioListener;
    delete fontListener;
}

napi_value CommandQueueDeleteListeners(napi_env env, napi_callback_info info)
{
    napi_value undefined;
    napi_get_undefined(env, &undefined);

    size_t argc = ARG_NUM_SEVEN;
    napi_value args[ARG_NUM_SEVEN];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < ARG_NUM_SEVEN) {
        LOGE("Wrong number of arguments in Napi_CommandQueue_cppDeleteListeners");
        return undefined;
    }

    uint64_t listenerRefs[ARG_NUM_SEVEN];
    if (!ParseListenerRefs(env, args, listenerRefs)) {
        return undefined;
    }

    DeleteAllListeners(listenerRefs);
    return undefined;
}
} // namespace ohos_rive
