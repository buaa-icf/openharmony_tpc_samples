/**
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

#include "yoga_config_napi.h"
#include "yoga_napi.h"

namespace YOGA_NAPI {

// Utility functions
YGConfigRef YogaConfigNapi::extractConfigRef(napi_env env, napi_value configValue)
{
    return YogaNapi::extractConfigRef(env, configValue);
}

void YogaConfigNapi::setConfigRef(napi_env env, napi_value configValue, YGConfigRef config)
{
    YogaNapi::setConfigRef(env, configValue, config);
}

// YGConfigNew
napi_value YogaConfigNapi::NapiYGConfigNew(napi_env env, napi_callback_info info)
{
    YGConfigRef config = YGConfigNew();

    napi_value configObject;
    napi_create_object(env, &configObject);
    setConfigRef(env, configObject, config);

    return configObject;
}

// YGConfigFree
napi_value YogaConfigNapi::NapiYGConfigFree(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);

    YGConfigRef config = extractConfigRef(env, args[ARG_INDEX_ZERO]);
    if (config == nullptr) {
        napi_throw_error(env, nullptr, "Invalid config");
        return nullptr;
    }

    YGConfigFree(config);

    return nullptr;
}

// YGConfigSetUseWebDefaults
napi_value YogaConfigNapi::NapiYGConfigSetUseWebDefaults(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGConfigRef config = extractConfigRef(env, args[ARG_INDEX_ZERO]);
    if (config == nullptr) {
        napi_throw_error(env, nullptr, "Invalid config");
        return nullptr;
    }

    bool useWebDefaults;
    napi_get_value_bool(env, args[ARG_INDEX_ONE], &useWebDefaults);

    YGConfigSetUseWebDefaults(config, useWebDefaults);

    return nullptr;
}

// YGConfigSetPointScaleFactor
napi_value YogaConfigNapi::NapiYGConfigSetPointScaleFactor(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGConfigRef config = extractConfigRef(env, args[ARG_INDEX_ZERO]);
    if (config == nullptr) {
        napi_throw_error(env, nullptr, "Invalid config");
        return nullptr;
    }

    double pixelsInPoint;
    napi_get_value_double(env, args[ARG_INDEX_ONE], &pixelsInPoint);

    YGConfigSetPointScaleFactor(config, static_cast<float>(pixelsInPoint));

    return nullptr;
}

// YGConfigSetErrata
napi_value YogaConfigNapi::NapiYGConfigSetErrata(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGConfigRef config = extractConfigRef(env, args[ARG_INDEX_ZERO]);
    if (config == nullptr) {
        napi_throw_error(env, nullptr, "Invalid config");
        return nullptr;
    }

    int32_t errata;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &errata);

    YGConfigSetErrata(config, static_cast<YGErrata>(errata));

    return nullptr;
}

// YGConfigGetErrata
napi_value YogaConfigNapi::NapiYGConfigGetErrata(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);

    YGConfigRef config = extractConfigRef(env, args[ARG_INDEX_ZERO]);
    if (config == nullptr) {
        napi_throw_error(env, nullptr, "Invalid config");
        return nullptr;
    }

    YGErrata errata = YGConfigGetErrata(config);

    napi_value result;
    napi_create_int32(env, static_cast<int32_t>(errata), &result);

    return result;
}

// YGConfigSetExperimentalFeatureEnabled
napi_value YogaConfigNapi::NapiYGConfigSetExperimentalFeatureEnabled(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGConfigRef config = extractConfigRef(env, args[ARG_INDEX_ZERO]);
    if (config == nullptr) {
        napi_throw_error(env, nullptr, "Invalid config");
        return nullptr;
    }

    int32_t feature;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &feature);

    bool enabled;
    napi_get_value_bool(env, args[ARG_INDEX_TWO], &enabled);

    YGConfigSetExperimentalFeatureEnabled(config, static_cast<YGExperimentalFeature>(feature), enabled);

    return nullptr;
}

}  // namespace YOGA_NAPI