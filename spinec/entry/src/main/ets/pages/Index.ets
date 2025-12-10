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

import { Spine } from '@ohos/spinec';
import { hilog } from '@kit.PerformanceAnalysisKit';
const XCOMPONENT_ID = 'spineXComponent';
const LOG_TAG = 'SpineDemo';

@Entry
@Component
struct Index {
  @State currentAnimation: string = '';
  @State animationList: string[] = [];
  @State isLoaded: boolean = false;
  @State isXComponentReady: boolean = false;
  @State message: string = '等待 XComponent 初始化...';

  // 加载中状态
  @State isLoading: boolean = false;

  // XComponent 控制器
  private xComponentController: XComponentController = new XComponentController();

  // 动画帧刷新定时器
  private renderTimer: number = -1;

  // 记录已加载的实例（防止重复）
  private loadedInstanceName: string | null = null;

  // 组件销毁标志，用于防止内存泄漏
  private isDestroyed: boolean = false;

  // 活动定时器数组，用于管理所有异步定时器
  private activeTimers: number[] = [];

  // 播放控制相关状态（内部使用，不在UI显示）
  private playCount: number = 0; // 当前播放次数
  private maxPlayCount: number = 20; // 最大播放次数
  private isPlaying: boolean = false; // 是否正在播放
  private checkInterval: number = -1; // 检查播放次数的定时器

  // 空闲检测相关
  private lastActivityTime: number = Date.now(); // 最后一次活动时间
  private idleCheckInterval: number = -1; // 空闲检查定时器
  private IDLE_TIMEOUT: number = 20000; // 20秒空闲超时

  // 用于清理XComponent显示的定时器
  private cleanupDisplayTimer: number = -1;

  aboutToAppear(): void {
    // 重置销毁标志
    this.isDestroyed = false;
    // 初始化资源管理器
    const context = getContext(this);
    const result: boolean = Spine.initResourceManager(context.resourceManager);

    // 启动空闲检测
    this.startIdleDetection();
  }

  aboutToDisappear(): void {
    // 设置销毁标志，阻止后续异步操作
    this.isDestroyed = true;

    // 停止空闲检测
    this.stopIdleDetection();

    // 停止渲染循环
    this.stopRenderLoop();

    // 停止检查定时器
    this.stopCheckTimer();

    // 停止清理显示定时器
    this.stopCleanupDisplayTimer();

    // 清理所有活动定时器
    this.cleanupAllTimers();

    // 移除 Spine 实例（如果已加载）
    if (this.loadedInstanceName) {
      try {
        Spine.removeInstance(XCOMPONENT_ID, this.loadedInstanceName);
      } catch (error) {
        hilog.error(0, LOG_TAG, 'Error removing Spine instance: %{public}s', String(error));
      }
      this.loadedInstanceName = null;
    }

    // 清理XComponent显示
    this.clearXComponentDisplay();

    // 重置所有状态变量
    this.resetAllStates();

    hilog.info(0, LOG_TAG, '页面销毁，资源已清理');
  }

  // 更新活动时间（用户有操作时调用）
  private updateActivityTime(): void {
    this.lastActivityTime = Date.now();
  }

  // 启动空闲检测
  private startIdleDetection(): void {
    if (this.idleCheckInterval !== -1) {
      return;
    }

    // 每秒检查一次空闲状态
    this.idleCheckInterval = setInterval(() => {
      if (this.isDestroyed) {
        this.stopIdleDetection();
        return;
      }

      // 只有在动画播放完成且没有加载时才检查空闲
      if (this.isPlaying || this.isLoading || !this.isLoaded) {
        this.updateActivityTime(); // 有活动时更新时间
        return;
      }

      const currentTime = Date.now();
      const idleTime = currentTime - this.lastActivityTime;

      // 空闲超过20秒，自动释放资源
      if (idleTime >= this.IDLE_TIMEOUT) {
        hilog.info(0, LOG_TAG, '检测到空闲超时，自动释放资源');
        this.autoReleaseResources();
      }
    }, 1000);

    // 添加到活动定时器数组
    this.activeTimers.push(this.idleCheckInterval);
  }

