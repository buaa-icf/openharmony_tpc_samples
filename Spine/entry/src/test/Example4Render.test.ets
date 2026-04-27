import { afterEach, describe, expect, it } from '@ohos/hypium'

import { createCapturedPage } from './pageRouteCapture'
import {
  RenderablePage,
  TestAnimationState,
  TestBound,
  TestCanvasRenderingContext,
  TestSkeleton,
  TestSkeletonRenderer,
  assertFrameResult,
  expectClose
} from './renderTestFakes'
import '../main/ets/pages/Example4'

const PAGE_PATH = 'pages/Example4'

const createdPages: Array<RenderablePage> = []

function createPage(): RenderablePage {
  const page = createCapturedPage(PAGE_PATH) as RenderablePage
  createdPages.push(page)
  return page
}

export default function example4RenderTest() {
  describe('Example4RenderTest', () => {
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
      expect(context.clearRectCalls[0].width).assertEqual(300)
      expect(context.clearRectCalls[0].height).assertEqual(200)
      expectClose(skeleton.x, 150)
      expectClose(skeleton.y, 180)
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
      expectClose(skeleton.y, 432)
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
      expectClose(skeleton.y, 81)
      expectClose(skeleton.scaleX, 0.15)
      expectClose(skeleton.scaleY, -0.15)
      expect(skeletonRenderer.drawnSkeleton === skeleton).assertTrue()
      assertFrameResult(result, beforeRender, afterRender, lastFrameTime, animationState)
    })
  })
}
