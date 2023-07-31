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
import { RUNNING, SUCCESS, FAILURE,Task,Decorator } from 'behaviortree'
import { describe , beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '../utils/utils'

export default function DecoratorTest() {
  // 通过
  describe('DecoratorTest', function () {
    _it('does nothing by itself', () => {
      const task = new Task({
        run(blackboard) {
          return blackboard.result
        }
      })
      console.log(`dudu2`)
      expect(task.run({ result: SUCCESS })).toEqual(SUCCESS)

      expect(task.run({ result: FAILURE })).toEqual(FAILURE)


      const decoratedTask = new Decorator({ node: task })
      expect(decoratedTask.run({ result: SUCCESS })).toEqual(SUCCESS)

      expect(decoratedTask.run({ result: FAILURE })).toEqual(FAILURE)

    })

    _it('can have a start and end callback', () => {
      const blackboard = { start: 0, end: 0, result: RUNNING }
      const task = new Task({
        run(blackboard) {
          return blackboard.result
        }
      })
      const decoratedTask = new Decorator({
        start: function (b) {
          ++b.start
        },
        end: function (b) {
          ++b.end
        },
        node: task
      })

      decoratedTask.run(blackboard)

      expect(blackboard.start).toEqual(1)
      expect(blackboard.end).toEqual(0)

      // @ts-ignore
      blackboard.result = FAILURE

      decoratedTask.run(blackboard, { rerun: true })

      expect(blackboard.start).toEqual(1)
      expect(blackboard.end).toEqual(1)
    })
  })
}