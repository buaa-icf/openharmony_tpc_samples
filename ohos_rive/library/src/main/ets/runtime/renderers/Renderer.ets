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
import { NativeObject } from '../core/NativeObject';
import { RendererType } from './RendererType';
import rive from 'libohos_rive.so';
import { Fit } from '../core/Fit';
import { Alignment } from '../core/Alignment';
import { RectF } from './RectF';
import { SharedSurface } from './SharedSurface';
import { RefCount } from '../core/RefCount';
import { RiveFramCallBack } from './RiveFramCallBack';
import { JSON } from '@kit.ArkTS';

const TAG = 'Renderer'

export abstract class Renderer extends NativeObject {
    public uiContext: UIContext
    public type: RendererType
    public trace: boolean
    public isPlaying: boolean = false
    public isAttached: boolean = false
    private sharedSurface: SharedSurface | null = null
    public framCallBack: RiveFramCallBack | null = null

    constructor(uiContext: UIContext, type: RendererType = RendererType.Rive, trace: boolean = false) {
        console.debug(`${TAG}, constructor type = ${JSON.stringify(type)}, trace = ${JSON.stringify(trace)}`)
        super(NativeObject.NULL_POINTER);
        this.uiContext = uiContext
        this.type = type
        this.trace = trace
    }

    private cppStart(rendererPointer: BigInt) {
        console.debug(`${TAG}, cppStart rendererPointer = ${rendererPointer}`)
        rive.Napi_Renderer_cppStart(rendererPointer)
        console.debug(`${TAG}, cppStart end`)
    }

    private cppStop(rendererPointer: BigInt) {
        console.debug(`${TAG}, cppStop rendererPointer = ${rendererPointer}`)
        rive.Napi_Renderer_cppStop(rendererPointer)
        console.debug(`${TAG}, cppStop end`)
    }

    private cppSave(rendererPointer: BigInt) {
        console.debug(`${TAG}, cppSave rendererPointer = ${rendererPointer}`)
        rive.Napi_Renderer_cppSave(rendererPointer)
        console.debug(`${TAG}, cppSave end`)
    }

    private cppRestore(rendererPointer: BigInt) {
        console.debug(`${TAG}, cppRestore rendererPointer = ${rendererPointer}`)
        rive.Napi_Renderer_cppRestore(rendererPointer)
        console.debug(`${TAG}, cppRestore end`)
    }

    private cppWidth(rendererPointer: BigInt): number {
        console.debug(`${TAG}, cppWidth rendererPointer = ${rendererPointer}`)
        return rive.Napi_Renderer_cppWidth(rendererPointer)
    }

    private cppHeight(rendererPointer: BigInt): number {
        console.debug(`${TAG}, cppHeight rendererPointer = ${rendererPointer}`)
        return rive.Napi_Renderer_cppHeight(rendererPointer)
    }

    private cppAvgFps(rendererPointer: BigInt): number {
        console.debug(`${TAG}, cppAvgFps rendererPointer = ${rendererPointer}`)
        return rive.Napi_Renderer_cppAvgFps(rendererPointer)
    }

    cppDoFrame(rendererPointer: BigInt) {
        console.debug(`${TAG}, cppDoFrame rendererPointer = ${rendererPointer}`)
        rive.Napi_Renderer_cppDoFrame(rendererPointer)
        console.debug(`${TAG}, cppDoFrame end`)
    }

    private cppSetSurface(surfaceId: string, rendererPointer: BigInt) {
        console.debug(`${TAG}, cppSetSurface rendererPointer = ${rendererPointer}, surfaceId = ${surfaceId}`)
        rive.Napi_Renderer_cppSetSurface(rendererPointer, BigInt(surfaceId))
        console.debug(`${TAG}, cppSetSurface end`)
    }

