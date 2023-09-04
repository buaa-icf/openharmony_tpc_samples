/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import animator from "@ohos.animator";

export class LVBase {
    padding = -1
    baseAnimator = null
    animing = false
    animStartValue= 0
    animEndValue= 1
    lastAnimValue= 0
    isRestart = false
    animDrawTime = 0
    animRepeatMode = false
    isBack = false

    constructor() {
    }

    getPadding() {
        return this.padding;
    }

    /**
     * 设置内间距，有的组件不生效
     */
    setPadding(padding) {
        this.padding = padding;
        return this;
    }

    /**
     * 设置动画的开始值和结束值
     */
    setAnimValue(start, end) {
        this.animStartValue = start
        this.animEndValue = end
    }

    /**
     * 设置动画执行模式
     * 为true时动画值会一次由start变为end，一次由end变为start
     * 为end时动画值每次都是由start变为end
     */
    setAnimRepeatMode(animRepeatMode) {
        this.animRepeatMode = animRepeatMode
    }

    /**
     * 设置动画第一次是由start变为end还是end变为start，只有当animRepeatMode为true时才有效
     * 为true时，动画第一次是由start变为end
     * 为end时，动画第一次是由end变为start
     */
    setIsBack(isBack) {
        this.isBack = isBack
    }

    /**
     * 获取当前动画是由start变为end还是end变为start，只有当animRepeatMode为true时才有效
     */
    getIsBack() {
        return this.isBack
    }

    /**
     * 获取动画是否是重复执行后的第一个值
     */
    getIsRestart() {
        return this.isRestart;
    }

    /**
     * 获取动画当前执行次数
     */
    getAnimDrawTime() {
        return this.animDrawTime;
    }

    /**
     * 获取动画是否在执行
     */
    getAnimIsRunning() {
        return this.animing
    }

    /**
     * 开启动画
     */
    startViewAnim(time, callback) {
        this.stopViewAnim(callback)
        this.baseAnimator = animator.create({
            duration: time as number,
            easing: 'linear',
            fill: 'forwards',
            iterations: -1,
            begin: this.animStartValue,
            end: this.animEndValue,
            direction:'normal',
            delay:0
        });
        var that = this
        this.baseAnimator.onframe = function (value) {
            if (that.animing) {
                if (value < that.lastAnimValue) {
                    that.isRestart = true
                    that.isBack = !that.isBack;
                    that.OnAnimationRepeat();
                } else {
                    that.isRestart = false
                }
                that.lastAnimValue = value
                that.animDrawTime++
                if (that.animRepeatMode) {
                    if (that.isBack) {
                        that.OnAnimationUpdate(that.animEndValue - value)
                    } else {
                        that.OnAnimationUpdate(value)
                    }
                } else {
                    that.OnAnimationUpdate(value)
                }
                callback()
            }
        };
        this.animing = true
        this.baseAnimator.play();
    }

    /**
     * 停止动画
     */
    stopViewAnim(callback) {
        if (this.baseAnimator != null && this.animing) {
            this.animing = false
            this.baseAnimator.pause()
            this.baseAnimator.finish()
            this.baseAnimator.cancel()
            this.baseAnimator = null
            this.animDrawTime = 0
            this.lastAnimValue = 0
            this.setIsBack(false)
            this.OnAnimationStop()
            callback()
        }
    }

    OnAnimationRepeat() {

    }

    OnAnimationUpdate(value) {

    }

    OnAnimationStop() {

    }
}