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
} from '@ohos/yoga';

export default function yogaFlexDirectionTest() {
  describe('YogaFlexDirectionTest', () => {

    // 验证纵向排列无高度容器的子元素垂直堆叠布局
    it('test_flex_direction_column_no_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setHeight(10);
      root.insertChild(root_child2, 2);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(30);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(10);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(20);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(30);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(10);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(20);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(10);
    });

    // 验证横向排列无宽度容器的子元素水平排列布局
    it('test_flex_direction_row_no_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(10);
      root.insertChild(root_child2, 2);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(30);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(10);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(20);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(30);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(20);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(10);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(100);
    });

    // 验证纵向排列容器中子元素从上到下的布局
    it('test_flex_direction_column', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setHeight(10);
      root.insertChild(root_child2, 2);

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

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(10);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(20);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

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

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(10);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(20);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(10);
    });

    // 验证横向排列容器中子元素从左到右的布局
    it('test_flex_direction_row', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(10);
      root.insertChild(root_child2, 2);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(10);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(20);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(80);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(70);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(100);
    });

    // 验证纵向反向排列容器中子元素从下到上的布局
    it('test_flex_direction_column_reverse', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.COLUMN_REVERSE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setHeight(10);
      root.insertChild(root_child2, 2);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(90);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(80);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(70);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(90);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(80);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(70);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(10);
    });

    // 验证横向反向排列容器中子元素从右到左的布局
    it('test_flex_direction_row_reverse', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW_REVERSE);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(10);
      root.insertChild(root_child2, 2);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(80);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(70);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(10);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(20);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(100);
    });
  });
}