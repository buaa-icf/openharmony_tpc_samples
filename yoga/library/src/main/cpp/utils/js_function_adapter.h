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

#ifndef OHOS_JS_FUNCTION_ADAPTER_H
#define OHOS_JS_FUNCTION_ADAPTER_H

#include "common.h"
#include <yoga/Yoga.h>
#include <unordered_map>

namespace YOGA_NAPI {

class JSFunctionAdapter {
public:
    // Measure function management
    static void StoreMeasureFunction(napi_env env, YGNodeRef node, napi_value measureFunc)
    {
        StoreJSFunction(env, node, measureFunc, measureFuncMap);
    }
    static napi_value GetStoredMeasureFunction(napi_env env, YGNodeRef node)
    {
        return GetStoredJSFunction(env, node, measureFuncMap);
    }

    // Baseline function management
    static void StoreBaselineFunction(napi_env env, YGNodeRef node, napi_value baselineFunc)
    {
        StoreJSFunction(env, node, baselineFunc, baselineFuncMap);
    }
    static napi_value GetStoredBaselineFunction(napi_env env, YGNodeRef node)
    {
        return GetStoredJSFunction(env, node, baselineFuncMap);
    }

    static void RemoveJSFunction(napi_env env, YGNodeRef node);

    static YGSize MeasureCallback(YGNodeConstRef node, float width, YGMeasureMode widthMode, float height,
                                  YGMeasureMode heightMode);
    static float BaselineCallback(YGNodeConstRef node, float width, float height);

private:
    static std::unordered_map<YGNodeRef, napi_ref> measureFuncMap;
    static std::unordered_map<YGNodeRef, napi_ref> baselineFuncMap;

    // Helper functions
    static void StoreJSFunction(napi_env env, YGNodeRef node, napi_value func,
                                std::unordered_map<YGNodeRef, napi_ref> &funcMap);
    static napi_value GetStoredJSFunction(napi_env env, YGNodeRef node,
                                          const std::unordered_map<YGNodeRef, napi_ref> &funcMap);

    // Default size calculation
    static YGSize GetDefaultSize(float width, YGMeasureMode widthMode, float height, YGMeasureMode heightMode);
};

}  // namespace YOGA_NAPI

#endif  // OHOS_JS_FUNCTION_ADAPTER_H