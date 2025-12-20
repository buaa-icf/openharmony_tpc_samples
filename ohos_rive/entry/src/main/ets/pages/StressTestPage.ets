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

import {
    Alignment,
    Artboard,
    File,
    Fit,
    LinearAnimationInstance,
    RectF,
    Renderer,
    RiveAnimationView
} from '@ohos/rive';
import { systemDateTime } from '@kit.BasicServicesKit';

@Entry
@ComponentV2
struct StressTestPage {
    public file: File | null = null
    public artboard: Artboard | null = null
    public animationInstance: LinearAnimationInstance | null = null
    public render: MyRenderer | null = null
    @Local textContent: string = `1 instances @ 60.0FPS(16.67ms)`
    @Local instanceCount: number = 1

    build() {
        Column() {

            RiveAnimationView({
                creatRendererFun: this.creatRenderer
            })
                .width('90%')
                .height('85%')
                .margin({ top: 30, bottom: 20 })

            Text(this.textContent)
                .width('90%')
        }
        .width('100%')
        .padding({ bottom: 5 })
    }

    @Event
    setTextContent: (content: string) => void = (content: string) => {
        this.textContent = content
    }

    @Event
    creatRenderer: () => Promise<Renderer | null> = async ():Promise<Renderer | null> => {
        const setUpFile = async () => {
            try {
                const riv: Uint8Array | undefined =
                  await this.getUIContext().getHostContext()?.resourceManager.getRawFileContent('marty.riv')
                if (riv) {
                    const arrayBuffer = riv.buffer.slice(
                        riv.byteOffset,
                        riv.byteOffset + riv.byteLength
                    );
                    this.file = new File(arrayBuffer);
                    this.artboard = this.file.firstArtboard
                    this.animationInstance = this.artboard.animationIndex(1)
                }
            } catch (err) {
                console.error(`StressTestPage: Error processing loaded file: ${err}`);
            }
        }

        try {
            await setUpFile()

            if (this.artboard && this.animationInstance) {
                this.render =
                    new MyRenderer(this.getUIContext(), this.artboard, this.animationInstance, this.setTextContent)
                console.info(`StressTestPage: creatRenderer render: ${this.render}`);
                return this.render
            }
        } catch (error) {
            console.error(`StressTestPage: creatRenderer error: ${JSON.stringify(Error)}`);
        }
        return null
    }


}

class MyRenderer extends Renderer {
    public artboard: Artboard;
    private _instanceCount: number = 1;
    private animationInstance: LinearAnimationInstance;
    private _totalElapsed: number = 0;

    public set totalElapsed(value: number) {
        this._totalElapsed = value;
    }

    public get totalElapsed(): number {
        return this._totalElapsed;
    }

    private _totalFrames: number = 0;

    public set totalFrames(value: number) {
        this._totalFrames = value;
    }

    public get totalFrames(): number {
        return this._totalFrames;
    }

    public setTextContentFun: (content: string) => void

    public set instanceCount(value: number) {
        this._instanceCount = value;
    }

    public get instanceCount(): number {
        return this._instanceCount;
    }

    constructor(context: UIContext, artboard: Artboard, animationInstance: LinearAnimationInstance,
        callBack: (content: string) => void) {
        super(context);
        this.artboard = artboard
        this.animationInstance = animationInstance
        this.setTextContentFun = callBack
    }

    draw(): void {
        if (!this.isAttached || !this.hasCppObject) {
            return
        }
        this.save()
        this.align(
            Fit.CONTAIN,
            Alignment.CENTER,
            new RectF(0, 0, this.width, this.height),
            this.artboard.bounds as RectF
        )
        const rows = (this._instanceCount + 6) / 7
        const cols = Math.min(this._instanceCount, 7)
        this.translate(0, (rows - 1) * -0.5 * 200)
        for (let j = 1; j <= rows; j++) {
            this.save()
            this.translate((cols - 1) * -0.5 * 125, 0)
            for (let i = 1; i <= cols; i++) {
                this.artboard.draw(this.cppPointer)
                this.translate(125, 0)
            }
            this.restore()
            this.translate(0, 200)
        }
        this.restore()
    }

    advance(elapsed: number): void {
        if (!this.isAttached || !this.hasCppObject) {
            return
        }
        // Actually advance the animation here. draw() will also call advance(), but the
        // purpose of that is to draw each Marty at a slightly different animation offset,
        // and it will loop back around to the original animation location.
        this.animationInstance.advanceAndGetResult(elapsed)
        this.animationInstance.apply()
        this.artboard.advance(elapsed)

        this._totalElapsed += elapsed
        this._totalFrames++

        if (this._totalElapsed > 1) {
            const fps = this._totalFrames / this._totalElapsed
            const fpsStr = fps.toFixed(1)
            const time = 1e3 / fps
            const timeStr = time.toFixed(2)
            const content = `${this._instanceCount} instances @ ${fpsStr} FPS (${timeStr} ms)`
            this.setTextContentFun(content)
            this._totalElapsed = 0
            this._totalFrames = 0
        }
    }
}