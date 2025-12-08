/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Spine Harmony Runtime - ArkTS 示例页面
 * 展示如何在鸿蒙应用中使用 Spine 骨骼动画
 */

import { Spine} from '@ohos/spinec';
import { hilog } from '@kit.PerformanceAnalysisKit';
const XCOMPONENT_ID = 'spineXComponent';
const LOG_TAG = 'SpineDemo';

@Entry
@Component
struct Index {
  private xComponentContext: object | undefined = undefined;
  @State currentAnimation: string = '';
  @State animationList: string[] = [];
  @State isLoaded: boolean = false;
  @State isXComponentReady: boolean = false;
  @State message: string = '等待 XComponent 初始化...';

  // XComponent 控制器
  private xComponentController: XComponentController = new XComponentController();

  // 动画帧刷新定时器
  private renderTimer: number = -1;

  aboutToAppear(): void {
    hilog.info(0, LOG_TAG, 'aboutToAppear - initializing resource manager');
    // 初始化资源管理器
    const context = getContext(this);
    const result : boolean = Spine.initResourceManager(context.resourceManager);
    hilog.info(0, LOG_TAG, 'initResourceManager result: %{public}s', String(result));
  }

  aboutToDisappear(): void {
    hilog.info(0, LOG_TAG, 'aboutToDisappear - cleanup');
    // 1. 首先停止渲染循环
    if (this.renderTimer !== -1) {
      clearInterval(this.renderTimer);
      this.renderTimer = -1;
    }

    // 2. 移除 Spine 实例（如果已加载）
    if (this.isLoaded) {
      try {
        Spine.removeInstance(XCOMPONENT_ID, 'spineboy');
        hilog.info(0, LOG_TAG, 'Spine instance removed');
      } catch (error) {
        hilog.error(0, LOG_TAG, 'Error removing Spine instance: %{public}s', String(error));
      }
      this.isLoaded = false;
    }
  }

  // 加载 Spine 骨骼
  loadSpineSkeleton(): void {
    hilog.info(0, LOG_TAG, 'loadSpineSkeleton called');
    hilog.info(0, LOG_TAG, 'isXComponentReady: %{public}s', String(this.isXComponentReady));
    hilog.info(0, LOG_TAG, 'isLoaded: %{public}s', String(this.isLoaded));

    if (!this.isXComponentReady) {
      this.message = 'XComponent 尚未就绪，请稍候...';
      hilog.warn(0, LOG_TAG, 'XComponent not ready yet');
      return;
    }

    if (this.isLoaded) {
      this.message = '已加载';
      return;
    }

    this.message = '正在加载...';

    // 延迟一小段时间确保 EGL 上下文完全就绪
    setTimeout(() => {
      this.doLoadSkeleton();
    }, 100);
  }

  doLoadSkeleton(): void {
    try {
      hilog.info(0, LOG_TAG, 'Calling Spine.loadSkeleton...');
      hilog.info(0, LOG_TAG, 'XCOMPONENT_ID: %{public}s', XCOMPONENT_ID);

      // 加载骨骼文件
      // 注意：需要将 Spine 资源文件放在 rawfile/Spine/ 目录下
      const success : boolean = Spine.loadSkeleton(
        XCOMPONENT_ID,           // XComponent ID
        'spineboy',              // 实例名称
        'spine/spineboy.atlas',  // atlas 文件路径 (相对于 rawfile)
        'spine/spineboy.json',   // skeleton 文件路径 (相对于 rawfile)
        0.5                      // 缩放比例
      );

      hilog.info(0, LOG_TAG, 'loadSkeleton result: %{public}s', String(success));

      if (success) {
        this.isLoaded = true;
        this.message = '加载成功！';

        // 获取动画列表
        this.animationList = Spine.getAnimations(XCOMPONENT_ID, 'spineboy') as string[];
        hilog.info(0, LOG_TAG, 'Animations count: %{public}d', this.animationList.length);

        // 设置位置（屏幕中央偏下）
        Spine.setPosition(XCOMPONENT_ID, 'spineboy', 540, 200);

        // 设置默认动画
        if (this.animationList.length > 0) {
          this.playAnimation(this.animationList[0]);
        }

        // 启动渲染循环
        this.startRenderLoop();
      } else {
        this.message = '加载失败，请查看日志';
        hilog.error(0, LOG_TAG, 'loadSkeleton returned false');
      }
    } catch (error) {
      this.message = `加载错误: ${error}`;
      hilog.error(0, LOG_TAG, 'loadSkeleton exception: %{public}s', String(error));
    }
  }

