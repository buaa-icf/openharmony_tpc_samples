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
import { FrameCallback } from '@kit.ArkUI';
import { Renderer } from './Renderer';


export class RiveFramCallBack extends FrameCallback {
    public renderer: Renderer;

    constructor(renderer: Renderer) {
        super();
        this.renderer = renderer;
    }

    onFrame(framTimeNanos: number) {
        if (this.renderer.isPlaying) {
            if (this.renderer.hasCppObject) {
                this.renderer.cppDoFrame(this.renderer.cppPointer);
            }

            if (this.renderer.isPlaying) {
                this.renderer.scheduleFrame();
            }
        }
    }
}