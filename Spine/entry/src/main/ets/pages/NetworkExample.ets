/**
 * Apache License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  AssetManager,
  AtlasAttachmentLoader,
  AnimationState,
  AnimationStateData,
  SkeletonRenderer,
  SkeletonJson,
  Skeleton,
  TextureAtlas,
  Physics,
  Delay,
  Bound
} from '@ohos/spine'

import { Animator as animator, AnimatorResult, AnimatorOptions } from '@kit.ArkUI';

@Entry
@Component
struct NetWorkExample {
  // 渲染构建上下文
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings);
  private _animator: AnimatorResult | undefined;
  private animationState: AnimationState | undefined;
  private animations: Array<string> = ['death', 'aim', 'idle', 'jump', 'run', 'shoot', 'walk'];
  private currentIndex: number = 0;
  private animationName: string = '';

  aboutToDisappear() {
    this._animator?.finish();
    this.canvasRenderingContext.clearRect(0, 0, this.canvasRenderingContext.width, this.canvasRenderingContext.height);
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Row({ space: 10 }) {
          // 关联画布
          Canvas(this.canvasRenderingContext)
            .width('100%')
            .height('100%')
            .onClick(() => {
              if (this.currentIndex < this.animations.length) {
                this.animationName = this.animations[this.currentIndex];
                this.animationState?.setAnimation(0, this.animationName, true);
                this.currentIndex = (this.currentIndex + 1) % this.animations.length;
              }
            })
        }


        // 加载网络Img
        Row() {
          Button('加载动画')
            .onClick(() => {
              this.loadAnimation();
            });
          Button('播放动画')
            .onClick(() => {
              this._animator?.play();
            });
          Button('停止动画')
            .onClick(() => {
              this._animator?.pause();
            });
          Button('清空画布')
            .onClick(() => {
              this._animator?.finish();
              this.animationState?.setEmptyAnimations(0);
              this.canvasRenderingContext.clearRect(0, 0, this.canvasRenderingContext.width,
                this.canvasRenderingContext.height);
            });

        }.margin({ top: 5 })

        Row() {
          Button('站')
            .onClick(() => {
              this.animationState?.setAnimation(0, 'aim', true);
            });
          Button('躺')
            .onClick(() => {
              this.animationState?.setAnimation(0, 'death', true);
            });
          Button('悠闲')
            .onClick(() => {
              this.animationState?.setAnimation(0, 'idle', true);
            });
          Button('跳')
            .onClick(() => {
              this.animationState?.setAnimation(0, 'jump', true);
            });
          Button('跑')
            .onClick(() => {
              this.animationState?.setAnimation(0, 'run', true);
            });
          Button('射击')
            .onClick(() => {
              this.animationState?.setAnimation(0, 'shoot', true);
            });

          Button('走')
            .onClick(() => {
              this.animationState?.setAnimation(0, 'walk', true);
            });
        }.margin({ top: 5 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  async loadAnimation() {
    let skeletonRenderer = new SkeletonRenderer(this.canvasRenderingContext);
    skeletonRenderer.triangleRendering = true; // true是使用drawTriangle方式渲染 false是使用drawImages方式渲染

    // Load the assets.
    let assetManager = new AssetManager("https://esotericsoftware.com/files/examples/4.0/spineboy/export/");
    assetManager.loadText("spineboy-ess.json");
    assetManager.loadTextureAtlas("spineboy.atlas");
    await assetManager.loadAll();

    // Create the texture atlas and skeleton data.
    let atlas: TextureAtlas = assetManager.require("spineboy.atlas");
    let atlasLoader = new AtlasAttachmentLoader(atlas);
    let skeletonJson = new SkeletonJson(atlasLoader);
    let skeletonData = skeletonJson.readSkeletonData(assetManager.require("spineboy-ess.json"));

    // Instantiate a new skeleton based on the atlas and skeleton data.
    let skeleton = new Skeleton(skeletonData);
    skeleton.setToSetupPose();
    skeleton.updateWorldTransform(Physics.update);
    let bounds = skeleton.getBoundsRect();

    // Setup an animation state with a default mix of 0.2 seconds.
    let animationStateData = new AnimationStateData(skeleton.data);
    animationStateData.defaultMix = 0.2;
    this.animationState = new AnimationState(animationStateData);

    let lastFrameTime = Date.now() / 1000;
    if (this._animator) {
      this._animator.finish();
    }
    let options: AnimatorOptions = {
      duration: 20000,
      easing: 'linear',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: -1,
      begin: 0,
      end: 1
    };
    let expectedFrameRate: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 60
    }

    this._animator = animator.create(options);
    this._animator.setExpectedFrameRateRange(expectedFrameRate);
    let result: Delay = { time: lastFrameTime, isFinish: true };
    this._animator.onFrame = (value: number) => {
      if (result.isFinish) {
        result.isFinish = false;
        result = this.render(this.canvasRenderingContext, result.time, skeleton, this.animationState!, skeletonRenderer,
          bounds);
      }
    }
    this._animator.play();
    this.animationState?.setAnimation(0, 'walk', true);
  }

  render(context: CanvasRenderingContext2D, lastFrameTime: number, skeleton: Skeleton, animationState: AnimationState,
    skeletonRenderer: SkeletonRenderer, bounds: Bound): Delay {
    // Calculate the delta time between this and the last frame in seconds.
    let now = Date.now() / 1000;
    let delta = now - lastFrameTime;
    lastFrameTime = now;

    // Resize the canvas drawing buffer if the canvas CSS width and height changed
    // and clear the canvas.

    context.clearRect(0, 0, context.width, context.height);

    // Center the skeleton and resize it so it fits inside the canvas.
    skeleton.x = context.width / 2;
    skeleton.y = context.height - context.height * 0.1;
    let scale = context.height / bounds.height * 0.8;
    skeleton.scaleX = scale;
    skeleton.scaleY = -scale;

    // Update and apply the animation state, update the skeleton's
    // world transforms and render the skeleton.
    animationState.update(delta);
    animationState.apply(skeleton);
    skeleton.updateWorldTransform(Physics.update);
    skeletonRenderer.draw(skeleton);

    let result: Delay = { time: lastFrameTime, isFinish: true };
    return result;
  }

  onBackPress(): boolean | void {
    return false;
  }
}
