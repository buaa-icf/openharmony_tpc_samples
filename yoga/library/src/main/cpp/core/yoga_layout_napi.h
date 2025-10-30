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

#ifndef OHOS_YOGA_LAYOUT_NAPI_H
#define OHOS_YOGA_LAYOUT_NAPI_H

#include "common.h"
#include <yoga/Yoga.h>

namespace YOGA_NAPI {
class YogaNodeMap;
class YogaLayoutNapi;
}  // namespace YOGA_NAPI

// Typedef for edge getter function pointer
typedef float (*EdgeGetter)(YGNodeConstRef, YGEdge);

namespace YOGA_NAPI {

// Helper class to manage layout data transfer from C++ to JS
class LayoutTransfer {
public:
    static void transferLayoutOutputsRecursive(napi_env env, YogaNodeMap *nodeMap, YGNodeRef root);

private:
    static void transferEdgeData(napi_env env, YGNodeRef node, napi_value layoutData, const char *propertyName,
                                 EdgeGetter getter);
};

class YogaLayoutNapi {
public:
    static napi_value NapiYGNodeCalculateLayout(napi_env env, napi_callback_info info);

private:
    static YGNodeRef extractNodeRef(napi_env env, napi_value nodeValue);
};

}  // namespace YOGA_NAPI

#endif  // OHOS_YOGA_LAYOUT_NAPI_H