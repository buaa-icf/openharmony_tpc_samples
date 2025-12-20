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

#include "bindings/bindings_state_machine_instance.h"
#include "helpers/general.h"
#include "refs.h"
#include "rive/animation/state_machine_instance.hpp"
#include "rive/viewmodel/runtime/viewmodel_instance_runtime.hpp"
#include <js_native_api.h>
namespace ohos_rive {
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;

static rive::StateMachineInstance *GetStateMachineInstance(napi_env env, napi_value arg)
{
    uint64_t instancePtr = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, arg, &instancePtr, &lossless) != napi_ok || !lossless) {
        LOGE("StateMachineInstance pointer get failed.");
        return nullptr;
    }
    return reinterpret_cast<rive::StateMachineInstance *>(instancePtr);
}

static rive::ViewModelInstanceRuntime *GetViewModelInstanceRuntime(napi_env env, napi_value arg)
{
    uint64_t instancePtr = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, arg, &instancePtr, &lossless) != napi_ok || !lossless) {
        LOGE("ViewModelInstanceRuntime pointer get failed.");
        return nullptr;
    }
    return reinterpret_cast<rive::ViewModelInstanceRuntime *>(instancePtr);
}

napi_value StateMachineAdvance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO; // 2 arguments: stateMachineInstance and elapsedTime
    napi_value args[ARG_NUM_TWO];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return nullptr;
    }

    double elapsedTime;
    status = napi_get_value_double(env, args[1], &elapsedTime);
    if (status != napi_ok) {
        LOGE("Get elapsed Time failed.");
        return nullptr;
    }

    auto result = stateMachineInstance->advanceAndApply(static_cast<float>(elapsedTime));
    napi_value resultValue;
    status = napi_get_boolean(env, result, &resultValue);
    if (status != napi_ok) {
        LOGE("Create result napi value failed.");
    }
    return resultValue;
}

napi_value StateMachineStateChangedCount(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return nullptr;
    }

    auto count = SizeTToInt(stateMachineInstance->stateChangedCount());
    napi_value countValue;
    status = napi_create_int32(env, count, &countValue);
    if (status != napi_ok) {
        LOGE("Create state changed count napi value failed.");
    }
    return countValue;
}

napi_value StateMachineStateChangedByIndex(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO; // 2 arguments: stateMachineInstance and index
    napi_value args[ARG_NUM_TWO];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return nullptr;
    }

    int32_t index;
    status = napi_get_value_int32(env, args[1], &index);
    if (status != napi_ok) {
        LOGE("Get index failed.");
        return nullptr;
    }

    auto statePtr = stateMachineInstance->stateChangedByIndex(index);
    napi_value stateValue;
    status = napi_create_bigint_uint64(env, (uint64_t)statePtr, &stateValue);
    if (status != napi_ok) {
        LOGE("Create state napi value failed.");
    }
    return stateValue;
}

napi_value StateMachineReportedEventCount(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return nullptr;
    }

    auto count = SizeTToInt(stateMachineInstance->reportedEventCount());
    napi_value countValue;
    status = napi_create_int32(env, count, &countValue);
    if (status != napi_ok) {
        LOGE("Create reported event count napi value failed.");
    }
    return countValue;
}

napi_value StateMachineReportedEventAt(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO; // 2 arguments: stateMachineInstance and index
    napi_value args[ARG_NUM_TWO];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return nullptr;
    }

    int32_t index;
    status = napi_get_value_int32(env, args[1], &index);
    if (status != napi_ok) {
        LOGE("Get index failed.");
        return nullptr;
    }

    auto eventReport = stateMachineInstance->reportedEventAt(index);

    napi_value event;
    napi_value secondsDelay;
    napi_value eventReportObj;
    status = napi_create_bigint_uint64(env, (uint64_t)eventReport.event(), &event);
    if (status != napi_ok) {
        LOGE("Create event ptr napi value failed.");
        return nullptr;
    }

    status = napi_create_double(env, eventReport.secondsDelay(), &secondsDelay);
    if (status != napi_ok) {
        LOGE("Create seconds delay napi value failed.");
        return nullptr;
    }

    napi_value argv[ARG_NUM_TWO] = {event, secondsDelay};
    status = napi_new_instance(env, GetRiveEventReportClass(env), ARG_NUM_TWO, argv, &eventReportObj);
    if (status != napi_ok) {
        LOGE("Create RiveEventReport Object failed.");
        return nullptr;
    }

    return eventReportObj;
}

napi_value StateMachineSMIInputByIndex(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return nullptr;
    }

    int32_t index;
    status = napi_get_value_int32(env, args[1], &index);
    if (status != napi_ok) {
        LOGE("Get index failed.");
        return nullptr;
    }

    auto input = stateMachineInstance->input(index);
    napi_value inputValue;
    status = napi_create_bigint_uint64(env, (uint64_t)input, &inputValue);
    if (status != napi_ok) {
        LOGE("Create input ptr napi value failed.");
        return nullptr;
    }

    return inputValue;
}

napi_value StateMachineInputCount(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return nullptr;
    }

    auto count = SizeTToInt(stateMachineInstance->inputCount());
    napi_value countValue;
    status = napi_create_int32(env, count, &countValue);
    if (status != napi_ok) {
        LOGE("Create input count napi value failed.");
        return nullptr;
    }
    return countValue;
}

