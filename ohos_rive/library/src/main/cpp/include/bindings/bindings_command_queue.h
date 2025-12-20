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

#ifndef OHOS_RIVE_BINDINGS_COMMAND_QUEUE_H
#define OHOS_RIVE_BINDINGS_COMMAND_QUEUE_H

#include "helpers/exception_handler.h"
#include "helpers/factories.h"
#include "helpers/resource.h"
#include "rive/animation/state_machine_instance.hpp"
#include "rive/command_queue.hpp"
#include "rive/command_server.hpp"
#include "rive/file.hpp"
#include <string>

namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;
constexpr size_t ARG_NUM_FIVE = 5;
constexpr size_t ARG_NUM_SIX = 6;
constexpr size_t ARG_NUM_SEVEN = 7;
constexpr size_t ARG_NUM_EIGHT = 8;
constexpr size_t ARG_NUM_NINE = 9;
constexpr size_t ARG_NUM_TEN = 10;
constexpr size_t ARG_NUM_ELEVEN = 11;
constexpr size_t ARG_NUM_TWELVE = 12;
constexpr size_t ARG_NUM_THIRTEEN = 13;
constexpr size_t BUFFER_SIZE = 256;

typedef struct CommandQueueDrawParams {
    uint64_t ref = 0;
    uint64_t eglDisplayRef = 0;
    uint64_t eglSurfaceRef = 0;
    uint64_t eglContextRef = 0;
    uint64_t drawKey = 0;
    uint64_t artboardHandleRef = 0;
    uint64_t stateMachineHandleRef = 0;
    uint64_t renderTargetRef = 0;
    int32_t width = 0;
    int32_t height = 0;
    int32_t ohosClearColor = 0;
    rive::Fit fit = rive::Fit::none;
    rive::Alignment alignment = rive::Alignment::center;
} CommandQueueDrawParams;

