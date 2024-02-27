/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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
import { describe, beforeEach, it} from '@ohos/hypium'
import {
  SUCCESS,FAILURE as FAILURE,BranchNode
} from 'behaviortree'
import { Task_1 } from "../utils/constant";
const BASE_COUNT: number = 2000;
function endTime(startTime: number, tag: string) {
  console.log(tag + ":startTime:" + startTime)
  let endTime: number = new Date().getTime();
  let averageTime = ((endTime - startTime) * 1000 / BASE_COUNT)
  console.log(tag + ":endTime:" + endTime)
  console.log(tag + ":averageTime:" + averageTime + "μs");
}
export default function BranchNodeTestDescribe() {
  // 通过
  describe('BranchNodeTest', () => {
    let countSuccess = 0;
    const successTask = new Task_1
    ({
      run: ()=> {
        ++countSuccess;
        return SUCCESS;
      }
    });
    let countFail = 0;
    const failTask = new Task_1({
      run: ()=> {
        ++countFail;
        return FAILURE;
      }
    });
    let countRunning = 0;
    const runningTask = new Task_1({
      run: ()=> {
        ++countRunning;
        return SUCCESS;
      }
    });

    beforeEach(() => {
      countSuccess = 0;
      countFail = 0;
      countRunning = 0;
    });

    it('returns_failure_if_one_task_is_failing',0, () => {
      const branchNode = new  BranchNode({
        nodes: [successTask, runningTask, failTask]
      });
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        branchNode.run()
      }
      endTime(startTime, 'returns_failure_if_one_task_is_failing');
    });
    it('returns_success_if_all_tasks_are_success',0, () => {
      const branchNode = new BranchNode({
        nodes: [successTask, successTask]
      });
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        branchNode.run();
      }
      endTime(startTime, 'returns_success_if_all_tasks_are_success');
    });
  })
}
