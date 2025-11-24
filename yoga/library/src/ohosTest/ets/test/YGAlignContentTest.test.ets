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
  YogaGutter
} from '../../../main/ets/yoga';

export default function yogaAlignContentTest() {
  describe('YogaAlignContentTest', () => {

    // 测试在不换行（nowrap）的情况下，使用默认的 align-content: flex-start 对子元素布局的影响。
    it('test_align_content_flex_start_nowrap', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(140);
      root.setHeight(120);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);
    });

    // 测试在允许多行排列（wrap）情况下，align-content 设置为 flex-start 时多行子元素的垂直对齐方式。
    it('test_align_content_flex_start_wrap', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(140);
      root.setHeight(120);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(10);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(50);
      root_child3.setHeight(10);
      root.insertChild(root_child3, 3);

      const root_child4 = Yoga.createNode(config);
      root_child4.setWidth(50);
      root_child4.setHeight(10);
      root.insertChild(root_child4, 4);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(10);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(50);
      expect(root_child3.getLayoutY()).assertEqual(10);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(0);
      expect(root_child4.getLayoutY()).assertEqual(20);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(90);
      expect(root_child2.getLayoutY()).assertEqual(10);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(40);
      expect(root_child3.getLayoutY()).assertEqual(10);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(90);
      expect(root_child4.getLayoutY()).assertEqual(20);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);
    });

    // 测试即使设置了 wrap 模式，但在只有一行子元素时 align-content: flex-start 的表现。
    it('test_align_content_flex_start_wrap_singleline', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(140);
      root.setHeight(120);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);
    });

    // 测试在 wrap 模式下，align-content 设置为 center 时多行子元素在交叉轴上的居中对齐效果。
    it('test_align_content_center_wrap', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignContent(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(140);
      root.setHeight(120);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(10);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(50);
      root_child3.setHeight(10);
      root.insertChild(root_child3, 3);

      const root_child4 = Yoga.createNode(config);
      root_child4.setWidth(50);
      root_child4.setHeight(10);
      root.insertChild(root_child4, 4);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(45);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(45);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(55);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(50);
      expect(root_child3.getLayoutY()).assertEqual(55);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(0);
      expect(root_child4.getLayoutY()).assertEqual(65);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(45);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(45);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(90);
      expect(root_child2.getLayoutY()).assertEqual(55);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(40);
      expect(root_child3.getLayoutY()).assertEqual(55);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(90);
      expect(root_child4.getLayoutY()).assertEqual(65);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);
    });

    // 测试默认的 stretch 模式下，子元素在没有明确高度时如何被拉伸以填满容器的高度。
    it('test_align_content_stretch', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignContent(YogaAlign.STRETCH);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(150);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(50);
      root.insertChild(root_child3, 3);

      const root_child4 = Yoga.createNode(config);
      root_child4.setWidth(50);
      root.insertChild(root_child4, 4);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(150);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(0);

      expect(root_child3.getLayoutX()).assertEqual(0);
      expect(root_child3.getLayoutY()).assertEqual(0);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(0);

      expect(root_child4.getLayoutX()).assertEqual(0);
      expect(root_child4.getLayoutY()).assertEqual(0);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(150);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(100);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child1.getLayoutX()).assertEqual(100);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(0);

      expect(root_child2.getLayoutX()).assertEqual(100);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(0);

      expect(root_child3.getLayoutX()).assertEqual(100);
      expect(root_child3.getLayoutY()).assertEqual(0);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(0);

      expect(root_child4.getLayoutX()).assertEqual(100);
      expect(root_child4.getLayoutY()).assertEqual(0);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(0);
    });

    // 测试在 row 方向的 flex 容器中，align-content: stretch 如何影响子元素的尺寸分配。
    it('test_align_content_stretch_row', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignContent(YogaAlign.STRETCH);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(150);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(50);
      root.insertChild(root_child3, 3);

      const root_child4 = Yoga.createNode(config);
      root_child4.setWidth(50);
      root.insertChild(root_child4, 4);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(150);
      expect(root.getLayoutHeight()).assertEqual(100);

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

      expect(root_child3.getLayoutX()).assertEqual(0);
      expect(root_child3.getLayoutY()).assertEqual(50);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(50);

      expect(root_child4.getLayoutX()).assertEqual(50);
      expect(root_child4.getLayoutY()).assertEqual(50);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(150);
      expect(root.getLayoutHeight()).assertEqual(100);

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

      expect(root_child3.getLayoutX()).assertEqual(100);
      expect(root_child3.getLayoutY()).assertEqual(50);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(50);

      expect(root_child4.getLayoutX()).assertEqual(50);
      expect(root_child4.getLayoutY()).assertEqual(50);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(50);
    });

    // 测试在 wrap 模式下，align-content 设置为 space-between 时多行子元素之间均匀分布的空间安排。
    it('test_align_content_space_between_wrap', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignContent(YogaAlign.SPACE_BETWEEN);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(140);
      root.setHeight(120);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(10);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(50);
      root_child3.setHeight(10);
      root.insertChild(root_child3, 3);

      const root_child4 = Yoga.createNode(config);
      root_child4.setWidth(50);
      root_child4.setHeight(10);
      root.insertChild(root_child4, 4);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(55);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(50);
      expect(root_child3.getLayoutY()).assertEqual(55);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(0);
      expect(root_child4.getLayoutY()).assertEqual(110);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(90);
      expect(root_child2.getLayoutY()).assertEqual(55);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(40);
      expect(root_child3.getLayoutY()).assertEqual(55);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(90);
      expect(root_child4.getLayoutY()).assertEqual(110);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);
    });

    // 测试在 wrap 模式下，align-content 设置为 space-around 时每行周围平均分配空间的效果。
    it('test_align_content_space_around_wrap', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignContent(YogaAlign.SPACE_AROUND);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(140);
      root.setHeight(120);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(10);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(50);
      root_child3.setHeight(10);
      root.insertChild(root_child3, 3);

      const root_child4 = Yoga.createNode(config);
      root_child4.setWidth(50);
      root_child4.setHeight(10);
      root.insertChild(root_child4, 4);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(15);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(root_child1.getLayoutY()).assertEqual(15);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(55);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(50);
      expect(root_child3.getLayoutY()).assertEqual(55);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(0);
      expect(root_child4.getLayoutY()).assertEqual(95);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(root_child0.getLayoutY()).assertEqual(15);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(15);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(90);
      expect(root_child2.getLayoutY()).assertEqual(55);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(40);
      expect(root_child3.getLayoutY()).assertEqual(55);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(90);
      expect(root_child4.getLayoutY()).assertEqual(95);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);
    });

    // 测试在 wrap 模式下，align-content 设置为 space-evenly 时各行间及与边界之间的空间完全均等分布的情形。
    it('test_align_content_space_evenly_wrap', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignContent(YogaAlign.SPACE_EVENLY);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(140);
      root.setHeight(120);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(50);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(50);
      root_child1.setHeight(10);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(50);
      root_child2.setHeight(10);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(50);
      root_child3.setHeight(10);
      root.insertChild(root_child3, 3);

      const root_child4 = Yoga.createNode(config);
      root_child4.setWidth(50);
      root_child4.setHeight(10);
      root.insertChild(root_child4, 4);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(Math.floor(root_child0.getLayoutY())).assertEqual(23);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(50);
      expect(Math.floor(root_child1.getLayoutY())).assertEqual(23);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(Math.floor(root_child2.getLayoutY())).assertEqual(55);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(50);
      expect(Math.floor(root_child3.getLayoutY())).assertEqual(55);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(0);
      expect(Math.floor(root_child4.getLayoutY())).assertEqual(88);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(140);
      expect(root.getLayoutHeight()).assertEqual(120);

      expect(root_child0.getLayoutX()).assertEqual(90);
      expect(Math.floor(root_child0.getLayoutY())).assertEqual(23);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(Math.floor(root_child1.getLayoutY())).assertEqual(23);
      expect(root_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(90);
      expect(Math.floor(root_child2.getLayoutY())).assertEqual(55);
      expect(root_child2.getLayoutWidth()).assertEqual(50);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      expect(root_child3.getLayoutX()).assertEqual(40);
      expect(Math.floor(root_child3.getLayoutY())).assertEqual(55);
      expect(root_child3.getLayoutWidth()).assertEqual(50);
      expect(root_child3.getLayoutHeight()).assertEqual(10);

      expect(root_child4.getLayoutX()).assertEqual(90);
      expect(Math.floor(root_child4.getLayoutY())).assertEqual(88);
      expect(root_child4.getLayoutWidth()).assertEqual(50);
      expect(root_child4.getLayoutHeight()).assertEqual(10);
    });
  });
}