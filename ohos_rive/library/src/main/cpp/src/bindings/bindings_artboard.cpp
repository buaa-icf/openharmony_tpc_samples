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

#include "bindings/bindings_artboard.h"
#include "helpers/general.h"
#include <cstdio>
#include <string>

#include "models/renderer.h"
#include "rive/animation/linear_animation_instance.hpp"
#include "rive/animation/state_machine_instance.hpp"
#include "rive/artboard.hpp"
#include "rive/text/text_value_run.hpp"
#include "rive/viewmodel/runtime/viewmodel_instance_runtime.hpp"
#include <js_native_api.h>
namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;
constexpr size_t ARG_NUM_FIVE = 5;

napi_value ArtboardCppName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("failed to get callback info");
        return nullptr;
    }

    uint64_t ref;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(ref);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    const std::string &name = artboard->name();
    LOGI("Get artboard name: %{public}s", name.c_str());

    napi_value result;
    status = napi_create_string_utf8(env, name.c_str(), name.length(), &result);
    if (status != napi_ok) {
        LOGE("Failed to create string");
        return nullptr;
    }

    return result;
}

napi_value ArtboardAnimationNameByIndex(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO] = {nullptr};

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("failed to get callback info");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }

    int32_t index = 0;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &index);
    if (status != napi_ok) {
        LOGE("Failed to get animation index");
        return nullptr;
    }

    auto *artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (artboard == nullptr) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    auto *animation = artboard->animation(static_cast<size_t>(index));
    if (animation == nullptr) {
        LOGE("Animation not found");
        return nullptr;
    }

    auto name = animation->name();
    LOGI("Get animation name: %{public}s", name.c_str());

    napi_value result;
    status = napi_create_string_utf8(env, name.c_str(), NAPI_AUTO_LENGTH, &result);
    if (status != napi_ok) {
        LOGE("Failed to create string");
        return nullptr;
    }

    return result;
}

napi_value ArtboardStateMachineNameByIndex(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO] = {nullptr};

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("failed to get callback info");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }

    int32_t index = 0;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &index);
    if (status != napi_ok) {
        LOGE("Failed to get state machine index");
        return nullptr;
    }

    auto *artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (artboard == nullptr) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    auto *stateMachine = artboard->stateMachine(static_cast<size_t>(index));
    if (stateMachine == nullptr) {
        LOGE("State machine not found");
        return nullptr;
    }

    auto name = stateMachine->name();
    LOGI("Get state machine name: %{public}s", name.c_str());

    napi_value result;
    status = napi_create_string_utf8(env, name.c_str(), NAPI_AUTO_LENGTH, &result);
    if (status != napi_ok) {
        LOGE("Failed to create string");
        return nullptr;
    }

    return result;
}

napi_value ArtboardAnimationByIndex(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("failed to get callback info");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }

    int32_t index;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &index);
    if (status != napi_ok) {
        LOGE("Failed to get animation index");
        return nullptr;
    }

    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    auto animation = artboard->animationAt(index);
    if (!animation) {
        LOGE("Animation not found at specified index");
        return nullptr;
    }

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(animation.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }

    return result;
}

napi_value PointerToNapiValue(napi_env env, void *ptr)
{
    napi_value result;
    napi_status status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(ptr), &result);
    if (status != napi_ok) {
        LOGE("Failed to create bigint");
        return nullptr;
    }
    return result;
}

napi_value ArtboardAnimationByName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("failed to get callback info");
        return nullptr;
    }

    uint64_t ref = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &ref, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(ref);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    std::string animationName = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto animation = artboard->animationNamed(animationName);
    if (!animation) {
        LOGE("Animation not found with name: %{public}s", animationName.c_str());
        return nullptr;
    }

    return PointerToNapiValue(env, animation.release());
}