napi_value CommandQueueCreateListeners(napi_env env, napi_callback_info info);
napi_value CommandQueueCreateRenderTarget(napi_env env, napi_callback_info info);
napi_value CommandQueueGetViewModelProperties(napi_env env, napi_callback_info info);
napi_value CommandQueueGetEnums(napi_env env, napi_callback_info info);
napi_value CommandQueueCreateDefaultArtboard(napi_env env, napi_callback_info info);
napi_value CommandQueueCreateArtboardByName(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteArtboard(napi_env env, napi_callback_info info);
napi_value CommandQueueCreateDefaultStateMachine(napi_env env, napi_callback_info info);
napi_value CommandQueueCreateStateMachineByName(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteStateMachine(napi_env env, napi_callback_info info);
napi_value CommandQueueAdvanceStateMachine(napi_env env, napi_callback_info info);
napi_value CommandQueueNamedVMCreateBlankVMI(napi_env env, napi_callback_info info);
napi_value CommandQueueDefaultVMCreateBlankVMI(napi_env env, napi_callback_info info);
napi_value CommandQueueNamedVMCreateDefaultVMI(napi_env env, napi_callback_info info);
napi_value CommandQueueDefaultVMCreateDefaultVMI(napi_env env, napi_callback_info info);
napi_value CommandQueueNamedVMCreateNamedVMI(napi_env env, napi_callback_info info);
napi_value CommandQueueDefaultVMCreateNamedVMI(napi_env env, napi_callback_info info);
napi_value CommandQueueReferenceNestedVMI(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteViewModelInstance(napi_env env, napi_callback_info info);
napi_value CommandQueueBindViewModelInstance(napi_env env, napi_callback_info info);
napi_value CommandQueueSetNumberProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueGetNumberProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueSetStringProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueGetStringProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueSetBooleanProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueGetBooleanProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueSetEnumProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueGetEnumProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueSetColorProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueGetColorProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueFireTriggerProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueSubscribeToProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueUnsubscribeFromProperty(napi_env env, napi_callback_info info);
napi_value CommandQueueDecodeImage(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteImage(napi_env env, napi_callback_info info);
napi_value CommandQueueRegisterImage(napi_env env, napi_callback_info info);
napi_value CommandQueueUnregisterImage(napi_env env, napi_callback_info info);
napi_value CommandQueueDecodeAudio(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteAudio(napi_env env, napi_callback_info info);
napi_value CommandQueueRegisterAudio(napi_env env, napi_callback_info info);
napi_value CommandQueueUnregisterAudio(napi_env env, napi_callback_info info);
napi_value CommandQueueDecodeFont(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteFont(napi_env env, napi_callback_info info);
napi_value CommandQueueRegisterFont(napi_env env, napi_callback_info info);
napi_value CommandQueueUnregisterFont(napi_env env, napi_callback_info info);
napi_value CommandQueuePointerMove(napi_env env, napi_callback_info info);
napi_value CommandQueuePointerDown(napi_env env, napi_callback_info info);
napi_value CommandQueuePointerUp(napi_env env, napi_callback_info info);
napi_value CommandQueuePointerExit(napi_env env, napi_callback_info info);
napi_value CommandQueueCreateDrawKey(napi_env env, napi_callback_info info);
napi_value CommandQueuePollMessages(napi_env env, napi_callback_info info);
napi_value CommandQueueDraw(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteRiveSurface(napi_env env, napi_callback_info info);
napi_value CommandQueueDeleteListeners(napi_env env, napi_callback_info info);

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

class NAPICommandQueue {
public:
    NAPICommandQueue(napi_env env, napi_value queue) : g_env(env)
    {
        napi_create_reference(env, queue, 1, &g_queueRef);
    }

    ~NAPICommandQueue()
    {
        if (g_queueRef != nullptr) {
            napi_delete_reference(g_env, g_queueRef);
        }
    }

    [[nodiscard]] napi_env env() const
    {
        return g_env;
    }

    /**
     * Call a CommandQueue JS instance method.
     *
     * @param methodName JS method name
     * @param argc Number of arguments
     * @param argv Arguments array
     */
    template <typename... Args>
    void call(const char *methodName, size_t argc, napi_value *argv) const
    {
        napi_value queue;
        napi_status status = napi_get_reference_value(g_env, g_queueRef, &queue);
        if (status != napi_ok) {
            LOGE("Failed to get queue from reference");
            return;
        }
        NapiExceptionHandler::CallVoidMethod(g_env, queue, methodName, argc, argv);
    }

private:
    napi_env const g_env;
    napi_ref g_queueRef = nullptr;
};

class FileListener : public rive::CommandQueue::FileListener {
public:
    FileListener(napi_env env, napi_value queue) : rive::CommandQueue::FileListener(), g_queue(env, queue) {}

    virtual ~FileListener() = default;

    void onFileLoaded(const rive::FileHandle handle, uint64_t requestID) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);
        napi_create_bigint_uint64(g_queue.env(), longFromHandle(handle), &argv[ARG_NUM_ONE]);
        g_queue.call("onFileLoaded", ARG_NUM_TWO, argv);
    }

    void onFileError(const rive::FileHandle, uint64_t requestID, std::string error) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value jError;
        napi_create_string_utf8(g_queue.env(), error.c_str(), error.length(), &jError);
        argv[ARG_NUM_ONE] = jError;

        g_queue.call("onFileError", ARG_NUM_TWO, argv);
    }

    void onArtboardsListed(const rive::FileHandle, uint64_t requestID, std::vector<std::string> artboardNames) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value array;
        napi_create_array(g_queue.env(), &array);
        for (size_t i = 0; i < artboardNames.size(); i++) {
            napi_value jsName;
            napi_create_string_utf8(g_queue.env(), artboardNames[i].c_str(), artboardNames[i].length(), &jsName);
            napi_set_element(g_queue.env(), array, i, jsName);
        }
        argv[ARG_NUM_ONE] = array;

        g_queue.call("onArtboardsListed", ARG_NUM_TWO, argv);
    }

    void onViewModelsListed(const rive::FileHandle,
                            uint64_t requestID,
                            std::vector<std::string> viewModelNames) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value array;
        napi_create_array(g_queue.env(), &array);
        for (size_t i = 0; i < viewModelNames.size(); i++) {
            napi_value jsName;
            napi_create_string_utf8(g_queue.env(), viewModelNames[i].c_str(), viewModelNames[i].length(), &jsName);
            napi_set_element(g_queue.env(), array, i, jsName);
        }
        argv[ARG_NUM_ONE] = array;

        g_queue.call("onViewModelsListed", ARG_NUM_TWO, argv);
    }

    void onViewModelInstanceNamesListed(const rive::FileHandle,
                                        uint64_t requestID,
                                        std::string,
                                        std::vector<std::string> instanceNames) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value array;
        napi_create_array(g_queue.env(), &array);
        for (size_t i = 0; i < instanceNames.size(); i++) {
            napi_value jsName;
            napi_create_string_utf8(g_queue.env(), instanceNames[i].c_str(), instanceNames[i].length(), &jsName);
            napi_set_element(g_queue.env(), array, i, jsName);
        }
        argv[ARG_NUM_ONE] = array;

        g_queue.call("onViewModelInstancesListed", ARG_NUM_TWO, argv);
    }

    void onViewModelPropertiesListed(
        const rive::FileHandle,
        uint64_t requestID,
        std::string viewModelName,
        std::vector<rive::CommandQueue::FileListener::ViewModelPropertyData> properties) override
    {
        napi_env env = g_queue.env();
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value array;
        napi_create_array(env, &array);

        for (size_t i = 0; i < properties.size(); i++) {
            const auto &property = properties[i];

            napi_value jProperty;
            napi_create_object(env, &jProperty);

            // Add property name
            napi_value jsName;
            napi_create_string_utf8(env, property.name.c_str(), property.name.length(), &jsName);
            napi_set_named_property(env, jProperty, "name", jsName);

            // Add property type
            napi_value jsType;
            napi_create_int32(env, static_cast<int32_t>(property.type), &jsType);
            napi_set_named_property(env, jProperty, "type", jsType);

            napi_set_element(env, array, i, jProperty);
        }
        argv[ARG_NUM_ONE] = array;

        g_queue.call("onViewModelPropertiesListed", ARG_NUM_TWO, argv);
    }

    void onViewModelEnumsListed(const rive::FileHandle,
                                uint64_t requestID,
                                std::vector<rive::ViewModelEnum> enums) override
    {
        napi_env env = g_queue.env();
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value array;
        napi_create_array(env, &array);

        for (size_t i = 0; i < enums.size(); i++) {
            const auto &enumItem = enums[i];

            napi_value jEnum;
            napi_create_object(env, &jEnum);

            // Add enum name
            napi_value jsName;
            napi_create_string_utf8(env, enumItem.name.c_str(), enumItem.name.length(), &jsName);
            napi_set_named_property(env, jEnum, "name", jsName);

            // Add enum values
            napi_value jValues;
            napi_create_array(env, &jValues);
            for (size_t j = 0; j < enumItem.enumerants.size(); j++) {
                napi_value jValue;
                napi_create_string_utf8(env, enumItem.enumerants[j].c_str(), enumItem.enumerants[j].length(), &jValue);
                napi_set_element(env, jValues, j, jValue);
            }
            napi_set_named_property(env, jEnum, "values", jValues);

            napi_set_element(env, array, i, jEnum);
        }
        argv[ARG_NUM_ONE] = array;

        g_queue.call("onEnumsListed", ARG_NUM_TWO, argv);
    }

private:
    NAPICommandQueue g_queue;
};

class ArtboardListener : public rive::CommandQueue::ArtboardListener {
public:
    ArtboardListener(napi_env env, napi_value queue) : rive::CommandQueue::ArtboardListener(), g_queue(env, queue) {}

    virtual ~ArtboardListener() = default;

    void onStateMachinesListed(const rive::ArtboardHandle,
                               uint64_t requestID,
                               std::vector<std::string> stateMachineNames) override
    {
        napi_env env = g_queue.env();
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value array;
        napi_create_array(env, &array);
        for (size_t i = 0; i < stateMachineNames.size(); i++) {
            napi_value jsName;
            napi_create_string_utf8(env, stateMachineNames[i].c_str(), stateMachineNames[i].length(), &jsName);
            napi_set_element(env, array, i, jsName);
        }
        argv[ARG_NUM_ONE] = array;

        g_queue.call("onStateMachinesListed", ARG_NUM_TWO, argv);
    }

private:
    NAPICommandQueue g_queue;
};

class StateMachineListener : public rive::CommandQueue::StateMachineListener {
public:
    StateMachineListener(napi_env env, napi_value queue)
        : rive::CommandQueue::StateMachineListener(), g_queue(env, queue)
    {
    }

    virtual ~StateMachineListener() = default;

    void onStateMachineSettled(const rive::StateMachineHandle smHandle, uint64_t requestID) override
    {
        napi_value argv[ARG_NUM_ONE];
        napi_create_bigint_uint64(g_queue.env(), longFromHandle(smHandle), &argv[ARG_NUM_ZERO]);
        g_queue.call("onStateMachineSettled", ARG_NUM_ONE, argv);
    }

private:
    NAPICommandQueue g_queue;
};

class ViewModelInstanceListener : public rive::CommandQueue::ViewModelInstanceListener {
public:
    ViewModelInstanceListener(napi_env env, napi_value queue)
        : rive::CommandQueue::ViewModelInstanceListener(), g_queue(env, queue)
    {
    }

    virtual ~ViewModelInstanceListener() = default;

    void onViewModelDataReceived(const rive::ViewModelInstanceHandle vmiHandle,
                                 uint64_t requestID,
                                 rive::CommandQueue::ViewModelInstanceData data) override
    {
        napi_env env = g_queue.env();
        napi_value argv[ARG_NUM_FOUR];

        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);
        napi_create_bigint_uint64(g_queue.env(), longFromHandle(vmiHandle), &argv[ARG_NUM_ONE]);

        napi_value propertyName;
        napi_create_string_utf8(env, data.metaData.name.c_str(), data.metaData.name.length(), &propertyName);
        argv[ARG_NUM_TWO] = propertyName;

        switch (data.metaData.type) {
            case rive::DataType::number:
                napi_create_double(env, data.numberValue, &argv[ARG_NUM_THREE]);
                g_queue.call("onNumberPropertyUpdated", ARG_NUM_FOUR, argv);
                break;
            case rive::DataType::string:
                napi_value strValue;
                napi_create_string_utf8(env, data.stringValue.c_str(), data.stringValue.length(), &strValue);
                argv[ARG_NUM_THREE] = strValue;
                g_queue.call("onStringPropertyUpdated", ARG_NUM_FOUR, argv);
                break;
            case rive::DataType::boolean:
                napi_value boolValue;
                napi_get_boolean(env, data.boolValue, &boolValue);
                argv[ARG_NUM_THREE] = boolValue;
                g_queue.call("onBooleanPropertyUpdated", ARG_NUM_FOUR, argv);
                break;
            case rive::DataType::enumType:
                napi_value enumValue;
                napi_create_string_utf8(env, data.stringValue.c_str(), data.stringValue.length(), &enumValue);
                argv[ARG_NUM_THREE] = enumValue;
                g_queue.call("onEnumPropertyUpdated", ARG_NUM_FOUR, argv);
                break;
            case rive::DataType::color:
                napi_create_int32(env, data.colorValue, &argv[ARG_NUM_THREE]);
                g_queue.call("onColorPropertyUpdated", ARG_NUM_FOUR, argv);
                break;
            case rive::DataType::trigger:
                napi_value undefined;
                napi_get_undefined(env, &undefined);
                argv[ARG_NUM_THREE] = undefined;
                g_queue.call("onTriggerPropertyUpdated", ARG_NUM_FOUR, argv);
                break;
            default:
                LOGE("Unknown ViewModelInstance property type: %{public}d", static_cast<int>(data.metaData.type));
        }
    }

private:
    NAPICommandQueue g_queue;
};

