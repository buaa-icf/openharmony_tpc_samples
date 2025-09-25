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
 * 动画插值器工具类
 * 提供各种自定义插值器实现
 */
export class AnimationInterpolator {
  
  /**
   * 创建自定义三次贝塞尔曲线插值器
   * @param x1 控制点1的x坐标
   * @param y1 控制点1的y坐标  
   * @param x2 控制点2的x坐标
   * @param y2 控制点2的y坐标
   */
  static cubicBezier(x1: number, y1: number, x2: number, y2: number): curves.ICurve {
    return curves.cubicBezierCurve(x1, y1, x2, y2);
  }

  /**
   * 加速插值器
   * 动画开始慢，然后加速
   */
  static accelerate(factor: number = 1.0): curves.ICurve {
    return AnimationInterpolator.cubicBezier(factor * 0.4, 0, 1, 1);
  }

  /**
   * 减速插值器
   * 动画开始快，然后减速
   */
  static decelerate(factor: number = 1.0): curves.ICurve {
    return AnimationInterpolator.cubicBezier(0, 0, (1 - factor) * 0.6, 1);
  }

  /**
   * 加速减速插值器
   * 动画开始和结束慢，中间快
   */
  static accelerateDecelerate(): curves.ICurve {
    return curves.cubicBezierCurve(0.4, 0, 0.6, 1);
  }

  /**
   * 过冲插值器
   * 动画会超过目标值然后回弹
   */
  static overshoot(tension: number = 2.0): curves.ICurve {
    return curves.springCurve(1, 1, 0.1, tension);
  }

  /**
   * 预期插值器  
   * 动画开始时会先向后一点，然后向前
   */
  static anticipate(tension: number = 2.0): curves.ICurve {
    return curves.springCurve(1, 1, tension, 1);
  }

  /**
   * 预期过冲插值器
   * 结合预期和过冲效果
   */
  static anticipateOvershoot(tension: number = 2.0): curves.ICurve {
    return curves.springCurve(1, 0.8, tension * 0.5, tension);
  }

  /**
   * 回弹插值器
   * 动画到达终点后会有回弹效果
   */
  static bounce(): curves.ICurve {
    return curves.springCurve(1, 0.55, 0.3, 1.7);
  }

  /**
   * 弹簧插值器
   * 模拟弹簧物理效果
   */
  static spring(stiffness: number = 1, damping: number = 0.8): curves.ICurve {
    return curves.springMotion(stiffness, damping);
  }

  /**
   * 循环插值器
   */
  static cycle(cycles: number): curves.ICurve {
    return curves.cubicBezierCurve(0, 0, 1, 1);
  }


  /**
   * 线性插值器
   * 匀速动画
   */
  static linear(): curves.ICurve {
    return curves.cubicBezierCurve(0, 0, 1, 1);
  }

  /**
   * 快进快出插值器
   */
  static fastOutSlowIn(): curves.ICurve {
    return AnimationInterpolator.cubicBezier(0.4, 0, 0.2, 1);
  }

  /**
   * 线性快出插值器
   */
  static linearOutSlowIn(): curves.ICurve {
    return AnimationInterpolator.cubicBezier(0, 0, 0.2, 1);
  }

  /**
   * 快进线性插值器
   */
  static fastOutLinearIn(): curves.ICurve {
    return AnimationInterpolator.cubicBezier(0.4, 0, 1, 1);
  }

  /**
   * 自定义缓动函数插值器
   */
  static custom(easingFunction: (t: number) => number): curves.ICurve {
    const midPoint = easingFunction(0.5);
    return AnimationInterpolator.cubicBezier(0.5, midPoint, 0.5, midPoint);
  }

  /**
   * 震荡插值器
   */
  static oscillation(frequency: number = 2): curves.ICurve {
    return curves.springCurve(1, 0.4, 0.2, frequency);
  }

  /**
   * 重力插值器
   */
  static gravity(acceleration: number = 1.0): curves.ICurve {
    return AnimationInterpolator.accelerate(acceleration * 2);
  }

  /**
   * 摩擦插值器
   */
  static friction(friction: number = 1.0): curves.ICurve {
    return AnimationInterpolator.decelerate(friction);
  }
}

/**
 * 动画预设配置
 */
export class AnimationPresets {
  static readonly ENTER_FAST = AnimationInterpolator.fastOutSlowIn();

  static readonly EXIT_FAST = AnimationInterpolator.linearOutSlowIn();

  static readonly ENTER_ELEGANT = AnimationInterpolator.decelerate(1.5);

  static readonly EXIT_ELEGANT = AnimationInterpolator.accelerate(1.5);

  static readonly ENTER_ELASTIC = AnimationInterpolator.overshoot(1.5);

  static readonly EXIT_ELASTIC = AnimationInterpolator.anticipate(1.5);

  static readonly NATURAL = curves.cubicBezierCurve(0.4, 0, 0.6, 1);

  static readonly EMPHASIS = AnimationInterpolator.spring(1.2, 0.7);

  static readonly SUBTLE = AnimationInterpolator.decelerate(0.8);

  static readonly DRAMATIC = AnimationInterpolator.anticipateOvershoot(2.5);
}