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

import { RUNNING, SUCCESS, FAILURE,Sequence,Selector,Task,Decorator,BehaviorTree } from 'behaviortree'
import InvertDecorator from 'behaviortree/lib/decorators/InvertDecorator'
import { describe  , beforeAll, beforeEach, afterEach, afterAll, it as test, expect } from '../utils/utils'


let bTree
let blackboard

export default function BehaviorTreedescribe() {

  // 通过
  describe('with_a_medium_complex_tree', function() {
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

    beforeEach(() => {
      blackboard = {
        aCounter: 0,
        bCounter: 0,
        switchCounter: 0,
        switchResult: RUNNING
      }
      bTree = new BehaviorTree({ tree, blackboard })
    })

    test('controls stepping with running and stuff', () => {
      bTree.step()

      expect(blackboard.aCounter).toEqual(2)
      expect(blackboard.bCounter).toEqual(1)
      expect(blackboard.switchCounter).toEqual(1)

      bTree.step()

      expect(blackboard.aCounter).toEqual(2)
      expect(blackboard.bCounter).toEqual(1)
      expect(blackboard.switchCounter).toEqual(2)

      blackboard.switchResult = FAILURE
      bTree.step()

      expect(blackboard.aCounter).toEqual(2)
      expect(blackboard.bCounter).toEqual(2)
      expect(blackboard.switchCounter).toEqual(3)

      blackboard.switchResult = RUNNING
      bTree.step()

      expect(blackboard.aCounter).toEqual(4)
      expect(blackboard.bCounter).toEqual(3)
      expect(blackboard.switchCounter).toEqual(4)

      blackboard.switchResult = SUCCESS
      bTree.step()

      expect(blackboard.aCounter).toEqual(5)
      expect(blackboard.bCounter).toEqual(3)
      expect(blackboard.switchCounter).toEqual(5)

      bTree.step()

      expect(blackboard.aCounter).toEqual(8)
      expect(blackboard.bCounter).toEqual(4)
      expect(blackboard.switchCounter).toEqual(6)
    })
  })

  // 通过
  describe('with_the_simplest_tree_possible1', function() {
    beforeEach(() => {
      blackboard = {
        start: 0,
        run: 0,
        end: 0,
        result: RUNNING
      }
      const tree = new Task({
        start: function (blackboard) {
          ++blackboard.start
        },
        run: function (blackboard) {
          ++blackboard.run
          return blackboard.result
        },
        end: function (blackboard) {
          ++blackboard.end
        }
      })
      bTree = new BehaviorTree({ tree, blackboard })
    })

    test('running does not call start multiple times', () => {
      bTree.step()

      expect(blackboard.start).toEqual(1)
      expect(blackboard.run).toEqual(1)
      expect(blackboard.end).toEqual(0)

      bTree.step()

      expect(blackboard.start).toEqual(1)
      expect(blackboard.run).toEqual(2)
      expect(blackboard.end).toEqual(0)

      blackboard.result = FAILURE
      bTree.step()

      expect(blackboard.start).toEqual(1)
      expect(blackboard.run).toEqual(3)
      expect(blackboard.end).toEqual(1)

      blackboard.result = SUCCESS
      bTree.step()

      expect(blackboard.start).toEqual(2)
      expect(blackboard.run).toEqual(4)
      expect(blackboard.end).toEqual(2)
    })
  })

  // 通过
  describe('with_the_simplest_tree_possible2', function() {
    beforeEach(() => {
      blackboard = {
        start: 0,
        run: 0,
        end: 0,
        result: RUNNING
      }
      const tree = new Task({
        start: function (blackboard) {
          ++blackboard.start
        },
        run: function (blackboard) {
          ++blackboard.run
          return blackboard.result
        },
        end: function (blackboard) {
          ++blackboard.end
        }
      })
      bTree = new BehaviorTree({ tree, blackboard })
    })

    test('running does not call start multiple times', () => {
      bTree.step()

      expect(blackboard.start).toEqual(1)
      expect(blackboard.run).toEqual(1)
      expect(blackboard.end).toEqual(0)

      bTree.step()

      expect(blackboard.start).toEqual(1)
      expect(blackboard.run).toEqual(2)
      expect(blackboard.end).toEqual(0)

      blackboard.result = FAILURE
      bTree.step()

      expect(blackboard.start).toEqual(1)
      expect(blackboard.run).toEqual(3)
      expect(blackboard.end).toEqual(1)

      blackboard.result = SUCCESS
      bTree.step()

      expect(blackboard.start).toEqual(2)
      expect(blackboard.run).toEqual(4)
      expect(blackboard.end).toEqual(2)
    })
  })

  // 通过
  describe('registering_of_tasks', function() {
    beforeEach(() => {
      blackboard = {
        taskA: 0,
        taskB: 0,
        taskC: 0,
        result: RUNNING
      }
      BehaviorTree.register(
        'taskA',
        new Task({
          run: function (blackboard) {
            ++blackboard.taskA
            return SUCCESS
          }
        })
      )
      BehaviorTree.register(
        'taskB',
        new Task({
          run: function (blackboard) {
            ++blackboard.taskB
            return FAILURE
          }
        })
      )
    })

    test('looks up previously registered tasks', () => {
      bTree = new BehaviorTree({
        blackboard,
        tree: new Sequence({
          nodes: ['taskA', 'taskB', 'taskA']
        })
      })
      bTree.step()

      expect(blackboard.taskA).toEqual(1)
      expect(blackboard.taskB).toEqual(1)
    })

    test('can use function-shortcut to create tasks with only a run method', () => {
      BehaviorTree.register('taskC', () => {
        ++blackboard.taskC
        return FAILURE
      })
      bTree = new BehaviorTree({
        blackboard,
        tree: new Sequence({
          nodes: ['taskA', 'taskC', 'taskB']
        })
      })
      bTree.step()

      expect(blackboard.taskA).toEqual(1)
      expect(blackboard.taskB).toEqual(0)
      expect(blackboard.taskC).toEqual(1)
    })

    test('can be erased', () => {
      BehaviorTree.cleanRegistry()

      bTree = new BehaviorTree({
        blackboard,
        tree: new Selector({
          nodes: ['taskA', 'taskC', 'taskB']
        })
      })

      expect(() => {
        bTree.step()
      }).toThrowError('No node with name taskA registered.')
    })

    test('can load tree directly as registered sequence', () => {
      BehaviorTree.register(
        'awesome behavior',
        new Sequence({
          nodes: ['taskA', 'taskB', 'taskA']
        })
      )
      bTree = new BehaviorTree({
        blackboard,
        tree: 'awesome behavior'
      })
      bTree.step()

      expect(blackboard.taskA).toEqual(1)
      expect(blackboard.taskB).toEqual(1)
    })

    test('looks up previously registered sequences with sub sequences as well', () => {
      BehaviorTree.register(
        'mySubSequence',
        new Sequence({
          nodes: ['taskA', 'taskB', 'taskA']
        })
      )

      BehaviorTree.register(
        'mySequence',
        new Sequence({
          nodes: ['mySubSequence', 'taskB']
        })
      )
      bTree = new BehaviorTree({
        blackboard,
        tree: new Sequence({
          nodes: ['mySequence']
        })
      })
      bTree.step()

      expect(blackboard.taskA).toEqual(1)
      expect(blackboard.taskB).toEqual(1)
    })

    test('looks up previously registered task within a decorators', () => {
      bTree = new BehaviorTree({
        blackboard,
        tree: new Selector({
          // @ts-ignore
          nodes: [new InvertDecorator.default({ node: 'taskA' }), 'taskB']
        })
      })
      bTree.step()

      expect(blackboard.taskA).toEqual(1)
      expect(blackboard.taskB).toEqual(1)
    })
  })

  // 通过
  describe('behavior_with_running_nodes', function() {
    test('calls start of all task where appropriate', () => {
      const task1 = new Task({
        start: function (blackboard) {
          ++blackboard.start1
        },
        end: function (blackboard) {
          ++blackboard.end1
        },
        run: function (blackboard) {
          ++blackboard.run1
          return SUCCESS
        }
      })
      const task2 = new Task({
        start: function (blackboard) {
          ++blackboard.start2
        },
        end: function (blackboard) {
          ++blackboard.end2
        },
        run: function (blackboard) {
          ++blackboard.run2
          return blackboard.task2Result
        }
      })
      const task3 = new Task({
        start: function (blackboard) {
          ++blackboard.start3
        },
        end: function (blackboard) {
          ++blackboard.end3
        },
        run: function (blackboard) {
          ++blackboard.run3
          return SUCCESS
        }
      })

      const decoratedTask2 = new Decorator({
        start: function (blackboard) {
          ++blackboard.startDeco
        },
        end: function (blackboard) {
          ++blackboard.endDeco
        },
        node: task2
      })

      const sequence = new Sequence({
        start: function (blackboard) {
          ++blackboard.startSeq
        },
        end: function (blackboard) {
          ++blackboard.endSeq
        },
        nodes: [task1, decoratedTask2, task3]
      })
      const blackboard = {
        task2Result: RUNNING,
        start1: 0,
        run1: 0,
        end1: 0,
        start2: 0,
        run2: 0,
        end2: 0,
        start3: 0,
        run3: 0,
        end3: 0,
        startSeq: 0,
        endSeq: 0,
        startDeco: 0,
        endDeco: 0
      }

      const bTree = new BehaviorTree({
        tree: sequence,
        blackboard
      })

      bTree.step()

      expect(blackboard.startSeq).toEqual(1)
      expect(blackboard.endSeq).toEqual(0)

      expect(blackboard.startDeco).toEqual(1)
      expect(blackboard.endDeco).toEqual(0)

      expect(blackboard.start1).toEqual(1)
      expect(blackboard.run1).toEqual(1)
      expect(blackboard.end1).toEqual(1)

      expect(blackboard.start2).toEqual(1)
      expect(blackboard.run2).toEqual(1)
      expect(blackboard.end2).toEqual(0)

      expect(blackboard.start3).toEqual(0)
      expect(blackboard.run3).toEqual(0)
      expect(blackboard.end3).toEqual(0)

      bTree.step()

      expect(blackboard.startSeq).toEqual(1)
      expect(blackboard.endSeq).toEqual(0)

      expect(blackboard.startDeco).toEqual(1)
      expect(blackboard.endDeco).toEqual(0)

      expect(blackboard.start1).toEqual(1)
      expect(blackboard.run1).toEqual(1)
      expect(blackboard.end1).toEqual(1)

      expect(blackboard.start2).toEqual(1)
      expect(blackboard.run2).toEqual(2)
      expect(blackboard.end2).toEqual(0)

      expect(blackboard.start3).toEqual(0)
      expect(blackboard.run3).toEqual(0)
      expect(blackboard.end3).toEqual(0)
      // @ts-ignore
      blackboard.task2Result = SUCCESS

      bTree.step()

      expect(blackboard.startSeq).toEqual(1)
      expect(blackboard.endSeq).toEqual(1)

      expect(blackboard.startDeco).toEqual(1)
      expect(blackboard.endDeco).toEqual(1)

      expect(blackboard.start1).toEqual(1)
      expect(blackboard.run1).toEqual(1)
      expect(blackboard.end1).toEqual(1)

      expect(blackboard.start2).toEqual(1)
      expect(blackboard.run2).toEqual(3)
      expect(blackboard.end2).toEqual(1)

      expect(blackboard.start3).toEqual(1)
      expect(blackboard.run3).toEqual(1)
      expect(blackboard.end3).toEqual(1)
    })
  })

  // 通过
  describe('some_curious_edge_cases', function() {
    function createTask(name) {
      return new Task({
        name,
        start: function (blackboard) {
          if (blackboard.result[`${name}start`]) {
            ++blackboard.result[`${name}start`]
          } else {
            blackboard.result[`${name}start`] = 1
          }
        },
        end: function (blackboard) {
          if (blackboard.result[`${name}end`]) {
            ++blackboard.result[`${name}end`]
          } else {
            blackboard.result[`${name}end`] = 1
          }
        },
        run: function (blackboard) {
          if (blackboard.result[`${name}run`]) {
            ++blackboard.result[`${name}run`]
          } else {
            blackboard.result[`${name}run`] = 1
          }
          return blackboard.running[name] ? RUNNING : SUCCESS
        }
      })
    }

    test('start of second sequence is called after first reruns', () => {
      const a1 = createTask('a1')
      const b1 = createTask('b1')

      const aSeq = new Sequence({
        nodes: [a1]
      })
      const bSeq = new Sequence({
        nodes: [b1]
      })
      const cSeq = new Sequence({
        nodes: [aSeq, bSeq]
      })
      const blackboard = {
        result: {},
        running: {}
      }

      const bTree = new BehaviorTree({
        tree: cSeq,
        blackboard
      })

      // @ts-ignore
      blackboard.running.a1 = true

      bTree.step()

      expect(JSON.stringify(blackboard.result)).toEqual(JSON.stringify({
        a1start: 1,
        a1run: 1
      }))

      // @ts-ignore
      blackboard.running.a1 = false

      bTree.step()

      expect(JSON.stringify(blackboard.result)).toEqual(JSON.stringify({
        a1start: 1,
        a1run: 2,
        a1end: 1,
        b1start: 1,
        b1run: 1,
        b1end: 1
      }))
    })
  })
}