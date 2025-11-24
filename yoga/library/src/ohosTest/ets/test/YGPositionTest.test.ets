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

export default function yogaPositionTest() {
  describe('YogaPositionTest', () => {

    // 验证静态定位元素的左上位置偏移量不会产生效果
    it('test_static_position_insets_have_no_effect_left_top', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.STATIC);
      root_child0.setPosition(YogaEdge.LEFT, 50);
      root_child0.setPosition(YogaEdge.TOP, 50);
      root_child0.setWidth(100);
      root_child0.setHeight(100);
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
      expect(root_child0.getLayoutHeight()).assertEqual(100);

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
    });

    // 验证静态定位元素的右下位置偏移量不会产生效果
    it('test_static_position_insets_have_no_effect_right_bottom', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.STATIC);
      root_child0.setPosition(YogaEdge.RIGHT, 50);
      root_child0.setPosition(YogaEdge.BOTTOM, 50);
      root_child0.setWidth(100);
      root_child0.setHeight(100);
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
      expect(root_child0.getLayoutHeight()).assertEqual(100);

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
    });

    // 验证静态定位容器中绝对定位子元素相对于已定位祖先元素的位置偏移计算
    it('test_static_position_absolute_child_insets_relative_to_positioned_ancestor', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(200);
      root_child0.setHeight(200);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setPositionType(YogaPositionType.STATIC);
      root_child0_child0.setMargin(YogaEdge.LEFT, 100);
      root_child0_child0.setWidth(100);
      root_child0_child0.setHeight(100);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0_child0_child0.setPosition(YogaEdge.LEFT, 50);
      root_child0_child0_child0.setPosition(YogaEdge.TOP, 50);
      root_child0_child0_child0.setWidth(50);
      root_child0_child0_child0.setHeight(50);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child0_child0.getLayoutX()).assertEqual(100);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(-50);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child0_child0.getLayoutX()).assertEqual(100);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(-50);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(50);
    });

    // 验证行反向布局中静态定位容器内绝对定位子元素的位置偏移计算
    it('test_static_position_absolute_child_insets_relative_to_positioned_ancestor_row_reverse', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexDirection(YogaFlexDirection.ROW_REVERSE);
      root_child0.setWidth(200);
      root_child0.setHeight(200);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setPositionType(YogaPositionType.STATIC);
      root_child0_child0.setWidth(100);
      root_child0_child0.setHeight(100);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0_child0_child0.setPosition(YogaEdge.LEFT, 50);
      root_child0_child0_child0.setPosition(YogaEdge.TOP, 50);
      root_child0_child0_child0.setWidth(50);
      root_child0_child0_child0.setHeight(50);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child0_child0.getLayoutX()).assertEqual(100);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(-50);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(50);
    });

    // 验证行反向和列反向布局组合下静态定位容器内绝对定位子元素的位置偏移计算
    it('test_column_reverse_static_position_absolute_child_insets_relative_to_positioned_ancestor_row_reverse', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexDirection(YogaFlexDirection.ROW_REVERSE);
      root_child0.setWidth(200);
      root_child0.setHeight(200);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexDirection(YogaFlexDirection.COLUMN_REVERSE);
      root_child0_child0.setPositionType(YogaPositionType.STATIC);
      root_child0_child0.setWidth(100);
      root_child0_child0.setHeight(100);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0_child0_child0.setPosition(YogaEdge.LEFT, 50);
      root_child0_child0_child0.setPosition(YogaEdge.TOP, 50);
      root_child0_child0_child0.setWidth(50);
      root_child0_child0_child0.setHeight(50);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child0_child0.getLayoutX()).assertEqual(100);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(-50);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(50);
    });
  });
}