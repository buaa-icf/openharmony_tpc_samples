/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { curves } from '@kit.ArkUI';

/**
 * 弹簧动画配置接口
 */
export interface SpringConfig {
  /** 弹簧刚度 */
  stiffness: number;
  /** 阻尼比 */
  damping: number;
  /** 质量 */
  mass: number;
}

/**
 * animateTo选项接口
 */
export interface AnimateToOptions {
  duration: number;
  delay?: number;
  curve: curves.ICurve;
  iterations?: number;
  onFinish?: () => void;
}

/**
 * 动画配置枚举类型
 */
export enum AnimationType {
  /** 菜单打开动画 */
  MENU_OPEN = 'menu_open',
  /** 菜单关闭动画 */
  MENU_CLOSE = 'menu_close',
  /** 跟随滑动的实时动画 */
  DRAG_FOLLOW = 'drag_follow',
  /** 回弹动画 */
  SPRING_BACK = 'spring_back'
}

/**
 * 动画插值器类型
 */
export enum InterpolatorType {
  /** 线性插值 */
  LINEAR = 'linear',
  /** 加速 */
  ACCELERATE = 'accelerate',
  /** 减速 */
  DECELERATE = 'decelerate',
  /** 加速减速 */
  ACCELERATE_DECELERATE = 'accelerate_decelerate',
  /** 弹簧效果 */
  SPRING = 'spring',
  /** 回弹效果 */
  BOUNCE = 'bounce',
  /** 过冲效果 */
  OVERSHOOT = 'overshoot',
  /** 预期效果 */
  ANTICIPATE = 'anticipate'
}

/**
 * 动画配置类
 * 提供完整的动画参数配置
 */
@Observed
export class AnimationConfig {
  /** 动画持续时间（毫秒） */
  duration: number = 250;
  
  /** 动画延迟时间（毫秒） */
  delay: number = 0;
  
  /** 动画插值器类型 */
  interpolator: InterpolatorType = InterpolatorType.ACCELERATE_DECELERATE;
  
  /** 自定义动画曲线 */
  customCurve?: curves.ICurve;
  
  /** 是否启用动画 */
  enabled: boolean = true;
  
  /** 动画填充模式 */
  fillMode: number = 0; // 0: none, 1: forwards, 2: backwards, 3: both
  
  /** 动画迭代次数 */
  iterations: number = 1;
  
  /** 动画播放方向 */
  playMode: number = 0; // 0: normal, 1: reverse, 2: alternate
  
  /** 弹簧动画参数（SPRING插值器时） */
  springConfig?: SpringConfig;
  
  /** 过冲动画参数（OVERSHOOT插值器时） */
  overshootTension?: number;
  
  /** 预期动画参数（ANTICIPATE插值器时） */
  anticipateTension?: number;

  /**
   * 构造函数
   */
  constructor(config?: Partial<AnimationConfig>) {
    if (config) {
      this.duration = config.duration ?? this.duration;
      this.delay = config.delay ?? this.delay;
      this.interpolator = config.interpolator ?? this.interpolator;
      this.customCurve = config.customCurve ?? this.customCurve;
      this.enabled = config.enabled ?? this.enabled;
      this.fillMode = config.fillMode ?? this.fillMode;
      this.iterations = config.iterations ?? this.iterations;
      this.playMode = config.playMode ?? this.playMode;
      this.springConfig = config.springConfig ?? this.springConfig;
      this.overshootTension = config.overshootTension ?? this.overshootTension;
      this.anticipateTension = config.anticipateTension ?? this.anticipateTension;
    }
  }

  /**
   * 获取对应的HarmonyOS动画曲线
   */
  getCurve(): curves.ICurve {
    if (this.customCurve) {
      return this.customCurve;
    }
    
    switch (this.interpolator) {
      case InterpolatorType.LINEAR:
        return curves.cubicBezierCurve(0, 0, 1, 1);
      case InterpolatorType.ACCELERATE:
        return curves.cubicBezierCurve(0.4, 0, 1, 1);
      case InterpolatorType.DECELERATE:
        return curves.cubicBezierCurve(0, 0, 0.6, 1);
      case InterpolatorType.ACCELERATE_DECELERATE:
        return curves.cubicBezierCurve(0.4, 0, 0.6, 1);
      case InterpolatorType.SPRING:
        if (this.springConfig) {
          return curves.springMotion(this.springConfig.stiffness, this.springConfig.damping);
        }
        return curves.springCurve(0.8, 1.0, 0.8, 0.6);
      case InterpolatorType.BOUNCE:
        return curves.springCurve(0.3, 1.5, 0.08, 0.6);
      case InterpolatorType.OVERSHOOT:
        return curves.springCurve(0.4, 1.0, 0.12, this.overshootTension || 0.4);
      case InterpolatorType.ANTICIPATE:
        return curves.springCurve(1, 1, this.anticipateTension || 1.5, 1);
      default:
        return curves.cubicBezierCurve(0.4, 0, 0.6, 1);
    }
  }

