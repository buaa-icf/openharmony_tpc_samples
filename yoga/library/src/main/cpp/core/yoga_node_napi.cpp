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

#include "yoga_node_napi.h"
#include "yoga_napi.h"
#include "utils/js_function_adapter.h"
#include "utils/node_map.h"

namespace YOGA_NAPI {

// Utility functions
YGNodeRef YogaNodeNapi::extractNodeRef(napi_env env, napi_value nodeValue)
{
    return YogaNapi::extractNodeRef(env, nodeValue);
}

void YogaNodeNapi::setNodeRef(napi_env env, napi_value nodeValue, YGNodeRef node)
{
    YogaNapi::setNodeRef(env, nodeValue, node);
}

// YGNodeNew
napi_value YogaNodeNapi::NapiYGNodeNew(napi_env env, napi_callback_info info)
{
    YGNodeRef node = YGNodeNew();
    YGNodeSetContext(node, YGNodeContext {}.asVoidPtr);

    napi_value nodeObject;
    napi_create_object(env, &nodeObject);
    setNodeRef(env, nodeObject, node);

    return nodeObject;
}

// YGNodeNewWithConfig
napi_value YogaNodeNapi::NapiYGNodeNewWithConfig(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);

    YGConfigRef config = YogaNapi::extractConfigRef(env, args[ARG_INDEX_ZERO]);
    if (config == nullptr) {
        napi_throw_error(env, nullptr, "Invalid config");
        return nullptr;
    }

    YGNodeRef node = YGNodeNewWithConfig(config);
    YGNodeSetContext(node, YGNodeContext {}.asVoidPtr);

    napi_value nodeObject;
    napi_create_object(env, &nodeObject);
    setNodeRef(env, nodeObject, node);

    return nodeObject;
}

// YGNodeClone
napi_value YogaNodeNapi::NapiYGNodeClone(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    YGNodeRef newNode = YGNodeClone(node);
    YGNodeSetContext(newNode, YGNodeGetContext(node));

    napi_value newNodeObject;
    napi_create_object(env, &newNodeObject);
    setNodeRef(env, newNodeObject, newNode);

    return newNodeObject;
}

// YGNodeReset
napi_value YogaNodeNapi::NapiYGNodeReset(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    JSFunctionAdapter::StoreMeasureFunction(env, node, nullptr);
    JSFunctionAdapter::StoreBaselineFunction(env, node, nullptr);

    void *context = YGNodeGetContext(node);
    YGNodeReset(node);
    YGNodeSetContext(node, context);

    return nullptr;
}

// YGNodeIsDirty
napi_value YogaNodeNapi::NapiYGNodeIsDirty(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    bool isDirty = YGNodeIsDirty(node);
    napi_value result;
    napi_get_boolean(env, isDirty, &result);

    return result;
}

// YGNodeMarkDirty
napi_value YogaNodeNapi::NapiYGNodeMarkDirty(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    YGNodeMarkDirty(node);

    return nullptr;
}

// YGNodeInsertChild
napi_value YogaNodeNapi::NapiYGNodeInsertChild(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef parentNode = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (parentNode == nullptr) {
        napi_throw_error(env, nullptr, "Invalid parent node");
        return nullptr;
    }

    YGNodeRef childNode = extractNodeRef(env, args[ARG_INDEX_ONE]);
    if (childNode == nullptr) {
        napi_throw_error(env, nullptr, "Invalid child node");
        return nullptr;
    }

    uint32_t index;
    napi_get_value_uint32(env, args[ARG_INDEX_TWO], &index);

    YGNodeInsertChild(parentNode, childNode, static_cast<size_t>(index));

    return nullptr;
}

// YGNodeSwapChild
napi_value YogaNodeNapi::NapiYGNodeSwapChild(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef parentNode = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (parentNode == nullptr) {
        napi_throw_error(env, nullptr, "Invalid parent node");
        return nullptr;
    }

    YGNodeRef childNode = extractNodeRef(env, args[ARG_INDEX_ONE]);
    if (childNode == nullptr) {
        napi_throw_error(env, nullptr, "Invalid child node");
        return nullptr;
    }

    uint32_t index;
    napi_get_value_uint32(env, args[ARG_INDEX_TWO], &index);

    YGNodeSwapChild(parentNode, childNode, static_cast<size_t>(index));

    return nullptr;
}

// YGNodeRemoveChild
napi_value YogaNodeNapi::NapiYGNodeRemoveChild(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef parentNode = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (parentNode == nullptr) {
        napi_throw_error(env, nullptr, "Invalid parent node");
        return nullptr;
    }

    YGNodeRef childNode = extractNodeRef(env, args[ARG_INDEX_ONE]);
    if (childNode == nullptr) {
        napi_throw_error(env, nullptr, "Invalid child node");
        return nullptr;
    }

    YGNodeRemoveChild(parentNode, childNode);

    return nullptr;
}

// YGNodeRemoveAllChildren
napi_value YogaNodeNapi::NapiYGNodeRemoveAllChildren(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    YGNodeRemoveAllChildren(node);

    return nullptr;
}

// YGNodeSetIsReferenceBaseline
napi_value YogaNodeNapi::NapiYGNodeSetIsReferenceBaseline(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    bool isReferenceBaseline;
    napi_get_value_bool(env, args[ARG_INDEX_ONE], &isReferenceBaseline);

    YGNodeSetIsReferenceBaseline(node, isReferenceBaseline);

    return nullptr;
}

// YGNodeIsReferenceBaseline
napi_value YogaNodeNapi::NapiYGNodeIsReferenceBaseline(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    bool isReferenceBaseline = YGNodeIsReferenceBaseline(node);

    napi_value result;
    napi_get_boolean(env, isReferenceBaseline, &result);

    return result;
}

// YGNodeSetAlwaysFormsContainingBlock
napi_value YogaNodeNapi::NapiYGNodeSetAlwaysFormsContainingBlock(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    bool alwaysFormsContainingBlock;
    napi_get_value_bool(env, args[ARG_INDEX_ONE], &alwaysFormsContainingBlock);

    YGNodeSetAlwaysFormsContainingBlock(node, alwaysFormsContainingBlock);

    return nullptr;
}

// YGNodeSetMeasureFunc
napi_value YogaNodeNapi::NapiYGNodeSetMeasureFunc(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    napi_valuetype valueType;
    napi_status status = napi_typeof(env, args[ARG_INDEX_ONE], &valueType);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to get argument type");
        return nullptr;
    }

    if (valueType == napi_function) {
        JSFunctionAdapter::StoreMeasureFunction(env, node, args[ARG_INDEX_ONE]);
        YGNodeSetMeasureFunc(node, JSFunctionAdapter::MeasureCallback);
    } else {
        JSFunctionAdapter::StoreMeasureFunction(env, node, nullptr);
        YGNodeSetMeasureFunc(node, nullptr);
    }

    return nullptr;
}

// YGNodeSetBaselineFunc
napi_value YogaNodeNapi::NapiYGNodeSetBaselineFunc(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    napi_valuetype valueType;
    napi_status status = napi_typeof(env, args[ARG_INDEX_ONE], &valueType);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Failed to get argument type");
        return nullptr;
    }

    if (valueType == napi_function) {
        JSFunctionAdapter::StoreBaselineFunction(env, node, args[ARG_INDEX_ONE]);
        YGNodeSetBaselineFunc(node, JSFunctionAdapter::BaselineCallback);
    } else {
        JSFunctionAdapter::StoreBaselineFunction(env, node, nullptr);
        YGNodeSetBaselineFunc(node, nullptr);
    }

    return nullptr;
}

}  // namespace YOGA_NAPI