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

#include "node_map.h"
#include "yoga_napi.h"
#include <hilog/log.h>
#include <memory>

namespace YOGA_NAPI {

// Thread-local storage for NodeMap instance
// Using thread_local to ensure thread safety in multi-threaded environments
static thread_local std::unique_ptr<YogaNodeMap> g_nodeMap = nullptr;

YogaNodeMap::~YogaNodeMap()
{
    removeAll();
}

void YogaNodeMap::addNodeMapping(YGNodeRef node, napi_value jsObject)
{
    if (node == nullptr || jsObject == nullptr) {
        return;
    }

    // Remove old reference if exists
    auto it = nodeToJsRefMap.find(node);
    if (it != nodeToJsRefMap.end() && it->second) {
        napi_delete_reference(env, it->second);
        nodeToJsRefMap.erase(it);
    }

    // Create new reference
    napi_ref ref = nullptr;
    napi_status status = napi_create_reference(env, jsObject, 0, &ref);
    if (status == napi_ok && ref != nullptr) {
        nodeToJsRefMap[node] = ref;
    } else {
        OH_LOG_Print(LOG_APP, LOG_WARN, 0, YOGA_LOG_TAG, "Failed to create JS reference for node");
    }
}

napi_value YogaNodeMap::getJsObject(YGNodeRef node)
{
    auto it = nodeToJsRefMap.find(node);
    if (it != nodeToJsRefMap.end()) {
        napi_value result;
        napi_status status = napi_get_reference_value(env, it->second, &result);
        if (status == napi_ok) {
            return result;
        } else {
            OH_LOG_Print(LOG_APP, LOG_WARN, 0, YOGA_LOG_TAG, "Failed to get JS value from reference");
        }
    }
    return nullptr;
}

void YogaNodeMap::removeNodeMapping(YGNodeRef node)
{
    auto it = nodeToJsRefMap.find(node);
    if (it != nodeToJsRefMap.end() && it->second) {
        napi_delete_reference(env, it->second);
        nodeToJsRefMap.erase(it);
    }
}

void YogaNodeMap::removeAll()
{
    if (!nodeToJsRefMap.empty()) {
        for (auto &pair : nodeToJsRefMap) {
            if (pair.second) {
                napi_delete_reference(env, pair.second);
            }
        }
        nodeToJsRefMap.clear();
    }
}

// Global instance management
napi_env GetCurrentEnv()
{
    if (g_nodeMap) {
        return g_nodeMap->getEnv();
    }
    return nullptr;
}

YogaNodeMap *GetYogaNodeMap(napi_env env)
{
    if (!g_nodeMap) {
        g_nodeMap = std::make_unique<YogaNodeMap>(env);
    }
    return g_nodeMap.get();
}

}  // namespace YOGA_NAPI