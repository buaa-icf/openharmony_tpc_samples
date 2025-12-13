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

#include "bindings/bindings_state_machine_input_instance.h"
#include "helpers/general.h"
#include "refs.h"
#include "rive/animation/state_machine_bool.hpp"
#include "rive/animation/state_machine_input.hpp"
#include "rive/animation/state_machine_input_instance.hpp"
#include "rive/animation/state_machine_number.hpp"
#include "rive/animation/state_machine_trigger.hpp"
#include <js_native_api.h>
namespace ohos_rive {
constexpr size_t ARG_NUM_TWO = 2;

static rive::SMIInput *GetSMIInstance(napi_env env, napi_value arg)
{
    uint64_t instancePtr = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, arg, &instancePtr, &lossless) != napi_ok || !lossless) {
        LOGE("SMI Input Instance pointer get failed.");
        return nullptr;
    }
    return reinterpret_cast<rive::SMIInput *>(instancePtr);
}

static rive::SMIBool *GetSMIBool(napi_env env, napi_value arg)
{
    uint64_t instancePtr = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, arg, &instancePtr, &lossless) != napi_ok || !lossless) {
        LOGE("SMI Input Instance pointer get failed.");
        return nullptr;
    }
    return reinterpret_cast<rive::SMIBool *>(instancePtr);
}

static rive::SMINumber *GetSMINumber(napi_env env, napi_value arg)
{
    uint64_t instancePtr = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, arg, &instancePtr, &lossless) != napi_ok || !lossless) {
        LOGE("SMI Input Instance pointer get failed.");
        return nullptr;
    }
    return reinterpret_cast<rive::SMINumber *>(instancePtr);
}

static rive::SMITrigger *GetSMITrigger(napi_env env, napi_value arg)
{
    uint64_t instancePtr = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, arg, &instancePtr, &lossless) != napi_ok || !lossless) {
        LOGE("SMI Input Instance pointer get failed.");
        return nullptr;
    }
    return reinterpret_cast<rive::SMITrigger *>(instancePtr);
}

napi_value SMIInputName(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto SMIInstance = GetSMIInstance(env, args[0]);
    if (SMIInstance == nullptr) {
        return nullptr;
    }
    auto name = SMIInstance->name();
    napi_value nameValue;
    status = napi_create_string_utf8(env, name.c_str(), name.length(), &nameValue);
    if (status != napi_ok) {
        LOGE("Create name napi value failed");
        return nullptr;
    }
    return nameValue;
}

napi_value SMIInputIsBoolean(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto SMIInstance = GetSMIInstance(env, args[0]);
    if (SMIInstance == nullptr) {
        return nullptr;
    }
    auto isBoolean = SMIInstance->input()->is<rive::StateMachineBool>();
    napi_value isBoolValue;
    status = napi_get_boolean(env, isBoolean, &isBoolValue);
    if (status != napi_ok) {
        LOGE("Create isBoolean napi value failed");
        return nullptr;
    }
    return isBoolValue;
}

napi_value SMIInputIsNumber(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto SMIInstance = GetSMIInstance(env, args[0]);
    if (SMIInstance == nullptr) {
        return nullptr;
    }
    auto isNumber = SMIInstance->input()->is<rive::StateMachineNumber>();
    napi_value isNumberValue;
    status = napi_get_boolean(env, isNumber, &isNumberValue);
    if (status != napi_ok) {
        LOGE("Create isNumber napi value failed");
        return nullptr;
    }
    return isNumberValue;
}

napi_value SMIInputIsTrigger(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto SMIInstance = GetSMIInstance(env, args[0]);
    if (SMIInstance == nullptr) {
        return nullptr;
    }
    auto isTrigger = SMIInstance->input()->is<rive::StateMachineTrigger>();
    napi_value isTriggerValue;
    status = napi_get_boolean(env, isTrigger, &isTriggerValue);
    if (status != napi_ok) {
        LOGE("Create isTrigger napi value failed");
        return nullptr;
    }
    return isTriggerValue;
}

napi_value SMIBoolValue(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto SMIBool = GetSMIBool(env, args[0]);
    if (SMIBool == nullptr) {
        return nullptr;
    }
    auto inputValue = SMIBool->value();
    napi_value input;
    status = napi_get_boolean(env, inputValue, &input);
    if (status != napi_ok) {
        LOGE("Create input->value() napi value failed");
        return nullptr;
    }
    return input;
}

napi_value SMIBoolSetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO; // 2 arguments are expected: SMIInstance and newValue
    napi_value args[ARG_NUM_TWO];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto SMIBool = GetSMIBool(env, args[0]);
    if (SMIBool == nullptr) {
        return undefined;
    }
    bool newValue = false;
    status = napi_get_value_bool(env, args[1], &newValue);
    if (status != napi_ok) {
        LOGE("newValue get failed.");
        return undefined;
    }

    SMIBool->value(newValue);
    return undefined;
}

napi_value SMINumberValue(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto SMINumber = GetSMINumber(env, args[0]);
    if (SMINumber == nullptr) {
        return nullptr;
    }
    auto inputValue = SMINumber->value();
    napi_value input;
    status = napi_create_double(env, inputValue, &input);
    if (status != napi_ok) {
        LOGE("Create input->value() napi value failed");
        return nullptr;
    }
    return input;
}

napi_value SMINumberSetValue(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO; // 2 arguments are expected: SMIInstance and newValue
    napi_value args[ARG_NUM_TWO];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto SMINumber = GetSMINumber(env, args[0]);
    if (SMINumber == nullptr) {
        return undefined;
    }
    double newValue;
    status = napi_get_value_double(env, args[1], &newValue);
    if (status != napi_ok) {
        LOGE("newValue get failed.");
        return undefined;
    }

    SMINumber->value(static_cast<float>(newValue));
    return undefined;
}

napi_value SMITriggerFire(napi_env env, napi_callback_info info)
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

    auto SMITrigger = GetSMITrigger(env, args[0]);
    if (SMITrigger == nullptr) {
        return undefined;
    }

    SMITrigger->fire();
    LOGI("SMITrigger fire success.");
    return undefined;
}

} // namespace ohos_rive
