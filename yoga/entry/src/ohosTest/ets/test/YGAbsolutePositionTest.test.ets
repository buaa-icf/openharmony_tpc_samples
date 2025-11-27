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
  YogaJustify,
  YogaPositionType,
  YogaWrap,
  YogaOverflow
} from '@ohos/yoga';

export default function yogaAbsolutePositionTest() {
  describe('YogaAbsolutePositionTest', () => {

    // 测试绝对定位子元素使用 START 和 TOP 属性定位的情况，在 LTR 和 RTL 布局方向下的位置表现。
    it('test_absolute_layout_width_height_start_top', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setPosition(YogaEdge.START, 10);
      root_child0.setPosition(YogaEdge.TOP, 10);
      root_child0.setWidth(10);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(80);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试绝对定位子元素使用 END 和 BOTTOM 属性定位的情况，在不同布局方向（LTR/RTL）下的坐标变化。
    it('test_absolute_layout_width_height_end_bottom', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setPosition(YogaEdge.END, 10);
      root_child0.setPosition(YogaEdge.BOTTOM, 10);
      root_child0.setWidth(10);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(80);
      expect(root_child0.getLayoutY()).assertEqual(80);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(80);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 测试当绝对定位子元素同时设置 START/TOP 和 END/BOTTOM 时，其拉伸并根据父容器尺寸调整宽高的行为。
    it('test_absolute_layout_start_top_end_bottom', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setPosition(YogaEdge.START, 10);
      root_child0.setPosition(YogaEdge.TOP, 10);
      root_child0.setPosition(YogaEdge.END, 10);
      root_child0.setPosition(YogaEdge.BOTTOM, 10);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(80);
      expect(root_child0.getLayoutHeight()).assertEqual(80);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(80);
      expect(root_child0.getLayoutHeight()).assertEqual(80);
    });

    // 验证在设置了居中对齐方式（justifyContent 和 alignItems）的父容器中，绝对定位子元素的位置计算是否正确。
    it('test_absolute_layout_align_items_and_justify_content_center', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexGrow(1);
      root.setWidth(110);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setWidth(60);
      root_child0.setHeight(40);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(110);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(25);
      expect(root_child0.getLayoutY()).assertEqual(30);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(40);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(110);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(25);
      expect(root_child0.getLayoutY()).assertEqual(30);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(40);
    });

    // 测试绝对定位子元素使用百分比形式设置 TOP、BOTTOM 或两者时相对于父容器高度的定位效果。
    it('test_absolute_layout_percentage_bottom_based_on_parent_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setPositionPercent(YogaEdge.TOP, 50);
      root_child0.setWidth(10);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setPositionType(YogaPositionType.ABSOLUTE);
      root_child1.setPositionPercent(YogaEdge.BOTTOM, 50);
      root_child1.setWidth(10);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setPositionType(YogaPositionType.ABSOLUTE);
      root_child2.setPositionPercent(YogaEdge.TOP, 10);
      root_child2.setPositionPercent(YogaEdge.BOTTOM, 10);
      root_child2.setWidth(10);
      root.insertChild(root_child2, 2);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(100);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(90);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(20);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(160);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(100);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(90);
      expect(root_child1.getLayoutY()).assertEqual(90);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(90);
      expect(root_child2.getLayoutY()).assertEqual(20);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(160);
    });

    // 检查在 flex-wrap 为 WRAP_REVERSE 的列布局容器中，绝对定位子元素的位置表现。
    it('test_absolute_layout_in_wrap_reverse_column_container', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP_REVERSE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setWidth(20);
      root_child0.setHeight(20);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(80);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0.getLayoutHeight()).assertEqual(20);
    });

    // 检查在 flex-wrap 为 WRAP_REVERSE 的行布局容器中，绝对定位子元素的位置表现。
    it('test_absolute_layout_in_wrap_reverse_row_container', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP_REVERSE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setWidth(20);
      root_child0.setHeight(20);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(80);
      expect(root_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(80);
      expect(root_child0.getLayoutY()).assertEqual(80);
      expect(root_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0.getLayoutHeight()).assertEqual(20);
    });
  });
}