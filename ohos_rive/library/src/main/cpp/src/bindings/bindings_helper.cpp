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

#include "bindings/bindings_helper.h"
#include "helpers/general.h"
#include "models/dimensions_helper.h"
#include "refs.h"
#include "rive/layout.hpp"
#include "rive/math/aabb.hpp"
#include "rive/math/mat2d.hpp"
#include "rive/math/vec2d.hpp"
#include <napi/native_api.h>

namespace ohos_rive {
constexpr size_t ARG_NUM_ZERO = 0;
constexpr size_t ARG_NUM_ONE = 1;
constexpr size_t ARG_NUM_TWO = 2;
constexpr size_t ARG_NUM_THREE = 3;
constexpr size_t ARG_NUM_FOUR = 4;
constexpr size_t ARG_NUM_FIVE = 5;
constexpr size_t ARG_NUM_SIX = 6;
static bool GetPointFromObject(napi_env env, napi_value obj, rive::Vec2D &point)
{
    napi_value xValue;
    napi_value yValue;

    if (napi_get_named_property(env, obj, "x", &xValue) != napi_ok) {
        return false;
    }
    if (napi_get_named_property(env, obj, "y", &yValue) != napi_ok) {
        return false;
    }

    double x;
    double y;
    if (napi_get_value_double(env, xValue, &x) != napi_ok) {
        return false;
    }
    if (napi_get_value_double(env, yValue, &y) != napi_ok) {
        return false;
    }

    point = rive::Vec2D((float)x, (float)y);
    return true;
}

static napi_value CreatePointObject(napi_env env, rive::Vec2D &convertedLocation)
{
    napi_value resultPoint;
    if (napi_create_object(env, &resultPoint) != napi_ok) {
        return nullptr;
    }

    napi_value xValue;
    napi_value yValue;
    if (napi_create_double(env, convertedLocation.x, &xValue) != napi_ok) {
        return nullptr;
    }
    if (napi_create_double(env, convertedLocation.y, &yValue) != napi_ok) {
        return nullptr;
    }
    if (napi_set_named_property(env, resultPoint, "x", xValue) != napi_ok) {
        return nullptr;
    }
    if (napi_set_named_property(env, resultPoint, "y", yValue) != napi_ok) {
        return nullptr;
    }

    return resultPoint;
}

napi_value ConvertToArtboardSpace(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM_SIX;
    napi_value args[ARG_NUM_SIX];
    auto status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok) {
        return nullptr;
    }

    if (argc < ARG_NUM_SIX) {
        LOGE("Invalid arguments, expected 6 arguments, actual number of arguments: %{public}ld", argc);
        return nullptr;
    }

    napi_value touchSpaceRectF = args[ARG_NUM_ZERO];
    napi_value touchSpacePointF = args[ARG_NUM_ONE];
    napi_value fitValue = args[ARG_NUM_TWO];
    napi_value alignmentValue = args[ARG_NUM_THREE];
    napi_value artboardSpaceRectF = args[ARG_NUM_FOUR];

    double scaleFactor;
    status = napi_get_value_double(env, args[ARG_NUM_FIVE], &scaleFactor);
    if (status != napi_ok) {
        return nullptr;
    }

    auto fit = GetFit(env, fitValue);
    auto alignment = GetAlignment(env, alignmentValue);
    auto artboardSpaceBounds = RectFToAABB(env, artboardSpaceRectF);
    auto touchSpaceBounds = RectFToAABB(env, touchSpaceRectF);

    rive::Vec2D touchLocation;
    if (!GetPointFromObject(env, touchSpacePointF, touchLocation)) {
        LOGE("Get touch point error");
        return nullptr;
    }

    rive::Mat2D forward = computeAlignment(fit, alignment, touchSpaceBounds, artboardSpaceBounds, (float)scaleFactor);
    rive::Mat2D inverse = forward.invertOrIdentity();

    rive::Vec2D convertedLocation = inverse * touchLocation;

    napi_value resultPoint = CreatePointObject(env, convertedLocation);
    if (resultPoint == nullptr) {
        LOGE("Create object error");
        return nullptr;
    }

    return resultPoint;
}
} // namespace ohos_rive

