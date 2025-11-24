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

declare enum YogaDirection {
    INHERIT = 0,
    LTR = 1,
    RTL = 2
}

declare enum YogaEdge {
    LEFT = 0,
    TOP = 1,
    RIGHT = 2,
    BOTTOM = 3,
    START = 4,
    END = 5,
    HORIZONTAL = 6,
    VERTICAL = 7,
    ALL = 8
}

declare enum YogaFlexDirection {
    COLUMN = 0,
    COLUMN_REVERSE = 1,
    ROW = 2,
    ROW_REVERSE = 3
}

declare enum YogaGutter {
    COLUMN = 0,
    ROW = 1,
    ALL = 2,
}

declare enum YogaJustify {
    FLEX_START = 0,
    CENTER = 1,
    FLEX_END = 2,
    SPACE_BETWEEN = 3,
    SPACE_AROUND = 4,
    SPACE_EVENLY = 5
}

declare enum YogaAlign {
    AUTO = 0,
    FLEX_START = 1,
    CENTER = 2,
    FLEX_END = 3,
    STRETCH = 4,
    BASELINE = 5,
    SPACE_BETWEEN = 6,
    SPACE_AROUND = 7,
    SPACE_EVENLY = 8
}

declare enum YogaPositionType {
    STATIC = 0,
    RELATIVE = 1,
    ABSOLUTE = 2
}

declare enum YogaBoxSizing {
    BORDER_BOX = 0,
    CONTENT_BOX = 1
}

declare enum YogaWrap {
    NO_WRAP = 0,
    WRAP = 1,
    WRAP_REVERSE = 2
}

declare enum YogaOverflow {
    VISIBLE = 0,
    HIDDEN = 1,
    SCROLL = 2
}

declare enum YogaDisplay {
    FLEX = 0,
    NONE = 1,
    CONTENTS = 2
}

declare enum YogaUnit {
    UNDEFINED = 0,
    POINT = 1,
    PERCENT = 2,
    AUTO = 3
}

declare enum YogaMeasureMode {
    UNDEFINED = 0,
    EXACTLY = 1,
    AT_MOST = 2
}

declare enum YogaErrata {
    NONE = 0,
    STRETCH_FLEX_BASIS = 1,
    ABSOLUTE_POSITION_WITHOUT_INSETS_EXCLUDES_PADDING = 2,
    ABSOLUTE_PERCENT_AGAINST_INNER_SIZE = 4,
    ALL = 2147483647,
    CLASSIC = 2147483646
}

declare enum YogaExperimentalFeature {
    WEB_FLEX_BASIS = 0
}

declare type YogaMeasureFunction = (
    node: YogaNode,
    width: number,
    widthMode: YogaMeasureMode,
    height: number,
    heightMode: YogaMeasureMode
) => number;

declare type YogaBaselineFunction = (
    node: YogaNode,
    width: number,
    height: number,
) => number;

interface YogaValue {
    value: number;
    unit: YogaUnit;
}