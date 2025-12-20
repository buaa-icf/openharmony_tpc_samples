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

#include "bindings/bindings_layer_state.h"
#include "helpers/general.h"
#include "refs.h"
#include "rive/animation/animation_state.hpp"
#include "rive/animation/any_state.hpp"
#include "rive/animation/blend_state.hpp"
#include "rive/animation/blend_state_1d.hpp"
#include "rive/animation/blend_state_direct.hpp"
#include "rive/animation/entry_state.hpp"
#include "rive/animation/exit_state.hpp"
#include "rive/animation/layer_state.hpp"

#include "rive/animation/linear_animation_instance.hpp"
#include <js_native_api.h>
namespace ohos_rive {
static rive::LayerState *GetLayerState(napi_env env, napi_value arg)
{
    uintptr_t instancePtr = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, arg, &instancePtr, &lossless) != napi_ok || !lossless) {
        LOGE("LayerState pointer get failed.");
        return nullptr;
    }
    return reinterpret_cast<rive::LayerState *>(instancePtr);
}

static rive::AnimationState *GetAnimationState(napi_env env, napi_value arg)
{
    uintptr_t instancePtr = 0;
    bool lossless = false;
    if (napi_get_value_bigint_uint64(env, arg, &instancePtr, &lossless) != napi_ok || !lossless) {
        LOGE("AnimationState pointer get failed.");
        return nullptr;
    }
    return reinterpret_cast<rive::AnimationState *>(instancePtr);
}

template <typename State>
static napi_value LayerStateIsState(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto layerState = GetLayerState(env, args[0]);
    if (layerState == nullptr) {
        return nullptr;
    }

    napi_value isState;
    status = napi_get_boolean(env, layerState->is<State>(), &isState);
    if (status != napi_ok) {
        LOGE("Create isState napi value failed.");
        return nullptr;
    }
    return isState;
}

napi_value LayerStateIsExitState(napi_env env, napi_callback_info info)
{
    return LayerStateIsState<rive::ExitState>(env, info);
}

napi_value LayerStateIsAnyState(napi_env env, napi_callback_info info)
{
    return LayerStateIsState<rive::AnyState>(env, info);
}

napi_value LayerStateIsEntryState(napi_env env, napi_callback_info info)
{
    return LayerStateIsState<rive::EntryState>(env, info);
}

napi_value LayerStateIsAnimationState(napi_env env, napi_callback_info info)
{
    return LayerStateIsState<rive::AnimationState>(env, info);
}

napi_value LayerStateIsBlendState(napi_env env, napi_callback_info info)
{
    return LayerStateIsState<rive::BlendState>(env, info);
}

napi_value LayerStateIsBlendState1D(napi_env env, napi_callback_info info)
{
    return LayerStateIsState<rive::BlendState1D>(env, info);
}

napi_value LayerStateIsBlendStateDirect(napi_env env, napi_callback_info info)
{
    return LayerStateIsState<rive::BlendStateDirect>(env, info);
}

napi_value AnimationStateName(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];

    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 1) {
        LOGE("Invalid arguments, actual number of arguments is %{public}ld", argc);
        return nullptr;
    }

    auto animationState = GetAnimationState(env, args[0]);
    if (animationState == nullptr) {
        return nullptr;
    }

    auto animation = animationState->animation();
    std::string name;
    if (animation == nullptr) {
        name = "Unknown";
    } else {
        name = animationState->animation()->name();
    }

    napi_value nameValue;
    status = napi_create_string_utf8(env, name.c_str(), name.length(), &nameValue);
    if (status != napi_ok) {
        LOGE("Create animation name napi value failed.");
        return nullptr;
    }
    return nameValue;
}

} // namespace ohos_rive