  // 停止空闲检测
  private stopIdleDetection(): void {
    if (this.idleCheckInterval !== -1) {
      clearInterval(this.idleCheckInterval);
      this.idleCheckInterval = -1;
    }
  }

  // 清理XComponent显示（通过渲染几帧黑色背景来清除残留画面）
  private clearXComponentDisplay(): void {
    // 停止清理定时器（如果有）
    this.stopCleanupDisplayTimer();

    // 使用setInterval渲染几帧黑色背景来清除残留画面
    let frameCount = 0;
    const maxFrames = 3; // 渲染3帧确保清除

    this.cleanupDisplayTimer = setInterval(() => {
      if (this.isDestroyed || frameCount >= maxFrames) {
        this.stopCleanupDisplayTimer();
        return;
      }
      try {
        // 尝试渲染空帧（如果Spine库支持）
        Spine.renderFrame(XCOMPONENT_ID);

        frameCount++;
        hilog.debug(0, LOG_TAG, '清理XComponent显示，帧数: %{public}d', frameCount);
      } catch (error) {
        hilog.error(0, LOG_TAG, '清理XComponent显示失败: %{public}s', String(error));
        this.stopCleanupDisplayTimer();
      }
    }, 50); // 20fps的速度清理

    if (this.cleanupDisplayTimer !== -1) {
      this.activeTimers.push(this.cleanupDisplayTimer);
    }
  }

  // 停止清理显示定时器
  private stopCleanupDisplayTimer(): void {
    if (this.cleanupDisplayTimer !== -1) {
      clearInterval(this.cleanupDisplayTimer);
      this.cleanupDisplayTimer = -1;
    }
  }
  // 完全重置XComponent（最彻底的清理方法）
  private resetXComponent(): void {
    hilog.info(0, LOG_TAG, '开始重置XComponent...');

    // 先清理Spine实例
    if (this.loadedInstanceName) {
      try {
        Spine.removeInstance(XCOMPONENT_ID, this.loadedInstanceName);
        hilog.info(0, LOG_TAG, '已移除Spine实例');
      } catch (error) {
        hilog.error(0, LOG_TAG, '移除Spine实例失败: %{public}s', String(error));
      }
    }
    // 重置XComponent的控制器来触发重绘
    try {
      // 延迟重置就绪状态
      this.setTimeoutSafe(() => {
        if (this.isDestroyed) { return; }

        this.isXComponentReady = false;
        this.message = 'XComponent重置中...';

        // 延迟设置就绪状态
        this.setTimeoutSafe(() => {
          if (this.isDestroyed) { return; }

          // 重新注册XComponent
          const regResult: boolean = Spine.registerXComponent(XCOMPONENT_ID);
          hilog.info(0, LOG_TAG, '重新注册XComponent结果: %{public}s', regResult ? '成功' : '失败');

          if (regResult) {
            this.isXComponentReady = true;
            this.message = '点击"加载骨骼"按钮';
          } else {
            this.message = 'XComponent重新注册失败';
          }
        }, 300);
      }, 100);

    } catch (error) {
      hilog.error(0, LOG_TAG, '重置XComponent失败: %{public}s', String(error));
    }
  }

  // 自动释放资源
  private autoReleaseResources(): void {
    hilog.info(0, LOG_TAG, '开始自动释放资源...');

    // 停止所有动画和定时器
    this.stopRenderLoop();
    this.stopCheckTimer();
    this.isPlaying = false;

    // 清理XComponent上的残留显示
    this.clearXComponentDisplay();

    // 移除Spine实例
    if (this.loadedInstanceName) {
      try {
        Spine.removeInstance(XCOMPONENT_ID, this.loadedInstanceName);
        hilog.info(0, LOG_TAG, '已释放Spine实例: %{public}s', this.loadedInstanceName);
      } catch (error) {
        hilog.error(0, LOG_TAG, '释放Spine实例失败: %{public}s', String(error));
      }
      this.loadedInstanceName = null;
    }

    // 重置UI状态到初始状态
    this.resetToInitialState();

    // 完全重置XComponent
    this.resetXComponent();

    hilog.info(0, LOG_TAG, '自动释放资源完成');
  }

