/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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