napi_value ArtboardAnimationCount(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("failed to get callback info");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    int count = artboard->animationCount();

    napi_value result;
    status = napi_create_int32(env, count, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Animation count: %{public}d", count);
    return result;
}

napi_value ArtboardStateMachineByIndex(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and index");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }

    int32_t index;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &index);
    if (status != napi_ok) {
        LOGE("Failed to get state machine index");
        return nullptr;
    }

    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    auto stateMachine = artboard->stateMachineAt(index);
    if (!stateMachine) {
        LOGE("State machine not found at index: %{public}d", index);
        return nullptr;
    }

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(stateMachine.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    return result;
}

napi_value ArtboardStateMachineByName(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and name");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }

    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    std::string stateMachineName = NapiStringToString(env, args[ARG_NUM_ONE]);

    auto stateMachine = artboard->stateMachineNamed(stateMachineName);
    if (!stateMachine) {
        LOGE("State machine not found with name: %{public}s", stateMachineName.c_str());
        return nullptr;
    }

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(stateMachine.release()), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    return result;
}

napi_value ArtboardStateMachineCount(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected artboard reference");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    int count = artboard->stateMachineCount();

    napi_value result;
    status = napi_create_int32(env, count, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("State machine count: %{public}d", count);
    return result;
}

napi_value ArtboardInputByNameAtPath(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE("Invalid arguments - expected artboard reference, name and path");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    std::string inputName = NapiStringToString(env, args[ARG_NUM_ONE]);
    std::string inputPath = NapiStringToString(env, args[ARG_NUM_TWO]);

    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    auto input = artboard->input(inputName, inputPath);
    if (!input) {
        LOGE("artboard input failure: %{public}s, path: %{public}s", inputName.c_str(), inputPath.c_str());
        return nullptr;
    }

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(input), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Input success: %{public}s, path: %{public}s", inputName.c_str(), inputPath.c_str());
    return result;
}

napi_value ArtboardGetVolume(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected artboard reference");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    float volume = artboard->volume();

    napi_value result;
    status = napi_create_double(env, volume, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Get volume: %{public}f", volume);
    return result;
}

napi_value ArtboardSetVolume(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and volume");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }

    double volume;
    status = napi_get_value_double(env, args[ARG_NUM_ONE], &volume);
    if (status != napi_ok) {
        LOGE("Failed to get volume value");
        return nullptr;
    }

    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    artboard->volume(static_cast<float>(volume));
    LOGI("Set volume: %{public}f", volume);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ArtboardFindTextValueRun(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and name");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    std::string textValueRunName = NapiStringToString(env, args[ARG_NUM_ONE]);

    auto textValueRun = artboard->find<rive::TextValueRun>(textValueRunName);
    if (!textValueRun) {
        LOGE("TextValueRun not found with name: %{public}s", textValueRunName.c_str());
        return nullptr;
    }

    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(textValueRun), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }

    LOGI("TextValueRun found with name: %{public}s", textValueRunName.c_str());
    return result;
}

napi_value ArtboardFindValueOfTextValueRun(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and name");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    std::string textValueRunName = NapiStringToString(env, args[ARG_NUM_ONE]);
    auto run = artboard->find<rive::TextValueRun>(textValueRunName);
    if (run == nullptr) {
        LOGE("TextValueRun not found with name: %{public}s", textValueRunName.c_str());
        return nullptr;
    }

    std::string textValue = run->text();
    napi_value result;
    status = napi_create_string_utf8(env, textValue.c_str(), textValue.length(), &result);
    if (status != napi_ok) {
        LOGE("Failed to create string result");
        return nullptr;
    }
    LOGI("TextValueRun value found - name: %{public}s, value: %{public}s", textValueRunName.c_str(), textValue.c_str());
    return result;
}

napi_value ArtboardSetValueOfTextValueRun(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];
    napi_value falseValue;
    napi_get_boolean(env, false, &falseValue);

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE("Invalid arguments - expected artboard reference, name and new text");
        return falseValue;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return falseValue;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return falseValue;
    }

    std::string textValueRunName = NapiStringToString(env, args[ARG_NUM_ONE]);
    std::string newText = NapiStringToString(env, args[ARG_NUM_TWO]);
    auto run = artboard->find<rive::TextValueRun>(textValueRunName);
    if (run == nullptr) {
        LOGE("TextValueRun not found with name: %{public}s", textValueRunName.c_str());
        return falseValue;
    }

    run->text(newText);
    LOGI("TextValueRun value set - name: %{public}s, new value: %{public}s", textValueRunName.c_str(), newText.c_str());

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ArtboardFindTextValueRunAtPath(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE("Invalid arguments - expected artboard reference, name and path");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    std::string textValueRunName = NapiStringToString(env, args[ARG_NUM_ONE]);
    std::string textValueRunPath = NapiStringToString(env, args[ARG_NUM_TWO]);

    auto textValueRun = artboard->getTextRun(textValueRunName, textValueRunPath);
    if (!textValueRun) {
        LOGE("TextValueRun not found with name: %{public}s, path: %{public}s", textValueRunName.c_str(),
             textValueRunPath.c_str());
        return nullptr;
    }
    napi_value result;
    status = napi_create_bigint_uint64(env, reinterpret_cast<uint64_t>(textValueRun), &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("TextValueRun found with name: %{public}s, path: %{public}s", textValueRunName.c_str(),
         textValueRunPath.c_str());
    return result;
}

napi_value ArtboardFindValueOfTextValueRunAtPath(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_THREE;
    napi_value args[ARG_NUM_THREE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_THREE) {
        LOGE("Invalid arguments - expected artboard reference, name and path");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }

    std::string textValueRunName = NapiStringToString(env, args[ARG_NUM_ONE]);
    std::string textValueRunPath = NapiStringToString(env, args[ARG_NUM_TWO]);

    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    auto run = artboard->getTextRun(textValueRunName, textValueRunPath);
    if (run == nullptr) {
        LOGE("TextValueRun not found with name: %{public}s, path: %{public}s", textValueRunName.c_str(),
             textValueRunPath.c_str());
        return nullptr;
    }

    std::string textValue = run->text();
    napi_value result;
    status = napi_create_string_utf8(env, textValue.c_str(), textValue.length(), &result);
    if (status != napi_ok) {
        LOGE("Failed to create string result");
        return nullptr;
    }
    LOGI("TextValueRun value found - name: %{public}s, path: %{public}s, value: %{public}s", textValueRunName.c_str(),
         textValueRunPath.c_str(), textValue.c_str());
    return result;
}

napi_value ArtboardSetValueOfTextValueRunAtPath(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_FOUR;
    napi_value args[ARG_NUM_FOUR];
    napi_value falseValue;
    napi_get_boolean(env, false, &falseValue);

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_FOUR) {
        LOGE("Invalid arguments - expected artboard reference, name, new text and path");
        return falseValue;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return falseValue;
    }

    std::string textValueRunName = NapiStringToString(env, args[ARG_NUM_ONE]);
    std::string newText = NapiStringToString(env, args[ARG_NUM_TWO]);
    std::string textValueRunPath = NapiStringToString(env, args[ARG_NUM_THREE]);
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return falseValue;
    }

    auto run = artboard->getTextRun(textValueRunName, textValueRunPath);
    if (run == nullptr) {
        LOGE("TextValueRun not found with name: %{public}s, path: %{public}s", textValueRunName.c_str(),
             textValueRunPath.c_str());

        return falseValue;
    }
    run->text(newText);
    LOGI("TextValueRun value set - name: %{public}s, path: %{public}s, new value: %{public}s", textValueRunName.c_str(),
         textValueRunPath.c_str(), newText.c_str());
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ArtboardAdvance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_value falseValue;
    napi_get_boolean(env, false, &falseValue);

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and elapsed time");
        return falseValue;
    }
    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return falseValue;
    }

    // get elapsed time from arguments
    double elapsedTime;
    status = napi_get_value_double(env, args[ARG_NUM_ONE], &elapsedTime);
    if (status != napi_ok) {
        LOGE("Failed to get elapsed time");
        return falseValue;
    }

    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return falseValue;
    }
    bool result = artboard->advance(static_cast<float>(elapsedTime));

    napi_value jsResult;
    status = napi_get_boolean(env, result, &jsResult);
    if (status != napi_ok) {
        LOGE("Failed to create boolean result");
        return falseValue;
    }

    LOGI("Artboard advanced by %{public}f seconds, result: %{public}s", elapsedTime, result ? "true" : "false");
    return jsResult;
}

