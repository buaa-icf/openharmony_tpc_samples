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

#include "common.h"
#include "yoga_napi.h"
#include "core/yoga_config_napi.h"
#include "core/yoga_node_napi.h"
#include "core/yoga_style_napi.h"
#include "core/yoga_layout_napi.h"
#include <napi/native_api.h>
#include <hilog/log.h>

namespace YOGA_NAPI {

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor properties[] = {
        // Config
        DECLARE_NAPI_FUNCTION("configNew", YogaConfigNapi::NapiYGConfigNew),
        DECLARE_NAPI_FUNCTION("configSetUseWebDefaults", YogaConfigNapi::NapiYGConfigSetUseWebDefaults),
        DECLARE_NAPI_FUNCTION("configSetPointScaleFactor", YogaConfigNapi::NapiYGConfigSetPointScaleFactor),
        DECLARE_NAPI_FUNCTION("configSetErrata", YogaConfigNapi::NapiYGConfigSetErrata),
        DECLARE_NAPI_FUNCTION("configGetErrata", YogaConfigNapi::NapiYGConfigGetErrata),
        DECLARE_NAPI_FUNCTION("configSetExperimentalFeatureEnabled",
                              YogaConfigNapi::NapiYGConfigSetExperimentalFeatureEnabled),

        // Node
        DECLARE_NAPI_FUNCTION("nodeNew", YogaNodeNapi::NapiYGNodeNew),
        DECLARE_NAPI_FUNCTION("nodeNewWithConfig", YogaNodeNapi::NapiYGNodeNewWithConfig),
        DECLARE_NAPI_FUNCTION("nodeClone", YogaNodeNapi::NapiYGNodeClone),
        DECLARE_NAPI_FUNCTION("nodeReset", YogaNodeNapi::NapiYGNodeReset),
        DECLARE_NAPI_FUNCTION("nodeCalculateLayout", YogaLayoutNapi::NapiYGNodeCalculateLayout),
        DECLARE_NAPI_FUNCTION("nodeIsDirty", YogaNodeNapi::NapiYGNodeIsDirty),
        DECLARE_NAPI_FUNCTION("nodeMarkDirty", YogaNodeNapi::NapiYGNodeMarkDirty),
        DECLARE_NAPI_FUNCTION("nodeInsertChild", YogaNodeNapi::NapiYGNodeInsertChild),
        DECLARE_NAPI_FUNCTION("nodeSwapChild", YogaNodeNapi::NapiYGNodeSwapChild),
        DECLARE_NAPI_FUNCTION("nodeRemoveChild", YogaNodeNapi::NapiYGNodeRemoveChild),
        DECLARE_NAPI_FUNCTION("nodeRemoveAllChildren", YogaNodeNapi::NapiYGNodeRemoveAllChildren),
        DECLARE_NAPI_FUNCTION("nodeSetMeasureFunc", YogaNodeNapi::NapiYGNodeSetMeasureFunc),
        DECLARE_NAPI_FUNCTION("nodeSetBaselineFunc", YogaNodeNapi::NapiYGNodeSetBaselineFunc),
        DECLARE_NAPI_FUNCTION("nodeSetIsReferenceBaseline", YogaNodeNapi::NapiYGNodeSetIsReferenceBaseline),
        DECLARE_NAPI_FUNCTION("nodeIsReferenceBaseline", YogaNodeNapi::NapiYGNodeIsReferenceBaseline),
        DECLARE_NAPI_FUNCTION("nodeSetAlwaysFormsContainingBlock",
                              YogaNodeNapi::NapiYGNodeSetAlwaysFormsContainingBlock),

        // NodeStyle
        DECLARE_NAPI_FUNCTION("nodeCopyStyle", YogaStyleNapi::NapiYGNodeCopyStyle),
        // Layout direction
        DECLARE_NAPI_FUNCTION("nodeStyleSetDirection", YogaStyleNapi::NapiYGNodeStyleSetDirection),
        DECLARE_NAPI_FUNCTION("nodeStyleSetFlexDirection", YogaStyleNapi::NapiYGNodeStyleSetFlexDirection),
        DECLARE_NAPI_FUNCTION("nodeStyleSetJustifyContent", YogaStyleNapi::NapiYGNodeStyleSetJustifyContent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetAlignContent", YogaStyleNapi::NapiYGNodeStyleSetAlignContent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetAlignItems", YogaStyleNapi::NapiYGNodeStyleSetAlignItems),
        DECLARE_NAPI_FUNCTION("nodeStyleSetAlignSelf", YogaStyleNapi::NapiYGNodeStyleSetAlignSelf),
        DECLARE_NAPI_FUNCTION("nodeStyleSetPositionType", YogaStyleNapi::NapiYGNodeStyleSetPositionType),
        DECLARE_NAPI_FUNCTION("nodeStyleSetFlexWrap", YogaStyleNapi::NapiYGNodeStyleSetFlexWrap),
        DECLARE_NAPI_FUNCTION("nodeStyleSetOverflow", YogaStyleNapi::NapiYGNodeStyleSetOverflow),
        DECLARE_NAPI_FUNCTION("nodeStyleSetDisplay", YogaStyleNapi::NapiYGNodeStyleSetDisplay),
        // Flex
        DECLARE_NAPI_FUNCTION("nodeStyleSetFlex", YogaStyleNapi::NapiYGNodeStyleSetFlex),
        DECLARE_NAPI_FUNCTION("nodeStyleSetFlexGrow", YogaStyleNapi::NapiYGNodeStyleSetFlexGrow),
        DECLARE_NAPI_FUNCTION("nodeStyleSetFlexShrink", YogaStyleNapi::NapiYGNodeStyleSetFlexShrink),
        DECLARE_NAPI_FUNCTION("nodeStyleSetFlexBasis", YogaStyleNapi::NapiYGNodeStyleSetFlexBasis),
        DECLARE_NAPI_FUNCTION("nodeStyleSetFlexBasisPercent", YogaStyleNapi::NapiYGNodeStyleSetFlexBasisPercent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetFlexBasisAuto", YogaStyleNapi::NapiYGNodeStyleSetFlexBasisAuto),
        // Dimension
        DECLARE_NAPI_FUNCTION("nodeStyleSetWidth", YogaStyleNapi::NapiYGNodeStyleSetWidth),
        DECLARE_NAPI_FUNCTION("nodeStyleSetWidthPercent", YogaStyleNapi::NapiYGNodeStyleSetWidthPercent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetWidthAuto", YogaStyleNapi::NapiYGNodeStyleSetWidthAuto),
        DECLARE_NAPI_FUNCTION("nodeStyleSetHeight", YogaStyleNapi::NapiYGNodeStyleSetHeight),
        DECLARE_NAPI_FUNCTION("nodeStyleSetHeightPercent", YogaStyleNapi::NapiYGNodeStyleSetHeightPercent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetHeightAuto", YogaStyleNapi::NapiYGNodeStyleSetHeightAuto),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMinWidth", YogaStyleNapi::NapiYGNodeStyleSetMinWidth),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMinWidthPercent", YogaStyleNapi::NapiYGNodeStyleSetMinWidthPercent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMinHeight", YogaStyleNapi::NapiYGNodeStyleSetMinHeight),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMinHeightPercent", YogaStyleNapi::NapiYGNodeStyleSetMinHeightPercent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMaxWidth", YogaStyleNapi::NapiYGNodeStyleSetMaxWidth),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMaxWidthPercent", YogaStyleNapi::NapiYGNodeStyleSetMaxWidthPercent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMaxHeight", YogaStyleNapi::NapiYGNodeStyleSetMaxHeight),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMaxHeightPercent", YogaStyleNapi::NapiYGNodeStyleSetMaxHeightPercent),
        // Margin
        DECLARE_NAPI_FUNCTION("nodeStyleSetMargin", YogaStyleNapi::NapiYGNodeStyleSetMargin),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMarginPercent", YogaStyleNapi::NapiYGNodeStyleSetMarginPercent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetMarginAuto", YogaStyleNapi::NapiYGNodeStyleSetMarginAuto),
        // Padding
        DECLARE_NAPI_FUNCTION("nodeStyleSetPadding", YogaStyleNapi::NapiYGNodeStyleSetPadding),
        DECLARE_NAPI_FUNCTION("nodeStyleSetPaddingPercent", YogaStyleNapi::NapiYGNodeStyleSetPaddingPercent),
        // Border
        DECLARE_NAPI_FUNCTION("nodeStyleSetBorder", YogaStyleNapi::NapiYGNodeStyleSetBorder),
        // Position
        DECLARE_NAPI_FUNCTION("nodeStyleSetPosition", YogaStyleNapi::NapiYGNodeStyleSetPosition),
        DECLARE_NAPI_FUNCTION("nodeStyleSetPositionPercent", YogaStyleNapi::NapiYGNodeStyleSetPositionPercent),
        DECLARE_NAPI_FUNCTION("nodeStyleSetPositionAuto", YogaStyleNapi::NapiYGNodeStyleSetPositionAuto),
        // Gap
        DECLARE_NAPI_FUNCTION("nodeStyleSetGap", YogaStyleNapi::NapiYGNodeStyleSetGap),
        DECLARE_NAPI_FUNCTION("nodeStyleSetGapPercent", YogaStyleNapi::NapiYGNodeStyleSetGapPercent),
        // BoxSizing
        DECLARE_NAPI_FUNCTION("nodeStyleSetBoxSizing", YogaStyleNapi::NapiYGNodeStyleSetBoxSizing),
        // AspectRatio
        DECLARE_NAPI_FUNCTION("nodeStyleSetAspectRatio", YogaStyleNapi::NapiYGNodeStyleSetAspectRatio),

        // Getters
        DECLARE_NAPI_FUNCTION("nodeStyleGetDirection", YogaStyleNapi::NapiYGNodeStyleGetDirection),
        DECLARE_NAPI_FUNCTION("nodeStyleGetFlexDirection", YogaStyleNapi::NapiYGNodeStyleGetFlexDirection),
        DECLARE_NAPI_FUNCTION("nodeStyleGetJustifyContent", YogaStyleNapi::NapiYGNodeStyleGetJustifyContent),
        DECLARE_NAPI_FUNCTION("nodeStyleGetAlignContent", YogaStyleNapi::NapiYGNodeStyleGetAlignContent),
        DECLARE_NAPI_FUNCTION("nodeStyleGetAlignItems", YogaStyleNapi::NapiYGNodeStyleGetAlignItems),
        DECLARE_NAPI_FUNCTION("nodeStyleGetAlignSelf", YogaStyleNapi::NapiYGNodeStyleGetAlignSelf),
        DECLARE_NAPI_FUNCTION("nodeStyleGetPositionType", YogaStyleNapi::NapiYGNodeStyleGetPositionType),
        DECLARE_NAPI_FUNCTION("nodeStyleGetFlexWrap", YogaStyleNapi::NapiYGNodeStyleGetFlexWrap),
        DECLARE_NAPI_FUNCTION("nodeStyleGetOverflow", YogaStyleNapi::NapiYGNodeStyleGetOverflow),
        DECLARE_NAPI_FUNCTION("nodeStyleGetDisplay", YogaStyleNapi::NapiYGNodeStyleGetDisplay),
        DECLARE_NAPI_FUNCTION("nodeStyleGetFlex", YogaStyleNapi::NapiYGNodeStyleGetFlex),
        DECLARE_NAPI_FUNCTION("nodeStyleGetFlexGrow", YogaStyleNapi::NapiYGNodeStyleGetFlexGrow),
        DECLARE_NAPI_FUNCTION("nodeStyleGetFlexShrink", YogaStyleNapi::NapiYGNodeStyleGetFlexShrink),
        DECLARE_NAPI_FUNCTION("nodeStyleGetFlexBasis", YogaStyleNapi::NapiYGNodeStyleGetFlexBasis),
        DECLARE_NAPI_FUNCTION("nodeStyleGetPosition", YogaStyleNapi::NapiYGNodeStyleGetPosition),
        DECLARE_NAPI_FUNCTION("nodeStyleGetMargin", YogaStyleNapi::NapiYGNodeStyleGetMargin),
        DECLARE_NAPI_FUNCTION("nodeStyleGetPadding", YogaStyleNapi::NapiYGNodeStyleGetPadding),
        DECLARE_NAPI_FUNCTION("nodeStyleGetBorder", YogaStyleNapi::NapiYGNodeStyleGetBorder),
        DECLARE_NAPI_FUNCTION("nodeStyleGetGap", YogaStyleNapi::NapiYGNodeStyleGetGap),
        DECLARE_NAPI_FUNCTION("nodeStyleGetBoxSizing", YogaStyleNapi::NapiYGNodeStyleGetBoxSizing),
        DECLARE_NAPI_FUNCTION("nodeStyleGetWidth", YogaStyleNapi::NapiYGNodeStyleGetWidth),
        DECLARE_NAPI_FUNCTION("nodeStyleGetHeight", YogaStyleNapi::NapiYGNodeStyleGetHeight),
        DECLARE_NAPI_FUNCTION("nodeStyleGetMinWidth", YogaStyleNapi::NapiYGNodeStyleGetMinWidth),
        DECLARE_NAPI_FUNCTION("nodeStyleGetMinHeight", YogaStyleNapi::NapiYGNodeStyleGetMinHeight),
        DECLARE_NAPI_FUNCTION("nodeStyleGetMaxWidth", YogaStyleNapi::NapiYGNodeStyleGetMaxWidth),
        DECLARE_NAPI_FUNCTION("nodeStyleGetMaxHeight", YogaStyleNapi::NapiYGNodeStyleGetMaxHeight),
        DECLARE_NAPI_FUNCTION("nodeStyleGetAspectRatio", YogaStyleNapi::NapiYGNodeStyleGetAspectRatio),
    };
    napi_define_properties(env, exports, sizeof(properties) / sizeof(properties[0]), properties);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "yoga_native",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}

}  // namespace YOGA_NAPI