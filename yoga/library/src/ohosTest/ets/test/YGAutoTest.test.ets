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

export default function yogaAutoTest() {
  describe('YogaAutoTest', () => {

    // 测试容器宽度设为 auto 时，其宽度根据子元素内容自动调整大小。在 row 布局方向下，容器宽度等于所有子元素宽度之和。
    it('test_auto_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidthAuto();
      root.setHeight(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(50);
      root.insertChild(root_child2, 2);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(150);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child2.getLayoutX()).assertEqual(100);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(150);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(100);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);
    });

    // 测试容器高度设为 auto 时，其高度根据子元素内容自动调整大小。在默认 column 布局方向下，容器高度等于所有子元素高度之和。
    it('test_auto_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(50);
      root.setHeightAuto();

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(50);
      root.insertChild(root_child2, 2);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(150);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(100);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(150);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(100);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);
    });

    // 测试默认情况下容器的自动尺寸计算行为，验证在未明确设置高度时容器如何根据子元素内容确定自身尺寸。
    it('test_auto_flex_basis', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(50);
      root.insertChild(root_child2, 2);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(150);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(100);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(150);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(100);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);
    });

    // 测试子元素的 position 属性设为 auto 时的表现，验证 RIGHT 属性设为 auto 时的布局效果。
    it('test_auto_position', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(50);
      root.setHeight(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionAuto(YogaEdge.RIGHT);
      root_child0.setWidth(25);
      root_child0.setHeight(25);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child0.getLayoutHeight()).assertEqual(25);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(25);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child0.getLayoutHeight()).assertEqual(25);
    });

    // 测试子元素的 margin 属性设为 auto 时的表现，验证 LEFT margin 设为 auto 时是否能实现自动居中或推至右侧的效果。
    it('test_auto_margin', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(50);
      root.setHeight(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setMarginAuto(YogaEdge.LEFT);
      root_child0.setWidth(25);
      root_child0.setHeight(25);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(25);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child0.getLayoutHeight()).assertEqual(25);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(25);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(25);
      expect(root_child0.getLayoutHeight()).assertEqual(25);
    });
  });
}