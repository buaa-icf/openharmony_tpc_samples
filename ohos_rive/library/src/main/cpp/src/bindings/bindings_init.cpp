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

#include <thread>

#include "bindings/bindings_init.h"
#include "helpers/font_helper.h"
#include "helpers/general.h"
#include "helpers/resource.h"
#include "models/dimensions_helper.h"
#include "refs.h"

namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;
constexpr size_t ARG_NUM_FIVE = 5;
constexpr size_t ARG_NUM_SIX = 6;
napi_value RiveCppCalculateRequiredBounds(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_undefined(env, &result);

    napi_status status;
    size_t argc = ARG_NUM_SIX;
    napi_value args[ARG_NUM_SIX] = {nullptr};
    status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_SIX) {
        LOGE("Failed to parse arguments for RiveCppCalculateRequiredBounds");
        return result;
    }

    rive::Fit fit = GetFit(env, args[ARG_NUM_ZERO]);
    rive::Alignment alignment = GetAlignment(env, args[ARG_NUM_ONE]);
    rive::AABB availableBounds = RectFToAABB(env, args[ARG_NUM_TWO]);
    rive::AABB artboardBounds = RectFToAABB(env, args[ARG_NUM_THREE]);

    double scaleFactor = 0.0f;
    status = napi_get_value_double(env, args[ARG_NUM_FIVE], &scaleFactor);
    if (status != napi_ok) {
        LOGE("Failed to parse scaleFactor for RiveCppCalculateRequiredBounds");
        return result;
    }

    DimensionsHelper helper;
    auto required = helper.computeDimensions(fit, alignment, availableBounds, artboardBounds, scaleFactor);
    AABBToRectF(env, required, args[ARG_NUM_FOUR]);

    return result;
}

napi_value RiveCppInitialize(napi_env env, napi_callback_info info)
{
#if defined(DEBUG) || defined(LOG)
    std::thread t(LogThread);
    t.detach();
#endif
    rive::Font::gFallbackProc = FontHelper::FindFontFallback;
    return nullptr;
}

napi_value RiveCppRegisterClass(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Failed to parse arguments for RegisterClass");
        return nullptr;
    }

    RegisterClass(env, args, argc);

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}

napi_value RiveCppUnregisterClass(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_TWO;
    napi_value args[ARG_NUM_TWO] = {nullptr};
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < ARG_NUM_ONE) {
        LOGE("Failed to parse arguments for UnregisterClass");
        return nullptr;
    }

    UnregisterClass(env, args, argc);

    napi_value result;
    napi_get_undefined(env, &result);
    return result;
}
} // namespace ohos_rive
