import { describe, it, expect } from '@ohos/hypium';
import {
  AnimationState,
  Bound,
  Delay,
  Physics,
  Skeleton,
  SkeletonRenderer
} from '@ohos/spine';
import { renderNetworkExampleFrame } from '../../../main/ets/pages/NetworkExample';

interface ClearRectCall {
  x: number;
  y: number;
  width: number;
  height: number;
}

export default function NetworkExampleTest() {
  describe('NetworkExampleTest', () => {
    it('renderUpdatesCanvasSkeletonAndAnimation', 0, () => {
      let callOrder: string = '';
      let clearRectCall: ClearRectCall = { x: -1, y: -1, width: -1, height: -1 };
      let updatedDelta: number = -1;
      let appliedSkeleton: ESObject | undefined = undefined;
      let worldTransformPhysics: Physics | undefined = undefined;
      let drawnSkeleton: ESObject | undefined = undefined;

      let context: ESObject = {
        width: 500,
        height: 400,
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
      let bounds: Bound = { x: 0, y: 0, width: 120, height: 200 };
      let lastFrameTime: number = Date.now() / 1000 - 0.5;

      let result: Delay = renderNetworkExampleFrame(context as CanvasRenderingContext2D, lastFrameTime,
        skeleton as Skeleton, animationState as AnimationState, skeletonRenderer as SkeletonRenderer, bounds);

      expect(clearRectCall.x).assertEqual(0);
      expect(clearRectCall.y).assertEqual(0);
      expect(clearRectCall.width).assertEqual(500);
      expect(clearRectCall.height).assertEqual(400);
      expect(skeleton.x).assertEqual(250);
      expect(skeleton.y).assertEqual(360);
      expect(skeleton.scaleX).assertEqual(1.6);
      expect(skeleton.scaleY).assertEqual(-1.6);
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
