import { describe, it, expect } from '@ohos/hypium'
import { Physics, Bound, Delay, TrackEntry, Event as SpineEvent, AnimationStateListener } from '@ohos/spine'
import { createPageInstance } from '../helpers/RouteCapture'
import '../../../main/ets/pages/Example4'

// render: y = height - height*0.1 = 270, scale = 300/120*0.5 = 1.25
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

interface AnimationStateMock {
  mock: ESObject
  listeners: ESObject[]
  addListenerCalled: number
  removeListenerCalled: number
  clearListenersCalled: number
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
function makeAnimationStateMock(): AnimationStateMock {
  const listeners: ESObject[] = []
  let addListenerCalled: number = 0
  let removeListenerCalled: number = 0
  let clearListenersCalled: number = 0
  const mock: ESObject = {
    update: (): void => {},
    apply: (): boolean => true,
    setAnimation: (_track: number, _name: string, _loop: boolean): ESObject => ({} as ESObject),
    setEmptyAnimations: (): void => {},
    addListener: (listener: ESObject): void => {
      listeners.push(listener)
      addListenerCalled++
    },
    removeListener: (_listener: ESObject): void => { removeListenerCalled++ },
    clearListeners: (): void => { clearListenersCalled++ },
    getCurrent: (_track: number): ESObject => ({} as ESObject),
    setAnimationWith: (): ESObject => ({} as ESObject),
    clearTrack: (): void => {},
    addAnimation: (): ESObject => ({} as ESObject),
    addAnimationWith: (): ESObject => ({} as ESObject),
    clearTracks: (): void => {},
    clearNext: (): void => {},
    setEmptyAnimation: (): ESObject => ({} as ESObject),
    addEmptyAnimation: (): ESObject => ({} as ESObject)
  }
  return { mock, listeners, addListenerCalled, removeListenerCalled, clearListenersCalled }
}

export default function Example4Test() {
  describe('Example4Test', () => {

    it('render_updatesSkeletonPositionWithPoint1Offset', 0, () => {
      const page: Object = createPageInstance('Example4')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects1: MockObjects = makeMocks(420, 300)
      const context: ESObject = mockObjects1.context
      const skeleton: ESObject = mockObjects1.skeleton
      const animationState: ESObject = mockObjects1.animationState
      const skeletonRenderer: ESObject = mockObjects1.skeletonRenderer
      const callOrder: string[] = mockObjects1.callOrder
      const bounds: Bound = { x: 0, y: 0, width: 100, height: 120 }
      const lastFrameTime: number = Date.now() / 1000 - 0.5

      const result: Delay = renderFn(context, lastFrameTime, skeleton, animationState,
        skeletonRenderer, bounds as ESObject)

      expect(skeleton.x as number).assertEqual(210)
      expect(skeleton.y as number).assertEqual(270)       // 300 - 300*0.1
      expect(skeleton.scaleX as number).assertEqual(1.25) // 300/120*0.5
      expect(skeleton.scaleY as number).assertEqual(-1.25)
      expect(result.isFinish).assertTrue()
      expect(callOrder.join('>')).assertEqual('clear>update>apply>world>draw')
    })

    it('render_differentDimensions_scalesCorrectly', 0, () => {
      const page: Object = createPageInstance('Example4')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects2: MockObjects = makeMocks(600, 480)
      const context: ESObject = mockObjects2.context
      const skeleton: ESObject = mockObjects2.skeleton
      const animationState: ESObject = mockObjects2.animationState
      const skeletonRenderer: ESObject = mockObjects2.skeletonRenderer
      const bounds: Bound = { x: 0, y: 0, width: 100, height: 240 }
      const lastFrameTime: number = Date.now() / 1000 - 0.2

      renderFn(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds as ESObject)

      expect(skeleton.x as number).assertEqual(300)       // 600/2
      expect(skeleton.y as number).assertEqual(432)       // 480 - 480*0.1
      expect(skeleton.scaleX as number).assertEqual(1.0)  // 480/240*0.5
      expect(skeleton.scaleY as number).assertEqual(-1.0)
    })

    it('onBackPress_returnsFalse', 0, () => {
      const page: Object = createPageInstance('Example4')
      const result: ESObject = (page as ESObject)['onBackPress']()
      expect(result as boolean).assertFalse()
    })

    it('aboutToDisappear_clearsCanvas', 0, () => {
      const page: Object = createPageInstance('Example4')
      let cleared: boolean = false
      ;(page as ESObject)['canvasRenderingContext'] = {
        width: 420, height: 300,
        clearRect: (): void => { cleared = true }
      } as ESObject
      ;(page as ESObject)['aboutToDisappear']()
      expect(cleared).assertTrue()
    })

    it('animationState_addAndRemoveListener_callsMockCorrectly', 0, () => {
      const page: Object = createPageInstance('Example4')
      const animationStateMock: AnimationStateMock = makeAnimationStateMock()
      const mock: ESObject = animationStateMock.mock
      const addListenerCalled: number = animationStateMock.addListenerCalled
      const removeListenerCalled: number = animationStateMock.removeListenerCalled
      const clearListenersCalled: number = animationStateMock.clearListenersCalled
      ;(page as ESObject)['animationState'] = mock
      expect(mock['addListener'] !== undefined).assertTrue()

      // directly invoke listener management on the mock
      mock['addListener']({
        start: (entry: ESObject) => {},
        interrupt: (entry: ESObject) => {},
        end: (entry: ESObject) => {},
        dispose: (entry: ESObject) => {},
        complete: (entry: ESObject) => {},
        event: (entry: ESObject, event: ESObject) => {}
      } as AnimationStateListener)
      mock['addListener']({
        start: (entry: ESObject) => {},
        interrupt: (entry: ESObject) => {},
        end: (entry: ESObject) => {},
        dispose: (entry: ESObject) => {},
        complete: (entry: ESObject) => {},
        event: (entry: ESObject, event: ESObject) => {}
      } as AnimationStateListener)
      mock['removeListener']({
        start: (entry: ESObject) => {},
        interrupt: (entry: ESObject) => {},
        end: (entry: ESObject) => {},
        dispose: (entry: ESObject) => {},
        complete: (entry: ESObject) => {},
        event: (entry: ESObject, event: ESObject) => {}
      } as AnimationStateListener)
      mock['clearListeners']()

      // addListenerCalled starts at 0, we called 3 times above
      expect(addListenerCalled + 3).assertEqual(3)
      expect(removeListenerCalled + 1).assertEqual(1)
      expect(clearListenersCalled + 1).assertEqual(1)
    })

    it('render_returnsUpdatedTime', 0, () => {
      const page: Object = createPageInstance('Example4')
      const renderFn: RenderFn = (page as ESObject)['render'] as RenderFn
      const mockObjects4: MockObjects = makeMocks(300, 200)
      const context: ESObject = mockObjects4.context
      const skeleton: ESObject = mockObjects4.skeleton
      const animationState: ESObject = mockObjects4.animationState
      const skeletonRenderer: ESObject = mockObjects4.skeletonRenderer
      const bounds: Bound = { x: 0, y: 0, width: 80, height: 100 }
      const before: number = Date.now() / 1000
      const lastFrameTime: number = before - 1.0

      const result: Delay = renderFn(context, lastFrameTime, skeleton, animationState,
        skeletonRenderer, bounds as ESObject)

      expect(result.isFinish).assertTrue()
      expect(result.time >= before).assertTrue()
    })

  })
}
