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

import { EvaAnimPlayer } from '../EvaAnimPlayer';
import { emitter } from '@kit.BasicServicesKit';
import { MyXComponentController } from './MyXComponentController';
import { EvaConstant } from '../util/EvaConstant';
import { ELog } from '../util/ELog';
import { EvaPref } from '../file/EvaPref';


@Component
export struct EvaAnimComponent {
    private static readonly TAG: string = `${EvaConstant.TAG}.EvaAnimComponent`
    // 定义emitter事件
    // XComponentController中的onSerfaceCreated回调事件
    static readonly EVENT_ID_ON_SURFACE_CREATED = 'onSurfaceCreated';
    // XComponentController中的onSurfaceChanged回调事件
    static readonly EVENT_ID_ON_SURFACE_CHANGED = 'onSurfaceChanged';
    // XComponentController中的onSurfaceDestroyed回调事件
    static readonly EVENT_ID_ON_SURFACE_DESTROYED = 'onSurfaceDestroyed';
    @ObjectLink playerEva: EvaAnimPlayer;
    xType: XComponentType = XComponentType.SURFACE;
    xComponentController: XComponentController = new MyXComponentController(this.playerEva.uuid);

    build() {
        Stack() {
            XComponent({
                id: 'EvaAnimComponent',
                type: this.xType,
                controller: this.xComponentController
            }).width(this.playerEva.xArea.width)
                .height(this.playerEva.xArea.height)
                .backgroundColor(Color.Transparent)
                .onTouch((event: TouchEvent) => {
                    const isRunning = this.playerEva.isRunning()
                    const isDispatch = event != null && this.playerEva?.pluginManager?.onDispatchTouchEvent(event)
                    const isHasBg = this.playerEva?.hasBgImage()
                    if (isRunning && !isDispatch && !isHasBg) {
                        return false
                    } else {
                        // 阻止事件继续向上冒泡
                        event.stopPropagation();
                        return true
                    }
                })
        }.id('eva_anim_component_stack')
        .width('100%')
        .height('100%')
        .onAreaChange((oldValue: Area, newValue: Area) => {
            this.playerEva.onStackAreaChange(oldValue, newValue);
        })
    }

    async aboutToAppear(): Promise<void> {
        // 注册事件
        emitter.on(EvaAnimComponent.EVENT_ID_ON_SURFACE_CREATED, this.onSurfaceCreated);
        emitter.on(EvaAnimComponent.EVENT_ID_ON_SURFACE_CHANGED, this.onSurfaceChanged);
        emitter.on(EvaAnimComponent.EVENT_ID_ON_SURFACE_DESTROYED, this.onSurfaceDestroyed);

        this.playerEva.xController = this.xComponentController
        await this.playerEva.aboutToAppear()
        EvaPref.init(this.getUIContext().getHostContext())
    }

    aboutToDisappear(): void {
        emitter.off(EvaAnimComponent.EVENT_ID_ON_SURFACE_CREATED);
        emitter.off(EvaAnimComponent.EVENT_ID_ON_SURFACE_CHANGED);
        emitter.off(EvaAnimComponent.EVENT_ID_ON_SURFACE_DESTROYED);
        this.playerEva.aboutToDisappear()
    }

    onPageShow(): void {
        this.playerEva.onPageShow()
    }

    onPageHide(): void {
        this.playerEva.onPageHide()
    }

    private onSurfaceCreated: Callback<emitter.EventData> = (eventData: emitter.EventData): void => {
        ELog.i(EvaAnimComponent.TAG, `onSurfaceCreated eventData: ${JSON.stringify(eventData)}`);
        let uuid: string = eventData.data?.uuid
        if (uuid != this.playerEva.uuid) {
            ELog.e(EvaAnimPlayer.TAG, `uuid不匹配 uuid = ${uuid}, EvaAnimPlayer.uuid = ${this.playerEva.uuid}`)
            return
        }
        let surfaceId: string = eventData.data?.surfaceId;
        ELog.i(EvaAnimComponent.TAG, `onSurfaceCreated surfaceId = ${surfaceId}`)
        this.playerEva.onSurfaceCreated(surfaceId)
    }
    
    private onSurfaceChanged: Callback<emitter.EventData> = (eventData: emitter.EventData): void => {
        ELog.i(EvaAnimComponent.TAG, `onSurfaceChanged eventData: ${JSON.stringify(eventData)}`);
        let uuid: string = eventData.data?.uuid
        if (uuid != this.playerEva.uuid) {
            ELog.e(EvaAnimPlayer.TAG, `uuid不匹配 uuid = ${uuid}, EvaAnimPlayer.uuid = ${this.playerEva.uuid}`)
            return
        }
        let surfaceId: string = eventData.data?.surfaceId;
        let rect: SurfaceRect = eventData.data?.rect;
        ELog.i(EvaAnimComponent.TAG, `onSurfaceChanged surfaceId: ${surfaceId}, rect: ${JSON.stringify(rect)}}`);
        this.playerEva.onSurfaceTextureSizeChanged(surfaceId, rect)
    }
    
    private onSurfaceDestroyed: Callback<emitter.EventData> = (eventData: emitter.EventData): void => {
        ELog.i(EvaAnimComponent.TAG, `onSurfaceDestroyed eventData: ${JSON.stringify(eventData)}`);
        let uuid: string = eventData.data?.uuid
        if (uuid != this.playerEva.uuid) {
            ELog.e(EvaAnimPlayer.TAG, `uuid不匹配 uuid = ${uuid}, EvaAnimPlayer.uuid = ${this.playerEva.uuid}`)
            return
        }
        let surfaceId: string = eventData.data?.surfaceId;
        ELog.i(EvaAnimComponent.TAG, `onSurfaceDestroyed surfaceId = ${surfaceId}`)
        this.playerEva.onSurfaceDestroyed()
    }
}