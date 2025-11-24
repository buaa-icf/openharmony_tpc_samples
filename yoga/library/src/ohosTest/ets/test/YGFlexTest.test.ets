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
  YogaFlexDirection,
  YogaPositionType,
  YogaConstants
} from '../../../main/ets/yoga';

export default function yogaFlexTest() {
  describe('YogaFlexTest', () => {
    // Helper functions
    let createNode: () => YogaNode = (): YogaNode => {
      return Yoga.createNode();
    };

    // 验证纵向布局中 flex-basis 和 flex-grow 的组合效果
    it('test_flex_basis_flex_grow_column', 0, () => {
      const root = createNode();
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = createNode();
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasis(50);
      root.insertChild(root_child0, 0);

      const root_child1 = createNode();
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
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(75);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(75);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(25);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(75);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(75);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(25);
    });

    // 验证横向布局中两个可收缩元素的宽度平分效果
    it('test_flex_shrink_flex_grow_row', 0, () => {
      const root = createNode();
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(500);
      root.setHeight(500);

      const root_child0 = createNode();
      root_child0.setFlexShrink(1);
      root_child0.setWidth(500);
      root_child0.setHeight(100);
      root.insertChild(root_child0, 0);

      const root_child1 = createNode();
      root_child1.setFlexShrink(1);
      root_child1.setWidth(500);
      root_child1.setHeight(100);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(250);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(250);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(250);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(250);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(250);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(250);
      expect(root_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证横向布局中一个可收缩元素和一个可增长元素的尺寸分配
    it('test_flex_shrink_flex_grow_child_flex_shrink_other_child', 0, () => {
      const root = createNode();
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(500);
      root.setHeight(500);

      const root_child0 = createNode();
      root_child0.setFlexShrink(1);
      root_child0.setWidth(500);
      root_child0.setHeight(100);
      root.insertChild(root_child0, 0);

      const root_child1 = createNode();
      root_child1.setFlexGrow(1);
      root_child1.setFlexShrink(1);
      root_child1.setWidth(500);
      root_child1.setHeight(100);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(250);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(250);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(250);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(250);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(250);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(250);
      expect(root_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证横向布局中 flex-basis 和 flex-grow 的组合效果
    it('test_flex_basis_flex_grow_row', 0, () => {
      const root = createNode();
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = createNode();
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasis(50);
      root.insertChild(root_child0, 0);

      const root_child1 = createNode();
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
      expect(root_child0.getLayoutWidth()).assertEqual(75);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(75);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(25);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(75);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(25);
      expect(root_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证纵向布局中 flex-basis 和 flex-shrink 的组合效果
    it('test_flex_basis_flex_shrink_column', 0, () => {
      const root = createNode();
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = createNode();
      root_child0.setFlexShrink(1);
      root_child0.setFlexBasis(100);
      root.insertChild(root_child0, 0);

      const root_child1 = createNode();
      root_child1.setFlexBasis(50);
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
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(50);
    });

    // 验证横向布局中 flex-basis 和 flex-shrink 的组合效果
    it('test_flex_basis_flex_shrink_row', 0, () => {
      const root = createNode();
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = createNode();
      root_child0.setFlexShrink(1);
      root_child0.setFlexBasis(100);
      root.insertChild(root_child0, 0);

      const root_child1 = createNode();
      root_child1.setFlexBasis(50);
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
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

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
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证元素在空间不足时可收缩至零高度的效果
    it('test_flex_shrink_to_zero', 0, () => {
      const root = createNode();
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setHeight(75);

      const root_child0 = createNode();
      root_child0.setWidth(50);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = createNode();
      root_child1.setFlexShrink(1);
      root_child1.setWidth(50);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);

      const root_child2 = createNode();
      root_child2.setWidth(50);
      root_child2.setHeight(50);
      root.insertChild(root_child2, 2);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(75);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(50);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(75);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(50);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);
    });

    // 验证 flex-basis 优先级高于显式设置的宽/高属性
    it('test_flex_basis_overrides_main_size', 0, () => {
      const root = createNode();
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = createNode();
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasis(50);
      root_child0.setHeight(20);
      root.insertChild(root_child0, 0);

      const root_child1 = createNode();
      root_child1.setFlexGrow(1);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = createNode();
      root_child2.setFlexGrow(1);
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
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(60);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(80);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(60);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(80);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(20);
    });

    // 验证在 at most 约束下 flex-grow 和 flex-shrink 的行为
    it('test_flex_grow_shrink_at_most', 0, () => {
      const root = createNode();
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = createNode();
      root.insertChild(root_child0, 0);

      const root_child0_child0 = createNode();
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexShrink(1);
      root_child0.insertChild(root_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);
    });

    // 验证小于1的 flex-grow 因子的效果
    it('test_flex_grow_less_than_factor_one', 0, () => {
      const root = createNode();
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(500);

      const root_child0 = createNode();
      root_child0.setFlexGrow(0.2);
      root_child0.setFlexBasis(40);
      root.insertChild(root_child0, 0);

      const root_child1 = createNode();
      root_child1.setFlexGrow(0.2);
      root.insertChild(root_child1, 1);

      const root_child2 = createNode();
      root_child2.setFlexGrow(0.4);
      root.insertChild(root_child2, 2);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(Math.floor(root_child0.getLayoutHeight())).assertEqual(132);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(132);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(Math.floor(root_child1.getLayoutHeight())).assertEqual(92);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(224);
      expect(root_child2.getLayoutWidth()).assertEqual(200);
      expect(Math.floor(root_child2.getLayoutHeight())).assertEqual(184);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(Math.floor(root_child0.getLayoutHeight())).assertEqual(132);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(132);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(Math.floor(root_child1.getLayoutHeight())).assertEqual(92);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(224);
      expect(root_child2.getLayoutWidth()).assertEqual(200);
      expect(Math.floor(root_child2.getLayoutHeight())).assertEqual(184);
    });
  });
}