    private cppDestroySurface(rendererPointer: BigInt) {
        console.debug(`${TAG}, cppDestroySurface rendererPointer = ${rendererPointer}`)
        rive.Napi_Renderer_cppDestroySurface(rendererPointer)
        console.debug(`${TAG}, cppDestroySurface end`)
    }

    private cppAlign(
        cppPointer: BigInt,
        fit: Fit,
        alignment: Alignment,
        targetBounds: RectF,
        srcBounds: RectF,
        scaleFactor: number,
    ) {
        rive.Napi_Renderer_cppAlign(cppPointer, fit, alignment, targetBounds, srcBounds, scaleFactor)
        console.debug(`${TAG}, cppAlign end`)
    }

    private cppTransform(
        cppPointer: BigInt,
        x: number,
        sy: number,
        sx: number,
        y: number,
        tx: number,
        ty: number,
    ) {
        rive.Napi_Renderer_cppTransform(cppPointer, x, sy, sx, y, tx, ty)
        console.debug(`${TAG}, cppTransform end`)
    }

    private getCppRenderer(trace: boolean, type: number): BigInt {
        console.debug(`${TAG}, getCppRenderer trace = ${trace}, type = ${type}`)
        return rive.Napi_Renderer_cppConstructor(this, trace, type)
    }


    /**
     * Creates the native renderer object
     */
    make(): void {
        console.debug(`${TAG}, make this.hasCppObject = ${this.hasCppObject}`)
        if (!this.hasCppObject) {
            this.cppPointer = this.getCppRenderer(this.trace, this.type.valueOf());
            console.debug(`${TAG}, make this.cppPointer = ${this.cppPointer}, this.refs = ${this.refs}`)
            this.refs.incrementAndGet();
        }
    }

    /**
     * Helper function to reassign the renderer type.
     */
    setRendererType(newType: number): void {
        console.debug(`${TAG}, setRendererType newType = ${newType}, this.type.valueOf() = ${this.type.valueOf()}`)
        if (newType !== this.type.valueOf()) {
            this.type = RendererType.fromIndex(newType);
        }
    }

    /**
     * Abstract method to be implemented by concrete renderers
     */
    abstract draw(): void;

    /**
     * Abstract method to be implemented by concrete renderers
     */
    abstract advance(elapsed: number): void;

    /**
     * Starts the renderer and registers for frame callbacks
     */
    start(): void {
        console.debug(`${TAG}, start`)
        if (this.isPlaying) {
            console.warn(`${TAG}, start this.isPlaying = ${this.isPlaying}`)
            return;
        }
        if (!this.isAttached) {
            console.warn(`${TAG}, start this.isAttached = ${this.isAttached}`)
            return;
        }
        if (!this.hasCppObject) {
            console.warn(`${TAG}, start this.hasCppObject = ${this.hasCppObject}`)
            return;
        }

        this.isPlaying = true;
        try {
            this.cppStart(this.cppPointer);
            this.scheduleFrame();
        } catch (e) {
            console.error(`${TAG}, start catch e = ${JSON.stringify(e)}`)
        }
    }

    /**
     * Sets the drawing surface for the renderer
     * @deprecated This method is dangerous as it does not correctly manage the Surface's lifecycle
     */
    setSurface(surfaceId: string): void {
        console.debug(`${TAG}, setSurface surfaceId = ${surfaceId}`)
        const sharedSurface = new SharedSurface(surfaceId);
        this.setSharedSurface(sharedSurface);
    }

    /**
     * Sets the drawing surface for the renderer using SharedSurface
     */
    setSharedSurface(surface: SharedSurface): void {
        console.debug(`${TAG}, setSharedSurface surface = ${JSON.stringify(surface)}`)
        if (this.sharedSurface) {
            this.sharedSurface.release();
        }
        surface.acquire();
        this.sharedSurface = surface;

        this.cppSetSurface(surface.surfaceId, this.cppPointer);
        this.isAttached = true;
        this.start();
    }

