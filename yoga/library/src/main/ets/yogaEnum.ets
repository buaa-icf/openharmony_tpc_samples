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

/**
 * 布局方向枚举
 * 
 * 控制布局的文本方向和布局方向
 */
export enum YogaDirection {
    /** 继承父节点的方向 */
    INHERIT = 0,
    /** 从左到右布局 (Left-To-Right) */
    LTR = 1,
    /** 从右到左布局 (Right-To-Left) */
    RTL = 2
}

/**
 * 边缘类型枚举
 * 
 * 用于指定节点的边缘，如边距、内边距、边框等
 */
export enum YogaEdge {
    /** 左边缘 */
    LEFT = 0,
    /** 上边缘 */
    TOP = 1,
    /** 右边缘 */
    RIGHT = 2,
    /** 下边缘 */
    BOTTOM = 3,
    /** 起始边缘 (根据布局方向决定是左还是右) */
    START = 4,
    /** 结束边缘 (根据布局方向决定是右还是左) */
    END = 5,
    /** 水平方向 (同时设置LEFT和RIGHT) */
    HORIZONTAL = 6,
    /** 垂直方向 (同时设置TOP和BOTTOM) */
    VERTICAL = 7,
    /** 所有边缘 (同时设置LEFT、TOP、RIGHT、BOTTOM) */
    ALL = 8
}

/**
 * 弹性盒子方向枚举
 * 
 * 控制主轴方向和内容排列方向
 */
export enum YogaFlexDirection {
    /** 列方向，从上到下 */
    COLUMN = 0,
    /** 列方向，从下到上 */
    COLUMN_REVERSE = 1,
    /** 行方向，从左到右 */
    ROW = 2,
    /** 行方向，从右到左 */
    ROW_REVERSE = 3
}

/**
 * 间距类型枚举
 * 
 * 控制子元素之间的间距类型
 */
export enum YogaGutter {
    /** 列间距 */
    COLUMN = 0,
    /** 行间距 */
    ROW = 1,
    /** 所有间距 */
    ALL = 2,
}

/**
 * 内容对齐方式枚举
 * 
 * 控制子元素在主轴上的对齐方式
 */
export enum YogaJustify {
    /** 从主轴起始位置对齐 */
    FLEX_START = 0,
    /** 居中对齐 */
    CENTER = 1,
    /** 从主轴结束位置对齐 */
    FLEX_END = 2,
    /** 子元素均匀分布，两端对齐，相邻元素间距相等 */
    SPACE_BETWEEN = 3,
    /** 子元素均匀分布，每个元素周围间距相等 */
    SPACE_AROUND = 4,
    /** 子元素均匀分布，所有间距相等 */
    SPACE_EVENLY = 5
}

/**
 * 对齐方式枚举
 * 
 * 控制子元素在交叉轴上的对齐方式
 */
export enum YogaAlign {
    /** 自动对齐 (默认值) */
    AUTO = 0,
    /** 从交叉轴起始位置对齐 */
    FLEX_START = 1,
    /** 居中对齐 */
    CENTER = 2,
    /** 从交叉轴结束位置对齐 */
    FLEX_END = 3,
    /** 拉伸填满容器 */
    STRETCH = 4,
    /** 基线对齐 */
    BASELINE = 5,
    /** 子元素均匀分布，两端对齐，相邻元素间距相等 */
    SPACE_BETWEEN = 6,
    /** 子元素均匀分布，每个元素周围间距相等 */
    SPACE_AROUND = 7,
    /** 子元素均匀分布，所有间距相等 */
    SPACE_EVENLY = 8
}

/**
 * 定位类型枚举
 * 
 * 控制节点的定位方式
 */
export enum YogaPositionType {
    /** 静态定位 (默认值，正常文档流) */
    STATIC = 0,
    /** 相对定位 (相对于正常位置进行偏移) */
    RELATIVE = 1,
    /** 绝对定位 (相对于最近的非static祖先元素进行定位) */
    ABSOLUTE = 2
}

/**
 * 盒模型类型枚举
 * 
 * 控制宽度和高度的计算方式
 */
export enum YogaBoxSizing {
    /** 边框盒模型 (宽度和高度包含内容、内边距和边框) */
    BORDER_BOX = 0,
    /** 内容盒模型 (宽度和高度仅包含内容) */
    CONTENT_BOX = 1
}

/**
 * 换行方式枚举
 * 
 * 控制子元素的换行方式
 */
export enum YogaWrap {
    /** 不换行 (默认值) */
    NO_WRAP = 0,
    /** 换行 */
    WRAP = 1,
    /** 反向换行 */
    WRAP_REVERSE = 2
}

/**
 * 溢出处理方式枚举
 * 
 * 控制内容溢出容器时的处理方式
 */
export enum YogaOverflow {
    /** 可见 (默认值，内容可以溢出容器) */
    VISIBLE = 0,
    /** 隐藏 (溢出内容被裁剪) */
    HIDDEN = 1,
    /** 滚动 (提供滚动条查看溢出内容) */
    SCROLL = 2
}

/**
 * 显示类型枚举
 * 
 * 控制节点的显示方式
 */
export enum YogaDisplay {
    /** 弹性盒子布局 (默认值) */
    FLEX = 0,
    /** 隐藏 (不显示，不占用空间) */
    NONE = 1,
    /** 内容 (仅渲染子元素，自身不生成框) */
    CONTENTS = 2
}

/**
 * 单位类型枚举
 * 
 * 表示数值的单位类型
 */
export enum YogaUnit {
    /** 未定义 */
    UNDEFINED = 0,
    /** 点 (pt) */
    POINT = 1,
    /** 百分比 (%) */
    PERCENT = 2,
    /** 自动 (auto) */
    AUTO = 3
}

/**
 * 测量模式枚举
 * 
 * 用于测量函数中指定尺寸约束
 */
export enum YogaMeasureMode {
    /** 未定义 */
    UNDEFINED = 0,
    /** 精确值 (必须等于指定值) */
    EXACTLY = 1,
    /** 最大值 (不能超过指定值) */
    AT_MOST = 2
}

/**
 * 错误修正选项枚举
 * 
 * 控制布局引擎的错误修正行为
 */
export enum YogaErrata {
    /** 无错误修正 */
    NONE = 0,
    /** 拉伸flex basis */
    STRETCH_FLEX_BASIS = 1,
    /** 绝对定位元素不包含内边距 */
    ABSOLUTE_POSITION_WITHOUT_INSETS_EXCLUDES_PADDING = 2,
    /** 绝对定位百分比相对于内部尺寸 */
    ABSOLUTE_PERCENT_AGAINST_INNER_SIZE = 4,
    /** 所有错误修正 */
    ALL = 2147483647,
    /** 经典模式 */
    CLASSIC = 2147483646
}

/**
 * 实验特性枚举
 * 
 * 控制实验性功能的启用状态
 */
export enum YogaExperimentalFeature {
    /** Web flex basis特性 */
    WEB_FLEX_BASIS = 0
}
