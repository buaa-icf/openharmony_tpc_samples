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
  YogaConfig,
  YogaFlexDirection,
  YogaAlign,
  YogaConstants,
  YogaBaselineFunction
} from '@ohos/yoga';

export default function yogaAlignBaselineTest() {
  describe('YogaAlignBaselineTest', () => {
    // Helper functions
    let createNode: () => YogaNode = (): YogaNode => {
      return Yoga.createNode();
    };

    let getBaselineFunc: () => YogaBaselineFunction = (): YogaBaselineFunction => {
      return (node: YogaNode, width: number, height: number) => {
        return height / 2;
      };
    };

    let createYGNode: (config: YogaConfig, flexDirection: YogaFlexDirection, width: number, height: number,
      alignBaseline: boolean) => YogaNode =
      (config: YogaConfig, flexDirection: YogaFlexDirection, width: number, height: number,
        alignBaseline: boolean): YogaNode => {
        const node = createNode();
        node.setFlexDirection(flexDirection);
        node.setWidth(width);
        node.setHeight(height);
        if (alignBaseline) {
          node.setAlignItems(YogaAlign.BASELINE);
        }
        return node;
      };

    // 测试父节点使用列布局子节点作为基线参考的情况
    it('test_align_baseline_parent_using_child_in_column_as_reference', 0, () => {
      const config = new YogaConfig();

      const root = createYGNode(config, YogaFlexDirection.ROW, 1000, 1000, true);

      const root_child0 = createYGNode(config, YogaFlexDirection.COLUMN, 500, 600, false);
      root.insertChild(root_child0, 0);

      const root_child1 = createYGNode(config, YogaFlexDirection.COLUMN, 500, 800, false);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = createYGNode(config, YogaFlexDirection.COLUMN, 500, 300, false);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child1_child1 = createYGNode(config, YogaFlexDirection.COLUMN, 500, 400, false);
      const baselineFunc = getBaselineFunc();
      root_child1_child1.setBaselineFunction(baselineFunc);
      root_child1_child1.setIsReferenceBaseline(true);
      root_child1.insertChild(root_child1_child1, 1);

      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);

      expect(root_child1.getLayoutX()).assertEqual(500);
      expect(root_child1.getLayoutY()).assertEqual(100);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);

      expect(root_child1_child1.getLayoutX()).assertEqual(0);
      expect(root_child1_child1.getLayoutY()).assertEqual(300);
    });

    // 测试父节点使用行布局子节点作为基线参考的情况
    it('test_align_baseline_parent_using_child_in_row_as_reference', 0, () => {
      const config = new YogaConfig();

      const root = createYGNode(config, YogaFlexDirection.ROW, 1000, 1000, true);

      const root_child0 = createYGNode(config, YogaFlexDirection.COLUMN, 500, 600, false);
      root.insertChild(root_child0, 0);

      const root_child1 = createYGNode(config, YogaFlexDirection.ROW, 500, 800, true);
      root.insertChild(root_child1, 1);

      const root_child1_child0 = createYGNode(config, YogaFlexDirection.COLUMN, 500, 500, false);
      root_child1.insertChild(root_child1_child0, 0);

      const root_child1_child1 = createYGNode(config, YogaFlexDirection.COLUMN, 500, 400, false);
      const baselineFunc = getBaselineFunc();
      root_child1_child1.setBaselineFunction(baselineFunc);
      root_child1_child1.setIsReferenceBaseline(true);
      root_child1.insertChild(root_child1_child1, 1);

      root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

      expect(root_child0.getLayoutX()).assertEqual(0);
      expect(root_child0.getLayoutY()).assertEqual(0);

      expect(root_child1.getLayoutX()).assertEqual(500);
      expect(root_child1.getLayoutY()).assertEqual(100);

      expect(root_child1_child0.getLayoutX()).assertEqual(0);
      expect(root_child1_child0.getLayoutY()).assertEqual(0);

      expect(root_child1_child1.getLayoutX()).assertEqual(500);
      expect(root_child1_child1.getLayoutY()).assertEqual(300);
    });
  });
}