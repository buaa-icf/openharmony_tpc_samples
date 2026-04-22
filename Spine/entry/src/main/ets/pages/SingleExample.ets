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
struct SingleExample {
  // 渲染构建上下文
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings);
  private _animator: AnimatorResult | undefined;
  private animationState: AnimationState | undefined;
  private rawfilePath: string = 'animation/';
  private animations: Array<string> = ['aim', 'death', 'idle', 'jump', 'run', 'shoot', 'walk'];
  private sourcesData: SourcesData = { json: 'spineboy-ess.json', atlas: 'spineboy.atlas' };
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
            .onVisibleAreaChange([0], (isVisible: boolean) => {
              if (isVisible) {
                this._animator?.play();
              } else {
                this._animator?.pause();
              }
            })
        }

        // 加载网络Img
        Row() {
          Button($r('app.string.Pause_animation'))
            .onClick(() => {
              this._animator?.pause();
            });
          Button($r('app.string.Play_animation'))
            .onClick(() => {
              this._animator?.play();
            });
          Button($r('app.string.Clear_canvas'))
            .onClick(() => {
              this._animator?.finish();
              this.animationState?.setEmptyAnimations(0);
              this.canvasRenderingContext.clearRect(0, 0, this.canvasRenderingContext.width,
                this.canvasRenderingContext.height);
            });

          Button($r('app.string.Resource_6'))
            .onClick(() => {
              this.rawfilePath = 'animation6/';
              this.sourcesData.json = 'stretchyman-pro.json';
              this.sourcesData.atlas = 'stretchyman-pma.atlas';
              this.animations = ['idle', 'sneak'];
              this.currentIndex = 0;
              this.loadAnimation();
              this.animationName = 'idle';
              this.animationState?.setAnimation(0, this.animationName, true);
            });

        }.margin({ top: 5 })

        Row() {
          Button($r('app.string.Resource_1'))
            .onClick(() => {
              this.rawfilePath = 'animation/';
              this.sourcesData.json = 'spineboy-ess.json';
              this.sourcesData.atlas = 'spineboy.atlas';
              this.animations = ['aim', 'death', 'idle', 'jump', 'run', 'shoot', 'walk'];
              this.currentIndex = 0;
              this.loadAnimation();
              this.animationName = 'walk';
              this.animationState?.setAnimation(0, this.animationName, true);
            });

          Button($r('app.string.Resource_2'))
            .onClick(() => {
              this.rawfilePath = 'animation2/';
              this.sourcesData.json = 'snowglobe-pro.json';
              this.sourcesData.atlas = 'snowglobe-pma.atlas';
              this.animations = ['eyeblink', 'idle', 'shake'];
              this.currentIndex = 0;
              this.loadAnimation();
              this.animationName = 'eyeblink';
              this.animationState?.setAnimation(0, this.animationName, true);
            });
          Button($r('app.string.Resource_3'))
            .onClick(() => {
              this.rawfilePath = 'animation3/';
              this.sourcesData.json = 'cloud-pot.json';
              this.sourcesData.atlas = 'cloud-pot.atlas';
              this.animations = ['playing-in-the-rain', 'pot-moving-followed-by-rain', 'rain'];
              this.currentIndex = 0;
              this.loadAnimation();
              this.animationName = 'rain';
              this.animationState?.setAnimation(0, this.animationName, true);
            });

          Button($r('app.string.Resource_4'))
            .onClick(() => {
              this.rawfilePath = 'animation4/';
              this.sourcesData.json = 'owl-pro.json';
              this.sourcesData.atlas = 'owl-pma.atlas';
              this.animations = ['blink', 'down', 'idle', 'left', 'right', 'up'];
              this.currentIndex = 0;
              this.loadAnimation();
              this.animationName = 'up';
              this.animationState?.setAnimation(0, this.animationName, true);
            });

          Button($r('app.string.Resource_5'))
            .onClick(() => {
              this.rawfilePath = 'animation5/';
              this.sourcesData.json = 'dragon-ess.json';
              this.sourcesData.atlas = 'dragon-pma.atlas';
              this.animations = ['flying'];
              this.currentIndex = 0;
              this.loadAnimation();
              this.animationName = 'flying';
              this.animationState?.setAnimation(0, this.animationName, true);
            });

        }.margin({ top: 5 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  loadAnimation() {
    let skeletonRenderer = new SkeletonRenderer(this.canvasRenderingContext);

    skeletonRenderer.triangleRendering = true; // true是使用drawTriangle方式渲染 false是使用drawImages方式渲染

    // 加载动画资源
    let assetManager = new AssetManager(this.rawfilePath);
    assetManager.loadText(this.sourcesData.json);
    assetManager.loadTextureAtlas(this.sourcesData.atlas);

    // 创建纹理图集和骨骼数据
    let atlas: TextureAtlas = assetManager.require(this.sourcesData.atlas);
    let atlasLoader = new AtlasAttachmentLoader(atlas);
    let skeletonJson = new SkeletonJson(atlasLoader);
    let skeletonData = skeletonJson.readSkeletonData(assetManager.require(this.sourcesData.json));

    // 初始化骨骼实例
    let skeleton = new Skeleton(skeletonData);
    skeleton.setToSetupPose();
    skeleton.updateWorldTransform(Physics.update);
    let bounds = skeleton.getBoundsRect();

    // 配置动画状态 设置默认动画混合时间为 0.2 秒
    let animationStateData = new AnimationStateData(skeleton.data);
    animationStateData.defaultMix = 0.2;
    this.animationState = new AnimationState(animationStateData);


    // 初始化动画控制器
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

    // 创建并启动动画控制器
    this._animator = this.getUIContext().createAnimator(options);
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
  }

  render(context: CanvasRenderingContext2D, lastFrameTime: number, skeleton: Skeleton, animationState: AnimationState,
    skeletonRenderer: SkeletonRenderer, bounds: Bound): Delay {
    return renderSingleExampleFrame(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds);
  }

  onBackPress(): boolean | void {
    return false;
  }
}

interface SourcesData {
  json: string;
  atlas: string;
}

export function renderSingleExampleFrame(context: CanvasRenderingContext2D, lastFrameTime: number, skeleton: Skeleton,
  animationState: AnimationState, skeletonRenderer: SkeletonRenderer, bounds: Bound): Delay {
  let now = Date.now() / 1000;
  let delta = now - lastFrameTime;
  lastFrameTime = now;

  context.clearRect(0, 0, context.width, context.height);

  skeleton.x = context.width / 2;
  skeleton.y = context.height - context.height * 0.2;
  let scale = context.height / bounds.height * 0.5;
  skeleton.scaleX = scale;
  skeleton.scaleY = -scale;

  animationState.update(delta);
  animationState.apply(skeleton);
  skeleton.updateWorldTransform(Physics.update);
  skeletonRenderer.draw(skeleton);

  let result: Delay = { time: lastFrameTime, isFinish: true };
  return result;
}
