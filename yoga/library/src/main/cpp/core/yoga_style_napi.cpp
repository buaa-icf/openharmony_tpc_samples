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

#include "yoga_style_napi.h"
#include "yoga_napi.h"
#include <hilog/log.h>

namespace YOGA_NAPI {

YGNodeRef YogaStyleNapi::extractNodeRef(napi_env env, napi_value nodeValue)
{
    return YogaNapi::extractNodeRef(env, nodeValue);
}

// YGNodeCopyStyle
napi_value YogaStyleNapi::NapiYGNodeCopyStyle(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef dstNode = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (dstNode == nullptr) {
        napi_throw_error(env, nullptr, "Invalid destination node");
        return nullptr;
    }

    YGNodeRef srcNode = extractNodeRef(env, args[ARG_INDEX_ONE]);
    if (srcNode == nullptr) {
        napi_throw_error(env, nullptr, "Invalid source node");
        return nullptr;
    }

    YGNodeCopyStyle(dstNode, srcNode);

    return nullptr;
}

#define CHECK_NODE(nodeVar)                             \
    if (nodeVar == nullptr) {                           \
        napi_throw_error(env, nullptr, "Invalid node"); \
        return nullptr;                                 \
    }

#define YG_NODE_NAPI_STYLE_ENUM_PROP(name, enumType)                                          \
    napi_value YogaStyleNapi::NapiYGNodeStyleSet##name(napi_env env, napi_callback_info info) \
    {                                                                                         \
        GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);                                      \
        YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);                           \
        CHECK_NODE(node);                                                                     \
        int32_t value;                                                                        \
        napi_get_value_int32(env, args[ARG_INDEX_ONE], &value);                               \
        YGNodeStyleSet##name(node, static_cast<enumType>(value));                             \
        return nullptr;                                                                       \
    }                                                                                         \
                                                                                              \
    napi_value YogaStyleNapi::NapiYGNodeStyleGet##name(napi_env env, napi_callback_info info) \
    {                                                                                         \
        GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);                                      \
        YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);                           \
        CHECK_NODE(node);                                                                     \
        auto value = YGNodeStyleGet##name(node);                                              \
        napi_value result;                                                                    \
        napi_create_int32(env, static_cast<int32_t>(value), &result);                         \
        return result;                                                                        \
    }

#define YG_NODE_NAPI_STYLE_FLOAT_PROP(name)                                                   \
    napi_value YogaStyleNapi::NapiYGNodeStyleSet##name(napi_env env, napi_callback_info info) \
    {                                                                                         \
        GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);                                      \
        YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);                           \
        CHECK_NODE(node);                                                                     \
        double value;                                                                         \
        napi_get_value_double(env, args[ARG_INDEX_ONE], &value);                              \
        YGNodeStyleSet##name(node, static_cast<float>(value));                                \
        return nullptr;                                                                       \
    }                                                                                         \
                                                                                              \
    napi_value YogaStyleNapi::NapiYGNodeStyleGet##name(napi_env env, napi_callback_info info) \
    {                                                                                         \
        GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);                                      \
        YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);                           \
        CHECK_NODE(node);                                                                     \
        float value = YGNodeStyleGet##name(node);                                             \
        napi_value result;                                                                    \
        napi_create_double(env, static_cast<double>(value), &result);                         \
        return result;                                                                        \
    }

#define YG_NODE_NAPI_STYLE_UNIT_PROP(name)                                                             \
    napi_value YogaStyleNapi::NapiYGNodeStyleGet##name(napi_env env, napi_callback_info info)          \
    {                                                                                                  \
        GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);                                               \
        YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);                                    \
        CHECK_NODE(node);                                                                              \
        YGValue value = YGNodeStyleGet##name(node);                                                    \
        return CreateYogaValue(env, value);                                                            \
    }                                                                                                  \
                                                                                                       \
    napi_value YogaStyleNapi::NapiYGNodeStyleSet##name(napi_env env, napi_callback_info info)          \
    {                                                                                                  \
        GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);                                               \
        YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);                                    \
        CHECK_NODE(node);                                                                              \
        double value;                                                                                  \
        napi_get_value_double(env, args[ARG_INDEX_ONE], &value);                                       \
        YGNodeStyleSet##name(node, static_cast<float>(value));                                         \
        return nullptr;                                                                                \
    }                                                                                                  \
                                                                                                       \
    napi_value YogaStyleNapi::NapiYGNodeStyleSet##name##Percent(napi_env env, napi_callback_info info) \
    {                                                                                                  \
        GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);                                               \
        YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);                                    \
        CHECK_NODE(node);                                                                              \
        double value;                                                                                  \
        napi_get_value_double(env, args[ARG_INDEX_ONE], &value);                                       \
        YGNodeStyleSet##name##Percent(node, static_cast<float>(value));                                \
        return nullptr;                                                                                \
    }

