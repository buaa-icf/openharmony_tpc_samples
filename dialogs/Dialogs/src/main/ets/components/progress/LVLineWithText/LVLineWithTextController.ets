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
export class LVLineWithTextController {
    padding = -1;
    lineWidth = -1;
    textSize = -1;
    viewColor = '#FFFFFF';
    textColor = '#FFFFFF';
    animValue = 0;

    constructor() {
    }

    getPadding() {
        return this.padding;
    }

    setPadding(padding) {
        this.padding = padding;
        return this;
    }

    getLineWidth() {
        return this.lineWidth;
    }

    setLineWidth(lineWidth) {
        this.lineWidth = lineWidth;
        return this;
    }

    getTextSize() {
        return this.textSize;
    }

    setTextSize(textSize) {
        this.textSize = textSize;
        return this;
    }

    getViewColor() {
        return this.viewColor;
    }

    setViewColor(viewColor) {
        this.viewColor = viewColor;
        return this;
    }

    getTextColor() {
        return this.textColor;
    }

    setTextColor(textColor) {
        this.textColor = textColor;
        return this;
    }
}