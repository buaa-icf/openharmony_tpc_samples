import { afterEach, describe, expect, it } from '@ohos/hypium'

import { createSingleExamplePage } from './singleExampleRouteCapture'
import '../main/ets/pages/SingleExample'

interface ClearRectCall {
  x: number
  y: number
  width: number
  height: number
}

interface TestBound {
  height: number
}

interface TestDelay {
  time: number
  isFinish: boolean
}

interface SingleExampleLike {
  render(context: TestCanvasRenderingContext, lastFrameTime: number, skeleton: TestSkeleton,
    animationState: TestAnimationState, skeletonRenderer: TestSkeletonRenderer, bounds: TestBound): TestDelay
  aboutToBeDeleted?(): void
}

class TestCanvasRenderingContext {
  width: number
  height: number
  clearRectCalls: Array<ClearRectCall> = []
  private callSequence: Array<string>

  constructor(width: number, height: number, callSequence: Array<string>) {
    this.width = width
    this.height = height
    this.callSequence = callSequence
  }

  clearRect(x: number, y: number, width: number, height: number): void {
    this.callSequence.push('clearRect')
    this.clearRectCalls.push({ x, y, width, height })
  }
}

class TestSkeleton {
  x: number = 0
  y: number = 0
  scaleX: number = 0
  scaleY: number = 0
  updateWorldTransformCalls: number = 0
  private callSequence: Array<string>

  constructor(callSequence: Array<string>) {
    this.callSequence = callSequence
  }

  updateWorldTransform(physics: Object): void {
    this.callSequence.push('updateWorldTransform')
    this.updateWorldTransformCalls += 1
    expect(physics !== undefined).assertTrue()
  }
}

class TestAnimationState {
  updateCalls: Array<number> = []
  appliedSkeleton?: TestSkeleton
  private callSequence: Array<string>

  constructor(callSequence: Array<string>) {
    this.callSequence = callSequence
  }

  update(delta: number): void {
    this.callSequence.push('update')
    this.updateCalls.push(delta)
  }

  apply(skeleton: TestSkeleton): void {
    this.callSequence.push('apply')
    this.appliedSkeleton = skeleton
  }
}

class TestSkeletonRenderer {
  drawCalls: number = 0
  drawnSkeleton?: TestSkeleton
  private callSequence: Array<string>

  constructor(callSequence: Array<string>) {
    this.callSequence = callSequence
  }

  draw(skeleton: TestSkeleton): void {
    this.callSequence.push('draw')
    this.drawCalls += 1
    this.drawnSkeleton = skeleton
  }
}

const createdPages: Array<SingleExampleLike> = []

function createPage(): SingleExampleLike {
  const page = createSingleExamplePage() as SingleExampleLike
  createdPages.push(page)
  return page
}

function expectClose(actual: number, expected: number): void {
  expect(Math.abs(actual - expected) < 0.000001).assertTrue()
}

function assertFrameResult(result: TestDelay, beforeRender: number, afterRender: number, lastFrameTime: number,
  animationState: TestAnimationState): void {
  expect(result.isFinish).assertTrue()
  expect(result.time >= beforeRender).assertTrue()
  expect(result.time <= afterRender).assertTrue()
  expectClose(animationState.updateCalls[0], result.time - lastFrameTime)
}

export default function singleExampleRenderTest() {
  describe('SingleExampleRenderTest', () => {
    afterEach(() => {
      while (createdPages.length > 0) {
        createdPages.pop()?.aboutToBeDeleted?.()
      }
    })

    it('positions scales and draws the skeleton for one frame', 0, () => {
      const page = createPage()
      const callSequence: Array<string> = []
      const context = new TestCanvasRenderingContext(300, 200, callSequence)
      const skeleton = new TestSkeleton(callSequence)
      const animationState = new TestAnimationState(callSequence)
      const skeletonRenderer = new TestSkeletonRenderer(callSequence)
      const bounds: TestBound = { height: 100 }
      const lastFrameTime = Date.now() / 1000 - 0.25

      const beforeRender = Date.now() / 1000
      const result = page.render(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds)
      const afterRender = Date.now() / 1000

      expect(context.clearRectCalls.length).assertEqual(1)
      expect(context.clearRectCalls[0].x).assertEqual(0)
      expect(context.clearRectCalls[0].y).assertEqual(0)
      expect(context.clearRectCalls[0].width).assertEqual(300)
      expect(context.clearRectCalls[0].height).assertEqual(200)
      expectClose(skeleton.x, 150)
      expectClose(skeleton.y, 160)
      expectClose(skeleton.scaleX, 1)
      expectClose(skeleton.scaleY, -1)
      expect(animationState.updateCalls.length).assertEqual(1)
      expect(animationState.appliedSkeleton === skeleton).assertTrue()
      expect(skeleton.updateWorldTransformCalls).assertEqual(1)
      expect(skeletonRenderer.drawCalls).assertEqual(1)
      expect(skeletonRenderer.drawnSkeleton === skeleton).assertTrue()
      expect(callSequence.join(',')).assertEqual('clearRect,update,apply,updateWorldTransform,draw')
      assertFrameResult(result, beforeRender, afterRender, lastFrameTime, animationState)
    })

    it('recomputes placement from the current canvas and bounds size', 0, () => {
      const page = createPage()
      const callSequence: Array<string> = []
      const context = new TestCanvasRenderingContext(640, 480, callSequence)
      const skeleton = new TestSkeleton(callSequence)
      const animationState = new TestAnimationState(callSequence)
      const skeletonRenderer = new TestSkeletonRenderer(callSequence)
      const bounds: TestBound = { height: 240 }
      const lastFrameTime = Date.now() / 1000 - 0.5

      const beforeRender = Date.now() / 1000
      const result = page.render(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds)
      const afterRender = Date.now() / 1000

      expectClose(skeleton.x, 320)
      expectClose(skeleton.y, 384)
      expectClose(skeleton.scaleX, 1)
      expectClose(skeleton.scaleY, -1)
      expect(context.clearRectCalls[0].width).assertEqual(640)
      expect(context.clearRectCalls[0].height).assertEqual(480)
      expect(callSequence.join(',')).assertEqual('clearRect,update,apply,updateWorldTransform,draw')
      assertFrameResult(result, beforeRender, afterRender, lastFrameTime, animationState)
    })

    it('uses fractional scale when the bounds are taller than the canvas', 0, () => {
      const page = createPage()
      const callSequence: Array<string> = []
      const context = new TestCanvasRenderingContext(120, 90, callSequence)
      const skeleton = new TestSkeleton(callSequence)
      const animationState = new TestAnimationState(callSequence)
      const skeletonRenderer = new TestSkeletonRenderer(callSequence)
      const bounds: TestBound = { height: 300 }
      const lastFrameTime = Date.now() / 1000 - 0.1

      const beforeRender = Date.now() / 1000
      const result = page.render(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds)
      const afterRender = Date.now() / 1000

      expectClose(skeleton.x, 60)
      expectClose(skeleton.y, 72)
      expectClose(skeleton.scaleX, 0.15)
      expectClose(skeleton.scaleY, -0.15)
      expect(skeletonRenderer.drawnSkeleton === skeleton).assertTrue()
      assertFrameResult(result, beforeRender, afterRender, lastFrameTime, animationState)
    })
  })
}
