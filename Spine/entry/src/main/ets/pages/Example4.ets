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
  Bound,
  AnimationStateListener,
  AnimationStateAdapter,
  TrackEntry,
  Event,
  SkeletonData
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
  private animations: Array<string> = ['walk'];
  private sourcesData: SourcesData = { json: 'spineboy-ess.json', atlas: 'spineboy.atlas' };
  private currentIndex: number = 0;
  private animationName: string = '';
  private listener1: MyAnimationStateListener | null = null;
  private skeletonData: SkeletonData | null = null;
  private assetManager: AssetManager | null = null;

  async load() {
    this.rawfilePath = 'animation/';
    this.sourcesData.json = 'spineboy-ess.json';
    this.sourcesData.atlas = 'spineboy.atlas';
    this.animations = ['walk'];
    this.currentIndex = 0;
    await this.loadAnimation();
    this.animationName = 'walk';
    this.animationState?.setAnimation(0, this.animationName, true);
  }

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
          Button('加载')
            .onClick(async () => {
              await this.load();
            });
          Button('停止动画')
            .onClick(() => {
              this._animator?.pause();
            });
          Button('播放动画')
            .onClick(() => {
              this._animator?.play();
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
          Button('添加监听')
            .onClick(() => {
              // 监听添加方式一
              this.animationState?.addListener({
                // 当此条目被设置为当前条目时调用。
                start(entry: TrackEntry) {
                  console.info('spine listener loadAnimation start entry:', entry)
                },

                // 当另一个条目将此条目替换为当前条目时调用。此条目可继续用于混合。
                interrupt(entry: TrackEntry) {
                  console.info('spine listener loadAnimation interrupt entry:', entry)
                },

                // 当此条目不再是当前条目并且永远不会再次应用时调用
                end(entry: TrackEntry) {
                  console.info('spine listener loadAnimation end entry:', entry)
                },

                // 当此条目即将被处理时触发。这有可能在条目从未被设为当前条目的情况下发生。 在调用处理函数后，不应再保留对该条目的引用，因为它可能会被销毁或重新分配。
                dispose(entry: TrackEntry) {
                  console.info('spine listener loadAnimation dispose entry:', entry)
                },

                // 每次此条目的动画完成循环时调用
                complete(entry: TrackEntry) {
                  console.info('spine listener loadAnimation complete entry:', entry)
                },

                // 当此条目的动画触发事件时调用
                event(entry: TrackEntry, event: Event) {
                  console.info('spine listener loadAnimation event entry:' + JSON.stringify(entry) + ',event:' +
                  JSON.stringify(event))
                }
              });
              // 监听添加方式二
              this.listener1 = new MyAnimationStateListener();
              this.animationState?.addListener(this.listener1);
              // 监听添加方式三
              this.animationState?.addListener(new MyAnimationStateListener1());
            });

          Button('移除监听')
            .onClick(() => {
              if (this.listener1) {
                this.animationState?.removeListener(this.listener1);
              }
            });

          Button('移除所有监听')
            .onClick(() => {
              this.animationState?.clearListeners();
            });
        }.margin({ top: 5 })

        Row() {
          Button('getCurrent')
            .onClick(() => {
              let obj = this.animationState?.getCurrent(0);
              console.info('spine demo getCurrent :' + JSON.stringify(obj));
            });

          Button('expandToIndex')
            .onClick(() => {
              let entry: TrackEntry | null | undefined = this.animationState?.expandToIndex(0);
              console.info('spine demo expandToIndex entry:' + JSON.stringify(entry));
            });

          Button('setAnimationWith')
            .onClick(() => {
              let animation = this.skeletonData?.findAnimation('aim');
              this.animationState?.setAnimationWith(1, animation, false);
            });
        }.margin({ top: 5 })

        Row() {
          Button('clearTrack')
            .onClick(() => {
              this.animationState?.clearTrack(0);
            });

          Button('setCurrent')
            .onClick(() => {
              const obj = this.animationState?.setAnimation(0, "death", true);
              this.animationState?.setCurrent(1, obj, false);
            });

          Button('addAnimation')
            .onClick(() => {
              this.animationState?.addAnimation(2, 'shoot');
            });
        }.margin({ top: 5 })

        Row() {
          Button('addAnimationWith')
            .onClick(() => {
              let animation = this.skeletonData?.findAnimation('run');
              this.animationState?.addAnimationWith(3, animation, true);
            });

          Button('clearTracks')
            .onClick(() => {
              this.animationState?.clearTracks();
            });

          Button('clearNext')
            .onClick(() => {
              const obj = this.animationState?.setAnimation(0, "death", true);
              this.animationState?.clearNext(obj);
            });
        }.margin({ top: 5 })

        Row() {
          Button('setEmptyAnimation')
            .onClick(() => {
              this.animationState?.setEmptyAnimation(0, 0.5)
            });

          Button('addEmptyAnimation')
            .onClick(() => {
              const obj = this.animationState?.setAnimation(1, "run", true);
              this.animationState?.clearNext(obj);
              this.animationState?.addEmptyAnimation(1, 0.3, 1.0);
            });
        }.margin({ top: 5 })

        Row() {
          Button('updateMixingFrom')
            .onClick(() => {
              const obj = this.animationState?.setAnimation(0, "death", true);
              this.animationState?.updateMixingFrom(obj, 1);
            });

          Button('remove')
            .onClick(() => {
              console.info('spine demo remove obj:' + JSON.stringify(this.assetManager?.get("spineboy.png")));
              this.assetManager?.remove("spineboy.png"); // 移除纹理（保留JSON和图集）
              console.info('spine demo remove after obj:' + JSON.stringify(this.assetManager?.get("spineboy.png")));
            });

          Button('removeAll')
            .onClick(() => {
              console.info('spine demo removeAll obj:' + JSON.stringify(this.assetManager?.get("spineboy-ess.json")));
              this.assetManager?.removeAll()
              console.info('spine demo removeAll after obj:' +
              JSON.stringify(this.assetManager?.get("spineboy-ess.json")));
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

    // 加载动画资源
    this.assetManager = new AssetManager(this.rawfilePath);
    this.assetManager.loadJson(this.sourcesData.json);
    this.assetManager.loadTexture('spineboy.png');
    this.assetManager.loadTextureAtlas(this.sourcesData.atlas);
    await this.assetManager.loadAll(); // 等待所有资源加载完成

    // 创建纹理图集和骨骼数据
    let atlas: TextureAtlas = this.assetManager.get(this.sourcesData.atlas);
    let atlasLoader = new AtlasAttachmentLoader(atlas);
    let skeletonJson = new SkeletonJson(atlasLoader);
    this.skeletonData = skeletonJson.readSkeletonData(this.assetManager.require(this.sourcesData.json));

    // 初始化骨骼实例
    let skeleton = new Skeleton(this.skeletonData);
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
    skeleton.y = context.height - context.height * 0.1; // 垂直位置：靠近 Canvas 底部（留 10% 边距）
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

interface SourcesData {
  json: string;
  atlas: string;
}

class MyAnimationStateListener extends AnimationStateAdapter {
  // 当此条目被设置为当前条目时调用。
  start(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener start entry:', entry)
  }

  // 当另一个条目将此条目替换为当前条目时调用。此条目可继续用于混合。
  interrupt(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener interrupt entry:', entry)
  }

  // 当此条目不再是当前条目并且永远不会再次应用时调用
  end(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener end entry:', entry)
  }

  // 当此条目即将被处理时触发。这有可能在条目从未被设为当前条目的情况下发生。 在调用处理函数后，不应再保留对该条目的引用，因为它可能会被销毁或重新分配。
  dispose(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener dispose entry:', entry)
  }

  // 每次此条目的动画完成循环时调用
  complete(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener complete entry:', entry)
  }

  // 当此条目的动画触发事件时调用
  event(entry: TrackEntry, event: Event) {
    console.info('spine MyAnimationStateListener event entry:', entry + ',event:' + event)
  }
}

class MyAnimationStateListener1 implements AnimationStateListener {
  // 当此条目被设置为当前条目时调用。
  start(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener1 start entry:', entry)
  }

  // 当另一个条目将此条目替换为当前条目时调用。此条目可继续用于混合。
  interrupt(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener1 interrupt entry:', entry)
  }

  // 当此条目不再是当前条目并且永远不会再次应用时调用
  end(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener1 end entry:', entry)
  }

  // 当此条目即将被处理时触发。这有可能在条目从未被设为当前条目的情况下发生。 在调用处理函数后，不应再保留对该条目的引用，因为它可能会被销毁或重新分配。
  dispose(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener1 dispose entry:', entry)
  }

  // 每次此条目的动画完成循环时调用
  complete(entry: TrackEntry) {
    console.info('spine MyAnimationStateListener1 complete entry:', entry)
  }

  // 当此条目的动画触发事件时调用
  event(entry: TrackEntry, event: Event) {
    console.info('spine MyAnimationStateListener1 event entry:', entry + ',event:' + event)
  }
}