  // 重置到初始状态
  private resetToInitialState(): void {
    // 重置所有动画相关状态
    this.isLoaded = false;
    this.isLoading = false;
    this.animationList = [];
    this.currentAnimation = '';
    this.playCount = 0;

    // 显示初始提示信息
    this.message = this.isXComponentReady ? '点击"加载骨骼"按钮' : '等待 XComponent 初始化...';

    // 重置活动时间（防止立即再次触发空闲检测）
    this.updateActivityTime();

    hilog.info(0, LOG_TAG, '已重置到初始状态');
  }

  // 安全的定时器设置函数
  private setTimeoutSafe(callback: () => void, delay: number): number {
    const timerId = setTimeout(() => {
      // 检查组件是否已销毁
      if (this.isDestroyed) {
        return;
      }
      try {
        callback();
      } catch (error) {
        hilog.error(0, LOG_TAG, 'Timer callback error: %{public}s', String(error));
      }
      // 从活动定时器数组中移除
      this.removeTimerFromActiveList(timerId);
    }, delay);
    // 添加到活动定时器数组
    this.activeTimers.push(timerId);
    return timerId;
  }

  // 清理所有活动定时器
  private cleanupAllTimers(): void {
    this.activeTimers.forEach(timerId => {
      try {
        clearTimeout(timerId);
        clearInterval(timerId);
      } catch (error) {
        hilog.error(0, LOG_TAG, 'Error clearing timer %{public}d: %{public}s', timerId, String(error));
      }
    });
    this.activeTimers = [];
  }

  // 从活动定时器数组中移除定时器
  private removeTimerFromActiveList(timerId: number): void {
    const index = this.activeTimers.indexOf(timerId);
    if (index > -1) {
      this.activeTimers.splice(index, 1);
    }
  }

  // 重置所有状态变量
  private resetAllStates(): void {
    this.isLoaded = false;
    this.isLoading = false;
    this.isXComponentReady = false;
    this.message = '等待 XComponent 初始化...';
    this.animationList = [];
    this.currentAnimation = '';
    this.playCount = 0;
    this.isPlaying = false;
    this.lastActivityTime = Date.now();
  }

  // 停止检查定时器
  private stopCheckTimer(): void {
    if (this.checkInterval !== -1) {
      clearInterval(this.checkInterval);
      this.checkInterval = -1;
    }
  }

  loadSpineSkeleton(): void {
    // 更新活动时间
    this.updateActivityTime();

    // 组件是否已销毁
    if (this.isDestroyed) {
      return;
    }
    // XComponent 是否就绪
    if (!this.isXComponentReady) {
      this.message = 'XComponent 尚未就绪，请稍候...';
      return;
    }
    // 是否正在加载中（防止重复点击）
    if (this.isLoading) {
      this.message = '正在加载中，请稍候...';
      return;
    }

    // 如果已经加载，则执行重新加载流程
    if (this.isLoaded && this.loadedInstanceName) {
      this.message = '重新加载中...';
      this.isLoading = true;

      // 使用安全的定时器
      this.setTimeoutSafe(() => {
        this.cleanupBeforeReload();
        // 清理完成后重新加载
        this.setTimeoutSafe(() => {
          this.doLoadSkeleton();
        }, 100);
      }, 100);

      return;
    }
    // 正常加载流程
    this.message = '正在加载...';
    this.isLoading = true;
    // 使用安全的定时器
    this.setTimeoutSafe(() => {
      this.doLoadSkeleton();
    }, 100);
  }

