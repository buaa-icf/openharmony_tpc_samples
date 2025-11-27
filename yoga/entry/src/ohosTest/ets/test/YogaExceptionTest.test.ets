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
  YogaConstants,
  YogaFlexDirection,
  YogaAlign
} from '@ohos/yoga';

export default function yogaExceptionTest() {
  describe('YogaExceptionTest', () => {
    // Helper functions
    let createNode: () => YogaNode = (): YogaNode => {
      return Yoga.createNode();
    };

    // 测试当baseline函数抛出异常时，布局计算能正确传播异常
    it('testBaselineThrows', 0, () => {
      let exceptionThrown = false;
      
      try {
        const root = createNode();
        root.setFlexDirection(YogaFlexDirection.ROW);
        root.setAlignItems(YogaAlign.BASELINE);

        const child1 = createNode();
        root.insertChild(child1, 0);

        const child2 = createNode();
        const baselineFunc = (node: YogaNode, width: number, height: number) => {
          throw new Error("Baseline function error");
        };
        child2.setBaselineFunction(baselineFunc);
        root.insertChild(child2, 1);

        root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      } catch (e) {
        exceptionThrown = true;
      }
      
      expect(exceptionThrown).assertTrue();
    });

    // 测试baseline异常发生后，后续节点的baseline函数不会被调用
    it('testBaselineThrowsAndStops', 0, () => {
      let expectedError: Error | null = null;
      let child3Called = false;
      let exceptionThrown = false;
      let correctException = false;

      try {
        const root = createNode();
        root.setFlexDirection(YogaFlexDirection.ROW);
        root.setAlignItems(YogaAlign.BASELINE);

        const child1 = createNode();
        root.insertChild(child1, 0);

        const child2 = createNode();
        const baselineFunc2 = (node: YogaNode, width: number, height: number) => {
          expectedError = new Error("Expected baseline error");
          throw expectedError;
        };
        child2.setBaselineFunction(baselineFunc2);
        root.insertChild(child2, 1);

        const child3 = createNode();
        const baselineFunc3 = (node: YogaNode, width: number, height: number) => {
          child3Called = true;
          return 1.0;
        };
        child3.setBaselineFunction(baselineFunc3);
        root.insertChild(child3, 2);

        root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      } catch (e) {
        exceptionThrown = true;
        if (e === expectedError) {
          correctException = true;
        }
      }

      expect(exceptionThrown).assertTrue();
      expect(correctException).assertTrue();
      expect(child3Called).assertFalse();
    });

    // 测试当measure函数抛出异常时，布局计算能正确传播异常
    it('testMeasureThrows', 0, () => {
      let exceptionThrown = false;
      
      try {
        const node = createNode();
        const measureFunc = (
          node: YogaNode,
          width: number,
          widthMode: number,
          height: number,
          heightMode: number
        ) => {
          throw new Error("Measure function error");
        };
        node.setMeasureFunction(measureFunc);
        node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      } catch (e) {
        exceptionThrown = true;
      }
      
      expect(exceptionThrown).assertTrue();
    });

    // 测试measure异常发生后，后续节点的measure函数不会被调用
    it('testMeasureThrowsAndStops', 0, () => {
      let expectedError: Error | null = null;
      let child3Called = false;
      let exceptionThrown = false;
      let correctException = false;

      try {
        const root = createNode();
        root.setFlexDirection(YogaFlexDirection.ROW);
        root.setAlignItems(YogaAlign.BASELINE);

        const child1 = createNode();
        root.insertChild(child1, 0);

        const child2 = createNode();
        const measureFunc2 = (
          node: YogaNode,
          width: number,
          widthMode: number,
          height: number,
          heightMode: number
        ) => {
          expectedError = new Error("Expected measure error");
          throw expectedError;
        };
        child2.setMeasureFunction(measureFunc2);
        root.insertChild(child2, 1);

        const child3 = createNode();
        const measureFunc3 = (
          node: YogaNode,
          width: number,
          widthMode: number,
          height: number,
          heightMode: number
        ) => {
          child3Called = true;
          return 1; // 返回一个简单的值
        };
        child3.setMeasureFunction(measureFunc3);
        root.insertChild(child3, 2);

        root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
      } catch (e) {
        exceptionThrown = true;
        if (e === expectedError) {
          correctException = true;
        }
      }

      expect(exceptionThrown).assertTrue();
      expect(correctException).assertTrue();
      expect(child3Called).assertFalse();
    });
  });
}