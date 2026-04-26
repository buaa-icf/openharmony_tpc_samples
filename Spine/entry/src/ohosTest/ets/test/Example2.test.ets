import { describe, it, expect } from '@ohos/hypium'
import { Physics, Bound, Delay } from '@ohos/spine'
import { createPageInstance } from '../helpers/RouteCapture'
import '../../../main/ets/pages/Example2'

// render: y = height - height*0.3 = 300*0.7 = 210, scale = 300/120*0.5 = 1.25
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
    clearRect: (_x: number, _y: number, _w: number, _h: number): void => { callOrder.push('clear') }
  }
  const skeleton: ESObject = {
    x: 0, y: 0, scaleX: 0, scaleY: 0,
    updateWorldTransform: (_p: ESObject): void => { callOrder.push('world') }
  }
  const animationState: ESObject = {
    update: (_d: number): void => { callOrder.push('update') },
    apply: (_s: ESObject): boolean => { callOrder.push('apply'); return true }
  }
  const skeletonRenderer: ESObject = {
    draw: (_s: ESObject): void => { callOrder.push('draw') }
  }
  return { context, skeleton, animationState, skeletonRenderer, callOrder }
}

export default function Example2Test() {
  describe('Example2Test', () => {

    it('render_updatesSkeletonPositionWithPoint3Offset', 0, () => {
      const page: Object = createPageInstance('Example2')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects: MockObjects = makeMocks(420, 300)
      const context: ESObject = mockObjects.context
      const skeleton: ESObject = mockObjects.skeleton
      const animationState: ESObject = mockObjects.animationState
      const skeletonRenderer: ESObject = mockObjects.skeletonRenderer
      const callOrder: string[] = mockObjects.callOrder
      const bounds: Bound = { x: 0, y: 0, width: 100, height: 120 }
      const lastFrameTime: number = Date.now() / 1000 - 0.5

      const result: Delay = renderFn(context, lastFrameTime, skeleton, animationState,
        skeletonRenderer, bounds as ESObject)

      expect(skeleton.x as number).assertEqual(210)
      expect(skeleton.y as number).assertEqual(210)       // 300 - 300*0.3
      expect(skeleton.scaleX as number).assertEqual(1.25) // 300/120*0.5
      expect(skeleton.scaleY as number).assertEqual(-1.25)
      expect(result.isFinish).assertTrue()
      expect(callOrder.join('>')).assertEqual('clear>update>apply>world>draw')
    })

    it('render_differentDimensions_scalesCorrectly', 0, () => {
      const page: Object = createPageInstance('Example2')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects2: MockObjects = makeMocks(800, 600)
      const context: ESObject = mockObjects2.context
      const skeleton: ESObject = mockObjects2.skeleton
      const animationState: ESObject = mockObjects2.animationState
      const skeletonRenderer: ESObject = mockObjects2.skeletonRenderer
      const bounds: Bound = { x: 0, y: 0, width: 100, height: 300 }
      const lastFrameTime: number = Date.now() / 1000 - 0.2

      renderFn(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds as ESObject)

      expect(skeleton.x as number).assertEqual(400)       // 800/2
      expect(skeleton.y as number).assertEqual(420)       // 600 - 600*0.3
      expect(skeleton.scaleX as number).assertEqual(1.0)  // 600/300*0.5
      expect(skeleton.scaleY as number).assertEqual(-1.0)
    })

    it('render_returnsUpdatedTime', 0, () => {
      const page: Object = createPageInstance('Example2')
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
      const page: Object = createPageInstance('Example2')
      const result: ESObject = (page as ESObject)['onBackPress']()
      expect(result as boolean).assertFalse()
    })

    it('aboutToDisappear_clearsCanvas', 0, () => {
      const page: Object = createPageInstance('Example2')
      let cleared: boolean = false
      ;(page as ESObject)['canvasRenderingContext'] = {
        width: 420, height: 300,
        clearRect: (): void => { cleared = true }
      } as ESObject
      ;(page as ESObject)['aboutToDisappear']()
      expect(cleared).assertTrue()
    })

  })
}
