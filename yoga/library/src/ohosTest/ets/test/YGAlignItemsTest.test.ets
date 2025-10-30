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
  YogaGutter
} from '../../../main/ets/yoga';

export default function yogaAlignItemsTest() {
  describe('YogaAlignItemsTest', () => {

    // 测试默认的 stretch 对齐方式下，子元素在没有明确宽度时如何拉伸以填满容器的宽度。
    it('test_align_items_stretch', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试 align-items 设置为 center 时，子元素在交叉轴上的居中对齐效果。
    it('test_align_items_center', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(10);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(45);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(45);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试 align-items 设置为 flex-start 时，子元素在交叉轴上从起始位置对齐的行为。
    it('test_align_items_flex_start', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.FLEX_START);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(10);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试 align-items 设置为 flex-end 时，子元素在交叉轴上从结束位置对齐的行为。
    it('test_align_items_flex_end', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.FLEX_END);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(10);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试在 row 布局方向下，align-items 设置为 baseline 时子元素基线对齐的效果。
    it('test_align_baseline', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(30);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(30);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);
    });

    // 测试当子元素包含嵌套子元素时，align-items: baseline 的基线对齐行为。
    it('test_align_baseline_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(50);
      root_child1_child0.setHeight(10);
      root_child1.insertChild(root_child1_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试在多行布局中，包含嵌套子元素的基线对齐情况。
    it('test_align_baseline_child_multiline', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexDirection(YogaFlexDirection.ROW);
      root_child1.setFlexWrap(YogaWrap.WRAP);
      root_child1.setWidth(50);
      root_child1.setHeight(25);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(25);
      root_child1_child0.setHeight(20);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child1_child1 = Yoga.createNode(config);
      root_child1_child1.setWidth(25);
      root_child1_child1.setHeight(10);
      root_child1.insertChild(root_child1_child1, 1);

      const root_child1_child2 = Yoga.createNode(config);
      root_child1_child2.setWidth(25);
      root_child1_child2.setHeight(20);
      root_child1.insertChild(root_child1_child2, 2);

      const root_child1_child3 = Yoga.createNode(config);
      root_child1_child3.setWidth(25);
      root_child1_child3.setHeight(10);
      root_child1.insertChild(root_child1_child3, 3);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(25);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child1.getLayoutX()).assertEqual(25);
      expect(root_child1_child1.getLayoutY()).assertEqual(0);
      expect(root_child1_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child1_child2.getLayoutX()).assertEqual(0);
      expect(root_child1_child2.getLayoutY()).assertEqual(20);
      expect(root_child1_child2.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child3.getLayoutX()).assertEqual(25);
      expect(root_child1_child3.getLayoutY()).assertEqual(20);
      expect(root_child1_child3.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child3.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(25);

      expect(root_child1_child0.getLayoutX()).assertEqual(25);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child1.getLayoutX()).assertEqual(0);
      expect(root_child1_child1.getLayoutY()).assertEqual(0);
      expect(root_child1_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child1_child2.getLayoutX()).assertEqual(25);
      expect(root_child1_child2.getLayoutY()).assertEqual(20);
      expect(root_child1_child2.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child3.getLayoutX()).assertEqual(0);
      expect(root_child1_child3.getLayoutY()).assertEqual(20);
      expect(root_child1_child3.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child3.getLayoutHeight()).assertEqual(10);
    });

    // 测试当子元素设置了 alignSelf: baseline 覆盖父容器设置时的基线对齐行为。
    it('test_align_baseline_child_multiline_override', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexDirection(YogaFlexDirection.ROW);
      root_child1.setFlexWrap(YogaWrap.WRAP);
      root_child1.setWidth(50);
      root_child1.setHeight(25);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(25);
      root_child1_child0.setHeight(20);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child1_child1 = Yoga.createNode(config);
      root_child1_child1.setAlignSelf(YogaAlign.BASELINE);
      root_child1_child1.setWidth(25);
      root_child1_child1.setHeight(10);
      root_child1.insertChild(root_child1_child1, 1);

      const root_child1_child2 = Yoga.createNode(config);
      root_child1_child2.setWidth(25);
      root_child1_child2.setHeight(20);
      root_child1.insertChild(root_child1_child2, 2);

      const root_child1_child3 = Yoga.createNode(config);
      root_child1_child3.setAlignSelf(YogaAlign.BASELINE);
      root_child1_child3.setWidth(25);
      root_child1_child3.setHeight(10);
      root_child1.insertChild(root_child1_child3, 3);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(25);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child1.getLayoutX()).assertEqual(25);
      expect(root_child1_child1.getLayoutY()).assertEqual(0);
      expect(root_child1_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child1_child2.getLayoutX()).assertEqual(0);
      expect(root_child1_child2.getLayoutY()).assertEqual(20);
      expect(root_child1_child2.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child3.getLayoutX()).assertEqual(25);
      expect(root_child1_child3.getLayoutY()).assertEqual(20);
      expect(root_child1_child3.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child3.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(25);

      expect(root_child1_child0.getLayoutX()).assertEqual(25);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child1.getLayoutX()).assertEqual(0);
      expect(root_child1_child1.getLayoutY()).assertEqual(0);
      expect(root_child1_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child1_child2.getLayoutX()).assertEqual(25);
      expect(root_child1_child2.getLayoutY()).assertEqual(20);
      expect(root_child1_child2.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child3.getLayoutX()).assertEqual(0);
      expect(root_child1_child3.getLayoutY()).assertEqual(20);
      expect(root_child1_child3.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child3.getLayoutHeight()).assertEqual(10);
    });

    // 测试在多行布局中，部分子元素未覆盖 alignSelf 时的基线对齐行为。
    it('test_align_baseline_child_multiline_no_override_on_secondline', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexDirection(YogaFlexDirection.ROW);
      root_child1.setFlexWrap(YogaWrap.WRAP);
      root_child1.setWidth(50);
      root_child1.setHeight(25);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(25);
      root_child1_child0.setHeight(20);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child1_child1 = Yoga.createNode(config);
      root_child1_child1.setWidth(25);
      root_child1_child1.setHeight(10);
      root_child1.insertChild(root_child1_child1, 1);

      const root_child1_child2 = Yoga.createNode(config);
      root_child1_child2.setWidth(25);
      root_child1_child2.setHeight(20);
      root_child1.insertChild(root_child1_child2, 2);

      const root_child1_child3 = Yoga.createNode(config);
      root_child1_child3.setAlignSelf(YogaAlign.BASELINE);
      root_child1_child3.setWidth(25);
      root_child1_child3.setHeight(10);
      root_child1.insertChild(root_child1_child3, 3);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(25);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child1.getLayoutX()).assertEqual(25);
      expect(root_child1_child1.getLayoutY()).assertEqual(0);
      expect(root_child1_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child1_child2.getLayoutX()).assertEqual(0);
      expect(root_child1_child2.getLayoutY()).assertEqual(20);
      expect(root_child1_child2.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child3.getLayoutX()).assertEqual(25);
      expect(root_child1_child3.getLayoutY()).assertEqual(20);
      expect(root_child1_child3.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child3.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(25);

      expect(root_child1_child0.getLayoutX()).assertEqual(25);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child1.getLayoutX()).assertEqual(0);
      expect(root_child1_child1.getLayoutY()).assertEqual(0);
      expect(root_child1_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child1_child2.getLayoutX()).assertEqual(25);
      expect(root_child1_child2.getLayoutY()).assertEqual(20);
      expect(root_child1_child2.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child3.getLayoutX()).assertEqual(0);
      expect(root_child1_child3.getLayoutY()).assertEqual(20);
      expect(root_child1_child3.getLayoutWidth()).assertEqual(25);
      expect(root_child1_child3.getLayoutHeight()).assertEqual(10);
    });

    // 测试带有 top 位置偏移的子元素在基线对齐中的表现。
    it('test_align_baseline_child_top', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPosition(YogaEdge.TOP, 10);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(50);
      root_child1_child0.setHeight(10);
      root_child1.insertChild(root_child1_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试第二个子元素具有 top 偏移时的基线对齐效果。
    it('test_align_baseline_child_top2', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setPosition(YogaEdge.TOP, 5);
      root_child1.setWidth(50);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(50);
      root_child1_child0.setHeight(10);
      root_child1.insertChild(root_child1_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(45);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(45);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试双重嵌套子元素的基线对齐情况。
    it('test_align_baseline_double_nested_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setWidth(50);
      root_child0_child0.setHeight(20);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(50);
      root_child1_child0.setHeight(15);
      root_child1.insertChild(root_child1_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(5);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(15);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(5);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(15);
    });

    // 测试在 column 布局方向下，align-items: baseline 的基线对齐行为。
    it('test_align_baseline_column', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);
    });

    // 测试子元素包含 margin 时的基线对齐效果。
    it('test_align_baseline_child_margin', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setMargin(YogaEdge.LEFT, 5);
      root_child0.setMargin(YogaEdge.TOP, 5);
      root_child0.setMargin(YogaEdge.RIGHT, 5);
      root_child0.setMargin(YogaEdge.BOTTOM, 5);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setMargin(YogaEdge.LEFT, 1);
      root_child1_child0.setMargin(YogaEdge.TOP, 1);
      root_child1_child0.setMargin(YogaEdge.RIGHT, 1);
      root_child1_child0.setMargin(YogaEdge.BOTTOM, 1);
      root_child1_child0.setWidth(50);
      root_child1_child0.setHeight(10);
      root_child1.insertChild(root_child1_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(5);
      expect(root_child0.getLayoutY()).assertEqual(5);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(60);
      expect(root_child1.getLayoutY()).assertEqual(44);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(1);
      expect(root_child1_child0.getLayoutY()).assertEqual(1);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(45);
      expect(root_child0.getLayoutY()).assertEqual(5);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(-10);
      expect(root_child1.getLayoutY()).assertEqual(44);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(-1);
      expect(root_child1_child0.getLayoutY()).assertEqual(1);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试父元素包含 padding 时的基线对齐效果。
    it('test_align_baseline_child_padding', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setPadding(YogaEdge.LEFT, 5);
      root.setPadding(YogaEdge.TOP, 5);
      root.setPadding(YogaEdge.RIGHT, 5);
      root.setPadding(YogaEdge.BOTTOM, 5);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setPadding(YogaEdge.LEFT, 5);
      root_child1.setPadding(YogaEdge.TOP, 5);
      root_child1.setPadding(YogaEdge.RIGHT, 5);
      root_child1.setPadding(YogaEdge.BOTTOM, 5);
      root_child1.setWidth(50);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(50);
      root_child1_child0.setHeight(10);
      root_child1.insertChild(root_child1_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(5);
      expect(root_child0.getLayoutY()).assertEqual(5);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(55);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(5);
      expect(root_child1_child0.getLayoutY()).assertEqual(5);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(45);
      expect(root_child0.getLayoutY()).assertEqual(5);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(-5);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(-5);
      expect(root_child1_child0.getLayoutY()).assertEqual(5);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试在 wrap 模式下的多行基线对齐行为。
    it('test_align_baseline_multiline', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(50);
      root_child1_child0.setHeight(10);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(20);
      root.insertChild(root_child2, 2);

      const root_child2_child0 = Yoga.createNode(config);
      root_child2_child0.setWidth(50);
      root_child2_child0.setHeight(10);
      root_child2.insertChild(root_child2_child0, 0);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(50);
      root_child3.setHeight(50);
      root.insertChild(root_child3, 3);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(100);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child2_child0.getLayoutX()).assertEqual(0);
      expect(root_child2_child0.getLayoutY()).assertEqual(0);
      expect(root_child2_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child2_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(50);
      expect(root_child3.getLayoutY()).assertEqual(60);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(50);
      expect(root_child2.getLayoutY()).assertEqual(100);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child2_child0.getLayoutX()).assertEqual(0);
      expect(root_child2_child0.getLayoutY()).assertEqual(0);
      expect(root_child2_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child2_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(0);
      expect(root_child3.getLayoutY()).assertEqual(60);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(50);
    });

    // 测试在 row 和 column 混合布局中的多行基线对齐情况。
    it('test_align_baseline_multiline_row_and_column', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.BASELINE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidth(50);
      root_child1_child0.setHeight(10);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(20);
      root.insertChild(root_child2, 2);

      const root_child2_child0 = Yoga.createNode(config);
      root_child2_child0.setWidth(50);
      root_child2_child0.setHeight(10);
      root_child2.insertChild(root_child2_child0, 0);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(50);
      root_child3.setHeight(20);
      root.insertChild(root_child3, 3);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(100);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child2_child0.getLayoutX()).assertEqual(0);
      expect(root_child2_child0.getLayoutY()).assertEqual(0);
      expect(root_child2_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child2_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(50);
      expect(root_child3.getLayoutY()).assertEqual(90);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(40);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(50);
      expect(root_child2.getLayoutY()).assertEqual(100);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(20);

      expect(root_child2_child0.getLayoutX()).assertEqual(0);
      expect(root_child2_child0.getLayoutY()).assertEqual(0);
      expect(root_child2_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child2_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(0);
      expect(root_child3.getLayoutY()).assertEqual(90);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(20);
    });

    // 测试子元素尺寸大于父容器且有 margin 时，使用 align-items: center 的布局效果。
    it('test_align_items_center_child_with_margin_bigger_than_parent', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(52);
      root.setHeight(52);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignItems(YogaAlign.CENTER);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setMargin(YogaEdge.LEFT, 10);
      root_child0_child0.setMargin(YogaEdge.RIGHT, 10);
      root_child0_child0.setWidth(52);
      root_child0_child0.setHeight(52);
      root_child0.insertChild(root_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(52);
      expect(root.getLayoutHeight()).assertEqual(52);

      expect(root_child0.getLayoutX()).assertEqual(-10);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0.getLayoutHeight()).assertEqual(52);

      expect(root_child0_child0.getLayoutX()).assertEqual(10);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(52);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(52);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(52);
      expect(root.getLayoutHeight()).assertEqual(52);

      expect(root_child0.getLayoutX()).assertEqual(-10);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0.getLayoutHeight()).assertEqual(52);

      expect(root_child0_child0.getLayoutX()).assertEqual(10);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(52);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(52);
    });

    // 测试子元素尺寸大于父容器且有 margin 时，使用 align-items: flex-end 的布局效果。
    it('test_align_items_flex_end_child_with_margin_bigger_than_parent', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(52);
      root.setHeight(52);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignItems(YogaAlign.FLEX_END);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setMargin(YogaEdge.LEFT, 10);
      root_child0_child0.setMargin(YogaEdge.RIGHT, 10);
      root_child0_child0.setWidth(52);
      root_child0_child0.setHeight(52);
      root_child0.insertChild(root_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(52);
      expect(root.getLayoutHeight()).assertEqual(52);

      expect(root_child0.getLayoutX()).assertEqual(-10);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0.getLayoutHeight()).assertEqual(52);

      expect(root_child0_child0.getLayoutX()).assertEqual(10);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(52);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(52);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(52);
      expect(root.getLayoutHeight()).assertEqual(52);

      expect(root_child0.getLayoutX()).assertEqual(-10);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0.getLayoutHeight()).assertEqual(52);

      expect(root_child0_child0.getLayoutX()).assertEqual(10);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(52);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(52);
    });

    // 测试子元素尺寸大于父容器但无 margin 时，使用 align-items: center 的布局效果。
    it('test_align_items_center_child_without_margin_bigger_than_parent', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(52);
      root.setHeight(52);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignItems(YogaAlign.CENTER);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setWidth(72);
      root_child0_child0.setHeight(72);
      root_child0.insertChild(root_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(52);
      expect(root.getLayoutHeight()).assertEqual(52);

      expect(root_child0.getLayoutX()).assertEqual(-10);
      expect(root_child0.getLayoutY()).assertEqual(-10);
      expect(root_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0.getLayoutHeight()).assertEqual(72);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(72);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(52);
      expect(root.getLayoutHeight()).assertEqual(52);

      expect(root_child0.getLayoutX()).assertEqual(-10);
      expect(root_child0.getLayoutY()).assertEqual(-10);
      expect(root_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0.getLayoutHeight()).assertEqual(72);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(72);
    });

    // 测试子元素尺寸大于父容器但无 margin 时，使用 align-items: flex-end 的布局效果。
    it('test_align_items_flex_end_child_without_margin_bigger_than_parent', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(52);
      root.setHeight(52);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignItems(YogaAlign.FLEX_END);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setWidth(72);
      root_child0_child0.setHeight(72);
      root_child0.insertChild(root_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(52);
      expect(root.getLayoutHeight()).assertEqual(52);

      expect(root_child0.getLayoutX()).assertEqual(-10);
      expect(root_child0.getLayoutY()).assertEqual(-10);
      expect(root_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0.getLayoutHeight()).assertEqual(72);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(72);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(52);
      expect(root.getLayoutHeight()).assertEqual(52);

      expect(root_child0.getLayoutX()).assertEqual(-10);
      expect(root_child0.getLayoutY()).assertEqual(-10);
      expect(root_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0.getLayoutHeight()).assertEqual(72);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(72);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(72);
    });

    // 测试 align-items: center 模式下容器尺寸应基于内容大小的特性。
    it('test_align_center_should_size_based_on_content', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMargin(YogaEdge.TOP, 20);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setJustifyContent(YogaJustify.CENTER);
      root_child0.setFlexShrink(1);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setWidth(20);
      root_child0_child0_child0.setHeight(20);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(20);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(40);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(20);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(40);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(20);
    });

    // 测试默认 stretch 模式下容器尺寸应基于父容器大小的特性。
    it('test_align_stretch_should_size_based_on_parent', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMargin(YogaEdge.TOP, 20);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setJustifyContent(YogaJustify.CENTER);
      root_child0.setFlexShrink(1);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setWidth(20);
      root_child0_child0_child0.setHeight(20);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(20);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(20);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(80);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(20);
    });

    // 测试 align-items: flex-start 下子元素收缩时的布局表现。
    it('test_align_flex_start_with_shrinking_children', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(500);
      root.setHeight(500);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignItems(YogaAlign.FLEX_START);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setFlexGrow(1);
      root_child0_child0_child0.setFlexShrink(1);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(500);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(0);
    });

    // 测试 align-items: flex-start 下子元素拉伸时的布局表现。
    it('test_align_flex_start_with_stretching_children', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(500);
      root.setHeight(500);

      const root_child0 = Yoga.createNode(config);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setFlexGrow(1);
      root_child0_child0_child0.setFlexShrink(1);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(0);
    });

    // 测试同时使用 flex-start 和 stretch 时子元素的收缩行为。
    it('test_align_flex_start_with_shrinking_children_with_stretch', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(500);
      root.setHeight(500);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignItems(YogaAlign.FLEX_START);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setFlexGrow(1);
      root_child0_child0_child0.setFlexShrink(1);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(500);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(500);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(0);
    });

    // 测试在 row-reverse 布局方向下 align-items: flex-end 的对齐效果。
    it('test_align_flex_end_with_row_reverse', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.FLEX_END);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(100);
      root.setHeight(75);

      const root_child0 = Yoga.createNode(config);
      root_child0.setMargin(YogaEdge.LEFT, 3);
      root_child0.setMargin(YogaEdge.RIGHT, 5);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(75);

      expect(root_child0.getLayoutX()).assertEqual(3);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(58);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(75);

      expect(root_child0.getLayoutX()).assertEqual(45);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(-8);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);
    });

    // 测试在 row-reverse 布局方向下的默认 stretch 对齐行为。
    it('test_align_stretch_with_row_reverse', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(100);
      root.setHeight(75);

      const root_child0 = Yoga.createNode(config);
      root_child0.setMargin(YogaEdge.LEFT, 3);
      root_child0.setMargin(YogaEdge.RIGHT, 5);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(75);

      expect(root_child0.getLayoutX()).assertEqual(3);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(58);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(75);

      expect(root_child0.getLayoutX()).assertEqual(45);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(-8);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);
    });
  });
}