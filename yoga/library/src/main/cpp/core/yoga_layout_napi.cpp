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

#include "yoga_layout_napi.h"
#include "yoga_napi.h"
#include "utils/node_map.h"
#include <hilog/log.h>

namespace YOGA_NAPI {

// Utility functions
YGNodeRef YogaLayoutNapi::extractNodeRef(napi_env env, napi_value nodeValue)
{
    return YogaNapi::extractNodeRef(env, nodeValue);
}

// Helper function to transfer edge data (margin, padding, border)
void LayoutTransfer::transferEdgeData(napi_env env, YGNodeRef node, napi_value layoutData, const char *propertyName,
                                      EdgeGetter getter)
{
    napi_value edgeData;
    napi_create_object(env, &edgeData);

    napi_value left, top, right, bottom;
    napi_create_double(env, static_cast<double>(getter(node, YGEdgeLeft)), &left);
    napi_create_double(env, static_cast<double>(getter(node, YGEdgeTop)), &top);
    napi_create_double(env, static_cast<double>(getter(node, YGEdgeRight)), &right);
    napi_create_double(env, static_cast<double>(getter(node, YGEdgeBottom)), &bottom);

    napi_set_named_property(env, edgeData, "left", left);
    napi_set_named_property(env, edgeData, "top", top);
    napi_set_named_property(env, edgeData, "right", right);
    napi_set_named_property(env, edgeData, "bottom", bottom);

    napi_set_named_property(env, layoutData, propertyName, edgeData);
}

void LayoutTransfer::transferLayoutOutputsRecursive(napi_env env, YogaNodeMap *nodeMap, YGNodeRef root)
{
    if (!YGNodeGetHasNewLayout(root)) {
        return;
    }

    napi_value jsNode = nodeMap->getJsObject(root);
    if (!jsNode) {
        OH_LOG_WARN(LOG_APP, "JS object not found for Yoga node during layout transfer");
        return;
    }

    napi_value layoutData;
    napi_create_object(env, &layoutData);

    napi_value hasNewLayout;
    napi_get_boolean(env, true, &hasNewLayout);
    napi_set_named_property(env, layoutData, "hasNewLayout", hasNewLayout);

    // Position and dimensions
    napi_value left, top, width, height, direction;
    napi_create_double(env, static_cast<double>(YGNodeLayoutGetLeft(root)), &left);
    napi_create_double(env, static_cast<double>(YGNodeLayoutGetTop(root)), &top);
    napi_create_double(env, static_cast<double>(YGNodeLayoutGetWidth(root)), &width);
    napi_create_double(env, static_cast<double>(YGNodeLayoutGetHeight(root)), &height);
    napi_create_int32(env, static_cast<int32_t>(YGNodeLayoutGetDirection(root)), &direction);

    napi_set_named_property(env, layoutData, "left", left);
    napi_set_named_property(env, layoutData, "top", top);
    napi_set_named_property(env, layoutData, "width", width);
    napi_set_named_property(env, layoutData, "height", height);
    napi_set_named_property(env, layoutData, "direction", direction);

    YGNodeEdges edgesSet {root};

    if (edgesSet.has(YGNodeEdges::MARGIN)) {
        transferEdgeData(env, root, layoutData, "margin", YGNodeLayoutGetMargin);
    }
    if (edgesSet.has(YGNodeEdges::PADDING)) {
        transferEdgeData(env, root, layoutData, "padding", YGNodeLayoutGetPadding);
    }
    if (edgesSet.has(YGNodeEdges::BORDER)) {
        transferEdgeData(env, root, layoutData, "border", YGNodeLayoutGetBorder);
    }

    napi_set_named_property(env, jsNode, YogaNapi::YG_LAYOUT, layoutData);

    YGNodeSetHasNewLayout(root, false);

    // --- Recursively transfer layout for children ---
    for (size_t i = 0; i < YGNodeGetChildCount(root); i++) {
        transferLayoutOutputsRecursive(env, nodeMap, YGNodeGetChild(root, i));
    }
}

// YGNodeCalculateLayout
napi_value YogaLayoutNapi::NapiYGNodeCalculateLayout(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef root = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (root == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    double availableWidth, availableHeight;
    napi_status status_width = napi_get_value_double(env, args[ARG_INDEX_ONE], &availableWidth);
    napi_status status_height = napi_get_value_double(env, args[ARG_INDEX_TWO], &availableHeight);

    if (status_width != napi_ok || status_height != napi_ok) {
        napi_throw_error(env, nullptr, "Invalid width or height argument");
        return nullptr;
    }

    YogaNodeMap *nodeMap = GetYogaNodeMap(env);
    if (!nodeMap) {
        napi_throw_error(env, nullptr, "NodeMap not initialized for this thread");
        return nullptr;
    }

    YGNodeCalculateLayout(root, static_cast<float>(availableWidth), static_cast<float>(availableHeight),
                          YGNodeStyleGetDirection(root));

    LayoutTransfer::transferLayoutOutputsRecursive(env, nodeMap, root);

    return nullptr;
}

}  // namespace YOGA_NAPI