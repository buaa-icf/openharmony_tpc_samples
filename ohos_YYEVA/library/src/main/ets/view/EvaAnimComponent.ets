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

import { IEvaAnimPlayer } from './IEvaAnimPlayer';
import { emitter } from '@kit.BasicServicesKit';
import { EvaConstant } from '../util/EvaConstant';
import { ELog } from '../util/ELog';
import { EvaPref } from '../file/EvaPref';
import { EvaAnimView } from './EvaAnimView'


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
    @ObjectLink playerEva: IEvaAnimPlayer;
    public xcompID: string = "";
    public xType: XComponentType = XComponentType.SURFACE;
    public evaView: EvaAnimView = new EvaAnimView();

    build() {
        Stack() {
            XComponent({
                id: this.xcompID,
                type: this.xType,
                controller: this.evaView
            }).width(this.playerEva.xArea.width)
                .height(this.playerEva.xArea.height)
                .backgroundColor(Color.Transparent)
                .onTouch((event: TouchEvent) => {
                    const isRunning = this.playerEva.isRunning()
                    const isDispatch = event != null && this.playerEva?.onDispatchTouchEvent(event)
                    const isHasBg = this.playerEva?.hasBgImage()
                    if (isRunning && !isDispatch && !isHasBg) {
                        return false
                    } else {
                        // 阻止事件继续向上冒泡
                        event.stopPropagation();
                        return true
                    }
                })
                .onAreaChange((oldValue: Area, newValue: Area) => {
                    this.playerEva.onStackAreaChange(oldValue, newValue);
                })
                .id('eva_anim_component_stack')
        }
        .width('100%')
        .height('100%')
    }

    async aboutToAppear(): Promise<void> {
        if (this.playerEva == null) {
            return;
        }
        this.xcompID = 'EvaAnimComponent'+this.playerEva.uuid;
        this.evaView?.bind(this.playerEva);
        await this.evaView?.aboutToAppear();
        EvaPref.init(this.getUIContext().getHostContext());
    }

    aboutToDisappear(): void {
        this.playerEva.onDestroy()
    }

    onPageShow(): void {
    }

    onPageHide(): void {
    }
}