#define YG_NODE_NAPI_STYLE_UNIT_PROP_AUTO(name)                                                     \
    YG_NODE_NAPI_STYLE_UNIT_PROP(name)                                                              \
    napi_value YogaStyleNapi::NapiYGNodeStyleSet##name##Auto(napi_env env, napi_callback_info info) \
    {                                                                                               \
        GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_ONE);                                            \
        YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);                                 \
        CHECK_NODE(node);                                                                           \
        YGNodeStyleSet##name##Auto(node);                                                           \
        return nullptr;                                                                             \
    }

YG_NODE_NAPI_STYLE_ENUM_PROP(Direction, YGDirection)
YG_NODE_NAPI_STYLE_ENUM_PROP(FlexDirection, YGFlexDirection)
YG_NODE_NAPI_STYLE_ENUM_PROP(JustifyContent, YGJustify)
YG_NODE_NAPI_STYLE_ENUM_PROP(AlignItems, YGAlign)
YG_NODE_NAPI_STYLE_ENUM_PROP(AlignSelf, YGAlign)
YG_NODE_NAPI_STYLE_ENUM_PROP(AlignContent, YGAlign)
YG_NODE_NAPI_STYLE_ENUM_PROP(PositionType, YGPositionType)
YG_NODE_NAPI_STYLE_ENUM_PROP(BoxSizing, YGBoxSizing)
YG_NODE_NAPI_STYLE_ENUM_PROP(FlexWrap, YGWrap)
YG_NODE_NAPI_STYLE_ENUM_PROP(Overflow, YGOverflow)
YG_NODE_NAPI_STYLE_ENUM_PROP(Display, YGDisplay)
YG_NODE_NAPI_STYLE_FLOAT_PROP(Flex)
YG_NODE_NAPI_STYLE_FLOAT_PROP(FlexGrow)
YG_NODE_NAPI_STYLE_FLOAT_PROP(FlexShrink)
YG_NODE_NAPI_STYLE_FLOAT_PROP(AspectRatio)

YG_NODE_NAPI_STYLE_UNIT_PROP_AUTO(FlexBasis)
YG_NODE_NAPI_STYLE_UNIT_PROP_AUTO(Width)
YG_NODE_NAPI_STYLE_UNIT_PROP_AUTO(Height)

YG_NODE_NAPI_STYLE_UNIT_PROP(MinWidth)
YG_NODE_NAPI_STYLE_UNIT_PROP(MaxWidth)
YG_NODE_NAPI_STYLE_UNIT_PROP(MinHeight)
YG_NODE_NAPI_STYLE_UNIT_PROP(MaxHeight)

// YGNodeStyleSetPosition
napi_value YogaStyleNapi::NapiYGNodeStyleSetPosition(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    double position;
    napi_get_value_double(env, args[ARG_INDEX_TWO], &position);

    YGNodeStyleSetPosition(node, static_cast<YGEdge>(edge), static_cast<float>(position));

    return nullptr;
}

// YGNodeStyleSetPositionPercent
napi_value YogaStyleNapi::NapiYGNodeStyleSetPositionPercent(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    double position;
    napi_get_value_double(env, args[ARG_INDEX_TWO], &position);

    YGNodeStyleSetPositionPercent(node, static_cast<YGEdge>(edge), static_cast<float>(position));

    return nullptr;
}

// YGNodeStyleSetPositionAuto
napi_value YogaStyleNapi::NapiYGNodeStyleSetPositionAuto(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    YGNodeStyleSetPositionAuto(node, static_cast<YGEdge>(edge));

    return nullptr;
}

// YGNodeStyleSetMargin
napi_value YogaStyleNapi::NapiYGNodeStyleSetMargin(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    double margin;
    napi_get_value_double(env, args[ARG_INDEX_TWO], &margin);

    YGNodeEdges {node}.add(YGNodeEdges::MARGIN).setOn(node);

    YGNodeStyleSetMargin(node, static_cast<YGEdge>(edge), static_cast<float>(margin));

    return nullptr;
}

// YGNodeStyleSetMarginPercent
napi_value YogaStyleNapi::NapiYGNodeStyleSetMarginPercent(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    double margin;
    napi_get_value_double(env, args[ARG_INDEX_TWO], &margin);

    YGNodeEdges {node}.add(YGNodeEdges::MARGIN).setOn(node);

    YGNodeStyleSetMarginPercent(node, static_cast<YGEdge>(edge), static_cast<float>(margin));

    return nullptr;
}

