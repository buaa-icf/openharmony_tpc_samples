/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import {
  AssetManager,
  AtlasAttachmentLoader,
  AnimationState,
  AnimationStateData,
  SkeletonRenderer,
  SkeletonBinary,
  Skeleton,
  TextureAtlas,
  Physics,
  Delay,
  Bound
} from '@ohos/spine'

import { Animator as animator, AnimatorResult, AnimatorOptions } from '@kit.ArkUI';

@Entry
@Component
struct Example1 {
  // 渲染构建上下文
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings);
  private _animator: AnimatorResult | undefined;
  private animationState: AnimationState | undefined;

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
    let assetManager = new AssetManager("animation5/"); // 创建 AssetManager 实例，设置资源基础路径为 "animation/"
    assetManager.loadBinary("dragon-ess.skel");; // 加载 Spine 动画所需的 skel 数据文件
    assetManager.loadTextureAtlas("dragon-pma.atlas"); // 加载纹理图集文件 ("spineboy.atlas")
    await assetManager.loadAll(); // 等待所有资源加载完成

    // 3. 创建纹理图集和骨骼数据
    let atlas: TextureAtlas = assetManager.require("dragon-pma.atlas"); // 从资源管理器获取纹理图集
    let atlasLoader = new AtlasAttachmentLoader(atlas); // 创建 AtlasAttachmentLoader 用于加载附件
    let skeletonBinary = new SkeletonBinary(atlasLoader);; // 创建 SkeletonBinary 解析器
    let skeletonData = skeletonBinary.readSkeletonData(assetManager.require("dragon-ess.skel")); // 读取并解析骨骼动画数据文件，生成 skeletonData

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
    this._animator = animator.create(options);
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
    // Calculate the delta time between this and the last frame in seconds.
    let now = Date.now() / 1000; // 获取当前时间（秒）
    let delta = now - lastFrameTime; // 计算与上一帧的时间差（秒）
    lastFrameTime = now; // 更新上一帧时间为当前时间

    // and clear the canvas.
    context.clearRect(0, 0, context.width, context.height); // 清空画布

    // Center the skeleton and resize it so it fits inside the canvas.
    skeleton.x = context.width / 2; // 将骨骼水平居中（Canvas 宽度的一半）
    skeleton.y = context.height - context.height * 0.3; // 垂直位置：靠近 Canvas 底部（留 30% 边距）
    let scale = context.height / bounds.height * 0.5; // 计算缩放比例（基于 Canvas 高度和动画边界框高度）
    skeleton.scaleX = scale; // 水平缩放
    skeleton.scaleY = -scale; // 垂直缩放（负值表示 Y 轴翻转，使动画朝上）

    // Update and apply the animation state, update the skeleton's
    // world transforms and render the skeleton.
    animationState.update(delta); // 更新动画状态（根据时间差推进动画）
    animationState.apply(skeleton); // 将动画状态应用到骨骼（更新骨骼的骨骼变换）
    skeleton.updateWorldTransform(Physics.update); // 更新骨骼的全局变换
    skeletonRenderer.draw(skeleton); // 渲染骨骼到 Canvas

    let result: Delay = { time: lastFrameTime, isFinish: true };
    return result;
  }

  onBackPress(): boolean | void {
    return false;
  }
}
