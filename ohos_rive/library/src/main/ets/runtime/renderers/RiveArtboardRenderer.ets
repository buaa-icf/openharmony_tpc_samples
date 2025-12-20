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

import { RiveFileController } from '../controllers/RiveFileController';
import { Fit } from '../core/Fit';
import { RendererType } from './RendererType';
import { Renderer } from './Renderer';
import { Alignment } from '../core/Alignment';

/**
 * Enumeration for pointer events
 */
export enum PointerEvents {
    POINTER_DOWN,
    POINTER_UP,
    POINTER_MOVE,
    POINTER_EXIT
}

const TAG = 'RiveArtboardRenderer'

/**
 * Open class for Rive artboard renderers in HarmonyOS/ETS
 */
export class RiveArtboardRenderer extends Renderer {
    private _controller: RiveFileController;

    constructor(
        uiContext: UIContext,
        controller: RiveFileController,
        trace: boolean = false,
        rendererType: RendererType = RendererType.Rive
    ) {
        super(uiContext, rendererType, trace);
        this._controller = controller;

        // Initialize controller
        this._controller.onStart = () => this.start();
        this._controller.acquire();
        // Add controller to the Renderer dependencies.
        // When the renderer is disposed, it'll `release()` it
        try {
            this.dependencies.add(this._controller);
        } catch (error) {
            console.error(`${TAG}, constructor error = ${JSON.stringify(error)}`)
        }
    }

    get controller(): RiveFileController {
        console.debug(`${TAG}, controller`)
        return this._controller;
    }

    private get fit(): Fit {
        console.debug(`${TAG}, get fit this._controller.fit = ${this._controller.fit}`)
        return this._controller.fit;
    }

    private get alignment(): Alignment {
        console.debug(`${TAG}, get alignment this._controller.alignment = ${this._controller.alignment}`)
        return this._controller.alignment;
    }

    private get scaleFactor(): number {
        return this._controller.layoutScaleFactorActive;
    }

    /**
     * Resizes the artboard based on the current fit and scale factor
     */
    private resizeArtboard(): void {
        console.debug(`${TAG}, resizeArtboard this.fit === Fit.LAYOUT = ${this.fit === Fit.LAYOUT}`)
        if (this.fit === Fit.LAYOUT) {
            const newWidth = this.width / this.scaleFactor;
            const newHeight = this.height / this.scaleFactor;
            const activeArtboard = this._controller.activeArtboard;
            if (activeArtboard) {
                activeArtboard.width = newWidth;
                activeArtboard.height = newHeight;
            }
        } else {
            const activeArtboard = this._controller.activeArtboard;
            if (activeArtboard) {
                activeArtboard.resetArtboardSize();
            }
        }
    }

    /**
     * Draws the artboard - be aware of thread safety!
     */
    draw(): void {
        if (this._controller.requireArtboardResize == true) {
            this._controller.requireArtboardResize = false
            this.resizeArtboard()
        }

        if (!this.hasCppObject || !this._controller.isActive) {
            return;
        }
        const activeArtboard = this._controller.activeArtboard;
        if (activeArtboard) {
            activeArtboard.drawFit(this.cppPointer, this.fit, this.alignment, this.scaleFactor);
        }
    }

    /**
     * Advances the animation - be aware of thread safety!
     */
    override advance(elapsed: number): void {
        console.debug(`${TAG}, advance elapsed = ${elapsed}`)
        if (!this.hasCppObject) {
            console.warn(`${TAG}, advance this.hasCppObject = ${this.hasCppObject}`)
            return;
        }
        if (this._controller.isActive) {
            console.debug(`${TAG}, advance this._controller.isActive = ${this._controller.isActive}`)
            this._controller.advance(elapsed);
        }

        if (!this._controller.isAdvancing) {
            console.debug(`${TAG}, advance this._controller.isAdvancing = ${this._controller.isAdvancing}`)
            this.stopThread();
        }
    }

    /**
     * Resets the renderer and controller
     */
    reset(): void {
        console.debug(`${TAG}, reset`)
        this._controller.stopAllAnimations();
        this._controller.reset();
        this.stop();
        this._controller.selectArtboard();
        this.start();
    }

    /**
     * Disposes dependencies in an orderly manner
     */
    protected override disposeDependencies(): void {
        console.debug(`${TAG}, disposeDependencies`)
        super.disposeDependencies();
    }
}