  // 播放动画
  playAnimation(animName: string): void {
    if (!this.isLoaded) { return; }

    Spine.setAnimation(XCOMPONENT_ID, 'spineboy', 0, animName, true);
    this.currentAnimation = animName;
  }

  // 启动渲染循环
  startRenderLoop(): void {
    if (this.renderTimer !== -1) { return; }

    // 约 60fps
    this.renderTimer = setInterval(() => {
      Spine.renderFrame(XCOMPONENT_ID);
    }, 16);
  }
  build() {
    Column() {
      // 标题
      Text('Spine 鸿蒙示例')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      // 状态信息
      Text(this.message)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 10 })

      // XComponent Ready 状态
      Text(`XComponent: ${this.isXComponentReady ? '就绪' : '等待中'}`)
        .fontSize(12)
        .fontColor(this.isXComponentReady ? '#00AA00' : '#FF6600')
        .margin({ bottom: 5 })

      // XComponent 渲染区域
      XComponent({
        id: XCOMPONENT_ID,
        type: XComponentType.SURFACE,
        libraryname: 'Spine',  // 关键：指定 Native 库名，系统会自动调用对应库的回调
        controller: this.xComponentController
      })
        .width('100%')
        .height('60%')
        .backgroundColor('#333333')
        .onLoad((context) => {
          hilog.info(0, LOG_TAG, 'XComponent onLoad called');
          this.xComponentContext = context;
          // XComponent 加载完成后注册（libraryname 已配置，Native 回调会自动触发）
          const regResult : boolean = Spine.registerXComponent(XCOMPONENT_ID);
          hilog.info(0, LOG_TAG, 'registerXComponent result: %{public}s', String(regResult));
          // 延迟设置就绪状态，确保 Native 层完全初始化
          setTimeout(() => {
            this.isXComponentReady = true;
            this.message = '点击"加载骨骼"按钮';
            hilog.info(0, LOG_TAG, 'XComponent is ready');
          }, 500);
        })

      // 控制按钮
      Row() {
        Button('加载骨骼')
          .onClick(() => {
            this.loadSpineSkeleton();
          })
          .margin(5)

        Button('刷新')
          .onClick(() => {
            if (this.isLoaded) {
              Spine.renderFrame(XCOMPONENT_ID);
            }
          })
          .margin(5)
      }
      .margin({ top: 10 })

      // 当前动画
      if (this.currentAnimation) {
        Text(`当前动画: ${this.currentAnimation}`)
          .fontSize(14)
          .margin({ top: 10 })
      }

      // 动画列表
      if (this.animationList.length > 0) {
        Text('可用动画:')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 15, bottom: 5 })

        Scroll() {
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
            ForEach(this.animationList, (anim: string) => {
              Button(anim)
                .fontSize(12)
                .height(32)
                .backgroundColor(this.currentAnimation === anim ? '#007AFF' : '#E0E0E0')
                .fontColor(this.currentAnimation === anim ? '#FFFFFF' : '#333333')
                .margin(3)
                .onClick(() => {
                  this.playAnimation(anim);
                })
            })
          }
          .width('100%')
        }
        .height(100)
        .scrollBar(BarState.Auto)
      }
    }
    .width('100%')
    .height('100%')
    .padding(10)
  }
}