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

#include "yoga_napi.h"
#include "utils/js_function_adapter.h"
#include "utils/node_map.h"
#include "common.h"
#include <yoga/Yoga.h>
#include <unordered_map>
#include <string>
#include <hilog/log.h>

namespace YOGA_NAPI {

// Utility function implementations
napi_value CreateYogaValue(napi_env env, YGValue value)
{
    napi_value result;
    napi_create_object(env, &result);

    napi_value valueProp;
    napi_create_double(env, static_cast<double>(value.value), &valueProp);
    napi_set_named_property(env, result, YogaNapi::YG_VALUE, valueProp);

    napi_value unitProp;
    napi_create_int32(env, static_cast<int32_t>(value.unit), &unitProp);
    napi_set_named_property(env, result, YogaNapi::YG_VALUE_UNIT, unitProp);

    return result;
}

// Utility functions
YGConfigRef YogaNapi::extractConfigRef(napi_env env, napi_value configValue)
{
    return ExtractRefPtr<YGConfig>(env, configValue, YG_CONFIG_REF);
}

YGNodeRef YogaNapi::extractNodeRef(napi_env env, napi_value nodeValue)
{
    return ExtractRefPtr<YGNode>(env, nodeValue, YG_NODE_REF);
}

void YogaNapi::setConfigRef(napi_env env, napi_value configValue, YGConfigRef config)
{
    napi_value external;
    napi_create_external(env, config, nullptr, nullptr, &external);
    napi_set_named_property(env, configValue, YG_CONFIG_REF, external);
}

void YogaNapi::setNodeRef(napi_env env, napi_value nodeValue, YGNodeRef node)
{
    napi_value external;
    napi_create_external(env, node, nullptr, nullptr, &external);
    napi_set_named_property(env, nodeValue, YG_NODE_REF, external);

    GetYogaNodeMap(env)->addNodeMapping(node, nodeValue);
}

}  // namespace YOGA_NAPI