napi_value ArtboardBounds(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected artboard reference");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    // get bounds from artboard instance
    const auto bounds = artboard->bounds();

    // JavaScript object
    napi_value jsBounds;
    status = napi_create_object(env, &jsBounds);
    if (status != napi_ok) {
        LOGE("Failed to create bounds object");
        return nullptr;
    }
    napi_value leftValue;
    napi_create_double(env, bounds.left(), &leftValue);
    napi_set_named_property(env, jsBounds, "left", leftValue);

    napi_value topValue;
    napi_create_double(env, bounds.top(), &topValue);
    napi_set_named_property(env, jsBounds, "top", topValue);

    napi_value rightValue;
    napi_create_double(env, bounds.right(), &rightValue);
    napi_set_named_property(env, jsBounds, "right", rightValue);

    napi_value bottomValue;
    napi_create_double(env, bounds.bottom(), &bottomValue);
    napi_set_named_property(env, jsBounds, "bottom", bottomValue);

    LOGI("Artboard bounds: left=%{public}f, top=%{public}f, right=%{public}f, bottom=%{public}f", bounds.left(),
         bounds.top(), bounds.right(), bounds.bottom());
    return jsBounds;
}

napi_value ArtboardResetArtboardSize(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected artboard reference");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }
    artboard->width(artboard->originalWidth());
    artboard->height(artboard->originalHeight());
    LOGI("Artboard size reset to original: %{public}f x %{public}f", artboard->originalWidth(),
         artboard->originalHeight());
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ArtboardGetArtboardWidth(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected artboard reference");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }
    float width = artboard->width();

    napi_value result;
    status = napi_create_double(env, width, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Get artboard width: %{public}f", width);
    return result;
}

napi_value ArtboardSetArtboardWidth(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and width value");
        return nullptr;
    }

    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }

    double width;
    status = napi_get_value_double(env, args[ARG_NUM_ONE], &width);
    if (status != napi_ok) {
        LOGE("Failed to get width value");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    // artboard width
    artboard->width(static_cast<float>(width));
    LOGI("Set artboard width: %{public}f", width);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ArtboardGetArtboardHeight(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected artboard reference");
        return nullptr;
    }
    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    float height = artboard->height();

    napi_value result;
    status = napi_create_double(env, height, &result);
    if (status != napi_ok) {
        LOGE("Failed to create result");
        return nullptr;
    }
    LOGI("Get artboard height: %{public}f", height);
    return result;
}

napi_value ArtboardSetArtboardHeight(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and height value");
        return nullptr;
    }
    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    double height;
    status = napi_get_value_double(env, args[ARG_NUM_ONE], &height);
    if (status != napi_ok) {
        LOGE("Failed to get height value");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }
    artboard->height(static_cast<float>(height));
    LOGI("Set artboard height: %{public}f", height);
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ArtboardSetViewModelInstance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and view model instance reference");
        return nullptr;
    }
    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    // get view model instance reference
    uint64_t viewModelInstanceRef = 0;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &viewModelInstanceRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get view model instance reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }
    auto instance = reinterpret_cast<rive::ViewModelInstanceRuntime *>(viewModelInstanceRef);
    if (!instance) {
        LOGE("Invalid view model instance reference");
        return nullptr;
    }
    // bind view model instance to artboard
    artboard->bindViewModelInstance(instance->instance());
    LOGI("ViewModel instance bound to artboard successfully");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ArtboardDraw(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments - expected artboard reference and renderer reference");
        return nullptr;
    }
    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }

    uint64_t rendererRef = 0;
    lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ONE], &rendererRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get renderer reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    auto wrapper = reinterpret_cast<Renderer *>(rendererRef);
    if (!wrapper) {
        LOGE("Invalid renderer reference");
        return nullptr;
    }

    auto *renderer = wrapper->GetRendererOnWorkerThread();
    if (!renderer) {
        LOGE("Renderer not available in main thread");
        napi_value undefined;
        napi_get_undefined(env, &undefined);
        return undefined;
    }
    wrapper->SetPendingDraw(artboard, renderer);
    LOGI("Artboard drawn successfully");
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

