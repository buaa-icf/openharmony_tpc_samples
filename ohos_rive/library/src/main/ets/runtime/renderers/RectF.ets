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
import rive from 'libohos_rive.so';

export class RectF implements rive.Bounds {
    public left: number = 0;
    public top: number = 0;
    public right: number = 0;
    public bottom: number = 0;

    constructor(left: number = 0, top: number = 0, right: number = 0, bottom: number = 0) {
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
    }
}