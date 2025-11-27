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
  YogaWrap
} from '@ohos/yoga';

export default function yogaJustifyContentTest() {
  describe('YogaJustifyContentTest', () => {

    // 验证横向布局中元素在起始位置对齐的效果
    it('test_justify_content_row_flex_start', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(102);
      root.setHeight(102);

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
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(10);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(20);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(92);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(82);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(72);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);
    });

    // 验证横向布局中元素在末尾位置对齐的效果
    it('test_justify_content_row_flex_end', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setJustifyContent(YogaJustify.FLEX_END);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(102);
      root.setHeight(102);

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
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(72);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(82);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(92);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(20);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(10);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);
    });

    // 验证横向布局中元素居中对齐的效果
    it('test_justify_content_row_center', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(102);
      root.setHeight(102);

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
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(36);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(46);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(56);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(56);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(46);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(36);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);
    });

    // 验证横向布局中元素之间平均分布间距的效果
    it('test_justify_content_row_space_between', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setJustifyContent(YogaJustify.SPACE_BETWEEN);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(102);
      root.setHeight(102);

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
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(46);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(92);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(92);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(46);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);
    });

    // 验证横向布局中元素周围平均分布间距的效果
    it('test_justify_content_row_space_around', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setJustifyContent(YogaJustify.SPACE_AROUND);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(102);
      root.setHeight(102);

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
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(12);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(46);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(80);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(80);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(102);

      expect(root_child1.getLayoutX()).assertEqual(46);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(10);
      expect(root_child1.getLayoutHeight()).assertEqual(102);

      expect(root_child2.getLayoutX()).assertEqual(12);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(10);
      expect(root_child2.getLayoutHeight()).assertEqual(102);
    });

    // 验证纵向布局中元素均匀分布间距的效果
    it('test_justify_content_column_space_evenly', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.SPACE_EVENLY);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(102);
      root.setHeight(102);

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
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(18);
      expect(root_child0.getLayoutWidth()).assertEqual(102);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(46);
      expect(root_child1.getLayoutWidth()).assertEqual(102);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(74);
      expect(root_child2.getLayoutWidth()).assertEqual(102);
      expect(root_child2.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(102);
      expect(root.getLayoutHeight()).assertEqual(102);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(18);
      expect(root_child0.getLayoutWidth()).assertEqual(102);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(46);
      expect(root_child1.getLayoutWidth()).assertEqual(102);
      expect(root_child1.getLayoutHeight()).assertEqual(10);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(74);
      expect(root_child2.getLayoutWidth()).assertEqual(102);
      expect(root_child2.getLayoutHeight()).assertEqual(10);
    });
  });
}