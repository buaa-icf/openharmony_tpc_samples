import { describe, it, expect } from '@ohos/hypium'
import { Physics, Bound, Delay } from '@ohos/spine'
import { createPageInstance } from '../helpers/RouteCapture'
import '../../../main/ets/pages/NetworkExample'

// render: y = height - height*0.1 = 400*0.9 = 360, scale = 400/200*0.8 = 1.6
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

export default function NetworkExampleTest() {
  describe('NetworkExampleTest', () => {

    it('render_updatesSkeletonPositionWithPoint8Scale', 0, () => {
      const page: Object = createPageInstance('NetworkExample')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects1: MockObjects = makeMocks(500, 400)
      const context: ESObject = mockObjects1.context
      const skeleton: ESObject = mockObjects1.skeleton
      const animationState: ESObject = mockObjects1.animationState
      const skeletonRenderer: ESObject = mockObjects1.skeletonRenderer
      const callOrder: string[] = mockObjects1.callOrder
      const bounds: Bound = { x: 0, y: 0, width: 120, height: 200 }
      const lastFrameTime: number = Date.now() / 1000 - 0.5

      const result: Delay = renderFn(context, lastFrameTime, skeleton, animationState,
        skeletonRenderer, bounds as ESObject)

      expect(skeleton.x as number).assertEqual(250)
      expect(skeleton.y as number).assertEqual(360)       // 400 - 400*0.1
      expect(skeleton.scaleX as number).assertEqual(1.6)  // 400/200*0.8
      expect(skeleton.scaleY as number).assertEqual(-1.6)
      expect(result.isFinish).assertTrue()
      expect(callOrder.join('>')).assertEqual('clear>update>apply>world>draw')
    })

    it('render_differentDimensions_scalesCorrectly', 0, () => {
      const page: Object = createPageInstance('NetworkExample')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects2: MockObjects = makeMocks(640, 480)
      const context: ESObject = mockObjects2.context
      const skeleton: ESObject = mockObjects2.skeleton
      const animationState: ESObject = mockObjects2.animationState
      const skeletonRenderer: ESObject = mockObjects2.skeletonRenderer
      const bounds: Bound = { x: 0, y: 0, width: 100, height: 300 }
      const lastFrameTime: number = Date.now() / 1000 - 0.3

      renderFn(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds as ESObject)

      expect(skeleton.x as number).assertEqual(320)        // 640/2
      expect(skeleton.y as number).assertEqual(432)        // 480 - 480*0.1
      expect(skeleton.scaleX as number).assertEqual(1.28)  // 480/300*0.8
      expect(skeleton.scaleY as number).assertEqual(-1.28)
    })

    it('render_returnsUpdatedTime', 0, () => {
      const page: Object = createPageInstance('NetworkExample')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects3: MockObjects = makeMocks(300, 200)
      const context: ESObject = mockObjects3.context
      const skeleton: ESObject = mockObjects3.skeleton
      const animationState: ESObject = mockObjects3.animationState
      const skeletonRenderer: ESObject = mockObjects3.skeletonRenderer
      const bounds: Bound = { x: 0, y: 0, width: 80, height: 100 }
      const before: number = Date.now() / 1000
      const lastFrameTime: number = before - 1.5

      const result: Delay = renderFn(context, lastFrameTime, skeleton, animationState,
        skeletonRenderer, bounds as ESObject)

      expect(result.isFinish).assertTrue()
      expect(result.time >= before).assertTrue()
    })

    it('onBackPress_returnsFalse', 0, () => {
      const page: Object = createPageInstance('NetworkExample')
      const result: ESObject = (page as ESObject)['onBackPress']()
      expect(result as boolean).assertFalse()
    })

    it('aboutToDisappear_clearsCanvas', 0, () => {
      const page: Object = createPageInstance('NetworkExample')
      let cleared: boolean = false
      ;(page as ESObject)['canvasRenderingContext'] = {
        width: 500, height: 400,
        clearRect: (): void => { cleared = true }
      } as ESObject
      ;(page as ESObject)['aboutToDisappear']()
      expect(cleared).assertTrue()
    })

  })
}