static bool ParseBasicArgs(napi_env env, napi_callback_info info, napi_value args[ARG_NUM_FIVE])
{
    size_t argc = ARG_NUM_FIVE;
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_FIVE) {
        LOGE("Invalid arguments - expected artboard reference, renderer reference, fit, alignment and scale factor");
        return false;
    }
    return true;
}

static rive::ArtboardInstance *GetValidArtboard(napi_env env, napi_value arg)
{
    uint64_t artboardRef = 0;
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, arg, &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }
    return artboard;
}

static bool GetValidRenderer(napi_env env, napi_value arg, Renderer **outWrapper, rive::Renderer **outRenderer)
{
    uint64_t rendererRef = 0;
    bool lossless = false;
    napi_status status = napi_get_value_bigint_uint64(env, arg, &rendererRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get renderer reference");
        return false;
    }
    auto wrapper = reinterpret_cast<Renderer *>(rendererRef);
    if (!wrapper) {
        LOGE("Invalid renderer reference");
        return false;
    }
    auto *renderer = wrapper->GetRendererOnWorkerThread();
    if (!renderer) {
        LOGE("Renderer not available in main thread");
        return false;
    }
    *outWrapper = wrapper;
    *outRenderer = renderer;
    return true;
}

static bool GetValidScaleFactor(napi_env env, napi_value arg, double *outScaleFactor)
{
    double scaleFactor;
    napi_status status = napi_get_value_double(env, arg, &scaleFactor);
    if (status != napi_ok) {
        LOGE("Failed to get scale factor");
        return false;
    }
    *outScaleFactor = scaleFactor;
    return true;
}

