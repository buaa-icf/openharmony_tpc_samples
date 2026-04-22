import { describe, it, expect } from '@ohos/hypium';
import {
  AnimationState,
  Bound,
  Delay,
  Physics,
  Skeleton,
  SkeletonRenderer
} from '@ohos/spine';
import { renderExample1Frame } from '../../../main/ets/pages/Example1';

interface ClearRectCall {
  x: number;
  y: number;
  width: number;
  height: number;
}

export default function Example1Test() {
  describe('Example1Test', () => {
    it('renderUpdatesCanvasSkeletonAndAnimation', 0, () => {
      let callOrder: string = '';
      let clearRectCall: ClearRectCall = { x: -1, y: -1, width: -1, height: -1 };
      let updatedDelta: number = -1;
      let appliedSkeleton: ESObject | undefined = undefined;
      let worldTransformPhysics: Physics | undefined = undefined;
      let drawnSkeleton: ESObject | undefined = undefined;

      let context: ESObject = {
        width: 420,
        height: 300,
        clearRect: (x: number, y: number, width: number, height: number): void => {
          callOrder += 'clear>';
          clearRectCall = { x: x, y: y, width: width, height: height };
        }
      };
      let skeleton: ESObject = {
        x: 0,
        y: 0,
        scaleX: 0,
        scaleY: 0,
        updateWorldTransform: (physics: Physics): void => {
          callOrder += 'world>';
          worldTransformPhysics = physics;
        }
      };
      let animationState: ESObject = {
        update: (delta: number): void => {
          callOrder += 'update>';
          updatedDelta = delta;
        },
        apply: (target: ESObject): boolean => {
          callOrder += 'apply>';
          appliedSkeleton = target;
          return true;
        }
      };
      let skeletonRenderer: ESObject = {
        draw: (target: ESObject): void => {
          callOrder += 'draw>';
          drawnSkeleton = target;
        }
      };
      let bounds: Bound = { x: 0, y: 0, width: 100, height: 120 };
      let lastFrameTime: number = Date.now() / 1000 - 0.5;

      let result: Delay = renderExample1Frame(context as CanvasRenderingContext2D, lastFrameTime, skeleton as Skeleton,
        animationState as AnimationState, skeletonRenderer as SkeletonRenderer, bounds);

      expect(clearRectCall.x).assertEqual(0);
      expect(clearRectCall.y).assertEqual(0);
      expect(clearRectCall.width).assertEqual(420);
      expect(clearRectCall.height).assertEqual(300);
      expect(skeleton.x).assertEqual(210);
      expect(skeleton.y).assertEqual(270);
      expect(skeleton.scaleX).assertEqual(1.25);
      expect(skeleton.scaleY).assertEqual(-1.25);
      expect(updatedDelta > 0).assertTrue();
      expect(appliedSkeleton).assertEqual(skeleton);
      expect(worldTransformPhysics).assertEqual(Physics.update);
      expect(drawnSkeleton).assertEqual(skeleton);
      expect(result.isFinish).assertTrue();
      expect(result.time >= lastFrameTime).assertTrue();
      expect(callOrder).assertEqual('clear>update>apply>world>draw>');
    });
  });
}