// ANIMATION
napi_value StateMachineName(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return nullptr;
    }

    auto name = stateMachineInstance->stateMachine()->name();
    napi_value nameValue;
    status = napi_create_string_utf8(env, name.c_str(), name.length(), &nameValue);
    if (status != napi_ok) {
        LOGE("Create Name napi value failed.");
        return nullptr;
    }
    return nameValue;
}

napi_value StateMachineLayerCount(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return nullptr;
    }

    napi_value layerCount;
    status = napi_create_int32(env, stateMachineInstance->stateMachine()->layerCount(), &layerCount);
    if (status != napi_ok) {
        LOGE("Create layer count napi value failed.");
        return nullptr;
    }
    return layerCount;
}

napi_value StateMachinePointerDown(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR; // 4: number of arguments
    napi_value args[ARG_NUM_FOUR];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_FOUR) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]); // 0: stateMachineInstance
    if (stateMachineInstance == nullptr) {
        return undefined;
    }

    int pointerID;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &pointerID); // 1: pointerID
    if (status != napi_ok) {
        LOGE("Get pointerID failed.");
        return undefined;
    }

    double x;
    double y;
    status = napi_get_value_double(env, args[ARG_NUM_TWO], &x); // 2: x
    if (status != napi_ok) {
        LOGE("Get x failed.");
        return undefined;
    }
    status = napi_get_value_double(env, args[ARG_NUM_THREE], &y); // 3: y
    if (status != napi_ok) {
        LOGE("Get y failed.");
        return undefined;
    }

    stateMachineInstance->pointerDown(rive::Vec2D(x, y), pointerID);
    LOGI("Pointer down success.");
    return undefined;
}

napi_value StateMachinePointerMove(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR; // 4: number of arguments
    napi_value args[ARG_NUM_FOUR];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_FOUR) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]); // 0: stateMachineInstance
    if (stateMachineInstance == nullptr) {
        return undefined;
    }

    int pointerID;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &pointerID); // 1: pointerID
    if (status != napi_ok) {
        LOGE("Get pointerID failed.");
        return undefined;
    }

    double x;
    double y;
    status = napi_get_value_double(env, args[ARG_NUM_TWO], &x); // 2: x
    if (status != napi_ok) {
        LOGE("Get x failed.");
        return undefined;
    }
    status = napi_get_value_double(env, args[ARG_NUM_THREE], &y); // 3: y
    if (status != napi_ok) {
        LOGE("Get y failed.");
        return undefined;
    }

    stateMachineInstance->pointerMove(rive::Vec2D(x, y), 0.0f, pointerID);
    LOGI("Pointer move success.");
    return undefined;
}

napi_value StateMachinePointerUp(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR; // 4: number of arguments
    napi_value args[ARG_NUM_FOUR];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_FOUR) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]); // 0: stateMachineInstance
    if (stateMachineInstance == nullptr) {
        return undefined;
    }

    int pointerID;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &pointerID); // 1: pointerID
    if (status != napi_ok) {
        LOGE("Get pointerID failed.");
        return undefined;
    }

    double x;
    double y;
    status = napi_get_value_double(env, args[ARG_NUM_TWO], &x); // 2: x
    if (status != napi_ok) {
        LOGE("Get x failed.");
        return undefined;
    }
    status = napi_get_value_double(env, args[ARG_NUM_THREE], &y); // 3: y
    if (status != napi_ok) {
        LOGE("Get y failed.");
        return undefined;
    }

    stateMachineInstance->pointerUp(rive::Vec2D(x, y), pointerID);
    LOGI("Pointer up success.");
    return undefined;
}

napi_value StateMachinePointerExit(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR; // 4: number of arguments
    napi_value args[ARG_NUM_FOUR];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_FOUR) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]); // 0: stateMachineInstance
    if (stateMachineInstance == nullptr) {
        return undefined;
    }

    int pointerID;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &pointerID); // 1: pointerID
    if (status != napi_ok) {
        LOGE("Get pointerID failed.");
        return undefined;
    }

    double x;
    double y;
    status = napi_get_value_double(env, args[ARG_NUM_TWO], &x); // 2: x
    if (status != napi_ok) {
        LOGE("Get x failed.");
        return undefined;
    }
    status = napi_get_value_double(env, args[ARG_NUM_THREE], &y); // 3: y
    if (status != napi_ok) {
        LOGE("Get y failed.");
        return undefined;
    }

    stateMachineInstance->pointerExit(rive::Vec2D(x, y), pointerID);
    LOGI("Pointer exit success.");
    return undefined;
}

napi_value StateMachineSetViewModelInstance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO; // 2: number of arguments
    napi_value args[ARG_NUM_TWO];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]); // 0: stateMachineInstance
    if (stateMachineInstance == nullptr) {
        return undefined;
    }

    auto viewModelInstanceRuntime = GetViewModelInstanceRuntime(env, args[1]); // 1: viewModelInstanceRuntime
    if (viewModelInstanceRuntime == nullptr) {
        return undefined;
    }

    stateMachineInstance->bindViewModelInstance(viewModelInstanceRuntime->instance());
    LOGI("Set view model instance success.");
    return undefined;
}

napi_value StateMachineDelete(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto stateMachineInstance = GetStateMachineInstance(env, args[0]);
    if (stateMachineInstance == nullptr) {
        return undefined;
    }
    delete stateMachineInstance;

    LOGI("Delete state machine instance success.");
    return undefined;
}

} // namespace ohos_rive

