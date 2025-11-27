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

export default function yogaFlexWrapTest() {
  describe('YogaFlexWrapTest', () => {

    // 验证纵向排列元素在容器高度不足时的换行布局效果
    it('test_wrap_column', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(30);
      root_child0.setHeight(30);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(30);
      root_child1.setHeight(30);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(30);
      root_child2.setHeight(30);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(30);
      root_child3.setHeight(30);
      root.insertChild(root_child3, 3);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(30);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(30);
      expect(root_child1.getLayoutWidth()).assertEqual(30);
      expect(root_child1.getLayoutHeight()).assertEqual(30);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(60);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(30);

      expect(root_child3.getLayoutX()).assertEqual(30);
      expect(root_child3.getLayoutY()).assertEqual(0);
      expect(root_child3.getLayoutWidth()).assertEqual(30);
      expect(root_child3.getLayoutHeight()).assertEqual(30);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(30);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(30);

      expect(root_child1.getLayoutX()).assertEqual(30);
      expect(root_child1.getLayoutY()).assertEqual(30);
      expect(root_child1.getLayoutWidth()).assertEqual(30);
      expect(root_child1.getLayoutHeight()).assertEqual(30);

      expect(root_child2.getLayoutX()).assertEqual(30);
      expect(root_child2.getLayoutY()).assertEqual(60);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(30);

      expect(root_child3.getLayoutX()).assertEqual(0);
      expect(root_child3.getLayoutY()).assertEqual(0);
      expect(root_child3.getLayoutWidth()).assertEqual(30);
      expect(root_child3.getLayoutHeight()).assertEqual(30);
    });

    // 验证横向排列元素在容器宽度不足时的换行布局效果
    it('test_wrap_row', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(30);
      root_child0.setHeight(30);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(30);
      root_child1.setHeight(30);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(30);
      root_child2.setHeight(30);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(30);
      root_child3.setHeight(30);
      root.insertChild(root_child3, 3);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(60);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(30);

      expect(root_child1.getLayoutX()).assertEqual(30);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(30);
      expect(root_child1.getLayoutHeight()).assertEqual(30);

      expect(root_child2.getLayoutX()).assertEqual(60);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(30);

      expect(root_child3.getLayoutX()).assertEqual(0);
      expect(root_child3.getLayoutY()).assertEqual(30);
      expect(root_child3.getLayoutWidth()).assertEqual(30);
      expect(root_child3.getLayoutHeight()).assertEqual(30);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(60);

      expect(root_child0.getLayoutX()).assertEqual(70);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(30);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(30);
      expect(root_child1.getLayoutHeight()).assertEqual(30);

      expect(root_child2.getLayoutX()).assertEqual(10);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(30);

      expect(root_child3.getLayoutX()).assertEqual(70);
      expect(root_child3.getLayoutY()).assertEqual(30);
      expect(root_child3.getLayoutWidth()).assertEqual(30);
      expect(root_child3.getLayoutHeight()).assertEqual(30);
    });

    // 验证横向换行布局中末端对齐的元素排列效果
    it('test_wrap_row_align_items_flex_end', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.FLEX_END);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(30);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(30);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(30);
      root_child2.setHeight(30);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(30);
      root_child3.setHeight(30);
      root.insertChild(root_child3, 3);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(60);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(20);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(30);
      expect(root_child1.getLayoutY()).assertEqual(10);
      expect(root_child1.getLayoutWidth()).assertEqual(30);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child2.getLayoutX()).assertEqual(60);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(30);

      expect(root_child3.getLayoutX()).assertEqual(0);
      expect(root_child3.getLayoutY()).assertEqual(30);
      expect(root_child3.getLayoutWidth()).assertEqual(30);
      expect(root_child3.getLayoutHeight()).assertEqual(30);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(60);

      expect(root_child0.getLayoutX()).assertEqual(70);
      expect(root_child0.getLayoutY()).assertEqual(20);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(10);
      expect(root_child1.getLayoutWidth()).assertEqual(30);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child2.getLayoutX()).assertEqual(10);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(30);

      expect(root_child3.getLayoutX()).assertEqual(70);
      expect(root_child3.getLayoutY()).assertEqual(30);
      expect(root_child3.getLayoutWidth()).assertEqual(30);
      expect(root_child3.getLayoutHeight()).assertEqual(30);
    });

    // 验证横向换行布局中居中对齐的元素排列效果
    it('test_wrap_row_align_items_center', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(30);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(30);
      root_child1.setHeight(20);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(30);
      root_child2.setHeight(30);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(30);
      root_child3.setHeight(30);
      root.insertChild(root_child3, 3);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(60);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(30);
      expect(root_child1.getLayoutY()).assertEqual(5);
      expect(root_child1.getLayoutWidth()).assertEqual(30);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child2.getLayoutX()).assertEqual(60);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(30);

      expect(root_child3.getLayoutX()).assertEqual(0);
      expect(root_child3.getLayoutY()).assertEqual(30);
      expect(root_child3.getLayoutWidth()).assertEqual(30);
      expect(root_child3.getLayoutHeight()).assertEqual(30);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(60);

      expect(root_child0.getLayoutX()).assertEqual(70);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(5);
      expect(root_child1.getLayoutWidth()).assertEqual(30);
      expect(root_child1.getLayoutHeight()).assertEqual(20);

      expect(root_child2.getLayoutX()).assertEqual(10);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(30);

      expect(root_child3.getLayoutX()).assertEqual(70);
      expect(root_child3.getLayoutY()).assertEqual(30);
      expect(root_child3.getLayoutWidth()).assertEqual(30);
      expect(root_child3.getLayoutHeight()).assertEqual(30);
    });

    // 验证子元素最小主轴尺寸覆盖 flex-basis 时的换行布局效果
    it('test_flex_wrap_children_with_min_main_overriding_flex_basis', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexBasis(50);
      root_child0.setMinWidth(55);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexBasis(50);
      root_child1.setMinWidth(55);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);

      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(55);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(55);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(45);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(55);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(45);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(55);
      expect(root_child1.getLayoutHeight()).assertEqual(50);
    });
  });
}