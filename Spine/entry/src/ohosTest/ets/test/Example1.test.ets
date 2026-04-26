import { afterEach, describe, expect, it } from '@ohos/hypium'
import { createPageInstance } from '../helpers/RouteCapture'
import '../../../main/ets/pages/Example1'

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

interface Example1PageLike {
  render(context: TestCanvas, lastFrameTime: number, skeleton: TestSkeleton,
    animationState: TestAnimationState, skeletonRenderer: TestSkeletonRenderer,
    bounds: TestBound): TestDelay
  aboutToBeDeleted?(): void
}

class TestCanvas {
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

const createdPages: Array<Example1PageLike> = []

function createPage(): Example1PageLike {
  const page = createPageInstance('Example1') as Example1PageLike
  createdPages.push(page)
  return page
}

function expectClose(actual: number, expected: number): void {
  expect(Math.abs(actual - expected) < 0.000001).assertTrue()
}

// render: skeleton.y = height - height*0.1, scale = height/bounds.height*0.5
export default function Example1Test() {
  describe('Example1Test', () => {
    afterEach(() => {
      while (createdPages.length > 0) {
        createdPages.pop()?.aboutToBeDeleted?.()
      }
    })

    it('positions scales and draws skeleton for one frame', 0, () => {
      const page = createPage()
      const callSequence: Array<string> = []
      const context = new TestCanvas(420, 300, callSequence)
      const skeleton = new TestSkeleton(callSequence)
      const animationState = new TestAnimationState(callSequence)
      const skeletonRenderer = new TestSkeletonRenderer(callSequence)
      const bounds: TestBound = { height: 120 }
      const lastFrameTime = Date.now() / 1000 - 0.25

      const beforeRender = Date.now() / 1000
      const result = page.render(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds)
      const afterRender = Date.now() / 1000

      expect(context.clearRectCalls[0].x).assertEqual(0)
      expect(context.clearRectCalls[0].y).assertEqual(0)
      expect(context.clearRectCalls[0].width).assertEqual(420)
      expect(context.clearRectCalls[0].height).assertEqual(300)
      expectClose(skeleton.x, 210)
      expectClose(skeleton.y, 270)   // 300 - 300*0.1
      expectClose(skeleton.scaleX, 1.25)  // 300/120*0.5
      expectClose(skeleton.scaleY, -1.25)
      expect(animationState.updateCalls.length).assertEqual(1)
      expect(animationState.appliedSkeleton === skeleton).assertTrue()
      expect(skeleton.updateWorldTransformCalls).assertEqual(1)
      expect(skeletonRenderer.drawnSkeleton === skeleton).assertTrue()
      expect(callSequence.join(',')).assertEqual('clearRect,update,apply,updateWorldTransform,draw')
      expect(result.isFinish).assertTrue()
      expect(result.time >= beforeRender).assertTrue()
      expect(result.time <= afterRender).assertTrue()
      expectClose(animationState.updateCalls[0], result.time - lastFrameTime)
    })

    it('recomputes placement from different canvas and bounds size', 0, () => {
      const page = createPage()
      const callSequence: Array<string> = []
      const context = new TestCanvas(600, 400, callSequence)
      const skeleton = new TestSkeleton(callSequence)
      const animationState = new TestAnimationState(callSequence)
      const skeletonRenderer = new TestSkeletonRenderer(callSequence)
      const bounds: TestBound = { height: 200 }
      const lastFrameTime = Date.now() / 1000 - 0.5

      const beforeRender = Date.now() / 1000
      const result = page.render(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds)
      const afterRender = Date.now() / 1000

      expectClose(skeleton.x, 300)
      expectClose(skeleton.y, 360)   // 400 - 400*0.1
      expectClose(skeleton.scaleX, 1.0)  // 400/200*0.5
      expectClose(skeleton.scaleY, -1.0)
      expect(callSequence.join(',')).assertEqual('clearRect,update,apply,updateWorldTransform,draw')
      expect(result.isFinish).assertTrue()
      expect(result.time >= beforeRender).assertTrue()
      expect(result.time <= afterRender).assertTrue()
    })

    it('uses fractional scale when bounds are taller than canvas', 0, () => {
      const page = createPage()
      const callSequence: Array<string> = []
      const context = new TestCanvas(300, 200, callSequence)
      const skeleton = new TestSkeleton(callSequence)
      const animationState = new TestAnimationState(callSequence)
      const skeletonRenderer = new TestSkeletonRenderer(callSequence)
      const bounds: TestBound = { height: 400 }
      const lastFrameTime = Date.now() / 1000 - 0.1

      const beforeRender = Date.now() / 1000
      const result = page.render(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds)
      const afterRender = Date.now() / 1000

      expectClose(skeleton.x, 150)
      expectClose(skeleton.y, 180)   // 200 - 200*0.1
      expectClose(skeleton.scaleX, 0.25)  // 200/400*0.5
      expectClose(skeleton.scaleY, -0.25)
      expect(skeletonRenderer.drawnSkeleton === skeleton).assertTrue()
      expect(result.isFinish).assertTrue()
      expect(result.time >= beforeRender).assertTrue()
      expect(result.time <= afterRender).assertTrue()
    })
  })
}
