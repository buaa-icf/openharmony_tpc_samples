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

export default function yogaAlignSelfTest() {
  describe('YogaAlignSelfTest', () => {

    // 测试子元素通过 alignSelf: center 在交叉轴上居中对齐的效果。
    it('test_align_self_center', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignSelf(YogaAlign.CENTER);
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

    // 测试子元素通过 alignSelf: flex-end 在交叉轴末端对齐的效果。
    it('test_align_self_flex_end', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignSelf(YogaAlign.FLEX_END);
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

    // 测试子元素通过 alignSelf: flex-start 在交叉轴起始端对齐的效果。
    it('test_align_self_flex_start', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignSelf(YogaAlign.FLEX_START);
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

    // 测试子元素使用 alignSelf: flex-end 覆盖父容器设置的 alignItems: flex-start 的效果。
    it('test_align_self_flex_end_override_flex_start', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.FLEX_START);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignSelf(YogaAlign.FLEX_END);
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

    // 测试在 row 布局方向下，多个子元素通过 alignSelf: baseline 实现基线对齐的情况，包括嵌套子元素的处理。
    it('test_align_self_baseline', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setAlignSelf(YogaAlign.BASELINE);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setAlignSelf(YogaAlign.BASELINE);
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
  });
}