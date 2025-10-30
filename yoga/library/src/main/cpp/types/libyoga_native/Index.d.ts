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

/// <reference path="./common.ts" />

// config
export const configNew: () => Object;
export const configSetUseWebDefaults: (config: Object, enabled: boolean) => void;
export const configSetPointScaleFactor: (config: Object, pixelsInPoint: number) => void;
export const configSetErrata: (config: Object, errata: YogaErrata) => void;
export const configGetErrata: (config: Object) => YogaErrata;
export const configSetExperimentalFeatureEnabled: (config: Object, feature: YogaExperimentalFeature, enabled: boolean) => void;

// node
export const nodeNew: () => Object;
export const nodeNewWithConfig: (config: Object) => Object;
export const nodeClone: (node: Object) => Object;
export const nodeReset: (node: Object) => void;
export const nodeCalculateLayout: (node: Object, availableWidth: number, availableHeight: number) => void;
export const nodeIsDirty: (node: Object) => boolean;
export const nodeMarkDirty: (node: Object) => void;
export const nodeInsertChild: (parentNode: Object, childNode: Object, index: number) => void;
export const nodeSwapChild: (parentNode: Object, childNode: Object, index: number) => void;
export const nodeRemoveChild: (parentNode: Object, childNode: Object) => void;
export const nodeRemoveAllChildren: (node: Object) => void;
export const nodeSetMeasureFunc: (node: Object, measureFunc: YogaMeasureFunction | null) => void;
export const nodeSetBaselineFunc: (node: Object, baselineFunc: YogaBaselineFunction | null) => void;
export const nodeSetIsReferenceBaseline: (node: Object, isReferenceBaseline: boolean) => void;
export const nodeIsReferenceBaseline: (node: Object) => boolean;
export const nodeSetAlwaysFormsContainingBlock: (node: Object, alwaysFormsContainingBlock: boolean) => void;
// NodeStyle
export const nodeCopyStyle: (dstNode: Object, srcNode: Object) => void;
// setter
export const nodeStyleSetDirection: (node: Object, direction: YogaDirection) => void;
export const nodeStyleSetFlexDirection: (node: Object, flexDirection: YogaFlexDirection) => void;
export const nodeStyleSetJustifyContent: (node: Object, justifyContent: YogaJustify) => void;
export const nodeStyleSetAlignContent: (node: Object, alignContent: YogaAlign) => void;
export const nodeStyleSetAlignItems: (node: Object, alignItems: YogaAlign) => void;
export const nodeStyleSetAlignSelf: (node: Object, alignSelf: YogaAlign) => void;
export const nodeStyleSetPositionType: (node: Object, positionType: YogaPositionType) => void;
export const nodeStyleSetFlexWrap: (node: Object, flexWrap: YogaWrap) => void;
export const nodeStyleSetOverflow: (node: Object, overflow: YogaOverflow) => void;
export const nodeStyleSetDisplay: (node: Object, display: YogaDisplay) => void;
export const nodeStyleSetFlex: (node: Object, flex: number) => void;
export const nodeStyleSetFlexGrow: (node: Object, flexGrow: number) => void;
export const nodeStyleSetFlexShrink: (node: Object, flexShrink: number) => void;
export const nodeStyleSetFlexBasis: (node: Object, flexBasis: number) => void;
export const nodeStyleSetFlexBasisPercent: (node: Object, flexBasis: number) => void;
export const nodeStyleSetFlexBasisAuto: (node: Object) => void;
export const nodeStyleSetPosition: (node: Object, edge: YogaEdge, position: number) => void;
export const nodeStyleSetPositionPercent: (node: Object, edge: YogaEdge, position: number) => void;
export const nodeStyleSetPositionAuto: (node: Object, edge: YogaEdge) => void;
export const nodeStyleSetMargin: (node: Object, edge: YogaEdge, margin: number) => void;
export const nodeStyleSetMarginPercent: (node: Object, edge: YogaEdge, margin: number) => void;
export const nodeStyleSetMarginAuto: (node: Object, edge: YogaEdge) => void;
export const nodeStyleSetPadding: (node: Object, edge: YogaEdge, padding: number) => void;
export const nodeStyleSetPaddingPercent: (node: Object, edge: YogaEdge, padding: number) => void;
export const nodeStyleSetBorder: (node: Object, edge: YogaEdge, border: number) => void;
export const nodeStyleSetGap: (node: Object, gutter: YogaGutter, gapLength: number) => void;
export const nodeStyleSetGapPercent: (node: Object, gutter: YogaGutter, gapLength: number) => void;
export const nodeStyleSetBoxSizing: (node: Object, boxSizing: YogaBoxSizing) => void;
// Size
export const nodeStyleSetWidth: (node: Object, width: number) => void;
export const nodeStyleSetWidthPercent: (node: Object, width: number) => void;
export const nodeStyleSetWidthAuto: (node: Object) => void;
export const nodeStyleSetHeight: (node: Object, height: number) => void;
export const nodeStyleSetHeightPercent: (node: Object, height: number) => void;
export const nodeStyleSetHeightAuto: (node: Object) => void;
export const nodeStyleSetMinWidth: (node: Object, minWidth: number) => void;
export const nodeStyleSetMinWidthPercent: (node: Object, minWidth: number) => void;
export const nodeStyleSetMinHeight: (node: Object, minHeight: number) => void;
export const nodeStyleSetMinHeightPercent: (node: Object, minHeight: number) => void;
export const nodeStyleSetMaxWidth: (node: Object, maxWidth: number) => void;
export const nodeStyleSetMaxWidthPercent: (node: Object, maxWidth: number) => void;
export const nodeStyleSetMaxHeight: (node: Object, maxHeight: number) => void;
export const nodeStyleSetMaxHeightPercent: (node: Object, maxHeight: number) => void;
export const nodeStyleSetAspectRatio: (node: Object, aspectRatio: number) => void;
// getter
export const nodeStyleGetDirection: (node: Object) => YogaDirection;
export const nodeStyleGetFlexDirection: (node: Object) => YogaFlexDirection;
export const nodeStyleGetJustifyContent: (node: Object) => YogaJustify;
export const nodeStyleGetAlignContent: (node: Object) => YogaAlign;
export const nodeStyleGetAlignItems: (node: Object) => YogaAlign;
export const nodeStyleGetAlignSelf: (node: Object) => YogaAlign;
export const nodeStyleGetPositionType: (node: Object) => YogaPositionType;
export const nodeStyleGetFlexWrap: (node: Object) => YogaWrap;
export const nodeStyleGetOverflow: (node: Object) => YogaOverflow;
export const nodeStyleGetDisplay: (node: Object) => YogaDisplay;
export const nodeStyleGetFlex: (node: Object) => number;
export const nodeStyleGetFlexGrow: (node: Object) => number;
export const nodeStyleGetFlexShrink: (node: Object) => number;
export const nodeStyleGetFlexBasis: (node: Object) => YogaValue;
export const nodeStyleGetPosition: (node: Object, edge: YogaEdge) => YogaValue;
export const nodeStyleGetMargin: (node: Object, edge: YogaEdge) => YogaValue;
export const nodeStyleGetPadding: (node: Object, edge: YogaEdge) => YogaValue;
export const nodeStyleGetBorder: (node: Object, edge: YogaEdge) => number;
export const nodeStyleGetGap: (node: Object, gutter: YogaGutter) => number;
export const nodeStyleGetBoxSizing: (node: Object) => YogaBoxSizing;
export const nodeStyleGetWidth: (node: Object) => YogaValue;
export const nodeStyleGetHeight: (node: Object) => YogaValue;
export const nodeStyleGetMinWidth: (node: Object) => YogaValue;
export const nodeStyleGetMinHeight: (node: Object) => YogaValue;
export const nodeStyleGetMaxWidth: (node: Object) => YogaValue;
export const nodeStyleGetMaxHeight: (node: Object) => YogaValue;
export const nodeStyleGetAspectRatio: (node: Object) => number;