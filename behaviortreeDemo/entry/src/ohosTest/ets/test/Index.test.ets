/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { BehaviorTree,Task,SUCCESS,FAILURE,Selector,Sequence,RUNNING } from "behaviortree";
let bTree
let blackboard
export default function IndexTest() {
  describe('IndexTest', function () {
    const aTask = new Task({
      run: function (blackboard) {
        ++blackboard.aCounter
        return SUCCESS
      }
    })
    const bTask = new Task({
      run: function (blackboard) {
        ++blackboard.bCounter
        return FAILURE
      }
    })
    const switchTask = new Task({
      run: function (blackboard) {
        ++blackboard.switchCounter
        return blackboard.switchResult
      }
    })
    const tree = new Sequence({
      nodes: [
        aTask,
        aTask,
        new Selector({
          nodes: [bTask, switchTask, bTask]
        }),
        aTask
      ]
    })



    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.

    })
    beforeEach(function () {
      blackboard = {
        aCounter: 0,
        bCounter: 0,
        switchCounter: 0,
        switchResult: RUNNING
      }
      bTree = new BehaviorTree({ tree, blackboard })
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('controls_stepping_with_running_and_stuff', 0 ,() => {
      bTree.step()

      expect(blackboard.aCounter).assertEqual(2)
      expect(blackboard.bCounter).assertEqual(1)
      expect(blackboard.switchCounter).assertEqual(1)

      bTree.step()

      expect(blackboard.aCounter).assertEqual(2)
      expect(blackboard.bCounter).assertEqual(1)
      expect(blackboard.switchCounter).assertEqual(2)

      blackboard.switchResult = FAILURE
      bTree.step()

      expect(blackboard.aCounter).assertEqual(2)
      expect(blackboard.bCounter).assertEqual(2)
      expect(blackboard.switchCounter).assertEqual(3)

      blackboard.switchResult = RUNNING
      bTree.step()

      expect(blackboard.aCounter).assertEqual(4)
      expect(blackboard.bCounter).assertEqual(3)
      expect(blackboard.switchCounter).assertEqual(4)

      blackboard.switchResult = SUCCESS
      bTree.step()

      expect(blackboard.aCounter).assertEqual(5)
      expect(blackboard.bCounter).assertEqual(3)
      expect(blackboard.switchCounter).assertEqual(5)

      bTree.step()

      expect(blackboard.aCounter).assertEqual(8)
      expect(blackboard.bCounter).assertEqual(4)
      expect(blackboard.switchCounter).assertEqual(6)
    })
  })
}