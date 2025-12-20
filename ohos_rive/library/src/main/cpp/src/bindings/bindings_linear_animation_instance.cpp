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

#include "bindings/bindings_linear_animation_instance.h"
#include "helpers/general.h"
#include "refs.h"
#include "rive/animation/linear_animation_instance.hpp"
#include "rive/animation/loop.hpp"
#include <cstdint>
#include <js_native_api.h>
#include <napi/native_api.h>

namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;
constexpr size_t ARG_NUM_FIVE = 5;
static rive::LinearAnimationInstance *GetLinearAnimationInstance(napi_env env, napi_value arg)
{
    uintptr_t instancePtr = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, arg, &instancePtr, &lossless) != napi_ok || !lossless) {
        LOGE("Animation Instance pointer get failed.");
        return nullptr;
    }
    return reinterpret_cast<rive::LinearAnimationInstance *>(instancePtr);
}

napi_value Advance(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    double elapsedTime = 0;
    status = napi_get_value_double(env, args[ARG_NUM_ONE], &elapsedTime);
    if (status != napi_ok) {
        LOGE("Elapsed time get failed.");
        return nullptr;
    }

    animationInstance->advance(static_cast<float>(elapsedTime));
    bool didLoop = animationInstance->didLoop();

    napi_value loopValue = nullptr;
    if (didLoop) {
        rive::Loop loopType = animationInstance->loop();
        switch (loopType) {
            case rive::Loop::oneShot:
                loopValue = GetOneShotLoopField(env);
                break;
            case rive::Loop::loop:
                loopValue = GetLoopLoopField(env);
                break;
            case rive::Loop::pingPong:
                loopValue = GetPingPongLoopField(env);
                break;
            default:
                loopValue = GetNoneLoopField(env);
                break;
        }
    }
    return loopValue;
}

napi_value AdvanceAndGetResult(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    double elapsedTime = 0;
    status = napi_get_value_double(env, args[ARG_NUM_ONE], &elapsedTime);
    if (status != napi_ok) {
        LOGE("Elapsed time get failed.");
        return nullptr;
    }

    bool keepGoing = animationInstance->advance(static_cast<float>(elapsedTime));
    bool didLoop = animationInstance->didLoop();

    napi_value advanceResultValue = nullptr;

    if (didLoop) {
        rive::Loop loopType = animationInstance->loop();
        switch (loopType) {
            case rive::Loop::oneShot:
                advanceResultValue = GetAdvanceResultOneShotField(env);
                break;
            case rive::Loop::loop:
                advanceResultValue = GetAdvanceResultLoopField(env);
                break;
            case rive::Loop::pingPong:
                advanceResultValue = GetAdvanceResultPingPongField(env);
                break;
            default:
                // This should not happen: if we looped, we should get a
                // loop result.
                LOGE("Unexpected loop type encountered. Defaulting to none.");
                advanceResultValue = GetAdvanceResultNoneField(env);
                break;
        }
    } else if (keepGoing) {
        advanceResultValue = GetAdvanceResultAdvancedField(env);
    } else {
        advanceResultValue = GetAdvanceResultNoneField(env);
    }

    return advanceResultValue;
}

napi_value Apply(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return undefined;
    }

    double mix = 0;
    status = napi_get_value_double(env, args[ARG_NUM_ONE], &mix);
    if (status != napi_ok) {
        LOGE("mix get failed.");
        return undefined;
    }
    animationInstance->apply(static_cast<float>(mix));

    LOGI("Apply mix: %{public}f success.", mix);
    return undefined;
}

napi_value GetTime(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    napi_value time;
    status = napi_create_double(env, animationInstance->time(), &time);
    if (status != napi_ok) {
        LOGE("Create time napi value failed.");
        return nullptr;
    }
    return time;
}

napi_value SetTime(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return undefined;
    }

    double time = 0;
    status = napi_get_value_double(env, args[ARG_NUM_ONE], &time);
    if (status != napi_ok) {
        LOGE("Time get failed.");
        return undefined;
    }

    animationInstance->time(time);
    return undefined;
}

napi_value SetDirection(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return undefined;
    }

    int direction;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &direction);
    if (status != napi_ok) {
        LOGE("Get direction error.");
        return undefined;
    }
    animationInstance->direction(direction);
    return undefined;
}

napi_value GetDirection(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    napi_value direction;
    status = napi_create_int32(env, animationInstance->direction(), &direction);
    if (status != napi_ok) {
        LOGE("Create direction napi value failed.");
        return nullptr;
    }
    return direction;
}

napi_value GetLoop(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    napi_value loopValue;
    status = napi_create_uint32(env, (unsigned int)animationInstance->loop(), &loopValue);
    if (status != napi_ok) {
        LOGE("Create loop napi value failed.");
        return nullptr;
    }
    return loopValue;
}

napi_value SetLoop(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_TWO) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return undefined;
    }

    int loopType;
    status = napi_get_value_int32(env, args[ARG_NUM_ONE], &loopType);
    if (status != napi_ok) {
        LOGE("Get loop value failed.");
        return nullptr;
    }

    animationInstance->loopValue(loopType);
    return undefined;
}

napi_value Name(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    auto name = animationInstance->animation()->name();
    napi_value nameValue;
    status = napi_create_string_utf8(env, name.c_str(), name.length(), &nameValue);
    if (status != napi_ok) {
        LOGE("Create name napi value failed.");
        return nullptr;
    }
    return nameValue;
}

napi_value Duration(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    napi_value duration;
    status = napi_create_uint32(env, animationInstance->animation()->duration(), &duration);
    if (status != napi_ok) {
        LOGE("Create duration napi value failed.");
        return nullptr;
    }
    return duration;
}

napi_value Fps(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    napi_value fps;
    status = napi_create_uint32(env, animationInstance->animation()->fps(), &fps);
    if (status != napi_ok) {
        LOGE("Create fps napi value failed.");
        return nullptr;
    }
    return fps;
}

napi_value WorkStart(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    napi_value workStart;
    status = napi_create_uint32(env, animationInstance->animation()->workStart(), &workStart);
    if (status != napi_ok) {
        LOGE("Create workStart napi value failed.");
        return nullptr;
    }

    LOGI("Get workStart value success.");
    return workStart;
}

napi_value WorkEnd(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return nullptr;
    }

    napi_value workEnd;
    status = napi_create_uint32(env, animationInstance->animation()->workEnd(), &workEnd);
    if (status != napi_ok) {
        LOGE("Create workEnd napi value failed.");
        return nullptr;
    }

    LOGI("Get workEnd value success.");
    return workEnd;
}

napi_value Delete(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_ONE;
    napi_value args[ARG_NUM_ONE];

    napi_value undefined;
    napi_get_undefined(env, &undefined);

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return undefined;
    }

    auto animationInstance = GetLinearAnimationInstance(env, args[ARG_NUM_ZERO]);
    if (animationInstance == nullptr) {
        return undefined;
    }
    delete animationInstance;

    LOGI("Delete linear animation instance success.");
    return undefined;
}

} // namespace ohos_rive