class ImageListener : public rive::CommandQueue::RenderImageListener {
public:
    ImageListener(napi_env env, napi_value queue) : rive::CommandQueue::RenderImageListener(), g_queue(env, queue) {}

    virtual ~ImageListener() = default;

    void onRenderImageDecoded(const rive::RenderImageHandle handle, uint64_t requestID) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);
        napi_create_bigint_uint64(g_queue.env(), longFromHandle(handle), &argv[ARG_NUM_ONE]);
        g_queue.call("onImageDecoded", ARG_NUM_TWO, argv);
    }

    void onRenderImageError(const rive::RenderImageHandle, uint64_t requestID, std::string error) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value jError;
        napi_create_string_utf8(g_queue.env(), error.c_str(), error.length(), &jError);
        argv[ARG_NUM_ONE] = jError;

        g_queue.call("onImageError", ARG_NUM_TWO, argv);
    }

private:
    NAPICommandQueue g_queue;
};

class AudioListener : public rive::CommandQueue::AudioSourceListener {
public:
    AudioListener(napi_env env, napi_value queue) : rive::CommandQueue::AudioSourceListener(), g_queue(env, queue) {}

    virtual ~AudioListener() = default;

    void onAudioSourceDecoded(const rive::AudioSourceHandle handle, uint64_t requestID) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);
        napi_create_bigint_uint64(g_queue.env(), longFromHandle(handle), &argv[ARG_NUM_ONE]);
        g_queue.call("onAudioDecoded", ARG_NUM_TWO, argv);
    }

    void onAudioSourceError(const rive::AudioSourceHandle, uint64_t requestID, std::string error) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value jError;
        napi_create_string_utf8(g_queue.env(), error.c_str(), error.length(), &jError);
        argv[ARG_NUM_ONE] = jError;

        g_queue.call("onAudioError", ARG_NUM_TWO, argv);
    }

private:
    NAPICommandQueue g_queue;
};

class FontListener : public rive::CommandQueue::FontListener {
public:
    FontListener(napi_env env, napi_value queue) : rive::CommandQueue::FontListener(), g_queue(env, queue) {}

    virtual ~FontListener() = default;

    void onFontDecoded(const rive::FontHandle handle, uint64_t requestID) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);
        napi_create_bigint_uint64(g_queue.env(), longFromHandle(handle), &argv[ARG_NUM_ONE]);
        g_queue.call("onFontDecoded", ARG_NUM_TWO, argv);
    }

    void onFontError(const rive::FontHandle, uint64_t requestID, std::string error) override
    {
        napi_value argv[ARG_NUM_TWO];
        napi_create_bigint_uint64(g_queue.env(), requestID, &argv[ARG_NUM_ZERO]);

        napi_value jError;
        napi_create_string_utf8(g_queue.env(), error.c_str(), error.length(), &jError);
        argv[ARG_NUM_ONE] = jError;

        g_queue.call("onFontError", ARG_NUM_TWO, argv);
    }

private:
    NAPICommandQueue g_queue;
};

} // namespace ohos_rive

#endif // OHOS_RIVE_BINDINGS_COMMAND_QUEUE_H

