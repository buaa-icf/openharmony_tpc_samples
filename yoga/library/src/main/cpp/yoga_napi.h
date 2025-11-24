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

#ifndef OHOS_YOGA_NAPI_H
#define OHOS_YOGA_NAPI_H

#include "common.h"
#include <yoga/Yoga.h>
#include <unordered_map>
#include <string>

namespace YOGA_NAPI {

// Forward declarations for modules
class YogaConfigNapi;
class YogaNodeNapi;
class YogaStyleNapi;
class YogaLayoutNapi;
// Helper classes
class JSFunctionAdapter;
class YogaNodeMap;

union YGNodeContext {
    int32_t edgesSet = 0;
    void *asVoidPtr;
};

// Utility classes
class YGNodeEdges {
    int32_t flags_;

public:
    enum Edge {
        MARGIN = 1,
        PADDING = 2,
        BORDER = 4,
    };

    explicit YGNodeEdges(YGNodeRef node)
    {
        auto context = YGNodeContext {};
        context.asVoidPtr = YGNodeGetContext(node);
        flags_ = context.edgesSet;
    }

    void setOn(YGNodeRef node)
    {
        auto context = YGNodeContext {};
        context.edgesSet = flags_;
        YGNodeSetContext(node, context.asVoidPtr);
    }

    bool has(Edge edge)
    {
        return (flags_ & edge) == edge;
    }

    YGNodeEdges &add(Edge edge)
    {
        flags_ |= edge;
        return *this;
    }

    int get()
    {
        return flags_;
    }
};

// Main coordinator class
class YogaNapi {
public:
    static constexpr char YG_CONFIG_REF[] = "_configRef";
    static constexpr char YG_NODE_REF[] = "_nodeRef";
    static constexpr char YG_LAYOUT[] = "_layout";
    static constexpr char YG_VALUE[] = "value";
    static constexpr char YG_VALUE_UNIT[] = "unit";

    // Utility functions
    static YGConfigRef extractConfigRef(napi_env env, napi_value configValue);
    static YGNodeRef extractNodeRef(napi_env env, napi_value nodeValue);
    static void setConfigRef(napi_env env, napi_value configValue, YGConfigRef config);
    static void setNodeRef(napi_env env, napi_value nodeValue, YGNodeRef node);
};

}  // namespace YOGA_NAPI

#endif  // OHOS_YOGA_NAPI_H