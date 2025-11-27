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

export default function yogaGapTest() {
  describe('YogaGapTest', () => {

    // 验证横向排列元素在居中对齐时列间距的应用效果
    it('test_column_gap_justify_center', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);
      root.setGap(YogaGutter.COLUMN, 10);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(20);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(20);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(20);
      root.insertChild(root_child2, 2);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(20);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(70);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(20);
      expect(root_child2.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(70);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(20);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(20);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(10);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(20);
      expect(root_child2.getLayoutHeight()).assertEqual(100);
    });

    // 验证换行布局中拉伸对齐时列间距和行间距的分布效果
    it('test_column_gap_wrap_align_stretch', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setAlignContent(YogaAlign.STRETCH);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setWidth(300);
      root.setHeight(300);
      root.setGap(YogaGutter.COLUMN, 5);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setMinWidth(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root_child1.setMinWidth(60);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setFlexGrow(1);
      root_child2.setMinWidth(60);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setFlexGrow(1);
      root_child3.setMinWidth(60);
      root.insertChild(root_child3, 3);

      const root_child4 = Yoga.createNode(config);
      root_child4.setFlexGrow(1);
      root_child4.setMinWidth(60);
      root.insertChild(root_child4, 4);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(300);
      expect(root.getLayoutHeight()).assertEqual(300);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(Math.floor(root_child0.getLayoutWidth())).assertEqual(71);
      expect(root_child0.getLayoutHeight()).assertEqual(150);

      expect(Math.floor(root_child1.getLayoutX())).assertEqual(76);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(Math.floor(root_child1.getLayoutWidth())).assertEqual(72);
      expect(root_child1.getLayoutHeight()).assertEqual(150);

      expect(Math.floor(root_child2.getLayoutX())).assertEqual(153);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(Math.floor(root_child2.getLayoutWidth())).assertEqual(71);
      expect(root_child2.getLayoutHeight()).assertEqual(150);

      expect(Math.floor(root_child3.getLayoutX())).assertEqual(229);
      expect(root_child3.getLayoutY()).assertEqual(0);
      expect(Math.floor(root_child3.getLayoutWidth())).assertEqual(71);
      expect(root_child3.getLayoutHeight()).assertEqual(150);

      expect(root_child4.getLayoutX()).assertEqual(0);
      expect(root_child4.getLayoutY()).assertEqual(150);
      expect(root_child4.getLayoutWidth()).assertEqual(300);
      expect(root_child4.getLayoutHeight()).assertEqual(150);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(300);
      expect(root.getLayoutHeight()).assertEqual(300);

      expect(Math.floor(root_child0.getLayoutX())).assertEqual(229);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(Math.floor(root_child0.getLayoutWidth())).assertEqual(71);
      expect(root_child0.getLayoutHeight()).assertEqual(150);

      expect(Math.floor(root_child1.getLayoutX())).assertEqual(153);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(Math.floor(root_child1.getLayoutWidth())).assertEqual(71);
      expect(root_child1.getLayoutHeight()).assertEqual(150);

      expect(Math.floor(root_child2.getLayoutX())).assertEqual(76);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(Math.floor(root_child2.getLayoutWidth())).assertEqual(72);
      expect(root_child2.getLayoutHeight()).assertEqual(150);

      expect(Math.floor(root_child3.getLayoutX())).assertEqual(0);
      expect(root_child3.getLayoutY()).assertEqual(0);
      expect(Math.floor(root_child3.getLayoutWidth())).assertEqual(71);
      expect(root_child3.getLayoutHeight()).assertEqual(150);

      expect(root_child4.getLayoutX()).assertEqual(0);
      expect(root_child4.getLayoutY()).assertEqual(150);
      expect(root_child4.getLayoutWidth()).assertEqual(300);
      expect(root_child4.getLayoutHeight()).assertEqual(150);
    });

    // 验证子元素和列间距共同决定父容器宽度的计算逻辑
    it('test_column_gap_determines_parent_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setHeight(100);
      root.setGap(YogaGutter.COLUMN, 10);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(10);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(20);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(30);
      root.insertChild(root_child2, 2);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(80);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(20);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(20);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(50);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(80);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(70);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(20);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(30);
      expect(root_child2.getLayoutHeight()).assertEqual(100);
    });

    // 验证使用百分比间距的换行布局中行列间距效果
    it('test_row_gap_percent_wrapping', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setFlexWrap(YogaWrap.WRAP);
      root.setPadding(YogaEdge.LEFT, 10);
      root.setPadding(YogaEdge.TOP, 10);
      root.setPadding(YogaEdge.RIGHT, 10);
      root.setPadding(YogaEdge.BOTTOM, 10);
      root.setWidth(300);
      root.setHeight(700);
      root.setGapPercent(YogaGutter.COLUMN, 10);
      root.setGapPercent(YogaGutter.ROW, 10);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(100);
      root_child0.setHeight(100);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setWidth(100);
      root_child1.setHeight(100);
      root.insertChild(root_child1, 1);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(100);
      root_child2.setHeight(100);
      root.insertChild(root_child2, 2);

      const root_child3 = Yoga.createNode(config);
      root_child3.setWidth(100);
      root_child3.setHeight(100);
      root.insertChild(root_child3, 3);

      const root_child4 = Yoga.createNode(config);
      root_child4.setWidth(100);
      root_child4.setHeight(100);
      root.insertChild(root_child4, 4);
      
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(300);
      expect(root.getLayoutHeight()).assertEqual(700);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(Math.floor(root_child1.getLayoutX())).assertEqual(138);
      expect(root_child1.getLayoutY()).assertEqual(10);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(10);
      expect(Math.floor(root_child2.getLayoutY())).assertEqual(178);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(100);

      expect(Math.floor(root_child3.getLayoutX())).assertEqual(138);
      expect(Math.floor(root_child3.getLayoutY())).assertEqual(178);
      expect(root_child3.getLayoutWidth()).assertEqual(100);
      expect(root_child3.getLayoutHeight()).assertEqual(100);

      expect(root_child4.getLayoutX()).assertEqual(10);
      expect(Math.floor(root_child4.getLayoutY())).assertEqual(346);
      expect(root_child4.getLayoutWidth()).assertEqual(100);
      expect(root_child4.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(300);
      expect(root.getLayoutHeight()).assertEqual(700);

      expect(root_child0.getLayoutX()).assertEqual(190);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(Math.floor(root_child1.getLayoutX())).assertEqual(62);
      expect(root_child1.getLayoutY()).assertEqual(10);
      expect(root_child1.getLayoutWidth()).assertEqual(100);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child2.getLayoutX()).assertEqual(190);
      expect(Math.floor(root_child2.getLayoutY())).assertEqual(178);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(100);

      expect(Math.floor(root_child3.getLayoutX())).assertEqual(62);
      expect(Math.floor(root_child3.getLayoutY())).assertEqual(178);
      expect(root_child3.getLayoutWidth()).assertEqual(100);
      expect(root_child3.getLayoutHeight()).assertEqual(100);

      expect(root_child4.getLayoutX()).assertEqual(190);
      expect(Math.floor(root_child4.getLayoutY())).assertEqual(346);
      expect(root_child4.getLayoutWidth()).assertEqual(100);
      expect(root_child4.getLayoutHeight()).assertEqual(100);
    });
  });
}