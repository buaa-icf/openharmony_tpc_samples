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

export default function yogaPercentageTest() {
  describe('YogaPercentageTest', () => {

    // 验证子元素百分比宽高的计算效果
    it('test_percentage_width_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidthPercent(30);
      root_child0.setHeightPercent(30);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(140);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(60);
    });

    // 验证相对父容器的百分比定位(左上)效果
    it('test_percentage_position_left_top', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(400);
      root.setHeight(400);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionPercent(YogaEdge.LEFT, 10);
      root_child0.setPositionPercent(YogaEdge.TOP, 20);
      root_child0.setWidthPercent(45);
      root_child0.setHeightPercent(55);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(400);
      expect(root.getLayoutHeight()).assertEqual(400);

      expect(root_child0.getLayoutX()).assertEqual(40);
      expect(root_child0.getLayoutY()).assertEqual(80);
      expect(root_child0.getLayoutWidth()).assertEqual(180);
      expect(root_child0.getLayoutHeight()).assertEqual(220);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(400);
      expect(root.getLayoutHeight()).assertEqual(400);

      expect(root_child0.getLayoutX()).assertEqual(260);
      expect(root_child0.getLayoutY()).assertEqual(80);
      expect(root_child0.getLayoutWidth()).assertEqual(180);
      expect(root_child0.getLayoutHeight()).assertEqual(220);
    });

    // 验证相对父容器的百分比定位(右下)效果
    it('test_percentage_position_bottom_right', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(500);
      root.setHeight(500);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionPercent(YogaEdge.RIGHT, 20);
      root_child0.setPositionPercent(YogaEdge.BOTTOM, 10);
      root_child0.setWidthPercent(55);
      root_child0.setHeightPercent(15);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(-100);
      expect(root_child0.getLayoutY()).assertEqual(-50);
      expect(root_child0.getLayoutWidth()).assertEqual(275);
      expect(root_child0.getLayoutHeight()).assertEqual(75);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(500);
      expect(root.getLayoutHeight()).assertEqual(500);

      expect(root_child0.getLayoutX()).assertEqual(125);
      expect(root_child0.getLayoutY()).assertEqual(-50);
      expect(root_child0.getLayoutWidth()).assertEqual(275);
      expect(root_child0.getLayoutHeight()).assertEqual(75);
    });

    // 验证横向布局中百分比弹性基准值的计算
    it('test_percentage_flex_basis', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasisPercent(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root_child1.setFlexBasisPercent(25);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(125);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child1.getLayoutX()).assertEqual(125);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(75);
      expect(root_child1.getLayoutHeight()).assertEqual(200);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(75);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(125);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(75);
      expect(root_child1.getLayoutHeight()).assertEqual(200);
    });

    // 验证纵向布局中百分比弹性基准值的计算
    it('test_percentage_flex_basis_cross', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasisPercent(50);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root_child1.setFlexBasisPercent(25);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(125);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(125);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(root_child1.getLayoutHeight()).assertEqual(75);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(125);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(125);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(root_child1.getLayoutHeight()).assertEqual(75);
    });

    // 验证主轴方向上百分比弹性基准值与最大高度的组合效果
    it('test_percentage_flex_basis_main_max_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasisPercent(10);
      root_child0.setMaxHeightPercent(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(4);
      root_child1.setFlexBasisPercent(10);
      root_child1.setMaxHeightPercent(20);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(52);
      expect(root_child0.getLayoutHeight()).assertEqual(120);

      expect(root_child1.getLayoutX()).assertEqual(52);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(148);
      expect(root_child1.getLayoutHeight()).assertEqual(40);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(148);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(52);
      expect(root_child0.getLayoutHeight()).assertEqual(120);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(148);
      expect(root_child1.getLayoutHeight()).assertEqual(40);
    });

    // 验证交叉轴方向上百分比弹性基准值与最大高度的组合效果
    it('test_percentage_flex_basis_cross_max_height', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasisPercent(10);
      root_child0.setMaxHeightPercent(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(4);
      root_child1.setFlexBasisPercent(10);
      root_child1.setMaxHeightPercent(20);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(120);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(120);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(root_child1.getLayoutHeight()).assertEqual(40);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(120);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(120);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(root_child1.getLayoutHeight()).assertEqual(40);
    });

    // 验证主轴方向上百分比弹性基准值与最大宽度的组合效果
    it('test_percentage_flex_basis_main_max_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasisPercent(15);
      root_child0.setMaxWidthPercent(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(4);
      root_child1.setFlexBasisPercent(10);
      root_child1.setMaxWidthPercent(20);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(120);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child1.getLayoutX()).assertEqual(120);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(40);
      expect(root_child1.getLayoutHeight()).assertEqual(200);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(80);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(120);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child1.getLayoutX()).assertEqual(40);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(40);
      expect(root_child1.getLayoutHeight()).assertEqual(200);
    });

    // 验证交叉轴方向上百分比弹性基准值与最大宽度的组合效果
    it('test_percentage_flex_basis_cross_max_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasisPercent(10);
      root_child0.setMaxWidthPercent(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(4);
      root_child1.setFlexBasisPercent(15);
      root_child1.setMaxWidthPercent(20);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(120);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(40);
      expect(root_child1.getLayoutHeight()).assertEqual(150);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(80);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(120);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(160);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(40);
      expect(root_child1.getLayoutHeight()).assertEqual(150);
    });

    // 验证主轴方向上百分比弹性基准值与最小宽度的组合效果
    it('test_percentage_flex_basis_main_min_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasisPercent(15);
      root_child0.setMinWidthPercent(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(4);
      root_child1.setFlexBasisPercent(10);
      root_child1.setMinWidthPercent(20);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(120);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child1.getLayoutX()).assertEqual(120);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(80);
      expect(root_child1.getLayoutHeight()).assertEqual(200);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(80);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(120);
      expect(root_child0.getLayoutHeight()).assertEqual(200);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(80);
      expect(root_child1.getLayoutHeight()).assertEqual(200);
    });

    // 验证交叉轴方向上百分比弹性基准值与最小宽度的组合效果
    it('test_percentage_flex_basis_cross_min_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasisPercent(10);
      root_child0.setMinWidthPercent(60);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(4);
      root_child1.setFlexBasisPercent(15);
      root_child1.setMinWidthPercent(20);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(root_child1.getLayoutHeight()).assertEqual(150);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(50);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(root_child1.getLayoutHeight()).assertEqual(150);
    });

    // 验证嵌套元素中百分比、内边距和外边距的综合计算效果
    it('test_percentage_multiple_nested_with_padding_margin_and_percentage_values', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setFlexBasisPercent(10);
      root_child0.setMargin(YogaEdge.LEFT, 5);
      root_child0.setMargin(YogaEdge.TOP, 5);
      root_child0.setMargin(YogaEdge.RIGHT, 5);
      root_child0.setMargin(YogaEdge.BOTTOM, 5);
      root_child0.setPadding(YogaEdge.LEFT, 3);
      root_child0.setPadding(YogaEdge.TOP, 3);
      root_child0.setPadding(YogaEdge.RIGHT, 3);
      root_child0.setPadding(YogaEdge.BOTTOM, 3);
      root_child0.setMinWidthPercent(60);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setMargin(YogaEdge.LEFT, 5);
      root_child0_child0.setMargin(YogaEdge.TOP, 5);
      root_child0_child0.setMargin(YogaEdge.RIGHT, 5);
      root_child0_child0.setMargin(YogaEdge.BOTTOM, 5);
      root_child0_child0.setPaddingPercent(YogaEdge.LEFT, 3);
      root_child0_child0.setPaddingPercent(YogaEdge.TOP, 3);
      root_child0_child0.setPaddingPercent(YogaEdge.RIGHT, 3);
      root_child0_child0.setPaddingPercent(YogaEdge.BOTTOM, 3);
      root_child0_child0.setWidthPercent(50);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setMarginPercent(YogaEdge.LEFT, 5);
      root_child0_child0_child0.setMarginPercent(YogaEdge.TOP, 5);
      root_child0_child0_child0.setMarginPercent(YogaEdge.RIGHT, 5);
      root_child0_child0_child0.setMarginPercent(YogaEdge.BOTTOM, 5);
      root_child0_child0_child0.setPadding(YogaEdge.LEFT, 3);
      root_child0_child0_child0.setPadding(YogaEdge.TOP, 3);
      root_child0_child0_child0.setPadding(YogaEdge.RIGHT, 3);
      root_child0_child0_child0.setPadding(YogaEdge.BOTTOM, 3);
      root_child0_child0_child0.setWidthPercent(45);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(4);
      root_child1.setFlexBasisPercent(15);
      root_child1.setMinWidthPercent(20);
      root.insertChild(root_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(5);
      expect(root_child0.getLayoutY()).assertEqual(5);
      expect(root_child0.getLayoutWidth()).assertEqual(190);
      expect(root_child0.getLayoutHeight()).assertEqual(48);

      expect(root_child0_child0.getLayoutX()).assertEqual(8);
      expect(root_child0_child0.getLayoutY()).assertEqual(8);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(92);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(25);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(10);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(10);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(36);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(6);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(58);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(root_child1.getLayoutHeight()).assertEqual(142);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(5);
      expect(root_child0.getLayoutY()).assertEqual(5);
      expect(root_child0.getLayoutWidth()).assertEqual(190);
      expect(root_child0.getLayoutHeight()).assertEqual(48);

      expect(root_child0_child0.getLayoutX()).assertEqual(90);
      expect(root_child0_child0.getLayoutY()).assertEqual(8);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(92);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(25);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(46);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(10);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(36);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(6);

      expect(root_child1.getLayoutX()).assertEqual(0);
      expect(root_child1.getLayoutY()).assertEqual(58);
      expect(root_child1.getLayoutWidth()).assertEqual(200);
      expect(root_child1.getLayoutHeight()).assertEqual(142);
    });

    // 验证百分比外边距始终基于父容器宽度计算的规则
    it('test_percentage_margin_should_calculate_based_only_on_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setMarginPercent(YogaEdge.LEFT, 10);
      root_child0.setMarginPercent(YogaEdge.TOP, 10);
      root_child0.setMarginPercent(YogaEdge.RIGHT, 10);
      root_child0.setMarginPercent(YogaEdge.BOTTOM, 10);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setWidth(10);
      root_child0_child0.setHeight(10);
      root_child0.insertChild(root_child0_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(20);
      expect(root_child0.getLayoutY()).assertEqual(20);
      expect(root_child0.getLayoutWidth()).assertEqual(160);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(20);
      expect(root_child0.getLayoutY()).assertEqual(20);
      expect(root_child0.getLayoutWidth()).assertEqual(160);
      expect(root_child0.getLayoutHeight()).assertEqual(60);

      expect(root_child0_child0.getLayoutX()).assertEqual(150);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);
    });

    // 验证百分比内边距始终基于父容器宽度计算的规则
    it('test_percentage_padding_should_calculate_based_only_on_width', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexGrow(1);
      root_child0.setPaddingPercent(YogaEdge.LEFT, 10);
      root_child0.setPaddingPercent(YogaEdge.TOP, 10);
      root_child0.setPaddingPercent(YogaEdge.RIGHT, 10);
      root_child0.setPaddingPercent(YogaEdge.BOTTOM, 10);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setWidth(10);
      root_child0_child0.setHeight(10);
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
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0.getLayoutX()).assertEqual(20);
      expect(root_child0_child0.getLayoutY()).assertEqual(20);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(200);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child0_child0.getLayoutX()).assertEqual(170);
      expect(root_child0_child0.getLayoutY()).assertEqual(20);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(10);
    });

    // 验证绝对定位元素的百分比位置计算
    it('test_percentage_absolute_position', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setPositionPercent(YogaEdge.LEFT, 30);
      root_child0.setPositionPercent(YogaEdge.TOP, 10);
      root_child0.setWidth(10);
      root_child0.setHeight(10);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(60);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(60);
      expect(root_child0.getLayoutY()).assertEqual(10);
      expect(root_child0.getLayoutWidth()).assertEqual(10);
      expect(root_child0.getLayoutHeight()).assertEqual(10);
    });

    // 验证父容器尺寸未定义时百分比宽高的计算结果
    it('test_percentage_width_height_undefined_parent_size', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidthPercent(50);
      root_child0.setHeightPercent(50);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(0);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(0);
      expect(root.getLayoutHeight()).assertEqual(0);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(0);
      expect(root_child0.getLayoutHeight()).assertEqual(0);
    });

    // 验证弹性增长容器内百分比元素的布局效果
    it('test_percent_within_flex_grow', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(350);
      root.setHeight(100);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidth(100);
      root.insertChild(root_child0, 0);

      const root_child1 = Yoga.createNode(config);
      root_child1.setFlexGrow(1);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = Yoga.createNode(config);
      root_child1_child0.setWidthPercent(100);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child2 = Yoga.createNode(config);
      root_child2.setWidth(100);
      root.insertChild(root_child2, 2);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(350);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(100);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(150);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(150);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child2.getLayoutX()).assertEqual(250);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(100);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(350);
      expect(root.getLayoutHeight()).assertEqual(100);

      expect(root_child0.getLayoutX()).assertEqual(250);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(100);

      expect(root_child1.getLayoutX()).assertEqual(100);
      expect(root_child1.getLayoutY()).assertEqual(0);
      expect(root_child1.getLayoutWidth()).assertEqual(150);
      expect(root_child1.getLayoutHeight()).assertEqual(100);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);
      expect(root_child1_child0.getLayoutWidth()).assertEqual(150);
      expect(root_child1_child0.getLayoutHeight()).assertEqual(0);

      expect(root_child2.getLayoutX()).assertEqual(0);
      expect(root_child2.getLayoutY()).assertEqual(0);
      expect(root_child2.getLayoutWidth()).assertEqual(100);
      expect(root_child2.getLayoutHeight()).assertEqual(100);
    });

    // 验证包装容器内百分比元素的布局效果
    it('test_percentage_container_in_wrapping_container', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setJustifyContent(YogaJustify.CENTER);
      root.setAlignItems(YogaAlign.CENTER);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(200);
      root.setHeight(200);

      const root_child0 = Yoga.createNode(config);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setFlexDirection(YogaFlexDirection.ROW);
      root_child0_child0.setJustifyContent(YogaJustify.CENTER);
      root_child0_child0.setWidthPercent(100);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child0_child0 = Yoga.createNode(config);
      root_child0_child0_child0.setWidth(50);
      root_child0_child0_child0.setHeight(50);
      root_child0_child0.insertChild(root_child0_child0_child0, 0);

      const root_child0_child0_child1 = Yoga.createNode(config);
      root_child0_child0_child1.setWidth(50);
      root_child0_child0_child1.setHeight(50);
      root_child0_child0.insertChild(root_child0_child0_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(75);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0_child1.getLayoutX()).assertEqual(50);
      expect(root_child0_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child1.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(200);
      expect(root.getLayoutHeight()).assertEqual(200);

      expect(root_child0.getLayoutX()).assertEqual(50);
      expect(root_child0.getLayoutY()).assertEqual(75);
      expect(root_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(100);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0_child0.getLayoutX()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child0.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0_child1.getLayoutX()).assertEqual(0);
      expect(root_child0_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child0_child1.getLayoutWidth()).assertEqual(50);
      expect(root_child0_child0_child1.getLayoutHeight()).assertEqual(50);
    });

    // 验证绝对定位容器内百分比元素的布局效果
    it('test_percent_absolute_position', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setWidth(60);
      root.setHeight(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setFlexDirection(YogaFlexDirection.ROW);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setPositionPercent(YogaEdge.LEFT, 50);
      root_child0.setWidthPercent(100);
      root_child0.setHeight(50);
      root.insertChild(root_child0, 0);

      const root_child0_child0 = Yoga.createNode(config);
      root_child0_child0.setWidthPercent(100);
      root_child0.insertChild(root_child0_child0, 0);

      const root_child0_child1 = Yoga.createNode(config);
      root_child0_child1.setWidthPercent(100);
      root_child0.insertChild(root_child0_child1, 1);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(30);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child1.getLayoutX()).assertEqual(60);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(60);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(50);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(30);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child0.getLayoutX()).assertEqual(0);
      expect(root_child0_child0.getLayoutY()).assertEqual(0);
      expect(root_child0_child0.getLayoutWidth()).assertEqual(60);
      expect(root_child0_child0.getLayoutHeight()).assertEqual(50);

      expect(root_child0_child1.getLayoutX()).assertEqual(-60);
      expect(root_child0_child1.getLayoutY()).assertEqual(0);
      expect(root_child0_child1.getLayoutWidth()).assertEqual(60);
      expect(root_child0_child1.getLayoutHeight()).assertEqual(50);
    });

    // 验证主轴最小最大约束下百分比尺寸的计算
    it('test_percent_of_minmax_main', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setFlexDirection(YogaFlexDirection.ROW);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMinWidth(60);
      root.setMaxWidth(60);
      root.setHeight(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidthPercent(50);
      root_child0.setHeight(20);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(30);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(20);
    });

    // 验证交叉轴拉伸时最小最大约束下百分比尺寸的计算
    it('test_percent_of_minmax_cross_stretched', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMinWidth(60);
      root.setMaxWidth(60);
      root.setHeight(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidthPercent(50);
      root_child0.setHeight(20);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(30);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(20);
    });

    // 验证绝对定位元素在交叉轴拉伸时的百分比计算
    it('test_percent_absolute_of_minmax_cross_stretched', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMinWidth(60);
      root.setMaxWidth(60);
      root.setHeight(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setPositionType(YogaPositionType.ABSOLUTE);
      root_child0.setWidthPercent(50);
      root_child0.setHeight(20);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(30);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(20);
    });

    // 验证交叉轴未拉伸时最小最大约束下百分比尺寸的计算
    it('test_percent_of_minmax_cross_unstretched', 0, () => {
      const config = Yoga.createConfig();

      const root = Yoga.createNode(config);
      root.setAlignItems(YogaAlign.FLEX_START);
      root.setPositionType(YogaPositionType.ABSOLUTE);
      root.setMinWidth(60);
      root.setMaxWidth(60);
      root.setHeight(50);

      const root_child0 = Yoga.createNode(config);
      root_child0.setWidthPercent(50);
      root_child0.setHeight(20);
      root.insertChild(root_child0, 0);
      root.setDirection(YogaDirection.LTR);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(20);

      root.setDirection(YogaDirection.RTL);
      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root.getLayoutX()).assertEqual(0);
      expect(root.getLayoutY()).assertEqual(0);
      expect(root.getLayoutWidth()).assertEqual(60);
      expect(root.getLayoutHeight()).assertEqual(50);

      expect(root_child0.getLayoutX()).assertEqual(30);
      expect(root_child0.getLayoutY()).assertEqual(0);
      expect(root_child0.getLayoutWidth()).assertEqual(30);
      expect(root_child0.getLayoutHeight()).assertEqual(20);
    });
  });
}