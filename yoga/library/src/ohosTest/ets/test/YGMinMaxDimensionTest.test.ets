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

export default function yogaMinMaxDimensionTest() {
  describe('YogaMinMaxDimensionTest', () => {

    // 验证最大宽度限制元素宽度的效果
    it('test_max_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setMaxWidth(50);
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
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 验证最大高度限制元素高度的效果
    it('test_max_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(10);
      root_child0.setMaxHeight(50);
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
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(50);
    });

    // 验证在最小最大高度约束下居中对齐的布局效果
    it('test_justify_content_min_max', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setMinHeight(100);
      root.setMaxHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(60);
      root_child0.setHeight(60);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(20);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(40);
      expect(root_child0.getLayoutY()).assertEqual(20);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(60);
    });

    // 验证在最小最大宽度约束下项目对齐的布局效果
    it('test_align_items_min_max', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMinWidth(100);
      root.setMaxWidth(200);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(60);
      root_child0.setHeight(60);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(20);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(20);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(60);
    });

    // 验证内容超出最小最大高度约束时的溢出布局效果
    it('test_justify_content_overflow_min_max', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMinHeight(100);
      root.setMaxHeight(110);

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
      expect(root.getLayoutHeight()).assertEqual(110);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(-20);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(30);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(80);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(50);
      expect(root.getLayoutHeight()).assertEqual(110);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(-20);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(30);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(80);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(50);
    });

    // 验证弹性增长元素在最小最大高度约束下的尺寸计算
    it('test_flex_grow_to_min', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setMinHeight(100);
      root.setMaxHeight(500);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexShrink(1);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
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

    // 验证在 at most 约束容器中弹性增长元素的布局行为
    it('test_flex_grow_in_at_most_container', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignItems(YogaAlign.FLEX_START);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexDirection(YogaFlexDirection.ROW);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexBasis(0);
      root_child0.insertChild(root_child0_child0, 0);
      
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

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(100);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(0);
    });

    // 验证弹性子元素在无约束容器中的增长行为
    it('test_flex_grow_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasis(0);
      root_child0.setHeight(100);
      root.insertChild(root_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(100);
    });

    // 验证纵向布局中弹性元素在最小最大高度约束下的行为
    it('test_flex_grow_within_constrained_min_max_column', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMinHeight(100);
      root.setMaxHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(50);
    });

    // 验证弹性元素在最大宽度约束下的布局效果
    it('test_flex_grow_within_max_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexDirection(YogaFlexDirection.ROW);
      root_child0.setMaxWidth(100);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setHeight(20);
      root_child0.insertChild(root_child0_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(100);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);
    });

    // 验证弹性元素在受限最大宽度约束下的布局效果
    it('test_flex_grow_within_constrained_max_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexDirection(YogaFlexDirection.ROW);
      root_child0.setMaxWidth(300);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setHeight(20);
      root_child0.insertChild(root_child0_child0, 0);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(20);
    });

    // 验证根节点的 flex-grow 属性被忽略的情况
    it('test_flex_root_ignored', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexGrow(1);
      root.setWidth(100);
      root.setMinHeight(100);
      root.setMaxHeight(500);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasis(200);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setHeight(100);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(300);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(200);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(300);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(200);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证嵌套弹性元素在最小化根节点中的布局效果
    it('test_flex_grow_root_minimized', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setMinHeight(100);
      root.setMaxHeight(500);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setMinHeight(100);
      root_child0.setMaxHeight(500);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexBasis(200);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child1 = Yoga.createNode(config);
      root_child0_child1.setHeight(100);
      root_child0.insertChild(root_child0_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(300);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(300);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(200);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(300);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(300);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(200);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证弹性元素在最大化高度容器中的布局效果
    it('test_flex_grow_height_maximized', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(500);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setMinHeight(100);
      root_child0.setMaxHeight(500);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexGrow(1);
      root_child0_child0.setFlexBasis(200);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child1 = Yoga.createNode(config);
      root_child0_child1.setHeight(100);
      root_child0.insertChild(root_child0_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(500);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(400);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(400);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(500);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(400);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(400);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证横向布局中弹性元素在最小宽度约束下的行为
    it('test_flex_grow_within_constrained_min_row', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMinWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
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

    // 验证纵向布局中弹性元素在最小高度约束下的行为
    it('test_flex_grow_within_constrained_min_column', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMinHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setHeight(50);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(0);
      expect(root_child1.getLayoutHeight()).assertEqual(50);
    });

    // 验证横向布局中弹性元素在最大宽度约束下的行为
    it('test_flex_grow_within_constrained_max_row', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexDirection(YogaFlexDirection.ROW);
      root_child0.setMaxWidth(100);
      root_child0.setHeight(100);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexShrink(1);
      root_child0_child0.setFlexBasis(100);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child1 = Yoga.createNode(config);
      root_child0_child1.setWidth(50);
      root_child0.insertChild(root_child0_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child1.getLayoutX()).assertEqual(50);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(100);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(100);
    });

    // 验证纵向布局中弹性元素在最大高度约束下的行为
    it('test_flex_grow_within_constrained_max_column', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setMaxHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexShrink(1);
      root_child0.setFlexBasis(100);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
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

    // 验证子元素最小最大宽度在弹性布局中的效果
    it('test_child_min_max_width_flexing', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(120);
      root.setHeight(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasis(0);
      root_child0.setMinWidth(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root_child1.setFlexBasisPercent(50);
      root_child1.setMaxWidth(20);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(120);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(100);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(20);
      expect(root_child1.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(120);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(20);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(20);
      expect(root_child1.getLayoutHeight()).assertEqual(50);
    });

    // 验证最小宽度优先级高于显式宽度设置
    it('test_min_width_overrides_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(50);
      root.setMinWidth(100);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(0);
    });

    // 验证最大宽度优先级高于显式宽度设置
    it('test_max_width_overrides_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setMaxWidth(100);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(0);
    });

    // 验证最小高度优先级高于显式高度设置
    it('test_min_height_overrides_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setHeight(50);
      root.setMinHeight(100);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);
    });

    // 验证最大高度优先级高于显式高度设置
    it('test_max_height_overrides_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setHeight(200);
      root.setMaxHeight(100);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(100);
    });

    // 验证百分比最小最大尺寸在无显式尺寸时的计算效果
    it('test_min_max_percent_no_width_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.FLEX_START);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setMinWidthPercent(10);
      root_child0.setMaxWidthPercent(10);
      root_child0.setMinHeightPercent(10);
      root_child0.setMaxHeightPercent(10);
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
  });
}