napi_value ArtboardDrawAligned(napi_env env, napi_callback_info info)
{
    napi_value args[ARG_NUM_FIVE];
    if (!ParseBasicArgs(env, info, args)) {
        return nullptr;
    }

    auto artboard = GetValidArtboard(env, args[ARG_NUM_ZERO]);
    if (!artboard) {
        return nullptr;
    }

    Renderer *wrapper = nullptr;
    rive::Renderer *renderer = nullptr;
    if (!GetValidRenderer(env, args[ARG_NUM_ONE], &wrapper, &renderer)) {
        return nullptr;
    }

    auto fit = GetFit(env, args[ARG_NUM_TWO]);
    auto alignment = GetAlignment(env, args[ARG_NUM_THREE]);

    double scaleFactor = 0.0;
    if (!GetValidScaleFactor(env, args[ARG_NUM_FOUR], &scaleFactor)) {
        return nullptr;
    }

    wrapper->SetPendingDraw(artboard, renderer, fit, alignment, static_cast<float>(scaleFactor));

    LOGI("Artboard drawn aligned with scale: %{public}f", scaleFactor);
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

napi_value ArtboardDelete(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments - expected artboard reference");
        return nullptr;
    }
    uint64_t artboardRef = 0;
    bool lossless = false;
    status = napi_get_value_bigint_uint64(env, args[ARG_NUM_ZERO], &artboardRef, &lossless);
    if (status != napi_ok || !lossless) {
        LOGE("Failed to get artboard reference");
        return nullptr;
    }
    auto artboard = reinterpret_cast<rive::ArtboardInstance *>(artboardRef);
    if (!artboard) {
        LOGE("Invalid artboard reference");
        return nullptr;
    }

    delete artboard;
    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

} // namespace ohos_rive
