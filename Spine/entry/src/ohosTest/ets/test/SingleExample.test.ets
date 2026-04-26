
import { describe, it, expect } from '@ohos/hypium'
import { Physics, Bound, Delay } from '@ohos/spine'
import { createPageInstance } from '../helpers/RouteCapture'
import '../../../main/ets/pages/SingleExample'

// render: y = height - height*0.2 = 300*0.8 = 240, scale = 300/100*0.5 = 1.5
type RenderFn = (
  ctx: ESObject, lastFrameTime: number,
  skeleton: ESObject, animationState: ESObject,
  skeletonRenderer: ESObject, bounds: ESObject
) => Delay

interface MockObjects {
  context: ESObject
  skeleton: ESObject
  animationState: ESObject
  skeletonRenderer: ESObject
  callOrder: string[]
}
function makeMocks(width: number, height: number): MockObjects {
  const callOrder: string[] = []
  const context: ESObject = {
    width: width, height: height,
    clearRect: (): void => { callOrder.push('clear') }
  }
  const skeleton: ESObject = {
    x: 0, y: 0, scaleX: 0, scaleY: 0,
    updateWorldTransform: (): void => { callOrder.push('world') }
  }
  const animationState: ESObject = {
    update: (): void => { callOrder.push('update') },
    apply: (): boolean => { callOrder.push('apply'); return true }
  }
  const skeletonRenderer: ESObject = {
    draw: (): void => { callOrder.push('draw') }
  }
  return { context, skeleton, animationState, skeletonRenderer, callOrder }
}

export default function SingleExampleTest() {
  describe('SingleExampleTest', () => {

    it('render_updatesSkeletonPositionWithPoint2Offset', 0, () => {
      const page: Object = createPageInstance('SingleExample')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects: MockObjects = makeMocks(400, 300)
      const context: ESObject = mockObjects.context
      const skeleton: ESObject = mockObjects.skeleton
      const animationState: ESObject = mockObjects.animationState
      const skeletonRenderer: ESObject = mockObjects.skeletonRenderer
      const callOrder: string[] = mockObjects.callOrder
      const bounds: Bound = { x: 0, y: 0, width: 100, height: 100 }
      const lastFrameTime: number = Date.now() / 1000 - 0.5

      const result: Delay = renderFn(context, lastFrameTime, skeleton, animationState,
        skeletonRenderer, bounds as ESObject)

      expect(skeleton.x as number).assertEqual(200)
      expect(skeleton.y as number).assertEqual(240)       // 300 - 300*0.2
      expect(skeleton.scaleX as number).assertEqual(1.5)  // 300/100*0.5
      expect(skeleton.scaleY as number).assertEqual(-1.5)
      expect(result.isFinish).assertTrue()
      expect(callOrder.join('>')).assertEqual('clear>update>apply>world>draw')
    })

    it('render_differentDimensions_scalesCorrectly', 0, () => {
      const page: Object = createPageInstance('SingleExample')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects2: MockObjects = makeMocks(800, 400)
      const context: ESObject = mockObjects2.context
      const skeleton: ESObject = mockObjects2.skeleton
      const animationState: ESObject = mockObjects2.animationState
      const skeletonRenderer: ESObject = mockObjects2.skeletonRenderer
      const bounds: Bound = { x: 0, y: 0, width: 200, height: 200 }
      const lastFrameTime: number = Date.now() / 1000 - 0.2

      renderFn(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds as ESObject)

      expect(skeleton.x as number).assertEqual(400)       // 800/2
      expect(skeleton.y as number).assertEqual(320)       // 400 - 400*0.2
      expect(skeleton.scaleX as number).assertEqual(1.0)  // 400/200*0.5
      expect(skeleton.scaleY as number).assertEqual(-1.0)
    })

    it('render_returnsUpdatedTime', 0, () => {
      const page: Object = createPageInstance('SingleExample')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects3: MockObjects = makeMocks(300, 200)
      const context: ESObject = mockObjects3.context
      const skeleton: ESObject = mockObjects3.skeleton
      const animationState: ESObject = mockObjects3.animationState
      const skeletonRenderer: ESObject = mockObjects3.skeletonRenderer
      const bounds: Bound = { x: 0, y: 0, width: 80, height: 100 }
      const before: number = Date.now() / 1000
      const lastFrameTime: number = before - 1.0

      const result: Delay = renderFn(context, lastFrameTime, skeleton, animationState,
        skeletonRenderer, bounds as ESObject)

      expect(result.isFinish).assertTrue()
      expect(result.time >= before).assertTrue()
    })

    it('onBackPress_returnsFalse', 0, () => {
      const page: Object = createPageInstance('SingleExample')
      const result: ESObject = (page as ESObject)['onBackPress']()
      expect(result as boolean).assertFalse()
    })

    it('aboutToDisappear_clearsCanvas', 0, () => {
      const page: Object = createPageInstance('SingleExample')
      let cleared: boolean = false
      ;(page as ESObject)['canvasRenderingContext'] = {
        width: 400, height: 300,
        clearRect: (): void => { cleared = true }
      } as ESObject
      ;(page as ESObject)['aboutToDisappear']()
      expect(cleared).assertTrue()
    })

  })
}
