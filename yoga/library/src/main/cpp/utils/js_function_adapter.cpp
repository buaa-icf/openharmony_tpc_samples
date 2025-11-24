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

#include "js_function_adapter.h"
#include "node_map.h"
#include "yoga_napi.h"
#include <cstring>

namespace YOGA_NAPI {

constexpr char YogaNapi::YG_CONFIG_REF[];
constexpr char YogaNapi::YG_NODE_REF[];
constexpr char YogaNapi::YG_LAYOUT[];
constexpr char YogaNapi::YG_VALUE[];
constexpr char YogaNapi::YG_VALUE_UNIT[];

// Static member definitions
std::unordered_map<YGNodeRef, napi_ref> JSFunctionAdapter::measureFuncMap;
std::unordered_map<YGNodeRef, napi_ref> JSFunctionAdapter::baselineFuncMap;

// Yoga callback function implementations
YGSize JSFunctionAdapter::MeasureCallback(YGNodeConstRef node, float width, YGMeasureMode widthMode, float height,
                                          YGMeasureMode heightMode)
{
    napi_env env = GetCurrentEnv();
    if (!env) {
        return GetDefaultSize(width, widthMode, height, heightMode);
    }

    YogaNodeMap *nodeMap = GetYogaNodeMap(env);
    if (!nodeMap) {
        return GetDefaultSize(width, widthMode, height, heightMode);
    }

    napi_value jsNode = nodeMap->getJsObject(const_cast<YGNodeRef>(node));
    if (!jsNode) {
        return GetDefaultSize(width, widthMode, height, heightMode);
    }

    napi_value measureFunc = GetStoredMeasureFunction(env, const_cast<YGNodeRef>(node));
    if (measureFunc == nullptr) {
        return GetDefaultSize(width, widthMode, height, heightMode);
    }

    napi_value args[ARG_COUNT_FIVE];
    args[ARG_INDEX_ZERO] = jsNode;
    napi_create_double(env, static_cast<double>(width), &args[ARG_INDEX_ONE]);
    napi_create_int32(env, static_cast<int32_t>(widthMode), &args[ARG_INDEX_TWO]);
    napi_create_double(env, static_cast<double>(height), &args[ARG_INDEX_THREE]);
    napi_create_int32(env, static_cast<int32_t>(heightMode), &args[ARG_INDEX_FOUR]);

    napi_value result;
    if (napi_call_function(env, jsNode, measureFunc, ARG_COUNT_FIVE, args, &result) == napi_ok) {
        int64_t measureResult;
        if (napi_get_value_int64(env, result, &measureResult) == napi_ok) {
            // Extract width and height from packed long value
            // Format: [32-bit width][32-bit height]
            uint32_t wBits = MASK_32_BITS & (measureResult >> SHIFT_32_BITS);
            uint32_t hBits = MASK_32_BITS & measureResult;
            float measuredWidth, measuredHeight;
            std::memcpy(&measuredWidth,  &wBits, sizeof(float));
            std::memcpy(&measuredHeight, &hBits, sizeof(float));
            return YGSize {measuredWidth, measuredHeight};
        }
    }

    return GetDefaultSize(width, widthMode, height, heightMode);
}

float JSFunctionAdapter::BaselineCallback(YGNodeConstRef node, float width, float height)
{
    napi_env env = GetCurrentEnv();
    if (!env) {
        return height;
    }

    YogaNodeMap *nodeMap = GetYogaNodeMap(env);
    if (!nodeMap) {
        return height;
    }

    napi_value jsNode = nodeMap->getJsObject(const_cast<YGNodeRef>(node));
    if (!jsNode) {
        return height;
    }

    napi_value baselineFunc = GetStoredBaselineFunction(env, const_cast<YGNodeRef>(node));
    if (baselineFunc == nullptr) {
        return height;
    }

    napi_value args[ARG_COUNT_THREE];
    args[ARG_INDEX_ZERO] = jsNode;
    napi_create_double(env, static_cast<double>(width), &args[ARG_INDEX_ONE]);
    napi_create_double(env, static_cast<double>(height), &args[ARG_INDEX_TWO]);

    napi_value result;
    if (napi_call_function(env, jsNode, baselineFunc, ARG_COUNT_THREE, args, &result) == napi_ok) {
        double baselineValue;
        if (napi_get_value_double(env, result, &baselineValue) == napi_ok) {
            return static_cast<float>(baselineValue);
        }
    }

    return height;
}

// Helper functions
void JSFunctionAdapter::StoreJSFunction(napi_env env, YGNodeRef node, napi_value func,
                                        std::unordered_map<YGNodeRef, napi_ref> &funcMap)
{
    if (node == nullptr || env == nullptr) {
        return;
    }

    // Remove old reference
    auto it = funcMap.find(node);
    if (it != funcMap.end()) {
        if (it->second) {
            napi_delete_reference(env, it->second);
        }
        funcMap.erase(it);
    }

    // Store new reference
    if (func != nullptr) {
        napi_ref ref;
        if (napi_create_reference(env, func, 0, &ref) == napi_ok && ref != nullptr) {
            funcMap[node] = ref;
        }
    }
}

napi_value JSFunctionAdapter::GetStoredJSFunction(napi_env env, YGNodeRef node,
                                                  const std::unordered_map<YGNodeRef, napi_ref> &funcMap)
{
    auto it = funcMap.find(node);
    if (it != funcMap.end()) {
        napi_value result;
        napi_get_reference_value(env, it->second, &result);
        return result;
    }
    return nullptr;
}

void JSFunctionAdapter::RemoveJSFunction(napi_env env, YGNodeRef node)
{
    auto measureFunc = measureFuncMap.find(node);
    if (measureFunc != measureFuncMap.end()) {
        if (measureFunc->second) {
            napi_delete_reference(env, measureFunc->second);
        }
        measureFuncMap.erase(measureFunc);
    }

    auto baselineFunc = baselineFuncMap.find(node);
    if (baselineFunc != baselineFuncMap.end()) {
        if (baselineFunc->second) {
            napi_delete_reference(env, baselineFunc->second);
        }
        baselineFuncMap.erase(baselineFunc);
    }
}

// Default size calculation
YGSize JSFunctionAdapter::GetDefaultSize(float width, YGMeasureMode widthMode, float height, YGMeasureMode heightMode)
{
    return YGSize {widthMode == YGMeasureModeUndefined ? 0 : width, heightMode == YGMeasureModeUndefined ? 0 : height};
}

}  // namespace YOGA_NAPI