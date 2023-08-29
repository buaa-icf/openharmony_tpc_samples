/**
 * Copyright (c) 2021 ZhangXiaoqiu
 * LoadingViewJs is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 *          http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */
import {LVBase} from '../base/LVBase'

export class LVCircularRingController extends LVBase {
    animValue = 0;
    viewColor = '#A0FFFFFF';
    barColor = '#FFFFFF';

    getAnimValue() {
        return this.animValue;
    }

    getViewColor() {
        return this.viewColor;
    }

    setViewColor(viewColor) {
        this.viewColor = viewColor;
        return this;
    }

    getBarColor() {
        return this.barColor;
    }

    setBarColor(barColor) {
        this.barColor = barColor;
        return this;
    }

    OnAnimationUpdate(value) {
        this.animValue = 360 * value;
    }
}