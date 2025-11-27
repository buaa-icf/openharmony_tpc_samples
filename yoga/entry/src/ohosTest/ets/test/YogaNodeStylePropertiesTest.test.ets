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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  Yoga,
  YogaNode,
  YogaDirection,
  YogaEdge,
  YogaFlexDirection,
  YogaJustify,
  YogaConstants,
  YogaAlign,
  YogaPositionType,
  YogaWrap,
  YogaOverflow,
  YogaDisplay,
  YogaValue,
  YogaUnit
} from '@ohos/yoga';

export default function yogaNodeStylePropertiesTest() {
  describe('YogaNodeStylePropertiesTest', () => {
    // Helper functions
    let createNode: () => YogaNode = (): YogaNode => {
      return Yoga.createNode();
    };

    let style: () => StyledNode = (): StyledNode => {
      return new StyledNode();
    };

    // StyledNode helper class
    class StyledNode {
      private mNode: YogaNode;

      constructor() {
        this.mNode = Yoga.createNode();
      }

      node(): YogaNode {
        return this.mNode;
      }

      children(...children: StyledNode[]): StyledNode {
        // Clear existing children
        while (this.mNode.getChildCount() > 0) {
          this.mNode.removeChild(0);
        }

        // Add new children
        for (let i = 0; i < children.length; i++) {
          this.mNode.insertChild(children[i].node(), i);
        }
        return this;
      }

      direction(direction: YogaDirection): StyledNode {
        this.mNode.setDirection(direction);
        return this;
      }

      width(width: number): StyledNode {
        this.mNode.setWidth(width);
        return this;
      }

      widthPercent(width: number): StyledNode {
        this.mNode.setWidthPercent(width);
        return this;
      }

      flexDirection(direction: YogaFlexDirection): StyledNode {
        this.mNode.setFlexDirection(direction);
        return this;
      }

      justifyContent(justify: YogaJustify): StyledNode {
        this.mNode.setJustifyContent(justify);
        return this;
      }

      height(height: number): StyledNode {
        this.mNode.setHeight(height);
        return this;
      }

      heightPercent(height: number): StyledNode {
        this.mNode.setHeightPercent(height);
        return this;
      }

      alignItems(align: YogaAlign): StyledNode {
        this.mNode.setAlignItems(align);
        return this;
      }

      alignSelf(align: YogaAlign): StyledNode {
        this.mNode.setAlignSelf(align);
        return this;
      }

      alignContent(align: YogaAlign): StyledNode {
        this.mNode.setAlignContent(align);
        return this;
      }

      flexWrap(wrap: YogaWrap): StyledNode {
        this.mNode.setFlexWrap(wrap);
        return this;
      }

      positionType(positionType: YogaPositionType): StyledNode {
        this.mNode.setPositionType(positionType);
        return this;
      }

      overflow(overflow: YogaOverflow): StyledNode {
        this.mNode.setOverflow(overflow);
        return this;
      }

      flexShrink(flexShrink: number): StyledNode {
        this.mNode.setFlexShrink(flexShrink);
        return this;
      }

      display(display: YogaDisplay): StyledNode {
        this.mNode.setDisplay(display);
        return this;
      }

      flexGrow(flexGrow: number): StyledNode {
        this.mNode.setFlexGrow(flexGrow);
        return this;
      }

      flex(flex: number): StyledNode {
        this.mNode.setFlex(flex);
        return this;
      }

      flexBasis(flexBasis: number): StyledNode {
        this.mNode.setFlexBasis(flexBasis);
        return this;
      }

      flexBasisPercent(flexBasis: number): StyledNode {
        this.mNode.setFlexBasisPercent(flexBasis);
        return this;
      }

      margin(edge: YogaEdge, margin: number): StyledNode {
        this.mNode.setMargin(edge, margin);
        return this;
      }

      marginPercent(edge: YogaEdge, margin: number): StyledNode {
        this.mNode.setMarginPercent(edge, margin);
        return this;
      }

      marginAuto(edge: YogaEdge): StyledNode {
        this.mNode.setMarginAuto(edge);
        return this;
      }

      padding(edge: YogaEdge, padding: number): StyledNode {
        this.mNode.setPadding(edge, padding);
        return this;
      }

      paddingPercent(edge: YogaEdge, padding: number): StyledNode {
        this.mNode.setPaddingPercent(edge, padding);
        return this;
      }

      border(edge: YogaEdge, border: number): StyledNode {
        this.mNode.setBorder(edge, border);
        return this;
      }

      position(edge: YogaEdge, position: number): StyledNode {
        this.mNode.setPosition(edge, position);
        return this;
      }

      positionPercent(edge: YogaEdge, position: number): StyledNode {
        this.mNode.setPositionPercent(edge, position);
        return this;
      }

      minWidth(minWidth: number): StyledNode {
        this.mNode.setMinWidth(minWidth);
        return this;
      }

      minWidthPercent(minWidth: number): StyledNode {
        this.mNode.setMinWidthPercent(minWidth);
        return this;
      }

      minHeight(minHeight: number): StyledNode {
        this.mNode.setMinHeight(minHeight);
        return this;
      }

      minHeightPercent(minHeight: number): StyledNode {
        this.mNode.setMinHeightPercent(minHeight);
        return this;
      }

      maxWidth(maxWidth: number): StyledNode {
        this.mNode.setMaxWidth(maxWidth);
        return this;
      }

      maxWidthPercent(maxWidth: number): StyledNode {
        this.mNode.setMaxWidthPercent(maxWidth);
        return this;
      }

      maxHeight(maxHeight: number): StyledNode {
        this.mNode.setMaxHeight(maxHeight);
        return this;
      }

      maxHeightPercent(maxHeight: number): StyledNode {
        this.mNode.setMaxHeightPercent(maxHeight);
        return this;
      }

      aspectRatio(aspectRatio: number): StyledNode {
        this.mNode.setAspectRatio(aspectRatio);
        return this;
      }
    }

    // 测试默认方向为 YogaDirection.INHERIT。
    it('testDirectionDefault', 0, () => {
      const node = createNode();

      expect(node.getStyleDirection()).assertEqual(YogaDirection.INHERIT);
      expect(node.getLayoutDirection()).assertEqual(YogaDirection.INHERIT);
    });

    // 测试设置方向为 YogaDirection.LTR 后，样式和布局方向均正确应用。
    it('testDirectionAssignment', 0, () => {
      const node = createNode();
      node.setDirection(YogaDirection.LTR);
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(node.getStyleDirection()).assertEqual(YogaDirection.LTR);
      expect(node.getLayoutDirection()).assertEqual(YogaDirection.LTR);
    });

    // 测试当方向设为 RTL 并子元素宽度为父容器40%时，其X坐标是否从右侧开始计算。
    it('testDirectionAffectsLayout', 0, () => {
      const node = style().direction(YogaDirection.RTL).width(200).children(style().widthPercent(40)).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutX())).assertEqual(120);
    });

    // 验证默认主轴方向为 YogaFlexDirection.COLUMN。
    it('testFlexDirectionDefault', 0, () => {
      const node = createNode();

      expect(node.getFlexDirection()).assertEqual(YogaFlexDirection.COLUMN);
    });

    // 测试设置主轴方向为 COLUMN_REVERSE 是否生效。
    it('testFlexDirectionAssignment', 0, () => {
      const node = style().flexDirection(YogaFlexDirection.COLUMN_REVERSE).node();

      expect(node.getFlexDirection()).assertEqual(YogaFlexDirection.COLUMN_REVERSE);
    });

    // 设置主轴方向为 ROW_REVERSE，验证子项布局位置是否符合预期。
    it('testFlexDirectionAffectsLayout', 0, () => {
      const node = style()
        .flexDirection(YogaFlexDirection.ROW_REVERSE)
        .width(200)
        .children(style().widthPercent(40))
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutX())).assertEqual(120);
    });

    // 默认对齐方式应为 YogaJustify.FLEX_START。
    it('testJustifyContentDefault', 0, () => {
      const node = createNode();

      expect(node.getJustifyContent()).assertEqual(YogaJustify.FLEX_START);
    });

    // 测试设置对齐方式为 SPACE_EVENLY 是否成功。
    it('testJustifyContentAssignment', 0, () => {
      const node = createNode();
      node.setJustifyContent(YogaJustify.SPACE_EVENLY);

      expect(node.getJustifyContent()).assertEqual(YogaJustify.SPACE_EVENLY);
    });

    // 设置对齐方式为居中后，验证子项垂直方向的位置。
    it('testJustifyContentAffectsLayout', 0, () => {
      const node = style()
        .justifyContent(YogaJustify.CENTER)
        .height(200)
        .children(style().heightPercent(40))
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutY())).assertEqual(60);
    });

    // 默认交叉轴对齐方式为 STRETCH。
    it('testAlignItemsDefault', 0, () => {
      const node = createNode();

      expect(node.getAlignItems()).assertEqual(YogaAlign.STRETCH);
    });

    // 测试设置交叉轴对齐方式为 SPACE_AROUND 是否有效。
    it('testAlignItemsAssignment', 0, () => {
      const node = createNode();
      node.setAlignItems(YogaAlign.SPACE_AROUND);

      expect(node.getAlignItems()).assertEqual(YogaAlign.SPACE_AROUND);
    });

    // 设置交叉轴对齐为居中，验证子项水平方向的位置。
    it('testAlignItemsAffectsLayout', 0, () => {
      const node = style().alignItems(YogaAlign.CENTER).height(200).children(style().widthPercent(40)).node();
      node.calculateLayout(200, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutX())).assertEqual(60);
    });

    // 默认自身对齐属性为 AUTO。
    it('testAlignSelfDefault', 0, () => {
      const node = createNode();

      expect(node.getAlignSelf()).assertEqual(YogaAlign.AUTO);
    });

    // 测试设置自身对齐为 FLEX_END 是否生效。
    it('testAlignSelfAssignment', 0, () => {
      const node = createNode();
      node.setAlignSelf(YogaAlign.FLEX_END);

      expect(node.getAlignSelf()).assertEqual(YogaAlign.FLEX_END);
    });

    // 子节点设置自身对齐为居中，验证其布局位置是否正确。
    it('testAlignSelfAffectsLayout', 0, () => {
      const node = style().height(200).children(style().alignSelf(YogaAlign.CENTER).widthPercent(40)).node();
      node.calculateLayout(200, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutX())).assertEqual(60);
    });

    // 默认多行内容对齐方式为 FLEX_START。
    it('testAlignContentDefault', 0, () => {
      const node = createNode();

      expect(node.getAlignContent()).assertEqual(YogaAlign.FLEX_START);
    });

    // 测试设置内容对齐为 BASELINE 是否成功。
    it('testAlignContentAssignment', 0, () => {
      const node = createNode();
      node.setAlignContent(YogaAlign.BASELINE);

      expect(node.getAlignContent()).assertEqual(YogaAlign.BASELINE);
    });

    // 多行排列并设置内容对齐为 SPACE_AROUND，验证子项的布局偏移。
    it('testAlignContentAffectsLayout', 0, () => {
      const node = style()
        .alignContent(YogaAlign.SPACE_AROUND)
        .flexWrap(YogaWrap.WRAP)
        .height(200)
        .width(200)
        .children(
          style().widthPercent(20).heightPercent(60),
          style().widthPercent(20).heightPercent(60)
        )
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutX())).assertEqual(30);
    });

    // 默认定位类型为相对定位 (RELATIVE)。
    it('testPositionTypeDefault', 0, () => {
      const node = createNode();

      expect(node.getPositionType()).assertEqual(YogaPositionType.RELATIVE);
    });

    // 测试绝对定位 (ABSOLUTE) 的设置是否被接受。
    it('testPositionTypeAssignment', 0, () => {
      const node = createNode();
      node.setPositionType(YogaPositionType.ABSOLUTE);

      expect(node.getPositionType()).assertEqual(YogaPositionType.ABSOLUTE);
    });

    // 第二个子项设为绝对定位，验证其不参与常规流布局。
    it('testPositionTypeAffectsLayout', 0, () => {
      const node = style()
        .height(200)
        .children(
          style().height(100),
          style().height(100).positionType(YogaPositionType.ABSOLUTE)
        )
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(1).getLayoutY())).assertEqual(0);
    });

    // 容器启用反向换行 (WRAP_REVERSE)，验证子项排列顺序与位置。
    it('testWrapAffectsLayout', 0, () => {
      const node = style()
        .width(200)
        .height(200)
        .flexWrap(YogaWrap.WRAP_REVERSE)
        .children(
          style().width(10).heightPercent(60),
          style().heightPercent(60)
        )
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutX())).assertEqual(190);
    });

    // 默认溢出行为为可见 (VISIBLE)。
    it('testOverflowDefault', 0, () => {
      const node = createNode();

      expect(node.getOverflow()).assertEqual(YogaOverflow.VISIBLE);
    });

    // 测试设置溢出行为为滚动 (SCROLL) 是否成功。
    it('testOverflowAssignment', 0, () => {
      const node = createNode();
      node.setOverflow(YogaOverflow.SCROLL);

      expect(node.getOverflow()).assertEqual(YogaOverflow.SCROLL);
    });

    // 默认显示模式为弹性盒子 (FLEX)。
    it('testDisplayDefault', 0, () => {
      const node = createNode();

      expect(node.getDisplay()).assertEqual(YogaDisplay.FLEX);
    });

    // 测试设置显示为隐藏 (NONE) 是否生效。
    it('testDisplayAssignment', 0, () => {
      const node = createNode();
      node.setDisplay(YogaDisplay.NONE);

      expect(node.getDisplay()).assertEqual(YogaDisplay.NONE);
    });

    // 某一子项设为隐藏，其余填充剩余空间，验证布局变化。
    it('testDisplayAffectsLayout', 0, () => {
      const node = style()
        .children(
          style().flexGrow(1).display(YogaDisplay.NONE),
          style().flexGrow(1)
        )
        .node();
      node.calculateLayout(200, 200);

      expect(Math.floor(node.getChild(1).getLayoutHeight())).assertEqual(200);
    });

    // 子项具有正数 flex 值，在不足空间内扩展至填满容器高度。
    it('testFlexAffectsLayoutGrowing', 0, () => {
      const node = style().height(200).children(style().height(100).flex(1.25)).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutHeight())).assertEqual(200);
    });

    // 子项尺寸超过可用空间，根据 flex 属性收缩以适应容器。
    it('testFlexAffectsLayoutShrinking', 0, () => {
      const node = style().height(200).children(style().height(300).flex(1.25)).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutHeight())).assertEqual(200);
    });

    // 默认增长比例为 0。
    it('testFlexGrowDefault', 0, () => {
      const node = createNode();

      expect(node.getFlexGrow()).assertEqual(0);
    });

    // 测试设置增长比例为 2.5 是否有效。
    it('testFlexGrowAssignment', 0, () => {
      const node = createNode();
      node.setFlexGrow(2.5);

      expect(node.getFlexGrow()).assertEqual(2.5);
    });

    // 第一个子项增长比为 1，第二个不变，验证第一个占据剩余空间。
    it('testFlexGrowAffectsLayout', 0, () => {
      const node = style()
        .height(200)
        .children(
          style().height(50).flexGrow(1),
          style().height(50)
        )
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutHeight())).assertEqual(150);
    });

    // 默认收缩比例为 0。
    it('testFlexShrinkDefault', 0, () => {
      const node = createNode();

      expect(node.getFlexShrink()).assertEqual(0);
    });

    // 测试设置收缩比例为 2.5 是否生效。
    it('testFlexShrinkAssignment', 0, () => {
      const node = createNode();
      node.setFlexShrink(2.5);

      expect(node.getFlexShrink()).assertEqual(2.5);
    });

    // 第一项收缩比为 1，第二项固定大小，验证第一项的高度缩减效果。
    it('testFlexShrinkAffectsLayout', 0, () => {
      const node = style()
        .height(200)
        .children(
          style().height(150).flexShrink(1),
          style().height(150)
        )
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutHeight())).assertEqual(50);
    });

    // 默认基础尺寸为自动 (AUTO)。
    it('testFlexBasisDefault', 0, () => {
      const node = createNode();

      expect(YogaValue.AUTO.equals(node.getFlexBasis())).assertTrue();
    });

    // 分别测试设置基础尺寸为具体值、百分比及自动的情况。
    it('testFlexBasisAssignment', 0, () => {
      const node = createNode();
      node.setFlexBasis(50);
      expect(Math.abs(50 - node.getFlexBasis().value) < 0.001 &&
        node.getFlexBasis().unit === YogaUnit.POINT).assertTrue();

      node.setFlexBasisPercent(20);
      expect(Math.abs(20 - node.getFlexBasis().value) < 0.001 &&
        node.getFlexBasis().unit === YogaUnit.PERCENT).assertTrue();

      node.setFlexBasisAuto();
      expect(YogaValue.AUTO.equals(node.getFlexBasis())).assertTrue();
    });

    // 两个子项都设置了基础尺寸和收缩比例，验证它们如何分配空间。
    it('testFlexBasisAffectsLayout', 0, () => {
      const node = style()
        .height(200)
        .children(
          style().flexBasis(150).flexShrink(1),
          style().flexBasis(150).flexShrink(1)
        )
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutHeight())).assertEqual(100);
    });

    // 使用百分比设定基础尺寸，验证子项最终尺寸。
    it('testFlexBasisPercentAffectsLayout', 0, () => {
      const node = style()
        .height(200)
        .children(
          style().flexBasisPercent(60),
          style().flexBasisPercent(40)
        )
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(1).getLayoutHeight())).assertEqual(80);
    });

    // 所有边缘默认外边距为未定义 (UNDEFINED)。
    it('testMarginDefault', 0, () => {
      const node = createNode();
      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END, YogaEdge.HORIZONTAL, YogaEdge.VERTICAL, YogaEdge.ALL
      ];

      for (const edge of edges) {
        expect(YogaValue.UNDEFINED.equals(node.getMargin(edge))).assertTrue();
      }
    });

    // 测试各个边缘分别设置像素、百分比和自动外边距的功能。
    it('testMarginAssignment', 0, () => {
      const node = createNode();
      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END
      ];

      for (const edge of edges) {
        node.setMargin(edge, 25);
        expect(Math.abs(25 - node.getMargin(edge).value) < 0.001 &&
          node.getMargin(edge).unit === YogaUnit.POINT).assertTrue();

        node.setMarginPercent(edge, 5);
        expect(Math.abs(5 - node.getMargin(edge).value) < 0.001 &&
          node.getMargin(edge).unit === YogaUnit.PERCENT).assertTrue();

        node.setMarginAuto(edge);
        expect(YogaValue.AUTO.equals(node.getMargin(edge))).assertTrue();
      }
    });

    // 测试负数值作为外边距能否正常工作。
    it('testNegativeMarginAssignment', 0, () => {
      const node = createNode();
      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END
      ];

      for (const edge of edges) {
        node.setMargin(edge, -25);
        expect(Math.abs(-25 - node.getMargin(edge).value) < 0.001 &&
          node.getMargin(edge).unit === YogaUnit.POINT).assertTrue();

        node.setMarginPercent(edge, -5);
        expect(Math.abs(-5 - node.getMargin(edge).value) < 0.001 &&
          node.getMargin(edge).unit === YogaUnit.PERCENT).assertTrue();

        node.setMarginAuto(edge);
        expect(YogaValue.AUTO.equals(node.getMargin(edge))).assertTrue();
      }
    });

    // 上边缘外边距为 42px，验证整体布局向下偏移量。
    it('testMarginPointAffectsLayout', 0, () => {
      const node = style().margin(YogaEdge.TOP, 42).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutY())).assertEqual(42);
    });

    // 子项上边缘外边距为 20%，验证基于父容器高度的偏移。
    it('testMarginPercentAffectsLayout', 0, () => {
      const node = style()
        .height(200)
        .children(style().flexGrow(1).marginPercent(YogaEdge.TOP, 20))
        .node();
      node.calculateLayout(200, 200);

      expect(Math.floor(node.getChild(0).getLayoutY())).assertEqual(40);
    });

    // 左右边距设为 auto，验证子项水平居中。
    it('testMarginAutoAffectsLayout', 0, () => {
      const node = style()
        .width(200)
        .flexDirection(YogaFlexDirection.ROW)
        .children(style().marginAuto(YogaEdge.LEFT).marginAuto(YogaEdge.RIGHT).width(100))
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutX())).assertEqual(50);
    });

    // 所有内边距初始状态为未定义。
    it('testPaddingDefault', 0, () => {
      const node = createNode();
      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END, YogaEdge.HORIZONTAL, YogaEdge.VERTICAL, YogaEdge.ALL
      ];

      for (const edge of edges) {
        expect(YogaValue.UNDEFINED.equals(node.getPadding(edge))).assertTrue();
      }
    });

    // 测试设置不同边缘的内边距（像素和百分比）功能。
    it('testPaddingAssignment', 0, () => {
      const node = createNode();
      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END
      ];

      for (const edge of edges) {
        node.setPadding(edge, 25);
        expect(Math.abs(25 - node.getPadding(edge).value) < 0.001 &&
          node.getPadding(edge).unit === YogaUnit.POINT).assertTrue();

        node.setPaddingPercent(edge, 5);
        expect(Math.abs(5 - node.getPadding(edge).value) < 0.001 &&
          node.getPadding(edge).unit === YogaUnit.PERCENT).assertTrue();
      }
    });

    // 容器上内边距为 42px，验证子项布局起点。
    it('testPaddingPointAffectsLayout', 0, () => {
      const node = style().padding(YogaEdge.TOP, 42).children(style()).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutY())).assertEqual(42);
    });

    // 内边距使用百分比表示，验证其相对于容器高度的影响。
    it('testPaddingPercentAffectsLayout', 0, () => {
      const node = style()
        .height(200)
        .paddingPercent(YogaEdge.TOP, 20)
        .children(style().flexGrow(1))
        .node();
      node.calculateLayout(200, 200);

      expect(Math.floor(node.getChild(0).getLayoutY())).assertEqual(40);
    });

    // 边框宽度默认未定义。
    it('testBorderDefault', 0, () => {
      const node = createNode();
      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END
      ];

      for (const edge of edges) {
        expect(YogaConstants.isUndefined(node.getBorder(edge))).assertTrue();
      }
    });

    // 测试各边缘设置统一数值的边框宽度。
    it('testBorderAssignment', 0, () => {
      const node = createNode();
      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END
      ];

      for (const edge of edges) {
        node.setBorder(edge, 2.5);
        expect(node.getBorder(edge)).assertEqual(2.5);
      }
    });

    // 顶部边框影响内部子项的布局起始位置。
    it('testBorderAffectsLayout', 0, () => {
      const node = style().border(YogaEdge.TOP, 42).children(style()).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutY())).assertEqual(42);
    });

    // 默认情况下，所有位置属性均为未定义。
    it('testPositionDefault', 0, () => {
      const node = createNode();
      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END
      ];

      for (const edge of edges) {
        expect(YogaValue.UNDEFINED.equals(node.getPosition(edge))).assertTrue();
      }
    });

    // 测试绝对定位元素的位置属性设置（包括像素和百分比单位）。
    it('testPositionAssignment', 0, () => {
      const node = createNode();
      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END
      ];

      for (const edge of edges) {
        node.setPosition(edge, 25);
        expect(Math.abs(25 - node.getPosition(edge).value) < 0.001 &&
          node.getPosition(edge).unit === YogaUnit.POINT).assertTrue();

        node.setPositionPercent(edge, 5);
        expect(Math.abs(5 - node.getPosition(edge).value) < 0.001 &&
          node.getPosition(edge).unit === YogaUnit.PERCENT).assertTrue();
      }
    });

    // 绝对定位子项同时设置上下间距，验证其实际高度。
    it('testPositionAffectsLayout', 0, () => {
      const node = style()
        .height(100)
        .children(
          style()
            .positionType(YogaPositionType.ABSOLUTE)
            .position(YogaEdge.TOP, 11)
            .position(YogaEdge.BOTTOM, 22)
        )
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutHeight())).assertEqual(67);
    });

    // 绝对定位子项左右间距采用百分比形式，验证其宽度表现。
    it('testPositionPercentAffectsLayout', 0, () => {
      const node = style()
        .width(100)
        .children(
          style()
            .positionType(YogaPositionType.ABSOLUTE)
            .positionPercent(YogaEdge.LEFT, 11)
            .positionPercent(YogaEdge.RIGHT, 22)
        )
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutWidth())).assertEqual(67);
    });

    // 默认宽度为自动 (AUTO)。
    it('testWidthDefault', 0, () => {
      const node = createNode();

      expect(YogaValue.AUTO.equals(node.getWidth())).assertTrue();
    });

    // 测试设置固定宽度和百分比宽度两种情况。
    it('testWidthAssignment', 0, () => {
      const node = createNode();
      node.setWidth(123);
      expect(Math.abs(123 - node.getWidth().value) < 0.001 &&
        node.getWidth().unit === YogaUnit.POINT).assertTrue();

      node.setWidthPercent(45);
      expect(Math.abs(45 - node.getWidth().value) < 0.001 &&
        node.getWidth().unit === YogaUnit.PERCENT).assertTrue();
    });

    // 固定宽度 123px 应反映在布局结果中。
    it('testWidthAffectsLayout', 0, () => {
      const node = style().width(123).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutWidth())).assertEqual(123);
    });

    // 百分比宽度基于父容器计算，验证子项实际宽度。
    it('testWidthPercentAffectsLayout', 0, () => {
      const node = style().widthPercent(75).node();
      node.calculateLayout(200, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutWidth())).assertEqual(150);
    });

    // 默认高度为自动 (AUTO)。
    it('testHeightDefault', 0, () => {
      const node = createNode();

      expect(YogaValue.AUTO.equals(node.getHeight())).assertTrue();
    });

    // 测试设置具体高度和百分比高度。
    it('testHeightAssignment', 0, () => {
      const node = createNode();
      node.setHeight(123);
      expect(Math.abs(123 - node.getHeight().value) < 0.001 &&
        node.getHeight().unit === YogaUnit.POINT).assertTrue();

      node.setHeightPercent(45);
      expect(Math.abs(45 - node.getHeight().value) < 0.001 &&
        node.getHeight().unit === YogaUnit.PERCENT).assertTrue();
    });

    // 固定高度 123px 应体现在布局输出中。
    it('testHeightAffectsLayout', 0, () => {
      const node = style().height(123).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutHeight())).assertEqual(123);
    });

    // 百分比高度依据父容器高度确定，验证子项实际高度。
    it('testHeightPercentAffectsLayout', 0, () => {
      const node = style().heightPercent(75).node();
      node.calculateLayout(YogaConstants.UNDEFINED, 200);

      expect(Math.floor(node.getLayoutHeight())).assertEqual(150);
    });

    // 最小宽度默认为未定义。
    it('testMinWidthDefault', 0, () => {
      const node = createNode();

      expect(YogaValue.UNDEFINED.equals(node.getMinWidth())).assertTrue();
    });

    // 测试最小宽度的具体值和百分比赋值。
    it('testMinWidthAssignment', 0, () => {
      const node = createNode();
      node.setMinWidth(123);
      expect(Math.abs(123 - node.getMinWidth().value) < 0.001 &&
        node.getMinWidth().unit === YogaUnit.POINT).assertTrue();

      node.setMinWidthPercent(45);
      expect(Math.abs(45 - node.getMinWidth().value) < 0.001 &&
        node.getMinWidth().unit === YogaUnit.PERCENT).assertTrue();
    });

    // 设定最小宽度强制拉伸容器的实际宽度。
    it('testMinWidthAffectsLayout', 0, () => {
      const node = style().minWidth(123).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutWidth())).assertEqual(123);
    });

    // 百分比最小宽度超出原始尺寸，验证布局中的放大效果。
    it('testMinWidthPercentAffectsLayout', 0, () => {
      const node = style().minWidthPercent(120).node();
      node.calculateLayout(200, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutWidth())).assertEqual(240);
    });

    // 最小高度默认为未定义。
    it('testMinHeightDefault', 0, () => {
      const node = createNode();

      expect(YogaValue.UNDEFINED.equals(node.getMinHeight())).assertTrue();
    });

    // 测试设置最小高度值及其百分比版本。
    it('testMinHeightAssignment', 0, () => {
      const node = createNode();
      node.setMinHeight(123);
      expect(Math.abs(123 - node.getMinHeight().value) < 0.001 &&
        node.getMinHeight().unit === YogaUnit.POINT).assertTrue();

      node.setMinHeightPercent(45);
      expect(Math.abs(45 - node.getMinHeight().value) < 0.001 &&
        node.getMinHeight().unit === YogaUnit.PERCENT).assertTrue();
    });

    // 强制设定最小高度，验证布局中是否满足此限制。
    it('testMinHeightAffectsLayout', 0, () => {
      const node = style().minHeight(123).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutHeight())).assertEqual(123);
    });

    // 百分比最小高度大于原高，验证布局结果。
    it('testMinHeightPercentAffectsLayout', 0, () => {
      const node = style().minHeightPercent(120).node();
      node.calculateLayout(YogaConstants.UNDEFINED, 200);

      expect(Math.floor(node.getLayoutHeight())).assertEqual(240);
    });

    // 最大宽度默认为未定义。
    it('testMaxWidthDefault', 0, () => {
      const node = createNode();

      expect(YogaValue.UNDEFINED.equals(node.getMaxWidth())).assertTrue();
    });

    // 测试最大宽度的设定逻辑。
    it('testMaxWidthAssignment', 0, () => {
      const node = createNode();
      node.setMaxWidth(123);
      expect(Math.abs(123 - node.getMaxWidth().value) < 0.001 &&
        node.getMaxWidth().unit === YogaUnit.POINT).assertTrue();

      node.setMaxWidthPercent(45);
      expect(Math.abs(45 - node.getMaxWidth().value) < 0.001 &&
        node.getMaxWidth().unit === YogaUnit.PERCENT).assertTrue();
    });

    // 子项最大宽度小于默认宽度，验证其受限于最大宽度。
    it('testMaxWidthAffectsLayout', 0, () => {
      const node = style().width(200).children(style().maxWidth(123)).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutWidth())).assertEqual(123);
    });

    // 百分比最大宽度约束子项尺寸，验证结果。
    it('testMaxWidthPercentAffectsLayout', 0, () => {
      const node = style().width(200).children(style().maxWidthPercent(80)).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutWidth())).assertEqual(160);
    });

    // 最大高度默认为未定义。
    it('testMaxHeightDefault', 0, () => {
      const node = createNode();

      expect(YogaValue.UNDEFINED.equals(node.getMaxHeight())).assertTrue();
    });

    // 测试设置最大高度及其百分比形式。
    it('testMaxHeightAssignment', 0, () => {
      const node = createNode();
      node.setMaxHeight(123);
      expect(Math.abs(123 - node.getMaxHeight().value) < 0.001 &&
        node.getMaxHeight().unit === YogaUnit.POINT).assertTrue();

      node.setMaxHeightPercent(45);
      expect(Math.abs(45 - node.getMaxHeight().value) < 0.001 &&
        node.getMaxHeight().unit === YogaUnit.PERCENT).assertTrue();
    });

    // 子项最大高度限制其纵向尺寸。
    it('testMaxHeightAffectsLayout', 0, () => {
      const node = style()
        .height(200)
        .flexDirection(YogaFlexDirection.ROW)
        .children(style().maxHeight(123))
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutHeight())).assertEqual(123);
    });

    // 百分比最大高度控制子项尺寸范围。
    it('testMaxHeightPercentAffectsLayout', 0, () => {
      const node = style()
        .flexDirection(YogaFlexDirection.ROW)
        .height(200)
        .children(style().maxHeightPercent(80))
        .node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutHeight())).assertEqual(160);
    });

    // 默认宽高比为未定义。
    it('testAspectRatioDefault', 0, () => {
      const node = createNode();

      expect(YogaConstants.isUndefined(node.getAspectRatio())).assertTrue();
    });

    // 测试给节点指定特定的宽高比值。
    it('testAspectRatioAssignment', 0, () => {
      const node = createNode();
      node.setAspectRatio(2.75);

      expect(node.getAspectRatio()).assertEqual(2.75);
    });

    // 提供宽度并通过宽高比推导出对应高度。
    it('aspectRatioAffectsLayoutWithGivenWidth', 0, () => {
      const node = style().children(style().width(300).aspectRatio(1.5)).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutHeight())).assertEqual(200);
    });

    // 提供高度并通过宽高比推导出对应宽度。
    it('aspectRatioAffectsLayoutWithGivenHeight', 0, () => {
      const node = style().children(style().height(300).aspectRatio(1.5)).node();
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getChild(0).getLayoutWidth())).assertEqual(450);
    });
  });
}
