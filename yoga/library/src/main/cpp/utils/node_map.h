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

#ifndef OHOS_YOGA_NODE_MAP_H
#define OHOS_YOGA_NODE_MAP_H

#include "common.h"
#include <yoga/Yoga.h>
#include <unordered_map>

namespace YOGA_NAPI {

class YogaNodeMap {
private:
    std::unordered_map<YGNodeRef, napi_ref> nodeToJsRefMap;
    napi_env env;

public:
    explicit YogaNodeMap(napi_env environment) : env(environment) {}
    ~YogaNodeMap();

    void addNodeMapping(YGNodeRef node, napi_value jsObject);
    napi_value getJsObject(YGNodeRef node);
    napi_env getEnv() const
    {
        return env;
    }
    void removeNodeMapping(YGNodeRef node);
    void removeAll();
};

// Global instance management
napi_env GetCurrentEnv();
YogaNodeMap *GetYogaNodeMap(napi_env env);

}  // namespace YOGA_NAPI

#endif  // OHOS_YOGA_NODE_MAP_H