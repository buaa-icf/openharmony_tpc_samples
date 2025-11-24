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
  YogaPositionType,
  YogaConstants,
  YogaJustify,
  YogaAlign
} from '../../../main/ets/yoga';

export default function yogaBorderTest() {
  describe('YogaBorderTest', () => {

    // 验证绝对定位元素仅设置边框时，布局尺寸等于左右/上下边框之和
    it('test_border_no_size', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setBorder(YogaEdge.LEFT, 10);
      root.setBorder(YogaEdge.TOP, 10);
      root.setBorder(YogaEdge.RIGHT, 10);
      root.setBorder(YogaEdge.BOTTOM, 10);
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

    // 验证容器边框与子元素尺寸的叠加效果
    it('test_border_container_match_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setBorder(YogaEdge.LEFT, 10);
      root.setBorder(YogaEdge.TOP, 10);
      root.setBorder(YogaEdge.RIGHT, 10);
      root.setBorder(YogaEdge.BOTTOM, 10);

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

    // 验证弹性子元素在带边框容器中的尺寸计算
    it('test_border_flex_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setBorder(YogaEdge.LEFT, 10);
      root.setBorder(YogaEdge.TOP, 10);
      root.setBorder(YogaEdge.RIGHT, 10);
      root.setBorder(YogaEdge.BOTTOM, 10);
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

    // 验证子元素在带边框容器中的拉伸行为
    it('test_border_stretch_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setBorder(YogaEdge.LEFT, 10);
      root.setBorder(YogaEdge.TOP, 10);
      root.setBorder(YogaEdge.RIGHT, 10);
      root.setBorder(YogaEdge.BOTTOM, 10);
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

    // 验证居中对齐子元素在不等边框容器中的位置计算
    it('test_border_center_child', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setBorder(YogaEdge.START, 10);
      root.setBorder(YogaEdge.END, 20);
      root.setBorder(YogaEdge.BOTTOM, 20);
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
  });
}