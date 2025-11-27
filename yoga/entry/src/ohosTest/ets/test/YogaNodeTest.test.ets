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
  YogaConstants,
  YogaAlign,
  YogaMeasureMode,
  YogaMeasureOutput,
  YogaErrata,
  YogaUnit
} from '@ohos/yoga';

export default function yogaNodeTest() {
  describe('YogaNodeTest', () => {

    // 验证Yoga节点和配置的初始化功能
    it('testInit', 0, () => {
      const config = Yoga.createConfig();
      const node = Yoga.createNode(config);
    });

    // 验证基线对齐功能及基线函数的正确性
    it('testBaseline', 0, () => {
      const root = Yoga.createNode();
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setWidth(100);
      root.setHeight(100);

      const child1 = Yoga.createNode();
      child1.setWidth(40);
      child1.setHeight(40);
      root.insertChild(child1, 0);

      const child2 = Yoga.createNode();
      child2.setWidth(40);
      child2.setHeight(40);
      child2.setBaselineFunction((node: YogaNode, width: number, height: number) => {
        return 0;
      });
      root.insertChild(child2, 1);

      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(child1.getLayoutY())).assertEqual(0);
      expect(Math.floor(child2.getLayoutY())).assertEqual(40);
    });

    // 验证测量函数返回整数尺寸的处理
    it('testMeasure', 0, () => {
      const node = Yoga.createNode();
      node.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode,
        height: number, heightMode: YogaMeasureMode) => {
        return YogaMeasureOutput.make(100, 100);
      });
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      expect(Math.floor(node.getLayoutWidth())).assertEqual(100);
      expect(Math.floor(node.getLayoutHeight())).assertEqual(100);
    });

    // 验证测量函数返回浮点数尺寸的处理
    it('testMeasureFloat', 0, () => {
      const node = Yoga.createNode();
      node.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode,
        height: number, heightMode: YogaMeasureMode) => {
        return YogaMeasureOutput.make(100.5, 100.5);
      });
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      expect(Math.abs(101 - node.getLayoutWidth()) < 0.01).assertTrue();
      expect(Math.abs(101 - node.getLayoutHeight()) < 0.01).assertTrue();
    });

    // 验证测量函数处理最小浮点数值的能力
    it('testMeasureFloatMin', 0, () => {
      const node = Yoga.createNode();
      node.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode,
        height: number, heightMode: YogaMeasureMode) => {
        return YogaMeasureOutput.make(Number.MIN_VALUE, Number.MIN_VALUE);
      });
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      expect(Math.abs(Number.MIN_VALUE - node.getLayoutWidth()) < 0.01).assertTrue();
      expect(Math.abs(Number.MIN_VALUE - node.getLayoutHeight()) < 0.01).assertTrue();
      console.log("ch ==== 1")
    });

    // 验证测量函数处理大数值的能力
    it('testMeasureFloatBigNumber', 0, () => {
      const node = Yoga.createNode();
      const bigNumber = 100000;
      node.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode,
        height: number, heightMode: YogaMeasureMode) => {
        return YogaMeasureOutput.make(bigNumber, bigNumber);
      });
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      expect(Math.abs(bigNumber - node.getLayoutWidth()) < 0.01).assertTrue();
      expect(Math.abs(bigNumber - node.getLayoutHeight()) < 0.01).assertTrue();
    });

    // 验证样式从一个节点复制到另一个节点的功能
    it('testCopyStyle', 0, () => {
      const node0 = Yoga.createNode();
      expect(YogaConstants.isUndefined(node0.getMaxHeight())).assertTrue();

      const node1 = Yoga.createNode();
      node1.setMaxHeight(100);

      node0.copyStyle(node1);
      expect(Math.floor(node0.getMaxHeight().value)).assertEqual(100);
    });

    // 验证布局过程中外边距的正确计算和获取
    it('testLayoutMargin', 0, () => {
      const node = Yoga.createNode();
      node.setWidth(100);
      node.setHeight(100);
      node.setMargin(YogaEdge.START, 1);
      node.setMargin(YogaEdge.END, 2);
      node.setMargin(YogaEdge.TOP, 3);
      node.setMargin(YogaEdge.BOTTOM, 4);
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutMargin(YogaEdge.LEFT))).assertEqual(1);
      expect(Math.floor(node.getLayoutMargin(YogaEdge.RIGHT))).assertEqual(2);
      expect(Math.floor(node.getLayoutMargin(YogaEdge.TOP))).assertEqual(3);
      expect(Math.floor(node.getLayoutMargin(YogaEdge.BOTTOM))).assertEqual(4);
    });

    // 验证布局过程中内边距的正确计算和获取
    it('testLayoutPadding', 0, () => {
      const node = Yoga.createNode();
      node.setWidth(100);
      node.setHeight(100);
      node.setPadding(YogaEdge.START, 1);
      node.setPadding(YogaEdge.END, 2);
      node.setPadding(YogaEdge.TOP, 3);
      node.setPadding(YogaEdge.BOTTOM, 4);
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutPadding(YogaEdge.LEFT))).assertEqual(1);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.RIGHT))).assertEqual(2);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.TOP))).assertEqual(3);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.BOTTOM))).assertEqual(4);
    });

    // 验证布局过程中边框的正确计算和获取
    it('testLayoutBorder', 0, () => {
      const node = Yoga.createNode();
      node.setWidth(100);
      node.setHeight(100);
      node.setBorder(YogaEdge.START, 1);
      node.setBorder(YogaEdge.END, 2);
      node.setBorder(YogaEdge.TOP, 3);
      node.setBorder(YogaEdge.BOTTOM, 4);
      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(Math.floor(node.getLayoutBorder(YogaEdge.LEFT))).assertEqual(1);
      expect(Math.floor(node.getLayoutBorder(YogaEdge.RIGHT))).assertEqual(2);
      expect(Math.floor(node.getLayoutBorder(YogaEdge.TOP))).assertEqual(3);
      expect(Math.floor(node.getLayoutBorder(YogaEdge.BOTTOM))).assertEqual(4);
    });

    // 验证Web默认设置的启用效果
    it('testUseWebDefaults', 0, () => {
      const config = Yoga.createConfig();
      config.setUseWebDefaults(true);
      const node = Yoga.createNode(config);
      expect(node.getFlexDirection()).assertEqual(YogaFlexDirection.ROW);
    });

    // 验证根节点上百分比内边距的计算
    it('testPercentPaddingOnRoot', 0, () => {
      const node = Yoga.createNode();
      node.setPaddingPercent(YogaEdge.ALL, 10);
      node.calculateLayout(50, 50);

      expect(Math.floor(node.getLayoutPadding(YogaEdge.LEFT))).assertEqual(5);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.RIGHT))).assertEqual(5);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.TOP))).assertEqual(5);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.BOTTOM))).assertEqual(5);
    });

    // 验证边缘属性的默认值状态
    it('testDefaultEdgeValues', 0, () => {
      const node = Yoga.createNode();

      const edges = [
        YogaEdge.LEFT, YogaEdge.TOP, YogaEdge.RIGHT, YogaEdge.BOTTOM,
        YogaEdge.START, YogaEdge.END, YogaEdge.HORIZONTAL, YogaEdge.VERTICAL, YogaEdge.ALL
      ];

      for (const edge of edges) {
        expect(node.getMargin(edge).unit).assertEqual(YogaUnit.UNDEFINED);
        expect(node.getPadding(edge).unit).assertEqual(YogaUnit.UNDEFINED);
        expect(node.getPosition(edge).unit).assertEqual(YogaUnit.UNDEFINED);
        expect(YogaConstants.isUndefined(node.getBorder(edge))).assertTrue();
      }
    });

    // 验证新创建节点默认标记为有新布局
    it('initiallyHasNewLayout', 0, () => {
      const root = Yoga.createNode();
      expect(root.hasNewLayout()).assertTrue();
    });

    // 验证布局可见性标记功能
    it('initialLayoutCanBeMarkedSeen', 0, () => {
      const root = Yoga.createNode();
      root.markLayoutSeen();
      expect(root.hasNewLayout()).assertFalse();
    });

    // 验证计算布局后标记为未见状态
    it('calculatingLayoutMarksLayoutAsUnseen', 0, () => {
      const root = Yoga.createNode();
      root.markLayoutSeen();
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      expect(root.hasNewLayout()).assertTrue();
    });

    // 验证计算后的布局可标记为已见
    it('calculatedLayoutCanBeMarkedSeen', 0, () => {
      const root = Yoga.createNode();
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      root.markLayoutSeen();
      expect(root.hasNewLayout()).assertFalse();
    });

    // 验证重新计算布局会标记为未见
    it('recalculatingLayoutDoesMarkAsUnseen', 0, () => {
      const root = Yoga.createNode();
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      root.markLayoutSeen();
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      expect(root.hasNewLayout()).assertTrue();
    });

    // 验证重置操作也会重置布局可见性标记
    it('resetAlsoResetsLayoutSeen', 0, () => {
      const root = Yoga.createNode();
      root.markLayoutSeen();
      root.reset();
      expect(root.hasNewLayout()).assertTrue();
    });

    // 验证布局方向的传递和获取
    it('directionIsPassedThrough', 0, () => {
      const root = Yoga.createNode();

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutDirection()).assertEqual(YogaDirection.RTL);
    });

    // 验证重置API能正确重置所有布局输出数据
    it('testResetApiShouldResetAllLayoutOutputs', 0, () => {
      const config = Yoga.createConfig();
      config.setErrata(YogaErrata.STRETCH_FLEX_BASIS);
      const node = Yoga.createNode(config);
      node.setWidth(100);
      node.setHeight(100);
      node.setMargin(YogaEdge.START, 1);
      node.setMargin(YogaEdge.END, 2);
      node.setMargin(YogaEdge.TOP, 3);
      node.setMargin(YogaEdge.BOTTOM, 4);
      node.setPadding(YogaEdge.START, 1);
      node.setPadding(YogaEdge.END, 2);
      node.setPadding(YogaEdge.TOP, 3);
      node.setPadding(YogaEdge.BOTTOM, 4);
      node.setBorder(YogaEdge.START, 1);
      node.setBorder(YogaEdge.END, 2);
      node.setBorder(YogaEdge.TOP, 3);
      node.setBorder(YogaEdge.BOTTOM, 4);
      node.setDirection(YogaDirection.RTL);
      node.markLayoutSeen();
      node.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode,
        height: number, heightMode: YogaMeasureMode) => {
        return YogaMeasureOutput.make(100, 100);
      });
      node.setBaselineFunction((node: YogaNode, width: number, height: number) => {
        return height;
      });

      node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      node.reset();

      expect(Math.floor(node.getLayoutHeight())).assertEqual(0);
      expect(Math.floor(node.getLayoutWidth())).assertEqual(0);
      expect(Math.floor(node.getLayoutMargin(YogaEdge.LEFT))).assertEqual(0);
      expect(Math.floor(node.getLayoutMargin(YogaEdge.RIGHT))).assertEqual(0);
      expect(Math.floor(node.getLayoutMargin(YogaEdge.TOP))).assertEqual(0);
      expect(Math.floor(node.getLayoutMargin(YogaEdge.BOTTOM))).assertEqual(0);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.LEFT))).assertEqual(0);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.RIGHT))).assertEqual(0);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.TOP))).assertEqual(0);
      expect(Math.floor(node.getLayoutPadding(YogaEdge.BOTTOM))).assertEqual(0);
      expect(Math.floor(node.getLayoutBorder(YogaEdge.LEFT))).assertEqual(0);
      expect(Math.floor(node.getLayoutBorder(YogaEdge.RIGHT))).assertEqual(0);
      expect(Math.floor(node.getLayoutBorder(YogaEdge.TOP))).assertEqual(0);
      expect(Math.floor(node.getLayoutBorder(YogaEdge.BOTTOM))).assertEqual(0);
      expect(node.getLayoutDirection()).assertEqual(YogaDirection.INHERIT);
      expect(node.hasNewLayout()).assertTrue();
    });
  });
}
