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
  YogaGutter,
  YogaBoxSizing
} from '../../../main/ets/yoga';

export default function yogaBoxSizingTest() {
  describe('YogaBoxSizingTest', () => {

    // 验证内容盒模型下，padding和border会增加到设定的宽高上
    it('test_box_sizing_content_box_simple', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setPadding(YogaEdge.LEFT, 5);
      root.setPadding(YogaEdge.TOP, 5);
      root.setPadding(YogaEdge.RIGHT, 5);
      root.setPadding(YogaEdge.BOTTOM, 5);
      root.setBorder(YogaEdge.LEFT, 10);
      root.setBorder(YogaEdge.TOP, 10);
      root.setBorder(YogaEdge.RIGHT, 10);
      root.setBorder(YogaEdge.BOTTOM, 10);
      root.setWidth(100);
      root.setHeight(100);
      root.setBoxSizing(YogaBoxSizing.CONTENT_BOX);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(130);
      expect(root.getLayoutHeight()).assertEqual(130);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(130);
      expect(root.getLayoutHeight()).assertEqual(130);
    });

    // 验证边框盒模型下，padding和border包含在设定的宽高内
    it('test_box_sizing_border_box_simple', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setPadding(YogaEdge.LEFT, 5);
      root.setPadding(YogaEdge.TOP, 5);
      root.setPadding(YogaEdge.RIGHT, 5);
      root.setPadding(YogaEdge.BOTTOM, 5);
      root.setBorder(YogaEdge.LEFT, 10);
      root.setBorder(YogaEdge.TOP, 10);
      root.setBorder(YogaEdge.RIGHT, 10);
      root.setBorder(YogaEdge.BOTTOM, 10);
      root.setWidth(100);
      root.setHeight(100);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);
    });

    // 验证内容盒模型下百分比宽高的子元素，padding和border会额外增加尺寸
    it('test_box_sizing_content_box_percent', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPadding(YogaEdge.LEFT, 4);
      root_child0.setPadding(YogaEdge.TOP, 4);
      root_child0.setPadding(YogaEdge.RIGHT, 4);
      root_child0.setPadding(YogaEdge.BOTTOM, 4);
      root_child0.setBorder(YogaEdge.LEFT, 16);
      root_child0.setBorder(YogaEdge.TOP, 16);
      root_child0.setBorder(YogaEdge.RIGHT, 16);
      root_child0.setBorder(YogaEdge.BOTTOM, 16);
      root_child0.setWidthPercent(50);
      root_child0.setHeightPercent(25);
      root_child0.setBoxSizing(YogaBoxSizing.CONTENT_BOX);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(90);
      expect(root_child0.getLayoutHeight()).assertEqual(65);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(10);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(90);
      expect(root_child0.getLayoutHeight()).assertEqual(65);
    });

    // 验证边框盒模型下百分比宽高的子元素，padding和border包含在设定尺寸内
    it('test_box_sizing_border_box_percent', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPadding(YogaEdge.LEFT, 4);
      root_child0.setPadding(YogaEdge.TOP, 4);
      root_child0.setPadding(YogaEdge.RIGHT, 4);
      root_child0.setPadding(YogaEdge.BOTTOM, 4);
      root_child0.setBorder(YogaEdge.LEFT, 16);
      root_child0.setBorder(YogaEdge.TOP, 16);
      root_child0.setBorder(YogaEdge.RIGHT, 16);
      root_child0.setBorder(YogaEdge.BOTTOM, 16);
      root_child0.setWidthPercent(50);
      root_child0.setHeightPercent(25);
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
      expect(root_child0.getLayoutHeight()).assertEqual(40);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0.getLayoutHeight()).assertEqual(40);
    });

    // 验证绝对定位元素在内容盒模型下，padding和border对布局的影响
    it('test_box_sizing_content_box_absolute', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setPadding(YogaEdge.LEFT, 12);
      root_child0.setPadding(YogaEdge.TOP, 12);
      root_child0.setPadding(YogaEdge.RIGHT, 12);
      root_child0.setPadding(YogaEdge.BOTTOM, 12);
      root_child0.setBorder(YogaEdge.LEFT, 8);
      root_child0.setBorder(YogaEdge.TOP, 8);
      root_child0.setBorder(YogaEdge.RIGHT, 8);
      root_child0.setBorder(YogaEdge.BOTTOM, 8);
      root_child0.setHeightPercent(25);
      root_child0.setBoxSizing(YogaBoxSizing.CONTENT_BOX);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(40);
      expect(root_child0.getLayoutHeight()).assertEqual(65);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(60);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(40);
      expect(root_child0.getLayoutHeight()).assertEqual(65);
    });

    // 验证绝对定位元素在边框盒模型下，padding和border对布局的影响
    it('test_box_sizing_border_box_absolute', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(100);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setPadding(YogaEdge.LEFT, 12);
      root_child0.setPadding(YogaEdge.TOP, 12);
      root_child0.setPadding(YogaEdge.RIGHT, 12);
      root_child0.setPadding(YogaEdge.BOTTOM, 12);
      root_child0.setBorder(YogaEdge.LEFT, 8);
      root_child0.setBorder(YogaEdge.TOP, 8);
      root_child0.setBorder(YogaEdge.RIGHT, 8);
      root_child0.setBorder(YogaEdge.BOTTOM, 8);
      root_child0.setHeightPercent(25);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(40);
      expect(root_child0.getLayoutHeight()).assertEqual(40);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(100);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(60);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(40);
      expect(root_child0.getLayoutHeight()).assertEqual(40);
    });
  });
}