  doLoadSkeleton(): void {
    // 再次检查组件是否已销毁
    if (this.isDestroyed) {
      return;
    }
    try {
      const instanceName = 'spineboy';
      this.loadedInstanceName = instanceName;
      // 加载骨骼文件
      const success: boolean = Spine.loadSkeleton(
        XCOMPONENT_ID,
        instanceName,
        'spine/spineboy.atlas',
        'spine/spineboy.json',
        1
      );
      if (success) {
        this.isLoaded = true;
        this.isLoading = false;  // 释放加载锁
        this.message = '加载成功！';
        // 获取动画列表
        this.animationList = Spine.getAnimations(XCOMPONENT_ID, instanceName) as string[];
        // 设置位置
        Spine.setPosition(XCOMPONENT_ID, instanceName, 540, 200);
        // 设置缩放
        Spine.setScale(XCOMPONENT_ID, instanceName, 0.5, 0.5);
        // 设置默认动画
        if (this.animationList.length > 0) {
          const defaultAnim = this.animationList[0];
          this.playAnimation(defaultAnim);
        }
      } else {
        this.message = '加载失败，请查看日志';
        this.isLoading = false;  // 失败也要释放锁
        this.loadedInstanceName = null;
      }
    } catch (error) {
      this.message = `加载错误: ${error}`;
      this.isLoading = false;  // 异常也要释放锁
      this.loadedInstanceName = null;
      // 尝试清理可能已创建的部分资源
      this.safeCleanupSpineResources();
    }
  }

  // 安全的 Spine 资源清理
  private safeCleanupSpineResources(): void {
    if (!this.loadedInstanceName) {
      return;
    }
    try {
      Spine.removeInstance(XCOMPONENT_ID, this.loadedInstanceName);
    } catch (cleanupError) {
      hilog.debug(0, LOG_TAG, 'Cleanup error (expected): %{public}s', String(cleanupError));
    }
  }

  // 清理重新加载
  cleanupBeforeReload(): void {
    if (!this.loadedInstanceName) {
      return;
    }
    try {
      // 停止渲染循环
      this.stopRenderLoop();
      // 停止检查定时器
      this.stopCheckTimer();
      // 停止清理显示定时器
      this.stopCleanupDisplayTimer();
      // 移除已有实例
      Spine.removeInstance(XCOMPONENT_ID, this.loadedInstanceName);
      // 清理XComponent显示
      this.clearXComponentDisplay();
      // 重置状态
      this.isLoaded = false;
      this.animationList = [];
      this.currentAnimation = '';
      this.loadedInstanceName = null;
      this.playCount = 0;
      this.isPlaying = false;
    } catch (error) {
      hilog.error(0, LOG_TAG, 'Error in cleanupBeforeReload: %{public}s', String(error));
    }
  }

  // 播放动画
  playAnimation(animName: string): void {
    // 更新活动时间
    this.updateActivityTime();

    if (!this.isLoaded || this.isDestroyed) {
      return;
    }
    if (!this.loadedInstanceName) {
      return;
    }
    try {
      // 设置动画为循环播放
      Spine.setAnimation(XCOMPONENT_ID, this.loadedInstanceName, 0, animName, true);
      this.currentAnimation = animName;

      // 重置播放计数器
      this.playCount = 0;
      this.isPlaying = true;

      // 启动渲染循环
      this.startRenderLoop();

      // 启动检查定时器，每秒检查一次
      this.startCheckTimer();

    } catch (error) {
      hilog.error(0, LOG_TAG, 'Failed to set animation: %{public}s', String(error));
    }
  }

  // 启动检查定时器
  private startCheckTimer(): void {
    // 先停止之前的检查定时器
    this.stopCheckTimer();

    this.checkInterval = setInterval(() => {
      if (this.isDestroyed || !this.isPlaying) {
        this.stopCheckTimer();
        return;
      }

      // 增加播放计数
      this.playCount++;

      // 在日志中记录（不在UI显示）
      hilog.debug(0, LOG_TAG, '动画播放计数: %{public}d/%{public}d', this.playCount, this.maxPlayCount);

      // 如果达到最大播放次数，停止
      if (this.playCount >= this.maxPlayCount) {
        this.stopRenderLoop();
        this.stopCheckTimer();
        this.isPlaying = false;
        hilog.info(0, LOG_TAG, '动画完成指定次数播放，已停止渲染');

        // 更新活动时间（动画停止时也算用户活动）
        this.updateActivityTime();
      }
    }, 1000); // 每秒检查一次
  }

