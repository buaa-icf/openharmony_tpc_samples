import { expect } from '@ohos/hypium'

export interface ClearRectCall {
  x: number
  y: number
  width: number
  height: number
}

export interface TestBound {
  height: number
}

export interface TestDelay {
  time: number
  isFinish: boolean
}

export interface RenderablePage {
  render(context: TestCanvasRenderingContext, lastFrameTime: number, skeleton: TestSkeleton,
    animationState: TestAnimationState, skeletonRenderer: TestSkeletonRenderer, bounds: TestBound): TestDelay
  aboutToBeDeleted?(): void
}

export class TestCanvasRenderingContext {
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

export class TestSkeleton {
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

export class TestAnimationState {
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

export class TestSkeletonRenderer {
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

export function expectClose(actual: number, expected: number): void {
  expect(Math.abs(actual - expected) < 0.000001).assertTrue()
}

export function assertFrameResult(result: TestDelay, beforeRender: number, afterRender: number, lastFrameTime: number,
  animationState: TestAnimationState): void {
  expect(result.isFinish).assertTrue()
  expect(result.time >= beforeRender).assertTrue()
  expect(result.time <= afterRender).assertTrue()
  expectClose(animationState.updateCalls[0], result.time - lastFrameTime)
}
