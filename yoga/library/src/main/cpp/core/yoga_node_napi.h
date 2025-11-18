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

#ifndef OHOS_YOGA_NODE_NAPI_H
#define OHOS_YOGA_NODE_NAPI_H

#include "common.h"
#include <yoga/Yoga.h>

namespace YOGA_NAPI {

class YogaNodeNapi {
public:
    // Node
    static napi_value NapiYGNodeNew(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeFree(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeNewWithConfig(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeClone(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeReset(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeIsDirty(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeMarkDirty(napi_env env, napi_callback_info info);

    // children
    static napi_value NapiYGNodeInsertChild(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeSwapChild(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeRemoveChild(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeRemoveAllChildren(napi_env env, napi_callback_info info);

    // Node style
    static napi_value NapiYGNodeSetIsReferenceBaseline(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeIsReferenceBaseline(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeSetAlwaysFormsContainingBlock(napi_env env, napi_callback_info info);

    // CB Functions
    static napi_value NapiYGNodeSetMeasureFunc(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeSetBaselineFunc(napi_env env, napi_callback_info info);

private:
    static YGNodeRef extractNodeRef(napi_env env, napi_value nodeValue);
    static void setNodeRef(napi_env env, napi_value nodeValue, YGNodeRef node);
};

}  // namespace YOGA_NAPI

#endif  // OHOS_YOGA_NODE_NAPI_H