// YGNodeStyleSetMarginAuto
napi_value YogaStyleNapi::NapiYGNodeStyleSetMarginAuto(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    YGNodeEdges {node}.add(YGNodeEdges::MARGIN).setOn(node);

    YGNodeStyleSetMarginAuto(node, static_cast<YGEdge>(edge));

    return nullptr;
}

// YGNodeStyleSetPadding
napi_value YogaStyleNapi::NapiYGNodeStyleSetPadding(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    double padding;
    napi_get_value_double(env, args[ARG_INDEX_TWO], &padding);

    YGNodeEdges {node}.add(YGNodeEdges::PADDING).setOn(node);

    YGNodeStyleSetPadding(node, static_cast<YGEdge>(edge), static_cast<float>(padding));

    return nullptr;
}

// YGNodeStyleSetPaddingPercent
napi_value YogaStyleNapi::NapiYGNodeStyleSetPaddingPercent(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    double padding;
    napi_get_value_double(env, args[ARG_INDEX_TWO], &padding);

    YGNodeEdges {node}.add(YGNodeEdges::PADDING).setOn(node);

    YGNodeStyleSetPaddingPercent(node, static_cast<YGEdge>(edge), static_cast<float>(padding));

    return nullptr;
}

// YGNodeStyleSetBorder
napi_value YogaStyleNapi::NapiYGNodeStyleSetBorder(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    double border;
    napi_get_value_double(env, args[ARG_INDEX_TWO], &border);

    YGNodeEdges {node}.add(YGNodeEdges::BORDER).setOn(node);

    YGNodeStyleSetBorder(node, static_cast<YGEdge>(edge), static_cast<float>(border));

    return nullptr;
}

// YGNodeStyleSetGap
napi_value YogaStyleNapi::NapiYGNodeStyleSetGap(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t gutter;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &gutter);

    double gapLength;
    napi_get_value_double(env, args[ARG_INDEX_TWO], &gapLength);

    YGNodeStyleSetGap(node, static_cast<YGGutter>(gutter), static_cast<float>(gapLength));

    return nullptr;
}

// YGNodeStyleSetGapPercent
napi_value YogaStyleNapi::NapiYGNodeStyleSetGapPercent(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_THREE);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t gutter;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &gutter);

    double gapLength;
    napi_get_value_double(env, args[ARG_INDEX_TWO], &gapLength);

    YGNodeStyleSetGapPercent(node, static_cast<YGGutter>(gutter), static_cast<float>(gapLength));

    return nullptr;
}

// YGNodeStyleGetPosition
napi_value YogaStyleNapi::NapiYGNodeStyleGetPosition(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    YGValue position = YGNodeStyleGetPosition(node, static_cast<YGEdge>(edge));

    return CreateYogaValue(env, position);
}

// YGNodeStyleGetMargin
napi_value YogaStyleNapi::NapiYGNodeStyleGetMargin(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    YGValue margin = YGNodeStyleGetMargin(node, static_cast<YGEdge>(edge));

    return CreateYogaValue(env, margin);
}

// YGNodeStyleGetPadding
napi_value YogaStyleNapi::NapiYGNodeStyleGetPadding(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    YGValue padding = YGNodeStyleGetPadding(node, static_cast<YGEdge>(edge));

    return CreateYogaValue(env, padding);
}

// YGNodeStyleGetBorder
napi_value YogaStyleNapi::NapiYGNodeStyleGetBorder(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t edge;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &edge);

    float border = YGNodeStyleGetBorder(node, static_cast<YGEdge>(edge));

    napi_value result;
    napi_create_double(env, static_cast<double>(border), &result);

    return result;
}

// YGNodeStyleGetGap
napi_value YogaStyleNapi::NapiYGNodeStyleGetGap(napi_env env, napi_callback_info info)
{
    GET_PARAMS_WITH_CHECK(env, info, ARG_COUNT_TWO);

    YGNodeRef node = extractNodeRef(env, args[ARG_INDEX_ZERO]);
    if (node == nullptr) {
        napi_throw_error(env, nullptr, "Invalid node");
        return nullptr;
    }

    int32_t gutter;
    napi_get_value_int32(env, args[ARG_INDEX_ONE], &gutter);

    float gap = YGNodeStyleGetGap(node, static_cast<YGGutter>(gutter));

    napi_value result;
    napi_create_double(env, static_cast<double>(gap), &result);

    return result;
}

}  // namespace YOGA_NAPI