  /**
   * 创建默认动画配置
   */
  static default(): AnimationConfig {
    return new AnimationConfig();
  }

  /**
   * 创建快速动画配置
   */
  static fast(): AnimationConfig {
    let config = new AnimationConfig();
    config.duration = 150;
    config.interpolator = InterpolatorType.DECELERATE;
    return config;
  }

  /**
   * 创建慢速动画配置
   */
  static slow(): AnimationConfig {
    let config = new AnimationConfig();
    config.duration = 400;
    config.interpolator = InterpolatorType.ACCELERATE_DECELERATE;
    return config;
  }

  /**
   * 创建弹簧动画配置
   */
  static spring(): AnimationConfig {
    let config = new AnimationConfig();
    config.duration = 300;
    config.interpolator = InterpolatorType.SPRING;
    let springConfig: SpringConfig = {
      stiffness: 1,
      damping: 0.8,
      mass: 1
    };
    config.springConfig = springConfig;
    return config;
  }

  /**
   * 创建回弹动画配置
   */
  static bounce(): AnimationConfig {
    let config = new AnimationConfig();
    config.duration = 350;
    config.interpolator = InterpolatorType.BOUNCE;
    return config;
  }

  /**
   * 创建过冲动画配置
   */
  static overshoot(): AnimationConfig {
    let config = new AnimationConfig();
    config.duration = 300;
    config.interpolator = InterpolatorType.OVERSHOOT;
    config.overshootTension = 1.5;
    return config;
  }

  /**
   * 创建预期动画配置
   */
  static anticipate(): AnimationConfig {
    let config = new AnimationConfig();
    config.duration = 300;
    config.interpolator = InterpolatorType.ANTICIPATE;
    config.anticipateTension = 2.0;
    return config;
  }

  /**
   * 创建无动画配置
   */
  static none(): AnimationConfig {
    let config = new AnimationConfig();
    config.enabled = false;
    config.duration = 0;
    return config;
  }

  /**
   * 复制配置并修改特定属性
   */
  copy(overrides: Partial<AnimationConfig>): AnimationConfig {
    let newConfig = new AnimationConfig();
    newConfig.duration = overrides.duration ?? this.duration;
    newConfig.delay = overrides.delay ?? this.delay;
    newConfig.interpolator = overrides.interpolator ?? this.interpolator;
    newConfig.customCurve = overrides.customCurve ?? this.customCurve;
    newConfig.enabled = overrides.enabled ?? this.enabled;
    newConfig.fillMode = overrides.fillMode ?? this.fillMode;
    newConfig.iterations = overrides.iterations ?? this.iterations;
    newConfig.playMode = overrides.playMode ?? this.playMode;
    newConfig.springConfig = overrides.springConfig ?? this.springConfig;
    newConfig.overshootTension = overrides.overshootTension ?? this.overshootTension;
    newConfig.anticipateTension = overrides.anticipateTension ?? this.anticipateTension;
    return newConfig;
  }

  /**
   * 设置插值器类型
   * @param interpolator 插值器类型
   */
  setInterpolator(interpolator: InterpolatorType): AnimationConfig {
    this.interpolator = interpolator;
    return this;
  }

  /**
   * 设置自定义动画曲线
   * @param curve 自定义曲线
   */
  setCustomCurve(curve: curves.ICurve): AnimationConfig {
    this.customCurve = curve;
    return this;
  }

  /**
   * 设置动画持续时间
   * @param duration 持续时间（毫秒）
   */
  setDuration(duration: number): AnimationConfig {
    this.duration = duration;
    return this;
  }

  /**
   * 设置弹簧参数（SPRING插值器）
   * @param stiffness 弹簧刚度
   * @param damping 阻尼比
   * @param mass 质量
   */
  setSpringParams(stiffness: number, damping: number, mass: number = 1): AnimationConfig {
    this.springConfig = { stiffness, damping, mass };
    return this;
  }

  /**
   * 设置过冲张力（OVERSHOOT插值器）
   * @param tension 张力值
   */
  setOvershootTension(tension: number): AnimationConfig {
    this.overshootTension = tension;
    return this;
  }

  /**
   * 设置预期张力（ANTICIPATE插值器）
   * @param tension 张力值
   */
  setAnticipateTension(tension: number): AnimationConfig {
    this.anticipateTension = tension;
    return this;
  }

  toAnimateToOptions(): AnimateToOptions {
    let options: AnimateToOptions = {
      duration: this.duration,
      curve: this.getCurve()
    };
    
    if (this.delay > 0) {
      options.delay = this.delay;
    }
    
    if (this.iterations !== 1) {
      options.iterations = this.iterations;
    }
    
    return options;
  }
}