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

import { RUNNING, SUCCESS, FAILURE,Sequence,Selector,Task,Random,Decorator,Introspector,BehaviorTree } from 'behaviortree'
import InvertDecorator from 'behaviortree/lib/decorators/InvertDecorator'
import { describe , beforeAll, beforeEach, afterEach, afterAll, it as _it, expect,diff } from '../utils/utils'

export default function IntrospectorTest() {

  let bTree
  let blackboard
  let introspector

  BehaviorTree.register(
    'simpleTask',
    new Task({
      name: 'The Task',
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
  )
  BehaviorTree.register(
    'failingTask',
    new Task({
      name: 'Bumm',
      run: function (blackboard) {
        return FAILURE
      }
    })
  )
  BehaviorTree.register(
    'runningTask',
    new Task({
      name: 'Forest',
      run: function (blackboard) {
        return RUNNING
      }
    })
  )

  blackboard = {
    start: 0,
    run: 0,
    end: 0,
    result: SUCCESS
  }

  introspector = new Introspector()
  // 通过
  describe('IntrospectorTest', function () {
    beforeEach(() => {
      blackboard = {
        start: 0,
        run: 0,
        end: 0,
        result: SUCCESS
      }

      introspector = new Introspector()
    })
    _it('is empty initially', () => {
      expect(introspector.lastResult).toEqual(null)

      expect(introspector.results.length).toEqual(0)

    })
  })

  // 通过
  describe('with_the_simplest_tree_possible', function() {
    beforeEach(() => {

      bTree = new BehaviorTree({ tree: 'simpleTask', blackboard })
    })

    _it('puts in the result of the last run', () => {
      console.log(`dudu-------开始测试`)

      bTree.step({ introspector })

      const resultFirstRun = {
        name: 'The Task',
        result: SUCCESS
      }

      expect(JSON.stringify(introspector.lastResult)).toEqual(JSON.stringify(resultFirstRun))
      console.log(`dudu-------开始测试1`)

      expect(JSON.stringify(introspector.results)).toEqual(JSON.stringify([resultFirstRun]))
      console.log(`dudu-------开始测试2`)

      blackboard.result = FAILURE

      bTree.step({ introspector })

      const resultSecondRun = {
        name: 'The Task',
        result: FAILURE
      }
      expect(JSON.stringify(introspector.lastResult)).toEqual(JSON.stringify(resultSecondRun))
      console.log(`dudu-------开始测试3`)
      expect(JSON.stringify(introspector.results)).toEqual(JSON.stringify([resultFirstRun, resultSecondRun]))
      console.log(`dudu-------开始测试4`)


      blackboard.result = RUNNING

      bTree.step({ introspector })

      const resultThirdRun = {
        name: 'The Task',
        result: RUNNING
      }

      expect(JSON.stringify(introspector.lastResult)).toEqual(JSON.stringify(resultThirdRun)   )
      console.log(`dudu-------开始测试5`)

      expect(JSON.stringify(introspector.results)).toEqual(JSON.stringify([resultFirstRun, resultSecondRun, resultThirdRun]))
      console.log(`dudu-------开始测试6`)

    })
  })

  // 通过
  describe('with_nameless_tasks', function() {
    beforeEach(() => {
      blackboard = {
        start: 0,
        run: 0,
        end: 0,
        result: SUCCESS
      }

      bTree = new BehaviorTree({ tree: new Task({ run: () => RUNNING }), blackboard })
      introspector = new Introspector()
    })

    _it('does not print a name', () => {
      bTree.step({ introspector })

      const resultFirstRun = {
        result: RUNNING
      }

      expect(diff(introspector.lastResult,resultFirstRun)).toEqual(true)
      expect(diff(introspector.results,[resultFirstRun])).toEqual(true)
    })
  })

  // 通过
  describe('with_nameless_branching_nodes', function() {
    beforeEach(() => {
      blackboard = {
        start: 0,
        run: 0,
        end: 0,
        result: SUCCESS
      }

      bTree = new BehaviorTree({ tree: new Sequence({ nodes: ['simpleTask'] }), blackboard })
      introspector = new Introspector()
    })

    _it('does not print a name', () => {
      bTree.step({ introspector })

      const resultFirstRun = {
        children: [
          {
            name: 'The Task',
            result: SUCCESS
          }
        ],
        result: SUCCESS
      }

      expect(diff(introspector.lastResult,resultFirstRun)).toEqual(true)
      expect(diff(introspector.results,[resultFirstRun])).toEqual(true)
    })
  })

  // 通过
  describe('with_a_decorator', function() {
    beforeEach(() => {
      blackboard = {
        start: 0,
        run: 0,
        end: 0,
        result: SUCCESS
      }
      // @ts-ignore
      const tree = new InvertDecorator.default({ name: 'inverter', node: 'simpleTask' })
      bTree = new BehaviorTree({ tree, blackboard })
      introspector = new Introspector()
    })

    _it('shows Task and Decorator', () => {
      bTree.step({ introspector })

      const result = {
        name: 'inverter',
        result: FAILURE,
        children: [
          {
            name: 'The Task',
            result: SUCCESS
          }
        ]
      }




      expect(diff(introspector.lastResult,result)).toEqual(true)
      expect(diff(introspector.results,[result])).toEqual(true)
    })
  })

  // 通过
  describe('with_a_selector', function() {
    beforeEach(() => {
      blackboard = {
        start: 0,
        run: 0,
        end: 0,
        result: SUCCESS
      }
      introspector = new Introspector()
    })

    _it('does not show task that did not run', () => {
      const tree = new Selector({ name: 'select', nodes: ['simpleTask', 'failingTask'] })
      bTree = new BehaviorTree({ tree, blackboard })

      bTree.step({ introspector })

      const result = {
        name: 'select',
        result: SUCCESS,
        children: [
          {
            name: 'The Task',
            result: SUCCESS
          }
        ]
      }

      expect(diff(introspector.lastResult,result)).toEqual(true)

      expect(diff(introspector.results,[result])).toEqual(true)
    })

    _it('show all tasks if all did run', () => {
      const tree = new Selector({ name: 'select', nodes: ['failingTask', 'simpleTask'] })
      bTree = new BehaviorTree({ tree, blackboard })

      bTree.step({ introspector })

      const result = {
        name: 'select',
        result: SUCCESS,
        children: [
          {
            name: 'Bumm',
            result: FAILURE
          },
          {
            name: 'The Task',
            result: SUCCESS
          }
        ]
      }

      // console.log(`dudu1 -------- ${JSON.stringify(introspector.lastResult) === JSON.stringify(result)}  ${JSON.stringify(result)}`)
      console.log(`dudu1 -------- ${JSON.stringify(introspector.results,null,"\t")}  ${JSON.stringify([result],null,"\t")}`)


      console.log(`dudu1 ------ ${diff(introspector.results,[result])}`)

      expect(diff(introspector.lastResult,result)).toEqual(true)


    })

    _it('does not show more then was running', () => {
      const tree = new Selector({ name: 'select', nodes: ['runningTask', 'simpleTask'] })
      bTree = new BehaviorTree({ tree, blackboard })

      bTree.step({ introspector })

      const result = {
        name: 'select',
        result: RUNNING,
        children: [
          {
            name: 'Forest',
            result: RUNNING
          }
        ]
      }



      expect(diff(introspector.lastResult,result)).toEqual(true)
    })
  })

  // 通过
  describe('a_full_scale_tree', function() {
    beforeEach(() => {
      blackboard = {
        start: 0,
        run: 0,
        end: 0,
        result: SUCCESS
      }
      introspector = new Introspector()
    })

    _it('shows all that did run', () => {
      // @ts-ignore
      const invertedSimple = new InvertDecorator.default({ node: 'simpleTask' })
      const selector1 = new Selector({ name: 'select1', nodes: ['failingTask', 'simpleTask'] })
      const selector2 = new Selector({ name: 'select2', nodes: [invertedSimple, 'simpleTask', 'failingTask'] })

      const tree = new Sequence({ name: 'sequence', nodes: [selector1, selector2] })
      bTree = new BehaviorTree({ tree, blackboard })

      bTree.step({ introspector })

      const result = {
        name: 'sequence',
        result: SUCCESS,
        children: [
          {
            name: 'select1',
            result: SUCCESS,
            children: [
              {
                name: 'Bumm',
                result: FAILURE
              },
              {
                name: 'The Task',
                result: SUCCESS
              }
            ]
          },
          {
            name: 'select2',
            result: SUCCESS,
            children: [
              {
                result: FAILURE,
                children: [
                  {
                    name: 'The Task',
                    result: SUCCESS
                  }
                ]
              },
              {
                name: 'The Task',
                result: SUCCESS
              }
            ]
          }
        ]
      }



      expect(diff(introspector.lastResult,result)).toEqual(true)
      expect(diff(introspector.results,[result])).toEqual(true)
    })
  })

  // 通过
  describe('with_a_Random_node', function() {
    beforeEach(() => {
      blackboard = {
        start: 0,
        run: 0,
        end: 0,
        result: SUCCESS
      }
      bTree = new BehaviorTree({ tree: new Random({ nodes: ['simpleTask', 'failingTask'] }), blackboard })
      introspector = new Introspector()
    })

    _it('cleans the results', () => {
      for (let i = 10; i--; ) {
        bTree.step({ introspector })
      }
      expect(introspector.results.length).toEqual(10)
    })
  })

  // 通过
  describe('reset_method', function() {
    _it('cleans the results', () => {
      bTree = new BehaviorTree({ tree: 'simpleTask', blackboard: {} })
      bTree.step({ introspector })

      introspector.reset()

      expect(diff(introspector.lastResult,null)).toEqual(true)
      expect(diff(introspector.results,[])).toEqual(true)
    })
  })

  // 通过
  describe('having_a_custom_introspector_module', function() {
    class BlackboardChangesIntrospector extends Introspector {
      start(tree) {
        //@ts-ignore
        this.blackboardSnap = JSON.stringify(tree.blackboard)
        super.start(tree)
      }

      _toResult(node, result, blackboard) {
        const newSnap = JSON.stringify(blackboard)
        //@ts-ignore
        const blackboardChanged = newSnap !== this.blackboardSnap
        //@ts-ignore
        this.blackboardSnap = newSnap
        return {
          ...(node.name ? { name: node.name } : {}),
          result,
          blackboardChanged
        }
      }
    }
    beforeEach(() => {
      introspector = new BlackboardChangesIntrospector()
    })

    _it('also has the blackboard available', () => {
      bTree = new BehaviorTree({ tree: new Sequence({ nodes: ['simpleTask', 'failingTask'] }), blackboard })
      bTree.step({ introspector })
      expect(diff(introspector.lastResult.children.map((x) => x.blackboardChanged),[true, false])).toEqual(true)
    })
  })
}