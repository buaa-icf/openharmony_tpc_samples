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

export function renderExample1Frame(context: CanvasRenderingContext2D, lastFrameTime: number, skeleton: Skeleton,
  animationState: AnimationState, skeletonRenderer: SkeletonRenderer, bounds: Bound): Delay {
  let now = Date.now() / 1000;
  let delta = now - lastFrameTime;
  lastFrameTime = now;

  context.clearRect(0, 0, context.width, context.height);

  skeleton.x = context.width / 2;
  skeleton.y = context.height - context.height * 0.1;
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

@Entry
@Component
struct Example1 {
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
            .onReady(() => {
              this.loadAnimation();
            }).onClick(() => {
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
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  async loadAnimation() {
    // 1. 初始化 SkeletonRenderer
    let skeletonRenderer = new SkeletonRenderer(this.canvasRenderingContext); // 创建一个 SkeletonRenderer 实例，用于在画布上渲染骨骼动画 传入当前类的 canvasRenderingContext 作为渲染上下文
    skeletonRenderer.triangleRendering = true; // true是使用drawTriangle方式渲染 false是使用drawImages方式渲染

    // 2. 创建资源管理器并加载资源
    let assetManager = new AssetManager("animation/"); // 创建 AssetManager 实例，设置资源基础路径为 "animation/"
    assetManager.loadText("spineboy-ess.json"); // 加载 Spine 动画所需的 JSON 数据文件 ("spineboy-ess.json")
    assetManager.loadTextureAtlas("spineboy.atlas"); // 加载纹理图集文件 ("spineboy.atlas")
    await assetManager.loadAll(); // 等待所有资源加载完成

    // 3. 创建纹理图集和骨骼数据
    let atlas: TextureAtlas = assetManager.require("spineboy.atlas"); // 从资源管理器获取纹理图集
    let atlasLoader = new AtlasAttachmentLoader(atlas); // 创建 AtlasAttachmentLoader 用于加载附件
    let skeletonJson = new SkeletonJson(atlasLoader); // 创建 SkeletonJson 解析器
    let skeletonData = skeletonJson.readSkeletonData(assetManager.require("spineboy-ess.json")); // 读取并解析骨骼动画数据文件，生成 skeletonData

    // 4. 创建骨骼实例
    let skeleton = new Skeleton(skeletonData); // 基于骨骼数据创建新的骨骼实例
    skeleton.setToSetupPose(); // 将骨骼设置为初始姿势
    skeleton.updateWorldTransform(Physics.update); // 更新骨骼的世界变换
    let bounds = skeleton.getBoundsRect(); // 获取骨骼的边界矩形

    // 5. 设置动画状态
    let animationStateData = new AnimationStateData(skeleton.data); // 创建动画状态数据，传入骨骼数据
    animationStateData.defaultMix = 0.2; // 设置默认动画混合时间为 0.2 秒
    this.animationState = new AnimationState(animationStateData); // 创建动画状态实例并存储在类的 animationState 属性中

    let lastFrameTime = Date.now() / 1000; // 初始化动画计时器

    // 清理现有动画器
    if (this._animator) {
      this._animator.finish();
    }

    // 设置动画选项
    let options: AnimatorOptions = {
      duration: 20000,       // 动画持续时间 20 秒
      easing: 'linear',      // 线性缓动
      delay: 0,              // 无延迟
      fill: 'forwards',      // 动画完成后保持最后一帧状态
      direction: 'normal',   // 正常方向播放
      iterations: -1,        // 无限循环
      begin: 0,              // 从第 0 帧开始
      end: 1                 // 到第 1 帧结束
    };

    // 设置预期帧率  定义动画的预期帧率范围：最小 0，最大 120，期望 60
    let expectedFrameRate: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 60
    }

    // 创建动画器
    this._animator = this.getUIContext().createAnimator(options);
    this._animator.setExpectedFrameRateRange(expectedFrameRate);

    // 初始化渲染结果对象 创建延迟对象，包含初始时间和完成状态标志
    let result: Delay = { time: lastFrameTime, isFinish: true };

    // 设置动画器的每帧回调
    this._animator.onFrame = (value: number) => {
      if (result.isFinish) {
        result.isFinish = false;
        result = this.render(this.canvasRenderingContext, result.time, skeleton, this.animationState!, skeletonRenderer,
          bounds);
      }
    }
    // 播放动画
    this._animator.play();
  }

  render(context: CanvasRenderingContext2D, lastFrameTime: number, skeleton: Skeleton, animationState: AnimationState,
    skeletonRenderer: SkeletonRenderer, bounds: Bound): Delay {
    return renderExample1Frame(context, lastFrameTime, skeleton, animationState, skeletonRenderer, bounds);
  }

  onBackPress(): boolean | void {
    return false;
  }
}
