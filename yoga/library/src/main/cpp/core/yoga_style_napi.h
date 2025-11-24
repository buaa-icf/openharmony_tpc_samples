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

#ifndef OHOS_YOGA_STYLE_NAPI_H
#define OHOS_YOGA_STYLE_NAPI_H

#include "common.h"
#include <yoga/Yoga.h>

namespace YOGA_NAPI {

// Style
class YogaStyleNapi {
public:
    // Copy Style
    static napi_value NapiYGNodeCopyStyle(napi_env env, napi_callback_info info);

    // Layout Direction
    static napi_value NapiYGNodeStyleSetDirection(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetDirection(napi_env env, napi_callback_info info);

    // Flex Direction
    static napi_value NapiYGNodeStyleSetFlexDirection(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetFlexDirection(napi_env env, napi_callback_info info);

    // Justify Content
    static napi_value NapiYGNodeStyleSetJustifyContent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetJustifyContent(napi_env env, napi_callback_info info);

    // Align Content
    static napi_value NapiYGNodeStyleSetAlignContent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetAlignContent(napi_env env, napi_callback_info info);

    // Align Items
    static napi_value NapiYGNodeStyleSetAlignItems(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetAlignItems(napi_env env, napi_callback_info info);

    // Align Self
    static napi_value NapiYGNodeStyleSetAlignSelf(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetAlignSelf(napi_env env, napi_callback_info info);

    // Position Type
    static napi_value NapiYGNodeStyleSetPositionType(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetPositionType(napi_env env, napi_callback_info info);

    // Flex Wrap
    static napi_value NapiYGNodeStyleSetFlexWrap(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetFlexWrap(napi_env env, napi_callback_info info);

    // Overflow
    static napi_value NapiYGNodeStyleSetOverflow(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetOverflow(napi_env env, napi_callback_info info);

    // Display
    static napi_value NapiYGNodeStyleSetDisplay(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetDisplay(napi_env env, napi_callback_info info);

    // Flex
    static napi_value NapiYGNodeStyleSetFlex(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetFlex(napi_env env, napi_callback_info info);

    // Flex Grow
    static napi_value NapiYGNodeStyleSetFlexGrow(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetFlexGrow(napi_env env, napi_callback_info info);

    // Flex Shrink
    static napi_value NapiYGNodeStyleSetFlexShrink(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetFlexShrink(napi_env env, napi_callback_info info);

    // Flex Basis
    static napi_value NapiYGNodeStyleSetFlexBasis(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetFlexBasisPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetFlexBasisAuto(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetFlexBasis(napi_env env, napi_callback_info info);

    // Position
    static napi_value NapiYGNodeStyleSetPosition(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetPositionPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetPositionAuto(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetPosition(napi_env env, napi_callback_info info);

    // Margin
    static napi_value NapiYGNodeStyleSetMargin(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetMarginPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetMarginAuto(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetMargin(napi_env env, napi_callback_info info);

    // Padding
    static napi_value NapiYGNodeStyleSetPadding(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetPaddingPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetPadding(napi_env env, napi_callback_info info);

    // Border
    static napi_value NapiYGNodeStyleSetBorder(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetBorder(napi_env env, napi_callback_info info);

    // Gap
    static napi_value NapiYGNodeStyleSetGap(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetGapPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetGap(napi_env env, napi_callback_info info);

    // Box Sizing
    static napi_value NapiYGNodeStyleSetBoxSizing(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetBoxSizing(napi_env env, napi_callback_info info);

    // Width
    static napi_value NapiYGNodeStyleSetWidth(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetWidthPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetWidthAuto(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetWidth(napi_env env, napi_callback_info info);

    // Height
    static napi_value NapiYGNodeStyleSetHeight(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetHeightPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetHeightAuto(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetHeight(napi_env env, napi_callback_info info);

    // Min Width
    static napi_value NapiYGNodeStyleSetMinWidth(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetMinWidthPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetMinWidth(napi_env env, napi_callback_info info);

    // Min Height
    static napi_value NapiYGNodeStyleSetMinHeight(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetMinHeightPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetMinHeight(napi_env env, napi_callback_info info);

    // Max Width
    static napi_value NapiYGNodeStyleSetMaxWidth(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetMaxWidthPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetMaxWidth(napi_env env, napi_callback_info info);

    // Max Height
    static napi_value NapiYGNodeStyleSetMaxHeight(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleSetMaxHeightPercent(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetMaxHeight(napi_env env, napi_callback_info info);

    // Aspect Ratio
    static napi_value NapiYGNodeStyleSetAspectRatio(napi_env env, napi_callback_info info);
    static napi_value NapiYGNodeStyleGetAspectRatio(napi_env env, napi_callback_info info);

private:
    static YGNodeRef extractNodeRef(napi_env env, napi_value nodeValue);
};

}  // namespace YOGA_NAPI

#endif  // OHOS_YOGA_STYLE_NAPI_H