    /**
     * Marks the animation as stopped
     */
    stopThread(): void {
        console.debug(`${TAG}, stopThread`)
        if (!this.isPlaying) {
            console.warn(`${TAG}, stopThread this.isPlaying = ${this.isPlaying}`)
            return;
        }
        if (!this.hasCppObject) {
            console.warn(`${TAG}, stopThread this.hasCppObject = ${this.hasCppObject}`)
            return;
        }

        this.isPlaying = false;
        this.cppStop(this.cppPointer);
    }

    /**
     * Calls stopThread and removes any pending frame callbacks
     */
    stop(): void {
        console.debug(`${TAG}, stop`)
        this.stopThread();
        this.framCallBack = null
        this.uiContext.postFrameCallback(this.framCallBack)
    }

    private destroySurface(): void {
        console.debug(`${TAG}, destroySurface`)
        this.isAttached = false;
        this.stop();
        this.cppDestroySurface(this.cppPointer);
    }

    scheduleFrame(): void {
        console.debug(`${TAG}, scheduleFrame`)
        this.framCallBack = new RiveFramCallBack(this)
        this.uiContext.postFrameCallback(this.framCallBack)
        console.debug(`${TAG}, scheduleFrame end`)
    }

    save(): void {
        console.debug(`${TAG}, save`)
        this.cppSave(this.cppPointer);
    }

    restore(): void {
        console.debug(`${TAG}, restore`)
        this.cppRestore(this.cppPointer);
    }

    get width(): number {
        console.debug(`${TAG}, get width`)
        let width = this.cppWidth(this.cppPointer);
        console.debug(`${TAG}, get width = ${width}`)
        return width
    }

    get height(): number {
        console.debug(`${TAG}, get height`)
        let height = this.cppHeight(this.cppPointer);
        console.debug(`${TAG}, get height = ${height}`)
        return height
    }

    get averageFps(): number {
        console.debug(`${TAG}, get averageFps`)
        let avgFps = this.cppAvgFps(this.cppPointer);
        console.debug(`${TAG}, get avgFps = ${avgFps}`)
        return avgFps
    }

    align(
        fit: Fit,
        alignment: Alignment,
        targetBounds: RectF,
        sourceBounds: RectF,
        scaleFactor: number = 1.0
    ): void {
        this.cppAlign(
            this.cppPointer,
            fit,
            alignment,
            targetBounds,
            sourceBounds,
            scaleFactor
        );
    }

    transform(x: number, sy: number, sx: number, y: number, tx: number, ty: number): void {
        console.debug(`${TAG}, transform x = ${x}, sy = ${sy}, sx = ${sx}, y = ${y}, tx = ${tx}, ty = ${ty}`)
        this.cppTransform(this.cppPointer, x, sy, sx, y, tx, ty);
    }

    scale(sx: number, sy: number): void {
        console.debug(`${TAG}, scale sx = ${sx}, sy = ${sy}`)
        this.transform(sx, 0, 0, sy, 0, 0);
    }

    translate(dx: number, dy: number): void {
        console.debug(`${TAG}, translate dx = ${dx}, dy = ${dy}`)
        this.transform(1, 0, 0, 1, dx, dy);
    }

    /**
     * Schedules the deletion of the underlying C++ object using a two-phase disposal pattern
     */
    delete(): void {
        console.debug(`${TAG}, delete`)
        this.stop();

        this.destroySurface();

        this.cppDelete(this.cppPointer);
        this.cppPointer = 0n;
    }

    /**
     * Releases all of this renderer's dependents
     */
    protected disposeDependencies(): void {
        console.debug(`${TAG}, disposeDependencies`)
        if (this.sharedSurface) {
            this.sharedSurface.release();
            this.sharedSurface = null;
        }
        try {
            this.dependencies.forEach((dep: RefCount) => dep.release());
            this.dependencies.clear();
        } catch (error) {
            console.error(`${TAG}, disposeDependencies error: ${JSON.stringify(error)}`)
        }
    }
}