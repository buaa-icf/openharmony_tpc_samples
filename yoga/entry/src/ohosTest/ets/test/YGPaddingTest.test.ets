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

export default function yogaPaddingTest() {
  describe('YogaPaddingTest', () => {

    // 验证仅设置内边距时元素尺寸等于内边距之和
    it('test_padding_no_size', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setPadding(YogaEdge.LEFT, 10);
      root.setPadding(YogaEdge.TOP, 10);
      root.setPadding(YogaEdge.RIGHT, 10);
      root.setPadding(YogaEdge.BOTTOM, 10);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(20);
      expect(root.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(20);
      expect(root.getLayoutHeight()).assertEqual(20);
    });

    // 验证容器内边距与子元素尺寸的叠加效果
    it('test_padding_container_match_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setPadding(YogaEdge.LEFT, 10);
      root.setPadding(YogaEdge.TOP, 10);
      root.setPadding(YogaEdge.RIGHT, 10);
      root.setPadding(YogaEdge.BOTTOM, 10);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(10);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(30);
      expect(root.getLayoutHeight()).assertEqual(30);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(30);
      expect(root.getLayoutHeight()).assertEqual(30);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 验证弹性子元素在带内边距容器中的尺寸计算
    it('test_padding_flex_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setPadding(YogaEdge.LEFT, 10);
      root.setPadding(YogaEdge.TOP, 10);
      root.setPadding(YogaEdge.RIGHT, 10);
      root.setPadding(YogaEdge.BOTTOM, 10);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setWidth(10);
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
      expect(root_child0.getLayoutHeight()).assertEqual(80);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(80);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(80);
    });

    // 验证拉伸子元素在带内边距容器中的尺寸适应
    it('test_padding_stretch_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setPadding(YogaEdge.LEFT, 10);
      root.setPadding(YogaEdge.TOP, 10);
      root.setPadding(YogaEdge.RIGHT, 10);
      root.setPadding(YogaEdge.BOTTOM, 10);
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

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(80);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(80);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 验证居中对齐子元素在不等内边距容器中的位置计算
    it('test_padding_center_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setPadding(YogaEdge.START, 10);
      root.setPadding(YogaEdge.END, 20);
      root.setPadding(YogaEdge.BOTTOM, 20);
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

      expect(root_child0.getLayoutX()).assertEqual(40);
      expect(root_child0.getLayoutY()).assertEqual(35);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(35);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 验证带内边距子元素在末端对齐时的布局效果
    it('test_child_with_padding_align_end', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.FLEX_END);
      root.setAlignItems(YogaAlign.FLEX_END);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPadding(YogaEdge.LEFT, 20);
      root_child0.setPadding(YogaEdge.TOP, 20);
      root_child0.setPadding(YogaEdge.RIGHT, 20);
      root_child0.setPadding(YogaEdge.BOTTOM, 20);
      root_child0.setWidth(100);
      root_child0.setHeight(100);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(100);
      expect(root_child0.getLayoutY()).assertEqual(100);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(100);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);
    });

    // 验证同时定义物理和相对边缘内边距时的布局行为
    it('test_physical_and_relative_edge_defined', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setPadding(YogaEdge.LEFT, 20);
      root.setPadding(YogaEdge.END, 50);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidthPercent(100);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(20);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(130);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(150);
      expect(root_child0.getLayoutHeight()).assertEqual(50);
    });
  });
}