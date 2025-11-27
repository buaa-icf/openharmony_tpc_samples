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
  YogaUnit,
  YogaJustify,
  YogaPositionType,
  YogaWrap,
  YogaGutter,
  YogaDisplay
} from '@ohos/yoga';

export default function yogaDisplayTest() {
  describe('YogaDisplayTest', () => {

    // 验证设置为 DISPLAY.NONE 的元素不参与布局，其空间被其他元素占用
    it('test_display_none', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root_child1.setDisplay(YogaDisplay.NONE);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);
    });

    // 验证即使设置了固定尺寸，DISPLAY.NONE 元素仍不显示且不占空间
    it('test_display_none_fixed_size', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(20);
      root_child1.setHeight(20);
      root_child1.setDisplay(YogaDisplay.NONE);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);
    });

    // 验证带有 margin 的 DISPLAY.NONE 元素不参与布局，margin 不影响其他元素
    it('test_display_none_with_margin', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setMargin(YogaEdge.LEFT, 10);
      root_child0.setMargin(YogaEdge.TOP, 10);
      root_child0.setMargin(YogaEdge.RIGHT, 10);
      root_child0.setMargin(YogaEdge.BOTTOM, 10);
      root_child0.setWidth(20);
      root_child0.setHeight(20);
      root_child0.setDisplay(YogaDisplay.NONE);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证 DISPLAY.NONE 的父元素及其子元素都不参与布局
    it('test_display_none_with_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexShrink(1);
      root_child0.setFlexBasisPercent(0);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root_child1.setFlexShrink(1);
      root_child1.setFlexBasisPercent(0);
      root_child1.setDisplay(YogaDisplay.NONE);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setFlexGrow(1);
      root_child1_child0.setFlexShrink(1);
      root_child1_child0.setFlexBasisPercent(0);
      root_child1_child0.setWidth(20);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child2 = Yoga.createNode(config);
      root_child2.setFlexGrow(1);
      root_child2.setFlexShrink(1);
      root_child2.setFlexBasisPercent(0);
      root.insertChild(root_child2, 2);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child2.getLayoutX()).assertEqual(50);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(100);
    });

    // 验证设置了 position 属性但为 DISPLAY.NONE 的元素仍不参与布局
    it('test_display_none_with_position', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root_child1.setPosition(YogaEdge.TOP, 10);
      root_child1.setDisplay(YogaDisplay.NONE);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);
    });

    // 验证绝对定位的 DISPLAY.NONE 元素不参与布局
    it('test_display_none_with_position_absolute', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setWidth(100);
      root_child0.setHeight(100);
      root_child0.setDisplay(YogaDisplay.NONE);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);
    });

    // 验证 DISPLAY.CONTENTS 元素本身不渲染，但其子元素参与布局
    it('test_display_contents', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setDisplay(YogaDisplay.CONTENTS);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0_child0.setFlexBasisPercent(0);
      root_child0_child0.setHeight(10);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child1 = Yoga.createNode(config);
      root_child0_child1.setFlexGrow(1);
      root_child0_child1.setFlexShrink(1);
      root_child0_child1.setFlexBasisPercent(0);
      root_child0_child1.setHeight(20);
      root_child0.insertChild(root_child0_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(50);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);
    });

    // 验证 DISPLAY.CONTENTS 元素忽略自身尺寸设置，仅子元素参与布局
    it('test_display_contents_fixed_size', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root_child0.setDisplay(YogaDisplay.CONTENTS);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0_child0.setFlexBasisPercent(0);
      root_child0_child0.setHeight(10);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child1 = Yoga.createNode(config);
      root_child0_child1.setFlexGrow(1);
      root_child0_child1.setFlexShrink(1);
      root_child0_child1.setFlexBasisPercent(0);
      root_child0_child1.setHeight(20);
      root_child0.insertChild(root_child0_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(50);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);
    });

    // 验证 DISPLAY.CONTENTS 元素的 margin 不生效，但不影响子元素布局
    it('test_display_contents_with_margin', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setMargin(YogaEdge.LEFT, 10);
      root_child0.setMargin(YogaEdge.TOP, 10);
      root_child0.setMargin(YogaEdge.RIGHT, 10);
      root_child0.setMargin(YogaEdge.BOTTOM, 10);
      root_child0.setWidth(20);
      root_child0.setHeight(20);
      root_child0.setDisplay(YogaDisplay.CONTENTS);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证 DISPLAY.CONTENTS 元素的 padding 对其子元素布局有影响
    it('test_display_contents_with_padding', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPadding(YogaEdge.LEFT, 10);
      root_child0.setPadding(YogaEdge.TOP, 10);
      root_child0.setPadding(YogaEdge.RIGHT, 10);
      root_child0.setPadding(YogaEdge.BOTTOM, 10);
      root_child0.setDisplay(YogaDisplay.CONTENTS);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0_child0.setFlexBasisPercent(0);
      root_child0_child0.setHeight(10);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child1 = Yoga.createNode(config);
      root_child0_child1.setFlexGrow(1);
      root_child0_child1.setFlexShrink(1);
      root_child0_child1.setFlexBasisPercent(0);
      root_child0_child1.setHeight(20);
      root_child0.insertChild(root_child0_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(50);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);
    });

    // 验证 DISPLAY.CONTENTS 元素的位置属性对其子元素有影响
    it('test_display_contents_with_position', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPosition(YogaEdge.TOP, 10);
      root_child0.setDisplay(YogaDisplay.CONTENTS);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0_child0.setFlexBasisPercent(0);
      root_child0_child0.setHeight(10);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child1 = Yoga.createNode(config);
      root_child0_child1.setFlexGrow(1);
      root_child0_child1.setFlexShrink(1);
      root_child0_child1.setFlexBasisPercent(0);
      root_child0_child1.setHeight(20);
      root_child0.insertChild(root_child0_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(50);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);
    });

    // 验证绝对定位的 DISPLAY.CONTENTS 元素对其子元素布局的影响
    it('test_display_contents_with_position_absolute', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root_child0.setDisplay(YogaDisplay.CONTENTS);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0_child0.setFlexBasisPercent(0);
      root_child0_child0.setHeight(10);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child1 = Yoga.createNode(config);
      root_child0_child1.setFlexGrow(1);
      root_child0_child1.setFlexShrink(1);
      root_child0_child1.setFlexBasisPercent(0);
      root_child0_child1.setHeight(20);
      root_child0.insertChild(root_child0_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(50);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(20);
    });

    // 验证嵌套的 DISPLAY.CONTENTS 元素，所有容器都不渲染只有最内层子元素参与布局
    it('test_display_contents_nested', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setDisplay(YogaDisplay.CONTENTS);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setDisplay(YogaDisplay.CONTENTS);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setFlexGrow(1);
      root_child0_child0_child0.setFlexShrink(1);
      root_child0_child0_child0.setFlexBasisPercent(0);
      root_child0_child0_child0.setHeight(10);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);

      const root_child0_child0_child1 = Yoga.createNode(config);
      root_child0_child0_child1.setFlexGrow(1);
      root_child0_child0_child1.setFlexShrink(1);
      root_child0_child0_child1.setFlexBasisPercent(0);
      root_child0_child0_child1.setHeight(20);
      root_child0_child0.insertChild(root_child0_child0_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child0_child1.getLayoutX()).assertEqual(50);
      expect(root_child0_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child1.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child0_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child1.getLayoutHeight()).assertEqual(20);
    });

    // 验证 DISPLAY.CONTENTS 元素与其兄弟元素共同参与布局的情况
    it('test_display_contents_with_siblings', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexShrink(1);
      root_child0.setFlexBasisPercent(0);
      root_child0.setHeight(30);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setDisplay(YogaDisplay.CONTENTS);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setFlexGrow(1);
      root_child1_child0.setFlexShrink(1);
      root_child1_child0.setFlexBasisPercent(0);
      root_child1_child0.setHeight(10);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child1_child1 = Yoga.createNode(config);
      root_child1_child1.setFlexGrow(1);
      root_child1_child1.setFlexShrink(1);
      root_child1_child1.setFlexBasisPercent(0);
      root_child1_child1.setHeight(20);
      root_child1.insertChild(root_child1_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setFlexGrow(1);
      root_child2.setFlexShrink(1);
      root_child2.setFlexBasisPercent(0);
      root_child2.setHeight(30);
      root.insertChild(root_child2, 2);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child0.getLayoutHeight()).assertEqual(30);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      expect(root_child1_child0.getLayoutX()).assertEqual(25);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1_child1.getLayoutX()).assertEqual(50);
      expect(root_child1_child1.getLayoutY()).assertEqual(0);
      expect(root_child1_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child2.getLayoutX()).assertEqual(75);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(25);
      expect(root_child2.getLayoutHeight()).assertEqual(30);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(75);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child0.getLayoutHeight()).assertEqual(30);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      expect(root_child1_child0.getLayoutX()).assertEqual(50);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1_child1.getLayoutX()).assertEqual(25);
      expect(root_child1_child1.getLayoutY()).assertEqual(0);
      expect(root_child1_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(25);
      expect(root_child2.getLayoutHeight()).assertEqual(30);
    });
  });
}