  // 启动渲染循环
  startRenderLoop(): void {
    if (this.renderTimer !== -1) {
      return;
    }
    if (this.isDestroyed) {
      return;
    }

    // 约 60fps
    this.renderTimer = setInterval(() => {
      if (this.isDestroyed) {
        this.stopRenderLoop();
        return;
      }
      if (!this.isLoaded || !this.isPlaying) {
        return;
      }
      try {
        Spine.renderFrame(XCOMPONENT_ID);
      } catch (error) {
        hilog.error(0, LOG_TAG, 'Render frame error: %{public}s', String(error));
        this.stopRenderLoop();
        this.stopCheckTimer();
      }
    }, 16);

    // 添加到活动定时器数组
    this.activeTimers.push(this.renderTimer);
  }

  // 停止渲染循环
  stopRenderLoop(): void {
    if (this.renderTimer !== -1) {
      clearInterval(this.renderTimer);
      this.renderTimer = -1;
    }
  }

  // 渲染帧（手动）
  renderFrame(): void {
    // 更新活动时间
    this.updateActivityTime();

    if (!this.isLoaded || this.isDestroyed) {
      return;
    }
    try {
      Spine.renderFrame(XCOMPONENT_ID);
    } catch (error) {
      hilog.error(0, LOG_TAG, 'Render frame failed: %{public}s', String(error));
    }
  }

  build() {
    Column() {
      // 标题
      Text('Spine 示例')
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
        .fontColor(this.isXComponentReady ? '#00AB00' : '#FF6600')
        .margin({ bottom: 5 })
      // XComponent 渲染区域
      XComponent({
        id: XCOMPONENT_ID,
        type: XComponentType.SURFACE,
        libraryname: 'Spine',
        controller: this.xComponentController
      })
        .width('100%')
        .height('60%')
        .backgroundColor('#333333')
        .onLoad((context) => {
          const regResult: boolean = Spine.registerXComponent(XCOMPONENT_ID);
          // 延迟设置就绪状态，确保 Native 层完全初始化
          // 使用安全的定时器
          const readyTimer = setTimeout(() => {
            // 检查组件是否已销毁
            if (this.isDestroyed) {
              return;
            }
            this.isXComponentReady = true;
            this.message = '点击"加载骨骼"按钮';
            // 从活动定时器数组中移除
            this.removeTimerFromActiveList(readyTimer);
          }, 500);
          // 添加到活动定时器数组
          this.activeTimers.push(readyTimer);
        })
        .onDestroy(() => {
          hilog.info(0, LOG_TAG, 'XComponent销毁');
        })
      // 当前动画
      if (this.currentAnimation) {
        Text(`当前动画: ${this.currentAnimation}`)
          .fontSize(14)
          .margin({ top: 10 })
      }
      // 控制按钮
      Row() {
        Button(this.isLoading ? '加载中...' : (this.isLoaded ? '重新加载' : '加载骨骼'))
          .enabled(!this.isLoading)  // 加载时禁用按钮
          .onClick(() => {
            this.loadSpineSkeleton();
          })
          .margin(5)
        Button('刷新')
          .onClick(() => {
            this.renderFrame();
          })
          .margin(5)
      }
      .margin({ top: 10 })

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

      // 空闲状态提示
      if (this.isLoaded && !this.isPlaying && !this.isLoading) {
        Text('动画已停止，20秒无操作将自动释放资源')
          .fontSize(12)
          .fontColor('#FFA500')
          .margin({ top: 10 })
      }
    }
    .width('100%')
    .height('100%')
    .padding(10)
  }
}